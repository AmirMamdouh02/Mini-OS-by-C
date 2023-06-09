
obj/user/quicksort_noleakage:     file format elf32-i386


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
  800031:	e8 0e 06 00 00       	call   800644 <libmain>
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
  80003b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	char Line[255] ;
	char Chose ;
	do
	{
		//2012: lock the interrupt
		sys_disable_interrupt();
  800041:	e8 1e 21 00 00       	call   802164 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 39 80 00       	push   $0x8039c0
  80004e:	e8 e1 09 00 00       	call   800a34 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 39 80 00       	push   $0x8039c2
  80005e:	e8 d1 09 00 00       	call   800a34 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT    !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 db 39 80 00       	push   $0x8039db
  80006e:	e8 c1 09 00 00       	call   800a34 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 39 80 00       	push   $0x8039c2
  80007e:	e8 b1 09 00 00       	call   800a34 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 39 80 00       	push   $0x8039c0
  80008e:	e8 a1 09 00 00       	call   800a34 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f4 39 80 00       	push   $0x8039f4
  8000a5:	e8 0c 10 00 00       	call   8010b6 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 5c 15 00 00       	call   80161c <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 04 1b 00 00       	call   801bd9 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 14 3a 80 00       	push   $0x803a14
  8000e3:	e8 4c 09 00 00       	call   800a34 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 36 3a 80 00       	push   $0x803a36
  8000f3:	e8 3c 09 00 00       	call   800a34 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 44 3a 80 00       	push   $0x803a44
  800103:	e8 2c 09 00 00       	call   800a34 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 53 3a 80 00       	push   $0x803a53
  800113:	e8 1c 09 00 00       	call   800a34 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 63 3a 80 00       	push   $0x803a63
  800123:	e8 0c 09 00 00       	call   800a34 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 bc 04 00 00       	call   8005ec <getchar>
  800130:	88 45 ef             	mov    %al,-0x11(%ebp)
			cputchar(Chose);
  800133:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 64 04 00 00       	call   8005a4 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 57 04 00 00       	call   8005a4 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d ef 61          	cmpb   $0x61,-0x11(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d ef 62          	cmpb   $0x62,-0x11(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d ef 63          	cmpb   $0x63,-0x11(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 17 20 00 00       	call   80217e <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  80016b:	83 f8 62             	cmp    $0x62,%eax
  80016e:	74 1d                	je     80018d <_main+0x155>
  800170:	83 f8 63             	cmp    $0x63,%eax
  800173:	74 2b                	je     8001a0 <_main+0x168>
  800175:	83 f8 61             	cmp    $0x61,%eax
  800178:	75 39                	jne    8001b3 <_main+0x17b>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017a:	83 ec 08             	sub    $0x8,%esp
  80017d:	ff 75 f4             	pushl  -0xc(%ebp)
  800180:	ff 75 f0             	pushl  -0x10(%ebp)
  800183:	e8 e4 02 00 00       	call   80046c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f4             	pushl  -0xc(%ebp)
  800193:	ff 75 f0             	pushl  -0x10(%ebp)
  800196:	e8 02 03 00 00       	call   80049d <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8001a6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a9:	e8 24 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8001b9:	ff 75 f0             	pushl  -0x10(%ebp)
  8001bc:	e8 11 03 00 00       	call   8004d2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8001ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8001cd:	e8 df 00 00 00       	call   8002b1 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 8a 1f 00 00       	call   802164 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 6c 3a 80 00       	push   $0x803a6c
  8001e2:	e8 4d 08 00 00       	call   800a34 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 8f 1f 00 00       	call   80217e <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f4             	pushl  -0xc(%ebp)
  8001f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f8:	e8 c5 01 00 00       	call   8003c2 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 a0 3a 80 00       	push   $0x803aa0
  800211:	6a 49                	push   $0x49
  800213:	68 c2 3a 80 00       	push   $0x803ac2
  800218:	e8 63 05 00 00       	call   800780 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 42 1f 00 00       	call   802164 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 e0 3a 80 00       	push   $0x803ae0
  80022a:	e8 05 08 00 00       	call   800a34 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 14 3b 80 00       	push   $0x803b14
  80023a:	e8 f5 07 00 00       	call   800a34 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 48 3b 80 00       	push   $0x803b48
  80024a:	e8 e5 07 00 00       	call   800a34 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 27 1f 00 00       	call   80217e <sys_enable_interrupt>

		}

		free(Elements) ;
  800257:	83 ec 0c             	sub    $0xc,%esp
  80025a:	ff 75 f0             	pushl  -0x10(%ebp)
  80025d:	e8 10 1a 00 00       	call   801c72 <free>
  800262:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800265:	e8 fa 1e 00 00       	call   802164 <sys_disable_interrupt>

		cprintf("Do you want to repeat (y/n): ") ;
  80026a:	83 ec 0c             	sub    $0xc,%esp
  80026d:	68 7a 3b 80 00       	push   $0x803b7a
  800272:	e8 bd 07 00 00       	call   800a34 <cprintf>
  800277:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  80027a:	e8 6d 03 00 00       	call   8005ec <getchar>
  80027f:	88 45 ef             	mov    %al,-0x11(%ebp)
		cputchar(Chose);
  800282:	0f be 45 ef          	movsbl -0x11(%ebp),%eax
  800286:	83 ec 0c             	sub    $0xc,%esp
  800289:	50                   	push   %eax
  80028a:	e8 15 03 00 00       	call   8005a4 <cputchar>
  80028f:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  800292:	83 ec 0c             	sub    $0xc,%esp
  800295:	6a 0a                	push   $0xa
  800297:	e8 08 03 00 00       	call   8005a4 <cputchar>
  80029c:	83 c4 10             	add    $0x10,%esp

		sys_enable_interrupt();
  80029f:	e8 da 1e 00 00       	call   80217e <sys_enable_interrupt>

	} while (Chose == 'y');
  8002a4:	80 7d ef 79          	cmpb   $0x79,-0x11(%ebp)
  8002a8:	0f 84 93 fd ff ff    	je     800041 <_main+0x9>

}
  8002ae:	90                   	nop
  8002af:	c9                   	leave  
  8002b0:	c3                   	ret    

008002b1 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	48                   	dec    %eax
  8002bb:	50                   	push   %eax
  8002bc:	6a 00                	push   $0x0
  8002be:	ff 75 0c             	pushl  0xc(%ebp)
  8002c1:	ff 75 08             	pushl  0x8(%ebp)
  8002c4:	e8 06 00 00 00       	call   8002cf <QSort>
  8002c9:	83 c4 10             	add    $0x10,%esp
}
  8002cc:	90                   	nop
  8002cd:	c9                   	leave  
  8002ce:	c3                   	ret    

008002cf <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d8:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002db:	0f 8d de 00 00 00    	jge    8003bf <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e4:	40                   	inc    %eax
  8002e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8002eb:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ee:	e9 80 00 00 00       	jmp    800373 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8002f3:	ff 45 f4             	incl   -0xc(%ebp)
  8002f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002f9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002fc:	7f 2b                	jg     800329 <QSort+0x5a>
  8002fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800301:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800308:	8b 45 08             	mov    0x8(%ebp),%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	8b 10                	mov    (%eax),%edx
  80030f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800312:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 c8                	add    %ecx,%eax
  80031e:	8b 00                	mov    (%eax),%eax
  800320:	39 c2                	cmp    %eax,%edx
  800322:	7d cf                	jge    8002f3 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800324:	eb 03                	jmp    800329 <QSort+0x5a>
  800326:	ff 4d f0             	decl   -0x10(%ebp)
  800329:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80032c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80032f:	7e 26                	jle    800357 <QSort+0x88>
  800331:	8b 45 10             	mov    0x10(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800345:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 c8                	add    %ecx,%eax
  800351:	8b 00                	mov    (%eax),%eax
  800353:	39 c2                	cmp    %eax,%edx
  800355:	7e cf                	jle    800326 <QSort+0x57>

		if (i <= j)
  800357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80035d:	7f 14                	jg     800373 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	ff 75 f0             	pushl  -0x10(%ebp)
  800365:	ff 75 f4             	pushl  -0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 a9 00 00 00       	call   800419 <Swap>
  800370:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800376:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800379:	0f 8e 77 ff ff ff    	jle    8002f6 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80037f:	83 ec 04             	sub    $0x4,%esp
  800382:	ff 75 f0             	pushl  -0x10(%ebp)
  800385:	ff 75 10             	pushl  0x10(%ebp)
  800388:	ff 75 08             	pushl  0x8(%ebp)
  80038b:	e8 89 00 00 00       	call   800419 <Swap>
  800390:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800393:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800396:	48                   	dec    %eax
  800397:	50                   	push   %eax
  800398:	ff 75 10             	pushl  0x10(%ebp)
  80039b:	ff 75 0c             	pushl  0xc(%ebp)
  80039e:	ff 75 08             	pushl  0x8(%ebp)
  8003a1:	e8 29 ff ff ff       	call   8002cf <QSort>
  8003a6:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003a9:	ff 75 14             	pushl  0x14(%ebp)
  8003ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8003af:	ff 75 0c             	pushl  0xc(%ebp)
  8003b2:	ff 75 08             	pushl  0x8(%ebp)
  8003b5:	e8 15 ff ff ff       	call   8002cf <QSort>
  8003ba:	83 c4 10             	add    $0x10,%esp
  8003bd:	eb 01                	jmp    8003c0 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003bf:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003c0:	c9                   	leave  
  8003c1:	c3                   	ret    

008003c2 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003c2:	55                   	push   %ebp
  8003c3:	89 e5                	mov    %esp,%ebp
  8003c5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003c8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003d6:	eb 33                	jmp    80040b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e5:	01 d0                	add    %edx,%eax
  8003e7:	8b 10                	mov    (%eax),%edx
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	40                   	inc    %eax
  8003ed:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	8b 00                	mov    (%eax),%eax
  8003fb:	39 c2                	cmp    %eax,%edx
  8003fd:	7e 09                	jle    800408 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800406:	eb 0c                	jmp    800414 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800408:	ff 45 f8             	incl   -0x8(%ebp)
  80040b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040e:	48                   	dec    %eax
  80040f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800412:	7f c4                	jg     8003d8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800414:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800417:	c9                   	leave  
  800418:	c3                   	ret    

00800419 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800419:	55                   	push   %ebp
  80041a:	89 e5                	mov    %esp,%ebp
  80041c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80041f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800429:	8b 45 08             	mov    0x8(%ebp),%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800433:	8b 45 0c             	mov    0xc(%ebp),%eax
  800436:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043d:	8b 45 08             	mov    0x8(%ebp),%eax
  800440:	01 c2                	add    %eax,%edx
  800442:	8b 45 10             	mov    0x10(%ebp),%eax
  800445:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	01 c8                	add    %ecx,%eax
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800455:	8b 45 10             	mov    0x10(%ebp),%eax
  800458:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045f:	8b 45 08             	mov    0x8(%ebp),%eax
  800462:	01 c2                	add    %eax,%edx
  800464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800467:	89 02                	mov    %eax,(%edx)
}
  800469:	90                   	nop
  80046a:	c9                   	leave  
  80046b:	c3                   	ret    

0080046c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800472:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800479:	eb 17                	jmp    800492 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80047b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80047e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c2                	add    %eax,%edx
  80048a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80048f:	ff 45 fc             	incl   -0x4(%ebp)
  800492:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800495:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800498:	7c e1                	jl     80047b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004aa:	eb 1b                	jmp    8004c7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b9:	01 c2                	add    %eax,%edx
  8004bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004be:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004c1:	48                   	dec    %eax
  8004c2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004c4:	ff 45 fc             	incl   -0x4(%ebp)
  8004c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004cd:	7c dd                	jl     8004ac <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004cf:	90                   	nop
  8004d0:	c9                   	leave  
  8004d1:	c3                   	ret    

008004d2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004d2:	55                   	push   %ebp
  8004d3:	89 e5                	mov    %esp,%ebp
  8004d5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004db:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004e0:	f7 e9                	imul   %ecx
  8004e2:	c1 f9 1f             	sar    $0x1f,%ecx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	29 c8                	sub    %ecx,%eax
  8004e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004f3:	eb 1e                	jmp    800513 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8004f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800505:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800508:	99                   	cltd   
  800509:	f7 7d f8             	idivl  -0x8(%ebp)
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800510:	ff 45 fc             	incl   -0x4(%ebp)
  800513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800516:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800519:	7c da                	jl     8004f5 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800524:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80052b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800532:	eb 42                	jmp    800576 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800537:	99                   	cltd   
  800538:	f7 7d f0             	idivl  -0x10(%ebp)
  80053b:	89 d0                	mov    %edx,%eax
  80053d:	85 c0                	test   %eax,%eax
  80053f:	75 10                	jne    800551 <PrintElements+0x33>
			cprintf("\n");
  800541:	83 ec 0c             	sub    $0xc,%esp
  800544:	68 c0 39 80 00       	push   $0x8039c0
  800549:	e8 e6 04 00 00       	call   800a34 <cprintf>
  80054e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	01 d0                	add    %edx,%eax
  800560:	8b 00                	mov    (%eax),%eax
  800562:	83 ec 08             	sub    $0x8,%esp
  800565:	50                   	push   %eax
  800566:	68 98 3b 80 00       	push   $0x803b98
  80056b:	e8 c4 04 00 00       	call   800a34 <cprintf>
  800570:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800573:	ff 45 f4             	incl   -0xc(%ebp)
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	48                   	dec    %eax
  80057a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80057d:	7f b5                	jg     800534 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80057f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800582:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800589:	8b 45 08             	mov    0x8(%ebp),%eax
  80058c:	01 d0                	add    %edx,%eax
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	50                   	push   %eax
  800594:	68 9d 3b 80 00       	push   $0x803b9d
  800599:	e8 96 04 00 00       	call   800a34 <cprintf>
  80059e:	83 c4 10             	add    $0x10,%esp

}
  8005a1:	90                   	nop
  8005a2:	c9                   	leave  
  8005a3:	c3                   	ret    

008005a4 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005a4:	55                   	push   %ebp
  8005a5:	89 e5                	mov    %esp,%ebp
  8005a7:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005b0:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005b4:	83 ec 0c             	sub    $0xc,%esp
  8005b7:	50                   	push   %eax
  8005b8:	e8 db 1b 00 00       	call   802198 <sys_cputc>
  8005bd:	83 c4 10             	add    $0x10,%esp
}
  8005c0:	90                   	nop
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005c9:	e8 96 1b 00 00       	call   802164 <sys_disable_interrupt>
	char c = ch;
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005d4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005d8:	83 ec 0c             	sub    $0xc,%esp
  8005db:	50                   	push   %eax
  8005dc:	e8 b7 1b 00 00       	call   802198 <sys_cputc>
  8005e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005e4:	e8 95 1b 00 00       	call   80217e <sys_enable_interrupt>
}
  8005e9:	90                   	nop
  8005ea:	c9                   	leave  
  8005eb:	c3                   	ret    

008005ec <getchar>:

int
getchar(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8005f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005f9:	eb 08                	jmp    800603 <getchar+0x17>
	{
		c = sys_cgetc();
  8005fb:	e8 df 19 00 00       	call   801fdf <sys_cgetc>
  800600:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800603:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800607:	74 f2                	je     8005fb <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800609:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80060c:	c9                   	leave  
  80060d:	c3                   	ret    

0080060e <atomic_getchar>:

int
atomic_getchar(void)
{
  80060e:	55                   	push   %ebp
  80060f:	89 e5                	mov    %esp,%ebp
  800611:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800614:	e8 4b 1b 00 00       	call   802164 <sys_disable_interrupt>
	int c=0;
  800619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800620:	eb 08                	jmp    80062a <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800622:	e8 b8 19 00 00       	call   801fdf <sys_cgetc>
  800627:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80062a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80062e:	74 f2                	je     800622 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800630:	e8 49 1b 00 00       	call   80217e <sys_enable_interrupt>
	return c;
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800638:	c9                   	leave  
  800639:	c3                   	ret    

0080063a <iscons>:

int iscons(int fdnum)
{
  80063a:	55                   	push   %ebp
  80063b:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80063d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800642:	5d                   	pop    %ebp
  800643:	c3                   	ret    

00800644 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80064a:	e8 08 1d 00 00       	call   802357 <sys_getenvindex>
  80064f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800652:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800655:	89 d0                	mov    %edx,%eax
  800657:	c1 e0 03             	shl    $0x3,%eax
  80065a:	01 d0                	add    %edx,%eax
  80065c:	01 c0                	add    %eax,%eax
  80065e:	01 d0                	add    %edx,%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	01 d0                	add    %edx,%eax
  800669:	c1 e0 04             	shl    $0x4,%eax
  80066c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800671:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800676:	a1 24 50 80 00       	mov    0x805024,%eax
  80067b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800681:	84 c0                	test   %al,%al
  800683:	74 0f                	je     800694 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800685:	a1 24 50 80 00       	mov    0x805024,%eax
  80068a:	05 5c 05 00 00       	add    $0x55c,%eax
  80068f:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800694:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800698:	7e 0a                	jle    8006a4 <libmain+0x60>
		binaryname = argv[0];
  80069a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006a4:	83 ec 08             	sub    $0x8,%esp
  8006a7:	ff 75 0c             	pushl  0xc(%ebp)
  8006aa:	ff 75 08             	pushl  0x8(%ebp)
  8006ad:	e8 86 f9 ff ff       	call   800038 <_main>
  8006b2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006b5:	e8 aa 1a 00 00       	call   802164 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006ba:	83 ec 0c             	sub    $0xc,%esp
  8006bd:	68 bc 3b 80 00       	push   $0x803bbc
  8006c2:	e8 6d 03 00 00       	call   800a34 <cprintf>
  8006c7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006ca:	a1 24 50 80 00       	mov    0x805024,%eax
  8006cf:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8006da:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006e0:	83 ec 04             	sub    $0x4,%esp
  8006e3:	52                   	push   %edx
  8006e4:	50                   	push   %eax
  8006e5:	68 e4 3b 80 00       	push   $0x803be4
  8006ea:	e8 45 03 00 00       	call   800a34 <cprintf>
  8006ef:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006f2:	a1 24 50 80 00       	mov    0x805024,%eax
  8006f7:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006fd:	a1 24 50 80 00       	mov    0x805024,%eax
  800702:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800708:	a1 24 50 80 00       	mov    0x805024,%eax
  80070d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800713:	51                   	push   %ecx
  800714:	52                   	push   %edx
  800715:	50                   	push   %eax
  800716:	68 0c 3c 80 00       	push   $0x803c0c
  80071b:	e8 14 03 00 00       	call   800a34 <cprintf>
  800720:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800723:	a1 24 50 80 00       	mov    0x805024,%eax
  800728:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	50                   	push   %eax
  800732:	68 64 3c 80 00       	push   $0x803c64
  800737:	e8 f8 02 00 00       	call   800a34 <cprintf>
  80073c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80073f:	83 ec 0c             	sub    $0xc,%esp
  800742:	68 bc 3b 80 00       	push   $0x803bbc
  800747:	e8 e8 02 00 00       	call   800a34 <cprintf>
  80074c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80074f:	e8 2a 1a 00 00       	call   80217e <sys_enable_interrupt>

	// exit gracefully
	exit();
  800754:	e8 19 00 00 00       	call   800772 <exit>
}
  800759:	90                   	nop
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    

0080075c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800762:	83 ec 0c             	sub    $0xc,%esp
  800765:	6a 00                	push   $0x0
  800767:	e8 b7 1b 00 00       	call   802323 <sys_destroy_env>
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	90                   	nop
  800770:	c9                   	leave  
  800771:	c3                   	ret    

00800772 <exit>:

void
exit(void)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800778:	e8 0c 1c 00 00       	call   802389 <sys_exit_env>
}
  80077d:	90                   	nop
  80077e:	c9                   	leave  
  80077f:	c3                   	ret    

00800780 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800780:	55                   	push   %ebp
  800781:	89 e5                	mov    %esp,%ebp
  800783:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800786:	8d 45 10             	lea    0x10(%ebp),%eax
  800789:	83 c0 04             	add    $0x4,%eax
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80078f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800794:	85 c0                	test   %eax,%eax
  800796:	74 16                	je     8007ae <_panic+0x2e>
		cprintf("%s: ", argv0);
  800798:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80079d:	83 ec 08             	sub    $0x8,%esp
  8007a0:	50                   	push   %eax
  8007a1:	68 78 3c 80 00       	push   $0x803c78
  8007a6:	e8 89 02 00 00       	call   800a34 <cprintf>
  8007ab:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007ae:	a1 00 50 80 00       	mov    0x805000,%eax
  8007b3:	ff 75 0c             	pushl  0xc(%ebp)
  8007b6:	ff 75 08             	pushl  0x8(%ebp)
  8007b9:	50                   	push   %eax
  8007ba:	68 7d 3c 80 00       	push   $0x803c7d
  8007bf:	e8 70 02 00 00       	call   800a34 <cprintf>
  8007c4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ca:	83 ec 08             	sub    $0x8,%esp
  8007cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d0:	50                   	push   %eax
  8007d1:	e8 f3 01 00 00       	call   8009c9 <vcprintf>
  8007d6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007d9:	83 ec 08             	sub    $0x8,%esp
  8007dc:	6a 00                	push   $0x0
  8007de:	68 99 3c 80 00       	push   $0x803c99
  8007e3:	e8 e1 01 00 00       	call   8009c9 <vcprintf>
  8007e8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007eb:	e8 82 ff ff ff       	call   800772 <exit>

	// should not return here
	while (1) ;
  8007f0:	eb fe                	jmp    8007f0 <_panic+0x70>

008007f2 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	8b 50 74             	mov    0x74(%eax),%edx
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	39 c2                	cmp    %eax,%edx
  800805:	74 14                	je     80081b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800807:	83 ec 04             	sub    $0x4,%esp
  80080a:	68 9c 3c 80 00       	push   $0x803c9c
  80080f:	6a 26                	push   $0x26
  800811:	68 e8 3c 80 00       	push   $0x803ce8
  800816:	e8 65 ff ff ff       	call   800780 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80081b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800822:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800829:	e9 c2 00 00 00       	jmp    8008f0 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80082e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800831:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	01 d0                	add    %edx,%eax
  80083d:	8b 00                	mov    (%eax),%eax
  80083f:	85 c0                	test   %eax,%eax
  800841:	75 08                	jne    80084b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800843:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800846:	e9 a2 00 00 00       	jmp    8008ed <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80084b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800859:	eb 69                	jmp    8008c4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80085b:	a1 24 50 80 00       	mov    0x805024,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	84 c0                	test   %al,%al
  800879:	75 46                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800886:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	01 c0                	add    %eax,%eax
  80088d:	01 d0                	add    %edx,%eax
  80088f:	c1 e0 03             	shl    $0x3,%eax
  800892:	01 c8                	add    %ecx,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800899:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80089c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	01 c8                	add    %ecx,%eax
  8008b2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008b4:	39 c2                	cmp    %eax,%edx
  8008b6:	75 09                	jne    8008c1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008b8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008bf:	eb 12                	jmp    8008d3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008c1:	ff 45 e8             	incl   -0x18(%ebp)
  8008c4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008c9:	8b 50 74             	mov    0x74(%eax),%edx
  8008cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	77 88                	ja     80085b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008d7:	75 14                	jne    8008ed <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008d9:	83 ec 04             	sub    $0x4,%esp
  8008dc:	68 f4 3c 80 00       	push   $0x803cf4
  8008e1:	6a 3a                	push   $0x3a
  8008e3:	68 e8 3c 80 00       	push   $0x803ce8
  8008e8:	e8 93 fe ff ff       	call   800780 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008ed:	ff 45 f0             	incl   -0x10(%ebp)
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008f6:	0f 8c 32 ff ff ff    	jl     80082e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800903:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80090a:	eb 26                	jmp    800932 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80090c:	a1 24 50 80 00       	mov    0x805024,%eax
  800911:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800917:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80091a:	89 d0                	mov    %edx,%eax
  80091c:	01 c0                	add    %eax,%eax
  80091e:	01 d0                	add    %edx,%eax
  800920:	c1 e0 03             	shl    $0x3,%eax
  800923:	01 c8                	add    %ecx,%eax
  800925:	8a 40 04             	mov    0x4(%eax),%al
  800928:	3c 01                	cmp    $0x1,%al
  80092a:	75 03                	jne    80092f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80092c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80092f:	ff 45 e0             	incl   -0x20(%ebp)
  800932:	a1 24 50 80 00       	mov    0x805024,%eax
  800937:	8b 50 74             	mov    0x74(%eax),%edx
  80093a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80093d:	39 c2                	cmp    %eax,%edx
  80093f:	77 cb                	ja     80090c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800944:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800947:	74 14                	je     80095d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800949:	83 ec 04             	sub    $0x4,%esp
  80094c:	68 48 3d 80 00       	push   $0x803d48
  800951:	6a 44                	push   $0x44
  800953:	68 e8 3c 80 00       	push   $0x803ce8
  800958:	e8 23 fe ff ff       	call   800780 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80095d:	90                   	nop
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 d1                	mov    %dl,%cl
  800978:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80097f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800982:	8b 00                	mov    (%eax),%eax
  800984:	3d ff 00 00 00       	cmp    $0xff,%eax
  800989:	75 2c                	jne    8009b7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80098b:	a0 28 50 80 00       	mov    0x805028,%al
  800990:	0f b6 c0             	movzbl %al,%eax
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	8b 12                	mov    (%edx),%edx
  800998:	89 d1                	mov    %edx,%ecx
  80099a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80099d:	83 c2 08             	add    $0x8,%edx
  8009a0:	83 ec 04             	sub    $0x4,%esp
  8009a3:	50                   	push   %eax
  8009a4:	51                   	push   %ecx
  8009a5:	52                   	push   %edx
  8009a6:	e8 0b 16 00 00       	call   801fb6 <sys_cputs>
  8009ab:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ba:	8b 40 04             	mov    0x4(%eax),%eax
  8009bd:	8d 50 01             	lea    0x1(%eax),%edx
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009c6:	90                   	nop
  8009c7:	c9                   	leave  
  8009c8:	c3                   	ret    

008009c9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009c9:	55                   	push   %ebp
  8009ca:	89 e5                	mov    %esp,%ebp
  8009cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009d9:	00 00 00 
	b.cnt = 0;
  8009dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009e3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009e6:	ff 75 0c             	pushl  0xc(%ebp)
  8009e9:	ff 75 08             	pushl  0x8(%ebp)
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	50                   	push   %eax
  8009f3:	68 60 09 80 00       	push   $0x800960
  8009f8:	e8 11 02 00 00       	call   800c0e <vprintfmt>
  8009fd:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a00:	a0 28 50 80 00       	mov    0x805028,%al
  800a05:	0f b6 c0             	movzbl %al,%eax
  800a08:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a0e:	83 ec 04             	sub    $0x4,%esp
  800a11:	50                   	push   %eax
  800a12:	52                   	push   %edx
  800a13:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a19:	83 c0 08             	add    $0x8,%eax
  800a1c:	50                   	push   %eax
  800a1d:	e8 94 15 00 00       	call   801fb6 <sys_cputs>
  800a22:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a25:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a2c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a32:	c9                   	leave  
  800a33:	c3                   	ret    

00800a34 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a3a:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a41:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 f4             	pushl  -0xc(%ebp)
  800a50:	50                   	push   %eax
  800a51:	e8 73 ff ff ff       	call   8009c9 <vcprintf>
  800a56:	83 c4 10             	add    $0x10,%esp
  800a59:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a67:	e8 f8 16 00 00       	call   802164 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a6c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	83 ec 08             	sub    $0x8,%esp
  800a78:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7b:	50                   	push   %eax
  800a7c:	e8 48 ff ff ff       	call   8009c9 <vcprintf>
  800a81:	83 c4 10             	add    $0x10,%esp
  800a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a87:	e8 f2 16 00 00       	call   80217e <sys_enable_interrupt>
	return cnt;
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	53                   	push   %ebx
  800a95:	83 ec 14             	sub    $0x14,%esp
  800a98:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800aa4:	8b 45 18             	mov    0x18(%ebp),%eax
  800aa7:	ba 00 00 00 00       	mov    $0x0,%edx
  800aac:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aaf:	77 55                	ja     800b06 <printnum+0x75>
  800ab1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ab4:	72 05                	jb     800abb <printnum+0x2a>
  800ab6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ab9:	77 4b                	ja     800b06 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800abb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800abe:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ac1:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac9:	52                   	push   %edx
  800aca:	50                   	push   %eax
  800acb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ace:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad1:	e8 6a 2c 00 00       	call   803740 <__udivdi3>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	ff 75 20             	pushl  0x20(%ebp)
  800adf:	53                   	push   %ebx
  800ae0:	ff 75 18             	pushl  0x18(%ebp)
  800ae3:	52                   	push   %edx
  800ae4:	50                   	push   %eax
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	ff 75 08             	pushl  0x8(%ebp)
  800aeb:	e8 a1 ff ff ff       	call   800a91 <printnum>
  800af0:	83 c4 20             	add    $0x20,%esp
  800af3:	eb 1a                	jmp    800b0f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	ff 75 20             	pushl  0x20(%ebp)
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b06:	ff 4d 1c             	decl   0x1c(%ebp)
  800b09:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b0d:	7f e6                	jg     800af5 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b0f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b12:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b1d:	53                   	push   %ebx
  800b1e:	51                   	push   %ecx
  800b1f:	52                   	push   %edx
  800b20:	50                   	push   %eax
  800b21:	e8 2a 2d 00 00       	call   803850 <__umoddi3>
  800b26:	83 c4 10             	add    $0x10,%esp
  800b29:	05 b4 3f 80 00       	add    $0x803fb4,%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f be c0             	movsbl %al,%eax
  800b33:	83 ec 08             	sub    $0x8,%esp
  800b36:	ff 75 0c             	pushl  0xc(%ebp)
  800b39:	50                   	push   %eax
  800b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3d:	ff d0                	call   *%eax
  800b3f:	83 c4 10             	add    $0x10,%esp
}
  800b42:	90                   	nop
  800b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b46:	c9                   	leave  
  800b47:	c3                   	ret    

00800b48 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b4b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b4f:	7e 1c                	jle    800b6d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b51:	8b 45 08             	mov    0x8(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 50 08             	lea    0x8(%eax),%edx
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	89 10                	mov    %edx,(%eax)
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	83 e8 08             	sub    $0x8,%eax
  800b66:	8b 50 04             	mov    0x4(%eax),%edx
  800b69:	8b 00                	mov    (%eax),%eax
  800b6b:	eb 40                	jmp    800bad <getuint+0x65>
	else if (lflag)
  800b6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b71:	74 1e                	je     800b91 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	8d 50 04             	lea    0x4(%eax),%edx
  800b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7e:	89 10                	mov    %edx,(%eax)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	83 e8 04             	sub    $0x4,%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8f:	eb 1c                	jmp    800bad <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 04             	lea    0x4(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 04             	sub    $0x4,%eax
  800ba6:	8b 00                	mov    (%eax),%eax
  800ba8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bad:	5d                   	pop    %ebp
  800bae:	c3                   	ret    

00800baf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bb2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bb6:	7e 1c                	jle    800bd4 <getint+0x25>
		return va_arg(*ap, long long);
  800bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbb:	8b 00                	mov    (%eax),%eax
  800bbd:	8d 50 08             	lea    0x8(%eax),%edx
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 10                	mov    %edx,(%eax)
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	83 e8 08             	sub    $0x8,%eax
  800bcd:	8b 50 04             	mov    0x4(%eax),%edx
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	eb 38                	jmp    800c0c <getint+0x5d>
	else if (lflag)
  800bd4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd8:	74 1a                	je     800bf4 <getint+0x45>
		return va_arg(*ap, long);
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	8d 50 04             	lea    0x4(%eax),%edx
  800be2:	8b 45 08             	mov    0x8(%ebp),%eax
  800be5:	89 10                	mov    %edx,(%eax)
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bea:	8b 00                	mov    (%eax),%eax
  800bec:	83 e8 04             	sub    $0x4,%eax
  800bef:	8b 00                	mov    (%eax),%eax
  800bf1:	99                   	cltd   
  800bf2:	eb 18                	jmp    800c0c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf7:	8b 00                	mov    (%eax),%eax
  800bf9:	8d 50 04             	lea    0x4(%eax),%edx
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 10                	mov    %edx,(%eax)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8b 00                	mov    (%eax),%eax
  800c06:	83 e8 04             	sub    $0x4,%eax
  800c09:	8b 00                	mov    (%eax),%eax
  800c0b:	99                   	cltd   
}
  800c0c:	5d                   	pop    %ebp
  800c0d:	c3                   	ret    

00800c0e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	56                   	push   %esi
  800c12:	53                   	push   %ebx
  800c13:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c16:	eb 17                	jmp    800c2f <vprintfmt+0x21>
			if (ch == '\0')
  800c18:	85 db                	test   %ebx,%ebx
  800c1a:	0f 84 af 03 00 00    	je     800fcf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c20:	83 ec 08             	sub    $0x8,%esp
  800c23:	ff 75 0c             	pushl  0xc(%ebp)
  800c26:	53                   	push   %ebx
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	ff d0                	call   *%eax
  800c2c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 10             	mov    %edx,0x10(%ebp)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	0f b6 d8             	movzbl %al,%ebx
  800c3d:	83 fb 25             	cmp    $0x25,%ebx
  800c40:	75 d6                	jne    800c18 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c42:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c46:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c4d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c54:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c5b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	8d 50 01             	lea    0x1(%eax),%edx
  800c68:	89 55 10             	mov    %edx,0x10(%ebp)
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	0f b6 d8             	movzbl %al,%ebx
  800c70:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c73:	83 f8 55             	cmp    $0x55,%eax
  800c76:	0f 87 2b 03 00 00    	ja     800fa7 <vprintfmt+0x399>
  800c7c:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
  800c83:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c85:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c89:	eb d7                	jmp    800c62 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c8b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c8f:	eb d1                	jmp    800c62 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c9b:	89 d0                	mov    %edx,%eax
  800c9d:	c1 e0 02             	shl    $0x2,%eax
  800ca0:	01 d0                	add    %edx,%eax
  800ca2:	01 c0                	add    %eax,%eax
  800ca4:	01 d8                	add    %ebx,%eax
  800ca6:	83 e8 30             	sub    $0x30,%eax
  800ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cac:	8b 45 10             	mov    0x10(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cb4:	83 fb 2f             	cmp    $0x2f,%ebx
  800cb7:	7e 3e                	jle    800cf7 <vprintfmt+0xe9>
  800cb9:	83 fb 39             	cmp    $0x39,%ebx
  800cbc:	7f 39                	jg     800cf7 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cbe:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cc1:	eb d5                	jmp    800c98 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 c0 04             	add    $0x4,%eax
  800cc9:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 e8 04             	sub    $0x4,%eax
  800cd2:	8b 00                	mov    (%eax),%eax
  800cd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cd7:	eb 1f                	jmp    800cf8 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cd9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cdd:	79 83                	jns    800c62 <vprintfmt+0x54>
				width = 0;
  800cdf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ce6:	e9 77 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ceb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800cf2:	e9 6b ff ff ff       	jmp    800c62 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cf7:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cf8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cfc:	0f 89 60 ff ff ff    	jns    800c62 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d08:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d0f:	e9 4e ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d14:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d17:	e9 46 ff ff ff       	jmp    800c62 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1f:	83 c0 04             	add    $0x4,%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
  800d25:	8b 45 14             	mov    0x14(%ebp),%eax
  800d28:	83 e8 04             	sub    $0x4,%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	83 ec 08             	sub    $0x8,%esp
  800d30:	ff 75 0c             	pushl  0xc(%ebp)
  800d33:	50                   	push   %eax
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	ff d0                	call   *%eax
  800d39:	83 c4 10             	add    $0x10,%esp
			break;
  800d3c:	e9 89 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 c0 04             	add    $0x4,%eax
  800d47:	89 45 14             	mov    %eax,0x14(%ebp)
  800d4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4d:	83 e8 04             	sub    $0x4,%eax
  800d50:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d52:	85 db                	test   %ebx,%ebx
  800d54:	79 02                	jns    800d58 <vprintfmt+0x14a>
				err = -err;
  800d56:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d58:	83 fb 64             	cmp    $0x64,%ebx
  800d5b:	7f 0b                	jg     800d68 <vprintfmt+0x15a>
  800d5d:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  800d64:	85 f6                	test   %esi,%esi
  800d66:	75 19                	jne    800d81 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d68:	53                   	push   %ebx
  800d69:	68 c5 3f 80 00       	push   $0x803fc5
  800d6e:	ff 75 0c             	pushl  0xc(%ebp)
  800d71:	ff 75 08             	pushl  0x8(%ebp)
  800d74:	e8 5e 02 00 00       	call   800fd7 <printfmt>
  800d79:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d7c:	e9 49 02 00 00       	jmp    800fca <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d81:	56                   	push   %esi
  800d82:	68 ce 3f 80 00       	push   $0x803fce
  800d87:	ff 75 0c             	pushl  0xc(%ebp)
  800d8a:	ff 75 08             	pushl  0x8(%ebp)
  800d8d:	e8 45 02 00 00       	call   800fd7 <printfmt>
  800d92:	83 c4 10             	add    $0x10,%esp
			break;
  800d95:	e9 30 02 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d9a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9d:	83 c0 04             	add    $0x4,%eax
  800da0:	89 45 14             	mov    %eax,0x14(%ebp)
  800da3:	8b 45 14             	mov    0x14(%ebp),%eax
  800da6:	83 e8 04             	sub    $0x4,%eax
  800da9:	8b 30                	mov    (%eax),%esi
  800dab:	85 f6                	test   %esi,%esi
  800dad:	75 05                	jne    800db4 <vprintfmt+0x1a6>
				p = "(null)";
  800daf:	be d1 3f 80 00       	mov    $0x803fd1,%esi
			if (width > 0 && padc != '-')
  800db4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800db8:	7e 6d                	jle    800e27 <vprintfmt+0x219>
  800dba:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dbe:	74 67                	je     800e27 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dc3:	83 ec 08             	sub    $0x8,%esp
  800dc6:	50                   	push   %eax
  800dc7:	56                   	push   %esi
  800dc8:	e8 12 05 00 00       	call   8012df <strnlen>
  800dcd:	83 c4 10             	add    $0x10,%esp
  800dd0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dd3:	eb 16                	jmp    800deb <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dd5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dd9:	83 ec 08             	sub    $0x8,%esp
  800ddc:	ff 75 0c             	pushl  0xc(%ebp)
  800ddf:	50                   	push   %eax
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	ff d0                	call   *%eax
  800de5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800de8:	ff 4d e4             	decl   -0x1c(%ebp)
  800deb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800def:	7f e4                	jg     800dd5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800df1:	eb 34                	jmp    800e27 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800df3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800df7:	74 1c                	je     800e15 <vprintfmt+0x207>
  800df9:	83 fb 1f             	cmp    $0x1f,%ebx
  800dfc:	7e 05                	jle    800e03 <vprintfmt+0x1f5>
  800dfe:	83 fb 7e             	cmp    $0x7e,%ebx
  800e01:	7e 12                	jle    800e15 <vprintfmt+0x207>
					putch('?', putdat);
  800e03:	83 ec 08             	sub    $0x8,%esp
  800e06:	ff 75 0c             	pushl  0xc(%ebp)
  800e09:	6a 3f                	push   $0x3f
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	ff d0                	call   *%eax
  800e10:	83 c4 10             	add    $0x10,%esp
  800e13:	eb 0f                	jmp    800e24 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e15:	83 ec 08             	sub    $0x8,%esp
  800e18:	ff 75 0c             	pushl  0xc(%ebp)
  800e1b:	53                   	push   %ebx
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e24:	ff 4d e4             	decl   -0x1c(%ebp)
  800e27:	89 f0                	mov    %esi,%eax
  800e29:	8d 70 01             	lea    0x1(%eax),%esi
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	0f be d8             	movsbl %al,%ebx
  800e31:	85 db                	test   %ebx,%ebx
  800e33:	74 24                	je     800e59 <vprintfmt+0x24b>
  800e35:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e39:	78 b8                	js     800df3 <vprintfmt+0x1e5>
  800e3b:	ff 4d e0             	decl   -0x20(%ebp)
  800e3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e42:	79 af                	jns    800df3 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e44:	eb 13                	jmp    800e59 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e46:	83 ec 08             	sub    $0x8,%esp
  800e49:	ff 75 0c             	pushl  0xc(%ebp)
  800e4c:	6a 20                	push   $0x20
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	ff d0                	call   *%eax
  800e53:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e56:	ff 4d e4             	decl   -0x1c(%ebp)
  800e59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5d:	7f e7                	jg     800e46 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e5f:	e9 66 01 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e64:	83 ec 08             	sub    $0x8,%esp
  800e67:	ff 75 e8             	pushl  -0x18(%ebp)
  800e6a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e6d:	50                   	push   %eax
  800e6e:	e8 3c fd ff ff       	call   800baf <getint>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e79:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e82:	85 d2                	test   %edx,%edx
  800e84:	79 23                	jns    800ea9 <vprintfmt+0x29b>
				putch('-', putdat);
  800e86:	83 ec 08             	sub    $0x8,%esp
  800e89:	ff 75 0c             	pushl  0xc(%ebp)
  800e8c:	6a 2d                	push   $0x2d
  800e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e91:	ff d0                	call   *%eax
  800e93:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9c:	f7 d8                	neg    %eax
  800e9e:	83 d2 00             	adc    $0x0,%edx
  800ea1:	f7 da                	neg    %edx
  800ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ea9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eb0:	e9 bc 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800eb5:	83 ec 08             	sub    $0x8,%esp
  800eb8:	ff 75 e8             	pushl  -0x18(%ebp)
  800ebb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebe:	50                   	push   %eax
  800ebf:	e8 84 fc ff ff       	call   800b48 <getuint>
  800ec4:	83 c4 10             	add    $0x10,%esp
  800ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ecd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ed4:	e9 98 00 00 00       	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ed9:	83 ec 08             	sub    $0x8,%esp
  800edc:	ff 75 0c             	pushl  0xc(%ebp)
  800edf:	6a 58                	push   $0x58
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	ff d0                	call   *%eax
  800ee6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ee9:	83 ec 08             	sub    $0x8,%esp
  800eec:	ff 75 0c             	pushl  0xc(%ebp)
  800eef:	6a 58                	push   $0x58
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	ff d0                	call   *%eax
  800ef6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ef9:	83 ec 08             	sub    $0x8,%esp
  800efc:	ff 75 0c             	pushl  0xc(%ebp)
  800eff:	6a 58                	push   $0x58
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	ff d0                	call   *%eax
  800f06:	83 c4 10             	add    $0x10,%esp
			break;
  800f09:	e9 bc 00 00 00       	jmp    800fca <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 0c             	pushl  0xc(%ebp)
  800f14:	6a 30                	push   $0x30
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	ff d0                	call   *%eax
  800f1b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 0c             	pushl  0xc(%ebp)
  800f24:	6a 78                	push   $0x78
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	ff d0                	call   *%eax
  800f2b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f31:	83 c0 04             	add    $0x4,%eax
  800f34:	89 45 14             	mov    %eax,0x14(%ebp)
  800f37:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3a:	83 e8 04             	sub    $0x4,%eax
  800f3d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f49:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f50:	eb 1f                	jmp    800f71 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f52:	83 ec 08             	sub    $0x8,%esp
  800f55:	ff 75 e8             	pushl  -0x18(%ebp)
  800f58:	8d 45 14             	lea    0x14(%ebp),%eax
  800f5b:	50                   	push   %eax
  800f5c:	e8 e7 fb ff ff       	call   800b48 <getuint>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f6a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f71:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	52                   	push   %edx
  800f7c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f7f:	50                   	push   %eax
  800f80:	ff 75 f4             	pushl  -0xc(%ebp)
  800f83:	ff 75 f0             	pushl  -0x10(%ebp)
  800f86:	ff 75 0c             	pushl  0xc(%ebp)
  800f89:	ff 75 08             	pushl  0x8(%ebp)
  800f8c:	e8 00 fb ff ff       	call   800a91 <printnum>
  800f91:	83 c4 20             	add    $0x20,%esp
			break;
  800f94:	eb 34                	jmp    800fca <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			break;
  800fa5:	eb 23                	jmp    800fca <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	6a 25                	push   $0x25
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	ff d0                	call   *%eax
  800fb4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fb7:	ff 4d 10             	decl   0x10(%ebp)
  800fba:	eb 03                	jmp    800fbf <vprintfmt+0x3b1>
  800fbc:	ff 4d 10             	decl   0x10(%ebp)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	48                   	dec    %eax
  800fc3:	8a 00                	mov    (%eax),%al
  800fc5:	3c 25                	cmp    $0x25,%al
  800fc7:	75 f3                	jne    800fbc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fc9:	90                   	nop
		}
	}
  800fca:	e9 47 fc ff ff       	jmp    800c16 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fcf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fd3:	5b                   	pop    %ebx
  800fd4:	5e                   	pop    %esi
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fdd:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe0:	83 c0 04             	add    $0x4,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe9:	ff 75 f4             	pushl  -0xc(%ebp)
  800fec:	50                   	push   %eax
  800fed:	ff 75 0c             	pushl  0xc(%ebp)
  800ff0:	ff 75 08             	pushl  0x8(%ebp)
  800ff3:	e8 16 fc ff ff       	call   800c0e <vprintfmt>
  800ff8:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ffb:	90                   	nop
  800ffc:	c9                   	leave  
  800ffd:	c3                   	ret    

00800ffe <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	8b 40 08             	mov    0x8(%eax),%eax
  801007:	8d 50 01             	lea    0x1(%eax),%edx
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	8b 10                	mov    (%eax),%edx
  801015:	8b 45 0c             	mov    0xc(%ebp),%eax
  801018:	8b 40 04             	mov    0x4(%eax),%eax
  80101b:	39 c2                	cmp    %eax,%edx
  80101d:	73 12                	jae    801031 <sprintputch+0x33>
		*b->buf++ = ch;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	8b 00                	mov    (%eax),%eax
  801024:	8d 48 01             	lea    0x1(%eax),%ecx
  801027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102a:	89 0a                	mov    %ecx,(%edx)
  80102c:	8b 55 08             	mov    0x8(%ebp),%edx
  80102f:	88 10                	mov    %dl,(%eax)
}
  801031:	90                   	nop
  801032:	5d                   	pop    %ebp
  801033:	c3                   	ret    

