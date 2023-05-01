
obj/user/mergesort_leakage:     file format elf32-i386


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
  800031:	e8 65 07 00 00       	call   80079b <libmain>
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
  800041:	e8 75 22 00 00       	call   8022bb <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 00 3b 80 00       	push   $0x803b00
  80004e:	e8 38 0b 00 00       	call   800b8b <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 02 3b 80 00       	push   $0x803b02
  80005e:	e8 28 0b 00 00       	call   800b8b <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 18 3b 80 00       	push   $0x803b18
  80006e:	e8 18 0b 00 00       	call   800b8b <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 02 3b 80 00       	push   $0x803b02
  80007e:	e8 08 0b 00 00       	call   800b8b <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 00 3b 80 00       	push   $0x803b00
  80008e:	e8 f8 0a 00 00       	call   800b8b <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80009f:	50                   	push   %eax
  8000a0:	68 30 3b 80 00       	push   $0x803b30
  8000a5:	e8 63 11 00 00       	call   80120d <readline>
  8000aa:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 0a                	push   $0xa
  8000b2:	6a 00                	push   $0x0
  8000b4:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8000ba:	50                   	push   %eax
  8000bb:	e8 b3 16 00 00       	call   801773 <strtol>
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c9:	c1 e0 02             	shl    $0x2,%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 5b 1c 00 00       	call   801d30 <malloc>
  8000d5:	83 c4 10             	add    $0x10,%esp
  8000d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	68 50 3b 80 00       	push   $0x803b50
  8000e3:	e8 a3 0a 00 00       	call   800b8b <cprintf>
  8000e8:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000eb:	83 ec 0c             	sub    $0xc,%esp
  8000ee:	68 72 3b 80 00       	push   $0x803b72
  8000f3:	e8 93 0a 00 00       	call   800b8b <cprintf>
  8000f8:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000fb:	83 ec 0c             	sub    $0xc,%esp
  8000fe:	68 80 3b 80 00       	push   $0x803b80
  800103:	e8 83 0a 00 00       	call   800b8b <cprintf>
  800108:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	68 8f 3b 80 00       	push   $0x803b8f
  800113:	e8 73 0a 00 00       	call   800b8b <cprintf>
  800118:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011b:	83 ec 0c             	sub    $0xc,%esp
  80011e:	68 9f 3b 80 00       	push   $0x803b9f
  800123:	e8 63 0a 00 00       	call   800b8b <cprintf>
  800128:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012b:	e8 13 06 00 00       	call   800743 <getchar>
  800130:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800133:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800137:	83 ec 0c             	sub    $0xc,%esp
  80013a:	50                   	push   %eax
  80013b:	e8 bb 05 00 00       	call   8006fb <cputchar>
  800140:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800143:	83 ec 0c             	sub    $0xc,%esp
  800146:	6a 0a                	push   $0xa
  800148:	e8 ae 05 00 00       	call   8006fb <cputchar>
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
  800162:	e8 6e 21 00 00       	call   8022d5 <sys_enable_interrupt>

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
  800183:	e8 e6 01 00 00       	call   80036e <InitializeAscending>
  800188:	83 c4 10             	add    $0x10,%esp
			break ;
  80018b:	eb 37                	jmp    8001c4 <_main+0x18c>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	ff 75 f0             	pushl  -0x10(%ebp)
  800193:	ff 75 ec             	pushl  -0x14(%ebp)
  800196:	e8 04 02 00 00       	call   80039f <InitializeDescending>
  80019b:	83 c4 10             	add    $0x10,%esp
			break ;
  80019e:	eb 24                	jmp    8001c4 <_main+0x18c>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a0:	83 ec 08             	sub    $0x8,%esp
  8001a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 26 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001ae:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b1:	eb 11                	jmp    8001c4 <_main+0x18c>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b3:	83 ec 08             	sub    $0x8,%esp
  8001b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bc:	e8 13 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001c1:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001c4:	83 ec 04             	sub    $0x4,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	6a 01                	push   $0x1
  8001cc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cf:	e8 d2 02 00 00       	call   8004a6 <MSort>
  8001d4:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001d7:	e8 df 20 00 00       	call   8022bb <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	68 a8 3b 80 00       	push   $0x803ba8
  8001e4:	e8 a2 09 00 00       	call   800b8b <cprintf>
  8001e9:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001ec:	e8 e4 20 00 00       	call   8022d5 <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001f1:	83 ec 08             	sub    $0x8,%esp
  8001f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001fa:	e8 c5 00 00 00       	call   8002c4 <CheckSorted>
  8001ff:	83 c4 10             	add    $0x10,%esp
  800202:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  800205:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800209:	75 14                	jne    80021f <_main+0x1e7>
  80020b:	83 ec 04             	sub    $0x4,%esp
  80020e:	68 dc 3b 80 00       	push   $0x803bdc
  800213:	6a 4a                	push   $0x4a
  800215:	68 fe 3b 80 00       	push   $0x803bfe
  80021a:	e8 b8 06 00 00       	call   8008d7 <_panic>
		else
		{
			sys_disable_interrupt();
  80021f:	e8 97 20 00 00       	call   8022bb <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	68 18 3c 80 00       	push   $0x803c18
  80022c:	e8 5a 09 00 00       	call   800b8b <cprintf>
  800231:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800234:	83 ec 0c             	sub    $0xc,%esp
  800237:	68 4c 3c 80 00       	push   $0x803c4c
  80023c:	e8 4a 09 00 00       	call   800b8b <cprintf>
  800241:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800244:	83 ec 0c             	sub    $0xc,%esp
  800247:	68 80 3c 80 00       	push   $0x803c80
  80024c:	e8 3a 09 00 00       	call   800b8b <cprintf>
  800251:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  800254:	e8 7c 20 00 00       	call   8022d5 <sys_enable_interrupt>
		}

		//free(Elements) ;

		sys_disable_interrupt();
  800259:	e8 5d 20 00 00       	call   8022bb <sys_disable_interrupt>
			Chose = 0 ;
  80025e:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800262:	eb 42                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 b2 3c 80 00       	push   $0x803cb2
  80026c:	e8 1a 09 00 00       	call   800b8b <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
				Chose = getchar() ;
  800274:	e8 ca 04 00 00       	call   800743 <getchar>
  800279:	88 45 f7             	mov    %al,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 72 04 00 00       	call   8006fb <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 65 04 00 00       	call   8006fb <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 58 04 00 00       	call   8006fb <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		//free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b2                	jne    800264 <_main+0x22c>
				Chose = getchar() ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 1e 20 00 00       	call   8022d5 <sys_enable_interrupt>

	} while (Chose == 'y');
  8002b7:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002bb:	0f 84 80 fd ff ff    	je     800041 <_main+0x9>

}
  8002c1:	90                   	nop
  8002c2:	c9                   	leave  
  8002c3:	c3                   	ret    

008002c4 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8002c4:	55                   	push   %ebp
  8002c5:	89 e5                	mov    %esp,%ebp
  8002c7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8002ca:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8002d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8002d8:	eb 33                	jmp    80030d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8002da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8002ee:	40                   	inc    %eax
  8002ef:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	01 c8                	add    %ecx,%eax
  8002fb:	8b 00                	mov    (%eax),%eax
  8002fd:	39 c2                	cmp    %eax,%edx
  8002ff:	7e 09                	jle    80030a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800301:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800308:	eb 0c                	jmp    800316 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80030a:	ff 45 f8             	incl   -0x8(%ebp)
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	48                   	dec    %eax
  800311:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800314:	7f c4                	jg     8002da <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800316:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800321:	8b 45 0c             	mov    0xc(%ebp),%eax
  800324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032b:	8b 45 08             	mov    0x8(%ebp),%eax
  80032e:	01 d0                	add    %edx,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800335:	8b 45 0c             	mov    0xc(%ebp),%eax
  800338:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033f:	8b 45 08             	mov    0x8(%ebp),%eax
  800342:	01 c2                	add    %eax,%edx
  800344:	8b 45 10             	mov    0x10(%ebp),%eax
  800347:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80034e:	8b 45 08             	mov    0x8(%ebp),%eax
  800351:	01 c8                	add    %ecx,%eax
  800353:	8b 00                	mov    (%eax),%eax
  800355:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800357:	8b 45 10             	mov    0x10(%ebp),%eax
  80035a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	01 c2                	add    %eax,%edx
  800366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800369:	89 02                	mov    %eax,(%edx)
}
  80036b:	90                   	nop
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80037b:	eb 17                	jmp    800394 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80037d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800387:	8b 45 08             	mov    0x8(%ebp),%eax
  80038a:	01 c2                	add    %eax,%edx
  80038c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80038f:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800391:	ff 45 fc             	incl   -0x4(%ebp)
  800394:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800397:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80039a:	7c e1                	jl     80037d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  80039c:	90                   	nop
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003ac:	eb 1b                	jmp    8003c9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8003ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bb:	01 c2                	add    %eax,%edx
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8003c3:	48                   	dec    %eax
  8003c4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8003c6:	ff 45 fc             	incl   -0x4(%ebp)
  8003c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003cf:	7c dd                	jl     8003ae <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8003d1:	90                   	nop
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    

008003d4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8003d4:	55                   	push   %ebp
  8003d5:	89 e5                	mov    %esp,%ebp
  8003d7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8003e2:	f7 e9                	imul   %ecx
  8003e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8003e7:	89 d0                	mov    %edx,%eax
  8003e9:	29 c8                	sub    %ecx,%eax
  8003eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8003ee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8003f5:	eb 1e                	jmp    800415 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8003f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8003fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800407:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040a:	99                   	cltd   
  80040b:	f7 7d f8             	idivl  -0x8(%ebp)
  80040e:	89 d0                	mov    %edx,%eax
  800410:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800412:	ff 45 fc             	incl   -0x4(%ebp)
  800415:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800418:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80041b:	7c da                	jl     8003f7 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//	cprintf("i=%d\n",i);
	}

}
  80041d:	90                   	nop
  80041e:	c9                   	leave  
  80041f:	c3                   	ret    

00800420 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800426:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80042d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800434:	eb 42                	jmp    800478 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800439:	99                   	cltd   
  80043a:	f7 7d f0             	idivl  -0x10(%ebp)
  80043d:	89 d0                	mov    %edx,%eax
  80043f:	85 c0                	test   %eax,%eax
  800441:	75 10                	jne    800453 <PrintElements+0x33>
			cprintf("\n");
  800443:	83 ec 0c             	sub    $0xc,%esp
  800446:	68 00 3b 80 00       	push   $0x803b00
  80044b:	e8 3b 07 00 00       	call   800b8b <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 d0 3c 80 00       	push   $0x803cd0
  80046d:	e8 19 07 00 00       	call   800b8b <cprintf>
  800472:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800475:	ff 45 f4             	incl   -0xc(%ebp)
  800478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047b:	48                   	dec    %eax
  80047c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80047f:	7f b5                	jg     800436 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800484:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	01 d0                	add    %edx,%eax
  800490:	8b 00                	mov    (%eax),%eax
  800492:	83 ec 08             	sub    $0x8,%esp
  800495:	50                   	push   %eax
  800496:	68 d5 3c 80 00       	push   $0x803cd5
  80049b:	e8 eb 06 00 00       	call   800b8b <cprintf>
  8004a0:	83 c4 10             	add    $0x10,%esp

}
  8004a3:	90                   	nop
  8004a4:	c9                   	leave  
  8004a5:	c3                   	ret    

008004a6 <MSort>:


void MSort(int* A, int p, int r)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
  8004a9:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  8004ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004af:	3b 45 10             	cmp    0x10(%ebp),%eax
  8004b2:	7d 54                	jge    800508 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  8004b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ba:	01 d0                	add    %edx,%eax
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 1f             	shr    $0x1f,%edx
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	d1 f8                	sar    %eax
  8004c5:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  8004c8:	83 ec 04             	sub    $0x4,%esp
  8004cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8004ce:	ff 75 0c             	pushl  0xc(%ebp)
  8004d1:	ff 75 08             	pushl  0x8(%ebp)
  8004d4:	e8 cd ff ff ff       	call   8004a6 <MSort>
  8004d9:	83 c4 10             	add    $0x10,%esp

	MSort(A, q + 1, r);
  8004dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004df:	40                   	inc    %eax
  8004e0:	83 ec 04             	sub    $0x4,%esp
  8004e3:	ff 75 10             	pushl  0x10(%ebp)
  8004e6:	50                   	push   %eax
  8004e7:	ff 75 08             	pushl  0x8(%ebp)
  8004ea:	e8 b7 ff ff ff       	call   8004a6 <MSort>
  8004ef:	83 c4 10             	add    $0x10,%esp

	Merge(A, p, q, r);
  8004f2:	ff 75 10             	pushl  0x10(%ebp)
  8004f5:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f8:	ff 75 0c             	pushl  0xc(%ebp)
  8004fb:	ff 75 08             	pushl  0x8(%ebp)
  8004fe:	e8 08 00 00 00       	call   80050b <Merge>
  800503:	83 c4 10             	add    $0x10,%esp
  800506:	eb 01                	jmp    800509 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800508:	90                   	nop

	MSort(A, q + 1, r);

	Merge(A, p, q, r);

}
  800509:	c9                   	leave  
  80050a:	c3                   	ret    

0080050b <Merge>:

void Merge(int* A, int p, int q, int r)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  800511:	8b 45 10             	mov    0x10(%ebp),%eax
  800514:	2b 45 0c             	sub    0xc(%ebp),%eax
  800517:	40                   	inc    %eax
  800518:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	2b 45 10             	sub    0x10(%ebp),%eax
  800521:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800524:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  80052b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  800532:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800535:	c1 e0 02             	shl    $0x2,%eax
  800538:	83 ec 0c             	sub    $0xc,%esp
  80053b:	50                   	push   %eax
  80053c:	e8 ef 17 00 00       	call   801d30 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 da 17 00 00       	call   801d30 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  80055c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  800563:	eb 2f                	jmp    800594 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  800565:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800568:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800572:	01 c2                	add    %eax,%edx
  800574:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800577:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80057a:	01 c8                	add    %ecx,%eax
  80057c:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800581:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800588:	8b 45 08             	mov    0x8(%ebp),%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	89 02                	mov    %eax,(%edx)

	//	int Left[5000] ;
	//	int Right[5000] ;

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  800591:	ff 45 ec             	incl   -0x14(%ebp)
  800594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800597:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80059a:	7c c9                	jl     800565 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005a3:	eb 2a                	jmp    8005cf <Merge+0xc4>
	{
		Right[j] = A[q + j];
  8005a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005b2:	01 c2                	add    %eax,%edx
  8005b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8005b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005ba:	01 c8                	add    %ecx,%eax
  8005bc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	01 c8                	add    %ecx,%eax
  8005c8:	8b 00                	mov    (%eax),%eax
  8005ca:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8005cc:	ff 45 e8             	incl   -0x18(%ebp)
  8005cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005d2:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005d5:	7c ce                	jl     8005a5 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8005d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005dd:	e9 0a 01 00 00       	jmp    8006ec <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  8005e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005e5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005e8:	0f 8d 95 00 00 00    	jge    800683 <Merge+0x178>
  8005ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f1:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f4:	0f 8d 89 00 00 00    	jge    800683 <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	7d 33                	jge    800653 <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  800620:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800623:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800628:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80062f:	8b 45 08             	mov    0x8(%ebp),%eax
  800632:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800638:	8d 50 01             	lea    0x1(%eax),%edx
  80063b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80063e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800645:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	8b 00                	mov    (%eax),%eax
  80064c:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  80064e:	e9 96 00 00 00       	jmp    8006e9 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80065b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800662:	8b 45 08             	mov    0x8(%ebp),%eax
  800665:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8d 50 01             	lea    0x1(%eax),%edx
  80066e:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800671:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800678:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067b:	01 d0                	add    %edx,%eax
  80067d:	8b 00                	mov    (%eax),%eax
  80067f:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800681:	eb 66                	jmp    8006e9 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  800683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800686:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800689:	7d 30                	jge    8006bb <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  80068b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80068e:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800693:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80069a:	8b 45 08             	mov    0x8(%ebp),%eax
  80069d:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006a3:	8d 50 01             	lea    0x1(%eax),%edx
  8006a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8006a9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8006b3:	01 d0                	add    %edx,%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	89 01                	mov    %eax,(%ecx)
  8006b9:	eb 2e                	jmp    8006e9 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  8006bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006be:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8006c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d3:	8d 50 01             	lea    0x1(%eax),%edx
  8006d6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8006d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006e0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006e3:	01 d0                	add    %edx,%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  8006e9:	ff 45 e4             	incl   -0x1c(%ebp)
  8006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006ef:	3b 45 14             	cmp    0x14(%ebp),%eax
  8006f2:	0f 8e ea fe ff ff    	jle    8005e2 <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

}
  8006f8:	90                   	nop
  8006f9:	c9                   	leave  
  8006fa:	c3                   	ret    

008006fb <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006fb:	55                   	push   %ebp
  8006fc:	89 e5                	mov    %esp,%ebp
  8006fe:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800701:	8b 45 08             	mov    0x8(%ebp),%eax
  800704:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800707:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80070b:	83 ec 0c             	sub    $0xc,%esp
  80070e:	50                   	push   %eax
  80070f:	e8 db 1b 00 00       	call   8022ef <sys_cputc>
  800714:	83 c4 10             	add    $0x10,%esp
}
  800717:	90                   	nop
  800718:	c9                   	leave  
  800719:	c3                   	ret    

0080071a <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  80071a:	55                   	push   %ebp
  80071b:	89 e5                	mov    %esp,%ebp
  80071d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800720:	e8 96 1b 00 00       	call   8022bb <sys_disable_interrupt>
	char c = ch;
  800725:	8b 45 08             	mov    0x8(%ebp),%eax
  800728:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80072b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80072f:	83 ec 0c             	sub    $0xc,%esp
  800732:	50                   	push   %eax
  800733:	e8 b7 1b 00 00       	call   8022ef <sys_cputc>
  800738:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80073b:	e8 95 1b 00 00       	call   8022d5 <sys_enable_interrupt>
}
  800740:	90                   	nop
  800741:	c9                   	leave  
  800742:	c3                   	ret    

00800743 <getchar>:

int
getchar(void)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800749:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800750:	eb 08                	jmp    80075a <getchar+0x17>
	{
		c = sys_cgetc();
  800752:	e8 df 19 00 00       	call   802136 <sys_cgetc>
  800757:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  80075a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80075e:	74 f2                	je     800752 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800760:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <atomic_getchar>:

int
atomic_getchar(void)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80076b:	e8 4b 1b 00 00       	call   8022bb <sys_disable_interrupt>
	int c=0;
  800770:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800777:	eb 08                	jmp    800781 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800779:	e8 b8 19 00 00       	call   802136 <sys_cgetc>
  80077e:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800785:	74 f2                	je     800779 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800787:	e8 49 1b 00 00       	call   8022d5 <sys_enable_interrupt>
	return c;
  80078c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80078f:	c9                   	leave  
  800790:	c3                   	ret    

00800791 <iscons>:

int iscons(int fdnum)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800794:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800799:	5d                   	pop    %ebp
  80079a:	c3                   	ret    

0080079b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007a1:	e8 08 1d 00 00       	call   8024ae <sys_getenvindex>
  8007a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ac:	89 d0                	mov    %edx,%eax
  8007ae:	c1 e0 03             	shl    $0x3,%eax
  8007b1:	01 d0                	add    %edx,%eax
  8007b3:	01 c0                	add    %eax,%eax
  8007b5:	01 d0                	add    %edx,%eax
  8007b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	c1 e0 04             	shl    $0x4,%eax
  8007c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007c8:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007cd:	a1 24 50 80 00       	mov    0x805024,%eax
  8007d2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	74 0f                	je     8007eb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007dc:	a1 24 50 80 00       	mov    0x805024,%eax
  8007e1:	05 5c 05 00 00       	add    $0x55c,%eax
  8007e6:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007ef:	7e 0a                	jle    8007fb <libmain+0x60>
		binaryname = argv[0];
  8007f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f4:	8b 00                	mov    (%eax),%eax
  8007f6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 2f f8 ff ff       	call   800038 <_main>
  800809:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80080c:	e8 aa 1a 00 00       	call   8022bb <sys_disable_interrupt>
	cprintf("**************************************\n");
  800811:	83 ec 0c             	sub    $0xc,%esp
  800814:	68 f4 3c 80 00       	push   $0x803cf4
  800819:	e8 6d 03 00 00       	call   800b8b <cprintf>
  80081e:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80082c:	a1 24 50 80 00       	mov    0x805024,%eax
  800831:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800837:	83 ec 04             	sub    $0x4,%esp
  80083a:	52                   	push   %edx
  80083b:	50                   	push   %eax
  80083c:	68 1c 3d 80 00       	push   $0x803d1c
  800841:	e8 45 03 00 00       	call   800b8b <cprintf>
  800846:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800849:	a1 24 50 80 00       	mov    0x805024,%eax
  80084e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800854:	a1 24 50 80 00       	mov    0x805024,%eax
  800859:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80085f:	a1 24 50 80 00       	mov    0x805024,%eax
  800864:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80086a:	51                   	push   %ecx
  80086b:	52                   	push   %edx
  80086c:	50                   	push   %eax
  80086d:	68 44 3d 80 00       	push   $0x803d44
  800872:	e8 14 03 00 00       	call   800b8b <cprintf>
  800877:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80087a:	a1 24 50 80 00       	mov    0x805024,%eax
  80087f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	50                   	push   %eax
  800889:	68 9c 3d 80 00       	push   $0x803d9c
  80088e:	e8 f8 02 00 00       	call   800b8b <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800896:	83 ec 0c             	sub    $0xc,%esp
  800899:	68 f4 3c 80 00       	push   $0x803cf4
  80089e:	e8 e8 02 00 00       	call   800b8b <cprintf>
  8008a3:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008a6:	e8 2a 1a 00 00       	call   8022d5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008ab:	e8 19 00 00 00       	call   8008c9 <exit>
}
  8008b0:	90                   	nop
  8008b1:	c9                   	leave  
  8008b2:	c3                   	ret    

008008b3 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008b3:	55                   	push   %ebp
  8008b4:	89 e5                	mov    %esp,%ebp
  8008b6:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008b9:	83 ec 0c             	sub    $0xc,%esp
  8008bc:	6a 00                	push   $0x0
  8008be:	e8 b7 1b 00 00       	call   80247a <sys_destroy_env>
  8008c3:	83 c4 10             	add    $0x10,%esp
}
  8008c6:	90                   	nop
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <exit>:

void
exit(void)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008cf:	e8 0c 1c 00 00       	call   8024e0 <sys_exit_env>
}
  8008d4:	90                   	nop
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008dd:	8d 45 10             	lea    0x10(%ebp),%eax
  8008e0:	83 c0 04             	add    $0x4,%eax
  8008e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008e6:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008eb:	85 c0                	test   %eax,%eax
  8008ed:	74 16                	je     800905 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008ef:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	50                   	push   %eax
  8008f8:	68 b0 3d 80 00       	push   $0x803db0
  8008fd:	e8 89 02 00 00       	call   800b8b <cprintf>
  800902:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800905:	a1 00 50 80 00       	mov    0x805000,%eax
  80090a:	ff 75 0c             	pushl  0xc(%ebp)
  80090d:	ff 75 08             	pushl  0x8(%ebp)
  800910:	50                   	push   %eax
  800911:	68 b5 3d 80 00       	push   $0x803db5
  800916:	e8 70 02 00 00       	call   800b8b <cprintf>
  80091b:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 f4             	pushl  -0xc(%ebp)
  800927:	50                   	push   %eax
  800928:	e8 f3 01 00 00       	call   800b20 <vcprintf>
  80092d:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	6a 00                	push   $0x0
  800935:	68 d1 3d 80 00       	push   $0x803dd1
  80093a:	e8 e1 01 00 00       	call   800b20 <vcprintf>
  80093f:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800942:	e8 82 ff ff ff       	call   8008c9 <exit>

	// should not return here
	while (1) ;
  800947:	eb fe                	jmp    800947 <_panic+0x70>

