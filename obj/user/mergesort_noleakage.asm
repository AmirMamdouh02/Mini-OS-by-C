
obj/user/mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 8f 07 00 00       	call   8007c5 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void Merge(int* A, int p, int q, int r);

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
  800041:	e8 9f 22 00 00       	call   8022e5 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 40 3b 80 00       	push   $0x803b40
  80004e:	e8 62 0b 00 00       	call   800bb5 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 42 3b 80 00       	push   $0x803b42
  80005e:	e8 52 0b 00 00       	call   800bb5 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 58 3b 80 00       	push   $0x803b58
  80006e:	e8 42 0b 00 00       	call   800bb5 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 42 3b 80 00       	push   $0x803b42
  80007e:	e8 32 0b 00 00       	call   800bb5 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 40 3b 80 00       	push   $0x803b40
  80008e:	e8 22 0b 00 00       	call   800bb5 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 70 3b 80 00       	push   $0x803b70
  8000a5:	e8 8d 11 00 00       	call   801237 <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 dd 16 00 00       	call   80179d <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 85 1c 00 00       	call   801d5a <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 90 3b 80 00       	push   $0x803b90
  8000e3:	e8 cd 0a 00 00       	call   800bb5 <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 b2 3b 80 00       	push   $0x803bb2
  8000f3:	e8 bd 0a 00 00       	call   800bb5 <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 c0 3b 80 00       	push   $0x803bc0
  800103:	e8 ad 0a 00 00       	call   800bb5 <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 cf 3b 80 00       	push   $0x803bcf
  800113:	e8 9d 0a 00 00       	call   800bb5 <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 df 3b 80 00       	push   $0x803bdf
  800123:	e8 8d 0a 00 00       	call   800bb5 <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 3d 06 00 00       	call   80076d <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 e5 05 00 00       	call   800725 <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 d8 05 00 00       	call   800725 <cputchar>
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
  800162:	e8 98 21 00 00       	call   8022ff <sys_enable_interrupt>

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
  800183:	e8 f4 01 00 00       	call   80037c <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 12 02 00 00       	call   8003ad <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 34 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 21 02 00 00       	call   8003e2 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 e0 02 00 00       	call   8004b4 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 09 21 00 00       	call   8022e5 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 e8 3b 80 00       	push   $0x803be8
  8001e4:	e8 cc 09 00 00       	call   800bb5 <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 0e 21 00 00       	call   8022ff <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 d3 00 00 00       	call   8002d2 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 1c 3c 80 00       	push   $0x803c1c
  800213:	6a 4a                	push   $0x4a
  800215:	68 3e 3c 80 00       	push   $0x803c3e
  80021a:	e8 e2 06 00 00       	call   800901 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 c1 20 00 00       	call   8022e5 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 5c 3c 80 00       	push   $0x803c5c
  80022c:	e8 84 09 00 00       	call   800bb5 <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 90 3c 80 00       	push   $0x803c90
  80023c:	e8 74 09 00 00       	call   800bb5 <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 c4 3c 80 00       	push   $0x803cc4
  80024c:	e8 64 09 00 00       	call   800bb5 <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 a6 20 00 00       	call   8022ff <sys_enable_interrupt>
		}

		free(Elements) ;
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	ff 75 ec             	pushl  -0x14(%ebp)
  80025f:	e8 8f 1b 00 00       	call   801df3 <free>
  800264:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  800267:	e8 79 20 00 00       	call   8022e5 <sys_disable_interrupt>
			Chose = 0 ;
  80026c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800270:	eb 42                	jmp    8002b4 <_main+0x27c>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	68 f6 3c 80 00       	push   $0x803cf6
  80027a:	e8 36 09 00 00       	call   800bb5 <cprintf>
  80027f:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800282:	e8 e6 04 00 00       	call   80076d <getchar>
  800287:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80028a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	e8 8e 04 00 00       	call   800725 <cputchar>
  800297:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 0a                	push   $0xa
  80029f:	e8 81 04 00 00       	call   800725 <cputchar>
  8002a4:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  8002a7:	83 ec 0c             	sub    $0xc,%esp
  8002aa:	6a 0a                	push   $0xa
  8002ac:	e8 74 04 00 00       	call   800725 <cputchar>
  8002b1:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002b4:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002b8:	74 06                	je     8002c0 <_main+0x288>
  8002ba:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002be:	75 b2                	jne    800272 <_main+0x23a>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002c0:	e8 3a 20 00 00       	call   8022ff <sys_enable_interrupt>

	} while (Chose == 'y');
  8002c5:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002c9:	0f 84 72 fd ff ff    	je     800041 <_main+0x9>

}
  8002cf:	90                   	nop
  8002d0:	c9                   	leave  
  8002d1:	c3                   	ret    

008002d2 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002d2:	55                   	push   %ebp
  8002d3:	89 e5                	mov    %esp,%ebp
  8002d5:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002d8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002e6:	eb 33                	jmp    80031b <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 d0                	add    %edx,%eax
  8002f7:	8b 10                	mov    (%eax),%edx
  8002f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002fc:	40                   	inc    %eax
  8002fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800304:	8b 45 08             	mov    0x8(%ebp),%eax
  800307:	01 c8                	add    %ecx,%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	39 c2                	cmp    %eax,%edx
  80030d:	7e 09                	jle    800318 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80030f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800316:	eb 0c                	jmp    800324 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800318:	ff 45 f8             	incl   -0x8(%ebp)
  80031b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031e:	48                   	dec    %eax
  80031f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800322:	7f c4                	jg     8002e8 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800324:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800327:	c9                   	leave  
  800328:	c3                   	ret    

00800329 <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80032f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800339:	8b 45 08             	mov    0x8(%ebp),%eax
  80033c:	01 d0                	add    %edx,%eax
  80033e:	8b 00                	mov    (%eax),%eax
  800340:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800343:	8b 45 0c             	mov    0xc(%ebp),%eax
  800346:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80034d:	8b 45 08             	mov    0x8(%ebp),%eax
  800350:	01 c2                	add    %eax,%edx
  800352:	8b 45 10             	mov    0x10(%ebp),%eax
  800355:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80035c:	8b 45 08             	mov    0x8(%ebp),%eax
  80035f:	01 c8                	add    %ecx,%eax
  800361:	8b 00                	mov    (%eax),%eax
  800363:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800365:	8b 45 10             	mov    0x10(%ebp),%eax
  800368:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	01 c2                	add    %eax,%edx
  800374:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800377:	89 02                	mov    %eax,(%edx)
}
  800379:	90                   	nop
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800382:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800389:	eb 17                	jmp    8003a2 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80038b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800395:	8b 45 08             	mov    0x8(%ebp),%eax
  800398:	01 c2                	add    %eax,%edx
  80039a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80039d:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80039f:	ff 45 fc             	incl   -0x4(%ebp)
  8003a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003a8:	7c e1                	jl     80038b <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8003aa:	90                   	nop
  8003ab:	c9                   	leave  
  8003ac:	c3                   	ret    

008003ad <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8003ad:	55                   	push   %ebp
  8003ae:	89 e5                	mov    %esp,%ebp
  8003b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ba:	eb 1b                	jmp    8003d7 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c9:	01 c2                	add    %eax,%edx
  8003cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ce:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003d1:	48                   	dec    %eax
  8003d2:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003d4:	ff 45 fc             	incl   -0x4(%ebp)
  8003d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003da:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003dd:	7c dd                	jl     8003bc <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003df:	90                   	nop
  8003e0:	c9                   	leave  
  8003e1:	c3                   	ret    

008003e2 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003e8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003eb:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003f0:	f7 e9                	imul   %ecx
  8003f2:	c1 f9 1f             	sar    $0x1f,%ecx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	29 c8                	sub    %ecx,%eax
  8003f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800403:	eb 1e                	jmp    800423 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800408:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	99                   	cltd   
  800419:	f7 7d f8             	idivl  -0x8(%ebp)
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 fc             	incl   -0x4(%ebp)
  800423:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	7c da                	jl     800405 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
			//cprintf("i=%d\n",i);
	}

}
  80042b:	90                   	nop
  80042c:	c9                   	leave  
  80042d:	c3                   	ret    

0080042e <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  80042e:	55                   	push   %ebp
  80042f:	89 e5                	mov    %esp,%ebp
  800431:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800434:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80043b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800442:	eb 42                	jmp    800486 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800447:	99                   	cltd   
  800448:	f7 7d f0             	idivl  -0x10(%ebp)
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	85 c0                	test   %eax,%eax
  80044f:	75 10                	jne    800461 <PrintElements+0x33>
			cprintf("\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 40 3b 80 00       	push   $0x803b40
  800459:	e8 57 07 00 00       	call   800bb5 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	01 d0                	add    %edx,%eax
  800470:	8b 00                	mov    (%eax),%eax
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	50                   	push   %eax
  800476:	68 14 3d 80 00       	push   $0x803d14
  80047b:	e8 35 07 00 00       	call   800bb5 <cprintf>
  800480:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800483:	ff 45 f4             	incl   -0xc(%ebp)
  800486:	8b 45 0c             	mov    0xc(%ebp),%eax
  800489:	48                   	dec    %eax
  80048a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80048d:	7f b5                	jg     800444 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	01 d0                	add    %edx,%eax
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 19 3d 80 00       	push   $0x803d19
  8004a9:	e8 07 07 00 00       	call   800bb5 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp

}
  8004b1:	90                   	nop
  8004b2:	c9                   	leave  
  8004b3:	c3                   	ret    

008004b4 <MSort>:


void MSort(int* A, int p, int r)
{
  8004b4:	55                   	push   %ebp
  8004b5:	89 e5                	mov    %esp,%ebp
  8004b7:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004c0:	7d 54                	jge    800516 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	89 c2                	mov    %eax,%edx
  8004cc:	c1 ea 1f             	shr    $0x1f,%edx
  8004cf:	01 d0                	add    %edx,%eax
  8004d1:	d1 f8                	sar    %eax
  8004d3:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8004dc:	ff 75 0c             	pushl  0xc(%ebp)
  8004df:	ff 75 08             	pushl  0x8(%ebp)
  8004e2:	e8 cd ff ff ff       	call   8004b4 <MSort>
  8004e7:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ed:	40                   	inc    %eax
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	ff 75 10             	pushl  0x10(%ebp)
  8004f4:	50                   	push   %eax
  8004f5:	ff 75 08             	pushl  0x8(%ebp)
  8004f8:	e8 b7 ff ff ff       	call   8004b4 <MSort>
  8004fd:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  800500:	ff 75 10             	pushl  0x10(%ebp)
  800503:	ff 75 f4             	pushl  -0xc(%ebp)
  800506:	ff 75 0c             	pushl  0xc(%ebp)
  800509:	ff 75 08             	pushl  0x8(%ebp)
  80050c:	e8 08 00 00 00       	call   800519 <Merge>
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	eb 01                	jmp    800517 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800516:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800517:	c9                   	leave  
  800518:	c3                   	ret    

00800519 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80051f:	8b 45 10             	mov    0x10(%ebp),%eax
  800522:	2b 45 0c             	sub    0xc(%ebp),%eax
  800525:	40                   	inc    %eax
  800526:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	2b 45 10             	sub    0x10(%ebp),%eax
  80052f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800532:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	//cprintf("allocate LEFT\n");
	int* Left = malloc(sizeof(int) * leftCapacity);
  800540:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800543:	c1 e0 02             	shl    $0x2,%eax
  800546:	83 ec 0c             	sub    $0xc,%esp
  800549:	50                   	push   %eax
  80054a:	e8 0b 18 00 00       	call   801d5a <malloc>
  80054f:	83 c4 10             	add    $0x10,%esp
  800552:	89 45 d8             	mov    %eax,-0x28(%ebp)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);
  800555:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800558:	c1 e0 02             	shl    $0x2,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 f6 17 00 00       	call   801d5a <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80056a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800571:	eb 2f                	jmp    8005a2 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800576:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80057d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800580:	01 c2                	add    %eax,%edx
  800582:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800585:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800588:	01 c8                	add    %ecx,%eax
  80058a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80058f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	01 c8                	add    %ecx,%eax
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 02                	mov    %eax,(%edx)

	//cprintf("allocate RIGHT\n");
	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80059f:	ff 45 ec             	incl   -0x14(%ebp)
  8005a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8005a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005a8:	7c c9                	jl     800573 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005b1:	eb 2a                	jmp    8005dd <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005c0:	01 c2                	add    %eax,%edx
  8005c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d4:	01 c8                	add    %ecx,%eax
  8005d6:	8b 00                	mov    (%eax),%eax
  8005d8:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e0:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005e3:	7c ce                	jl     8005b3 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005eb:	e9 0a 01 00 00       	jmp    8006fa <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005f6:	0f 8d 95 00 00 00    	jge    800691 <Merge+0x178>
  8005fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005ff:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800602:	0f 8d 89 00 00 00    	jge    800691 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800612:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800615:	01 d0                	add    %edx,%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800623:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800626:	01 c8                	add    %ecx,%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	39 c2                	cmp    %eax,%edx
  80062c:	7d 33                	jge    800661 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800631:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800636:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80063d:	8b 45 08             	mov    0x8(%ebp),%eax
  800640:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800646:	8d 50 01             	lea    0x1(%eax),%edx
  800649:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80064c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800653:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800656:	01 d0                	add    %edx,%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80065c:	e9 96 00 00 00       	jmp    8006f7 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800664:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800669:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800679:	8d 50 01             	lea    0x1(%eax),%edx
  80067c:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80067f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800686:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800689:	01 d0                	add    %edx,%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80068f:	eb 66                	jmp    8006f7 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800694:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800697:	7d 30                	jge    8006c9 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  800699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80069c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ab:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b1:	8d 50 01             	lea    0x1(%eax),%edx
  8006b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006c1:	01 d0                	add    %edx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 01                	mov    %eax,(%ecx)
  8006c7:	eb 2e                	jmp    8006f7 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006cc:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006e1:	8d 50 01             	lea    0x1(%eax),%edx
  8006e4:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006e7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f1:	01 d0                	add    %edx,%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006f7:	ff 45 e4             	incl   -0x1c(%ebp)
  8006fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006fd:	3b 45 14             	cmp    0x14(%ebp),%eax
  800700:	0f 8e ea fe ff ff    	jle    8005f0 <Merge+0xd7>
			A[k - 1] = Right[rightIndex++];
		}
	}

	//cprintf("free LEFT\n");
	free(Left);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d8             	pushl  -0x28(%ebp)
  80070c:	e8 e2 16 00 00       	call   801df3 <free>
  800711:	83 c4 10             	add    $0x10,%esp
	//cprintf("free RIGHT\n");
	free(Right);
  800714:	83 ec 0c             	sub    $0xc,%esp
  800717:	ff 75 d4             	pushl  -0x2c(%ebp)
  80071a:	e8 d4 16 00 00       	call   801df3 <free>
  80071f:	83 c4 10             	add    $0x10,%esp

}
  800722:	90                   	nop
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800731:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800735:	83 ec 0c             	sub    $0xc,%esp
  800738:	50                   	push   %eax
  800739:	e8 db 1b 00 00       	call   802319 <sys_cputc>
  80073e:	83 c4 10             	add    $0x10,%esp
}
  800741:	90                   	nop
  800742:	c9                   	leave  
  800743:	c3                   	ret    

00800744 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80074a:	e8 96 1b 00 00       	call   8022e5 <sys_disable_interrupt>
	char c = ch;
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800755:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800759:	83 ec 0c             	sub    $0xc,%esp
  80075c:	50                   	push   %eax
  80075d:	e8 b7 1b 00 00       	call   802319 <sys_cputc>
  800762:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800765:	e8 95 1b 00 00       	call   8022ff <sys_enable_interrupt>
}
  80076a:	90                   	nop
  80076b:	c9                   	leave  
  80076c:	c3                   	ret    

0080076d <getchar>:

int
getchar(void)
{
  80076d:	55                   	push   %ebp
  80076e:	89 e5                	mov    %esp,%ebp
  800770:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800773:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80077a:	eb 08                	jmp    800784 <getchar+0x17>
	{
		c = sys_cgetc();
  80077c:	e8 df 19 00 00       	call   802160 <sys_cgetc>
  800781:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800784:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800788:	74 f2                	je     80077c <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80078a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <atomic_getchar>:

int
atomic_getchar(void)
{
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800795:	e8 4b 1b 00 00       	call   8022e5 <sys_disable_interrupt>
	int c=0;
  80079a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8007a1:	eb 08                	jmp    8007ab <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8007a3:	e8 b8 19 00 00       	call   802160 <sys_cgetc>
  8007a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8007ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007af:	74 f2                	je     8007a3 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007b1:	e8 49 1b 00 00       	call   8022ff <sys_enable_interrupt>
	return c;
  8007b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007b9:	c9                   	leave  
  8007ba:	c3                   	ret    

008007bb <iscons>:

int iscons(int fdnum)
{
  8007bb:	55                   	push   %ebp
  8007bc:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007be:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    

008007c5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007c5:	55                   	push   %ebp
  8007c6:	89 e5                	mov    %esp,%ebp
  8007c8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007cb:	e8 08 1d 00 00       	call   8024d8 <sys_getenvindex>
  8007d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007d6:	89 d0                	mov    %edx,%eax
  8007d8:	c1 e0 03             	shl    $0x3,%eax
  8007db:	01 d0                	add    %edx,%eax
  8007dd:	01 c0                	add    %eax,%eax
  8007df:	01 d0                	add    %edx,%eax
  8007e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007e8:	01 d0                	add    %edx,%eax
  8007ea:	c1 e0 04             	shl    $0x4,%eax
  8007ed:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007f2:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800802:	84 c0                	test   %al,%al
  800804:	74 0f                	je     800815 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800806:	a1 24 50 80 00       	mov    0x805024,%eax
  80080b:	05 5c 05 00 00       	add    $0x55c,%eax
  800810:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800815:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800819:	7e 0a                	jle    800825 <libmain+0x60>
		binaryname = argv[0];
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	8b 00                	mov    (%eax),%eax
  800820:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800825:	83 ec 08             	sub    $0x8,%esp
  800828:	ff 75 0c             	pushl  0xc(%ebp)
  80082b:	ff 75 08             	pushl  0x8(%ebp)
  80082e:	e8 05 f8 ff ff       	call   800038 <_main>
  800833:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800836:	e8 aa 1a 00 00       	call   8022e5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80083b:	83 ec 0c             	sub    $0xc,%esp
  80083e:	68 38 3d 80 00       	push   $0x803d38
  800843:	e8 6d 03 00 00       	call   800bb5 <cprintf>
  800848:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80084b:	a1 24 50 80 00       	mov    0x805024,%eax
  800850:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800856:	a1 24 50 80 00       	mov    0x805024,%eax
  80085b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800861:	83 ec 04             	sub    $0x4,%esp
  800864:	52                   	push   %edx
  800865:	50                   	push   %eax
  800866:	68 60 3d 80 00       	push   $0x803d60
  80086b:	e8 45 03 00 00       	call   800bb5 <cprintf>
  800870:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800873:	a1 24 50 80 00       	mov    0x805024,%eax
  800878:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80087e:	a1 24 50 80 00       	mov    0x805024,%eax
  800883:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800889:	a1 24 50 80 00       	mov    0x805024,%eax
  80088e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800894:	51                   	push   %ecx
  800895:	52                   	push   %edx
  800896:	50                   	push   %eax
  800897:	68 88 3d 80 00       	push   $0x803d88
  80089c:	e8 14 03 00 00       	call   800bb5 <cprintf>
  8008a1:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8008a4:	a1 24 50 80 00       	mov    0x805024,%eax
  8008a9:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008af:	83 ec 08             	sub    $0x8,%esp
  8008b2:	50                   	push   %eax
  8008b3:	68 e0 3d 80 00       	push   $0x803de0
  8008b8:	e8 f8 02 00 00       	call   800bb5 <cprintf>
  8008bd:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008c0:	83 ec 0c             	sub    $0xc,%esp
  8008c3:	68 38 3d 80 00       	push   $0x803d38
  8008c8:	e8 e8 02 00 00       	call   800bb5 <cprintf>
  8008cd:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008d0:	e8 2a 1a 00 00       	call   8022ff <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008d5:	e8 19 00 00 00       	call   8008f3 <exit>
}
  8008da:	90                   	nop
  8008db:	c9                   	leave  
  8008dc:	c3                   	ret    

008008dd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008e3:	83 ec 0c             	sub    $0xc,%esp
  8008e6:	6a 00                	push   $0x0
  8008e8:	e8 b7 1b 00 00       	call   8024a4 <sys_destroy_env>
  8008ed:	83 c4 10             	add    $0x10,%esp
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <exit>:

void
exit(void)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008f9:	e8 0c 1c 00 00       	call   80250a <sys_exit_env>
}
  8008fe:	90                   	nop
  8008ff:	c9                   	leave  
  800900:	c3                   	ret    

00800901 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800907:	8d 45 10             	lea    0x10(%ebp),%eax
  80090a:	83 c0 04             	add    $0x4,%eax
  80090d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800910:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800915:	85 c0                	test   %eax,%eax
  800917:	74 16                	je     80092f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800919:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	50                   	push   %eax
  800922:	68 f4 3d 80 00       	push   $0x803df4
  800927:	e8 89 02 00 00       	call   800bb5 <cprintf>
  80092c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80092f:	a1 00 50 80 00       	mov    0x805000,%eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	50                   	push   %eax
  80093b:	68 f9 3d 80 00       	push   $0x803df9
  800940:	e8 70 02 00 00       	call   800bb5 <cprintf>
  800945:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 f4             	pushl  -0xc(%ebp)
  800951:	50                   	push   %eax
  800952:	e8 f3 01 00 00       	call   800b4a <vcprintf>
  800957:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80095a:	83 ec 08             	sub    $0x8,%esp
  80095d:	6a 00                	push   $0x0
  80095f:	68 15 3e 80 00       	push   $0x803e15
  800964:	e8 e1 01 00 00       	call   800b4a <vcprintf>
  800969:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80096c:	e8 82 ff ff ff       	call   8008f3 <exit>

	// should not return here
	while (1) ;
  800971:	eb fe                	jmp    800971 <_panic+0x70>

00800973 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800979:	a1 24 50 80 00       	mov    0x805024,%eax
  80097e:	8b 50 74             	mov    0x74(%eax),%edx
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	39 c2                	cmp    %eax,%edx
  800986:	74 14                	je     80099c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 18 3e 80 00       	push   $0x803e18
  800990:	6a 26                	push   $0x26
  800992:	68 64 3e 80 00       	push   $0x803e64
  800997:	e8 65 ff ff ff       	call   800901 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80099c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8009a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8009aa:	e9 c2 00 00 00       	jmp    800a71 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bc:	01 d0                	add    %edx,%eax
  8009be:	8b 00                	mov    (%eax),%eax
  8009c0:	85 c0                	test   %eax,%eax
  8009c2:	75 08                	jne    8009cc <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009c4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009c7:	e9 a2 00 00 00       	jmp    800a6e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009da:	eb 69                	jmp    800a45 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8009e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ea:	89 d0                	mov    %edx,%eax
  8009ec:	01 c0                	add    %eax,%eax
  8009ee:	01 d0                	add    %edx,%eax
  8009f0:	c1 e0 03             	shl    $0x3,%eax
  8009f3:	01 c8                	add    %ecx,%eax
  8009f5:	8a 40 04             	mov    0x4(%eax),%al
  8009f8:	84 c0                	test   %al,%al
  8009fa:	75 46                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009fc:	a1 24 50 80 00       	mov    0x805024,%eax
  800a01:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a07:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	01 c0                	add    %eax,%eax
  800a0e:	01 d0                	add    %edx,%eax
  800a10:	c1 e0 03             	shl    $0x3,%eax
  800a13:	01 c8                	add    %ecx,%eax
  800a15:	8b 00                	mov    (%eax),%eax
  800a17:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a22:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a27:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	01 c8                	add    %ecx,%eax
  800a33:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a35:	39 c2                	cmp    %eax,%edx
  800a37:	75 09                	jne    800a42 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a39:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a40:	eb 12                	jmp    800a54 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a42:	ff 45 e8             	incl   -0x18(%ebp)
  800a45:	a1 24 50 80 00       	mov    0x805024,%eax
  800a4a:	8b 50 74             	mov    0x74(%eax),%edx
  800a4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a50:	39 c2                	cmp    %eax,%edx
  800a52:	77 88                	ja     8009dc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a58:	75 14                	jne    800a6e <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a5a:	83 ec 04             	sub    $0x4,%esp
  800a5d:	68 70 3e 80 00       	push   $0x803e70
  800a62:	6a 3a                	push   $0x3a
  800a64:	68 64 3e 80 00       	push   $0x803e64
  800a69:	e8 93 fe ff ff       	call   800901 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a6e:	ff 45 f0             	incl   -0x10(%ebp)
  800a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a77:	0f 8c 32 ff ff ff    	jl     8009af <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a84:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a8b:	eb 26                	jmp    800ab3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a8d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a92:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a98:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a9b:	89 d0                	mov    %edx,%eax
  800a9d:	01 c0                	add    %eax,%eax
  800a9f:	01 d0                	add    %edx,%eax
  800aa1:	c1 e0 03             	shl    $0x3,%eax
  800aa4:	01 c8                	add    %ecx,%eax
  800aa6:	8a 40 04             	mov    0x4(%eax),%al
  800aa9:	3c 01                	cmp    $0x1,%al
  800aab:	75 03                	jne    800ab0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800aad:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ab0:	ff 45 e0             	incl   -0x20(%ebp)
  800ab3:	a1 24 50 80 00       	mov    0x805024,%eax
  800ab8:	8b 50 74             	mov    0x74(%eax),%edx
  800abb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800abe:	39 c2                	cmp    %eax,%edx
  800ac0:	77 cb                	ja     800a8d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800ac8:	74 14                	je     800ade <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aca:	83 ec 04             	sub    $0x4,%esp
  800acd:	68 c4 3e 80 00       	push   $0x803ec4
  800ad2:	6a 44                	push   $0x44
  800ad4:	68 64 3e 80 00       	push   $0x803e64
  800ad9:	e8 23 fe ff ff       	call   800901 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ade:	90                   	nop
  800adf:	c9                   	leave  
  800ae0:	c3                   	ret    

00800ae1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aea:	8b 00                	mov    (%eax),%eax
  800aec:	8d 48 01             	lea    0x1(%eax),%ecx
  800aef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af2:	89 0a                	mov    %ecx,(%edx)
  800af4:	8b 55 08             	mov    0x8(%ebp),%edx
  800af7:	88 d1                	mov    %dl,%cl
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b0a:	75 2c                	jne    800b38 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800b0c:	a0 28 50 80 00       	mov    0x805028,%al
  800b11:	0f b6 c0             	movzbl %al,%eax
  800b14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b17:	8b 12                	mov    (%edx),%edx
  800b19:	89 d1                	mov    %edx,%ecx
  800b1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1e:	83 c2 08             	add    $0x8,%edx
  800b21:	83 ec 04             	sub    $0x4,%esp
  800b24:	50                   	push   %eax
  800b25:	51                   	push   %ecx
  800b26:	52                   	push   %edx
  800b27:	e8 0b 16 00 00       	call   802137 <sys_cputs>
  800b2c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3b:	8b 40 04             	mov    0x4(%eax),%eax
  800b3e:	8d 50 01             	lea    0x1(%eax),%edx
  800b41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b44:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b47:	90                   	nop
  800b48:	c9                   	leave  
  800b49:	c3                   	ret    

00800b4a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b53:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5a:	00 00 00 
	b.cnt = 0;
  800b5d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b64:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b67:	ff 75 0c             	pushl  0xc(%ebp)
  800b6a:	ff 75 08             	pushl  0x8(%ebp)
  800b6d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 e1 0a 80 00       	push   $0x800ae1
  800b79:	e8 11 02 00 00       	call   800d8f <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b81:	a0 28 50 80 00       	mov    0x805028,%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b8f:	83 ec 04             	sub    $0x4,%esp
  800b92:	50                   	push   %eax
  800b93:	52                   	push   %edx
  800b94:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b9a:	83 c0 08             	add    $0x8,%eax
  800b9d:	50                   	push   %eax
  800b9e:	e8 94 15 00 00       	call   802137 <sys_cputs>
  800ba3:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ba6:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800bad:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <cprintf>:

int cprintf(const char *fmt, ...) {
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bbb:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bc2:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcb:	83 ec 08             	sub    $0x8,%esp
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	e8 73 ff ff ff       	call   800b4a <vcprintf>
  800bd7:	83 c4 10             	add    $0x10,%esp
  800bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800be8:	e8 f8 16 00 00       	call   8022e5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bed:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	e8 48 ff ff ff       	call   800b4a <vcprintf>
  800c02:	83 c4 10             	add    $0x10,%esp
  800c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800c08:	e8 f2 16 00 00       	call   8022ff <sys_enable_interrupt>
	return cnt;
  800c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c10:	c9                   	leave  
  800c11:	c3                   	ret    

00800c12 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c12:	55                   	push   %ebp
  800c13:	89 e5                	mov    %esp,%ebp
  800c15:	53                   	push   %ebx
  800c16:	83 ec 14             	sub    $0x14,%esp
  800c19:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c25:	8b 45 18             	mov    0x18(%ebp),%eax
  800c28:	ba 00 00 00 00       	mov    $0x0,%edx
  800c2d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c30:	77 55                	ja     800c87 <printnum+0x75>
  800c32:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c35:	72 05                	jb     800c3c <printnum+0x2a>
  800c37:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c3a:	77 4b                	ja     800c87 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c3c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c3f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c42:	8b 45 18             	mov    0x18(%ebp),%eax
  800c45:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4a:	52                   	push   %edx
  800c4b:	50                   	push   %eax
  800c4c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c4f:	ff 75 f0             	pushl  -0x10(%ebp)
  800c52:	e8 69 2c 00 00       	call   8038c0 <__udivdi3>
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	83 ec 04             	sub    $0x4,%esp
  800c5d:	ff 75 20             	pushl  0x20(%ebp)
  800c60:	53                   	push   %ebx
  800c61:	ff 75 18             	pushl  0x18(%ebp)
  800c64:	52                   	push   %edx
  800c65:	50                   	push   %eax
  800c66:	ff 75 0c             	pushl  0xc(%ebp)
  800c69:	ff 75 08             	pushl  0x8(%ebp)
  800c6c:	e8 a1 ff ff ff       	call   800c12 <printnum>
  800c71:	83 c4 20             	add    $0x20,%esp
  800c74:	eb 1a                	jmp    800c90 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	ff 75 20             	pushl  0x20(%ebp)
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c87:	ff 4d 1c             	decl   0x1c(%ebp)
  800c8a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c8e:	7f e6                	jg     800c76 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c90:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9e:	53                   	push   %ebx
  800c9f:	51                   	push   %ecx
  800ca0:	52                   	push   %edx
  800ca1:	50                   	push   %eax
  800ca2:	e8 29 2d 00 00       	call   8039d0 <__umoddi3>
  800ca7:	83 c4 10             	add    $0x10,%esp
  800caa:	05 34 41 80 00       	add    $0x804134,%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	0f be c0             	movsbl %al,%eax
  800cb4:	83 ec 08             	sub    $0x8,%esp
  800cb7:	ff 75 0c             	pushl  0xc(%ebp)
  800cba:	50                   	push   %eax
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
}
  800cc3:	90                   	nop
  800cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cc7:	c9                   	leave  
  800cc8:	c3                   	ret    

00800cc9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd0:	7e 1c                	jle    800cee <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 00                	mov    (%eax),%eax
  800cd7:	8d 50 08             	lea    0x8(%eax),%edx
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 10                	mov    %edx,(%eax)
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	8b 00                	mov    (%eax),%eax
  800ce4:	83 e8 08             	sub    $0x8,%eax
  800ce7:	8b 50 04             	mov    0x4(%eax),%edx
  800cea:	8b 00                	mov    (%eax),%eax
  800cec:	eb 40                	jmp    800d2e <getuint+0x65>
	else if (lflag)
  800cee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf2:	74 1e                	je     800d12 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8b 00                	mov    (%eax),%eax
  800cf9:	8d 50 04             	lea    0x4(%eax),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	89 10                	mov    %edx,(%eax)
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 e8 04             	sub    $0x4,%eax
  800d09:	8b 00                	mov    (%eax),%eax
  800d0b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d10:	eb 1c                	jmp    800d2e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 00                	mov    (%eax),%eax
  800d17:	8d 50 04             	lea    0x4(%eax),%edx
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	89 10                	mov    %edx,(%eax)
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	83 e8 04             	sub    $0x4,%eax
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d33:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d37:	7e 1c                	jle    800d55 <getint+0x25>
		return va_arg(*ap, long long);
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8b 00                	mov    (%eax),%eax
  800d3e:	8d 50 08             	lea    0x8(%eax),%edx
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	89 10                	mov    %edx,(%eax)
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8b 00                	mov    (%eax),%eax
  800d4b:	83 e8 08             	sub    $0x8,%eax
  800d4e:	8b 50 04             	mov    0x4(%eax),%edx
  800d51:	8b 00                	mov    (%eax),%eax
  800d53:	eb 38                	jmp    800d8d <getint+0x5d>
	else if (lflag)
  800d55:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d59:	74 1a                	je     800d75 <getint+0x45>
		return va_arg(*ap, long);
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	8b 00                	mov    (%eax),%eax
  800d60:	8d 50 04             	lea    0x4(%eax),%edx
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	89 10                	mov    %edx,(%eax)
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8b 00                	mov    (%eax),%eax
  800d6d:	83 e8 04             	sub    $0x4,%eax
  800d70:	8b 00                	mov    (%eax),%eax
  800d72:	99                   	cltd   
  800d73:	eb 18                	jmp    800d8d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 50 04             	lea    0x4(%eax),%edx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	89 10                	mov    %edx,(%eax)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8b 00                	mov    (%eax),%eax
  800d87:	83 e8 04             	sub    $0x4,%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	99                   	cltd   
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	56                   	push   %esi
  800d93:	53                   	push   %ebx
  800d94:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d97:	eb 17                	jmp    800db0 <vprintfmt+0x21>
			if (ch == '\0')
  800d99:	85 db                	test   %ebx,%ebx
  800d9b:	0f 84 af 03 00 00    	je     801150 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	53                   	push   %ebx
  800da8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dab:	ff d0                	call   *%eax
  800dad:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	8d 50 01             	lea    0x1(%eax),%edx
  800db6:	89 55 10             	mov    %edx,0x10(%ebp)
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	0f b6 d8             	movzbl %al,%ebx
  800dbe:	83 fb 25             	cmp    $0x25,%ebx
  800dc1:	75 d6                	jne    800d99 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800dc3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800dc7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dce:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dd5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ddc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800de3:	8b 45 10             	mov    0x10(%ebp),%eax
  800de6:	8d 50 01             	lea    0x1(%eax),%edx
  800de9:	89 55 10             	mov    %edx,0x10(%ebp)
  800dec:	8a 00                	mov    (%eax),%al
  800dee:	0f b6 d8             	movzbl %al,%ebx
  800df1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800df4:	83 f8 55             	cmp    $0x55,%eax
  800df7:	0f 87 2b 03 00 00    	ja     801128 <vprintfmt+0x399>
  800dfd:	8b 04 85 58 41 80 00 	mov    0x804158(,%eax,4),%eax
  800e04:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800e06:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800e0a:	eb d7                	jmp    800de3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800e0c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e10:	eb d1                	jmp    800de3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e12:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e19:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e1c:	89 d0                	mov    %edx,%eax
  800e1e:	c1 e0 02             	shl    $0x2,%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d8                	add    %ebx,%eax
  800e27:	83 e8 30             	sub    $0x30,%eax
  800e2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e30:	8a 00                	mov    (%eax),%al
  800e32:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e35:	83 fb 2f             	cmp    $0x2f,%ebx
  800e38:	7e 3e                	jle    800e78 <vprintfmt+0xe9>
  800e3a:	83 fb 39             	cmp    $0x39,%ebx
  800e3d:	7f 39                	jg     800e78 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e3f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e42:	eb d5                	jmp    800e19 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e44:	8b 45 14             	mov    0x14(%ebp),%eax
  800e47:	83 c0 04             	add    $0x4,%eax
  800e4a:	89 45 14             	mov    %eax,0x14(%ebp)
  800e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e50:	83 e8 04             	sub    $0x4,%eax
  800e53:	8b 00                	mov    (%eax),%eax
  800e55:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e58:	eb 1f                	jmp    800e79 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5e:	79 83                	jns    800de3 <vprintfmt+0x54>
				width = 0;
  800e60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e67:	e9 77 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e6c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e73:	e9 6b ff ff ff       	jmp    800de3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e78:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e79:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e7d:	0f 89 60 ff ff ff    	jns    800de3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e83:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e89:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e90:	e9 4e ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e95:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e98:	e9 46 ff ff ff       	jmp    800de3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e9d:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea0:	83 c0 04             	add    $0x4,%eax
  800ea3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea9:	83 e8 04             	sub    $0x4,%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	83 ec 08             	sub    $0x8,%esp
  800eb1:	ff 75 0c             	pushl  0xc(%ebp)
  800eb4:	50                   	push   %eax
  800eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb8:	ff d0                	call   *%eax
  800eba:	83 c4 10             	add    $0x10,%esp
			break;
  800ebd:	e9 89 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ec2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec5:	83 c0 04             	add    $0x4,%eax
  800ec8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ecb:	8b 45 14             	mov    0x14(%ebp),%eax
  800ece:	83 e8 04             	sub    $0x4,%eax
  800ed1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ed3:	85 db                	test   %ebx,%ebx
  800ed5:	79 02                	jns    800ed9 <vprintfmt+0x14a>
				err = -err;
  800ed7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed9:	83 fb 64             	cmp    $0x64,%ebx
  800edc:	7f 0b                	jg     800ee9 <vprintfmt+0x15a>
  800ede:	8b 34 9d a0 3f 80 00 	mov    0x803fa0(,%ebx,4),%esi
  800ee5:	85 f6                	test   %esi,%esi
  800ee7:	75 19                	jne    800f02 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ee9:	53                   	push   %ebx
  800eea:	68 45 41 80 00       	push   $0x804145
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	ff 75 08             	pushl  0x8(%ebp)
  800ef5:	e8 5e 02 00 00       	call   801158 <printfmt>
  800efa:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800efd:	e9 49 02 00 00       	jmp    80114b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800f02:	56                   	push   %esi
  800f03:	68 4e 41 80 00       	push   $0x80414e
  800f08:	ff 75 0c             	pushl  0xc(%ebp)
  800f0b:	ff 75 08             	pushl  0x8(%ebp)
  800f0e:	e8 45 02 00 00       	call   801158 <printfmt>
  800f13:	83 c4 10             	add    $0x10,%esp
			break;
  800f16:	e9 30 02 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1e:	83 c0 04             	add    $0x4,%eax
  800f21:	89 45 14             	mov    %eax,0x14(%ebp)
  800f24:	8b 45 14             	mov    0x14(%ebp),%eax
  800f27:	83 e8 04             	sub    $0x4,%eax
  800f2a:	8b 30                	mov    (%eax),%esi
  800f2c:	85 f6                	test   %esi,%esi
  800f2e:	75 05                	jne    800f35 <vprintfmt+0x1a6>
				p = "(null)";
  800f30:	be 51 41 80 00       	mov    $0x804151,%esi
			if (width > 0 && padc != '-')
  800f35:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f39:	7e 6d                	jle    800fa8 <vprintfmt+0x219>
  800f3b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f3f:	74 67                	je     800fa8 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	83 ec 08             	sub    $0x8,%esp
  800f47:	50                   	push   %eax
  800f48:	56                   	push   %esi
  800f49:	e8 12 05 00 00       	call   801460 <strnlen>
  800f4e:	83 c4 10             	add    $0x10,%esp
  800f51:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f54:	eb 16                	jmp    800f6c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f56:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	50                   	push   %eax
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	ff d0                	call   *%eax
  800f66:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f69:	ff 4d e4             	decl   -0x1c(%ebp)
  800f6c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f70:	7f e4                	jg     800f56 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f72:	eb 34                	jmp    800fa8 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f74:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f78:	74 1c                	je     800f96 <vprintfmt+0x207>
  800f7a:	83 fb 1f             	cmp    $0x1f,%ebx
  800f7d:	7e 05                	jle    800f84 <vprintfmt+0x1f5>
  800f7f:	83 fb 7e             	cmp    $0x7e,%ebx
  800f82:	7e 12                	jle    800f96 <vprintfmt+0x207>
					putch('?', putdat);
  800f84:	83 ec 08             	sub    $0x8,%esp
  800f87:	ff 75 0c             	pushl  0xc(%ebp)
  800f8a:	6a 3f                	push   $0x3f
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	ff d0                	call   *%eax
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	eb 0f                	jmp    800fa5 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f96:	83 ec 08             	sub    $0x8,%esp
  800f99:	ff 75 0c             	pushl  0xc(%ebp)
  800f9c:	53                   	push   %ebx
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	ff d0                	call   *%eax
  800fa2:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800fa8:	89 f0                	mov    %esi,%eax
  800faa:	8d 70 01             	lea    0x1(%eax),%esi
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	0f be d8             	movsbl %al,%ebx
  800fb2:	85 db                	test   %ebx,%ebx
  800fb4:	74 24                	je     800fda <vprintfmt+0x24b>
  800fb6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fba:	78 b8                	js     800f74 <vprintfmt+0x1e5>
  800fbc:	ff 4d e0             	decl   -0x20(%ebp)
  800fbf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fc3:	79 af                	jns    800f74 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc5:	eb 13                	jmp    800fda <vprintfmt+0x24b>
				putch(' ', putdat);
  800fc7:	83 ec 08             	sub    $0x8,%esp
  800fca:	ff 75 0c             	pushl  0xc(%ebp)
  800fcd:	6a 20                	push   $0x20
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	ff d0                	call   *%eax
  800fd4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fd7:	ff 4d e4             	decl   -0x1c(%ebp)
  800fda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fde:	7f e7                	jg     800fc7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fe0:	e9 66 01 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	ff 75 e8             	pushl  -0x18(%ebp)
  800feb:	8d 45 14             	lea    0x14(%ebp),%eax
  800fee:	50                   	push   %eax
  800fef:	e8 3c fd ff ff       	call   800d30 <getint>
  800ff4:	83 c4 10             	add    $0x10,%esp
  800ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffa:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801000:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801003:	85 d2                	test   %edx,%edx
  801005:	79 23                	jns    80102a <vprintfmt+0x29b>
				putch('-', putdat);
  801007:	83 ec 08             	sub    $0x8,%esp
  80100a:	ff 75 0c             	pushl  0xc(%ebp)
  80100d:	6a 2d                	push   $0x2d
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
  801012:	ff d0                	call   *%eax
  801014:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80101a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80101d:	f7 d8                	neg    %eax
  80101f:	83 d2 00             	adc    $0x0,%edx
  801022:	f7 da                	neg    %edx
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80102a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801031:	e9 bc 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	ff 75 e8             	pushl  -0x18(%ebp)
  80103c:	8d 45 14             	lea    0x14(%ebp),%eax
  80103f:	50                   	push   %eax
  801040:	e8 84 fc ff ff       	call   800cc9 <getuint>
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80104b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80104e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801055:	e9 98 00 00 00       	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80105a:	83 ec 08             	sub    $0x8,%esp
  80105d:	ff 75 0c             	pushl  0xc(%ebp)
  801060:	6a 58                	push   $0x58
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	ff d0                	call   *%eax
  801067:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106a:	83 ec 08             	sub    $0x8,%esp
  80106d:	ff 75 0c             	pushl  0xc(%ebp)
  801070:	6a 58                	push   $0x58
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	ff d0                	call   *%eax
  801077:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80107a:	83 ec 08             	sub    $0x8,%esp
  80107d:	ff 75 0c             	pushl  0xc(%ebp)
  801080:	6a 58                	push   $0x58
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	ff d0                	call   *%eax
  801087:	83 c4 10             	add    $0x10,%esp
			break;
  80108a:	e9 bc 00 00 00       	jmp    80114b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80108f:	83 ec 08             	sub    $0x8,%esp
  801092:	ff 75 0c             	pushl  0xc(%ebp)
  801095:	6a 30                	push   $0x30
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	ff d0                	call   *%eax
  80109c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80109f:	83 ec 08             	sub    $0x8,%esp
  8010a2:	ff 75 0c             	pushl  0xc(%ebp)
  8010a5:	6a 78                	push   $0x78
  8010a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010aa:	ff d0                	call   *%eax
  8010ac:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010af:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b2:	83 c0 04             	add    $0x4,%eax
  8010b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8010b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010bb:	83 e8 04             	sub    $0x4,%eax
  8010be:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010ca:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010d1:	eb 1f                	jmp    8010f2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010d3:	83 ec 08             	sub    $0x8,%esp
  8010d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8010d9:	8d 45 14             	lea    0x14(%ebp),%eax
  8010dc:	50                   	push   %eax
  8010dd:	e8 e7 fb ff ff       	call   800cc9 <getuint>
  8010e2:	83 c4 10             	add    $0x10,%esp
  8010e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010eb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010f2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010f9:	83 ec 04             	sub    $0x4,%esp
  8010fc:	52                   	push   %edx
  8010fd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801100:	50                   	push   %eax
  801101:	ff 75 f4             	pushl  -0xc(%ebp)
  801104:	ff 75 f0             	pushl  -0x10(%ebp)
  801107:	ff 75 0c             	pushl  0xc(%ebp)
  80110a:	ff 75 08             	pushl  0x8(%ebp)
  80110d:	e8 00 fb ff ff       	call   800c12 <printnum>
  801112:	83 c4 20             	add    $0x20,%esp
			break;
  801115:	eb 34                	jmp    80114b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	ff 75 0c             	pushl  0xc(%ebp)
  80111d:	53                   	push   %ebx
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	ff d0                	call   *%eax
  801123:	83 c4 10             	add    $0x10,%esp
			break;
  801126:	eb 23                	jmp    80114b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	ff 75 0c             	pushl  0xc(%ebp)
  80112e:	6a 25                	push   $0x25
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	ff d0                	call   *%eax
  801135:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801138:	ff 4d 10             	decl   0x10(%ebp)
  80113b:	eb 03                	jmp    801140 <vprintfmt+0x3b1>
  80113d:	ff 4d 10             	decl   0x10(%ebp)
  801140:	8b 45 10             	mov    0x10(%ebp),%eax
  801143:	48                   	dec    %eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 25                	cmp    $0x25,%al
  801148:	75 f3                	jne    80113d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80114a:	90                   	nop
		}
	}
  80114b:	e9 47 fc ff ff       	jmp    800d97 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801150:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801151:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801154:	5b                   	pop    %ebx
  801155:	5e                   	pop    %esi
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80115e:	8d 45 10             	lea    0x10(%ebp),%eax
  801161:	83 c0 04             	add    $0x4,%eax
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801167:	8b 45 10             	mov    0x10(%ebp),%eax
  80116a:	ff 75 f4             	pushl  -0xc(%ebp)
  80116d:	50                   	push   %eax
  80116e:	ff 75 0c             	pushl  0xc(%ebp)
  801171:	ff 75 08             	pushl  0x8(%ebp)
  801174:	e8 16 fc ff ff       	call   800d8f <vprintfmt>
  801179:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80117c:	90                   	nop
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801182:	8b 45 0c             	mov    0xc(%ebp),%eax
  801185:	8b 40 08             	mov    0x8(%eax),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 10                	mov    (%eax),%edx
  801196:	8b 45 0c             	mov    0xc(%ebp),%eax
  801199:	8b 40 04             	mov    0x4(%eax),%eax
  80119c:	39 c2                	cmp    %eax,%edx
  80119e:	73 12                	jae    8011b2 <sprintputch+0x33>
		*b->buf++ = ch;
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	8b 00                	mov    (%eax),%eax
  8011a5:	8d 48 01             	lea    0x1(%eax),%ecx
  8011a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011ab:	89 0a                	mov    %ecx,(%edx)
  8011ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b0:	88 10                	mov    %dl,(%eax)
}
  8011b2:	90                   	nop
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 d0                	add    %edx,%eax
  8011cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011da:	74 06                	je     8011e2 <vsnprintf+0x2d>
  8011dc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011e0:	7f 07                	jg     8011e9 <vsnprintf+0x34>
		return -E_INVAL;
  8011e2:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e7:	eb 20                	jmp    801209 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011e9:	ff 75 14             	pushl  0x14(%ebp)
  8011ec:	ff 75 10             	pushl  0x10(%ebp)
  8011ef:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011f2:	50                   	push   %eax
  8011f3:	68 7f 11 80 00       	push   $0x80117f
  8011f8:	e8 92 fb ff ff       	call   800d8f <vprintfmt>
  8011fd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801200:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801206:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801209:	c9                   	leave  
  80120a:	c3                   	ret    