00801034 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	8d 50 ff             	lea    -0x1(%eax),%edx
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801059:	74 06                	je     801061 <vsnprintf+0x2d>
  80105b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80105f:	7f 07                	jg     801068 <vsnprintf+0x34>
		return -E_INVAL;
  801061:	b8 03 00 00 00       	mov    $0x3,%eax
  801066:	eb 20                	jmp    801088 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801068:	ff 75 14             	pushl  0x14(%ebp)
  80106b:	ff 75 10             	pushl  0x10(%ebp)
  80106e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801071:	50                   	push   %eax
  801072:	68 fe 0f 80 00       	push   $0x800ffe
  801077:	e8 92 fb ff ff       	call   800c0e <vprintfmt>
  80107c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80107f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801082:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801085:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801090:	8d 45 10             	lea    0x10(%ebp),%eax
  801093:	83 c0 04             	add    $0x4,%eax
  801096:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801099:	8b 45 10             	mov    0x10(%ebp),%eax
  80109c:	ff 75 f4             	pushl  -0xc(%ebp)
  80109f:	50                   	push   %eax
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	ff 75 08             	pushl  0x8(%ebp)
  8010a6:	e8 89 ff ff ff       	call   801034 <vsnprintf>
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c0:	74 13                	je     8010d5 <readline+0x1f>
		cprintf("%s", prompt);
  8010c2:	83 ec 08             	sub    $0x8,%esp
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	68 30 41 80 00       	push   $0x804130
  8010cd:	e8 62 f9 ff ff       	call   800a34 <cprintf>
  8010d2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010dc:	83 ec 0c             	sub    $0xc,%esp
  8010df:	6a 00                	push   $0x0
  8010e1:	e8 54 f5 ff ff       	call   80063a <iscons>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010ec:	e8 fb f4 ff ff       	call   8005ec <getchar>
  8010f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8010f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8010f8:	79 22                	jns    80111c <readline+0x66>
			if (c != -E_EOF)
  8010fa:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010fe:	0f 84 ad 00 00 00    	je     8011b1 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801104:	83 ec 08             	sub    $0x8,%esp
  801107:	ff 75 ec             	pushl  -0x14(%ebp)
  80110a:	68 33 41 80 00       	push   $0x804133
  80110f:	e8 20 f9 ff ff       	call   800a34 <cprintf>
  801114:	83 c4 10             	add    $0x10,%esp
			return;
  801117:	e9 95 00 00 00       	jmp    8011b1 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80111c:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801120:	7e 34                	jle    801156 <readline+0xa0>
  801122:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801129:	7f 2b                	jg     801156 <readline+0xa0>
			if (echoing)
  80112b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80112f:	74 0e                	je     80113f <readline+0x89>
				cputchar(c);
  801131:	83 ec 0c             	sub    $0xc,%esp
  801134:	ff 75 ec             	pushl  -0x14(%ebp)
  801137:	e8 68 f4 ff ff       	call   8005a4 <cputchar>
  80113c:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80113f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801142:	8d 50 01             	lea    0x1(%eax),%edx
  801145:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801148:	89 c2                	mov    %eax,%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801152:	88 10                	mov    %dl,(%eax)
  801154:	eb 56                	jmp    8011ac <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801156:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80115a:	75 1f                	jne    80117b <readline+0xc5>
  80115c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801160:	7e 19                	jle    80117b <readline+0xc5>
			if (echoing)
  801162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801166:	74 0e                	je     801176 <readline+0xc0>
				cputchar(c);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	ff 75 ec             	pushl  -0x14(%ebp)
  80116e:	e8 31 f4 ff ff       	call   8005a4 <cputchar>
  801173:	83 c4 10             	add    $0x10,%esp

			i--;
  801176:	ff 4d f4             	decl   -0xc(%ebp)
  801179:	eb 31                	jmp    8011ac <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80117b:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80117f:	74 0a                	je     80118b <readline+0xd5>
  801181:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801185:	0f 85 61 ff ff ff    	jne    8010ec <readline+0x36>
			if (echoing)
  80118b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80118f:	74 0e                	je     80119f <readline+0xe9>
				cputchar(c);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	ff 75 ec             	pushl  -0x14(%ebp)
  801197:	e8 08 f4 ff ff       	call   8005a4 <cputchar>
  80119c:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011aa:	eb 06                	jmp    8011b2 <readline+0xfc>
		}
	}
  8011ac:	e9 3b ff ff ff       	jmp    8010ec <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011b1:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011ba:	e8 a5 0f 00 00       	call   802164 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	74 13                	je     8011d8 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	68 30 41 80 00       	push   $0x804130
  8011d0:	e8 5f f8 ff ff       	call   800a34 <cprintf>
  8011d5:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	6a 00                	push   $0x0
  8011e4:	e8 51 f4 ff ff       	call   80063a <iscons>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8011ef:	e8 f8 f3 ff ff       	call   8005ec <getchar>
  8011f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  8011f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011fb:	79 23                	jns    801220 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011fd:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801201:	74 13                	je     801216 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801203:	83 ec 08             	sub    $0x8,%esp
  801206:	ff 75 ec             	pushl  -0x14(%ebp)
  801209:	68 33 41 80 00       	push   $0x804133
  80120e:	e8 21 f8 ff ff       	call   800a34 <cprintf>
  801213:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801216:	e8 63 0f 00 00       	call   80217e <sys_enable_interrupt>
			return;
  80121b:	e9 9a 00 00 00       	jmp    8012ba <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801220:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801224:	7e 34                	jle    80125a <atomic_readline+0xa6>
  801226:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80122d:	7f 2b                	jg     80125a <atomic_readline+0xa6>
			if (echoing)
  80122f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801233:	74 0e                	je     801243 <atomic_readline+0x8f>
				cputchar(c);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 ec             	pushl  -0x14(%ebp)
  80123b:	e8 64 f3 ff ff       	call   8005a4 <cputchar>
  801240:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801243:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801246:	8d 50 01             	lea    0x1(%eax),%edx
  801249:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80124c:	89 c2                	mov    %eax,%edx
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	01 d0                	add    %edx,%eax
  801253:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801256:	88 10                	mov    %dl,(%eax)
  801258:	eb 5b                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80125a:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80125e:	75 1f                	jne    80127f <atomic_readline+0xcb>
  801260:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801264:	7e 19                	jle    80127f <atomic_readline+0xcb>
			if (echoing)
  801266:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80126a:	74 0e                	je     80127a <atomic_readline+0xc6>
				cputchar(c);
  80126c:	83 ec 0c             	sub    $0xc,%esp
  80126f:	ff 75 ec             	pushl  -0x14(%ebp)
  801272:	e8 2d f3 ff ff       	call   8005a4 <cputchar>
  801277:	83 c4 10             	add    $0x10,%esp
			i--;
  80127a:	ff 4d f4             	decl   -0xc(%ebp)
  80127d:	eb 36                	jmp    8012b5 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80127f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801283:	74 0a                	je     80128f <atomic_readline+0xdb>
  801285:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801289:	0f 85 60 ff ff ff    	jne    8011ef <atomic_readline+0x3b>
			if (echoing)
  80128f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801293:	74 0e                	je     8012a3 <atomic_readline+0xef>
				cputchar(c);
  801295:	83 ec 0c             	sub    $0xc,%esp
  801298:	ff 75 ec             	pushl  -0x14(%ebp)
  80129b:	e8 04 f3 ff ff       	call   8005a4 <cputchar>
  8012a0:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	01 d0                	add    %edx,%eax
  8012ab:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012ae:	e8 cb 0e 00 00       	call   80217e <sys_enable_interrupt>
			return;
  8012b3:	eb 05                	jmp    8012ba <atomic_readline+0x106>
		}
	}
  8012b5:	e9 35 ff ff ff       	jmp    8011ef <atomic_readline+0x3b>
}
  8012ba:	c9                   	leave  
  8012bb:	c3                   	ret    

008012bc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012c9:	eb 06                	jmp    8012d1 <strlen+0x15>
		n++;
  8012cb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012ce:	ff 45 08             	incl   0x8(%ebp)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 f1                	jne    8012cb <strlen+0xf>
		n++;
	return n;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ec:	eb 09                	jmp    8012f7 <strnlen+0x18>
		n++;
  8012ee:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f1:	ff 45 08             	incl   0x8(%ebp)
  8012f4:	ff 4d 0c             	decl   0xc(%ebp)
  8012f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012fb:	74 09                	je     801306 <strnlen+0x27>
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	84 c0                	test   %al,%al
  801304:	75 e8                	jne    8012ee <strnlen+0xf>
		n++;
	return n;
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801317:	90                   	nop
  801318:	8b 45 08             	mov    0x8(%ebp),%eax
  80131b:	8d 50 01             	lea    0x1(%eax),%edx
  80131e:	89 55 08             	mov    %edx,0x8(%ebp)
  801321:	8b 55 0c             	mov    0xc(%ebp),%edx
  801324:	8d 4a 01             	lea    0x1(%edx),%ecx
  801327:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80132a:	8a 12                	mov    (%edx),%dl
  80132c:	88 10                	mov    %dl,(%eax)
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	75 e4                	jne    801318 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801334:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
  80133c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80133f:	8b 45 08             	mov    0x8(%ebp),%eax
  801342:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134c:	eb 1f                	jmp    80136d <strncpy+0x34>
		*dst++ = *src;
  80134e:	8b 45 08             	mov    0x8(%ebp),%eax
  801351:	8d 50 01             	lea    0x1(%eax),%edx
  801354:	89 55 08             	mov    %edx,0x8(%ebp)
  801357:	8b 55 0c             	mov    0xc(%ebp),%edx
  80135a:	8a 12                	mov    (%edx),%dl
  80135c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80135e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801361:	8a 00                	mov    (%eax),%al
  801363:	84 c0                	test   %al,%al
  801365:	74 03                	je     80136a <strncpy+0x31>
			src++;
  801367:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80136a:	ff 45 fc             	incl   -0x4(%ebp)
  80136d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801370:	3b 45 10             	cmp    0x10(%ebp),%eax
  801373:	72 d9                	jb     80134e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801375:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80138a:	74 30                	je     8013bc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80138c:	eb 16                	jmp    8013a4 <strlcpy+0x2a>
			*dst++ = *src++;
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 08             	mov    %edx,0x8(%ebp)
  801397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013a4:	ff 4d 10             	decl   0x10(%ebp)
  8013a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013ab:	74 09                	je     8013b6 <strlcpy+0x3c>
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 d8                	jne    80138e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c2:	29 c2                	sub    %eax,%edx
  8013c4:	89 d0                	mov    %edx,%eax
}
  8013c6:	c9                   	leave  
  8013c7:	c3                   	ret    

008013c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013c8:	55                   	push   %ebp
  8013c9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013cb:	eb 06                	jmp    8013d3 <strcmp+0xb>
		p++, q++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
  8013d0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	84 c0                	test   %al,%al
  8013da:	74 0e                	je     8013ea <strcmp+0x22>
  8013dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013df:	8a 10                	mov    (%eax),%dl
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	8a 00                	mov    (%eax),%al
  8013e6:	38 c2                	cmp    %al,%dl
  8013e8:	74 e3                	je     8013cd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	8a 00                	mov    (%eax),%al
  8013ef:	0f b6 d0             	movzbl %al,%edx
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	0f b6 c0             	movzbl %al,%eax
  8013fa:	29 c2                	sub    %eax,%edx
  8013fc:	89 d0                	mov    %edx,%eax
}
  8013fe:	5d                   	pop    %ebp
  8013ff:	c3                   	ret    

00801400 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801400:	55                   	push   %ebp
  801401:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801403:	eb 09                	jmp    80140e <strncmp+0xe>
		n--, p++, q++;
  801405:	ff 4d 10             	decl   0x10(%ebp)
  801408:	ff 45 08             	incl   0x8(%ebp)
  80140b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80140e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801412:	74 17                	je     80142b <strncmp+0x2b>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	74 0e                	je     80142b <strncmp+0x2b>
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 10                	mov    (%eax),%dl
  801422:	8b 45 0c             	mov    0xc(%ebp),%eax
  801425:	8a 00                	mov    (%eax),%al
  801427:	38 c2                	cmp    %al,%dl
  801429:	74 da                	je     801405 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80142b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142f:	75 07                	jne    801438 <strncmp+0x38>
		return 0;
  801431:	b8 00 00 00 00       	mov    $0x0,%eax
  801436:	eb 14                	jmp    80144c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	8a 00                	mov    (%eax),%al
  80143d:	0f b6 d0             	movzbl %al,%edx
  801440:	8b 45 0c             	mov    0xc(%ebp),%eax
  801443:	8a 00                	mov    (%eax),%al
  801445:	0f b6 c0             	movzbl %al,%eax
  801448:	29 c2                	sub    %eax,%edx
  80144a:	89 d0                	mov    %edx,%eax
}
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80145a:	eb 12                	jmp    80146e <strchr+0x20>
		if (*s == c)
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801464:	75 05                	jne    80146b <strchr+0x1d>
			return (char *) s;
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	eb 11                	jmp    80147c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80146b:	ff 45 08             	incl   0x8(%ebp)
  80146e:	8b 45 08             	mov    0x8(%ebp),%eax
  801471:	8a 00                	mov    (%eax),%al
  801473:	84 c0                	test   %al,%al
  801475:	75 e5                	jne    80145c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801477:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80147c:	c9                   	leave  
  80147d:	c3                   	ret    