00800949 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80094f:	a1 24 50 80 00       	mov    0x805024,%eax
  800954:	8b 50 74             	mov    0x74(%eax),%edx
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	39 c2                	cmp    %eax,%edx
  80095c:	74 14                	je     800972 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 d4 3d 80 00       	push   $0x803dd4
  800966:	6a 26                	push   $0x26
  800968:	68 20 3e 80 00       	push   $0x803e20
  80096d:	e8 65 ff ff ff       	call   8008d7 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800979:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800980:	e9 c2 00 00 00       	jmp    800a47 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800988:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	01 d0                	add    %edx,%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	85 c0                	test   %eax,%eax
  800998:	75 08                	jne    8009a2 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80099a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80099d:	e9 a2 00 00 00       	jmp    800a44 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009a2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009b0:	eb 69                	jmp    800a1b <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009c0:	89 d0                	mov    %edx,%eax
  8009c2:	01 c0                	add    %eax,%eax
  8009c4:	01 d0                	add    %edx,%eax
  8009c6:	c1 e0 03             	shl    $0x3,%eax
  8009c9:	01 c8                	add    %ecx,%eax
  8009cb:	8a 40 04             	mov    0x4(%eax),%al
  8009ce:	84 c0                	test   %al,%al
  8009d0:	75 46                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d2:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009dd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009e0:	89 d0                	mov    %edx,%eax
  8009e2:	01 c0                	add    %eax,%eax
  8009e4:	01 d0                	add    %edx,%eax
  8009e6:	c1 e0 03             	shl    $0x3,%eax
  8009e9:	01 c8                	add    %ecx,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009f0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009f8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009fd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a04:	8b 45 08             	mov    0x8(%ebp),%eax
  800a07:	01 c8                	add    %ecx,%eax
  800a09:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a0b:	39 c2                	cmp    %eax,%edx
  800a0d:	75 09                	jne    800a18 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a0f:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a16:	eb 12                	jmp    800a2a <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a18:	ff 45 e8             	incl   -0x18(%ebp)
  800a1b:	a1 24 50 80 00       	mov    0x805024,%eax
  800a20:	8b 50 74             	mov    0x74(%eax),%edx
  800a23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a26:	39 c2                	cmp    %eax,%edx
  800a28:	77 88                	ja     8009b2 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a2e:	75 14                	jne    800a44 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a30:	83 ec 04             	sub    $0x4,%esp
  800a33:	68 2c 3e 80 00       	push   $0x803e2c
  800a38:	6a 3a                	push   $0x3a
  800a3a:	68 20 3e 80 00       	push   $0x803e20
  800a3f:	e8 93 fe ff ff       	call   8008d7 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a44:	ff 45 f0             	incl   -0x10(%ebp)
  800a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a4d:	0f 8c 32 ff ff ff    	jl     800985 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a53:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a5a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a61:	eb 26                	jmp    800a89 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a63:	a1 24 50 80 00       	mov    0x805024,%eax
  800a68:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a6e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	01 c0                	add    %eax,%eax
  800a75:	01 d0                	add    %edx,%eax
  800a77:	c1 e0 03             	shl    $0x3,%eax
  800a7a:	01 c8                	add    %ecx,%eax
  800a7c:	8a 40 04             	mov    0x4(%eax),%al
  800a7f:	3c 01                	cmp    $0x1,%al
  800a81:	75 03                	jne    800a86 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a83:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a86:	ff 45 e0             	incl   -0x20(%ebp)
  800a89:	a1 24 50 80 00       	mov    0x805024,%eax
  800a8e:	8b 50 74             	mov    0x74(%eax),%edx
  800a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a94:	39 c2                	cmp    %eax,%edx
  800a96:	77 cb                	ja     800a63 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a9b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a9e:	74 14                	je     800ab4 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800aa0:	83 ec 04             	sub    $0x4,%esp
  800aa3:	68 80 3e 80 00       	push   $0x803e80
  800aa8:	6a 44                	push   $0x44
  800aaa:	68 20 3e 80 00       	push   $0x803e20
  800aaf:	e8 23 fe ff ff       	call   8008d7 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ab4:	90                   	nop
  800ab5:	c9                   	leave  
  800ab6:	c3                   	ret    

00800ab7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac0:	8b 00                	mov    (%eax),%eax
  800ac2:	8d 48 01             	lea    0x1(%eax),%ecx
  800ac5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac8:	89 0a                	mov    %ecx,(%edx)
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	88 d1                	mov    %dl,%cl
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ad2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ae0:	75 2c                	jne    800b0e <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ae2:	a0 28 50 80 00       	mov    0x805028,%al
  800ae7:	0f b6 c0             	movzbl %al,%eax
  800aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aed:	8b 12                	mov    (%edx),%edx
  800aef:	89 d1                	mov    %edx,%ecx
  800af1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af4:	83 c2 08             	add    $0x8,%edx
  800af7:	83 ec 04             	sub    $0x4,%esp
  800afa:	50                   	push   %eax
  800afb:	51                   	push   %ecx
  800afc:	52                   	push   %edx
  800afd:	e8 0b 16 00 00       	call   80210d <sys_cputs>
  800b02:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b11:	8b 40 04             	mov    0x4(%eax),%eax
  800b14:	8d 50 01             	lea    0x1(%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b1d:	90                   	nop
  800b1e:	c9                   	leave  
  800b1f:	c3                   	ret    

00800b20 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b20:	55                   	push   %ebp
  800b21:	89 e5                	mov    %esp,%ebp
  800b23:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b29:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b30:	00 00 00 
	b.cnt = 0;
  800b33:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b3a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b3d:	ff 75 0c             	pushl  0xc(%ebp)
  800b40:	ff 75 08             	pushl  0x8(%ebp)
  800b43:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	68 b7 0a 80 00       	push   $0x800ab7
  800b4f:	e8 11 02 00 00       	call   800d65 <vprintfmt>
  800b54:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b57:	a0 28 50 80 00       	mov    0x805028,%al
  800b5c:	0f b6 c0             	movzbl %al,%eax
  800b5f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b65:	83 ec 04             	sub    $0x4,%esp
  800b68:	50                   	push   %eax
  800b69:	52                   	push   %edx
  800b6a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b70:	83 c0 08             	add    $0x8,%eax
  800b73:	50                   	push   %eax
  800b74:	e8 94 15 00 00       	call   80210d <sys_cputs>
  800b79:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b7c:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b83:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b89:	c9                   	leave  
  800b8a:	c3                   	ret    

00800b8b <cprintf>:

int cprintf(const char *fmt, ...) {
  800b8b:	55                   	push   %ebp
  800b8c:	89 e5                	mov    %esp,%ebp
  800b8e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b91:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800b98:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba7:	50                   	push   %eax
  800ba8:	e8 73 ff ff ff       	call   800b20 <vcprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bbe:	e8 f8 16 00 00       	call   8022bb <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bc3:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	50                   	push   %eax
  800bd3:	e8 48 ff ff ff       	call   800b20 <vcprintf>
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bde:	e8 f2 16 00 00       	call   8022d5 <sys_enable_interrupt>
	return cnt;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	83 ec 14             	sub    $0x14,%esp
  800bef:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bfb:	8b 45 18             	mov    0x18(%ebp),%eax
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c06:	77 55                	ja     800c5d <printnum+0x75>
  800c08:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c0b:	72 05                	jb     800c12 <printnum+0x2a>
  800c0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c10:	77 4b                	ja     800c5d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c12:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c15:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c18:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c20:	52                   	push   %edx
  800c21:	50                   	push   %eax
  800c22:	ff 75 f4             	pushl  -0xc(%ebp)
  800c25:	ff 75 f0             	pushl  -0x10(%ebp)
  800c28:	e8 6b 2c 00 00       	call   803898 <__udivdi3>
  800c2d:	83 c4 10             	add    $0x10,%esp
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	ff 75 20             	pushl  0x20(%ebp)
  800c36:	53                   	push   %ebx
  800c37:	ff 75 18             	pushl  0x18(%ebp)
  800c3a:	52                   	push   %edx
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 a1 ff ff ff       	call   800be8 <printnum>
  800c47:	83 c4 20             	add    $0x20,%esp
  800c4a:	eb 1a                	jmp    800c66 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c4c:	83 ec 08             	sub    $0x8,%esp
  800c4f:	ff 75 0c             	pushl  0xc(%ebp)
  800c52:	ff 75 20             	pushl  0x20(%ebp)
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	ff d0                	call   *%eax
  800c5a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c5d:	ff 4d 1c             	decl   0x1c(%ebp)
  800c60:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c64:	7f e6                	jg     800c4c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c66:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c69:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c74:	53                   	push   %ebx
  800c75:	51                   	push   %ecx
  800c76:	52                   	push   %edx
  800c77:	50                   	push   %eax
  800c78:	e8 2b 2d 00 00       	call   8039a8 <__umoddi3>
  800c7d:	83 c4 10             	add    $0x10,%esp
  800c80:	05 f4 40 80 00       	add    $0x8040f4,%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	0f be c0             	movsbl %al,%eax
  800c8a:	83 ec 08             	sub    $0x8,%esp
  800c8d:	ff 75 0c             	pushl  0xc(%ebp)
  800c90:	50                   	push   %eax
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	ff d0                	call   *%eax
  800c96:	83 c4 10             	add    $0x10,%esp
}
  800c99:	90                   	nop
  800c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ca2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ca6:	7e 1c                	jle    800cc4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	8d 50 08             	lea    0x8(%eax),%edx
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 10                	mov    %edx,(%eax)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8b 00                	mov    (%eax),%eax
  800cba:	83 e8 08             	sub    $0x8,%eax
  800cbd:	8b 50 04             	mov    0x4(%eax),%edx
  800cc0:	8b 00                	mov    (%eax),%eax
  800cc2:	eb 40                	jmp    800d04 <getuint+0x65>
	else if (lflag)
  800cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc8:	74 1e                	je     800ce8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800cca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccd:	8b 00                	mov    (%eax),%eax
  800ccf:	8d 50 04             	lea    0x4(%eax),%edx
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	89 10                	mov    %edx,(%eax)
  800cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cda:	8b 00                	mov    (%eax),%eax
  800cdc:	83 e8 04             	sub    $0x4,%eax
  800cdf:	8b 00                	mov    (%eax),%eax
  800ce1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce6:	eb 1c                	jmp    800d04 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8b 00                	mov    (%eax),%eax
  800ced:	8d 50 04             	lea    0x4(%eax),%edx
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	89 10                	mov    %edx,(%eax)
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8b 00                	mov    (%eax),%eax
  800cfa:	83 e8 04             	sub    $0x4,%eax
  800cfd:	8b 00                	mov    (%eax),%eax
  800cff:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d09:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d0d:	7e 1c                	jle    800d2b <getint+0x25>
		return va_arg(*ap, long long);
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	8b 00                	mov    (%eax),%eax
  800d14:	8d 50 08             	lea    0x8(%eax),%edx
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	89 10                	mov    %edx,(%eax)
  800d1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1f:	8b 00                	mov    (%eax),%eax
  800d21:	83 e8 08             	sub    $0x8,%eax
  800d24:	8b 50 04             	mov    0x4(%eax),%edx
  800d27:	8b 00                	mov    (%eax),%eax
  800d29:	eb 38                	jmp    800d63 <getint+0x5d>
	else if (lflag)
  800d2b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d2f:	74 1a                	je     800d4b <getint+0x45>
		return va_arg(*ap, long);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8b 00                	mov    (%eax),%eax
  800d36:	8d 50 04             	lea    0x4(%eax),%edx
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	89 10                	mov    %edx,(%eax)
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	8b 00                	mov    (%eax),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	99                   	cltd   
  800d49:	eb 18                	jmp    800d63 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8b 00                	mov    (%eax),%eax
  800d50:	8d 50 04             	lea    0x4(%eax),%edx
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 10                	mov    %edx,(%eax)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8b 00                	mov    (%eax),%eax
  800d5d:	83 e8 04             	sub    $0x4,%eax
  800d60:	8b 00                	mov    (%eax),%eax
  800d62:	99                   	cltd   
}
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	56                   	push   %esi
  800d69:	53                   	push   %ebx
  800d6a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d6d:	eb 17                	jmp    800d86 <vprintfmt+0x21>
			if (ch == '\0')
  800d6f:	85 db                	test   %ebx,%ebx
  800d71:	0f 84 af 03 00 00    	je     801126 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	53                   	push   %ebx
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d86:	8b 45 10             	mov    0x10(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 10             	mov    %edx,0x10(%ebp)
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	0f b6 d8             	movzbl %al,%ebx
  800d94:	83 fb 25             	cmp    $0x25,%ebx
  800d97:	75 d6                	jne    800d6f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d99:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d9d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800da4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800db2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800db9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dbc:	8d 50 01             	lea    0x1(%eax),%edx
  800dbf:	89 55 10             	mov    %edx,0x10(%ebp)
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	0f b6 d8             	movzbl %al,%ebx
  800dc7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800dca:	83 f8 55             	cmp    $0x55,%eax
  800dcd:	0f 87 2b 03 00 00    	ja     8010fe <vprintfmt+0x399>
  800dd3:	8b 04 85 18 41 80 00 	mov    0x804118(,%eax,4),%eax
  800dda:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ddc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800de0:	eb d7                	jmp    800db9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800de2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800de6:	eb d1                	jmp    800db9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800de8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800def:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df2:	89 d0                	mov    %edx,%eax
  800df4:	c1 e0 02             	shl    $0x2,%eax
  800df7:	01 d0                	add    %edx,%eax
  800df9:	01 c0                	add    %eax,%eax
  800dfb:	01 d8                	add    %ebx,%eax
  800dfd:	83 e8 30             	sub    $0x30,%eax
  800e00:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e03:	8b 45 10             	mov    0x10(%ebp),%eax
  800e06:	8a 00                	mov    (%eax),%al
  800e08:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e0b:	83 fb 2f             	cmp    $0x2f,%ebx
  800e0e:	7e 3e                	jle    800e4e <vprintfmt+0xe9>
  800e10:	83 fb 39             	cmp    $0x39,%ebx
  800e13:	7f 39                	jg     800e4e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e15:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e18:	eb d5                	jmp    800def <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e1d:	83 c0 04             	add    $0x4,%eax
  800e20:	89 45 14             	mov    %eax,0x14(%ebp)
  800e23:	8b 45 14             	mov    0x14(%ebp),%eax
  800e26:	83 e8 04             	sub    $0x4,%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e2e:	eb 1f                	jmp    800e4f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e34:	79 83                	jns    800db9 <vprintfmt+0x54>
				width = 0;
  800e36:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e3d:	e9 77 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e42:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e49:	e9 6b ff ff ff       	jmp    800db9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e4e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e4f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e53:	0f 89 60 ff ff ff    	jns    800db9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e59:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e5f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e66:	e9 4e ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e6e:	e9 46 ff ff ff       	jmp    800db9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e73:	8b 45 14             	mov    0x14(%ebp),%eax
  800e76:	83 c0 04             	add    $0x4,%eax
  800e79:	89 45 14             	mov    %eax,0x14(%ebp)
  800e7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7f:	83 e8 04             	sub    $0x4,%eax
  800e82:	8b 00                	mov    (%eax),%eax
  800e84:	83 ec 08             	sub    $0x8,%esp
  800e87:	ff 75 0c             	pushl  0xc(%ebp)
  800e8a:	50                   	push   %eax
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	ff d0                	call   *%eax
  800e90:	83 c4 10             	add    $0x10,%esp
			break;
  800e93:	e9 89 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 c0 04             	add    $0x4,%eax
  800e9e:	89 45 14             	mov    %eax,0x14(%ebp)
  800ea1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ea4:	83 e8 04             	sub    $0x4,%eax
  800ea7:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ea9:	85 db                	test   %ebx,%ebx
  800eab:	79 02                	jns    800eaf <vprintfmt+0x14a>
				err = -err;
  800ead:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eaf:	83 fb 64             	cmp    $0x64,%ebx
  800eb2:	7f 0b                	jg     800ebf <vprintfmt+0x15a>
  800eb4:	8b 34 9d 60 3f 80 00 	mov    0x803f60(,%ebx,4),%esi
  800ebb:	85 f6                	test   %esi,%esi
  800ebd:	75 19                	jne    800ed8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ebf:	53                   	push   %ebx
  800ec0:	68 05 41 80 00       	push   $0x804105
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	ff 75 08             	pushl  0x8(%ebp)
  800ecb:	e8 5e 02 00 00       	call   80112e <printfmt>
  800ed0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ed3:	e9 49 02 00 00       	jmp    801121 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ed8:	56                   	push   %esi
  800ed9:	68 0e 41 80 00       	push   $0x80410e
  800ede:	ff 75 0c             	pushl  0xc(%ebp)
  800ee1:	ff 75 08             	pushl  0x8(%ebp)
  800ee4:	e8 45 02 00 00       	call   80112e <printfmt>
  800ee9:	83 c4 10             	add    $0x10,%esp
			break;
  800eec:	e9 30 02 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ef1:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef4:	83 c0 04             	add    $0x4,%eax
  800ef7:	89 45 14             	mov    %eax,0x14(%ebp)
  800efa:	8b 45 14             	mov    0x14(%ebp),%eax
  800efd:	83 e8 04             	sub    $0x4,%eax
  800f00:	8b 30                	mov    (%eax),%esi
  800f02:	85 f6                	test   %esi,%esi
  800f04:	75 05                	jne    800f0b <vprintfmt+0x1a6>
				p = "(null)";
  800f06:	be 11 41 80 00       	mov    $0x804111,%esi
			if (width > 0 && padc != '-')
  800f0b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0f:	7e 6d                	jle    800f7e <vprintfmt+0x219>
  800f11:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f15:	74 67                	je     800f7e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f1a:	83 ec 08             	sub    $0x8,%esp
  800f1d:	50                   	push   %eax
  800f1e:	56                   	push   %esi
  800f1f:	e8 12 05 00 00       	call   801436 <strnlen>
  800f24:	83 c4 10             	add    $0x10,%esp
  800f27:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f2a:	eb 16                	jmp    800f42 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f2c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	ff 75 0c             	pushl  0xc(%ebp)
  800f36:	50                   	push   %eax
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	ff d0                	call   *%eax
  800f3c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800f42:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f46:	7f e4                	jg     800f2c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f48:	eb 34                	jmp    800f7e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f4a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f4e:	74 1c                	je     800f6c <vprintfmt+0x207>
  800f50:	83 fb 1f             	cmp    $0x1f,%ebx
  800f53:	7e 05                	jle    800f5a <vprintfmt+0x1f5>
  800f55:	83 fb 7e             	cmp    $0x7e,%ebx
  800f58:	7e 12                	jle    800f6c <vprintfmt+0x207>
					putch('?', putdat);
  800f5a:	83 ec 08             	sub    $0x8,%esp
  800f5d:	ff 75 0c             	pushl  0xc(%ebp)
  800f60:	6a 3f                	push   $0x3f
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
  800f65:	ff d0                	call   *%eax
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	eb 0f                	jmp    800f7b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f6c:	83 ec 08             	sub    $0x8,%esp
  800f6f:	ff 75 0c             	pushl  0xc(%ebp)
  800f72:	53                   	push   %ebx
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	ff d0                	call   *%eax
  800f78:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f7b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f7e:	89 f0                	mov    %esi,%eax
  800f80:	8d 70 01             	lea    0x1(%eax),%esi
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f be d8             	movsbl %al,%ebx
  800f88:	85 db                	test   %ebx,%ebx
  800f8a:	74 24                	je     800fb0 <vprintfmt+0x24b>
  800f8c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f90:	78 b8                	js     800f4a <vprintfmt+0x1e5>
  800f92:	ff 4d e0             	decl   -0x20(%ebp)
  800f95:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f99:	79 af                	jns    800f4a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f9b:	eb 13                	jmp    800fb0 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f9d:	83 ec 08             	sub    $0x8,%esp
  800fa0:	ff 75 0c             	pushl  0xc(%ebp)
  800fa3:	6a 20                	push   $0x20
  800fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa8:	ff d0                	call   *%eax
  800faa:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fad:	ff 4d e4             	decl   -0x1c(%ebp)
  800fb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fb4:	7f e7                	jg     800f9d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fb6:	e9 66 01 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fbb:	83 ec 08             	sub    $0x8,%esp
  800fbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800fc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	e8 3c fd ff ff       	call   800d06 <getint>
  800fca:	83 c4 10             	add    $0x10,%esp
  800fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fd9:	85 d2                	test   %edx,%edx
  800fdb:	79 23                	jns    801000 <vprintfmt+0x29b>
				putch('-', putdat);
  800fdd:	83 ec 08             	sub    $0x8,%esp
  800fe0:	ff 75 0c             	pushl  0xc(%ebp)
  800fe3:	6a 2d                	push   $0x2d
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	ff d0                	call   *%eax
  800fea:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff3:	f7 d8                	neg    %eax
  800ff5:	83 d2 00             	adc    $0x0,%edx
  800ff8:	f7 da                	neg    %edx
  800ffa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ffd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801000:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801007:	e9 bc 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80100c:	83 ec 08             	sub    $0x8,%esp
  80100f:	ff 75 e8             	pushl  -0x18(%ebp)
  801012:	8d 45 14             	lea    0x14(%ebp),%eax
  801015:	50                   	push   %eax
  801016:	e8 84 fc ff ff       	call   800c9f <getuint>
  80101b:	83 c4 10             	add    $0x10,%esp
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801021:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801024:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80102b:	e9 98 00 00 00       	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801030:	83 ec 08             	sub    $0x8,%esp
  801033:	ff 75 0c             	pushl  0xc(%ebp)
  801036:	6a 58                	push   $0x58
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	ff d0                	call   *%eax
  80103d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801040:	83 ec 08             	sub    $0x8,%esp
  801043:	ff 75 0c             	pushl  0xc(%ebp)
  801046:	6a 58                	push   $0x58
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	ff d0                	call   *%eax
  80104d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801050:	83 ec 08             	sub    $0x8,%esp
  801053:	ff 75 0c             	pushl  0xc(%ebp)
  801056:	6a 58                	push   $0x58
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	ff d0                	call   *%eax
  80105d:	83 c4 10             	add    $0x10,%esp
			break;
  801060:	e9 bc 00 00 00       	jmp    801121 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801065:	83 ec 08             	sub    $0x8,%esp
  801068:	ff 75 0c             	pushl  0xc(%ebp)
  80106b:	6a 30                	push   $0x30
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	ff d0                	call   *%eax
  801072:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801075:	83 ec 08             	sub    $0x8,%esp
  801078:	ff 75 0c             	pushl  0xc(%ebp)
  80107b:	6a 78                	push   $0x78
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	ff d0                	call   *%eax
  801082:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801085:	8b 45 14             	mov    0x14(%ebp),%eax
  801088:	83 c0 04             	add    $0x4,%eax
  80108b:	89 45 14             	mov    %eax,0x14(%ebp)
  80108e:	8b 45 14             	mov    0x14(%ebp),%eax
  801091:	83 e8 04             	sub    $0x4,%eax
  801094:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801096:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801099:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010a0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010a7:	eb 1f                	jmp    8010c8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010a9:	83 ec 08             	sub    $0x8,%esp
  8010ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8010af:	8d 45 14             	lea    0x14(%ebp),%eax
  8010b2:	50                   	push   %eax
  8010b3:	e8 e7 fb ff ff       	call   800c9f <getuint>
  8010b8:	83 c4 10             	add    $0x10,%esp
  8010bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010c1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010c8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010cf:	83 ec 04             	sub    $0x4,%esp
  8010d2:	52                   	push   %edx
  8010d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010d6:	50                   	push   %eax
  8010d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010da:	ff 75 f0             	pushl  -0x10(%ebp)
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	ff 75 08             	pushl  0x8(%ebp)
  8010e3:	e8 00 fb ff ff       	call   800be8 <printnum>
  8010e8:	83 c4 20             	add    $0x20,%esp
			break;
  8010eb:	eb 34                	jmp    801121 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010ed:	83 ec 08             	sub    $0x8,%esp
  8010f0:	ff 75 0c             	pushl  0xc(%ebp)
  8010f3:	53                   	push   %ebx
  8010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f7:	ff d0                	call   *%eax
  8010f9:	83 c4 10             	add    $0x10,%esp
			break;
  8010fc:	eb 23                	jmp    801121 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010fe:	83 ec 08             	sub    $0x8,%esp
  801101:	ff 75 0c             	pushl  0xc(%ebp)
  801104:	6a 25                	push   $0x25
  801106:	8b 45 08             	mov    0x8(%ebp),%eax
  801109:	ff d0                	call   *%eax
  80110b:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80110e:	ff 4d 10             	decl   0x10(%ebp)
  801111:	eb 03                	jmp    801116 <vprintfmt+0x3b1>
  801113:	ff 4d 10             	decl   0x10(%ebp)
  801116:	8b 45 10             	mov    0x10(%ebp),%eax
  801119:	48                   	dec    %eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 25                	cmp    $0x25,%al
  80111e:	75 f3                	jne    801113 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801120:	90                   	nop
		}
	}
  801121:	e9 47 fc ff ff       	jmp    800d6d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801126:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80112a:	5b                   	pop    %ebx
  80112b:	5e                   	pop    %esi
  80112c:	5d                   	pop    %ebp
  80112d:	c3                   	ret    