0080120b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80120b:	55                   	push   %ebp
  80120c:	89 e5                	mov    %esp,%ebp
  80120e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801211:	8d 45 10             	lea    0x10(%ebp),%eax
  801214:	83 c0 04             	add    $0x4,%eax
  801217:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80121a:	8b 45 10             	mov    0x10(%ebp),%eax
  80121d:	ff 75 f4             	pushl  -0xc(%ebp)
  801220:	50                   	push   %eax
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	ff 75 08             	pushl  0x8(%ebp)
  801227:	e8 89 ff ff ff       	call   8011b5 <vsnprintf>
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801235:	c9                   	leave  
  801236:	c3                   	ret    

00801237 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
  80123a:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  80123d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801241:	74 13                	je     801256 <readline+0x1f>
		cprintf("%s", prompt);
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	ff 75 08             	pushl  0x8(%ebp)
  801249:	68 b0 42 80 00       	push   $0x8042b0
  80124e:	e8 62 f9 ff ff       	call   800bb5 <cprintf>
  801253:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  80125d:	83 ec 0c             	sub    $0xc,%esp
  801260:	6a 00                	push   $0x0
  801262:	e8 54 f5 ff ff       	call   8007bb <iscons>
  801267:	83 c4 10             	add    $0x10,%esp
  80126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80126d:	e8 fb f4 ff ff       	call   80076d <getchar>
  801272:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801275:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801279:	79 22                	jns    80129d <readline+0x66>
			if (c != -E_EOF)
  80127b:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80127f:	0f 84 ad 00 00 00    	je     801332 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801285:	83 ec 08             	sub    $0x8,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	68 b3 42 80 00       	push   $0x8042b3
  801290:	e8 20 f9 ff ff       	call   800bb5 <cprintf>
  801295:	83 c4 10             	add    $0x10,%esp
			return;
  801298:	e9 95 00 00 00       	jmp    801332 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80129d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8012a1:	7e 34                	jle    8012d7 <readline+0xa0>
  8012a3:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8012aa:	7f 2b                	jg     8012d7 <readline+0xa0>
			if (echoing)
  8012ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012b0:	74 0e                	je     8012c0 <readline+0x89>
				cputchar(c);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b8:	e8 68 f4 ff ff       	call   800725 <cputchar>
  8012bd:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8012c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c3:	8d 50 01             	lea    0x1(%eax),%edx
  8012c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8012c9:	89 c2                	mov    %eax,%edx
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012d3:	88 10                	mov    %dl,(%eax)
  8012d5:	eb 56                	jmp    80132d <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012d7:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012db:	75 1f                	jne    8012fc <readline+0xc5>
  8012dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012e1:	7e 19                	jle    8012fc <readline+0xc5>
			if (echoing)
  8012e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e7:	74 0e                	je     8012f7 <readline+0xc0>
				cputchar(c);
  8012e9:	83 ec 0c             	sub    $0xc,%esp
  8012ec:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ef:	e8 31 f4 ff ff       	call   800725 <cputchar>
  8012f4:	83 c4 10             	add    $0x10,%esp

			i--;
  8012f7:	ff 4d f4             	decl   -0xc(%ebp)
  8012fa:	eb 31                	jmp    80132d <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012fc:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801300:	74 0a                	je     80130c <readline+0xd5>
  801302:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  801306:	0f 85 61 ff ff ff    	jne    80126d <readline+0x36>
			if (echoing)
  80130c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801310:	74 0e                	je     801320 <readline+0xe9>
				cputchar(c);
  801312:	83 ec 0c             	sub    $0xc,%esp
  801315:	ff 75 ec             	pushl  -0x14(%ebp)
  801318:	e8 08 f4 ff ff       	call   800725 <cputchar>
  80131d:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 d0                	add    %edx,%eax
  801328:	c6 00 00             	movb   $0x0,(%eax)
			return;
  80132b:	eb 06                	jmp    801333 <readline+0xfc>
		}
	}
  80132d:	e9 3b ff ff ff       	jmp    80126d <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801332:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80133b:	e8 a5 0f 00 00       	call   8022e5 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801340:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801344:	74 13                	je     801359 <atomic_readline+0x24>
		cprintf("%s", prompt);
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	ff 75 08             	pushl  0x8(%ebp)
  80134c:	68 b0 42 80 00       	push   $0x8042b0
  801351:	e8 5f f8 ff ff       	call   800bb5 <cprintf>
  801356:	83 c4 10             	add    $0x10,%esp

	i = 0;
  801359:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801360:	83 ec 0c             	sub    $0xc,%esp
  801363:	6a 00                	push   $0x0
  801365:	e8 51 f4 ff ff       	call   8007bb <iscons>
  80136a:	83 c4 10             	add    $0x10,%esp
  80136d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801370:	e8 f8 f3 ff ff       	call   80076d <getchar>
  801375:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801378:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80137c:	79 23                	jns    8013a1 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80137e:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801382:	74 13                	je     801397 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801384:	83 ec 08             	sub    $0x8,%esp
  801387:	ff 75 ec             	pushl  -0x14(%ebp)
  80138a:	68 b3 42 80 00       	push   $0x8042b3
  80138f:	e8 21 f8 ff ff       	call   800bb5 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801397:	e8 63 0f 00 00       	call   8022ff <sys_enable_interrupt>
			return;
  80139c:	e9 9a 00 00 00       	jmp    80143b <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8013a1:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8013a5:	7e 34                	jle    8013db <atomic_readline+0xa6>
  8013a7:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8013ae:	7f 2b                	jg     8013db <atomic_readline+0xa6>
			if (echoing)
  8013b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b4:	74 0e                	je     8013c4 <atomic_readline+0x8f>
				cputchar(c);
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8013bc:	e8 64 f3 ff ff       	call   800725 <cputchar>
  8013c1:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8013c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013c7:	8d 50 01             	lea    0x1(%eax),%edx
  8013ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013cd:	89 c2                	mov    %eax,%edx
  8013cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d2:	01 d0                	add    %edx,%eax
  8013d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d7:	88 10                	mov    %dl,(%eax)
  8013d9:	eb 5b                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013db:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013df:	75 1f                	jne    801400 <atomic_readline+0xcb>
  8013e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013e5:	7e 19                	jle    801400 <atomic_readline+0xcb>
			if (echoing)
  8013e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013eb:	74 0e                	je     8013fb <atomic_readline+0xc6>
				cputchar(c);
  8013ed:	83 ec 0c             	sub    $0xc,%esp
  8013f0:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f3:	e8 2d f3 ff ff       	call   800725 <cputchar>
  8013f8:	83 c4 10             	add    $0x10,%esp
			i--;
  8013fb:	ff 4d f4             	decl   -0xc(%ebp)
  8013fe:	eb 36                	jmp    801436 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801400:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801404:	74 0a                	je     801410 <atomic_readline+0xdb>
  801406:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80140a:	0f 85 60 ff ff ff    	jne    801370 <atomic_readline+0x3b>
			if (echoing)
  801410:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801414:	74 0e                	je     801424 <atomic_readline+0xef>
				cputchar(c);
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	ff 75 ec             	pushl  -0x14(%ebp)
  80141c:	e8 04 f3 ff ff       	call   800725 <cputchar>
  801421:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801424:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142a:	01 d0                	add    %edx,%eax
  80142c:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  80142f:	e8 cb 0e 00 00       	call   8022ff <sys_enable_interrupt>
			return;
  801434:	eb 05                	jmp    80143b <atomic_readline+0x106>
		}
	}
  801436:	e9 35 ff ff ff       	jmp    801370 <atomic_readline+0x3b>
}
  80143b:	c9                   	leave  
  80143c:	c3                   	ret    

0080143d <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80143d:	55                   	push   %ebp
  80143e:	89 e5                	mov    %esp,%ebp
  801440:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801443:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144a:	eb 06                	jmp    801452 <strlen+0x15>
		n++;
  80144c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	84 c0                	test   %al,%al
  801459:	75 f1                	jne    80144c <strlen+0xf>
		n++;
	return n;
  80145b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80145e:	c9                   	leave  
  80145f:	c3                   	ret    

00801460 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801466:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80146d:	eb 09                	jmp    801478 <strnlen+0x18>
		n++;
  80146f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801472:	ff 45 08             	incl   0x8(%ebp)
  801475:	ff 4d 0c             	decl   0xc(%ebp)
  801478:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80147c:	74 09                	je     801487 <strnlen+0x27>
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
  801481:	8a 00                	mov    (%eax),%al
  801483:	84 c0                	test   %al,%al
  801485:	75 e8                	jne    80146f <strnlen+0xf>
		n++;
	return n;
  801487:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801498:	90                   	nop
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	8d 50 01             	lea    0x1(%eax),%edx
  80149f:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014a5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014ab:	8a 12                	mov    (%edx),%dl
  8014ad:	88 10                	mov    %dl,(%eax)
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	84 c0                	test   %al,%al
  8014b3:	75 e4                	jne    801499 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8014b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014b8:	c9                   	leave  
  8014b9:	c3                   	ret    

008014ba <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8014ba:	55                   	push   %ebp
  8014bb:	89 e5                	mov    %esp,%ebp
  8014bd:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8014c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014cd:	eb 1f                	jmp    8014ee <strncpy+0x34>
		*dst++ = *src;
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8d 50 01             	lea    0x1(%eax),%edx
  8014d5:	89 55 08             	mov    %edx,0x8(%ebp)
  8014d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014db:	8a 12                	mov    (%edx),%dl
  8014dd:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e2:	8a 00                	mov    (%eax),%al
  8014e4:	84 c0                	test   %al,%al
  8014e6:	74 03                	je     8014eb <strncpy+0x31>
			src++;
  8014e8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014eb:	ff 45 fc             	incl   -0x4(%ebp)
  8014ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f4:	72 d9                	jb     8014cf <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f9:	c9                   	leave  
  8014fa:	c3                   	ret    

008014fb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014fb:	55                   	push   %ebp
  8014fc:	89 e5                	mov    %esp,%ebp
  8014fe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801501:	8b 45 08             	mov    0x8(%ebp),%eax
  801504:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150b:	74 30                	je     80153d <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80150d:	eb 16                	jmp    801525 <strlcpy+0x2a>
			*dst++ = *src++;
  80150f:	8b 45 08             	mov    0x8(%ebp),%eax
  801512:	8d 50 01             	lea    0x1(%eax),%edx
  801515:	89 55 08             	mov    %edx,0x8(%ebp)
  801518:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801521:	8a 12                	mov    (%edx),%dl
  801523:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801525:	ff 4d 10             	decl   0x10(%ebp)
  801528:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152c:	74 09                	je     801537 <strlcpy+0x3c>
  80152e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801531:	8a 00                	mov    (%eax),%al
  801533:	84 c0                	test   %al,%al
  801535:	75 d8                	jne    80150f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801537:	8b 45 08             	mov    0x8(%ebp),%eax
  80153a:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80153d:	8b 55 08             	mov    0x8(%ebp),%edx
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	29 c2                	sub    %eax,%edx
  801545:	89 d0                	mov    %edx,%eax
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80154c:	eb 06                	jmp    801554 <strcmp+0xb>
		p++, q++;
  80154e:	ff 45 08             	incl   0x8(%ebp)
  801551:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	8a 00                	mov    (%eax),%al
  801559:	84 c0                	test   %al,%al
  80155b:	74 0e                	je     80156b <strcmp+0x22>
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	8a 10                	mov    (%eax),%dl
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	38 c2                	cmp    %al,%dl
  801569:	74 e3                	je     80154e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f b6 d0             	movzbl %al,%edx
  801573:	8b 45 0c             	mov    0xc(%ebp),%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	0f b6 c0             	movzbl %al,%eax
  80157b:	29 c2                	sub    %eax,%edx
  80157d:	89 d0                	mov    %edx,%eax
}
  80157f:	5d                   	pop    %ebp
  801580:	c3                   	ret    

00801581 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801584:	eb 09                	jmp    80158f <strncmp+0xe>
		n--, p++, q++;
  801586:	ff 4d 10             	decl   0x10(%ebp)
  801589:	ff 45 08             	incl   0x8(%ebp)
  80158c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80158f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801593:	74 17                	je     8015ac <strncmp+0x2b>
  801595:	8b 45 08             	mov    0x8(%ebp),%eax
  801598:	8a 00                	mov    (%eax),%al
  80159a:	84 c0                	test   %al,%al
  80159c:	74 0e                	je     8015ac <strncmp+0x2b>
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8a 10                	mov    (%eax),%dl
  8015a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a6:	8a 00                	mov    (%eax),%al
  8015a8:	38 c2                	cmp    %al,%dl
  8015aa:	74 da                	je     801586 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8015ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015b0:	75 07                	jne    8015b9 <strncmp+0x38>
		return 0;
  8015b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b7:	eb 14                	jmp    8015cd <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bc:	8a 00                	mov    (%eax),%al
  8015be:	0f b6 d0             	movzbl %al,%edx
  8015c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c4:	8a 00                	mov    (%eax),%al
  8015c6:	0f b6 c0             	movzbl %al,%eax
  8015c9:	29 c2                	sub    %eax,%edx
  8015cb:	89 d0                	mov    %edx,%eax
}
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	83 ec 04             	sub    $0x4,%esp
  8015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015db:	eb 12                	jmp    8015ef <strchr+0x20>
		if (*s == c)
  8015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e0:	8a 00                	mov    (%eax),%al
  8015e2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015e5:	75 05                	jne    8015ec <strchr+0x1d>
			return (char *) s;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	eb 11                	jmp    8015fd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015ec:	ff 45 08             	incl   0x8(%ebp)
  8015ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f2:	8a 00                	mov    (%eax),%al
  8015f4:	84 c0                	test   %al,%al
  8015f6:	75 e5                	jne    8015dd <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015fd:	c9                   	leave  
  8015fe:	c3                   	ret    

008015ff <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	83 ec 04             	sub    $0x4,%esp
  801605:	8b 45 0c             	mov    0xc(%ebp),%eax
  801608:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80160b:	eb 0d                	jmp    80161a <strfind+0x1b>
		if (*s == c)
  80160d:	8b 45 08             	mov    0x8(%ebp),%eax
  801610:	8a 00                	mov    (%eax),%al
  801612:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801615:	74 0e                	je     801625 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801617:	ff 45 08             	incl   0x8(%ebp)
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	84 c0                	test   %al,%al
  801621:	75 ea                	jne    80160d <strfind+0xe>
  801623:	eb 01                	jmp    801626 <strfind+0x27>
		if (*s == c)
			break;
  801625:	90                   	nop
	return (char *) s;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
  80162e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801631:	8b 45 08             	mov    0x8(%ebp),%eax
  801634:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801637:	8b 45 10             	mov    0x10(%ebp),%eax
  80163a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80163d:	eb 0e                	jmp    80164d <memset+0x22>
		*p++ = c;
  80163f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801642:	8d 50 01             	lea    0x1(%eax),%edx
  801645:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801648:	8b 55 0c             	mov    0xc(%ebp),%edx
  80164b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80164d:	ff 4d f8             	decl   -0x8(%ebp)
  801650:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801654:	79 e9                	jns    80163f <memset+0x14>
		*p++ = c;

	return v;
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801659:	c9                   	leave  
  80165a:	c3                   	ret    

0080165b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801661:	8b 45 0c             	mov    0xc(%ebp),%eax
  801664:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801667:	8b 45 08             	mov    0x8(%ebp),%eax
  80166a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80166d:	eb 16                	jmp    801685 <memcpy+0x2a>
		*d++ = *s++;
  80166f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801672:	8d 50 01             	lea    0x1(%eax),%edx
  801675:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801678:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80167e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801681:	8a 12                	mov    (%edx),%dl
  801683:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	8d 50 ff             	lea    -0x1(%eax),%edx
  80168b:	89 55 10             	mov    %edx,0x10(%ebp)
  80168e:	85 c0                	test   %eax,%eax
  801690:	75 dd                	jne    80166f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801695:	c9                   	leave  
  801696:	c3                   	ret    

00801697 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80169d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8016a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8016a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016af:	73 50                	jae    801701 <memmove+0x6a>
  8016b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b7:	01 d0                	add    %edx,%eax
  8016b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8016bc:	76 43                	jbe    801701 <memmove+0x6a>
		s += n;
  8016be:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c1:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8016c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c7:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016ca:	eb 10                	jmp    8016dc <memmove+0x45>
			*--d = *--s;
  8016cc:	ff 4d f8             	decl   -0x8(%ebp)
  8016cf:	ff 4d fc             	decl   -0x4(%ebp)
  8016d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d5:	8a 10                	mov    (%eax),%dl
  8016d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016da:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8016df:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e2:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	75 e3                	jne    8016cc <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016e9:	eb 23                	jmp    80170e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ee:	8d 50 01             	lea    0x1(%eax),%edx
  8016f1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016fa:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016fd:	8a 12                	mov    (%edx),%dl
  8016ff:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	8d 50 ff             	lea    -0x1(%eax),%edx
  801707:	89 55 10             	mov    %edx,0x10(%ebp)
  80170a:	85 c0                	test   %eax,%eax
  80170c:	75 dd                	jne    8016eb <memmove+0x54>
			*d++ = *s++;

	return dst;
  80170e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80171f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801722:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801725:	eb 2a                	jmp    801751 <memcmp+0x3e>
		if (*s1 != *s2)
  801727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80172a:	8a 10                	mov    (%eax),%dl
  80172c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	38 c2                	cmp    %al,%dl
  801733:	74 16                	je     80174b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801738:	8a 00                	mov    (%eax),%al
  80173a:	0f b6 d0             	movzbl %al,%edx
  80173d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801740:	8a 00                	mov    (%eax),%al
  801742:	0f b6 c0             	movzbl %al,%eax
  801745:	29 c2                	sub    %eax,%edx
  801747:	89 d0                	mov    %edx,%eax
  801749:	eb 18                	jmp    801763 <memcmp+0x50>
		s1++, s2++;
  80174b:	ff 45 fc             	incl   -0x4(%ebp)
  80174e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801751:	8b 45 10             	mov    0x10(%ebp),%eax
  801754:	8d 50 ff             	lea    -0x1(%eax),%edx
  801757:	89 55 10             	mov    %edx,0x10(%ebp)
  80175a:	85 c0                	test   %eax,%eax
  80175c:	75 c9                	jne    801727 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801763:	c9                   	leave  
  801764:	c3                   	ret    