0080147e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80147e:	55                   	push   %ebp
  80147f:	89 e5                	mov    %esp,%ebp
  801481:	83 ec 04             	sub    $0x4,%esp
  801484:	8b 45 0c             	mov    0xc(%ebp),%eax
  801487:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80148a:	eb 0d                	jmp    801499 <strfind+0x1b>
		if (*s == c)
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801494:	74 0e                	je     8014a4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801496:	ff 45 08             	incl   0x8(%ebp)
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8a 00                	mov    (%eax),%al
  80149e:	84 c0                	test   %al,%al
  8014a0:	75 ea                	jne    80148c <strfind+0xe>
  8014a2:	eb 01                	jmp    8014a5 <strfind+0x27>
		if (*s == c)
			break;
  8014a4:	90                   	nop
	return (char *) s;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014bc:	eb 0e                	jmp    8014cc <memset+0x22>
		*p++ = c;
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8d 50 01             	lea    0x1(%eax),%edx
  8014c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ca:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014cc:	ff 4d f8             	decl   -0x8(%ebp)
  8014cf:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014d3:	79 e9                	jns    8014be <memset+0x14>
		*p++ = c;

	return v;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014ec:	eb 16                	jmp    801504 <memcpy+0x2a>
		*d++ = *s++;
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	8d 50 01             	lea    0x1(%eax),%edx
  8014f4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014fd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801500:	8a 12                	mov    (%edx),%dl
  801502:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801504:	8b 45 10             	mov    0x10(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	89 55 10             	mov    %edx,0x10(%ebp)
  80150d:	85 c0                	test   %eax,%eax
  80150f:	75 dd                	jne    8014ee <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801511:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801514:	c9                   	leave  
  801515:	c3                   	ret    

00801516 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80152e:	73 50                	jae    801580 <memmove+0x6a>
  801530:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801533:	8b 45 10             	mov    0x10(%ebp),%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153b:	76 43                	jbe    801580 <memmove+0x6a>
		s += n;
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801543:	8b 45 10             	mov    0x10(%ebp),%eax
  801546:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801549:	eb 10                	jmp    80155b <memmove+0x45>
			*--d = *--s;
  80154b:	ff 4d f8             	decl   -0x8(%ebp)
  80154e:	ff 4d fc             	decl   -0x4(%ebp)
  801551:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801554:	8a 10                	mov    (%eax),%dl
  801556:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801559:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80155b:	8b 45 10             	mov    0x10(%ebp),%eax
  80155e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801561:	89 55 10             	mov    %edx,0x10(%ebp)
  801564:	85 c0                	test   %eax,%eax
  801566:	75 e3                	jne    80154b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801568:	eb 23                	jmp    80158d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80156a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156d:	8d 50 01             	lea    0x1(%eax),%edx
  801570:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801573:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801576:	8d 4a 01             	lea    0x1(%edx),%ecx
  801579:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801580:	8b 45 10             	mov    0x10(%ebp),%eax
  801583:	8d 50 ff             	lea    -0x1(%eax),%edx
  801586:	89 55 10             	mov    %edx,0x10(%ebp)
  801589:	85 c0                	test   %eax,%eax
  80158b:	75 dd                	jne    80156a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801598:	8b 45 08             	mov    0x8(%ebp),%eax
  80159b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015a4:	eb 2a                	jmp    8015d0 <memcmp+0x3e>
		if (*s1 != *s2)
  8015a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a9:	8a 10                	mov    (%eax),%dl
  8015ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	38 c2                	cmp    %al,%dl
  8015b2:	74 16                	je     8015ca <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	0f b6 d0             	movzbl %al,%edx
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	0f b6 c0             	movzbl %al,%eax
  8015c4:	29 c2                	sub    %eax,%edx
  8015c6:	89 d0                	mov    %edx,%eax
  8015c8:	eb 18                	jmp    8015e2 <memcmp+0x50>
		s1++, s2++;
  8015ca:	ff 45 fc             	incl   -0x4(%ebp)
  8015cd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	75 c9                	jne    8015a6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e2:	c9                   	leave  
  8015e3:	c3                   	ret    

008015e4 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015e4:	55                   	push   %ebp
  8015e5:	89 e5                	mov    %esp,%ebp
  8015e7:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f0:	01 d0                	add    %edx,%eax
  8015f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8015f5:	eb 15                	jmp    80160c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8a 00                	mov    (%eax),%al
  8015fc:	0f b6 d0             	movzbl %al,%edx
  8015ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801602:	0f b6 c0             	movzbl %al,%eax
  801605:	39 c2                	cmp    %eax,%edx
  801607:	74 0d                	je     801616 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801609:	ff 45 08             	incl   0x8(%ebp)
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801612:	72 e3                	jb     8015f7 <memfind+0x13>
  801614:	eb 01                	jmp    801617 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801616:	90                   	nop
	return (void *) s;
  801617:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    

0080161c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801622:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801629:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801630:	eb 03                	jmp    801635 <strtol+0x19>
		s++;
  801632:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8a 00                	mov    (%eax),%al
  80163a:	3c 20                	cmp    $0x20,%al
  80163c:	74 f4                	je     801632 <strtol+0x16>
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	3c 09                	cmp    $0x9,%al
  801645:	74 eb                	je     801632 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8a 00                	mov    (%eax),%al
  80164c:	3c 2b                	cmp    $0x2b,%al
  80164e:	75 05                	jne    801655 <strtol+0x39>
		s++;
  801650:	ff 45 08             	incl   0x8(%ebp)
  801653:	eb 13                	jmp    801668 <strtol+0x4c>
	else if (*s == '-')
  801655:	8b 45 08             	mov    0x8(%ebp),%eax
  801658:	8a 00                	mov    (%eax),%al
  80165a:	3c 2d                	cmp    $0x2d,%al
  80165c:	75 0a                	jne    801668 <strtol+0x4c>
		s++, neg = 1;
  80165e:	ff 45 08             	incl   0x8(%ebp)
  801661:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80166c:	74 06                	je     801674 <strtol+0x58>
  80166e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801672:	75 20                	jne    801694 <strtol+0x78>
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	3c 30                	cmp    $0x30,%al
  80167b:	75 17                	jne    801694 <strtol+0x78>
  80167d:	8b 45 08             	mov    0x8(%ebp),%eax
  801680:	40                   	inc    %eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3c 78                	cmp    $0x78,%al
  801685:	75 0d                	jne    801694 <strtol+0x78>
		s += 2, base = 16;
  801687:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80168b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801692:	eb 28                	jmp    8016bc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801694:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801698:	75 15                	jne    8016af <strtol+0x93>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 00                	mov    (%eax),%al
  80169f:	3c 30                	cmp    $0x30,%al
  8016a1:	75 0c                	jne    8016af <strtol+0x93>
		s++, base = 8;
  8016a3:	ff 45 08             	incl   0x8(%ebp)
  8016a6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016ad:	eb 0d                	jmp    8016bc <strtol+0xa0>
	else if (base == 0)
  8016af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016b3:	75 07                	jne    8016bc <strtol+0xa0>
		base = 10;
  8016b5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	8a 00                	mov    (%eax),%al
  8016c1:	3c 2f                	cmp    $0x2f,%al
  8016c3:	7e 19                	jle    8016de <strtol+0xc2>
  8016c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c8:	8a 00                	mov    (%eax),%al
  8016ca:	3c 39                	cmp    $0x39,%al
  8016cc:	7f 10                	jg     8016de <strtol+0xc2>
			dig = *s - '0';
  8016ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	0f be c0             	movsbl %al,%eax
  8016d6:	83 e8 30             	sub    $0x30,%eax
  8016d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016dc:	eb 42                	jmp    801720 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016de:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e1:	8a 00                	mov    (%eax),%al
  8016e3:	3c 60                	cmp    $0x60,%al
  8016e5:	7e 19                	jle    801700 <strtol+0xe4>
  8016e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ea:	8a 00                	mov    (%eax),%al
  8016ec:	3c 7a                	cmp    $0x7a,%al
  8016ee:	7f 10                	jg     801700 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8a 00                	mov    (%eax),%al
  8016f5:	0f be c0             	movsbl %al,%eax
  8016f8:	83 e8 57             	sub    $0x57,%eax
  8016fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016fe:	eb 20                	jmp    801720 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801700:	8b 45 08             	mov    0x8(%ebp),%eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	3c 40                	cmp    $0x40,%al
  801707:	7e 39                	jle    801742 <strtol+0x126>
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	3c 5a                	cmp    $0x5a,%al
  801710:	7f 30                	jg     801742 <strtol+0x126>
			dig = *s - 'A' + 10;
  801712:	8b 45 08             	mov    0x8(%ebp),%eax
  801715:	8a 00                	mov    (%eax),%al
  801717:	0f be c0             	movsbl %al,%eax
  80171a:	83 e8 37             	sub    $0x37,%eax
  80171d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801723:	3b 45 10             	cmp    0x10(%ebp),%eax
  801726:	7d 19                	jge    801741 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801728:	ff 45 08             	incl   0x8(%ebp)
  80172b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801732:	89 c2                	mov    %eax,%edx
  801734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801737:	01 d0                	add    %edx,%eax
  801739:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80173c:	e9 7b ff ff ff       	jmp    8016bc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801741:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801742:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801746:	74 08                	je     801750 <strtol+0x134>
		*endptr = (char *) s;
  801748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174b:	8b 55 08             	mov    0x8(%ebp),%edx
  80174e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801750:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801754:	74 07                	je     80175d <strtol+0x141>
  801756:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801759:	f7 d8                	neg    %eax
  80175b:	eb 03                	jmp    801760 <strtol+0x144>
  80175d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801760:	c9                   	leave  
  801761:	c3                   	ret    

00801762 <ltostr>:

void
ltostr(long value, char *str)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80176f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801776:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80177a:	79 13                	jns    80178f <ltostr+0x2d>
	{
		neg = 1;
  80177c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801789:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80178c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801797:	99                   	cltd   
  801798:	f7 f9                	idiv   %ecx
  80179a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80179d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a0:	8d 50 01             	lea    0x1(%eax),%edx
  8017a3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017a6:	89 c2                	mov    %eax,%edx
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017b0:	83 c2 30             	add    $0x30,%edx
  8017b3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017b8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017bd:	f7 e9                	imul   %ecx
  8017bf:	c1 fa 02             	sar    $0x2,%edx
  8017c2:	89 c8                	mov    %ecx,%eax
  8017c4:	c1 f8 1f             	sar    $0x1f,%eax
  8017c7:	29 c2                	sub    %eax,%edx
  8017c9:	89 d0                	mov    %edx,%eax
  8017cb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017d1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017d6:	f7 e9                	imul   %ecx
  8017d8:	c1 fa 02             	sar    $0x2,%edx
  8017db:	89 c8                	mov    %ecx,%eax
  8017dd:	c1 f8 1f             	sar    $0x1f,%eax
  8017e0:	29 c2                	sub    %eax,%edx
  8017e2:	89 d0                	mov    %edx,%eax
  8017e4:	c1 e0 02             	shl    $0x2,%eax
  8017e7:	01 d0                	add    %edx,%eax
  8017e9:	01 c0                	add    %eax,%eax
  8017eb:	29 c1                	sub    %eax,%ecx
  8017ed:	89 ca                	mov    %ecx,%edx
  8017ef:	85 d2                	test   %edx,%edx
  8017f1:	75 9c                	jne    80178f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8017f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017fd:	48                   	dec    %eax
  8017fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801801:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801805:	74 3d                	je     801844 <ltostr+0xe2>
		start = 1 ;
  801807:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80180e:	eb 34                	jmp    801844 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801813:	8b 45 0c             	mov    0xc(%ebp),%eax
  801816:	01 d0                	add    %edx,%eax
  801818:	8a 00                	mov    (%eax),%al
  80181a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80181d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	01 c2                	add    %eax,%edx
  801825:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	01 c8                	add    %ecx,%eax
  80182d:	8a 00                	mov    (%eax),%al
  80182f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801831:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	01 c2                	add    %eax,%edx
  801839:	8a 45 eb             	mov    -0x15(%ebp),%al
  80183c:	88 02                	mov    %al,(%edx)
		start++ ;
  80183e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801841:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184a:	7c c4                	jl     801810 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80184c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80184f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801852:	01 d0                	add    %edx,%eax
  801854:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801857:	90                   	nop
  801858:	c9                   	leave  
  801859:	c3                   	ret    

0080185a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801860:	ff 75 08             	pushl  0x8(%ebp)
  801863:	e8 54 fa ff ff       	call   8012bc <strlen>
  801868:	83 c4 04             	add    $0x4,%esp
  80186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	e8 46 fa ff ff       	call   8012bc <strlen>
  801876:	83 c4 04             	add    $0x4,%esp
  801879:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80187c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801883:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80188a:	eb 17                	jmp    8018a3 <strcconcat+0x49>
		final[s] = str1[s] ;
  80188c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	01 c2                	add    %eax,%edx
  801894:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	01 c8                	add    %ecx,%eax
  80189c:	8a 00                	mov    (%eax),%al
  80189e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018a0:	ff 45 fc             	incl   -0x4(%ebp)
  8018a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018a9:	7c e1                	jl     80188c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018b2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018b9:	eb 1f                	jmp    8018da <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018c4:	89 c2                	mov    %eax,%edx
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	01 c2                	add    %eax,%edx
  8018cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d1:	01 c8                	add    %ecx,%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018d7:	ff 45 f8             	incl   -0x8(%ebp)
  8018da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018e0:	7c d9                	jl     8018bb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e8:	01 d0                	add    %edx,%eax
  8018ea:	c6 00 00             	movb   $0x0,(%eax)
}
  8018ed:	90                   	nop
  8018ee:	c9                   	leave  
  8018ef:	c3                   	ret    

008018f0 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8018f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8018ff:	8b 00                	mov    (%eax),%eax
  801901:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801908:	8b 45 10             	mov    0x10(%ebp),%eax
  80190b:	01 d0                	add    %edx,%eax
  80190d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801913:	eb 0c                	jmp    801921 <strsplit+0x31>
			*string++ = 0;
  801915:	8b 45 08             	mov    0x8(%ebp),%eax
  801918:	8d 50 01             	lea    0x1(%eax),%edx
  80191b:	89 55 08             	mov    %edx,0x8(%ebp)
  80191e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801921:	8b 45 08             	mov    0x8(%ebp),%eax
  801924:	8a 00                	mov    (%eax),%al
  801926:	84 c0                	test   %al,%al
  801928:	74 18                	je     801942 <strsplit+0x52>
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	8a 00                	mov    (%eax),%al
  80192f:	0f be c0             	movsbl %al,%eax
  801932:	50                   	push   %eax
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	e8 13 fb ff ff       	call   80144e <strchr>
  80193b:	83 c4 08             	add    $0x8,%esp
  80193e:	85 c0                	test   %eax,%eax
  801940:	75 d3                	jne    801915 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801942:	8b 45 08             	mov    0x8(%ebp),%eax
  801945:	8a 00                	mov    (%eax),%al
  801947:	84 c0                	test   %al,%al
  801949:	74 5a                	je     8019a5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80194b:	8b 45 14             	mov    0x14(%ebp),%eax
  80194e:	8b 00                	mov    (%eax),%eax
  801950:	83 f8 0f             	cmp    $0xf,%eax
  801953:	75 07                	jne    80195c <strsplit+0x6c>
		{
			return 0;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	eb 66                	jmp    8019c2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	8d 48 01             	lea    0x1(%eax),%ecx
  801964:	8b 55 14             	mov    0x14(%ebp),%edx
  801967:	89 0a                	mov    %ecx,(%edx)
  801969:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801970:	8b 45 10             	mov    0x10(%ebp),%eax
  801973:	01 c2                	add    %eax,%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197a:	eb 03                	jmp    80197f <strsplit+0x8f>
			string++;
  80197c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80197f:	8b 45 08             	mov    0x8(%ebp),%eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	84 c0                	test   %al,%al
  801986:	74 8b                	je     801913 <strsplit+0x23>
  801988:	8b 45 08             	mov    0x8(%ebp),%eax
  80198b:	8a 00                	mov    (%eax),%al
  80198d:	0f be c0             	movsbl %al,%eax
  801990:	50                   	push   %eax
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	e8 b5 fa ff ff       	call   80144e <strchr>
  801999:	83 c4 08             	add    $0x8,%esp
  80199c:	85 c0                	test   %eax,%eax
  80199e:	74 dc                	je     80197c <strsplit+0x8c>
			string++;
	}
  8019a0:	e9 6e ff ff ff       	jmp    801913 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019a5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8019a9:	8b 00                	mov    (%eax),%eax
  8019ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b5:	01 d0                	add    %edx,%eax
  8019b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019bd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019ca:	a1 04 50 80 00       	mov    0x805004,%eax
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	74 1f                	je     8019f2 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019d3:	e8 1d 00 00 00       	call   8019f5 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019d8:	83 ec 0c             	sub    $0xc,%esp
  8019db:	68 44 41 80 00       	push   $0x804144
  8019e0:	e8 4f f0 ff ff       	call   800a34 <cprintf>
  8019e5:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019e8:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8019ef:	00 00 00 
	}
}
  8019f2:	90                   	nop
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8019fb:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a02:	00 00 00 
  801a05:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a0c:	00 00 00 
  801a0f:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a16:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801a19:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a20:	00 00 00 
  801a23:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a2a:	00 00 00 
  801a2d:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a34:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801a37:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a41:	c1 e8 0c             	shr    $0xc,%eax
  801a44:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801a49:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a53:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a58:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a5d:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801a62:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801a69:	a1 20 51 80 00       	mov    0x805120,%eax
  801a6e:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801a72:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801a75:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801a7c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a82:	01 d0                	add    %edx,%eax
  801a84:	48                   	dec    %eax
  801a85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a88:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a90:	f7 75 e4             	divl   -0x1c(%ebp)
  801a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a96:	29 d0                	sub    %edx,%eax
  801a98:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801a9b:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801aa2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aa5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801aaa:	2d 00 10 00 00       	sub    $0x1000,%eax
  801aaf:	83 ec 04             	sub    $0x4,%esp
  801ab2:	6a 07                	push   $0x7
  801ab4:	ff 75 e8             	pushl  -0x18(%ebp)
  801ab7:	50                   	push   %eax
  801ab8:	e8 3d 06 00 00       	call   8020fa <sys_allocate_chunk>
  801abd:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ac0:	a1 20 51 80 00       	mov    0x805120,%eax
  801ac5:	83 ec 0c             	sub    $0xc,%esp
  801ac8:	50                   	push   %eax
  801ac9:	e8 b2 0c 00 00       	call   802780 <initialize_MemBlocksList>
  801ace:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801ad1:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801ad6:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801ad9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801add:	0f 84 f3 00 00 00    	je     801bd6 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801ae3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801ae7:	75 14                	jne    801afd <initialize_dyn_block_system+0x108>
  801ae9:	83 ec 04             	sub    $0x4,%esp
  801aec:	68 69 41 80 00       	push   $0x804169
  801af1:	6a 36                	push   $0x36
  801af3:	68 87 41 80 00       	push   $0x804187
  801af8:	e8 83 ec ff ff       	call   800780 <_panic>
  801afd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b00:	8b 00                	mov    (%eax),%eax
  801b02:	85 c0                	test   %eax,%eax
  801b04:	74 10                	je     801b16 <initialize_dyn_block_system+0x121>
  801b06:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b09:	8b 00                	mov    (%eax),%eax
  801b0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b0e:	8b 52 04             	mov    0x4(%edx),%edx
  801b11:	89 50 04             	mov    %edx,0x4(%eax)
  801b14:	eb 0b                	jmp    801b21 <initialize_dyn_block_system+0x12c>
  801b16:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b19:	8b 40 04             	mov    0x4(%eax),%eax
  801b1c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b24:	8b 40 04             	mov    0x4(%eax),%eax
  801b27:	85 c0                	test   %eax,%eax
  801b29:	74 0f                	je     801b3a <initialize_dyn_block_system+0x145>
  801b2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b2e:	8b 40 04             	mov    0x4(%eax),%eax
  801b31:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b34:	8b 12                	mov    (%edx),%edx
  801b36:	89 10                	mov    %edx,(%eax)
  801b38:	eb 0a                	jmp    801b44 <initialize_dyn_block_system+0x14f>
  801b3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b3d:	8b 00                	mov    (%eax),%eax
  801b3f:	a3 48 51 80 00       	mov    %eax,0x805148
  801b44:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b57:	a1 54 51 80 00       	mov    0x805154,%eax
  801b5c:	48                   	dec    %eax
  801b5d:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801b62:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b65:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801b6c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b6f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801b76:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801b7a:	75 14                	jne    801b90 <initialize_dyn_block_system+0x19b>
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	68 94 41 80 00       	push   $0x804194
  801b84:	6a 3e                	push   $0x3e
  801b86:	68 87 41 80 00       	push   $0x804187
  801b8b:	e8 f0 eb ff ff       	call   800780 <_panic>
  801b90:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b96:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b99:	89 10                	mov    %edx,(%eax)
  801b9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b9e:	8b 00                	mov    (%eax),%eax
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	74 0d                	je     801bb1 <initialize_dyn_block_system+0x1bc>
  801ba4:	a1 38 51 80 00       	mov    0x805138,%eax
  801ba9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bac:	89 50 04             	mov    %edx,0x4(%eax)
  801baf:	eb 08                	jmp    801bb9 <initialize_dyn_block_system+0x1c4>
  801bb1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bb4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bbc:	a3 38 51 80 00       	mov    %eax,0x805138
  801bc1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801bcb:	a1 44 51 80 00       	mov    0x805144,%eax
  801bd0:	40                   	inc    %eax
  801bd1:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801bd6:	90                   	nop
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801bdf:	e8 e0 fd ff ff       	call   8019c4 <InitializeUHeap>
		if (size == 0) return NULL ;
  801be4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801be8:	75 07                	jne    801bf1 <malloc+0x18>
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
  801bef:	eb 7f                	jmp    801c70 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801bf1:	e8 d2 08 00 00       	call   8024c8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bf6:	85 c0                	test   %eax,%eax
  801bf8:	74 71                	je     801c6b <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801bfa:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c01:	8b 55 08             	mov    0x8(%ebp),%edx
  801c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c07:	01 d0                	add    %edx,%eax
  801c09:	48                   	dec    %eax
  801c0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c10:	ba 00 00 00 00       	mov    $0x0,%edx
  801c15:	f7 75 f4             	divl   -0xc(%ebp)
  801c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1b:	29 d0                	sub    %edx,%eax
  801c1d:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801c20:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801c27:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801c2e:	76 07                	jbe    801c37 <malloc+0x5e>
					return NULL ;
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
  801c35:	eb 39                	jmp    801c70 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801c37:	83 ec 0c             	sub    $0xc,%esp
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	e8 e6 0d 00 00       	call   802a28 <alloc_block_FF>
  801c42:	83 c4 10             	add    $0x10,%esp
  801c45:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801c48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c4c:	74 16                	je     801c64 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801c4e:	83 ec 0c             	sub    $0xc,%esp
  801c51:	ff 75 ec             	pushl  -0x14(%ebp)
  801c54:	e8 37 0c 00 00       	call   802890 <insert_sorted_allocList>
  801c59:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c5f:	8b 40 08             	mov    0x8(%eax),%eax
  801c62:	eb 0c                	jmp    801c70 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801c64:	b8 00 00 00 00       	mov    $0x0,%eax
  801c69:	eb 05                	jmp    801c70 <malloc+0x97>
				}
		}
	return 0;
  801c6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c70:	c9                   	leave  
  801c71:	c3                   	ret    

00801c72 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801c78:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801c7e:	83 ec 08             	sub    $0x8,%esp
  801c81:	ff 75 f4             	pushl  -0xc(%ebp)
  801c84:	68 40 50 80 00       	push   $0x805040
  801c89:	e8 cf 0b 00 00       	call   80285d <find_block>
  801c8e:	83 c4 10             	add    $0x10,%esp
  801c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c97:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801c9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca0:	8b 40 08             	mov    0x8(%eax),%eax
  801ca3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801ca6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801caa:	0f 84 a1 00 00 00    	je     801d51 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801cb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cb4:	75 17                	jne    801ccd <free+0x5b>
  801cb6:	83 ec 04             	sub    $0x4,%esp
  801cb9:	68 69 41 80 00       	push   $0x804169
  801cbe:	68 80 00 00 00       	push   $0x80
  801cc3:	68 87 41 80 00       	push   $0x804187
  801cc8:	e8 b3 ea ff ff       	call   800780 <_panic>
  801ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd0:	8b 00                	mov    (%eax),%eax
  801cd2:	85 c0                	test   %eax,%eax
  801cd4:	74 10                	je     801ce6 <free+0x74>
  801cd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd9:	8b 00                	mov    (%eax),%eax
  801cdb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cde:	8b 52 04             	mov    0x4(%edx),%edx
  801ce1:	89 50 04             	mov    %edx,0x4(%eax)
  801ce4:	eb 0b                	jmp    801cf1 <free+0x7f>
  801ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce9:	8b 40 04             	mov    0x4(%eax),%eax
  801cec:	a3 44 50 80 00       	mov    %eax,0x805044
  801cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf4:	8b 40 04             	mov    0x4(%eax),%eax
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	74 0f                	je     801d0a <free+0x98>
  801cfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfe:	8b 40 04             	mov    0x4(%eax),%eax
  801d01:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d04:	8b 12                	mov    (%edx),%edx
  801d06:	89 10                	mov    %edx,(%eax)
  801d08:	eb 0a                	jmp    801d14 <free+0xa2>
  801d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0d:	8b 00                	mov    (%eax),%eax
  801d0f:	a3 40 50 80 00       	mov    %eax,0x805040
  801d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d17:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d27:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d2c:	48                   	dec    %eax
  801d2d:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	ff 75 f0             	pushl  -0x10(%ebp)
  801d38:	e8 29 12 00 00       	call   802f66 <insert_sorted_with_merge_freeList>
  801d3d:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801d40:	83 ec 08             	sub    $0x8,%esp
  801d43:	ff 75 ec             	pushl  -0x14(%ebp)
  801d46:	ff 75 e8             	pushl  -0x18(%ebp)
  801d49:	e8 74 03 00 00       	call   8020c2 <sys_free_user_mem>
  801d4e:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801d51:	90                   	nop
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 38             	sub    $0x38,%esp
  801d5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d60:	e8 5f fc ff ff       	call   8019c4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d69:	75 0a                	jne    801d75 <smalloc+0x21>
  801d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d70:	e9 b2 00 00 00       	jmp    801e27 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801d75:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801d7c:	76 0a                	jbe    801d88 <smalloc+0x34>
		return NULL;
  801d7e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d83:	e9 9f 00 00 00       	jmp    801e27 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d88:	e8 3b 07 00 00       	call   8024c8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d8d:	85 c0                	test   %eax,%eax
  801d8f:	0f 84 8d 00 00 00    	je     801e22 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801d95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801d9c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801da9:	01 d0                	add    %edx,%eax
  801dab:	48                   	dec    %eax
  801dac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801daf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db2:	ba 00 00 00 00       	mov    $0x0,%edx
  801db7:	f7 75 f0             	divl   -0x10(%ebp)
  801dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dbd:	29 d0                	sub    %edx,%eax
  801dbf:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801dc2:	83 ec 0c             	sub    $0xc,%esp
  801dc5:	ff 75 e8             	pushl  -0x18(%ebp)
  801dc8:	e8 5b 0c 00 00       	call   802a28 <alloc_block_FF>
  801dcd:	83 c4 10             	add    $0x10,%esp
  801dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801dd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dd7:	75 07                	jne    801de0 <smalloc+0x8c>
			return NULL;
  801dd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dde:	eb 47                	jmp    801e27 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801de0:	83 ec 0c             	sub    $0xc,%esp
  801de3:	ff 75 f4             	pushl  -0xc(%ebp)
  801de6:	e8 a5 0a 00 00       	call   802890 <insert_sorted_allocList>
  801deb:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801df1:	8b 40 08             	mov    0x8(%eax),%eax
  801df4:	89 c2                	mov    %eax,%edx
  801df6:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801dfa:	52                   	push   %edx
  801dfb:	50                   	push   %eax
  801dfc:	ff 75 0c             	pushl  0xc(%ebp)
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	e8 46 04 00 00       	call   80224d <sys_createSharedObject>
  801e07:	83 c4 10             	add    $0x10,%esp
  801e0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801e0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e11:	78 08                	js     801e1b <smalloc+0xc7>
		return (void *)b->sva;
  801e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e16:	8b 40 08             	mov    0x8(%eax),%eax
  801e19:	eb 0c                	jmp    801e27 <smalloc+0xd3>
		}else{
		return NULL;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e20:	eb 05                	jmp    801e27 <smalloc+0xd3>
			}

	}return NULL;
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e2f:	e8 90 fb ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801e34:	e8 8f 06 00 00       	call   8024c8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e39:	85 c0                	test   %eax,%eax
  801e3b:	0f 84 ad 00 00 00    	je     801eee <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e41:	83 ec 08             	sub    $0x8,%esp
  801e44:	ff 75 0c             	pushl  0xc(%ebp)
  801e47:	ff 75 08             	pushl  0x8(%ebp)
  801e4a:	e8 28 04 00 00       	call   802277 <sys_getSizeOfSharedObject>
  801e4f:	83 c4 10             	add    $0x10,%esp
  801e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801e55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e59:	79 0a                	jns    801e65 <sget+0x3c>
    {
    	return NULL;
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e60:	e9 8e 00 00 00       	jmp    801ef3 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801e65:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801e6c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e79:	01 d0                	add    %edx,%eax
  801e7b:	48                   	dec    %eax
  801e7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e82:	ba 00 00 00 00       	mov    $0x0,%edx
  801e87:	f7 75 ec             	divl   -0x14(%ebp)
  801e8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e8d:	29 d0                	sub    %edx,%eax
  801e8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801e92:	83 ec 0c             	sub    $0xc,%esp
  801e95:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e98:	e8 8b 0b 00 00       	call   802a28 <alloc_block_FF>
  801e9d:	83 c4 10             	add    $0x10,%esp
  801ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801ea3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ea7:	75 07                	jne    801eb0 <sget+0x87>
				return NULL;
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	eb 43                	jmp    801ef3 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb6:	e8 d5 09 00 00       	call   802890 <insert_sorted_allocList>
  801ebb:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801ebe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec1:	8b 40 08             	mov    0x8(%eax),%eax
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	50                   	push   %eax
  801ec8:	ff 75 0c             	pushl  0xc(%ebp)
  801ecb:	ff 75 08             	pushl  0x8(%ebp)
  801ece:	e8 c1 03 00 00       	call   802294 <sys_getSharedObject>
  801ed3:	83 c4 10             	add    $0x10,%esp
  801ed6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801ed9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801edd:	78 08                	js     801ee7 <sget+0xbe>
			return (void *)b->sva;
  801edf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee2:	8b 40 08             	mov    0x8(%eax),%eax
  801ee5:	eb 0c                	jmp    801ef3 <sget+0xca>
			}else{
			return NULL;
  801ee7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eec:	eb 05                	jmp    801ef3 <sget+0xca>
			}
    }}return NULL;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
  801ef8:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801efb:	e8 c4 fa ff ff       	call   8019c4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f00:	83 ec 04             	sub    $0x4,%esp
  801f03:	68 b8 41 80 00       	push   $0x8041b8
  801f08:	68 03 01 00 00       	push   $0x103
  801f0d:	68 87 41 80 00       	push   $0x804187
  801f12:	e8 69 e8 ff ff       	call   800780 <_panic>