0080112e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80112e:	55                   	push   %ebp
  80112f:	89 e5                	mov    %esp,%ebp
  801131:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801134:	8d 45 10             	lea    0x10(%ebp),%eax
  801137:	83 c0 04             	add    $0x4,%eax
  80113a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	ff 75 f4             	pushl  -0xc(%ebp)
  801143:	50                   	push   %eax
  801144:	ff 75 0c             	pushl  0xc(%ebp)
  801147:	ff 75 08             	pushl  0x8(%ebp)
  80114a:	e8 16 fc ff ff       	call   800d65 <vprintfmt>
  80114f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801152:	90                   	nop
  801153:	c9                   	leave  
  801154:	c3                   	ret    

00801155 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801155:	55                   	push   %ebp
  801156:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	8b 40 08             	mov    0x8(%eax),%eax
  80115e:	8d 50 01             	lea    0x1(%eax),%edx
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	8b 10                	mov    (%eax),%edx
  80116c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116f:	8b 40 04             	mov    0x4(%eax),%eax
  801172:	39 c2                	cmp    %eax,%edx
  801174:	73 12                	jae    801188 <sprintputch+0x33>
		*b->buf++ = ch;
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	8b 00                	mov    (%eax),%eax
  80117b:	8d 48 01             	lea    0x1(%eax),%ecx
  80117e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801181:	89 0a                	mov    %ecx,(%edx)
  801183:	8b 55 08             	mov    0x8(%ebp),%edx
  801186:	88 10                	mov    %dl,(%eax)
}
  801188:	90                   	nop
  801189:	5d                   	pop    %ebp
  80118a:	c3                   	ret    

0080118b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80118b:	55                   	push   %ebp
  80118c:	89 e5                	mov    %esp,%ebp
  80118e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	01 d0                	add    %edx,%eax
  8011a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011b0:	74 06                	je     8011b8 <vsnprintf+0x2d>
  8011b2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b6:	7f 07                	jg     8011bf <vsnprintf+0x34>
		return -E_INVAL;
  8011b8:	b8 03 00 00 00       	mov    $0x3,%eax
  8011bd:	eb 20                	jmp    8011df <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011bf:	ff 75 14             	pushl  0x14(%ebp)
  8011c2:	ff 75 10             	pushl  0x10(%ebp)
  8011c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011c8:	50                   	push   %eax
  8011c9:	68 55 11 80 00       	push   $0x801155
  8011ce:	e8 92 fb ff ff       	call   800d65 <vprintfmt>
  8011d3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8011ea:	83 c0 04             	add    $0x4,%eax
  8011ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f6:	50                   	push   %eax
  8011f7:	ff 75 0c             	pushl  0xc(%ebp)
  8011fa:	ff 75 08             	pushl  0x8(%ebp)
  8011fd:	e8 89 ff ff ff       	call   80118b <vsnprintf>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801208:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801213:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801217:	74 13                	je     80122c <readline+0x1f>
		cprintf("%s", prompt);
  801219:	83 ec 08             	sub    $0x8,%esp
  80121c:	ff 75 08             	pushl  0x8(%ebp)
  80121f:	68 70 42 80 00       	push   $0x804270
  801224:	e8 62 f9 ff ff       	call   800b8b <cprintf>
  801229:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80122c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801233:	83 ec 0c             	sub    $0xc,%esp
  801236:	6a 00                	push   $0x0
  801238:	e8 54 f5 ff ff       	call   800791 <iscons>
  80123d:	83 c4 10             	add    $0x10,%esp
  801240:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801243:	e8 fb f4 ff ff       	call   800743 <getchar>
  801248:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80124b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80124f:	79 22                	jns    801273 <readline+0x66>
			if (c != -E_EOF)
  801251:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801255:	0f 84 ad 00 00 00    	je     801308 <readline+0xfb>
				cprintf("read error: %e\n", c);
  80125b:	83 ec 08             	sub    $0x8,%esp
  80125e:	ff 75 ec             	pushl  -0x14(%ebp)
  801261:	68 73 42 80 00       	push   $0x804273
  801266:	e8 20 f9 ff ff       	call   800b8b <cprintf>
  80126b:	83 c4 10             	add    $0x10,%esp
			return;
  80126e:	e9 95 00 00 00       	jmp    801308 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801273:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801277:	7e 34                	jle    8012ad <readline+0xa0>
  801279:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801280:	7f 2b                	jg     8012ad <readline+0xa0>
			if (echoing)
  801282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801286:	74 0e                	je     801296 <readline+0x89>
				cputchar(c);
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	ff 75 ec             	pushl  -0x14(%ebp)
  80128e:	e8 68 f4 ff ff       	call   8006fb <cputchar>
  801293:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	8d 50 01             	lea    0x1(%eax),%edx
  80129c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80129f:	89 c2                	mov    %eax,%edx
  8012a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a4:	01 d0                	add    %edx,%eax
  8012a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012a9:	88 10                	mov    %dl,(%eax)
  8012ab:	eb 56                	jmp    801303 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8012ad:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8012b1:	75 1f                	jne    8012d2 <readline+0xc5>
  8012b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8012b7:	7e 19                	jle    8012d2 <readline+0xc5>
			if (echoing)
  8012b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012bd:	74 0e                	je     8012cd <readline+0xc0>
				cputchar(c);
  8012bf:	83 ec 0c             	sub    $0xc,%esp
  8012c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012c5:	e8 31 f4 ff ff       	call   8006fb <cputchar>
  8012ca:	83 c4 10             	add    $0x10,%esp

			i--;
  8012cd:	ff 4d f4             	decl   -0xc(%ebp)
  8012d0:	eb 31                	jmp    801303 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  8012d2:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8012d6:	74 0a                	je     8012e2 <readline+0xd5>
  8012d8:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012dc:	0f 85 61 ff ff ff    	jne    801243 <readline+0x36>
			if (echoing)
  8012e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012e6:	74 0e                	je     8012f6 <readline+0xe9>
				cputchar(c);
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	ff 75 ec             	pushl  -0x14(%ebp)
  8012ee:	e8 08 f4 ff ff       	call   8006fb <cputchar>
  8012f3:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	01 d0                	add    %edx,%eax
  8012fe:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801301:	eb 06                	jmp    801309 <readline+0xfc>
		}
	}
  801303:	e9 3b ff ff ff       	jmp    801243 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801308:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801309:	c9                   	leave  
  80130a:	c3                   	ret    

0080130b <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801311:	e8 a5 0f 00 00       	call   8022bb <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801316:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80131a:	74 13                	je     80132f <atomic_readline+0x24>
		cprintf("%s", prompt);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 08             	pushl  0x8(%ebp)
  801322:	68 70 42 80 00       	push   $0x804270
  801327:	e8 5f f8 ff ff       	call   800b8b <cprintf>
  80132c:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80132f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801336:	83 ec 0c             	sub    $0xc,%esp
  801339:	6a 00                	push   $0x0
  80133b:	e8 51 f4 ff ff       	call   800791 <iscons>
  801340:	83 c4 10             	add    $0x10,%esp
  801343:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801346:	e8 f8 f3 ff ff       	call   800743 <getchar>
  80134b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80134e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801352:	79 23                	jns    801377 <atomic_readline+0x6c>
			if (c != -E_EOF)
  801354:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801358:	74 13                	je     80136d <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  80135a:	83 ec 08             	sub    $0x8,%esp
  80135d:	ff 75 ec             	pushl  -0x14(%ebp)
  801360:	68 73 42 80 00       	push   $0x804273
  801365:	e8 21 f8 ff ff       	call   800b8b <cprintf>
  80136a:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80136d:	e8 63 0f 00 00       	call   8022d5 <sys_enable_interrupt>
			return;
  801372:	e9 9a 00 00 00       	jmp    801411 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801377:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80137b:	7e 34                	jle    8013b1 <atomic_readline+0xa6>
  80137d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801384:	7f 2b                	jg     8013b1 <atomic_readline+0xa6>
			if (echoing)
  801386:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80138a:	74 0e                	je     80139a <atomic_readline+0x8f>
				cputchar(c);
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	ff 75 ec             	pushl  -0x14(%ebp)
  801392:	e8 64 f3 ff ff       	call   8006fb <cputchar>
  801397:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80139a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8013a3:	89 c2                	mov    %eax,%edx
  8013a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a8:	01 d0                	add    %edx,%eax
  8013aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013ad:	88 10                	mov    %dl,(%eax)
  8013af:	eb 5b                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  8013b1:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  8013b5:	75 1f                	jne    8013d6 <atomic_readline+0xcb>
  8013b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8013bb:	7e 19                	jle    8013d6 <atomic_readline+0xcb>
			if (echoing)
  8013bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013c1:	74 0e                	je     8013d1 <atomic_readline+0xc6>
				cputchar(c);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013c9:	e8 2d f3 ff ff       	call   8006fb <cputchar>
  8013ce:	83 c4 10             	add    $0x10,%esp
			i--;
  8013d1:	ff 4d f4             	decl   -0xc(%ebp)
  8013d4:	eb 36                	jmp    80140c <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8013d6:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013da:	74 0a                	je     8013e6 <atomic_readline+0xdb>
  8013dc:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013e0:	0f 85 60 ff ff ff    	jne    801346 <atomic_readline+0x3b>
			if (echoing)
  8013e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ea:	74 0e                	je     8013fa <atomic_readline+0xef>
				cputchar(c);
  8013ec:	83 ec 0c             	sub    $0xc,%esp
  8013ef:	ff 75 ec             	pushl  -0x14(%ebp)
  8013f2:	e8 04 f3 ff ff       	call   8006fb <cputchar>
  8013f7:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801400:	01 d0                	add    %edx,%eax
  801402:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801405:	e8 cb 0e 00 00       	call   8022d5 <sys_enable_interrupt>
			return;
  80140a:	eb 05                	jmp    801411 <atomic_readline+0x106>
		}
	}
  80140c:	e9 35 ff ff ff       	jmp    801346 <atomic_readline+0x3b>
}
  801411:	c9                   	leave  
  801412:	c3                   	ret    

00801413 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801413:	55                   	push   %ebp
  801414:	89 e5                	mov    %esp,%ebp
  801416:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801419:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801420:	eb 06                	jmp    801428 <strlen+0x15>
		n++;
  801422:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801425:	ff 45 08             	incl   0x8(%ebp)
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	84 c0                	test   %al,%al
  80142f:	75 f1                	jne    801422 <strlen+0xf>
		n++;
	return n;
  801431:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801434:	c9                   	leave  
  801435:	c3                   	ret    

00801436 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801436:	55                   	push   %ebp
  801437:	89 e5                	mov    %esp,%ebp
  801439:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80143c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801443:	eb 09                	jmp    80144e <strnlen+0x18>
		n++;
  801445:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801448:	ff 45 08             	incl   0x8(%ebp)
  80144b:	ff 4d 0c             	decl   0xc(%ebp)
  80144e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801452:	74 09                	je     80145d <strnlen+0x27>
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	84 c0                	test   %al,%al
  80145b:	75 e8                	jne    801445 <strnlen+0xf>
		n++;
	return n;
  80145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801468:	8b 45 08             	mov    0x8(%ebp),%eax
  80146b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80146e:	90                   	nop
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8d 50 01             	lea    0x1(%eax),%edx
  801475:	89 55 08             	mov    %edx,0x8(%ebp)
  801478:	8b 55 0c             	mov    0xc(%ebp),%edx
  80147b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80147e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801481:	8a 12                	mov    (%edx),%dl
  801483:	88 10                	mov    %dl,(%eax)
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	75 e4                	jne    80146f <strcpy+0xd>
		/* do nothing */;
	return ret;
  80148b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80149c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014a3:	eb 1f                	jmp    8014c4 <strncpy+0x34>
		*dst++ = *src;
  8014a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a8:	8d 50 01             	lea    0x1(%eax),%edx
  8014ab:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b1:	8a 12                	mov    (%edx),%dl
  8014b3:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8014b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	84 c0                	test   %al,%al
  8014bc:	74 03                	je     8014c1 <strncpy+0x31>
			src++;
  8014be:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8014c1:	ff 45 fc             	incl   -0x4(%ebp)
  8014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014ca:	72 d9                	jb     8014a5 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8014cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014e1:	74 30                	je     801513 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014e3:	eb 16                	jmp    8014fb <strlcpy+0x2a>
			*dst++ = *src++;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8d 50 01             	lea    0x1(%eax),%edx
  8014eb:	89 55 08             	mov    %edx,0x8(%ebp)
  8014ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014f7:	8a 12                	mov    (%edx),%dl
  8014f9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014fb:	ff 4d 10             	decl   0x10(%ebp)
  8014fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801502:	74 09                	je     80150d <strlcpy+0x3c>
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	84 c0                	test   %al,%al
  80150b:	75 d8                	jne    8014e5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801513:	8b 55 08             	mov    0x8(%ebp),%edx
  801516:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801519:	29 c2                	sub    %eax,%edx
  80151b:	89 d0                	mov    %edx,%eax
}
  80151d:	c9                   	leave  
  80151e:	c3                   	ret    

0080151f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801522:	eb 06                	jmp    80152a <strcmp+0xb>
		p++, q++;
  801524:	ff 45 08             	incl   0x8(%ebp)
  801527:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80152a:	8b 45 08             	mov    0x8(%ebp),%eax
  80152d:	8a 00                	mov    (%eax),%al
  80152f:	84 c0                	test   %al,%al
  801531:	74 0e                	je     801541 <strcmp+0x22>
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	8a 10                	mov    (%eax),%dl
  801538:	8b 45 0c             	mov    0xc(%ebp),%eax
  80153b:	8a 00                	mov    (%eax),%al
  80153d:	38 c2                	cmp    %al,%dl
  80153f:	74 e3                	je     801524 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	8a 00                	mov    (%eax),%al
  801546:	0f b6 d0             	movzbl %al,%edx
  801549:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154c:	8a 00                	mov    (%eax),%al
  80154e:	0f b6 c0             	movzbl %al,%eax
  801551:	29 c2                	sub    %eax,%edx
  801553:	89 d0                	mov    %edx,%eax
}
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    

