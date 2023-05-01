
obj/user/quicksort_heap:     file format elf32-i386


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
  800031:	e8 1f 06 00 00       	call   800655 <libmain>
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
  800041:	e8 2f 21 00 00       	call   802175 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 39 80 00       	push   $0x8039c0
  80004e:	e8 f2 09 00 00       	call   800a45 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 39 80 00       	push   $0x8039c2
  80005e:	e8 e2 09 00 00       	call   800a45 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   QUICK SORT   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 db 39 80 00       	push   $0x8039db
  80006e:	e8 d2 09 00 00       	call   800a45 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 39 80 00       	push   $0x8039c2
  80007e:	e8 c2 09 00 00       	call   800a45 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 39 80 00       	push   $0x8039c0
  80008e:	e8 b2 09 00 00       	call   800a45 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 f4 39 80 00       	push   $0x8039f4
  8000a5:	e8 1d 10 00 00       	call   8010c7 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 6d 15 00 00       	call   80162d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 15 1b 00 00       	call   801bea <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 14 3a 80 00       	push   $0x803a14
  8000e3:	e8 5d 09 00 00       	call   800a45 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 36 3a 80 00       	push   $0x803a36
  8000f3:	e8 4d 09 00 00       	call   800a45 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 44 3a 80 00       	push   $0x803a44
  800103:	e8 3d 09 00 00       	call   800a45 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 53 3a 80 00       	push   $0x803a53
  800113:	e8 2d 09 00 00       	call   800a45 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 63 3a 80 00       	push   $0x803a63
  800123:	e8 1d 09 00 00       	call   800a45 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 cd 04 00 00       	call   8005fd <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 75 04 00 00       	call   8005b5 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 68 04 00 00       	call   8005b5 <cputchar>
  80014d:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800150:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800154:	74 0c                	je     800162 <_main+0x12a>
  800156:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015a:	74 06                	je     800162 <_main+0x12a>
  80015c:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800160:	75 b9                	jne    80011b <_main+0xe3>
		//2012: lock the interrupt
		sys_enable_interrupt();
  800162:	e8 28 20 00 00       	call   80218f <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  800167:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
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
  80017d:	ff 75 f0             	pushl  -0x10(%ebp)
  800180:	ff 75 ec             	pushl  -0x14(%ebp)
  800183:	e8 f5 02 00 00       	call   80047d <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 13 03 00 00       	call   8004ae <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 35 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 22 03 00 00       	call   8004e3 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 f0 00 00 00       	call   8002c2 <QuickSort>
  8001d2:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d5:	e8 9b 1f 00 00       	call   802175 <sys_disable_interrupt>
			cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001da:	83 ec 0c             	sub    $0xc,%esp
  8001dd:	68 6c 3a 80 00       	push   $0x803a6c
  8001e2:	e8 5e 08 00 00       	call   800a45 <cprintf>
  8001e7:	83 c4 10             	add    $0x10,%esp
		//		PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ea:	e8 a0 1f 00 00       	call   80218f <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f5:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f8:	e8 d6 01 00 00       	call   8003d3 <CheckSorted>
  8001fd:	83 c4 10             	add    $0x10,%esp
  800200:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800203:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800207:	75 14                	jne    80021d <_main+0x1e5>
  800209:	83 ec 04             	sub    $0x4,%esp
  80020c:	68 a0 3a 80 00       	push   $0x803aa0
  800211:	6a 48                	push   $0x48
  800213:	68 c2 3a 80 00       	push   $0x803ac2
  800218:	e8 74 05 00 00       	call   800791 <_panic>
		else
		{
			sys_disable_interrupt();
  80021d:	e8 53 1f 00 00       	call   802175 <sys_disable_interrupt>
			cprintf("\n===============================================\n") ;
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	68 d8 3a 80 00       	push   $0x803ad8
  80022a:	e8 16 08 00 00       	call   800a45 <cprintf>
  80022f:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800232:	83 ec 0c             	sub    $0xc,%esp
  800235:	68 0c 3b 80 00       	push   $0x803b0c
  80023a:	e8 06 08 00 00       	call   800a45 <cprintf>
  80023f:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	68 40 3b 80 00       	push   $0x803b40
  80024a:	e8 f6 07 00 00       	call   800a45 <cprintf>
  80024f:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800252:	e8 38 1f 00 00       	call   80218f <sys_enable_interrupt>
		}

		sys_disable_interrupt();
  800257:	e8 19 1f 00 00       	call   802175 <sys_disable_interrupt>
			Chose = 0 ;
  80025c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800260:	eb 42                	jmp    8002a4 <_main+0x26c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800262:	83 ec 0c             	sub    $0xc,%esp
  800265:	68 72 3b 80 00       	push   $0x803b72
  80026a:	e8 d6 07 00 00       	call   800a45 <cprintf>
  80026f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800272:	e8 86 03 00 00       	call   8005fd <getchar>
  800277:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80027e:	83 ec 0c             	sub    $0xc,%esp
  800281:	50                   	push   %eax
  800282:	e8 2e 03 00 00       	call   8005b5 <cputchar>
  800287:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 0a                	push   $0xa
  80028f:	e8 21 03 00 00       	call   8005b5 <cputchar>
  800294:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	6a 0a                	push   $0xa
  80029c:	e8 14 03 00 00       	call   8005b5 <cputchar>
  8002a1:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
		}

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002a8:	74 06                	je     8002b0 <_main+0x278>
  8002aa:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002ae:	75 b2                	jne    800262 <_main+0x22a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b0:	e8 da 1e 00 00       	call   80218f <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b9:	0f 84 82 fd ff ff    	je     800041 <_main+0x9>

}
  8002bf:	90                   	nop
  8002c0:	c9                   	leave  
  8002c1:	c3                   	ret    

008002c2 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8002c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002cb:	48                   	dec    %eax
  8002cc:	50                   	push   %eax
  8002cd:	6a 00                	push   $0x0
  8002cf:	ff 75 0c             	pushl  0xc(%ebp)
  8002d2:	ff 75 08             	pushl  0x8(%ebp)
  8002d5:	e8 06 00 00 00       	call   8002e0 <QSort>
  8002da:	83 c4 10             	add    $0x10,%esp
}
  8002dd:	90                   	nop
  8002de:	c9                   	leave  
  8002df:	c3                   	ret    

008002e0 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8002e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002e9:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002ec:	0f 8d de 00 00 00    	jge    8003d0 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  8002f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002f5:	40                   	inc    %eax
  8002f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8002f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8002fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8002ff:	e9 80 00 00 00       	jmp    800384 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800304:	ff 45 f4             	incl   -0xc(%ebp)
  800307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80030a:	3b 45 14             	cmp    0x14(%ebp),%eax
  80030d:	7f 2b                	jg     80033a <QSort+0x5a>
  80030f:	8b 45 10             	mov    0x10(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800323:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	39 c2                	cmp    %eax,%edx
  800333:	7d cf                	jge    800304 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800335:	eb 03                	jmp    80033a <QSort+0x5a>
  800337:	ff 4d f0             	decl   -0x10(%ebp)
  80033a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800340:	7e 26                	jle    800368 <QSort+0x88>
  800342:	8b 45 10             	mov    0x10(%ebp),%eax
  800345:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034c:	8b 45 08             	mov    0x8(%ebp),%eax
  80034f:	01 d0                	add    %edx,%eax
  800351:	8b 10                	mov    (%eax),%edx
  800353:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800356:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035d:	8b 45 08             	mov    0x8(%ebp),%eax
  800360:	01 c8                	add    %ecx,%eax
  800362:	8b 00                	mov    (%eax),%eax
  800364:	39 c2                	cmp    %eax,%edx
  800366:	7e cf                	jle    800337 <QSort+0x57>

		if (i <= j)
  800368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80036e:	7f 14                	jg     800384 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	ff 75 f0             	pushl  -0x10(%ebp)
  800376:	ff 75 f4             	pushl  -0xc(%ebp)
  800379:	ff 75 08             	pushl  0x8(%ebp)
  80037c:	e8 a9 00 00 00       	call   80042a <Swap>
  800381:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80038a:	0f 8e 77 ff ff ff    	jle    800307 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800390:	83 ec 04             	sub    $0x4,%esp
  800393:	ff 75 f0             	pushl  -0x10(%ebp)
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	ff 75 08             	pushl  0x8(%ebp)
  80039c:	e8 89 00 00 00       	call   80042a <Swap>
  8003a1:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a7:	48                   	dec    %eax
  8003a8:	50                   	push   %eax
  8003a9:	ff 75 10             	pushl  0x10(%ebp)
  8003ac:	ff 75 0c             	pushl  0xc(%ebp)
  8003af:	ff 75 08             	pushl  0x8(%ebp)
  8003b2:	e8 29 ff ff ff       	call   8002e0 <QSort>
  8003b7:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8003ba:	ff 75 14             	pushl  0x14(%ebp)
  8003bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 15 ff ff ff       	call   8002e0 <QSort>
  8003cb:	83 c4 10             	add    $0x10,%esp
  8003ce:	eb 01                	jmp    8003d1 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8003d0:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  8003d1:	c9                   	leave  
  8003d2:	c3                   	ret    

008003d3 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8003d3:	55                   	push   %ebp
  8003d4:	89 e5                	mov    %esp,%ebp
  8003d6:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8003d9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8003e7:	eb 33                	jmp    80041c <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8003e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	8b 10                	mov    (%eax),%edx
  8003fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8003fd:	40                   	inc    %eax
  8003fe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c8                	add    %ecx,%eax
  80040a:	8b 00                	mov    (%eax),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	7e 09                	jle    800419 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800410:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800417:	eb 0c                	jmp    800425 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800419:	ff 45 f8             	incl   -0x8(%ebp)
  80041c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80041f:	48                   	dec    %eax
  800420:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800423:	7f c4                	jg     8003e9 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800425:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800428:	c9                   	leave  
  800429:	c3                   	ret    

0080042a <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80042a:	55                   	push   %ebp
  80042b:	89 e5                	mov    %esp,%ebp
  80042d:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800430:	8b 45 0c             	mov    0xc(%ebp),%eax
  800433:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043a:	8b 45 08             	mov    0x8(%ebp),%eax
  80043d:	01 d0                	add    %edx,%eax
  80043f:	8b 00                	mov    (%eax),%eax
  800441:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800444:	8b 45 0c             	mov    0xc(%ebp),%eax
  800447:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80044e:	8b 45 08             	mov    0x8(%ebp),%eax
  800451:	01 c2                	add    %eax,%edx
  800453:	8b 45 10             	mov    0x10(%ebp),%eax
  800456:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800466:	8b 45 10             	mov    0x10(%ebp),%eax
  800469:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	01 c2                	add    %eax,%edx
  800475:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800478:	89 02                	mov    %eax,(%edx)
}
  80047a:	90                   	nop
  80047b:	c9                   	leave  
  80047c:	c3                   	ret    

0080047d <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800483:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80048a:	eb 17                	jmp    8004a3 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80048c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	01 c2                	add    %eax,%edx
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004a0:	ff 45 fc             	incl   -0x4(%ebp)
  8004a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004a9:	7c e1                	jl     80048c <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8004bb:	eb 1b                	jmp    8004d8 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8004bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	01 c2                	add    %eax,%edx
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cf:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8004d2:	48                   	dec    %eax
  8004d3:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004d5:	ff 45 fc             	incl   -0x4(%ebp)
  8004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004de:	7c dd                	jl     8004bd <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8004e0:	90                   	nop
  8004e1:	c9                   	leave  
  8004e2:	c3                   	ret    

008004e3 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8004e3:	55                   	push   %ebp
  8004e4:	89 e5                	mov    %esp,%ebp
  8004e6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8004e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ec:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8004f1:	f7 e9                	imul   %ecx
  8004f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f6:	89 d0                	mov    %edx,%eax
  8004f8:	29 c8                	sub    %ecx,%eax
  8004fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8004fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800504:	eb 1e                	jmp    800524 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800506:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800519:	99                   	cltd   
  80051a:	f7 7d f8             	idivl  -0x8(%ebp)
  80051d:	89 d0                	mov    %edx,%eax
  80051f:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800521:	ff 45 fc             	incl   -0x4(%ebp)
  800524:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800527:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80052a:	7c da                	jl     800506 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80052c:	90                   	nop
  80052d:	c9                   	leave  
  80052e:	c3                   	ret    

0080052f <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80052f:	55                   	push   %ebp
  800530:	89 e5                	mov    %esp,%ebp
  800532:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800535:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80053c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800543:	eb 42                	jmp    800587 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800548:	99                   	cltd   
  800549:	f7 7d f0             	idivl  -0x10(%ebp)
  80054c:	89 d0                	mov    %edx,%eax
  80054e:	85 c0                	test   %eax,%eax
  800550:	75 10                	jne    800562 <PrintElements+0x33>
			cprintf("\n");
  800552:	83 ec 0c             	sub    $0xc,%esp
  800555:	68 c0 39 80 00       	push   $0x8039c0
  80055a:	e8 e6 04 00 00       	call   800a45 <cprintf>
  80055f:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056c:	8b 45 08             	mov    0x8(%ebp),%eax
  80056f:	01 d0                	add    %edx,%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	83 ec 08             	sub    $0x8,%esp
  800576:	50                   	push   %eax
  800577:	68 90 3b 80 00       	push   $0x803b90
  80057c:	e8 c4 04 00 00       	call   800a45 <cprintf>
  800581:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800584:	ff 45 f4             	incl   -0xc(%ebp)
  800587:	8b 45 0c             	mov    0xc(%ebp),%eax
  80058a:	48                   	dec    %eax
  80058b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80058e:	7f b5                	jg     800545 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	8b 45 08             	mov    0x8(%ebp),%eax
  80059d:	01 d0                	add    %edx,%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	83 ec 08             	sub    $0x8,%esp
  8005a4:	50                   	push   %eax
  8005a5:	68 95 3b 80 00       	push   $0x803b95
  8005aa:	e8 96 04 00 00       	call   800a45 <cprintf>
  8005af:	83 c4 10             	add    $0x10,%esp

}
  8005b2:	90                   	nop
  8005b3:	c9                   	leave  
  8005b4:	c3                   	ret    

008005b5 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8005b5:	55                   	push   %ebp
  8005b6:	89 e5                	mov    %esp,%ebp
  8005b8:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005c1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005c5:	83 ec 0c             	sub    $0xc,%esp
  8005c8:	50                   	push   %eax
  8005c9:	e8 db 1b 00 00       	call   8021a9 <sys_cputc>
  8005ce:	83 c4 10             	add    $0x10,%esp
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005da:	e8 96 1b 00 00       	call   802175 <sys_disable_interrupt>
	char c = ch;
  8005df:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e2:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8005e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8005e9:	83 ec 0c             	sub    $0xc,%esp
  8005ec:	50                   	push   %eax
  8005ed:	e8 b7 1b 00 00       	call   8021a9 <sys_cputc>
  8005f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8005f5:	e8 95 1b 00 00       	call   80218f <sys_enable_interrupt>
}
  8005fa:	90                   	nop
  8005fb:	c9                   	leave  
  8005fc:	c3                   	ret    

008005fd <getchar>:

int
getchar(void)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800603:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80060a:	eb 08                	jmp    800614 <getchar+0x17>
	{
		c = sys_cgetc();
  80060c:	e8 df 19 00 00       	call   801ff0 <sys_cgetc>
  800611:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800618:	74 f2                	je     80060c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80061a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80061d:	c9                   	leave  
  80061e:	c3                   	ret    

0080061f <atomic_getchar>:

int
atomic_getchar(void)
{
  80061f:	55                   	push   %ebp
  800620:	89 e5                	mov    %esp,%ebp
  800622:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800625:	e8 4b 1b 00 00       	call   802175 <sys_disable_interrupt>
	int c=0;
  80062a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800631:	eb 08                	jmp    80063b <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800633:	e8 b8 19 00 00       	call   801ff0 <sys_cgetc>
  800638:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80063b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80063f:	74 f2                	je     800633 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800641:	e8 49 1b 00 00       	call   80218f <sys_enable_interrupt>
	return c;
  800646:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <iscons>:

int iscons(int fdnum)
{
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80064e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800653:	5d                   	pop    %ebp
  800654:	c3                   	ret    

00800655 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800655:	55                   	push   %ebp
  800656:	89 e5                	mov    %esp,%ebp
  800658:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80065b:	e8 08 1d 00 00       	call   802368 <sys_getenvindex>
  800660:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800666:	89 d0                	mov    %edx,%eax
  800668:	c1 e0 03             	shl    $0x3,%eax
  80066b:	01 d0                	add    %edx,%eax
  80066d:	01 c0                	add    %eax,%eax
  80066f:	01 d0                	add    %edx,%eax
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	01 d0                	add    %edx,%eax
  80067a:	c1 e0 04             	shl    $0x4,%eax
  80067d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800682:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800687:	a1 24 50 80 00       	mov    0x805024,%eax
  80068c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800692:	84 c0                	test   %al,%al
  800694:	74 0f                	je     8006a5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800696:	a1 24 50 80 00       	mov    0x805024,%eax
  80069b:	05 5c 05 00 00       	add    $0x55c,%eax
  8006a0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006a9:	7e 0a                	jle    8006b5 <libmain+0x60>
		binaryname = argv[0];
  8006ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006b5:	83 ec 08             	sub    $0x8,%esp
  8006b8:	ff 75 0c             	pushl  0xc(%ebp)
  8006bb:	ff 75 08             	pushl  0x8(%ebp)
  8006be:	e8 75 f9 ff ff       	call   800038 <_main>
  8006c3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006c6:	e8 aa 1a 00 00       	call   802175 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006cb:	83 ec 0c             	sub    $0xc,%esp
  8006ce:	68 b4 3b 80 00       	push   $0x803bb4
  8006d3:	e8 6d 03 00 00       	call   800a45 <cprintf>
  8006d8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006db:	a1 24 50 80 00       	mov    0x805024,%eax
  8006e0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006e6:	a1 24 50 80 00       	mov    0x805024,%eax
  8006eb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006f1:	83 ec 04             	sub    $0x4,%esp
  8006f4:	52                   	push   %edx
  8006f5:	50                   	push   %eax
  8006f6:	68 dc 3b 80 00       	push   $0x803bdc
  8006fb:	e8 45 03 00 00       	call   800a45 <cprintf>
  800700:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800703:	a1 24 50 80 00       	mov    0x805024,%eax
  800708:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80070e:	a1 24 50 80 00       	mov    0x805024,%eax
  800713:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800719:	a1 24 50 80 00       	mov    0x805024,%eax
  80071e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800724:	51                   	push   %ecx
  800725:	52                   	push   %edx
  800726:	50                   	push   %eax
  800727:	68 04 3c 80 00       	push   $0x803c04
  80072c:	e8 14 03 00 00       	call   800a45 <cprintf>
  800731:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800734:	a1 24 50 80 00       	mov    0x805024,%eax
  800739:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80073f:	83 ec 08             	sub    $0x8,%esp
  800742:	50                   	push   %eax
  800743:	68 5c 3c 80 00       	push   $0x803c5c
  800748:	e8 f8 02 00 00       	call   800a45 <cprintf>
  80074d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800750:	83 ec 0c             	sub    $0xc,%esp
  800753:	68 b4 3b 80 00       	push   $0x803bb4
  800758:	e8 e8 02 00 00       	call   800a45 <cprintf>
  80075d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800760:	e8 2a 1a 00 00       	call   80218f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800765:	e8 19 00 00 00       	call   800783 <exit>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800773:	83 ec 0c             	sub    $0xc,%esp
  800776:	6a 00                	push   $0x0
  800778:	e8 b7 1b 00 00       	call   802334 <sys_destroy_env>
  80077d:	83 c4 10             	add    $0x10,%esp
}
  800780:	90                   	nop
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <exit>:

void
exit(void)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800789:	e8 0c 1c 00 00       	call   80239a <sys_exit_env>
}
  80078e:	90                   	nop
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800797:	8d 45 10             	lea    0x10(%ebp),%eax
  80079a:	83 c0 04             	add    $0x4,%eax
  80079d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007a0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007a5:	85 c0                	test   %eax,%eax
  8007a7:	74 16                	je     8007bf <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007a9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007ae:	83 ec 08             	sub    $0x8,%esp
  8007b1:	50                   	push   %eax
  8007b2:	68 70 3c 80 00       	push   $0x803c70
  8007b7:	e8 89 02 00 00       	call   800a45 <cprintf>
  8007bc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007bf:	a1 00 50 80 00       	mov    0x805000,%eax
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	50                   	push   %eax
  8007cb:	68 75 3c 80 00       	push   $0x803c75
  8007d0:	e8 70 02 00 00       	call   800a45 <cprintf>
  8007d5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8007db:	83 ec 08             	sub    $0x8,%esp
  8007de:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e1:	50                   	push   %eax
  8007e2:	e8 f3 01 00 00       	call   8009da <vcprintf>
  8007e7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007ea:	83 ec 08             	sub    $0x8,%esp
  8007ed:	6a 00                	push   $0x0
  8007ef:	68 91 3c 80 00       	push   $0x803c91
  8007f4:	e8 e1 01 00 00       	call   8009da <vcprintf>
  8007f9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007fc:	e8 82 ff ff ff       	call   800783 <exit>

	// should not return here
	while (1) ;
  800801:	eb fe                	jmp    800801 <_panic+0x70>

00800803 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800809:	a1 24 50 80 00       	mov    0x805024,%eax
  80080e:	8b 50 74             	mov    0x74(%eax),%edx
  800811:	8b 45 0c             	mov    0xc(%ebp),%eax
  800814:	39 c2                	cmp    %eax,%edx
  800816:	74 14                	je     80082c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800818:	83 ec 04             	sub    $0x4,%esp
  80081b:	68 94 3c 80 00       	push   $0x803c94
  800820:	6a 26                	push   $0x26
  800822:	68 e0 3c 80 00       	push   $0x803ce0
  800827:	e8 65 ff ff ff       	call   800791 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80082c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800833:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80083a:	e9 c2 00 00 00       	jmp    800901 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	01 d0                	add    %edx,%eax
  80084e:	8b 00                	mov    (%eax),%eax
  800850:	85 c0                	test   %eax,%eax
  800852:	75 08                	jne    80085c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800854:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800857:	e9 a2 00 00 00       	jmp    8008fe <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80085c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800863:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80086a:	eb 69                	jmp    8008d5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80086c:	a1 24 50 80 00       	mov    0x805024,%eax
  800871:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800877:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80087a:	89 d0                	mov    %edx,%eax
  80087c:	01 c0                	add    %eax,%eax
  80087e:	01 d0                	add    %edx,%eax
  800880:	c1 e0 03             	shl    $0x3,%eax
  800883:	01 c8                	add    %ecx,%eax
  800885:	8a 40 04             	mov    0x4(%eax),%al
  800888:	84 c0                	test   %al,%al
  80088a:	75 46                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088c:	a1 24 50 80 00       	mov    0x805024,%eax
  800891:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800897:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80089a:	89 d0                	mov    %edx,%eax
  80089c:	01 c0                	add    %eax,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	c1 e0 03             	shl    $0x3,%eax
  8008a3:	01 c8                	add    %ecx,%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008b2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008be:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008c5:	39 c2                	cmp    %eax,%edx
  8008c7:	75 09                	jne    8008d2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008c9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008d0:	eb 12                	jmp    8008e4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d2:	ff 45 e8             	incl   -0x18(%ebp)
  8008d5:	a1 24 50 80 00       	mov    0x805024,%eax
  8008da:	8b 50 74             	mov    0x74(%eax),%edx
  8008dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008e0:	39 c2                	cmp    %eax,%edx
  8008e2:	77 88                	ja     80086c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008e8:	75 14                	jne    8008fe <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008ea:	83 ec 04             	sub    $0x4,%esp
  8008ed:	68 ec 3c 80 00       	push   $0x803cec
  8008f2:	6a 3a                	push   $0x3a
  8008f4:	68 e0 3c 80 00       	push   $0x803ce0
  8008f9:	e8 93 fe ff ff       	call   800791 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008fe:	ff 45 f0             	incl   -0x10(%ebp)
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800907:	0f 8c 32 ff ff ff    	jl     80083f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80090d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800914:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80091b:	eb 26                	jmp    800943 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80091d:	a1 24 50 80 00       	mov    0x805024,%eax
  800922:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800928:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80092b:	89 d0                	mov    %edx,%eax
  80092d:	01 c0                	add    %eax,%eax
  80092f:	01 d0                	add    %edx,%eax
  800931:	c1 e0 03             	shl    $0x3,%eax
  800934:	01 c8                	add    %ecx,%eax
  800936:	8a 40 04             	mov    0x4(%eax),%al
  800939:	3c 01                	cmp    $0x1,%al
  80093b:	75 03                	jne    800940 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80093d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800940:	ff 45 e0             	incl   -0x20(%ebp)
  800943:	a1 24 50 80 00       	mov    0x805024,%eax
  800948:	8b 50 74             	mov    0x74(%eax),%edx
  80094b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80094e:	39 c2                	cmp    %eax,%edx
  800950:	77 cb                	ja     80091d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800955:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800958:	74 14                	je     80096e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80095a:	83 ec 04             	sub    $0x4,%esp
  80095d:	68 40 3d 80 00       	push   $0x803d40
  800962:	6a 44                	push   $0x44
  800964:	68 e0 3c 80 00       	push   $0x803ce0
  800969:	e8 23 fe ff ff       	call   800791 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80096e:	90                   	nop
  80096f:	c9                   	leave  
  800970:	c3                   	ret    

00800971 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800971:	55                   	push   %ebp
  800972:	89 e5                	mov    %esp,%ebp
  800974:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	8d 48 01             	lea    0x1(%eax),%ecx
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800982:	89 0a                	mov    %ecx,(%edx)
  800984:	8b 55 08             	mov    0x8(%ebp),%edx
  800987:	88 d1                	mov    %dl,%cl
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 00                	mov    (%eax),%eax
  800995:	3d ff 00 00 00       	cmp    $0xff,%eax
  80099a:	75 2c                	jne    8009c8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80099c:	a0 28 50 80 00       	mov    0x805028,%al
  8009a1:	0f b6 c0             	movzbl %al,%eax
  8009a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a7:	8b 12                	mov    (%edx),%edx
  8009a9:	89 d1                	mov    %edx,%ecx
  8009ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ae:	83 c2 08             	add    $0x8,%edx
  8009b1:	83 ec 04             	sub    $0x4,%esp
  8009b4:	50                   	push   %eax
  8009b5:	51                   	push   %ecx
  8009b6:	52                   	push   %edx
  8009b7:	e8 0b 16 00 00       	call   801fc7 <sys_cputs>
  8009bc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cb:	8b 40 04             	mov    0x4(%eax),%eax
  8009ce:	8d 50 01             	lea    0x1(%eax),%edx
  8009d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009d7:	90                   	nop
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009ea:	00 00 00 
	b.cnt = 0;
  8009ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009f4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009f7:	ff 75 0c             	pushl  0xc(%ebp)
  8009fa:	ff 75 08             	pushl  0x8(%ebp)
  8009fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a03:	50                   	push   %eax
  800a04:	68 71 09 80 00       	push   $0x800971
  800a09:	e8 11 02 00 00       	call   800c1f <vprintfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a11:	a0 28 50 80 00       	mov    0x805028,%al
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a1f:	83 ec 04             	sub    $0x4,%esp
  800a22:	50                   	push   %eax
  800a23:	52                   	push   %edx
  800a24:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a2a:	83 c0 08             	add    $0x8,%eax
  800a2d:	50                   	push   %eax
  800a2e:	e8 94 15 00 00       	call   801fc7 <sys_cputs>
  800a33:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a36:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800a3d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a43:	c9                   	leave  
  800a44:	c3                   	ret    

00800a45 <cprintf>:

int cprintf(const char *fmt, ...) {
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a4b:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800a52:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a61:	50                   	push   %eax
  800a62:	e8 73 ff ff ff       	call   8009da <vcprintf>
  800a67:	83 c4 10             	add    $0x10,%esp
  800a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a70:	c9                   	leave  
  800a71:	c3                   	ret    

00800a72 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a78:	e8 f8 16 00 00       	call   802175 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a7d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a83:	8b 45 08             	mov    0x8(%ebp),%eax
  800a86:	83 ec 08             	sub    $0x8,%esp
  800a89:	ff 75 f4             	pushl  -0xc(%ebp)
  800a8c:	50                   	push   %eax
  800a8d:	e8 48 ff ff ff       	call   8009da <vcprintf>
  800a92:	83 c4 10             	add    $0x10,%esp
  800a95:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a98:	e8 f2 16 00 00       	call   80218f <sys_enable_interrupt>
	return cnt;
  800a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aa0:	c9                   	leave  
  800aa1:	c3                   	ret    

00800aa2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aa2:	55                   	push   %ebp
  800aa3:	89 e5                	mov    %esp,%ebp
  800aa5:	53                   	push   %ebx
  800aa6:	83 ec 14             	sub    $0x14,%esp
  800aa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800aac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aaf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800ab5:	8b 45 18             	mov    0x18(%ebp),%eax
  800ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  800abd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac0:	77 55                	ja     800b17 <printnum+0x75>
  800ac2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800ac5:	72 05                	jb     800acc <printnum+0x2a>
  800ac7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800aca:	77 4b                	ja     800b17 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800acc:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800acf:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ad2:	8b 45 18             	mov    0x18(%ebp),%eax
  800ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ada:	52                   	push   %edx
  800adb:	50                   	push   %eax
  800adc:	ff 75 f4             	pushl  -0xc(%ebp)
  800adf:	ff 75 f0             	pushl  -0x10(%ebp)
  800ae2:	e8 69 2c 00 00       	call   803750 <__udivdi3>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	83 ec 04             	sub    $0x4,%esp
  800aed:	ff 75 20             	pushl  0x20(%ebp)
  800af0:	53                   	push   %ebx
  800af1:	ff 75 18             	pushl  0x18(%ebp)
  800af4:	52                   	push   %edx
  800af5:	50                   	push   %eax
  800af6:	ff 75 0c             	pushl  0xc(%ebp)
  800af9:	ff 75 08             	pushl  0x8(%ebp)
  800afc:	e8 a1 ff ff ff       	call   800aa2 <printnum>
  800b01:	83 c4 20             	add    $0x20,%esp
  800b04:	eb 1a                	jmp    800b20 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	ff 75 20             	pushl  0x20(%ebp)
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	ff d0                	call   *%eax
  800b14:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b17:	ff 4d 1c             	decl   0x1c(%ebp)
  800b1a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b1e:	7f e6                	jg     800b06 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b20:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b23:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b2e:	53                   	push   %ebx
  800b2f:	51                   	push   %ecx
  800b30:	52                   	push   %edx
  800b31:	50                   	push   %eax
  800b32:	e8 29 2d 00 00       	call   803860 <__umoddi3>
  800b37:	83 c4 10             	add    $0x10,%esp
  800b3a:	05 b4 3f 80 00       	add    $0x803fb4,%eax
  800b3f:	8a 00                	mov    (%eax),%al
  800b41:	0f be c0             	movsbl %al,%eax
  800b44:	83 ec 08             	sub    $0x8,%esp
  800b47:	ff 75 0c             	pushl  0xc(%ebp)
  800b4a:	50                   	push   %eax
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	ff d0                	call   *%eax
  800b50:	83 c4 10             	add    $0x10,%esp
}
  800b53:	90                   	nop
  800b54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b60:	7e 1c                	jle    800b7e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	8d 50 08             	lea    0x8(%eax),%edx
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	89 10                	mov    %edx,(%eax)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	83 e8 08             	sub    $0x8,%eax
  800b77:	8b 50 04             	mov    0x4(%eax),%edx
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	eb 40                	jmp    800bbe <getuint+0x65>
	else if (lflag)
  800b7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b82:	74 1e                	je     800ba2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	8d 50 04             	lea    0x4(%eax),%edx
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 10                	mov    %edx,(%eax)
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	83 e8 04             	sub    $0x4,%eax
  800b99:	8b 00                	mov    (%eax),%eax
  800b9b:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba0:	eb 1c                	jmp    800bbe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 00                	mov    (%eax),%eax
  800ba7:	8d 50 04             	lea    0x4(%eax),%edx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	89 10                	mov    %edx,(%eax)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 00                	mov    (%eax),%eax
  800bb4:	83 e8 04             	sub    $0x4,%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bbe:	5d                   	pop    %ebp
  800bbf:	c3                   	ret    

00800bc0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bc3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bc7:	7e 1c                	jle    800be5 <getint+0x25>
		return va_arg(*ap, long long);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	8b 00                	mov    (%eax),%eax
  800bce:	8d 50 08             	lea    0x8(%eax),%edx
  800bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd4:	89 10                	mov    %edx,(%eax)
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 00                	mov    (%eax),%eax
  800bdb:	83 e8 08             	sub    $0x8,%eax
  800bde:	8b 50 04             	mov    0x4(%eax),%edx
  800be1:	8b 00                	mov    (%eax),%eax
  800be3:	eb 38                	jmp    800c1d <getint+0x5d>
	else if (lflag)
  800be5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be9:	74 1a                	je     800c05 <getint+0x45>
		return va_arg(*ap, long);
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 00                	mov    (%eax),%eax
  800bf0:	8d 50 04             	lea    0x4(%eax),%edx
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	89 10                	mov    %edx,(%eax)
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfb:	8b 00                	mov    (%eax),%eax
  800bfd:	83 e8 04             	sub    $0x4,%eax
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	99                   	cltd   
  800c03:	eb 18                	jmp    800c1d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c05:	8b 45 08             	mov    0x8(%ebp),%eax
  800c08:	8b 00                	mov    (%eax),%eax
  800c0a:	8d 50 04             	lea    0x4(%eax),%edx
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 10                	mov    %edx,(%eax)
  800c12:	8b 45 08             	mov    0x8(%ebp),%eax
  800c15:	8b 00                	mov    (%eax),%eax
  800c17:	83 e8 04             	sub    $0x4,%eax
  800c1a:	8b 00                	mov    (%eax),%eax
  800c1c:	99                   	cltd   
}
  800c1d:	5d                   	pop    %ebp
  800c1e:	c3                   	ret    

00800c1f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c27:	eb 17                	jmp    800c40 <vprintfmt+0x21>
			if (ch == '\0')
  800c29:	85 db                	test   %ebx,%ebx
  800c2b:	0f 84 af 03 00 00    	je     800fe0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c31:	83 ec 08             	sub    $0x8,%esp
  800c34:	ff 75 0c             	pushl  0xc(%ebp)
  800c37:	53                   	push   %ebx
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	ff d0                	call   *%eax
  800c3d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c40:	8b 45 10             	mov    0x10(%ebp),%eax
  800c43:	8d 50 01             	lea    0x1(%eax),%edx
  800c46:	89 55 10             	mov    %edx,0x10(%ebp)
  800c49:	8a 00                	mov    (%eax),%al
  800c4b:	0f b6 d8             	movzbl %al,%ebx
  800c4e:	83 fb 25             	cmp    $0x25,%ebx
  800c51:	75 d6                	jne    800c29 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c53:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c65:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c6c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c73:	8b 45 10             	mov    0x10(%ebp),%eax
  800c76:	8d 50 01             	lea    0x1(%eax),%edx
  800c79:	89 55 10             	mov    %edx,0x10(%ebp)
  800c7c:	8a 00                	mov    (%eax),%al
  800c7e:	0f b6 d8             	movzbl %al,%ebx
  800c81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c84:	83 f8 55             	cmp    $0x55,%eax
  800c87:	0f 87 2b 03 00 00    	ja     800fb8 <vprintfmt+0x399>
  800c8d:	8b 04 85 d8 3f 80 00 	mov    0x803fd8(,%eax,4),%eax
  800c94:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c9a:	eb d7                	jmp    800c73 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800ca0:	eb d1                	jmp    800c73 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ca2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ca9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	c1 e0 02             	shl    $0x2,%eax
  800cb1:	01 d0                	add    %edx,%eax
  800cb3:	01 c0                	add    %eax,%eax
  800cb5:	01 d8                	add    %ebx,%eax
  800cb7:	83 e8 30             	sub    $0x30,%eax
  800cba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc0:	8a 00                	mov    (%eax),%al
  800cc2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800cc5:	83 fb 2f             	cmp    $0x2f,%ebx
  800cc8:	7e 3e                	jle    800d08 <vprintfmt+0xe9>
  800cca:	83 fb 39             	cmp    $0x39,%ebx
  800ccd:	7f 39                	jg     800d08 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ccf:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cd2:	eb d5                	jmp    800ca9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd7:	83 c0 04             	add    $0x4,%eax
  800cda:	89 45 14             	mov    %eax,0x14(%ebp)
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	83 e8 04             	sub    $0x4,%eax
  800ce3:	8b 00                	mov    (%eax),%eax
  800ce5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ce8:	eb 1f                	jmp    800d09 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cee:	79 83                	jns    800c73 <vprintfmt+0x54>
				width = 0;
  800cf0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cf7:	e9 77 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cfc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d03:	e9 6b ff ff ff       	jmp    800c73 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d08:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d0d:	0f 89 60 ff ff ff    	jns    800c73 <vprintfmt+0x54>
				width = precision, precision = -1;
  800d13:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d19:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d20:	e9 4e ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d25:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d28:	e9 46 ff ff ff       	jmp    800c73 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d30:	83 c0 04             	add    $0x4,%eax
  800d33:	89 45 14             	mov    %eax,0x14(%ebp)
  800d36:	8b 45 14             	mov    0x14(%ebp),%eax
  800d39:	83 e8 04             	sub    $0x4,%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	83 ec 08             	sub    $0x8,%esp
  800d41:	ff 75 0c             	pushl  0xc(%ebp)
  800d44:	50                   	push   %eax
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			break;
  800d4d:	e9 89 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d52:	8b 45 14             	mov    0x14(%ebp),%eax
  800d55:	83 c0 04             	add    $0x4,%eax
  800d58:	89 45 14             	mov    %eax,0x14(%ebp)
  800d5b:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5e:	83 e8 04             	sub    $0x4,%eax
  800d61:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d63:	85 db                	test   %ebx,%ebx
  800d65:	79 02                	jns    800d69 <vprintfmt+0x14a>
				err = -err;
  800d67:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d69:	83 fb 64             	cmp    $0x64,%ebx
  800d6c:	7f 0b                	jg     800d79 <vprintfmt+0x15a>
  800d6e:	8b 34 9d 20 3e 80 00 	mov    0x803e20(,%ebx,4),%esi
  800d75:	85 f6                	test   %esi,%esi
  800d77:	75 19                	jne    800d92 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d79:	53                   	push   %ebx
  800d7a:	68 c5 3f 80 00       	push   $0x803fc5
  800d7f:	ff 75 0c             	pushl  0xc(%ebp)
  800d82:	ff 75 08             	pushl  0x8(%ebp)
  800d85:	e8 5e 02 00 00       	call   800fe8 <printfmt>
  800d8a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d8d:	e9 49 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d92:	56                   	push   %esi
  800d93:	68 ce 3f 80 00       	push   $0x803fce
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	ff 75 08             	pushl  0x8(%ebp)
  800d9e:	e8 45 02 00 00       	call   800fe8 <printfmt>
  800da3:	83 c4 10             	add    $0x10,%esp
			break;
  800da6:	e9 30 02 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800dab:	8b 45 14             	mov    0x14(%ebp),%eax
  800dae:	83 c0 04             	add    $0x4,%eax
  800db1:	89 45 14             	mov    %eax,0x14(%ebp)
  800db4:	8b 45 14             	mov    0x14(%ebp),%eax
  800db7:	83 e8 04             	sub    $0x4,%eax
  800dba:	8b 30                	mov    (%eax),%esi
  800dbc:	85 f6                	test   %esi,%esi
  800dbe:	75 05                	jne    800dc5 <vprintfmt+0x1a6>
				p = "(null)";
  800dc0:	be d1 3f 80 00       	mov    $0x803fd1,%esi
			if (width > 0 && padc != '-')
  800dc5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc9:	7e 6d                	jle    800e38 <vprintfmt+0x219>
  800dcb:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dcf:	74 67                	je     800e38 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dd4:	83 ec 08             	sub    $0x8,%esp
  800dd7:	50                   	push   %eax
  800dd8:	56                   	push   %esi
  800dd9:	e8 12 05 00 00       	call   8012f0 <strnlen>
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800de4:	eb 16                	jmp    800dfc <vprintfmt+0x1dd>
					putch(padc, putdat);
  800de6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800dea:	83 ec 08             	sub    $0x8,%esp
  800ded:	ff 75 0c             	pushl  0xc(%ebp)
  800df0:	50                   	push   %eax
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	ff d0                	call   *%eax
  800df6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800df9:	ff 4d e4             	decl   -0x1c(%ebp)
  800dfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e00:	7f e4                	jg     800de6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e02:	eb 34                	jmp    800e38 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e04:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e08:	74 1c                	je     800e26 <vprintfmt+0x207>
  800e0a:	83 fb 1f             	cmp    $0x1f,%ebx
  800e0d:	7e 05                	jle    800e14 <vprintfmt+0x1f5>
  800e0f:	83 fb 7e             	cmp    $0x7e,%ebx
  800e12:	7e 12                	jle    800e26 <vprintfmt+0x207>
					putch('?', putdat);
  800e14:	83 ec 08             	sub    $0x8,%esp
  800e17:	ff 75 0c             	pushl  0xc(%ebp)
  800e1a:	6a 3f                	push   $0x3f
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	ff d0                	call   *%eax
  800e21:	83 c4 10             	add    $0x10,%esp
  800e24:	eb 0f                	jmp    800e35 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e26:	83 ec 08             	sub    $0x8,%esp
  800e29:	ff 75 0c             	pushl  0xc(%ebp)
  800e2c:	53                   	push   %ebx
  800e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e30:	ff d0                	call   *%eax
  800e32:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e35:	ff 4d e4             	decl   -0x1c(%ebp)
  800e38:	89 f0                	mov    %esi,%eax
  800e3a:	8d 70 01             	lea    0x1(%eax),%esi
  800e3d:	8a 00                	mov    (%eax),%al
  800e3f:	0f be d8             	movsbl %al,%ebx
  800e42:	85 db                	test   %ebx,%ebx
  800e44:	74 24                	je     800e6a <vprintfmt+0x24b>
  800e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e4a:	78 b8                	js     800e04 <vprintfmt+0x1e5>
  800e4c:	ff 4d e0             	decl   -0x20(%ebp)
  800e4f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e53:	79 af                	jns    800e04 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e55:	eb 13                	jmp    800e6a <vprintfmt+0x24b>
				putch(' ', putdat);
  800e57:	83 ec 08             	sub    $0x8,%esp
  800e5a:	ff 75 0c             	pushl  0xc(%ebp)
  800e5d:	6a 20                	push   $0x20
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	ff d0                	call   *%eax
  800e64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e67:	ff 4d e4             	decl   -0x1c(%ebp)
  800e6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6e:	7f e7                	jg     800e57 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e70:	e9 66 01 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e75:	83 ec 08             	sub    $0x8,%esp
  800e78:	ff 75 e8             	pushl  -0x18(%ebp)
  800e7b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e7e:	50                   	push   %eax
  800e7f:	e8 3c fd ff ff       	call   800bc0 <getint>
  800e84:	83 c4 10             	add    $0x10,%esp
  800e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e93:	85 d2                	test   %edx,%edx
  800e95:	79 23                	jns    800eba <vprintfmt+0x29b>
				putch('-', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 2d                	push   $0x2d
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ead:	f7 d8                	neg    %eax
  800eaf:	83 d2 00             	adc    $0x0,%edx
  800eb2:	f7 da                	neg    %edx
  800eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800eba:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ec1:	e9 bc 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ec6:	83 ec 08             	sub    $0x8,%esp
  800ec9:	ff 75 e8             	pushl  -0x18(%ebp)
  800ecc:	8d 45 14             	lea    0x14(%ebp),%eax
  800ecf:	50                   	push   %eax
  800ed0:	e8 84 fc ff ff       	call   800b59 <getuint>
  800ed5:	83 c4 10             	add    $0x10,%esp
  800ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800edb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ede:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ee5:	e9 98 00 00 00       	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eea:	83 ec 08             	sub    $0x8,%esp
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	6a 58                	push   $0x58
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	ff d0                	call   *%eax
  800ef7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800efa:	83 ec 08             	sub    $0x8,%esp
  800efd:	ff 75 0c             	pushl  0xc(%ebp)
  800f00:	6a 58                	push   $0x58
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	ff d0                	call   *%eax
  800f07:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 0c             	pushl  0xc(%ebp)
  800f10:	6a 58                	push   $0x58
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	ff d0                	call   *%eax
  800f17:	83 c4 10             	add    $0x10,%esp
			break;
  800f1a:	e9 bc 00 00 00       	jmp    800fdb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f1f:	83 ec 08             	sub    $0x8,%esp
  800f22:	ff 75 0c             	pushl  0xc(%ebp)
  800f25:	6a 30                	push   $0x30
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	ff d0                	call   *%eax
  800f2c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f2f:	83 ec 08             	sub    $0x8,%esp
  800f32:	ff 75 0c             	pushl  0xc(%ebp)
  800f35:	6a 78                	push   $0x78
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f42:	83 c0 04             	add    $0x4,%eax
  800f45:	89 45 14             	mov    %eax,0x14(%ebp)
  800f48:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4b:	83 e8 04             	sub    $0x4,%eax
  800f4e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f5a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f61:	eb 1f                	jmp    800f82 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 e8             	pushl  -0x18(%ebp)
  800f69:	8d 45 14             	lea    0x14(%ebp),%eax
  800f6c:	50                   	push   %eax
  800f6d:	e8 e7 fb ff ff       	call   800b59 <getuint>
  800f72:	83 c4 10             	add    $0x10,%esp
  800f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f78:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f82:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f89:	83 ec 04             	sub    $0x4,%esp
  800f8c:	52                   	push   %edx
  800f8d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f90:	50                   	push   %eax
  800f91:	ff 75 f4             	pushl  -0xc(%ebp)
  800f94:	ff 75 f0             	pushl  -0x10(%ebp)
  800f97:	ff 75 0c             	pushl  0xc(%ebp)
  800f9a:	ff 75 08             	pushl  0x8(%ebp)
  800f9d:	e8 00 fb ff ff       	call   800aa2 <printnum>
  800fa2:	83 c4 20             	add    $0x20,%esp
			break;
  800fa5:	eb 34                	jmp    800fdb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fa7:	83 ec 08             	sub    $0x8,%esp
  800faa:	ff 75 0c             	pushl  0xc(%ebp)
  800fad:	53                   	push   %ebx
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	ff d0                	call   *%eax
  800fb3:	83 c4 10             	add    $0x10,%esp
			break;
  800fb6:	eb 23                	jmp    800fdb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fb8:	83 ec 08             	sub    $0x8,%esp
  800fbb:	ff 75 0c             	pushl  0xc(%ebp)
  800fbe:	6a 25                	push   $0x25
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	ff d0                	call   *%eax
  800fc5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fc8:	ff 4d 10             	decl   0x10(%ebp)
  800fcb:	eb 03                	jmp    800fd0 <vprintfmt+0x3b1>
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	48                   	dec    %eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 25                	cmp    $0x25,%al
  800fd8:	75 f3                	jne    800fcd <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fda:	90                   	nop
		}
	}
  800fdb:	e9 47 fc ff ff       	jmp    800c27 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fe0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fe1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    