00801f17 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
  801f1a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f1d:	83 ec 04             	sub    $0x4,%esp
  801f20:	68 e0 41 80 00       	push   $0x8041e0
  801f25:	68 17 01 00 00       	push   $0x117
  801f2a:	68 87 41 80 00       	push   $0x804187
  801f2f:	e8 4c e8 ff ff       	call   800780 <_panic>

00801f34 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f3a:	83 ec 04             	sub    $0x4,%esp
  801f3d:	68 04 42 80 00       	push   $0x804204
  801f42:	68 22 01 00 00       	push   $0x122
  801f47:	68 87 41 80 00       	push   $0x804187
  801f4c:	e8 2f e8 ff ff       	call   800780 <_panic>

00801f51 <shrink>:

}
void shrink(uint32 newSize)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f57:	83 ec 04             	sub    $0x4,%esp
  801f5a:	68 04 42 80 00       	push   $0x804204
  801f5f:	68 27 01 00 00       	push   $0x127
  801f64:	68 87 41 80 00       	push   $0x804187
  801f69:	e8 12 e8 ff ff       	call   800780 <_panic>

00801f6e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f6e:	55                   	push   %ebp
  801f6f:	89 e5                	mov    %esp,%ebp
  801f71:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	68 04 42 80 00       	push   $0x804204
  801f7c:	68 2c 01 00 00       	push   $0x12c
  801f81:	68 87 41 80 00       	push   $0x804187
  801f86:	e8 f5 e7 ff ff       	call   800780 <_panic>

00801f8b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	57                   	push   %edi
  801f8f:	56                   	push   %esi
  801f90:	53                   	push   %ebx
  801f91:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f94:	8b 45 08             	mov    0x8(%ebp),%eax
  801f97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f9d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fa3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fa6:	cd 30                	int    $0x30
  801fa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fae:	83 c4 10             	add    $0x10,%esp
  801fb1:	5b                   	pop    %ebx
  801fb2:	5e                   	pop    %esi
  801fb3:	5f                   	pop    %edi
  801fb4:	5d                   	pop    %ebp
  801fb5:	c3                   	ret    

00801fb6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fb6:	55                   	push   %ebp
  801fb7:	89 e5                	mov    %esp,%ebp
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fc2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	52                   	push   %edx
  801fce:	ff 75 0c             	pushl  0xc(%ebp)
  801fd1:	50                   	push   %eax
  801fd2:	6a 00                	push   $0x0
  801fd4:	e8 b2 ff ff ff       	call   801f8b <syscall>
  801fd9:	83 c4 18             	add    $0x18,%esp
}
  801fdc:	90                   	nop
  801fdd:	c9                   	leave  
  801fde:	c3                   	ret    

00801fdf <sys_cgetc>:

int
sys_cgetc(void)
{
  801fdf:	55                   	push   %ebp
  801fe0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801fe2:	6a 00                	push   $0x0
  801fe4:	6a 00                	push   $0x0
  801fe6:	6a 00                	push   $0x0
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 01                	push   $0x1
  801fee:	e8 98 ff ff ff       	call   801f8b <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
}
  801ff6:	c9                   	leave  
  801ff7:	c3                   	ret    

00801ff8 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801ff8:	55                   	push   %ebp
  801ff9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801ffb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	52                   	push   %edx
  802008:	50                   	push   %eax
  802009:	6a 05                	push   $0x5
  80200b:	e8 7b ff ff ff       	call   801f8b <syscall>
  802010:	83 c4 18             	add    $0x18,%esp
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	56                   	push   %esi
  802019:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80201a:	8b 75 18             	mov    0x18(%ebp),%esi
  80201d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802020:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802023:	8b 55 0c             	mov    0xc(%ebp),%edx
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	56                   	push   %esi
  80202a:	53                   	push   %ebx
  80202b:	51                   	push   %ecx
  80202c:	52                   	push   %edx
  80202d:	50                   	push   %eax
  80202e:	6a 06                	push   $0x6
  802030:	e8 56 ff ff ff       	call   801f8b <syscall>
  802035:	83 c4 18             	add    $0x18,%esp
}
  802038:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80203b:	5b                   	pop    %ebx
  80203c:	5e                   	pop    %esi
  80203d:	5d                   	pop    %ebp
  80203e:	c3                   	ret    

0080203f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80203f:	55                   	push   %ebp
  802040:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802042:	8b 55 0c             	mov    0xc(%ebp),%edx
  802045:	8b 45 08             	mov    0x8(%ebp),%eax
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	52                   	push   %edx
  80204f:	50                   	push   %eax
  802050:	6a 07                	push   $0x7
  802052:	e8 34 ff ff ff       	call   801f8b <syscall>
  802057:	83 c4 18             	add    $0x18,%esp
}
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80205f:	6a 00                	push   $0x0
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	ff 75 0c             	pushl  0xc(%ebp)
  802068:	ff 75 08             	pushl  0x8(%ebp)
  80206b:	6a 08                	push   $0x8
  80206d:	e8 19 ff ff ff       	call   801f8b <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
}
  802075:	c9                   	leave  
  802076:	c3                   	ret    

00802077 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 09                	push   $0x9
  802086:	e8 00 ff ff ff       	call   801f8b <syscall>
  80208b:	83 c4 18             	add    $0x18,%esp
}
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802093:	6a 00                	push   $0x0
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	6a 00                	push   $0x0
  80209d:	6a 0a                	push   $0xa
  80209f:	e8 e7 fe ff ff       	call   801f8b <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 0b                	push   $0xb
  8020b8:	e8 ce fe ff ff       	call   801f8b <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ce:	ff 75 08             	pushl  0x8(%ebp)
  8020d1:	6a 0f                	push   $0xf
  8020d3:	e8 b3 fe ff ff       	call   801f8b <syscall>
  8020d8:	83 c4 18             	add    $0x18,%esp
	return;
  8020db:	90                   	nop
}
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	ff 75 0c             	pushl  0xc(%ebp)
  8020ea:	ff 75 08             	pushl  0x8(%ebp)
  8020ed:	6a 10                	push   $0x10
  8020ef:	e8 97 fe ff ff       	call   801f8b <syscall>
  8020f4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f7:	90                   	nop
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	ff 75 10             	pushl  0x10(%ebp)
  802104:	ff 75 0c             	pushl  0xc(%ebp)
  802107:	ff 75 08             	pushl  0x8(%ebp)
  80210a:	6a 11                	push   $0x11
  80210c:	e8 7a fe ff ff       	call   801f8b <syscall>
  802111:	83 c4 18             	add    $0x18,%esp
	return ;
  802114:	90                   	nop
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 0c                	push   $0xc
  802126:	e8 60 fe ff ff       	call   801f8b <syscall>
  80212b:	83 c4 18             	add    $0x18,%esp
}
  80212e:	c9                   	leave  
  80212f:	c3                   	ret    

00802130 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	ff 75 08             	pushl  0x8(%ebp)
  80213e:	6a 0d                	push   $0xd
  802140:	e8 46 fe ff ff       	call   801f8b <syscall>
  802145:	83 c4 18             	add    $0x18,%esp
}
  802148:	c9                   	leave  
  802149:	c3                   	ret    

0080214a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80214a:	55                   	push   %ebp
  80214b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 0e                	push   $0xe
  802159:	e8 2d fe ff ff       	call   801f8b <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	90                   	nop
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 13                	push   $0x13
  802173:	e8 13 fe ff ff       	call   801f8b <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 14                	push   $0x14
  80218d:	e8 f9 fd ff ff       	call   801f8b <syscall>
  802192:	83 c4 18             	add    $0x18,%esp
}
  802195:	90                   	nop
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <sys_cputc>:


void
sys_cputc(const char c)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 04             	sub    $0x4,%esp
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021a4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021a8:	6a 00                	push   $0x0
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	50                   	push   %eax
  8021b1:	6a 15                	push   $0x15
  8021b3:	e8 d3 fd ff ff       	call   801f8b <syscall>
  8021b8:	83 c4 18             	add    $0x18,%esp
}
  8021bb:	90                   	nop
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 16                	push   $0x16
  8021cd:	e8 b9 fd ff ff       	call   801f8b <syscall>
  8021d2:	83 c4 18             	add    $0x18,%esp
}
  8021d5:	90                   	nop
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	ff 75 0c             	pushl  0xc(%ebp)
  8021e7:	50                   	push   %eax
  8021e8:	6a 17                	push   $0x17
  8021ea:	e8 9c fd ff ff       	call   801f8b <syscall>
  8021ef:	83 c4 18             	add    $0x18,%esp
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	52                   	push   %edx
  802204:	50                   	push   %eax
  802205:	6a 1a                	push   $0x1a
  802207:	e8 7f fd ff ff       	call   801f8b <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802214:	8b 55 0c             	mov    0xc(%ebp),%edx
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	52                   	push   %edx
  802221:	50                   	push   %eax
  802222:	6a 18                	push   $0x18
  802224:	e8 62 fd ff ff       	call   801f8b <syscall>
  802229:	83 c4 18             	add    $0x18,%esp
}
  80222c:	90                   	nop
  80222d:	c9                   	leave  
  80222e:	c3                   	ret    

0080222f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802232:	8b 55 0c             	mov    0xc(%ebp),%edx
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	52                   	push   %edx
  80223f:	50                   	push   %eax
  802240:	6a 19                	push   $0x19
  802242:	e8 44 fd ff ff       	call   801f8b <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
}
  80224a:	90                   	nop
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
  802250:	83 ec 04             	sub    $0x4,%esp
  802253:	8b 45 10             	mov    0x10(%ebp),%eax
  802256:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802259:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80225c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	6a 00                	push   $0x0
  802265:	51                   	push   %ecx
  802266:	52                   	push   %edx
  802267:	ff 75 0c             	pushl  0xc(%ebp)
  80226a:	50                   	push   %eax
  80226b:	6a 1b                	push   $0x1b
  80226d:	e8 19 fd ff ff       	call   801f8b <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80227a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 00                	push   $0x0
  802286:	52                   	push   %edx
  802287:	50                   	push   %eax
  802288:	6a 1c                	push   $0x1c
  80228a:	e8 fc fc ff ff       	call   801f8b <syscall>
  80228f:	83 c4 18             	add    $0x18,%esp
}
  802292:	c9                   	leave  
  802293:	c3                   	ret    

00802294 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802294:	55                   	push   %ebp
  802295:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802297:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80229a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	51                   	push   %ecx
  8022a5:	52                   	push   %edx
  8022a6:	50                   	push   %eax
  8022a7:	6a 1d                	push   $0x1d
  8022a9:	e8 dd fc ff ff       	call   801f8b <syscall>
  8022ae:	83 c4 18             	add    $0x18,%esp
}
  8022b1:	c9                   	leave  
  8022b2:	c3                   	ret    

008022b3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022b3:	55                   	push   %ebp
  8022b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	52                   	push   %edx
  8022c3:	50                   	push   %eax
  8022c4:	6a 1e                	push   $0x1e
  8022c6:	e8 c0 fc ff ff       	call   801f8b <syscall>
  8022cb:	83 c4 18             	add    $0x18,%esp
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	6a 00                	push   $0x0
  8022d9:	6a 00                	push   $0x0
  8022db:	6a 00                	push   $0x0
  8022dd:	6a 1f                	push   $0x1f
  8022df:	e8 a7 fc ff ff       	call   801f8b <syscall>
  8022e4:	83 c4 18             	add    $0x18,%esp
}
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ef:	6a 00                	push   $0x0
  8022f1:	ff 75 14             	pushl  0x14(%ebp)
  8022f4:	ff 75 10             	pushl  0x10(%ebp)
  8022f7:	ff 75 0c             	pushl  0xc(%ebp)
  8022fa:	50                   	push   %eax
  8022fb:	6a 20                	push   $0x20
  8022fd:	e8 89 fc ff ff       	call   801f8b <syscall>
  802302:	83 c4 18             	add    $0x18,%esp
}
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	6a 00                	push   $0x0
  80230f:	6a 00                	push   $0x0
  802311:	6a 00                	push   $0x0
  802313:	6a 00                	push   $0x0
  802315:	50                   	push   %eax
  802316:	6a 21                	push   $0x21
  802318:	e8 6e fc ff ff       	call   801f8b <syscall>
  80231d:	83 c4 18             	add    $0x18,%esp
}
  802320:	90                   	nop
  802321:	c9                   	leave  
  802322:	c3                   	ret    

00802323 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802323:	55                   	push   %ebp
  802324:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	50                   	push   %eax
  802332:	6a 22                	push   $0x22
  802334:	e8 52 fc ff ff       	call   801f8b <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	c9                   	leave  
  80233d:	c3                   	ret    

0080233e <sys_getenvid>:

int32 sys_getenvid(void)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802341:	6a 00                	push   $0x0
  802343:	6a 00                	push   $0x0
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 02                	push   $0x2
  80234d:	e8 39 fc ff ff       	call   801f8b <syscall>
  802352:	83 c4 18             	add    $0x18,%esp
}
  802355:	c9                   	leave  
  802356:	c3                   	ret    

00802357 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802357:	55                   	push   %ebp
  802358:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	6a 00                	push   $0x0
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 03                	push   $0x3
  802366:	e8 20 fc ff ff       	call   801f8b <syscall>
  80236b:	83 c4 18             	add    $0x18,%esp
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 00                	push   $0x0
  80237b:	6a 00                	push   $0x0
  80237d:	6a 04                	push   $0x4
  80237f:	e8 07 fc ff ff       	call   801f8b <syscall>
  802384:	83 c4 18             	add    $0x18,%esp
}
  802387:	c9                   	leave  
  802388:	c3                   	ret    

00802389 <sys_exit_env>:


void sys_exit_env(void)
{
  802389:	55                   	push   %ebp
  80238a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	6a 00                	push   $0x0
  802396:	6a 23                	push   $0x23
  802398:	e8 ee fb ff ff       	call   801f8b <syscall>
  80239d:	83 c4 18             	add    $0x18,%esp
}
  8023a0:	90                   	nop
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023a9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023ac:	8d 50 04             	lea    0x4(%eax),%edx
  8023af:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023b2:	6a 00                	push   $0x0
  8023b4:	6a 00                	push   $0x0
  8023b6:	6a 00                	push   $0x0
  8023b8:	52                   	push   %edx
  8023b9:	50                   	push   %eax
  8023ba:	6a 24                	push   $0x24
  8023bc:	e8 ca fb ff ff       	call   801f8b <syscall>
  8023c1:	83 c4 18             	add    $0x18,%esp
	return result;
  8023c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023cd:	89 01                	mov    %eax,(%ecx)
  8023cf:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	c9                   	leave  
  8023d6:	c2 04 00             	ret    $0x4

008023d9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023d9:	55                   	push   %ebp
  8023da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	ff 75 10             	pushl  0x10(%ebp)
  8023e3:	ff 75 0c             	pushl  0xc(%ebp)
  8023e6:	ff 75 08             	pushl  0x8(%ebp)
  8023e9:	6a 12                	push   $0x12
  8023eb:	e8 9b fb ff ff       	call   801f8b <syscall>
  8023f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f3:	90                   	nop
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <sys_rcr2>:
uint32 sys_rcr2()
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 00                	push   $0x0
  802401:	6a 00                	push   $0x0
  802403:	6a 25                	push   $0x25
  802405:	e8 81 fb ff ff       	call   801f8b <syscall>
  80240a:	83 c4 18             	add    $0x18,%esp
}
  80240d:	c9                   	leave  
  80240e:	c3                   	ret    

0080240f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80240f:	55                   	push   %ebp
  802410:	89 e5                	mov    %esp,%ebp
  802412:	83 ec 04             	sub    $0x4,%esp
  802415:	8b 45 08             	mov    0x8(%ebp),%eax
  802418:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80241b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	50                   	push   %eax
  802428:	6a 26                	push   $0x26
  80242a:	e8 5c fb ff ff       	call   801f8b <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
	return ;
  802432:	90                   	nop
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <rsttst>:
void rsttst()
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 28                	push   $0x28
  802444:	e8 42 fb ff ff       	call   801f8b <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
	return ;
  80244c:	90                   	nop
}
  80244d:	c9                   	leave  
  80244e:	c3                   	ret    

0080244f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80244f:	55                   	push   %ebp
  802450:	89 e5                	mov    %esp,%ebp
  802452:	83 ec 04             	sub    $0x4,%esp
  802455:	8b 45 14             	mov    0x14(%ebp),%eax
  802458:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80245b:	8b 55 18             	mov    0x18(%ebp),%edx
  80245e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802462:	52                   	push   %edx
  802463:	50                   	push   %eax
  802464:	ff 75 10             	pushl  0x10(%ebp)
  802467:	ff 75 0c             	pushl  0xc(%ebp)
  80246a:	ff 75 08             	pushl  0x8(%ebp)
  80246d:	6a 27                	push   $0x27
  80246f:	e8 17 fb ff ff       	call   801f8b <syscall>
  802474:	83 c4 18             	add    $0x18,%esp
	return ;
  802477:	90                   	nop
}
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <chktst>:
void chktst(uint32 n)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	ff 75 08             	pushl  0x8(%ebp)
  802488:	6a 29                	push   $0x29
  80248a:	e8 fc fa ff ff       	call   801f8b <syscall>
  80248f:	83 c4 18             	add    $0x18,%esp
	return ;
  802492:	90                   	nop
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <inctst>:

void inctst()
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 2a                	push   $0x2a
  8024a4:	e8 e2 fa ff ff       	call   801f8b <syscall>
  8024a9:	83 c4 18             	add    $0x18,%esp
	return ;
  8024ac:	90                   	nop
}
  8024ad:	c9                   	leave  
  8024ae:	c3                   	ret    