00801557 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801557:	55                   	push   %ebp
  801558:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80155a:	eb 09                	jmp    801565 <strncmp+0xe>
		n--, p++, q++;
  80155c:	ff 4d 10             	decl   0x10(%ebp)
  80155f:	ff 45 08             	incl   0x8(%ebp)
  801562:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801565:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801569:	74 17                	je     801582 <strncmp+0x2b>
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 0e                	je     801582 <strncmp+0x2b>
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	8a 10                	mov    (%eax),%dl
  801579:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	38 c2                	cmp    %al,%dl
  801580:	74 da                	je     80155c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801582:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801586:	75 07                	jne    80158f <strncmp+0x38>
		return 0;
  801588:	b8 00 00 00 00       	mov    $0x0,%eax
  80158d:	eb 14                	jmp    8015a3 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	0f b6 d0             	movzbl %al,%edx
  801597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159a:	8a 00                	mov    (%eax),%al
  80159c:	0f b6 c0             	movzbl %al,%eax
  80159f:	29 c2                	sub    %eax,%edx
  8015a1:	89 d0                	mov    %edx,%eax
}
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 04             	sub    $0x4,%esp
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015b1:	eb 12                	jmp    8015c5 <strchr+0x20>
		if (*s == c)
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	8a 00                	mov    (%eax),%al
  8015b8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015bb:	75 05                	jne    8015c2 <strchr+0x1d>
			return (char *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c0:	eb 11                	jmp    8015d3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8015c2:	ff 45 08             	incl   0x8(%ebp)
  8015c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c8:	8a 00                	mov    (%eax),%al
  8015ca:	84 c0                	test   %al,%al
  8015cc:	75 e5                	jne    8015b3 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 04             	sub    $0x4,%esp
  8015db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015de:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015e1:	eb 0d                	jmp    8015f0 <strfind+0x1b>
		if (*s == c)
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	8a 00                	mov    (%eax),%al
  8015e8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015eb:	74 0e                	je     8015fb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015ed:	ff 45 08             	incl   0x8(%ebp)
  8015f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f3:	8a 00                	mov    (%eax),%al
  8015f5:	84 c0                	test   %al,%al
  8015f7:	75 ea                	jne    8015e3 <strfind+0xe>
  8015f9:	eb 01                	jmp    8015fc <strfind+0x27>
		if (*s == c)
			break;
  8015fb:	90                   	nop
	return (char *) s;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80160d:	8b 45 10             	mov    0x10(%ebp),%eax
  801610:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801613:	eb 0e                	jmp    801623 <memset+0x22>
		*p++ = c;
  801615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801618:	8d 50 01             	lea    0x1(%eax),%edx
  80161b:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801621:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801623:	ff 4d f8             	decl   -0x8(%ebp)
  801626:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80162a:	79 e9                	jns    801615 <memset+0x14>
		*p++ = c;

	return v;
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801637:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163d:	8b 45 08             	mov    0x8(%ebp),%eax
  801640:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801643:	eb 16                	jmp    80165b <memcpy+0x2a>
		*d++ = *s++;
  801645:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801648:	8d 50 01             	lea    0x1(%eax),%edx
  80164b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80164e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801651:	8d 4a 01             	lea    0x1(%edx),%ecx
  801654:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801657:	8a 12                	mov    (%edx),%dl
  801659:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80165b:	8b 45 10             	mov    0x10(%ebp),%eax
  80165e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801661:	89 55 10             	mov    %edx,0x10(%ebp)
  801664:	85 c0                	test   %eax,%eax
  801666:	75 dd                	jne    801645 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801673:	8b 45 0c             	mov    0xc(%ebp),%eax
  801676:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80167f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801682:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801685:	73 50                	jae    8016d7 <memmove+0x6a>
  801687:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	01 d0                	add    %edx,%eax
  80168f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801692:	76 43                	jbe    8016d7 <memmove+0x6a>
		s += n;
  801694:	8b 45 10             	mov    0x10(%ebp),%eax
  801697:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80169a:	8b 45 10             	mov    0x10(%ebp),%eax
  80169d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8016a0:	eb 10                	jmp    8016b2 <memmove+0x45>
			*--d = *--s;
  8016a2:	ff 4d f8             	decl   -0x8(%ebp)
  8016a5:	ff 4d fc             	decl   -0x4(%ebp)
  8016a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016ab:	8a 10                	mov    (%eax),%dl
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8016b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016b8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 e3                	jne    8016a2 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8016bf:	eb 23                	jmp    8016e4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8016c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c4:	8d 50 01             	lea    0x1(%eax),%edx
  8016c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8016ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8016d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8016d3:	8a 12                	mov    (%edx),%dl
  8016d5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8016d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8016da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	75 dd                	jne    8016c1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016fb:	eb 2a                	jmp    801727 <memcmp+0x3e>
		if (*s1 != *s2)
  8016fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801700:	8a 10                	mov    (%eax),%dl
  801702:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	38 c2                	cmp    %al,%dl
  801709:	74 16                	je     801721 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80170b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80170e:	8a 00                	mov    (%eax),%al
  801710:	0f b6 d0             	movzbl %al,%edx
  801713:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801716:	8a 00                	mov    (%eax),%al
  801718:	0f b6 c0             	movzbl %al,%eax
  80171b:	29 c2                	sub    %eax,%edx
  80171d:	89 d0                	mov    %edx,%eax
  80171f:	eb 18                	jmp    801739 <memcmp+0x50>
		s1++, s2++;
  801721:	ff 45 fc             	incl   -0x4(%ebp)
  801724:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801727:	8b 45 10             	mov    0x10(%ebp),%eax
  80172a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172d:	89 55 10             	mov    %edx,0x10(%ebp)
  801730:	85 c0                	test   %eax,%eax
  801732:	75 c9                	jne    8016fd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801734:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801741:	8b 55 08             	mov    0x8(%ebp),%edx
  801744:	8b 45 10             	mov    0x10(%ebp),%eax
  801747:	01 d0                	add    %edx,%eax
  801749:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80174c:	eb 15                	jmp    801763 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80174e:	8b 45 08             	mov    0x8(%ebp),%eax
  801751:	8a 00                	mov    (%eax),%al
  801753:	0f b6 d0             	movzbl %al,%edx
  801756:	8b 45 0c             	mov    0xc(%ebp),%eax
  801759:	0f b6 c0             	movzbl %al,%eax
  80175c:	39 c2                	cmp    %eax,%edx
  80175e:	74 0d                	je     80176d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801760:	ff 45 08             	incl   0x8(%ebp)
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801769:	72 e3                	jb     80174e <memfind+0x13>
  80176b:	eb 01                	jmp    80176e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80176d:	90                   	nop
	return (void *) s;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801779:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801780:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801787:	eb 03                	jmp    80178c <strtol+0x19>
		s++;
  801789:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8a 00                	mov    (%eax),%al
  801791:	3c 20                	cmp    $0x20,%al
  801793:	74 f4                	je     801789 <strtol+0x16>
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	8a 00                	mov    (%eax),%al
  80179a:	3c 09                	cmp    $0x9,%al
  80179c:	74 eb                	je     801789 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80179e:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a1:	8a 00                	mov    (%eax),%al
  8017a3:	3c 2b                	cmp    $0x2b,%al
  8017a5:	75 05                	jne    8017ac <strtol+0x39>
		s++;
  8017a7:	ff 45 08             	incl   0x8(%ebp)
  8017aa:	eb 13                	jmp    8017bf <strtol+0x4c>
	else if (*s == '-')
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 2d                	cmp    $0x2d,%al
  8017b3:	75 0a                	jne    8017bf <strtol+0x4c>
		s++, neg = 1;
  8017b5:	ff 45 08             	incl   0x8(%ebp)
  8017b8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8017bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c3:	74 06                	je     8017cb <strtol+0x58>
  8017c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8017c9:	75 20                	jne    8017eb <strtol+0x78>
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	8a 00                	mov    (%eax),%al
  8017d0:	3c 30                	cmp    $0x30,%al
  8017d2:	75 17                	jne    8017eb <strtol+0x78>
  8017d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d7:	40                   	inc    %eax
  8017d8:	8a 00                	mov    (%eax),%al
  8017da:	3c 78                	cmp    $0x78,%al
  8017dc:	75 0d                	jne    8017eb <strtol+0x78>
		s += 2, base = 16;
  8017de:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017e2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017e9:	eb 28                	jmp    801813 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017ef:	75 15                	jne    801806 <strtol+0x93>
  8017f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f4:	8a 00                	mov    (%eax),%al
  8017f6:	3c 30                	cmp    $0x30,%al
  8017f8:	75 0c                	jne    801806 <strtol+0x93>
		s++, base = 8;
  8017fa:	ff 45 08             	incl   0x8(%ebp)
  8017fd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801804:	eb 0d                	jmp    801813 <strtol+0xa0>
	else if (base == 0)
  801806:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180a:	75 07                	jne    801813 <strtol+0xa0>
		base = 10;
  80180c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801813:	8b 45 08             	mov    0x8(%ebp),%eax
  801816:	8a 00                	mov    (%eax),%al
  801818:	3c 2f                	cmp    $0x2f,%al
  80181a:	7e 19                	jle    801835 <strtol+0xc2>
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8a 00                	mov    (%eax),%al
  801821:	3c 39                	cmp    $0x39,%al
  801823:	7f 10                	jg     801835 <strtol+0xc2>
			dig = *s - '0';
  801825:	8b 45 08             	mov    0x8(%ebp),%eax
  801828:	8a 00                	mov    (%eax),%al
  80182a:	0f be c0             	movsbl %al,%eax
  80182d:	83 e8 30             	sub    $0x30,%eax
  801830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801833:	eb 42                	jmp    801877 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801835:	8b 45 08             	mov    0x8(%ebp),%eax
  801838:	8a 00                	mov    (%eax),%al
  80183a:	3c 60                	cmp    $0x60,%al
  80183c:	7e 19                	jle    801857 <strtol+0xe4>
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8a 00                	mov    (%eax),%al
  801843:	3c 7a                	cmp    $0x7a,%al
  801845:	7f 10                	jg     801857 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8a 00                	mov    (%eax),%al
  80184c:	0f be c0             	movsbl %al,%eax
  80184f:	83 e8 57             	sub    $0x57,%eax
  801852:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801855:	eb 20                	jmp    801877 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 40                	cmp    $0x40,%al
  80185e:	7e 39                	jle    801899 <strtol+0x126>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 5a                	cmp    $0x5a,%al
  801867:	7f 30                	jg     801899 <strtol+0x126>
			dig = *s - 'A' + 10;
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	0f be c0             	movsbl %al,%eax
  801871:	83 e8 37             	sub    $0x37,%eax
  801874:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80187d:	7d 19                	jge    801898 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80187f:	ff 45 08             	incl   0x8(%ebp)
  801882:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801885:	0f af 45 10          	imul   0x10(%ebp),%eax
  801889:	89 c2                	mov    %eax,%edx
  80188b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801893:	e9 7b ff ff ff       	jmp    801813 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801898:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801899:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80189d:	74 08                	je     8018a7 <strtol+0x134>
		*endptr = (char *) s;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8018a5:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8018a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8018ab:	74 07                	je     8018b4 <strtol+0x141>
  8018ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b0:	f7 d8                	neg    %eax
  8018b2:	eb 03                	jmp    8018b7 <strtol+0x144>
  8018b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b7:	c9                   	leave  
  8018b8:	c3                   	ret    

008018b9 <ltostr>:

void
ltostr(long value, char *str)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8018bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8018c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8018cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8018d1:	79 13                	jns    8018e6 <ltostr+0x2d>
	{
		neg = 1;
  8018d3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018dd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018e0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018e3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018ee:	99                   	cltd   
  8018ef:	f7 f9                	idiv   %ecx
  8018f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018f7:	8d 50 01             	lea    0x1(%eax),%edx
  8018fa:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018fd:	89 c2                	mov    %eax,%edx
  8018ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801902:	01 d0                	add    %edx,%eax
  801904:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801907:	83 c2 30             	add    $0x30,%edx
  80190a:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80190c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801914:	f7 e9                	imul   %ecx
  801916:	c1 fa 02             	sar    $0x2,%edx
  801919:	89 c8                	mov    %ecx,%eax
  80191b:	c1 f8 1f             	sar    $0x1f,%eax
  80191e:	29 c2                	sub    %eax,%edx
  801920:	89 d0                	mov    %edx,%eax
  801922:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801925:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801928:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80192d:	f7 e9                	imul   %ecx
  80192f:	c1 fa 02             	sar    $0x2,%edx
  801932:	89 c8                	mov    %ecx,%eax
  801934:	c1 f8 1f             	sar    $0x1f,%eax
  801937:	29 c2                	sub    %eax,%edx
  801939:	89 d0                	mov    %edx,%eax
  80193b:	c1 e0 02             	shl    $0x2,%eax
  80193e:	01 d0                	add    %edx,%eax
  801940:	01 c0                	add    %eax,%eax
  801942:	29 c1                	sub    %eax,%ecx
  801944:	89 ca                	mov    %ecx,%edx
  801946:	85 d2                	test   %edx,%edx
  801948:	75 9c                	jne    8018e6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80194a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801951:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801954:	48                   	dec    %eax
  801955:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801958:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80195c:	74 3d                	je     80199b <ltostr+0xe2>
		start = 1 ;
  80195e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801965:	eb 34                	jmp    80199b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	01 d0                	add    %edx,%eax
  80196f:	8a 00                	mov    (%eax),%al
  801971:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801977:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197a:	01 c2                	add    %eax,%edx
  80197c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80197f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801982:	01 c8                	add    %ecx,%eax
  801984:	8a 00                	mov    (%eax),%al
  801986:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801988:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80198b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198e:	01 c2                	add    %eax,%edx
  801990:	8a 45 eb             	mov    -0x15(%ebp),%al
  801993:	88 02                	mov    %al,(%edx)
		start++ ;
  801995:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801998:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80199b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019a1:	7c c4                	jl     801967 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8019a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8019a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a9:	01 d0                	add    %edx,%eax
  8019ab:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8019ae:	90                   	nop
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 54 fa ff ff       	call   801413 <strlen>
  8019bf:	83 c4 04             	add    $0x4,%esp
  8019c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8019c5:	ff 75 0c             	pushl  0xc(%ebp)
  8019c8:	e8 46 fa ff ff       	call   801413 <strlen>
  8019cd:	83 c4 04             	add    $0x4,%esp
  8019d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8019d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019e1:	eb 17                	jmp    8019fa <strcconcat+0x49>
		final[s] = str1[s] ;
  8019e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e9:	01 c2                	add    %eax,%edx
  8019eb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	01 c8                	add    %ecx,%eax
  8019f3:	8a 00                	mov    (%eax),%al
  8019f5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019f7:	ff 45 fc             	incl   -0x4(%ebp)
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801a00:	7c e1                	jl     8019e3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801a02:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801a09:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801a10:	eb 1f                	jmp    801a31 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801a12:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a15:	8d 50 01             	lea    0x1(%eax),%edx
  801a18:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a1b:	89 c2                	mov    %eax,%edx
  801a1d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a20:	01 c2                	add    %eax,%edx
  801a22:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a28:	01 c8                	add    %ecx,%eax
  801a2a:	8a 00                	mov    (%eax),%al
  801a2c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801a2e:	ff 45 f8             	incl   -0x8(%ebp)
  801a31:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a34:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a37:	7c d9                	jl     801a12 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801a39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3f:	01 d0                	add    %edx,%eax
  801a41:	c6 00 00             	movb   $0x0,(%eax)
}
  801a44:	90                   	nop
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a53:	8b 45 14             	mov    0x14(%ebp),%eax
  801a56:	8b 00                	mov    (%eax),%eax
  801a58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a62:	01 d0                	add    %edx,%eax
  801a64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a6a:	eb 0c                	jmp    801a78 <strsplit+0x31>
			*string++ = 0;
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	8d 50 01             	lea    0x1(%eax),%edx
  801a72:	89 55 08             	mov    %edx,0x8(%ebp)
  801a75:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	8a 00                	mov    (%eax),%al
  801a7d:	84 c0                	test   %al,%al
  801a7f:	74 18                	je     801a99 <strsplit+0x52>
  801a81:	8b 45 08             	mov    0x8(%ebp),%eax
  801a84:	8a 00                	mov    (%eax),%al
  801a86:	0f be c0             	movsbl %al,%eax
  801a89:	50                   	push   %eax
  801a8a:	ff 75 0c             	pushl  0xc(%ebp)
  801a8d:	e8 13 fb ff ff       	call   8015a5 <strchr>
  801a92:	83 c4 08             	add    $0x8,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	75 d3                	jne    801a6c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8a 00                	mov    (%eax),%al
  801a9e:	84 c0                	test   %al,%al
  801aa0:	74 5a                	je     801afc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801aa2:	8b 45 14             	mov    0x14(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	83 f8 0f             	cmp    $0xf,%eax
  801aaa:	75 07                	jne    801ab3 <strsplit+0x6c>
		{
			return 0;
  801aac:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab1:	eb 66                	jmp    801b19 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ab6:	8b 00                	mov    (%eax),%eax
  801ab8:	8d 48 01             	lea    0x1(%eax),%ecx
  801abb:	8b 55 14             	mov    0x14(%ebp),%edx
  801abe:	89 0a                	mov    %ecx,(%edx)
  801ac0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  801aca:	01 c2                	add    %eax,%edx
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad1:	eb 03                	jmp    801ad6 <strsplit+0x8f>
			string++;
  801ad3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad9:	8a 00                	mov    (%eax),%al
  801adb:	84 c0                	test   %al,%al
  801add:	74 8b                	je     801a6a <strsplit+0x23>
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8a 00                	mov    (%eax),%al
  801ae4:	0f be c0             	movsbl %al,%eax
  801ae7:	50                   	push   %eax
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	e8 b5 fa ff ff       	call   8015a5 <strchr>
  801af0:	83 c4 08             	add    $0x8,%esp
  801af3:	85 c0                	test   %eax,%eax
  801af5:	74 dc                	je     801ad3 <strsplit+0x8c>
			string++;
	}
  801af7:	e9 6e ff ff ff       	jmp    801a6a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801afc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801afd:	8b 45 14             	mov    0x14(%ebp),%eax
  801b00:	8b 00                	mov    (%eax),%eax
  801b02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b09:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0c:	01 d0                	add    %edx,%eax
  801b0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801b14:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801b21:	a1 04 50 80 00       	mov    0x805004,%eax
  801b26:	85 c0                	test   %eax,%eax
  801b28:	74 1f                	je     801b49 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801b2a:	e8 1d 00 00 00       	call   801b4c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801b2f:	83 ec 0c             	sub    $0xc,%esp
  801b32:	68 84 42 80 00       	push   $0x804284
  801b37:	e8 4f f0 ff ff       	call   800b8b <cprintf>
  801b3c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b3f:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b46:	00 00 00 
	}
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801b52:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b59:	00 00 00 
  801b5c:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b63:	00 00 00 
  801b66:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b6d:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b70:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b77:	00 00 00 
  801b7a:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b81:	00 00 00 
  801b84:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b8b:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801b8e:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b98:	c1 e8 0c             	shr    $0xc,%eax
  801b9b:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801ba0:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801baa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801baf:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bb4:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801bb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801bc0:	a1 20 51 80 00       	mov    0x805120,%eax
  801bc5:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801bc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801bcc:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801bd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801bd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bd9:	01 d0                	add    %edx,%eax
  801bdb:	48                   	dec    %eax
  801bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bdf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801be2:	ba 00 00 00 00       	mov    $0x0,%edx
  801be7:	f7 75 e4             	divl   -0x1c(%ebp)
  801bea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bed:	29 d0                	sub    %edx,%eax
  801bef:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801bf2:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801bf9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c01:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	6a 07                	push   $0x7
  801c0b:	ff 75 e8             	pushl  -0x18(%ebp)
  801c0e:	50                   	push   %eax
  801c0f:	e8 3d 06 00 00       	call   802251 <sys_allocate_chunk>
  801c14:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801c17:	a1 20 51 80 00       	mov    0x805120,%eax
  801c1c:	83 ec 0c             	sub    $0xc,%esp
  801c1f:	50                   	push   %eax
  801c20:	e8 b2 0c 00 00       	call   8028d7 <initialize_MemBlocksList>
  801c25:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801c28:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801c2d:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801c30:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c34:	0f 84 f3 00 00 00    	je     801d2d <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801c3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c3e:	75 14                	jne    801c54 <initialize_dyn_block_system+0x108>
  801c40:	83 ec 04             	sub    $0x4,%esp
  801c43:	68 a9 42 80 00       	push   $0x8042a9
  801c48:	6a 36                	push   $0x36
  801c4a:	68 c7 42 80 00       	push   $0x8042c7
  801c4f:	e8 83 ec ff ff       	call   8008d7 <_panic>
  801c54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c57:	8b 00                	mov    (%eax),%eax
  801c59:	85 c0                	test   %eax,%eax
  801c5b:	74 10                	je     801c6d <initialize_dyn_block_system+0x121>
  801c5d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c60:	8b 00                	mov    (%eax),%eax
  801c62:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c65:	8b 52 04             	mov    0x4(%edx),%edx
  801c68:	89 50 04             	mov    %edx,0x4(%eax)
  801c6b:	eb 0b                	jmp    801c78 <initialize_dyn_block_system+0x12c>
  801c6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c70:	8b 40 04             	mov    0x4(%eax),%eax
  801c73:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c7b:	8b 40 04             	mov    0x4(%eax),%eax
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	74 0f                	je     801c91 <initialize_dyn_block_system+0x145>
  801c82:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c85:	8b 40 04             	mov    0x4(%eax),%eax
  801c88:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c8b:	8b 12                	mov    (%edx),%edx
  801c8d:	89 10                	mov    %edx,(%eax)
  801c8f:	eb 0a                	jmp    801c9b <initialize_dyn_block_system+0x14f>
  801c91:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c94:	8b 00                	mov    (%eax),%eax
  801c96:	a3 48 51 80 00       	mov    %eax,0x805148
  801c9b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c9e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ca4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ca7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801cae:	a1 54 51 80 00       	mov    0x805154,%eax
  801cb3:	48                   	dec    %eax
  801cb4:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801cb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cbc:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801cc3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cc6:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801ccd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801cd1:	75 14                	jne    801ce7 <initialize_dyn_block_system+0x19b>
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	68 d4 42 80 00       	push   $0x8042d4
  801cdb:	6a 3e                	push   $0x3e
  801cdd:	68 c7 42 80 00       	push   $0x8042c7
  801ce2:	e8 f0 eb ff ff       	call   8008d7 <_panic>
  801ce7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801ced:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cf0:	89 10                	mov    %edx,(%eax)
  801cf2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cf5:	8b 00                	mov    (%eax),%eax
  801cf7:	85 c0                	test   %eax,%eax
  801cf9:	74 0d                	je     801d08 <initialize_dyn_block_system+0x1bc>
  801cfb:	a1 38 51 80 00       	mov    0x805138,%eax
  801d00:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d03:	89 50 04             	mov    %edx,0x4(%eax)
  801d06:	eb 08                	jmp    801d10 <initialize_dyn_block_system+0x1c4>
  801d08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d0b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801d10:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d13:	a3 38 51 80 00       	mov    %eax,0x805138
  801d18:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d1b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d22:	a1 44 51 80 00       	mov    0x805144,%eax
  801d27:	40                   	inc    %eax
  801d28:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801d2d:	90                   	nop
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801d36:	e8 e0 fd ff ff       	call   801b1b <InitializeUHeap>
		if (size == 0) return NULL ;
  801d3b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d3f:	75 07                	jne    801d48 <malloc+0x18>
  801d41:	b8 00 00 00 00       	mov    $0x0,%eax
  801d46:	eb 7f                	jmp    801dc7 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d48:	e8 d2 08 00 00       	call   80261f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d4d:	85 c0                	test   %eax,%eax
  801d4f:	74 71                	je     801dc2 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801d51:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d58:	8b 55 08             	mov    0x8(%ebp),%edx
  801d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5e:	01 d0                	add    %edx,%eax
  801d60:	48                   	dec    %eax
  801d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d67:	ba 00 00 00 00       	mov    $0x0,%edx
  801d6c:	f7 75 f4             	divl   -0xc(%ebp)
  801d6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d72:	29 d0                	sub    %edx,%eax
  801d74:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801d77:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801d7e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d85:	76 07                	jbe    801d8e <malloc+0x5e>
					return NULL ;
  801d87:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8c:	eb 39                	jmp    801dc7 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801d8e:	83 ec 0c             	sub    $0xc,%esp
  801d91:	ff 75 08             	pushl  0x8(%ebp)
  801d94:	e8 e6 0d 00 00       	call   802b7f <alloc_block_FF>
  801d99:	83 c4 10             	add    $0x10,%esp
  801d9c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801d9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801da3:	74 16                	je     801dbb <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801da5:	83 ec 0c             	sub    $0xc,%esp
  801da8:	ff 75 ec             	pushl  -0x14(%ebp)
  801dab:	e8 37 0c 00 00       	call   8029e7 <insert_sorted_allocList>
  801db0:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801db6:	8b 40 08             	mov    0x8(%eax),%eax
  801db9:	eb 0c                	jmp    801dc7 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801dbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc0:	eb 05                	jmp    801dc7 <malloc+0x97>
				}
		}
	return 0;
  801dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc7:	c9                   	leave  
  801dc8:	c3                   	ret    

00801dc9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801dc9:	55                   	push   %ebp
  801dca:	89 e5                	mov    %esp,%ebp
  801dcc:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801dd5:	83 ec 08             	sub    $0x8,%esp
  801dd8:	ff 75 f4             	pushl  -0xc(%ebp)
  801ddb:	68 40 50 80 00       	push   $0x805040
  801de0:	e8 cf 0b 00 00       	call   8029b4 <find_block>
  801de5:	83 c4 10             	add    $0x10,%esp
  801de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dee:	8b 40 0c             	mov    0xc(%eax),%eax
  801df1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df7:	8b 40 08             	mov    0x8(%eax),%eax
  801dfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801dfd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e01:	0f 84 a1 00 00 00    	je     801ea8 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801e07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e0b:	75 17                	jne    801e24 <free+0x5b>
  801e0d:	83 ec 04             	sub    $0x4,%esp
  801e10:	68 a9 42 80 00       	push   $0x8042a9
  801e15:	68 80 00 00 00       	push   $0x80
  801e1a:	68 c7 42 80 00       	push   $0x8042c7
  801e1f:	e8 b3 ea ff ff       	call   8008d7 <_panic>
  801e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e27:	8b 00                	mov    (%eax),%eax
  801e29:	85 c0                	test   %eax,%eax
  801e2b:	74 10                	je     801e3d <free+0x74>
  801e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e30:	8b 00                	mov    (%eax),%eax
  801e32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e35:	8b 52 04             	mov    0x4(%edx),%edx
  801e38:	89 50 04             	mov    %edx,0x4(%eax)
  801e3b:	eb 0b                	jmp    801e48 <free+0x7f>
  801e3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e40:	8b 40 04             	mov    0x4(%eax),%eax
  801e43:	a3 44 50 80 00       	mov    %eax,0x805044
  801e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4b:	8b 40 04             	mov    0x4(%eax),%eax
  801e4e:	85 c0                	test   %eax,%eax
  801e50:	74 0f                	je     801e61 <free+0x98>
  801e52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e55:	8b 40 04             	mov    0x4(%eax),%eax
  801e58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e5b:	8b 12                	mov    (%edx),%edx
  801e5d:	89 10                	mov    %edx,(%eax)
  801e5f:	eb 0a                	jmp    801e6b <free+0xa2>
  801e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e64:	8b 00                	mov    (%eax),%eax
  801e66:	a3 40 50 80 00       	mov    %eax,0x805040
  801e6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e7e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e83:	48                   	dec    %eax
  801e84:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801e89:	83 ec 0c             	sub    $0xc,%esp
  801e8c:	ff 75 f0             	pushl  -0x10(%ebp)
  801e8f:	e8 29 12 00 00       	call   8030bd <insert_sorted_with_merge_freeList>
  801e94:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801e97:	83 ec 08             	sub    $0x8,%esp
  801e9a:	ff 75 ec             	pushl  -0x14(%ebp)
  801e9d:	ff 75 e8             	pushl  -0x18(%ebp)
  801ea0:	e8 74 03 00 00       	call   802219 <sys_free_user_mem>
  801ea5:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801ea8:	90                   	nop
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 38             	sub    $0x38,%esp
  801eb1:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb4:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801eb7:	e8 5f fc ff ff       	call   801b1b <InitializeUHeap>
	if (size == 0) return NULL ;
  801ebc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ec0:	75 0a                	jne    801ecc <smalloc+0x21>
  801ec2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec7:	e9 b2 00 00 00       	jmp    801f7e <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801ecc:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801ed3:	76 0a                	jbe    801edf <smalloc+0x34>
		return NULL;
  801ed5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eda:	e9 9f 00 00 00       	jmp    801f7e <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801edf:	e8 3b 07 00 00       	call   80261f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ee4:	85 c0                	test   %eax,%eax
  801ee6:	0f 84 8d 00 00 00    	je     801f79 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801eec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801ef3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801efa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f00:	01 d0                	add    %edx,%eax
  801f02:	48                   	dec    %eax
  801f03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801f06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f09:	ba 00 00 00 00       	mov    $0x0,%edx
  801f0e:	f7 75 f0             	divl   -0x10(%ebp)
  801f11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f14:	29 d0                	sub    %edx,%eax
  801f16:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	ff 75 e8             	pushl  -0x18(%ebp)
  801f1f:	e8 5b 0c 00 00       	call   802b7f <alloc_block_FF>
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801f2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2e:	75 07                	jne    801f37 <smalloc+0x8c>
			return NULL;
  801f30:	b8 00 00 00 00       	mov    $0x0,%eax
  801f35:	eb 47                	jmp    801f7e <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801f37:	83 ec 0c             	sub    $0xc,%esp
  801f3a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3d:	e8 a5 0a 00 00       	call   8029e7 <insert_sorted_allocList>
  801f42:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	8b 40 08             	mov    0x8(%eax),%eax
  801f4b:	89 c2                	mov    %eax,%edx
  801f4d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f51:	52                   	push   %edx
  801f52:	50                   	push   %eax
  801f53:	ff 75 0c             	pushl  0xc(%ebp)
  801f56:	ff 75 08             	pushl  0x8(%ebp)
  801f59:	e8 46 04 00 00       	call   8023a4 <sys_createSharedObject>
  801f5e:	83 c4 10             	add    $0x10,%esp
  801f61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801f64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f68:	78 08                	js     801f72 <smalloc+0xc7>
		return (void *)b->sva;
  801f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6d:	8b 40 08             	mov    0x8(%eax),%eax
  801f70:	eb 0c                	jmp    801f7e <smalloc+0xd3>
		}else{
		return NULL;
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
  801f77:	eb 05                	jmp    801f7e <smalloc+0xd3>
			}

	}return NULL;
  801f79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f86:	e8 90 fb ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801f8b:	e8 8f 06 00 00       	call   80261f <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f90:	85 c0                	test   %eax,%eax
  801f92:	0f 84 ad 00 00 00    	je     802045 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f98:	83 ec 08             	sub    $0x8,%esp
  801f9b:	ff 75 0c             	pushl  0xc(%ebp)
  801f9e:	ff 75 08             	pushl  0x8(%ebp)
  801fa1:	e8 28 04 00 00       	call   8023ce <sys_getSizeOfSharedObject>
  801fa6:	83 c4 10             	add    $0x10,%esp
  801fa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801fac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb0:	79 0a                	jns    801fbc <sget+0x3c>
    {
    	return NULL;
  801fb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb7:	e9 8e 00 00 00       	jmp    80204a <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801fbc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801fc3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801fca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd0:	01 d0                	add    %edx,%eax
  801fd2:	48                   	dec    %eax
  801fd3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801fd6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fd9:	ba 00 00 00 00       	mov    $0x0,%edx
  801fde:	f7 75 ec             	divl   -0x14(%ebp)
  801fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fe4:	29 d0                	sub    %edx,%eax
  801fe6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801fe9:	83 ec 0c             	sub    $0xc,%esp
  801fec:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fef:	e8 8b 0b 00 00       	call   802b7f <alloc_block_FF>
  801ff4:	83 c4 10             	add    $0x10,%esp
  801ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801ffa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ffe:	75 07                	jne    802007 <sget+0x87>
				return NULL;
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
  802005:	eb 43                	jmp    80204a <sget+0xca>
			}
			insert_sorted_allocList(b);
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	ff 75 f0             	pushl  -0x10(%ebp)
  80200d:	e8 d5 09 00 00       	call   8029e7 <insert_sorted_allocList>
  802012:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  802015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802018:	8b 40 08             	mov    0x8(%eax),%eax
  80201b:	83 ec 04             	sub    $0x4,%esp
  80201e:	50                   	push   %eax
  80201f:	ff 75 0c             	pushl  0xc(%ebp)
  802022:	ff 75 08             	pushl  0x8(%ebp)
  802025:	e8 c1 03 00 00       	call   8023eb <sys_getSharedObject>
  80202a:	83 c4 10             	add    $0x10,%esp
  80202d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  802030:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802034:	78 08                	js     80203e <sget+0xbe>
			return (void *)b->sva;
  802036:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802039:	8b 40 08             	mov    0x8(%eax),%eax
  80203c:	eb 0c                	jmp    80204a <sget+0xca>
			}else{
			return NULL;
  80203e:	b8 00 00 00 00       	mov    $0x0,%eax
  802043:	eb 05                	jmp    80204a <sget+0xca>
			}
    }}return NULL;
  802045:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80204a:	c9                   	leave  
  80204b:	c3                   	ret    

