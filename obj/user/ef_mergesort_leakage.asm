
obj/user/ef_mergesort_leakage:     file format elf32-i386


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
  800031:	e8 9a 07 00 00       	call   8007d0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	char Line[255] ;
	char Chose ;
	int numOfRep = 0;
  800041:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{
		numOfRep++ ;
  800048:	ff 45 f0             	incl   -0x10(%ebp)
		//2012: lock the interrupt
		sys_disable_interrupt();
  80004b:	e8 9a 20 00 00       	call   8020ea <sys_disable_interrupt>

		cprintf("\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 40 39 80 00       	push   $0x803940
  800058:	e8 63 0b 00 00       	call   800bc0 <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	68 42 39 80 00       	push   $0x803942
  800068:	e8 53 0b 00 00       	call   800bc0 <cprintf>
  80006d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800070:	83 ec 0c             	sub    $0xc,%esp
  800073:	68 58 39 80 00       	push   $0x803958
  800078:	e8 43 0b 00 00       	call   800bc0 <cprintf>
  80007d:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800080:	83 ec 0c             	sub    $0xc,%esp
  800083:	68 42 39 80 00       	push   $0x803942
  800088:	e8 33 0b 00 00       	call   800bc0 <cprintf>
  80008d:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	68 40 39 80 00       	push   $0x803940
  800098:	e8 23 0b 00 00       	call   800bc0 <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
		cprintf("Enter the number of elements: ");
  8000a0:	83 ec 0c             	sub    $0xc,%esp
  8000a3:	68 70 39 80 00       	push   $0x803970
  8000a8:	e8 13 0b 00 00       	call   800bc0 <cprintf>
  8000ad:	83 c4 10             	add    $0x10,%esp

		int NumOfElements ;

		if (numOfRep == 1)
  8000b0:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  8000b4:	75 09                	jne    8000bf <_main+0x87>
			NumOfElements = 32;
  8000b6:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)
  8000bd:	eb 0d                	jmp    8000cc <_main+0x94>
		else if (numOfRep == 2)
  8000bf:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8000c3:	75 07                	jne    8000cc <_main+0x94>
			NumOfElements = 32;
  8000c5:	c7 45 ec 20 00 00 00 	movl   $0x20,-0x14(%ebp)

		cprintf("%d\n", NumOfElements) ;
  8000cc:	83 ec 08             	sub    $0x8,%esp
  8000cf:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d2:	68 8f 39 80 00       	push   $0x80398f
  8000d7:	e8 e4 0a 00 00       	call   800bc0 <cprintf>
  8000dc:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e2:	c1 e0 02             	shl    $0x2,%eax
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	50                   	push   %eax
  8000e9:	e8 71 1a 00 00       	call   801b5f <malloc>
  8000ee:	83 c4 10             	add    $0x10,%esp
  8000f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	68 94 39 80 00       	push   $0x803994
  8000fc:	e8 bf 0a 00 00       	call   800bc0 <cprintf>
  800101:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  800104:	83 ec 0c             	sub    $0xc,%esp
  800107:	68 b6 39 80 00       	push   $0x8039b6
  80010c:	e8 af 0a 00 00       	call   800bc0 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 c4 39 80 00       	push   $0x8039c4
  80011c:	e8 9f 0a 00 00       	call   800bc0 <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 d3 39 80 00       	push   $0x8039d3
  80012c:	e8 8f 0a 00 00       	call   800bc0 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 e3 39 80 00       	push   $0x8039e3
  80013c:	e8 7f 0a 00 00       	call   800bc0 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  800144:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800148:	75 06                	jne    800150 <_main+0x118>
				Chose = 'a' ;
  80014a:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
  80014e:	eb 0a                	jmp    80015a <_main+0x122>
			else if (numOfRep == 2)
  800150:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  800154:	75 04                	jne    80015a <_main+0x122>
				Chose = 'c' ;
  800156:	c6 45 f7 63          	movb   $0x63,-0x9(%ebp)
			cputchar(Chose);
  80015a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015e:	83 ec 0c             	sub    $0xc,%esp
  800161:	50                   	push   %eax
  800162:	e8 c9 05 00 00       	call   800730 <cputchar>
  800167:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	6a 0a                	push   $0xa
  80016f:	e8 bc 05 00 00       	call   800730 <cputchar>
  800174:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800177:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80017b:	74 0c                	je     800189 <_main+0x151>
  80017d:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800181:	74 06                	je     800189 <_main+0x151>
  800183:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800187:	75 ab                	jne    800134 <_main+0xfc>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800189:	e8 76 1f 00 00       	call   802104 <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80018e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800192:	83 f8 62             	cmp    $0x62,%eax
  800195:	74 1d                	je     8001b4 <_main+0x17c>
  800197:	83 f8 63             	cmp    $0x63,%eax
  80019a:	74 2b                	je     8001c7 <_main+0x18f>
  80019c:	83 f8 61             	cmp    $0x61,%eax
  80019f:	75 39                	jne    8001da <_main+0x1a2>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  8001a1:	83 ec 08             	sub    $0x8,%esp
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8001aa:	e8 f4 01 00 00       	call   8003a3 <InitializeAscending>
  8001af:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b2:	eb 37                	jmp    8001eb <_main+0x1b3>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8001bd:	e8 12 02 00 00       	call   8003d4 <InitializeDescending>
  8001c2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001c5:	eb 24                	jmp    8001eb <_main+0x1b3>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001c7:	83 ec 08             	sub    $0x8,%esp
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d0:	e8 34 02 00 00       	call   800409 <InitializeSemiRandom>
  8001d5:	83 c4 10             	add    $0x10,%esp
			break ;
  8001d8:	eb 11                	jmp    8001eb <_main+0x1b3>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e3:	e8 21 02 00 00       	call   800409 <InitializeSemiRandom>
  8001e8:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f1:	6a 01                	push   $0x1
  8001f3:	ff 75 e8             	pushl  -0x18(%ebp)
  8001f6:	e8 e0 02 00 00       	call   8004db <MSort>
  8001fb:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001fe:	e8 e7 1e 00 00       	call   8020ea <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  800203:	83 ec 0c             	sub    $0xc,%esp
  800206:	68 ec 39 80 00       	push   $0x8039ec
  80020b:	e8 b0 09 00 00       	call   800bc0 <cprintf>
  800210:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  800213:	e8 ec 1e 00 00       	call   802104 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	ff 75 ec             	pushl  -0x14(%ebp)
  80021e:	ff 75 e8             	pushl  -0x18(%ebp)
  800221:	e8 d3 00 00 00       	call   8002f9 <CheckSorted>
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  80022c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800230:	75 14                	jne    800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 20 3a 80 00       	push   $0x803a20
  80023a:	6a 58                	push   $0x58
  80023c:	68 42 3a 80 00       	push   $0x803a42
  800241:	e8 c6 06 00 00       	call   80090c <_panic>
		else
		{
			sys_disable_interrupt();
  800246:	e8 9f 1e 00 00       	call   8020ea <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80024b:	83 ec 0c             	sub    $0xc,%esp
  80024e:	68 60 3a 80 00       	push   $0x803a60
  800253:	e8 68 09 00 00       	call   800bc0 <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	68 94 3a 80 00       	push   $0x803a94
  800263:	e8 58 09 00 00       	call   800bc0 <cprintf>
  800268:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80026b:	83 ec 0c             	sub    $0xc,%esp
  80026e:	68 c8 3a 80 00       	push   $0x803ac8
  800273:	e8 48 09 00 00       	call   800bc0 <cprintf>
  800278:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80027b:	e8 84 1e 00 00       	call   802104 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800280:	e8 65 1e 00 00       	call   8020ea <sys_disable_interrupt>
		Chose = 0 ;
  800285:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  800289:	eb 50                	jmp    8002db <_main+0x2a3>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  80028b:	83 ec 0c             	sub    $0xc,%esp
  80028e:	68 fa 3a 80 00       	push   $0x803afa
  800293:	e8 28 09 00 00       	call   800bc0 <cprintf>
  800298:	83 c4 10             	add    $0x10,%esp
			if (numOfRep == 1)
  80029b:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  80029f:	75 06                	jne    8002a7 <_main+0x26f>
				Chose = 'y' ;
  8002a1:	c6 45 f7 79          	movb   $0x79,-0x9(%ebp)
  8002a5:	eb 0a                	jmp    8002b1 <_main+0x279>
			else if (numOfRep == 2)
  8002a7:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002ab:	75 04                	jne    8002b1 <_main+0x279>
				Chose = 'n' ;
  8002ad:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
			cputchar(Chose);
  8002b1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8002b5:	83 ec 0c             	sub    $0xc,%esp
  8002b8:	50                   	push   %eax
  8002b9:	e8 72 04 00 00       	call   800730 <cputchar>
  8002be:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002c1:	83 ec 0c             	sub    $0xc,%esp
  8002c4:	6a 0a                	push   $0xa
  8002c6:	e8 65 04 00 00       	call   800730 <cputchar>
  8002cb:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	6a 0a                	push   $0xa
  8002d3:	e8 58 04 00 00       	call   800730 <cputchar>
  8002d8:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  8002db:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002df:	74 06                	je     8002e7 <_main+0x2af>
  8002e1:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002e5:	75 a4                	jne    80028b <_main+0x253>
				Chose = 'n' ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
		sys_enable_interrupt();
  8002e7:	e8 18 1e 00 00       	call   802104 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002ec:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002f0:	0f 84 52 fd ff ff    	je     800048 <_main+0x10>
}
  8002f6:	90                   	nop
  8002f7:	c9                   	leave  
  8002f8:	c3                   	ret    

008002f9 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ff:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800306:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80030d:	eb 33                	jmp    800342 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80030f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800319:	8b 45 08             	mov    0x8(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	8b 10                	mov    (%eax),%edx
  800320:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800323:	40                   	inc    %eax
  800324:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 c8                	add    %ecx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	39 c2                	cmp    %eax,%edx
  800334:	7e 09                	jle    80033f <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800336:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  80033d:	eb 0c                	jmp    80034b <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80033f:	ff 45 f8             	incl   -0x8(%ebp)
  800342:	8b 45 0c             	mov    0xc(%ebp),%eax
  800345:	48                   	dec    %eax
  800346:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800349:	7f c4                	jg     80030f <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  80034b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80034e:	c9                   	leave  
  80034f:	c3                   	ret    

00800350 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800356:	8b 45 0c             	mov    0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 08             	mov    0x8(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 00                	mov    (%eax),%eax
  800367:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  80036a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800374:	8b 45 08             	mov    0x8(%ebp),%eax
  800377:	01 c2                	add    %eax,%edx
  800379:	8b 45 10             	mov    0x10(%ebp),%eax
  80037c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	01 c8                	add    %ecx,%eax
  800388:	8b 00                	mov    (%eax),%eax
  80038a:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	01 c2                	add    %eax,%edx
  80039b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039e:	89 02                	mov    %eax,(%edx)
}
  8003a0:	90                   	nop
  8003a1:	c9                   	leave  
  8003a2:	c3                   	ret    

008003a3 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  8003a3:	55                   	push   %ebp
  8003a4:	89 e5                	mov    %esp,%ebp
  8003a6:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003b0:	eb 17                	jmp    8003c9 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  8003b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bf:	01 c2                	add    %eax,%edx
  8003c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c e1                	jl     8003b2 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003e1:	eb 1b                	jmp    8003fe <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 c2                	add    %eax,%edx
  8003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f5:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003f8:	48                   	dec    %eax
  8003f9:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003fb:	ff 45 fc             	incl   -0x4(%ebp)
  8003fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800401:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800404:	7c dd                	jl     8003e3 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800406:	90                   	nop
  800407:	c9                   	leave  
  800408:	c3                   	ret    

00800409 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800409:	55                   	push   %ebp
  80040a:	89 e5                	mov    %esp,%ebp
  80040c:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80040f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800412:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800417:	f7 e9                	imul   %ecx
  800419:	c1 f9 1f             	sar    $0x1f,%ecx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	29 c8                	sub    %ecx,%eax
  800420:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800423:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80042a:	eb 1e                	jmp    80044a <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80042c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80043c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043f:	99                   	cltd   
  800440:	f7 7d f8             	idivl  -0x8(%ebp)
  800443:	89 d0                	mov    %edx,%eax
  800445:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800447:	ff 45 fc             	incl   -0x4(%ebp)
  80044a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80044d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800450:	7c da                	jl     80042c <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  800452:	90                   	nop
  800453:	c9                   	leave  
  800454:	c3                   	ret    

00800455 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800455:	55                   	push   %ebp
  800456:	89 e5                	mov    %esp,%ebp
  800458:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  80045b:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800462:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800469:	eb 42                	jmp    8004ad <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  80046b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80046e:	99                   	cltd   
  80046f:	f7 7d f0             	idivl  -0x10(%ebp)
  800472:	89 d0                	mov    %edx,%eax
  800474:	85 c0                	test   %eax,%eax
  800476:	75 10                	jne    800488 <PrintElements+0x33>
			cprintf("\n");
  800478:	83 ec 0c             	sub    $0xc,%esp
  80047b:	68 40 39 80 00       	push   $0x803940
  800480:	e8 3b 07 00 00       	call   800bc0 <cprintf>
  800485:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800492:	8b 45 08             	mov    0x8(%ebp),%eax
  800495:	01 d0                	add    %edx,%eax
  800497:	8b 00                	mov    (%eax),%eax
  800499:	83 ec 08             	sub    $0x8,%esp
  80049c:	50                   	push   %eax
  80049d:	68 18 3b 80 00       	push   $0x803b18
  8004a2:	e8 19 07 00 00       	call   800bc0 <cprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004aa:	ff 45 f4             	incl   -0xc(%ebp)
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	48                   	dec    %eax
  8004b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004b4:	7f b5                	jg     80046b <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8004b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c3:	01 d0                	add    %edx,%eax
  8004c5:	8b 00                	mov    (%eax),%eax
  8004c7:	83 ec 08             	sub    $0x8,%esp
  8004ca:	50                   	push   %eax
  8004cb:	68 8f 39 80 00       	push   $0x80398f
  8004d0:	e8 eb 06 00 00       	call   800bc0 <cprintf>
  8004d5:	83 c4 10             	add    $0x10,%esp

}
  8004d8:	90                   	nop
  8004d9:	c9                   	leave  
  8004da:	c3                   	ret    

008004db <MSort>:


void MSort(int* A, int p, int r)
{
  8004db:	55                   	push   %ebp
  8004dc:	89 e5                	mov    %esp,%ebp
  8004de:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004e7:	7d 54                	jge    80053d <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ef:	01 d0                	add    %edx,%eax
  8004f1:	89 c2                	mov    %eax,%edx
  8004f3:	c1 ea 1f             	shr    $0x1f,%edx
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	d1 f8                	sar    %eax
  8004fa:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004fd:	83 ec 04             	sub    $0x4,%esp
  800500:	ff 75 f4             	pushl  -0xc(%ebp)
  800503:	ff 75 0c             	pushl  0xc(%ebp)
  800506:	ff 75 08             	pushl  0x8(%ebp)
  800509:	e8 cd ff ff ff       	call   8004db <MSort>
  80050e:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  800511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800514:	40                   	inc    %eax
  800515:	83 ec 04             	sub    $0x4,%esp
  800518:	ff 75 10             	pushl  0x10(%ebp)
  80051b:	50                   	push   %eax
  80051c:	ff 75 08             	pushl  0x8(%ebp)
  80051f:	e8 b7 ff ff ff       	call   8004db <MSort>
  800524:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800527:	ff 75 10             	pushl  0x10(%ebp)
  80052a:	ff 75 f4             	pushl  -0xc(%ebp)
  80052d:	ff 75 0c             	pushl  0xc(%ebp)
  800530:	ff 75 08             	pushl  0x8(%ebp)
  800533:	e8 08 00 00 00       	call   800540 <Merge>
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb 01                	jmp    80053e <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  80053d:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800546:	8b 45 10             	mov    0x10(%ebp),%eax
  800549:	2b 45 0c             	sub    0xc(%ebp),%eax
  80054c:	40                   	inc    %eax
  80054d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	2b 45 10             	sub    0x10(%ebp),%eax
  800556:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800559:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800560:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800567:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80056a:	c1 e0 02             	shl    $0x2,%eax
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	50                   	push   %eax
  800571:	e8 e9 15 00 00       	call   801b5f <malloc>
  800576:	83 c4 10             	add    $0x10,%esp
  800579:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  80057c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057f:	c1 e0 02             	shl    $0x2,%eax
  800582:	83 ec 0c             	sub    $0xc,%esp
  800585:	50                   	push   %eax
  800586:	e8 d4 15 00 00       	call   801b5f <malloc>
  80058b:	83 c4 10             	add    $0x10,%esp
  80058e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800598:	eb 2f                	jmp    8005c9 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  80059a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80059d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a7:	01 c2                	add    %eax,%edx
  8005a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005af:	01 c8                	add    %ecx,%eax
  8005b1:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8005b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c0:	01 c8                	add    %ecx,%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8005c6:	ff 45 ec             	incl   -0x14(%ebp)
  8005c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005cc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005cf:	7c c9                	jl     80059a <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005d8:	eb 2a                	jmp    800604 <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005e7:	01 c2                	add    %eax,%edx
  8005e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ef:	01 c8                	add    %ecx,%eax
  8005f1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fb:	01 c8                	add    %ecx,%eax
  8005fd:	8b 00                	mov    (%eax),%eax
  8005ff:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800601:	ff 45 e8             	incl   -0x18(%ebp)
  800604:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800607:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80060a:	7c ce                	jl     8005da <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800612:	e9 0a 01 00 00       	jmp    800721 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  800617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80061a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80061d:	0f 8d 95 00 00 00    	jge    8006b8 <Merge+0x178>
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800626:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800629:	0f 8d 89 00 00 00    	jge    8006b8 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80062f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800632:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800639:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80063c:	01 d0                	add    %edx,%eax
  80063e:	8b 10                	mov    (%eax),%edx
  800640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800643:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80064d:	01 c8                	add    %ecx,%eax
  80064f:	8b 00                	mov    (%eax),%eax
  800651:	39 c2                	cmp    %eax,%edx
  800653:	7d 33                	jge    800688 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800658:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80066a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80066d:	8d 50 01             	lea    0x1(%eax),%edx
  800670:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800673:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80067a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80067d:	01 d0                	add    %edx,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800683:	e9 96 00 00 00       	jmp    80071e <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068b:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800690:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800697:	8b 45 08             	mov    0x8(%ebp),%eax
  80069a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80069d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006a0:	8d 50 01             	lea    0x1(%eax),%edx
  8006a3:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006b0:	01 d0                	add    %edx,%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8006b6:	eb 66                	jmp    80071e <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8006b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006bb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8006be:	7d 30                	jge    8006f0 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8006c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006d8:	8d 50 01             	lea    0x1(%eax),%edx
  8006db:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	89 01                	mov    %eax,(%ecx)
  8006ee:	eb 2e                	jmp    80071e <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f3:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8d 50 01             	lea    0x1(%eax),%edx
  80070b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80070e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800715:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800718:	01 d0                	add    %edx,%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  80071e:	ff 45 e4             	incl   -0x1c(%ebp)
  800721:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800724:	3b 45 14             	cmp    0x14(%ebp),%eax
  800727:	0f 8e ea fe ff ff    	jle    800617 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  80072d:	90                   	nop
  80072e:	c9                   	leave  
  80072f:	c3                   	ret    

00800730 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800736:	8b 45 08             	mov    0x8(%ebp),%eax
  800739:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80073c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800740:	83 ec 0c             	sub    $0xc,%esp
  800743:	50                   	push   %eax
  800744:	e8 d5 19 00 00       	call   80211e <sys_cputc>
  800749:	83 c4 10             	add    $0x10,%esp
}
  80074c:	90                   	nop
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800755:	e8 90 19 00 00       	call   8020ea <sys_disable_interrupt>
	char c = ch;
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800760:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800764:	83 ec 0c             	sub    $0xc,%esp
  800767:	50                   	push   %eax
  800768:	e8 b1 19 00 00       	call   80211e <sys_cputc>
  80076d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800770:	e8 8f 19 00 00       	call   802104 <sys_enable_interrupt>
}
  800775:	90                   	nop
  800776:	c9                   	leave  
  800777:	c3                   	ret    

00800778 <getchar>:

int
getchar(void)
{
  800778:	55                   	push   %ebp
  800779:	89 e5                	mov    %esp,%ebp
  80077b:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80077e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800785:	eb 08                	jmp    80078f <getchar+0x17>
	{
		c = sys_cgetc();
  800787:	e8 d9 17 00 00       	call   801f65 <sys_cgetc>
  80078c:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80078f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800793:	74 f2                	je     800787 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800795:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <atomic_getchar>:

int
atomic_getchar(void)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007a0:	e8 45 19 00 00       	call   8020ea <sys_disable_interrupt>
	int c=0;
  8007a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007ac:	eb 08                	jmp    8007b6 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007ae:	e8 b2 17 00 00       	call   801f65 <sys_cgetc>
  8007b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007ba:	74 f2                	je     8007ae <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007bc:	e8 43 19 00 00       	call   802104 <sys_enable_interrupt>
	return c;
  8007c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <iscons>:

int iscons(int fdnum)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007c9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007ce:	5d                   	pop    %ebp
  8007cf:	c3                   	ret    

008007d0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007d6:	e8 02 1b 00 00       	call   8022dd <sys_getenvindex>
  8007db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e1:	89 d0                	mov    %edx,%eax
  8007e3:	c1 e0 03             	shl    $0x3,%eax
  8007e6:	01 d0                	add    %edx,%eax
  8007e8:	01 c0                	add    %eax,%eax
  8007ea:	01 d0                	add    %edx,%eax
  8007ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007f3:	01 d0                	add    %edx,%eax
  8007f5:	c1 e0 04             	shl    $0x4,%eax
  8007f8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007fd:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800802:	a1 24 50 80 00       	mov    0x805024,%eax
  800807:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80080d:	84 c0                	test   %al,%al
  80080f:	74 0f                	je     800820 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800811:	a1 24 50 80 00       	mov    0x805024,%eax
  800816:	05 5c 05 00 00       	add    $0x55c,%eax
  80081b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800820:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800824:	7e 0a                	jle    800830 <libmain+0x60>
		binaryname = argv[0];
  800826:	8b 45 0c             	mov    0xc(%ebp),%eax
  800829:	8b 00                	mov    (%eax),%eax
  80082b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	ff 75 08             	pushl  0x8(%ebp)
  800839:	e8 fa f7 ff ff       	call   800038 <_main>
  80083e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800841:	e8 a4 18 00 00       	call   8020ea <sys_disable_interrupt>
	cprintf("**************************************\n");
  800846:	83 ec 0c             	sub    $0xc,%esp
  800849:	68 38 3b 80 00       	push   $0x803b38
  80084e:	e8 6d 03 00 00       	call   800bc0 <cprintf>
  800853:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800861:	a1 24 50 80 00       	mov    0x805024,%eax
  800866:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80086c:	83 ec 04             	sub    $0x4,%esp
  80086f:	52                   	push   %edx
  800870:	50                   	push   %eax
  800871:	68 60 3b 80 00       	push   $0x803b60
  800876:	e8 45 03 00 00       	call   800bc0 <cprintf>
  80087b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800894:	a1 24 50 80 00       	mov    0x805024,%eax
  800899:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80089f:	51                   	push   %ecx
  8008a0:	52                   	push   %edx
  8008a1:	50                   	push   %eax
  8008a2:	68 88 3b 80 00       	push   $0x803b88
  8008a7:	e8 14 03 00 00       	call   800bc0 <cprintf>
  8008ac:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008af:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 e0 3b 80 00       	push   $0x803be0
  8008c3:	e8 f8 02 00 00       	call   800bc0 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008cb:	83 ec 0c             	sub    $0xc,%esp
  8008ce:	68 38 3b 80 00       	push   $0x803b38
  8008d3:	e8 e8 02 00 00       	call   800bc0 <cprintf>
  8008d8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008db:	e8 24 18 00 00       	call   802104 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008e0:	e8 19 00 00 00       	call   8008fe <exit>
}
  8008e5:	90                   	nop
  8008e6:	c9                   	leave  
  8008e7:	c3                   	ret    

008008e8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008ee:	83 ec 0c             	sub    $0xc,%esp
  8008f1:	6a 00                	push   $0x0
  8008f3:	e8 b1 19 00 00       	call   8022a9 <sys_destroy_env>
  8008f8:	83 c4 10             	add    $0x10,%esp
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <exit>:

void
exit(void)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800904:	e8 06 1a 00 00       	call   80230f <sys_exit_env>
}
  800909:	90                   	nop
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800912:	8d 45 10             	lea    0x10(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80091b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800920:	85 c0                	test   %eax,%eax
  800922:	74 16                	je     80093a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800924:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	50                   	push   %eax
  80092d:	68 f4 3b 80 00       	push   $0x803bf4
  800932:	e8 89 02 00 00       	call   800bc0 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80093a:	a1 00 50 80 00       	mov    0x805000,%eax
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	50                   	push   %eax
  800946:	68 f9 3b 80 00       	push   $0x803bf9
  80094b:	e8 70 02 00 00       	call   800bc0 <cprintf>
  800950:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800953:	8b 45 10             	mov    0x10(%ebp),%eax
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 f4             	pushl  -0xc(%ebp)
  80095c:	50                   	push   %eax
  80095d:	e8 f3 01 00 00       	call   800b55 <vcprintf>
  800962:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800965:	83 ec 08             	sub    $0x8,%esp
  800968:	6a 00                	push   $0x0
  80096a:	68 15 3c 80 00       	push   $0x803c15
  80096f:	e8 e1 01 00 00       	call   800b55 <vcprintf>
  800974:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800977:	e8 82 ff ff ff       	call   8008fe <exit>

	// should not return here
	while (1) ;
  80097c:	eb fe                	jmp    80097c <_panic+0x70>

0080097e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800984:	a1 24 50 80 00       	mov    0x805024,%eax
  800989:	8b 50 74             	mov    0x74(%eax),%edx
  80098c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098f:	39 c2                	cmp    %eax,%edx
  800991:	74 14                	je     8009a7 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800993:	83 ec 04             	sub    $0x4,%esp
  800996:	68 18 3c 80 00       	push   $0x803c18
  80099b:	6a 26                	push   $0x26
  80099d:	68 64 3c 80 00       	push   $0x803c64
  8009a2:	e8 65 ff ff ff       	call   80090c <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8009a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009b5:	e9 c2 00 00 00       	jmp    800a7c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	01 d0                	add    %edx,%eax
  8009c9:	8b 00                	mov    (%eax),%eax
  8009cb:	85 c0                	test   %eax,%eax
  8009cd:	75 08                	jne    8009d7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009cf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009d2:	e9 a2 00 00 00       	jmp    800a79 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009e5:	eb 69                	jmp    800a50 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009e7:	a1 24 50 80 00       	mov    0x805024,%eax
  8009ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009f5:	89 d0                	mov    %edx,%eax
  8009f7:	01 c0                	add    %eax,%eax
  8009f9:	01 d0                	add    %edx,%eax
  8009fb:	c1 e0 03             	shl    $0x3,%eax
  8009fe:	01 c8                	add    %ecx,%eax
  800a00:	8a 40 04             	mov    0x4(%eax),%al
  800a03:	84 c0                	test   %al,%al
  800a05:	75 46                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a07:	a1 24 50 80 00       	mov    0x805024,%eax
  800a0c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a12:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a15:	89 d0                	mov    %edx,%eax
  800a17:	01 c0                	add    %eax,%eax
  800a19:	01 d0                	add    %edx,%eax
  800a1b:	c1 e0 03             	shl    $0x3,%eax
  800a1e:	01 c8                	add    %ecx,%eax
  800a20:	8b 00                	mov    (%eax),%eax
  800a22:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a2d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	01 c8                	add    %ecx,%eax
  800a3e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a40:	39 c2                	cmp    %eax,%edx
  800a42:	75 09                	jne    800a4d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a44:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a4b:	eb 12                	jmp    800a5f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4d:	ff 45 e8             	incl   -0x18(%ebp)
  800a50:	a1 24 50 80 00       	mov    0x805024,%eax
  800a55:	8b 50 74             	mov    0x74(%eax),%edx
  800a58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a5b:	39 c2                	cmp    %eax,%edx
  800a5d:	77 88                	ja     8009e7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a5f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a63:	75 14                	jne    800a79 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a65:	83 ec 04             	sub    $0x4,%esp
  800a68:	68 70 3c 80 00       	push   $0x803c70
  800a6d:	6a 3a                	push   $0x3a
  800a6f:	68 64 3c 80 00       	push   $0x803c64
  800a74:	e8 93 fe ff ff       	call   80090c <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a79:	ff 45 f0             	incl   -0x10(%ebp)
  800a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a82:	0f 8c 32 ff ff ff    	jl     8009ba <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a88:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a96:	eb 26                	jmp    800abe <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a98:	a1 24 50 80 00       	mov    0x805024,%eax
  800a9d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	01 c0                	add    %eax,%eax
  800aaa:	01 d0                	add    %edx,%eax
  800aac:	c1 e0 03             	shl    $0x3,%eax
  800aaf:	01 c8                	add    %ecx,%eax
  800ab1:	8a 40 04             	mov    0x4(%eax),%al
  800ab4:	3c 01                	cmp    $0x1,%al
  800ab6:	75 03                	jne    800abb <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800ab8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800abb:	ff 45 e0             	incl   -0x20(%ebp)
  800abe:	a1 24 50 80 00       	mov    0x805024,%eax
  800ac3:	8b 50 74             	mov    0x74(%eax),%edx
  800ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ac9:	39 c2                	cmp    %eax,%edx
  800acb:	77 cb                	ja     800a98 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ad0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ad3:	74 14                	je     800ae9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800ad5:	83 ec 04             	sub    $0x4,%esp
  800ad8:	68 c4 3c 80 00       	push   $0x803cc4
  800add:	6a 44                	push   $0x44
  800adf:	68 64 3c 80 00       	push   $0x803c64
  800ae4:	e8 23 fe ff ff       	call   80090c <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ae9:	90                   	nop
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 48 01             	lea    0x1(%eax),%ecx
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afd:	89 0a                	mov    %ecx,(%edx)
  800aff:	8b 55 08             	mov    0x8(%ebp),%edx
  800b02:	88 d1                	mov    %dl,%cl
  800b04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b07:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0e:	8b 00                	mov    (%eax),%eax
  800b10:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b15:	75 2c                	jne    800b43 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b17:	a0 28 50 80 00       	mov    0x805028,%al
  800b1c:	0f b6 c0             	movzbl %al,%eax
  800b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b22:	8b 12                	mov    (%edx),%edx
  800b24:	89 d1                	mov    %edx,%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	83 c2 08             	add    $0x8,%edx
  800b2c:	83 ec 04             	sub    $0x4,%esp
  800b2f:	50                   	push   %eax
  800b30:	51                   	push   %ecx
  800b31:	52                   	push   %edx
  800b32:	e8 05 14 00 00       	call   801f3c <sys_cputs>
  800b37:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b46:	8b 40 04             	mov    0x4(%eax),%eax
  800b49:	8d 50 01             	lea    0x1(%eax),%edx
  800b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b52:	90                   	nop
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b5e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b65:	00 00 00 
	b.cnt = 0;
  800b68:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b6f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b7e:	50                   	push   %eax
  800b7f:	68 ec 0a 80 00       	push   $0x800aec
  800b84:	e8 11 02 00 00       	call   800d9a <vprintfmt>
  800b89:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b8c:	a0 28 50 80 00       	mov    0x805028,%al
  800b91:	0f b6 c0             	movzbl %al,%eax
  800b94:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b9a:	83 ec 04             	sub    $0x4,%esp
  800b9d:	50                   	push   %eax
  800b9e:	52                   	push   %edx
  800b9f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ba5:	83 c0 08             	add    $0x8,%eax
  800ba8:	50                   	push   %eax
  800ba9:	e8 8e 13 00 00       	call   801f3c <sys_cputs>
  800bae:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800bb1:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bb8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bc6:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bcd:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	e8 73 ff ff ff       	call   800b55 <vcprintf>
  800be2:	83 c4 10             	add    $0x10,%esp
  800be5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bf3:	e8 f2 14 00 00       	call   8020ea <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bf8:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	83 ec 08             	sub    $0x8,%esp
  800c04:	ff 75 f4             	pushl  -0xc(%ebp)
  800c07:	50                   	push   %eax
  800c08:	e8 48 ff ff ff       	call   800b55 <vcprintf>
  800c0d:	83 c4 10             	add    $0x10,%esp
  800c10:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c13:	e8 ec 14 00 00       	call   802104 <sys_enable_interrupt>
	return cnt;
  800c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1b:	c9                   	leave  
  800c1c:	c3                   	ret    

00800c1d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	53                   	push   %ebx
  800c21:	83 ec 14             	sub    $0x14,%esp
  800c24:	8b 45 10             	mov    0x10(%ebp),%eax
  800c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c30:	8b 45 18             	mov    0x18(%ebp),%eax
  800c33:	ba 00 00 00 00       	mov    $0x0,%edx
  800c38:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c3b:	77 55                	ja     800c92 <printnum+0x75>
  800c3d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c40:	72 05                	jb     800c47 <printnum+0x2a>
  800c42:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c45:	77 4b                	ja     800c92 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c47:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c4a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c4d:	8b 45 18             	mov    0x18(%ebp),%eax
  800c50:	ba 00 00 00 00       	mov    $0x0,%edx
  800c55:	52                   	push   %edx
  800c56:	50                   	push   %eax
  800c57:	ff 75 f4             	pushl  -0xc(%ebp)
  800c5a:	ff 75 f0             	pushl  -0x10(%ebp)
  800c5d:	e8 62 2a 00 00       	call   8036c4 <__udivdi3>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	83 ec 04             	sub    $0x4,%esp
  800c68:	ff 75 20             	pushl  0x20(%ebp)
  800c6b:	53                   	push   %ebx
  800c6c:	ff 75 18             	pushl  0x18(%ebp)
  800c6f:	52                   	push   %edx
  800c70:	50                   	push   %eax
  800c71:	ff 75 0c             	pushl  0xc(%ebp)
  800c74:	ff 75 08             	pushl  0x8(%ebp)
  800c77:	e8 a1 ff ff ff       	call   800c1d <printnum>
  800c7c:	83 c4 20             	add    $0x20,%esp
  800c7f:	eb 1a                	jmp    800c9b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c81:	83 ec 08             	sub    $0x8,%esp
  800c84:	ff 75 0c             	pushl  0xc(%ebp)
  800c87:	ff 75 20             	pushl  0x20(%ebp)
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	ff d0                	call   *%eax
  800c8f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c92:	ff 4d 1c             	decl   0x1c(%ebp)
  800c95:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c99:	7f e6                	jg     800c81 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c9b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ca6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ca9:	53                   	push   %ebx
  800caa:	51                   	push   %ecx
  800cab:	52                   	push   %edx
  800cac:	50                   	push   %eax
  800cad:	e8 22 2b 00 00       	call   8037d4 <__umoddi3>
  800cb2:	83 c4 10             	add    $0x10,%esp
  800cb5:	05 34 3f 80 00       	add    $0x803f34,%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	0f be c0             	movsbl %al,%eax
  800cbf:	83 ec 08             	sub    $0x8,%esp
  800cc2:	ff 75 0c             	pushl  0xc(%ebp)
  800cc5:	50                   	push   %eax
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc9:	ff d0                	call   *%eax
  800ccb:	83 c4 10             	add    $0x10,%esp
}
  800cce:	90                   	nop
  800ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cdb:	7e 1c                	jle    800cf9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 50 08             	lea    0x8(%eax),%edx
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	89 10                	mov    %edx,(%eax)
  800cea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	83 e8 08             	sub    $0x8,%eax
  800cf2:	8b 50 04             	mov    0x4(%eax),%edx
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	eb 40                	jmp    800d39 <getuint+0x65>
	else if (lflag)
  800cf9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cfd:	74 1e                	je     800d1d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8b 00                	mov    (%eax),%eax
  800d04:	8d 50 04             	lea    0x4(%eax),%edx
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	89 10                	mov    %edx,(%eax)
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8b 00                	mov    (%eax),%eax
  800d11:	83 e8 04             	sub    $0x4,%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	eb 1c                	jmp    800d39 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8b 00                	mov    (%eax),%eax
  800d22:	8d 50 04             	lea    0x4(%eax),%edx
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 10                	mov    %edx,(%eax)
  800d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2d:	8b 00                	mov    (%eax),%eax
  800d2f:	83 e8 04             	sub    $0x4,%eax
  800d32:	8b 00                	mov    (%eax),%eax
  800d34:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d3e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d42:	7e 1c                	jle    800d60 <getint+0x25>
		return va_arg(*ap, long long);
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 00                	mov    (%eax),%eax
  800d49:	8d 50 08             	lea    0x8(%eax),%edx
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 10                	mov    %edx,(%eax)
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	8b 00                	mov    (%eax),%eax
  800d56:	83 e8 08             	sub    $0x8,%eax
  800d59:	8b 50 04             	mov    0x4(%eax),%edx
  800d5c:	8b 00                	mov    (%eax),%eax
  800d5e:	eb 38                	jmp    800d98 <getint+0x5d>
	else if (lflag)
  800d60:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d64:	74 1a                	je     800d80 <getint+0x45>
		return va_arg(*ap, long);
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8b 00                	mov    (%eax),%eax
  800d6b:	8d 50 04             	lea    0x4(%eax),%edx
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	89 10                	mov    %edx,(%eax)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	83 e8 04             	sub    $0x4,%eax
  800d7b:	8b 00                	mov    (%eax),%eax
  800d7d:	99                   	cltd   
  800d7e:	eb 18                	jmp    800d98 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	8d 50 04             	lea    0x4(%eax),%edx
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 10                	mov    %edx,(%eax)
  800d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d90:	8b 00                	mov    (%eax),%eax
  800d92:	83 e8 04             	sub    $0x4,%eax
  800d95:	8b 00                	mov    (%eax),%eax
  800d97:	99                   	cltd   
}
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
  800d9f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	eb 17                	jmp    800dbb <vprintfmt+0x21>
			if (ch == '\0')
  800da4:	85 db                	test   %ebx,%ebx
  800da6:	0f 84 af 03 00 00    	je     80115b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800dac:	83 ec 08             	sub    $0x8,%esp
  800daf:	ff 75 0c             	pushl  0xc(%ebp)
  800db2:	53                   	push   %ebx
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	ff d0                	call   *%eax
  800db8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800dbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbe:	8d 50 01             	lea    0x1(%eax),%edx
  800dc1:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	0f b6 d8             	movzbl %al,%ebx
  800dc9:	83 fb 25             	cmp    $0x25,%ebx
  800dcc:	75 d6                	jne    800da4 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dce:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dd2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dd9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800de0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800de7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 10             	mov    %edx,0x10(%ebp)
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d8             	movzbl %al,%ebx
  800dfc:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dff:	83 f8 55             	cmp    $0x55,%eax
  800e02:	0f 87 2b 03 00 00    	ja     801133 <vprintfmt+0x399>
  800e08:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
  800e0f:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e11:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e15:	eb d7                	jmp    800dee <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e17:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e1b:	eb d1                	jmp    800dee <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e1d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e24:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e27:	89 d0                	mov    %edx,%eax
  800e29:	c1 e0 02             	shl    $0x2,%eax
  800e2c:	01 d0                	add    %edx,%eax
  800e2e:	01 c0                	add    %eax,%eax
  800e30:	01 d8                	add    %ebx,%eax
  800e32:	83 e8 30             	sub    $0x30,%eax
  800e35:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e38:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e40:	83 fb 2f             	cmp    $0x2f,%ebx
  800e43:	7e 3e                	jle    800e83 <vprintfmt+0xe9>
  800e45:	83 fb 39             	cmp    $0x39,%ebx
  800e48:	7f 39                	jg     800e83 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e4a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e4d:	eb d5                	jmp    800e24 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e52:	83 c0 04             	add    $0x4,%eax
  800e55:	89 45 14             	mov    %eax,0x14(%ebp)
  800e58:	8b 45 14             	mov    0x14(%ebp),%eax
  800e5b:	83 e8 04             	sub    $0x4,%eax
  800e5e:	8b 00                	mov    (%eax),%eax
  800e60:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e63:	eb 1f                	jmp    800e84 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e65:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e69:	79 83                	jns    800dee <vprintfmt+0x54>
				width = 0;
  800e6b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e72:	e9 77 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e77:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e7e:	e9 6b ff ff ff       	jmp    800dee <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e83:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e84:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e88:	0f 89 60 ff ff ff    	jns    800dee <vprintfmt+0x54>
				width = precision, precision = -1;
  800e8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e94:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e9b:	e9 4e ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ea0:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ea3:	e9 46 ff ff ff       	jmp    800dee <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ea8:	8b 45 14             	mov    0x14(%ebp),%eax
  800eab:	83 c0 04             	add    $0x4,%eax
  800eae:	89 45 14             	mov    %eax,0x14(%ebp)
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	83 e8 04             	sub    $0x4,%eax
  800eb7:	8b 00                	mov    (%eax),%eax
  800eb9:	83 ec 08             	sub    $0x8,%esp
  800ebc:	ff 75 0c             	pushl  0xc(%ebp)
  800ebf:	50                   	push   %eax
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec3:	ff d0                	call   *%eax
  800ec5:	83 c4 10             	add    $0x10,%esp
			break;
  800ec8:	e9 89 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ecd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed0:	83 c0 04             	add    $0x4,%eax
  800ed3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed9:	83 e8 04             	sub    $0x4,%eax
  800edc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ede:	85 db                	test   %ebx,%ebx
  800ee0:	79 02                	jns    800ee4 <vprintfmt+0x14a>
				err = -err;
  800ee2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ee4:	83 fb 64             	cmp    $0x64,%ebx
  800ee7:	7f 0b                	jg     800ef4 <vprintfmt+0x15a>
  800ee9:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  800ef0:	85 f6                	test   %esi,%esi
  800ef2:	75 19                	jne    800f0d <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ef4:	53                   	push   %ebx
  800ef5:	68 45 3f 80 00       	push   $0x803f45
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 5e 02 00 00       	call   801163 <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f08:	e9 49 02 00 00       	jmp    801156 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f0d:	56                   	push   %esi
  800f0e:	68 4e 3f 80 00       	push   $0x803f4e
  800f13:	ff 75 0c             	pushl  0xc(%ebp)
  800f16:	ff 75 08             	pushl  0x8(%ebp)
  800f19:	e8 45 02 00 00       	call   801163 <printfmt>
  800f1e:	83 c4 10             	add    $0x10,%esp
			break;
  800f21:	e9 30 02 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f26:	8b 45 14             	mov    0x14(%ebp),%eax
  800f29:	83 c0 04             	add    $0x4,%eax
  800f2c:	89 45 14             	mov    %eax,0x14(%ebp)
  800f2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800f32:	83 e8 04             	sub    $0x4,%eax
  800f35:	8b 30                	mov    (%eax),%esi
  800f37:	85 f6                	test   %esi,%esi
  800f39:	75 05                	jne    800f40 <vprintfmt+0x1a6>
				p = "(null)";
  800f3b:	be 51 3f 80 00       	mov    $0x803f51,%esi
			if (width > 0 && padc != '-')
  800f40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f44:	7e 6d                	jle    800fb3 <vprintfmt+0x219>
  800f46:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f4a:	74 67                	je     800fb3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	50                   	push   %eax
  800f53:	56                   	push   %esi
  800f54:	e8 0c 03 00 00       	call   801265 <strnlen>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f5f:	eb 16                	jmp    800f77 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f61:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f65:	83 ec 08             	sub    $0x8,%esp
  800f68:	ff 75 0c             	pushl  0xc(%ebp)
  800f6b:	50                   	push   %eax
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	ff d0                	call   *%eax
  800f71:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f74:	ff 4d e4             	decl   -0x1c(%ebp)
  800f77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7b:	7f e4                	jg     800f61 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7d:	eb 34                	jmp    800fb3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f7f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f83:	74 1c                	je     800fa1 <vprintfmt+0x207>
  800f85:	83 fb 1f             	cmp    $0x1f,%ebx
  800f88:	7e 05                	jle    800f8f <vprintfmt+0x1f5>
  800f8a:	83 fb 7e             	cmp    $0x7e,%ebx
  800f8d:	7e 12                	jle    800fa1 <vprintfmt+0x207>
					putch('?', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 3f                	push   $0x3f
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
  800f9f:	eb 0f                	jmp    800fb0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800fa1:	83 ec 08             	sub    $0x8,%esp
  800fa4:	ff 75 0c             	pushl  0xc(%ebp)
  800fa7:	53                   	push   %ebx
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fab:	ff d0                	call   *%eax
  800fad:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fb0:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb3:	89 f0                	mov    %esi,%eax
  800fb5:	8d 70 01             	lea    0x1(%eax),%esi
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	0f be d8             	movsbl %al,%ebx
  800fbd:	85 db                	test   %ebx,%ebx
  800fbf:	74 24                	je     800fe5 <vprintfmt+0x24b>
  800fc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc5:	78 b8                	js     800f7f <vprintfmt+0x1e5>
  800fc7:	ff 4d e0             	decl   -0x20(%ebp)
  800fca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fce:	79 af                	jns    800f7f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd0:	eb 13                	jmp    800fe5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 0c             	pushl  0xc(%ebp)
  800fd8:	6a 20                	push   $0x20
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	ff d0                	call   *%eax
  800fdf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fe2:	ff 4d e4             	decl   -0x1c(%ebp)
  800fe5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe9:	7f e7                	jg     800fd2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800feb:	e9 66 01 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ff0:	83 ec 08             	sub    $0x8,%esp
  800ff3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ff6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ff9:	50                   	push   %eax
  800ffa:	e8 3c fd ff ff       	call   800d3b <getint>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801005:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801008:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100e:	85 d2                	test   %edx,%edx
  801010:	79 23                	jns    801035 <vprintfmt+0x29b>
				putch('-', putdat);
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	ff 75 0c             	pushl  0xc(%ebp)
  801018:	6a 2d                	push   $0x2d
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	ff d0                	call   *%eax
  80101f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801025:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801028:	f7 d8                	neg    %eax
  80102a:	83 d2 00             	adc    $0x0,%edx
  80102d:	f7 da                	neg    %edx
  80102f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801032:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801035:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80103c:	e9 bc 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801041:	83 ec 08             	sub    $0x8,%esp
  801044:	ff 75 e8             	pushl  -0x18(%ebp)
  801047:	8d 45 14             	lea    0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	e8 84 fc ff ff       	call   800cd4 <getuint>
  801050:	83 c4 10             	add    $0x10,%esp
  801053:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801056:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801059:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801060:	e9 98 00 00 00       	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 58                	push   $0x58
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 58                	push   $0x58
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801085:	83 ec 08             	sub    $0x8,%esp
  801088:	ff 75 0c             	pushl  0xc(%ebp)
  80108b:	6a 58                	push   $0x58
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	ff d0                	call   *%eax
  801092:	83 c4 10             	add    $0x10,%esp
			break;
  801095:	e9 bc 00 00 00       	jmp    801156 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	ff 75 0c             	pushl  0xc(%ebp)
  8010a0:	6a 30                	push   $0x30
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a5:	ff d0                	call   *%eax
  8010a7:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 0c             	pushl  0xc(%ebp)
  8010b0:	6a 78                	push   $0x78
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	ff d0                	call   *%eax
  8010b7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bd:	83 c0 04             	add    $0x4,%eax
  8010c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8010c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8010c6:	83 e8 04             	sub    $0x4,%eax
  8010c9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010d5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010dc:	eb 1f                	jmp    8010fd <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8010e4:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e7:	50                   	push   %eax
  8010e8:	e8 e7 fb ff ff       	call   800cd4 <getuint>
  8010ed:	83 c4 10             	add    $0x10,%esp
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010f6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010fd:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801101:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	52                   	push   %edx
  801108:	ff 75 e4             	pushl  -0x1c(%ebp)
  80110b:	50                   	push   %eax
  80110c:	ff 75 f4             	pushl  -0xc(%ebp)
  80110f:	ff 75 f0             	pushl  -0x10(%ebp)
  801112:	ff 75 0c             	pushl  0xc(%ebp)
  801115:	ff 75 08             	pushl  0x8(%ebp)
  801118:	e8 00 fb ff ff       	call   800c1d <printnum>
  80111d:	83 c4 20             	add    $0x20,%esp
			break;
  801120:	eb 34                	jmp    801156 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801122:	83 ec 08             	sub    $0x8,%esp
  801125:	ff 75 0c             	pushl  0xc(%ebp)
  801128:	53                   	push   %ebx
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	ff d0                	call   *%eax
  80112e:	83 c4 10             	add    $0x10,%esp
			break;
  801131:	eb 23                	jmp    801156 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801133:	83 ec 08             	sub    $0x8,%esp
  801136:	ff 75 0c             	pushl  0xc(%ebp)
  801139:	6a 25                	push   $0x25
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	ff d0                	call   *%eax
  801140:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801143:	ff 4d 10             	decl   0x10(%ebp)
  801146:	eb 03                	jmp    80114b <vprintfmt+0x3b1>
  801148:	ff 4d 10             	decl   0x10(%ebp)
  80114b:	8b 45 10             	mov    0x10(%ebp),%eax
  80114e:	48                   	dec    %eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 25                	cmp    $0x25,%al
  801153:	75 f3                	jne    801148 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801155:	90                   	nop
		}
	}
  801156:	e9 47 fc ff ff       	jmp    800da2 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  80115b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  80115c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80115f:	5b                   	pop    %ebx
  801160:	5e                   	pop    %esi
  801161:	5d                   	pop    %ebp
  801162:	c3                   	ret    