008024af <gettst>:
uint32 gettst()
{
  8024af:	55                   	push   %ebp
  8024b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 2b                	push   $0x2b
  8024be:	e8 c8 fa ff ff       	call   801f8b <syscall>
  8024c3:	83 c4 18             	add    $0x18,%esp
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 2c                	push   $0x2c
  8024da:	e8 ac fa ff ff       	call   801f8b <syscall>
  8024df:	83 c4 18             	add    $0x18,%esp
  8024e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024e5:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024e9:	75 07                	jne    8024f2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f0:	eb 05                	jmp    8024f7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
  8024fc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024ff:	6a 00                	push   $0x0
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	6a 2c                	push   $0x2c
  80250b:	e8 7b fa ff ff       	call   801f8b <syscall>
  802510:	83 c4 18             	add    $0x18,%esp
  802513:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802516:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80251a:	75 07                	jne    802523 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80251c:	b8 01 00 00 00       	mov    $0x1,%eax
  802521:	eb 05                	jmp    802528 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802523:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    

0080252a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80252a:	55                   	push   %ebp
  80252b:	89 e5                	mov    %esp,%ebp
  80252d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802530:	6a 00                	push   $0x0
  802532:	6a 00                	push   $0x0
  802534:	6a 00                	push   $0x0
  802536:	6a 00                	push   $0x0
  802538:	6a 00                	push   $0x0
  80253a:	6a 2c                	push   $0x2c
  80253c:	e8 4a fa ff ff       	call   801f8b <syscall>
  802541:	83 c4 18             	add    $0x18,%esp
  802544:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802547:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80254b:	75 07                	jne    802554 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80254d:	b8 01 00 00 00       	mov    $0x1,%eax
  802552:	eb 05                	jmp    802559 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802554:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802559:	c9                   	leave  
  80255a:	c3                   	ret    

0080255b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80255b:	55                   	push   %ebp
  80255c:	89 e5                	mov    %esp,%ebp
  80255e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 2c                	push   $0x2c
  80256d:	e8 19 fa ff ff       	call   801f8b <syscall>
  802572:	83 c4 18             	add    $0x18,%esp
  802575:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802578:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80257c:	75 07                	jne    802585 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80257e:	b8 01 00 00 00       	mov    $0x1,%eax
  802583:	eb 05                	jmp    80258a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802585:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	ff 75 08             	pushl  0x8(%ebp)
  80259a:	6a 2d                	push   $0x2d
  80259c:	e8 ea f9 ff ff       	call   801f8b <syscall>
  8025a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a4:	90                   	nop
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
  8025aa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	6a 00                	push   $0x0
  8025b9:	53                   	push   %ebx
  8025ba:	51                   	push   %ecx
  8025bb:	52                   	push   %edx
  8025bc:	50                   	push   %eax
  8025bd:	6a 2e                	push   $0x2e
  8025bf:	e8 c7 f9 ff ff       	call   801f8b <syscall>
  8025c4:	83 c4 18             	add    $0x18,%esp
}
  8025c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	52                   	push   %edx
  8025dc:	50                   	push   %eax
  8025dd:	6a 2f                	push   $0x2f
  8025df:	e8 a7 f9 ff ff       	call   801f8b <syscall>
  8025e4:	83 c4 18             	add    $0x18,%esp
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8025ef:	83 ec 0c             	sub    $0xc,%esp
  8025f2:	68 14 42 80 00       	push   $0x804214
  8025f7:	e8 38 e4 ff ff       	call   800a34 <cprintf>
  8025fc:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8025ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802606:	83 ec 0c             	sub    $0xc,%esp
  802609:	68 40 42 80 00       	push   $0x804240
  80260e:	e8 21 e4 ff ff       	call   800a34 <cprintf>
  802613:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802616:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80261a:	a1 38 51 80 00       	mov    0x805138,%eax
  80261f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802622:	eb 56                	jmp    80267a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802624:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802628:	74 1c                	je     802646 <print_mem_block_lists+0x5d>
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 50 08             	mov    0x8(%eax),%edx
  802630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802633:	8b 48 08             	mov    0x8(%eax),%ecx
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	8b 40 0c             	mov    0xc(%eax),%eax
  80263c:	01 c8                	add    %ecx,%eax
  80263e:	39 c2                	cmp    %eax,%edx
  802640:	73 04                	jae    802646 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802642:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802649:	8b 50 08             	mov    0x8(%eax),%edx
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 0c             	mov    0xc(%eax),%eax
  802652:	01 c2                	add    %eax,%edx
  802654:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802657:	8b 40 08             	mov    0x8(%eax),%eax
  80265a:	83 ec 04             	sub    $0x4,%esp
  80265d:	52                   	push   %edx
  80265e:	50                   	push   %eax
  80265f:	68 55 42 80 00       	push   $0x804255
  802664:	e8 cb e3 ff ff       	call   800a34 <cprintf>
  802669:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802672:	a1 40 51 80 00       	mov    0x805140,%eax
  802677:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267e:	74 07                	je     802687 <print_mem_block_lists+0x9e>
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 00                	mov    (%eax),%eax
  802685:	eb 05                	jmp    80268c <print_mem_block_lists+0xa3>
  802687:	b8 00 00 00 00       	mov    $0x0,%eax
  80268c:	a3 40 51 80 00       	mov    %eax,0x805140
  802691:	a1 40 51 80 00       	mov    0x805140,%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	75 8a                	jne    802624 <print_mem_block_lists+0x3b>
  80269a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269e:	75 84                	jne    802624 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8026a0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026a4:	75 10                	jne    8026b6 <print_mem_block_lists+0xcd>
  8026a6:	83 ec 0c             	sub    $0xc,%esp
  8026a9:	68 64 42 80 00       	push   $0x804264
  8026ae:	e8 81 e3 ff ff       	call   800a34 <cprintf>
  8026b3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8026b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8026bd:	83 ec 0c             	sub    $0xc,%esp
  8026c0:	68 88 42 80 00       	push   $0x804288
  8026c5:	e8 6a e3 ff ff       	call   800a34 <cprintf>
  8026ca:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8026cd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026d1:	a1 40 50 80 00       	mov    0x805040,%eax
  8026d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d9:	eb 56                	jmp    802731 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026df:	74 1c                	je     8026fd <print_mem_block_lists+0x114>
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	8b 50 08             	mov    0x8(%eax),%edx
  8026e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ea:	8b 48 08             	mov    0x8(%eax),%ecx
  8026ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026f3:	01 c8                	add    %ecx,%eax
  8026f5:	39 c2                	cmp    %eax,%edx
  8026f7:	73 04                	jae    8026fd <print_mem_block_lists+0x114>
			sorted = 0 ;
  8026f9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802700:	8b 50 08             	mov    0x8(%eax),%edx
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 40 0c             	mov    0xc(%eax),%eax
  802709:	01 c2                	add    %eax,%edx
  80270b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270e:	8b 40 08             	mov    0x8(%eax),%eax
  802711:	83 ec 04             	sub    $0x4,%esp
  802714:	52                   	push   %edx
  802715:	50                   	push   %eax
  802716:	68 55 42 80 00       	push   $0x804255
  80271b:	e8 14 e3 ff ff       	call   800a34 <cprintf>
  802720:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802729:	a1 48 50 80 00       	mov    0x805048,%eax
  80272e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802735:	74 07                	je     80273e <print_mem_block_lists+0x155>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 00                	mov    (%eax),%eax
  80273c:	eb 05                	jmp    802743 <print_mem_block_lists+0x15a>
  80273e:	b8 00 00 00 00       	mov    $0x0,%eax
  802743:	a3 48 50 80 00       	mov    %eax,0x805048
  802748:	a1 48 50 80 00       	mov    0x805048,%eax
  80274d:	85 c0                	test   %eax,%eax
  80274f:	75 8a                	jne    8026db <print_mem_block_lists+0xf2>
  802751:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802755:	75 84                	jne    8026db <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802757:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80275b:	75 10                	jne    80276d <print_mem_block_lists+0x184>
  80275d:	83 ec 0c             	sub    $0xc,%esp
  802760:	68 a0 42 80 00       	push   $0x8042a0
  802765:	e8 ca e2 ff ff       	call   800a34 <cprintf>
  80276a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80276d:	83 ec 0c             	sub    $0xc,%esp
  802770:	68 14 42 80 00       	push   $0x804214
  802775:	e8 ba e2 ff ff       	call   800a34 <cprintf>
  80277a:	83 c4 10             	add    $0x10,%esp

}
  80277d:	90                   	nop
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802786:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80278d:	00 00 00 
  802790:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802797:	00 00 00 
  80279a:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8027a1:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8027a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027ab:	e9 9e 00 00 00       	jmp    80284e <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8027b0:	a1 50 50 80 00       	mov    0x805050,%eax
  8027b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b8:	c1 e2 04             	shl    $0x4,%edx
  8027bb:	01 d0                	add    %edx,%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	75 14                	jne    8027d5 <initialize_MemBlocksList+0x55>
  8027c1:	83 ec 04             	sub    $0x4,%esp
  8027c4:	68 c8 42 80 00       	push   $0x8042c8
  8027c9:	6a 3d                	push   $0x3d
  8027cb:	68 eb 42 80 00       	push   $0x8042eb
  8027d0:	e8 ab df ff ff       	call   800780 <_panic>
  8027d5:	a1 50 50 80 00       	mov    0x805050,%eax
  8027da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027dd:	c1 e2 04             	shl    $0x4,%edx
  8027e0:	01 d0                	add    %edx,%eax
  8027e2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8027e8:	89 10                	mov    %edx,(%eax)
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	74 18                	je     802808 <initialize_MemBlocksList+0x88>
  8027f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8027f5:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8027fb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8027fe:	c1 e1 04             	shl    $0x4,%ecx
  802801:	01 ca                	add    %ecx,%edx
  802803:	89 50 04             	mov    %edx,0x4(%eax)
  802806:	eb 12                	jmp    80281a <initialize_MemBlocksList+0x9a>
  802808:	a1 50 50 80 00       	mov    0x805050,%eax
  80280d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802810:	c1 e2 04             	shl    $0x4,%edx
  802813:	01 d0                	add    %edx,%eax
  802815:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80281a:	a1 50 50 80 00       	mov    0x805050,%eax
  80281f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802822:	c1 e2 04             	shl    $0x4,%edx
  802825:	01 d0                	add    %edx,%eax
  802827:	a3 48 51 80 00       	mov    %eax,0x805148
  80282c:	a1 50 50 80 00       	mov    0x805050,%eax
  802831:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802834:	c1 e2 04             	shl    $0x4,%edx
  802837:	01 d0                	add    %edx,%eax
  802839:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802840:	a1 54 51 80 00       	mov    0x805154,%eax
  802845:	40                   	inc    %eax
  802846:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80284b:	ff 45 f4             	incl   -0xc(%ebp)
  80284e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802851:	3b 45 08             	cmp    0x8(%ebp),%eax
  802854:	0f 82 56 ff ff ff    	jb     8027b0 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80285a:	90                   	nop
  80285b:	c9                   	leave  
  80285c:	c3                   	ret    