0080204c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80204c:	55                   	push   %ebp
  80204d:	89 e5                	mov    %esp,%ebp
  80204f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802052:	e8 c4 fa ff ff       	call   801b1b <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	68 f8 42 80 00       	push   $0x8042f8
  80205f:	68 03 01 00 00       	push   $0x103
  802064:	68 c7 42 80 00       	push   $0x8042c7
  802069:	e8 69 e8 ff ff       	call   8008d7 <_panic>

0080206e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802074:	83 ec 04             	sub    $0x4,%esp
  802077:	68 20 43 80 00       	push   $0x804320
  80207c:	68 17 01 00 00       	push   $0x117
  802081:	68 c7 42 80 00       	push   $0x8042c7
  802086:	e8 4c e8 ff ff       	call   8008d7 <_panic>

0080208b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	68 44 43 80 00       	push   $0x804344
  802099:	68 22 01 00 00       	push   $0x122
  80209e:	68 c7 42 80 00       	push   $0x8042c7
  8020a3:	e8 2f e8 ff ff       	call   8008d7 <_panic>

008020a8 <shrink>:

}
void shrink(uint32 newSize)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020ae:	83 ec 04             	sub    $0x4,%esp
  8020b1:	68 44 43 80 00       	push   $0x804344
  8020b6:	68 27 01 00 00       	push   $0x127
  8020bb:	68 c7 42 80 00       	push   $0x8042c7
  8020c0:	e8 12 e8 ff ff       	call   8008d7 <_panic>

008020c5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8020cb:	83 ec 04             	sub    $0x4,%esp
  8020ce:	68 44 43 80 00       	push   $0x804344
  8020d3:	68 2c 01 00 00       	push   $0x12c
  8020d8:	68 c7 42 80 00       	push   $0x8042c7
  8020dd:	e8 f5 e7 ff ff       	call   8008d7 <_panic>

008020e2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	57                   	push   %edi
  8020e6:	56                   	push   %esi
  8020e7:	53                   	push   %ebx
  8020e8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020f7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020fa:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020fd:	cd 30                	int    $0x30
  8020ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802102:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802105:	83 c4 10             	add    $0x10,%esp
  802108:	5b                   	pop    %ebx
  802109:	5e                   	pop    %esi
  80210a:	5f                   	pop    %edi
  80210b:	5d                   	pop    %ebp
  80210c:	c3                   	ret    

0080210d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	83 ec 04             	sub    $0x4,%esp
  802113:	8b 45 10             	mov    0x10(%ebp),%eax
  802116:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802119:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	52                   	push   %edx
  802125:	ff 75 0c             	pushl  0xc(%ebp)
  802128:	50                   	push   %eax
  802129:	6a 00                	push   $0x0
  80212b:	e8 b2 ff ff ff       	call   8020e2 <syscall>
  802130:	83 c4 18             	add    $0x18,%esp
}
  802133:	90                   	nop
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <sys_cgetc>:

int
sys_cgetc(void)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802139:	6a 00                	push   $0x0
  80213b:	6a 00                	push   $0x0
  80213d:	6a 00                	push   $0x0
  80213f:	6a 00                	push   $0x0
  802141:	6a 00                	push   $0x0
  802143:	6a 01                	push   $0x1
  802145:	e8 98 ff ff ff       	call   8020e2 <syscall>
  80214a:	83 c4 18             	add    $0x18,%esp
}
  80214d:	c9                   	leave  
  80214e:	c3                   	ret    

0080214f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80214f:	55                   	push   %ebp
  802150:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802152:	8b 55 0c             	mov    0xc(%ebp),%edx
  802155:	8b 45 08             	mov    0x8(%ebp),%eax
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	52                   	push   %edx
  80215f:	50                   	push   %eax
  802160:	6a 05                	push   $0x5
  802162:	e8 7b ff ff ff       	call   8020e2 <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	56                   	push   %esi
  802170:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802171:	8b 75 18             	mov    0x18(%ebp),%esi
  802174:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802177:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80217a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80217d:	8b 45 08             	mov    0x8(%ebp),%eax
  802180:	56                   	push   %esi
  802181:	53                   	push   %ebx
  802182:	51                   	push   %ecx
  802183:	52                   	push   %edx
  802184:	50                   	push   %eax
  802185:	6a 06                	push   $0x6
  802187:	e8 56 ff ff ff       	call   8020e2 <syscall>
  80218c:	83 c4 18             	add    $0x18,%esp
}
  80218f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802192:	5b                   	pop    %ebx
  802193:	5e                   	pop    %esi
  802194:	5d                   	pop    %ebp
  802195:	c3                   	ret    

00802196 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802196:	55                   	push   %ebp
  802197:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802199:	8b 55 0c             	mov    0xc(%ebp),%edx
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	52                   	push   %edx
  8021a6:	50                   	push   %eax
  8021a7:	6a 07                	push   $0x7
  8021a9:	e8 34 ff ff ff       	call   8020e2 <syscall>
  8021ae:	83 c4 18             	add    $0x18,%esp
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	ff 75 0c             	pushl  0xc(%ebp)
  8021bf:	ff 75 08             	pushl  0x8(%ebp)
  8021c2:	6a 08                	push   $0x8
  8021c4:	e8 19 ff ff ff       	call   8020e2 <syscall>
  8021c9:	83 c4 18             	add    $0x18,%esp
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 00                	push   $0x0
  8021d5:	6a 00                	push   $0x0
  8021d7:	6a 00                	push   $0x0
  8021d9:	6a 00                	push   $0x0
  8021db:	6a 09                	push   $0x9
  8021dd:	e8 00 ff ff ff       	call   8020e2 <syscall>
  8021e2:	83 c4 18             	add    $0x18,%esp
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021ea:	6a 00                	push   $0x0
  8021ec:	6a 00                	push   $0x0
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 0a                	push   $0xa
  8021f6:	e8 e7 fe ff ff       	call   8020e2 <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802203:	6a 00                	push   $0x0
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	6a 00                	push   $0x0
  80220d:	6a 0b                	push   $0xb
  80220f:	e8 ce fe ff ff       	call   8020e2 <syscall>
  802214:	83 c4 18             	add    $0x18,%esp
}
  802217:	c9                   	leave  
  802218:	c3                   	ret    

00802219 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80221c:	6a 00                	push   $0x0
  80221e:	6a 00                	push   $0x0
  802220:	6a 00                	push   $0x0
  802222:	ff 75 0c             	pushl  0xc(%ebp)
  802225:	ff 75 08             	pushl  0x8(%ebp)
  802228:	6a 0f                	push   $0xf
  80222a:	e8 b3 fe ff ff       	call   8020e2 <syscall>
  80222f:	83 c4 18             	add    $0x18,%esp
	return;
  802232:	90                   	nop
}
  802233:	c9                   	leave  
  802234:	c3                   	ret    

00802235 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	6a 00                	push   $0x0
  80223e:	ff 75 0c             	pushl  0xc(%ebp)
  802241:	ff 75 08             	pushl  0x8(%ebp)
  802244:	6a 10                	push   $0x10
  802246:	e8 97 fe ff ff       	call   8020e2 <syscall>
  80224b:	83 c4 18             	add    $0x18,%esp
	return ;
  80224e:	90                   	nop
}
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	ff 75 10             	pushl  0x10(%ebp)
  80225b:	ff 75 0c             	pushl  0xc(%ebp)
  80225e:	ff 75 08             	pushl  0x8(%ebp)
  802261:	6a 11                	push   $0x11
  802263:	e8 7a fe ff ff       	call   8020e2 <syscall>
  802268:	83 c4 18             	add    $0x18,%esp
	return ;
  80226b:	90                   	nop
}
  80226c:	c9                   	leave  
  80226d:	c3                   	ret    

0080226e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80226e:	55                   	push   %ebp
  80226f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 00                	push   $0x0
  802277:	6a 00                	push   $0x0
  802279:	6a 00                	push   $0x0
  80227b:	6a 0c                	push   $0xc
  80227d:	e8 60 fe ff ff       	call   8020e2 <syscall>
  802282:	83 c4 18             	add    $0x18,%esp
}
  802285:	c9                   	leave  
  802286:	c3                   	ret    

00802287 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802287:	55                   	push   %ebp
  802288:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	ff 75 08             	pushl  0x8(%ebp)
  802295:	6a 0d                	push   $0xd
  802297:	e8 46 fe ff ff       	call   8020e2 <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 0e                	push   $0xe
  8022b0:	e8 2d fe ff ff       	call   8020e2 <syscall>
  8022b5:	83 c4 18             	add    $0x18,%esp
}
  8022b8:	90                   	nop
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    

008022bb <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022bb:	55                   	push   %ebp
  8022bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 00                	push   $0x0
  8022c8:	6a 13                	push   $0x13
  8022ca:	e8 13 fe ff ff       	call   8020e2 <syscall>
  8022cf:	83 c4 18             	add    $0x18,%esp
}
  8022d2:	90                   	nop
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 14                	push   $0x14
  8022e4:	e8 f9 fd ff ff       	call   8020e2 <syscall>
  8022e9:	83 c4 18             	add    $0x18,%esp
}
  8022ec:	90                   	nop
  8022ed:	c9                   	leave  
  8022ee:	c3                   	ret    

008022ef <sys_cputc>:


void
sys_cputc(const char c)
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	83 ec 04             	sub    $0x4,%esp
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022fb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	50                   	push   %eax
  802308:	6a 15                	push   $0x15
  80230a:	e8 d3 fd ff ff       	call   8020e2 <syscall>
  80230f:	83 c4 18             	add    $0x18,%esp
}
  802312:	90                   	nop
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 16                	push   $0x16
  802324:	e8 b9 fd ff ff       	call   8020e2 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
}
  80232c:	90                   	nop
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	ff 75 0c             	pushl  0xc(%ebp)
  80233e:	50                   	push   %eax
  80233f:	6a 17                	push   $0x17
  802341:	e8 9c fd ff ff       	call   8020e2 <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80234e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	6a 00                	push   $0x0
  802356:	6a 00                	push   $0x0
  802358:	6a 00                	push   $0x0
  80235a:	52                   	push   %edx
  80235b:	50                   	push   %eax
  80235c:	6a 1a                	push   $0x1a
  80235e:	e8 7f fd ff ff       	call   8020e2 <syscall>
  802363:	83 c4 18             	add    $0x18,%esp
}
  802366:	c9                   	leave  
  802367:	c3                   	ret    

00802368 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802368:	55                   	push   %ebp
  802369:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80236b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236e:	8b 45 08             	mov    0x8(%ebp),%eax
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	52                   	push   %edx
  802378:	50                   	push   %eax
  802379:	6a 18                	push   $0x18
  80237b:	e8 62 fd ff ff       	call   8020e2 <syscall>
  802380:	83 c4 18             	add    $0x18,%esp
}
  802383:	90                   	nop
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802389:	8b 55 0c             	mov    0xc(%ebp),%edx
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 00                	push   $0x0
  802395:	52                   	push   %edx
  802396:	50                   	push   %eax
  802397:	6a 19                	push   $0x19
  802399:	e8 44 fd ff ff       	call   8020e2 <syscall>
  80239e:	83 c4 18             	add    $0x18,%esp
}
  8023a1:	90                   	nop
  8023a2:	c9                   	leave  
  8023a3:	c3                   	ret    

008023a4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023a4:	55                   	push   %ebp
  8023a5:	89 e5                	mov    %esp,%ebp
  8023a7:	83 ec 04             	sub    $0x4,%esp
  8023aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023b0:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	6a 00                	push   $0x0
  8023bc:	51                   	push   %ecx
  8023bd:	52                   	push   %edx
  8023be:	ff 75 0c             	pushl  0xc(%ebp)
  8023c1:	50                   	push   %eax
  8023c2:	6a 1b                	push   $0x1b
  8023c4:	e8 19 fd ff ff       	call   8020e2 <syscall>
  8023c9:	83 c4 18             	add    $0x18,%esp
}
  8023cc:	c9                   	leave  
  8023cd:	c3                   	ret    

008023ce <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8023d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	6a 00                	push   $0x0
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	52                   	push   %edx
  8023de:	50                   	push   %eax
  8023df:	6a 1c                	push   $0x1c
  8023e1:	e8 fc fc ff ff       	call   8020e2 <syscall>
  8023e6:	83 c4 18             	add    $0x18,%esp
}
  8023e9:	c9                   	leave  
  8023ea:	c3                   	ret    

008023eb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023eb:	55                   	push   %ebp
  8023ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	51                   	push   %ecx
  8023fc:	52                   	push   %edx
  8023fd:	50                   	push   %eax
  8023fe:	6a 1d                	push   $0x1d
  802400:	e8 dd fc ff ff       	call   8020e2 <syscall>
  802405:	83 c4 18             	add    $0x18,%esp
}
  802408:	c9                   	leave  
  802409:	c3                   	ret    

0080240a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80240d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802410:	8b 45 08             	mov    0x8(%ebp),%eax
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	52                   	push   %edx
  80241a:	50                   	push   %eax
  80241b:	6a 1e                	push   $0x1e
  80241d:	e8 c0 fc ff ff       	call   8020e2 <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
}
  802425:	c9                   	leave  
  802426:	c3                   	ret    

00802427 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802427:	55                   	push   %ebp
  802428:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	6a 00                	push   $0x0
  802434:	6a 1f                	push   $0x1f
  802436:	e8 a7 fc ff ff       	call   8020e2 <syscall>
  80243b:	83 c4 18             	add    $0x18,%esp
}
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	6a 00                	push   $0x0
  802448:	ff 75 14             	pushl  0x14(%ebp)
  80244b:	ff 75 10             	pushl  0x10(%ebp)
  80244e:	ff 75 0c             	pushl  0xc(%ebp)
  802451:	50                   	push   %eax
  802452:	6a 20                	push   $0x20
  802454:	e8 89 fc ff ff       	call   8020e2 <syscall>
  802459:	83 c4 18             	add    $0x18,%esp
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	50                   	push   %eax
  80246d:	6a 21                	push   $0x21
  80246f:	e8 6e fc ff ff       	call   8020e2 <syscall>
  802474:	83 c4 18             	add    $0x18,%esp
}
  802477:	90                   	nop
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	6a 00                	push   $0x0
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	50                   	push   %eax
  802489:	6a 22                	push   $0x22
  80248b:	e8 52 fc ff ff       	call   8020e2 <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
}
  802493:	c9                   	leave  
  802494:	c3                   	ret    

00802495 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802495:	55                   	push   %ebp
  802496:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	6a 02                	push   $0x2
  8024a4:	e8 39 fc ff ff       	call   8020e2 <syscall>
  8024a9:	83 c4 18             	add    $0x18,%esp
}
  8024ac:	c9                   	leave  
  8024ad:	c3                   	ret    

008024ae <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8024ae:	55                   	push   %ebp
  8024af:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 00                	push   $0x0
  8024b5:	6a 00                	push   $0x0
  8024b7:	6a 00                	push   $0x0
  8024b9:	6a 00                	push   $0x0
  8024bb:	6a 03                	push   $0x3
  8024bd:	e8 20 fc ff ff       	call   8020e2 <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
}
  8024c5:	c9                   	leave  
  8024c6:	c3                   	ret    

008024c7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 00                	push   $0x0
  8024ce:	6a 00                	push   $0x0
  8024d0:	6a 00                	push   $0x0
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 04                	push   $0x4
  8024d6:	e8 07 fc ff ff       	call   8020e2 <syscall>
  8024db:	83 c4 18             	add    $0x18,%esp
}
  8024de:	c9                   	leave  
  8024df:	c3                   	ret    

008024e0 <sys_exit_env>:


void sys_exit_env(void)
{
  8024e0:	55                   	push   %ebp
  8024e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024e3:	6a 00                	push   $0x0
  8024e5:	6a 00                	push   $0x0
  8024e7:	6a 00                	push   $0x0
  8024e9:	6a 00                	push   $0x0
  8024eb:	6a 00                	push   $0x0
  8024ed:	6a 23                	push   $0x23
  8024ef:	e8 ee fb ff ff       	call   8020e2 <syscall>
  8024f4:	83 c4 18             	add    $0x18,%esp
}
  8024f7:	90                   	nop
  8024f8:	c9                   	leave  
  8024f9:	c3                   	ret    

008024fa <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
  8024fd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802500:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802503:	8d 50 04             	lea    0x4(%eax),%edx
  802506:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	52                   	push   %edx
  802510:	50                   	push   %eax
  802511:	6a 24                	push   $0x24
  802513:	e8 ca fb ff ff       	call   8020e2 <syscall>
  802518:	83 c4 18             	add    $0x18,%esp
	return result;
  80251b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80251e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802521:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802524:	89 01                	mov    %eax,(%ecx)
  802526:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802529:	8b 45 08             	mov    0x8(%ebp),%eax
  80252c:	c9                   	leave  
  80252d:	c2 04 00             	ret    $0x4

00802530 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	ff 75 10             	pushl  0x10(%ebp)
  80253a:	ff 75 0c             	pushl  0xc(%ebp)
  80253d:	ff 75 08             	pushl  0x8(%ebp)
  802540:	6a 12                	push   $0x12
  802542:	e8 9b fb ff ff       	call   8020e2 <syscall>
  802547:	83 c4 18             	add    $0x18,%esp
	return ;
  80254a:	90                   	nop
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <sys_rcr2>:
uint32 sys_rcr2()
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802550:	6a 00                	push   $0x0
  802552:	6a 00                	push   $0x0
  802554:	6a 00                	push   $0x0
  802556:	6a 00                	push   $0x0
  802558:	6a 00                	push   $0x0
  80255a:	6a 25                	push   $0x25
  80255c:	e8 81 fb ff ff       	call   8020e2 <syscall>
  802561:	83 c4 18             	add    $0x18,%esp
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	83 ec 04             	sub    $0x4,%esp
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802572:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802576:	6a 00                	push   $0x0
  802578:	6a 00                	push   $0x0
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	50                   	push   %eax
  80257f:	6a 26                	push   $0x26
  802581:	e8 5c fb ff ff       	call   8020e2 <syscall>
  802586:	83 c4 18             	add    $0x18,%esp
	return ;
  802589:	90                   	nop
}
  80258a:	c9                   	leave  
  80258b:	c3                   	ret    

0080258c <rsttst>:
void rsttst()
{
  80258c:	55                   	push   %ebp
  80258d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80258f:	6a 00                	push   $0x0
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 28                	push   $0x28
  80259b:	e8 42 fb ff ff       	call   8020e2 <syscall>
  8025a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8025a3:	90                   	nop
}
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 04             	sub    $0x4,%esp
  8025ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8025af:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8025b2:	8b 55 18             	mov    0x18(%ebp),%edx
  8025b5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8025b9:	52                   	push   %edx
  8025ba:	50                   	push   %eax
  8025bb:	ff 75 10             	pushl  0x10(%ebp)
  8025be:	ff 75 0c             	pushl  0xc(%ebp)
  8025c1:	ff 75 08             	pushl  0x8(%ebp)
  8025c4:	6a 27                	push   $0x27
  8025c6:	e8 17 fb ff ff       	call   8020e2 <syscall>
  8025cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8025ce:	90                   	nop
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <chktst>:
void chktst(uint32 n)
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	ff 75 08             	pushl  0x8(%ebp)
  8025df:	6a 29                	push   $0x29
  8025e1:	e8 fc fa ff ff       	call   8020e2 <syscall>
  8025e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8025e9:	90                   	nop
}
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <inctst>:

void inctst()
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 2a                	push   $0x2a
  8025fb:	e8 e2 fa ff ff       	call   8020e2 <syscall>
  802600:	83 c4 18             	add    $0x18,%esp
	return ;
  802603:	90                   	nop
}
  802604:	c9                   	leave  
  802605:	c3                   	ret    

00802606 <gettst>:
uint32 gettst()
{
  802606:	55                   	push   %ebp
  802607:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802609:	6a 00                	push   $0x0
  80260b:	6a 00                	push   $0x0
  80260d:	6a 00                	push   $0x0
  80260f:	6a 00                	push   $0x0
  802611:	6a 00                	push   $0x0
  802613:	6a 2b                	push   $0x2b
  802615:	e8 c8 fa ff ff       	call   8020e2 <syscall>
  80261a:	83 c4 18             	add    $0x18,%esp
}
  80261d:	c9                   	leave  
  80261e:	c3                   	ret    

0080261f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80261f:	55                   	push   %ebp
  802620:	89 e5                	mov    %esp,%ebp
  802622:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802625:	6a 00                	push   $0x0
  802627:	6a 00                	push   $0x0
  802629:	6a 00                	push   $0x0
  80262b:	6a 00                	push   $0x0
  80262d:	6a 00                	push   $0x0
  80262f:	6a 2c                	push   $0x2c
  802631:	e8 ac fa ff ff       	call   8020e2 <syscall>
  802636:	83 c4 18             	add    $0x18,%esp
  802639:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80263c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802640:	75 07                	jne    802649 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802642:	b8 01 00 00 00       	mov    $0x1,%eax
  802647:	eb 05                	jmp    80264e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802649:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264e:	c9                   	leave  
  80264f:	c3                   	ret    

00802650 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 2c                	push   $0x2c
  802662:	e8 7b fa ff ff       	call   8020e2 <syscall>
  802667:	83 c4 18             	add    $0x18,%esp
  80266a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80266d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802671:	75 07                	jne    80267a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802673:	b8 01 00 00 00       	mov    $0x1,%eax
  802678:	eb 05                	jmp    80267f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80267a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80267f:	c9                   	leave  
  802680:	c3                   	ret    