00801163 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801163:	55                   	push   %ebp
  801164:	89 e5                	mov    %esp,%ebp
  801166:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801169:	8d 45 10             	lea    0x10(%ebp),%eax
  80116c:	83 c0 04             	add    $0x4,%eax
  80116f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801172:	8b 45 10             	mov    0x10(%ebp),%eax
  801175:	ff 75 f4             	pushl  -0xc(%ebp)
  801178:	50                   	push   %eax
  801179:	ff 75 0c             	pushl  0xc(%ebp)
  80117c:	ff 75 08             	pushl  0x8(%ebp)
  80117f:	e8 16 fc ff ff       	call   800d9a <vprintfmt>
  801184:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	8b 40 08             	mov    0x8(%eax),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80119c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119f:	8b 10                	mov    (%eax),%edx
  8011a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a4:	8b 40 04             	mov    0x4(%eax),%eax
  8011a7:	39 c2                	cmp    %eax,%edx
  8011a9:	73 12                	jae    8011bd <sprintputch+0x33>
		*b->buf++ = ch;
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	8b 00                	mov    (%eax),%eax
  8011b0:	8d 48 01             	lea    0x1(%eax),%ecx
  8011b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011b6:	89 0a                	mov    %ecx,(%edx)
  8011b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bb:	88 10                	mov    %dl,(%eax)
}
  8011bd:	90                   	nop
  8011be:	5d                   	pop    %ebp
  8011bf:	c3                   	ret    

008011c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011c0:	55                   	push   %ebp
  8011c1:	89 e5                	mov    %esp,%ebp
  8011c3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e5:	74 06                	je     8011ed <vsnprintf+0x2d>
  8011e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011eb:	7f 07                	jg     8011f4 <vsnprintf+0x34>
		return -E_INVAL;
  8011ed:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f2:	eb 20                	jmp    801214 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011f4:	ff 75 14             	pushl  0x14(%ebp)
  8011f7:	ff 75 10             	pushl  0x10(%ebp)
  8011fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011fd:	50                   	push   %eax
  8011fe:	68 8a 11 80 00       	push   $0x80118a
  801203:	e8 92 fb ff ff       	call   800d9a <vprintfmt>
  801208:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80120b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80120e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801211:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80121c:	8d 45 10             	lea    0x10(%ebp),%eax
  80121f:	83 c0 04             	add    $0x4,%eax
  801222:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	ff 75 f4             	pushl  -0xc(%ebp)
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	ff 75 08             	pushl  0x8(%ebp)
  801232:	e8 89 ff ff ff       	call   8011c0 <vsnprintf>
  801237:	83 c4 10             	add    $0x10,%esp
  80123a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80123d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80124f:	eb 06                	jmp    801257 <strlen+0x15>
		n++;
  801251:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801254:	ff 45 08             	incl   0x8(%ebp)
  801257:	8b 45 08             	mov    0x8(%ebp),%eax
  80125a:	8a 00                	mov    (%eax),%al
  80125c:	84 c0                	test   %al,%al
  80125e:	75 f1                	jne    801251 <strlen+0xf>
		n++;
	return n;
  801260:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 09                	jmp    80127d <strnlen+0x18>
		n++;
  801274:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801277:	ff 45 08             	incl   0x8(%ebp)
  80127a:	ff 4d 0c             	decl   0xc(%ebp)
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	74 09                	je     80128c <strnlen+0x27>
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e8                	jne    801274 <strnlen+0xf>
		n++;
	return n;
  80128c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    

00801291 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801297:	8b 45 08             	mov    0x8(%ebp),%eax
  80129a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80129d:	90                   	nop
  80129e:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a1:	8d 50 01             	lea    0x1(%eax),%edx
  8012a4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012b0:	8a 12                	mov    (%edx),%dl
  8012b2:	88 10                	mov    %dl,(%eax)
  8012b4:	8a 00                	mov    (%eax),%al
  8012b6:	84 c0                	test   %al,%al
  8012b8:	75 e4                	jne    80129e <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d2:	eb 1f                	jmp    8012f3 <strncpy+0x34>
		*dst++ = *src;
  8012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d7:	8d 50 01             	lea    0x1(%eax),%edx
  8012da:	89 55 08             	mov    %edx,0x8(%ebp)
  8012dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e0:	8a 12                	mov    (%edx),%dl
  8012e2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	8a 00                	mov    (%eax),%al
  8012e9:	84 c0                	test   %al,%al
  8012eb:	74 03                	je     8012f0 <strncpy+0x31>
			src++;
  8012ed:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012f0:	ff 45 fc             	incl   -0x4(%ebp)
  8012f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012f9:	72 d9                	jb     8012d4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012fe:	c9                   	leave  
  8012ff:	c3                   	ret    

00801300 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801300:	55                   	push   %ebp
  801301:	89 e5                	mov    %esp,%ebp
  801303:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80130c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801310:	74 30                	je     801342 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801312:	eb 16                	jmp    80132a <strlcpy+0x2a>
			*dst++ = *src++;
  801314:	8b 45 08             	mov    0x8(%ebp),%eax
  801317:	8d 50 01             	lea    0x1(%eax),%edx
  80131a:	89 55 08             	mov    %edx,0x8(%ebp)
  80131d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801320:	8d 4a 01             	lea    0x1(%edx),%ecx
  801323:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801326:	8a 12                	mov    (%edx),%dl
  801328:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80132a:	ff 4d 10             	decl   0x10(%ebp)
  80132d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801331:	74 09                	je     80133c <strlcpy+0x3c>
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	84 c0                	test   %al,%al
  80133a:	75 d8                	jne    801314 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80133c:	8b 45 08             	mov    0x8(%ebp),%eax
  80133f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801342:	8b 55 08             	mov    0x8(%ebp),%edx
  801345:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801348:	29 c2                	sub    %eax,%edx
  80134a:	89 d0                	mov    %edx,%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    

0080134e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80134e:	55                   	push   %ebp
  80134f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801351:	eb 06                	jmp    801359 <strcmp+0xb>
		p++, q++;
  801353:	ff 45 08             	incl   0x8(%ebp)
  801356:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 0e                	je     801370 <strcmp+0x22>
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 10                	mov    (%eax),%dl
  801367:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	38 c2                	cmp    %al,%dl
  80136e:	74 e3                	je     801353 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f b6 d0             	movzbl %al,%edx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	8a 00                	mov    (%eax),%al
  80137d:	0f b6 c0             	movzbl %al,%eax
  801380:	29 c2                	sub    %eax,%edx
  801382:	89 d0                	mov    %edx,%eax
}
  801384:	5d                   	pop    %ebp
  801385:	c3                   	ret    

00801386 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801389:	eb 09                	jmp    801394 <strncmp+0xe>
		n--, p++, q++;
  80138b:	ff 4d 10             	decl   0x10(%ebp)
  80138e:	ff 45 08             	incl   0x8(%ebp)
  801391:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801394:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801398:	74 17                	je     8013b1 <strncmp+0x2b>
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8a 00                	mov    (%eax),%al
  80139f:	84 c0                	test   %al,%al
  8013a1:	74 0e                	je     8013b1 <strncmp+0x2b>
  8013a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a6:	8a 10                	mov    (%eax),%dl
  8013a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ab:	8a 00                	mov    (%eax),%al
  8013ad:	38 c2                	cmp    %al,%dl
  8013af:	74 da                	je     80138b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	75 07                	jne    8013be <strncmp+0x38>
		return 0;
  8013b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bc:	eb 14                	jmp    8013d2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	8a 00                	mov    (%eax),%al
  8013c3:	0f b6 d0             	movzbl %al,%edx
  8013c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	0f b6 c0             	movzbl %al,%eax
  8013ce:	29 c2                	sub    %eax,%edx
  8013d0:	89 d0                	mov    %edx,%eax
}
  8013d2:	5d                   	pop    %ebp
  8013d3:	c3                   	ret    

008013d4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013d4:	55                   	push   %ebp
  8013d5:	89 e5                	mov    %esp,%ebp
  8013d7:	83 ec 04             	sub    $0x4,%esp
  8013da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013e0:	eb 12                	jmp    8013f4 <strchr+0x20>
		if (*s == c)
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013ea:	75 05                	jne    8013f1 <strchr+0x1d>
			return (char *) s;
  8013ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ef:	eb 11                	jmp    801402 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013f1:	ff 45 08             	incl   0x8(%ebp)
  8013f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f7:	8a 00                	mov    (%eax),%al
  8013f9:	84 c0                	test   %al,%al
  8013fb:	75 e5                	jne    8013e2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801402:	c9                   	leave  
  801403:	c3                   	ret    

00801404 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801404:	55                   	push   %ebp
  801405:	89 e5                	mov    %esp,%ebp
  801407:	83 ec 04             	sub    $0x4,%esp
  80140a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80140d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801410:	eb 0d                	jmp    80141f <strfind+0x1b>
		if (*s == c)
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
  801415:	8a 00                	mov    (%eax),%al
  801417:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80141a:	74 0e                	je     80142a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80141c:	ff 45 08             	incl   0x8(%ebp)
  80141f:	8b 45 08             	mov    0x8(%ebp),%eax
  801422:	8a 00                	mov    (%eax),%al
  801424:	84 c0                	test   %al,%al
  801426:	75 ea                	jne    801412 <strfind+0xe>
  801428:	eb 01                	jmp    80142b <strfind+0x27>
		if (*s == c)
			break;
  80142a:	90                   	nop
	return (char *) s;
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142e:	c9                   	leave  
  80142f:	c3                   	ret    

00801430 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80143c:	8b 45 10             	mov    0x10(%ebp),%eax
  80143f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801442:	eb 0e                	jmp    801452 <memset+0x22>
		*p++ = c;
  801444:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801447:	8d 50 01             	lea    0x1(%eax),%edx
  80144a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80144d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801450:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801452:	ff 4d f8             	decl   -0x8(%ebp)
  801455:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801459:	79 e9                	jns    801444 <memset+0x14>
		*p++ = c;

	return v;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801472:	eb 16                	jmp    80148a <memcpy+0x2a>
		*d++ = *s++;
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	8d 50 01             	lea    0x1(%eax),%edx
  80147a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80147d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801480:	8d 4a 01             	lea    0x1(%edx),%ecx
  801483:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801486:	8a 12                	mov    (%edx),%dl
  801488:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	8d 50 ff             	lea    -0x1(%eax),%edx
  801490:	89 55 10             	mov    %edx,0x10(%ebp)
  801493:	85 c0                	test   %eax,%eax
  801495:	75 dd                	jne    801474 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ab:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014b1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014b4:	73 50                	jae    801506 <memmove+0x6a>
  8014b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bc:	01 d0                	add    %edx,%eax
  8014be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014c1:	76 43                	jbe    801506 <memmove+0x6a>
		s += n;
  8014c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014cf:	eb 10                	jmp    8014e1 <memmove+0x45>
			*--d = *--s;
  8014d1:	ff 4d f8             	decl   -0x8(%ebp)
  8014d4:	ff 4d fc             	decl   -0x4(%ebp)
  8014d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014da:	8a 10                	mov    (%eax),%dl
  8014dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014df:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014e7:	89 55 10             	mov    %edx,0x10(%ebp)
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	75 e3                	jne    8014d1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014ee:	eb 23                	jmp    801513 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f3:	8d 50 01             	lea    0x1(%eax),%edx
  8014f6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ff:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801502:	8a 12                	mov    (%edx),%dl
  801504:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801506:	8b 45 10             	mov    0x10(%ebp),%eax
  801509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150c:	89 55 10             	mov    %edx,0x10(%ebp)
  80150f:	85 c0                	test   %eax,%eax
  801511:	75 dd                	jne    8014f0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801524:	8b 45 0c             	mov    0xc(%ebp),%eax
  801527:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80152a:	eb 2a                	jmp    801556 <memcmp+0x3e>
		if (*s1 != *s2)
  80152c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80152f:	8a 10                	mov    (%eax),%dl
  801531:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	38 c2                	cmp    %al,%dl
  801538:	74 16                	je     801550 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80153a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	0f b6 d0             	movzbl %al,%edx
  801542:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	0f b6 c0             	movzbl %al,%eax
  80154a:	29 c2                	sub    %eax,%edx
  80154c:	89 d0                	mov    %edx,%eax
  80154e:	eb 18                	jmp    801568 <memcmp+0x50>
		s1++, s2++;
  801550:	ff 45 fc             	incl   -0x4(%ebp)
  801553:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801556:	8b 45 10             	mov    0x10(%ebp),%eax
  801559:	8d 50 ff             	lea    -0x1(%eax),%edx
  80155c:	89 55 10             	mov    %edx,0x10(%ebp)
  80155f:	85 c0                	test   %eax,%eax
  801561:	75 c9                	jne    80152c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801570:	8b 55 08             	mov    0x8(%ebp),%edx
  801573:	8b 45 10             	mov    0x10(%ebp),%eax
  801576:	01 d0                	add    %edx,%eax
  801578:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80157b:	eb 15                	jmp    801592 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	8a 00                	mov    (%eax),%al
  801582:	0f b6 d0             	movzbl %al,%edx
  801585:	8b 45 0c             	mov    0xc(%ebp),%eax
  801588:	0f b6 c0             	movzbl %al,%eax
  80158b:	39 c2                	cmp    %eax,%edx
  80158d:	74 0d                	je     80159c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80158f:	ff 45 08             	incl   0x8(%ebp)
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801598:	72 e3                	jb     80157d <memfind+0x13>
  80159a:	eb 01                	jmp    80159d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80159c:	90                   	nop
	return (void *) s;
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015af:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015b6:	eb 03                	jmp    8015bb <strtol+0x19>
		s++;
  8015b8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	3c 20                	cmp    $0x20,%al
  8015c2:	74 f4                	je     8015b8 <strtol+0x16>
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	8a 00                	mov    (%eax),%al
  8015c9:	3c 09                	cmp    $0x9,%al
  8015cb:	74 eb                	je     8015b8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8a 00                	mov    (%eax),%al
  8015d2:	3c 2b                	cmp    $0x2b,%al
  8015d4:	75 05                	jne    8015db <strtol+0x39>
		s++;
  8015d6:	ff 45 08             	incl   0x8(%ebp)
  8015d9:	eb 13                	jmp    8015ee <strtol+0x4c>
	else if (*s == '-')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 2d                	cmp    $0x2d,%al
  8015e2:	75 0a                	jne    8015ee <strtol+0x4c>
		s++, neg = 1;
  8015e4:	ff 45 08             	incl   0x8(%ebp)
  8015e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f2:	74 06                	je     8015fa <strtol+0x58>
  8015f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015f8:	75 20                	jne    80161a <strtol+0x78>
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	8a 00                	mov    (%eax),%al
  8015ff:	3c 30                	cmp    $0x30,%al
  801601:	75 17                	jne    80161a <strtol+0x78>
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	40                   	inc    %eax
  801607:	8a 00                	mov    (%eax),%al
  801609:	3c 78                	cmp    $0x78,%al
  80160b:	75 0d                	jne    80161a <strtol+0x78>
		s += 2, base = 16;
  80160d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801611:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801618:	eb 28                	jmp    801642 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80161a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80161e:	75 15                	jne    801635 <strtol+0x93>
  801620:	8b 45 08             	mov    0x8(%ebp),%eax
  801623:	8a 00                	mov    (%eax),%al
  801625:	3c 30                	cmp    $0x30,%al
  801627:	75 0c                	jne    801635 <strtol+0x93>
		s++, base = 8;
  801629:	ff 45 08             	incl   0x8(%ebp)
  80162c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801633:	eb 0d                	jmp    801642 <strtol+0xa0>
	else if (base == 0)
  801635:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801639:	75 07                	jne    801642 <strtol+0xa0>
		base = 10;
  80163b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8a 00                	mov    (%eax),%al
  801647:	3c 2f                	cmp    $0x2f,%al
  801649:	7e 19                	jle    801664 <strtol+0xc2>
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 39                	cmp    $0x39,%al
  801652:	7f 10                	jg     801664 <strtol+0xc2>
			dig = *s - '0';
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	0f be c0             	movsbl %al,%eax
  80165c:	83 e8 30             	sub    $0x30,%eax
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801662:	eb 42                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8a 00                	mov    (%eax),%al
  801669:	3c 60                	cmp    $0x60,%al
  80166b:	7e 19                	jle    801686 <strtol+0xe4>
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 7a                	cmp    $0x7a,%al
  801674:	7f 10                	jg     801686 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	0f be c0             	movsbl %al,%eax
  80167e:	83 e8 57             	sub    $0x57,%eax
  801681:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801684:	eb 20                	jmp    8016a6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801686:	8b 45 08             	mov    0x8(%ebp),%eax
  801689:	8a 00                	mov    (%eax),%al
  80168b:	3c 40                	cmp    $0x40,%al
  80168d:	7e 39                	jle    8016c8 <strtol+0x126>
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8a 00                	mov    (%eax),%al
  801694:	3c 5a                	cmp    $0x5a,%al
  801696:	7f 30                	jg     8016c8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	8a 00                	mov    (%eax),%al
  80169d:	0f be c0             	movsbl %al,%eax
  8016a0:	83 e8 37             	sub    $0x37,%eax
  8016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016ac:	7d 19                	jge    8016c7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ae:	ff 45 08             	incl   0x8(%ebp)
  8016b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016b8:	89 c2                	mov    %eax,%edx
  8016ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016bd:	01 d0                	add    %edx,%eax
  8016bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016c2:	e9 7b ff ff ff       	jmp    801642 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016c7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016cc:	74 08                	je     8016d6 <strtol+0x134>
		*endptr = (char *) s;
  8016ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016d4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016da:	74 07                	je     8016e3 <strtol+0x141>
  8016dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016df:	f7 d8                	neg    %eax
  8016e1:	eb 03                	jmp    8016e6 <strtol+0x144>
  8016e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <ltostr>:

void
ltostr(long value, char *str)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016f5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801700:	79 13                	jns    801715 <ltostr+0x2d>
	{
		neg = 1;
  801702:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80170f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801712:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80171d:	99                   	cltd   
  80171e:	f7 f9                	idiv   %ecx
  801720:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801723:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801726:	8d 50 01             	lea    0x1(%eax),%edx
  801729:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80172c:	89 c2                	mov    %eax,%edx
  80172e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801731:	01 d0                	add    %edx,%eax
  801733:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801736:	83 c2 30             	add    $0x30,%edx
  801739:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801754:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801757:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80175c:	f7 e9                	imul   %ecx
  80175e:	c1 fa 02             	sar    $0x2,%edx
  801761:	89 c8                	mov    %ecx,%eax
  801763:	c1 f8 1f             	sar    $0x1f,%eax
  801766:	29 c2                	sub    %eax,%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	c1 e0 02             	shl    $0x2,%eax
  80176d:	01 d0                	add    %edx,%eax
  80176f:	01 c0                	add    %eax,%eax
  801771:	29 c1                	sub    %eax,%ecx
  801773:	89 ca                	mov    %ecx,%edx
  801775:	85 d2                	test   %edx,%edx
  801777:	75 9c                	jne    801715 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801780:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801783:	48                   	dec    %eax
  801784:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801787:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80178b:	74 3d                	je     8017ca <ltostr+0xe2>
		start = 1 ;
  80178d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801794:	eb 34                	jmp    8017ca <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801799:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179c:	01 d0                	add    %edx,%eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a9:	01 c2                	add    %eax,%edx
  8017ab:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	01 c8                	add    %ecx,%eax
  8017b3:	8a 00                	mov    (%eax),%al
  8017b5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bd:	01 c2                	add    %eax,%edx
  8017bf:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017c2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017c4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017c7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017d0:	7c c4                	jl     801796 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d8:	01 d0                	add    %edx,%eax
  8017da:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017dd:	90                   	nop
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 54 fa ff ff       	call   801242 <strlen>
  8017ee:	83 c4 04             	add    $0x4,%esp
  8017f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	e8 46 fa ff ff       	call   801242 <strlen>
  8017fc:	83 c4 04             	add    $0x4,%esp
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801802:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801809:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801810:	eb 17                	jmp    801829 <strcconcat+0x49>
		final[s] = str1[s] ;
  801812:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801815:	8b 45 10             	mov    0x10(%ebp),%eax
  801818:	01 c2                	add    %eax,%edx
  80181a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	01 c8                	add    %ecx,%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801826:	ff 45 fc             	incl   -0x4(%ebp)
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80182f:	7c e1                	jl     801812 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801831:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801838:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80183f:	eb 1f                	jmp    801860 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801844:	8d 50 01             	lea    0x1(%eax),%edx
  801847:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80184a:	89 c2                	mov    %eax,%edx
  80184c:	8b 45 10             	mov    0x10(%ebp),%eax
  80184f:	01 c2                	add    %eax,%edx
  801851:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801854:	8b 45 0c             	mov    0xc(%ebp),%eax
  801857:	01 c8                	add    %ecx,%eax
  801859:	8a 00                	mov    (%eax),%al
  80185b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80185d:	ff 45 f8             	incl   -0x8(%ebp)
  801860:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801863:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801866:	7c d9                	jl     801841 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801868:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80186b:	8b 45 10             	mov    0x10(%ebp),%eax
  80186e:	01 d0                	add    %edx,%eax
  801870:	c6 00 00             	movb   $0x0,(%eax)
}
  801873:	90                   	nop
  801874:	c9                   	leave  
  801875:	c3                   	ret    

00801876 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801879:	8b 45 14             	mov    0x14(%ebp),%eax
  80187c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801882:	8b 45 14             	mov    0x14(%ebp),%eax
  801885:	8b 00                	mov    (%eax),%eax
  801887:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	01 d0                	add    %edx,%eax
  801893:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801899:	eb 0c                	jmp    8018a7 <strsplit+0x31>
			*string++ = 0;
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8d 50 01             	lea    0x1(%eax),%edx
  8018a1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018a4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8a 00                	mov    (%eax),%al
  8018ac:	84 c0                	test   %al,%al
  8018ae:	74 18                	je     8018c8 <strsplit+0x52>
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	8a 00                	mov    (%eax),%al
  8018b5:	0f be c0             	movsbl %al,%eax
  8018b8:	50                   	push   %eax
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	e8 13 fb ff ff       	call   8013d4 <strchr>
  8018c1:	83 c4 08             	add    $0x8,%esp
  8018c4:	85 c0                	test   %eax,%eax
  8018c6:	75 d3                	jne    80189b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cb:	8a 00                	mov    (%eax),%al
  8018cd:	84 c0                	test   %al,%al
  8018cf:	74 5a                	je     80192b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018d4:	8b 00                	mov    (%eax),%eax
  8018d6:	83 f8 0f             	cmp    $0xf,%eax
  8018d9:	75 07                	jne    8018e2 <strsplit+0x6c>
		{
			return 0;
  8018db:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e0:	eb 66                	jmp    801948 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018e5:	8b 00                	mov    (%eax),%eax
  8018e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8018ea:	8b 55 14             	mov    0x14(%ebp),%edx
  8018ed:	89 0a                	mov    %ecx,(%edx)
  8018ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f9:	01 c2                	add    %eax,%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801900:	eb 03                	jmp    801905 <strsplit+0x8f>
			string++;
  801902:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	84 c0                	test   %al,%al
  80190c:	74 8b                	je     801899 <strsplit+0x23>
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	8a 00                	mov    (%eax),%al
  801913:	0f be c0             	movsbl %al,%eax
  801916:	50                   	push   %eax
  801917:	ff 75 0c             	pushl  0xc(%ebp)
  80191a:	e8 b5 fa ff ff       	call   8013d4 <strchr>
  80191f:	83 c4 08             	add    $0x8,%esp
  801922:	85 c0                	test   %eax,%eax
  801924:	74 dc                	je     801902 <strsplit+0x8c>
			string++;
	}
  801926:	e9 6e ff ff ff       	jmp    801899 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80192b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80192c:	8b 45 14             	mov    0x14(%ebp),%eax
  80192f:	8b 00                	mov    (%eax),%eax
  801931:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801938:	8b 45 10             	mov    0x10(%ebp),%eax
  80193b:	01 d0                	add    %edx,%eax
  80193d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801943:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801950:	a1 04 50 80 00       	mov    0x805004,%eax
  801955:	85 c0                	test   %eax,%eax
  801957:	74 1f                	je     801978 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801959:	e8 1d 00 00 00       	call   80197b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80195e:	83 ec 0c             	sub    $0xc,%esp
  801961:	68 b0 40 80 00       	push   $0x8040b0
  801966:	e8 55 f2 ff ff       	call   800bc0 <cprintf>
  80196b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80196e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801975:	00 00 00 
	}
}
  801978:	90                   	nop
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801981:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801988:	00 00 00 
  80198b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801992:	00 00 00 
  801995:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80199c:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80199f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019a6:	00 00 00 
  8019a9:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019b0:	00 00 00 
  8019b3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019ba:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8019bd:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8019c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c7:	c1 e8 0c             	shr    $0xc,%eax
  8019ca:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8019cf:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8019d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019e3:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  8019e8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8019ef:	a1 20 51 80 00       	mov    0x805120,%eax
  8019f4:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8019f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8019fb:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801a02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a08:	01 d0                	add    %edx,%eax
  801a0a:	48                   	dec    %eax
  801a0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a11:	ba 00 00 00 00       	mov    $0x0,%edx
  801a16:	f7 75 e4             	divl   -0x1c(%ebp)
  801a19:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a1c:	29 d0                	sub    %edx,%eax
  801a1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801a21:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801a28:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a30:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	6a 07                	push   $0x7
  801a3a:	ff 75 e8             	pushl  -0x18(%ebp)
  801a3d:	50                   	push   %eax
  801a3e:	e8 3d 06 00 00       	call   802080 <sys_allocate_chunk>
  801a43:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a46:	a1 20 51 80 00       	mov    0x805120,%eax
  801a4b:	83 ec 0c             	sub    $0xc,%esp
  801a4e:	50                   	push   %eax
  801a4f:	e8 b2 0c 00 00       	call   802706 <initialize_MemBlocksList>
  801a54:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801a57:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801a5c:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801a5f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a63:	0f 84 f3 00 00 00    	je     801b5c <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801a69:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a6d:	75 14                	jne    801a83 <initialize_dyn_block_system+0x108>
  801a6f:	83 ec 04             	sub    $0x4,%esp
  801a72:	68 d5 40 80 00       	push   $0x8040d5
  801a77:	6a 36                	push   $0x36
  801a79:	68 f3 40 80 00       	push   $0x8040f3
  801a7e:	e8 89 ee ff ff       	call   80090c <_panic>
  801a83:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a86:	8b 00                	mov    (%eax),%eax
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	74 10                	je     801a9c <initialize_dyn_block_system+0x121>
  801a8c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a8f:	8b 00                	mov    (%eax),%eax
  801a91:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a94:	8b 52 04             	mov    0x4(%edx),%edx
  801a97:	89 50 04             	mov    %edx,0x4(%eax)
  801a9a:	eb 0b                	jmp    801aa7 <initialize_dyn_block_system+0x12c>
  801a9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a9f:	8b 40 04             	mov    0x4(%eax),%eax
  801aa2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801aa7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aaa:	8b 40 04             	mov    0x4(%eax),%eax
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	74 0f                	je     801ac0 <initialize_dyn_block_system+0x145>
  801ab1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ab4:	8b 40 04             	mov    0x4(%eax),%eax
  801ab7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801aba:	8b 12                	mov    (%edx),%edx
  801abc:	89 10                	mov    %edx,(%eax)
  801abe:	eb 0a                	jmp    801aca <initialize_dyn_block_system+0x14f>
  801ac0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ac3:	8b 00                	mov    (%eax),%eax
  801ac5:	a3 48 51 80 00       	mov    %eax,0x805148
  801aca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801acd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ad3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ad6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801add:	a1 54 51 80 00       	mov    0x805154,%eax
  801ae2:	48                   	dec    %eax
  801ae3:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801ae8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aeb:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801af2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801af5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801afc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801b00:	75 14                	jne    801b16 <initialize_dyn_block_system+0x19b>
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	68 00 41 80 00       	push   $0x804100
  801b0a:	6a 3e                	push   $0x3e
  801b0c:	68 f3 40 80 00       	push   $0x8040f3
  801b11:	e8 f6 ed ff ff       	call   80090c <_panic>
  801b16:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b1f:	89 10                	mov    %edx,(%eax)
  801b21:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b24:	8b 00                	mov    (%eax),%eax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	74 0d                	je     801b37 <initialize_dyn_block_system+0x1bc>
  801b2a:	a1 38 51 80 00       	mov    0x805138,%eax
  801b2f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b32:	89 50 04             	mov    %edx,0x4(%eax)
  801b35:	eb 08                	jmp    801b3f <initialize_dyn_block_system+0x1c4>
  801b37:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b3a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b3f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b42:	a3 38 51 80 00       	mov    %eax,0x805138
  801b47:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b51:	a1 44 51 80 00       	mov    0x805144,%eax
  801b56:	40                   	inc    %eax
  801b57:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801b5c:	90                   	nop
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801b65:	e8 e0 fd ff ff       	call   80194a <InitializeUHeap>
		if (size == 0) return NULL ;
  801b6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b6e:	75 07                	jne    801b77 <malloc+0x18>
  801b70:	b8 00 00 00 00       	mov    $0x0,%eax
  801b75:	eb 7f                	jmp    801bf6 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b77:	e8 d2 08 00 00       	call   80244e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	74 71                	je     801bf1 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801b80:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b87:	8b 55 08             	mov    0x8(%ebp),%edx
  801b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b8d:	01 d0                	add    %edx,%eax
  801b8f:	48                   	dec    %eax
  801b90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b96:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9b:	f7 75 f4             	divl   -0xc(%ebp)
  801b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba1:	29 d0                	sub    %edx,%eax
  801ba3:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801ba6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801bad:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801bb4:	76 07                	jbe    801bbd <malloc+0x5e>
					return NULL ;
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbb:	eb 39                	jmp    801bf6 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801bbd:	83 ec 0c             	sub    $0xc,%esp
  801bc0:	ff 75 08             	pushl  0x8(%ebp)
  801bc3:	e8 e6 0d 00 00       	call   8029ae <alloc_block_FF>
  801bc8:	83 c4 10             	add    $0x10,%esp
  801bcb:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801bce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bd2:	74 16                	je     801bea <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801bd4:	83 ec 0c             	sub    $0xc,%esp
  801bd7:	ff 75 ec             	pushl  -0x14(%ebp)
  801bda:	e8 37 0c 00 00       	call   802816 <insert_sorted_allocList>
  801bdf:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801be5:	8b 40 08             	mov    0x8(%eax),%eax
  801be8:	eb 0c                	jmp    801bf6 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801bea:	b8 00 00 00 00       	mov    $0x0,%eax
  801bef:	eb 05                	jmp    801bf6 <malloc+0x97>
				}
		}
	return 0;
  801bf1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
  801bfb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801c04:	83 ec 08             	sub    $0x8,%esp
  801c07:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0a:	68 40 50 80 00       	push   $0x805040
  801c0f:	e8 cf 0b 00 00       	call   8027e3 <find_block>
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c20:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c26:	8b 40 08             	mov    0x8(%eax),%eax
  801c29:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801c2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c30:	0f 84 a1 00 00 00    	je     801cd7 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801c36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c3a:	75 17                	jne    801c53 <free+0x5b>
  801c3c:	83 ec 04             	sub    $0x4,%esp
  801c3f:	68 d5 40 80 00       	push   $0x8040d5
  801c44:	68 80 00 00 00       	push   $0x80
  801c49:	68 f3 40 80 00       	push   $0x8040f3
  801c4e:	e8 b9 ec ff ff       	call   80090c <_panic>
  801c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c56:	8b 00                	mov    (%eax),%eax
  801c58:	85 c0                	test   %eax,%eax
  801c5a:	74 10                	je     801c6c <free+0x74>
  801c5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5f:	8b 00                	mov    (%eax),%eax
  801c61:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c64:	8b 52 04             	mov    0x4(%edx),%edx
  801c67:	89 50 04             	mov    %edx,0x4(%eax)
  801c6a:	eb 0b                	jmp    801c77 <free+0x7f>
  801c6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6f:	8b 40 04             	mov    0x4(%eax),%eax
  801c72:	a3 44 50 80 00       	mov    %eax,0x805044
  801c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7a:	8b 40 04             	mov    0x4(%eax),%eax
  801c7d:	85 c0                	test   %eax,%eax
  801c7f:	74 0f                	je     801c90 <free+0x98>
  801c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c84:	8b 40 04             	mov    0x4(%eax),%eax
  801c87:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c8a:	8b 12                	mov    (%edx),%edx
  801c8c:	89 10                	mov    %edx,(%eax)
  801c8e:	eb 0a                	jmp    801c9a <free+0xa2>
  801c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c93:	8b 00                	mov    (%eax),%eax
  801c95:	a3 40 50 80 00       	mov    %eax,0x805040
  801c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cad:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801cb2:	48                   	dec    %eax
  801cb3:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801cb8:	83 ec 0c             	sub    $0xc,%esp
  801cbb:	ff 75 f0             	pushl  -0x10(%ebp)
  801cbe:	e8 29 12 00 00       	call   802eec <insert_sorted_with_merge_freeList>
  801cc3:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801cc6:	83 ec 08             	sub    $0x8,%esp
  801cc9:	ff 75 ec             	pushl  -0x14(%ebp)
  801ccc:	ff 75 e8             	pushl  -0x18(%ebp)
  801ccf:	e8 74 03 00 00       	call   802048 <sys_free_user_mem>
  801cd4:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 38             	sub    $0x38,%esp
  801ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce3:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ce6:	e8 5f fc ff ff       	call   80194a <InitializeUHeap>
	if (size == 0) return NULL ;
  801ceb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cef:	75 0a                	jne    801cfb <smalloc+0x21>
  801cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf6:	e9 b2 00 00 00       	jmp    801dad <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801cfb:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801d02:	76 0a                	jbe    801d0e <smalloc+0x34>
		return NULL;
  801d04:	b8 00 00 00 00       	mov    $0x0,%eax
  801d09:	e9 9f 00 00 00       	jmp    801dad <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d0e:	e8 3b 07 00 00       	call   80244e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d13:	85 c0                	test   %eax,%eax
  801d15:	0f 84 8d 00 00 00    	je     801da8 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801d1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801d22:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2f:	01 d0                	add    %edx,%eax
  801d31:	48                   	dec    %eax
  801d32:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d38:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3d:	f7 75 f0             	divl   -0x10(%ebp)
  801d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d43:	29 d0                	sub    %edx,%eax
  801d45:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	ff 75 e8             	pushl  -0x18(%ebp)
  801d4e:	e8 5b 0c 00 00       	call   8029ae <alloc_block_FF>
  801d53:	83 c4 10             	add    $0x10,%esp
  801d56:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801d59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d5d:	75 07                	jne    801d66 <smalloc+0x8c>
			return NULL;
  801d5f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d64:	eb 47                	jmp    801dad <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801d66:	83 ec 0c             	sub    $0xc,%esp
  801d69:	ff 75 f4             	pushl  -0xc(%ebp)
  801d6c:	e8 a5 0a 00 00       	call   802816 <insert_sorted_allocList>
  801d71:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d77:	8b 40 08             	mov    0x8(%eax),%eax
  801d7a:	89 c2                	mov    %eax,%edx
  801d7c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d80:	52                   	push   %edx
  801d81:	50                   	push   %eax
  801d82:	ff 75 0c             	pushl  0xc(%ebp)
  801d85:	ff 75 08             	pushl  0x8(%ebp)
  801d88:	e8 46 04 00 00       	call   8021d3 <sys_createSharedObject>
  801d8d:	83 c4 10             	add    $0x10,%esp
  801d90:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801d93:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d97:	78 08                	js     801da1 <smalloc+0xc7>
		return (void *)b->sva;
  801d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9c:	8b 40 08             	mov    0x8(%eax),%eax
  801d9f:	eb 0c                	jmp    801dad <smalloc+0xd3>
		}else{
		return NULL;
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
  801da6:	eb 05                	jmp    801dad <smalloc+0xd3>
			}

	}return NULL;
  801da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801db5:	e8 90 fb ff ff       	call   80194a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801dba:	e8 8f 06 00 00       	call   80244e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	0f 84 ad 00 00 00    	je     801e74 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801dc7:	83 ec 08             	sub    $0x8,%esp
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	e8 28 04 00 00       	call   8021fd <sys_getSizeOfSharedObject>
  801dd5:	83 c4 10             	add    $0x10,%esp
  801dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ddf:	79 0a                	jns    801deb <sget+0x3c>
    {
    	return NULL;
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
  801de6:	e9 8e 00 00 00       	jmp    801e79 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801deb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801df2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801df9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801dff:	01 d0                	add    %edx,%eax
  801e01:	48                   	dec    %eax
  801e02:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e08:	ba 00 00 00 00       	mov    $0x0,%edx
  801e0d:	f7 75 ec             	divl   -0x14(%ebp)
  801e10:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e13:	29 d0                	sub    %edx,%eax
  801e15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801e18:	83 ec 0c             	sub    $0xc,%esp
  801e1b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e1e:	e8 8b 0b 00 00       	call   8029ae <alloc_block_FF>
  801e23:	83 c4 10             	add    $0x10,%esp
  801e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801e29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e2d:	75 07                	jne    801e36 <sget+0x87>
				return NULL;
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e34:	eb 43                	jmp    801e79 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	ff 75 f0             	pushl  -0x10(%ebp)
  801e3c:	e8 d5 09 00 00       	call   802816 <insert_sorted_allocList>
  801e41:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e47:	8b 40 08             	mov    0x8(%eax),%eax
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	50                   	push   %eax
  801e4e:	ff 75 0c             	pushl  0xc(%ebp)
  801e51:	ff 75 08             	pushl  0x8(%ebp)
  801e54:	e8 c1 03 00 00       	call   80221a <sys_getSharedObject>
  801e59:	83 c4 10             	add    $0x10,%esp
  801e5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801e5f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e63:	78 08                	js     801e6d <sget+0xbe>
			return (void *)b->sva;
  801e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e68:	8b 40 08             	mov    0x8(%eax),%eax
  801e6b:	eb 0c                	jmp    801e79 <sget+0xca>
			}else{
			return NULL;
  801e6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e72:	eb 05                	jmp    801e79 <sget+0xca>
			}
    }}return NULL;
  801e74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e79:	c9                   	leave  
  801e7a:	c3                   	ret    