0080285d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80285d:	55                   	push   %ebp
  80285e:	89 e5                	mov    %esp,%ebp
  802860:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	8b 00                	mov    (%eax),%eax
  802868:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80286b:	eb 18                	jmp    802885 <find_block+0x28>

		if(tmp->sva == va){
  80286d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802870:	8b 40 08             	mov    0x8(%eax),%eax
  802873:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802876:	75 05                	jne    80287d <find_block+0x20>
			return tmp ;
  802878:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80287b:	eb 11                	jmp    80288e <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  80287d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802880:	8b 00                	mov    (%eax),%eax
  802882:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802885:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802889:	75 e2                	jne    80286d <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80288b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80288e:	c9                   	leave  
  80288f:	c3                   	ret    

00802890 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802896:	a1 40 50 80 00       	mov    0x805040,%eax
  80289b:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  80289e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8028a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028aa:	75 65                	jne    802911 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8028ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b0:	75 14                	jne    8028c6 <insert_sorted_allocList+0x36>
  8028b2:	83 ec 04             	sub    $0x4,%esp
  8028b5:	68 c8 42 80 00       	push   $0x8042c8
  8028ba:	6a 62                	push   $0x62
  8028bc:	68 eb 42 80 00       	push   $0x8042eb
  8028c1:	e8 ba de ff ff       	call   800780 <_panic>
  8028c6:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cf:	89 10                	mov    %edx,(%eax)
  8028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d4:	8b 00                	mov    (%eax),%eax
  8028d6:	85 c0                	test   %eax,%eax
  8028d8:	74 0d                	je     8028e7 <insert_sorted_allocList+0x57>
  8028da:	a1 40 50 80 00       	mov    0x805040,%eax
  8028df:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e2:	89 50 04             	mov    %edx,0x4(%eax)
  8028e5:	eb 08                	jmp    8028ef <insert_sorted_allocList+0x5f>
  8028e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ea:	a3 44 50 80 00       	mov    %eax,0x805044
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	a3 40 50 80 00       	mov    %eax,0x805040
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802901:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802906:	40                   	inc    %eax
  802907:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80290c:	e9 14 01 00 00       	jmp    802a25 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802911:	8b 45 08             	mov    0x8(%ebp),%eax
  802914:	8b 50 08             	mov    0x8(%eax),%edx
  802917:	a1 44 50 80 00       	mov    0x805044,%eax
  80291c:	8b 40 08             	mov    0x8(%eax),%eax
  80291f:	39 c2                	cmp    %eax,%edx
  802921:	76 65                	jbe    802988 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802923:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802927:	75 14                	jne    80293d <insert_sorted_allocList+0xad>
  802929:	83 ec 04             	sub    $0x4,%esp
  80292c:	68 04 43 80 00       	push   $0x804304
  802931:	6a 64                	push   $0x64
  802933:	68 eb 42 80 00       	push   $0x8042eb
  802938:	e8 43 de ff ff       	call   800780 <_panic>
  80293d:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	89 50 04             	mov    %edx,0x4(%eax)
  802949:	8b 45 08             	mov    0x8(%ebp),%eax
  80294c:	8b 40 04             	mov    0x4(%eax),%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	74 0c                	je     80295f <insert_sorted_allocList+0xcf>
  802953:	a1 44 50 80 00       	mov    0x805044,%eax
  802958:	8b 55 08             	mov    0x8(%ebp),%edx
  80295b:	89 10                	mov    %edx,(%eax)
  80295d:	eb 08                	jmp    802967 <insert_sorted_allocList+0xd7>
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	a3 40 50 80 00       	mov    %eax,0x805040
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	a3 44 50 80 00       	mov    %eax,0x805044
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802978:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80297d:	40                   	inc    %eax
  80297e:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802983:	e9 9d 00 00 00       	jmp    802a25 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802988:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80298f:	e9 85 00 00 00       	jmp    802a19 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	8b 50 08             	mov    0x8(%eax),%edx
  80299a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299d:	8b 40 08             	mov    0x8(%eax),%eax
  8029a0:	39 c2                	cmp    %eax,%edx
  8029a2:	73 6a                	jae    802a0e <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8029a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a8:	74 06                	je     8029b0 <insert_sorted_allocList+0x120>
  8029aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ae:	75 14                	jne    8029c4 <insert_sorted_allocList+0x134>
  8029b0:	83 ec 04             	sub    $0x4,%esp
  8029b3:	68 28 43 80 00       	push   $0x804328
  8029b8:	6a 6b                	push   $0x6b
  8029ba:	68 eb 42 80 00       	push   $0x8042eb
  8029bf:	e8 bc dd ff ff       	call   800780 <_panic>
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 50 04             	mov    0x4(%eax),%edx
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	89 50 04             	mov    %edx,0x4(%eax)
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d6:	89 10                	mov    %edx,(%eax)
  8029d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029db:	8b 40 04             	mov    0x4(%eax),%eax
  8029de:	85 c0                	test   %eax,%eax
  8029e0:	74 0d                	je     8029ef <insert_sorted_allocList+0x15f>
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 40 04             	mov    0x4(%eax),%eax
  8029e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029eb:	89 10                	mov    %edx,(%eax)
  8029ed:	eb 08                	jmp    8029f7 <insert_sorted_allocList+0x167>
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	a3 40 50 80 00       	mov    %eax,0x805040
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fd:	89 50 04             	mov    %edx,0x4(%eax)
  802a00:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a05:	40                   	inc    %eax
  802a06:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802a0b:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802a0c:	eb 17                	jmp    802a25 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802a16:	ff 45 f0             	incl   -0x10(%ebp)
  802a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a1f:	0f 8c 6f ff ff ff    	jl     802994 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802a25:	90                   	nop
  802a26:	c9                   	leave  
  802a27:	c3                   	ret    

00802a28 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a28:	55                   	push   %ebp
  802a29:	89 e5                	mov    %esp,%ebp
  802a2b:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802a2e:	a1 38 51 80 00       	mov    0x805138,%eax
  802a33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802a36:	e9 7c 01 00 00       	jmp    802bb7 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a44:	0f 86 cf 00 00 00    	jbe    802b19 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802a4a:	a1 48 51 80 00       	mov    0x805148,%eax
  802a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a55:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802a58:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5e:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 50 08             	mov    0x8(%eax),%edx
  802a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6a:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 40 0c             	mov    0xc(%eax),%eax
  802a73:	2b 45 08             	sub    0x8(%ebp),%eax
  802a76:	89 c2                	mov    %eax,%edx
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 50 08             	mov    0x8(%eax),%edx
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	01 c2                	add    %eax,%edx
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802a8f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a93:	75 17                	jne    802aac <alloc_block_FF+0x84>
  802a95:	83 ec 04             	sub    $0x4,%esp
  802a98:	68 5d 43 80 00       	push   $0x80435d
  802a9d:	68 83 00 00 00       	push   $0x83
  802aa2:	68 eb 42 80 00       	push   $0x8042eb
  802aa7:	e8 d4 dc ff ff       	call   800780 <_panic>
  802aac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aaf:	8b 00                	mov    (%eax),%eax
  802ab1:	85 c0                	test   %eax,%eax
  802ab3:	74 10                	je     802ac5 <alloc_block_FF+0x9d>
  802ab5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802abd:	8b 52 04             	mov    0x4(%edx),%edx
  802ac0:	89 50 04             	mov    %edx,0x4(%eax)
  802ac3:	eb 0b                	jmp    802ad0 <alloc_block_FF+0xa8>
  802ac5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac8:	8b 40 04             	mov    0x4(%eax),%eax
  802acb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ad0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad3:	8b 40 04             	mov    0x4(%eax),%eax
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	74 0f                	je     802ae9 <alloc_block_FF+0xc1>
  802ada:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ae3:	8b 12                	mov    (%edx),%edx
  802ae5:	89 10                	mov    %edx,(%eax)
  802ae7:	eb 0a                	jmp    802af3 <alloc_block_FF+0xcb>
  802ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aec:	8b 00                	mov    (%eax),%eax
  802aee:	a3 48 51 80 00       	mov    %eax,0x805148
  802af3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802afc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b06:	a1 54 51 80 00       	mov    0x805154,%eax
  802b0b:	48                   	dec    %eax
  802b0c:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b14:	e9 ad 00 00 00       	jmp    802bc6 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b22:	0f 85 87 00 00 00    	jne    802baf <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802b28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b2c:	75 17                	jne    802b45 <alloc_block_FF+0x11d>
  802b2e:	83 ec 04             	sub    $0x4,%esp
  802b31:	68 5d 43 80 00       	push   $0x80435d
  802b36:	68 87 00 00 00       	push   $0x87
  802b3b:	68 eb 42 80 00       	push   $0x8042eb
  802b40:	e8 3b dc ff ff       	call   800780 <_panic>
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	74 10                	je     802b5e <alloc_block_FF+0x136>
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b56:	8b 52 04             	mov    0x4(%edx),%edx
  802b59:	89 50 04             	mov    %edx,0x4(%eax)
  802b5c:	eb 0b                	jmp    802b69 <alloc_block_FF+0x141>
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 40 04             	mov    0x4(%eax),%eax
  802b64:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6c:	8b 40 04             	mov    0x4(%eax),%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	74 0f                	je     802b82 <alloc_block_FF+0x15a>
  802b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b76:	8b 40 04             	mov    0x4(%eax),%eax
  802b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b7c:	8b 12                	mov    (%edx),%edx
  802b7e:	89 10                	mov    %edx,(%eax)
  802b80:	eb 0a                	jmp    802b8c <alloc_block_FF+0x164>
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	a3 38 51 80 00       	mov    %eax,0x805138
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b9f:	a1 44 51 80 00       	mov    0x805144,%eax
  802ba4:	48                   	dec    %eax
  802ba5:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	eb 17                	jmp    802bc6 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 00                	mov    (%eax),%eax
  802bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802bb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bbb:	0f 85 7a fe ff ff    	jne    802a3b <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bc6:	c9                   	leave  
  802bc7:	c3                   	ret    

00802bc8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bc8:	55                   	push   %ebp
  802bc9:	89 e5                	mov    %esp,%ebp
  802bcb:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802bce:	a1 38 51 80 00       	mov    0x805138,%eax
  802bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802bd6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802bdd:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802be4:	a1 38 51 80 00       	mov    0x805138,%eax
  802be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bec:	e9 d0 00 00 00       	jmp    802cc1 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf7:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bfa:	0f 82 b8 00 00 00    	jb     802cb8 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 0c             	mov    0xc(%eax),%eax
  802c06:	2b 45 08             	sub    0x8(%ebp),%eax
  802c09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802c0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c12:	0f 83 a1 00 00 00    	jae    802cb9 <alloc_block_BF+0xf1>
				differsize = differance ;
  802c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c21:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802c24:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c28:	0f 85 8b 00 00 00    	jne    802cb9 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c32:	75 17                	jne    802c4b <alloc_block_BF+0x83>
  802c34:	83 ec 04             	sub    $0x4,%esp
  802c37:	68 5d 43 80 00       	push   $0x80435d
  802c3c:	68 a0 00 00 00       	push   $0xa0
  802c41:	68 eb 42 80 00       	push   $0x8042eb
  802c46:	e8 35 db ff ff       	call   800780 <_panic>
  802c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4e:	8b 00                	mov    (%eax),%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	74 10                	je     802c64 <alloc_block_BF+0x9c>
  802c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c57:	8b 00                	mov    (%eax),%eax
  802c59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c5c:	8b 52 04             	mov    0x4(%edx),%edx
  802c5f:	89 50 04             	mov    %edx,0x4(%eax)
  802c62:	eb 0b                	jmp    802c6f <alloc_block_BF+0xa7>
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 40 04             	mov    0x4(%eax),%eax
  802c6a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 40 04             	mov    0x4(%eax),%eax
  802c75:	85 c0                	test   %eax,%eax
  802c77:	74 0f                	je     802c88 <alloc_block_BF+0xc0>
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 40 04             	mov    0x4(%eax),%eax
  802c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c82:	8b 12                	mov    (%edx),%edx
  802c84:	89 10                	mov    %edx,(%eax)
  802c86:	eb 0a                	jmp    802c92 <alloc_block_BF+0xca>
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	8b 00                	mov    (%eax),%eax
  802c8d:	a3 38 51 80 00       	mov    %eax,0x805138
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca5:	a1 44 51 80 00       	mov    0x805144,%eax
  802caa:	48                   	dec    %eax
  802cab:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	e9 0c 01 00 00       	jmp    802dc4 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802cb8:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802cb9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc5:	74 07                	je     802cce <alloc_block_BF+0x106>
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	8b 00                	mov    (%eax),%eax
  802ccc:	eb 05                	jmp    802cd3 <alloc_block_BF+0x10b>
  802cce:	b8 00 00 00 00       	mov    $0x0,%eax
  802cd3:	a3 40 51 80 00       	mov    %eax,0x805140
  802cd8:	a1 40 51 80 00       	mov    0x805140,%eax
  802cdd:	85 c0                	test   %eax,%eax
  802cdf:	0f 85 0c ff ff ff    	jne    802bf1 <alloc_block_BF+0x29>
  802ce5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ce9:	0f 85 02 ff ff ff    	jne    802bf1 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802cef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802cf3:	0f 84 c6 00 00 00    	je     802dbf <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802cf9:	a1 48 51 80 00       	mov    0x805148,%eax
  802cfe:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802d01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d04:	8b 55 08             	mov    0x8(%ebp),%edx
  802d07:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802d0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d0d:	8b 50 08             	mov    0x8(%eax),%edx
  802d10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d13:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d19:	8b 40 0c             	mov    0xc(%eax),%eax
  802d1c:	2b 45 08             	sub    0x8(%ebp),%eax
  802d1f:	89 c2                	mov    %eax,%edx
  802d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d24:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	8b 50 08             	mov    0x8(%eax),%edx
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	01 c2                	add    %eax,%edx
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d35:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802d38:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d3c:	75 17                	jne    802d55 <alloc_block_BF+0x18d>
  802d3e:	83 ec 04             	sub    $0x4,%esp
  802d41:	68 5d 43 80 00       	push   $0x80435d
  802d46:	68 af 00 00 00       	push   $0xaf
  802d4b:	68 eb 42 80 00       	push   $0x8042eb
  802d50:	e8 2b da ff ff       	call   800780 <_panic>
  802d55:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d58:	8b 00                	mov    (%eax),%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 10                	je     802d6e <alloc_block_BF+0x1a6>
  802d5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d66:	8b 52 04             	mov    0x4(%edx),%edx
  802d69:	89 50 04             	mov    %edx,0x4(%eax)
  802d6c:	eb 0b                	jmp    802d79 <alloc_block_BF+0x1b1>
  802d6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d71:	8b 40 04             	mov    0x4(%eax),%eax
  802d74:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d7c:	8b 40 04             	mov    0x4(%eax),%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	74 0f                	je     802d92 <alloc_block_BF+0x1ca>
  802d83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d86:	8b 40 04             	mov    0x4(%eax),%eax
  802d89:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d8c:	8b 12                	mov    (%edx),%edx
  802d8e:	89 10                	mov    %edx,(%eax)
  802d90:	eb 0a                	jmp    802d9c <alloc_block_BF+0x1d4>
  802d92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d95:	8b 00                	mov    (%eax),%eax
  802d97:	a3 48 51 80 00       	mov    %eax,0x805148
  802d9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d9f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802da5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802daf:	a1 54 51 80 00       	mov    0x805154,%eax
  802db4:	48                   	dec    %eax
  802db5:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802dba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dbd:	eb 05                	jmp    802dc4 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc4:	c9                   	leave  
  802dc5:	c3                   	ret    

00802dc6 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802dc6:	55                   	push   %ebp
  802dc7:	89 e5                	mov    %esp,%ebp
  802dc9:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802dcc:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802dd4:	e9 7c 01 00 00       	jmp    802f55 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddf:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de2:	0f 86 cf 00 00 00    	jbe    802eb7 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802de8:	a1 48 51 80 00       	mov    0x805148,%eax
  802ded:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802df0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802df3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802df6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfc:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e02:	8b 50 08             	mov    0x8(%eax),%edx
  802e05:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e08:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e11:	2b 45 08             	sub    0x8(%ebp),%eax
  802e14:	89 c2                	mov    %eax,%edx
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 50 08             	mov    0x8(%eax),%edx
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	01 c2                	add    %eax,%edx
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802e2d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e31:	75 17                	jne    802e4a <alloc_block_NF+0x84>
  802e33:	83 ec 04             	sub    $0x4,%esp
  802e36:	68 5d 43 80 00       	push   $0x80435d
  802e3b:	68 c4 00 00 00       	push   $0xc4
  802e40:	68 eb 42 80 00       	push   $0x8042eb
  802e45:	e8 36 d9 ff ff       	call   800780 <_panic>
  802e4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	85 c0                	test   %eax,%eax
  802e51:	74 10                	je     802e63 <alloc_block_NF+0x9d>
  802e53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e56:	8b 00                	mov    (%eax),%eax
  802e58:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e5b:	8b 52 04             	mov    0x4(%edx),%edx
  802e5e:	89 50 04             	mov    %edx,0x4(%eax)
  802e61:	eb 0b                	jmp    802e6e <alloc_block_NF+0xa8>
  802e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e66:	8b 40 04             	mov    0x4(%eax),%eax
  802e69:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e71:	8b 40 04             	mov    0x4(%eax),%eax
  802e74:	85 c0                	test   %eax,%eax
  802e76:	74 0f                	je     802e87 <alloc_block_NF+0xc1>
  802e78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e7b:	8b 40 04             	mov    0x4(%eax),%eax
  802e7e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e81:	8b 12                	mov    (%edx),%edx
  802e83:	89 10                	mov    %edx,(%eax)
  802e85:	eb 0a                	jmp    802e91 <alloc_block_NF+0xcb>
  802e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8a:	8b 00                	mov    (%eax),%eax
  802e8c:	a3 48 51 80 00       	mov    %eax,0x805148
  802e91:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea4:	a1 54 51 80 00       	mov    0x805154,%eax
  802ea9:	48                   	dec    %eax
  802eaa:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802eaf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eb2:	e9 ad 00 00 00       	jmp    802f64 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ec0:	0f 85 87 00 00 00    	jne    802f4d <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eca:	75 17                	jne    802ee3 <alloc_block_NF+0x11d>
  802ecc:	83 ec 04             	sub    $0x4,%esp
  802ecf:	68 5d 43 80 00       	push   $0x80435d
  802ed4:	68 c8 00 00 00       	push   $0xc8
  802ed9:	68 eb 42 80 00       	push   $0x8042eb
  802ede:	e8 9d d8 ff ff       	call   800780 <_panic>
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	74 10                	je     802efc <alloc_block_NF+0x136>
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 00                	mov    (%eax),%eax
  802ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef4:	8b 52 04             	mov    0x4(%edx),%edx
  802ef7:	89 50 04             	mov    %edx,0x4(%eax)
  802efa:	eb 0b                	jmp    802f07 <alloc_block_NF+0x141>
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 40 04             	mov    0x4(%eax),%eax
  802f02:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 40 04             	mov    0x4(%eax),%eax
  802f0d:	85 c0                	test   %eax,%eax
  802f0f:	74 0f                	je     802f20 <alloc_block_NF+0x15a>
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	8b 40 04             	mov    0x4(%eax),%eax
  802f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1a:	8b 12                	mov    (%edx),%edx
  802f1c:	89 10                	mov    %edx,(%eax)
  802f1e:	eb 0a                	jmp    802f2a <alloc_block_NF+0x164>
  802f20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f23:	8b 00                	mov    (%eax),%eax
  802f25:	a3 38 51 80 00       	mov    %eax,0x805138
  802f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3d:	a1 44 51 80 00       	mov    0x805144,%eax
  802f42:	48                   	dec    %eax
  802f43:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	eb 17                	jmp    802f64 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	8b 00                	mov    (%eax),%eax
  802f52:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802f55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f59:	0f 85 7a fe ff ff    	jne    802dd9 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802f5f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802f64:	c9                   	leave  
  802f65:	c3                   	ret    

00802f66 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f66:	55                   	push   %ebp
  802f67:	89 e5                	mov    %esp,%ebp
  802f69:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802f6c:	a1 38 51 80 00       	mov    0x805138,%eax
  802f71:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802f74:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802f7c:	a1 44 51 80 00       	mov    0x805144,%eax
  802f81:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802f84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f88:	75 68                	jne    802ff2 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802f8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8e:	75 17                	jne    802fa7 <insert_sorted_with_merge_freeList+0x41>
  802f90:	83 ec 04             	sub    $0x4,%esp
  802f93:	68 c8 42 80 00       	push   $0x8042c8
  802f98:	68 da 00 00 00       	push   $0xda
  802f9d:	68 eb 42 80 00       	push   $0x8042eb
  802fa2:	e8 d9 d7 ff ff       	call   800780 <_panic>
  802fa7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	89 10                	mov    %edx,(%eax)
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	85 c0                	test   %eax,%eax
  802fb9:	74 0d                	je     802fc8 <insert_sorted_with_merge_freeList+0x62>
  802fbb:	a1 38 51 80 00       	mov    0x805138,%eax
  802fc0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc3:	89 50 04             	mov    %edx,0x4(%eax)
  802fc6:	eb 08                	jmp    802fd0 <insert_sorted_with_merge_freeList+0x6a>
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd3:	a3 38 51 80 00       	mov    %eax,0x805138
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe2:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe7:	40                   	inc    %eax
  802fe8:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802fed:	e9 49 07 00 00       	jmp    80373b <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff5:	8b 50 08             	mov    0x8(%eax),%edx
  802ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ffb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffe:	01 c2                	add    %eax,%edx
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 40 08             	mov    0x8(%eax),%eax
  803006:	39 c2                	cmp    %eax,%edx
  803008:	73 77                	jae    803081 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80300a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	85 c0                	test   %eax,%eax
  803011:	75 6e                	jne    803081 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803013:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803017:	74 68                	je     803081 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  803019:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301d:	75 17                	jne    803036 <insert_sorted_with_merge_freeList+0xd0>
  80301f:	83 ec 04             	sub    $0x4,%esp
  803022:	68 04 43 80 00       	push   $0x804304
  803027:	68 e0 00 00 00       	push   $0xe0
  80302c:	68 eb 42 80 00       	push   $0x8042eb
  803031:	e8 4a d7 ff ff       	call   800780 <_panic>
  803036:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80303c:	8b 45 08             	mov    0x8(%ebp),%eax
  80303f:	89 50 04             	mov    %edx,0x4(%eax)
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	8b 40 04             	mov    0x4(%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 0c                	je     803058 <insert_sorted_with_merge_freeList+0xf2>
  80304c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803051:	8b 55 08             	mov    0x8(%ebp),%edx
  803054:	89 10                	mov    %edx,(%eax)
  803056:	eb 08                	jmp    803060 <insert_sorted_with_merge_freeList+0xfa>
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	a3 38 51 80 00       	mov    %eax,0x805138
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803068:	8b 45 08             	mov    0x8(%ebp),%eax
  80306b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803071:	a1 44 51 80 00       	mov    0x805144,%eax
  803076:	40                   	inc    %eax
  803077:	a3 44 51 80 00       	mov    %eax,0x805144
  80307c:	e9 ba 06 00 00       	jmp    80373b <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	8b 50 0c             	mov    0xc(%eax),%edx
  803087:	8b 45 08             	mov    0x8(%ebp),%eax
  80308a:	8b 40 08             	mov    0x8(%eax),%eax
  80308d:	01 c2                	add    %eax,%edx
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 40 08             	mov    0x8(%eax),%eax
  803095:	39 c2                	cmp    %eax,%edx
  803097:	73 78                	jae    803111 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  803099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309c:	8b 40 04             	mov    0x4(%eax),%eax
  80309f:	85 c0                	test   %eax,%eax
  8030a1:	75 6e                	jne    803111 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8030a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030a7:	74 68                	je     803111 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8030a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ad:	75 17                	jne    8030c6 <insert_sorted_with_merge_freeList+0x160>
  8030af:	83 ec 04             	sub    $0x4,%esp
  8030b2:	68 c8 42 80 00       	push   $0x8042c8
  8030b7:	68 e6 00 00 00       	push   $0xe6
  8030bc:	68 eb 42 80 00       	push   $0x8042eb
  8030c1:	e8 ba d6 ff ff       	call   800780 <_panic>
  8030c6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cf:	89 10                	mov    %edx,(%eax)
  8030d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d4:	8b 00                	mov    (%eax),%eax
  8030d6:	85 c0                	test   %eax,%eax
  8030d8:	74 0d                	je     8030e7 <insert_sorted_with_merge_freeList+0x181>
  8030da:	a1 38 51 80 00       	mov    0x805138,%eax
  8030df:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e2:	89 50 04             	mov    %edx,0x4(%eax)
  8030e5:	eb 08                	jmp    8030ef <insert_sorted_with_merge_freeList+0x189>
  8030e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f2:	a3 38 51 80 00       	mov    %eax,0x805138
  8030f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803101:	a1 44 51 80 00       	mov    0x805144,%eax
  803106:	40                   	inc    %eax
  803107:	a3 44 51 80 00       	mov    %eax,0x805144
  80310c:	e9 2a 06 00 00       	jmp    80373b <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803111:	a1 38 51 80 00       	mov    0x805138,%eax
  803116:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803119:	e9 ed 05 00 00       	jmp    80370b <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	8b 00                	mov    (%eax),%eax
  803123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80312a:	0f 84 a7 00 00 00    	je     8031d7 <insert_sorted_with_merge_freeList+0x271>
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 50 0c             	mov    0xc(%eax),%edx
  803136:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803139:	8b 40 08             	mov    0x8(%eax),%eax
  80313c:	01 c2                	add    %eax,%edx
  80313e:	8b 45 08             	mov    0x8(%ebp),%eax
  803141:	8b 40 08             	mov    0x8(%eax),%eax
  803144:	39 c2                	cmp    %eax,%edx
  803146:	0f 83 8b 00 00 00    	jae    8031d7 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80314c:	8b 45 08             	mov    0x8(%ebp),%eax
  80314f:	8b 50 0c             	mov    0xc(%eax),%edx
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	8b 40 08             	mov    0x8(%eax),%eax
  803158:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  80315a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80315d:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803160:	39 c2                	cmp    %eax,%edx
  803162:	73 73                	jae    8031d7 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803164:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803168:	74 06                	je     803170 <insert_sorted_with_merge_freeList+0x20a>
  80316a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80316e:	75 17                	jne    803187 <insert_sorted_with_merge_freeList+0x221>
  803170:	83 ec 04             	sub    $0x4,%esp
  803173:	68 7c 43 80 00       	push   $0x80437c
  803178:	68 f0 00 00 00       	push   $0xf0
  80317d:	68 eb 42 80 00       	push   $0x8042eb
  803182:	e8 f9 d5 ff ff       	call   800780 <_panic>
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	8b 10                	mov    (%eax),%edx
  80318c:	8b 45 08             	mov    0x8(%ebp),%eax
  80318f:	89 10                	mov    %edx,(%eax)
  803191:	8b 45 08             	mov    0x8(%ebp),%eax
  803194:	8b 00                	mov    (%eax),%eax
  803196:	85 c0                	test   %eax,%eax
  803198:	74 0b                	je     8031a5 <insert_sorted_with_merge_freeList+0x23f>
  80319a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319d:	8b 00                	mov    (%eax),%eax
  80319f:	8b 55 08             	mov    0x8(%ebp),%edx
  8031a2:	89 50 04             	mov    %edx,0x4(%eax)
  8031a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ab:	89 10                	mov    %edx,(%eax)
  8031ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b3:	89 50 04             	mov    %edx,0x4(%eax)
  8031b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b9:	8b 00                	mov    (%eax),%eax
  8031bb:	85 c0                	test   %eax,%eax
  8031bd:	75 08                	jne    8031c7 <insert_sorted_with_merge_freeList+0x261>
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031c7:	a1 44 51 80 00       	mov    0x805144,%eax
  8031cc:	40                   	inc    %eax
  8031cd:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  8031d2:	e9 64 05 00 00       	jmp    80373b <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  8031d7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031dc:	8b 50 0c             	mov    0xc(%eax),%edx
  8031df:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031e4:	8b 40 08             	mov    0x8(%eax),%eax
  8031e7:	01 c2                	add    %eax,%edx
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	8b 40 08             	mov    0x8(%eax),%eax
  8031ef:	39 c2                	cmp    %eax,%edx
  8031f1:	0f 85 b1 00 00 00    	jne    8032a8 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  8031f7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031fc:	85 c0                	test   %eax,%eax
  8031fe:	0f 84 a4 00 00 00    	je     8032a8 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803204:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803209:	8b 00                	mov    (%eax),%eax
  80320b:	85 c0                	test   %eax,%eax
  80320d:	0f 85 95 00 00 00    	jne    8032a8 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803213:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803218:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80321e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803221:	8b 55 08             	mov    0x8(%ebp),%edx
  803224:	8b 52 0c             	mov    0xc(%edx),%edx
  803227:	01 ca                	add    %ecx,%edx
  803229:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803244:	75 17                	jne    80325d <insert_sorted_with_merge_freeList+0x2f7>
  803246:	83 ec 04             	sub    $0x4,%esp
  803249:	68 c8 42 80 00       	push   $0x8042c8
  80324e:	68 ff 00 00 00       	push   $0xff
  803253:	68 eb 42 80 00       	push   $0x8042eb
  803258:	e8 23 d5 ff ff       	call   800780 <_panic>
  80325d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	89 10                	mov    %edx,(%eax)
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	8b 00                	mov    (%eax),%eax
  80326d:	85 c0                	test   %eax,%eax
  80326f:	74 0d                	je     80327e <insert_sorted_with_merge_freeList+0x318>
  803271:	a1 48 51 80 00       	mov    0x805148,%eax
  803276:	8b 55 08             	mov    0x8(%ebp),%edx
  803279:	89 50 04             	mov    %edx,0x4(%eax)
  80327c:	eb 08                	jmp    803286 <insert_sorted_with_merge_freeList+0x320>
  80327e:	8b 45 08             	mov    0x8(%ebp),%eax
  803281:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	a3 48 51 80 00       	mov    %eax,0x805148
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803298:	a1 54 51 80 00       	mov    0x805154,%eax
  80329d:	40                   	inc    %eax
  80329e:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8032a3:	e9 93 04 00 00       	jmp    80373b <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 50 08             	mov    0x8(%eax),%edx
  8032ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b4:	01 c2                	add    %eax,%edx
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	8b 40 08             	mov    0x8(%eax),%eax
  8032bc:	39 c2                	cmp    %eax,%edx
  8032be:	0f 85 ae 00 00 00    	jne    803372 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8032c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c7:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	8b 40 08             	mov    0x8(%eax),%eax
  8032d0:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  8032d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d5:	8b 00                	mov    (%eax),%eax
  8032d7:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  8032da:	39 c2                	cmp    %eax,%edx
  8032dc:	0f 84 90 00 00 00    	je     803372 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  8032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e5:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ee:	01 c2                	add    %eax,%edx
  8032f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f3:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80330a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80330e:	75 17                	jne    803327 <insert_sorted_with_merge_freeList+0x3c1>
  803310:	83 ec 04             	sub    $0x4,%esp
  803313:	68 c8 42 80 00       	push   $0x8042c8
  803318:	68 0b 01 00 00       	push   $0x10b
  80331d:	68 eb 42 80 00       	push   $0x8042eb
  803322:	e8 59 d4 ff ff       	call   800780 <_panic>
  803327:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80332d:	8b 45 08             	mov    0x8(%ebp),%eax
  803330:	89 10                	mov    %edx,(%eax)
  803332:	8b 45 08             	mov    0x8(%ebp),%eax
  803335:	8b 00                	mov    (%eax),%eax
  803337:	85 c0                	test   %eax,%eax
  803339:	74 0d                	je     803348 <insert_sorted_with_merge_freeList+0x3e2>
  80333b:	a1 48 51 80 00       	mov    0x805148,%eax
  803340:	8b 55 08             	mov    0x8(%ebp),%edx
  803343:	89 50 04             	mov    %edx,0x4(%eax)
  803346:	eb 08                	jmp    803350 <insert_sorted_with_merge_freeList+0x3ea>
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803350:	8b 45 08             	mov    0x8(%ebp),%eax
  803353:	a3 48 51 80 00       	mov    %eax,0x805148
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803362:	a1 54 51 80 00       	mov    0x805154,%eax
  803367:	40                   	inc    %eax
  803368:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80336d:	e9 c9 03 00 00       	jmp    80373b <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803372:	8b 45 08             	mov    0x8(%ebp),%eax
  803375:	8b 50 0c             	mov    0xc(%eax),%edx
  803378:	8b 45 08             	mov    0x8(%ebp),%eax
  80337b:	8b 40 08             	mov    0x8(%eax),%eax
  80337e:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803383:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803386:	39 c2                	cmp    %eax,%edx
  803388:	0f 85 bb 00 00 00    	jne    803449 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  80338e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803392:	0f 84 b1 00 00 00    	je     803449 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339b:	8b 40 04             	mov    0x4(%eax),%eax
  80339e:	85 c0                	test   %eax,%eax
  8033a0:	0f 85 a3 00 00 00    	jne    803449 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8033a6:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ae:	8b 52 08             	mov    0x8(%edx),%edx
  8033b1:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8033b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8033b9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033bf:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8033c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c5:	8b 52 0c             	mov    0xc(%edx),%edx
  8033c8:	01 ca                	add    %ecx,%edx
  8033ca:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8033e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033e5:	75 17                	jne    8033fe <insert_sorted_with_merge_freeList+0x498>
  8033e7:	83 ec 04             	sub    $0x4,%esp
  8033ea:	68 c8 42 80 00       	push   $0x8042c8
  8033ef:	68 17 01 00 00       	push   $0x117
  8033f4:	68 eb 42 80 00       	push   $0x8042eb
  8033f9:	e8 82 d3 ff ff       	call   800780 <_panic>
  8033fe:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803404:	8b 45 08             	mov    0x8(%ebp),%eax
  803407:	89 10                	mov    %edx,(%eax)
  803409:	8b 45 08             	mov    0x8(%ebp),%eax
  80340c:	8b 00                	mov    (%eax),%eax
  80340e:	85 c0                	test   %eax,%eax
  803410:	74 0d                	je     80341f <insert_sorted_with_merge_freeList+0x4b9>
  803412:	a1 48 51 80 00       	mov    0x805148,%eax
  803417:	8b 55 08             	mov    0x8(%ebp),%edx
  80341a:	89 50 04             	mov    %edx,0x4(%eax)
  80341d:	eb 08                	jmp    803427 <insert_sorted_with_merge_freeList+0x4c1>
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803427:	8b 45 08             	mov    0x8(%ebp),%eax
  80342a:	a3 48 51 80 00       	mov    %eax,0x805148
  80342f:	8b 45 08             	mov    0x8(%ebp),%eax
  803432:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803439:	a1 54 51 80 00       	mov    0x805154,%eax
  80343e:	40                   	inc    %eax
  80343f:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803444:	e9 f2 02 00 00       	jmp    80373b <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803449:	8b 45 08             	mov    0x8(%ebp),%eax
  80344c:	8b 50 08             	mov    0x8(%eax),%edx
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	8b 40 0c             	mov    0xc(%eax),%eax
  803455:	01 c2                	add    %eax,%edx
  803457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345a:	8b 40 08             	mov    0x8(%eax),%eax
  80345d:	39 c2                	cmp    %eax,%edx
  80345f:	0f 85 be 00 00 00    	jne    803523 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803468:	8b 40 04             	mov    0x4(%eax),%eax
  80346b:	8b 50 08             	mov    0x8(%eax),%edx
  80346e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803471:	8b 40 04             	mov    0x4(%eax),%eax
  803474:	8b 40 0c             	mov    0xc(%eax),%eax
  803477:	01 c2                	add    %eax,%edx
  803479:	8b 45 08             	mov    0x8(%ebp),%eax
  80347c:	8b 40 08             	mov    0x8(%eax),%eax
  80347f:	39 c2                	cmp    %eax,%edx
  803481:	0f 84 9c 00 00 00    	je     803523 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	8b 50 08             	mov    0x8(%eax),%edx
  80348d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803490:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803496:	8b 50 0c             	mov    0xc(%eax),%edx
  803499:	8b 45 08             	mov    0x8(%ebp),%eax
  80349c:	8b 40 0c             	mov    0xc(%eax),%eax
  80349f:	01 c2                	add    %eax,%edx
  8034a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8034b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8034bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034bf:	75 17                	jne    8034d8 <insert_sorted_with_merge_freeList+0x572>
  8034c1:	83 ec 04             	sub    $0x4,%esp
  8034c4:	68 c8 42 80 00       	push   $0x8042c8
  8034c9:	68 26 01 00 00       	push   $0x126
  8034ce:	68 eb 42 80 00       	push   $0x8042eb
  8034d3:	e8 a8 d2 ff ff       	call   800780 <_panic>
  8034d8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034de:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e1:	89 10                	mov    %edx,(%eax)
  8034e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e6:	8b 00                	mov    (%eax),%eax
  8034e8:	85 c0                	test   %eax,%eax
  8034ea:	74 0d                	je     8034f9 <insert_sorted_with_merge_freeList+0x593>
  8034ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8034f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034f4:	89 50 04             	mov    %edx,0x4(%eax)
  8034f7:	eb 08                	jmp    803501 <insert_sorted_with_merge_freeList+0x59b>
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803501:	8b 45 08             	mov    0x8(%ebp),%eax
  803504:	a3 48 51 80 00       	mov    %eax,0x805148
  803509:	8b 45 08             	mov    0x8(%ebp),%eax
  80350c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803513:	a1 54 51 80 00       	mov    0x805154,%eax
  803518:	40                   	inc    %eax
  803519:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  80351e:	e9 18 02 00 00       	jmp    80373b <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803526:	8b 50 0c             	mov    0xc(%eax),%edx
  803529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352c:	8b 40 08             	mov    0x8(%eax),%eax
  80352f:	01 c2                	add    %eax,%edx
  803531:	8b 45 08             	mov    0x8(%ebp),%eax
  803534:	8b 40 08             	mov    0x8(%eax),%eax
  803537:	39 c2                	cmp    %eax,%edx
  803539:	0f 85 c4 01 00 00    	jne    803703 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	8b 50 0c             	mov    0xc(%eax),%edx
  803545:	8b 45 08             	mov    0x8(%ebp),%eax
  803548:	8b 40 08             	mov    0x8(%eax),%eax
  80354b:	01 c2                	add    %eax,%edx
  80354d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803550:	8b 00                	mov    (%eax),%eax
  803552:	8b 40 08             	mov    0x8(%eax),%eax
  803555:	39 c2                	cmp    %eax,%edx
  803557:	0f 85 a6 01 00 00    	jne    803703 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  80355d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803561:	0f 84 9c 01 00 00    	je     803703 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356a:	8b 50 0c             	mov    0xc(%eax),%edx
  80356d:	8b 45 08             	mov    0x8(%ebp),%eax
  803570:	8b 40 0c             	mov    0xc(%eax),%eax
  803573:	01 c2                	add    %eax,%edx
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	8b 00                	mov    (%eax),%eax
  80357a:	8b 40 0c             	mov    0xc(%eax),%eax
  80357d:	01 c2                	add    %eax,%edx
  80357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803582:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  803599:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80359d:	75 17                	jne    8035b6 <insert_sorted_with_merge_freeList+0x650>
  80359f:	83 ec 04             	sub    $0x4,%esp
  8035a2:	68 c8 42 80 00       	push   $0x8042c8
  8035a7:	68 32 01 00 00       	push   $0x132
  8035ac:	68 eb 42 80 00       	push   $0x8042eb
  8035b1:	e8 ca d1 ff ff       	call   800780 <_panic>
  8035b6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8035bf:	89 10                	mov    %edx,(%eax)
  8035c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c4:	8b 00                	mov    (%eax),%eax
  8035c6:	85 c0                	test   %eax,%eax
  8035c8:	74 0d                	je     8035d7 <insert_sorted_with_merge_freeList+0x671>
  8035ca:	a1 48 51 80 00       	mov    0x805148,%eax
  8035cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d2:	89 50 04             	mov    %edx,0x4(%eax)
  8035d5:	eb 08                	jmp    8035df <insert_sorted_with_merge_freeList+0x679>
  8035d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035da:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035df:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e2:	a3 48 51 80 00       	mov    %eax,0x805148
  8035e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035f1:	a1 54 51 80 00       	mov    0x805154,%eax
  8035f6:	40                   	inc    %eax
  8035f7:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  8035fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ff:	8b 00                	mov    (%eax),%eax
  803601:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360b:	8b 00                	mov    (%eax),%eax
  80360d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803617:	8b 00                	mov    (%eax),%eax
  803619:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80361c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803620:	75 17                	jne    803639 <insert_sorted_with_merge_freeList+0x6d3>
  803622:	83 ec 04             	sub    $0x4,%esp
  803625:	68 5d 43 80 00       	push   $0x80435d
  80362a:	68 36 01 00 00       	push   $0x136
  80362f:	68 eb 42 80 00       	push   $0x8042eb
  803634:	e8 47 d1 ff ff       	call   800780 <_panic>
  803639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80363c:	8b 00                	mov    (%eax),%eax
  80363e:	85 c0                	test   %eax,%eax
  803640:	74 10                	je     803652 <insert_sorted_with_merge_freeList+0x6ec>
  803642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803645:	8b 00                	mov    (%eax),%eax
  803647:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80364a:	8b 52 04             	mov    0x4(%edx),%edx
  80364d:	89 50 04             	mov    %edx,0x4(%eax)
  803650:	eb 0b                	jmp    80365d <insert_sorted_with_merge_freeList+0x6f7>
  803652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803655:	8b 40 04             	mov    0x4(%eax),%eax
  803658:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80365d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803660:	8b 40 04             	mov    0x4(%eax),%eax
  803663:	85 c0                	test   %eax,%eax
  803665:	74 0f                	je     803676 <insert_sorted_with_merge_freeList+0x710>
  803667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366a:	8b 40 04             	mov    0x4(%eax),%eax
  80366d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803670:	8b 12                	mov    (%edx),%edx
  803672:	89 10                	mov    %edx,(%eax)
  803674:	eb 0a                	jmp    803680 <insert_sorted_with_merge_freeList+0x71a>
  803676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803679:	8b 00                	mov    (%eax),%eax
  80367b:	a3 38 51 80 00       	mov    %eax,0x805138
  803680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803683:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803693:	a1 44 51 80 00       	mov    0x805144,%eax
  803698:	48                   	dec    %eax
  803699:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80369e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036a2:	75 17                	jne    8036bb <insert_sorted_with_merge_freeList+0x755>
  8036a4:	83 ec 04             	sub    $0x4,%esp
  8036a7:	68 c8 42 80 00       	push   $0x8042c8
  8036ac:	68 37 01 00 00       	push   $0x137
  8036b1:	68 eb 42 80 00       	push   $0x8042eb
  8036b6:	e8 c5 d0 ff ff       	call   800780 <_panic>
  8036bb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c4:	89 10                	mov    %edx,(%eax)
  8036c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036c9:	8b 00                	mov    (%eax),%eax
  8036cb:	85 c0                	test   %eax,%eax
  8036cd:	74 0d                	je     8036dc <insert_sorted_with_merge_freeList+0x776>
  8036cf:	a1 48 51 80 00       	mov    0x805148,%eax
  8036d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036d7:	89 50 04             	mov    %edx,0x4(%eax)
  8036da:	eb 08                	jmp    8036e4 <insert_sorted_with_merge_freeList+0x77e>
  8036dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036df:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036e7:	a3 48 51 80 00       	mov    %eax,0x805148
  8036ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036ef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f6:	a1 54 51 80 00       	mov    0x805154,%eax
  8036fb:	40                   	inc    %eax
  8036fc:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803701:	eb 38                	jmp    80373b <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803703:	a1 40 51 80 00       	mov    0x805140,%eax
  803708:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80370b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80370f:	74 07                	je     803718 <insert_sorted_with_merge_freeList+0x7b2>
  803711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803714:	8b 00                	mov    (%eax),%eax
  803716:	eb 05                	jmp    80371d <insert_sorted_with_merge_freeList+0x7b7>
  803718:	b8 00 00 00 00       	mov    $0x0,%eax
  80371d:	a3 40 51 80 00       	mov    %eax,0x805140
  803722:	a1 40 51 80 00       	mov    0x805140,%eax
  803727:	85 c0                	test   %eax,%eax
  803729:	0f 85 ef f9 ff ff    	jne    80311e <insert_sorted_with_merge_freeList+0x1b8>
  80372f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803733:	0f 85 e5 f9 ff ff    	jne    80311e <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803739:	eb 00                	jmp    80373b <insert_sorted_with_merge_freeList+0x7d5>
  80373b:	90                   	nop
  80373c:	c9                   	leave  
  80373d:	c3                   	ret    
  80373e:	66 90                	xchg   %ax,%ax

00803740 <__udivdi3>:
  803740:	55                   	push   %ebp
  803741:	57                   	push   %edi
  803742:	56                   	push   %esi
  803743:	53                   	push   %ebx
  803744:	83 ec 1c             	sub    $0x1c,%esp
  803747:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80374b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80374f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803753:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803757:	89 ca                	mov    %ecx,%edx
  803759:	89 f8                	mov    %edi,%eax
  80375b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80375f:	85 f6                	test   %esi,%esi
  803761:	75 2d                	jne    803790 <__udivdi3+0x50>
  803763:	39 cf                	cmp    %ecx,%edi
  803765:	77 65                	ja     8037cc <__udivdi3+0x8c>
  803767:	89 fd                	mov    %edi,%ebp
  803769:	85 ff                	test   %edi,%edi
  80376b:	75 0b                	jne    803778 <__udivdi3+0x38>
  80376d:	b8 01 00 00 00       	mov    $0x1,%eax
  803772:	31 d2                	xor    %edx,%edx
  803774:	f7 f7                	div    %edi
  803776:	89 c5                	mov    %eax,%ebp
  803778:	31 d2                	xor    %edx,%edx
  80377a:	89 c8                	mov    %ecx,%eax
  80377c:	f7 f5                	div    %ebp
  80377e:	89 c1                	mov    %eax,%ecx
  803780:	89 d8                	mov    %ebx,%eax
  803782:	f7 f5                	div    %ebp
  803784:	89 cf                	mov    %ecx,%edi
  803786:	89 fa                	mov    %edi,%edx
  803788:	83 c4 1c             	add    $0x1c,%esp
  80378b:	5b                   	pop    %ebx
  80378c:	5e                   	pop    %esi
  80378d:	5f                   	pop    %edi
  80378e:	5d                   	pop    %ebp
  80378f:	c3                   	ret    
  803790:	39 ce                	cmp    %ecx,%esi
  803792:	77 28                	ja     8037bc <__udivdi3+0x7c>
  803794:	0f bd fe             	bsr    %esi,%edi
  803797:	83 f7 1f             	xor    $0x1f,%edi
  80379a:	75 40                	jne    8037dc <__udivdi3+0x9c>
  80379c:	39 ce                	cmp    %ecx,%esi
  80379e:	72 0a                	jb     8037aa <__udivdi3+0x6a>
  8037a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037a4:	0f 87 9e 00 00 00    	ja     803848 <__udivdi3+0x108>
  8037aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8037af:	89 fa                	mov    %edi,%edx
  8037b1:	83 c4 1c             	add    $0x1c,%esp
  8037b4:	5b                   	pop    %ebx
  8037b5:	5e                   	pop    %esi
  8037b6:	5f                   	pop    %edi
  8037b7:	5d                   	pop    %ebp
  8037b8:	c3                   	ret    
  8037b9:	8d 76 00             	lea    0x0(%esi),%esi
  8037bc:	31 ff                	xor    %edi,%edi
  8037be:	31 c0                	xor    %eax,%eax
  8037c0:	89 fa                	mov    %edi,%edx
  8037c2:	83 c4 1c             	add    $0x1c,%esp
  8037c5:	5b                   	pop    %ebx
  8037c6:	5e                   	pop    %esi
  8037c7:	5f                   	pop    %edi
  8037c8:	5d                   	pop    %ebp
  8037c9:	c3                   	ret    
  8037ca:	66 90                	xchg   %ax,%ax
  8037cc:	89 d8                	mov    %ebx,%eax
  8037ce:	f7 f7                	div    %edi
  8037d0:	31 ff                	xor    %edi,%edi
  8037d2:	89 fa                	mov    %edi,%edx
  8037d4:	83 c4 1c             	add    $0x1c,%esp
  8037d7:	5b                   	pop    %ebx
  8037d8:	5e                   	pop    %esi
  8037d9:	5f                   	pop    %edi
  8037da:	5d                   	pop    %ebp
  8037db:	c3                   	ret    
  8037dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037e1:	89 eb                	mov    %ebp,%ebx
  8037e3:	29 fb                	sub    %edi,%ebx
  8037e5:	89 f9                	mov    %edi,%ecx
  8037e7:	d3 e6                	shl    %cl,%esi
  8037e9:	89 c5                	mov    %eax,%ebp
  8037eb:	88 d9                	mov    %bl,%cl
  8037ed:	d3 ed                	shr    %cl,%ebp
  8037ef:	89 e9                	mov    %ebp,%ecx
  8037f1:	09 f1                	or     %esi,%ecx
  8037f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8037f7:	89 f9                	mov    %edi,%ecx
  8037f9:	d3 e0                	shl    %cl,%eax
  8037fb:	89 c5                	mov    %eax,%ebp
  8037fd:	89 d6                	mov    %edx,%esi
  8037ff:	88 d9                	mov    %bl,%cl
  803801:	d3 ee                	shr    %cl,%esi
  803803:	89 f9                	mov    %edi,%ecx
  803805:	d3 e2                	shl    %cl,%edx
  803807:	8b 44 24 08          	mov    0x8(%esp),%eax
  80380b:	88 d9                	mov    %bl,%cl
  80380d:	d3 e8                	shr    %cl,%eax
  80380f:	09 c2                	or     %eax,%edx
  803811:	89 d0                	mov    %edx,%eax
  803813:	89 f2                	mov    %esi,%edx
  803815:	f7 74 24 0c          	divl   0xc(%esp)
  803819:	89 d6                	mov    %edx,%esi
  80381b:	89 c3                	mov    %eax,%ebx
  80381d:	f7 e5                	mul    %ebp
  80381f:	39 d6                	cmp    %edx,%esi
  803821:	72 19                	jb     80383c <__udivdi3+0xfc>
  803823:	74 0b                	je     803830 <__udivdi3+0xf0>
  803825:	89 d8                	mov    %ebx,%eax
  803827:	31 ff                	xor    %edi,%edi
  803829:	e9 58 ff ff ff       	jmp    803786 <__udivdi3+0x46>
  80382e:	66 90                	xchg   %ax,%ax
  803830:	8b 54 24 08          	mov    0x8(%esp),%edx
  803834:	89 f9                	mov    %edi,%ecx
  803836:	d3 e2                	shl    %cl,%edx
  803838:	39 c2                	cmp    %eax,%edx
  80383a:	73 e9                	jae    803825 <__udivdi3+0xe5>
  80383c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80383f:	31 ff                	xor    %edi,%edi
  803841:	e9 40 ff ff ff       	jmp    803786 <__udivdi3+0x46>
  803846:	66 90                	xchg   %ax,%ax
  803848:	31 c0                	xor    %eax,%eax
  80384a:	e9 37 ff ff ff       	jmp    803786 <__udivdi3+0x46>
  80384f:	90                   	nop

00803850 <__umoddi3>:
  803850:	55                   	push   %ebp
  803851:	57                   	push   %edi
  803852:	56                   	push   %esi
  803853:	53                   	push   %ebx
  803854:	83 ec 1c             	sub    $0x1c,%esp
  803857:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80385b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80385f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803863:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803867:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80386b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80386f:	89 f3                	mov    %esi,%ebx
  803871:	89 fa                	mov    %edi,%edx
  803873:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803877:	89 34 24             	mov    %esi,(%esp)
  80387a:	85 c0                	test   %eax,%eax
  80387c:	75 1a                	jne    803898 <__umoddi3+0x48>
  80387e:	39 f7                	cmp    %esi,%edi
  803880:	0f 86 a2 00 00 00    	jbe    803928 <__umoddi3+0xd8>
  803886:	89 c8                	mov    %ecx,%eax
  803888:	89 f2                	mov    %esi,%edx
  80388a:	f7 f7                	div    %edi
  80388c:	89 d0                	mov    %edx,%eax
  80388e:	31 d2                	xor    %edx,%edx
  803890:	83 c4 1c             	add    $0x1c,%esp
  803893:	5b                   	pop    %ebx
  803894:	5e                   	pop    %esi
  803895:	5f                   	pop    %edi
  803896:	5d                   	pop    %ebp
  803897:	c3                   	ret    
  803898:	39 f0                	cmp    %esi,%eax
  80389a:	0f 87 ac 00 00 00    	ja     80394c <__umoddi3+0xfc>
  8038a0:	0f bd e8             	bsr    %eax,%ebp
  8038a3:	83 f5 1f             	xor    $0x1f,%ebp
  8038a6:	0f 84 ac 00 00 00    	je     803958 <__umoddi3+0x108>
  8038ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8038b1:	29 ef                	sub    %ebp,%edi
  8038b3:	89 fe                	mov    %edi,%esi
  8038b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038b9:	89 e9                	mov    %ebp,%ecx
  8038bb:	d3 e0                	shl    %cl,%eax
  8038bd:	89 d7                	mov    %edx,%edi
  8038bf:	89 f1                	mov    %esi,%ecx
  8038c1:	d3 ef                	shr    %cl,%edi
  8038c3:	09 c7                	or     %eax,%edi
  8038c5:	89 e9                	mov    %ebp,%ecx
  8038c7:	d3 e2                	shl    %cl,%edx
  8038c9:	89 14 24             	mov    %edx,(%esp)
  8038cc:	89 d8                	mov    %ebx,%eax
  8038ce:	d3 e0                	shl    %cl,%eax
  8038d0:	89 c2                	mov    %eax,%edx
  8038d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038d6:	d3 e0                	shl    %cl,%eax
  8038d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038e0:	89 f1                	mov    %esi,%ecx
  8038e2:	d3 e8                	shr    %cl,%eax
  8038e4:	09 d0                	or     %edx,%eax
  8038e6:	d3 eb                	shr    %cl,%ebx
  8038e8:	89 da                	mov    %ebx,%edx
  8038ea:	f7 f7                	div    %edi
  8038ec:	89 d3                	mov    %edx,%ebx
  8038ee:	f7 24 24             	mull   (%esp)
  8038f1:	89 c6                	mov    %eax,%esi
  8038f3:	89 d1                	mov    %edx,%ecx
  8038f5:	39 d3                	cmp    %edx,%ebx
  8038f7:	0f 82 87 00 00 00    	jb     803984 <__umoddi3+0x134>
  8038fd:	0f 84 91 00 00 00    	je     803994 <__umoddi3+0x144>
  803903:	8b 54 24 04          	mov    0x4(%esp),%edx
  803907:	29 f2                	sub    %esi,%edx
  803909:	19 cb                	sbb    %ecx,%ebx
  80390b:	89 d8                	mov    %ebx,%eax
  80390d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803911:	d3 e0                	shl    %cl,%eax
  803913:	89 e9                	mov    %ebp,%ecx
  803915:	d3 ea                	shr    %cl,%edx
  803917:	09 d0                	or     %edx,%eax
  803919:	89 e9                	mov    %ebp,%ecx
  80391b:	d3 eb                	shr    %cl,%ebx
  80391d:	89 da                	mov    %ebx,%edx
  80391f:	83 c4 1c             	add    $0x1c,%esp
  803922:	5b                   	pop    %ebx
  803923:	5e                   	pop    %esi
  803924:	5f                   	pop    %edi
  803925:	5d                   	pop    %ebp
  803926:	c3                   	ret    
  803927:	90                   	nop
  803928:	89 fd                	mov    %edi,%ebp
  80392a:	85 ff                	test   %edi,%edi
  80392c:	75 0b                	jne    803939 <__umoddi3+0xe9>
  80392e:	b8 01 00 00 00       	mov    $0x1,%eax
  803933:	31 d2                	xor    %edx,%edx
  803935:	f7 f7                	div    %edi
  803937:	89 c5                	mov    %eax,%ebp
  803939:	89 f0                	mov    %esi,%eax
  80393b:	31 d2                	xor    %edx,%edx
  80393d:	f7 f5                	div    %ebp
  80393f:	89 c8                	mov    %ecx,%eax
  803941:	f7 f5                	div    %ebp
  803943:	89 d0                	mov    %edx,%eax
  803945:	e9 44 ff ff ff       	jmp    80388e <__umoddi3+0x3e>
  80394a:	66 90                	xchg   %ax,%ax
  80394c:	89 c8                	mov    %ecx,%eax
  80394e:	89 f2                	mov    %esi,%edx
  803950:	83 c4 1c             	add    $0x1c,%esp
  803953:	5b                   	pop    %ebx
  803954:	5e                   	pop    %esi
  803955:	5f                   	pop    %edi
  803956:	5d                   	pop    %ebp
  803957:	c3                   	ret    
  803958:	3b 04 24             	cmp    (%esp),%eax
  80395b:	72 06                	jb     803963 <__umoddi3+0x113>
  80395d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803961:	77 0f                	ja     803972 <__umoddi3+0x122>
  803963:	89 f2                	mov    %esi,%edx
  803965:	29 f9                	sub    %edi,%ecx
  803967:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80396b:	89 14 24             	mov    %edx,(%esp)
  80396e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803972:	8b 44 24 04          	mov    0x4(%esp),%eax
  803976:	8b 14 24             	mov    (%esp),%edx
  803979:	83 c4 1c             	add    $0x1c,%esp
  80397c:	5b                   	pop    %ebx
  80397d:	5e                   	pop    %esi
  80397e:	5f                   	pop    %edi
  80397f:	5d                   	pop    %ebp
  803980:	c3                   	ret    
  803981:	8d 76 00             	lea    0x0(%esi),%esi
  803984:	2b 04 24             	sub    (%esp),%eax
  803987:	19 fa                	sbb    %edi,%edx
  803989:	89 d1                	mov    %edx,%ecx
  80398b:	89 c6                	mov    %eax,%esi
  80398d:	e9 71 ff ff ff       	jmp    803903 <__umoddi3+0xb3>
  803992:	66 90                	xchg   %ax,%ax
  803994:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803998:	72 ea                	jb     803984 <__umoddi3+0x134>
  80399a:	89 d9                	mov    %ebx,%ecx
  80399c:	e9 62 ff ff ff       	jmp    803903 <__umoddi3+0xb3>