00802681 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802681:	55                   	push   %ebp
  802682:	89 e5                	mov    %esp,%ebp
  802684:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802687:	6a 00                	push   $0x0
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 2c                	push   $0x2c
  802693:	e8 4a fa ff ff       	call   8020e2 <syscall>
  802698:	83 c4 18             	add    $0x18,%esp
  80269b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80269e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8026a2:	75 07                	jne    8026ab <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8026a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a9:	eb 05                	jmp    8026b0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026b0:	c9                   	leave  
  8026b1:	c3                   	ret    

008026b2 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
  8026b5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 2c                	push   $0x2c
  8026c4:	e8 19 fa ff ff       	call   8020e2 <syscall>
  8026c9:	83 c4 18             	add    $0x18,%esp
  8026cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8026cf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026d3:	75 07                	jne    8026dc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026d5:	b8 01 00 00 00       	mov    $0x1,%eax
  8026da:	eb 05                	jmp    8026e1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026e1:	c9                   	leave  
  8026e2:	c3                   	ret    

008026e3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026e3:	55                   	push   %ebp
  8026e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	6a 00                	push   $0x0
  8026ee:	ff 75 08             	pushl  0x8(%ebp)
  8026f1:	6a 2d                	push   $0x2d
  8026f3:	e8 ea f9 ff ff       	call   8020e2 <syscall>
  8026f8:	83 c4 18             	add    $0x18,%esp
	return ;
  8026fb:	90                   	nop
}
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    

008026fe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802702:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802705:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802708:	8b 55 0c             	mov    0xc(%ebp),%edx
  80270b:	8b 45 08             	mov    0x8(%ebp),%eax
  80270e:	6a 00                	push   $0x0
  802710:	53                   	push   %ebx
  802711:	51                   	push   %ecx
  802712:	52                   	push   %edx
  802713:	50                   	push   %eax
  802714:	6a 2e                	push   $0x2e
  802716:	e8 c7 f9 ff ff       	call   8020e2 <syscall>
  80271b:	83 c4 18             	add    $0x18,%esp
}
  80271e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802721:	c9                   	leave  
  802722:	c3                   	ret    

00802723 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802723:	55                   	push   %ebp
  802724:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802726:	8b 55 0c             	mov    0xc(%ebp),%edx
  802729:	8b 45 08             	mov    0x8(%ebp),%eax
  80272c:	6a 00                	push   $0x0
  80272e:	6a 00                	push   $0x0
  802730:	6a 00                	push   $0x0
  802732:	52                   	push   %edx
  802733:	50                   	push   %eax
  802734:	6a 2f                	push   $0x2f
  802736:	e8 a7 f9 ff ff       	call   8020e2 <syscall>
  80273b:	83 c4 18             	add    $0x18,%esp
}
  80273e:	c9                   	leave  
  80273f:	c3                   	ret    

00802740 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802740:	55                   	push   %ebp
  802741:	89 e5                	mov    %esp,%ebp
  802743:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802746:	83 ec 0c             	sub    $0xc,%esp
  802749:	68 54 43 80 00       	push   $0x804354
  80274e:	e8 38 e4 ff ff       	call   800b8b <cprintf>
  802753:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802756:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80275d:	83 ec 0c             	sub    $0xc,%esp
  802760:	68 80 43 80 00       	push   $0x804380
  802765:	e8 21 e4 ff ff       	call   800b8b <cprintf>
  80276a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80276d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802771:	a1 38 51 80 00       	mov    0x805138,%eax
  802776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802779:	eb 56                	jmp    8027d1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80277b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277f:	74 1c                	je     80279d <print_mem_block_lists+0x5d>
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	8b 50 08             	mov    0x8(%eax),%edx
  802787:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278a:	8b 48 08             	mov    0x8(%eax),%ecx
  80278d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802790:	8b 40 0c             	mov    0xc(%eax),%eax
  802793:	01 c8                	add    %ecx,%eax
  802795:	39 c2                	cmp    %eax,%edx
  802797:	73 04                	jae    80279d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802799:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 50 08             	mov    0x8(%eax),%edx
  8027a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a9:	01 c2                	add    %eax,%edx
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 40 08             	mov    0x8(%eax),%eax
  8027b1:	83 ec 04             	sub    $0x4,%esp
  8027b4:	52                   	push   %edx
  8027b5:	50                   	push   %eax
  8027b6:	68 95 43 80 00       	push   $0x804395
  8027bb:	e8 cb e3 ff ff       	call   800b8b <cprintf>
  8027c0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8027c9:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d5:	74 07                	je     8027de <print_mem_block_lists+0x9e>
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	eb 05                	jmp    8027e3 <print_mem_block_lists+0xa3>
  8027de:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e3:	a3 40 51 80 00       	mov    %eax,0x805140
  8027e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	75 8a                	jne    80277b <print_mem_block_lists+0x3b>
  8027f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f5:	75 84                	jne    80277b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8027f7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027fb:	75 10                	jne    80280d <print_mem_block_lists+0xcd>
  8027fd:	83 ec 0c             	sub    $0xc,%esp
  802800:	68 a4 43 80 00       	push   $0x8043a4
  802805:	e8 81 e3 ff ff       	call   800b8b <cprintf>
  80280a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80280d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802814:	83 ec 0c             	sub    $0xc,%esp
  802817:	68 c8 43 80 00       	push   $0x8043c8
  80281c:	e8 6a e3 ff ff       	call   800b8b <cprintf>
  802821:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802824:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802828:	a1 40 50 80 00       	mov    0x805040,%eax
  80282d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802830:	eb 56                	jmp    802888 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802832:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802836:	74 1c                	je     802854 <print_mem_block_lists+0x114>
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 50 08             	mov    0x8(%eax),%edx
  80283e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802841:	8b 48 08             	mov    0x8(%eax),%ecx
  802844:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802847:	8b 40 0c             	mov    0xc(%eax),%eax
  80284a:	01 c8                	add    %ecx,%eax
  80284c:	39 c2                	cmp    %eax,%edx
  80284e:	73 04                	jae    802854 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802850:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 50 08             	mov    0x8(%eax),%edx
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	8b 40 0c             	mov    0xc(%eax),%eax
  802860:	01 c2                	add    %eax,%edx
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 40 08             	mov    0x8(%eax),%eax
  802868:	83 ec 04             	sub    $0x4,%esp
  80286b:	52                   	push   %edx
  80286c:	50                   	push   %eax
  80286d:	68 95 43 80 00       	push   $0x804395
  802872:	e8 14 e3 ff ff       	call   800b8b <cprintf>
  802877:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802880:	a1 48 50 80 00       	mov    0x805048,%eax
  802885:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802888:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80288c:	74 07                	je     802895 <print_mem_block_lists+0x155>
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	eb 05                	jmp    80289a <print_mem_block_lists+0x15a>
  802895:	b8 00 00 00 00       	mov    $0x0,%eax
  80289a:	a3 48 50 80 00       	mov    %eax,0x805048
  80289f:	a1 48 50 80 00       	mov    0x805048,%eax
  8028a4:	85 c0                	test   %eax,%eax
  8028a6:	75 8a                	jne    802832 <print_mem_block_lists+0xf2>
  8028a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ac:	75 84                	jne    802832 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8028ae:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028b2:	75 10                	jne    8028c4 <print_mem_block_lists+0x184>
  8028b4:	83 ec 0c             	sub    $0xc,%esp
  8028b7:	68 e0 43 80 00       	push   $0x8043e0
  8028bc:	e8 ca e2 ff ff       	call   800b8b <cprintf>
  8028c1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8028c4:	83 ec 0c             	sub    $0xc,%esp
  8028c7:	68 54 43 80 00       	push   $0x804354
  8028cc:	e8 ba e2 ff ff       	call   800b8b <cprintf>
  8028d1:	83 c4 10             	add    $0x10,%esp

}
  8028d4:	90                   	nop
  8028d5:	c9                   	leave  
  8028d6:	c3                   	ret    

008028d7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8028d7:	55                   	push   %ebp
  8028d8:	89 e5                	mov    %esp,%ebp
  8028da:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8028dd:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8028e4:	00 00 00 
  8028e7:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8028ee:	00 00 00 
  8028f1:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8028f8:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8028fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802902:	e9 9e 00 00 00       	jmp    8029a5 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802907:	a1 50 50 80 00       	mov    0x805050,%eax
  80290c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290f:	c1 e2 04             	shl    $0x4,%edx
  802912:	01 d0                	add    %edx,%eax
  802914:	85 c0                	test   %eax,%eax
  802916:	75 14                	jne    80292c <initialize_MemBlocksList+0x55>
  802918:	83 ec 04             	sub    $0x4,%esp
  80291b:	68 08 44 80 00       	push   $0x804408
  802920:	6a 3d                	push   $0x3d
  802922:	68 2b 44 80 00       	push   $0x80442b
  802927:	e8 ab df ff ff       	call   8008d7 <_panic>
  80292c:	a1 50 50 80 00       	mov    0x805050,%eax
  802931:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802934:	c1 e2 04             	shl    $0x4,%edx
  802937:	01 d0                	add    %edx,%eax
  802939:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80293f:	89 10                	mov    %edx,(%eax)
  802941:	8b 00                	mov    (%eax),%eax
  802943:	85 c0                	test   %eax,%eax
  802945:	74 18                	je     80295f <initialize_MemBlocksList+0x88>
  802947:	a1 48 51 80 00       	mov    0x805148,%eax
  80294c:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802952:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802955:	c1 e1 04             	shl    $0x4,%ecx
  802958:	01 ca                	add    %ecx,%edx
  80295a:	89 50 04             	mov    %edx,0x4(%eax)
  80295d:	eb 12                	jmp    802971 <initialize_MemBlocksList+0x9a>
  80295f:	a1 50 50 80 00       	mov    0x805050,%eax
  802964:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802967:	c1 e2 04             	shl    $0x4,%edx
  80296a:	01 d0                	add    %edx,%eax
  80296c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802971:	a1 50 50 80 00       	mov    0x805050,%eax
  802976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802979:	c1 e2 04             	shl    $0x4,%edx
  80297c:	01 d0                	add    %edx,%eax
  80297e:	a3 48 51 80 00       	mov    %eax,0x805148
  802983:	a1 50 50 80 00       	mov    0x805050,%eax
  802988:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80298b:	c1 e2 04             	shl    $0x4,%edx
  80298e:	01 d0                	add    %edx,%eax
  802990:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802997:	a1 54 51 80 00       	mov    0x805154,%eax
  80299c:	40                   	inc    %eax
  80299d:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8029a2:	ff 45 f4             	incl   -0xc(%ebp)
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ab:	0f 82 56 ff ff ff    	jb     802907 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8029b1:	90                   	nop
  8029b2:	c9                   	leave  
  8029b3:	c3                   	ret    

008029b4 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8029b4:	55                   	push   %ebp
  8029b5:	89 e5                	mov    %esp,%ebp
  8029b7:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8029ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8029c2:	eb 18                	jmp    8029dc <find_block+0x28>

		if(tmp->sva == va){
  8029c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029c7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8029cd:	75 05                	jne    8029d4 <find_block+0x20>
			return tmp ;
  8029cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029d2:	eb 11                	jmp    8029e5 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8029d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8029d7:	8b 00                	mov    (%eax),%eax
  8029d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8029dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029e0:	75 e2                	jne    8029c4 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8029e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8029e5:	c9                   	leave  
  8029e6:	c3                   	ret    

008029e7 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8029e7:	55                   	push   %ebp
  8029e8:	89 e5                	mov    %esp,%ebp
  8029ea:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8029ed:	a1 40 50 80 00       	mov    0x805040,%eax
  8029f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8029f5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8029fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a01:	75 65                	jne    802a68 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802a03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a07:	75 14                	jne    802a1d <insert_sorted_allocList+0x36>
  802a09:	83 ec 04             	sub    $0x4,%esp
  802a0c:	68 08 44 80 00       	push   $0x804408
  802a11:	6a 62                	push   $0x62
  802a13:	68 2b 44 80 00       	push   $0x80442b
  802a18:	e8 ba de ff ff       	call   8008d7 <_panic>
  802a1d:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	89 10                	mov    %edx,(%eax)
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	74 0d                	je     802a3e <insert_sorted_allocList+0x57>
  802a31:	a1 40 50 80 00       	mov    0x805040,%eax
  802a36:	8b 55 08             	mov    0x8(%ebp),%edx
  802a39:	89 50 04             	mov    %edx,0x4(%eax)
  802a3c:	eb 08                	jmp    802a46 <insert_sorted_allocList+0x5f>
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	a3 44 50 80 00       	mov    %eax,0x805044
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	a3 40 50 80 00       	mov    %eax,0x805040
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a58:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a5d:	40                   	inc    %eax
  802a5e:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802a63:	e9 14 01 00 00       	jmp    802b7c <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	8b 50 08             	mov    0x8(%eax),%edx
  802a6e:	a1 44 50 80 00       	mov    0x805044,%eax
  802a73:	8b 40 08             	mov    0x8(%eax),%eax
  802a76:	39 c2                	cmp    %eax,%edx
  802a78:	76 65                	jbe    802adf <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802a7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a7e:	75 14                	jne    802a94 <insert_sorted_allocList+0xad>
  802a80:	83 ec 04             	sub    $0x4,%esp
  802a83:	68 44 44 80 00       	push   $0x804444
  802a88:	6a 64                	push   $0x64
  802a8a:	68 2b 44 80 00       	push   $0x80442b
  802a8f:	e8 43 de ff ff       	call   8008d7 <_panic>
  802a94:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	89 50 04             	mov    %edx,0x4(%eax)
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	8b 40 04             	mov    0x4(%eax),%eax
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	74 0c                	je     802ab6 <insert_sorted_allocList+0xcf>
  802aaa:	a1 44 50 80 00       	mov    0x805044,%eax
  802aaf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab2:	89 10                	mov    %edx,(%eax)
  802ab4:	eb 08                	jmp    802abe <insert_sorted_allocList+0xd7>
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	a3 40 50 80 00       	mov    %eax,0x805040
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	a3 44 50 80 00       	mov    %eax,0x805044
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802acf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ad4:	40                   	inc    %eax
  802ad5:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802ada:	e9 9d 00 00 00       	jmp    802b7c <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802adf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802ae6:	e9 85 00 00 00       	jmp    802b70 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	8b 50 08             	mov    0x8(%eax),%edx
  802af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af4:	8b 40 08             	mov    0x8(%eax),%eax
  802af7:	39 c2                	cmp    %eax,%edx
  802af9:	73 6a                	jae    802b65 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802afb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aff:	74 06                	je     802b07 <insert_sorted_allocList+0x120>
  802b01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b05:	75 14                	jne    802b1b <insert_sorted_allocList+0x134>
  802b07:	83 ec 04             	sub    $0x4,%esp
  802b0a:	68 68 44 80 00       	push   $0x804468
  802b0f:	6a 6b                	push   $0x6b
  802b11:	68 2b 44 80 00       	push   $0x80442b
  802b16:	e8 bc dd ff ff       	call   8008d7 <_panic>
  802b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1e:	8b 50 04             	mov    0x4(%eax),%edx
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	89 50 04             	mov    %edx,0x4(%eax)
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b2d:	89 10                	mov    %edx,(%eax)
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	8b 40 04             	mov    0x4(%eax),%eax
  802b35:	85 c0                	test   %eax,%eax
  802b37:	74 0d                	je     802b46 <insert_sorted_allocList+0x15f>
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	8b 40 04             	mov    0x4(%eax),%eax
  802b3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b42:	89 10                	mov    %edx,(%eax)
  802b44:	eb 08                	jmp    802b4e <insert_sorted_allocList+0x167>
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	a3 40 50 80 00       	mov    %eax,0x805040
  802b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b51:	8b 55 08             	mov    0x8(%ebp),%edx
  802b54:	89 50 04             	mov    %edx,0x4(%eax)
  802b57:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b5c:	40                   	inc    %eax
  802b5d:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802b62:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802b63:	eb 17                	jmp    802b7c <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802b6d:	ff 45 f0             	incl   -0x10(%ebp)
  802b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b73:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b76:	0f 8c 6f ff ff ff    	jl     802aeb <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802b7c:	90                   	nop
  802b7d:	c9                   	leave  
  802b7e:	c3                   	ret    

00802b7f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b7f:	55                   	push   %ebp
  802b80:	89 e5                	mov    %esp,%ebp
  802b82:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802b85:	a1 38 51 80 00       	mov    0x805138,%eax
  802b8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802b8d:	e9 7c 01 00 00       	jmp    802d0e <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 40 0c             	mov    0xc(%eax),%eax
  802b98:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b9b:	0f 86 cf 00 00 00    	jbe    802c70 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802ba1:	a1 48 51 80 00       	mov    0x805148,%eax
  802ba6:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bac:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802baf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb5:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 50 08             	mov    0x8(%eax),%edx
  802bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc1:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bca:	2b 45 08             	sub    0x8(%ebp),%eax
  802bcd:	89 c2                	mov    %eax,%edx
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 50 08             	mov    0x8(%eax),%edx
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	01 c2                	add    %eax,%edx
  802be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be3:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802be6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bea:	75 17                	jne    802c03 <alloc_block_FF+0x84>
  802bec:	83 ec 04             	sub    $0x4,%esp
  802bef:	68 9d 44 80 00       	push   $0x80449d
  802bf4:	68 83 00 00 00       	push   $0x83
  802bf9:	68 2b 44 80 00       	push   $0x80442b
  802bfe:	e8 d4 dc ff ff       	call   8008d7 <_panic>
  802c03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c06:	8b 00                	mov    (%eax),%eax
  802c08:	85 c0                	test   %eax,%eax
  802c0a:	74 10                	je     802c1c <alloc_block_FF+0x9d>
  802c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0f:	8b 00                	mov    (%eax),%eax
  802c11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c14:	8b 52 04             	mov    0x4(%edx),%edx
  802c17:	89 50 04             	mov    %edx,0x4(%eax)
  802c1a:	eb 0b                	jmp    802c27 <alloc_block_FF+0xa8>
  802c1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2a:	8b 40 04             	mov    0x4(%eax),%eax
  802c2d:	85 c0                	test   %eax,%eax
  802c2f:	74 0f                	je     802c40 <alloc_block_FF+0xc1>
  802c31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c34:	8b 40 04             	mov    0x4(%eax),%eax
  802c37:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c3a:	8b 12                	mov    (%edx),%edx
  802c3c:	89 10                	mov    %edx,(%eax)
  802c3e:	eb 0a                	jmp    802c4a <alloc_block_FF+0xcb>
  802c40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c43:	8b 00                	mov    (%eax),%eax
  802c45:	a3 48 51 80 00       	mov    %eax,0x805148
  802c4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5d:	a1 54 51 80 00       	mov    0x805154,%eax
  802c62:	48                   	dec    %eax
  802c63:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6b:	e9 ad 00 00 00       	jmp    802d1d <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c73:	8b 40 0c             	mov    0xc(%eax),%eax
  802c76:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c79:	0f 85 87 00 00 00    	jne    802d06 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802c7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c83:	75 17                	jne    802c9c <alloc_block_FF+0x11d>
  802c85:	83 ec 04             	sub    $0x4,%esp
  802c88:	68 9d 44 80 00       	push   $0x80449d
  802c8d:	68 87 00 00 00       	push   $0x87
  802c92:	68 2b 44 80 00       	push   $0x80442b
  802c97:	e8 3b dc ff ff       	call   8008d7 <_panic>
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	85 c0                	test   %eax,%eax
  802ca3:	74 10                	je     802cb5 <alloc_block_FF+0x136>
  802ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca8:	8b 00                	mov    (%eax),%eax
  802caa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cad:	8b 52 04             	mov    0x4(%edx),%edx
  802cb0:	89 50 04             	mov    %edx,0x4(%eax)
  802cb3:	eb 0b                	jmp    802cc0 <alloc_block_FF+0x141>
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 40 04             	mov    0x4(%eax),%eax
  802cbb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 40 04             	mov    0x4(%eax),%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	74 0f                	je     802cd9 <alloc_block_FF+0x15a>
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 04             	mov    0x4(%eax),%eax
  802cd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd3:	8b 12                	mov    (%edx),%edx
  802cd5:	89 10                	mov    %edx,(%eax)
  802cd7:	eb 0a                	jmp    802ce3 <alloc_block_FF+0x164>
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 00                	mov    (%eax),%eax
  802cde:	a3 38 51 80 00       	mov    %eax,0x805138
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf6:	a1 44 51 80 00       	mov    0x805144,%eax
  802cfb:	48                   	dec    %eax
  802cfc:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	eb 17                	jmp    802d1d <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 00                	mov    (%eax),%eax
  802d0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802d0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d12:	0f 85 7a fe ff ff    	jne    802b92 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802d18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d1d:	c9                   	leave  
  802d1e:	c3                   	ret    

00802d1f <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802d1f:	55                   	push   %ebp
  802d20:	89 e5                	mov    %esp,%ebp
  802d22:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802d25:	a1 38 51 80 00       	mov    0x805138,%eax
  802d2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802d2d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802d34:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802d3b:	a1 38 51 80 00       	mov    0x805138,%eax
  802d40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d43:	e9 d0 00 00 00       	jmp    802e18 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d51:	0f 82 b8 00 00 00    	jb     802e0f <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5d:	2b 45 08             	sub    0x8(%ebp),%eax
  802d60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802d63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d66:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d69:	0f 83 a1 00 00 00    	jae    802e10 <alloc_block_BF+0xf1>
				differsize = differance ;
  802d6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d72:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802d7b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d7f:	0f 85 8b 00 00 00    	jne    802e10 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802d85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d89:	75 17                	jne    802da2 <alloc_block_BF+0x83>
  802d8b:	83 ec 04             	sub    $0x4,%esp
  802d8e:	68 9d 44 80 00       	push   $0x80449d
  802d93:	68 a0 00 00 00       	push   $0xa0
  802d98:	68 2b 44 80 00       	push   $0x80442b
  802d9d:	e8 35 db ff ff       	call   8008d7 <_panic>
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 10                	je     802dbb <alloc_block_BF+0x9c>
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 00                	mov    (%eax),%eax
  802db0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db3:	8b 52 04             	mov    0x4(%edx),%edx
  802db6:	89 50 04             	mov    %edx,0x4(%eax)
  802db9:	eb 0b                	jmp    802dc6 <alloc_block_BF+0xa7>
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 40 04             	mov    0x4(%eax),%eax
  802dc1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 40 04             	mov    0x4(%eax),%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	74 0f                	je     802ddf <alloc_block_BF+0xc0>
  802dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd3:	8b 40 04             	mov    0x4(%eax),%eax
  802dd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd9:	8b 12                	mov    (%edx),%edx
  802ddb:	89 10                	mov    %edx,(%eax)
  802ddd:	eb 0a                	jmp    802de9 <alloc_block_BF+0xca>
  802ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de2:	8b 00                	mov    (%eax),%eax
  802de4:	a3 38 51 80 00       	mov    %eax,0x805138
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfc:	a1 44 51 80 00       	mov    0x805144,%eax
  802e01:	48                   	dec    %eax
  802e02:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0a:	e9 0c 01 00 00       	jmp    802f1b <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802e0f:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802e10:	a1 40 51 80 00       	mov    0x805140,%eax
  802e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e1c:	74 07                	je     802e25 <alloc_block_BF+0x106>
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	eb 05                	jmp    802e2a <alloc_block_BF+0x10b>
  802e25:	b8 00 00 00 00       	mov    $0x0,%eax
  802e2a:	a3 40 51 80 00       	mov    %eax,0x805140
  802e2f:	a1 40 51 80 00       	mov    0x805140,%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	0f 85 0c ff ff ff    	jne    802d48 <alloc_block_BF+0x29>
  802e3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e40:	0f 85 02 ff ff ff    	jne    802d48 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802e46:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e4a:	0f 84 c6 00 00 00    	je     802f16 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802e50:	a1 48 51 80 00       	mov    0x805148,%eax
  802e55:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802e58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e5e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802e61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e64:	8b 50 08             	mov    0x8(%eax),%edx
  802e67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e6a:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e70:	8b 40 0c             	mov    0xc(%eax),%eax
  802e73:	2b 45 08             	sub    0x8(%ebp),%eax
  802e76:	89 c2                	mov    %eax,%edx
  802e78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e7b:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802e7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e81:	8b 50 08             	mov    0x8(%eax),%edx
  802e84:	8b 45 08             	mov    0x8(%ebp),%eax
  802e87:	01 c2                	add    %eax,%edx
  802e89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e8c:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802e8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e93:	75 17                	jne    802eac <alloc_block_BF+0x18d>
  802e95:	83 ec 04             	sub    $0x4,%esp
  802e98:	68 9d 44 80 00       	push   $0x80449d
  802e9d:	68 af 00 00 00       	push   $0xaf
  802ea2:	68 2b 44 80 00       	push   $0x80442b
  802ea7:	e8 2b da ff ff       	call   8008d7 <_panic>
  802eac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	74 10                	je     802ec5 <alloc_block_BF+0x1a6>
  802eb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb8:	8b 00                	mov    (%eax),%eax
  802eba:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ebd:	8b 52 04             	mov    0x4(%edx),%edx
  802ec0:	89 50 04             	mov    %edx,0x4(%eax)
  802ec3:	eb 0b                	jmp    802ed0 <alloc_block_BF+0x1b1>
  802ec5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec8:	8b 40 04             	mov    0x4(%eax),%eax
  802ecb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ed0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed3:	8b 40 04             	mov    0x4(%eax),%eax
  802ed6:	85 c0                	test   %eax,%eax
  802ed8:	74 0f                	je     802ee9 <alloc_block_BF+0x1ca>
  802eda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802edd:	8b 40 04             	mov    0x4(%eax),%eax
  802ee0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ee3:	8b 12                	mov    (%edx),%edx
  802ee5:	89 10                	mov    %edx,(%eax)
  802ee7:	eb 0a                	jmp    802ef3 <alloc_block_BF+0x1d4>
  802ee9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	a3 48 51 80 00       	mov    %eax,0x805148
  802ef3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802efc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f06:	a1 54 51 80 00       	mov    0x805154,%eax
  802f0b:	48                   	dec    %eax
  802f0c:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802f11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f14:	eb 05                	jmp    802f1b <alloc_block_BF+0x1fc>
	}

	return NULL;
  802f16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f1b:	c9                   	leave  
  802f1c:	c3                   	ret    