00800fe8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fe8:	55                   	push   %ebp
  800fe9:	89 e5                	mov    %esp,%ebp
  800feb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fee:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff1:	83 c0 04             	add    $0x4,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	ff 75 08             	pushl  0x8(%ebp)
  801004:	e8 16 fc ff ff       	call   800c1f <vprintfmt>
  801009:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80100c:	90                   	nop
  80100d:	c9                   	leave  
  80100e:	c3                   	ret    

0080100f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801012:	8b 45 0c             	mov    0xc(%ebp),%eax
  801015:	8b 40 08             	mov    0x8(%eax),%eax
  801018:	8d 50 01             	lea    0x1(%eax),%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801021:	8b 45 0c             	mov    0xc(%ebp),%eax
  801024:	8b 10                	mov    (%eax),%edx
  801026:	8b 45 0c             	mov    0xc(%ebp),%eax
  801029:	8b 40 04             	mov    0x4(%eax),%eax
  80102c:	39 c2                	cmp    %eax,%edx
  80102e:	73 12                	jae    801042 <sprintputch+0x33>
		*b->buf++ = ch;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 00                	mov    (%eax),%eax
  801035:	8d 48 01             	lea    0x1(%eax),%ecx
  801038:	8b 55 0c             	mov    0xc(%ebp),%edx
  80103b:	89 0a                	mov    %ecx,(%edx)
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	88 10                	mov    %dl,(%eax)
}
  801042:	90                   	nop
  801043:	5d                   	pop    %ebp
  801044:	c3                   	ret    

00801045 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801045:	55                   	push   %ebp
  801046:	89 e5                	mov    %esp,%ebp
  801048:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801051:	8b 45 0c             	mov    0xc(%ebp),%eax
  801054:	8d 50 ff             	lea    -0x1(%eax),%edx
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	01 d0                	add    %edx,%eax
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801066:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106a:	74 06                	je     801072 <vsnprintf+0x2d>
  80106c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801070:	7f 07                	jg     801079 <vsnprintf+0x34>
		return -E_INVAL;
  801072:	b8 03 00 00 00       	mov    $0x3,%eax
  801077:	eb 20                	jmp    801099 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801079:	ff 75 14             	pushl  0x14(%ebp)
  80107c:	ff 75 10             	pushl  0x10(%ebp)
  80107f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801082:	50                   	push   %eax
  801083:	68 0f 10 80 00       	push   $0x80100f
  801088:	e8 92 fb ff ff       	call   800c1f <vprintfmt>
  80108d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801093:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801096:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8010b0:	50                   	push   %eax
  8010b1:	ff 75 0c             	pushl  0xc(%ebp)
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 89 ff ff ff       	call   801045 <vsnprintf>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010c5:	c9                   	leave  
  8010c6:	c3                   	ret    

008010c7 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8010cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010d1:	74 13                	je     8010e6 <readline+0x1f>
		cprintf("%s", prompt);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 08             	pushl  0x8(%ebp)
  8010d9:	68 30 41 80 00       	push   $0x804130
  8010de:	e8 62 f9 ff ff       	call   800a45 <cprintf>
  8010e3:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8010e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8010ed:	83 ec 0c             	sub    $0xc,%esp
  8010f0:	6a 00                	push   $0x0
  8010f2:	e8 54 f5 ff ff       	call   80064b <iscons>
  8010f7:	83 c4 10             	add    $0x10,%esp
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  8010fd:	e8 fb f4 ff ff       	call   8005fd <getchar>
  801102:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801109:	79 22                	jns    80112d <readline+0x66>
			if (c != -E_EOF)
  80110b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80110f:	0f 84 ad 00 00 00    	je     8011c2 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801115:	83 ec 08             	sub    $0x8,%esp
  801118:	ff 75 ec             	pushl  -0x14(%ebp)
  80111b:	68 33 41 80 00       	push   $0x804133
  801120:	e8 20 f9 ff ff       	call   800a45 <cprintf>
  801125:	83 c4 10             	add    $0x10,%esp
			return;
  801128:	e9 95 00 00 00       	jmp    8011c2 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80112d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801131:	7e 34                	jle    801167 <readline+0xa0>
  801133:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80113a:	7f 2b                	jg     801167 <readline+0xa0>
			if (echoing)
  80113c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801140:	74 0e                	je     801150 <readline+0x89>
				cputchar(c);
  801142:	83 ec 0c             	sub    $0xc,%esp
  801145:	ff 75 ec             	pushl  -0x14(%ebp)
  801148:	e8 68 f4 ff ff       	call   8005b5 <cputchar>
  80114d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801153:	8d 50 01             	lea    0x1(%eax),%edx
  801156:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801159:	89 c2                	mov    %eax,%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801163:	88 10                	mov    %dl,(%eax)
  801165:	eb 56                	jmp    8011bd <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801167:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80116b:	75 1f                	jne    80118c <readline+0xc5>
  80116d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801171:	7e 19                	jle    80118c <readline+0xc5>
			if (echoing)
  801173:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801177:	74 0e                	je     801187 <readline+0xc0>
				cputchar(c);
  801179:	83 ec 0c             	sub    $0xc,%esp
  80117c:	ff 75 ec             	pushl  -0x14(%ebp)
  80117f:	e8 31 f4 ff ff       	call   8005b5 <cputchar>
  801184:	83 c4 10             	add    $0x10,%esp

			i--;
  801187:	ff 4d f4             	decl   -0xc(%ebp)
  80118a:	eb 31                	jmp    8011bd <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80118c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801190:	74 0a                	je     80119c <readline+0xd5>
  801192:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801196:	0f 85 61 ff ff ff    	jne    8010fd <readline+0x36>
			if (echoing)
  80119c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011a0:	74 0e                	je     8011b0 <readline+0xe9>
				cputchar(c);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8011a8:	e8 08 f4 ff ff       	call   8005b5 <cputchar>
  8011ad:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8011bb:	eb 06                	jmp    8011c3 <readline+0xfc>
		}
	}
  8011bd:	e9 3b ff ff ff       	jmp    8010fd <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8011c2:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011cb:	e8 a5 0f 00 00       	call   802175 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8011d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011d4:	74 13                	je     8011e9 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8011d6:	83 ec 08             	sub    $0x8,%esp
  8011d9:	ff 75 08             	pushl  0x8(%ebp)
  8011dc:	68 30 41 80 00       	push   $0x804130
  8011e1:	e8 5f f8 ff ff       	call   800a45 <cprintf>
  8011e6:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f0:	83 ec 0c             	sub    $0xc,%esp
  8011f3:	6a 00                	push   $0x0
  8011f5:	e8 51 f4 ff ff       	call   80064b <iscons>
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801200:	e8 f8 f3 ff ff       	call   8005fd <getchar>
  801205:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801208:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80120c:	79 23                	jns    801231 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80120e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801212:	74 13                	je     801227 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801214:	83 ec 08             	sub    $0x8,%esp
  801217:	ff 75 ec             	pushl  -0x14(%ebp)
  80121a:	68 33 41 80 00       	push   $0x804133
  80121f:	e8 21 f8 ff ff       	call   800a45 <cprintf>
  801224:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801227:	e8 63 0f 00 00       	call   80218f <sys_enable_interrupt>
			return;
  80122c:	e9 9a 00 00 00       	jmp    8012cb <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801231:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801235:	7e 34                	jle    80126b <atomic_readline+0xa6>
  801237:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80123e:	7f 2b                	jg     80126b <atomic_readline+0xa6>
			if (echoing)
  801240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801244:	74 0e                	je     801254 <atomic_readline+0x8f>
				cputchar(c);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	ff 75 ec             	pushl  -0x14(%ebp)
  80124c:	e8 64 f3 ff ff       	call   8005b5 <cputchar>
  801251:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801257:	8d 50 01             	lea    0x1(%eax),%edx
  80125a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80125d:	89 c2                	mov    %eax,%edx
  80125f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801262:	01 d0                	add    %edx,%eax
  801264:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801267:	88 10                	mov    %dl,(%eax)
  801269:	eb 5b                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80126b:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80126f:	75 1f                	jne    801290 <atomic_readline+0xcb>
  801271:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801275:	7e 19                	jle    801290 <atomic_readline+0xcb>
			if (echoing)
  801277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80127b:	74 0e                	je     80128b <atomic_readline+0xc6>
				cputchar(c);
  80127d:	83 ec 0c             	sub    $0xc,%esp
  801280:	ff 75 ec             	pushl  -0x14(%ebp)
  801283:	e8 2d f3 ff ff       	call   8005b5 <cputchar>
  801288:	83 c4 10             	add    $0x10,%esp
			i--;
  80128b:	ff 4d f4             	decl   -0xc(%ebp)
  80128e:	eb 36                	jmp    8012c6 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801290:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801294:	74 0a                	je     8012a0 <atomic_readline+0xdb>
  801296:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80129a:	0f 85 60 ff ff ff    	jne    801200 <atomic_readline+0x3b>
			if (echoing)
  8012a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012a4:	74 0e                	je     8012b4 <atomic_readline+0xef>
				cputchar(c);
  8012a6:	83 ec 0c             	sub    $0xc,%esp
  8012a9:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ac:	e8 04 f3 ff ff       	call   8005b5 <cputchar>
  8012b1:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8012b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8012bf:	e8 cb 0e 00 00       	call   80218f <sys_enable_interrupt>
			return;
  8012c4:	eb 05                	jmp    8012cb <atomic_readline+0x106>
		}
	}
  8012c6:	e9 35 ff ff ff       	jmp    801200 <atomic_readline+0x3b>
}
  8012cb:	c9                   	leave  
  8012cc:	c3                   	ret    

008012cd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8012d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012da:	eb 06                	jmp    8012e2 <strlen+0x15>
		n++;
  8012dc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8012df:	ff 45 08             	incl   0x8(%ebp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	75 f1                	jne    8012dc <strlen+0xf>
		n++;
	return n;
  8012eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8012f6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012fd:	eb 09                	jmp    801308 <strnlen+0x18>
		n++;
  8012ff:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801302:	ff 45 08             	incl   0x8(%ebp)
  801305:	ff 4d 0c             	decl   0xc(%ebp)
  801308:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130c:	74 09                	je     801317 <strnlen+0x27>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	75 e8                	jne    8012ff <strnlen+0xf>
		n++;
	return n;
  801317:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80131a:	c9                   	leave  
  80131b:	c3                   	ret    

0080131c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80131c:	55                   	push   %ebp
  80131d:	89 e5                	mov    %esp,%ebp
  80131f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801328:	90                   	nop
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 08             	mov    %edx,0x8(%ebp)
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	8d 4a 01             	lea    0x1(%edx),%ecx
  801338:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80133b:	8a 12                	mov    (%edx),%dl
  80133d:	88 10                	mov    %dl,(%eax)
  80133f:	8a 00                	mov    (%eax),%al
  801341:	84 c0                	test   %al,%al
  801343:	75 e4                	jne    801329 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801356:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80135d:	eb 1f                	jmp    80137e <strncpy+0x34>
		*dst++ = *src;
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8d 50 01             	lea    0x1(%eax),%edx
  801365:	89 55 08             	mov    %edx,0x8(%ebp)
  801368:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136b:	8a 12                	mov    (%edx),%dl
  80136d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80136f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801372:	8a 00                	mov    (%eax),%al
  801374:	84 c0                	test   %al,%al
  801376:	74 03                	je     80137b <strncpy+0x31>
			src++;
  801378:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80137b:	ff 45 fc             	incl   -0x4(%ebp)
  80137e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801381:	3b 45 10             	cmp    0x10(%ebp),%eax
  801384:	72 d9                	jb     80135f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801397:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139b:	74 30                	je     8013cd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80139d:	eb 16                	jmp    8013b5 <strlcpy+0x2a>
			*dst++ = *src++;
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8d 50 01             	lea    0x1(%eax),%edx
  8013a5:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ab:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013b1:	8a 12                	mov    (%edx),%dl
  8013b3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013b5:	ff 4d 10             	decl   0x10(%ebp)
  8013b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013bc:	74 09                	je     8013c7 <strlcpy+0x3c>
  8013be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	84 c0                	test   %al,%al
  8013c5:	75 d8                	jne    80139f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8013cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d3:	29 c2                	sub    %eax,%edx
  8013d5:	89 d0                	mov    %edx,%eax
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8013dc:	eb 06                	jmp    8013e4 <strcmp+0xb>
		p++, q++;
  8013de:	ff 45 08             	incl   0x8(%ebp)
  8013e1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8013e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e7:	8a 00                	mov    (%eax),%al
  8013e9:	84 c0                	test   %al,%al
  8013eb:	74 0e                	je     8013fb <strcmp+0x22>
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 10                	mov    (%eax),%dl
  8013f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	38 c2                	cmp    %al,%dl
  8013f9:	74 e3                	je     8013de <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f b6 d0             	movzbl %al,%edx
  801403:	8b 45 0c             	mov    0xc(%ebp),%eax
  801406:	8a 00                	mov    (%eax),%al
  801408:	0f b6 c0             	movzbl %al,%eax
  80140b:	29 c2                	sub    %eax,%edx
  80140d:	89 d0                	mov    %edx,%eax
}
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801414:	eb 09                	jmp    80141f <strncmp+0xe>
		n--, p++, q++;
  801416:	ff 4d 10             	decl   0x10(%ebp)
  801419:	ff 45 08             	incl   0x8(%ebp)
  80141c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80141f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801423:	74 17                	je     80143c <strncmp+0x2b>
  801425:	8b 45 08             	mov    0x8(%ebp),%eax
  801428:	8a 00                	mov    (%eax),%al
  80142a:	84 c0                	test   %al,%al
  80142c:	74 0e                	je     80143c <strncmp+0x2b>
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	8a 10                	mov    (%eax),%dl
  801433:	8b 45 0c             	mov    0xc(%ebp),%eax
  801436:	8a 00                	mov    (%eax),%al
  801438:	38 c2                	cmp    %al,%dl
  80143a:	74 da                	je     801416 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80143c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801440:	75 07                	jne    801449 <strncmp+0x38>
		return 0;
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
  801447:	eb 14                	jmp    80145d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	0f b6 d0             	movzbl %al,%edx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	0f b6 c0             	movzbl %al,%eax
  801459:	29 c2                	sub    %eax,%edx
  80145b:	89 d0                	mov    %edx,%eax
}
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    

0080145f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80145f:	55                   	push   %ebp
  801460:	89 e5                	mov    %esp,%ebp
  801462:	83 ec 04             	sub    $0x4,%esp
  801465:	8b 45 0c             	mov    0xc(%ebp),%eax
  801468:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80146b:	eb 12                	jmp    80147f <strchr+0x20>
		if (*s == c)
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801475:	75 05                	jne    80147c <strchr+0x1d>
			return (char *) s;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	eb 11                	jmp    80148d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80147c:	ff 45 08             	incl   0x8(%ebp)
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	84 c0                	test   %al,%al
  801486:	75 e5                	jne    80146d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 04             	sub    $0x4,%esp
  801495:	8b 45 0c             	mov    0xc(%ebp),%eax
  801498:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80149b:	eb 0d                	jmp    8014aa <strfind+0x1b>
		if (*s == c)
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	8a 00                	mov    (%eax),%al
  8014a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014a5:	74 0e                	je     8014b5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014a7:	ff 45 08             	incl   0x8(%ebp)
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	84 c0                	test   %al,%al
  8014b1:	75 ea                	jne    80149d <strfind+0xe>
  8014b3:	eb 01                	jmp    8014b6 <strfind+0x27>
		if (*s == c)
			break;
  8014b5:	90                   	nop
	return (char *) s;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8014c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8014c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ca:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8014cd:	eb 0e                	jmp    8014dd <memset+0x22>
		*p++ = c;
  8014cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8014dd:	ff 4d f8             	decl   -0x8(%ebp)
  8014e0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8014e4:	79 e9                	jns    8014cf <memset+0x14>
		*p++ = c;

	return v;
  8014e6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8014fd:	eb 16                	jmp    801515 <memcpy+0x2a>
		*d++ = *s++;
  8014ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801502:	8d 50 01             	lea    0x1(%eax),%edx
  801505:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801508:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80150e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801511:	8a 12                	mov    (%edx),%dl
  801513:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	8d 50 ff             	lea    -0x1(%eax),%edx
  80151b:	89 55 10             	mov    %edx,0x10(%ebp)
  80151e:	85 c0                	test   %eax,%eax
  801520:	75 dd                	jne    8014ff <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80152d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801530:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801539:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80153f:	73 50                	jae    801591 <memmove+0x6a>
  801541:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801544:	8b 45 10             	mov    0x10(%ebp),%eax
  801547:	01 d0                	add    %edx,%eax
  801549:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80154c:	76 43                	jbe    801591 <memmove+0x6a>
		s += n;
  80154e:	8b 45 10             	mov    0x10(%ebp),%eax
  801551:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801554:	8b 45 10             	mov    0x10(%ebp),%eax
  801557:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80155a:	eb 10                	jmp    80156c <memmove+0x45>
			*--d = *--s;
  80155c:	ff 4d f8             	decl   -0x8(%ebp)
  80155f:	ff 4d fc             	decl   -0x4(%ebp)
  801562:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801565:	8a 10                	mov    (%eax),%dl
  801567:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80156c:	8b 45 10             	mov    0x10(%ebp),%eax
  80156f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801572:	89 55 10             	mov    %edx,0x10(%ebp)
  801575:	85 c0                	test   %eax,%eax
  801577:	75 e3                	jne    80155c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801579:	eb 23                	jmp    80159e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80157b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157e:	8d 50 01             	lea    0x1(%eax),%edx
  801581:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801584:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801587:	8d 4a 01             	lea    0x1(%edx),%ecx
  80158a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80158d:	8a 12                	mov    (%edx),%dl
  80158f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801591:	8b 45 10             	mov    0x10(%ebp),%eax
  801594:	8d 50 ff             	lea    -0x1(%eax),%edx
  801597:	89 55 10             	mov    %edx,0x10(%ebp)
  80159a:	85 c0                	test   %eax,%eax
  80159c:	75 dd                	jne    80157b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8015af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8015b5:	eb 2a                	jmp    8015e1 <memcmp+0x3e>
		if (*s1 != *s2)
  8015b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ba:	8a 10                	mov    (%eax),%dl
  8015bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015bf:	8a 00                	mov    (%eax),%al
  8015c1:	38 c2                	cmp    %al,%dl
  8015c3:	74 16                	je     8015db <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8015c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	0f b6 d0             	movzbl %al,%edx
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	0f b6 c0             	movzbl %al,%eax
  8015d5:	29 c2                	sub    %eax,%edx
  8015d7:	89 d0                	mov    %edx,%eax
  8015d9:	eb 18                	jmp    8015f3 <memcmp+0x50>
		s1++, s2++;
  8015db:	ff 45 fc             	incl   -0x4(%ebp)
  8015de:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8015e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8015ea:	85 c0                	test   %eax,%eax
  8015ec:	75 c9                	jne    8015b7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8015fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801601:	01 d0                	add    %edx,%eax
  801603:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801606:	eb 15                	jmp    80161d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	8a 00                	mov    (%eax),%al
  80160d:	0f b6 d0             	movzbl %al,%edx
  801610:	8b 45 0c             	mov    0xc(%ebp),%eax
  801613:	0f b6 c0             	movzbl %al,%eax
  801616:	39 c2                	cmp    %eax,%edx
  801618:	74 0d                	je     801627 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80161a:	ff 45 08             	incl   0x8(%ebp)
  80161d:	8b 45 08             	mov    0x8(%ebp),%eax
  801620:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801623:	72 e3                	jb     801608 <memfind+0x13>
  801625:	eb 01                	jmp    801628 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801627:	90                   	nop
	return (void *) s;
  801628:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801633:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80163a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801641:	eb 03                	jmp    801646 <strtol+0x19>
		s++;
  801643:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801646:	8b 45 08             	mov    0x8(%ebp),%eax
  801649:	8a 00                	mov    (%eax),%al
  80164b:	3c 20                	cmp    $0x20,%al
  80164d:	74 f4                	je     801643 <strtol+0x16>
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8a 00                	mov    (%eax),%al
  801654:	3c 09                	cmp    $0x9,%al
  801656:	74 eb                	je     801643 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	8a 00                	mov    (%eax),%al
  80165d:	3c 2b                	cmp    $0x2b,%al
  80165f:	75 05                	jne    801666 <strtol+0x39>
		s++;
  801661:	ff 45 08             	incl   0x8(%ebp)
  801664:	eb 13                	jmp    801679 <strtol+0x4c>
	else if (*s == '-')
  801666:	8b 45 08             	mov    0x8(%ebp),%eax
  801669:	8a 00                	mov    (%eax),%al
  80166b:	3c 2d                	cmp    $0x2d,%al
  80166d:	75 0a                	jne    801679 <strtol+0x4c>
		s++, neg = 1;
  80166f:	ff 45 08             	incl   0x8(%ebp)
  801672:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801679:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80167d:	74 06                	je     801685 <strtol+0x58>
  80167f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801683:	75 20                	jne    8016a5 <strtol+0x78>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	3c 30                	cmp    $0x30,%al
  80168c:	75 17                	jne    8016a5 <strtol+0x78>
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	40                   	inc    %eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 78                	cmp    $0x78,%al
  801696:	75 0d                	jne    8016a5 <strtol+0x78>
		s += 2, base = 16;
  801698:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80169c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8016a3:	eb 28                	jmp    8016cd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8016a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016a9:	75 15                	jne    8016c0 <strtol+0x93>
  8016ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ae:	8a 00                	mov    (%eax),%al
  8016b0:	3c 30                	cmp    $0x30,%al
  8016b2:	75 0c                	jne    8016c0 <strtol+0x93>
		s++, base = 8;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
  8016b7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8016be:	eb 0d                	jmp    8016cd <strtol+0xa0>
	else if (base == 0)
  8016c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016c4:	75 07                	jne    8016cd <strtol+0xa0>
		base = 10;
  8016c6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d0:	8a 00                	mov    (%eax),%al
  8016d2:	3c 2f                	cmp    $0x2f,%al
  8016d4:	7e 19                	jle    8016ef <strtol+0xc2>
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8a 00                	mov    (%eax),%al
  8016db:	3c 39                	cmp    $0x39,%al
  8016dd:	7f 10                	jg     8016ef <strtol+0xc2>
			dig = *s - '0';
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8a 00                	mov    (%eax),%al
  8016e4:	0f be c0             	movsbl %al,%eax
  8016e7:	83 e8 30             	sub    $0x30,%eax
  8016ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016ed:	eb 42                	jmp    801731 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	8a 00                	mov    (%eax),%al
  8016f4:	3c 60                	cmp    $0x60,%al
  8016f6:	7e 19                	jle    801711 <strtol+0xe4>
  8016f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fb:	8a 00                	mov    (%eax),%al
  8016fd:	3c 7a                	cmp    $0x7a,%al
  8016ff:	7f 10                	jg     801711 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8a 00                	mov    (%eax),%al
  801706:	0f be c0             	movsbl %al,%eax
  801709:	83 e8 57             	sub    $0x57,%eax
  80170c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80170f:	eb 20                	jmp    801731 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8a 00                	mov    (%eax),%al
  801716:	3c 40                	cmp    $0x40,%al
  801718:	7e 39                	jle    801753 <strtol+0x126>
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3c 5a                	cmp    $0x5a,%al
  801721:	7f 30                	jg     801753 <strtol+0x126>
			dig = *s - 'A' + 10;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	0f be c0             	movsbl %al,%eax
  80172b:	83 e8 37             	sub    $0x37,%eax
  80172e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801734:	3b 45 10             	cmp    0x10(%ebp),%eax
  801737:	7d 19                	jge    801752 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801739:	ff 45 08             	incl   0x8(%ebp)
  80173c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80173f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801743:	89 c2                	mov    %eax,%edx
  801745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801748:	01 d0                	add    %edx,%eax
  80174a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80174d:	e9 7b ff ff ff       	jmp    8016cd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801752:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801753:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801757:	74 08                	je     801761 <strtol+0x134>
		*endptr = (char *) s;
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175c:	8b 55 08             	mov    0x8(%ebp),%edx
  80175f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801761:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801765:	74 07                	je     80176e <strtol+0x141>
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	f7 d8                	neg    %eax
  80176c:	eb 03                	jmp    801771 <strtol+0x144>
  80176e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <ltostr>:

void
ltostr(long value, char *str)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801787:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80178b:	79 13                	jns    8017a0 <ltostr+0x2d>
	{
		neg = 1;
  80178d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80179a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80179d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8017a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8017a8:	99                   	cltd   
  8017a9:	f7 f9                	idiv   %ecx
  8017ab:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8017ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b1:	8d 50 01             	lea    0x1(%eax),%edx
  8017b4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8017c1:	83 c2 30             	add    $0x30,%edx
  8017c4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8017c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017ce:	f7 e9                	imul   %ecx
  8017d0:	c1 fa 02             	sar    $0x2,%edx
  8017d3:	89 c8                	mov    %ecx,%eax
  8017d5:	c1 f8 1f             	sar    $0x1f,%eax
  8017d8:	29 c2                	sub    %eax,%edx
  8017da:	89 d0                	mov    %edx,%eax
  8017dc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8017df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8017e2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8017e7:	f7 e9                	imul   %ecx
  8017e9:	c1 fa 02             	sar    $0x2,%edx
  8017ec:	89 c8                	mov    %ecx,%eax
  8017ee:	c1 f8 1f             	sar    $0x1f,%eax
  8017f1:	29 c2                	sub    %eax,%edx
  8017f3:	89 d0                	mov    %edx,%eax
  8017f5:	c1 e0 02             	shl    $0x2,%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	01 c0                	add    %eax,%eax
  8017fc:	29 c1                	sub    %eax,%ecx
  8017fe:	89 ca                	mov    %ecx,%edx
  801800:	85 d2                	test   %edx,%edx
  801802:	75 9c                	jne    8017a0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80180b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80180e:	48                   	dec    %eax
  80180f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801812:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801816:	74 3d                	je     801855 <ltostr+0xe2>
		start = 1 ;
  801818:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80181f:	eb 34                	jmp    801855 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801824:	8b 45 0c             	mov    0xc(%ebp),%eax
  801827:	01 d0                	add    %edx,%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80182e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801831:	8b 45 0c             	mov    0xc(%ebp),%eax
  801834:	01 c2                	add    %eax,%edx
  801836:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801839:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183c:	01 c8                	add    %ecx,%eax
  80183e:	8a 00                	mov    (%eax),%al
  801840:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801842:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801845:	8b 45 0c             	mov    0xc(%ebp),%eax
  801848:	01 c2                	add    %eax,%edx
  80184a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80184d:	88 02                	mov    %al,(%edx)
		start++ ;
  80184f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801852:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801855:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801858:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80185b:	7c c4                	jl     801821 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80185d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801860:	8b 45 0c             	mov    0xc(%ebp),%eax
  801863:	01 d0                	add    %edx,%eax
  801865:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801868:	90                   	nop
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801871:	ff 75 08             	pushl  0x8(%ebp)
  801874:	e8 54 fa ff ff       	call   8012cd <strlen>
  801879:	83 c4 04             	add    $0x4,%esp
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	e8 46 fa ff ff       	call   8012cd <strlen>
  801887:	83 c4 04             	add    $0x4,%esp
  80188a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80188d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801894:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80189b:	eb 17                	jmp    8018b4 <strcconcat+0x49>
		final[s] = str1[s] ;
  80189d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8018a3:	01 c2                	add    %eax,%edx
  8018a5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	01 c8                	add    %ecx,%eax
  8018ad:	8a 00                	mov    (%eax),%al
  8018af:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8018b1:	ff 45 fc             	incl   -0x4(%ebp)
  8018b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8018ba:	7c e1                	jl     80189d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8018bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8018c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8018ca:	eb 1f                	jmp    8018eb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8018cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018cf:	8d 50 01             	lea    0x1(%eax),%edx
  8018d2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8018d5:	89 c2                	mov    %eax,%edx
  8018d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018da:	01 c2                	add    %eax,%edx
  8018dc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8018df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e2:	01 c8                	add    %ecx,%eax
  8018e4:	8a 00                	mov    (%eax),%al
  8018e6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8018e8:	ff 45 f8             	incl   -0x8(%ebp)
  8018eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018ee:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018f1:	7c d9                	jl     8018cc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8018f3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	c6 00 00             	movb   $0x0,(%eax)
}
  8018fe:	90                   	nop
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801904:	8b 45 14             	mov    0x14(%ebp),%eax
  801907:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80190d:	8b 45 14             	mov    0x14(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801919:	8b 45 10             	mov    0x10(%ebp),%eax
  80191c:	01 d0                	add    %edx,%eax
  80191e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801924:	eb 0c                	jmp    801932 <strsplit+0x31>
			*string++ = 0;
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8d 50 01             	lea    0x1(%eax),%edx
  80192c:	89 55 08             	mov    %edx,0x8(%ebp)
  80192f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	84 c0                	test   %al,%al
  801939:	74 18                	je     801953 <strsplit+0x52>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	8a 00                	mov    (%eax),%al
  801940:	0f be c0             	movsbl %al,%eax
  801943:	50                   	push   %eax
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	e8 13 fb ff ff       	call   80145f <strchr>
  80194c:	83 c4 08             	add    $0x8,%esp
  80194f:	85 c0                	test   %eax,%eax
  801951:	75 d3                	jne    801926 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	8a 00                	mov    (%eax),%al
  801958:	84 c0                	test   %al,%al
  80195a:	74 5a                	je     8019b6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80195c:	8b 45 14             	mov    0x14(%ebp),%eax
  80195f:	8b 00                	mov    (%eax),%eax
  801961:	83 f8 0f             	cmp    $0xf,%eax
  801964:	75 07                	jne    80196d <strsplit+0x6c>
		{
			return 0;
  801966:	b8 00 00 00 00       	mov    $0x0,%eax
  80196b:	eb 66                	jmp    8019d3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80196d:	8b 45 14             	mov    0x14(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	8d 48 01             	lea    0x1(%eax),%ecx
  801975:	8b 55 14             	mov    0x14(%ebp),%edx
  801978:	89 0a                	mov    %ecx,(%edx)
  80197a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801981:	8b 45 10             	mov    0x10(%ebp),%eax
  801984:	01 c2                	add    %eax,%edx
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80198b:	eb 03                	jmp    801990 <strsplit+0x8f>
			string++;
  80198d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	8a 00                	mov    (%eax),%al
  801995:	84 c0                	test   %al,%al
  801997:	74 8b                	je     801924 <strsplit+0x23>
  801999:	8b 45 08             	mov    0x8(%ebp),%eax
  80199c:	8a 00                	mov    (%eax),%al
  80199e:	0f be c0             	movsbl %al,%eax
  8019a1:	50                   	push   %eax
  8019a2:	ff 75 0c             	pushl  0xc(%ebp)
  8019a5:	e8 b5 fa ff ff       	call   80145f <strchr>
  8019aa:	83 c4 08             	add    $0x8,%esp
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	74 dc                	je     80198d <strsplit+0x8c>
			string++;
	}
  8019b1:	e9 6e ff ff ff       	jmp    801924 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8019b6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8019b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ba:	8b 00                	mov    (%eax),%eax
  8019bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c6:	01 d0                	add    %edx,%eax
  8019c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8019ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8019db:	a1 04 50 80 00       	mov    0x805004,%eax
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	74 1f                	je     801a03 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8019e4:	e8 1d 00 00 00       	call   801a06 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8019e9:	83 ec 0c             	sub    $0xc,%esp
  8019ec:	68 44 41 80 00       	push   $0x804144
  8019f1:	e8 4f f0 ff ff       	call   800a45 <cprintf>
  8019f6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8019f9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801a00:	00 00 00 
	}
}
  801a03:	90                   	nop
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801a0c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801a13:	00 00 00 
  801a16:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801a1d:	00 00 00 
  801a20:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801a27:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801a2a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801a31:	00 00 00 
  801a34:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801a3b:	00 00 00 
  801a3e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801a45:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801a48:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a52:	c1 e8 0c             	shr    $0xc,%eax
  801a55:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801a5a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a69:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a6e:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801a73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801a7a:	a1 20 51 80 00       	mov    0x805120,%eax
  801a7f:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801a83:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801a86:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801a8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a93:	01 d0                	add    %edx,%eax
  801a95:	48                   	dec    %eax
  801a96:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa1:	f7 75 e4             	divl   -0x1c(%ebp)
  801aa4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aa7:	29 d0                	sub    %edx,%eax
  801aa9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801aac:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801ab3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ab6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801abb:	2d 00 10 00 00       	sub    $0x1000,%eax
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	6a 07                	push   $0x7
  801ac5:	ff 75 e8             	pushl  -0x18(%ebp)
  801ac8:	50                   	push   %eax
  801ac9:	e8 3d 06 00 00       	call   80210b <sys_allocate_chunk>
  801ace:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ad1:	a1 20 51 80 00       	mov    0x805120,%eax
  801ad6:	83 ec 0c             	sub    $0xc,%esp
  801ad9:	50                   	push   %eax
  801ada:	e8 b2 0c 00 00       	call   802791 <initialize_MemBlocksList>
  801adf:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801ae2:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801ae7:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801aea:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801aee:	0f 84 f3 00 00 00    	je     801be7 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801af4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801af8:	75 14                	jne    801b0e <initialize_dyn_block_system+0x108>
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	68 69 41 80 00       	push   $0x804169
  801b02:	6a 36                	push   $0x36
  801b04:	68 87 41 80 00       	push   $0x804187
  801b09:	e8 83 ec ff ff       	call   800791 <_panic>
  801b0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b11:	8b 00                	mov    (%eax),%eax
  801b13:	85 c0                	test   %eax,%eax
  801b15:	74 10                	je     801b27 <initialize_dyn_block_system+0x121>
  801b17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b1a:	8b 00                	mov    (%eax),%eax
  801b1c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b1f:	8b 52 04             	mov    0x4(%edx),%edx
  801b22:	89 50 04             	mov    %edx,0x4(%eax)
  801b25:	eb 0b                	jmp    801b32 <initialize_dyn_block_system+0x12c>
  801b27:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b2a:	8b 40 04             	mov    0x4(%eax),%eax
  801b2d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801b32:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b35:	8b 40 04             	mov    0x4(%eax),%eax
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	74 0f                	je     801b4b <initialize_dyn_block_system+0x145>
  801b3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b3f:	8b 40 04             	mov    0x4(%eax),%eax
  801b42:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b45:	8b 12                	mov    (%edx),%edx
  801b47:	89 10                	mov    %edx,(%eax)
  801b49:	eb 0a                	jmp    801b55 <initialize_dyn_block_system+0x14f>
  801b4b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b4e:	8b 00                	mov    (%eax),%eax
  801b50:	a3 48 51 80 00       	mov    %eax,0x805148
  801b55:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b5e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b68:	a1 54 51 80 00       	mov    0x805154,%eax
  801b6d:	48                   	dec    %eax
  801b6e:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801b73:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b76:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801b7d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b80:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801b87:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801b8b:	75 14                	jne    801ba1 <initialize_dyn_block_system+0x19b>
  801b8d:	83 ec 04             	sub    $0x4,%esp
  801b90:	68 94 41 80 00       	push   $0x804194
  801b95:	6a 3e                	push   $0x3e
  801b97:	68 87 41 80 00       	push   $0x804187
  801b9c:	e8 f0 eb ff ff       	call   800791 <_panic>
  801ba1:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801ba7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801baa:	89 10                	mov    %edx,(%eax)
  801bac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801baf:	8b 00                	mov    (%eax),%eax
  801bb1:	85 c0                	test   %eax,%eax
  801bb3:	74 0d                	je     801bc2 <initialize_dyn_block_system+0x1bc>
  801bb5:	a1 38 51 80 00       	mov    0x805138,%eax
  801bba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801bbd:	89 50 04             	mov    %edx,0x4(%eax)
  801bc0:	eb 08                	jmp    801bca <initialize_dyn_block_system+0x1c4>
  801bc2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bc5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801bca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bcd:	a3 38 51 80 00       	mov    %eax,0x805138
  801bd2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bd5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801bdc:	a1 44 51 80 00       	mov    0x805144,%eax
  801be1:	40                   	inc    %eax
  801be2:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801be7:	90                   	nop
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
  801bed:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801bf0:	e8 e0 fd ff ff       	call   8019d5 <InitializeUHeap>
		if (size == 0) return NULL ;
  801bf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801bf9:	75 07                	jne    801c02 <malloc+0x18>
  801bfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801c00:	eb 7f                	jmp    801c81 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801c02:	e8 d2 08 00 00       	call   8024d9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c07:	85 c0                	test   %eax,%eax
  801c09:	74 71                	je     801c7c <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801c0b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801c12:	8b 55 08             	mov    0x8(%ebp),%edx
  801c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c18:	01 d0                	add    %edx,%eax
  801c1a:	48                   	dec    %eax
  801c1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c21:	ba 00 00 00 00       	mov    $0x0,%edx
  801c26:	f7 75 f4             	divl   -0xc(%ebp)
  801c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2c:	29 d0                	sub    %edx,%eax
  801c2e:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801c31:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801c38:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801c3f:	76 07                	jbe    801c48 <malloc+0x5e>
					return NULL ;
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
  801c46:	eb 39                	jmp    801c81 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801c48:	83 ec 0c             	sub    $0xc,%esp
  801c4b:	ff 75 08             	pushl  0x8(%ebp)
  801c4e:	e8 e6 0d 00 00       	call   802a39 <alloc_block_FF>
  801c53:	83 c4 10             	add    $0x10,%esp
  801c56:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801c59:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801c5d:	74 16                	je     801c75 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801c5f:	83 ec 0c             	sub    $0xc,%esp
  801c62:	ff 75 ec             	pushl  -0x14(%ebp)
  801c65:	e8 37 0c 00 00       	call   8028a1 <insert_sorted_allocList>
  801c6a:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c70:	8b 40 08             	mov    0x8(%eax),%eax
  801c73:	eb 0c                	jmp    801c81 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801c75:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7a:	eb 05                	jmp    801c81 <malloc+0x97>
				}
		}
	return 0;
  801c7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801c8f:	83 ec 08             	sub    $0x8,%esp
  801c92:	ff 75 f4             	pushl  -0xc(%ebp)
  801c95:	68 40 50 80 00       	push   $0x805040
  801c9a:	e8 cf 0b 00 00       	call   80286e <find_block>
  801c9f:	83 c4 10             	add    $0x10,%esp
  801ca2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca8:	8b 40 0c             	mov    0xc(%eax),%eax
  801cab:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb1:	8b 40 08             	mov    0x8(%eax),%eax
  801cb4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801cb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cbb:	0f 84 a1 00 00 00    	je     801d62 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801cc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cc5:	75 17                	jne    801cde <free+0x5b>
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	68 69 41 80 00       	push   $0x804169
  801ccf:	68 80 00 00 00       	push   $0x80
  801cd4:	68 87 41 80 00       	push   $0x804187
  801cd9:	e8 b3 ea ff ff       	call   800791 <_panic>
  801cde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce1:	8b 00                	mov    (%eax),%eax
  801ce3:	85 c0                	test   %eax,%eax
  801ce5:	74 10                	je     801cf7 <free+0x74>
  801ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cea:	8b 00                	mov    (%eax),%eax
  801cec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cef:	8b 52 04             	mov    0x4(%edx),%edx
  801cf2:	89 50 04             	mov    %edx,0x4(%eax)
  801cf5:	eb 0b                	jmp    801d02 <free+0x7f>
  801cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cfa:	8b 40 04             	mov    0x4(%eax),%eax
  801cfd:	a3 44 50 80 00       	mov    %eax,0x805044
  801d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d05:	8b 40 04             	mov    0x4(%eax),%eax
  801d08:	85 c0                	test   %eax,%eax
  801d0a:	74 0f                	je     801d1b <free+0x98>
  801d0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d0f:	8b 40 04             	mov    0x4(%eax),%eax
  801d12:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d15:	8b 12                	mov    (%edx),%edx
  801d17:	89 10                	mov    %edx,(%eax)
  801d19:	eb 0a                	jmp    801d25 <free+0xa2>
  801d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1e:	8b 00                	mov    (%eax),%eax
  801d20:	a3 40 50 80 00       	mov    %eax,0x805040
  801d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d28:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d38:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801d3d:	48                   	dec    %eax
  801d3e:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801d43:	83 ec 0c             	sub    $0xc,%esp
  801d46:	ff 75 f0             	pushl  -0x10(%ebp)
  801d49:	e8 29 12 00 00       	call   802f77 <insert_sorted_with_merge_freeList>
  801d4e:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801d51:	83 ec 08             	sub    $0x8,%esp
  801d54:	ff 75 ec             	pushl  -0x14(%ebp)
  801d57:	ff 75 e8             	pushl  -0x18(%ebp)
  801d5a:	e8 74 03 00 00       	call   8020d3 <sys_free_user_mem>
  801d5f:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801d62:	90                   	nop
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
  801d68:	83 ec 38             	sub    $0x38,%esp
  801d6b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d6e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d71:	e8 5f fc ff ff       	call   8019d5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801d76:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d7a:	75 0a                	jne    801d86 <smalloc+0x21>
  801d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801d81:	e9 b2 00 00 00       	jmp    801e38 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801d86:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801d8d:	76 0a                	jbe    801d99 <smalloc+0x34>
		return NULL;
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d94:	e9 9f 00 00 00       	jmp    801e38 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d99:	e8 3b 07 00 00       	call   8024d9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	0f 84 8d 00 00 00    	je     801e33 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801da6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801dad:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801db4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dba:	01 d0                	add    %edx,%eax
  801dbc:	48                   	dec    %eax
  801dbd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dc3:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc8:	f7 75 f0             	divl   -0x10(%ebp)
  801dcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dce:	29 d0                	sub    %edx,%eax
  801dd0:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801dd3:	83 ec 0c             	sub    $0xc,%esp
  801dd6:	ff 75 e8             	pushl  -0x18(%ebp)
  801dd9:	e8 5b 0c 00 00       	call   802a39 <alloc_block_FF>
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801de4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de8:	75 07                	jne    801df1 <smalloc+0x8c>
			return NULL;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
  801def:	eb 47                	jmp    801e38 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801df1:	83 ec 0c             	sub    $0xc,%esp
  801df4:	ff 75 f4             	pushl  -0xc(%ebp)
  801df7:	e8 a5 0a 00 00       	call   8028a1 <insert_sorted_allocList>
  801dfc:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e02:	8b 40 08             	mov    0x8(%eax),%eax
  801e05:	89 c2                	mov    %eax,%edx
  801e07:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801e0b:	52                   	push   %edx
  801e0c:	50                   	push   %eax
  801e0d:	ff 75 0c             	pushl  0xc(%ebp)
  801e10:	ff 75 08             	pushl  0x8(%ebp)
  801e13:	e8 46 04 00 00       	call   80225e <sys_createSharedObject>
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801e1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801e22:	78 08                	js     801e2c <smalloc+0xc7>
		return (void *)b->sva;
  801e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e27:	8b 40 08             	mov    0x8(%eax),%eax
  801e2a:	eb 0c                	jmp    801e38 <smalloc+0xd3>
		}else{
		return NULL;
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e31:	eb 05                	jmp    801e38 <smalloc+0xd3>
			}

	}return NULL;
  801e33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
  801e3d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e40:	e8 90 fb ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801e45:	e8 8f 06 00 00       	call   8024d9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e4a:	85 c0                	test   %eax,%eax
  801e4c:	0f 84 ad 00 00 00    	je     801eff <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801e52:	83 ec 08             	sub    $0x8,%esp
  801e55:	ff 75 0c             	pushl  0xc(%ebp)
  801e58:	ff 75 08             	pushl  0x8(%ebp)
  801e5b:	e8 28 04 00 00       	call   802288 <sys_getSizeOfSharedObject>
  801e60:	83 c4 10             	add    $0x10,%esp
  801e63:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801e66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e6a:	79 0a                	jns    801e76 <sget+0x3c>
    {
    	return NULL;
  801e6c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e71:	e9 8e 00 00 00       	jmp    801f04 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801e76:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801e7d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e87:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e8a:	01 d0                	add    %edx,%eax
  801e8c:	48                   	dec    %eax
  801e8d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e93:	ba 00 00 00 00       	mov    $0x0,%edx
  801e98:	f7 75 ec             	divl   -0x14(%ebp)
  801e9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e9e:	29 d0                	sub    %edx,%eax
  801ea0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801ea3:	83 ec 0c             	sub    $0xc,%esp
  801ea6:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ea9:	e8 8b 0b 00 00       	call   802a39 <alloc_block_FF>
  801eae:	83 c4 10             	add    $0x10,%esp
  801eb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801eb4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb8:	75 07                	jne    801ec1 <sget+0x87>
				return NULL;
  801eba:	b8 00 00 00 00       	mov    $0x0,%eax
  801ebf:	eb 43                	jmp    801f04 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801ec1:	83 ec 0c             	sub    $0xc,%esp
  801ec4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec7:	e8 d5 09 00 00       	call   8028a1 <insert_sorted_allocList>
  801ecc:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed2:	8b 40 08             	mov    0x8(%eax),%eax
  801ed5:	83 ec 04             	sub    $0x4,%esp
  801ed8:	50                   	push   %eax
  801ed9:	ff 75 0c             	pushl  0xc(%ebp)
  801edc:	ff 75 08             	pushl  0x8(%ebp)
  801edf:	e8 c1 03 00 00       	call   8022a5 <sys_getSharedObject>
  801ee4:	83 c4 10             	add    $0x10,%esp
  801ee7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801eea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801eee:	78 08                	js     801ef8 <sget+0xbe>
			return (void *)b->sva;
  801ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef3:	8b 40 08             	mov    0x8(%eax),%eax
  801ef6:	eb 0c                	jmp    801f04 <sget+0xca>
			}else{
			return NULL;
  801ef8:	b8 00 00 00 00       	mov    $0x0,%eax
  801efd:	eb 05                	jmp    801f04 <sget+0xca>
			}
    }}return NULL;
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f04:	c9                   	leave  
  801f05:	c3                   	ret    