00801765 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80176b:	8b 55 08             	mov    0x8(%ebp),%edx
  80176e:	8b 45 10             	mov    0x10(%ebp),%eax
  801771:	01 d0                	add    %edx,%eax
  801773:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801776:	eb 15                	jmp    80178d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801778:	8b 45 08             	mov    0x8(%ebp),%eax
  80177b:	8a 00                	mov    (%eax),%al
  80177d:	0f b6 d0             	movzbl %al,%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	0f b6 c0             	movzbl %al,%eax
  801786:	39 c2                	cmp    %eax,%edx
  801788:	74 0d                	je     801797 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80178a:	ff 45 08             	incl   0x8(%ebp)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801793:	72 e3                	jb     801778 <memfind+0x13>
  801795:	eb 01                	jmp    801798 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801797:	90                   	nop
	return (void *) s;
  801798:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8017a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8017aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b1:	eb 03                	jmp    8017b6 <strtol+0x19>
		s++;
  8017b3:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	8a 00                	mov    (%eax),%al
  8017bb:	3c 20                	cmp    $0x20,%al
  8017bd:	74 f4                	je     8017b3 <strtol+0x16>
  8017bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c2:	8a 00                	mov    (%eax),%al
  8017c4:	3c 09                	cmp    $0x9,%al
  8017c6:	74 eb                	je     8017b3 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8a 00                	mov    (%eax),%al
  8017cd:	3c 2b                	cmp    $0x2b,%al
  8017cf:	75 05                	jne    8017d6 <strtol+0x39>
		s++;
  8017d1:	ff 45 08             	incl   0x8(%ebp)
  8017d4:	eb 13                	jmp    8017e9 <strtol+0x4c>
	else if (*s == '-')
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	3c 2d                	cmp    $0x2d,%al
  8017dd:	75 0a                	jne    8017e9 <strtol+0x4c>
		s++, neg = 1;
  8017df:	ff 45 08             	incl   0x8(%ebp)
  8017e2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ed:	74 06                	je     8017f5 <strtol+0x58>
  8017ef:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017f3:	75 20                	jne    801815 <strtol+0x78>
  8017f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f8:	8a 00                	mov    (%eax),%al
  8017fa:	3c 30                	cmp    $0x30,%al
  8017fc:	75 17                	jne    801815 <strtol+0x78>
  8017fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801801:	40                   	inc    %eax
  801802:	8a 00                	mov    (%eax),%al
  801804:	3c 78                	cmp    $0x78,%al
  801806:	75 0d                	jne    801815 <strtol+0x78>
		s += 2, base = 16;
  801808:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80180c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801813:	eb 28                	jmp    80183d <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801819:	75 15                	jne    801830 <strtol+0x93>
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8a 00                	mov    (%eax),%al
  801820:	3c 30                	cmp    $0x30,%al
  801822:	75 0c                	jne    801830 <strtol+0x93>
		s++, base = 8;
  801824:	ff 45 08             	incl   0x8(%ebp)
  801827:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80182e:	eb 0d                	jmp    80183d <strtol+0xa0>
	else if (base == 0)
  801830:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801834:	75 07                	jne    80183d <strtol+0xa0>
		base = 10;
  801836:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	3c 2f                	cmp    $0x2f,%al
  801844:	7e 19                	jle    80185f <strtol+0xc2>
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	8a 00                	mov    (%eax),%al
  80184b:	3c 39                	cmp    $0x39,%al
  80184d:	7f 10                	jg     80185f <strtol+0xc2>
			dig = *s - '0';
  80184f:	8b 45 08             	mov    0x8(%ebp),%eax
  801852:	8a 00                	mov    (%eax),%al
  801854:	0f be c0             	movsbl %al,%eax
  801857:	83 e8 30             	sub    $0x30,%eax
  80185a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80185d:	eb 42                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	8a 00                	mov    (%eax),%al
  801864:	3c 60                	cmp    $0x60,%al
  801866:	7e 19                	jle    801881 <strtol+0xe4>
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8a 00                	mov    (%eax),%al
  80186d:	3c 7a                	cmp    $0x7a,%al
  80186f:	7f 10                	jg     801881 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801871:	8b 45 08             	mov    0x8(%ebp),%eax
  801874:	8a 00                	mov    (%eax),%al
  801876:	0f be c0             	movsbl %al,%eax
  801879:	83 e8 57             	sub    $0x57,%eax
  80187c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80187f:	eb 20                	jmp    8018a1 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	8a 00                	mov    (%eax),%al
  801886:	3c 40                	cmp    $0x40,%al
  801888:	7e 39                	jle    8018c3 <strtol+0x126>
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8a 00                	mov    (%eax),%al
  80188f:	3c 5a                	cmp    $0x5a,%al
  801891:	7f 30                	jg     8018c3 <strtol+0x126>
			dig = *s - 'A' + 10;
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8a 00                	mov    (%eax),%al
  801898:	0f be c0             	movsbl %al,%eax
  80189b:	83 e8 37             	sub    $0x37,%eax
  80189e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8018a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a4:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018a7:	7d 19                	jge    8018c2 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8018a9:	ff 45 08             	incl   0x8(%ebp)
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	0f af 45 10          	imul   0x10(%ebp),%eax
  8018b3:	89 c2                	mov    %eax,%edx
  8018b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b8:	01 d0                	add    %edx,%eax
  8018ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8018bd:	e9 7b ff ff ff       	jmp    80183d <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8018c2:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8018c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018c7:	74 08                	je     8018d1 <strtol+0x134>
		*endptr = (char *) s;
  8018c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018cf:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018d1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018d5:	74 07                	je     8018de <strtol+0x141>
  8018d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018da:	f7 d8                	neg    %eax
  8018dc:	eb 03                	jmp    8018e1 <strtol+0x144>
  8018de:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <ltostr>:

void
ltostr(long value, char *str)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018fb:	79 13                	jns    801910 <ltostr+0x2d>
	{
		neg = 1;
  8018fd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80190a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80190d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801918:	99                   	cltd   
  801919:	f7 f9                	idiv   %ecx
  80191b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80191e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801921:	8d 50 01             	lea    0x1(%eax),%edx
  801924:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801927:	89 c2                	mov    %eax,%edx
  801929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192c:	01 d0                	add    %edx,%eax
  80192e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801931:	83 c2 30             	add    $0x30,%edx
  801934:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801936:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801939:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80193e:	f7 e9                	imul   %ecx
  801940:	c1 fa 02             	sar    $0x2,%edx
  801943:	89 c8                	mov    %ecx,%eax
  801945:	c1 f8 1f             	sar    $0x1f,%eax
  801948:	29 c2                	sub    %eax,%edx
  80194a:	89 d0                	mov    %edx,%eax
  80194c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80194f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801952:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801957:	f7 e9                	imul   %ecx
  801959:	c1 fa 02             	sar    $0x2,%edx
  80195c:	89 c8                	mov    %ecx,%eax
  80195e:	c1 f8 1f             	sar    $0x1f,%eax
  801961:	29 c2                	sub    %eax,%edx
  801963:	89 d0                	mov    %edx,%eax
  801965:	c1 e0 02             	shl    $0x2,%eax
  801968:	01 d0                	add    %edx,%eax
  80196a:	01 c0                	add    %eax,%eax
  80196c:	29 c1                	sub    %eax,%ecx
  80196e:	89 ca                	mov    %ecx,%edx
  801970:	85 d2                	test   %edx,%edx
  801972:	75 9c                	jne    801910 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801974:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80197b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197e:	48                   	dec    %eax
  80197f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801982:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801986:	74 3d                	je     8019c5 <ltostr+0xe2>
		start = 1 ;
  801988:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80198f:	eb 34                	jmp    8019c5 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801991:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	01 d0                	add    %edx,%eax
  801999:	8a 00                	mov    (%eax),%al
  80199b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	01 c2                	add    %eax,%edx
  8019a6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8019a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ac:	01 c8                	add    %ecx,%eax
  8019ae:	8a 00                	mov    (%eax),%al
  8019b0:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8019b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b8:	01 c2                	add    %eax,%edx
  8019ba:	8a 45 eb             	mov    -0x15(%ebp),%al
  8019bd:	88 02                	mov    %al,(%edx)
		start++ ;
  8019bf:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8019c2:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019cb:	7c c4                	jl     801991 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019cd:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	01 d0                	add    %edx,%eax
  8019d5:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019d8:	90                   	nop
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 54 fa ff ff       	call   80143d <strlen>
  8019e9:	83 c4 04             	add    $0x4,%esp
  8019ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	e8 46 fa ff ff       	call   80143d <strlen>
  8019f7:	83 c4 04             	add    $0x4,%esp
  8019fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019fd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801a0b:	eb 17                	jmp    801a24 <strcconcat+0x49>
		final[s] = str1[s] ;
  801a0d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a10:	8b 45 10             	mov    0x10(%ebp),%eax
  801a13:	01 c2                	add    %eax,%edx
  801a15:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	01 c8                	add    %ecx,%eax
  801a1d:	8a 00                	mov    (%eax),%al
  801a1f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801a21:	ff 45 fc             	incl   -0x4(%ebp)
  801a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a27:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a2a:	7c e1                	jl     801a0d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a2c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a3a:	eb 1f                	jmp    801a5b <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a3f:	8d 50 01             	lea    0x1(%eax),%edx
  801a42:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a45:	89 c2                	mov    %eax,%edx
  801a47:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4a:	01 c2                	add    %eax,%edx
  801a4c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a52:	01 c8                	add    %ecx,%eax
  801a54:	8a 00                	mov    (%eax),%al
  801a56:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a58:	ff 45 f8             	incl   -0x8(%ebp)
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a61:	7c d9                	jl     801a3c <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a63:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a66:	8b 45 10             	mov    0x10(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	c6 00 00             	movb   $0x0,(%eax)
}
  801a6e:	90                   	nop
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a74:	8b 45 14             	mov    0x14(%ebp),%eax
  801a77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a89:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8c:	01 d0                	add    %edx,%eax
  801a8e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a94:	eb 0c                	jmp    801aa2 <strsplit+0x31>
			*string++ = 0;
  801a96:	8b 45 08             	mov    0x8(%ebp),%eax
  801a99:	8d 50 01             	lea    0x1(%eax),%edx
  801a9c:	89 55 08             	mov    %edx,0x8(%ebp)
  801a9f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	8a 00                	mov    (%eax),%al
  801aa7:	84 c0                	test   %al,%al
  801aa9:	74 18                	je     801ac3 <strsplit+0x52>
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	8a 00                	mov    (%eax),%al
  801ab0:	0f be c0             	movsbl %al,%eax
  801ab3:	50                   	push   %eax
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	e8 13 fb ff ff       	call   8015cf <strchr>
  801abc:	83 c4 08             	add    $0x8,%esp
  801abf:	85 c0                	test   %eax,%eax
  801ac1:	75 d3                	jne    801a96 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	8a 00                	mov    (%eax),%al
  801ac8:	84 c0                	test   %al,%al
  801aca:	74 5a                	je     801b26 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801acc:	8b 45 14             	mov    0x14(%ebp),%eax
  801acf:	8b 00                	mov    (%eax),%eax
  801ad1:	83 f8 0f             	cmp    $0xf,%eax
  801ad4:	75 07                	jne    801add <strsplit+0x6c>
		{
			return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  801adb:	eb 66                	jmp    801b43 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801add:	8b 45 14             	mov    0x14(%ebp),%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	8d 48 01             	lea    0x1(%eax),%ecx
  801ae5:	8b 55 14             	mov    0x14(%ebp),%edx
  801ae8:	89 0a                	mov    %ecx,(%edx)
  801aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801af1:	8b 45 10             	mov    0x10(%ebp),%eax
  801af4:	01 c2                	add    %eax,%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801afb:	eb 03                	jmp    801b00 <strsplit+0x8f>
			string++;
  801afd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8a 00                	mov    (%eax),%al
  801b05:	84 c0                	test   %al,%al
  801b07:	74 8b                	je     801a94 <strsplit+0x23>
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	8a 00                	mov    (%eax),%al
  801b0e:	0f be c0             	movsbl %al,%eax
  801b11:	50                   	push   %eax
  801b12:	ff 75 0c             	pushl  0xc(%ebp)
  801b15:	e8 b5 fa ff ff       	call   8015cf <strchr>
  801b1a:	83 c4 08             	add    $0x8,%esp
  801b1d:	85 c0                	test   %eax,%eax
  801b1f:	74 dc                	je     801afd <strsplit+0x8c>
			string++;
	}
  801b21:	e9 6e ff ff ff       	jmp    801a94 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801b26:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801b27:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2a:	8b 00                	mov    (%eax),%eax
  801b2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b33:	8b 45 10             	mov    0x10(%ebp),%eax
  801b36:	01 d0                	add    %edx,%eax
  801b38:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b3e:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b43:	c9                   	leave  
  801b44:	c3                   	ret    

00801b45 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b4b:	a1 04 50 80 00       	mov    0x805004,%eax
  801b50:	85 c0                	test   %eax,%eax
  801b52:	74 1f                	je     801b73 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b54:	e8 1d 00 00 00       	call   801b76 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	68 c4 42 80 00       	push   $0x8042c4
  801b61:	e8 4f f0 ff ff       	call   800bb5 <cprintf>
  801b66:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b69:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b70:	00 00 00 
	}
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801b7c:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b83:	00 00 00 
  801b86:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b8d:	00 00 00 
  801b90:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b97:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b9a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801ba1:	00 00 00 
  801ba4:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801bab:	00 00 00 
  801bae:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801bb5:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801bb8:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc2:	c1 e8 0c             	shr    $0xc,%eax
  801bc5:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801bca:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801bd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bd4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bd9:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bde:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801be3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801bea:	a1 20 51 80 00       	mov    0x805120,%eax
  801bef:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801bf3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801bf6:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801bfd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801c00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c03:	01 d0                	add    %edx,%eax
  801c05:	48                   	dec    %eax
  801c06:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c11:	f7 75 e4             	divl   -0x1c(%ebp)
  801c14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801c17:	29 d0                	sub    %edx,%eax
  801c19:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801c1c:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801c23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801c26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c2b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c30:	83 ec 04             	sub    $0x4,%esp
  801c33:	6a 07                	push   $0x7
  801c35:	ff 75 e8             	pushl  -0x18(%ebp)
  801c38:	50                   	push   %eax
  801c39:	e8 3d 06 00 00       	call   80227b <sys_allocate_chunk>
  801c3e:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c41:	a1 20 51 80 00       	mov    0x805120,%eax
  801c46:	83 ec 0c             	sub    $0xc,%esp
  801c49:	50                   	push   %eax
  801c4a:	e8 b2 0c 00 00       	call   802901 <initialize_MemBlocksList>
  801c4f:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801c52:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801c57:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801c5a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c5e:	0f 84 f3 00 00 00    	je     801d57 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801c64:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c68:	75 14                	jne    801c7e <initialize_dyn_block_system+0x108>
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	68 e9 42 80 00       	push   $0x8042e9
  801c72:	6a 36                	push   $0x36
  801c74:	68 07 43 80 00       	push   $0x804307
  801c79:	e8 83 ec ff ff       	call   800901 <_panic>
  801c7e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c81:	8b 00                	mov    (%eax),%eax
  801c83:	85 c0                	test   %eax,%eax
  801c85:	74 10                	je     801c97 <initialize_dyn_block_system+0x121>
  801c87:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c8a:	8b 00                	mov    (%eax),%eax
  801c8c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c8f:	8b 52 04             	mov    0x4(%edx),%edx
  801c92:	89 50 04             	mov    %edx,0x4(%eax)
  801c95:	eb 0b                	jmp    801ca2 <initialize_dyn_block_system+0x12c>
  801c97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c9a:	8b 40 04             	mov    0x4(%eax),%eax
  801c9d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ca2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ca5:	8b 40 04             	mov    0x4(%eax),%eax
  801ca8:	85 c0                	test   %eax,%eax
  801caa:	74 0f                	je     801cbb <initialize_dyn_block_system+0x145>
  801cac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801caf:	8b 40 04             	mov    0x4(%eax),%eax
  801cb2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cb5:	8b 12                	mov    (%edx),%edx
  801cb7:	89 10                	mov    %edx,(%eax)
  801cb9:	eb 0a                	jmp    801cc5 <initialize_dyn_block_system+0x14f>
  801cbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cbe:	8b 00                	mov    (%eax),%eax
  801cc0:	a3 48 51 80 00       	mov    %eax,0x805148
  801cc5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cd8:	a1 54 51 80 00       	mov    0x805154,%eax
  801cdd:	48                   	dec    %eax
  801cde:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801ce3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ce6:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801ced:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cf0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801cf7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801cfb:	75 14                	jne    801d11 <initialize_dyn_block_system+0x19b>
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	68 14 43 80 00       	push   $0x804314
  801d05:	6a 3e                	push   $0x3e
  801d07:	68 07 43 80 00       	push   $0x804307
  801d0c:	e8 f0 eb ff ff       	call   800901 <_panic>
  801d11:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801d17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d1a:	89 10                	mov    %edx,(%eax)
  801d1c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d1f:	8b 00                	mov    (%eax),%eax
  801d21:	85 c0                	test   %eax,%eax
  801d23:	74 0d                	je     801d32 <initialize_dyn_block_system+0x1bc>
  801d25:	a1 38 51 80 00       	mov    0x805138,%eax
  801d2a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d2d:	89 50 04             	mov    %edx,0x4(%eax)
  801d30:	eb 08                	jmp    801d3a <initialize_dyn_block_system+0x1c4>
  801d32:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d35:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801d3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d3d:	a3 38 51 80 00       	mov    %eax,0x805138
  801d42:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d4c:	a1 44 51 80 00       	mov    0x805144,%eax
  801d51:	40                   	inc    %eax
  801d52:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801d57:	90                   	nop
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801d60:	e8 e0 fd ff ff       	call   801b45 <InitializeUHeap>
		if (size == 0) return NULL ;
  801d65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d69:	75 07                	jne    801d72 <malloc+0x18>
  801d6b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d70:	eb 7f                	jmp    801df1 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d72:	e8 d2 08 00 00       	call   802649 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d77:	85 c0                	test   %eax,%eax
  801d79:	74 71                	je     801dec <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801d7b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d82:	8b 55 08             	mov    0x8(%ebp),%edx
  801d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d88:	01 d0                	add    %edx,%eax
  801d8a:	48                   	dec    %eax
  801d8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d91:	ba 00 00 00 00       	mov    $0x0,%edx
  801d96:	f7 75 f4             	divl   -0xc(%ebp)
  801d99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d9c:	29 d0                	sub    %edx,%eax
  801d9e:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801da1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801da8:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801daf:	76 07                	jbe    801db8 <malloc+0x5e>
					return NULL ;
  801db1:	b8 00 00 00 00       	mov    $0x0,%eax
  801db6:	eb 39                	jmp    801df1 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801db8:	83 ec 0c             	sub    $0xc,%esp
  801dbb:	ff 75 08             	pushl  0x8(%ebp)
  801dbe:	e8 e6 0d 00 00       	call   802ba9 <alloc_block_FF>
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801dc9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801dcd:	74 16                	je     801de5 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801dcf:	83 ec 0c             	sub    $0xc,%esp
  801dd2:	ff 75 ec             	pushl  -0x14(%ebp)
  801dd5:	e8 37 0c 00 00       	call   802a11 <insert_sorted_allocList>
  801dda:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de0:	8b 40 08             	mov    0x8(%eax),%eax
  801de3:	eb 0c                	jmp    801df1 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801de5:	b8 00 00 00 00       	mov    $0x0,%eax
  801dea:	eb 05                	jmp    801df1 <malloc+0x97>
				}
		}
	return 0;
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801dff:	83 ec 08             	sub    $0x8,%esp
  801e02:	ff 75 f4             	pushl  -0xc(%ebp)
  801e05:	68 40 50 80 00       	push   $0x805040
  801e0a:	e8 cf 0b 00 00       	call   8029de <find_block>
  801e0f:	83 c4 10             	add    $0x10,%esp
  801e12:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801e15:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e18:	8b 40 0c             	mov    0xc(%eax),%eax
  801e1b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801e1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e21:	8b 40 08             	mov    0x8(%eax),%eax
  801e24:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801e27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e2b:	0f 84 a1 00 00 00    	je     801ed2 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801e31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e35:	75 17                	jne    801e4e <free+0x5b>
  801e37:	83 ec 04             	sub    $0x4,%esp
  801e3a:	68 e9 42 80 00       	push   $0x8042e9
  801e3f:	68 80 00 00 00       	push   $0x80
  801e44:	68 07 43 80 00       	push   $0x804307
  801e49:	e8 b3 ea ff ff       	call   800901 <_panic>
  801e4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e51:	8b 00                	mov    (%eax),%eax
  801e53:	85 c0                	test   %eax,%eax
  801e55:	74 10                	je     801e67 <free+0x74>
  801e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e5a:	8b 00                	mov    (%eax),%eax
  801e5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e5f:	8b 52 04             	mov    0x4(%edx),%edx
  801e62:	89 50 04             	mov    %edx,0x4(%eax)
  801e65:	eb 0b                	jmp    801e72 <free+0x7f>
  801e67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6a:	8b 40 04             	mov    0x4(%eax),%eax
  801e6d:	a3 44 50 80 00       	mov    %eax,0x805044
  801e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e75:	8b 40 04             	mov    0x4(%eax),%eax
  801e78:	85 c0                	test   %eax,%eax
  801e7a:	74 0f                	je     801e8b <free+0x98>
  801e7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7f:	8b 40 04             	mov    0x4(%eax),%eax
  801e82:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e85:	8b 12                	mov    (%edx),%edx
  801e87:	89 10                	mov    %edx,(%eax)
  801e89:	eb 0a                	jmp    801e95 <free+0xa2>
  801e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8e:	8b 00                	mov    (%eax),%eax
  801e90:	a3 40 50 80 00       	mov    %eax,0x805040
  801e95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ea8:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ead:	48                   	dec    %eax
  801eae:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb9:	e8 29 12 00 00       	call   8030e7 <insert_sorted_with_merge_freeList>
  801ebe:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801ec1:	83 ec 08             	sub    $0x8,%esp
  801ec4:	ff 75 ec             	pushl  -0x14(%ebp)
  801ec7:	ff 75 e8             	pushl  -0x18(%ebp)
  801eca:	e8 74 03 00 00       	call   802243 <sys_free_user_mem>
  801ecf:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801ed2:	90                   	nop
  801ed3:	c9                   	leave  
  801ed4:	c3                   	ret    

00801ed5 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801ed5:	55                   	push   %ebp
  801ed6:	89 e5                	mov    %esp,%ebp
  801ed8:	83 ec 38             	sub    $0x38,%esp
  801edb:	8b 45 10             	mov    0x10(%ebp),%eax
  801ede:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ee1:	e8 5f fc ff ff       	call   801b45 <InitializeUHeap>
	if (size == 0) return NULL ;
  801ee6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801eea:	75 0a                	jne    801ef6 <smalloc+0x21>
  801eec:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef1:	e9 b2 00 00 00       	jmp    801fa8 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801ef6:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801efd:	76 0a                	jbe    801f09 <smalloc+0x34>
		return NULL;
  801eff:	b8 00 00 00 00       	mov    $0x0,%eax
  801f04:	e9 9f 00 00 00       	jmp    801fa8 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801f09:	e8 3b 07 00 00       	call   802649 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	0f 84 8d 00 00 00    	je     801fa3 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801f16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801f1d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2a:	01 d0                	add    %edx,%eax
  801f2c:	48                   	dec    %eax
  801f2d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f33:	ba 00 00 00 00       	mov    $0x0,%edx
  801f38:	f7 75 f0             	divl   -0x10(%ebp)
  801f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3e:	29 d0                	sub    %edx,%eax
  801f40:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801f43:	83 ec 0c             	sub    $0xc,%esp
  801f46:	ff 75 e8             	pushl  -0x18(%ebp)
  801f49:	e8 5b 0c 00 00       	call   802ba9 <alloc_block_FF>
  801f4e:	83 c4 10             	add    $0x10,%esp
  801f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801f54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f58:	75 07                	jne    801f61 <smalloc+0x8c>
			return NULL;
  801f5a:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5f:	eb 47                	jmp    801fa8 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801f61:	83 ec 0c             	sub    $0xc,%esp
  801f64:	ff 75 f4             	pushl  -0xc(%ebp)
  801f67:	e8 a5 0a 00 00       	call   802a11 <insert_sorted_allocList>
  801f6c:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	8b 40 08             	mov    0x8(%eax),%eax
  801f75:	89 c2                	mov    %eax,%edx
  801f77:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	ff 75 0c             	pushl  0xc(%ebp)
  801f80:	ff 75 08             	pushl  0x8(%ebp)
  801f83:	e8 46 04 00 00       	call   8023ce <sys_createSharedObject>
  801f88:	83 c4 10             	add    $0x10,%esp
  801f8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801f8e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f92:	78 08                	js     801f9c <smalloc+0xc7>
		return (void *)b->sva;
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	8b 40 08             	mov    0x8(%eax),%eax
  801f9a:	eb 0c                	jmp    801fa8 <smalloc+0xd3>
		}else{
		return NULL;
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa1:	eb 05                	jmp    801fa8 <smalloc+0xd3>
			}

	}return NULL;
  801fa3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa8:	c9                   	leave  
  801fa9:	c3                   	ret    