00801e7b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e7b:	55                   	push   %ebp
  801e7c:	89 e5                	mov    %esp,%ebp
  801e7e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e81:	e8 c4 fa ff ff       	call   80194a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e86:	83 ec 04             	sub    $0x4,%esp
  801e89:	68 24 41 80 00       	push   $0x804124
  801e8e:	68 03 01 00 00       	push   $0x103
  801e93:	68 f3 40 80 00       	push   $0x8040f3
  801e98:	e8 6f ea ff ff       	call   80090c <_panic>

00801e9d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e9d:	55                   	push   %ebp
  801e9e:	89 e5                	mov    %esp,%ebp
  801ea0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ea3:	83 ec 04             	sub    $0x4,%esp
  801ea6:	68 4c 41 80 00       	push   $0x80414c
  801eab:	68 17 01 00 00       	push   $0x117
  801eb0:	68 f3 40 80 00       	push   $0x8040f3
  801eb5:	e8 52 ea ff ff       	call   80090c <_panic>

00801eba <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
  801ebd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	68 70 41 80 00       	push   $0x804170
  801ec8:	68 22 01 00 00       	push   $0x122
  801ecd:	68 f3 40 80 00       	push   $0x8040f3
  801ed2:	e8 35 ea ff ff       	call   80090c <_panic>

00801ed7 <shrink>:

}
void shrink(uint32 newSize)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801edd:	83 ec 04             	sub    $0x4,%esp
  801ee0:	68 70 41 80 00       	push   $0x804170
  801ee5:	68 27 01 00 00       	push   $0x127
  801eea:	68 f3 40 80 00       	push   $0x8040f3
  801eef:	e8 18 ea ff ff       	call   80090c <_panic>

00801ef4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ef4:	55                   	push   %ebp
  801ef5:	89 e5                	mov    %esp,%ebp
  801ef7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801efa:	83 ec 04             	sub    $0x4,%esp
  801efd:	68 70 41 80 00       	push   $0x804170
  801f02:	68 2c 01 00 00       	push   $0x12c
  801f07:	68 f3 40 80 00       	push   $0x8040f3
  801f0c:	e8 fb e9 ff ff       	call   80090c <_panic>

00801f11 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	57                   	push   %edi
  801f15:	56                   	push   %esi
  801f16:	53                   	push   %ebx
  801f17:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f20:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f23:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f26:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f29:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f2c:	cd 30                	int    $0x30
  801f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5f                   	pop    %edi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    

00801f3c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
  801f3f:	83 ec 04             	sub    $0x4,%esp
  801f42:	8b 45 10             	mov    0x10(%ebp),%eax
  801f45:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f48:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	52                   	push   %edx
  801f54:	ff 75 0c             	pushl  0xc(%ebp)
  801f57:	50                   	push   %eax
  801f58:	6a 00                	push   $0x0
  801f5a:	e8 b2 ff ff ff       	call   801f11 <syscall>
  801f5f:	83 c4 18             	add    $0x18,%esp
}
  801f62:	90                   	nop
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 01                	push   $0x1
  801f74:	e8 98 ff ff ff       	call   801f11 <syscall>
  801f79:	83 c4 18             	add    $0x18,%esp
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f81:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f84:	8b 45 08             	mov    0x8(%ebp),%eax
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	52                   	push   %edx
  801f8e:	50                   	push   %eax
  801f8f:	6a 05                	push   $0x5
  801f91:	e8 7b ff ff ff       	call   801f11 <syscall>
  801f96:	83 c4 18             	add    $0x18,%esp
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	56                   	push   %esi
  801f9f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fa0:	8b 75 18             	mov    0x18(%ebp),%esi
  801fa3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	56                   	push   %esi
  801fb0:	53                   	push   %ebx
  801fb1:	51                   	push   %ecx
  801fb2:	52                   	push   %edx
  801fb3:	50                   	push   %eax
  801fb4:	6a 06                	push   $0x6
  801fb6:	e8 56 ff ff ff       	call   801f11 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
}
  801fbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc1:	5b                   	pop    %ebx
  801fc2:	5e                   	pop    %esi
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    

00801fc5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	52                   	push   %edx
  801fd5:	50                   	push   %eax
  801fd6:	6a 07                	push   $0x7
  801fd8:	e8 34 ff ff ff       	call   801f11 <syscall>
  801fdd:	83 c4 18             	add    $0x18,%esp
}
  801fe0:	c9                   	leave  
  801fe1:	c3                   	ret    

00801fe2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fe2:	55                   	push   %ebp
  801fe3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	ff 75 0c             	pushl  0xc(%ebp)
  801fee:	ff 75 08             	pushl  0x8(%ebp)
  801ff1:	6a 08                	push   $0x8
  801ff3:	e8 19 ff ff ff       	call   801f11 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 09                	push   $0x9
  80200c:	e8 00 ff ff ff       	call   801f11 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 0a                	push   $0xa
  802025:	e8 e7 fe ff ff       	call   801f11 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	6a 0b                	push   $0xb
  80203e:	e8 ce fe ff ff       	call   801f11 <syscall>
  802043:	83 c4 18             	add    $0x18,%esp
}
  802046:	c9                   	leave  
  802047:	c3                   	ret    

00802048 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802048:	55                   	push   %ebp
  802049:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	ff 75 0c             	pushl  0xc(%ebp)
  802054:	ff 75 08             	pushl  0x8(%ebp)
  802057:	6a 0f                	push   $0xf
  802059:	e8 b3 fe ff ff       	call   801f11 <syscall>
  80205e:	83 c4 18             	add    $0x18,%esp
	return;
  802061:	90                   	nop
}
  802062:	c9                   	leave  
  802063:	c3                   	ret    

00802064 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802064:	55                   	push   %ebp
  802065:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 00                	push   $0x0
  80206d:	ff 75 0c             	pushl  0xc(%ebp)
  802070:	ff 75 08             	pushl  0x8(%ebp)
  802073:	6a 10                	push   $0x10
  802075:	e8 97 fe ff ff       	call   801f11 <syscall>
  80207a:	83 c4 18             	add    $0x18,%esp
	return ;
  80207d:	90                   	nop
}
  80207e:	c9                   	leave  
  80207f:	c3                   	ret    

00802080 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802083:	6a 00                	push   $0x0
  802085:	6a 00                	push   $0x0
  802087:	ff 75 10             	pushl  0x10(%ebp)
  80208a:	ff 75 0c             	pushl  0xc(%ebp)
  80208d:	ff 75 08             	pushl  0x8(%ebp)
  802090:	6a 11                	push   $0x11
  802092:	e8 7a fe ff ff       	call   801f11 <syscall>
  802097:	83 c4 18             	add    $0x18,%esp
	return ;
  80209a:	90                   	nop
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 0c                	push   $0xc
  8020ac:	e8 60 fe ff ff       	call   801f11 <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	ff 75 08             	pushl  0x8(%ebp)
  8020c4:	6a 0d                	push   $0xd
  8020c6:	e8 46 fe ff ff       	call   801f11 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
}
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 0e                	push   $0xe
  8020df:	e8 2d fe ff ff       	call   801f11 <syscall>
  8020e4:	83 c4 18             	add    $0x18,%esp
}
  8020e7:	90                   	nop
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 13                	push   $0x13
  8020f9:	e8 13 fe ff ff       	call   801f11 <syscall>
  8020fe:	83 c4 18             	add    $0x18,%esp
}
  802101:	90                   	nop
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802107:	6a 00                	push   $0x0
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 14                	push   $0x14
  802113:	e8 f9 fd ff ff       	call   801f11 <syscall>
  802118:	83 c4 18             	add    $0x18,%esp
}
  80211b:	90                   	nop
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_cputc>:


void
sys_cputc(const char c)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80212a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	50                   	push   %eax
  802137:	6a 15                	push   $0x15
  802139:	e8 d3 fd ff ff       	call   801f11 <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	90                   	nop
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802147:	6a 00                	push   $0x0
  802149:	6a 00                	push   $0x0
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	6a 16                	push   $0x16
  802153:	e8 b9 fd ff ff       	call   801f11 <syscall>
  802158:	83 c4 18             	add    $0x18,%esp
}
  80215b:	90                   	nop
  80215c:	c9                   	leave  
  80215d:	c3                   	ret    

0080215e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802161:	8b 45 08             	mov    0x8(%ebp),%eax
  802164:	6a 00                	push   $0x0
  802166:	6a 00                	push   $0x0
  802168:	6a 00                	push   $0x0
  80216a:	ff 75 0c             	pushl  0xc(%ebp)
  80216d:	50                   	push   %eax
  80216e:	6a 17                	push   $0x17
  802170:	e8 9c fd ff ff       	call   801f11 <syscall>
  802175:	83 c4 18             	add    $0x18,%esp
}
  802178:	c9                   	leave  
  802179:	c3                   	ret    

0080217a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80217a:	55                   	push   %ebp
  80217b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80217d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	52                   	push   %edx
  80218a:	50                   	push   %eax
  80218b:	6a 1a                	push   $0x1a
  80218d:	e8 7f fd ff ff       	call   801f11 <syscall>
  802192:	83 c4 18             	add    $0x18,%esp
}
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80219a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	6a 00                	push   $0x0
  8021a2:	6a 00                	push   $0x0
  8021a4:	6a 00                	push   $0x0
  8021a6:	52                   	push   %edx
  8021a7:	50                   	push   %eax
  8021a8:	6a 18                	push   $0x18
  8021aa:	e8 62 fd ff ff       	call   801f11 <syscall>
  8021af:	83 c4 18             	add    $0x18,%esp
}
  8021b2:	90                   	nop
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021be:	6a 00                	push   $0x0
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	52                   	push   %edx
  8021c5:	50                   	push   %eax
  8021c6:	6a 19                	push   $0x19
  8021c8:	e8 44 fd ff ff       	call   801f11 <syscall>
  8021cd:	83 c4 18             	add    $0x18,%esp
}
  8021d0:	90                   	nop
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021df:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	6a 00                	push   $0x0
  8021eb:	51                   	push   %ecx
  8021ec:	52                   	push   %edx
  8021ed:	ff 75 0c             	pushl  0xc(%ebp)
  8021f0:	50                   	push   %eax
  8021f1:	6a 1b                	push   $0x1b
  8021f3:	e8 19 fd ff ff       	call   801f11 <syscall>
  8021f8:	83 c4 18             	add    $0x18,%esp
}
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802200:	8b 55 0c             	mov    0xc(%ebp),%edx
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	52                   	push   %edx
  80220d:	50                   	push   %eax
  80220e:	6a 1c                	push   $0x1c
  802210:	e8 fc fc ff ff       	call   801f11 <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80221d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802220:	8b 55 0c             	mov    0xc(%ebp),%edx
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	51                   	push   %ecx
  80222b:	52                   	push   %edx
  80222c:	50                   	push   %eax
  80222d:	6a 1d                	push   $0x1d
  80222f:	e8 dd fc ff ff       	call   801f11 <syscall>
  802234:	83 c4 18             	add    $0x18,%esp
}
  802237:	c9                   	leave  
  802238:	c3                   	ret    

00802239 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802239:	55                   	push   %ebp
  80223a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80223c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	52                   	push   %edx
  802249:	50                   	push   %eax
  80224a:	6a 1e                	push   $0x1e
  80224c:	e8 c0 fc ff ff       	call   801f11 <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802259:	6a 00                	push   $0x0
  80225b:	6a 00                	push   $0x0
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 1f                	push   $0x1f
  802265:	e8 a7 fc ff ff       	call   801f11 <syscall>
  80226a:	83 c4 18             	add    $0x18,%esp
}
  80226d:	c9                   	leave  
  80226e:	c3                   	ret    

0080226f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	6a 00                	push   $0x0
  802277:	ff 75 14             	pushl  0x14(%ebp)
  80227a:	ff 75 10             	pushl  0x10(%ebp)
  80227d:	ff 75 0c             	pushl  0xc(%ebp)
  802280:	50                   	push   %eax
  802281:	6a 20                	push   $0x20
  802283:	e8 89 fc ff ff       	call   801f11 <syscall>
  802288:	83 c4 18             	add    $0x18,%esp
}
  80228b:	c9                   	leave  
  80228c:	c3                   	ret    

0080228d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80228d:	55                   	push   %ebp
  80228e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	6a 00                	push   $0x0
  802295:	6a 00                	push   $0x0
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	50                   	push   %eax
  80229c:	6a 21                	push   $0x21
  80229e:	e8 6e fc ff ff       	call   801f11 <syscall>
  8022a3:	83 c4 18             	add    $0x18,%esp
}
  8022a6:	90                   	nop
  8022a7:	c9                   	leave  
  8022a8:	c3                   	ret    

008022a9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022a9:	55                   	push   %ebp
  8022aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	50                   	push   %eax
  8022b8:	6a 22                	push   $0x22
  8022ba:	e8 52 fc ff ff       	call   801f11 <syscall>
  8022bf:	83 c4 18             	add    $0x18,%esp
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 02                	push   $0x2
  8022d3:	e8 39 fc ff ff       	call   801f11 <syscall>
  8022d8:	83 c4 18             	add    $0x18,%esp
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 03                	push   $0x3
  8022ec:	e8 20 fc ff ff       	call   801f11 <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 04                	push   $0x4
  802305:	e8 07 fc ff ff       	call   801f11 <syscall>
  80230a:	83 c4 18             	add    $0x18,%esp
}
  80230d:	c9                   	leave  
  80230e:	c3                   	ret    

0080230f <sys_exit_env>:


void sys_exit_env(void)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802312:	6a 00                	push   $0x0
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 23                	push   $0x23
  80231e:	e8 ee fb ff ff       	call   801f11 <syscall>
  802323:	83 c4 18             	add    $0x18,%esp
}
  802326:	90                   	nop
  802327:	c9                   	leave  
  802328:	c3                   	ret    

00802329 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80232f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802332:	8d 50 04             	lea    0x4(%eax),%edx
  802335:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	52                   	push   %edx
  80233f:	50                   	push   %eax
  802340:	6a 24                	push   $0x24
  802342:	e8 ca fb ff ff       	call   801f11 <syscall>
  802347:	83 c4 18             	add    $0x18,%esp
	return result;
  80234a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80234d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802350:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802353:	89 01                	mov    %eax,(%ecx)
  802355:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	c9                   	leave  
  80235c:	c2 04 00             	ret    $0x4

0080235f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	ff 75 10             	pushl  0x10(%ebp)
  802369:	ff 75 0c             	pushl  0xc(%ebp)
  80236c:	ff 75 08             	pushl  0x8(%ebp)
  80236f:	6a 12                	push   $0x12
  802371:	e8 9b fb ff ff       	call   801f11 <syscall>
  802376:	83 c4 18             	add    $0x18,%esp
	return ;
  802379:	90                   	nop
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <sys_rcr2>:
uint32 sys_rcr2()
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	6a 25                	push   $0x25
  80238b:	e8 81 fb ff ff       	call   801f11 <syscall>
  802390:	83 c4 18             	add    $0x18,%esp
}
  802393:	c9                   	leave  
  802394:	c3                   	ret    

00802395 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802395:	55                   	push   %ebp
  802396:	89 e5                	mov    %esp,%ebp
  802398:	83 ec 04             	sub    $0x4,%esp
  80239b:	8b 45 08             	mov    0x8(%ebp),%eax
  80239e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023a1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	50                   	push   %eax
  8023ae:	6a 26                	push   $0x26
  8023b0:	e8 5c fb ff ff       	call   801f11 <syscall>
  8023b5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b8:	90                   	nop
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    

008023bb <rsttst>:
void rsttst()
{
  8023bb:	55                   	push   %ebp
  8023bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023be:	6a 00                	push   $0x0
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 28                	push   $0x28
  8023ca:	e8 42 fb ff ff       	call   801f11 <syscall>
  8023cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d2:	90                   	nop
}
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
  8023d8:	83 ec 04             	sub    $0x4,%esp
  8023db:	8b 45 14             	mov    0x14(%ebp),%eax
  8023de:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023e1:	8b 55 18             	mov    0x18(%ebp),%edx
  8023e4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023e8:	52                   	push   %edx
  8023e9:	50                   	push   %eax
  8023ea:	ff 75 10             	pushl  0x10(%ebp)
  8023ed:	ff 75 0c             	pushl  0xc(%ebp)
  8023f0:	ff 75 08             	pushl  0x8(%ebp)
  8023f3:	6a 27                	push   $0x27
  8023f5:	e8 17 fb ff ff       	call   801f11 <syscall>
  8023fa:	83 c4 18             	add    $0x18,%esp
	return ;
  8023fd:	90                   	nop
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <chktst>:
void chktst(uint32 n)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	ff 75 08             	pushl  0x8(%ebp)
  80240e:	6a 29                	push   $0x29
  802410:	e8 fc fa ff ff       	call   801f11 <syscall>
  802415:	83 c4 18             	add    $0x18,%esp
	return ;
  802418:	90                   	nop
}
  802419:	c9                   	leave  
  80241a:	c3                   	ret    

0080241b <inctst>:

void inctst()
{
  80241b:	55                   	push   %ebp
  80241c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80241e:	6a 00                	push   $0x0
  802420:	6a 00                	push   $0x0
  802422:	6a 00                	push   $0x0
  802424:	6a 00                	push   $0x0
  802426:	6a 00                	push   $0x0
  802428:	6a 2a                	push   $0x2a
  80242a:	e8 e2 fa ff ff       	call   801f11 <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
	return ;
  802432:	90                   	nop
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <gettst>:
uint32 gettst()
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 2b                	push   $0x2b
  802444:	e8 c8 fa ff ff       	call   801f11 <syscall>
  802449:	83 c4 18             	add    $0x18,%esp
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 2c                	push   $0x2c
  802460:	e8 ac fa ff ff       	call   801f11 <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
  802468:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80246b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80246f:	75 07                	jne    802478 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802471:	b8 01 00 00 00       	mov    $0x1,%eax
  802476:	eb 05                	jmp    80247d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802478:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247d:	c9                   	leave  
  80247e:	c3                   	ret    

0080247f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
  802482:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 00                	push   $0x0
  80248b:	6a 00                	push   $0x0
  80248d:	6a 00                	push   $0x0
  80248f:	6a 2c                	push   $0x2c
  802491:	e8 7b fa ff ff       	call   801f11 <syscall>
  802496:	83 c4 18             	add    $0x18,%esp
  802499:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80249c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024a0:	75 07                	jne    8024a9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a7:	eb 05                	jmp    8024ae <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ae:	c9                   	leave  
  8024af:	c3                   	ret    

008024b0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	6a 00                	push   $0x0
  8024bc:	6a 00                	push   $0x0
  8024be:	6a 00                	push   $0x0
  8024c0:	6a 2c                	push   $0x2c
  8024c2:	e8 4a fa ff ff       	call   801f11 <syscall>
  8024c7:	83 c4 18             	add    $0x18,%esp
  8024ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024cd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024d1:	75 07                	jne    8024da <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8024d8:	eb 05                	jmp    8024df <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024da:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024df:	c9                   	leave  
  8024e0:	c3                   	ret    

008024e1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
  8024e4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 00                	push   $0x0
  8024ef:	6a 00                	push   $0x0
  8024f1:	6a 2c                	push   $0x2c
  8024f3:	e8 19 fa ff ff       	call   801f11 <syscall>
  8024f8:	83 c4 18             	add    $0x18,%esp
  8024fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024fe:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802502:	75 07                	jne    80250b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802504:	b8 01 00 00 00       	mov    $0x1,%eax
  802509:	eb 05                	jmp    802510 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80250b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802515:	6a 00                	push   $0x0
  802517:	6a 00                	push   $0x0
  802519:	6a 00                	push   $0x0
  80251b:	6a 00                	push   $0x0
  80251d:	ff 75 08             	pushl  0x8(%ebp)
  802520:	6a 2d                	push   $0x2d
  802522:	e8 ea f9 ff ff       	call   801f11 <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
	return ;
  80252a:	90                   	nop
}
  80252b:	c9                   	leave  
  80252c:	c3                   	ret    

0080252d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
  802530:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802531:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802534:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	6a 00                	push   $0x0
  80253f:	53                   	push   %ebx
  802540:	51                   	push   %ecx
  802541:	52                   	push   %edx
  802542:	50                   	push   %eax
  802543:	6a 2e                	push   $0x2e
  802545:	e8 c7 f9 ff ff       	call   801f11 <syscall>
  80254a:	83 c4 18             	add    $0x18,%esp
}
  80254d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802550:	c9                   	leave  
  802551:	c3                   	ret    

00802552 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802555:	8b 55 0c             	mov    0xc(%ebp),%edx
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	52                   	push   %edx
  802562:	50                   	push   %eax
  802563:	6a 2f                	push   $0x2f
  802565:	e8 a7 f9 ff ff       	call   801f11 <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
}
  80256d:	c9                   	leave  
  80256e:	c3                   	ret    