00801f06 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801f06:	55                   	push   %ebp
  801f07:	89 e5                	mov    %esp,%ebp
  801f09:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f0c:	e8 c4 fa ff ff       	call   8019d5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801f11:	83 ec 04             	sub    $0x4,%esp
  801f14:	68 b8 41 80 00       	push   $0x8041b8
  801f19:	68 03 01 00 00       	push   $0x103
  801f1e:	68 87 41 80 00       	push   $0x804187
  801f23:	e8 69 e8 ff ff       	call   800791 <_panic>

00801f28 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801f28:	55                   	push   %ebp
  801f29:	89 e5                	mov    %esp,%ebp
  801f2b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801f2e:	83 ec 04             	sub    $0x4,%esp
  801f31:	68 e0 41 80 00       	push   $0x8041e0
  801f36:	68 17 01 00 00       	push   $0x117
  801f3b:	68 87 41 80 00       	push   $0x804187
  801f40:	e8 4c e8 ff ff       	call   800791 <_panic>

00801f45 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
  801f48:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f4b:	83 ec 04             	sub    $0x4,%esp
  801f4e:	68 04 42 80 00       	push   $0x804204
  801f53:	68 22 01 00 00       	push   $0x122
  801f58:	68 87 41 80 00       	push   $0x804187
  801f5d:	e8 2f e8 ff ff       	call   800791 <_panic>

00801f62 <shrink>:

}
void shrink(uint32 newSize)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f68:	83 ec 04             	sub    $0x4,%esp
  801f6b:	68 04 42 80 00       	push   $0x804204
  801f70:	68 27 01 00 00       	push   $0x127
  801f75:	68 87 41 80 00       	push   $0x804187
  801f7a:	e8 12 e8 ff ff       	call   800791 <_panic>

00801f7f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f85:	83 ec 04             	sub    $0x4,%esp
  801f88:	68 04 42 80 00       	push   $0x804204
  801f8d:	68 2c 01 00 00       	push   $0x12c
  801f92:	68 87 41 80 00       	push   $0x804187
  801f97:	e8 f5 e7 ff ff       	call   800791 <_panic>

00801f9c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f9c:	55                   	push   %ebp
  801f9d:	89 e5                	mov    %esp,%ebp
  801f9f:	57                   	push   %edi
  801fa0:	56                   	push   %esi
  801fa1:	53                   	push   %ebx
  801fa2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fb1:	8b 7d 18             	mov    0x18(%ebp),%edi
  801fb4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801fb7:	cd 30                	int    $0x30
  801fb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801fbf:	83 c4 10             	add    $0x10,%esp
  801fc2:	5b                   	pop    %ebx
  801fc3:	5e                   	pop    %esi
  801fc4:	5f                   	pop    %edi
  801fc5:	5d                   	pop    %ebp
  801fc6:	c3                   	ret    

00801fc7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	83 ec 04             	sub    $0x4,%esp
  801fcd:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801fd3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	52                   	push   %edx
  801fdf:	ff 75 0c             	pushl  0xc(%ebp)
  801fe2:	50                   	push   %eax
  801fe3:	6a 00                	push   $0x0
  801fe5:	e8 b2 ff ff ff       	call   801f9c <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	90                   	nop
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	6a 00                	push   $0x0
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 01                	push   $0x1
  801fff:	e8 98 ff ff ff       	call   801f9c <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80200c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	52                   	push   %edx
  802019:	50                   	push   %eax
  80201a:	6a 05                	push   $0x5
  80201c:	e8 7b ff ff ff       	call   801f9c <syscall>
  802021:	83 c4 18             	add    $0x18,%esp
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
  802029:	56                   	push   %esi
  80202a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80202b:	8b 75 18             	mov    0x18(%ebp),%esi
  80202e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802031:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802034:	8b 55 0c             	mov    0xc(%ebp),%edx
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	56                   	push   %esi
  80203b:	53                   	push   %ebx
  80203c:	51                   	push   %ecx
  80203d:	52                   	push   %edx
  80203e:	50                   	push   %eax
  80203f:	6a 06                	push   $0x6
  802041:	e8 56 ff ff ff       	call   801f9c <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80204c:	5b                   	pop    %ebx
  80204d:	5e                   	pop    %esi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    

00802050 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802053:	8b 55 0c             	mov    0xc(%ebp),%edx
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	52                   	push   %edx
  802060:	50                   	push   %eax
  802061:	6a 07                	push   $0x7
  802063:	e8 34 ff ff ff       	call   801f9c <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	ff 75 0c             	pushl  0xc(%ebp)
  802079:	ff 75 08             	pushl  0x8(%ebp)
  80207c:	6a 08                	push   $0x8
  80207e:	e8 19 ff ff ff       	call   801f9c <syscall>
  802083:	83 c4 18             	add    $0x18,%esp
}
  802086:	c9                   	leave  
  802087:	c3                   	ret    

00802088 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802088:	55                   	push   %ebp
  802089:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	6a 09                	push   $0x9
  802097:	e8 00 ff ff ff       	call   801f9c <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 0a                	push   $0xa
  8020b0:	e8 e7 fe ff ff       	call   801f9c <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 0b                	push   $0xb
  8020c9:	e8 ce fe ff ff       	call   801f9c <syscall>
  8020ce:	83 c4 18             	add    $0x18,%esp
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    

008020d3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	ff 75 0c             	pushl  0xc(%ebp)
  8020df:	ff 75 08             	pushl  0x8(%ebp)
  8020e2:	6a 0f                	push   $0xf
  8020e4:	e8 b3 fe ff ff       	call   801f9c <syscall>
  8020e9:	83 c4 18             	add    $0x18,%esp
	return;
  8020ec:	90                   	nop
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	ff 75 0c             	pushl  0xc(%ebp)
  8020fb:	ff 75 08             	pushl  0x8(%ebp)
  8020fe:	6a 10                	push   $0x10
  802100:	e8 97 fe ff ff       	call   801f9c <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
	return ;
  802108:	90                   	nop
}
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	ff 75 10             	pushl  0x10(%ebp)
  802115:	ff 75 0c             	pushl  0xc(%ebp)
  802118:	ff 75 08             	pushl  0x8(%ebp)
  80211b:	6a 11                	push   $0x11
  80211d:	e8 7a fe ff ff       	call   801f9c <syscall>
  802122:	83 c4 18             	add    $0x18,%esp
	return ;
  802125:	90                   	nop
}
  802126:	c9                   	leave  
  802127:	c3                   	ret    

00802128 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802128:	55                   	push   %ebp
  802129:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 0c                	push   $0xc
  802137:	e8 60 fe ff ff       	call   801f9c <syscall>
  80213c:	83 c4 18             	add    $0x18,%esp
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	ff 75 08             	pushl  0x8(%ebp)
  80214f:	6a 0d                	push   $0xd
  802151:	e8 46 fe ff ff       	call   801f9c <syscall>
  802156:	83 c4 18             	add    $0x18,%esp
}
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80215e:	6a 00                	push   $0x0
  802160:	6a 00                	push   $0x0
  802162:	6a 00                	push   $0x0
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 0e                	push   $0xe
  80216a:	e8 2d fe ff ff       	call   801f9c <syscall>
  80216f:	83 c4 18             	add    $0x18,%esp
}
  802172:	90                   	nop
  802173:	c9                   	leave  
  802174:	c3                   	ret    

00802175 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802178:	6a 00                	push   $0x0
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	6a 13                	push   $0x13
  802184:	e8 13 fe ff ff       	call   801f9c <syscall>
  802189:	83 c4 18             	add    $0x18,%esp
}
  80218c:	90                   	nop
  80218d:	c9                   	leave  
  80218e:	c3                   	ret    

0080218f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80218f:	55                   	push   %ebp
  802190:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802192:	6a 00                	push   $0x0
  802194:	6a 00                	push   $0x0
  802196:	6a 00                	push   $0x0
  802198:	6a 00                	push   $0x0
  80219a:	6a 00                	push   $0x0
  80219c:	6a 14                	push   $0x14
  80219e:	e8 f9 fd ff ff       	call   801f9c <syscall>
  8021a3:	83 c4 18             	add    $0x18,%esp
}
  8021a6:	90                   	nop
  8021a7:	c9                   	leave  
  8021a8:	c3                   	ret    

008021a9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	83 ec 04             	sub    $0x4,%esp
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8021b5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	6a 00                	push   $0x0
  8021c1:	50                   	push   %eax
  8021c2:	6a 15                	push   $0x15
  8021c4:	e8 d3 fd ff ff       	call   801f9c <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
}
  8021cc:	90                   	nop
  8021cd:	c9                   	leave  
  8021ce:	c3                   	ret    

008021cf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 16                	push   $0x16
  8021de:	e8 b9 fd ff ff       	call   801f9c <syscall>
  8021e3:	83 c4 18             	add    $0x18,%esp
}
  8021e6:	90                   	nop
  8021e7:	c9                   	leave  
  8021e8:	c3                   	ret    

008021e9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8021e9:	55                   	push   %ebp
  8021ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8021ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	ff 75 0c             	pushl  0xc(%ebp)
  8021f8:	50                   	push   %eax
  8021f9:	6a 17                	push   $0x17
  8021fb:	e8 9c fd ff ff       	call   801f9c <syscall>
  802200:	83 c4 18             	add    $0x18,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802208:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	52                   	push   %edx
  802215:	50                   	push   %eax
  802216:	6a 1a                	push   $0x1a
  802218:	e8 7f fd ff ff       	call   801f9c <syscall>
  80221d:	83 c4 18             	add    $0x18,%esp
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802225:	8b 55 0c             	mov    0xc(%ebp),%edx
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	52                   	push   %edx
  802232:	50                   	push   %eax
  802233:	6a 18                	push   $0x18
  802235:	e8 62 fd ff ff       	call   801f9c <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
}
  80223d:	90                   	nop
  80223e:	c9                   	leave  
  80223f:	c3                   	ret    

00802240 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802240:	55                   	push   %ebp
  802241:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802243:	8b 55 0c             	mov    0xc(%ebp),%edx
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	6a 00                	push   $0x0
  80224b:	6a 00                	push   $0x0
  80224d:	6a 00                	push   $0x0
  80224f:	52                   	push   %edx
  802250:	50                   	push   %eax
  802251:	6a 19                	push   $0x19
  802253:	e8 44 fd ff ff       	call   801f9c <syscall>
  802258:	83 c4 18             	add    $0x18,%esp
}
  80225b:	90                   	nop
  80225c:	c9                   	leave  
  80225d:	c3                   	ret    

0080225e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80225e:	55                   	push   %ebp
  80225f:	89 e5                	mov    %esp,%ebp
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	8b 45 10             	mov    0x10(%ebp),%eax
  802267:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80226a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80226d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	6a 00                	push   $0x0
  802276:	51                   	push   %ecx
  802277:	52                   	push   %edx
  802278:	ff 75 0c             	pushl  0xc(%ebp)
  80227b:	50                   	push   %eax
  80227c:	6a 1b                	push   $0x1b
  80227e:	e8 19 fd ff ff       	call   801f9c <syscall>
  802283:	83 c4 18             	add    $0x18,%esp
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80228b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	52                   	push   %edx
  802298:	50                   	push   %eax
  802299:	6a 1c                	push   $0x1c
  80229b:	e8 fc fc ff ff       	call   801f9c <syscall>
  8022a0:	83 c4 18             	add    $0x18,%esp
}
  8022a3:	c9                   	leave  
  8022a4:	c3                   	ret    

008022a5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8022a5:	55                   	push   %ebp
  8022a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8022a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	51                   	push   %ecx
  8022b6:	52                   	push   %edx
  8022b7:	50                   	push   %eax
  8022b8:	6a 1d                	push   $0x1d
  8022ba:	e8 dd fc ff ff       	call   801f9c <syscall>
  8022bf:	83 c4 18             	add    $0x18,%esp
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8022c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	52                   	push   %edx
  8022d4:	50                   	push   %eax
  8022d5:	6a 1e                	push   $0x1e
  8022d7:	e8 c0 fc ff ff       	call   801f9c <syscall>
  8022dc:	83 c4 18             	add    $0x18,%esp
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 1f                	push   $0x1f
  8022f0:	e8 a7 fc ff ff       	call   801f9c <syscall>
  8022f5:	83 c4 18             	add    $0x18,%esp
}
  8022f8:	c9                   	leave  
  8022f9:	c3                   	ret    

008022fa <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8022fa:	55                   	push   %ebp
  8022fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	6a 00                	push   $0x0
  802302:	ff 75 14             	pushl  0x14(%ebp)
  802305:	ff 75 10             	pushl  0x10(%ebp)
  802308:	ff 75 0c             	pushl  0xc(%ebp)
  80230b:	50                   	push   %eax
  80230c:	6a 20                	push   $0x20
  80230e:	e8 89 fc ff ff       	call   801f9c <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	6a 00                	push   $0x0
  802326:	50                   	push   %eax
  802327:	6a 21                	push   $0x21
  802329:	e8 6e fc ff ff       	call   801f9c <syscall>
  80232e:	83 c4 18             	add    $0x18,%esp
}
  802331:	90                   	nop
  802332:	c9                   	leave  
  802333:	c3                   	ret    

00802334 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802334:	55                   	push   %ebp
  802335:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	50                   	push   %eax
  802343:	6a 22                	push   $0x22
  802345:	e8 52 fc ff ff       	call   801f9c <syscall>
  80234a:	83 c4 18             	add    $0x18,%esp
}
  80234d:	c9                   	leave  
  80234e:	c3                   	ret    

0080234f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80234f:	55                   	push   %ebp
  802350:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802352:	6a 00                	push   $0x0
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 02                	push   $0x2
  80235e:	e8 39 fc ff ff       	call   801f9c <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80236b:	6a 00                	push   $0x0
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 03                	push   $0x3
  802377:	e8 20 fc ff ff       	call   801f9c <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802384:	6a 00                	push   $0x0
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	6a 00                	push   $0x0
  80238e:	6a 04                	push   $0x4
  802390:	e8 07 fc ff ff       	call   801f9c <syscall>
  802395:	83 c4 18             	add    $0x18,%esp
}
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <sys_exit_env>:


void sys_exit_env(void)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 23                	push   $0x23
  8023a9:	e8 ee fb ff ff       	call   801f9c <syscall>
  8023ae:	83 c4 18             	add    $0x18,%esp
}
  8023b1:	90                   	nop
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8023ba:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023bd:	8d 50 04             	lea    0x4(%eax),%edx
  8023c0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	52                   	push   %edx
  8023ca:	50                   	push   %eax
  8023cb:	6a 24                	push   $0x24
  8023cd:	e8 ca fb ff ff       	call   801f9c <syscall>
  8023d2:	83 c4 18             	add    $0x18,%esp
	return result;
  8023d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8023de:	89 01                	mov    %eax,(%ecx)
  8023e0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8023e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e6:	c9                   	leave  
  8023e7:	c2 04 00             	ret    $0x4

008023ea <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8023ed:	6a 00                	push   $0x0
  8023ef:	6a 00                	push   $0x0
  8023f1:	ff 75 10             	pushl  0x10(%ebp)
  8023f4:	ff 75 0c             	pushl  0xc(%ebp)
  8023f7:	ff 75 08             	pushl  0x8(%ebp)
  8023fa:	6a 12                	push   $0x12
  8023fc:	e8 9b fb ff ff       	call   801f9c <syscall>
  802401:	83 c4 18             	add    $0x18,%esp
	return ;
  802404:	90                   	nop
}
  802405:	c9                   	leave  
  802406:	c3                   	ret    

00802407 <sys_rcr2>:
uint32 sys_rcr2()
{
  802407:	55                   	push   %ebp
  802408:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80240a:	6a 00                	push   $0x0
  80240c:	6a 00                	push   $0x0
  80240e:	6a 00                	push   $0x0
  802410:	6a 00                	push   $0x0
  802412:	6a 00                	push   $0x0
  802414:	6a 25                	push   $0x25
  802416:	e8 81 fb ff ff       	call   801f9c <syscall>
  80241b:	83 c4 18             	add    $0x18,%esp
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 04             	sub    $0x4,%esp
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80242c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	50                   	push   %eax
  802439:	6a 26                	push   $0x26
  80243b:	e8 5c fb ff ff       	call   801f9c <syscall>
  802440:	83 c4 18             	add    $0x18,%esp
	return ;
  802443:	90                   	nop
}
  802444:	c9                   	leave  
  802445:	c3                   	ret    

00802446 <rsttst>:
void rsttst()
{
  802446:	55                   	push   %ebp
  802447:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802449:	6a 00                	push   $0x0
  80244b:	6a 00                	push   $0x0
  80244d:	6a 00                	push   $0x0
  80244f:	6a 00                	push   $0x0
  802451:	6a 00                	push   $0x0
  802453:	6a 28                	push   $0x28
  802455:	e8 42 fb ff ff       	call   801f9c <syscall>
  80245a:	83 c4 18             	add    $0x18,%esp
	return ;
  80245d:	90                   	nop
}
  80245e:	c9                   	leave  
  80245f:	c3                   	ret    

00802460 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 04             	sub    $0x4,%esp
  802466:	8b 45 14             	mov    0x14(%ebp),%eax
  802469:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80246c:	8b 55 18             	mov    0x18(%ebp),%edx
  80246f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802473:	52                   	push   %edx
  802474:	50                   	push   %eax
  802475:	ff 75 10             	pushl  0x10(%ebp)
  802478:	ff 75 0c             	pushl  0xc(%ebp)
  80247b:	ff 75 08             	pushl  0x8(%ebp)
  80247e:	6a 27                	push   $0x27
  802480:	e8 17 fb ff ff       	call   801f9c <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
	return ;
  802488:	90                   	nop
}
  802489:	c9                   	leave  
  80248a:	c3                   	ret    

0080248b <chktst>:
void chktst(uint32 n)
{
  80248b:	55                   	push   %ebp
  80248c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	ff 75 08             	pushl  0x8(%ebp)
  802499:	6a 29                	push   $0x29
  80249b:	e8 fc fa ff ff       	call   801f9c <syscall>
  8024a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8024a3:	90                   	nop
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <inctst>:

void inctst()
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 2a                	push   $0x2a
  8024b5:	e8 e2 fa ff ff       	call   801f9c <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
	return ;
  8024bd:	90                   	nop
}
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <gettst>:
uint32 gettst()
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8024c3:	6a 00                	push   $0x0
  8024c5:	6a 00                	push   $0x0
  8024c7:	6a 00                	push   $0x0
  8024c9:	6a 00                	push   $0x0
  8024cb:	6a 00                	push   $0x0
  8024cd:	6a 2b                	push   $0x2b
  8024cf:	e8 c8 fa ff ff       	call   801f9c <syscall>
  8024d4:	83 c4 18             	add    $0x18,%esp
}
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
  8024dc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 2c                	push   $0x2c
  8024eb:	e8 ac fa ff ff       	call   801f9c <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
  8024f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8024f6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8024fa:	75 07                	jne    802503 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8024fc:	b8 01 00 00 00       	mov    $0x1,%eax
  802501:	eb 05                	jmp    802508 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802503:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
  80250d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802510:	6a 00                	push   $0x0
  802512:	6a 00                	push   $0x0
  802514:	6a 00                	push   $0x0
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 2c                	push   $0x2c
  80251c:	e8 7b fa ff ff       	call   801f9c <syscall>
  802521:	83 c4 18             	add    $0x18,%esp
  802524:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802527:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80252b:	75 07                	jne    802534 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80252d:	b8 01 00 00 00       	mov    $0x1,%eax
  802532:	eb 05                	jmp    802539 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802534:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802541:	6a 00                	push   $0x0
  802543:	6a 00                	push   $0x0
  802545:	6a 00                	push   $0x0
  802547:	6a 00                	push   $0x0
  802549:	6a 00                	push   $0x0
  80254b:	6a 2c                	push   $0x2c
  80254d:	e8 4a fa ff ff       	call   801f9c <syscall>
  802552:	83 c4 18             	add    $0x18,%esp
  802555:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802558:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80255c:	75 07                	jne    802565 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80255e:	b8 01 00 00 00       	mov    $0x1,%eax
  802563:	eb 05                	jmp    80256a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802565:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802572:	6a 00                	push   $0x0
  802574:	6a 00                	push   $0x0
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 2c                	push   $0x2c
  80257e:	e8 19 fa ff ff       	call   801f9c <syscall>
  802583:	83 c4 18             	add    $0x18,%esp
  802586:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802589:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80258d:	75 07                	jne    802596 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80258f:	b8 01 00 00 00       	mov    $0x1,%eax
  802594:	eb 05                	jmp    80259b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802596:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80259b:	c9                   	leave  
  80259c:	c3                   	ret    