00802f1d <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802f1d:	55                   	push   %ebp
  802f1e:	89 e5                	mov    %esp,%ebp
  802f20:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802f23:	a1 38 51 80 00       	mov    0x805138,%eax
  802f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802f2b:	e9 7c 01 00 00       	jmp    8030ac <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f33:	8b 40 0c             	mov    0xc(%eax),%eax
  802f36:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f39:	0f 86 cf 00 00 00    	jbe    80300e <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802f3f:	a1 48 51 80 00       	mov    0x805148,%eax
  802f44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802f4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f50:	8b 55 08             	mov    0x8(%ebp),%edx
  802f53:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 50 08             	mov    0x8(%eax),%edx
  802f5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f5f:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f65:	8b 40 0c             	mov    0xc(%eax),%eax
  802f68:	2b 45 08             	sub    0x8(%ebp),%eax
  802f6b:	89 c2                	mov    %eax,%edx
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 50 08             	mov    0x8(%eax),%edx
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	01 c2                	add    %eax,%edx
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802f84:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f88:	75 17                	jne    802fa1 <alloc_block_NF+0x84>
  802f8a:	83 ec 04             	sub    $0x4,%esp
  802f8d:	68 9d 44 80 00       	push   $0x80449d
  802f92:	68 c4 00 00 00       	push   $0xc4
  802f97:	68 2b 44 80 00       	push   $0x80442b
  802f9c:	e8 36 d9 ff ff       	call   8008d7 <_panic>
  802fa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa4:	8b 00                	mov    (%eax),%eax
  802fa6:	85 c0                	test   %eax,%eax
  802fa8:	74 10                	je     802fba <alloc_block_NF+0x9d>
  802faa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fad:	8b 00                	mov    (%eax),%eax
  802faf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fb2:	8b 52 04             	mov    0x4(%edx),%edx
  802fb5:	89 50 04             	mov    %edx,0x4(%eax)
  802fb8:	eb 0b                	jmp    802fc5 <alloc_block_NF+0xa8>
  802fba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fbd:	8b 40 04             	mov    0x4(%eax),%eax
  802fc0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fc8:	8b 40 04             	mov    0x4(%eax),%eax
  802fcb:	85 c0                	test   %eax,%eax
  802fcd:	74 0f                	je     802fde <alloc_block_NF+0xc1>
  802fcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fd2:	8b 40 04             	mov    0x4(%eax),%eax
  802fd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802fd8:	8b 12                	mov    (%edx),%edx
  802fda:	89 10                	mov    %edx,(%eax)
  802fdc:	eb 0a                	jmp    802fe8 <alloc_block_NF+0xcb>
  802fde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fe1:	8b 00                	mov    (%eax),%eax
  802fe3:	a3 48 51 80 00       	mov    %eax,0x805148
  802fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802feb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffb:	a1 54 51 80 00       	mov    0x805154,%eax
  803000:	48                   	dec    %eax
  803001:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  803006:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803009:	e9 ad 00 00 00       	jmp    8030bb <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  80300e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803011:	8b 40 0c             	mov    0xc(%eax),%eax
  803014:	3b 45 08             	cmp    0x8(%ebp),%eax
  803017:	0f 85 87 00 00 00    	jne    8030a4 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  80301d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803021:	75 17                	jne    80303a <alloc_block_NF+0x11d>
  803023:	83 ec 04             	sub    $0x4,%esp
  803026:	68 9d 44 80 00       	push   $0x80449d
  80302b:	68 c8 00 00 00       	push   $0xc8
  803030:	68 2b 44 80 00       	push   $0x80442b
  803035:	e8 9d d8 ff ff       	call   8008d7 <_panic>
  80303a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	85 c0                	test   %eax,%eax
  803041:	74 10                	je     803053 <alloc_block_NF+0x136>
  803043:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80304b:	8b 52 04             	mov    0x4(%edx),%edx
  80304e:	89 50 04             	mov    %edx,0x4(%eax)
  803051:	eb 0b                	jmp    80305e <alloc_block_NF+0x141>
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	8b 40 04             	mov    0x4(%eax),%eax
  803059:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80305e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803061:	8b 40 04             	mov    0x4(%eax),%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	74 0f                	je     803077 <alloc_block_NF+0x15a>
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	8b 40 04             	mov    0x4(%eax),%eax
  80306e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803071:	8b 12                	mov    (%edx),%edx
  803073:	89 10                	mov    %edx,(%eax)
  803075:	eb 0a                	jmp    803081 <alloc_block_NF+0x164>
  803077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	a3 38 51 80 00       	mov    %eax,0x805138
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803094:	a1 44 51 80 00       	mov    0x805144,%eax
  803099:	48                   	dec    %eax
  80309a:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  80309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a2:	eb 17                	jmp    8030bb <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8030a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a7:	8b 00                	mov    (%eax),%eax
  8030a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8030ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b0:	0f 85 7a fe ff ff    	jne    802f30 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8030b6:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8030bb:	c9                   	leave  
  8030bc:	c3                   	ret    