00801faa <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801faa:	55                   	push   %ebp
  801fab:	89 e5                	mov    %esp,%ebp
  801fad:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801fb0:	e8 90 fb ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801fb5:	e8 8f 06 00 00       	call   802649 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801fba:	85 c0                	test   %eax,%eax
  801fbc:	0f 84 ad 00 00 00    	je     80206f <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801fc2:	83 ec 08             	sub    $0x8,%esp
  801fc5:	ff 75 0c             	pushl  0xc(%ebp)
  801fc8:	ff 75 08             	pushl  0x8(%ebp)
  801fcb:	e8 28 04 00 00       	call   8023f8 <sys_getSizeOfSharedObject>
  801fd0:	83 c4 10             	add    $0x10,%esp
  801fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801fd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fda:	79 0a                	jns    801fe6 <sget+0x3c>
    {
    	return NULL;
  801fdc:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe1:	e9 8e 00 00 00       	jmp    802074 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801fe6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801fed:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ff4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ffa:	01 d0                	add    %edx,%eax
  801ffc:	48                   	dec    %eax
  801ffd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802000:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802003:	ba 00 00 00 00       	mov    $0x0,%edx
  802008:	f7 75 ec             	divl   -0x14(%ebp)
  80200b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80200e:	29 d0                	sub    %edx,%eax
  802010:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  802013:	83 ec 0c             	sub    $0xc,%esp
  802016:	ff 75 e4             	pushl  -0x1c(%ebp)
  802019:	e8 8b 0b 00 00       	call   802ba9 <alloc_block_FF>
  80201e:	83 c4 10             	add    $0x10,%esp
  802021:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  802024:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802028:	75 07                	jne    802031 <sget+0x87>
				return NULL;
  80202a:	b8 00 00 00 00       	mov    $0x0,%eax
  80202f:	eb 43                	jmp    802074 <sget+0xca>
			}
			insert_sorted_allocList(b);
  802031:	83 ec 0c             	sub    $0xc,%esp
  802034:	ff 75 f0             	pushl  -0x10(%ebp)
  802037:	e8 d5 09 00 00       	call   802a11 <insert_sorted_allocList>
  80203c:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  80203f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802042:	8b 40 08             	mov    0x8(%eax),%eax
  802045:	83 ec 04             	sub    $0x4,%esp
  802048:	50                   	push   %eax
  802049:	ff 75 0c             	pushl  0xc(%ebp)
  80204c:	ff 75 08             	pushl  0x8(%ebp)
  80204f:	e8 c1 03 00 00       	call   802415 <sys_getSharedObject>
  802054:	83 c4 10             	add    $0x10,%esp
  802057:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  80205a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80205e:	78 08                	js     802068 <sget+0xbe>
			return (void *)b->sva;
  802060:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802063:	8b 40 08             	mov    0x8(%eax),%eax
  802066:	eb 0c                	jmp    802074 <sget+0xca>
			}else{
			return NULL;
  802068:	b8 00 00 00 00       	mov    $0x0,%eax
  80206d:	eb 05                	jmp    802074 <sget+0xca>
			}
    }}return NULL;
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802074:	c9                   	leave  
  802075:	c3                   	ret    

00802076 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802076:	55                   	push   %ebp
  802077:	89 e5                	mov    %esp,%ebp
  802079:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80207c:	e8 c4 fa ff ff       	call   801b45 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802081:	83 ec 04             	sub    $0x4,%esp
  802084:	68 38 43 80 00       	push   $0x804338
  802089:	68 03 01 00 00       	push   $0x103
  80208e:	68 07 43 80 00       	push   $0x804307
  802093:	e8 69 e8 ff ff       	call   800901 <_panic>

00802098 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802098:	55                   	push   %ebp
  802099:	89 e5                	mov    %esp,%ebp
  80209b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80209e:	83 ec 04             	sub    $0x4,%esp
  8020a1:	68 60 43 80 00       	push   $0x804360
  8020a6:	68 17 01 00 00       	push   $0x117
  8020ab:	68 07 43 80 00       	push   $0x804307
  8020b0:	e8 4c e8 ff ff       	call   800901 <_panic>

008020b5 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020bb:	83 ec 04             	sub    $0x4,%esp
  8020be:	68 84 43 80 00       	push   $0x804384
  8020c3:	68 22 01 00 00       	push   $0x122
  8020c8:	68 07 43 80 00       	push   $0x804307
  8020cd:	e8 2f e8 ff ff       	call   800901 <_panic>

008020d2 <shrink>:

}
void shrink(uint32 newSize)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	68 84 43 80 00       	push   $0x804384
  8020e0:	68 27 01 00 00       	push   $0x127
  8020e5:	68 07 43 80 00       	push   $0x804307
  8020ea:	e8 12 e8 ff ff       	call   800901 <_panic>

008020ef <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020f5:	83 ec 04             	sub    $0x4,%esp
  8020f8:	68 84 43 80 00       	push   $0x804384
  8020fd:	68 2c 01 00 00       	push   $0x12c
  802102:	68 07 43 80 00       	push   $0x804307
  802107:	e8 f5 e7 ff ff       	call   800901 <_panic>

0080210c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80210c:	55                   	push   %ebp
  80210d:	89 e5                	mov    %esp,%ebp
  80210f:	57                   	push   %edi
  802110:	56                   	push   %esi
  802111:	53                   	push   %ebx
  802112:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802121:	8b 7d 18             	mov    0x18(%ebp),%edi
  802124:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802127:	cd 30                	int    $0x30
  802129:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80212c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80212f:	83 c4 10             	add    $0x10,%esp
  802132:	5b                   	pop    %ebx
  802133:	5e                   	pop    %esi
  802134:	5f                   	pop    %edi
  802135:	5d                   	pop    %ebp
  802136:	c3                   	ret    

00802137 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	83 ec 04             	sub    $0x4,%esp
  80213d:	8b 45 10             	mov    0x10(%ebp),%eax
  802140:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802143:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	52                   	push   %edx
  80214f:	ff 75 0c             	pushl  0xc(%ebp)
  802152:	50                   	push   %eax
  802153:	6a 00                	push   $0x0
  802155:	e8 b2 ff ff ff       	call   80210c <syscall>
  80215a:	83 c4 18             	add    $0x18,%esp
}
  80215d:	90                   	nop
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <sys_cgetc>:

int
sys_cgetc(void)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 01                	push   $0x1
  80216f:	e8 98 ff ff ff       	call   80210c <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80217c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	6a 00                	push   $0x0
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	52                   	push   %edx
  802189:	50                   	push   %eax
  80218a:	6a 05                	push   $0x5
  80218c:	e8 7b ff ff ff       	call   80210c <syscall>
  802191:	83 c4 18             	add    $0x18,%esp
}
  802194:	c9                   	leave  
  802195:	c3                   	ret    

00802196 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
  802199:	56                   	push   %esi
  80219a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80219b:	8b 75 18             	mov    0x18(%ebp),%esi
  80219e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021a1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021aa:	56                   	push   %esi
  8021ab:	53                   	push   %ebx
  8021ac:	51                   	push   %ecx
  8021ad:	52                   	push   %edx
  8021ae:	50                   	push   %eax
  8021af:	6a 06                	push   $0x6
  8021b1:	e8 56 ff ff ff       	call   80210c <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
}
  8021b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021bc:	5b                   	pop    %ebx
  8021bd:	5e                   	pop    %esi
  8021be:	5d                   	pop    %ebp
  8021bf:	c3                   	ret    

008021c0 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	52                   	push   %edx
  8021d0:	50                   	push   %eax
  8021d1:	6a 07                	push   $0x7
  8021d3:	e8 34 ff ff ff       	call   80210c <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
}
  8021db:	c9                   	leave  
  8021dc:	c3                   	ret    

008021dd <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	ff 75 0c             	pushl  0xc(%ebp)
  8021e9:	ff 75 08             	pushl  0x8(%ebp)
  8021ec:	6a 08                	push   $0x8
  8021ee:	e8 19 ff ff ff       	call   80210c <syscall>
  8021f3:	83 c4 18             	add    $0x18,%esp
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 09                	push   $0x9
  802207:	e8 00 ff ff ff       	call   80210c <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 00                	push   $0x0
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	6a 0a                	push   $0xa
  802220:	e8 e7 fe ff ff       	call   80210c <syscall>
  802225:	83 c4 18             	add    $0x18,%esp
}
  802228:	c9                   	leave  
  802229:	c3                   	ret    

0080222a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80222a:	55                   	push   %ebp
  80222b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 00                	push   $0x0
  802235:	6a 00                	push   $0x0
  802237:	6a 0b                	push   $0xb
  802239:	e8 ce fe ff ff       	call   80210c <syscall>
  80223e:	83 c4 18             	add    $0x18,%esp
}
  802241:	c9                   	leave  
  802242:	c3                   	ret    

00802243 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802243:	55                   	push   %ebp
  802244:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	ff 75 0c             	pushl  0xc(%ebp)
  80224f:	ff 75 08             	pushl  0x8(%ebp)
  802252:	6a 0f                	push   $0xf
  802254:	e8 b3 fe ff ff       	call   80210c <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
	return;
  80225c:	90                   	nop
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	ff 75 0c             	pushl  0xc(%ebp)
  80226b:	ff 75 08             	pushl  0x8(%ebp)
  80226e:	6a 10                	push   $0x10
  802270:	e8 97 fe ff ff       	call   80210c <syscall>
  802275:	83 c4 18             	add    $0x18,%esp
	return ;
  802278:	90                   	nop
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	ff 75 10             	pushl  0x10(%ebp)
  802285:	ff 75 0c             	pushl  0xc(%ebp)
  802288:	ff 75 08             	pushl  0x8(%ebp)
  80228b:	6a 11                	push   $0x11
  80228d:	e8 7a fe ff ff       	call   80210c <syscall>
  802292:	83 c4 18             	add    $0x18,%esp
	return ;
  802295:	90                   	nop
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 0c                	push   $0xc
  8022a7:	e8 60 fe ff ff       	call   80210c <syscall>
  8022ac:	83 c4 18             	add    $0x18,%esp
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	ff 75 08             	pushl  0x8(%ebp)
  8022bf:	6a 0d                	push   $0xd
  8022c1:	e8 46 fe ff ff       	call   80210c <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 0e                	push   $0xe
  8022da:	e8 2d fe ff ff       	call   80210c <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	90                   	nop
  8022e3:	c9                   	leave  
  8022e4:	c3                   	ret    

008022e5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022e5:	55                   	push   %ebp
  8022e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 13                	push   $0x13
  8022f4:	e8 13 fe ff ff       	call   80210c <syscall>
  8022f9:	83 c4 18             	add    $0x18,%esp
}
  8022fc:	90                   	nop
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	6a 14                	push   $0x14
  80230e:	e8 f9 fd ff ff       	call   80210c <syscall>
  802313:	83 c4 18             	add    $0x18,%esp
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <sys_cputc>:


void
sys_cputc(const char c)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 04             	sub    $0x4,%esp
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802325:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	6a 00                	push   $0x0
  802331:	50                   	push   %eax
  802332:	6a 15                	push   $0x15
  802334:	e8 d3 fd ff ff       	call   80210c <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
}
  80233c:	90                   	nop
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 00                	push   $0x0
  802348:	6a 00                	push   $0x0
  80234a:	6a 00                	push   $0x0
  80234c:	6a 16                	push   $0x16
  80234e:	e8 b9 fd ff ff       	call   80210c <syscall>
  802353:	83 c4 18             	add    $0x18,%esp
}
  802356:	90                   	nop
  802357:	c9                   	leave  
  802358:	c3                   	ret    

00802359 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802359:	55                   	push   %ebp
  80235a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80235c:	8b 45 08             	mov    0x8(%ebp),%eax
  80235f:	6a 00                	push   $0x0
  802361:	6a 00                	push   $0x0
  802363:	6a 00                	push   $0x0
  802365:	ff 75 0c             	pushl  0xc(%ebp)
  802368:	50                   	push   %eax
  802369:	6a 17                	push   $0x17
  80236b:	e8 9c fd ff ff       	call   80210c <syscall>
  802370:	83 c4 18             	add    $0x18,%esp
}
  802373:	c9                   	leave  
  802374:	c3                   	ret    

00802375 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802375:	55                   	push   %ebp
  802376:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802378:	8b 55 0c             	mov    0xc(%ebp),%edx
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	6a 00                	push   $0x0
  802380:	6a 00                	push   $0x0
  802382:	6a 00                	push   $0x0
  802384:	52                   	push   %edx
  802385:	50                   	push   %eax
  802386:	6a 1a                	push   $0x1a
  802388:	e8 7f fd ff ff       	call   80210c <syscall>
  80238d:	83 c4 18             	add    $0x18,%esp
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802395:	8b 55 0c             	mov    0xc(%ebp),%edx
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	6a 00                	push   $0x0
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	52                   	push   %edx
  8023a2:	50                   	push   %eax
  8023a3:	6a 18                	push   $0x18
  8023a5:	e8 62 fd ff ff       	call   80210c <syscall>
  8023aa:	83 c4 18             	add    $0x18,%esp
}
  8023ad:	90                   	nop
  8023ae:	c9                   	leave  
  8023af:	c3                   	ret    

008023b0 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b9:	6a 00                	push   $0x0
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	52                   	push   %edx
  8023c0:	50                   	push   %eax
  8023c1:	6a 19                	push   $0x19
  8023c3:	e8 44 fd ff ff       	call   80210c <syscall>
  8023c8:	83 c4 18             	add    $0x18,%esp
}
  8023cb:	90                   	nop
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	83 ec 04             	sub    $0x4,%esp
  8023d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023d7:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023da:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023dd:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	6a 00                	push   $0x0
  8023e6:	51                   	push   %ecx
  8023e7:	52                   	push   %edx
  8023e8:	ff 75 0c             	pushl  0xc(%ebp)
  8023eb:	50                   	push   %eax
  8023ec:	6a 1b                	push   $0x1b
  8023ee:	e8 19 fd ff ff       	call   80210c <syscall>
  8023f3:	83 c4 18             	add    $0x18,%esp
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802401:	6a 00                	push   $0x0
  802403:	6a 00                	push   $0x0
  802405:	6a 00                	push   $0x0
  802407:	52                   	push   %edx
  802408:	50                   	push   %eax
  802409:	6a 1c                	push   $0x1c
  80240b:	e8 fc fc ff ff       	call   80210c <syscall>
  802410:	83 c4 18             	add    $0x18,%esp
}
  802413:	c9                   	leave  
  802414:	c3                   	ret    

00802415 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802418:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80241b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241e:	8b 45 08             	mov    0x8(%ebp),%eax
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	51                   	push   %ecx
  802426:	52                   	push   %edx
  802427:	50                   	push   %eax
  802428:	6a 1d                	push   $0x1d
  80242a:	e8 dd fc ff ff       	call   80210c <syscall>
  80242f:	83 c4 18             	add    $0x18,%esp
}
  802432:	c9                   	leave  
  802433:	c3                   	ret    

00802434 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802434:	55                   	push   %ebp
  802435:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802437:	8b 55 0c             	mov    0xc(%ebp),%edx
  80243a:	8b 45 08             	mov    0x8(%ebp),%eax
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	52                   	push   %edx
  802444:	50                   	push   %eax
  802445:	6a 1e                	push   $0x1e
  802447:	e8 c0 fc ff ff       	call   80210c <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
}
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 1f                	push   $0x1f
  802460:	e8 a7 fc ff ff       	call   80210c <syscall>
  802465:	83 c4 18             	add    $0x18,%esp
}
  802468:	c9                   	leave  
  802469:	c3                   	ret    

0080246a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80246a:	55                   	push   %ebp
  80246b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	6a 00                	push   $0x0
  802472:	ff 75 14             	pushl  0x14(%ebp)
  802475:	ff 75 10             	pushl  0x10(%ebp)
  802478:	ff 75 0c             	pushl  0xc(%ebp)
  80247b:	50                   	push   %eax
  80247c:	6a 20                	push   $0x20
  80247e:	e8 89 fc ff ff       	call   80210c <syscall>
  802483:	83 c4 18             	add    $0x18,%esp
}
  802486:	c9                   	leave  
  802487:	c3                   	ret    

00802488 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802488:	55                   	push   %ebp
  802489:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	6a 00                	push   $0x0
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	50                   	push   %eax
  802497:	6a 21                	push   $0x21
  802499:	e8 6e fc ff ff       	call   80210c <syscall>
  80249e:	83 c4 18             	add    $0x18,%esp
}
  8024a1:	90                   	nop
  8024a2:	c9                   	leave  
  8024a3:	c3                   	ret    

008024a4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8024a4:	55                   	push   %ebp
  8024a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 00                	push   $0x0
  8024b0:	6a 00                	push   $0x0
  8024b2:	50                   	push   %eax
  8024b3:	6a 22                	push   $0x22
  8024b5:	e8 52 fc ff ff       	call   80210c <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
}
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <sys_getenvid>:

int32 sys_getenvid(void)
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 02                	push   $0x2
  8024ce:	e8 39 fc ff ff       	call   80210c <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
}
  8024d6:	c9                   	leave  
  8024d7:	c3                   	ret    

008024d8 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024d8:	55                   	push   %ebp
  8024d9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024db:	6a 00                	push   $0x0
  8024dd:	6a 00                	push   $0x0
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 03                	push   $0x3
  8024e7:	e8 20 fc ff ff       	call   80210c <syscall>
  8024ec:	83 c4 18             	add    $0x18,%esp
}
  8024ef:	c9                   	leave  
  8024f0:	c3                   	ret    

008024f1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024f4:	6a 00                	push   $0x0
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 04                	push   $0x4
  802500:	e8 07 fc ff ff       	call   80210c <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
}
  802508:	c9                   	leave  
  802509:	c3                   	ret    

0080250a <sys_exit_env>:


void sys_exit_env(void)
{
  80250a:	55                   	push   %ebp
  80250b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 00                	push   $0x0
  802513:	6a 00                	push   $0x0
  802515:	6a 00                	push   $0x0
  802517:	6a 23                	push   $0x23
  802519:	e8 ee fb ff ff       	call   80210c <syscall>
  80251e:	83 c4 18             	add    $0x18,%esp
}
  802521:	90                   	nop
  802522:	c9                   	leave  
  802523:	c3                   	ret    

00802524 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802524:	55                   	push   %ebp
  802525:	89 e5                	mov    %esp,%ebp
  802527:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80252a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80252d:	8d 50 04             	lea    0x4(%eax),%edx
  802530:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	52                   	push   %edx
  80253a:	50                   	push   %eax
  80253b:	6a 24                	push   $0x24
  80253d:	e8 ca fb ff ff       	call   80210c <syscall>
  802542:	83 c4 18             	add    $0x18,%esp
	return result;
  802545:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802548:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80254b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80254e:	89 01                	mov    %eax,(%ecx)
  802550:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	c9                   	leave  
  802557:	c2 04 00             	ret    $0x4

0080255a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	ff 75 10             	pushl  0x10(%ebp)
  802564:	ff 75 0c             	pushl  0xc(%ebp)
  802567:	ff 75 08             	pushl  0x8(%ebp)
  80256a:	6a 12                	push   $0x12
  80256c:	e8 9b fb ff ff       	call   80210c <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
	return ;
  802574:	90                   	nop
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <sys_rcr2>:
uint32 sys_rcr2()
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 25                	push   $0x25
  802586:	e8 81 fb ff ff       	call   80210c <syscall>
  80258b:	83 c4 18             	add    $0x18,%esp
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 04             	sub    $0x4,%esp
  802596:	8b 45 08             	mov    0x8(%ebp),%eax
  802599:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80259c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8025a0:	6a 00                	push   $0x0
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	50                   	push   %eax
  8025a9:	6a 26                	push   $0x26
  8025ab:	e8 5c fb ff ff       	call   80210c <syscall>
  8025b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b3:	90                   	nop
}
  8025b4:	c9                   	leave  
  8025b5:	c3                   	ret    

008025b6 <rsttst>:
void rsttst()
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 28                	push   $0x28
  8025c5:	e8 42 fb ff ff       	call   80210c <syscall>
  8025ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8025cd:	90                   	nop
}
  8025ce:	c9                   	leave  
  8025cf:	c3                   	ret    

008025d0 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	83 ec 04             	sub    $0x4,%esp
  8025d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8025d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025dc:	8b 55 18             	mov    0x18(%ebp),%edx
  8025df:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025e3:	52                   	push   %edx
  8025e4:	50                   	push   %eax
  8025e5:	ff 75 10             	pushl  0x10(%ebp)
  8025e8:	ff 75 0c             	pushl  0xc(%ebp)
  8025eb:	ff 75 08             	pushl  0x8(%ebp)
  8025ee:	6a 27                	push   $0x27
  8025f0:	e8 17 fb ff ff       	call   80210c <syscall>
  8025f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8025f8:	90                   	nop
}
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <chktst>:
void chktst(uint32 n)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	6a 00                	push   $0x0
  802604:	6a 00                	push   $0x0
  802606:	ff 75 08             	pushl  0x8(%ebp)
  802609:	6a 29                	push   $0x29
  80260b:	e8 fc fa ff ff       	call   80210c <syscall>
  802610:	83 c4 18             	add    $0x18,%esp
	return ;
  802613:	90                   	nop
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <inctst>:

void inctst()
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802619:	6a 00                	push   $0x0
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 2a                	push   $0x2a
  802625:	e8 e2 fa ff ff       	call   80210c <syscall>
  80262a:	83 c4 18             	add    $0x18,%esp
	return ;
  80262d:	90                   	nop
}
  80262e:	c9                   	leave  
  80262f:	c3                   	ret    

00802630 <gettst>:
uint32 gettst()
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	6a 2b                	push   $0x2b
  80263f:	e8 c8 fa ff ff       	call   80210c <syscall>
  802644:	83 c4 18             	add    $0x18,%esp
}
  802647:	c9                   	leave  
  802648:	c3                   	ret    

00802649 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802649:	55                   	push   %ebp
  80264a:	89 e5                	mov    %esp,%ebp
  80264c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 2c                	push   $0x2c
  80265b:	e8 ac fa ff ff       	call   80210c <syscall>
  802660:	83 c4 18             	add    $0x18,%esp
  802663:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802666:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80266a:	75 07                	jne    802673 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80266c:	b8 01 00 00 00       	mov    $0x1,%eax
  802671:	eb 05                	jmp    802678 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802673:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802678:	c9                   	leave  
  802679:	c3                   	ret    

0080267a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
  80267d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 2c                	push   $0x2c
  80268c:	e8 7b fa ff ff       	call   80210c <syscall>
  802691:	83 c4 18             	add    $0x18,%esp
  802694:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802697:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80269b:	75 07                	jne    8026a4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80269d:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a2:	eb 05                	jmp    8026a9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8026a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a9:	c9                   	leave  
  8026aa:	c3                   	ret    

008026ab <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8026ab:	55                   	push   %ebp
  8026ac:	89 e5                	mov    %esp,%ebp
  8026ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026b1:	6a 00                	push   $0x0
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 2c                	push   $0x2c
  8026bd:	e8 4a fa ff ff       	call   80210c <syscall>
  8026c2:	83 c4 18             	add    $0x18,%esp
  8026c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8026c8:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026cc:	75 07                	jne    8026d5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8026d3:	eb 05                	jmp    8026da <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026da:	c9                   	leave  
  8026db:	c3                   	ret    

008026dc <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026dc:	55                   	push   %ebp
  8026dd:	89 e5                	mov    %esp,%ebp
  8026df:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026e2:	6a 00                	push   $0x0
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 2c                	push   $0x2c
  8026ee:	e8 19 fa ff ff       	call   80210c <syscall>
  8026f3:	83 c4 18             	add    $0x18,%esp
  8026f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026f9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026fd:	75 07                	jne    802706 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026ff:	b8 01 00 00 00       	mov    $0x1,%eax
  802704:	eb 05                	jmp    80270b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802706:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802710:	6a 00                	push   $0x0
  802712:	6a 00                	push   $0x0
  802714:	6a 00                	push   $0x0
  802716:	6a 00                	push   $0x0
  802718:	ff 75 08             	pushl  0x8(%ebp)
  80271b:	6a 2d                	push   $0x2d
  80271d:	e8 ea f9 ff ff       	call   80210c <syscall>
  802722:	83 c4 18             	add    $0x18,%esp
	return ;
  802725:	90                   	nop
}
  802726:	c9                   	leave  
  802727:	c3                   	ret    