0080259d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80259d:	55                   	push   %ebp
  80259e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	ff 75 08             	pushl  0x8(%ebp)
  8025ab:	6a 2d                	push   $0x2d
  8025ad:	e8 ea f9 ff ff       	call   801f9c <syscall>
  8025b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b5:	90                   	nop
}
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8025bc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8025bf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8025c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c8:	6a 00                	push   $0x0
  8025ca:	53                   	push   %ebx
  8025cb:	51                   	push   %ecx
  8025cc:	52                   	push   %edx
  8025cd:	50                   	push   %eax
  8025ce:	6a 2e                	push   $0x2e
  8025d0:	e8 c7 f9 ff ff       	call   801f9c <syscall>
  8025d5:	83 c4 18             	add    $0x18,%esp
}
  8025d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8025db:	c9                   	leave  
  8025dc:	c3                   	ret    

008025dd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8025dd:	55                   	push   %ebp
  8025de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8025e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e6:	6a 00                	push   $0x0
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	52                   	push   %edx
  8025ed:	50                   	push   %eax
  8025ee:	6a 2f                	push   $0x2f
  8025f0:	e8 a7 f9 ff ff       	call   801f9c <syscall>
  8025f5:	83 c4 18             	add    $0x18,%esp
}
  8025f8:	c9                   	leave  
  8025f9:	c3                   	ret    

008025fa <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8025fa:	55                   	push   %ebp
  8025fb:	89 e5                	mov    %esp,%ebp
  8025fd:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802600:	83 ec 0c             	sub    $0xc,%esp
  802603:	68 14 42 80 00       	push   $0x804214
  802608:	e8 38 e4 ff ff       	call   800a45 <cprintf>
  80260d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802610:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802617:	83 ec 0c             	sub    $0xc,%esp
  80261a:	68 40 42 80 00       	push   $0x804240
  80261f:	e8 21 e4 ff ff       	call   800a45 <cprintf>
  802624:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802627:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80262b:	a1 38 51 80 00       	mov    0x805138,%eax
  802630:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802633:	eb 56                	jmp    80268b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802639:	74 1c                	je     802657 <print_mem_block_lists+0x5d>
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	8b 50 08             	mov    0x8(%eax),%edx
  802641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802644:	8b 48 08             	mov    0x8(%eax),%ecx
  802647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80264a:	8b 40 0c             	mov    0xc(%eax),%eax
  80264d:	01 c8                	add    %ecx,%eax
  80264f:	39 c2                	cmp    %eax,%edx
  802651:	73 04                	jae    802657 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802653:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 50 08             	mov    0x8(%eax),%edx
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 0c             	mov    0xc(%eax),%eax
  802663:	01 c2                	add    %eax,%edx
  802665:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802668:	8b 40 08             	mov    0x8(%eax),%eax
  80266b:	83 ec 04             	sub    $0x4,%esp
  80266e:	52                   	push   %edx
  80266f:	50                   	push   %eax
  802670:	68 55 42 80 00       	push   $0x804255
  802675:	e8 cb e3 ff ff       	call   800a45 <cprintf>
  80267a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802683:	a1 40 51 80 00       	mov    0x805140,%eax
  802688:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80268b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80268f:	74 07                	je     802698 <print_mem_block_lists+0x9e>
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 00                	mov    (%eax),%eax
  802696:	eb 05                	jmp    80269d <print_mem_block_lists+0xa3>
  802698:	b8 00 00 00 00       	mov    $0x0,%eax
  80269d:	a3 40 51 80 00       	mov    %eax,0x805140
  8026a2:	a1 40 51 80 00       	mov    0x805140,%eax
  8026a7:	85 c0                	test   %eax,%eax
  8026a9:	75 8a                	jne    802635 <print_mem_block_lists+0x3b>
  8026ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026af:	75 84                	jne    802635 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8026b1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026b5:	75 10                	jne    8026c7 <print_mem_block_lists+0xcd>
  8026b7:	83 ec 0c             	sub    $0xc,%esp
  8026ba:	68 64 42 80 00       	push   $0x804264
  8026bf:	e8 81 e3 ff ff       	call   800a45 <cprintf>
  8026c4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8026c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8026ce:	83 ec 0c             	sub    $0xc,%esp
  8026d1:	68 88 42 80 00       	push   $0x804288
  8026d6:	e8 6a e3 ff ff       	call   800a45 <cprintf>
  8026db:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8026de:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026e2:	a1 40 50 80 00       	mov    0x805040,%eax
  8026e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ea:	eb 56                	jmp    802742 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8026ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026f0:	74 1c                	je     80270e <print_mem_block_lists+0x114>
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 50 08             	mov    0x8(%eax),%edx
  8026f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fb:	8b 48 08             	mov    0x8(%eax),%ecx
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	8b 40 0c             	mov    0xc(%eax),%eax
  802704:	01 c8                	add    %ecx,%eax
  802706:	39 c2                	cmp    %eax,%edx
  802708:	73 04                	jae    80270e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80270a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80270e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802711:	8b 50 08             	mov    0x8(%eax),%edx
  802714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802717:	8b 40 0c             	mov    0xc(%eax),%eax
  80271a:	01 c2                	add    %eax,%edx
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 40 08             	mov    0x8(%eax),%eax
  802722:	83 ec 04             	sub    $0x4,%esp
  802725:	52                   	push   %edx
  802726:	50                   	push   %eax
  802727:	68 55 42 80 00       	push   $0x804255
  80272c:	e8 14 e3 ff ff       	call   800a45 <cprintf>
  802731:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802737:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80273a:	a1 48 50 80 00       	mov    0x805048,%eax
  80273f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802746:	74 07                	je     80274f <print_mem_block_lists+0x155>
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 00                	mov    (%eax),%eax
  80274d:	eb 05                	jmp    802754 <print_mem_block_lists+0x15a>
  80274f:	b8 00 00 00 00       	mov    $0x0,%eax
  802754:	a3 48 50 80 00       	mov    %eax,0x805048
  802759:	a1 48 50 80 00       	mov    0x805048,%eax
  80275e:	85 c0                	test   %eax,%eax
  802760:	75 8a                	jne    8026ec <print_mem_block_lists+0xf2>
  802762:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802766:	75 84                	jne    8026ec <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802768:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80276c:	75 10                	jne    80277e <print_mem_block_lists+0x184>
  80276e:	83 ec 0c             	sub    $0xc,%esp
  802771:	68 a0 42 80 00       	push   $0x8042a0
  802776:	e8 ca e2 ff ff       	call   800a45 <cprintf>
  80277b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80277e:	83 ec 0c             	sub    $0xc,%esp
  802781:	68 14 42 80 00       	push   $0x804214
  802786:	e8 ba e2 ff ff       	call   800a45 <cprintf>
  80278b:	83 c4 10             	add    $0x10,%esp

}
  80278e:	90                   	nop
  80278f:	c9                   	leave  
  802790:	c3                   	ret    

00802791 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802791:	55                   	push   %ebp
  802792:	89 e5                	mov    %esp,%ebp
  802794:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802797:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80279e:	00 00 00 
  8027a1:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8027a8:	00 00 00 
  8027ab:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8027b2:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8027b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8027bc:	e9 9e 00 00 00       	jmp    80285f <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8027c1:	a1 50 50 80 00       	mov    0x805050,%eax
  8027c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c9:	c1 e2 04             	shl    $0x4,%edx
  8027cc:	01 d0                	add    %edx,%eax
  8027ce:	85 c0                	test   %eax,%eax
  8027d0:	75 14                	jne    8027e6 <initialize_MemBlocksList+0x55>
  8027d2:	83 ec 04             	sub    $0x4,%esp
  8027d5:	68 c8 42 80 00       	push   $0x8042c8
  8027da:	6a 3d                	push   $0x3d
  8027dc:	68 eb 42 80 00       	push   $0x8042eb
  8027e1:	e8 ab df ff ff       	call   800791 <_panic>
  8027e6:	a1 50 50 80 00       	mov    0x805050,%eax
  8027eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ee:	c1 e2 04             	shl    $0x4,%edx
  8027f1:	01 d0                	add    %edx,%eax
  8027f3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8027f9:	89 10                	mov    %edx,(%eax)
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	74 18                	je     802819 <initialize_MemBlocksList+0x88>
  802801:	a1 48 51 80 00       	mov    0x805148,%eax
  802806:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80280c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80280f:	c1 e1 04             	shl    $0x4,%ecx
  802812:	01 ca                	add    %ecx,%edx
  802814:	89 50 04             	mov    %edx,0x4(%eax)
  802817:	eb 12                	jmp    80282b <initialize_MemBlocksList+0x9a>
  802819:	a1 50 50 80 00       	mov    0x805050,%eax
  80281e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802821:	c1 e2 04             	shl    $0x4,%edx
  802824:	01 d0                	add    %edx,%eax
  802826:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80282b:	a1 50 50 80 00       	mov    0x805050,%eax
  802830:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802833:	c1 e2 04             	shl    $0x4,%edx
  802836:	01 d0                	add    %edx,%eax
  802838:	a3 48 51 80 00       	mov    %eax,0x805148
  80283d:	a1 50 50 80 00       	mov    0x805050,%eax
  802842:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802845:	c1 e2 04             	shl    $0x4,%edx
  802848:	01 d0                	add    %edx,%eax
  80284a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802851:	a1 54 51 80 00       	mov    0x805154,%eax
  802856:	40                   	inc    %eax
  802857:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80285c:	ff 45 f4             	incl   -0xc(%ebp)
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	3b 45 08             	cmp    0x8(%ebp),%eax
  802865:	0f 82 56 ff ff ff    	jb     8027c1 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80286b:	90                   	nop
  80286c:	c9                   	leave  
  80286d:	c3                   	ret    