008030bd <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8030bd:	55                   	push   %ebp
  8030be:	89 e5                	mov    %esp,%ebp
  8030c0:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8030c3:	a1 38 51 80 00       	mov    0x805138,%eax
  8030c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8030cb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8030d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8030d3:	a1 44 51 80 00       	mov    0x805144,%eax
  8030d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8030db:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030df:	75 68                	jne    803149 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8030e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e5:	75 17                	jne    8030fe <insert_sorted_with_merge_freeList+0x41>
  8030e7:	83 ec 04             	sub    $0x4,%esp
  8030ea:	68 08 44 80 00       	push   $0x804408
  8030ef:	68 da 00 00 00       	push   $0xda
  8030f4:	68 2b 44 80 00       	push   $0x80442b
  8030f9:	e8 d9 d7 ff ff       	call   8008d7 <_panic>
  8030fe:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	89 10                	mov    %edx,(%eax)
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	85 c0                	test   %eax,%eax
  803110:	74 0d                	je     80311f <insert_sorted_with_merge_freeList+0x62>
  803112:	a1 38 51 80 00       	mov    0x805138,%eax
  803117:	8b 55 08             	mov    0x8(%ebp),%edx
  80311a:	89 50 04             	mov    %edx,0x4(%eax)
  80311d:	eb 08                	jmp    803127 <insert_sorted_with_merge_freeList+0x6a>
  80311f:	8b 45 08             	mov    0x8(%ebp),%eax
  803122:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	a3 38 51 80 00       	mov    %eax,0x805138
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803139:	a1 44 51 80 00       	mov    0x805144,%eax
  80313e:	40                   	inc    %eax
  80313f:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  803144:	e9 49 07 00 00       	jmp    803892 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80314c:	8b 50 08             	mov    0x8(%eax),%edx
  80314f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803152:	8b 40 0c             	mov    0xc(%eax),%eax
  803155:	01 c2                	add    %eax,%edx
  803157:	8b 45 08             	mov    0x8(%ebp),%eax
  80315a:	8b 40 08             	mov    0x8(%eax),%eax
  80315d:	39 c2                	cmp    %eax,%edx
  80315f:	73 77                	jae    8031d8 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  803161:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803164:	8b 00                	mov    (%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	75 6e                	jne    8031d8 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  80316a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80316e:	74 68                	je     8031d8 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  803170:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803174:	75 17                	jne    80318d <insert_sorted_with_merge_freeList+0xd0>
  803176:	83 ec 04             	sub    $0x4,%esp
  803179:	68 44 44 80 00       	push   $0x804444
  80317e:	68 e0 00 00 00       	push   $0xe0
  803183:	68 2b 44 80 00       	push   $0x80442b
  803188:	e8 4a d7 ff ff       	call   8008d7 <_panic>
  80318d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803193:	8b 45 08             	mov    0x8(%ebp),%eax
  803196:	89 50 04             	mov    %edx,0x4(%eax)
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	8b 40 04             	mov    0x4(%eax),%eax
  80319f:	85 c0                	test   %eax,%eax
  8031a1:	74 0c                	je     8031af <insert_sorted_with_merge_freeList+0xf2>
  8031a3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ab:	89 10                	mov    %edx,(%eax)
  8031ad:	eb 08                	jmp    8031b7 <insert_sorted_with_merge_freeList+0xfa>
  8031af:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b2:	a3 38 51 80 00       	mov    %eax,0x805138
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8031cd:	40                   	inc    %eax
  8031ce:	a3 44 51 80 00       	mov    %eax,0x805144
  8031d3:	e9 ba 06 00 00       	jmp    803892 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8031d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031db:	8b 50 0c             	mov    0xc(%eax),%edx
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	8b 40 08             	mov    0x8(%eax),%eax
  8031e4:	01 c2                	add    %eax,%edx
  8031e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e9:	8b 40 08             	mov    0x8(%eax),%eax
  8031ec:	39 c2                	cmp    %eax,%edx
  8031ee:	73 78                	jae    803268 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8031f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f3:	8b 40 04             	mov    0x4(%eax),%eax
  8031f6:	85 c0                	test   %eax,%eax
  8031f8:	75 6e                	jne    803268 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8031fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031fe:	74 68                	je     803268 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  803200:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803204:	75 17                	jne    80321d <insert_sorted_with_merge_freeList+0x160>
  803206:	83 ec 04             	sub    $0x4,%esp
  803209:	68 08 44 80 00       	push   $0x804408
  80320e:	68 e6 00 00 00       	push   $0xe6
  803213:	68 2b 44 80 00       	push   $0x80442b
  803218:	e8 ba d6 ff ff       	call   8008d7 <_panic>
  80321d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	89 10                	mov    %edx,(%eax)
  803228:	8b 45 08             	mov    0x8(%ebp),%eax
  80322b:	8b 00                	mov    (%eax),%eax
  80322d:	85 c0                	test   %eax,%eax
  80322f:	74 0d                	je     80323e <insert_sorted_with_merge_freeList+0x181>
  803231:	a1 38 51 80 00       	mov    0x805138,%eax
  803236:	8b 55 08             	mov    0x8(%ebp),%edx
  803239:	89 50 04             	mov    %edx,0x4(%eax)
  80323c:	eb 08                	jmp    803246 <insert_sorted_with_merge_freeList+0x189>
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803246:	8b 45 08             	mov    0x8(%ebp),%eax
  803249:	a3 38 51 80 00       	mov    %eax,0x805138
  80324e:	8b 45 08             	mov    0x8(%ebp),%eax
  803251:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803258:	a1 44 51 80 00       	mov    0x805144,%eax
  80325d:	40                   	inc    %eax
  80325e:	a3 44 51 80 00       	mov    %eax,0x805144
  803263:	e9 2a 06 00 00       	jmp    803892 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803268:	a1 38 51 80 00       	mov    0x805138,%eax
  80326d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803270:	e9 ed 05 00 00       	jmp    803862 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  803275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803278:	8b 00                	mov    (%eax),%eax
  80327a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  80327d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803281:	0f 84 a7 00 00 00    	je     80332e <insert_sorted_with_merge_freeList+0x271>
  803287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328a:	8b 50 0c             	mov    0xc(%eax),%edx
  80328d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803290:	8b 40 08             	mov    0x8(%eax),%eax
  803293:	01 c2                	add    %eax,%edx
  803295:	8b 45 08             	mov    0x8(%ebp),%eax
  803298:	8b 40 08             	mov    0x8(%eax),%eax
  80329b:	39 c2                	cmp    %eax,%edx
  80329d:	0f 83 8b 00 00 00    	jae    80332e <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 40 08             	mov    0x8(%eax),%eax
  8032af:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  8032b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b4:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  8032b7:	39 c2                	cmp    %eax,%edx
  8032b9:	73 73                	jae    80332e <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  8032bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bf:	74 06                	je     8032c7 <insert_sorted_with_merge_freeList+0x20a>
  8032c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032c5:	75 17                	jne    8032de <insert_sorted_with_merge_freeList+0x221>
  8032c7:	83 ec 04             	sub    $0x4,%esp
  8032ca:	68 bc 44 80 00       	push   $0x8044bc
  8032cf:	68 f0 00 00 00       	push   $0xf0
  8032d4:	68 2b 44 80 00       	push   $0x80442b
  8032d9:	e8 f9 d5 ff ff       	call   8008d7 <_panic>
  8032de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e1:	8b 10                	mov    (%eax),%edx
  8032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e6:	89 10                	mov    %edx,(%eax)
  8032e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032eb:	8b 00                	mov    (%eax),%eax
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	74 0b                	je     8032fc <insert_sorted_with_merge_freeList+0x23f>
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	8b 00                	mov    (%eax),%eax
  8032f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032f9:	89 50 04             	mov    %edx,0x4(%eax)
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 55 08             	mov    0x8(%ebp),%edx
  803302:	89 10                	mov    %edx,(%eax)
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80330a:	89 50 04             	mov    %edx,0x4(%eax)
  80330d:	8b 45 08             	mov    0x8(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	85 c0                	test   %eax,%eax
  803314:	75 08                	jne    80331e <insert_sorted_with_merge_freeList+0x261>
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80331e:	a1 44 51 80 00       	mov    0x805144,%eax
  803323:	40                   	inc    %eax
  803324:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  803329:	e9 64 05 00 00       	jmp    803892 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  80332e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803333:	8b 50 0c             	mov    0xc(%eax),%edx
  803336:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80333b:	8b 40 08             	mov    0x8(%eax),%eax
  80333e:	01 c2                	add    %eax,%edx
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	8b 40 08             	mov    0x8(%eax),%eax
  803346:	39 c2                	cmp    %eax,%edx
  803348:	0f 85 b1 00 00 00    	jne    8033ff <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  80334e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803353:	85 c0                	test   %eax,%eax
  803355:	0f 84 a4 00 00 00    	je     8033ff <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  80335b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803360:	8b 00                	mov    (%eax),%eax
  803362:	85 c0                	test   %eax,%eax
  803364:	0f 85 95 00 00 00    	jne    8033ff <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  80336a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80336f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803375:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803378:	8b 55 08             	mov    0x8(%ebp),%edx
  80337b:	8b 52 0c             	mov    0xc(%edx),%edx
  80337e:	01 ca                	add    %ecx,%edx
  803380:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803383:	8b 45 08             	mov    0x8(%ebp),%eax
  803386:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  80338d:	8b 45 08             	mov    0x8(%ebp),%eax
  803390:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803397:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80339b:	75 17                	jne    8033b4 <insert_sorted_with_merge_freeList+0x2f7>
  80339d:	83 ec 04             	sub    $0x4,%esp
  8033a0:	68 08 44 80 00       	push   $0x804408
  8033a5:	68 ff 00 00 00       	push   $0xff
  8033aa:	68 2b 44 80 00       	push   $0x80442b
  8033af:	e8 23 d5 ff ff       	call   8008d7 <_panic>
  8033b4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	89 10                	mov    %edx,(%eax)
  8033bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c2:	8b 00                	mov    (%eax),%eax
  8033c4:	85 c0                	test   %eax,%eax
  8033c6:	74 0d                	je     8033d5 <insert_sorted_with_merge_freeList+0x318>
  8033c8:	a1 48 51 80 00       	mov    0x805148,%eax
  8033cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8033d0:	89 50 04             	mov    %edx,0x4(%eax)
  8033d3:	eb 08                	jmp    8033dd <insert_sorted_with_merge_freeList+0x320>
  8033d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e0:	a3 48 51 80 00       	mov    %eax,0x805148
  8033e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8033f4:	40                   	inc    %eax
  8033f5:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8033fa:	e9 93 04 00 00       	jmp    803892 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8033ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803402:	8b 50 08             	mov    0x8(%eax),%edx
  803405:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803408:	8b 40 0c             	mov    0xc(%eax),%eax
  80340b:	01 c2                	add    %eax,%edx
  80340d:	8b 45 08             	mov    0x8(%ebp),%eax
  803410:	8b 40 08             	mov    0x8(%eax),%eax
  803413:	39 c2                	cmp    %eax,%edx
  803415:	0f 85 ae 00 00 00    	jne    8034c9 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  80341b:	8b 45 08             	mov    0x8(%ebp),%eax
  80341e:	8b 50 0c             	mov    0xc(%eax),%edx
  803421:	8b 45 08             	mov    0x8(%ebp),%eax
  803424:	8b 40 08             	mov    0x8(%eax),%eax
  803427:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342c:	8b 00                	mov    (%eax),%eax
  80342e:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803431:	39 c2                	cmp    %eax,%edx
  803433:	0f 84 90 00 00 00    	je     8034c9 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
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
  803465:	75 17                	jne    80347e <insert_sorted_with_merge_freeList+0x3c1>
  803467:	83 ec 04             	sub    $0x4,%esp
  80346a:	68 08 44 80 00       	push   $0x804408
  80346f:	68 0b 01 00 00       	push   $0x10b
  803474:	68 2b 44 80 00       	push   $0x80442b
  803479:	e8 59 d4 ff ff       	call   8008d7 <_panic>
  80347e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	89 10                	mov    %edx,(%eax)
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	85 c0                	test   %eax,%eax
  803490:	74 0d                	je     80349f <insert_sorted_with_merge_freeList+0x3e2>
  803492:	a1 48 51 80 00       	mov    0x805148,%eax
  803497:	8b 55 08             	mov    0x8(%ebp),%edx
  80349a:	89 50 04             	mov    %edx,0x4(%eax)
  80349d:	eb 08                	jmp    8034a7 <insert_sorted_with_merge_freeList+0x3ea>
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	a3 48 51 80 00       	mov    %eax,0x805148
  8034af:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b9:	a1 54 51 80 00       	mov    0x805154,%eax
  8034be:	40                   	inc    %eax
  8034bf:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8034c4:	e9 c9 03 00 00       	jmp    803892 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8034c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8034cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d2:	8b 40 08             	mov    0x8(%eax),%eax
  8034d5:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8034d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034da:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8034dd:	39 c2                	cmp    %eax,%edx
  8034df:	0f 85 bb 00 00 00    	jne    8035a0 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8034e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e9:	0f 84 b1 00 00 00    	je     8035a0 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8034ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f2:	8b 40 04             	mov    0x4(%eax),%eax
  8034f5:	85 c0                	test   %eax,%eax
  8034f7:	0f 85 a3 00 00 00    	jne    8035a0 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8034fd:	a1 38 51 80 00       	mov    0x805138,%eax
  803502:	8b 55 08             	mov    0x8(%ebp),%edx
  803505:	8b 52 08             	mov    0x8(%edx),%edx
  803508:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  80350b:	a1 38 51 80 00       	mov    0x805138,%eax
  803510:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803516:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803519:	8b 55 08             	mov    0x8(%ebp),%edx
  80351c:	8b 52 0c             	mov    0xc(%edx),%edx
  80351f:	01 ca                	add    %ecx,%edx
  803521:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803524:	8b 45 08             	mov    0x8(%ebp),%eax
  803527:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803538:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80353c:	75 17                	jne    803555 <insert_sorted_with_merge_freeList+0x498>
  80353e:	83 ec 04             	sub    $0x4,%esp
  803541:	68 08 44 80 00       	push   $0x804408
  803546:	68 17 01 00 00       	push   $0x117
  80354b:	68 2b 44 80 00       	push   $0x80442b
  803550:	e8 82 d3 ff ff       	call   8008d7 <_panic>
  803555:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80355b:	8b 45 08             	mov    0x8(%ebp),%eax
  80355e:	89 10                	mov    %edx,(%eax)
  803560:	8b 45 08             	mov    0x8(%ebp),%eax
  803563:	8b 00                	mov    (%eax),%eax
  803565:	85 c0                	test   %eax,%eax
  803567:	74 0d                	je     803576 <insert_sorted_with_merge_freeList+0x4b9>
  803569:	a1 48 51 80 00       	mov    0x805148,%eax
  80356e:	8b 55 08             	mov    0x8(%ebp),%edx
  803571:	89 50 04             	mov    %edx,0x4(%eax)
  803574:	eb 08                	jmp    80357e <insert_sorted_with_merge_freeList+0x4c1>
  803576:	8b 45 08             	mov    0x8(%ebp),%eax
  803579:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	a3 48 51 80 00       	mov    %eax,0x805148
  803586:	8b 45 08             	mov    0x8(%ebp),%eax
  803589:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803590:	a1 54 51 80 00       	mov    0x805154,%eax
  803595:	40                   	inc    %eax
  803596:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80359b:	e9 f2 02 00 00       	jmp    803892 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  8035a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a3:	8b 50 08             	mov    0x8(%eax),%edx
  8035a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ac:	01 c2                	add    %eax,%edx
  8035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b1:	8b 40 08             	mov    0x8(%eax),%eax
  8035b4:	39 c2                	cmp    %eax,%edx
  8035b6:	0f 85 be 00 00 00    	jne    80367a <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  8035bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bf:	8b 40 04             	mov    0x4(%eax),%eax
  8035c2:	8b 50 08             	mov    0x8(%eax),%edx
  8035c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c8:	8b 40 04             	mov    0x4(%eax),%eax
  8035cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ce:	01 c2                	add    %eax,%edx
  8035d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d3:	8b 40 08             	mov    0x8(%eax),%eax
  8035d6:	39 c2                	cmp    %eax,%edx
  8035d8:	0f 84 9c 00 00 00    	je     80367a <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8035de:	8b 45 08             	mov    0x8(%ebp),%eax
  8035e1:	8b 50 08             	mov    0x8(%eax),%edx
  8035e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e7:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8035ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ed:	8b 50 0c             	mov    0xc(%eax),%edx
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8035f6:	01 c2                	add    %eax,%edx
  8035f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035fb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8035fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803601:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803608:	8b 45 08             	mov    0x8(%ebp),%eax
  80360b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803612:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803616:	75 17                	jne    80362f <insert_sorted_with_merge_freeList+0x572>
  803618:	83 ec 04             	sub    $0x4,%esp
  80361b:	68 08 44 80 00       	push   $0x804408
  803620:	68 26 01 00 00       	push   $0x126
  803625:	68 2b 44 80 00       	push   $0x80442b
  80362a:	e8 a8 d2 ff ff       	call   8008d7 <_panic>
  80362f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803635:	8b 45 08             	mov    0x8(%ebp),%eax
  803638:	89 10                	mov    %edx,(%eax)
  80363a:	8b 45 08             	mov    0x8(%ebp),%eax
  80363d:	8b 00                	mov    (%eax),%eax
  80363f:	85 c0                	test   %eax,%eax
  803641:	74 0d                	je     803650 <insert_sorted_with_merge_freeList+0x593>
  803643:	a1 48 51 80 00       	mov    0x805148,%eax
  803648:	8b 55 08             	mov    0x8(%ebp),%edx
  80364b:	89 50 04             	mov    %edx,0x4(%eax)
  80364e:	eb 08                	jmp    803658 <insert_sorted_with_merge_freeList+0x59b>
  803650:	8b 45 08             	mov    0x8(%ebp),%eax
  803653:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803658:	8b 45 08             	mov    0x8(%ebp),%eax
  80365b:	a3 48 51 80 00       	mov    %eax,0x805148
  803660:	8b 45 08             	mov    0x8(%ebp),%eax
  803663:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80366a:	a1 54 51 80 00       	mov    0x805154,%eax
  80366f:	40                   	inc    %eax
  803670:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803675:	e9 18 02 00 00       	jmp    803892 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  80367a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367d:	8b 50 0c             	mov    0xc(%eax),%edx
  803680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803683:	8b 40 08             	mov    0x8(%eax),%eax
  803686:	01 c2                	add    %eax,%edx
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	8b 40 08             	mov    0x8(%eax),%eax
  80368e:	39 c2                	cmp    %eax,%edx
  803690:	0f 85 c4 01 00 00    	jne    80385a <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803696:	8b 45 08             	mov    0x8(%ebp),%eax
  803699:	8b 50 0c             	mov    0xc(%eax),%edx
  80369c:	8b 45 08             	mov    0x8(%ebp),%eax
  80369f:	8b 40 08             	mov    0x8(%eax),%eax
  8036a2:	01 c2                	add    %eax,%edx
  8036a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a7:	8b 00                	mov    (%eax),%eax
  8036a9:	8b 40 08             	mov    0x8(%eax),%eax
  8036ac:	39 c2                	cmp    %eax,%edx
  8036ae:	0f 85 a6 01 00 00    	jne    80385a <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8036b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b8:	0f 84 9c 01 00 00    	je     80385a <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  8036be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8036c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8036ca:	01 c2                	add    %eax,%edx
  8036cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036cf:	8b 00                	mov    (%eax),%eax
  8036d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8036d4:	01 c2                	add    %eax,%edx
  8036d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d9:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8036dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8036e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8036f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036f4:	75 17                	jne    80370d <insert_sorted_with_merge_freeList+0x650>
  8036f6:	83 ec 04             	sub    $0x4,%esp
  8036f9:	68 08 44 80 00       	push   $0x804408
  8036fe:	68 32 01 00 00       	push   $0x132
  803703:	68 2b 44 80 00       	push   $0x80442b
  803708:	e8 ca d1 ff ff       	call   8008d7 <_panic>
  80370d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803713:	8b 45 08             	mov    0x8(%ebp),%eax
  803716:	89 10                	mov    %edx,(%eax)
  803718:	8b 45 08             	mov    0x8(%ebp),%eax
  80371b:	8b 00                	mov    (%eax),%eax
  80371d:	85 c0                	test   %eax,%eax
  80371f:	74 0d                	je     80372e <insert_sorted_with_merge_freeList+0x671>
  803721:	a1 48 51 80 00       	mov    0x805148,%eax
  803726:	8b 55 08             	mov    0x8(%ebp),%edx
  803729:	89 50 04             	mov    %edx,0x4(%eax)
  80372c:	eb 08                	jmp    803736 <insert_sorted_with_merge_freeList+0x679>
  80372e:	8b 45 08             	mov    0x8(%ebp),%eax
  803731:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803736:	8b 45 08             	mov    0x8(%ebp),%eax
  803739:	a3 48 51 80 00       	mov    %eax,0x805148
  80373e:	8b 45 08             	mov    0x8(%ebp),%eax
  803741:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803748:	a1 54 51 80 00       	mov    0x805154,%eax
  80374d:	40                   	inc    %eax
  80374e:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803756:	8b 00                	mov    (%eax),%eax
  803758:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803762:	8b 00                	mov    (%eax),%eax
  803764:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80376b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376e:	8b 00                	mov    (%eax),%eax
  803770:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803773:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803777:	75 17                	jne    803790 <insert_sorted_with_merge_freeList+0x6d3>
  803779:	83 ec 04             	sub    $0x4,%esp
  80377c:	68 9d 44 80 00       	push   $0x80449d
  803781:	68 36 01 00 00       	push   $0x136
  803786:	68 2b 44 80 00       	push   $0x80442b
  80378b:	e8 47 d1 ff ff       	call   8008d7 <_panic>
  803790:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803793:	8b 00                	mov    (%eax),%eax
  803795:	85 c0                	test   %eax,%eax
  803797:	74 10                	je     8037a9 <insert_sorted_with_merge_freeList+0x6ec>
  803799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379c:	8b 00                	mov    (%eax),%eax
  80379e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037a1:	8b 52 04             	mov    0x4(%edx),%edx
  8037a4:	89 50 04             	mov    %edx,0x4(%eax)
  8037a7:	eb 0b                	jmp    8037b4 <insert_sorted_with_merge_freeList+0x6f7>
  8037a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037ac:	8b 40 04             	mov    0x4(%eax),%eax
  8037af:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8037b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037b7:	8b 40 04             	mov    0x4(%eax),%eax
  8037ba:	85 c0                	test   %eax,%eax
  8037bc:	74 0f                	je     8037cd <insert_sorted_with_merge_freeList+0x710>
  8037be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037c1:	8b 40 04             	mov    0x4(%eax),%eax
  8037c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037c7:	8b 12                	mov    (%edx),%edx
  8037c9:	89 10                	mov    %edx,(%eax)
  8037cb:	eb 0a                	jmp    8037d7 <insert_sorted_with_merge_freeList+0x71a>
  8037cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037d0:	8b 00                	mov    (%eax),%eax
  8037d2:	a3 38 51 80 00       	mov    %eax,0x805138
  8037d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037ea:	a1 44 51 80 00       	mov    0x805144,%eax
  8037ef:	48                   	dec    %eax
  8037f0:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8037f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037f9:	75 17                	jne    803812 <insert_sorted_with_merge_freeList+0x755>
  8037fb:	83 ec 04             	sub    $0x4,%esp
  8037fe:	68 08 44 80 00       	push   $0x804408
  803803:	68 37 01 00 00       	push   $0x137
  803808:	68 2b 44 80 00       	push   $0x80442b
  80380d:	e8 c5 d0 ff ff       	call   8008d7 <_panic>
  803812:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803818:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80381b:	89 10                	mov    %edx,(%eax)
  80381d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803820:	8b 00                	mov    (%eax),%eax
  803822:	85 c0                	test   %eax,%eax
  803824:	74 0d                	je     803833 <insert_sorted_with_merge_freeList+0x776>
  803826:	a1 48 51 80 00       	mov    0x805148,%eax
  80382b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80382e:	89 50 04             	mov    %edx,0x4(%eax)
  803831:	eb 08                	jmp    80383b <insert_sorted_with_merge_freeList+0x77e>
  803833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803836:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80383b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80383e:	a3 48 51 80 00       	mov    %eax,0x805148
  803843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803846:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80384d:	a1 54 51 80 00       	mov    0x805154,%eax
  803852:	40                   	inc    %eax
  803853:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803858:	eb 38                	jmp    803892 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80385a:	a1 40 51 80 00       	mov    0x805140,%eax
  80385f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803862:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803866:	74 07                	je     80386f <insert_sorted_with_merge_freeList+0x7b2>
  803868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386b:	8b 00                	mov    (%eax),%eax
  80386d:	eb 05                	jmp    803874 <insert_sorted_with_merge_freeList+0x7b7>
  80386f:	b8 00 00 00 00       	mov    $0x0,%eax
  803874:	a3 40 51 80 00       	mov    %eax,0x805140
  803879:	a1 40 51 80 00       	mov    0x805140,%eax
  80387e:	85 c0                	test   %eax,%eax
  803880:	0f 85 ef f9 ff ff    	jne    803275 <insert_sorted_with_merge_freeList+0x1b8>
  803886:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80388a:	0f 85 e5 f9 ff ff    	jne    803275 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803890:	eb 00                	jmp    803892 <insert_sorted_with_merge_freeList+0x7d5>
  803892:	90                   	nop
  803893:	c9                   	leave  
  803894:	c3                   	ret    
  803895:	66 90                	xchg   %ax,%ax
  803897:	90                   	nop

00803898 <__udivdi3>:
  803898:	55                   	push   %ebp
  803899:	57                   	push   %edi
  80389a:	56                   	push   %esi
  80389b:	53                   	push   %ebx
  80389c:	83 ec 1c             	sub    $0x1c,%esp
  80389f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8038a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8038a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8038ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8038af:	89 ca                	mov    %ecx,%edx
  8038b1:	89 f8                	mov    %edi,%eax
  8038b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8038b7:	85 f6                	test   %esi,%esi
  8038b9:	75 2d                	jne    8038e8 <__udivdi3+0x50>
  8038bb:	39 cf                	cmp    %ecx,%edi
  8038bd:	77 65                	ja     803924 <__udivdi3+0x8c>
  8038bf:	89 fd                	mov    %edi,%ebp
  8038c1:	85 ff                	test   %edi,%edi
  8038c3:	75 0b                	jne    8038d0 <__udivdi3+0x38>
  8038c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8038ca:	31 d2                	xor    %edx,%edx
  8038cc:	f7 f7                	div    %edi
  8038ce:	89 c5                	mov    %eax,%ebp
  8038d0:	31 d2                	xor    %edx,%edx
  8038d2:	89 c8                	mov    %ecx,%eax
  8038d4:	f7 f5                	div    %ebp
  8038d6:	89 c1                	mov    %eax,%ecx
  8038d8:	89 d8                	mov    %ebx,%eax
  8038da:	f7 f5                	div    %ebp
  8038dc:	89 cf                	mov    %ecx,%edi
  8038de:	89 fa                	mov    %edi,%edx
  8038e0:	83 c4 1c             	add    $0x1c,%esp
  8038e3:	5b                   	pop    %ebx
  8038e4:	5e                   	pop    %esi
  8038e5:	5f                   	pop    %edi
  8038e6:	5d                   	pop    %ebp
  8038e7:	c3                   	ret    
  8038e8:	39 ce                	cmp    %ecx,%esi
  8038ea:	77 28                	ja     803914 <__udivdi3+0x7c>
  8038ec:	0f bd fe             	bsr    %esi,%edi
  8038ef:	83 f7 1f             	xor    $0x1f,%edi
  8038f2:	75 40                	jne    803934 <__udivdi3+0x9c>
  8038f4:	39 ce                	cmp    %ecx,%esi
  8038f6:	72 0a                	jb     803902 <__udivdi3+0x6a>
  8038f8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038fc:	0f 87 9e 00 00 00    	ja     8039a0 <__udivdi3+0x108>
  803902:	b8 01 00 00 00       	mov    $0x1,%eax
  803907:	89 fa                	mov    %edi,%edx
  803909:	83 c4 1c             	add    $0x1c,%esp
  80390c:	5b                   	pop    %ebx
  80390d:	5e                   	pop    %esi
  80390e:	5f                   	pop    %edi
  80390f:	5d                   	pop    %ebp
  803910:	c3                   	ret    
  803911:	8d 76 00             	lea    0x0(%esi),%esi
  803914:	31 ff                	xor    %edi,%edi
  803916:	31 c0                	xor    %eax,%eax
  803918:	89 fa                	mov    %edi,%edx
  80391a:	83 c4 1c             	add    $0x1c,%esp
  80391d:	5b                   	pop    %ebx
  80391e:	5e                   	pop    %esi
  80391f:	5f                   	pop    %edi
  803920:	5d                   	pop    %ebp
  803921:	c3                   	ret    
  803922:	66 90                	xchg   %ax,%ax
  803924:	89 d8                	mov    %ebx,%eax
  803926:	f7 f7                	div    %edi
  803928:	31 ff                	xor    %edi,%edi
  80392a:	89 fa                	mov    %edi,%edx
  80392c:	83 c4 1c             	add    $0x1c,%esp
  80392f:	5b                   	pop    %ebx
  803930:	5e                   	pop    %esi
  803931:	5f                   	pop    %edi
  803932:	5d                   	pop    %ebp
  803933:	c3                   	ret    
  803934:	bd 20 00 00 00       	mov    $0x20,%ebp
  803939:	89 eb                	mov    %ebp,%ebx
  80393b:	29 fb                	sub    %edi,%ebx
  80393d:	89 f9                	mov    %edi,%ecx
  80393f:	d3 e6                	shl    %cl,%esi
  803941:	89 c5                	mov    %eax,%ebp
  803943:	88 d9                	mov    %bl,%cl
  803945:	d3 ed                	shr    %cl,%ebp
  803947:	89 e9                	mov    %ebp,%ecx
  803949:	09 f1                	or     %esi,%ecx
  80394b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80394f:	89 f9                	mov    %edi,%ecx
  803951:	d3 e0                	shl    %cl,%eax
  803953:	89 c5                	mov    %eax,%ebp
  803955:	89 d6                	mov    %edx,%esi
  803957:	88 d9                	mov    %bl,%cl
  803959:	d3 ee                	shr    %cl,%esi
  80395b:	89 f9                	mov    %edi,%ecx
  80395d:	d3 e2                	shl    %cl,%edx
  80395f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803963:	88 d9                	mov    %bl,%cl
  803965:	d3 e8                	shr    %cl,%eax
  803967:	09 c2                	or     %eax,%edx
  803969:	89 d0                	mov    %edx,%eax
  80396b:	89 f2                	mov    %esi,%edx
  80396d:	f7 74 24 0c          	divl   0xc(%esp)
  803971:	89 d6                	mov    %edx,%esi
  803973:	89 c3                	mov    %eax,%ebx
  803975:	f7 e5                	mul    %ebp
  803977:	39 d6                	cmp    %edx,%esi
  803979:	72 19                	jb     803994 <__udivdi3+0xfc>
  80397b:	74 0b                	je     803988 <__udivdi3+0xf0>
  80397d:	89 d8                	mov    %ebx,%eax
  80397f:	31 ff                	xor    %edi,%edi
  803981:	e9 58 ff ff ff       	jmp    8038de <__udivdi3+0x46>
  803986:	66 90                	xchg   %ax,%ax
  803988:	8b 54 24 08          	mov    0x8(%esp),%edx
  80398c:	89 f9                	mov    %edi,%ecx
  80398e:	d3 e2                	shl    %cl,%edx
  803990:	39 c2                	cmp    %eax,%edx
  803992:	73 e9                	jae    80397d <__udivdi3+0xe5>
  803994:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803997:	31 ff                	xor    %edi,%edi
  803999:	e9 40 ff ff ff       	jmp    8038de <__udivdi3+0x46>
  80399e:	66 90                	xchg   %ax,%ax
  8039a0:	31 c0                	xor    %eax,%eax
  8039a2:	e9 37 ff ff ff       	jmp    8038de <__udivdi3+0x46>
  8039a7:	90                   	nop

008039a8 <__umoddi3>:
  8039a8:	55                   	push   %ebp
  8039a9:	57                   	push   %edi
  8039aa:	56                   	push   %esi
  8039ab:	53                   	push   %ebx
  8039ac:	83 ec 1c             	sub    $0x1c,%esp
  8039af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8039b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8039b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8039bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8039bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8039c7:	89 f3                	mov    %esi,%ebx
  8039c9:	89 fa                	mov    %edi,%edx
  8039cb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8039cf:	89 34 24             	mov    %esi,(%esp)
  8039d2:	85 c0                	test   %eax,%eax
  8039d4:	75 1a                	jne    8039f0 <__umoddi3+0x48>
  8039d6:	39 f7                	cmp    %esi,%edi
  8039d8:	0f 86 a2 00 00 00    	jbe    803a80 <__umoddi3+0xd8>
  8039de:	89 c8                	mov    %ecx,%eax
  8039e0:	89 f2                	mov    %esi,%edx
  8039e2:	f7 f7                	div    %edi
  8039e4:	89 d0                	mov    %edx,%eax
  8039e6:	31 d2                	xor    %edx,%edx
  8039e8:	83 c4 1c             	add    $0x1c,%esp
  8039eb:	5b                   	pop    %ebx
  8039ec:	5e                   	pop    %esi
  8039ed:	5f                   	pop    %edi
  8039ee:	5d                   	pop    %ebp
  8039ef:	c3                   	ret    
  8039f0:	39 f0                	cmp    %esi,%eax
  8039f2:	0f 87 ac 00 00 00    	ja     803aa4 <__umoddi3+0xfc>
  8039f8:	0f bd e8             	bsr    %eax,%ebp
  8039fb:	83 f5 1f             	xor    $0x1f,%ebp
  8039fe:	0f 84 ac 00 00 00    	je     803ab0 <__umoddi3+0x108>
  803a04:	bf 20 00 00 00       	mov    $0x20,%edi
  803a09:	29 ef                	sub    %ebp,%edi
  803a0b:	89 fe                	mov    %edi,%esi
  803a0d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803a11:	89 e9                	mov    %ebp,%ecx
  803a13:	d3 e0                	shl    %cl,%eax
  803a15:	89 d7                	mov    %edx,%edi
  803a17:	89 f1                	mov    %esi,%ecx
  803a19:	d3 ef                	shr    %cl,%edi
  803a1b:	09 c7                	or     %eax,%edi
  803a1d:	89 e9                	mov    %ebp,%ecx
  803a1f:	d3 e2                	shl    %cl,%edx
  803a21:	89 14 24             	mov    %edx,(%esp)
  803a24:	89 d8                	mov    %ebx,%eax
  803a26:	d3 e0                	shl    %cl,%eax
  803a28:	89 c2                	mov    %eax,%edx
  803a2a:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a2e:	d3 e0                	shl    %cl,%eax
  803a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a34:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a38:	89 f1                	mov    %esi,%ecx
  803a3a:	d3 e8                	shr    %cl,%eax
  803a3c:	09 d0                	or     %edx,%eax
  803a3e:	d3 eb                	shr    %cl,%ebx
  803a40:	89 da                	mov    %ebx,%edx
  803a42:	f7 f7                	div    %edi
  803a44:	89 d3                	mov    %edx,%ebx
  803a46:	f7 24 24             	mull   (%esp)
  803a49:	89 c6                	mov    %eax,%esi
  803a4b:	89 d1                	mov    %edx,%ecx
  803a4d:	39 d3                	cmp    %edx,%ebx
  803a4f:	0f 82 87 00 00 00    	jb     803adc <__umoddi3+0x134>
  803a55:	0f 84 91 00 00 00    	je     803aec <__umoddi3+0x144>
  803a5b:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a5f:	29 f2                	sub    %esi,%edx
  803a61:	19 cb                	sbb    %ecx,%ebx
  803a63:	89 d8                	mov    %ebx,%eax
  803a65:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a69:	d3 e0                	shl    %cl,%eax
  803a6b:	89 e9                	mov    %ebp,%ecx
  803a6d:	d3 ea                	shr    %cl,%edx
  803a6f:	09 d0                	or     %edx,%eax
  803a71:	89 e9                	mov    %ebp,%ecx
  803a73:	d3 eb                	shr    %cl,%ebx
  803a75:	89 da                	mov    %ebx,%edx
  803a77:	83 c4 1c             	add    $0x1c,%esp
  803a7a:	5b                   	pop    %ebx
  803a7b:	5e                   	pop    %esi
  803a7c:	5f                   	pop    %edi
  803a7d:	5d                   	pop    %ebp
  803a7e:	c3                   	ret    
  803a7f:	90                   	nop
  803a80:	89 fd                	mov    %edi,%ebp
  803a82:	85 ff                	test   %edi,%edi
  803a84:	75 0b                	jne    803a91 <__umoddi3+0xe9>
  803a86:	b8 01 00 00 00       	mov    $0x1,%eax
  803a8b:	31 d2                	xor    %edx,%edx
  803a8d:	f7 f7                	div    %edi
  803a8f:	89 c5                	mov    %eax,%ebp
  803a91:	89 f0                	mov    %esi,%eax
  803a93:	31 d2                	xor    %edx,%edx
  803a95:	f7 f5                	div    %ebp
  803a97:	89 c8                	mov    %ecx,%eax
  803a99:	f7 f5                	div    %ebp
  803a9b:	89 d0                	mov    %edx,%eax
  803a9d:	e9 44 ff ff ff       	jmp    8039e6 <__umoddi3+0x3e>
  803aa2:	66 90                	xchg   %ax,%ax
  803aa4:	89 c8                	mov    %ecx,%eax
  803aa6:	89 f2                	mov    %esi,%edx
  803aa8:	83 c4 1c             	add    $0x1c,%esp
  803aab:	5b                   	pop    %ebx
  803aac:	5e                   	pop    %esi
  803aad:	5f                   	pop    %edi
  803aae:	5d                   	pop    %ebp
  803aaf:	c3                   	ret    
  803ab0:	3b 04 24             	cmp    (%esp),%eax
  803ab3:	72 06                	jb     803abb <__umoddi3+0x113>
  803ab5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803ab9:	77 0f                	ja     803aca <__umoddi3+0x122>
  803abb:	89 f2                	mov    %esi,%edx
  803abd:	29 f9                	sub    %edi,%ecx
  803abf:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ac3:	89 14 24             	mov    %edx,(%esp)
  803ac6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803aca:	8b 44 24 04          	mov    0x4(%esp),%eax
  803ace:	8b 14 24             	mov    (%esp),%edx
  803ad1:	83 c4 1c             	add    $0x1c,%esp
  803ad4:	5b                   	pop    %ebx
  803ad5:	5e                   	pop    %esi
  803ad6:	5f                   	pop    %edi
  803ad7:	5d                   	pop    %ebp
  803ad8:	c3                   	ret    
  803ad9:	8d 76 00             	lea    0x0(%esi),%esi
  803adc:	2b 04 24             	sub    (%esp),%eax
  803adf:	19 fa                	sbb    %edi,%edx
  803ae1:	89 d1                	mov    %edx,%ecx
  803ae3:	89 c6                	mov    %eax,%esi
  803ae5:	e9 71 ff ff ff       	jmp    803a5b <__umoddi3+0xb3>
  803aea:	66 90                	xchg   %ax,%ax
  803aec:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803af0:	72 ea                	jb     803adc <__umoddi3+0x134>
  803af2:	89 d9                	mov    %ebx,%ecx
  803af4:	e9 62 ff ff ff       	jmp    803a5b <__umoddi3+0xb3>