00802728 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802728:	55                   	push   %ebp
  802729:	89 e5                	mov    %esp,%ebp
  80272b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80272c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80272f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802732:	8b 55 0c             	mov    0xc(%ebp),%edx
  802735:	8b 45 08             	mov    0x8(%ebp),%eax
  802738:	6a 00                	push   $0x0
  80273a:	53                   	push   %ebx
  80273b:	51                   	push   %ecx
  80273c:	52                   	push   %edx
  80273d:	50                   	push   %eax
  80273e:	6a 2e                	push   $0x2e
  802740:	e8 c7 f9 ff ff       	call   80210c <syscall>
  802745:	83 c4 18             	add    $0x18,%esp
}
  802748:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802750:	8b 55 0c             	mov    0xc(%ebp),%edx
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	52                   	push   %edx
  80275d:	50                   	push   %eax
  80275e:	6a 2f                	push   $0x2f
  802760:	e8 a7 f9 ff ff       	call   80210c <syscall>
  802765:	83 c4 18             	add    $0x18,%esp
}
  802768:	c9                   	leave  
  802769:	c3                   	ret    

0080276a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80276a:	55                   	push   %ebp
  80276b:	89 e5                	mov    %esp,%ebp
  80276d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802770:	83 ec 0c             	sub    $0xc,%esp
  802773:	68 94 43 80 00       	push   $0x804394
  802778:	e8 38 e4 ff ff       	call   800bb5 <cprintf>
  80277d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802780:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802787:	83 ec 0c             	sub    $0xc,%esp
  80278a:	68 c0 43 80 00       	push   $0x8043c0
  80278f:	e8 21 e4 ff ff       	call   800bb5 <cprintf>
  802794:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802797:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80279b:	a1 38 51 80 00       	mov    0x805138,%eax
  8027a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027a3:	eb 56                	jmp    8027fb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027a9:	74 1c                	je     8027c7 <print_mem_block_lists+0x5d>
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 50 08             	mov    0x8(%eax),%edx
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	8b 48 08             	mov    0x8(%eax),%ecx
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bd:	01 c8                	add    %ecx,%eax
  8027bf:	39 c2                	cmp    %eax,%edx
  8027c1:	73 04                	jae    8027c7 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8027c3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 50 08             	mov    0x8(%eax),%edx
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d3:	01 c2                	add    %eax,%edx
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	8b 40 08             	mov    0x8(%eax),%eax
  8027db:	83 ec 04             	sub    $0x4,%esp
  8027de:	52                   	push   %edx
  8027df:	50                   	push   %eax
  8027e0:	68 d5 43 80 00       	push   $0x8043d5
  8027e5:	e8 cb e3 ff ff       	call   800bb5 <cprintf>
  8027ea:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027f3:	a1 40 51 80 00       	mov    0x805140,%eax
  8027f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ff:	74 07                	je     802808 <print_mem_block_lists+0x9e>
  802801:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802804:	8b 00                	mov    (%eax),%eax
  802806:	eb 05                	jmp    80280d <print_mem_block_lists+0xa3>
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
  80280d:	a3 40 51 80 00       	mov    %eax,0x805140
  802812:	a1 40 51 80 00       	mov    0x805140,%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	75 8a                	jne    8027a5 <print_mem_block_lists+0x3b>
  80281b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281f:	75 84                	jne    8027a5 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802821:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802825:	75 10                	jne    802837 <print_mem_block_lists+0xcd>
  802827:	83 ec 0c             	sub    $0xc,%esp
  80282a:	68 e4 43 80 00       	push   $0x8043e4
  80282f:	e8 81 e3 ff ff       	call   800bb5 <cprintf>
  802834:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802837:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80283e:	83 ec 0c             	sub    $0xc,%esp
  802841:	68 08 44 80 00       	push   $0x804408
  802846:	e8 6a e3 ff ff       	call   800bb5 <cprintf>
  80284b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80284e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802852:	a1 40 50 80 00       	mov    0x805040,%eax
  802857:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285a:	eb 56                	jmp    8028b2 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80285c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802860:	74 1c                	je     80287e <print_mem_block_lists+0x114>
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 50 08             	mov    0x8(%eax),%edx
  802868:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286b:	8b 48 08             	mov    0x8(%eax),%ecx
  80286e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802871:	8b 40 0c             	mov    0xc(%eax),%eax
  802874:	01 c8                	add    %ecx,%eax
  802876:	39 c2                	cmp    %eax,%edx
  802878:	73 04                	jae    80287e <print_mem_block_lists+0x114>
			sorted = 0 ;
  80287a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	8b 50 08             	mov    0x8(%eax),%edx
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 40 0c             	mov    0xc(%eax),%eax
  80288a:	01 c2                	add    %eax,%edx
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 40 08             	mov    0x8(%eax),%eax
  802892:	83 ec 04             	sub    $0x4,%esp
  802895:	52                   	push   %edx
  802896:	50                   	push   %eax
  802897:	68 d5 43 80 00       	push   $0x8043d5
  80289c:	e8 14 e3 ff ff       	call   800bb5 <cprintf>
  8028a1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8028a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028aa:	a1 48 50 80 00       	mov    0x805048,%eax
  8028af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b6:	74 07                	je     8028bf <print_mem_block_lists+0x155>
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 00                	mov    (%eax),%eax
  8028bd:	eb 05                	jmp    8028c4 <print_mem_block_lists+0x15a>
  8028bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c4:	a3 48 50 80 00       	mov    %eax,0x805048
  8028c9:	a1 48 50 80 00       	mov    0x805048,%eax
  8028ce:	85 c0                	test   %eax,%eax
  8028d0:	75 8a                	jne    80285c <print_mem_block_lists+0xf2>
  8028d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d6:	75 84                	jne    80285c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8028d8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028dc:	75 10                	jne    8028ee <print_mem_block_lists+0x184>
  8028de:	83 ec 0c             	sub    $0xc,%esp
  8028e1:	68 20 44 80 00       	push   $0x804420
  8028e6:	e8 ca e2 ff ff       	call   800bb5 <cprintf>
  8028eb:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8028ee:	83 ec 0c             	sub    $0xc,%esp
  8028f1:	68 94 43 80 00       	push   $0x804394
  8028f6:	e8 ba e2 ff ff       	call   800bb5 <cprintf>
  8028fb:	83 c4 10             	add    $0x10,%esp

}
  8028fe:	90                   	nop
  8028ff:	c9                   	leave  
  802900:	c3                   	ret    

00802901 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802901:	55                   	push   %ebp
  802902:	89 e5                	mov    %esp,%ebp
  802904:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802907:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  80290e:	00 00 00 
  802911:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802918:	00 00 00 
  80291b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802922:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802925:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80292c:	e9 9e 00 00 00       	jmp    8029cf <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802931:	a1 50 50 80 00       	mov    0x805050,%eax
  802936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802939:	c1 e2 04             	shl    $0x4,%edx
  80293c:	01 d0                	add    %edx,%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	75 14                	jne    802956 <initialize_MemBlocksList+0x55>
  802942:	83 ec 04             	sub    $0x4,%esp
  802945:	68 48 44 80 00       	push   $0x804448
  80294a:	6a 3d                	push   $0x3d
  80294c:	68 6b 44 80 00       	push   $0x80446b
  802951:	e8 ab df ff ff       	call   800901 <_panic>
  802956:	a1 50 50 80 00       	mov    0x805050,%eax
  80295b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80295e:	c1 e2 04             	shl    $0x4,%edx
  802961:	01 d0                	add    %edx,%eax
  802963:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802969:	89 10                	mov    %edx,(%eax)
  80296b:	8b 00                	mov    (%eax),%eax
  80296d:	85 c0                	test   %eax,%eax
  80296f:	74 18                	je     802989 <initialize_MemBlocksList+0x88>
  802971:	a1 48 51 80 00       	mov    0x805148,%eax
  802976:	8b 15 50 50 80 00    	mov    0x805050,%edx
  80297c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80297f:	c1 e1 04             	shl    $0x4,%ecx
  802982:	01 ca                	add    %ecx,%edx
  802984:	89 50 04             	mov    %edx,0x4(%eax)
  802987:	eb 12                	jmp    80299b <initialize_MemBlocksList+0x9a>
  802989:	a1 50 50 80 00       	mov    0x805050,%eax
  80298e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802991:	c1 e2 04             	shl    $0x4,%edx
  802994:	01 d0                	add    %edx,%eax
  802996:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80299b:	a1 50 50 80 00       	mov    0x805050,%eax
  8029a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a3:	c1 e2 04             	shl    $0x4,%edx
  8029a6:	01 d0                	add    %edx,%eax
  8029a8:	a3 48 51 80 00       	mov    %eax,0x805148
  8029ad:	a1 50 50 80 00       	mov    0x805050,%eax
  8029b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b5:	c1 e2 04             	shl    $0x4,%edx
  8029b8:	01 d0                	add    %edx,%eax
  8029ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c1:	a1 54 51 80 00       	mov    0x805154,%eax
  8029c6:	40                   	inc    %eax
  8029c7:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8029cc:	ff 45 f4             	incl   -0xc(%ebp)
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d5:	0f 82 56 ff ff ff    	jb     802931 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8029db:	90                   	nop
  8029dc:	c9                   	leave  
  8029dd:	c3                   	ret    