0080256f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80256f:	55                   	push   %ebp
  802570:	89 e5                	mov    %esp,%ebp
  802572:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802575:	83 ec 0c             	sub    $0xc,%esp
  802578:	68 80 41 80 00       	push   $0x804180
  80257d:	e8 3e e6 ff ff       	call   800bc0 <cprintf>
  802582:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802585:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80258c:	83 ec 0c             	sub    $0xc,%esp
  80258f:	68 ac 41 80 00       	push   $0x8041ac
  802594:	e8 27 e6 ff ff       	call   800bc0 <cprintf>
  802599:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80259c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025a0:	a1 38 51 80 00       	mov    0x805138,%eax
  8025a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a8:	eb 56                	jmp    802600 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ae:	74 1c                	je     8025cc <print_mem_block_lists+0x5d>
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 50 08             	mov    0x8(%eax),%edx
  8025b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025b9:	8b 48 08             	mov    0x8(%eax),%ecx
  8025bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c2:	01 c8                	add    %ecx,%eax
  8025c4:	39 c2                	cmp    %eax,%edx
  8025c6:	73 04                	jae    8025cc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025c8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 50 08             	mov    0x8(%eax),%edx
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d8:	01 c2                	add    %eax,%edx
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 40 08             	mov    0x8(%eax),%eax
  8025e0:	83 ec 04             	sub    $0x4,%esp
  8025e3:	52                   	push   %edx
  8025e4:	50                   	push   %eax
  8025e5:	68 c1 41 80 00       	push   $0x8041c1
  8025ea:	e8 d1 e5 ff ff       	call   800bc0 <cprintf>
  8025ef:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025f8:	a1 40 51 80 00       	mov    0x805140,%eax
  8025fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802600:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802604:	74 07                	je     80260d <print_mem_block_lists+0x9e>
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 00                	mov    (%eax),%eax
  80260b:	eb 05                	jmp    802612 <print_mem_block_lists+0xa3>
  80260d:	b8 00 00 00 00       	mov    $0x0,%eax
  802612:	a3 40 51 80 00       	mov    %eax,0x805140
  802617:	a1 40 51 80 00       	mov    0x805140,%eax
  80261c:	85 c0                	test   %eax,%eax
  80261e:	75 8a                	jne    8025aa <print_mem_block_lists+0x3b>
  802620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802624:	75 84                	jne    8025aa <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802626:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80262a:	75 10                	jne    80263c <print_mem_block_lists+0xcd>
  80262c:	83 ec 0c             	sub    $0xc,%esp
  80262f:	68 d0 41 80 00       	push   $0x8041d0
  802634:	e8 87 e5 ff ff       	call   800bc0 <cprintf>
  802639:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80263c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802643:	83 ec 0c             	sub    $0xc,%esp
  802646:	68 f4 41 80 00       	push   $0x8041f4
  80264b:	e8 70 e5 ff ff       	call   800bc0 <cprintf>
  802650:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802653:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802657:	a1 40 50 80 00       	mov    0x805040,%eax
  80265c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265f:	eb 56                	jmp    8026b7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802661:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802665:	74 1c                	je     802683 <print_mem_block_lists+0x114>
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 50 08             	mov    0x8(%eax),%edx
  80266d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802670:	8b 48 08             	mov    0x8(%eax),%ecx
  802673:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802676:	8b 40 0c             	mov    0xc(%eax),%eax
  802679:	01 c8                	add    %ecx,%eax
  80267b:	39 c2                	cmp    %eax,%edx
  80267d:	73 04                	jae    802683 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80267f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 50 08             	mov    0x8(%eax),%edx
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	8b 40 0c             	mov    0xc(%eax),%eax
  80268f:	01 c2                	add    %eax,%edx
  802691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802694:	8b 40 08             	mov    0x8(%eax),%eax
  802697:	83 ec 04             	sub    $0x4,%esp
  80269a:	52                   	push   %edx
  80269b:	50                   	push   %eax
  80269c:	68 c1 41 80 00       	push   $0x8041c1
  8026a1:	e8 1a e5 ff ff       	call   800bc0 <cprintf>
  8026a6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026af:	a1 48 50 80 00       	mov    0x805048,%eax
  8026b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bb:	74 07                	je     8026c4 <print_mem_block_lists+0x155>
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	8b 00                	mov    (%eax),%eax
  8026c2:	eb 05                	jmp    8026c9 <print_mem_block_lists+0x15a>
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c9:	a3 48 50 80 00       	mov    %eax,0x805048
  8026ce:	a1 48 50 80 00       	mov    0x805048,%eax
  8026d3:	85 c0                	test   %eax,%eax
  8026d5:	75 8a                	jne    802661 <print_mem_block_lists+0xf2>
  8026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026db:	75 84                	jne    802661 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026dd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026e1:	75 10                	jne    8026f3 <print_mem_block_lists+0x184>
  8026e3:	83 ec 0c             	sub    $0xc,%esp
  8026e6:	68 0c 42 80 00       	push   $0x80420c
  8026eb:	e8 d0 e4 ff ff       	call   800bc0 <cprintf>
  8026f0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026f3:	83 ec 0c             	sub    $0xc,%esp
  8026f6:	68 80 41 80 00       	push   $0x804180
  8026fb:	e8 c0 e4 ff ff       	call   800bc0 <cprintf>
  802700:	83 c4 10             	add    $0x10,%esp

}
  802703:	90                   	nop
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80270c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802713:	00 00 00 
  802716:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80271d:	00 00 00 
  802720:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802727:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80272a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802731:	e9 9e 00 00 00       	jmp    8027d4 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802736:	a1 50 50 80 00       	mov    0x805050,%eax
  80273b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273e:	c1 e2 04             	shl    $0x4,%edx
  802741:	01 d0                	add    %edx,%eax
  802743:	85 c0                	test   %eax,%eax
  802745:	75 14                	jne    80275b <initialize_MemBlocksList+0x55>
  802747:	83 ec 04             	sub    $0x4,%esp
  80274a:	68 34 42 80 00       	push   $0x804234
  80274f:	6a 3d                	push   $0x3d
  802751:	68 57 42 80 00       	push   $0x804257
  802756:	e8 b1 e1 ff ff       	call   80090c <_panic>
  80275b:	a1 50 50 80 00       	mov    0x805050,%eax
  802760:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802763:	c1 e2 04             	shl    $0x4,%edx
  802766:	01 d0                	add    %edx,%eax
  802768:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80276e:	89 10                	mov    %edx,(%eax)
  802770:	8b 00                	mov    (%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	74 18                	je     80278e <initialize_MemBlocksList+0x88>
  802776:	a1 48 51 80 00       	mov    0x805148,%eax
  80277b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802781:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802784:	c1 e1 04             	shl    $0x4,%ecx
  802787:	01 ca                	add    %ecx,%edx
  802789:	89 50 04             	mov    %edx,0x4(%eax)
  80278c:	eb 12                	jmp    8027a0 <initialize_MemBlocksList+0x9a>
  80278e:	a1 50 50 80 00       	mov    0x805050,%eax
  802793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802796:	c1 e2 04             	shl    $0x4,%edx
  802799:	01 d0                	add    %edx,%eax
  80279b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8027a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a8:	c1 e2 04             	shl    $0x4,%edx
  8027ab:	01 d0                	add    %edx,%eax
  8027ad:	a3 48 51 80 00       	mov    %eax,0x805148
  8027b2:	a1 50 50 80 00       	mov    0x805050,%eax
  8027b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ba:	c1 e2 04             	shl    $0x4,%edx
  8027bd:	01 d0                	add    %edx,%eax
  8027bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8027cb:	40                   	inc    %eax
  8027cc:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8027d1:	ff 45 f4             	incl   -0xc(%ebp)
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027da:	0f 82 56 ff ff ff    	jb     802736 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8027e0:	90                   	nop
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    

008027e3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
  8027e6:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8027e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ec:	8b 00                	mov    (%eax),%eax
  8027ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8027f1:	eb 18                	jmp    80280b <find_block+0x28>

		if(tmp->sva == va){
  8027f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027f6:	8b 40 08             	mov    0x8(%eax),%eax
  8027f9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027fc:	75 05                	jne    802803 <find_block+0x20>
			return tmp ;
  8027fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802801:	eb 11                	jmp    802814 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802803:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80280b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80280f:	75 e2                	jne    8027f3 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802811:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802814:	c9                   	leave  
  802815:	c3                   	ret    

00802816 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802816:	55                   	push   %ebp
  802817:	89 e5                	mov    %esp,%ebp
  802819:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80281c:	a1 40 50 80 00       	mov    0x805040,%eax
  802821:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802824:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802829:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  80282c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802830:	75 65                	jne    802897 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802832:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802836:	75 14                	jne    80284c <insert_sorted_allocList+0x36>
  802838:	83 ec 04             	sub    $0x4,%esp
  80283b:	68 34 42 80 00       	push   $0x804234
  802840:	6a 62                	push   $0x62
  802842:	68 57 42 80 00       	push   $0x804257
  802847:	e8 c0 e0 ff ff       	call   80090c <_panic>
  80284c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802852:	8b 45 08             	mov    0x8(%ebp),%eax
  802855:	89 10                	mov    %edx,(%eax)
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	85 c0                	test   %eax,%eax
  80285e:	74 0d                	je     80286d <insert_sorted_allocList+0x57>
  802860:	a1 40 50 80 00       	mov    0x805040,%eax
  802865:	8b 55 08             	mov    0x8(%ebp),%edx
  802868:	89 50 04             	mov    %edx,0x4(%eax)
  80286b:	eb 08                	jmp    802875 <insert_sorted_allocList+0x5f>
  80286d:	8b 45 08             	mov    0x8(%ebp),%eax
  802870:	a3 44 50 80 00       	mov    %eax,0x805044
  802875:	8b 45 08             	mov    0x8(%ebp),%eax
  802878:	a3 40 50 80 00       	mov    %eax,0x805040
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802887:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80288c:	40                   	inc    %eax
  80288d:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802892:	e9 14 01 00 00       	jmp    8029ab <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802897:	8b 45 08             	mov    0x8(%ebp),%eax
  80289a:	8b 50 08             	mov    0x8(%eax),%edx
  80289d:	a1 44 50 80 00       	mov    0x805044,%eax
  8028a2:	8b 40 08             	mov    0x8(%eax),%eax
  8028a5:	39 c2                	cmp    %eax,%edx
  8028a7:	76 65                	jbe    80290e <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8028a9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ad:	75 14                	jne    8028c3 <insert_sorted_allocList+0xad>
  8028af:	83 ec 04             	sub    $0x4,%esp
  8028b2:	68 70 42 80 00       	push   $0x804270
  8028b7:	6a 64                	push   $0x64
  8028b9:	68 57 42 80 00       	push   $0x804257
  8028be:	e8 49 e0 ff ff       	call   80090c <_panic>
  8028c3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	89 50 04             	mov    %edx,0x4(%eax)
  8028cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d2:	8b 40 04             	mov    0x4(%eax),%eax
  8028d5:	85 c0                	test   %eax,%eax
  8028d7:	74 0c                	je     8028e5 <insert_sorted_allocList+0xcf>
  8028d9:	a1 44 50 80 00       	mov    0x805044,%eax
  8028de:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e1:	89 10                	mov    %edx,(%eax)
  8028e3:	eb 08                	jmp    8028ed <insert_sorted_allocList+0xd7>
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	a3 40 50 80 00       	mov    %eax,0x805040
  8028ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f0:	a3 44 50 80 00       	mov    %eax,0x805044
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028fe:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802903:	40                   	inc    %eax
  802904:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802909:	e9 9d 00 00 00       	jmp    8029ab <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80290e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802915:	e9 85 00 00 00       	jmp    80299f <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80291a:	8b 45 08             	mov    0x8(%ebp),%eax
  80291d:	8b 50 08             	mov    0x8(%eax),%edx
  802920:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802923:	8b 40 08             	mov    0x8(%eax),%eax
  802926:	39 c2                	cmp    %eax,%edx
  802928:	73 6a                	jae    802994 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  80292a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80292e:	74 06                	je     802936 <insert_sorted_allocList+0x120>
  802930:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802934:	75 14                	jne    80294a <insert_sorted_allocList+0x134>
  802936:	83 ec 04             	sub    $0x4,%esp
  802939:	68 94 42 80 00       	push   $0x804294
  80293e:	6a 6b                	push   $0x6b
  802940:	68 57 42 80 00       	push   $0x804257
  802945:	e8 c2 df ff ff       	call   80090c <_panic>
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	8b 50 04             	mov    0x4(%eax),%edx
  802950:	8b 45 08             	mov    0x8(%ebp),%eax
  802953:	89 50 04             	mov    %edx,0x4(%eax)
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295c:	89 10                	mov    %edx,(%eax)
  80295e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802961:	8b 40 04             	mov    0x4(%eax),%eax
  802964:	85 c0                	test   %eax,%eax
  802966:	74 0d                	je     802975 <insert_sorted_allocList+0x15f>
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	8b 40 04             	mov    0x4(%eax),%eax
  80296e:	8b 55 08             	mov    0x8(%ebp),%edx
  802971:	89 10                	mov    %edx,(%eax)
  802973:	eb 08                	jmp    80297d <insert_sorted_allocList+0x167>
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	a3 40 50 80 00       	mov    %eax,0x805040
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 55 08             	mov    0x8(%ebp),%edx
  802983:	89 50 04             	mov    %edx,0x4(%eax)
  802986:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80298b:	40                   	inc    %eax
  80298c:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802991:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802992:	eb 17                	jmp    8029ab <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80299c:	ff 45 f0             	incl   -0x10(%ebp)
  80299f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029a5:	0f 8c 6f ff ff ff    	jl     80291a <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8029ab:	90                   	nop
  8029ac:	c9                   	leave  
  8029ad:	c3                   	ret    

008029ae <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8029ae:	55                   	push   %ebp
  8029af:	89 e5                	mov    %esp,%ebp
  8029b1:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  8029b4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8029bc:	e9 7c 01 00 00       	jmp    802b3d <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ca:	0f 86 cf 00 00 00    	jbe    802a9f <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8029d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8029d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8029d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029db:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8029de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e4:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8029e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ea:	8b 50 08             	mov    0x8(%eax),%edx
  8029ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f0:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f9:	2b 45 08             	sub    0x8(%ebp),%eax
  8029fc:	89 c2                	mov    %eax,%edx
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 50 08             	mov    0x8(%eax),%edx
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	01 c2                	add    %eax,%edx
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802a15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a19:	75 17                	jne    802a32 <alloc_block_FF+0x84>
  802a1b:	83 ec 04             	sub    $0x4,%esp
  802a1e:	68 c9 42 80 00       	push   $0x8042c9
  802a23:	68 83 00 00 00       	push   $0x83
  802a28:	68 57 42 80 00       	push   $0x804257
  802a2d:	e8 da de ff ff       	call   80090c <_panic>
  802a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a35:	8b 00                	mov    (%eax),%eax
  802a37:	85 c0                	test   %eax,%eax
  802a39:	74 10                	je     802a4b <alloc_block_FF+0x9d>
  802a3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3e:	8b 00                	mov    (%eax),%eax
  802a40:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a43:	8b 52 04             	mov    0x4(%edx),%edx
  802a46:	89 50 04             	mov    %edx,0x4(%eax)
  802a49:	eb 0b                	jmp    802a56 <alloc_block_FF+0xa8>
  802a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4e:	8b 40 04             	mov    0x4(%eax),%eax
  802a51:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a59:	8b 40 04             	mov    0x4(%eax),%eax
  802a5c:	85 c0                	test   %eax,%eax
  802a5e:	74 0f                	je     802a6f <alloc_block_FF+0xc1>
  802a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a63:	8b 40 04             	mov    0x4(%eax),%eax
  802a66:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a69:	8b 12                	mov    (%edx),%edx
  802a6b:	89 10                	mov    %edx,(%eax)
  802a6d:	eb 0a                	jmp    802a79 <alloc_block_FF+0xcb>
  802a6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a72:	8b 00                	mov    (%eax),%eax
  802a74:	a3 48 51 80 00       	mov    %eax,0x805148
  802a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8c:	a1 54 51 80 00       	mov    0x805154,%eax
  802a91:	48                   	dec    %eax
  802a92:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9a:	e9 ad 00 00 00       	jmp    802b4c <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802aa5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802aa8:	0f 85 87 00 00 00    	jne    802b35 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802aae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab2:	75 17                	jne    802acb <alloc_block_FF+0x11d>
  802ab4:	83 ec 04             	sub    $0x4,%esp
  802ab7:	68 c9 42 80 00       	push   $0x8042c9
  802abc:	68 87 00 00 00       	push   $0x87
  802ac1:	68 57 42 80 00       	push   $0x804257
  802ac6:	e8 41 de ff ff       	call   80090c <_panic>
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 00                	mov    (%eax),%eax
  802ad0:	85 c0                	test   %eax,%eax
  802ad2:	74 10                	je     802ae4 <alloc_block_FF+0x136>
  802ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad7:	8b 00                	mov    (%eax),%eax
  802ad9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adc:	8b 52 04             	mov    0x4(%edx),%edx
  802adf:	89 50 04             	mov    %edx,0x4(%eax)
  802ae2:	eb 0b                	jmp    802aef <alloc_block_FF+0x141>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 40 04             	mov    0x4(%eax),%eax
  802aea:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 40 04             	mov    0x4(%eax),%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	74 0f                	je     802b08 <alloc_block_FF+0x15a>
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	8b 40 04             	mov    0x4(%eax),%eax
  802aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b02:	8b 12                	mov    (%edx),%edx
  802b04:	89 10                	mov    %edx,(%eax)
  802b06:	eb 0a                	jmp    802b12 <alloc_block_FF+0x164>
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 00                	mov    (%eax),%eax
  802b0d:	a3 38 51 80 00       	mov    %eax,0x805138
  802b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b25:	a1 44 51 80 00       	mov    0x805144,%eax
  802b2a:	48                   	dec    %eax
  802b2b:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	eb 17                	jmp    802b4c <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802b3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b41:	0f 85 7a fe ff ff    	jne    8029c1 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802b47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b4c:	c9                   	leave  
  802b4d:	c3                   	ret    

00802b4e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
  802b51:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802b54:	a1 38 51 80 00       	mov    0x805138,%eax
  802b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802b5c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802b63:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802b6a:	a1 38 51 80 00       	mov    0x805138,%eax
  802b6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b72:	e9 d0 00 00 00       	jmp    802c47 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b7d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b80:	0f 82 b8 00 00 00    	jb     802c3e <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b89:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8c:	2b 45 08             	sub    0x8(%ebp),%eax
  802b8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802b92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b95:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b98:	0f 83 a1 00 00 00    	jae    802c3f <alloc_block_BF+0xf1>
				differsize = differance ;
  802b9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ba1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802baa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bae:	0f 85 8b 00 00 00    	jne    802c3f <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802bb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb8:	75 17                	jne    802bd1 <alloc_block_BF+0x83>
  802bba:	83 ec 04             	sub    $0x4,%esp
  802bbd:	68 c9 42 80 00       	push   $0x8042c9
  802bc2:	68 a0 00 00 00       	push   $0xa0
  802bc7:	68 57 42 80 00       	push   $0x804257
  802bcc:	e8 3b dd ff ff       	call   80090c <_panic>
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 00                	mov    (%eax),%eax
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	74 10                	je     802bea <alloc_block_BF+0x9c>
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be2:	8b 52 04             	mov    0x4(%edx),%edx
  802be5:	89 50 04             	mov    %edx,0x4(%eax)
  802be8:	eb 0b                	jmp    802bf5 <alloc_block_BF+0xa7>
  802bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bed:	8b 40 04             	mov    0x4(%eax),%eax
  802bf0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	74 0f                	je     802c0e <alloc_block_BF+0xc0>
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 40 04             	mov    0x4(%eax),%eax
  802c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c08:	8b 12                	mov    (%edx),%edx
  802c0a:	89 10                	mov    %edx,(%eax)
  802c0c:	eb 0a                	jmp    802c18 <alloc_block_BF+0xca>
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 00                	mov    (%eax),%eax
  802c13:	a3 38 51 80 00       	mov    %eax,0x805138
  802c18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c2b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c30:	48                   	dec    %eax
  802c31:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	e9 0c 01 00 00       	jmp    802d4a <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802c3e:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802c3f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c4b:	74 07                	je     802c54 <alloc_block_BF+0x106>
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	eb 05                	jmp    802c59 <alloc_block_BF+0x10b>
  802c54:	b8 00 00 00 00       	mov    $0x0,%eax
  802c59:	a3 40 51 80 00       	mov    %eax,0x805140
  802c5e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	0f 85 0c ff ff ff    	jne    802b77 <alloc_block_BF+0x29>
  802c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6f:	0f 85 02 ff ff ff    	jne    802b77 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802c75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c79:	0f 84 c6 00 00 00    	je     802d45 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802c7f:	a1 48 51 80 00       	mov    0x805148,%eax
  802c84:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802c87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c93:	8b 50 08             	mov    0x8(%eax),%edx
  802c96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c99:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802c9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca2:	2b 45 08             	sub    0x8(%ebp),%eax
  802ca5:	89 c2                	mov    %eax,%edx
  802ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802caa:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb0:	8b 50 08             	mov    0x8(%eax),%edx
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	01 c2                	add    %eax,%edx
  802cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbb:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802cbe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cc2:	75 17                	jne    802cdb <alloc_block_BF+0x18d>
  802cc4:	83 ec 04             	sub    $0x4,%esp
  802cc7:	68 c9 42 80 00       	push   $0x8042c9
  802ccc:	68 af 00 00 00       	push   $0xaf
  802cd1:	68 57 42 80 00       	push   $0x804257
  802cd6:	e8 31 dc ff ff       	call   80090c <_panic>
  802cdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 10                	je     802cf4 <alloc_block_BF+0x1a6>
  802ce4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce7:	8b 00                	mov    (%eax),%eax
  802ce9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cec:	8b 52 04             	mov    0x4(%edx),%edx
  802cef:	89 50 04             	mov    %edx,0x4(%eax)
  802cf2:	eb 0b                	jmp    802cff <alloc_block_BF+0x1b1>
  802cf4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf7:	8b 40 04             	mov    0x4(%eax),%eax
  802cfa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d02:	8b 40 04             	mov    0x4(%eax),%eax
  802d05:	85 c0                	test   %eax,%eax
  802d07:	74 0f                	je     802d18 <alloc_block_BF+0x1ca>
  802d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0c:	8b 40 04             	mov    0x4(%eax),%eax
  802d0f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d12:	8b 12                	mov    (%edx),%edx
  802d14:	89 10                	mov    %edx,(%eax)
  802d16:	eb 0a                	jmp    802d22 <alloc_block_BF+0x1d4>
  802d18:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d1b:	8b 00                	mov    (%eax),%eax
  802d1d:	a3 48 51 80 00       	mov    %eax,0x805148
  802d22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d25:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d35:	a1 54 51 80 00       	mov    0x805154,%eax
  802d3a:	48                   	dec    %eax
  802d3b:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802d40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d43:	eb 05                	jmp    802d4a <alloc_block_BF+0x1fc>
	}

	return NULL;
  802d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d4a:	c9                   	leave  
  802d4b:	c3                   	ret    

00802d4c <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802d4c:	55                   	push   %ebp
  802d4d:	89 e5                	mov    %esp,%ebp
  802d4f:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802d52:	a1 38 51 80 00       	mov    0x805138,%eax
  802d57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802d5a:	e9 7c 01 00 00       	jmp    802edb <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 40 0c             	mov    0xc(%eax),%eax
  802d65:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d68:	0f 86 cf 00 00 00    	jbe    802e3d <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802d6e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d79:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802d7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d82:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d88:	8b 50 08             	mov    0x8(%eax),%edx
  802d8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d8e:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 0c             	mov    0xc(%eax),%eax
  802d97:	2b 45 08             	sub    0x8(%ebp),%eax
  802d9a:	89 c2                	mov    %eax,%edx
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 50 08             	mov    0x8(%eax),%edx
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	01 c2                	add    %eax,%edx
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802db3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802db7:	75 17                	jne    802dd0 <alloc_block_NF+0x84>
  802db9:	83 ec 04             	sub    $0x4,%esp
  802dbc:	68 c9 42 80 00       	push   $0x8042c9
  802dc1:	68 c4 00 00 00       	push   $0xc4
  802dc6:	68 57 42 80 00       	push   $0x804257
  802dcb:	e8 3c db ff ff       	call   80090c <_panic>
  802dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd3:	8b 00                	mov    (%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 10                	je     802de9 <alloc_block_NF+0x9d>
  802dd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ddc:	8b 00                	mov    (%eax),%eax
  802dde:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de1:	8b 52 04             	mov    0x4(%edx),%edx
  802de4:	89 50 04             	mov    %edx,0x4(%eax)
  802de7:	eb 0b                	jmp    802df4 <alloc_block_NF+0xa8>
  802de9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dec:	8b 40 04             	mov    0x4(%eax),%eax
  802def:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	74 0f                	je     802e0d <alloc_block_NF+0xc1>
  802dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e01:	8b 40 04             	mov    0x4(%eax),%eax
  802e04:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e07:	8b 12                	mov    (%edx),%edx
  802e09:	89 10                	mov    %edx,(%eax)
  802e0b:	eb 0a                	jmp    802e17 <alloc_block_NF+0xcb>
  802e0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	a3 48 51 80 00       	mov    %eax,0x805148
  802e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e20:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e2f:	48                   	dec    %eax
  802e30:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802e35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e38:	e9 ad 00 00 00       	jmp    802eea <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e40:	8b 40 0c             	mov    0xc(%eax),%eax
  802e43:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e46:	0f 85 87 00 00 00    	jne    802ed3 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e50:	75 17                	jne    802e69 <alloc_block_NF+0x11d>
  802e52:	83 ec 04             	sub    $0x4,%esp
  802e55:	68 c9 42 80 00       	push   $0x8042c9
  802e5a:	68 c8 00 00 00       	push   $0xc8
  802e5f:	68 57 42 80 00       	push   $0x804257
  802e64:	e8 a3 da ff ff       	call   80090c <_panic>
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 00                	mov    (%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	74 10                	je     802e82 <alloc_block_NF+0x136>
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7a:	8b 52 04             	mov    0x4(%edx),%edx
  802e7d:	89 50 04             	mov    %edx,0x4(%eax)
  802e80:	eb 0b                	jmp    802e8d <alloc_block_NF+0x141>
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 40 04             	mov    0x4(%eax),%eax
  802e88:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 40 04             	mov    0x4(%eax),%eax
  802e93:	85 c0                	test   %eax,%eax
  802e95:	74 0f                	je     802ea6 <alloc_block_NF+0x15a>
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 40 04             	mov    0x4(%eax),%eax
  802e9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea0:	8b 12                	mov    (%edx),%edx
  802ea2:	89 10                	mov    %edx,(%eax)
  802ea4:	eb 0a                	jmp    802eb0 <alloc_block_NF+0x164>
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 00                	mov    (%eax),%eax
  802eab:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ec8:	48                   	dec    %eax
  802ec9:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	eb 17                	jmp    802eea <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 00                	mov    (%eax),%eax
  802ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802edf:	0f 85 7a fe ff ff    	jne    802d5f <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802ee5:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802eea:	c9                   	leave  
  802eeb:	c3                   	ret    

00802eec <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802eec:	55                   	push   %ebp
  802eed:	89 e5                	mov    %esp,%ebp
  802eef:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802ef2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef7:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802efa:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802f02:	a1 44 51 80 00       	mov    0x805144,%eax
  802f07:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802f0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f0e:	75 68                	jne    802f78 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802f10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f14:	75 17                	jne    802f2d <insert_sorted_with_merge_freeList+0x41>
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	68 34 42 80 00       	push   $0x804234
  802f1e:	68 da 00 00 00       	push   $0xda
  802f23:	68 57 42 80 00       	push   $0x804257
  802f28:	e8 df d9 ff ff       	call   80090c <_panic>
  802f2d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	74 0d                	je     802f4e <insert_sorted_with_merge_freeList+0x62>
  802f41:	a1 38 51 80 00       	mov    0x805138,%eax
  802f46:	8b 55 08             	mov    0x8(%ebp),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	eb 08                	jmp    802f56 <insert_sorted_with_merge_freeList+0x6a>
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	a3 38 51 80 00       	mov    %eax,0x805138
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f68:	a1 44 51 80 00       	mov    0x805144,%eax
  802f6d:	40                   	inc    %eax
  802f6e:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802f73:	e9 49 07 00 00       	jmp    8036c1 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7b:	8b 50 08             	mov    0x8(%eax),%edx
  802f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f81:	8b 40 0c             	mov    0xc(%eax),%eax
  802f84:	01 c2                	add    %eax,%edx
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	8b 40 08             	mov    0x8(%eax),%eax
  802f8c:	39 c2                	cmp    %eax,%edx
  802f8e:	73 77                	jae    803007 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f93:	8b 00                	mov    (%eax),%eax
  802f95:	85 c0                	test   %eax,%eax
  802f97:	75 6e                	jne    803007 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802f99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f9d:	74 68                	je     803007 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802f9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa3:	75 17                	jne    802fbc <insert_sorted_with_merge_freeList+0xd0>
  802fa5:	83 ec 04             	sub    $0x4,%esp
  802fa8:	68 70 42 80 00       	push   $0x804270
  802fad:	68 e0 00 00 00       	push   $0xe0
  802fb2:	68 57 42 80 00       	push   $0x804257
  802fb7:	e8 50 d9 ff ff       	call   80090c <_panic>
  802fbc:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	89 50 04             	mov    %edx,0x4(%eax)
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	8b 40 04             	mov    0x4(%eax),%eax
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	74 0c                	je     802fde <insert_sorted_with_merge_freeList+0xf2>
  802fd2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fd7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fda:	89 10                	mov    %edx,(%eax)
  802fdc:	eb 08                	jmp    802fe6 <insert_sorted_with_merge_freeList+0xfa>
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	a3 38 51 80 00       	mov    %eax,0x805138
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff7:	a1 44 51 80 00       	mov    0x805144,%eax
  802ffc:	40                   	inc    %eax
  802ffd:	a3 44 51 80 00       	mov    %eax,0x805144
  803002:	e9 ba 06 00 00       	jmp    8036c1 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803007:	8b 45 08             	mov    0x8(%ebp),%eax
  80300a:	8b 50 0c             	mov    0xc(%eax),%edx
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	8b 40 08             	mov    0x8(%eax),%eax
  803013:	01 c2                	add    %eax,%edx
  803015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803018:	8b 40 08             	mov    0x8(%eax),%eax
  80301b:	39 c2                	cmp    %eax,%edx
  80301d:	73 78                	jae    803097 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	8b 40 04             	mov    0x4(%eax),%eax
  803025:	85 c0                	test   %eax,%eax
  803027:	75 6e                	jne    803097 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803029:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80302d:	74 68                	je     803097 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80302f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803033:	75 17                	jne    80304c <insert_sorted_with_merge_freeList+0x160>
  803035:	83 ec 04             	sub    $0x4,%esp
  803038:	68 34 42 80 00       	push   $0x804234
  80303d:	68 e6 00 00 00       	push   $0xe6
  803042:	68 57 42 80 00       	push   $0x804257
  803047:	e8 c0 d8 ff ff       	call   80090c <_panic>
  80304c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	89 10                	mov    %edx,(%eax)
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	8b 00                	mov    (%eax),%eax
  80305c:	85 c0                	test   %eax,%eax
  80305e:	74 0d                	je     80306d <insert_sorted_with_merge_freeList+0x181>
  803060:	a1 38 51 80 00       	mov    0x805138,%eax
  803065:	8b 55 08             	mov    0x8(%ebp),%edx
  803068:	89 50 04             	mov    %edx,0x4(%eax)
  80306b:	eb 08                	jmp    803075 <insert_sorted_with_merge_freeList+0x189>
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	a3 38 51 80 00       	mov    %eax,0x805138
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803087:	a1 44 51 80 00       	mov    0x805144,%eax
  80308c:	40                   	inc    %eax
  80308d:	a3 44 51 80 00       	mov    %eax,0x805144
  803092:	e9 2a 06 00 00       	jmp    8036c1 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803097:	a1 38 51 80 00       	mov    0x805138,%eax
  80309c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80309f:	e9 ed 05 00 00       	jmp    803691 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  8030ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030b0:	0f 84 a7 00 00 00    	je     80315d <insert_sorted_with_merge_freeList+0x271>
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	8b 50 0c             	mov    0xc(%eax),%edx
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 40 08             	mov    0x8(%eax),%eax
  8030c2:	01 c2                	add    %eax,%edx
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ca:	39 c2                	cmp    %eax,%edx
  8030cc:	0f 83 8b 00 00 00    	jae    80315d <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  8030d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d5:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030db:	8b 40 08             	mov    0x8(%eax),%eax
  8030de:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  8030e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e3:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  8030e6:	39 c2                	cmp    %eax,%edx
  8030e8:	73 73                	jae    80315d <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  8030ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ee:	74 06                	je     8030f6 <insert_sorted_with_merge_freeList+0x20a>
  8030f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030f4:	75 17                	jne    80310d <insert_sorted_with_merge_freeList+0x221>
  8030f6:	83 ec 04             	sub    $0x4,%esp
  8030f9:	68 e8 42 80 00       	push   $0x8042e8
  8030fe:	68 f0 00 00 00       	push   $0xf0
  803103:	68 57 42 80 00       	push   $0x804257
  803108:	e8 ff d7 ff ff       	call   80090c <_panic>
  80310d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803110:	8b 10                	mov    (%eax),%edx
  803112:	8b 45 08             	mov    0x8(%ebp),%eax
  803115:	89 10                	mov    %edx,(%eax)
  803117:	8b 45 08             	mov    0x8(%ebp),%eax
  80311a:	8b 00                	mov    (%eax),%eax
  80311c:	85 c0                	test   %eax,%eax
  80311e:	74 0b                	je     80312b <insert_sorted_with_merge_freeList+0x23f>
  803120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803123:	8b 00                	mov    (%eax),%eax
  803125:	8b 55 08             	mov    0x8(%ebp),%edx
  803128:	89 50 04             	mov    %edx,0x4(%eax)
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	8b 55 08             	mov    0x8(%ebp),%edx
  803131:	89 10                	mov    %edx,(%eax)
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803139:	89 50 04             	mov    %edx,0x4(%eax)
  80313c:	8b 45 08             	mov    0x8(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	75 08                	jne    80314d <insert_sorted_with_merge_freeList+0x261>
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80314d:	a1 44 51 80 00       	mov    0x805144,%eax
  803152:	40                   	inc    %eax
  803153:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  803158:	e9 64 05 00 00       	jmp    8036c1 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  80315d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803162:	8b 50 0c             	mov    0xc(%eax),%edx
  803165:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80316a:	8b 40 08             	mov    0x8(%eax),%eax
  80316d:	01 c2                	add    %eax,%edx
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	8b 40 08             	mov    0x8(%eax),%eax
  803175:	39 c2                	cmp    %eax,%edx
  803177:	0f 85 b1 00 00 00    	jne    80322e <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  80317d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803182:	85 c0                	test   %eax,%eax
  803184:	0f 84 a4 00 00 00    	je     80322e <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  80318a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80318f:	8b 00                	mov    (%eax),%eax
  803191:	85 c0                	test   %eax,%eax
  803193:	0f 85 95 00 00 00    	jne    80322e <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803199:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80319e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031a4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8031a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8031aa:	8b 52 0c             	mov    0xc(%edx),%edx
  8031ad:	01 ca                	add    %ecx,%edx
  8031af:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  8031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  8031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8031c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ca:	75 17                	jne    8031e3 <insert_sorted_with_merge_freeList+0x2f7>
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	68 34 42 80 00       	push   $0x804234
  8031d4:	68 ff 00 00 00       	push   $0xff
  8031d9:	68 57 42 80 00       	push   $0x804257
  8031de:	e8 29 d7 ff ff       	call   80090c <_panic>
  8031e3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	89 10                	mov    %edx,(%eax)
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	8b 00                	mov    (%eax),%eax
  8031f3:	85 c0                	test   %eax,%eax
  8031f5:	74 0d                	je     803204 <insert_sorted_with_merge_freeList+0x318>
  8031f7:	a1 48 51 80 00       	mov    0x805148,%eax
  8031fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ff:	89 50 04             	mov    %edx,0x4(%eax)
  803202:	eb 08                	jmp    80320c <insert_sorted_with_merge_freeList+0x320>
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	a3 48 51 80 00       	mov    %eax,0x805148
  803214:	8b 45 08             	mov    0x8(%ebp),%eax
  803217:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321e:	a1 54 51 80 00       	mov    0x805154,%eax
  803223:	40                   	inc    %eax
  803224:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803229:	e9 93 04 00 00       	jmp    8036c1 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  80322e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803231:	8b 50 08             	mov    0x8(%eax),%edx
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	8b 40 0c             	mov    0xc(%eax),%eax
  80323a:	01 c2                	add    %eax,%edx
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	8b 40 08             	mov    0x8(%eax),%eax
  803242:	39 c2                	cmp    %eax,%edx
  803244:	0f 85 ae 00 00 00    	jne    8032f8 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  80324a:	8b 45 08             	mov    0x8(%ebp),%eax
  80324d:	8b 50 0c             	mov    0xc(%eax),%edx
  803250:	8b 45 08             	mov    0x8(%ebp),%eax
  803253:	8b 40 08             	mov    0x8(%eax),%eax
  803256:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325b:	8b 00                	mov    (%eax),%eax
  80325d:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803260:	39 c2                	cmp    %eax,%edx
  803262:	0f 84 90 00 00 00    	je     8032f8 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326b:	8b 50 0c             	mov    0xc(%eax),%edx
  80326e:	8b 45 08             	mov    0x8(%ebp),%eax
  803271:	8b 40 0c             	mov    0xc(%eax),%eax
  803274:	01 c2                	add    %eax,%edx
  803276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803279:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80327c:	8b 45 08             	mov    0x8(%ebp),%eax
  80327f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803290:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803294:	75 17                	jne    8032ad <insert_sorted_with_merge_freeList+0x3c1>
  803296:	83 ec 04             	sub    $0x4,%esp
  803299:	68 34 42 80 00       	push   $0x804234
  80329e:	68 0b 01 00 00       	push   $0x10b
  8032a3:	68 57 42 80 00       	push   $0x804257
  8032a8:	e8 5f d6 ff ff       	call   80090c <_panic>
  8032ad:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	89 10                	mov    %edx,(%eax)
  8032b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bb:	8b 00                	mov    (%eax),%eax
  8032bd:	85 c0                	test   %eax,%eax
  8032bf:	74 0d                	je     8032ce <insert_sorted_with_merge_freeList+0x3e2>
  8032c1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c9:	89 50 04             	mov    %edx,0x4(%eax)
  8032cc:	eb 08                	jmp    8032d6 <insert_sorted_with_merge_freeList+0x3ea>
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032de:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e8:	a1 54 51 80 00       	mov    0x805154,%eax
  8032ed:	40                   	inc    %eax
  8032ee:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8032f3:	e9 c9 03 00 00       	jmp    8036c1 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	8b 40 08             	mov    0x8(%eax),%eax
  803304:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  80330c:	39 c2                	cmp    %eax,%edx
  80330e:	0f 85 bb 00 00 00    	jne    8033cf <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  803314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803318:	0f 84 b1 00 00 00    	je     8033cf <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  80331e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803321:	8b 40 04             	mov    0x4(%eax),%eax
  803324:	85 c0                	test   %eax,%eax
  803326:	0f 85 a3 00 00 00    	jne    8033cf <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80332c:	a1 38 51 80 00       	mov    0x805138,%eax
  803331:	8b 55 08             	mov    0x8(%ebp),%edx
  803334:	8b 52 08             	mov    0x8(%edx),%edx
  803337:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  80333a:	a1 38 51 80 00       	mov    0x805138,%eax
  80333f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803345:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803348:	8b 55 08             	mov    0x8(%ebp),%edx
  80334b:	8b 52 0c             	mov    0xc(%edx),%edx
  80334e:	01 ca                	add    %ecx,%edx
  803350:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80335d:	8b 45 08             	mov    0x8(%ebp),%eax
  803360:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803367:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336b:	75 17                	jne    803384 <insert_sorted_with_merge_freeList+0x498>
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	68 34 42 80 00       	push   $0x804234
  803375:	68 17 01 00 00       	push   $0x117
  80337a:	68 57 42 80 00       	push   $0x804257
  80337f:	e8 88 d5 ff ff       	call   80090c <_panic>
  803384:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	89 10                	mov    %edx,(%eax)
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	85 c0                	test   %eax,%eax
  803396:	74 0d                	je     8033a5 <insert_sorted_with_merge_freeList+0x4b9>
  803398:	a1 48 51 80 00       	mov    0x805148,%eax
  80339d:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a0:	89 50 04             	mov    %edx,0x4(%eax)
  8033a3:	eb 08                	jmp    8033ad <insert_sorted_with_merge_freeList+0x4c1>
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	a3 48 51 80 00       	mov    %eax,0x805148
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033bf:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c4:	40                   	inc    %eax
  8033c5:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8033ca:	e9 f2 02 00 00       	jmp    8036c1 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 50 08             	mov    0x8(%eax),%edx
  8033d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033db:	01 c2                	add    %eax,%edx
  8033dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033e0:	8b 40 08             	mov    0x8(%eax),%eax
  8033e3:	39 c2                	cmp    %eax,%edx
  8033e5:	0f 85 be 00 00 00    	jne    8034a9 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  8033eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ee:	8b 40 04             	mov    0x4(%eax),%eax
  8033f1:	8b 50 08             	mov    0x8(%eax),%edx
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	8b 40 04             	mov    0x4(%eax),%eax
  8033fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8033fd:	01 c2                	add    %eax,%edx
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	8b 40 08             	mov    0x8(%eax),%eax
  803405:	39 c2                	cmp    %eax,%edx
  803407:	0f 84 9c 00 00 00    	je     8034a9 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	8b 50 08             	mov    0x8(%eax),%edx
  803413:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803416:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80341c:	8b 50 0c             	mov    0xc(%eax),%edx
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	8b 40 0c             	mov    0xc(%eax),%eax
  803425:	01 c2                	add    %eax,%edx
  803427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803437:	8b 45 08             	mov    0x8(%ebp),%eax
  80343a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803441:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803445:	75 17                	jne    80345e <insert_sorted_with_merge_freeList+0x572>
  803447:	83 ec 04             	sub    $0x4,%esp
  80344a:	68 34 42 80 00       	push   $0x804234
  80344f:	68 26 01 00 00       	push   $0x126
  803454:	68 57 42 80 00       	push   $0x804257
  803459:	e8 ae d4 ff ff       	call   80090c <_panic>
  80345e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803464:	8b 45 08             	mov    0x8(%ebp),%eax
  803467:	89 10                	mov    %edx,(%eax)
  803469:	8b 45 08             	mov    0x8(%ebp),%eax
  80346c:	8b 00                	mov    (%eax),%eax
  80346e:	85 c0                	test   %eax,%eax
  803470:	74 0d                	je     80347f <insert_sorted_with_merge_freeList+0x593>
  803472:	a1 48 51 80 00       	mov    0x805148,%eax
  803477:	8b 55 08             	mov    0x8(%ebp),%edx
  80347a:	89 50 04             	mov    %edx,0x4(%eax)
  80347d:	eb 08                	jmp    803487 <insert_sorted_with_merge_freeList+0x59b>
  80347f:	8b 45 08             	mov    0x8(%ebp),%eax
  803482:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803487:	8b 45 08             	mov    0x8(%ebp),%eax
  80348a:	a3 48 51 80 00       	mov    %eax,0x805148
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803499:	a1 54 51 80 00       	mov    0x805154,%eax
  80349e:	40                   	inc    %eax
  80349f:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  8034a4:	e9 18 02 00 00       	jmp    8036c1 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  8034a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ac:	8b 50 0c             	mov    0xc(%eax),%edx
  8034af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b2:	8b 40 08             	mov    0x8(%eax),%eax
  8034b5:	01 c2                	add    %eax,%edx
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	8b 40 08             	mov    0x8(%eax),%eax
  8034bd:	39 c2                	cmp    %eax,%edx
  8034bf:	0f 85 c4 01 00 00    	jne    803689 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  8034c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8034cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ce:	8b 40 08             	mov    0x8(%eax),%eax
  8034d1:	01 c2                	add    %eax,%edx
  8034d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d6:	8b 00                	mov    (%eax),%eax
  8034d8:	8b 40 08             	mov    0x8(%eax),%eax
  8034db:	39 c2                	cmp    %eax,%edx
  8034dd:	0f 85 a6 01 00 00    	jne    803689 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8034e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e7:	0f 84 9c 01 00 00    	je     803689 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  8034ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f0:	8b 50 0c             	mov    0xc(%eax),%edx
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8034f9:	01 c2                	add    %eax,%edx
  8034fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034fe:	8b 00                	mov    (%eax),%eax
  803500:	8b 40 0c             	mov    0xc(%eax),%eax
  803503:	01 c2                	add    %eax,%edx
  803505:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803508:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  80350b:	8b 45 08             	mov    0x8(%ebp),%eax
  80350e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803515:	8b 45 08             	mov    0x8(%ebp),%eax
  803518:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80351f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803523:	75 17                	jne    80353c <insert_sorted_with_merge_freeList+0x650>
  803525:	83 ec 04             	sub    $0x4,%esp
  803528:	68 34 42 80 00       	push   $0x804234
  80352d:	68 32 01 00 00       	push   $0x132
  803532:	68 57 42 80 00       	push   $0x804257
  803537:	e8 d0 d3 ff ff       	call   80090c <_panic>
  80353c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803542:	8b 45 08             	mov    0x8(%ebp),%eax
  803545:	89 10                	mov    %edx,(%eax)
  803547:	8b 45 08             	mov    0x8(%ebp),%eax
  80354a:	8b 00                	mov    (%eax),%eax
  80354c:	85 c0                	test   %eax,%eax
  80354e:	74 0d                	je     80355d <insert_sorted_with_merge_freeList+0x671>
  803550:	a1 48 51 80 00       	mov    0x805148,%eax
  803555:	8b 55 08             	mov    0x8(%ebp),%edx
  803558:	89 50 04             	mov    %edx,0x4(%eax)
  80355b:	eb 08                	jmp    803565 <insert_sorted_with_merge_freeList+0x679>
  80355d:	8b 45 08             	mov    0x8(%ebp),%eax
  803560:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803565:	8b 45 08             	mov    0x8(%ebp),%eax
  803568:	a3 48 51 80 00       	mov    %eax,0x805148
  80356d:	8b 45 08             	mov    0x8(%ebp),%eax
  803570:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803577:	a1 54 51 80 00       	mov    0x805154,%eax
  80357c:	40                   	inc    %eax
  80357d:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803585:	8b 00                	mov    (%eax),%eax
  803587:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80358e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803591:	8b 00                	mov    (%eax),%eax
  803593:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80359a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80359d:	8b 00                	mov    (%eax),%eax
  80359f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  8035a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035a6:	75 17                	jne    8035bf <insert_sorted_with_merge_freeList+0x6d3>
  8035a8:	83 ec 04             	sub    $0x4,%esp
  8035ab:	68 c9 42 80 00       	push   $0x8042c9
  8035b0:	68 36 01 00 00       	push   $0x136
  8035b5:	68 57 42 80 00       	push   $0x804257
  8035ba:	e8 4d d3 ff ff       	call   80090c <_panic>
  8035bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c2:	8b 00                	mov    (%eax),%eax
  8035c4:	85 c0                	test   %eax,%eax
  8035c6:	74 10                	je     8035d8 <insert_sorted_with_merge_freeList+0x6ec>
  8035c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035cb:	8b 00                	mov    (%eax),%eax
  8035cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035d0:	8b 52 04             	mov    0x4(%edx),%edx
  8035d3:	89 50 04             	mov    %edx,0x4(%eax)
  8035d6:	eb 0b                	jmp    8035e3 <insert_sorted_with_merge_freeList+0x6f7>
  8035d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035db:	8b 40 04             	mov    0x4(%eax),%eax
  8035de:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e6:	8b 40 04             	mov    0x4(%eax),%eax
  8035e9:	85 c0                	test   %eax,%eax
  8035eb:	74 0f                	je     8035fc <insert_sorted_with_merge_freeList+0x710>
  8035ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f0:	8b 40 04             	mov    0x4(%eax),%eax
  8035f3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f6:	8b 12                	mov    (%edx),%edx
  8035f8:	89 10                	mov    %edx,(%eax)
  8035fa:	eb 0a                	jmp    803606 <insert_sorted_with_merge_freeList+0x71a>
  8035fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035ff:	8b 00                	mov    (%eax),%eax
  803601:	a3 38 51 80 00       	mov    %eax,0x805138
  803606:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80360f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803612:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803619:	a1 44 51 80 00       	mov    0x805144,%eax
  80361e:	48                   	dec    %eax
  80361f:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803624:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803628:	75 17                	jne    803641 <insert_sorted_with_merge_freeList+0x755>
  80362a:	83 ec 04             	sub    $0x4,%esp
  80362d:	68 34 42 80 00       	push   $0x804234
  803632:	68 37 01 00 00       	push   $0x137
  803637:	68 57 42 80 00       	push   $0x804257
  80363c:	e8 cb d2 ff ff       	call   80090c <_panic>
  803641:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364a:	89 10                	mov    %edx,(%eax)
  80364c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364f:	8b 00                	mov    (%eax),%eax
  803651:	85 c0                	test   %eax,%eax
  803653:	74 0d                	je     803662 <insert_sorted_with_merge_freeList+0x776>
  803655:	a1 48 51 80 00       	mov    0x805148,%eax
  80365a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80365d:	89 50 04             	mov    %edx,0x4(%eax)
  803660:	eb 08                	jmp    80366a <insert_sorted_with_merge_freeList+0x77e>
  803662:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803665:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80366a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366d:	a3 48 51 80 00       	mov    %eax,0x805148
  803672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803675:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80367c:	a1 54 51 80 00       	mov    0x805154,%eax
  803681:	40                   	inc    %eax
  803682:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803687:	eb 38                	jmp    8036c1 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803689:	a1 40 51 80 00       	mov    0x805140,%eax
  80368e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803691:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803695:	74 07                	je     80369e <insert_sorted_with_merge_freeList+0x7b2>
  803697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369a:	8b 00                	mov    (%eax),%eax
  80369c:	eb 05                	jmp    8036a3 <insert_sorted_with_merge_freeList+0x7b7>
  80369e:	b8 00 00 00 00       	mov    $0x0,%eax
  8036a3:	a3 40 51 80 00       	mov    %eax,0x805140
  8036a8:	a1 40 51 80 00       	mov    0x805140,%eax
  8036ad:	85 c0                	test   %eax,%eax
  8036af:	0f 85 ef f9 ff ff    	jne    8030a4 <insert_sorted_with_merge_freeList+0x1b8>
  8036b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b9:	0f 85 e5 f9 ff ff    	jne    8030a4 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8036bf:	eb 00                	jmp    8036c1 <insert_sorted_with_merge_freeList+0x7d5>
  8036c1:	90                   	nop
  8036c2:	c9                   	leave  
  8036c3:	c3                   	ret    

008036c4 <__udivdi3>:
  8036c4:	55                   	push   %ebp
  8036c5:	57                   	push   %edi
  8036c6:	56                   	push   %esi
  8036c7:	53                   	push   %ebx
  8036c8:	83 ec 1c             	sub    $0x1c,%esp
  8036cb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036cf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036db:	89 ca                	mov    %ecx,%edx
  8036dd:	89 f8                	mov    %edi,%eax
  8036df:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036e3:	85 f6                	test   %esi,%esi
  8036e5:	75 2d                	jne    803714 <__udivdi3+0x50>
  8036e7:	39 cf                	cmp    %ecx,%edi
  8036e9:	77 65                	ja     803750 <__udivdi3+0x8c>
  8036eb:	89 fd                	mov    %edi,%ebp
  8036ed:	85 ff                	test   %edi,%edi
  8036ef:	75 0b                	jne    8036fc <__udivdi3+0x38>
  8036f1:	b8 01 00 00 00       	mov    $0x1,%eax
  8036f6:	31 d2                	xor    %edx,%edx
  8036f8:	f7 f7                	div    %edi
  8036fa:	89 c5                	mov    %eax,%ebp
  8036fc:	31 d2                	xor    %edx,%edx
  8036fe:	89 c8                	mov    %ecx,%eax
  803700:	f7 f5                	div    %ebp
  803702:	89 c1                	mov    %eax,%ecx
  803704:	89 d8                	mov    %ebx,%eax
  803706:	f7 f5                	div    %ebp
  803708:	89 cf                	mov    %ecx,%edi
  80370a:	89 fa                	mov    %edi,%edx
  80370c:	83 c4 1c             	add    $0x1c,%esp
  80370f:	5b                   	pop    %ebx
  803710:	5e                   	pop    %esi
  803711:	5f                   	pop    %edi
  803712:	5d                   	pop    %ebp
  803713:	c3                   	ret    
  803714:	39 ce                	cmp    %ecx,%esi
  803716:	77 28                	ja     803740 <__udivdi3+0x7c>
  803718:	0f bd fe             	bsr    %esi,%edi
  80371b:	83 f7 1f             	xor    $0x1f,%edi
  80371e:	75 40                	jne    803760 <__udivdi3+0x9c>
  803720:	39 ce                	cmp    %ecx,%esi
  803722:	72 0a                	jb     80372e <__udivdi3+0x6a>
  803724:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803728:	0f 87 9e 00 00 00    	ja     8037cc <__udivdi3+0x108>
  80372e:	b8 01 00 00 00       	mov    $0x1,%eax
  803733:	89 fa                	mov    %edi,%edx
  803735:	83 c4 1c             	add    $0x1c,%esp
  803738:	5b                   	pop    %ebx
  803739:	5e                   	pop    %esi
  80373a:	5f                   	pop    %edi
  80373b:	5d                   	pop    %ebp
  80373c:	c3                   	ret    
  80373d:	8d 76 00             	lea    0x0(%esi),%esi
  803740:	31 ff                	xor    %edi,%edi
  803742:	31 c0                	xor    %eax,%eax
  803744:	89 fa                	mov    %edi,%edx
  803746:	83 c4 1c             	add    $0x1c,%esp
  803749:	5b                   	pop    %ebx
  80374a:	5e                   	pop    %esi
  80374b:	5f                   	pop    %edi
  80374c:	5d                   	pop    %ebp
  80374d:	c3                   	ret    
  80374e:	66 90                	xchg   %ax,%ax
  803750:	89 d8                	mov    %ebx,%eax
  803752:	f7 f7                	div    %edi
  803754:	31 ff                	xor    %edi,%edi
  803756:	89 fa                	mov    %edi,%edx
  803758:	83 c4 1c             	add    $0x1c,%esp
  80375b:	5b                   	pop    %ebx
  80375c:	5e                   	pop    %esi
  80375d:	5f                   	pop    %edi
  80375e:	5d                   	pop    %ebp
  80375f:	c3                   	ret    
  803760:	bd 20 00 00 00       	mov    $0x20,%ebp
  803765:	89 eb                	mov    %ebp,%ebx
  803767:	29 fb                	sub    %edi,%ebx
  803769:	89 f9                	mov    %edi,%ecx
  80376b:	d3 e6                	shl    %cl,%esi
  80376d:	89 c5                	mov    %eax,%ebp
  80376f:	88 d9                	mov    %bl,%cl
  803771:	d3 ed                	shr    %cl,%ebp
  803773:	89 e9                	mov    %ebp,%ecx
  803775:	09 f1                	or     %esi,%ecx
  803777:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80377b:	89 f9                	mov    %edi,%ecx
  80377d:	d3 e0                	shl    %cl,%eax
  80377f:	89 c5                	mov    %eax,%ebp
  803781:	89 d6                	mov    %edx,%esi
  803783:	88 d9                	mov    %bl,%cl
  803785:	d3 ee                	shr    %cl,%esi
  803787:	89 f9                	mov    %edi,%ecx
  803789:	d3 e2                	shl    %cl,%edx
  80378b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80378f:	88 d9                	mov    %bl,%cl
  803791:	d3 e8                	shr    %cl,%eax
  803793:	09 c2                	or     %eax,%edx
  803795:	89 d0                	mov    %edx,%eax
  803797:	89 f2                	mov    %esi,%edx
  803799:	f7 74 24 0c          	divl   0xc(%esp)
  80379d:	89 d6                	mov    %edx,%esi
  80379f:	89 c3                	mov    %eax,%ebx
  8037a1:	f7 e5                	mul    %ebp
  8037a3:	39 d6                	cmp    %edx,%esi
  8037a5:	72 19                	jb     8037c0 <__udivdi3+0xfc>
  8037a7:	74 0b                	je     8037b4 <__udivdi3+0xf0>
  8037a9:	89 d8                	mov    %ebx,%eax
  8037ab:	31 ff                	xor    %edi,%edi
  8037ad:	e9 58 ff ff ff       	jmp    80370a <__udivdi3+0x46>
  8037b2:	66 90                	xchg   %ax,%ax
  8037b4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037b8:	89 f9                	mov    %edi,%ecx
  8037ba:	d3 e2                	shl    %cl,%edx
  8037bc:	39 c2                	cmp    %eax,%edx
  8037be:	73 e9                	jae    8037a9 <__udivdi3+0xe5>
  8037c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037c3:	31 ff                	xor    %edi,%edi
  8037c5:	e9 40 ff ff ff       	jmp    80370a <__udivdi3+0x46>
  8037ca:	66 90                	xchg   %ax,%ax
  8037cc:	31 c0                	xor    %eax,%eax
  8037ce:	e9 37 ff ff ff       	jmp    80370a <__udivdi3+0x46>
  8037d3:	90                   	nop

008037d4 <__umoddi3>:
  8037d4:	55                   	push   %ebp
  8037d5:	57                   	push   %edi
  8037d6:	56                   	push   %esi
  8037d7:	53                   	push   %ebx
  8037d8:	83 ec 1c             	sub    $0x1c,%esp
  8037db:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037df:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037e7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037f3:	89 f3                	mov    %esi,%ebx
  8037f5:	89 fa                	mov    %edi,%edx
  8037f7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037fb:	89 34 24             	mov    %esi,(%esp)
  8037fe:	85 c0                	test   %eax,%eax
  803800:	75 1a                	jne    80381c <__umoddi3+0x48>
  803802:	39 f7                	cmp    %esi,%edi
  803804:	0f 86 a2 00 00 00    	jbe    8038ac <__umoddi3+0xd8>
  80380a:	89 c8                	mov    %ecx,%eax
  80380c:	89 f2                	mov    %esi,%edx
  80380e:	f7 f7                	div    %edi
  803810:	89 d0                	mov    %edx,%eax
  803812:	31 d2                	xor    %edx,%edx
  803814:	83 c4 1c             	add    $0x1c,%esp
  803817:	5b                   	pop    %ebx
  803818:	5e                   	pop    %esi
  803819:	5f                   	pop    %edi
  80381a:	5d                   	pop    %ebp
  80381b:	c3                   	ret    
  80381c:	39 f0                	cmp    %esi,%eax
  80381e:	0f 87 ac 00 00 00    	ja     8038d0 <__umoddi3+0xfc>
  803824:	0f bd e8             	bsr    %eax,%ebp
  803827:	83 f5 1f             	xor    $0x1f,%ebp
  80382a:	0f 84 ac 00 00 00    	je     8038dc <__umoddi3+0x108>
  803830:	bf 20 00 00 00       	mov    $0x20,%edi
  803835:	29 ef                	sub    %ebp,%edi
  803837:	89 fe                	mov    %edi,%esi
  803839:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80383d:	89 e9                	mov    %ebp,%ecx
  80383f:	d3 e0                	shl    %cl,%eax
  803841:	89 d7                	mov    %edx,%edi
  803843:	89 f1                	mov    %esi,%ecx
  803845:	d3 ef                	shr    %cl,%edi
  803847:	09 c7                	or     %eax,%edi
  803849:	89 e9                	mov    %ebp,%ecx
  80384b:	d3 e2                	shl    %cl,%edx
  80384d:	89 14 24             	mov    %edx,(%esp)
  803850:	89 d8                	mov    %ebx,%eax
  803852:	d3 e0                	shl    %cl,%eax
  803854:	89 c2                	mov    %eax,%edx
  803856:	8b 44 24 08          	mov    0x8(%esp),%eax
  80385a:	d3 e0                	shl    %cl,%eax
  80385c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803860:	8b 44 24 08          	mov    0x8(%esp),%eax
  803864:	89 f1                	mov    %esi,%ecx
  803866:	d3 e8                	shr    %cl,%eax
  803868:	09 d0                	or     %edx,%eax
  80386a:	d3 eb                	shr    %cl,%ebx
  80386c:	89 da                	mov    %ebx,%edx
  80386e:	f7 f7                	div    %edi
  803870:	89 d3                	mov    %edx,%ebx
  803872:	f7 24 24             	mull   (%esp)
  803875:	89 c6                	mov    %eax,%esi
  803877:	89 d1                	mov    %edx,%ecx
  803879:	39 d3                	cmp    %edx,%ebx
  80387b:	0f 82 87 00 00 00    	jb     803908 <__umoddi3+0x134>
  803881:	0f 84 91 00 00 00    	je     803918 <__umoddi3+0x144>
  803887:	8b 54 24 04          	mov    0x4(%esp),%edx
  80388b:	29 f2                	sub    %esi,%edx
  80388d:	19 cb                	sbb    %ecx,%ebx
  80388f:	89 d8                	mov    %ebx,%eax
  803891:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803895:	d3 e0                	shl    %cl,%eax
  803897:	89 e9                	mov    %ebp,%ecx
  803899:	d3 ea                	shr    %cl,%edx
  80389b:	09 d0                	or     %edx,%eax
  80389d:	89 e9                	mov    %ebp,%ecx
  80389f:	d3 eb                	shr    %cl,%ebx
  8038a1:	89 da                	mov    %ebx,%edx
  8038a3:	83 c4 1c             	add    $0x1c,%esp
  8038a6:	5b                   	pop    %ebx
  8038a7:	5e                   	pop    %esi
  8038a8:	5f                   	pop    %edi
  8038a9:	5d                   	pop    %ebp
  8038aa:	c3                   	ret    
  8038ab:	90                   	nop
  8038ac:	89 fd                	mov    %edi,%ebp
  8038ae:	85 ff                	test   %edi,%edi
  8038b0:	75 0b                	jne    8038bd <__umoddi3+0xe9>
  8038b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038b7:	31 d2                	xor    %edx,%edx
  8038b9:	f7 f7                	div    %edi
  8038bb:	89 c5                	mov    %eax,%ebp
  8038bd:	89 f0                	mov    %esi,%eax
  8038bf:	31 d2                	xor    %edx,%edx
  8038c1:	f7 f5                	div    %ebp
  8038c3:	89 c8                	mov    %ecx,%eax
  8038c5:	f7 f5                	div    %ebp
  8038c7:	89 d0                	mov    %edx,%eax
  8038c9:	e9 44 ff ff ff       	jmp    803812 <__umoddi3+0x3e>
  8038ce:	66 90                	xchg   %ax,%ax
  8038d0:	89 c8                	mov    %ecx,%eax
  8038d2:	89 f2                	mov    %esi,%edx
  8038d4:	83 c4 1c             	add    $0x1c,%esp
  8038d7:	5b                   	pop    %ebx
  8038d8:	5e                   	pop    %esi
  8038d9:	5f                   	pop    %edi
  8038da:	5d                   	pop    %ebp
  8038db:	c3                   	ret    
  8038dc:	3b 04 24             	cmp    (%esp),%eax
  8038df:	72 06                	jb     8038e7 <__umoddi3+0x113>
  8038e1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038e5:	77 0f                	ja     8038f6 <__umoddi3+0x122>
  8038e7:	89 f2                	mov    %esi,%edx
  8038e9:	29 f9                	sub    %edi,%ecx
  8038eb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038ef:	89 14 24             	mov    %edx,(%esp)
  8038f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038f6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038fa:	8b 14 24             	mov    (%esp),%edx
  8038fd:	83 c4 1c             	add    $0x1c,%esp
  803900:	5b                   	pop    %ebx
  803901:	5e                   	pop    %esi
  803902:	5f                   	pop    %edi
  803903:	5d                   	pop    %ebp
  803904:	c3                   	ret    
  803905:	8d 76 00             	lea    0x0(%esi),%esi
  803908:	2b 04 24             	sub    (%esp),%eax
  80390b:	19 fa                	sbb    %edi,%edx
  80390d:	89 d1                	mov    %edx,%ecx
  80390f:	89 c6                	mov    %eax,%esi
  803911:	e9 71 ff ff ff       	jmp    803887 <__umoddi3+0xb3>
  803916:	66 90                	xchg   %ax,%ax
  803918:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80391c:	72 ea                	jb     803908 <__umoddi3+0x134>
  80391e:	89 d9                	mov    %ebx,%ecx
  803920:	e9 62 ff ff ff       	jmp    803887 <__umoddi3+0xb3>