0080286e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
  802871:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802874:	8b 45 08             	mov    0x8(%ebp),%eax
  802877:	8b 00                	mov    (%eax),%eax
  802879:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80287c:	eb 18                	jmp    802896 <find_block+0x28>

		if(tmp->sva == va){
  80287e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802881:	8b 40 08             	mov    0x8(%eax),%eax
  802884:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802887:	75 05                	jne    80288e <find_block+0x20>
			return tmp ;
  802889:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80288c:	eb 11                	jmp    80289f <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  80288e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802896:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80289a:	75 e2                	jne    80287e <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80289c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80289f:	c9                   	leave  
  8028a0:	c3                   	ret    

008028a1 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8028a1:	55                   	push   %ebp
  8028a2:	89 e5                	mov    %esp,%ebp
  8028a4:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8028a7:	a1 40 50 80 00       	mov    0x805040,%eax
  8028ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8028af:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8028b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028bb:	75 65                	jne    802922 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8028bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028c1:	75 14                	jne    8028d7 <insert_sorted_allocList+0x36>
  8028c3:	83 ec 04             	sub    $0x4,%esp
  8028c6:	68 c8 42 80 00       	push   $0x8042c8
  8028cb:	6a 62                	push   $0x62
  8028cd:	68 eb 42 80 00       	push   $0x8042eb
  8028d2:	e8 ba de ff ff       	call   800791 <_panic>
  8028d7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	89 10                	mov    %edx,(%eax)
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	74 0d                	je     8028f8 <insert_sorted_allocList+0x57>
  8028eb:	a1 40 50 80 00       	mov    0x805040,%eax
  8028f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f3:	89 50 04             	mov    %edx,0x4(%eax)
  8028f6:	eb 08                	jmp    802900 <insert_sorted_allocList+0x5f>
  8028f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fb:	a3 44 50 80 00       	mov    %eax,0x805044
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	a3 40 50 80 00       	mov    %eax,0x805040
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802912:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802917:	40                   	inc    %eax
  802918:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80291d:	e9 14 01 00 00       	jmp    802a36 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	8b 50 08             	mov    0x8(%eax),%edx
  802928:	a1 44 50 80 00       	mov    0x805044,%eax
  80292d:	8b 40 08             	mov    0x8(%eax),%eax
  802930:	39 c2                	cmp    %eax,%edx
  802932:	76 65                	jbe    802999 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802934:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802938:	75 14                	jne    80294e <insert_sorted_allocList+0xad>
  80293a:	83 ec 04             	sub    $0x4,%esp
  80293d:	68 04 43 80 00       	push   $0x804304
  802942:	6a 64                	push   $0x64
  802944:	68 eb 42 80 00       	push   $0x8042eb
  802949:	e8 43 de ff ff       	call   800791 <_panic>
  80294e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	89 50 04             	mov    %edx,0x4(%eax)
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	8b 40 04             	mov    0x4(%eax),%eax
  802960:	85 c0                	test   %eax,%eax
  802962:	74 0c                	je     802970 <insert_sorted_allocList+0xcf>
  802964:	a1 44 50 80 00       	mov    0x805044,%eax
  802969:	8b 55 08             	mov    0x8(%ebp),%edx
  80296c:	89 10                	mov    %edx,(%eax)
  80296e:	eb 08                	jmp    802978 <insert_sorted_allocList+0xd7>
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	a3 40 50 80 00       	mov    %eax,0x805040
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	a3 44 50 80 00       	mov    %eax,0x805044
  802980:	8b 45 08             	mov    0x8(%ebp),%eax
  802983:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802989:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80298e:	40                   	inc    %eax
  80298f:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802994:	e9 9d 00 00 00       	jmp    802a36 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802999:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8029a0:	e9 85 00 00 00       	jmp    802a2a <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	8b 50 08             	mov    0x8(%eax),%edx
  8029ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ae:	8b 40 08             	mov    0x8(%eax),%eax
  8029b1:	39 c2                	cmp    %eax,%edx
  8029b3:	73 6a                	jae    802a1f <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8029b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029b9:	74 06                	je     8029c1 <insert_sorted_allocList+0x120>
  8029bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029bf:	75 14                	jne    8029d5 <insert_sorted_allocList+0x134>
  8029c1:	83 ec 04             	sub    $0x4,%esp
  8029c4:	68 28 43 80 00       	push   $0x804328
  8029c9:	6a 6b                	push   $0x6b
  8029cb:	68 eb 42 80 00       	push   $0x8042eb
  8029d0:	e8 bc dd ff ff       	call   800791 <_panic>
  8029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d8:	8b 50 04             	mov    0x4(%eax),%edx
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	89 50 04             	mov    %edx,0x4(%eax)
  8029e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029e7:	89 10                	mov    %edx,(%eax)
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 40 04             	mov    0x4(%eax),%eax
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	74 0d                	je     802a00 <insert_sorted_allocList+0x15f>
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 40 04             	mov    0x4(%eax),%eax
  8029f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fc:	89 10                	mov    %edx,(%eax)
  8029fe:	eb 08                	jmp    802a08 <insert_sorted_allocList+0x167>
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	a3 40 50 80 00       	mov    %eax,0x805040
  802a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0e:	89 50 04             	mov    %edx,0x4(%eax)
  802a11:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a16:	40                   	inc    %eax
  802a17:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802a1c:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802a1d:	eb 17                	jmp    802a36 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802a27:	ff 45 f0             	incl   -0x10(%ebp)
  802a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a30:	0f 8c 6f ff ff ff    	jl     8029a5 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802a36:	90                   	nop
  802a37:	c9                   	leave  
  802a38:	c3                   	ret    

00802a39 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802a39:	55                   	push   %ebp
  802a3a:	89 e5                	mov    %esp,%ebp
  802a3c:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802a3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802a47:	e9 7c 01 00 00       	jmp    802bc8 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a55:	0f 86 cf 00 00 00    	jbe    802b2a <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802a5b:	a1 48 51 80 00       	mov    0x805148,%eax
  802a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a66:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6f:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 50 08             	mov    0x8(%eax),%edx
  802a78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7b:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 40 0c             	mov    0xc(%eax),%eax
  802a84:	2b 45 08             	sub    0x8(%ebp),%eax
  802a87:	89 c2                	mov    %eax,%edx
  802a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8c:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a92:	8b 50 08             	mov    0x8(%eax),%edx
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	01 c2                	add    %eax,%edx
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802aa0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802aa4:	75 17                	jne    802abd <alloc_block_FF+0x84>
  802aa6:	83 ec 04             	sub    $0x4,%esp
  802aa9:	68 5d 43 80 00       	push   $0x80435d
  802aae:	68 83 00 00 00       	push   $0x83
  802ab3:	68 eb 42 80 00       	push   $0x8042eb
  802ab8:	e8 d4 dc ff ff       	call   800791 <_panic>
  802abd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	74 10                	je     802ad6 <alloc_block_FF+0x9d>
  802ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac9:	8b 00                	mov    (%eax),%eax
  802acb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ace:	8b 52 04             	mov    0x4(%edx),%edx
  802ad1:	89 50 04             	mov    %edx,0x4(%eax)
  802ad4:	eb 0b                	jmp    802ae1 <alloc_block_FF+0xa8>
  802ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad9:	8b 40 04             	mov    0x4(%eax),%eax
  802adc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae4:	8b 40 04             	mov    0x4(%eax),%eax
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	74 0f                	je     802afa <alloc_block_FF+0xc1>
  802aeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aee:	8b 40 04             	mov    0x4(%eax),%eax
  802af1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802af4:	8b 12                	mov    (%edx),%edx
  802af6:	89 10                	mov    %edx,(%eax)
  802af8:	eb 0a                	jmp    802b04 <alloc_block_FF+0xcb>
  802afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afd:	8b 00                	mov    (%eax),%eax
  802aff:	a3 48 51 80 00       	mov    %eax,0x805148
  802b04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b07:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b17:	a1 54 51 80 00       	mov    0x805154,%eax
  802b1c:	48                   	dec    %eax
  802b1d:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b25:	e9 ad 00 00 00       	jmp    802bd7 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b30:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b33:	0f 85 87 00 00 00    	jne    802bc0 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802b39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b3d:	75 17                	jne    802b56 <alloc_block_FF+0x11d>
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	68 5d 43 80 00       	push   $0x80435d
  802b47:	68 87 00 00 00       	push   $0x87
  802b4c:	68 eb 42 80 00       	push   $0x8042eb
  802b51:	e8 3b dc ff ff       	call   800791 <_panic>
  802b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b59:	8b 00                	mov    (%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	74 10                	je     802b6f <alloc_block_FF+0x136>
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	8b 00                	mov    (%eax),%eax
  802b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b67:	8b 52 04             	mov    0x4(%edx),%edx
  802b6a:	89 50 04             	mov    %edx,0x4(%eax)
  802b6d:	eb 0b                	jmp    802b7a <alloc_block_FF+0x141>
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 40 04             	mov    0x4(%eax),%eax
  802b75:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7d:	8b 40 04             	mov    0x4(%eax),%eax
  802b80:	85 c0                	test   %eax,%eax
  802b82:	74 0f                	je     802b93 <alloc_block_FF+0x15a>
  802b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b87:	8b 40 04             	mov    0x4(%eax),%eax
  802b8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b8d:	8b 12                	mov    (%edx),%edx
  802b8f:	89 10                	mov    %edx,(%eax)
  802b91:	eb 0a                	jmp    802b9d <alloc_block_FF+0x164>
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 00                	mov    (%eax),%eax
  802b98:	a3 38 51 80 00       	mov    %eax,0x805138
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb0:	a1 44 51 80 00       	mov    0x805144,%eax
  802bb5:	48                   	dec    %eax
  802bb6:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbe:	eb 17                	jmp    802bd7 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802bc8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bcc:	0f 85 7a fe ff ff    	jne    802a4c <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd7:	c9                   	leave  
  802bd8:	c3                   	ret    

00802bd9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802bd9:	55                   	push   %ebp
  802bda:	89 e5                	mov    %esp,%ebp
  802bdc:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802bdf:	a1 38 51 80 00       	mov    0x805138,%eax
  802be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802be7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802bee:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802bf5:	a1 38 51 80 00       	mov    0x805138,%eax
  802bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bfd:	e9 d0 00 00 00       	jmp    802cd2 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 40 0c             	mov    0xc(%eax),%eax
  802c08:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c0b:	0f 82 b8 00 00 00    	jb     802cc9 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 40 0c             	mov    0xc(%eax),%eax
  802c17:	2b 45 08             	sub    0x8(%ebp),%eax
  802c1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c20:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c23:	0f 83 a1 00 00 00    	jae    802cca <alloc_block_BF+0xf1>
				differsize = differance ;
  802c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c32:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802c35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c39:	0f 85 8b 00 00 00    	jne    802cca <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c43:	75 17                	jne    802c5c <alloc_block_BF+0x83>
  802c45:	83 ec 04             	sub    $0x4,%esp
  802c48:	68 5d 43 80 00       	push   $0x80435d
  802c4d:	68 a0 00 00 00       	push   $0xa0
  802c52:	68 eb 42 80 00       	push   $0x8042eb
  802c57:	e8 35 db ff ff       	call   800791 <_panic>
  802c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5f:	8b 00                	mov    (%eax),%eax
  802c61:	85 c0                	test   %eax,%eax
  802c63:	74 10                	je     802c75 <alloc_block_BF+0x9c>
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 00                	mov    (%eax),%eax
  802c6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c6d:	8b 52 04             	mov    0x4(%edx),%edx
  802c70:	89 50 04             	mov    %edx,0x4(%eax)
  802c73:	eb 0b                	jmp    802c80 <alloc_block_BF+0xa7>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 40 04             	mov    0x4(%eax),%eax
  802c7b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 40 04             	mov    0x4(%eax),%eax
  802c86:	85 c0                	test   %eax,%eax
  802c88:	74 0f                	je     802c99 <alloc_block_BF+0xc0>
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 04             	mov    0x4(%eax),%eax
  802c90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c93:	8b 12                	mov    (%edx),%edx
  802c95:	89 10                	mov    %edx,(%eax)
  802c97:	eb 0a                	jmp    802ca3 <alloc_block_BF+0xca>
  802c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9c:	8b 00                	mov    (%eax),%eax
  802c9e:	a3 38 51 80 00       	mov    %eax,0x805138
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb6:	a1 44 51 80 00       	mov    0x805144,%eax
  802cbb:	48                   	dec    %eax
  802cbc:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	e9 0c 01 00 00       	jmp    802dd5 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802cc9:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802cca:	a1 40 51 80 00       	mov    0x805140,%eax
  802ccf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd6:	74 07                	je     802cdf <alloc_block_BF+0x106>
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 00                	mov    (%eax),%eax
  802cdd:	eb 05                	jmp    802ce4 <alloc_block_BF+0x10b>
  802cdf:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce4:	a3 40 51 80 00       	mov    %eax,0x805140
  802ce9:	a1 40 51 80 00       	mov    0x805140,%eax
  802cee:	85 c0                	test   %eax,%eax
  802cf0:	0f 85 0c ff ff ff    	jne    802c02 <alloc_block_BF+0x29>
  802cf6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cfa:	0f 85 02 ff ff ff    	jne    802c02 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802d00:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802d04:	0f 84 c6 00 00 00    	je     802dd0 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802d0a:	a1 48 51 80 00       	mov    0x805148,%eax
  802d0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d15:	8b 55 08             	mov    0x8(%ebp),%edx
  802d18:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1e:	8b 50 08             	mov    0x8(%eax),%edx
  802d21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d24:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802d27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d2a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2d:	2b 45 08             	sub    0x8(%ebp),%eax
  802d30:	89 c2                	mov    %eax,%edx
  802d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d35:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3b:	8b 50 08             	mov    0x8(%eax),%edx
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	01 c2                	add    %eax,%edx
  802d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d46:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802d49:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d4d:	75 17                	jne    802d66 <alloc_block_BF+0x18d>
  802d4f:	83 ec 04             	sub    $0x4,%esp
  802d52:	68 5d 43 80 00       	push   $0x80435d
  802d57:	68 af 00 00 00       	push   $0xaf
  802d5c:	68 eb 42 80 00       	push   $0x8042eb
  802d61:	e8 2b da ff ff       	call   800791 <_panic>
  802d66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d69:	8b 00                	mov    (%eax),%eax
  802d6b:	85 c0                	test   %eax,%eax
  802d6d:	74 10                	je     802d7f <alloc_block_BF+0x1a6>
  802d6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d72:	8b 00                	mov    (%eax),%eax
  802d74:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d77:	8b 52 04             	mov    0x4(%edx),%edx
  802d7a:	89 50 04             	mov    %edx,0x4(%eax)
  802d7d:	eb 0b                	jmp    802d8a <alloc_block_BF+0x1b1>
  802d7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d82:	8b 40 04             	mov    0x4(%eax),%eax
  802d85:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d8d:	8b 40 04             	mov    0x4(%eax),%eax
  802d90:	85 c0                	test   %eax,%eax
  802d92:	74 0f                	je     802da3 <alloc_block_BF+0x1ca>
  802d94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d97:	8b 40 04             	mov    0x4(%eax),%eax
  802d9a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d9d:	8b 12                	mov    (%edx),%edx
  802d9f:	89 10                	mov    %edx,(%eax)
  802da1:	eb 0a                	jmp    802dad <alloc_block_BF+0x1d4>
  802da3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	a3 48 51 80 00       	mov    %eax,0x805148
  802dad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc0:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc5:	48                   	dec    %eax
  802dc6:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dce:	eb 05                	jmp    802dd5 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802dd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dd5:	c9                   	leave  
  802dd6:	c3                   	ret    

00802dd7 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802dd7:	55                   	push   %ebp
  802dd8:	89 e5                	mov    %esp,%ebp
  802dda:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802ddd:	a1 38 51 80 00       	mov    0x805138,%eax
  802de2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802de5:	e9 7c 01 00 00       	jmp    802f66 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 40 0c             	mov    0xc(%eax),%eax
  802df0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802df3:	0f 86 cf 00 00 00    	jbe    802ec8 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802df9:	a1 48 51 80 00       	mov    0x805148,%eax
  802dfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802e01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e04:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802e07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0d:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 50 08             	mov    0x8(%eax),%edx
  802e16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e19:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e22:	2b 45 08             	sub    0x8(%ebp),%eax
  802e25:	89 c2                	mov    %eax,%edx
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 50 08             	mov    0x8(%eax),%edx
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	01 c2                	add    %eax,%edx
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802e3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e42:	75 17                	jne    802e5b <alloc_block_NF+0x84>
  802e44:	83 ec 04             	sub    $0x4,%esp
  802e47:	68 5d 43 80 00       	push   $0x80435d
  802e4c:	68 c4 00 00 00       	push   $0xc4
  802e51:	68 eb 42 80 00       	push   $0x8042eb
  802e56:	e8 36 d9 ff ff       	call   800791 <_panic>
  802e5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	85 c0                	test   %eax,%eax
  802e62:	74 10                	je     802e74 <alloc_block_NF+0x9d>
  802e64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e6c:	8b 52 04             	mov    0x4(%edx),%edx
  802e6f:	89 50 04             	mov    %edx,0x4(%eax)
  802e72:	eb 0b                	jmp    802e7f <alloc_block_NF+0xa8>
  802e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e82:	8b 40 04             	mov    0x4(%eax),%eax
  802e85:	85 c0                	test   %eax,%eax
  802e87:	74 0f                	je     802e98 <alloc_block_NF+0xc1>
  802e89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e8c:	8b 40 04             	mov    0x4(%eax),%eax
  802e8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e92:	8b 12                	mov    (%edx),%edx
  802e94:	89 10                	mov    %edx,(%eax)
  802e96:	eb 0a                	jmp    802ea2 <alloc_block_NF+0xcb>
  802e98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ea5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb5:	a1 54 51 80 00       	mov    0x805154,%eax
  802eba:	48                   	dec    %eax
  802ebb:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802ec0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ec3:	e9 ad 00 00 00       	jmp    802f75 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ece:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ed1:	0f 85 87 00 00 00    	jne    802f5e <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802ed7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edb:	75 17                	jne    802ef4 <alloc_block_NF+0x11d>
  802edd:	83 ec 04             	sub    $0x4,%esp
  802ee0:	68 5d 43 80 00       	push   $0x80435d
  802ee5:	68 c8 00 00 00       	push   $0xc8
  802eea:	68 eb 42 80 00       	push   $0x8042eb
  802eef:	e8 9d d8 ff ff       	call   800791 <_panic>
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	8b 00                	mov    (%eax),%eax
  802ef9:	85 c0                	test   %eax,%eax
  802efb:	74 10                	je     802f0d <alloc_block_NF+0x136>
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	8b 00                	mov    (%eax),%eax
  802f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f05:	8b 52 04             	mov    0x4(%edx),%edx
  802f08:	89 50 04             	mov    %edx,0x4(%eax)
  802f0b:	eb 0b                	jmp    802f18 <alloc_block_NF+0x141>
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 40 04             	mov    0x4(%eax),%eax
  802f13:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1b:	8b 40 04             	mov    0x4(%eax),%eax
  802f1e:	85 c0                	test   %eax,%eax
  802f20:	74 0f                	je     802f31 <alloc_block_NF+0x15a>
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f2b:	8b 12                	mov    (%edx),%edx
  802f2d:	89 10                	mov    %edx,(%eax)
  802f2f:	eb 0a                	jmp    802f3b <alloc_block_NF+0x164>
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	a3 38 51 80 00       	mov    %eax,0x805138
  802f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4e:	a1 44 51 80 00       	mov    0x805144,%eax
  802f53:	48                   	dec    %eax
  802f54:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	eb 17                	jmp    802f75 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	8b 00                	mov    (%eax),%eax
  802f63:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802f66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6a:	0f 85 7a fe ff ff    	jne    802dea <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802f70:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802f75:	c9                   	leave  
  802f76:	c3                   	ret    

00802f77 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f77:	55                   	push   %ebp
  802f78:	89 e5                	mov    %esp,%ebp
  802f7a:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802f7d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802f85:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f8a:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802f8d:	a1 44 51 80 00       	mov    0x805144,%eax
  802f92:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802f95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f99:	75 68                	jne    803003 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802f9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9f:	75 17                	jne    802fb8 <insert_sorted_with_merge_freeList+0x41>
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	68 c8 42 80 00       	push   $0x8042c8
  802fa9:	68 da 00 00 00       	push   $0xda
  802fae:	68 eb 42 80 00       	push   $0x8042eb
  802fb3:	e8 d9 d7 ff ff       	call   800791 <_panic>
  802fb8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 0d                	je     802fd9 <insert_sorted_with_merge_freeList+0x62>
  802fcc:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd4:	89 50 04             	mov    %edx,0x4(%eax)
  802fd7:	eb 08                	jmp    802fe1 <insert_sorted_with_merge_freeList+0x6a>
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ff8:	40                   	inc    %eax
  802ff9:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802ffe:	e9 49 07 00 00       	jmp    80374c <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803003:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803006:	8b 50 08             	mov    0x8(%eax),%edx
  803009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300c:	8b 40 0c             	mov    0xc(%eax),%eax
  80300f:	01 c2                	add    %eax,%edx
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 40 08             	mov    0x8(%eax),%eax
  803017:	39 c2                	cmp    %eax,%edx
  803019:	73 77                	jae    803092 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80301b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	75 6e                	jne    803092 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803024:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803028:	74 68                	je     803092 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  80302a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302e:	75 17                	jne    803047 <insert_sorted_with_merge_freeList+0xd0>
  803030:	83 ec 04             	sub    $0x4,%esp
  803033:	68 04 43 80 00       	push   $0x804304
  803038:	68 e0 00 00 00       	push   $0xe0
  80303d:	68 eb 42 80 00       	push   $0x8042eb
  803042:	e8 4a d7 ff ff       	call   800791 <_panic>
  803047:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	89 50 04             	mov    %edx,0x4(%eax)
  803053:	8b 45 08             	mov    0x8(%ebp),%eax
  803056:	8b 40 04             	mov    0x4(%eax),%eax
  803059:	85 c0                	test   %eax,%eax
  80305b:	74 0c                	je     803069 <insert_sorted_with_merge_freeList+0xf2>
  80305d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803062:	8b 55 08             	mov    0x8(%ebp),%edx
  803065:	89 10                	mov    %edx,(%eax)
  803067:	eb 08                	jmp    803071 <insert_sorted_with_merge_freeList+0xfa>
  803069:	8b 45 08             	mov    0x8(%ebp),%eax
  80306c:	a3 38 51 80 00       	mov    %eax,0x805138
  803071:	8b 45 08             	mov    0x8(%ebp),%eax
  803074:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803079:	8b 45 08             	mov    0x8(%ebp),%eax
  80307c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803082:	a1 44 51 80 00       	mov    0x805144,%eax
  803087:	40                   	inc    %eax
  803088:	a3 44 51 80 00       	mov    %eax,0x805144
  80308d:	e9 ba 06 00 00       	jmp    80374c <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	8b 50 0c             	mov    0xc(%eax),%edx
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	8b 40 08             	mov    0x8(%eax),%eax
  80309e:	01 c2                	add    %eax,%edx
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	8b 40 08             	mov    0x8(%eax),%eax
  8030a6:	39 c2                	cmp    %eax,%edx
  8030a8:	73 78                	jae    803122 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8030aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ad:	8b 40 04             	mov    0x4(%eax),%eax
  8030b0:	85 c0                	test   %eax,%eax
  8030b2:	75 6e                	jne    803122 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8030b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030b8:	74 68                	je     803122 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8030ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030be:	75 17                	jne    8030d7 <insert_sorted_with_merge_freeList+0x160>
  8030c0:	83 ec 04             	sub    $0x4,%esp
  8030c3:	68 c8 42 80 00       	push   $0x8042c8
  8030c8:	68 e6 00 00 00       	push   $0xe6
  8030cd:	68 eb 42 80 00       	push   $0x8042eb
  8030d2:	e8 ba d6 ff ff       	call   800791 <_panic>
  8030d7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e0:	89 10                	mov    %edx,(%eax)
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	8b 00                	mov    (%eax),%eax
  8030e7:	85 c0                	test   %eax,%eax
  8030e9:	74 0d                	je     8030f8 <insert_sorted_with_merge_freeList+0x181>
  8030eb:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f3:	89 50 04             	mov    %edx,0x4(%eax)
  8030f6:	eb 08                	jmp    803100 <insert_sorted_with_merge_freeList+0x189>
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	a3 38 51 80 00       	mov    %eax,0x805138
  803108:	8b 45 08             	mov    0x8(%ebp),%eax
  80310b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803112:	a1 44 51 80 00       	mov    0x805144,%eax
  803117:	40                   	inc    %eax
  803118:	a3 44 51 80 00       	mov    %eax,0x805144
  80311d:	e9 2a 06 00 00       	jmp    80374c <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803122:	a1 38 51 80 00       	mov    0x805138,%eax
  803127:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80312a:	e9 ed 05 00 00       	jmp    80371c <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	8b 00                	mov    (%eax),%eax
  803134:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803137:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80313b:	0f 84 a7 00 00 00    	je     8031e8 <insert_sorted_with_merge_freeList+0x271>
  803141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803144:	8b 50 0c             	mov    0xc(%eax),%edx
  803147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314a:	8b 40 08             	mov    0x8(%eax),%eax
  80314d:	01 c2                	add    %eax,%edx
  80314f:	8b 45 08             	mov    0x8(%ebp),%eax
  803152:	8b 40 08             	mov    0x8(%eax),%eax
  803155:	39 c2                	cmp    %eax,%edx
  803157:	0f 83 8b 00 00 00    	jae    8031e8 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	8b 50 0c             	mov    0xc(%eax),%edx
  803163:	8b 45 08             	mov    0x8(%ebp),%eax
  803166:	8b 40 08             	mov    0x8(%eax),%eax
  803169:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  80316b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80316e:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803171:	39 c2                	cmp    %eax,%edx
  803173:	73 73                	jae    8031e8 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803175:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803179:	74 06                	je     803181 <insert_sorted_with_merge_freeList+0x20a>
  80317b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317f:	75 17                	jne    803198 <insert_sorted_with_merge_freeList+0x221>
  803181:	83 ec 04             	sub    $0x4,%esp
  803184:	68 7c 43 80 00       	push   $0x80437c
  803189:	68 f0 00 00 00       	push   $0xf0
  80318e:	68 eb 42 80 00       	push   $0x8042eb
  803193:	e8 f9 d5 ff ff       	call   800791 <_panic>
  803198:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319b:	8b 10                	mov    (%eax),%edx
  80319d:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a0:	89 10                	mov    %edx,(%eax)
  8031a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a5:	8b 00                	mov    (%eax),%eax
  8031a7:	85 c0                	test   %eax,%eax
  8031a9:	74 0b                	je     8031b6 <insert_sorted_with_merge_freeList+0x23f>
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	8b 00                	mov    (%eax),%eax
  8031b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b3:	89 50 04             	mov    %edx,0x4(%eax)
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8031bc:	89 10                	mov    %edx,(%eax)
  8031be:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031c4:	89 50 04             	mov    %edx,0x4(%eax)
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	8b 00                	mov    (%eax),%eax
  8031cc:	85 c0                	test   %eax,%eax
  8031ce:	75 08                	jne    8031d8 <insert_sorted_with_merge_freeList+0x261>
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031d8:	a1 44 51 80 00       	mov    0x805144,%eax
  8031dd:	40                   	inc    %eax
  8031de:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  8031e3:	e9 64 05 00 00       	jmp    80374c <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  8031e8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031ed:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031f5:	8b 40 08             	mov    0x8(%eax),%eax
  8031f8:	01 c2                	add    %eax,%edx
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	8b 40 08             	mov    0x8(%eax),%eax
  803200:	39 c2                	cmp    %eax,%edx
  803202:	0f 85 b1 00 00 00    	jne    8032b9 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803208:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80320d:	85 c0                	test   %eax,%eax
  80320f:	0f 84 a4 00 00 00    	je     8032b9 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803215:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80321a:	8b 00                	mov    (%eax),%eax
  80321c:	85 c0                	test   %eax,%eax
  80321e:	0f 85 95 00 00 00    	jne    8032b9 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803224:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803229:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80322f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803232:	8b 55 08             	mov    0x8(%ebp),%edx
  803235:	8b 52 0c             	mov    0xc(%edx),%edx
  803238:	01 ca                	add    %ecx,%edx
  80323a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  80323d:	8b 45 08             	mov    0x8(%ebp),%eax
  803240:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803247:	8b 45 08             	mov    0x8(%ebp),%eax
  80324a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803255:	75 17                	jne    80326e <insert_sorted_with_merge_freeList+0x2f7>
  803257:	83 ec 04             	sub    $0x4,%esp
  80325a:	68 c8 42 80 00       	push   $0x8042c8
  80325f:	68 ff 00 00 00       	push   $0xff
  803264:	68 eb 42 80 00       	push   $0x8042eb
  803269:	e8 23 d5 ff ff       	call   800791 <_panic>
  80326e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803274:	8b 45 08             	mov    0x8(%ebp),%eax
  803277:	89 10                	mov    %edx,(%eax)
  803279:	8b 45 08             	mov    0x8(%ebp),%eax
  80327c:	8b 00                	mov    (%eax),%eax
  80327e:	85 c0                	test   %eax,%eax
  803280:	74 0d                	je     80328f <insert_sorted_with_merge_freeList+0x318>
  803282:	a1 48 51 80 00       	mov    0x805148,%eax
  803287:	8b 55 08             	mov    0x8(%ebp),%edx
  80328a:	89 50 04             	mov    %edx,0x4(%eax)
  80328d:	eb 08                	jmp    803297 <insert_sorted_with_merge_freeList+0x320>
  80328f:	8b 45 08             	mov    0x8(%ebp),%eax
  803292:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803297:	8b 45 08             	mov    0x8(%ebp),%eax
  80329a:	a3 48 51 80 00       	mov    %eax,0x805148
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a9:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ae:	40                   	inc    %eax
  8032af:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8032b4:	e9 93 04 00 00       	jmp    80374c <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8032b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032bc:	8b 50 08             	mov    0x8(%eax),%edx
  8032bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c5:	01 c2                	add    %eax,%edx
  8032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ca:	8b 40 08             	mov    0x8(%eax),%eax
  8032cd:	39 c2                	cmp    %eax,%edx
  8032cf:	0f 85 ae 00 00 00    	jne    803383 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8032d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d8:	8b 50 0c             	mov    0xc(%eax),%edx
  8032db:	8b 45 08             	mov    0x8(%ebp),%eax
  8032de:	8b 40 08             	mov    0x8(%eax),%eax
  8032e1:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  8032e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e6:	8b 00                	mov    (%eax),%eax
  8032e8:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  8032eb:	39 c2                	cmp    %eax,%edx
  8032ed:	0f 84 90 00 00 00    	je     803383 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  8032f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ff:	01 c2                	add    %eax,%edx
  803301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803304:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803307:	8b 45 08             	mov    0x8(%ebp),%eax
  80330a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80331b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331f:	75 17                	jne    803338 <insert_sorted_with_merge_freeList+0x3c1>
  803321:	83 ec 04             	sub    $0x4,%esp
  803324:	68 c8 42 80 00       	push   $0x8042c8
  803329:	68 0b 01 00 00       	push   $0x10b
  80332e:	68 eb 42 80 00       	push   $0x8042eb
  803333:	e8 59 d4 ff ff       	call   800791 <_panic>
  803338:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80333e:	8b 45 08             	mov    0x8(%ebp),%eax
  803341:	89 10                	mov    %edx,(%eax)
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	8b 00                	mov    (%eax),%eax
  803348:	85 c0                	test   %eax,%eax
  80334a:	74 0d                	je     803359 <insert_sorted_with_merge_freeList+0x3e2>
  80334c:	a1 48 51 80 00       	mov    0x805148,%eax
  803351:	8b 55 08             	mov    0x8(%ebp),%edx
  803354:	89 50 04             	mov    %edx,0x4(%eax)
  803357:	eb 08                	jmp    803361 <insert_sorted_with_merge_freeList+0x3ea>
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	a3 48 51 80 00       	mov    %eax,0x805148
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803373:	a1 54 51 80 00       	mov    0x805154,%eax
  803378:	40                   	inc    %eax
  803379:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80337e:	e9 c9 03 00 00       	jmp    80374c <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	8b 50 0c             	mov    0xc(%eax),%edx
  803389:	8b 45 08             	mov    0x8(%ebp),%eax
  80338c:	8b 40 08             	mov    0x8(%eax),%eax
  80338f:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803394:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803397:	39 c2                	cmp    %eax,%edx
  803399:	0f 85 bb 00 00 00    	jne    80345a <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  80339f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8033a3:	0f 84 b1 00 00 00    	je     80345a <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	8b 40 04             	mov    0x4(%eax),%eax
  8033af:	85 c0                	test   %eax,%eax
  8033b1:	0f 85 a3 00 00 00    	jne    80345a <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8033b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8033bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8033bf:	8b 52 08             	mov    0x8(%edx),%edx
  8033c2:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8033c5:	a1 38 51 80 00       	mov    0x805138,%eax
  8033ca:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033d0:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8033d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d6:	8b 52 0c             	mov    0xc(%edx),%edx
  8033d9:	01 ca                	add    %ecx,%edx
  8033db:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8033de:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8033f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033f6:	75 17                	jne    80340f <insert_sorted_with_merge_freeList+0x498>
  8033f8:	83 ec 04             	sub    $0x4,%esp
  8033fb:	68 c8 42 80 00       	push   $0x8042c8
  803400:	68 17 01 00 00       	push   $0x117
  803405:	68 eb 42 80 00       	push   $0x8042eb
  80340a:	e8 82 d3 ff ff       	call   800791 <_panic>
  80340f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803415:	8b 45 08             	mov    0x8(%ebp),%eax
  803418:	89 10                	mov    %edx,(%eax)
  80341a:	8b 45 08             	mov    0x8(%ebp),%eax
  80341d:	8b 00                	mov    (%eax),%eax
  80341f:	85 c0                	test   %eax,%eax
  803421:	74 0d                	je     803430 <insert_sorted_with_merge_freeList+0x4b9>
  803423:	a1 48 51 80 00       	mov    0x805148,%eax
  803428:	8b 55 08             	mov    0x8(%ebp),%edx
  80342b:	89 50 04             	mov    %edx,0x4(%eax)
  80342e:	eb 08                	jmp    803438 <insert_sorted_with_merge_freeList+0x4c1>
  803430:	8b 45 08             	mov    0x8(%ebp),%eax
  803433:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803438:	8b 45 08             	mov    0x8(%ebp),%eax
  80343b:	a3 48 51 80 00       	mov    %eax,0x805148
  803440:	8b 45 08             	mov    0x8(%ebp),%eax
  803443:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80344a:	a1 54 51 80 00       	mov    0x805154,%eax
  80344f:	40                   	inc    %eax
  803450:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803455:	e9 f2 02 00 00       	jmp    80374c <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  80345a:	8b 45 08             	mov    0x8(%ebp),%eax
  80345d:	8b 50 08             	mov    0x8(%eax),%edx
  803460:	8b 45 08             	mov    0x8(%ebp),%eax
  803463:	8b 40 0c             	mov    0xc(%eax),%eax
  803466:	01 c2                	add    %eax,%edx
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	8b 40 08             	mov    0x8(%eax),%eax
  80346e:	39 c2                	cmp    %eax,%edx
  803470:	0f 85 be 00 00 00    	jne    803534 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803479:	8b 40 04             	mov    0x4(%eax),%eax
  80347c:	8b 50 08             	mov    0x8(%eax),%edx
  80347f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803482:	8b 40 04             	mov    0x4(%eax),%eax
  803485:	8b 40 0c             	mov    0xc(%eax),%eax
  803488:	01 c2                	add    %eax,%edx
  80348a:	8b 45 08             	mov    0x8(%ebp),%eax
  80348d:	8b 40 08             	mov    0x8(%eax),%eax
  803490:	39 c2                	cmp    %eax,%edx
  803492:	0f 84 9c 00 00 00    	je     803534 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  803498:	8b 45 08             	mov    0x8(%ebp),%eax
  80349b:	8b 50 08             	mov    0x8(%eax),%edx
  80349e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a1:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8034a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a7:	8b 50 0c             	mov    0xc(%eax),%edx
  8034aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8034b0:	01 c2                	add    %eax,%edx
  8034b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b5:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8034b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034bb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8034cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034d0:	75 17                	jne    8034e9 <insert_sorted_with_merge_freeList+0x572>
  8034d2:	83 ec 04             	sub    $0x4,%esp
  8034d5:	68 c8 42 80 00       	push   $0x8042c8
  8034da:	68 26 01 00 00       	push   $0x126
  8034df:	68 eb 42 80 00       	push   $0x8042eb
  8034e4:	e8 a8 d2 ff ff       	call   800791 <_panic>
  8034e9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f2:	89 10                	mov    %edx,(%eax)
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	8b 00                	mov    (%eax),%eax
  8034f9:	85 c0                	test   %eax,%eax
  8034fb:	74 0d                	je     80350a <insert_sorted_with_merge_freeList+0x593>
  8034fd:	a1 48 51 80 00       	mov    0x805148,%eax
  803502:	8b 55 08             	mov    0x8(%ebp),%edx
  803505:	89 50 04             	mov    %edx,0x4(%eax)
  803508:	eb 08                	jmp    803512 <insert_sorted_with_merge_freeList+0x59b>
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803512:	8b 45 08             	mov    0x8(%ebp),%eax
  803515:	a3 48 51 80 00       	mov    %eax,0x805148
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803524:	a1 54 51 80 00       	mov    0x805154,%eax
  803529:	40                   	inc    %eax
  80352a:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  80352f:	e9 18 02 00 00       	jmp    80374c <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803537:	8b 50 0c             	mov    0xc(%eax),%edx
  80353a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80353d:	8b 40 08             	mov    0x8(%eax),%eax
  803540:	01 c2                	add    %eax,%edx
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	8b 40 08             	mov    0x8(%eax),%eax
  803548:	39 c2                	cmp    %eax,%edx
  80354a:	0f 85 c4 01 00 00    	jne    803714 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803550:	8b 45 08             	mov    0x8(%ebp),%eax
  803553:	8b 50 0c             	mov    0xc(%eax),%edx
  803556:	8b 45 08             	mov    0x8(%ebp),%eax
  803559:	8b 40 08             	mov    0x8(%eax),%eax
  80355c:	01 c2                	add    %eax,%edx
  80355e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803561:	8b 00                	mov    (%eax),%eax
  803563:	8b 40 08             	mov    0x8(%eax),%eax
  803566:	39 c2                	cmp    %eax,%edx
  803568:	0f 85 a6 01 00 00    	jne    803714 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  80356e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803572:	0f 84 9c 01 00 00    	je     803714 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80357b:	8b 50 0c             	mov    0xc(%eax),%edx
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	8b 40 0c             	mov    0xc(%eax),%eax
  803584:	01 c2                	add    %eax,%edx
  803586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803589:	8b 00                	mov    (%eax),%eax
  80358b:	8b 40 0c             	mov    0xc(%eax),%eax
  80358e:	01 c2                	add    %eax,%edx
  803590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803593:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8035aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035ae:	75 17                	jne    8035c7 <insert_sorted_with_merge_freeList+0x650>
  8035b0:	83 ec 04             	sub    $0x4,%esp
  8035b3:	68 c8 42 80 00       	push   $0x8042c8
  8035b8:	68 32 01 00 00       	push   $0x132
  8035bd:	68 eb 42 80 00       	push   $0x8042eb
  8035c2:	e8 ca d1 ff ff       	call   800791 <_panic>
  8035c7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d0:	89 10                	mov    %edx,(%eax)
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	8b 00                	mov    (%eax),%eax
  8035d7:	85 c0                	test   %eax,%eax
  8035d9:	74 0d                	je     8035e8 <insert_sorted_with_merge_freeList+0x671>
  8035db:	a1 48 51 80 00       	mov    0x805148,%eax
  8035e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e3:	89 50 04             	mov    %edx,0x4(%eax)
  8035e6:	eb 08                	jmp    8035f0 <insert_sorted_with_merge_freeList+0x679>
  8035e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035eb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	a3 48 51 80 00       	mov    %eax,0x805148
  8035f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803602:	a1 54 51 80 00       	mov    0x805154,%eax
  803607:	40                   	inc    %eax
  803608:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  80360d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803610:	8b 00                	mov    (%eax),%eax
  803612:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361c:	8b 00                	mov    (%eax),%eax
  80361e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803628:	8b 00                	mov    (%eax),%eax
  80362a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80362d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803631:	75 17                	jne    80364a <insert_sorted_with_merge_freeList+0x6d3>
  803633:	83 ec 04             	sub    $0x4,%esp
  803636:	68 5d 43 80 00       	push   $0x80435d
  80363b:	68 36 01 00 00       	push   $0x136
  803640:	68 eb 42 80 00       	push   $0x8042eb
  803645:	e8 47 d1 ff ff       	call   800791 <_panic>
  80364a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364d:	8b 00                	mov    (%eax),%eax
  80364f:	85 c0                	test   %eax,%eax
  803651:	74 10                	je     803663 <insert_sorted_with_merge_freeList+0x6ec>
  803653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803656:	8b 00                	mov    (%eax),%eax
  803658:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80365b:	8b 52 04             	mov    0x4(%edx),%edx
  80365e:	89 50 04             	mov    %edx,0x4(%eax)
  803661:	eb 0b                	jmp    80366e <insert_sorted_with_merge_freeList+0x6f7>
  803663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803666:	8b 40 04             	mov    0x4(%eax),%eax
  803669:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80366e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803671:	8b 40 04             	mov    0x4(%eax),%eax
  803674:	85 c0                	test   %eax,%eax
  803676:	74 0f                	je     803687 <insert_sorted_with_merge_freeList+0x710>
  803678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80367b:	8b 40 04             	mov    0x4(%eax),%eax
  80367e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803681:	8b 12                	mov    (%edx),%edx
  803683:	89 10                	mov    %edx,(%eax)
  803685:	eb 0a                	jmp    803691 <insert_sorted_with_merge_freeList+0x71a>
  803687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368a:	8b 00                	mov    (%eax),%eax
  80368c:	a3 38 51 80 00       	mov    %eax,0x805138
  803691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803694:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80369a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80369d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036a4:	a1 44 51 80 00       	mov    0x805144,%eax
  8036a9:	48                   	dec    %eax
  8036aa:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8036af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8036b3:	75 17                	jne    8036cc <insert_sorted_with_merge_freeList+0x755>
  8036b5:	83 ec 04             	sub    $0x4,%esp
  8036b8:	68 c8 42 80 00       	push   $0x8042c8
  8036bd:	68 37 01 00 00       	push   $0x137
  8036c2:	68 eb 42 80 00       	push   $0x8042eb
  8036c7:	e8 c5 d0 ff ff       	call   800791 <_panic>
  8036cc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036d5:	89 10                	mov    %edx,(%eax)
  8036d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036da:	8b 00                	mov    (%eax),%eax
  8036dc:	85 c0                	test   %eax,%eax
  8036de:	74 0d                	je     8036ed <insert_sorted_with_merge_freeList+0x776>
  8036e0:	a1 48 51 80 00       	mov    0x805148,%eax
  8036e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8036e8:	89 50 04             	mov    %edx,0x4(%eax)
  8036eb:	eb 08                	jmp    8036f5 <insert_sorted_with_merge_freeList+0x77e>
  8036ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036f8:	a3 48 51 80 00       	mov    %eax,0x805148
  8036fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803700:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803707:	a1 54 51 80 00       	mov    0x805154,%eax
  80370c:	40                   	inc    %eax
  80370d:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803712:	eb 38                	jmp    80374c <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803714:	a1 40 51 80 00       	mov    0x805140,%eax
  803719:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80371c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803720:	74 07                	je     803729 <insert_sorted_with_merge_freeList+0x7b2>
  803722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803725:	8b 00                	mov    (%eax),%eax
  803727:	eb 05                	jmp    80372e <insert_sorted_with_merge_freeList+0x7b7>
  803729:	b8 00 00 00 00       	mov    $0x0,%eax
  80372e:	a3 40 51 80 00       	mov    %eax,0x805140
  803733:	a1 40 51 80 00       	mov    0x805140,%eax
  803738:	85 c0                	test   %eax,%eax
  80373a:	0f 85 ef f9 ff ff    	jne    80312f <insert_sorted_with_merge_freeList+0x1b8>
  803740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803744:	0f 85 e5 f9 ff ff    	jne    80312f <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80374a:	eb 00                	jmp    80374c <insert_sorted_with_merge_freeList+0x7d5>
  80374c:	90                   	nop
  80374d:	c9                   	leave  
  80374e:	c3                   	ret    
  80374f:	90                   	nop

00803750 <__udivdi3>:
  803750:	55                   	push   %ebp
  803751:	57                   	push   %edi
  803752:	56                   	push   %esi
  803753:	53                   	push   %ebx
  803754:	83 ec 1c             	sub    $0x1c,%esp
  803757:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80375b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80375f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803763:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803767:	89 ca                	mov    %ecx,%edx
  803769:	89 f8                	mov    %edi,%eax
  80376b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80376f:	85 f6                	test   %esi,%esi
  803771:	75 2d                	jne    8037a0 <__udivdi3+0x50>
  803773:	39 cf                	cmp    %ecx,%edi
  803775:	77 65                	ja     8037dc <__udivdi3+0x8c>
  803777:	89 fd                	mov    %edi,%ebp
  803779:	85 ff                	test   %edi,%edi
  80377b:	75 0b                	jne    803788 <__udivdi3+0x38>
  80377d:	b8 01 00 00 00       	mov    $0x1,%eax
  803782:	31 d2                	xor    %edx,%edx
  803784:	f7 f7                	div    %edi
  803786:	89 c5                	mov    %eax,%ebp
  803788:	31 d2                	xor    %edx,%edx
  80378a:	89 c8                	mov    %ecx,%eax
  80378c:	f7 f5                	div    %ebp
  80378e:	89 c1                	mov    %eax,%ecx
  803790:	89 d8                	mov    %ebx,%eax
  803792:	f7 f5                	div    %ebp
  803794:	89 cf                	mov    %ecx,%edi
  803796:	89 fa                	mov    %edi,%edx
  803798:	83 c4 1c             	add    $0x1c,%esp
  80379b:	5b                   	pop    %ebx
  80379c:	5e                   	pop    %esi
  80379d:	5f                   	pop    %edi
  80379e:	5d                   	pop    %ebp
  80379f:	c3                   	ret    
  8037a0:	39 ce                	cmp    %ecx,%esi
  8037a2:	77 28                	ja     8037cc <__udivdi3+0x7c>
  8037a4:	0f bd fe             	bsr    %esi,%edi
  8037a7:	83 f7 1f             	xor    $0x1f,%edi
  8037aa:	75 40                	jne    8037ec <__udivdi3+0x9c>
  8037ac:	39 ce                	cmp    %ecx,%esi
  8037ae:	72 0a                	jb     8037ba <__udivdi3+0x6a>
  8037b0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8037b4:	0f 87 9e 00 00 00    	ja     803858 <__udivdi3+0x108>
  8037ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8037bf:	89 fa                	mov    %edi,%edx
  8037c1:	83 c4 1c             	add    $0x1c,%esp
  8037c4:	5b                   	pop    %ebx
  8037c5:	5e                   	pop    %esi
  8037c6:	5f                   	pop    %edi
  8037c7:	5d                   	pop    %ebp
  8037c8:	c3                   	ret    
  8037c9:	8d 76 00             	lea    0x0(%esi),%esi
  8037cc:	31 ff                	xor    %edi,%edi
  8037ce:	31 c0                	xor    %eax,%eax
  8037d0:	89 fa                	mov    %edi,%edx
  8037d2:	83 c4 1c             	add    $0x1c,%esp
  8037d5:	5b                   	pop    %ebx
  8037d6:	5e                   	pop    %esi
  8037d7:	5f                   	pop    %edi
  8037d8:	5d                   	pop    %ebp
  8037d9:	c3                   	ret    
  8037da:	66 90                	xchg   %ax,%ax
  8037dc:	89 d8                	mov    %ebx,%eax
  8037de:	f7 f7                	div    %edi
  8037e0:	31 ff                	xor    %edi,%edi
  8037e2:	89 fa                	mov    %edi,%edx
  8037e4:	83 c4 1c             	add    $0x1c,%esp
  8037e7:	5b                   	pop    %ebx
  8037e8:	5e                   	pop    %esi
  8037e9:	5f                   	pop    %edi
  8037ea:	5d                   	pop    %ebp
  8037eb:	c3                   	ret    
  8037ec:	bd 20 00 00 00       	mov    $0x20,%ebp
  8037f1:	89 eb                	mov    %ebp,%ebx
  8037f3:	29 fb                	sub    %edi,%ebx
  8037f5:	89 f9                	mov    %edi,%ecx
  8037f7:	d3 e6                	shl    %cl,%esi
  8037f9:	89 c5                	mov    %eax,%ebp
  8037fb:	88 d9                	mov    %bl,%cl
  8037fd:	d3 ed                	shr    %cl,%ebp
  8037ff:	89 e9                	mov    %ebp,%ecx
  803801:	09 f1                	or     %esi,%ecx
  803803:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803807:	89 f9                	mov    %edi,%ecx
  803809:	d3 e0                	shl    %cl,%eax
  80380b:	89 c5                	mov    %eax,%ebp
  80380d:	89 d6                	mov    %edx,%esi
  80380f:	88 d9                	mov    %bl,%cl
  803811:	d3 ee                	shr    %cl,%esi
  803813:	89 f9                	mov    %edi,%ecx
  803815:	d3 e2                	shl    %cl,%edx
  803817:	8b 44 24 08          	mov    0x8(%esp),%eax
  80381b:	88 d9                	mov    %bl,%cl
  80381d:	d3 e8                	shr    %cl,%eax
  80381f:	09 c2                	or     %eax,%edx
  803821:	89 d0                	mov    %edx,%eax
  803823:	89 f2                	mov    %esi,%edx
  803825:	f7 74 24 0c          	divl   0xc(%esp)
  803829:	89 d6                	mov    %edx,%esi
  80382b:	89 c3                	mov    %eax,%ebx
  80382d:	f7 e5                	mul    %ebp
  80382f:	39 d6                	cmp    %edx,%esi
  803831:	72 19                	jb     80384c <__udivdi3+0xfc>
  803833:	74 0b                	je     803840 <__udivdi3+0xf0>
  803835:	89 d8                	mov    %ebx,%eax
  803837:	31 ff                	xor    %edi,%edi
  803839:	e9 58 ff ff ff       	jmp    803796 <__udivdi3+0x46>
  80383e:	66 90                	xchg   %ax,%ax
  803840:	8b 54 24 08          	mov    0x8(%esp),%edx
  803844:	89 f9                	mov    %edi,%ecx
  803846:	d3 e2                	shl    %cl,%edx
  803848:	39 c2                	cmp    %eax,%edx
  80384a:	73 e9                	jae    803835 <__udivdi3+0xe5>
  80384c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80384f:	31 ff                	xor    %edi,%edi
  803851:	e9 40 ff ff ff       	jmp    803796 <__udivdi3+0x46>
  803856:	66 90                	xchg   %ax,%ax
  803858:	31 c0                	xor    %eax,%eax
  80385a:	e9 37 ff ff ff       	jmp    803796 <__udivdi3+0x46>
  80385f:	90                   	nop

00803860 <__umoddi3>:
  803860:	55                   	push   %ebp
  803861:	57                   	push   %edi
  803862:	56                   	push   %esi
  803863:	53                   	push   %ebx
  803864:	83 ec 1c             	sub    $0x1c,%esp
  803867:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80386b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80386f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803873:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803877:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80387b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80387f:	89 f3                	mov    %esi,%ebx
  803881:	89 fa                	mov    %edi,%edx
  803883:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803887:	89 34 24             	mov    %esi,(%esp)
  80388a:	85 c0                	test   %eax,%eax
  80388c:	75 1a                	jne    8038a8 <__umoddi3+0x48>
  80388e:	39 f7                	cmp    %esi,%edi
  803890:	0f 86 a2 00 00 00    	jbe    803938 <__umoddi3+0xd8>
  803896:	89 c8                	mov    %ecx,%eax
  803898:	89 f2                	mov    %esi,%edx
  80389a:	f7 f7                	div    %edi
  80389c:	89 d0                	mov    %edx,%eax
  80389e:	31 d2                	xor    %edx,%edx
  8038a0:	83 c4 1c             	add    $0x1c,%esp
  8038a3:	5b                   	pop    %ebx
  8038a4:	5e                   	pop    %esi
  8038a5:	5f                   	pop    %edi
  8038a6:	5d                   	pop    %ebp
  8038a7:	c3                   	ret    
  8038a8:	39 f0                	cmp    %esi,%eax
  8038aa:	0f 87 ac 00 00 00    	ja     80395c <__umoddi3+0xfc>
  8038b0:	0f bd e8             	bsr    %eax,%ebp
  8038b3:	83 f5 1f             	xor    $0x1f,%ebp
  8038b6:	0f 84 ac 00 00 00    	je     803968 <__umoddi3+0x108>
  8038bc:	bf 20 00 00 00       	mov    $0x20,%edi
  8038c1:	29 ef                	sub    %ebp,%edi
  8038c3:	89 fe                	mov    %edi,%esi
  8038c5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8038c9:	89 e9                	mov    %ebp,%ecx
  8038cb:	d3 e0                	shl    %cl,%eax
  8038cd:	89 d7                	mov    %edx,%edi
  8038cf:	89 f1                	mov    %esi,%ecx
  8038d1:	d3 ef                	shr    %cl,%edi
  8038d3:	09 c7                	or     %eax,%edi
  8038d5:	89 e9                	mov    %ebp,%ecx
  8038d7:	d3 e2                	shl    %cl,%edx
  8038d9:	89 14 24             	mov    %edx,(%esp)
  8038dc:	89 d8                	mov    %ebx,%eax
  8038de:	d3 e0                	shl    %cl,%eax
  8038e0:	89 c2                	mov    %eax,%edx
  8038e2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038e6:	d3 e0                	shl    %cl,%eax
  8038e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038ec:	8b 44 24 08          	mov    0x8(%esp),%eax
  8038f0:	89 f1                	mov    %esi,%ecx
  8038f2:	d3 e8                	shr    %cl,%eax
  8038f4:	09 d0                	or     %edx,%eax
  8038f6:	d3 eb                	shr    %cl,%ebx
  8038f8:	89 da                	mov    %ebx,%edx
  8038fa:	f7 f7                	div    %edi
  8038fc:	89 d3                	mov    %edx,%ebx
  8038fe:	f7 24 24             	mull   (%esp)
  803901:	89 c6                	mov    %eax,%esi
  803903:	89 d1                	mov    %edx,%ecx
  803905:	39 d3                	cmp    %edx,%ebx
  803907:	0f 82 87 00 00 00    	jb     803994 <__umoddi3+0x134>
  80390d:	0f 84 91 00 00 00    	je     8039a4 <__umoddi3+0x144>
  803913:	8b 54 24 04          	mov    0x4(%esp),%edx
  803917:	29 f2                	sub    %esi,%edx
  803919:	19 cb                	sbb    %ecx,%ebx
  80391b:	89 d8                	mov    %ebx,%eax
  80391d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803921:	d3 e0                	shl    %cl,%eax
  803923:	89 e9                	mov    %ebp,%ecx
  803925:	d3 ea                	shr    %cl,%edx
  803927:	09 d0                	or     %edx,%eax
  803929:	89 e9                	mov    %ebp,%ecx
  80392b:	d3 eb                	shr    %cl,%ebx
  80392d:	89 da                	mov    %ebx,%edx
  80392f:	83 c4 1c             	add    $0x1c,%esp
  803932:	5b                   	pop    %ebx
  803933:	5e                   	pop    %esi
  803934:	5f                   	pop    %edi
  803935:	5d                   	pop    %ebp
  803936:	c3                   	ret    
  803937:	90                   	nop
  803938:	89 fd                	mov    %edi,%ebp
  80393a:	85 ff                	test   %edi,%edi
  80393c:	75 0b                	jne    803949 <__umoddi3+0xe9>
  80393e:	b8 01 00 00 00       	mov    $0x1,%eax
  803943:	31 d2                	xor    %edx,%edx
  803945:	f7 f7                	div    %edi
  803947:	89 c5                	mov    %eax,%ebp
  803949:	89 f0                	mov    %esi,%eax
  80394b:	31 d2                	xor    %edx,%edx
  80394d:	f7 f5                	div    %ebp
  80394f:	89 c8                	mov    %ecx,%eax
  803951:	f7 f5                	div    %ebp
  803953:	89 d0                	mov    %edx,%eax
  803955:	e9 44 ff ff ff       	jmp    80389e <__umoddi3+0x3e>
  80395a:	66 90                	xchg   %ax,%ax
  80395c:	89 c8                	mov    %ecx,%eax
  80395e:	89 f2                	mov    %esi,%edx
  803960:	83 c4 1c             	add    $0x1c,%esp
  803963:	5b                   	pop    %ebx
  803964:	5e                   	pop    %esi
  803965:	5f                   	pop    %edi
  803966:	5d                   	pop    %ebp
  803967:	c3                   	ret    
  803968:	3b 04 24             	cmp    (%esp),%eax
  80396b:	72 06                	jb     803973 <__umoddi3+0x113>
  80396d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803971:	77 0f                	ja     803982 <__umoddi3+0x122>
  803973:	89 f2                	mov    %esi,%edx
  803975:	29 f9                	sub    %edi,%ecx
  803977:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80397b:	89 14 24             	mov    %edx,(%esp)
  80397e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803982:	8b 44 24 04          	mov    0x4(%esp),%eax
  803986:	8b 14 24             	mov    (%esp),%edx
  803989:	83 c4 1c             	add    $0x1c,%esp
  80398c:	5b                   	pop    %ebx
  80398d:	5e                   	pop    %esi
  80398e:	5f                   	pop    %edi
  80398f:	5d                   	pop    %ebp
  803990:	c3                   	ret    
  803991:	8d 76 00             	lea    0x0(%esi),%esi
  803994:	2b 04 24             	sub    (%esp),%eax
  803997:	19 fa                	sbb    %edi,%edx
  803999:	89 d1                	mov    %edx,%ecx
  80399b:	89 c6                	mov    %eax,%esi
  80399d:	e9 71 ff ff ff       	jmp    803913 <__umoddi3+0xb3>
  8039a2:	66 90                	xchg   %ax,%ax
  8039a4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8039a8:	72 ea                	jb     803994 <__umoddi3+0x134>
  8039aa:	89 d9                	mov    %ebx,%ecx
  8039ac:	e9 62 ff ff ff       	jmp    803913 <__umoddi3+0xb3>