008029de <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8029de:	55                   	push   %ebp
  8029df:	89 e5                	mov    %esp,%ebp
  8029e1:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	8b 00                	mov    (%eax),%eax
  8029e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8029ec:	eb 18                	jmp    802a06 <find_block+0x28>

		if(tmp->sva == va){
  8029ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029f1:	8b 40 08             	mov    0x8(%eax),%eax
  8029f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029f7:	75 05                	jne    8029fe <find_block+0x20>
			return tmp ;
  8029f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029fc:	eb 11                	jmp    802a0f <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8029fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a01:	8b 00                	mov    (%eax),%eax
  802a03:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802a06:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802a0a:	75 e2                	jne    8029ee <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802a0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802a0f:	c9                   	leave  
  802a10:	c3                   	ret    

00802a11 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802a11:	55                   	push   %ebp
  802a12:	89 e5                	mov    %esp,%ebp
  802a14:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802a17:	a1 40 50 80 00       	mov    0x805040,%eax
  802a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802a1f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802a27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a2b:	75 65                	jne    802a92 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802a2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a31:	75 14                	jne    802a47 <insert_sorted_allocList+0x36>
  802a33:	83 ec 04             	sub    $0x4,%esp
  802a36:	68 48 44 80 00       	push   $0x804448
  802a3b:	6a 62                	push   $0x62
  802a3d:	68 6b 44 80 00       	push   $0x80446b
  802a42:	e8 ba de ff ff       	call   800901 <_panic>
  802a47:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a50:	89 10                	mov    %edx,(%eax)
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	74 0d                	je     802a68 <insert_sorted_allocList+0x57>
  802a5b:	a1 40 50 80 00       	mov    0x805040,%eax
  802a60:	8b 55 08             	mov    0x8(%ebp),%edx
  802a63:	89 50 04             	mov    %edx,0x4(%eax)
  802a66:	eb 08                	jmp    802a70 <insert_sorted_allocList+0x5f>
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	a3 44 50 80 00       	mov    %eax,0x805044
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	a3 40 50 80 00       	mov    %eax,0x805040
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a82:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a87:	40                   	inc    %eax
  802a88:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802a8d:	e9 14 01 00 00       	jmp    802ba6 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	8b 50 08             	mov    0x8(%eax),%edx
  802a98:	a1 44 50 80 00       	mov    0x805044,%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	39 c2                	cmp    %eax,%edx
  802aa2:	76 65                	jbe    802b09 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802aa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa8:	75 14                	jne    802abe <insert_sorted_allocList+0xad>
  802aaa:	83 ec 04             	sub    $0x4,%esp
  802aad:	68 84 44 80 00       	push   $0x804484
  802ab2:	6a 64                	push   $0x64
  802ab4:	68 6b 44 80 00       	push   $0x80446b
  802ab9:	e8 43 de ff ff       	call   800901 <_panic>
  802abe:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	89 50 04             	mov    %edx,0x4(%eax)
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	8b 40 04             	mov    0x4(%eax),%eax
  802ad0:	85 c0                	test   %eax,%eax
  802ad2:	74 0c                	je     802ae0 <insert_sorted_allocList+0xcf>
  802ad4:	a1 44 50 80 00       	mov    0x805044,%eax
  802ad9:	8b 55 08             	mov    0x8(%ebp),%edx
  802adc:	89 10                	mov    %edx,(%eax)
  802ade:	eb 08                	jmp    802ae8 <insert_sorted_allocList+0xd7>
  802ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae3:	a3 40 50 80 00       	mov    %eax,0x805040
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	a3 44 50 80 00       	mov    %eax,0x805044
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802afe:	40                   	inc    %eax
  802aff:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802b04:	e9 9d 00 00 00       	jmp    802ba6 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802b09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802b10:	e9 85 00 00 00       	jmp    802b9a <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	8b 50 08             	mov    0x8(%eax),%edx
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 40 08             	mov    0x8(%eax),%eax
  802b21:	39 c2                	cmp    %eax,%edx
  802b23:	73 6a                	jae    802b8f <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802b25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b29:	74 06                	je     802b31 <insert_sorted_allocList+0x120>
  802b2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2f:	75 14                	jne    802b45 <insert_sorted_allocList+0x134>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 a8 44 80 00       	push   $0x8044a8
  802b39:	6a 6b                	push   $0x6b
  802b3b:	68 6b 44 80 00       	push   $0x80446b
  802b40:	e8 bc dd ff ff       	call   800901 <_panic>
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 50 04             	mov    0x4(%eax),%edx
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	89 50 04             	mov    %edx,0x4(%eax)
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b57:	89 10                	mov    %edx,(%eax)
  802b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5c:	8b 40 04             	mov    0x4(%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	74 0d                	je     802b70 <insert_sorted_allocList+0x15f>
  802b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b66:	8b 40 04             	mov    0x4(%eax),%eax
  802b69:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6c:	89 10                	mov    %edx,(%eax)
  802b6e:	eb 08                	jmp    802b78 <insert_sorted_allocList+0x167>
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	a3 40 50 80 00       	mov    %eax,0x805040
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%eax)
  802b81:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b86:	40                   	inc    %eax
  802b87:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802b8c:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802b8d:	eb 17                	jmp    802ba6 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802b97:	ff 45 f0             	incl   -0x10(%ebp)
  802b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b9d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802ba0:	0f 8c 6f ff ff ff    	jl     802b15 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802ba6:	90                   	nop
  802ba7:	c9                   	leave  
  802ba8:	c3                   	ret    

00802ba9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802ba9:	55                   	push   %ebp
  802baa:	89 e5                	mov    %esp,%ebp
  802bac:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802baf:	a1 38 51 80 00       	mov    0x805138,%eax
  802bb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802bb7:	e9 7c 01 00 00       	jmp    802d38 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bc5:	0f 86 cf 00 00 00    	jbe    802c9a <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802bcb:	a1 48 51 80 00       	mov    0x805148,%eax
  802bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd6:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdf:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	8b 50 08             	mov    0x8(%eax),%edx
  802be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802beb:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf4:	2b 45 08             	sub    0x8(%ebp),%eax
  802bf7:	89 c2                	mov    %eax,%edx
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 50 08             	mov    0x8(%eax),%edx
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	01 c2                	add    %eax,%edx
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802c10:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c14:	75 17                	jne    802c2d <alloc_block_FF+0x84>
  802c16:	83 ec 04             	sub    $0x4,%esp
  802c19:	68 dd 44 80 00       	push   $0x8044dd
  802c1e:	68 83 00 00 00       	push   $0x83
  802c23:	68 6b 44 80 00       	push   $0x80446b
  802c28:	e8 d4 dc ff ff       	call   800901 <_panic>
  802c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c30:	8b 00                	mov    (%eax),%eax
  802c32:	85 c0                	test   %eax,%eax
  802c34:	74 10                	je     802c46 <alloc_block_FF+0x9d>
  802c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c39:	8b 00                	mov    (%eax),%eax
  802c3b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3e:	8b 52 04             	mov    0x4(%edx),%edx
  802c41:	89 50 04             	mov    %edx,0x4(%eax)
  802c44:	eb 0b                	jmp    802c51 <alloc_block_FF+0xa8>
  802c46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c49:	8b 40 04             	mov    0x4(%eax),%eax
  802c4c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c54:	8b 40 04             	mov    0x4(%eax),%eax
  802c57:	85 c0                	test   %eax,%eax
  802c59:	74 0f                	je     802c6a <alloc_block_FF+0xc1>
  802c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5e:	8b 40 04             	mov    0x4(%eax),%eax
  802c61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c64:	8b 12                	mov    (%edx),%edx
  802c66:	89 10                	mov    %edx,(%eax)
  802c68:	eb 0a                	jmp    802c74 <alloc_block_FF+0xcb>
  802c6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6d:	8b 00                	mov    (%eax),%eax
  802c6f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c80:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c87:	a1 54 51 80 00       	mov    0x805154,%eax
  802c8c:	48                   	dec    %eax
  802c8d:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c95:	e9 ad 00 00 00       	jmp    802d47 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802ca0:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ca3:	0f 85 87 00 00 00    	jne    802d30 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802ca9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cad:	75 17                	jne    802cc6 <alloc_block_FF+0x11d>
  802caf:	83 ec 04             	sub    $0x4,%esp
  802cb2:	68 dd 44 80 00       	push   $0x8044dd
  802cb7:	68 87 00 00 00       	push   $0x87
  802cbc:	68 6b 44 80 00       	push   $0x80446b
  802cc1:	e8 3b dc ff ff       	call   800901 <_panic>
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 00                	mov    (%eax),%eax
  802ccb:	85 c0                	test   %eax,%eax
  802ccd:	74 10                	je     802cdf <alloc_block_FF+0x136>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 00                	mov    (%eax),%eax
  802cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd7:	8b 52 04             	mov    0x4(%edx),%edx
  802cda:	89 50 04             	mov    %edx,0x4(%eax)
  802cdd:	eb 0b                	jmp    802cea <alloc_block_FF+0x141>
  802cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce2:	8b 40 04             	mov    0x4(%eax),%eax
  802ce5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 40 04             	mov    0x4(%eax),%eax
  802cf0:	85 c0                	test   %eax,%eax
  802cf2:	74 0f                	je     802d03 <alloc_block_FF+0x15a>
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	8b 40 04             	mov    0x4(%eax),%eax
  802cfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cfd:	8b 12                	mov    (%edx),%edx
  802cff:	89 10                	mov    %edx,(%eax)
  802d01:	eb 0a                	jmp    802d0d <alloc_block_FF+0x164>
  802d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d06:	8b 00                	mov    (%eax),%eax
  802d08:	a3 38 51 80 00       	mov    %eax,0x805138
  802d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d20:	a1 44 51 80 00       	mov    0x805144,%eax
  802d25:	48                   	dec    %eax
  802d26:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	eb 17                	jmp    802d47 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d33:	8b 00                	mov    (%eax),%eax
  802d35:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802d38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3c:	0f 85 7a fe ff ff    	jne    802bbc <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d47:	c9                   	leave  
  802d48:	c3                   	ret    

00802d49 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d49:	55                   	push   %ebp
  802d4a:	89 e5                	mov    %esp,%ebp
  802d4c:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802d4f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d54:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802d57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802d5e:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802d65:	a1 38 51 80 00       	mov    0x805138,%eax
  802d6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d6d:	e9 d0 00 00 00       	jmp    802e42 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d75:	8b 40 0c             	mov    0xc(%eax),%eax
  802d78:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d7b:	0f 82 b8 00 00 00    	jb     802e39 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 40 0c             	mov    0xc(%eax),%eax
  802d87:	2b 45 08             	sub    0x8(%ebp),%eax
  802d8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802d8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d90:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d93:	0f 83 a1 00 00 00    	jae    802e3a <alloc_block_BF+0xf1>
				differsize = differance ;
  802d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802da5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802da9:	0f 85 8b 00 00 00    	jne    802e3a <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802daf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802db3:	75 17                	jne    802dcc <alloc_block_BF+0x83>
  802db5:	83 ec 04             	sub    $0x4,%esp
  802db8:	68 dd 44 80 00       	push   $0x8044dd
  802dbd:	68 a0 00 00 00       	push   $0xa0
  802dc2:	68 6b 44 80 00       	push   $0x80446b
  802dc7:	e8 35 db ff ff       	call   800901 <_panic>
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	8b 00                	mov    (%eax),%eax
  802dd1:	85 c0                	test   %eax,%eax
  802dd3:	74 10                	je     802de5 <alloc_block_BF+0x9c>
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddd:	8b 52 04             	mov    0x4(%edx),%edx
  802de0:	89 50 04             	mov    %edx,0x4(%eax)
  802de3:	eb 0b                	jmp    802df0 <alloc_block_BF+0xa7>
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 40 04             	mov    0x4(%eax),%eax
  802deb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	8b 40 04             	mov    0x4(%eax),%eax
  802df6:	85 c0                	test   %eax,%eax
  802df8:	74 0f                	je     802e09 <alloc_block_BF+0xc0>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 40 04             	mov    0x4(%eax),%eax
  802e00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e03:	8b 12                	mov    (%edx),%edx
  802e05:	89 10                	mov    %edx,(%eax)
  802e07:	eb 0a                	jmp    802e13 <alloc_block_BF+0xca>
  802e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e26:	a1 44 51 80 00       	mov    0x805144,%eax
  802e2b:	48                   	dec    %eax
  802e2c:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	e9 0c 01 00 00       	jmp    802f45 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802e39:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802e3a:	a1 40 51 80 00       	mov    0x805140,%eax
  802e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e42:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e46:	74 07                	je     802e4f <alloc_block_BF+0x106>
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	8b 00                	mov    (%eax),%eax
  802e4d:	eb 05                	jmp    802e54 <alloc_block_BF+0x10b>
  802e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  802e54:	a3 40 51 80 00       	mov    %eax,0x805140
  802e59:	a1 40 51 80 00       	mov    0x805140,%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	0f 85 0c ff ff ff    	jne    802d72 <alloc_block_BF+0x29>
  802e66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6a:	0f 85 02 ff ff ff    	jne    802d72 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802e70:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e74:	0f 84 c6 00 00 00    	je     802f40 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802e7a:	a1 48 51 80 00       	mov    0x805148,%eax
  802e7f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802e82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e85:	8b 55 08             	mov    0x8(%ebp),%edx
  802e88:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8e:	8b 50 08             	mov    0x8(%eax),%edx
  802e91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e94:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9d:	2b 45 08             	sub    0x8(%ebp),%eax
  802ea0:	89 c2                	mov    %eax,%edx
  802ea2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ea5:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eab:	8b 50 08             	mov    0x8(%eax),%edx
  802eae:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb1:	01 c2                	add    %eax,%edx
  802eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802eb6:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802eb9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ebd:	75 17                	jne    802ed6 <alloc_block_BF+0x18d>
  802ebf:	83 ec 04             	sub    $0x4,%esp
  802ec2:	68 dd 44 80 00       	push   $0x8044dd
  802ec7:	68 af 00 00 00       	push   $0xaf
  802ecc:	68 6b 44 80 00       	push   $0x80446b
  802ed1:	e8 2b da ff ff       	call   800901 <_panic>
  802ed6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed9:	8b 00                	mov    (%eax),%eax
  802edb:	85 c0                	test   %eax,%eax
  802edd:	74 10                	je     802eef <alloc_block_BF+0x1a6>
  802edf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ee7:	8b 52 04             	mov    0x4(%edx),%edx
  802eea:	89 50 04             	mov    %edx,0x4(%eax)
  802eed:	eb 0b                	jmp    802efa <alloc_block_BF+0x1b1>
  802eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef2:	8b 40 04             	mov    0x4(%eax),%eax
  802ef5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802efa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802efd:	8b 40 04             	mov    0x4(%eax),%eax
  802f00:	85 c0                	test   %eax,%eax
  802f02:	74 0f                	je     802f13 <alloc_block_BF+0x1ca>
  802f04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f07:	8b 40 04             	mov    0x4(%eax),%eax
  802f0a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f0d:	8b 12                	mov    (%edx),%edx
  802f0f:	89 10                	mov    %edx,(%eax)
  802f11:	eb 0a                	jmp    802f1d <alloc_block_BF+0x1d4>
  802f13:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f16:	8b 00                	mov    (%eax),%eax
  802f18:	a3 48 51 80 00       	mov    %eax,0x805148
  802f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f26:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f29:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f30:	a1 54 51 80 00       	mov    0x805154,%eax
  802f35:	48                   	dec    %eax
  802f36:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802f3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3e:	eb 05                	jmp    802f45 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f45:	c9                   	leave  
  802f46:	c3                   	ret    

00802f47 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802f47:	55                   	push   %ebp
  802f48:	89 e5                	mov    %esp,%ebp
  802f4a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802f4d:	a1 38 51 80 00       	mov    0x805138,%eax
  802f52:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802f55:	e9 7c 01 00 00       	jmp    8030d6 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	8b 40 0c             	mov    0xc(%eax),%eax
  802f60:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f63:	0f 86 cf 00 00 00    	jbe    803038 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802f69:	a1 48 51 80 00       	mov    0x805148,%eax
  802f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f74:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802f77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7d:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f83:	8b 50 08             	mov    0x8(%eax),%edx
  802f86:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f89:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f92:	2b 45 08             	sub    0x8(%ebp),%eax
  802f95:	89 c2                	mov    %eax,%edx
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 50 08             	mov    0x8(%eax),%edx
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	01 c2                	add    %eax,%edx
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802fae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fb2:	75 17                	jne    802fcb <alloc_block_NF+0x84>
  802fb4:	83 ec 04             	sub    $0x4,%esp
  802fb7:	68 dd 44 80 00       	push   $0x8044dd
  802fbc:	68 c4 00 00 00       	push   $0xc4
  802fc1:	68 6b 44 80 00       	push   $0x80446b
  802fc6:	e8 36 d9 ff ff       	call   800901 <_panic>
  802fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fce:	8b 00                	mov    (%eax),%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	74 10                	je     802fe4 <alloc_block_NF+0x9d>
  802fd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd7:	8b 00                	mov    (%eax),%eax
  802fd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fdc:	8b 52 04             	mov    0x4(%edx),%edx
  802fdf:	89 50 04             	mov    %edx,0x4(%eax)
  802fe2:	eb 0b                	jmp    802fef <alloc_block_NF+0xa8>
  802fe4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe7:	8b 40 04             	mov    0x4(%eax),%eax
  802fea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff2:	8b 40 04             	mov    0x4(%eax),%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	74 0f                	je     803008 <alloc_block_NF+0xc1>
  802ff9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ffc:	8b 40 04             	mov    0x4(%eax),%eax
  802fff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803002:	8b 12                	mov    (%edx),%edx
  803004:	89 10                	mov    %edx,(%eax)
  803006:	eb 0a                	jmp    803012 <alloc_block_NF+0xcb>
  803008:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300b:	8b 00                	mov    (%eax),%eax
  80300d:	a3 48 51 80 00       	mov    %eax,0x805148
  803012:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803015:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80301b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803025:	a1 54 51 80 00       	mov    0x805154,%eax
  80302a:	48                   	dec    %eax
  80302b:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  803030:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803033:	e9 ad 00 00 00       	jmp    8030e5 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	8b 40 0c             	mov    0xc(%eax),%eax
  80303e:	3b 45 08             	cmp    0x8(%ebp),%eax
  803041:	0f 85 87 00 00 00    	jne    8030ce <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  803047:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304b:	75 17                	jne    803064 <alloc_block_NF+0x11d>
  80304d:	83 ec 04             	sub    $0x4,%esp
  803050:	68 dd 44 80 00       	push   $0x8044dd
  803055:	68 c8 00 00 00       	push   $0xc8
  80305a:	68 6b 44 80 00       	push   $0x80446b
  80305f:	e8 9d d8 ff ff       	call   800901 <_panic>
  803064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803067:	8b 00                	mov    (%eax),%eax
  803069:	85 c0                	test   %eax,%eax
  80306b:	74 10                	je     80307d <alloc_block_NF+0x136>
  80306d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803070:	8b 00                	mov    (%eax),%eax
  803072:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803075:	8b 52 04             	mov    0x4(%edx),%edx
  803078:	89 50 04             	mov    %edx,0x4(%eax)
  80307b:	eb 0b                	jmp    803088 <alloc_block_NF+0x141>
  80307d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803080:	8b 40 04             	mov    0x4(%eax),%eax
  803083:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 40 04             	mov    0x4(%eax),%eax
  80308e:	85 c0                	test   %eax,%eax
  803090:	74 0f                	je     8030a1 <alloc_block_NF+0x15a>
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	8b 40 04             	mov    0x4(%eax),%eax
  803098:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80309b:	8b 12                	mov    (%edx),%edx
  80309d:	89 10                	mov    %edx,(%eax)
  80309f:	eb 0a                	jmp    8030ab <alloc_block_NF+0x164>
  8030a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	a3 38 51 80 00       	mov    %eax,0x805138
  8030ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030be:	a1 44 51 80 00       	mov    0x805144,%eax
  8030c3:	48                   	dec    %eax
  8030c4:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	eb 17                	jmp    8030e5 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8030ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d1:	8b 00                	mov    (%eax),%eax
  8030d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8030d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030da:	0f 85 7a fe ff ff    	jne    802f5a <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8030e0:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8030e5:	c9                   	leave  
  8030e6:	c3                   	ret    

008030e7 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030e7:	55                   	push   %ebp
  8030e8:	89 e5                	mov    %esp,%ebp
  8030ea:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8030ed:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8030f5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8030fd:	a1 44 51 80 00       	mov    0x805144,%eax
  803102:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  803105:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803109:	75 68                	jne    803173 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80310b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80310f:	75 17                	jne    803128 <insert_sorted_with_merge_freeList+0x41>
  803111:	83 ec 04             	sub    $0x4,%esp
  803114:	68 48 44 80 00       	push   $0x804448
  803119:	68 da 00 00 00       	push   $0xda
  80311e:	68 6b 44 80 00       	push   $0x80446b
  803123:	e8 d9 d7 ff ff       	call   800901 <_panic>
  803128:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80312e:	8b 45 08             	mov    0x8(%ebp),%eax
  803131:	89 10                	mov    %edx,(%eax)
  803133:	8b 45 08             	mov    0x8(%ebp),%eax
  803136:	8b 00                	mov    (%eax),%eax
  803138:	85 c0                	test   %eax,%eax
  80313a:	74 0d                	je     803149 <insert_sorted_with_merge_freeList+0x62>
  80313c:	a1 38 51 80 00       	mov    0x805138,%eax
  803141:	8b 55 08             	mov    0x8(%ebp),%edx
  803144:	89 50 04             	mov    %edx,0x4(%eax)
  803147:	eb 08                	jmp    803151 <insert_sorted_with_merge_freeList+0x6a>
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803151:	8b 45 08             	mov    0x8(%ebp),%eax
  803154:	a3 38 51 80 00       	mov    %eax,0x805138
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803163:	a1 44 51 80 00       	mov    0x805144,%eax
  803168:	40                   	inc    %eax
  803169:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  80316e:	e9 49 07 00 00       	jmp    8038bc <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803173:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803176:	8b 50 08             	mov    0x8(%eax),%edx
  803179:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80317c:	8b 40 0c             	mov    0xc(%eax),%eax
  80317f:	01 c2                	add    %eax,%edx
  803181:	8b 45 08             	mov    0x8(%ebp),%eax
  803184:	8b 40 08             	mov    0x8(%eax),%eax
  803187:	39 c2                	cmp    %eax,%edx
  803189:	73 77                	jae    803202 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80318b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318e:	8b 00                	mov    (%eax),%eax
  803190:	85 c0                	test   %eax,%eax
  803192:	75 6e                	jne    803202 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803194:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803198:	74 68                	je     803202 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  80319a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80319e:	75 17                	jne    8031b7 <insert_sorted_with_merge_freeList+0xd0>
  8031a0:	83 ec 04             	sub    $0x4,%esp
  8031a3:	68 84 44 80 00       	push   $0x804484
  8031a8:	68 e0 00 00 00       	push   $0xe0
  8031ad:	68 6b 44 80 00       	push   $0x80446b
  8031b2:	e8 4a d7 ff ff       	call   800901 <_panic>
  8031b7:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	89 50 04             	mov    %edx,0x4(%eax)
  8031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c6:	8b 40 04             	mov    0x4(%eax),%eax
  8031c9:	85 c0                	test   %eax,%eax
  8031cb:	74 0c                	je     8031d9 <insert_sorted_with_merge_freeList+0xf2>
  8031cd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031d5:	89 10                	mov    %edx,(%eax)
  8031d7:	eb 08                	jmp    8031e1 <insert_sorted_with_merge_freeList+0xfa>
  8031d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dc:	a3 38 51 80 00       	mov    %eax,0x805138
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8031f7:	40                   	inc    %eax
  8031f8:	a3 44 51 80 00       	mov    %eax,0x805144
  8031fd:	e9 ba 06 00 00       	jmp    8038bc <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	8b 50 0c             	mov    0xc(%eax),%edx
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	8b 40 08             	mov    0x8(%eax),%eax
  80320e:	01 c2                	add    %eax,%edx
  803210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803213:	8b 40 08             	mov    0x8(%eax),%eax
  803216:	39 c2                	cmp    %eax,%edx
  803218:	73 78                	jae    803292 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  80321a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321d:	8b 40 04             	mov    0x4(%eax),%eax
  803220:	85 c0                	test   %eax,%eax
  803222:	75 6e                	jne    803292 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803224:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803228:	74 68                	je     803292 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80322a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80322e:	75 17                	jne    803247 <insert_sorted_with_merge_freeList+0x160>
  803230:	83 ec 04             	sub    $0x4,%esp
  803233:	68 48 44 80 00       	push   $0x804448
  803238:	68 e6 00 00 00       	push   $0xe6
  80323d:	68 6b 44 80 00       	push   $0x80446b
  803242:	e8 ba d6 ff ff       	call   800901 <_panic>
  803247:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80324d:	8b 45 08             	mov    0x8(%ebp),%eax
  803250:	89 10                	mov    %edx,(%eax)
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	8b 00                	mov    (%eax),%eax
  803257:	85 c0                	test   %eax,%eax
  803259:	74 0d                	je     803268 <insert_sorted_with_merge_freeList+0x181>
  80325b:	a1 38 51 80 00       	mov    0x805138,%eax
  803260:	8b 55 08             	mov    0x8(%ebp),%edx
  803263:	89 50 04             	mov    %edx,0x4(%eax)
  803266:	eb 08                	jmp    803270 <insert_sorted_with_merge_freeList+0x189>
  803268:	8b 45 08             	mov    0x8(%ebp),%eax
  80326b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	a3 38 51 80 00       	mov    %eax,0x805138
  803278:	8b 45 08             	mov    0x8(%ebp),%eax
  80327b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803282:	a1 44 51 80 00       	mov    0x805144,%eax
  803287:	40                   	inc    %eax
  803288:	a3 44 51 80 00       	mov    %eax,0x805144
  80328d:	e9 2a 06 00 00       	jmp    8038bc <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803292:	a1 38 51 80 00       	mov    0x805138,%eax
  803297:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80329a:	e9 ed 05 00 00       	jmp    80388c <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80329f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a2:	8b 00                	mov    (%eax),%eax
  8032a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  8032a7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8032ab:	0f 84 a7 00 00 00    	je     803358 <insert_sorted_with_merge_freeList+0x271>
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	8b 50 0c             	mov    0xc(%eax),%edx
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	8b 40 08             	mov    0x8(%eax),%eax
  8032bd:	01 c2                	add    %eax,%edx
  8032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c2:	8b 40 08             	mov    0x8(%eax),%eax
  8032c5:	39 c2                	cmp    %eax,%edx
  8032c7:	0f 83 8b 00 00 00    	jae    803358 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  8032cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	8b 40 08             	mov    0x8(%eax),%eax
  8032d9:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  8032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032de:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  8032e1:	39 c2                	cmp    %eax,%edx
  8032e3:	73 73                	jae    803358 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  8032e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032e9:	74 06                	je     8032f1 <insert_sorted_with_merge_freeList+0x20a>
  8032eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ef:	75 17                	jne    803308 <insert_sorted_with_merge_freeList+0x221>
  8032f1:	83 ec 04             	sub    $0x4,%esp
  8032f4:	68 fc 44 80 00       	push   $0x8044fc
  8032f9:	68 f0 00 00 00       	push   $0xf0
  8032fe:	68 6b 44 80 00       	push   $0x80446b
  803303:	e8 f9 d5 ff ff       	call   800901 <_panic>
  803308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330b:	8b 10                	mov    (%eax),%edx
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	89 10                	mov    %edx,(%eax)
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	8b 00                	mov    (%eax),%eax
  803317:	85 c0                	test   %eax,%eax
  803319:	74 0b                	je     803326 <insert_sorted_with_merge_freeList+0x23f>
  80331b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331e:	8b 00                	mov    (%eax),%eax
  803320:	8b 55 08             	mov    0x8(%ebp),%edx
  803323:	89 50 04             	mov    %edx,0x4(%eax)
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 55 08             	mov    0x8(%ebp),%edx
  80332c:	89 10                	mov    %edx,(%eax)
  80332e:	8b 45 08             	mov    0x8(%ebp),%eax
  803331:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803334:	89 50 04             	mov    %edx,0x4(%eax)
  803337:	8b 45 08             	mov    0x8(%ebp),%eax
  80333a:	8b 00                	mov    (%eax),%eax
  80333c:	85 c0                	test   %eax,%eax
  80333e:	75 08                	jne    803348 <insert_sorted_with_merge_freeList+0x261>
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803348:	a1 44 51 80 00       	mov    0x805144,%eax
  80334d:	40                   	inc    %eax
  80334e:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  803353:	e9 64 05 00 00       	jmp    8038bc <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803358:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80335d:	8b 50 0c             	mov    0xc(%eax),%edx
  803360:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803365:	8b 40 08             	mov    0x8(%eax),%eax
  803368:	01 c2                	add    %eax,%edx
  80336a:	8b 45 08             	mov    0x8(%ebp),%eax
  80336d:	8b 40 08             	mov    0x8(%eax),%eax
  803370:	39 c2                	cmp    %eax,%edx
  803372:	0f 85 b1 00 00 00    	jne    803429 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803378:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80337d:	85 c0                	test   %eax,%eax
  80337f:	0f 84 a4 00 00 00    	je     803429 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803385:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80338a:	8b 00                	mov    (%eax),%eax
  80338c:	85 c0                	test   %eax,%eax
  80338e:	0f 85 95 00 00 00    	jne    803429 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803394:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803399:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80339f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8033a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a5:	8b 52 0c             	mov    0xc(%edx),%edx
  8033a8:	01 ca                	add    %ecx,%edx
  8033aa:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  8033b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8033c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033c5:	75 17                	jne    8033de <insert_sorted_with_merge_freeList+0x2f7>
  8033c7:	83 ec 04             	sub    $0x4,%esp
  8033ca:	68 48 44 80 00       	push   $0x804448
  8033cf:	68 ff 00 00 00       	push   $0xff
  8033d4:	68 6b 44 80 00       	push   $0x80446b
  8033d9:	e8 23 d5 ff ff       	call   800901 <_panic>
  8033de:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e7:	89 10                	mov    %edx,(%eax)
  8033e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ec:	8b 00                	mov    (%eax),%eax
  8033ee:	85 c0                	test   %eax,%eax
  8033f0:	74 0d                	je     8033ff <insert_sorted_with_merge_freeList+0x318>
  8033f2:	a1 48 51 80 00       	mov    0x805148,%eax
  8033f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fa:	89 50 04             	mov    %edx,0x4(%eax)
  8033fd:	eb 08                	jmp    803407 <insert_sorted_with_merge_freeList+0x320>
  8033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  803402:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803407:	8b 45 08             	mov    0x8(%ebp),%eax
  80340a:	a3 48 51 80 00       	mov    %eax,0x805148
  80340f:	8b 45 08             	mov    0x8(%ebp),%eax
  803412:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803419:	a1 54 51 80 00       	mov    0x805154,%eax
  80341e:	40                   	inc    %eax
  80341f:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803424:	e9 93 04 00 00       	jmp    8038bc <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  803429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342c:	8b 50 08             	mov    0x8(%eax),%edx
  80342f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803432:	8b 40 0c             	mov    0xc(%eax),%eax
  803435:	01 c2                	add    %eax,%edx
  803437:	8b 45 08             	mov    0x8(%ebp),%eax
  80343a:	8b 40 08             	mov    0x8(%eax),%eax
  80343d:	39 c2                	cmp    %eax,%edx
  80343f:	0f 85 ae 00 00 00    	jne    8034f3 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803445:	8b 45 08             	mov    0x8(%ebp),%eax
  803448:	8b 50 0c             	mov    0xc(%eax),%edx
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	8b 40 08             	mov    0x8(%eax),%eax
  803451:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803456:	8b 00                	mov    (%eax),%eax
  803458:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  80345b:	39 c2                	cmp    %eax,%edx
  80345d:	0f 84 90 00 00 00    	je     8034f3 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	8b 50 0c             	mov    0xc(%eax),%edx
  803469:	8b 45 08             	mov    0x8(%ebp),%eax
  80346c:	8b 40 0c             	mov    0xc(%eax),%eax
  80346f:	01 c2                	add    %eax,%edx
  803471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803474:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803477:	8b 45 08             	mov    0x8(%ebp),%eax
  80347a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803481:	8b 45 08             	mov    0x8(%ebp),%eax
  803484:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80348b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80348f:	75 17                	jne    8034a8 <insert_sorted_with_merge_freeList+0x3c1>
  803491:	83 ec 04             	sub    $0x4,%esp
  803494:	68 48 44 80 00       	push   $0x804448
  803499:	68 0b 01 00 00       	push   $0x10b
  80349e:	68 6b 44 80 00       	push   $0x80446b
  8034a3:	e8 59 d4 ff ff       	call   800901 <_panic>
  8034a8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	89 10                	mov    %edx,(%eax)
  8034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b6:	8b 00                	mov    (%eax),%eax
  8034b8:	85 c0                	test   %eax,%eax
  8034ba:	74 0d                	je     8034c9 <insert_sorted_with_merge_freeList+0x3e2>
  8034bc:	a1 48 51 80 00       	mov    0x805148,%eax
  8034c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8034c4:	89 50 04             	mov    %edx,0x4(%eax)
  8034c7:	eb 08                	jmp    8034d1 <insert_sorted_with_merge_freeList+0x3ea>
  8034c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d4:	a3 48 51 80 00       	mov    %eax,0x805148
  8034d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034e3:	a1 54 51 80 00       	mov    0x805154,%eax
  8034e8:	40                   	inc    %eax
  8034e9:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8034ee:	e9 c9 03 00 00       	jmp    8038bc <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8034f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fc:	8b 40 08             	mov    0x8(%eax),%eax
  8034ff:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803504:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803507:	39 c2                	cmp    %eax,%edx
  803509:	0f 85 bb 00 00 00    	jne    8035ca <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  80350f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803513:	0f 84 b1 00 00 00    	je     8035ca <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351c:	8b 40 04             	mov    0x4(%eax),%eax
  80351f:	85 c0                	test   %eax,%eax
  803521:	0f 85 a3 00 00 00    	jne    8035ca <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803527:	a1 38 51 80 00       	mov    0x805138,%eax
  80352c:	8b 55 08             	mov    0x8(%ebp),%edx
  80352f:	8b 52 08             	mov    0x8(%edx),%edx
  803532:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803535:	a1 38 51 80 00       	mov    0x805138,%eax
  80353a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803540:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803543:	8b 55 08             	mov    0x8(%ebp),%edx
  803546:	8b 52 0c             	mov    0xc(%edx),%edx
  803549:	01 ca                	add    %ecx,%edx
  80354b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80354e:	8b 45 08             	mov    0x8(%ebp),%eax
  803551:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803558:	8b 45 08             	mov    0x8(%ebp),%eax
  80355b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803562:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803566:	75 17                	jne    80357f <insert_sorted_with_merge_freeList+0x498>
  803568:	83 ec 04             	sub    $0x4,%esp
  80356b:	68 48 44 80 00       	push   $0x804448
  803570:	68 17 01 00 00       	push   $0x117
  803575:	68 6b 44 80 00       	push   $0x80446b
  80357a:	e8 82 d3 ff ff       	call   800901 <_panic>
  80357f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	89 10                	mov    %edx,(%eax)
  80358a:	8b 45 08             	mov    0x8(%ebp),%eax
  80358d:	8b 00                	mov    (%eax),%eax
  80358f:	85 c0                	test   %eax,%eax
  803591:	74 0d                	je     8035a0 <insert_sorted_with_merge_freeList+0x4b9>
  803593:	a1 48 51 80 00       	mov    0x805148,%eax
  803598:	8b 55 08             	mov    0x8(%ebp),%edx
  80359b:	89 50 04             	mov    %edx,0x4(%eax)
  80359e:	eb 08                	jmp    8035a8 <insert_sorted_with_merge_freeList+0x4c1>
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8035a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8035b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8035bf:	40                   	inc    %eax
  8035c0:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8035c5:	e9 f2 02 00 00       	jmp    8038bc <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  8035ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8035cd:	8b 50 08             	mov    0x8(%eax),%edx
  8035d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d6:	01 c2                	add    %eax,%edx
  8035d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035db:	8b 40 08             	mov    0x8(%eax),%eax
  8035de:	39 c2                	cmp    %eax,%edx
  8035e0:	0f 85 be 00 00 00    	jne    8036a4 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  8035e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e9:	8b 40 04             	mov    0x4(%eax),%eax
  8035ec:	8b 50 08             	mov    0x8(%eax),%edx
  8035ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f2:	8b 40 04             	mov    0x4(%eax),%eax
  8035f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f8:	01 c2                	add    %eax,%edx
  8035fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fd:	8b 40 08             	mov    0x8(%eax),%eax
  803600:	39 c2                	cmp    %eax,%edx
  803602:	0f 84 9c 00 00 00    	je     8036a4 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  803608:	8b 45 08             	mov    0x8(%ebp),%eax
  80360b:	8b 50 08             	mov    0x8(%eax),%edx
  80360e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803611:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803617:	8b 50 0c             	mov    0xc(%eax),%edx
  80361a:	8b 45 08             	mov    0x8(%ebp),%eax
  80361d:	8b 40 0c             	mov    0xc(%eax),%eax
  803620:	01 c2                	add    %eax,%edx
  803622:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803625:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803628:	8b 45 08             	mov    0x8(%ebp),%eax
  80362b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803632:	8b 45 08             	mov    0x8(%ebp),%eax
  803635:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80363c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803640:	75 17                	jne    803659 <insert_sorted_with_merge_freeList+0x572>
  803642:	83 ec 04             	sub    $0x4,%esp
  803645:	68 48 44 80 00       	push   $0x804448
  80364a:	68 26 01 00 00       	push   $0x126
  80364f:	68 6b 44 80 00       	push   $0x80446b
  803654:	e8 a8 d2 ff ff       	call   800901 <_panic>
  803659:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80365f:	8b 45 08             	mov    0x8(%ebp),%eax
  803662:	89 10                	mov    %edx,(%eax)
  803664:	8b 45 08             	mov    0x8(%ebp),%eax
  803667:	8b 00                	mov    (%eax),%eax
  803669:	85 c0                	test   %eax,%eax
  80366b:	74 0d                	je     80367a <insert_sorted_with_merge_freeList+0x593>
  80366d:	a1 48 51 80 00       	mov    0x805148,%eax
  803672:	8b 55 08             	mov    0x8(%ebp),%edx
  803675:	89 50 04             	mov    %edx,0x4(%eax)
  803678:	eb 08                	jmp    803682 <insert_sorted_with_merge_freeList+0x59b>
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803682:	8b 45 08             	mov    0x8(%ebp),%eax
  803685:	a3 48 51 80 00       	mov    %eax,0x805148
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803694:	a1 54 51 80 00       	mov    0x805154,%eax
  803699:	40                   	inc    %eax
  80369a:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  80369f:	e9 18 02 00 00       	jmp    8038bc <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  8036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a7:	8b 50 0c             	mov    0xc(%eax),%edx
  8036aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ad:	8b 40 08             	mov    0x8(%eax),%eax
  8036b0:	01 c2                	add    %eax,%edx
  8036b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036b5:	8b 40 08             	mov    0x8(%eax),%eax
  8036b8:	39 c2                	cmp    %eax,%edx
  8036ba:	0f 85 c4 01 00 00    	jne    803884 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  8036c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8036c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c9:	8b 40 08             	mov    0x8(%eax),%eax
  8036cc:	01 c2                	add    %eax,%edx
  8036ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d1:	8b 00                	mov    (%eax),%eax
  8036d3:	8b 40 08             	mov    0x8(%eax),%eax
  8036d6:	39 c2                	cmp    %eax,%edx
  8036d8:	0f 85 a6 01 00 00    	jne    803884 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8036de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036e2:	0f 84 9c 01 00 00    	je     803884 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  8036e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036eb:	8b 50 0c             	mov    0xc(%eax),%edx
  8036ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8036f4:	01 c2                	add    %eax,%edx
  8036f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f9:	8b 00                	mov    (%eax),%eax
  8036fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8036fe:	01 c2                	add    %eax,%edx
  803700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803703:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803706:	8b 45 08             	mov    0x8(%ebp),%eax
  803709:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803710:	8b 45 08             	mov    0x8(%ebp),%eax
  803713:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80371a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80371e:	75 17                	jne    803737 <insert_sorted_with_merge_freeList+0x650>
  803720:	83 ec 04             	sub    $0x4,%esp
  803723:	68 48 44 80 00       	push   $0x804448
  803728:	68 32 01 00 00       	push   $0x132
  80372d:	68 6b 44 80 00       	push   $0x80446b
  803732:	e8 ca d1 ff ff       	call   800901 <_panic>
  803737:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80373d:	8b 45 08             	mov    0x8(%ebp),%eax
  803740:	89 10                	mov    %edx,(%eax)
  803742:	8b 45 08             	mov    0x8(%ebp),%eax
  803745:	8b 00                	mov    (%eax),%eax
  803747:	85 c0                	test   %eax,%eax
  803749:	74 0d                	je     803758 <insert_sorted_with_merge_freeList+0x671>
  80374b:	a1 48 51 80 00       	mov    0x805148,%eax
  803750:	8b 55 08             	mov    0x8(%ebp),%edx
  803753:	89 50 04             	mov    %edx,0x4(%eax)
  803756:	eb 08                	jmp    803760 <insert_sorted_with_merge_freeList+0x679>
  803758:	8b 45 08             	mov    0x8(%ebp),%eax
  80375b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803760:	8b 45 08             	mov    0x8(%ebp),%eax
  803763:	a3 48 51 80 00       	mov    %eax,0x805148
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803772:	a1 54 51 80 00       	mov    0x805154,%eax
  803777:	40                   	inc    %eax
  803778:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  80377d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803780:	8b 00                	mov    (%eax),%eax
  803782:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378c:	8b 00                	mov    (%eax),%eax
  80378e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803798:	8b 00                	mov    (%eax),%eax
  80379a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80379d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037a1:	75 17                	jne    8037ba <insert_sorted_with_merge_freeList+0x6d3>
  8037a3:	83 ec 04             	sub    $0x4,%esp
  8037a6:	68 dd 44 80 00       	push   $0x8044dd
  8037ab:	68 36 01 00 00       	push   $0x136
  8037b0:	68 6b 44 80 00       	push   $0x80446b
  8037b5:	e8 47 d1 ff ff       	call   800901 <_panic>
  8037ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bd:	8b 00                	mov    (%eax),%eax
  8037bf:	85 c0                	test   %eax,%eax
  8037c1:	74 10                	je     8037d3 <insert_sorted_with_merge_freeList+0x6ec>
  8037c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c6:	8b 00                	mov    (%eax),%eax
  8037c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037cb:	8b 52 04             	mov    0x4(%edx),%edx
  8037ce:	89 50 04             	mov    %edx,0x4(%eax)
  8037d1:	eb 0b                	jmp    8037de <insert_sorted_with_merge_freeList+0x6f7>
  8037d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d6:	8b 40 04             	mov    0x4(%eax),%eax
  8037d9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e1:	8b 40 04             	mov    0x4(%eax),%eax
  8037e4:	85 c0                	test   %eax,%eax
  8037e6:	74 0f                	je     8037f7 <insert_sorted_with_merge_freeList+0x710>
  8037e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037eb:	8b 40 04             	mov    0x4(%eax),%eax
  8037ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037f1:	8b 12                	mov    (%edx),%edx
  8037f3:	89 10                	mov    %edx,(%eax)
  8037f5:	eb 0a                	jmp    803801 <insert_sorted_with_merge_freeList+0x71a>
  8037f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fa:	8b 00                	mov    (%eax),%eax
  8037fc:	a3 38 51 80 00       	mov    %eax,0x805138
  803801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803804:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80380a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803814:	a1 44 51 80 00       	mov    0x805144,%eax
  803819:	48                   	dec    %eax
  80381a:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80381f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803823:	75 17                	jne    80383c <insert_sorted_with_merge_freeList+0x755>
  803825:	83 ec 04             	sub    $0x4,%esp
  803828:	68 48 44 80 00       	push   $0x804448
  80382d:	68 37 01 00 00       	push   $0x137
  803832:	68 6b 44 80 00       	push   $0x80446b
  803837:	e8 c5 d0 ff ff       	call   800901 <_panic>
  80383c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803845:	89 10                	mov    %edx,(%eax)
  803847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80384a:	8b 00                	mov    (%eax),%eax
  80384c:	85 c0                	test   %eax,%eax
  80384e:	74 0d                	je     80385d <insert_sorted_with_merge_freeList+0x776>
  803850:	a1 48 51 80 00       	mov    0x805148,%eax
  803855:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803858:	89 50 04             	mov    %edx,0x4(%eax)
  80385b:	eb 08                	jmp    803865 <insert_sorted_with_merge_freeList+0x77e>
  80385d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803860:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803865:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803868:	a3 48 51 80 00       	mov    %eax,0x805148
  80386d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803870:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803877:	a1 54 51 80 00       	mov    0x805154,%eax
  80387c:	40                   	inc    %eax
  80387d:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803882:	eb 38                	jmp    8038bc <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803884:	a1 40 51 80 00       	mov    0x805140,%eax
  803889:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80388c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803890:	74 07                	je     803899 <insert_sorted_with_merge_freeList+0x7b2>
  803892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803895:	8b 00                	mov    (%eax),%eax
  803897:	eb 05                	jmp    80389e <insert_sorted_with_merge_freeList+0x7b7>
  803899:	b8 00 00 00 00       	mov    $0x0,%eax
  80389e:	a3 40 51 80 00       	mov    %eax,0x805140
  8038a3:	a1 40 51 80 00       	mov    0x805140,%eax
  8038a8:	85 c0                	test   %eax,%eax
  8038aa:	0f 85 ef f9 ff ff    	jne    80329f <insert_sorted_with_merge_freeList+0x1b8>
  8038b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038b4:	0f 85 e5 f9 ff ff    	jne    80329f <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8038ba:	eb 00                	jmp    8038bc <insert_sorted_with_merge_freeList+0x7d5>
  8038bc:	90                   	nop
  8038bd:	c9                   	leave  
  8038be:	c3                   	ret    
  8038bf:	90                   	nop

008038c0 <__udivdi3>:
  8038c0:	55                   	push   %ebp
  8038c1:	57                   	push   %edi
  8038c2:	56                   	push   %esi
  8038c3:	53                   	push   %ebx
  8038c4:	83 ec 1c             	sub    $0x1c,%esp
  8038c7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038cb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038cf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038d7:	89 ca                	mov    %ecx,%edx
  8038d9:	89 f8                	mov    %edi,%eax
  8038db:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038df:	85 f6                	test   %esi,%esi
  8038e1:	75 2d                	jne    803910 <__udivdi3+0x50>
  8038e3:	39 cf                	cmp    %ecx,%edi
  8038e5:	77 65                	ja     80394c <__udivdi3+0x8c>
  8038e7:	89 fd                	mov    %edi,%ebp
  8038e9:	85 ff                	test   %edi,%edi
  8038eb:	75 0b                	jne    8038f8 <__udivdi3+0x38>
  8038ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8038f2:	31 d2                	xor    %edx,%edx
  8038f4:	f7 f7                	div    %edi
  8038f6:	89 c5                	mov    %eax,%ebp
  8038f8:	31 d2                	xor    %edx,%edx
  8038fa:	89 c8                	mov    %ecx,%eax
  8038fc:	f7 f5                	div    %ebp
  8038fe:	89 c1                	mov    %eax,%ecx
  803900:	89 d8                	mov    %ebx,%eax
  803902:	f7 f5                	div    %ebp
  803904:	89 cf                	mov    %ecx,%edi
  803906:	89 fa                	mov    %edi,%edx
  803908:	83 c4 1c             	add    $0x1c,%esp
  80390b:	5b                   	pop    %ebx
  80390c:	5e                   	pop    %esi
  80390d:	5f                   	pop    %edi
  80390e:	5d                   	pop    %ebp
  80390f:	c3                   	ret    
  803910:	39 ce                	cmp    %ecx,%esi
  803912:	77 28                	ja     80393c <__udivdi3+0x7c>
  803914:	0f bd fe             	bsr    %esi,%edi
  803917:	83 f7 1f             	xor    $0x1f,%edi
  80391a:	75 40                	jne    80395c <__udivdi3+0x9c>
  80391c:	39 ce                	cmp    %ecx,%esi
  80391e:	72 0a                	jb     80392a <__udivdi3+0x6a>
  803920:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803924:	0f 87 9e 00 00 00    	ja     8039c8 <__udivdi3+0x108>
  80392a:	b8 01 00 00 00       	mov    $0x1,%eax
  80392f:	89 fa                	mov    %edi,%edx
  803931:	83 c4 1c             	add    $0x1c,%esp
  803934:	5b                   	pop    %ebx
  803935:	5e                   	pop    %esi
  803936:	5f                   	pop    %edi
  803937:	5d                   	pop    %ebp
  803938:	c3                   	ret    
  803939:	8d 76 00             	lea    0x0(%esi),%esi
  80393c:	31 ff                	xor    %edi,%edi
  80393e:	31 c0                	xor    %eax,%eax
  803940:	89 fa                	mov    %edi,%edx
  803942:	83 c4 1c             	add    $0x1c,%esp
  803945:	5b                   	pop    %ebx
  803946:	5e                   	pop    %esi
  803947:	5f                   	pop    %edi
  803948:	5d                   	pop    %ebp
  803949:	c3                   	ret    
  80394a:	66 90                	xchg   %ax,%ax
  80394c:	89 d8                	mov    %ebx,%eax
  80394e:	f7 f7                	div    %edi
  803950:	31 ff                	xor    %edi,%edi
  803952:	89 fa                	mov    %edi,%edx
  803954:	83 c4 1c             	add    $0x1c,%esp
  803957:	5b                   	pop    %ebx
  803958:	5e                   	pop    %esi
  803959:	5f                   	pop    %edi
  80395a:	5d                   	pop    %ebp
  80395b:	c3                   	ret    
  80395c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803961:	89 eb                	mov    %ebp,%ebx
  803963:	29 fb                	sub    %edi,%ebx
  803965:	89 f9                	mov    %edi,%ecx
  803967:	d3 e6                	shl    %cl,%esi
  803969:	89 c5                	mov    %eax,%ebp
  80396b:	88 d9                	mov    %bl,%cl
  80396d:	d3 ed                	shr    %cl,%ebp
  80396f:	89 e9                	mov    %ebp,%ecx
  803971:	09 f1                	or     %esi,%ecx
  803973:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803977:	89 f9                	mov    %edi,%ecx
  803979:	d3 e0                	shl    %cl,%eax
  80397b:	89 c5                	mov    %eax,%ebp
  80397d:	89 d6                	mov    %edx,%esi
  80397f:	88 d9                	mov    %bl,%cl
  803981:	d3 ee                	shr    %cl,%esi
  803983:	89 f9                	mov    %edi,%ecx
  803985:	d3 e2                	shl    %cl,%edx
  803987:	8b 44 24 08          	mov    0x8(%esp),%eax
  80398b:	88 d9                	mov    %bl,%cl
  80398d:	d3 e8                	shr    %cl,%eax
  80398f:	09 c2                	or     %eax,%edx
  803991:	89 d0                	mov    %edx,%eax
  803993:	89 f2                	mov    %esi,%edx
  803995:	f7 74 24 0c          	divl   0xc(%esp)
  803999:	89 d6                	mov    %edx,%esi
  80399b:	89 c3                	mov    %eax,%ebx
  80399d:	f7 e5                	mul    %ebp
  80399f:	39 d6                	cmp    %edx,%esi
  8039a1:	72 19                	jb     8039bc <__udivdi3+0xfc>
  8039a3:	74 0b                	je     8039b0 <__udivdi3+0xf0>
  8039a5:	89 d8                	mov    %ebx,%eax
  8039a7:	31 ff                	xor    %edi,%edi
  8039a9:	e9 58 ff ff ff       	jmp    803906 <__udivdi3+0x46>
  8039ae:	66 90                	xchg   %ax,%ax
  8039b0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8039b4:	89 f9                	mov    %edi,%ecx
  8039b6:	d3 e2                	shl    %cl,%edx
  8039b8:	39 c2                	cmp    %eax,%edx
  8039ba:	73 e9                	jae    8039a5 <__udivdi3+0xe5>
  8039bc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8039bf:	31 ff                	xor    %edi,%edi
  8039c1:	e9 40 ff ff ff       	jmp    803906 <__udivdi3+0x46>
  8039c6:	66 90                	xchg   %ax,%ax
  8039c8:	31 c0                	xor    %eax,%eax
  8039ca:	e9 37 ff ff ff       	jmp    803906 <__udivdi3+0x46>
  8039cf:	90                   	nop

008039d0 <__umoddi3>:
  8039d0:	55                   	push   %ebp
  8039d1:	57                   	push   %edi
  8039d2:	56                   	push   %esi
  8039d3:	53                   	push   %ebx
  8039d4:	83 ec 1c             	sub    $0x1c,%esp
  8039d7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039db:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039e3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039eb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039ef:	89 f3                	mov    %esi,%ebx
  8039f1:	89 fa                	mov    %edi,%edx
  8039f3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039f7:	89 34 24             	mov    %esi,(%esp)
  8039fa:	85 c0                	test   %eax,%eax
  8039fc:	75 1a                	jne    803a18 <__umoddi3+0x48>
  8039fe:	39 f7                	cmp    %esi,%edi
  803a00:	0f 86 a2 00 00 00    	jbe    803aa8 <__umoddi3+0xd8>
  803a06:	89 c8                	mov    %ecx,%eax
  803a08:	89 f2                	mov    %esi,%edx
  803a0a:	f7 f7                	div    %edi
  803a0c:	89 d0                	mov    %edx,%eax
  803a0e:	31 d2                	xor    %edx,%edx
  803a10:	83 c4 1c             	add    $0x1c,%esp
  803a13:	5b                   	pop    %ebx
  803a14:	5e                   	pop    %esi
  803a15:	5f                   	pop    %edi
  803a16:	5d                   	pop    %ebp
  803a17:	c3                   	ret    
  803a18:	39 f0                	cmp    %esi,%eax
  803a1a:	0f 87 ac 00 00 00    	ja     803acc <__umoddi3+0xfc>
  803a20:	0f bd e8             	bsr    %eax,%ebp
  803a23:	83 f5 1f             	xor    $0x1f,%ebp
  803a26:	0f 84 ac 00 00 00    	je     803ad8 <__umoddi3+0x108>
  803a2c:	bf 20 00 00 00       	mov    $0x20,%edi
  803a31:	29 ef                	sub    %ebp,%edi
  803a33:	89 fe                	mov    %edi,%esi
  803a35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a39:	89 e9                	mov    %ebp,%ecx
  803a3b:	d3 e0                	shl    %cl,%eax
  803a3d:	89 d7                	mov    %edx,%edi
  803a3f:	89 f1                	mov    %esi,%ecx
  803a41:	d3 ef                	shr    %cl,%edi
  803a43:	09 c7                	or     %eax,%edi
  803a45:	89 e9                	mov    %ebp,%ecx
  803a47:	d3 e2                	shl    %cl,%edx
  803a49:	89 14 24             	mov    %edx,(%esp)
  803a4c:	89 d8                	mov    %ebx,%eax
  803a4e:	d3 e0                	shl    %cl,%eax
  803a50:	89 c2                	mov    %eax,%edx
  803a52:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a56:	d3 e0                	shl    %cl,%eax
  803a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a5c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a60:	89 f1                	mov    %esi,%ecx
  803a62:	d3 e8                	shr    %cl,%eax
  803a64:	09 d0                	or     %edx,%eax
  803a66:	d3 eb                	shr    %cl,%ebx
  803a68:	89 da                	mov    %ebx,%edx
  803a6a:	f7 f7                	div    %edi
  803a6c:	89 d3                	mov    %edx,%ebx
  803a6e:	f7 24 24             	mull   (%esp)
  803a71:	89 c6                	mov    %eax,%esi
  803a73:	89 d1                	mov    %edx,%ecx
  803a75:	39 d3                	cmp    %edx,%ebx
  803a77:	0f 82 87 00 00 00    	jb     803b04 <__umoddi3+0x134>
  803a7d:	0f 84 91 00 00 00    	je     803b14 <__umoddi3+0x144>
  803a83:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a87:	29 f2                	sub    %esi,%edx
  803a89:	19 cb                	sbb    %ecx,%ebx
  803a8b:	89 d8                	mov    %ebx,%eax
  803a8d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a91:	d3 e0                	shl    %cl,%eax
  803a93:	89 e9                	mov    %ebp,%ecx
  803a95:	d3 ea                	shr    %cl,%edx
  803a97:	09 d0                	or     %edx,%eax
  803a99:	89 e9                	mov    %ebp,%ecx
  803a9b:	d3 eb                	shr    %cl,%ebx
  803a9d:	89 da                	mov    %ebx,%edx
  803a9f:	83 c4 1c             	add    $0x1c,%esp
  803aa2:	5b                   	pop    %ebx
  803aa3:	5e                   	pop    %esi
  803aa4:	5f                   	pop    %edi
  803aa5:	5d                   	pop    %ebp
  803aa6:	c3                   	ret    
  803aa7:	90                   	nop
  803aa8:	89 fd                	mov    %edi,%ebp
  803aaa:	85 ff                	test   %edi,%edi
  803aac:	75 0b                	jne    803ab9 <__umoddi3+0xe9>
  803aae:	b8 01 00 00 00       	mov    $0x1,%eax
  803ab3:	31 d2                	xor    %edx,%edx
  803ab5:	f7 f7                	div    %edi
  803ab7:	89 c5                	mov    %eax,%ebp
  803ab9:	89 f0                	mov    %esi,%eax
  803abb:	31 d2                	xor    %edx,%edx
  803abd:	f7 f5                	div    %ebp
  803abf:	89 c8                	mov    %ecx,%eax
  803ac1:	f7 f5                	div    %ebp
  803ac3:	89 d0                	mov    %edx,%eax
  803ac5:	e9 44 ff ff ff       	jmp    803a0e <__umoddi3+0x3e>
  803aca:	66 90                	xchg   %ax,%ax
  803acc:	89 c8                	mov    %ecx,%eax
  803ace:	89 f2                	mov    %esi,%edx
  803ad0:	83 c4 1c             	add    $0x1c,%esp
  803ad3:	5b                   	pop    %ebx
  803ad4:	5e                   	pop    %esi
  803ad5:	5f                   	pop    %edi
  803ad6:	5d                   	pop    %ebp
  803ad7:	c3                   	ret    
  803ad8:	3b 04 24             	cmp    (%esp),%eax
  803adb:	72 06                	jb     803ae3 <__umoddi3+0x113>
  803add:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ae1:	77 0f                	ja     803af2 <__umoddi3+0x122>
  803ae3:	89 f2                	mov    %esi,%edx
  803ae5:	29 f9                	sub    %edi,%ecx
  803ae7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803aeb:	89 14 24             	mov    %edx,(%esp)
  803aee:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803af2:	8b 44 24 04          	mov    0x4(%esp),%eax
  803af6:	8b 14 24             	mov    (%esp),%edx
  803af9:	83 c4 1c             	add    $0x1c,%esp
  803afc:	5b                   	pop    %ebx
  803afd:	5e                   	pop    %esi
  803afe:	5f                   	pop    %edi
  803aff:	5d                   	pop    %ebp
  803b00:	c3                   	ret    
  803b01:	8d 76 00             	lea    0x0(%esi),%esi
  803b04:	2b 04 24             	sub    (%esp),%eax
  803b07:	19 fa                	sbb    %edi,%edx
  803b09:	89 d1                	mov    %edx,%ecx
  803b0b:	89 c6                	mov    %eax,%esi
  803b0d:	e9 71 ff ff ff       	jmp    803a83 <__umoddi3+0xb3>
  803b12:	66 90                	xchg   %ax,%ax
  803b14:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803b18:	72 ea                	jb     803b04 <__umoddi3+0x134>
  803b1a:	89 d9                	mov    %ebx,%ecx
  803b1c:	e9 62 ff ff ff       	jmp    803a83 <__umoddi3+0xb3>
