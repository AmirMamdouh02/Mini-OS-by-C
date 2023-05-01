
obj/user/ef_mergesort_noleakage:     file format elf32-i386


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
  800031:	e8 81 07 00 00       	call   8007b7 <libmain>
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
  800041:	e8 8b 20 00 00       	call   8020d1 <sys_disable_interrupt>

		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 20 39 80 00       	push   $0x803920
  80004e:	e8 54 0b 00 00       	call   800ba7 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 22 39 80 00       	push   $0x803922
  80005e:	e8 44 0b 00 00       	call   800ba7 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!! MERGE SORT !!!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 38 39 80 00       	push   $0x803938
  80006e:	e8 34 0b 00 00       	call   800ba7 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 22 39 80 00       	push   $0x803922
  80007e:	e8 24 0b 00 00       	call   800ba7 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 20 39 80 00       	push   $0x803920
  80008e:	e8 14 0b 00 00       	call   800ba7 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp
		//readline("Enter the number of elements: ", Line);
		cprintf("Enter the number of elements: ");
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	68 50 39 80 00       	push   $0x803950
  80009e:	e8 04 0b 00 00       	call   800ba7 <cprintf>
  8000a3:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = 2000 ;
  8000a6:	c7 45 f0 d0 07 00 00 	movl   $0x7d0,-0x10(%ebp)
		cprintf("%d\n", NumOfElements) ;
  8000ad:	83 ec 08             	sub    $0x8,%esp
  8000b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8000b3:	68 6f 39 80 00       	push   $0x80396f
  8000b8:	e8 ea 0a 00 00       	call   800ba7 <cprintf>
  8000bd:	83 c4 10             	add    $0x10,%esp

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  8000c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c3:	c1 e0 02             	shl    $0x2,%eax
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	50                   	push   %eax
  8000ca:	e8 77 1a 00 00       	call   801b46 <malloc>
  8000cf:	83 c4 10             	add    $0x10,%esp
  8000d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		cprintf("Chose the initialization method:\n") ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 74 39 80 00       	push   $0x803974
  8000dd:	e8 c5 0a 00 00       	call   800ba7 <cprintf>
  8000e2:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 96 39 80 00       	push   $0x803996
  8000ed:	e8 b5 0a 00 00       	call   800ba7 <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 a4 39 80 00       	push   $0x8039a4
  8000fd:	e8 a5 0a 00 00       	call   800ba7 <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  800105:	83 ec 0c             	sub    $0xc,%esp
  800108:	68 b3 39 80 00       	push   $0x8039b3
  80010d:	e8 95 0a 00 00       	call   800ba7 <cprintf>
  800112:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  800115:	83 ec 0c             	sub    $0xc,%esp
  800118:	68 c3 39 80 00       	push   $0x8039c3
  80011d:	e8 85 0a 00 00       	call   800ba7 <cprintf>
  800122:	83 c4 10             	add    $0x10,%esp
			//Chose = getchar() ;
			Chose = 'a';
  800125:	c6 45 f7 61          	movb   $0x61,-0x9(%ebp)
			cputchar(Chose);
  800129:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	50                   	push   %eax
  800131:	e8 e1 05 00 00       	call   800717 <cputchar>
  800136:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800139:	83 ec 0c             	sub    $0xc,%esp
  80013c:	6a 0a                	push   $0xa
  80013e:	e8 d4 05 00 00       	call   800717 <cputchar>
  800143:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800146:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  80014a:	74 0c                	je     800158 <_main+0x120>
  80014c:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  800150:	74 06                	je     800158 <_main+0x120>
  800152:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800156:	75 bd                	jne    800115 <_main+0xdd>

		//2012: lock the interrupt
		sys_enable_interrupt();
  800158:	e8 8e 1f 00 00       	call   8020eb <sys_enable_interrupt>

		int  i ;
		switch (Chose)
  80015d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800161:	83 f8 62             	cmp    $0x62,%eax
  800164:	74 1d                	je     800183 <_main+0x14b>
  800166:	83 f8 63             	cmp    $0x63,%eax
  800169:	74 2b                	je     800196 <_main+0x15e>
  80016b:	83 f8 61             	cmp    $0x61,%eax
  80016e:	75 39                	jne    8001a9 <_main+0x171>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	ff 75 f0             	pushl  -0x10(%ebp)
  800176:	ff 75 ec             	pushl  -0x14(%ebp)
  800179:	e8 f0 01 00 00       	call   80036e <InitializeAscending>
  80017e:	83 c4 10             	add    $0x10,%esp
			break ;
  800181:	eb 37                	jmp    8001ba <_main+0x182>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	ff 75 f0             	pushl  -0x10(%ebp)
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	e8 0e 02 00 00       	call   80039f <InitializeDescending>
  800191:	83 c4 10             	add    $0x10,%esp
			break ;
  800194:	eb 24                	jmp    8001ba <_main+0x182>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	ff 75 f0             	pushl  -0x10(%ebp)
  80019c:	ff 75 ec             	pushl  -0x14(%ebp)
  80019f:	e8 30 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001a4:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a7:	eb 11                	jmp    8001ba <_main+0x182>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001a9:	83 ec 08             	sub    $0x8,%esp
  8001ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8001af:	ff 75 ec             	pushl  -0x14(%ebp)
  8001b2:	e8 1d 02 00 00       	call   8003d4 <InitializeSemiRandom>
  8001b7:	83 c4 10             	add    $0x10,%esp
		}

		MSort(Elements, 1, NumOfElements);
  8001ba:	83 ec 04             	sub    $0x4,%esp
  8001bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8001c0:	6a 01                	push   $0x1
  8001c2:	ff 75 ec             	pushl  -0x14(%ebp)
  8001c5:	e8 dc 02 00 00       	call   8004a6 <MSort>
  8001ca:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  8001cd:	e8 ff 1e 00 00       	call   8020d1 <sys_disable_interrupt>
		cprintf("Sorting is Finished!!!!it'll be checked now....\n") ;
  8001d2:	83 ec 0c             	sub    $0xc,%esp
  8001d5:	68 cc 39 80 00       	push   $0x8039cc
  8001da:	e8 c8 09 00 00       	call   800ba7 <cprintf>
  8001df:	83 c4 10             	add    $0x10,%esp
		//PrintElements(Elements, NumOfElements);
		sys_enable_interrupt();
  8001e2:	e8 04 1f 00 00       	call   8020eb <sys_enable_interrupt>

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001e7:	83 ec 08             	sub    $0x8,%esp
  8001ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ed:	ff 75 ec             	pushl  -0x14(%ebp)
  8001f0:	e8 cf 00 00 00       	call   8002c4 <CheckSorted>
  8001f5:	83 c4 10             	add    $0x10,%esp
  8001f8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8001ff:	75 14                	jne    800215 <_main+0x1dd>
  800201:	83 ec 04             	sub    $0x4,%esp
  800204:	68 00 3a 80 00       	push   $0x803a00
  800209:	6a 4e                	push   $0x4e
  80020b:	68 22 3a 80 00       	push   $0x803a22
  800210:	e8 de 06 00 00       	call   8008f3 <_panic>
		else
		{
			sys_disable_interrupt();
  800215:	e8 b7 1e 00 00       	call   8020d1 <sys_disable_interrupt>
			cprintf("===============================================\n") ;
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 40 3a 80 00       	push   $0x803a40
  800222:	e8 80 09 00 00       	call   800ba7 <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  80022a:	83 ec 0c             	sub    $0xc,%esp
  80022d:	68 74 3a 80 00       	push   $0x803a74
  800232:	e8 70 09 00 00       	call   800ba7 <cprintf>
  800237:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	68 a8 3a 80 00       	push   $0x803aa8
  800242:	e8 60 09 00 00       	call   800ba7 <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  80024a:	e8 9c 1e 00 00       	call   8020eb <sys_enable_interrupt>
		}

		free(Elements) ;
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	ff 75 ec             	pushl  -0x14(%ebp)
  800255:	e8 85 19 00 00       	call   801bdf <free>
  80025a:	83 c4 10             	add    $0x10,%esp

		sys_disable_interrupt();
  80025d:	e8 6f 1e 00 00       	call   8020d1 <sys_disable_interrupt>
			Chose = 0 ;
  800262:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
			while (Chose != 'y' && Chose != 'n')
  800266:	eb 3e                	jmp    8002a6 <_main+0x26e>
			{
				cprintf("Do you want to repeat (y/n): ") ;
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	68 da 3a 80 00       	push   $0x803ada
  800270:	e8 32 09 00 00       	call   800ba7 <cprintf>
  800275:	83 c4 10             	add    $0x10,%esp
				Chose = 'n' ;
  800278:	c6 45 f7 6e          	movb   $0x6e,-0x9(%ebp)
				cputchar(Chose);
  80027c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	50                   	push   %eax
  800284:	e8 8e 04 00 00       	call   800717 <cputchar>
  800289:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	6a 0a                	push   $0xa
  800291:	e8 81 04 00 00       	call   800717 <cputchar>
  800296:	83 c4 10             	add    $0x10,%esp
				cputchar('\n');
  800299:	83 ec 0c             	sub    $0xc,%esp
  80029c:	6a 0a                	push   $0xa
  80029e:	e8 74 04 00 00       	call   800717 <cputchar>
  8002a3:	83 c4 10             	add    $0x10,%esp

		free(Elements) ;

		sys_disable_interrupt();
			Chose = 0 ;
			while (Chose != 'y' && Chose != 'n')
  8002a6:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  8002aa:	74 06                	je     8002b2 <_main+0x27a>
  8002ac:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  8002b0:	75 b6                	jne    800268 <_main+0x230>
				Chose = 'n' ;
				cputchar(Chose);
				cputchar('\n');
				cputchar('\n');
			}
		sys_enable_interrupt();
  8002b2:	e8 34 1e 00 00       	call   8020eb <sys_enable_interrupt>

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
  800446:	68 20 39 80 00       	push   $0x803920
  80044b:	e8 57 07 00 00       	call   800ba7 <cprintf>
  800450:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800456:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045d:	8b 45 08             	mov    0x8(%ebp),%eax
  800460:	01 d0                	add    %edx,%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	83 ec 08             	sub    $0x8,%esp
  800467:	50                   	push   %eax
  800468:	68 f8 3a 80 00       	push   $0x803af8
  80046d:	e8 35 07 00 00       	call   800ba7 <cprintf>
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
  800496:	68 6f 39 80 00       	push   $0x80396f
  80049b:	e8 07 07 00 00       	call   800ba7 <cprintf>
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
  80053c:	e8 05 16 00 00       	call   801b46 <malloc>
  800541:	83 c4 10             	add    $0x10,%esp
  800544:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  800547:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054a:	c1 e0 02             	shl    $0x2,%eax
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	50                   	push   %eax
  800551:	e8 f0 15 00 00       	call   801b46 <malloc>
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	89 45 d4             	mov    %eax,-0x2c(%ebp)

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
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

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

	free(Left);
  8006f8:	83 ec 0c             	sub    $0xc,%esp
  8006fb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006fe:	e8 dc 14 00 00       	call   801bdf <free>
  800703:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800706:	83 ec 0c             	sub    $0xc,%esp
  800709:	ff 75 d4             	pushl  -0x2c(%ebp)
  80070c:	e8 ce 14 00 00       	call   801bdf <free>
  800711:	83 c4 10             	add    $0x10,%esp

}
  800714:	90                   	nop
  800715:	c9                   	leave  
  800716:	c3                   	ret    

00800717 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  800717:	55                   	push   %ebp
  800718:	89 e5                	mov    %esp,%ebp
  80071a:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800723:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	50                   	push   %eax
  80072b:	e8 d5 19 00 00       	call   802105 <sys_cputc>
  800730:	83 c4 10             	add    $0x10,%esp
}
  800733:	90                   	nop
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
  800739:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80073c:	e8 90 19 00 00       	call   8020d1 <sys_disable_interrupt>
	char c = ch;
  800741:	8b 45 08             	mov    0x8(%ebp),%eax
  800744:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800747:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	50                   	push   %eax
  80074f:	e8 b1 19 00 00       	call   802105 <sys_cputc>
  800754:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800757:	e8 8f 19 00 00       	call   8020eb <sys_enable_interrupt>
}
  80075c:	90                   	nop
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    

0080075f <getchar>:

int
getchar(void)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800765:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80076c:	eb 08                	jmp    800776 <getchar+0x17>
	{
		c = sys_cgetc();
  80076e:	e8 d9 17 00 00       	call   801f4c <sys_cgetc>
  800773:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800776:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80077a:	74 f2                	je     80076e <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80077c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80077f:	c9                   	leave  
  800780:	c3                   	ret    

00800781 <atomic_getchar>:

int
atomic_getchar(void)
{
  800781:	55                   	push   %ebp
  800782:	89 e5                	mov    %esp,%ebp
  800784:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800787:	e8 45 19 00 00       	call   8020d1 <sys_disable_interrupt>
	int c=0;
  80078c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800793:	eb 08                	jmp    80079d <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800795:	e8 b2 17 00 00       	call   801f4c <sys_cgetc>
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80079d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8007a1:	74 f2                	je     800795 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8007a3:	e8 43 19 00 00       	call   8020eb <sys_enable_interrupt>
	return c;
  8007a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <iscons>:

int iscons(int fdnum)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8007b0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8007bd:	e8 02 1b 00 00       	call   8022c4 <sys_getenvindex>
  8007c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8007c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c8:	89 d0                	mov    %edx,%eax
  8007ca:	c1 e0 03             	shl    $0x3,%eax
  8007cd:	01 d0                	add    %edx,%eax
  8007cf:	01 c0                	add    %eax,%eax
  8007d1:	01 d0                	add    %edx,%eax
  8007d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007da:	01 d0                	add    %edx,%eax
  8007dc:	c1 e0 04             	shl    $0x4,%eax
  8007df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8007e4:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8007e9:	a1 24 50 80 00       	mov    0x805024,%eax
  8007ee:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8007f4:	84 c0                	test   %al,%al
  8007f6:	74 0f                	je     800807 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007f8:	a1 24 50 80 00       	mov    0x805024,%eax
  8007fd:	05 5c 05 00 00       	add    $0x55c,%eax
  800802:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800807:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80080b:	7e 0a                	jle    800817 <libmain+0x60>
		binaryname = argv[0];
  80080d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	ff 75 08             	pushl  0x8(%ebp)
  800820:	e8 13 f8 ff ff       	call   800038 <_main>
  800825:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800828:	e8 a4 18 00 00       	call   8020d1 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	68 18 3b 80 00       	push   $0x803b18
  800835:	e8 6d 03 00 00       	call   800ba7 <cprintf>
  80083a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80083d:	a1 24 50 80 00       	mov    0x805024,%eax
  800842:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800848:	a1 24 50 80 00       	mov    0x805024,%eax
  80084d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800853:	83 ec 04             	sub    $0x4,%esp
  800856:	52                   	push   %edx
  800857:	50                   	push   %eax
  800858:	68 40 3b 80 00       	push   $0x803b40
  80085d:	e8 45 03 00 00       	call   800ba7 <cprintf>
  800862:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800865:	a1 24 50 80 00       	mov    0x805024,%eax
  80086a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800870:	a1 24 50 80 00       	mov    0x805024,%eax
  800875:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80087b:	a1 24 50 80 00       	mov    0x805024,%eax
  800880:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	68 68 3b 80 00       	push   $0x803b68
  80088e:	e8 14 03 00 00       	call   800ba7 <cprintf>
  800893:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800896:	a1 24 50 80 00       	mov    0x805024,%eax
  80089b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8008a1:	83 ec 08             	sub    $0x8,%esp
  8008a4:	50                   	push   %eax
  8008a5:	68 c0 3b 80 00       	push   $0x803bc0
  8008aa:	e8 f8 02 00 00       	call   800ba7 <cprintf>
  8008af:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8008b2:	83 ec 0c             	sub    $0xc,%esp
  8008b5:	68 18 3b 80 00       	push   $0x803b18
  8008ba:	e8 e8 02 00 00       	call   800ba7 <cprintf>
  8008bf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8008c2:	e8 24 18 00 00       	call   8020eb <sys_enable_interrupt>

	// exit gracefully
	exit();
  8008c7:	e8 19 00 00 00       	call   8008e5 <exit>
}
  8008cc:	90                   	nop
  8008cd:	c9                   	leave  
  8008ce:	c3                   	ret    

008008cf <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8008cf:	55                   	push   %ebp
  8008d0:	89 e5                	mov    %esp,%ebp
  8008d2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8008d5:	83 ec 0c             	sub    $0xc,%esp
  8008d8:	6a 00                	push   $0x0
  8008da:	e8 b1 19 00 00       	call   802290 <sys_destroy_env>
  8008df:	83 c4 10             	add    $0x10,%esp
}
  8008e2:	90                   	nop
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    

008008e5 <exit>:

void
exit(void)
{
  8008e5:	55                   	push   %ebp
  8008e6:	89 e5                	mov    %esp,%ebp
  8008e8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8008eb:	e8 06 1a 00 00       	call   8022f6 <sys_exit_env>
}
  8008f0:	90                   	nop
  8008f1:	c9                   	leave  
  8008f2:	c3                   	ret    

008008f3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008f9:	8d 45 10             	lea    0x10(%ebp),%eax
  8008fc:	83 c0 04             	add    $0x4,%eax
  8008ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800902:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800907:	85 c0                	test   %eax,%eax
  800909:	74 16                	je     800921 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80090b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800910:	83 ec 08             	sub    $0x8,%esp
  800913:	50                   	push   %eax
  800914:	68 d4 3b 80 00       	push   $0x803bd4
  800919:	e8 89 02 00 00       	call   800ba7 <cprintf>
  80091e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800921:	a1 00 50 80 00       	mov    0x805000,%eax
  800926:	ff 75 0c             	pushl  0xc(%ebp)
  800929:	ff 75 08             	pushl  0x8(%ebp)
  80092c:	50                   	push   %eax
  80092d:	68 d9 3b 80 00       	push   $0x803bd9
  800932:	e8 70 02 00 00       	call   800ba7 <cprintf>
  800937:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80093a:	8b 45 10             	mov    0x10(%ebp),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 f4             	pushl  -0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	e8 f3 01 00 00       	call   800b3c <vcprintf>
  800949:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80094c:	83 ec 08             	sub    $0x8,%esp
  80094f:	6a 00                	push   $0x0
  800951:	68 f5 3b 80 00       	push   $0x803bf5
  800956:	e8 e1 01 00 00       	call   800b3c <vcprintf>
  80095b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80095e:	e8 82 ff ff ff       	call   8008e5 <exit>

	// should not return here
	while (1) ;
  800963:	eb fe                	jmp    800963 <_panic+0x70>

00800965 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80096b:	a1 24 50 80 00       	mov    0x805024,%eax
  800970:	8b 50 74             	mov    0x74(%eax),%edx
  800973:	8b 45 0c             	mov    0xc(%ebp),%eax
  800976:	39 c2                	cmp    %eax,%edx
  800978:	74 14                	je     80098e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80097a:	83 ec 04             	sub    $0x4,%esp
  80097d:	68 f8 3b 80 00       	push   $0x803bf8
  800982:	6a 26                	push   $0x26
  800984:	68 44 3c 80 00       	push   $0x803c44
  800989:	e8 65 ff ff ff       	call   8008f3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80098e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800995:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80099c:	e9 c2 00 00 00       	jmp    800a63 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8009a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	01 d0                	add    %edx,%eax
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	85 c0                	test   %eax,%eax
  8009b4:	75 08                	jne    8009be <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8009b6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8009b9:	e9 a2 00 00 00       	jmp    800a60 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8009be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009c5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8009cc:	eb 69                	jmp    800a37 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8009ce:	a1 24 50 80 00       	mov    0x805024,%eax
  8009d3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009dc:	89 d0                	mov    %edx,%eax
  8009de:	01 c0                	add    %eax,%eax
  8009e0:	01 d0                	add    %edx,%eax
  8009e2:	c1 e0 03             	shl    $0x3,%eax
  8009e5:	01 c8                	add    %ecx,%eax
  8009e7:	8a 40 04             	mov    0x4(%eax),%al
  8009ea:	84 c0                	test   %al,%al
  8009ec:	75 46                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009ee:	a1 24 50 80 00       	mov    0x805024,%eax
  8009f3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009f9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009fc:	89 d0                	mov    %edx,%eax
  8009fe:	01 c0                	add    %eax,%eax
  800a00:	01 d0                	add    %edx,%eax
  800a02:	c1 e0 03             	shl    $0x3,%eax
  800a05:	01 c8                	add    %ecx,%eax
  800a07:	8b 00                	mov    (%eax),%eax
  800a09:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a0f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a14:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a19:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	01 c8                	add    %ecx,%eax
  800a25:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a27:	39 c2                	cmp    %eax,%edx
  800a29:	75 09                	jne    800a34 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800a2b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800a32:	eb 12                	jmp    800a46 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a34:	ff 45 e8             	incl   -0x18(%ebp)
  800a37:	a1 24 50 80 00       	mov    0x805024,%eax
  800a3c:	8b 50 74             	mov    0x74(%eax),%edx
  800a3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a42:	39 c2                	cmp    %eax,%edx
  800a44:	77 88                	ja     8009ce <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800a46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800a4a:	75 14                	jne    800a60 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800a4c:	83 ec 04             	sub    $0x4,%esp
  800a4f:	68 50 3c 80 00       	push   $0x803c50
  800a54:	6a 3a                	push   $0x3a
  800a56:	68 44 3c 80 00       	push   $0x803c44
  800a5b:	e8 93 fe ff ff       	call   8008f3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a60:	ff 45 f0             	incl   -0x10(%ebp)
  800a63:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a66:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a69:	0f 8c 32 ff ff ff    	jl     8009a1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a76:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a7d:	eb 26                	jmp    800aa5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a7f:	a1 24 50 80 00       	mov    0x805024,%eax
  800a84:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a8a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a8d:	89 d0                	mov    %edx,%eax
  800a8f:	01 c0                	add    %eax,%eax
  800a91:	01 d0                	add    %edx,%eax
  800a93:	c1 e0 03             	shl    $0x3,%eax
  800a96:	01 c8                	add    %ecx,%eax
  800a98:	8a 40 04             	mov    0x4(%eax),%al
  800a9b:	3c 01                	cmp    $0x1,%al
  800a9d:	75 03                	jne    800aa2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a9f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aa2:	ff 45 e0             	incl   -0x20(%ebp)
  800aa5:	a1 24 50 80 00       	mov    0x805024,%eax
  800aaa:	8b 50 74             	mov    0x74(%eax),%edx
  800aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ab0:	39 c2                	cmp    %eax,%edx
  800ab2:	77 cb                	ja     800a7f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ab7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800aba:	74 14                	je     800ad0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800abc:	83 ec 04             	sub    $0x4,%esp
  800abf:	68 a4 3c 80 00       	push   $0x803ca4
  800ac4:	6a 44                	push   $0x44
  800ac6:	68 44 3c 80 00       	push   $0x803c44
  800acb:	e8 23 fe ff ff       	call   8008f3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800ad0:	90                   	nop
  800ad1:	c9                   	leave  
  800ad2:	c3                   	ret    

00800ad3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800ad3:	55                   	push   %ebp
  800ad4:	89 e5                	mov    %esp,%ebp
  800ad6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adc:	8b 00                	mov    (%eax),%eax
  800ade:	8d 48 01             	lea    0x1(%eax),%ecx
  800ae1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae4:	89 0a                	mov    %ecx,(%edx)
  800ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae9:	88 d1                	mov    %dl,%cl
  800aeb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aee:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	3d ff 00 00 00       	cmp    $0xff,%eax
  800afc:	75 2c                	jne    800b2a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800afe:	a0 28 50 80 00       	mov    0x805028,%al
  800b03:	0f b6 c0             	movzbl %al,%eax
  800b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b09:	8b 12                	mov    (%edx),%edx
  800b0b:	89 d1                	mov    %edx,%ecx
  800b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b10:	83 c2 08             	add    $0x8,%edx
  800b13:	83 ec 04             	sub    $0x4,%esp
  800b16:	50                   	push   %eax
  800b17:	51                   	push   %ecx
  800b18:	52                   	push   %edx
  800b19:	e8 05 14 00 00       	call   801f23 <sys_cputs>
  800b1e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2d:	8b 40 04             	mov    0x4(%eax),%eax
  800b30:	8d 50 01             	lea    0x1(%eax),%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	89 50 04             	mov    %edx,0x4(%eax)
}
  800b39:	90                   	nop
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    

00800b3c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b45:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b4c:	00 00 00 
	b.cnt = 0;
  800b4f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b56:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b59:	ff 75 0c             	pushl  0xc(%ebp)
  800b5c:	ff 75 08             	pushl  0x8(%ebp)
  800b5f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b65:	50                   	push   %eax
  800b66:	68 d3 0a 80 00       	push   $0x800ad3
  800b6b:	e8 11 02 00 00       	call   800d81 <vprintfmt>
  800b70:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b73:	a0 28 50 80 00       	mov    0x805028,%al
  800b78:	0f b6 c0             	movzbl %al,%eax
  800b7b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	50                   	push   %eax
  800b85:	52                   	push   %edx
  800b86:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8c:	83 c0 08             	add    $0x8,%eax
  800b8f:	50                   	push   %eax
  800b90:	e8 8e 13 00 00       	call   801f23 <sys_cputs>
  800b95:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b98:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800b9f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800bad:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800bb4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	83 ec 08             	sub    $0x8,%esp
  800bc0:	ff 75 f4             	pushl  -0xc(%ebp)
  800bc3:	50                   	push   %eax
  800bc4:	e8 73 ff ff ff       	call   800b3c <vcprintf>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bd2:	c9                   	leave  
  800bd3:	c3                   	ret    

00800bd4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800bda:	e8 f2 14 00 00       	call   8020d1 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800bdf:	8d 45 0c             	lea    0xc(%ebp),%eax
  800be2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800be5:	8b 45 08             	mov    0x8(%ebp),%eax
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 f4             	pushl  -0xc(%ebp)
  800bee:	50                   	push   %eax
  800bef:	e8 48 ff ff ff       	call   800b3c <vcprintf>
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800bfa:	e8 ec 14 00 00       	call   8020eb <sys_enable_interrupt>
	return cnt;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	53                   	push   %ebx
  800c08:	83 ec 14             	sub    $0x14,%esp
  800c0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c11:	8b 45 14             	mov    0x14(%ebp),%eax
  800c14:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c17:	8b 45 18             	mov    0x18(%ebp),%eax
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c22:	77 55                	ja     800c79 <printnum+0x75>
  800c24:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800c27:	72 05                	jb     800c2e <printnum+0x2a>
  800c29:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c2c:	77 4b                	ja     800c79 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c2e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c31:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800c34:	8b 45 18             	mov    0x18(%ebp),%eax
  800c37:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	ff 75 f4             	pushl  -0xc(%ebp)
  800c41:	ff 75 f0             	pushl  -0x10(%ebp)
  800c44:	e8 63 2a 00 00       	call   8036ac <__udivdi3>
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	83 ec 04             	sub    $0x4,%esp
  800c4f:	ff 75 20             	pushl  0x20(%ebp)
  800c52:	53                   	push   %ebx
  800c53:	ff 75 18             	pushl  0x18(%ebp)
  800c56:	52                   	push   %edx
  800c57:	50                   	push   %eax
  800c58:	ff 75 0c             	pushl  0xc(%ebp)
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 a1 ff ff ff       	call   800c04 <printnum>
  800c63:	83 c4 20             	add    $0x20,%esp
  800c66:	eb 1a                	jmp    800c82 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c68:	83 ec 08             	sub    $0x8,%esp
  800c6b:	ff 75 0c             	pushl  0xc(%ebp)
  800c6e:	ff 75 20             	pushl  0x20(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	ff d0                	call   *%eax
  800c76:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c79:	ff 4d 1c             	decl   0x1c(%ebp)
  800c7c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c80:	7f e6                	jg     800c68 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c82:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c90:	53                   	push   %ebx
  800c91:	51                   	push   %ecx
  800c92:	52                   	push   %edx
  800c93:	50                   	push   %eax
  800c94:	e8 23 2b 00 00       	call   8037bc <__umoddi3>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	05 14 3f 80 00       	add    $0x803f14,%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	0f be c0             	movsbl %al,%eax
  800ca6:	83 ec 08             	sub    $0x8,%esp
  800ca9:	ff 75 0c             	pushl  0xc(%ebp)
  800cac:	50                   	push   %eax
  800cad:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb0:	ff d0                	call   *%eax
  800cb2:	83 c4 10             	add    $0x10,%esp
}
  800cb5:	90                   	nop
  800cb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cb9:	c9                   	leave  
  800cba:	c3                   	ret    

00800cbb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800cbe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cc2:	7e 1c                	jle    800ce0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8b 00                	mov    (%eax),%eax
  800cc9:	8d 50 08             	lea    0x8(%eax),%edx
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	89 10                	mov    %edx,(%eax)
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	8b 00                	mov    (%eax),%eax
  800cd6:	83 e8 08             	sub    $0x8,%eax
  800cd9:	8b 50 04             	mov    0x4(%eax),%edx
  800cdc:	8b 00                	mov    (%eax),%eax
  800cde:	eb 40                	jmp    800d20 <getuint+0x65>
	else if (lflag)
  800ce0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce4:	74 1e                	je     800d04 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8b 00                	mov    (%eax),%eax
  800ceb:	8d 50 04             	lea    0x4(%eax),%edx
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 10                	mov    %edx,(%eax)
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	8b 00                	mov    (%eax),%eax
  800cf8:	83 e8 04             	sub    $0x4,%eax
  800cfb:	8b 00                	mov    (%eax),%eax
  800cfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800d02:	eb 1c                	jmp    800d20 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	8d 50 04             	lea    0x4(%eax),%edx
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	89 10                	mov    %edx,(%eax)
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	83 e8 04             	sub    $0x4,%eax
  800d19:	8b 00                	mov    (%eax),%eax
  800d1b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d25:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d29:	7e 1c                	jle    800d47 <getint+0x25>
		return va_arg(*ap, long long);
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 00                	mov    (%eax),%eax
  800d30:	8d 50 08             	lea    0x8(%eax),%edx
  800d33:	8b 45 08             	mov    0x8(%ebp),%eax
  800d36:	89 10                	mov    %edx,(%eax)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	83 e8 08             	sub    $0x8,%eax
  800d40:	8b 50 04             	mov    0x4(%eax),%edx
  800d43:	8b 00                	mov    (%eax),%eax
  800d45:	eb 38                	jmp    800d7f <getint+0x5d>
	else if (lflag)
  800d47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d4b:	74 1a                	je     800d67 <getint+0x45>
		return va_arg(*ap, long);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 00                	mov    (%eax),%eax
  800d52:	8d 50 04             	lea    0x4(%eax),%edx
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 10                	mov    %edx,(%eax)
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	8b 00                	mov    (%eax),%eax
  800d5f:	83 e8 04             	sub    $0x4,%eax
  800d62:	8b 00                	mov    (%eax),%eax
  800d64:	99                   	cltd   
  800d65:	eb 18                	jmp    800d7f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8b 00                	mov    (%eax),%eax
  800d6c:	8d 50 04             	lea    0x4(%eax),%edx
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	89 10                	mov    %edx,(%eax)
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	8b 00                	mov    (%eax),%eax
  800d79:	83 e8 04             	sub    $0x4,%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	99                   	cltd   
}
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d89:	eb 17                	jmp    800da2 <vprintfmt+0x21>
			if (ch == '\0')
  800d8b:	85 db                	test   %ebx,%ebx
  800d8d:	0f 84 af 03 00 00    	je     801142 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d93:	83 ec 08             	sub    $0x8,%esp
  800d96:	ff 75 0c             	pushl  0xc(%ebp)
  800d99:	53                   	push   %ebx
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	ff d0                	call   *%eax
  800d9f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	8d 50 01             	lea    0x1(%eax),%edx
  800da8:	89 55 10             	mov    %edx,0x10(%ebp)
  800dab:	8a 00                	mov    (%eax),%al
  800dad:	0f b6 d8             	movzbl %al,%ebx
  800db0:	83 fb 25             	cmp    $0x25,%ebx
  800db3:	75 d6                	jne    800d8b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800db5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800db9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800dc0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800dc7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800dce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dd8:	8d 50 01             	lea    0x1(%eax),%edx
  800ddb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	0f b6 d8             	movzbl %al,%ebx
  800de3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800de6:	83 f8 55             	cmp    $0x55,%eax
  800de9:	0f 87 2b 03 00 00    	ja     80111a <vprintfmt+0x399>
  800def:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  800df6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800df8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800dfc:	eb d7                	jmp    800dd5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800dfe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800e02:	eb d1                	jmp    800dd5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e04:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800e0b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e0e:	89 d0                	mov    %edx,%eax
  800e10:	c1 e0 02             	shl    $0x2,%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	01 c0                	add    %eax,%eax
  800e17:	01 d8                	add    %ebx,%eax
  800e19:	83 e8 30             	sub    $0x30,%eax
  800e1c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800e1f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800e27:	83 fb 2f             	cmp    $0x2f,%ebx
  800e2a:	7e 3e                	jle    800e6a <vprintfmt+0xe9>
  800e2c:	83 fb 39             	cmp    $0x39,%ebx
  800e2f:	7f 39                	jg     800e6a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e31:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800e34:	eb d5                	jmp    800e0b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e36:	8b 45 14             	mov    0x14(%ebp),%eax
  800e39:	83 c0 04             	add    $0x4,%eax
  800e3c:	89 45 14             	mov    %eax,0x14(%ebp)
  800e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e42:	83 e8 04             	sub    $0x4,%eax
  800e45:	8b 00                	mov    (%eax),%eax
  800e47:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800e4a:	eb 1f                	jmp    800e6b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800e4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e50:	79 83                	jns    800dd5 <vprintfmt+0x54>
				width = 0;
  800e52:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e59:	e9 77 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e5e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e65:	e9 6b ff ff ff       	jmp    800dd5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e6a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e6b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e6f:	0f 89 60 ff ff ff    	jns    800dd5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e7b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e82:	e9 4e ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e87:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e8a:	e9 46 ff ff ff       	jmp    800dd5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax
  800ea0:	83 ec 08             	sub    $0x8,%esp
  800ea3:	ff 75 0c             	pushl  0xc(%ebp)
  800ea6:	50                   	push   %eax
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 89 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800eb4:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb7:	83 c0 04             	add    $0x4,%eax
  800eba:	89 45 14             	mov    %eax,0x14(%ebp)
  800ebd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec0:	83 e8 04             	sub    $0x4,%eax
  800ec3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ec5:	85 db                	test   %ebx,%ebx
  800ec7:	79 02                	jns    800ecb <vprintfmt+0x14a>
				err = -err;
  800ec9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ecb:	83 fb 64             	cmp    $0x64,%ebx
  800ece:	7f 0b                	jg     800edb <vprintfmt+0x15a>
  800ed0:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800ed7:	85 f6                	test   %esi,%esi
  800ed9:	75 19                	jne    800ef4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800edb:	53                   	push   %ebx
  800edc:	68 25 3f 80 00       	push   $0x803f25
  800ee1:	ff 75 0c             	pushl  0xc(%ebp)
  800ee4:	ff 75 08             	pushl  0x8(%ebp)
  800ee7:	e8 5e 02 00 00       	call   80114a <printfmt>
  800eec:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800eef:	e9 49 02 00 00       	jmp    80113d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ef4:	56                   	push   %esi
  800ef5:	68 2e 3f 80 00       	push   $0x803f2e
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	ff 75 08             	pushl  0x8(%ebp)
  800f00:	e8 45 02 00 00       	call   80114a <printfmt>
  800f05:	83 c4 10             	add    $0x10,%esp
			break;
  800f08:	e9 30 02 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800f10:	83 c0 04             	add    $0x4,%eax
  800f13:	89 45 14             	mov    %eax,0x14(%ebp)
  800f16:	8b 45 14             	mov    0x14(%ebp),%eax
  800f19:	83 e8 04             	sub    $0x4,%eax
  800f1c:	8b 30                	mov    (%eax),%esi
  800f1e:	85 f6                	test   %esi,%esi
  800f20:	75 05                	jne    800f27 <vprintfmt+0x1a6>
				p = "(null)";
  800f22:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f2b:	7e 6d                	jle    800f9a <vprintfmt+0x219>
  800f2d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f31:	74 67                	je     800f9a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800f33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	50                   	push   %eax
  800f3a:	56                   	push   %esi
  800f3b:	e8 0c 03 00 00       	call   80124c <strnlen>
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800f46:	eb 16                	jmp    800f5e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800f48:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	ff 75 0c             	pushl  0xc(%ebp)
  800f52:	50                   	push   %eax
  800f53:	8b 45 08             	mov    0x8(%ebp),%eax
  800f56:	ff d0                	call   *%eax
  800f58:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f5b:	ff 4d e4             	decl   -0x1c(%ebp)
  800f5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f62:	7f e4                	jg     800f48 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f64:	eb 34                	jmp    800f9a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f66:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f6a:	74 1c                	je     800f88 <vprintfmt+0x207>
  800f6c:	83 fb 1f             	cmp    $0x1f,%ebx
  800f6f:	7e 05                	jle    800f76 <vprintfmt+0x1f5>
  800f71:	83 fb 7e             	cmp    $0x7e,%ebx
  800f74:	7e 12                	jle    800f88 <vprintfmt+0x207>
					putch('?', putdat);
  800f76:	83 ec 08             	sub    $0x8,%esp
  800f79:	ff 75 0c             	pushl  0xc(%ebp)
  800f7c:	6a 3f                	push   $0x3f
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	ff d0                	call   *%eax
  800f83:	83 c4 10             	add    $0x10,%esp
  800f86:	eb 0f                	jmp    800f97 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f88:	83 ec 08             	sub    $0x8,%esp
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	53                   	push   %ebx
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	ff d0                	call   *%eax
  800f94:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f97:	ff 4d e4             	decl   -0x1c(%ebp)
  800f9a:	89 f0                	mov    %esi,%eax
  800f9c:	8d 70 01             	lea    0x1(%eax),%esi
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f be d8             	movsbl %al,%ebx
  800fa4:	85 db                	test   %ebx,%ebx
  800fa6:	74 24                	je     800fcc <vprintfmt+0x24b>
  800fa8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fac:	78 b8                	js     800f66 <vprintfmt+0x1e5>
  800fae:	ff 4d e0             	decl   -0x20(%ebp)
  800fb1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800fb5:	79 af                	jns    800f66 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fb7:	eb 13                	jmp    800fcc <vprintfmt+0x24b>
				putch(' ', putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	6a 20                	push   $0x20
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	ff d0                	call   *%eax
  800fc6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc9:	ff 4d e4             	decl   -0x1c(%ebp)
  800fcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fd0:	7f e7                	jg     800fb9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800fd2:	e9 66 01 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	ff 75 e8             	pushl  -0x18(%ebp)
  800fdd:	8d 45 14             	lea    0x14(%ebp),%eax
  800fe0:	50                   	push   %eax
  800fe1:	e8 3c fd ff ff       	call   800d22 <getint>
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ff2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ff5:	85 d2                	test   %edx,%edx
  800ff7:	79 23                	jns    80101c <vprintfmt+0x29b>
				putch('-', putdat);
  800ff9:	83 ec 08             	sub    $0x8,%esp
  800ffc:	ff 75 0c             	pushl  0xc(%ebp)
  800fff:	6a 2d                	push   $0x2d
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	ff d0                	call   *%eax
  801006:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801009:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80100c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80100f:	f7 d8                	neg    %eax
  801011:	83 d2 00             	adc    $0x0,%edx
  801014:	f7 da                	neg    %edx
  801016:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801019:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80101c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801023:	e9 bc 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801028:	83 ec 08             	sub    $0x8,%esp
  80102b:	ff 75 e8             	pushl  -0x18(%ebp)
  80102e:	8d 45 14             	lea    0x14(%ebp),%eax
  801031:	50                   	push   %eax
  801032:	e8 84 fc ff ff       	call   800cbb <getuint>
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80103d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801040:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801047:	e9 98 00 00 00       	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80104c:	83 ec 08             	sub    $0x8,%esp
  80104f:	ff 75 0c             	pushl  0xc(%ebp)
  801052:	6a 58                	push   $0x58
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	ff d0                	call   *%eax
  801059:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80105c:	83 ec 08             	sub    $0x8,%esp
  80105f:	ff 75 0c             	pushl  0xc(%ebp)
  801062:	6a 58                	push   $0x58
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	ff d0                	call   *%eax
  801069:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80106c:	83 ec 08             	sub    $0x8,%esp
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	6a 58                	push   $0x58
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	ff d0                	call   *%eax
  801079:	83 c4 10             	add    $0x10,%esp
			break;
  80107c:	e9 bc 00 00 00       	jmp    80113d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801081:	83 ec 08             	sub    $0x8,%esp
  801084:	ff 75 0c             	pushl  0xc(%ebp)
  801087:	6a 30                	push   $0x30
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	ff d0                	call   *%eax
  80108e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801091:	83 ec 08             	sub    $0x8,%esp
  801094:	ff 75 0c             	pushl  0xc(%ebp)
  801097:	6a 78                	push   $0x78
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	ff d0                	call   *%eax
  80109e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8010a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a4:	83 c0 04             	add    $0x4,%eax
  8010a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8010aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ad:	83 e8 04             	sub    $0x4,%eax
  8010b0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8010b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8010bc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8010c3:	eb 1f                	jmp    8010e4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8010c5:	83 ec 08             	sub    $0x8,%esp
  8010c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8010cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	e8 e7 fb ff ff       	call   800cbb <getuint>
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8010dd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8010e4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8010e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8010eb:	83 ec 04             	sub    $0x4,%esp
  8010ee:	52                   	push   %edx
  8010ef:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f2:	50                   	push   %eax
  8010f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8010f9:	ff 75 0c             	pushl  0xc(%ebp)
  8010fc:	ff 75 08             	pushl  0x8(%ebp)
  8010ff:	e8 00 fb ff ff       	call   800c04 <printnum>
  801104:	83 c4 20             	add    $0x20,%esp
			break;
  801107:	eb 34                	jmp    80113d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801109:	83 ec 08             	sub    $0x8,%esp
  80110c:	ff 75 0c             	pushl  0xc(%ebp)
  80110f:	53                   	push   %ebx
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	ff d0                	call   *%eax
  801115:	83 c4 10             	add    $0x10,%esp
			break;
  801118:	eb 23                	jmp    80113d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80111a:	83 ec 08             	sub    $0x8,%esp
  80111d:	ff 75 0c             	pushl  0xc(%ebp)
  801120:	6a 25                	push   $0x25
  801122:	8b 45 08             	mov    0x8(%ebp),%eax
  801125:	ff d0                	call   *%eax
  801127:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80112a:	ff 4d 10             	decl   0x10(%ebp)
  80112d:	eb 03                	jmp    801132 <vprintfmt+0x3b1>
  80112f:	ff 4d 10             	decl   0x10(%ebp)
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	48                   	dec    %eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 25                	cmp    $0x25,%al
  80113a:	75 f3                	jne    80112f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80113c:	90                   	nop
		}
	}
  80113d:	e9 47 fc ff ff       	jmp    800d89 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801142:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801143:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801150:	8d 45 10             	lea    0x10(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	ff 75 f4             	pushl  -0xc(%ebp)
  80115f:	50                   	push   %eax
  801160:	ff 75 0c             	pushl  0xc(%ebp)
  801163:	ff 75 08             	pushl  0x8(%ebp)
  801166:	e8 16 fc ff ff       	call   800d81 <vprintfmt>
  80116b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80116e:	90                   	nop
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801174:	8b 45 0c             	mov    0xc(%ebp),%eax
  801177:	8b 40 08             	mov    0x8(%eax),%eax
  80117a:	8d 50 01             	lea    0x1(%eax),%edx
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	8b 10                	mov    (%eax),%edx
  801188:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118b:	8b 40 04             	mov    0x4(%eax),%eax
  80118e:	39 c2                	cmp    %eax,%edx
  801190:	73 12                	jae    8011a4 <sprintputch+0x33>
		*b->buf++ = ch;
  801192:	8b 45 0c             	mov    0xc(%ebp),%eax
  801195:	8b 00                	mov    (%eax),%eax
  801197:	8d 48 01             	lea    0x1(%eax),%ecx
  80119a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80119d:	89 0a                	mov    %ecx,(%edx)
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	88 10                	mov    %dl,(%eax)
}
  8011a4:	90                   	nop
  8011a5:	5d                   	pop    %ebp
  8011a6:	c3                   	ret    

008011a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8011c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011cc:	74 06                	je     8011d4 <vsnprintf+0x2d>
  8011ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d2:	7f 07                	jg     8011db <vsnprintf+0x34>
		return -E_INVAL;
  8011d4:	b8 03 00 00 00       	mov    $0x3,%eax
  8011d9:	eb 20                	jmp    8011fb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011db:	ff 75 14             	pushl  0x14(%ebp)
  8011de:	ff 75 10             	pushl  0x10(%ebp)
  8011e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011e4:	50                   	push   %eax
  8011e5:	68 71 11 80 00       	push   $0x801171
  8011ea:	e8 92 fb ff ff       	call   800d81 <vprintfmt>
  8011ef:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8011f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011f5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011fb:	c9                   	leave  
  8011fc:	c3                   	ret    

008011fd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801203:	8d 45 10             	lea    0x10(%ebp),%eax
  801206:	83 c0 04             	add    $0x4,%eax
  801209:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80120c:	8b 45 10             	mov    0x10(%ebp),%eax
  80120f:	ff 75 f4             	pushl  -0xc(%ebp)
  801212:	50                   	push   %eax
  801213:	ff 75 0c             	pushl  0xc(%ebp)
  801216:	ff 75 08             	pushl  0x8(%ebp)
  801219:	e8 89 ff ff ff       	call   8011a7 <vsnprintf>
  80121e:	83 c4 10             	add    $0x10,%esp
  801221:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801224:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801227:	c9                   	leave  
  801228:	c3                   	ret    

00801229 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801229:	55                   	push   %ebp
  80122a:	89 e5                	mov    %esp,%ebp
  80122c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80122f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801236:	eb 06                	jmp    80123e <strlen+0x15>
		n++;
  801238:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	75 f1                	jne    801238 <strlen+0xf>
		n++;
	return n;
  801247:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80124a:	c9                   	leave  
  80124b:	c3                   	ret    

0080124c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801259:	eb 09                	jmp    801264 <strnlen+0x18>
		n++;
  80125b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80125e:	ff 45 08             	incl   0x8(%ebp)
  801261:	ff 4d 0c             	decl   0xc(%ebp)
  801264:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801268:	74 09                	je     801273 <strnlen+0x27>
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	75 e8                	jne    80125b <strnlen+0xf>
		n++;
	return n;
  801273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801276:	c9                   	leave  
  801277:	c3                   	ret    

00801278 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801278:	55                   	push   %ebp
  801279:	89 e5                	mov    %esp,%ebp
  80127b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801284:	90                   	nop
  801285:	8b 45 08             	mov    0x8(%ebp),%eax
  801288:	8d 50 01             	lea    0x1(%eax),%edx
  80128b:	89 55 08             	mov    %edx,0x8(%ebp)
  80128e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801291:	8d 4a 01             	lea    0x1(%edx),%ecx
  801294:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801297:	8a 12                	mov    (%edx),%dl
  801299:	88 10                	mov    %dl,(%eax)
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	84 c0                	test   %al,%al
  80129f:	75 e4                	jne    801285 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012a4:	c9                   	leave  
  8012a5:	c3                   	ret    

008012a6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012b9:	eb 1f                	jmp    8012da <strncpy+0x34>
		*dst++ = *src;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	8d 50 01             	lea    0x1(%eax),%edx
  8012c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c7:	8a 12                	mov    (%edx),%dl
  8012c9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	8a 00                	mov    (%eax),%al
  8012d0:	84 c0                	test   %al,%al
  8012d2:	74 03                	je     8012d7 <strncpy+0x31>
			src++;
  8012d4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012d7:	ff 45 fc             	incl   -0x4(%ebp)
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012dd:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012e0:	72 d9                	jb     8012bb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8012e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8012f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012f7:	74 30                	je     801329 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8012f9:	eb 16                	jmp    801311 <strlcpy+0x2a>
			*dst++ = *src++;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	8d 50 01             	lea    0x1(%eax),%edx
  801301:	89 55 08             	mov    %edx,0x8(%ebp)
  801304:	8b 55 0c             	mov    0xc(%ebp),%edx
  801307:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80130d:	8a 12                	mov    (%edx),%dl
  80130f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801311:	ff 4d 10             	decl   0x10(%ebp)
  801314:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801318:	74 09                	je     801323 <strlcpy+0x3c>
  80131a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131d:	8a 00                	mov    (%eax),%al
  80131f:	84 c0                	test   %al,%al
  801321:	75 d8                	jne    8012fb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801329:	8b 55 08             	mov    0x8(%ebp),%edx
  80132c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132f:	29 c2                	sub    %eax,%edx
  801331:	89 d0                	mov    %edx,%eax
}
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801338:	eb 06                	jmp    801340 <strcmp+0xb>
		p++, q++;
  80133a:	ff 45 08             	incl   0x8(%ebp)
  80133d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	84 c0                	test   %al,%al
  801347:	74 0e                	je     801357 <strcmp+0x22>
  801349:	8b 45 08             	mov    0x8(%ebp),%eax
  80134c:	8a 10                	mov    (%eax),%dl
  80134e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801351:	8a 00                	mov    (%eax),%al
  801353:	38 c2                	cmp    %al,%dl
  801355:	74 e3                	je     80133a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801357:	8b 45 08             	mov    0x8(%ebp),%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	0f b6 d0             	movzbl %al,%edx
  80135f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801362:	8a 00                	mov    (%eax),%al
  801364:	0f b6 c0             	movzbl %al,%eax
  801367:	29 c2                	sub    %eax,%edx
  801369:	89 d0                	mov    %edx,%eax
}
  80136b:	5d                   	pop    %ebp
  80136c:	c3                   	ret    

0080136d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801370:	eb 09                	jmp    80137b <strncmp+0xe>
		n--, p++, q++;
  801372:	ff 4d 10             	decl   0x10(%ebp)
  801375:	ff 45 08             	incl   0x8(%ebp)
  801378:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80137b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80137f:	74 17                	je     801398 <strncmp+0x2b>
  801381:	8b 45 08             	mov    0x8(%ebp),%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	84 c0                	test   %al,%al
  801388:	74 0e                	je     801398 <strncmp+0x2b>
  80138a:	8b 45 08             	mov    0x8(%ebp),%eax
  80138d:	8a 10                	mov    (%eax),%dl
  80138f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	38 c2                	cmp    %al,%dl
  801396:	74 da                	je     801372 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801398:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80139c:	75 07                	jne    8013a5 <strncmp+0x38>
		return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 14                	jmp    8013b9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	0f b6 d0             	movzbl %al,%edx
  8013ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	0f b6 c0             	movzbl %al,%eax
  8013b5:	29 c2                	sub    %eax,%edx
  8013b7:	89 d0                	mov    %edx,%eax
}
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013c7:	eb 12                	jmp    8013db <strchr+0x20>
		if (*s == c)
  8013c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8013d1:	75 05                	jne    8013d8 <strchr+0x1d>
			return (char *) s;
  8013d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d6:	eb 11                	jmp    8013e9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8013d8:	ff 45 08             	incl   0x8(%ebp)
  8013db:	8b 45 08             	mov    0x8(%ebp),%eax
  8013de:	8a 00                	mov    (%eax),%al
  8013e0:	84 c0                	test   %al,%al
  8013e2:	75 e5                	jne    8013c9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8013e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013e9:	c9                   	leave  
  8013ea:	c3                   	ret    

008013eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	83 ec 04             	sub    $0x4,%esp
  8013f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8013f7:	eb 0d                	jmp    801406 <strfind+0x1b>
		if (*s == c)
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	8a 00                	mov    (%eax),%al
  8013fe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801401:	74 0e                	je     801411 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	8b 45 08             	mov    0x8(%ebp),%eax
  801409:	8a 00                	mov    (%eax),%al
  80140b:	84 c0                	test   %al,%al
  80140d:	75 ea                	jne    8013f9 <strfind+0xe>
  80140f:	eb 01                	jmp    801412 <strfind+0x27>
		if (*s == c)
			break;
  801411:	90                   	nop
	return (char *) s;
  801412:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801423:	8b 45 10             	mov    0x10(%ebp),%eax
  801426:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801429:	eb 0e                	jmp    801439 <memset+0x22>
		*p++ = c;
  80142b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142e:	8d 50 01             	lea    0x1(%eax),%edx
  801431:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801434:	8b 55 0c             	mov    0xc(%ebp),%edx
  801437:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801439:	ff 4d f8             	decl   -0x8(%ebp)
  80143c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801440:	79 e9                	jns    80142b <memset+0x14>
		*p++ = c;

	return v;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801445:	c9                   	leave  
  801446:	c3                   	ret    

00801447 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80144d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801450:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801459:	eb 16                	jmp    801471 <memcpy+0x2a>
		*d++ = *s++;
  80145b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145e:	8d 50 01             	lea    0x1(%eax),%edx
  801461:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801464:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801467:	8d 4a 01             	lea    0x1(%edx),%ecx
  80146a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80146d:	8a 12                	mov    (%edx),%dl
  80146f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801471:	8b 45 10             	mov    0x10(%ebp),%eax
  801474:	8d 50 ff             	lea    -0x1(%eax),%edx
  801477:	89 55 10             	mov    %edx,0x10(%ebp)
  80147a:	85 c0                	test   %eax,%eax
  80147c:	75 dd                	jne    80145b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80147e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80148c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801495:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801498:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80149b:	73 50                	jae    8014ed <memmove+0x6a>
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014a8:	76 43                	jbe    8014ed <memmove+0x6a>
		s += n;
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014b6:	eb 10                	jmp    8014c8 <memmove+0x45>
			*--d = *--s;
  8014b8:	ff 4d f8             	decl   -0x8(%ebp)
  8014bb:	ff 4d fc             	decl   -0x4(%ebp)
  8014be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014c1:	8a 10                	mov    (%eax),%dl
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8014c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	75 e3                	jne    8014b8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8014d5:	eb 23                	jmp    8014fa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8014d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014da:	8d 50 01             	lea    0x1(%eax),%edx
  8014dd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014e6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014e9:	8a 12                	mov    (%edx),%dl
  8014eb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8014f6:	85 c0                	test   %eax,%eax
  8014f8:	75 dd                	jne    8014d7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014fd:	c9                   	leave  
  8014fe:	c3                   	ret    

008014ff <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8014ff:	55                   	push   %ebp
  801500:	89 e5                	mov    %esp,%ebp
  801502:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80150b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801511:	eb 2a                	jmp    80153d <memcmp+0x3e>
		if (*s1 != *s2)
  801513:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801516:	8a 10                	mov    (%eax),%dl
  801518:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151b:	8a 00                	mov    (%eax),%al
  80151d:	38 c2                	cmp    %al,%dl
  80151f:	74 16                	je     801537 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801524:	8a 00                	mov    (%eax),%al
  801526:	0f b6 d0             	movzbl %al,%edx
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	8a 00                	mov    (%eax),%al
  80152e:	0f b6 c0             	movzbl %al,%eax
  801531:	29 c2                	sub    %eax,%edx
  801533:	89 d0                	mov    %edx,%eax
  801535:	eb 18                	jmp    80154f <memcmp+0x50>
		s1++, s2++;
  801537:	ff 45 fc             	incl   -0x4(%ebp)
  80153a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80153d:	8b 45 10             	mov    0x10(%ebp),%eax
  801540:	8d 50 ff             	lea    -0x1(%eax),%edx
  801543:	89 55 10             	mov    %edx,0x10(%ebp)
  801546:	85 c0                	test   %eax,%eax
  801548:	75 c9                	jne    801513 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80154a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801557:	8b 55 08             	mov    0x8(%ebp),%edx
  80155a:	8b 45 10             	mov    0x10(%ebp),%eax
  80155d:	01 d0                	add    %edx,%eax
  80155f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801562:	eb 15                	jmp    801579 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	8a 00                	mov    (%eax),%al
  801569:	0f b6 d0             	movzbl %al,%edx
  80156c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156f:	0f b6 c0             	movzbl %al,%eax
  801572:	39 c2                	cmp    %eax,%edx
  801574:	74 0d                	je     801583 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801576:	ff 45 08             	incl   0x8(%ebp)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80157f:	72 e3                	jb     801564 <memfind+0x13>
  801581:	eb 01                	jmp    801584 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801583:	90                   	nop
	return (void *) s;
  801584:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801587:	c9                   	leave  
  801588:	c3                   	ret    

00801589 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80158f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801596:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80159d:	eb 03                	jmp    8015a2 <strtol+0x19>
		s++;
  80159f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8a 00                	mov    (%eax),%al
  8015a7:	3c 20                	cmp    $0x20,%al
  8015a9:	74 f4                	je     80159f <strtol+0x16>
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	3c 09                	cmp    $0x9,%al
  8015b2:	74 eb                	je     80159f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b7:	8a 00                	mov    (%eax),%al
  8015b9:	3c 2b                	cmp    $0x2b,%al
  8015bb:	75 05                	jne    8015c2 <strtol+0x39>
		s++;
  8015bd:	ff 45 08             	incl   0x8(%ebp)
  8015c0:	eb 13                	jmp    8015d5 <strtol+0x4c>
	else if (*s == '-')
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	3c 2d                	cmp    $0x2d,%al
  8015c9:	75 0a                	jne    8015d5 <strtol+0x4c>
		s++, neg = 1;
  8015cb:	ff 45 08             	incl   0x8(%ebp)
  8015ce:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8015d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015d9:	74 06                	je     8015e1 <strtol+0x58>
  8015db:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015df:	75 20                	jne    801601 <strtol+0x78>
  8015e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e4:	8a 00                	mov    (%eax),%al
  8015e6:	3c 30                	cmp    $0x30,%al
  8015e8:	75 17                	jne    801601 <strtol+0x78>
  8015ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ed:	40                   	inc    %eax
  8015ee:	8a 00                	mov    (%eax),%al
  8015f0:	3c 78                	cmp    $0x78,%al
  8015f2:	75 0d                	jne    801601 <strtol+0x78>
		s += 2, base = 16;
  8015f4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8015f8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8015ff:	eb 28                	jmp    801629 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801601:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801605:	75 15                	jne    80161c <strtol+0x93>
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	8a 00                	mov    (%eax),%al
  80160c:	3c 30                	cmp    $0x30,%al
  80160e:	75 0c                	jne    80161c <strtol+0x93>
		s++, base = 8;
  801610:	ff 45 08             	incl   0x8(%ebp)
  801613:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80161a:	eb 0d                	jmp    801629 <strtol+0xa0>
	else if (base == 0)
  80161c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801620:	75 07                	jne    801629 <strtol+0xa0>
		base = 10;
  801622:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8a 00                	mov    (%eax),%al
  80162e:	3c 2f                	cmp    $0x2f,%al
  801630:	7e 19                	jle    80164b <strtol+0xc2>
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	8a 00                	mov    (%eax),%al
  801637:	3c 39                	cmp    $0x39,%al
  801639:	7f 10                	jg     80164b <strtol+0xc2>
			dig = *s - '0';
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8a 00                	mov    (%eax),%al
  801640:	0f be c0             	movsbl %al,%eax
  801643:	83 e8 30             	sub    $0x30,%eax
  801646:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801649:	eb 42                	jmp    80168d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8a 00                	mov    (%eax),%al
  801650:	3c 60                	cmp    $0x60,%al
  801652:	7e 19                	jle    80166d <strtol+0xe4>
  801654:	8b 45 08             	mov    0x8(%ebp),%eax
  801657:	8a 00                	mov    (%eax),%al
  801659:	3c 7a                	cmp    $0x7a,%al
  80165b:	7f 10                	jg     80166d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80165d:	8b 45 08             	mov    0x8(%ebp),%eax
  801660:	8a 00                	mov    (%eax),%al
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 57             	sub    $0x57,%eax
  801668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166b:	eb 20                	jmp    80168d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	8a 00                	mov    (%eax),%al
  801672:	3c 40                	cmp    $0x40,%al
  801674:	7e 39                	jle    8016af <strtol+0x126>
  801676:	8b 45 08             	mov    0x8(%ebp),%eax
  801679:	8a 00                	mov    (%eax),%al
  80167b:	3c 5a                	cmp    $0x5a,%al
  80167d:	7f 30                	jg     8016af <strtol+0x126>
			dig = *s - 'A' + 10;
  80167f:	8b 45 08             	mov    0x8(%ebp),%eax
  801682:	8a 00                	mov    (%eax),%al
  801684:	0f be c0             	movsbl %al,%eax
  801687:	83 e8 37             	sub    $0x37,%eax
  80168a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80168d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801690:	3b 45 10             	cmp    0x10(%ebp),%eax
  801693:	7d 19                	jge    8016ae <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801695:	ff 45 08             	incl   0x8(%ebp)
  801698:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a4:	01 d0                	add    %edx,%eax
  8016a6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016a9:	e9 7b ff ff ff       	jmp    801629 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016ae:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b3:	74 08                	je     8016bd <strtol+0x134>
		*endptr = (char *) s;
  8016b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8016bb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016bd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016c1:	74 07                	je     8016ca <strtol+0x141>
  8016c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c6:	f7 d8                	neg    %eax
  8016c8:	eb 03                	jmp    8016cd <strtol+0x144>
  8016ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016cd:	c9                   	leave  
  8016ce:	c3                   	ret    

008016cf <ltostr>:

void
ltostr(long value, char *str)
{
  8016cf:	55                   	push   %ebp
  8016d0:	89 e5                	mov    %esp,%ebp
  8016d2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8016d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8016dc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8016e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016e7:	79 13                	jns    8016fc <ltostr+0x2d>
	{
		neg = 1;
  8016e9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8016f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8016f6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8016f9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801704:	99                   	cltd   
  801705:	f7 f9                	idiv   %ecx
  801707:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80170a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80170d:	8d 50 01             	lea    0x1(%eax),%edx
  801710:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801713:	89 c2                	mov    %eax,%edx
  801715:	8b 45 0c             	mov    0xc(%ebp),%eax
  801718:	01 d0                	add    %edx,%eax
  80171a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80171d:	83 c2 30             	add    $0x30,%edx
  801720:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801722:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801725:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80172a:	f7 e9                	imul   %ecx
  80172c:	c1 fa 02             	sar    $0x2,%edx
  80172f:	89 c8                	mov    %ecx,%eax
  801731:	c1 f8 1f             	sar    $0x1f,%eax
  801734:	29 c2                	sub    %eax,%edx
  801736:	89 d0                	mov    %edx,%eax
  801738:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80173b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80173e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801743:	f7 e9                	imul   %ecx
  801745:	c1 fa 02             	sar    $0x2,%edx
  801748:	89 c8                	mov    %ecx,%eax
  80174a:	c1 f8 1f             	sar    $0x1f,%eax
  80174d:	29 c2                	sub    %eax,%edx
  80174f:	89 d0                	mov    %edx,%eax
  801751:	c1 e0 02             	shl    $0x2,%eax
  801754:	01 d0                	add    %edx,%eax
  801756:	01 c0                	add    %eax,%eax
  801758:	29 c1                	sub    %eax,%ecx
  80175a:	89 ca                	mov    %ecx,%edx
  80175c:	85 d2                	test   %edx,%edx
  80175e:	75 9c                	jne    8016fc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801760:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801767:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80176a:	48                   	dec    %eax
  80176b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80176e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801772:	74 3d                	je     8017b1 <ltostr+0xe2>
		start = 1 ;
  801774:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80177b:	eb 34                	jmp    8017b1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80177d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801780:	8b 45 0c             	mov    0xc(%ebp),%eax
  801783:	01 d0                	add    %edx,%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801790:	01 c2                	add    %eax,%edx
  801792:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801795:	8b 45 0c             	mov    0xc(%ebp),%eax
  801798:	01 c8                	add    %ecx,%eax
  80179a:	8a 00                	mov    (%eax),%al
  80179c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80179e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a4:	01 c2                	add    %eax,%edx
  8017a6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017a9:	88 02                	mov    %al,(%edx)
		start++ ;
  8017ab:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017ae:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017b7:	7c c4                	jl     80177d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017b9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bf:	01 d0                	add    %edx,%eax
  8017c1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017c4:	90                   	nop
  8017c5:	c9                   	leave  
  8017c6:	c3                   	ret    

008017c7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8017cd:	ff 75 08             	pushl  0x8(%ebp)
  8017d0:	e8 54 fa ff ff       	call   801229 <strlen>
  8017d5:	83 c4 04             	add    $0x4,%esp
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8017db:	ff 75 0c             	pushl  0xc(%ebp)
  8017de:	e8 46 fa ff ff       	call   801229 <strlen>
  8017e3:	83 c4 04             	add    $0x4,%esp
  8017e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8017e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8017f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8017f7:	eb 17                	jmp    801810 <strcconcat+0x49>
		final[s] = str1[s] ;
  8017f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ff:	01 c2                	add    %eax,%edx
  801801:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	01 c8                	add    %ecx,%eax
  801809:	8a 00                	mov    (%eax),%al
  80180b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80180d:	ff 45 fc             	incl   -0x4(%ebp)
  801810:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801813:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801816:	7c e1                	jl     8017f9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801818:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80181f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801826:	eb 1f                	jmp    801847 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801828:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801831:	89 c2                	mov    %eax,%edx
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	01 c2                	add    %eax,%edx
  801838:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80183b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183e:	01 c8                	add    %ecx,%eax
  801840:	8a 00                	mov    (%eax),%al
  801842:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801844:	ff 45 f8             	incl   -0x8(%ebp)
  801847:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80184d:	7c d9                	jl     801828 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80184f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c6 00 00             	movb   $0x0,(%eax)
}
  80185a:	90                   	nop
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801860:	8b 45 14             	mov    0x14(%ebp),%eax
  801863:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801869:	8b 45 14             	mov    0x14(%ebp),%eax
  80186c:	8b 00                	mov    (%eax),%eax
  80186e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801875:	8b 45 10             	mov    0x10(%ebp),%eax
  801878:	01 d0                	add    %edx,%eax
  80187a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801880:	eb 0c                	jmp    80188e <strsplit+0x31>
			*string++ = 0;
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	8d 50 01             	lea    0x1(%eax),%edx
  801888:	89 55 08             	mov    %edx,0x8(%ebp)
  80188b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
  801891:	8a 00                	mov    (%eax),%al
  801893:	84 c0                	test   %al,%al
  801895:	74 18                	je     8018af <strsplit+0x52>
  801897:	8b 45 08             	mov    0x8(%ebp),%eax
  80189a:	8a 00                	mov    (%eax),%al
  80189c:	0f be c0             	movsbl %al,%eax
  80189f:	50                   	push   %eax
  8018a0:	ff 75 0c             	pushl  0xc(%ebp)
  8018a3:	e8 13 fb ff ff       	call   8013bb <strchr>
  8018a8:	83 c4 08             	add    $0x8,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	75 d3                	jne    801882 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	8a 00                	mov    (%eax),%al
  8018b4:	84 c0                	test   %al,%al
  8018b6:	74 5a                	je     801912 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8018bb:	8b 00                	mov    (%eax),%eax
  8018bd:	83 f8 0f             	cmp    $0xf,%eax
  8018c0:	75 07                	jne    8018c9 <strsplit+0x6c>
		{
			return 0;
  8018c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c7:	eb 66                	jmp    80192f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8018c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8018cc:	8b 00                	mov    (%eax),%eax
  8018ce:	8d 48 01             	lea    0x1(%eax),%ecx
  8018d1:	8b 55 14             	mov    0x14(%ebp),%edx
  8018d4:	89 0a                	mov    %ecx,(%edx)
  8018d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8018e0:	01 c2                	add    %eax,%edx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018e7:	eb 03                	jmp    8018ec <strsplit+0x8f>
			string++;
  8018e9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	8a 00                	mov    (%eax),%al
  8018f1:	84 c0                	test   %al,%al
  8018f3:	74 8b                	je     801880 <strsplit+0x23>
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8a 00                	mov    (%eax),%al
  8018fa:	0f be c0             	movsbl %al,%eax
  8018fd:	50                   	push   %eax
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	e8 b5 fa ff ff       	call   8013bb <strchr>
  801906:	83 c4 08             	add    $0x8,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	74 dc                	je     8018e9 <strsplit+0x8c>
			string++;
	}
  80190d:	e9 6e ff ff ff       	jmp    801880 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801912:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801913:	8b 45 14             	mov    0x14(%ebp),%eax
  801916:	8b 00                	mov    (%eax),%eax
  801918:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	01 d0                	add    %edx,%eax
  801924:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80192a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801937:	a1 04 50 80 00       	mov    0x805004,%eax
  80193c:	85 c0                	test   %eax,%eax
  80193e:	74 1f                	je     80195f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801940:	e8 1d 00 00 00       	call   801962 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801945:	83 ec 0c             	sub    $0xc,%esp
  801948:	68 90 40 80 00       	push   $0x804090
  80194d:	e8 55 f2 ff ff       	call   800ba7 <cprintf>
  801952:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801955:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80195c:	00 00 00 
	}
}
  80195f:	90                   	nop
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
  801965:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801968:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80196f:	00 00 00 
  801972:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801979:	00 00 00 
  80197c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801983:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801986:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80198d:	00 00 00 
  801990:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801997:	00 00 00 
  80199a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019a1:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8019a4:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8019ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ae:	c1 e8 0c             	shr    $0xc,%eax
  8019b1:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8019b6:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8019bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019c5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8019ca:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  8019cf:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8019d6:	a1 20 51 80 00       	mov    0x805120,%eax
  8019db:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8019df:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8019e2:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8019e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8019ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019ef:	01 d0                	add    %edx,%eax
  8019f1:	48                   	dec    %eax
  8019f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fd:	f7 75 e4             	divl   -0x1c(%ebp)
  801a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a03:	29 d0                	sub    %edx,%eax
  801a05:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801a08:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801a0f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a17:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	6a 07                	push   $0x7
  801a21:	ff 75 e8             	pushl  -0x18(%ebp)
  801a24:	50                   	push   %eax
  801a25:	e8 3d 06 00 00       	call   802067 <sys_allocate_chunk>
  801a2a:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a2d:	a1 20 51 80 00       	mov    0x805120,%eax
  801a32:	83 ec 0c             	sub    $0xc,%esp
  801a35:	50                   	push   %eax
  801a36:	e8 b2 0c 00 00       	call   8026ed <initialize_MemBlocksList>
  801a3b:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801a3e:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801a43:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801a46:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a4a:	0f 84 f3 00 00 00    	je     801b43 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801a50:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a54:	75 14                	jne    801a6a <initialize_dyn_block_system+0x108>
  801a56:	83 ec 04             	sub    $0x4,%esp
  801a59:	68 b5 40 80 00       	push   $0x8040b5
  801a5e:	6a 36                	push   $0x36
  801a60:	68 d3 40 80 00       	push   $0x8040d3
  801a65:	e8 89 ee ff ff       	call   8008f3 <_panic>
  801a6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a6d:	8b 00                	mov    (%eax),%eax
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	74 10                	je     801a83 <initialize_dyn_block_system+0x121>
  801a73:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a76:	8b 00                	mov    (%eax),%eax
  801a78:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a7b:	8b 52 04             	mov    0x4(%edx),%edx
  801a7e:	89 50 04             	mov    %edx,0x4(%eax)
  801a81:	eb 0b                	jmp    801a8e <initialize_dyn_block_system+0x12c>
  801a83:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a86:	8b 40 04             	mov    0x4(%eax),%eax
  801a89:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801a8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a91:	8b 40 04             	mov    0x4(%eax),%eax
  801a94:	85 c0                	test   %eax,%eax
  801a96:	74 0f                	je     801aa7 <initialize_dyn_block_system+0x145>
  801a98:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a9b:	8b 40 04             	mov    0x4(%eax),%eax
  801a9e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801aa1:	8b 12                	mov    (%edx),%edx
  801aa3:	89 10                	mov    %edx,(%eax)
  801aa5:	eb 0a                	jmp    801ab1 <initialize_dyn_block_system+0x14f>
  801aa7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aaa:	8b 00                	mov    (%eax),%eax
  801aac:	a3 48 51 80 00       	mov    %eax,0x805148
  801ab1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801aba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801abd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ac4:	a1 54 51 80 00       	mov    0x805154,%eax
  801ac9:	48                   	dec    %eax
  801aca:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801acf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ad2:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801ad9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801adc:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801ae3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801ae7:	75 14                	jne    801afd <initialize_dyn_block_system+0x19b>
  801ae9:	83 ec 04             	sub    $0x4,%esp
  801aec:	68 e0 40 80 00       	push   $0x8040e0
  801af1:	6a 3e                	push   $0x3e
  801af3:	68 d3 40 80 00       	push   $0x8040d3
  801af8:	e8 f6 ed ff ff       	call   8008f3 <_panic>
  801afd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b03:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b06:	89 10                	mov    %edx,(%eax)
  801b08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b0b:	8b 00                	mov    (%eax),%eax
  801b0d:	85 c0                	test   %eax,%eax
  801b0f:	74 0d                	je     801b1e <initialize_dyn_block_system+0x1bc>
  801b11:	a1 38 51 80 00       	mov    0x805138,%eax
  801b16:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b19:	89 50 04             	mov    %edx,0x4(%eax)
  801b1c:	eb 08                	jmp    801b26 <initialize_dyn_block_system+0x1c4>
  801b1e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b21:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b26:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b29:	a3 38 51 80 00       	mov    %eax,0x805138
  801b2e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b38:	a1 44 51 80 00       	mov    0x805144,%eax
  801b3d:	40                   	inc    %eax
  801b3e:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801b43:	90                   	nop
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801b4c:	e8 e0 fd ff ff       	call   801931 <InitializeUHeap>
		if (size == 0) return NULL ;
  801b51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b55:	75 07                	jne    801b5e <malloc+0x18>
  801b57:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5c:	eb 7f                	jmp    801bdd <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b5e:	e8 d2 08 00 00       	call   802435 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b63:	85 c0                	test   %eax,%eax
  801b65:	74 71                	je     801bd8 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801b67:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  801b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b74:	01 d0                	add    %edx,%eax
  801b76:	48                   	dec    %eax
  801b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b82:	f7 75 f4             	divl   -0xc(%ebp)
  801b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b88:	29 d0                	sub    %edx,%eax
  801b8a:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801b8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801b94:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801b9b:	76 07                	jbe    801ba4 <malloc+0x5e>
					return NULL ;
  801b9d:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba2:	eb 39                	jmp    801bdd <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801ba4:	83 ec 0c             	sub    $0xc,%esp
  801ba7:	ff 75 08             	pushl  0x8(%ebp)
  801baa:	e8 e6 0d 00 00       	call   802995 <alloc_block_FF>
  801baf:	83 c4 10             	add    $0x10,%esp
  801bb2:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801bb5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bb9:	74 16                	je     801bd1 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801bbb:	83 ec 0c             	sub    $0xc,%esp
  801bbe:	ff 75 ec             	pushl  -0x14(%ebp)
  801bc1:	e8 37 0c 00 00       	call   8027fd <insert_sorted_allocList>
  801bc6:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bcc:	8b 40 08             	mov    0x8(%eax),%eax
  801bcf:	eb 0c                	jmp    801bdd <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801bd1:	b8 00 00 00 00       	mov    $0x0,%eax
  801bd6:	eb 05                	jmp    801bdd <malloc+0x97>
				}
		}
	return 0;
  801bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801beb:	83 ec 08             	sub    $0x8,%esp
  801bee:	ff 75 f4             	pushl  -0xc(%ebp)
  801bf1:	68 40 50 80 00       	push   $0x805040
  801bf6:	e8 cf 0b 00 00       	call   8027ca <find_block>
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c04:	8b 40 0c             	mov    0xc(%eax),%eax
  801c07:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801c0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0d:	8b 40 08             	mov    0x8(%eax),%eax
  801c10:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801c13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c17:	0f 84 a1 00 00 00    	je     801cbe <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801c1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c21:	75 17                	jne    801c3a <free+0x5b>
  801c23:	83 ec 04             	sub    $0x4,%esp
  801c26:	68 b5 40 80 00       	push   $0x8040b5
  801c2b:	68 80 00 00 00       	push   $0x80
  801c30:	68 d3 40 80 00       	push   $0x8040d3
  801c35:	e8 b9 ec ff ff       	call   8008f3 <_panic>
  801c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3d:	8b 00                	mov    (%eax),%eax
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	74 10                	je     801c53 <free+0x74>
  801c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c46:	8b 00                	mov    (%eax),%eax
  801c48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c4b:	8b 52 04             	mov    0x4(%edx),%edx
  801c4e:	89 50 04             	mov    %edx,0x4(%eax)
  801c51:	eb 0b                	jmp    801c5e <free+0x7f>
  801c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c56:	8b 40 04             	mov    0x4(%eax),%eax
  801c59:	a3 44 50 80 00       	mov    %eax,0x805044
  801c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c61:	8b 40 04             	mov    0x4(%eax),%eax
  801c64:	85 c0                	test   %eax,%eax
  801c66:	74 0f                	je     801c77 <free+0x98>
  801c68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c6b:	8b 40 04             	mov    0x4(%eax),%eax
  801c6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c71:	8b 12                	mov    (%edx),%edx
  801c73:	89 10                	mov    %edx,(%eax)
  801c75:	eb 0a                	jmp    801c81 <free+0xa2>
  801c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7a:	8b 00                	mov    (%eax),%eax
  801c7c:	a3 40 50 80 00       	mov    %eax,0x805040
  801c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c94:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801c99:	48                   	dec    %eax
  801c9a:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801c9f:	83 ec 0c             	sub    $0xc,%esp
  801ca2:	ff 75 f0             	pushl  -0x10(%ebp)
  801ca5:	e8 29 12 00 00       	call   802ed3 <insert_sorted_with_merge_freeList>
  801caa:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801cad:	83 ec 08             	sub    $0x8,%esp
  801cb0:	ff 75 ec             	pushl  -0x14(%ebp)
  801cb3:	ff 75 e8             	pushl  -0x18(%ebp)
  801cb6:	e8 74 03 00 00       	call   80202f <sys_free_user_mem>
  801cbb:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801cbe:	90                   	nop
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
  801cc4:	83 ec 38             	sub    $0x38,%esp
  801cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801cca:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ccd:	e8 5f fc ff ff       	call   801931 <InitializeUHeap>
	if (size == 0) return NULL ;
  801cd2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801cd6:	75 0a                	jne    801ce2 <smalloc+0x21>
  801cd8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdd:	e9 b2 00 00 00       	jmp    801d94 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801ce2:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801ce9:	76 0a                	jbe    801cf5 <smalloc+0x34>
		return NULL;
  801ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf0:	e9 9f 00 00 00       	jmp    801d94 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801cf5:	e8 3b 07 00 00       	call   802435 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	0f 84 8d 00 00 00    	je     801d8f <smalloc+0xce>
	struct MemBlock *b = NULL;
  801d02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801d09:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d16:	01 d0                	add    %edx,%eax
  801d18:	48                   	dec    %eax
  801d19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  801d24:	f7 75 f0             	divl   -0x10(%ebp)
  801d27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2a:	29 d0                	sub    %edx,%eax
  801d2c:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801d2f:	83 ec 0c             	sub    $0xc,%esp
  801d32:	ff 75 e8             	pushl  -0x18(%ebp)
  801d35:	e8 5b 0c 00 00       	call   802995 <alloc_block_FF>
  801d3a:	83 c4 10             	add    $0x10,%esp
  801d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801d40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d44:	75 07                	jne    801d4d <smalloc+0x8c>
			return NULL;
  801d46:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4b:	eb 47                	jmp    801d94 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801d4d:	83 ec 0c             	sub    $0xc,%esp
  801d50:	ff 75 f4             	pushl  -0xc(%ebp)
  801d53:	e8 a5 0a 00 00       	call   8027fd <insert_sorted_allocList>
  801d58:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801d5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5e:	8b 40 08             	mov    0x8(%eax),%eax
  801d61:	89 c2                	mov    %eax,%edx
  801d63:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	ff 75 0c             	pushl  0xc(%ebp)
  801d6c:	ff 75 08             	pushl  0x8(%ebp)
  801d6f:	e8 46 04 00 00       	call   8021ba <sys_createSharedObject>
  801d74:	83 c4 10             	add    $0x10,%esp
  801d77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801d7a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801d7e:	78 08                	js     801d88 <smalloc+0xc7>
		return (void *)b->sva;
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	8b 40 08             	mov    0x8(%eax),%eax
  801d86:	eb 0c                	jmp    801d94 <smalloc+0xd3>
		}else{
		return NULL;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
  801d8d:	eb 05                	jmp    801d94 <smalloc+0xd3>
			}

	}return NULL;
  801d8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d9c:	e8 90 fb ff ff       	call   801931 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801da1:	e8 8f 06 00 00       	call   802435 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801da6:	85 c0                	test   %eax,%eax
  801da8:	0f 84 ad 00 00 00    	je     801e5b <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801dae:	83 ec 08             	sub    $0x8,%esp
  801db1:	ff 75 0c             	pushl  0xc(%ebp)
  801db4:	ff 75 08             	pushl  0x8(%ebp)
  801db7:	e8 28 04 00 00       	call   8021e4 <sys_getSizeOfSharedObject>
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801dc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc6:	79 0a                	jns    801dd2 <sget+0x3c>
    {
    	return NULL;
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcd:	e9 8e 00 00 00       	jmp    801e60 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801dd2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801dd9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801de6:	01 d0                	add    %edx,%eax
  801de8:	48                   	dec    %eax
  801de9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801dec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801def:	ba 00 00 00 00       	mov    $0x0,%edx
  801df4:	f7 75 ec             	divl   -0x14(%ebp)
  801df7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dfa:	29 d0                	sub    %edx,%eax
  801dfc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801dff:	83 ec 0c             	sub    $0xc,%esp
  801e02:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e05:	e8 8b 0b 00 00       	call   802995 <alloc_block_FF>
  801e0a:	83 c4 10             	add    $0x10,%esp
  801e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801e10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e14:	75 07                	jne    801e1d <sget+0x87>
				return NULL;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
  801e1b:	eb 43                	jmp    801e60 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801e1d:	83 ec 0c             	sub    $0xc,%esp
  801e20:	ff 75 f0             	pushl  -0x10(%ebp)
  801e23:	e8 d5 09 00 00       	call   8027fd <insert_sorted_allocList>
  801e28:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2e:	8b 40 08             	mov    0x8(%eax),%eax
  801e31:	83 ec 04             	sub    $0x4,%esp
  801e34:	50                   	push   %eax
  801e35:	ff 75 0c             	pushl  0xc(%ebp)
  801e38:	ff 75 08             	pushl  0x8(%ebp)
  801e3b:	e8 c1 03 00 00       	call   802201 <sys_getSharedObject>
  801e40:	83 c4 10             	add    $0x10,%esp
  801e43:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e4a:	78 08                	js     801e54 <sget+0xbe>
			return (void *)b->sva;
  801e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e4f:	8b 40 08             	mov    0x8(%eax),%eax
  801e52:	eb 0c                	jmp    801e60 <sget+0xca>
			}else{
			return NULL;
  801e54:	b8 00 00 00 00       	mov    $0x0,%eax
  801e59:	eb 05                	jmp    801e60 <sget+0xca>
			}
    }}return NULL;
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e68:	e8 c4 fa ff ff       	call   801931 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801e6d:	83 ec 04             	sub    $0x4,%esp
  801e70:	68 04 41 80 00       	push   $0x804104
  801e75:	68 03 01 00 00       	push   $0x103
  801e7a:	68 d3 40 80 00       	push   $0x8040d3
  801e7f:	e8 6f ea ff ff       	call   8008f3 <_panic>

00801e84 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801e8a:	83 ec 04             	sub    $0x4,%esp
  801e8d:	68 2c 41 80 00       	push   $0x80412c
  801e92:	68 17 01 00 00       	push   $0x117
  801e97:	68 d3 40 80 00       	push   $0x8040d3
  801e9c:	e8 52 ea ff ff       	call   8008f3 <_panic>

00801ea1 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ea7:	83 ec 04             	sub    $0x4,%esp
  801eaa:	68 50 41 80 00       	push   $0x804150
  801eaf:	68 22 01 00 00       	push   $0x122
  801eb4:	68 d3 40 80 00       	push   $0x8040d3
  801eb9:	e8 35 ea ff ff       	call   8008f3 <_panic>

00801ebe <shrink>:

}
void shrink(uint32 newSize)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	68 50 41 80 00       	push   $0x804150
  801ecc:	68 27 01 00 00       	push   $0x127
  801ed1:	68 d3 40 80 00       	push   $0x8040d3
  801ed6:	e8 18 ea ff ff       	call   8008f3 <_panic>

00801edb <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801edb:	55                   	push   %ebp
  801edc:	89 e5                	mov    %esp,%ebp
  801ede:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ee1:	83 ec 04             	sub    $0x4,%esp
  801ee4:	68 50 41 80 00       	push   $0x804150
  801ee9:	68 2c 01 00 00       	push   $0x12c
  801eee:	68 d3 40 80 00       	push   $0x8040d3
  801ef3:	e8 fb e9 ff ff       	call   8008f3 <_panic>

00801ef8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
  801efb:	57                   	push   %edi
  801efc:	56                   	push   %esi
  801efd:	53                   	push   %ebx
  801efe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f01:	8b 45 08             	mov    0x8(%ebp),%eax
  801f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f07:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f0a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f0d:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f10:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f13:	cd 30                	int    $0x30
  801f15:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f1b:	83 c4 10             	add    $0x10,%esp
  801f1e:	5b                   	pop    %ebx
  801f1f:	5e                   	pop    %esi
  801f20:	5f                   	pop    %edi
  801f21:	5d                   	pop    %ebp
  801f22:	c3                   	ret    

00801f23 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
  801f26:	83 ec 04             	sub    $0x4,%esp
  801f29:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f2f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	52                   	push   %edx
  801f3b:	ff 75 0c             	pushl  0xc(%ebp)
  801f3e:	50                   	push   %eax
  801f3f:	6a 00                	push   $0x0
  801f41:	e8 b2 ff ff ff       	call   801ef8 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	90                   	nop
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_cgetc>:

int
sys_cgetc(void)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 00                	push   $0x0
  801f57:	6a 00                	push   $0x0
  801f59:	6a 01                	push   $0x1
  801f5b:	e8 98 ff ff ff       	call   801ef8 <syscall>
  801f60:	83 c4 18             	add    $0x18,%esp
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801f68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	52                   	push   %edx
  801f75:	50                   	push   %eax
  801f76:	6a 05                	push   $0x5
  801f78:	e8 7b ff ff ff       	call   801ef8 <syscall>
  801f7d:	83 c4 18             	add    $0x18,%esp
}
  801f80:	c9                   	leave  
  801f81:	c3                   	ret    

00801f82 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801f82:	55                   	push   %ebp
  801f83:	89 e5                	mov    %esp,%ebp
  801f85:	56                   	push   %esi
  801f86:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801f87:	8b 75 18             	mov    0x18(%ebp),%esi
  801f8a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f8d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f90:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f93:	8b 45 08             	mov    0x8(%ebp),%eax
  801f96:	56                   	push   %esi
  801f97:	53                   	push   %ebx
  801f98:	51                   	push   %ecx
  801f99:	52                   	push   %edx
  801f9a:	50                   	push   %eax
  801f9b:	6a 06                	push   $0x6
  801f9d:	e8 56 ff ff ff       	call   801ef8 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fa8:	5b                   	pop    %ebx
  801fa9:	5e                   	pop    %esi
  801faa:	5d                   	pop    %ebp
  801fab:	c3                   	ret    

00801fac <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801faf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	6a 07                	push   $0x7
  801fbf:	e8 34 ff ff ff       	call   801ef8 <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	6a 00                	push   $0x0
  801fd2:	ff 75 0c             	pushl  0xc(%ebp)
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	6a 08                	push   $0x8
  801fda:	e8 19 ff ff ff       	call   801ef8 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 09                	push   $0x9
  801ff3:	e8 00 ff ff ff       	call   801ef8 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 0a                	push   $0xa
  80200c:	e8 e7 fe ff ff       	call   801ef8 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 0b                	push   $0xb
  802025:	e8 ce fe ff ff       	call   801ef8 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
}
  80202d:	c9                   	leave  
  80202e:	c3                   	ret    

0080202f <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80202f:	55                   	push   %ebp
  802030:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	ff 75 0c             	pushl  0xc(%ebp)
  80203b:	ff 75 08             	pushl  0x8(%ebp)
  80203e:	6a 0f                	push   $0xf
  802040:	e8 b3 fe ff ff       	call   801ef8 <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
	return;
  802048:	90                   	nop
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	ff 75 0c             	pushl  0xc(%ebp)
  802057:	ff 75 08             	pushl  0x8(%ebp)
  80205a:	6a 10                	push   $0x10
  80205c:	e8 97 fe ff ff       	call   801ef8 <syscall>
  802061:	83 c4 18             	add    $0x18,%esp
	return ;
  802064:	90                   	nop
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	ff 75 10             	pushl  0x10(%ebp)
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	6a 11                	push   $0x11
  802079:	e8 7a fe ff ff       	call   801ef8 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
	return ;
  802081:	90                   	nop
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 0c                	push   $0xc
  802093:	e8 60 fe ff ff       	call   801ef8 <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	ff 75 08             	pushl  0x8(%ebp)
  8020ab:	6a 0d                	push   $0xd
  8020ad:	e8 46 fe ff ff       	call   801ef8 <syscall>
  8020b2:	83 c4 18             	add    $0x18,%esp
}
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020ba:	6a 00                	push   $0x0
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 0e                	push   $0xe
  8020c6:	e8 2d fe ff ff       	call   801ef8 <syscall>
  8020cb:	83 c4 18             	add    $0x18,%esp
}
  8020ce:	90                   	nop
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 13                	push   $0x13
  8020e0:	e8 13 fe ff ff       	call   801ef8 <syscall>
  8020e5:	83 c4 18             	add    $0x18,%esp
}
  8020e8:	90                   	nop
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 14                	push   $0x14
  8020fa:	e8 f9 fd ff ff       	call   801ef8 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	90                   	nop
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <sys_cputc>:


void
sys_cputc(const char c)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 04             	sub    $0x4,%esp
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802111:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802115:	6a 00                	push   $0x0
  802117:	6a 00                	push   $0x0
  802119:	6a 00                	push   $0x0
  80211b:	6a 00                	push   $0x0
  80211d:	50                   	push   %eax
  80211e:	6a 15                	push   $0x15
  802120:	e8 d3 fd ff ff       	call   801ef8 <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
}
  802128:	90                   	nop
  802129:	c9                   	leave  
  80212a:	c3                   	ret    

0080212b <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80212b:	55                   	push   %ebp
  80212c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 00                	push   $0x0
  802134:	6a 00                	push   $0x0
  802136:	6a 00                	push   $0x0
  802138:	6a 16                	push   $0x16
  80213a:	e8 b9 fd ff ff       	call   801ef8 <syscall>
  80213f:	83 c4 18             	add    $0x18,%esp
}
  802142:	90                   	nop
  802143:	c9                   	leave  
  802144:	c3                   	ret    

00802145 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802145:	55                   	push   %ebp
  802146:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	6a 00                	push   $0x0
  80214d:	6a 00                	push   $0x0
  80214f:	6a 00                	push   $0x0
  802151:	ff 75 0c             	pushl  0xc(%ebp)
  802154:	50                   	push   %eax
  802155:	6a 17                	push   $0x17
  802157:	e8 9c fd ff ff       	call   801ef8 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
}
  80215f:	c9                   	leave  
  802160:	c3                   	ret    

00802161 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802164:	8b 55 0c             	mov    0xc(%ebp),%edx
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	52                   	push   %edx
  802171:	50                   	push   %eax
  802172:	6a 1a                	push   $0x1a
  802174:	e8 7f fd ff ff       	call   801ef8 <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802181:	8b 55 0c             	mov    0xc(%ebp),%edx
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	52                   	push   %edx
  80218e:	50                   	push   %eax
  80218f:	6a 18                	push   $0x18
  802191:	e8 62 fd ff ff       	call   801ef8 <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	90                   	nop
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80219f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	52                   	push   %edx
  8021ac:	50                   	push   %eax
  8021ad:	6a 19                	push   $0x19
  8021af:	e8 44 fd ff ff       	call   801ef8 <syscall>
  8021b4:	83 c4 18             	add    $0x18,%esp
}
  8021b7:	90                   	nop
  8021b8:	c9                   	leave  
  8021b9:	c3                   	ret    

008021ba <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	83 ec 04             	sub    $0x4,%esp
  8021c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021c6:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8021c9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	6a 00                	push   $0x0
  8021d2:	51                   	push   %ecx
  8021d3:	52                   	push   %edx
  8021d4:	ff 75 0c             	pushl  0xc(%ebp)
  8021d7:	50                   	push   %eax
  8021d8:	6a 1b                	push   $0x1b
  8021da:	e8 19 fd ff ff       	call   801ef8 <syscall>
  8021df:	83 c4 18             	add    $0x18,%esp
}
  8021e2:	c9                   	leave  
  8021e3:	c3                   	ret    

008021e4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8021e4:	55                   	push   %ebp
  8021e5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8021e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	6a 00                	push   $0x0
  8021ef:	6a 00                	push   $0x0
  8021f1:	6a 00                	push   $0x0
  8021f3:	52                   	push   %edx
  8021f4:	50                   	push   %eax
  8021f5:	6a 1c                	push   $0x1c
  8021f7:	e8 fc fc ff ff       	call   801ef8 <syscall>
  8021fc:	83 c4 18             	add    $0x18,%esp
}
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802204:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802207:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	51                   	push   %ecx
  802212:	52                   	push   %edx
  802213:	50                   	push   %eax
  802214:	6a 1d                	push   $0x1d
  802216:	e8 dd fc ff ff       	call   801ef8 <syscall>
  80221b:	83 c4 18             	add    $0x18,%esp
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802223:	8b 55 0c             	mov    0xc(%ebp),%edx
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	52                   	push   %edx
  802230:	50                   	push   %eax
  802231:	6a 1e                	push   $0x1e
  802233:	e8 c0 fc ff ff       	call   801ef8 <syscall>
  802238:	83 c4 18             	add    $0x18,%esp
}
  80223b:	c9                   	leave  
  80223c:	c3                   	ret    

0080223d <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80223d:	55                   	push   %ebp
  80223e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802240:	6a 00                	push   $0x0
  802242:	6a 00                	push   $0x0
  802244:	6a 00                	push   $0x0
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	6a 1f                	push   $0x1f
  80224c:	e8 a7 fc ff ff       	call   801ef8 <syscall>
  802251:	83 c4 18             	add    $0x18,%esp
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	6a 00                	push   $0x0
  80225e:	ff 75 14             	pushl  0x14(%ebp)
  802261:	ff 75 10             	pushl  0x10(%ebp)
  802264:	ff 75 0c             	pushl  0xc(%ebp)
  802267:	50                   	push   %eax
  802268:	6a 20                	push   $0x20
  80226a:	e8 89 fc ff ff       	call   801ef8 <syscall>
  80226f:	83 c4 18             	add    $0x18,%esp
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802277:	8b 45 08             	mov    0x8(%ebp),%eax
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	50                   	push   %eax
  802283:	6a 21                	push   $0x21
  802285:	e8 6e fc ff ff       	call   801ef8 <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
}
  80228d:	90                   	nop
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	6a 00                	push   $0x0
  80229c:	6a 00                	push   $0x0
  80229e:	50                   	push   %eax
  80229f:	6a 22                	push   $0x22
  8022a1:	e8 52 fc ff ff       	call   801ef8 <syscall>
  8022a6:	83 c4 18             	add    $0x18,%esp
}
  8022a9:	c9                   	leave  
  8022aa:	c3                   	ret    

008022ab <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022ab:	55                   	push   %ebp
  8022ac:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 02                	push   $0x2
  8022ba:	e8 39 fc ff ff       	call   801ef8 <syscall>
  8022bf:	83 c4 18             	add    $0x18,%esp
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 03                	push   $0x3
  8022d3:	e8 20 fc ff ff       	call   801ef8 <syscall>
  8022d8:	83 c4 18             	add    $0x18,%esp
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 00                	push   $0x0
  8022ea:	6a 04                	push   $0x4
  8022ec:	e8 07 fc ff ff       	call   801ef8 <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <sys_exit_env>:


void sys_exit_env(void)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 23                	push   $0x23
  802305:	e8 ee fb ff ff       	call   801ef8 <syscall>
  80230a:	83 c4 18             	add    $0x18,%esp
}
  80230d:	90                   	nop
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802316:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802319:	8d 50 04             	lea    0x4(%eax),%edx
  80231c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 00                	push   $0x0
  802325:	52                   	push   %edx
  802326:	50                   	push   %eax
  802327:	6a 24                	push   $0x24
  802329:	e8 ca fb ff ff       	call   801ef8 <syscall>
  80232e:	83 c4 18             	add    $0x18,%esp
	return result;
  802331:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802334:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802337:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80233a:	89 01                	mov    %eax,(%ecx)
  80233c:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	c9                   	leave  
  802343:	c2 04 00             	ret    $0x4

00802346 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	ff 75 10             	pushl  0x10(%ebp)
  802350:	ff 75 0c             	pushl  0xc(%ebp)
  802353:	ff 75 08             	pushl  0x8(%ebp)
  802356:	6a 12                	push   $0x12
  802358:	e8 9b fb ff ff       	call   801ef8 <syscall>
  80235d:	83 c4 18             	add    $0x18,%esp
	return ;
  802360:	90                   	nop
}
  802361:	c9                   	leave  
  802362:	c3                   	ret    

00802363 <sys_rcr2>:
uint32 sys_rcr2()
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 25                	push   $0x25
  802372:	e8 81 fb ff ff       	call   801ef8 <syscall>
  802377:	83 c4 18             	add    $0x18,%esp
}
  80237a:	c9                   	leave  
  80237b:	c3                   	ret    

0080237c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80237c:	55                   	push   %ebp
  80237d:	89 e5                	mov    %esp,%ebp
  80237f:	83 ec 04             	sub    $0x4,%esp
  802382:	8b 45 08             	mov    0x8(%ebp),%eax
  802385:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802388:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80238c:	6a 00                	push   $0x0
  80238e:	6a 00                	push   $0x0
  802390:	6a 00                	push   $0x0
  802392:	6a 00                	push   $0x0
  802394:	50                   	push   %eax
  802395:	6a 26                	push   $0x26
  802397:	e8 5c fb ff ff       	call   801ef8 <syscall>
  80239c:	83 c4 18             	add    $0x18,%esp
	return ;
  80239f:	90                   	nop
}
  8023a0:	c9                   	leave  
  8023a1:	c3                   	ret    

008023a2 <rsttst>:
void rsttst()
{
  8023a2:	55                   	push   %ebp
  8023a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 28                	push   $0x28
  8023b1:	e8 42 fb ff ff       	call   801ef8 <syscall>
  8023b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b9:	90                   	nop
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 04             	sub    $0x4,%esp
  8023c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8023c5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8023c8:	8b 55 18             	mov    0x18(%ebp),%edx
  8023cb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023cf:	52                   	push   %edx
  8023d0:	50                   	push   %eax
  8023d1:	ff 75 10             	pushl  0x10(%ebp)
  8023d4:	ff 75 0c             	pushl  0xc(%ebp)
  8023d7:	ff 75 08             	pushl  0x8(%ebp)
  8023da:	6a 27                	push   $0x27
  8023dc:	e8 17 fb ff ff       	call   801ef8 <syscall>
  8023e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8023e4:	90                   	nop
}
  8023e5:	c9                   	leave  
  8023e6:	c3                   	ret    

008023e7 <chktst>:
void chktst(uint32 n)
{
  8023e7:	55                   	push   %ebp
  8023e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	6a 00                	push   $0x0
  8023f2:	ff 75 08             	pushl  0x8(%ebp)
  8023f5:	6a 29                	push   $0x29
  8023f7:	e8 fc fa ff ff       	call   801ef8 <syscall>
  8023fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ff:	90                   	nop
}
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <inctst>:

void inctst()
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802405:	6a 00                	push   $0x0
  802407:	6a 00                	push   $0x0
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 2a                	push   $0x2a
  802411:	e8 e2 fa ff ff       	call   801ef8 <syscall>
  802416:	83 c4 18             	add    $0x18,%esp
	return ;
  802419:	90                   	nop
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <gettst>:
uint32 gettst()
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 2b                	push   $0x2b
  80242b:	e8 c8 fa ff ff       	call   801ef8 <syscall>
  802430:	83 c4 18             	add    $0x18,%esp
}
  802433:	c9                   	leave  
  802434:	c3                   	ret    

00802435 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802435:	55                   	push   %ebp
  802436:	89 e5                	mov    %esp,%ebp
  802438:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80243b:	6a 00                	push   $0x0
  80243d:	6a 00                	push   $0x0
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 2c                	push   $0x2c
  802447:	e8 ac fa ff ff       	call   801ef8 <syscall>
  80244c:	83 c4 18             	add    $0x18,%esp
  80244f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802452:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802456:	75 07                	jne    80245f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802458:	b8 01 00 00 00       	mov    $0x1,%eax
  80245d:	eb 05                	jmp    802464 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80245f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802464:	c9                   	leave  
  802465:	c3                   	ret    

00802466 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802466:	55                   	push   %ebp
  802467:	89 e5                	mov    %esp,%ebp
  802469:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 00                	push   $0x0
  802474:	6a 00                	push   $0x0
  802476:	6a 2c                	push   $0x2c
  802478:	e8 7b fa ff ff       	call   801ef8 <syscall>
  80247d:	83 c4 18             	add    $0x18,%esp
  802480:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802483:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802487:	75 07                	jne    802490 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802489:	b8 01 00 00 00       	mov    $0x1,%eax
  80248e:	eb 05                	jmp    802495 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802490:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802495:	c9                   	leave  
  802496:	c3                   	ret    

00802497 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802497:	55                   	push   %ebp
  802498:	89 e5                	mov    %esp,%ebp
  80249a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80249d:	6a 00                	push   $0x0
  80249f:	6a 00                	push   $0x0
  8024a1:	6a 00                	push   $0x0
  8024a3:	6a 00                	push   $0x0
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 2c                	push   $0x2c
  8024a9:	e8 4a fa ff ff       	call   801ef8 <syscall>
  8024ae:	83 c4 18             	add    $0x18,%esp
  8024b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024b4:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024b8:	75 07                	jne    8024c1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8024bf:	eb 05                	jmp    8024c6 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  8024da:	e8 19 fa ff ff       	call   801ef8 <syscall>
  8024df:	83 c4 18             	add    $0x18,%esp
  8024e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024e5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024e9:	75 07                	jne    8024f2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024eb:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f0:	eb 05                	jmp    8024f7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024fc:	6a 00                	push   $0x0
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	ff 75 08             	pushl  0x8(%ebp)
  802507:	6a 2d                	push   $0x2d
  802509:	e8 ea f9 ff ff       	call   801ef8 <syscall>
  80250e:	83 c4 18             	add    $0x18,%esp
	return ;
  802511:	90                   	nop
}
  802512:	c9                   	leave  
  802513:	c3                   	ret    

00802514 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802514:	55                   	push   %ebp
  802515:	89 e5                	mov    %esp,%ebp
  802517:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802518:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80251b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80251e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802521:	8b 45 08             	mov    0x8(%ebp),%eax
  802524:	6a 00                	push   $0x0
  802526:	53                   	push   %ebx
  802527:	51                   	push   %ecx
  802528:	52                   	push   %edx
  802529:	50                   	push   %eax
  80252a:	6a 2e                	push   $0x2e
  80252c:	e8 c7 f9 ff ff       	call   801ef8 <syscall>
  802531:	83 c4 18             	add    $0x18,%esp
}
  802534:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802537:	c9                   	leave  
  802538:	c3                   	ret    

00802539 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802539:	55                   	push   %ebp
  80253a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80253c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	6a 00                	push   $0x0
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	52                   	push   %edx
  802549:	50                   	push   %eax
  80254a:	6a 2f                	push   $0x2f
  80254c:	e8 a7 f9 ff ff       	call   801ef8 <syscall>
  802551:	83 c4 18             	add    $0x18,%esp
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80255c:	83 ec 0c             	sub    $0xc,%esp
  80255f:	68 60 41 80 00       	push   $0x804160
  802564:	e8 3e e6 ff ff       	call   800ba7 <cprintf>
  802569:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80256c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802573:	83 ec 0c             	sub    $0xc,%esp
  802576:	68 8c 41 80 00       	push   $0x80418c
  80257b:	e8 27 e6 ff ff       	call   800ba7 <cprintf>
  802580:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802583:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802587:	a1 38 51 80 00       	mov    0x805138,%eax
  80258c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258f:	eb 56                	jmp    8025e7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802591:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802595:	74 1c                	je     8025b3 <print_mem_block_lists+0x5d>
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 50 08             	mov    0x8(%eax),%edx
  80259d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a0:	8b 48 08             	mov    0x8(%eax),%ecx
  8025a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a9:	01 c8                	add    %ecx,%eax
  8025ab:	39 c2                	cmp    %eax,%edx
  8025ad:	73 04                	jae    8025b3 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025af:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 50 08             	mov    0x8(%eax),%edx
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025bf:	01 c2                	add    %eax,%edx
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 40 08             	mov    0x8(%eax),%eax
  8025c7:	83 ec 04             	sub    $0x4,%esp
  8025ca:	52                   	push   %edx
  8025cb:	50                   	push   %eax
  8025cc:	68 a1 41 80 00       	push   $0x8041a1
  8025d1:	e8 d1 e5 ff ff       	call   800ba7 <cprintf>
  8025d6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025df:	a1 40 51 80 00       	mov    0x805140,%eax
  8025e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025eb:	74 07                	je     8025f4 <print_mem_block_lists+0x9e>
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 00                	mov    (%eax),%eax
  8025f2:	eb 05                	jmp    8025f9 <print_mem_block_lists+0xa3>
  8025f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025f9:	a3 40 51 80 00       	mov    %eax,0x805140
  8025fe:	a1 40 51 80 00       	mov    0x805140,%eax
  802603:	85 c0                	test   %eax,%eax
  802605:	75 8a                	jne    802591 <print_mem_block_lists+0x3b>
  802607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260b:	75 84                	jne    802591 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80260d:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802611:	75 10                	jne    802623 <print_mem_block_lists+0xcd>
  802613:	83 ec 0c             	sub    $0xc,%esp
  802616:	68 b0 41 80 00       	push   $0x8041b0
  80261b:	e8 87 e5 ff ff       	call   800ba7 <cprintf>
  802620:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802623:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80262a:	83 ec 0c             	sub    $0xc,%esp
  80262d:	68 d4 41 80 00       	push   $0x8041d4
  802632:	e8 70 e5 ff ff       	call   800ba7 <cprintf>
  802637:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80263a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80263e:	a1 40 50 80 00       	mov    0x805040,%eax
  802643:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802646:	eb 56                	jmp    80269e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802648:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80264c:	74 1c                	je     80266a <print_mem_block_lists+0x114>
  80264e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802651:	8b 50 08             	mov    0x8(%eax),%edx
  802654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802657:	8b 48 08             	mov    0x8(%eax),%ecx
  80265a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265d:	8b 40 0c             	mov    0xc(%eax),%eax
  802660:	01 c8                	add    %ecx,%eax
  802662:	39 c2                	cmp    %eax,%edx
  802664:	73 04                	jae    80266a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802666:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80266a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266d:	8b 50 08             	mov    0x8(%eax),%edx
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 40 0c             	mov    0xc(%eax),%eax
  802676:	01 c2                	add    %eax,%edx
  802678:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267b:	8b 40 08             	mov    0x8(%eax),%eax
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	52                   	push   %edx
  802682:	50                   	push   %eax
  802683:	68 a1 41 80 00       	push   $0x8041a1
  802688:	e8 1a e5 ff ff       	call   800ba7 <cprintf>
  80268d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802696:	a1 48 50 80 00       	mov    0x805048,%eax
  80269b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80269e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a2:	74 07                	je     8026ab <print_mem_block_lists+0x155>
  8026a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	eb 05                	jmp    8026b0 <print_mem_block_lists+0x15a>
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	a3 48 50 80 00       	mov    %eax,0x805048
  8026b5:	a1 48 50 80 00       	mov    0x805048,%eax
  8026ba:	85 c0                	test   %eax,%eax
  8026bc:	75 8a                	jne    802648 <print_mem_block_lists+0xf2>
  8026be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c2:	75 84                	jne    802648 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026c4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8026c8:	75 10                	jne    8026da <print_mem_block_lists+0x184>
  8026ca:	83 ec 0c             	sub    $0xc,%esp
  8026cd:	68 ec 41 80 00       	push   $0x8041ec
  8026d2:	e8 d0 e4 ff ff       	call   800ba7 <cprintf>
  8026d7:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8026da:	83 ec 0c             	sub    $0xc,%esp
  8026dd:	68 60 41 80 00       	push   $0x804160
  8026e2:	e8 c0 e4 ff ff       	call   800ba7 <cprintf>
  8026e7:	83 c4 10             	add    $0x10,%esp

}
  8026ea:	90                   	nop
  8026eb:	c9                   	leave  
  8026ec:	c3                   	ret    

008026ed <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8026ed:	55                   	push   %ebp
  8026ee:	89 e5                	mov    %esp,%ebp
  8026f0:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8026f3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8026fa:	00 00 00 
  8026fd:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802704:	00 00 00 
  802707:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  80270e:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802711:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802718:	e9 9e 00 00 00       	jmp    8027bb <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  80271d:	a1 50 50 80 00       	mov    0x805050,%eax
  802722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802725:	c1 e2 04             	shl    $0x4,%edx
  802728:	01 d0                	add    %edx,%eax
  80272a:	85 c0                	test   %eax,%eax
  80272c:	75 14                	jne    802742 <initialize_MemBlocksList+0x55>
  80272e:	83 ec 04             	sub    $0x4,%esp
  802731:	68 14 42 80 00       	push   $0x804214
  802736:	6a 3d                	push   $0x3d
  802738:	68 37 42 80 00       	push   $0x804237
  80273d:	e8 b1 e1 ff ff       	call   8008f3 <_panic>
  802742:	a1 50 50 80 00       	mov    0x805050,%eax
  802747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80274a:	c1 e2 04             	shl    $0x4,%edx
  80274d:	01 d0                	add    %edx,%eax
  80274f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802755:	89 10                	mov    %edx,(%eax)
  802757:	8b 00                	mov    (%eax),%eax
  802759:	85 c0                	test   %eax,%eax
  80275b:	74 18                	je     802775 <initialize_MemBlocksList+0x88>
  80275d:	a1 48 51 80 00       	mov    0x805148,%eax
  802762:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802768:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80276b:	c1 e1 04             	shl    $0x4,%ecx
  80276e:	01 ca                	add    %ecx,%edx
  802770:	89 50 04             	mov    %edx,0x4(%eax)
  802773:	eb 12                	jmp    802787 <initialize_MemBlocksList+0x9a>
  802775:	a1 50 50 80 00       	mov    0x805050,%eax
  80277a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277d:	c1 e2 04             	shl    $0x4,%edx
  802780:	01 d0                	add    %edx,%eax
  802782:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802787:	a1 50 50 80 00       	mov    0x805050,%eax
  80278c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80278f:	c1 e2 04             	shl    $0x4,%edx
  802792:	01 d0                	add    %edx,%eax
  802794:	a3 48 51 80 00       	mov    %eax,0x805148
  802799:	a1 50 50 80 00       	mov    0x805050,%eax
  80279e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a1:	c1 e2 04             	shl    $0x4,%edx
  8027a4:	01 d0                	add    %edx,%eax
  8027a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8027b2:	40                   	inc    %eax
  8027b3:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8027b8:	ff 45 f4             	incl   -0xc(%ebp)
  8027bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c1:	0f 82 56 ff ff ff    	jb     80271d <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8027c7:	90                   	nop
  8027c8:	c9                   	leave  
  8027c9:	c3                   	ret    

008027ca <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8027ca:	55                   	push   %ebp
  8027cb:	89 e5                	mov    %esp,%ebp
  8027cd:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8027d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d3:	8b 00                	mov    (%eax),%eax
  8027d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8027d8:	eb 18                	jmp    8027f2 <find_block+0x28>

		if(tmp->sva == va){
  8027da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027dd:	8b 40 08             	mov    0x8(%eax),%eax
  8027e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8027e3:	75 05                	jne    8027ea <find_block+0x20>
			return tmp ;
  8027e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027e8:	eb 11                	jmp    8027fb <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8027ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8027f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8027f6:	75 e2                	jne    8027da <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8027f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8027fb:	c9                   	leave  
  8027fc:	c3                   	ret    

008027fd <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802803:	a1 40 50 80 00       	mov    0x805040,%eax
  802808:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  80280b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802810:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802813:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802817:	75 65                	jne    80287e <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802819:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80281d:	75 14                	jne    802833 <insert_sorted_allocList+0x36>
  80281f:	83 ec 04             	sub    $0x4,%esp
  802822:	68 14 42 80 00       	push   $0x804214
  802827:	6a 62                	push   $0x62
  802829:	68 37 42 80 00       	push   $0x804237
  80282e:	e8 c0 e0 ff ff       	call   8008f3 <_panic>
  802833:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	89 10                	mov    %edx,(%eax)
  80283e:	8b 45 08             	mov    0x8(%ebp),%eax
  802841:	8b 00                	mov    (%eax),%eax
  802843:	85 c0                	test   %eax,%eax
  802845:	74 0d                	je     802854 <insert_sorted_allocList+0x57>
  802847:	a1 40 50 80 00       	mov    0x805040,%eax
  80284c:	8b 55 08             	mov    0x8(%ebp),%edx
  80284f:	89 50 04             	mov    %edx,0x4(%eax)
  802852:	eb 08                	jmp    80285c <insert_sorted_allocList+0x5f>
  802854:	8b 45 08             	mov    0x8(%ebp),%eax
  802857:	a3 44 50 80 00       	mov    %eax,0x805044
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	a3 40 50 80 00       	mov    %eax,0x805040
  802864:	8b 45 08             	mov    0x8(%ebp),%eax
  802867:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802873:	40                   	inc    %eax
  802874:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802879:	e9 14 01 00 00       	jmp    802992 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80287e:	8b 45 08             	mov    0x8(%ebp),%eax
  802881:	8b 50 08             	mov    0x8(%eax),%edx
  802884:	a1 44 50 80 00       	mov    0x805044,%eax
  802889:	8b 40 08             	mov    0x8(%eax),%eax
  80288c:	39 c2                	cmp    %eax,%edx
  80288e:	76 65                	jbe    8028f5 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802890:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802894:	75 14                	jne    8028aa <insert_sorted_allocList+0xad>
  802896:	83 ec 04             	sub    $0x4,%esp
  802899:	68 50 42 80 00       	push   $0x804250
  80289e:	6a 64                	push   $0x64
  8028a0:	68 37 42 80 00       	push   $0x804237
  8028a5:	e8 49 e0 ff ff       	call   8008f3 <_panic>
  8028aa:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b3:	89 50 04             	mov    %edx,0x4(%eax)
  8028b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 0c                	je     8028cc <insert_sorted_allocList+0xcf>
  8028c0:	a1 44 50 80 00       	mov    0x805044,%eax
  8028c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028c8:	89 10                	mov    %edx,(%eax)
  8028ca:	eb 08                	jmp    8028d4 <insert_sorted_allocList+0xd7>
  8028cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cf:	a3 40 50 80 00       	mov    %eax,0x805040
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	a3 44 50 80 00       	mov    %eax,0x805044
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028ea:	40                   	inc    %eax
  8028eb:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8028f0:	e9 9d 00 00 00       	jmp    802992 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8028f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8028fc:	e9 85 00 00 00       	jmp    802986 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802901:	8b 45 08             	mov    0x8(%ebp),%eax
  802904:	8b 50 08             	mov    0x8(%eax),%edx
  802907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290a:	8b 40 08             	mov    0x8(%eax),%eax
  80290d:	39 c2                	cmp    %eax,%edx
  80290f:	73 6a                	jae    80297b <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802911:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802915:	74 06                	je     80291d <insert_sorted_allocList+0x120>
  802917:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80291b:	75 14                	jne    802931 <insert_sorted_allocList+0x134>
  80291d:	83 ec 04             	sub    $0x4,%esp
  802920:	68 74 42 80 00       	push   $0x804274
  802925:	6a 6b                	push   $0x6b
  802927:	68 37 42 80 00       	push   $0x804237
  80292c:	e8 c2 df ff ff       	call   8008f3 <_panic>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 50 04             	mov    0x4(%eax),%edx
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	89 50 04             	mov    %edx,0x4(%eax)
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802943:	89 10                	mov    %edx,(%eax)
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	85 c0                	test   %eax,%eax
  80294d:	74 0d                	je     80295c <insert_sorted_allocList+0x15f>
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 40 04             	mov    0x4(%eax),%eax
  802955:	8b 55 08             	mov    0x8(%ebp),%edx
  802958:	89 10                	mov    %edx,(%eax)
  80295a:	eb 08                	jmp    802964 <insert_sorted_allocList+0x167>
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	a3 40 50 80 00       	mov    %eax,0x805040
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 55 08             	mov    0x8(%ebp),%edx
  80296a:	89 50 04             	mov    %edx,0x4(%eax)
  80296d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802972:	40                   	inc    %eax
  802973:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802978:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802979:	eb 17                	jmp    802992 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80297b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802983:	ff 45 f0             	incl   -0x10(%ebp)
  802986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802989:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80298c:	0f 8c 6f ff ff ff    	jl     802901 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802992:	90                   	nop
  802993:	c9                   	leave  
  802994:	c3                   	ret    

00802995 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802995:	55                   	push   %ebp
  802996:	89 e5                	mov    %esp,%ebp
  802998:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80299b:	a1 38 51 80 00       	mov    0x805138,%eax
  8029a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8029a3:	e9 7c 01 00 00       	jmp    802b24 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8029a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029b1:	0f 86 cf 00 00 00    	jbe    802a86 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8029b7:	a1 48 51 80 00       	mov    0x805148,%eax
  8029bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8029c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cb:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8029ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d1:	8b 50 08             	mov    0x8(%eax),%edx
  8029d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d7:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8029e3:	89 c2                	mov    %eax,%edx
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	8b 50 08             	mov    0x8(%eax),%edx
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	01 c2                	add    %eax,%edx
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8029fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a00:	75 17                	jne    802a19 <alloc_block_FF+0x84>
  802a02:	83 ec 04             	sub    $0x4,%esp
  802a05:	68 a9 42 80 00       	push   $0x8042a9
  802a0a:	68 83 00 00 00       	push   $0x83
  802a0f:	68 37 42 80 00       	push   $0x804237
  802a14:	e8 da de ff ff       	call   8008f3 <_panic>
  802a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1c:	8b 00                	mov    (%eax),%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 10                	je     802a32 <alloc_block_FF+0x9d>
  802a22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a2a:	8b 52 04             	mov    0x4(%edx),%edx
  802a2d:	89 50 04             	mov    %edx,0x4(%eax)
  802a30:	eb 0b                	jmp    802a3d <alloc_block_FF+0xa8>
  802a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a40:	8b 40 04             	mov    0x4(%eax),%eax
  802a43:	85 c0                	test   %eax,%eax
  802a45:	74 0f                	je     802a56 <alloc_block_FF+0xc1>
  802a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4a:	8b 40 04             	mov    0x4(%eax),%eax
  802a4d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a50:	8b 12                	mov    (%edx),%edx
  802a52:	89 10                	mov    %edx,(%eax)
  802a54:	eb 0a                	jmp    802a60 <alloc_block_FF+0xcb>
  802a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a59:	8b 00                	mov    (%eax),%eax
  802a5b:	a3 48 51 80 00       	mov    %eax,0x805148
  802a60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a73:	a1 54 51 80 00       	mov    0x805154,%eax
  802a78:	48                   	dec    %eax
  802a79:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a81:	e9 ad 00 00 00       	jmp    802b33 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a89:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a8f:	0f 85 87 00 00 00    	jne    802b1c <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802a95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a99:	75 17                	jne    802ab2 <alloc_block_FF+0x11d>
  802a9b:	83 ec 04             	sub    $0x4,%esp
  802a9e:	68 a9 42 80 00       	push   $0x8042a9
  802aa3:	68 87 00 00 00       	push   $0x87
  802aa8:	68 37 42 80 00       	push   $0x804237
  802aad:	e8 41 de ff ff       	call   8008f3 <_panic>
  802ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	85 c0                	test   %eax,%eax
  802ab9:	74 10                	je     802acb <alloc_block_FF+0x136>
  802abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abe:	8b 00                	mov    (%eax),%eax
  802ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ac3:	8b 52 04             	mov    0x4(%edx),%edx
  802ac6:	89 50 04             	mov    %edx,0x4(%eax)
  802ac9:	eb 0b                	jmp    802ad6 <alloc_block_FF+0x141>
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 40 04             	mov    0x4(%eax),%eax
  802ad1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 40 04             	mov    0x4(%eax),%eax
  802adc:	85 c0                	test   %eax,%eax
  802ade:	74 0f                	je     802aef <alloc_block_FF+0x15a>
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 04             	mov    0x4(%eax),%eax
  802ae6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae9:	8b 12                	mov    (%edx),%edx
  802aeb:	89 10                	mov    %edx,(%eax)
  802aed:	eb 0a                	jmp    802af9 <alloc_block_FF+0x164>
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	8b 00                	mov    (%eax),%eax
  802af4:	a3 38 51 80 00       	mov    %eax,0x805138
  802af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0c:	a1 44 51 80 00       	mov    0x805144,%eax
  802b11:	48                   	dec    %eax
  802b12:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1a:	eb 17                	jmp    802b33 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1f:	8b 00                	mov    (%eax),%eax
  802b21:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802b24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b28:	0f 85 7a fe ff ff    	jne    8029a8 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802b2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b33:	c9                   	leave  
  802b34:	c3                   	ret    

00802b35 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b35:	55                   	push   %ebp
  802b36:	89 e5                	mov    %esp,%ebp
  802b38:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802b3b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802b43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802b4a:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802b51:	a1 38 51 80 00       	mov    0x805138,%eax
  802b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b59:	e9 d0 00 00 00       	jmp    802c2e <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b61:	8b 40 0c             	mov    0xc(%eax),%eax
  802b64:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b67:	0f 82 b8 00 00 00    	jb     802c25 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b70:	8b 40 0c             	mov    0xc(%eax),%eax
  802b73:	2b 45 08             	sub    0x8(%ebp),%eax
  802b76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802b79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b7c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b7f:	0f 83 a1 00 00 00    	jae    802c26 <alloc_block_BF+0xf1>
				differsize = differance ;
  802b85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b88:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802b91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b95:	0f 85 8b 00 00 00    	jne    802c26 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802b9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b9f:	75 17                	jne    802bb8 <alloc_block_BF+0x83>
  802ba1:	83 ec 04             	sub    $0x4,%esp
  802ba4:	68 a9 42 80 00       	push   $0x8042a9
  802ba9:	68 a0 00 00 00       	push   $0xa0
  802bae:	68 37 42 80 00       	push   $0x804237
  802bb3:	e8 3b dd ff ff       	call   8008f3 <_panic>
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	74 10                	je     802bd1 <alloc_block_BF+0x9c>
  802bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc4:	8b 00                	mov    (%eax),%eax
  802bc6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bc9:	8b 52 04             	mov    0x4(%edx),%edx
  802bcc:	89 50 04             	mov    %edx,0x4(%eax)
  802bcf:	eb 0b                	jmp    802bdc <alloc_block_BF+0xa7>
  802bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd4:	8b 40 04             	mov    0x4(%eax),%eax
  802bd7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 40 04             	mov    0x4(%eax),%eax
  802be2:	85 c0                	test   %eax,%eax
  802be4:	74 0f                	je     802bf5 <alloc_block_BF+0xc0>
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 40 04             	mov    0x4(%eax),%eax
  802bec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bef:	8b 12                	mov    (%edx),%edx
  802bf1:	89 10                	mov    %edx,(%eax)
  802bf3:	eb 0a                	jmp    802bff <alloc_block_BF+0xca>
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 00                	mov    (%eax),%eax
  802bfa:	a3 38 51 80 00       	mov    %eax,0x805138
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c12:	a1 44 51 80 00       	mov    0x805144,%eax
  802c17:	48                   	dec    %eax
  802c18:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	e9 0c 01 00 00       	jmp    802d31 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802c25:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802c26:	a1 40 51 80 00       	mov    0x805140,%eax
  802c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c32:	74 07                	je     802c3b <alloc_block_BF+0x106>
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 00                	mov    (%eax),%eax
  802c39:	eb 05                	jmp    802c40 <alloc_block_BF+0x10b>
  802c3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802c40:	a3 40 51 80 00       	mov    %eax,0x805140
  802c45:	a1 40 51 80 00       	mov    0x805140,%eax
  802c4a:	85 c0                	test   %eax,%eax
  802c4c:	0f 85 0c ff ff ff    	jne    802b5e <alloc_block_BF+0x29>
  802c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c56:	0f 85 02 ff ff ff    	jne    802b5e <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802c5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c60:	0f 84 c6 00 00 00    	je     802d2c <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802c66:	a1 48 51 80 00       	mov    0x805148,%eax
  802c6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802c6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c71:	8b 55 08             	mov    0x8(%ebp),%edx
  802c74:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c7a:	8b 50 08             	mov    0x8(%eax),%edx
  802c7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c80:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c86:	8b 40 0c             	mov    0xc(%eax),%eax
  802c89:	2b 45 08             	sub    0x8(%ebp),%eax
  802c8c:	89 c2                	mov    %eax,%edx
  802c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c91:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c97:	8b 50 08             	mov    0x8(%eax),%edx
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	01 c2                	add    %eax,%edx
  802c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ca2:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802ca5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ca9:	75 17                	jne    802cc2 <alloc_block_BF+0x18d>
  802cab:	83 ec 04             	sub    $0x4,%esp
  802cae:	68 a9 42 80 00       	push   $0x8042a9
  802cb3:	68 af 00 00 00       	push   $0xaf
  802cb8:	68 37 42 80 00       	push   $0x804237
  802cbd:	e8 31 dc ff ff       	call   8008f3 <_panic>
  802cc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc5:	8b 00                	mov    (%eax),%eax
  802cc7:	85 c0                	test   %eax,%eax
  802cc9:	74 10                	je     802cdb <alloc_block_BF+0x1a6>
  802ccb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cce:	8b 00                	mov    (%eax),%eax
  802cd0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cd3:	8b 52 04             	mov    0x4(%edx),%edx
  802cd6:	89 50 04             	mov    %edx,0x4(%eax)
  802cd9:	eb 0b                	jmp    802ce6 <alloc_block_BF+0x1b1>
  802cdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cde:	8b 40 04             	mov    0x4(%eax),%eax
  802ce1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ce6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce9:	8b 40 04             	mov    0x4(%eax),%eax
  802cec:	85 c0                	test   %eax,%eax
  802cee:	74 0f                	je     802cff <alloc_block_BF+0x1ca>
  802cf0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf3:	8b 40 04             	mov    0x4(%eax),%eax
  802cf6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802cf9:	8b 12                	mov    (%edx),%edx
  802cfb:	89 10                	mov    %edx,(%eax)
  802cfd:	eb 0a                	jmp    802d09 <alloc_block_BF+0x1d4>
  802cff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d02:	8b 00                	mov    (%eax),%eax
  802d04:	a3 48 51 80 00       	mov    %eax,0x805148
  802d09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d0c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d15:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d1c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d21:	48                   	dec    %eax
  802d22:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802d27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2a:	eb 05                	jmp    802d31 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d31:	c9                   	leave  
  802d32:	c3                   	ret    

00802d33 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802d33:	55                   	push   %ebp
  802d34:	89 e5                	mov    %esp,%ebp
  802d36:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802d39:	a1 38 51 80 00       	mov    0x805138,%eax
  802d3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802d41:	e9 7c 01 00 00       	jmp    802ec2 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d4f:	0f 86 cf 00 00 00    	jbe    802e24 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802d55:	a1 48 51 80 00       	mov    0x805148,%eax
  802d5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802d5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d60:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d66:	8b 55 08             	mov    0x8(%ebp),%edx
  802d69:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6f:	8b 50 08             	mov    0x8(%eax),%edx
  802d72:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d75:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7e:	2b 45 08             	sub    0x8(%ebp),%eax
  802d81:	89 c2                	mov    %eax,%edx
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 50 08             	mov    0x8(%eax),%edx
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	01 c2                	add    %eax,%edx
  802d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d97:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802d9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d9e:	75 17                	jne    802db7 <alloc_block_NF+0x84>
  802da0:	83 ec 04             	sub    $0x4,%esp
  802da3:	68 a9 42 80 00       	push   $0x8042a9
  802da8:	68 c4 00 00 00       	push   $0xc4
  802dad:	68 37 42 80 00       	push   $0x804237
  802db2:	e8 3c db ff ff       	call   8008f3 <_panic>
  802db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	85 c0                	test   %eax,%eax
  802dbe:	74 10                	je     802dd0 <alloc_block_NF+0x9d>
  802dc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc3:	8b 00                	mov    (%eax),%eax
  802dc5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dc8:	8b 52 04             	mov    0x4(%edx),%edx
  802dcb:	89 50 04             	mov    %edx,0x4(%eax)
  802dce:	eb 0b                	jmp    802ddb <alloc_block_NF+0xa8>
  802dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd3:	8b 40 04             	mov    0x4(%eax),%eax
  802dd6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 0f                	je     802df4 <alloc_block_NF+0xc1>
  802de5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802de8:	8b 40 04             	mov    0x4(%eax),%eax
  802deb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dee:	8b 12                	mov    (%edx),%edx
  802df0:	89 10                	mov    %edx,(%eax)
  802df2:	eb 0a                	jmp    802dfe <alloc_block_NF+0xcb>
  802df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df7:	8b 00                	mov    (%eax),%eax
  802df9:	a3 48 51 80 00       	mov    %eax,0x805148
  802dfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e01:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e07:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e11:	a1 54 51 80 00       	mov    0x805154,%eax
  802e16:	48                   	dec    %eax
  802e17:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802e1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e1f:	e9 ad 00 00 00       	jmp    802ed1 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e27:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e2d:	0f 85 87 00 00 00    	jne    802eba <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802e33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e37:	75 17                	jne    802e50 <alloc_block_NF+0x11d>
  802e39:	83 ec 04             	sub    $0x4,%esp
  802e3c:	68 a9 42 80 00       	push   $0x8042a9
  802e41:	68 c8 00 00 00       	push   $0xc8
  802e46:	68 37 42 80 00       	push   $0x804237
  802e4b:	e8 a3 da ff ff       	call   8008f3 <_panic>
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	8b 00                	mov    (%eax),%eax
  802e55:	85 c0                	test   %eax,%eax
  802e57:	74 10                	je     802e69 <alloc_block_NF+0x136>
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e61:	8b 52 04             	mov    0x4(%edx),%edx
  802e64:	89 50 04             	mov    %edx,0x4(%eax)
  802e67:	eb 0b                	jmp    802e74 <alloc_block_NF+0x141>
  802e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6c:	8b 40 04             	mov    0x4(%eax),%eax
  802e6f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	85 c0                	test   %eax,%eax
  802e7c:	74 0f                	je     802e8d <alloc_block_NF+0x15a>
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 40 04             	mov    0x4(%eax),%eax
  802e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e87:	8b 12                	mov    (%edx),%edx
  802e89:	89 10                	mov    %edx,(%eax)
  802e8b:	eb 0a                	jmp    802e97 <alloc_block_NF+0x164>
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	8b 00                	mov    (%eax),%eax
  802e92:	a3 38 51 80 00       	mov    %eax,0x805138
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eaa:	a1 44 51 80 00       	mov    0x805144,%eax
  802eaf:	48                   	dec    %eax
  802eb0:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb8:	eb 17                	jmp    802ed1 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802ec2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec6:	0f 85 7a fe ff ff    	jne    802d46 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802ecc:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802ed1:	c9                   	leave  
  802ed2:	c3                   	ret    

00802ed3 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ed3:	55                   	push   %ebp
  802ed4:	89 e5                	mov    %esp,%ebp
  802ed6:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802ed9:	a1 38 51 80 00       	mov    0x805138,%eax
  802ede:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802ee1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802ee9:	a1 44 51 80 00       	mov    0x805144,%eax
  802eee:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802ef1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ef5:	75 68                	jne    802f5f <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802ef7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802efb:	75 17                	jne    802f14 <insert_sorted_with_merge_freeList+0x41>
  802efd:	83 ec 04             	sub    $0x4,%esp
  802f00:	68 14 42 80 00       	push   $0x804214
  802f05:	68 da 00 00 00       	push   $0xda
  802f0a:	68 37 42 80 00       	push   $0x804237
  802f0f:	e8 df d9 ff ff       	call   8008f3 <_panic>
  802f14:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	89 10                	mov    %edx,(%eax)
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 00                	mov    (%eax),%eax
  802f24:	85 c0                	test   %eax,%eax
  802f26:	74 0d                	je     802f35 <insert_sorted_with_merge_freeList+0x62>
  802f28:	a1 38 51 80 00       	mov    0x805138,%eax
  802f2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802f30:	89 50 04             	mov    %edx,0x4(%eax)
  802f33:	eb 08                	jmp    802f3d <insert_sorted_with_merge_freeList+0x6a>
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	a3 38 51 80 00       	mov    %eax,0x805138
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f54:	40                   	inc    %eax
  802f55:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802f5a:	e9 49 07 00 00       	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f62:	8b 50 08             	mov    0x8(%eax),%edx
  802f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f68:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6b:	01 c2                	add    %eax,%edx
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	8b 40 08             	mov    0x8(%eax),%eax
  802f73:	39 c2                	cmp    %eax,%edx
  802f75:	73 77                	jae    802fee <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802f77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	85 c0                	test   %eax,%eax
  802f7e:	75 6e                	jne    802fee <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802f80:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f84:	74 68                	je     802fee <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802f86:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8a:	75 17                	jne    802fa3 <insert_sorted_with_merge_freeList+0xd0>
  802f8c:	83 ec 04             	sub    $0x4,%esp
  802f8f:	68 50 42 80 00       	push   $0x804250
  802f94:	68 e0 00 00 00       	push   $0xe0
  802f99:	68 37 42 80 00       	push   $0x804237
  802f9e:	e8 50 d9 ff ff       	call   8008f3 <_panic>
  802fa3:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	89 50 04             	mov    %edx,0x4(%eax)
  802faf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 0c                	je     802fc5 <insert_sorted_with_merge_freeList+0xf2>
  802fb9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	eb 08                	jmp    802fcd <insert_sorted_with_merge_freeList+0xfa>
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	a3 38 51 80 00       	mov    %eax,0x805138
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fde:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe3:	40                   	inc    %eax
  802fe4:	a3 44 51 80 00       	mov    %eax,0x805144
  802fe9:	e9 ba 06 00 00       	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	8b 40 08             	mov    0x8(%eax),%eax
  802ffa:	01 c2                	add    %eax,%edx
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 40 08             	mov    0x8(%eax),%eax
  803002:	39 c2                	cmp    %eax,%edx
  803004:	73 78                	jae    80307e <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 40 04             	mov    0x4(%eax),%eax
  80300c:	85 c0                	test   %eax,%eax
  80300e:	75 6e                	jne    80307e <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803010:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803014:	74 68                	je     80307e <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  803016:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80301a:	75 17                	jne    803033 <insert_sorted_with_merge_freeList+0x160>
  80301c:	83 ec 04             	sub    $0x4,%esp
  80301f:	68 14 42 80 00       	push   $0x804214
  803024:	68 e6 00 00 00       	push   $0xe6
  803029:	68 37 42 80 00       	push   $0x804237
  80302e:	e8 c0 d8 ff ff       	call   8008f3 <_panic>
  803033:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803039:	8b 45 08             	mov    0x8(%ebp),%eax
  80303c:	89 10                	mov    %edx,(%eax)
  80303e:	8b 45 08             	mov    0x8(%ebp),%eax
  803041:	8b 00                	mov    (%eax),%eax
  803043:	85 c0                	test   %eax,%eax
  803045:	74 0d                	je     803054 <insert_sorted_with_merge_freeList+0x181>
  803047:	a1 38 51 80 00       	mov    0x805138,%eax
  80304c:	8b 55 08             	mov    0x8(%ebp),%edx
  80304f:	89 50 04             	mov    %edx,0x4(%eax)
  803052:	eb 08                	jmp    80305c <insert_sorted_with_merge_freeList+0x189>
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	a3 38 51 80 00       	mov    %eax,0x805138
  803064:	8b 45 08             	mov    0x8(%ebp),%eax
  803067:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306e:	a1 44 51 80 00       	mov    0x805144,%eax
  803073:	40                   	inc    %eax
  803074:	a3 44 51 80 00       	mov    %eax,0x805144
  803079:	e9 2a 06 00 00       	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80307e:	a1 38 51 80 00       	mov    0x805138,%eax
  803083:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803086:	e9 ed 05 00 00       	jmp    803678 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80308b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803093:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803097:	0f 84 a7 00 00 00    	je     803144 <insert_sorted_with_merge_freeList+0x271>
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a6:	8b 40 08             	mov    0x8(%eax),%eax
  8030a9:	01 c2                	add    %eax,%edx
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 40 08             	mov    0x8(%eax),%eax
  8030b1:	39 c2                	cmp    %eax,%edx
  8030b3:	0f 83 8b 00 00 00    	jae    803144 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	8b 50 0c             	mov    0xc(%eax),%edx
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	8b 40 08             	mov    0x8(%eax),%eax
  8030c5:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  8030c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ca:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  8030cd:	39 c2                	cmp    %eax,%edx
  8030cf:	73 73                	jae    803144 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  8030d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d5:	74 06                	je     8030dd <insert_sorted_with_merge_freeList+0x20a>
  8030d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030db:	75 17                	jne    8030f4 <insert_sorted_with_merge_freeList+0x221>
  8030dd:	83 ec 04             	sub    $0x4,%esp
  8030e0:	68 c8 42 80 00       	push   $0x8042c8
  8030e5:	68 f0 00 00 00       	push   $0xf0
  8030ea:	68 37 42 80 00       	push   $0x804237
  8030ef:	e8 ff d7 ff ff       	call   8008f3 <_panic>
  8030f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f7:	8b 10                	mov    (%eax),%edx
  8030f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fc:	89 10                	mov    %edx,(%eax)
  8030fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	85 c0                	test   %eax,%eax
  803105:	74 0b                	je     803112 <insert_sorted_with_merge_freeList+0x23f>
  803107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310a:	8b 00                	mov    (%eax),%eax
  80310c:	8b 55 08             	mov    0x8(%ebp),%edx
  80310f:	89 50 04             	mov    %edx,0x4(%eax)
  803112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803115:	8b 55 08             	mov    0x8(%ebp),%edx
  803118:	89 10                	mov    %edx,(%eax)
  80311a:	8b 45 08             	mov    0x8(%ebp),%eax
  80311d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803120:	89 50 04             	mov    %edx,0x4(%eax)
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	85 c0                	test   %eax,%eax
  80312a:	75 08                	jne    803134 <insert_sorted_with_merge_freeList+0x261>
  80312c:	8b 45 08             	mov    0x8(%ebp),%eax
  80312f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803134:	a1 44 51 80 00       	mov    0x805144,%eax
  803139:	40                   	inc    %eax
  80313a:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  80313f:	e9 64 05 00 00       	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803144:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803149:	8b 50 0c             	mov    0xc(%eax),%edx
  80314c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803151:	8b 40 08             	mov    0x8(%eax),%eax
  803154:	01 c2                	add    %eax,%edx
  803156:	8b 45 08             	mov    0x8(%ebp),%eax
  803159:	8b 40 08             	mov    0x8(%eax),%eax
  80315c:	39 c2                	cmp    %eax,%edx
  80315e:	0f 85 b1 00 00 00    	jne    803215 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803164:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	0f 84 a4 00 00 00    	je     803215 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803171:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803176:	8b 00                	mov    (%eax),%eax
  803178:	85 c0                	test   %eax,%eax
  80317a:	0f 85 95 00 00 00    	jne    803215 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803180:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803185:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80318b:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80318e:	8b 55 08             	mov    0x8(%ebp),%edx
  803191:	8b 52 0c             	mov    0xc(%edx),%edx
  803194:	01 ca                	add    %ecx,%edx
  803196:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803199:	8b 45 08             	mov    0x8(%ebp),%eax
  80319c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8031ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b1:	75 17                	jne    8031ca <insert_sorted_with_merge_freeList+0x2f7>
  8031b3:	83 ec 04             	sub    $0x4,%esp
  8031b6:	68 14 42 80 00       	push   $0x804214
  8031bb:	68 ff 00 00 00       	push   $0xff
  8031c0:	68 37 42 80 00       	push   $0x804237
  8031c5:	e8 29 d7 ff ff       	call   8008f3 <_panic>
  8031ca:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	89 10                	mov    %edx,(%eax)
  8031d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d8:	8b 00                	mov    (%eax),%eax
  8031da:	85 c0                	test   %eax,%eax
  8031dc:	74 0d                	je     8031eb <insert_sorted_with_merge_freeList+0x318>
  8031de:	a1 48 51 80 00       	mov    0x805148,%eax
  8031e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e6:	89 50 04             	mov    %edx,0x4(%eax)
  8031e9:	eb 08                	jmp    8031f3 <insert_sorted_with_merge_freeList+0x320>
  8031eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ee:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f6:	a3 48 51 80 00       	mov    %eax,0x805148
  8031fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803205:	a1 54 51 80 00       	mov    0x805154,%eax
  80320a:	40                   	inc    %eax
  80320b:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803210:	e9 93 04 00 00       	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  803215:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803218:	8b 50 08             	mov    0x8(%eax),%edx
  80321b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80321e:	8b 40 0c             	mov    0xc(%eax),%eax
  803221:	01 c2                	add    %eax,%edx
  803223:	8b 45 08             	mov    0x8(%ebp),%eax
  803226:	8b 40 08             	mov    0x8(%eax),%eax
  803229:	39 c2                	cmp    %eax,%edx
  80322b:	0f 85 ae 00 00 00    	jne    8032df <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	8b 50 0c             	mov    0xc(%eax),%edx
  803237:	8b 45 08             	mov    0x8(%ebp),%eax
  80323a:	8b 40 08             	mov    0x8(%eax),%eax
  80323d:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  80323f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803242:	8b 00                	mov    (%eax),%eax
  803244:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803247:	39 c2                	cmp    %eax,%edx
  803249:	0f 84 90 00 00 00    	je     8032df <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  80324f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803252:	8b 50 0c             	mov    0xc(%eax),%edx
  803255:	8b 45 08             	mov    0x8(%ebp),%eax
  803258:	8b 40 0c             	mov    0xc(%eax),%eax
  80325b:	01 c2                	add    %eax,%edx
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80326d:	8b 45 08             	mov    0x8(%ebp),%eax
  803270:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80327b:	75 17                	jne    803294 <insert_sorted_with_merge_freeList+0x3c1>
  80327d:	83 ec 04             	sub    $0x4,%esp
  803280:	68 14 42 80 00       	push   $0x804214
  803285:	68 0b 01 00 00       	push   $0x10b
  80328a:	68 37 42 80 00       	push   $0x804237
  80328f:	e8 5f d6 ff ff       	call   8008f3 <_panic>
  803294:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	89 10                	mov    %edx,(%eax)
  80329f:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a2:	8b 00                	mov    (%eax),%eax
  8032a4:	85 c0                	test   %eax,%eax
  8032a6:	74 0d                	je     8032b5 <insert_sorted_with_merge_freeList+0x3e2>
  8032a8:	a1 48 51 80 00       	mov    0x805148,%eax
  8032ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8032b0:	89 50 04             	mov    %edx,0x4(%eax)
  8032b3:	eb 08                	jmp    8032bd <insert_sorted_with_merge_freeList+0x3ea>
  8032b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c0:	a3 48 51 80 00       	mov    %eax,0x805148
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032cf:	a1 54 51 80 00       	mov    0x805154,%eax
  8032d4:	40                   	inc    %eax
  8032d5:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8032da:	e9 c9 03 00 00       	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8032df:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e2:	8b 50 0c             	mov    0xc(%eax),%edx
  8032e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e8:	8b 40 08             	mov    0x8(%eax),%eax
  8032eb:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8032ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f0:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8032f3:	39 c2                	cmp    %eax,%edx
  8032f5:	0f 85 bb 00 00 00    	jne    8033b6 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8032fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032ff:	0f 84 b1 00 00 00    	je     8033b6 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803308:	8b 40 04             	mov    0x4(%eax),%eax
  80330b:	85 c0                	test   %eax,%eax
  80330d:	0f 85 a3 00 00 00    	jne    8033b6 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803313:	a1 38 51 80 00       	mov    0x805138,%eax
  803318:	8b 55 08             	mov    0x8(%ebp),%edx
  80331b:	8b 52 08             	mov    0x8(%edx),%edx
  80331e:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803321:	a1 38 51 80 00       	mov    0x805138,%eax
  803326:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80332c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80332f:	8b 55 08             	mov    0x8(%ebp),%edx
  803332:	8b 52 0c             	mov    0xc(%edx),%edx
  803335:	01 ca                	add    %ecx,%edx
  803337:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803344:	8b 45 08             	mov    0x8(%ebp),%eax
  803347:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80334e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803352:	75 17                	jne    80336b <insert_sorted_with_merge_freeList+0x498>
  803354:	83 ec 04             	sub    $0x4,%esp
  803357:	68 14 42 80 00       	push   $0x804214
  80335c:	68 17 01 00 00       	push   $0x117
  803361:	68 37 42 80 00       	push   $0x804237
  803366:	e8 88 d5 ff ff       	call   8008f3 <_panic>
  80336b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803371:	8b 45 08             	mov    0x8(%ebp),%eax
  803374:	89 10                	mov    %edx,(%eax)
  803376:	8b 45 08             	mov    0x8(%ebp),%eax
  803379:	8b 00                	mov    (%eax),%eax
  80337b:	85 c0                	test   %eax,%eax
  80337d:	74 0d                	je     80338c <insert_sorted_with_merge_freeList+0x4b9>
  80337f:	a1 48 51 80 00       	mov    0x805148,%eax
  803384:	8b 55 08             	mov    0x8(%ebp),%edx
  803387:	89 50 04             	mov    %edx,0x4(%eax)
  80338a:	eb 08                	jmp    803394 <insert_sorted_with_merge_freeList+0x4c1>
  80338c:	8b 45 08             	mov    0x8(%ebp),%eax
  80338f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	a3 48 51 80 00       	mov    %eax,0x805148
  80339c:	8b 45 08             	mov    0x8(%ebp),%eax
  80339f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a6:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ab:	40                   	inc    %eax
  8033ac:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8033b1:	e9 f2 02 00 00       	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  8033b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b9:	8b 50 08             	mov    0x8(%eax),%edx
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8033c2:	01 c2                	add    %eax,%edx
  8033c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c7:	8b 40 08             	mov    0x8(%eax),%eax
  8033ca:	39 c2                	cmp    %eax,%edx
  8033cc:	0f 85 be 00 00 00    	jne    803490 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  8033d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d5:	8b 40 04             	mov    0x4(%eax),%eax
  8033d8:	8b 50 08             	mov    0x8(%eax),%edx
  8033db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033de:	8b 40 04             	mov    0x4(%eax),%eax
  8033e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8033e4:	01 c2                	add    %eax,%edx
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	8b 40 08             	mov    0x8(%eax),%eax
  8033ec:	39 c2                	cmp    %eax,%edx
  8033ee:	0f 84 9c 00 00 00    	je     803490 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	8b 50 08             	mov    0x8(%eax),%edx
  8033fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033fd:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803403:	8b 50 0c             	mov    0xc(%eax),%edx
  803406:	8b 45 08             	mov    0x8(%ebp),%eax
  803409:	8b 40 0c             	mov    0xc(%eax),%eax
  80340c:	01 c2                	add    %eax,%edx
  80340e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803411:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803414:	8b 45 08             	mov    0x8(%ebp),%eax
  803417:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80341e:	8b 45 08             	mov    0x8(%ebp),%eax
  803421:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803428:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342c:	75 17                	jne    803445 <insert_sorted_with_merge_freeList+0x572>
  80342e:	83 ec 04             	sub    $0x4,%esp
  803431:	68 14 42 80 00       	push   $0x804214
  803436:	68 26 01 00 00       	push   $0x126
  80343b:	68 37 42 80 00       	push   $0x804237
  803440:	e8 ae d4 ff ff       	call   8008f3 <_panic>
  803445:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80344b:	8b 45 08             	mov    0x8(%ebp),%eax
  80344e:	89 10                	mov    %edx,(%eax)
  803450:	8b 45 08             	mov    0x8(%ebp),%eax
  803453:	8b 00                	mov    (%eax),%eax
  803455:	85 c0                	test   %eax,%eax
  803457:	74 0d                	je     803466 <insert_sorted_with_merge_freeList+0x593>
  803459:	a1 48 51 80 00       	mov    0x805148,%eax
  80345e:	8b 55 08             	mov    0x8(%ebp),%edx
  803461:	89 50 04             	mov    %edx,0x4(%eax)
  803464:	eb 08                	jmp    80346e <insert_sorted_with_merge_freeList+0x59b>
  803466:	8b 45 08             	mov    0x8(%ebp),%eax
  803469:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80346e:	8b 45 08             	mov    0x8(%ebp),%eax
  803471:	a3 48 51 80 00       	mov    %eax,0x805148
  803476:	8b 45 08             	mov    0x8(%ebp),%eax
  803479:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803480:	a1 54 51 80 00       	mov    0x805154,%eax
  803485:	40                   	inc    %eax
  803486:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  80348b:	e9 18 02 00 00       	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803493:	8b 50 0c             	mov    0xc(%eax),%edx
  803496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803499:	8b 40 08             	mov    0x8(%eax),%eax
  80349c:	01 c2                	add    %eax,%edx
  80349e:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a1:	8b 40 08             	mov    0x8(%eax),%eax
  8034a4:	39 c2                	cmp    %eax,%edx
  8034a6:	0f 85 c4 01 00 00    	jne    803670 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  8034ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8034af:	8b 50 0c             	mov    0xc(%eax),%edx
  8034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b5:	8b 40 08             	mov    0x8(%eax),%eax
  8034b8:	01 c2                	add    %eax,%edx
  8034ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034bd:	8b 00                	mov    (%eax),%eax
  8034bf:	8b 40 08             	mov    0x8(%eax),%eax
  8034c2:	39 c2                	cmp    %eax,%edx
  8034c4:	0f 85 a6 01 00 00    	jne    803670 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8034ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034ce:	0f 84 9c 01 00 00    	je     803670 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  8034d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d7:	8b 50 0c             	mov    0xc(%eax),%edx
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e0:	01 c2                	add    %eax,%edx
  8034e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e5:	8b 00                	mov    (%eax),%eax
  8034e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8034ea:	01 c2                	add    %eax,%edx
  8034ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ef:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8034f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8034fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  803506:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80350a:	75 17                	jne    803523 <insert_sorted_with_merge_freeList+0x650>
  80350c:	83 ec 04             	sub    $0x4,%esp
  80350f:	68 14 42 80 00       	push   $0x804214
  803514:	68 32 01 00 00       	push   $0x132
  803519:	68 37 42 80 00       	push   $0x804237
  80351e:	e8 d0 d3 ff ff       	call   8008f3 <_panic>
  803523:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803529:	8b 45 08             	mov    0x8(%ebp),%eax
  80352c:	89 10                	mov    %edx,(%eax)
  80352e:	8b 45 08             	mov    0x8(%ebp),%eax
  803531:	8b 00                	mov    (%eax),%eax
  803533:	85 c0                	test   %eax,%eax
  803535:	74 0d                	je     803544 <insert_sorted_with_merge_freeList+0x671>
  803537:	a1 48 51 80 00       	mov    0x805148,%eax
  80353c:	8b 55 08             	mov    0x8(%ebp),%edx
  80353f:	89 50 04             	mov    %edx,0x4(%eax)
  803542:	eb 08                	jmp    80354c <insert_sorted_with_merge_freeList+0x679>
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	a3 48 51 80 00       	mov    %eax,0x805148
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80355e:	a1 54 51 80 00       	mov    0x805154,%eax
  803563:	40                   	inc    %eax
  803564:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356c:	8b 00                	mov    (%eax),%eax
  80356e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803578:	8b 00                	mov    (%eax),%eax
  80357a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803584:	8b 00                	mov    (%eax),%eax
  803586:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803589:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80358d:	75 17                	jne    8035a6 <insert_sorted_with_merge_freeList+0x6d3>
  80358f:	83 ec 04             	sub    $0x4,%esp
  803592:	68 a9 42 80 00       	push   $0x8042a9
  803597:	68 36 01 00 00       	push   $0x136
  80359c:	68 37 42 80 00       	push   $0x804237
  8035a1:	e8 4d d3 ff ff       	call   8008f3 <_panic>
  8035a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035a9:	8b 00                	mov    (%eax),%eax
  8035ab:	85 c0                	test   %eax,%eax
  8035ad:	74 10                	je     8035bf <insert_sorted_with_merge_freeList+0x6ec>
  8035af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035b2:	8b 00                	mov    (%eax),%eax
  8035b4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035b7:	8b 52 04             	mov    0x4(%edx),%edx
  8035ba:	89 50 04             	mov    %edx,0x4(%eax)
  8035bd:	eb 0b                	jmp    8035ca <insert_sorted_with_merge_freeList+0x6f7>
  8035bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c2:	8b 40 04             	mov    0x4(%eax),%eax
  8035c5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035cd:	8b 40 04             	mov    0x4(%eax),%eax
  8035d0:	85 c0                	test   %eax,%eax
  8035d2:	74 0f                	je     8035e3 <insert_sorted_with_merge_freeList+0x710>
  8035d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035d7:	8b 40 04             	mov    0x4(%eax),%eax
  8035da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035dd:	8b 12                	mov    (%edx),%edx
  8035df:	89 10                	mov    %edx,(%eax)
  8035e1:	eb 0a                	jmp    8035ed <insert_sorted_with_merge_freeList+0x71a>
  8035e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e6:	8b 00                	mov    (%eax),%eax
  8035e8:	a3 38 51 80 00       	mov    %eax,0x805138
  8035ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803600:	a1 44 51 80 00       	mov    0x805144,%eax
  803605:	48                   	dec    %eax
  803606:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80360b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80360f:	75 17                	jne    803628 <insert_sorted_with_merge_freeList+0x755>
  803611:	83 ec 04             	sub    $0x4,%esp
  803614:	68 14 42 80 00       	push   $0x804214
  803619:	68 37 01 00 00       	push   $0x137
  80361e:	68 37 42 80 00       	push   $0x804237
  803623:	e8 cb d2 ff ff       	call   8008f3 <_panic>
  803628:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80362e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803631:	89 10                	mov    %edx,(%eax)
  803633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	85 c0                	test   %eax,%eax
  80363a:	74 0d                	je     803649 <insert_sorted_with_merge_freeList+0x776>
  80363c:	a1 48 51 80 00       	mov    0x805148,%eax
  803641:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803644:	89 50 04             	mov    %edx,0x4(%eax)
  803647:	eb 08                	jmp    803651 <insert_sorted_with_merge_freeList+0x77e>
  803649:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80364c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803651:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803654:	a3 48 51 80 00       	mov    %eax,0x805148
  803659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80365c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803663:	a1 54 51 80 00       	mov    0x805154,%eax
  803668:	40                   	inc    %eax
  803669:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  80366e:	eb 38                	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803670:	a1 40 51 80 00       	mov    0x805140,%eax
  803675:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367c:	74 07                	je     803685 <insert_sorted_with_merge_freeList+0x7b2>
  80367e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803681:	8b 00                	mov    (%eax),%eax
  803683:	eb 05                	jmp    80368a <insert_sorted_with_merge_freeList+0x7b7>
  803685:	b8 00 00 00 00       	mov    $0x0,%eax
  80368a:	a3 40 51 80 00       	mov    %eax,0x805140
  80368f:	a1 40 51 80 00       	mov    0x805140,%eax
  803694:	85 c0                	test   %eax,%eax
  803696:	0f 85 ef f9 ff ff    	jne    80308b <insert_sorted_with_merge_freeList+0x1b8>
  80369c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a0:	0f 85 e5 f9 ff ff    	jne    80308b <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8036a6:	eb 00                	jmp    8036a8 <insert_sorted_with_merge_freeList+0x7d5>
  8036a8:	90                   	nop
  8036a9:	c9                   	leave  
  8036aa:	c3                   	ret    
  8036ab:	90                   	nop

008036ac <__udivdi3>:
  8036ac:	55                   	push   %ebp
  8036ad:	57                   	push   %edi
  8036ae:	56                   	push   %esi
  8036af:	53                   	push   %ebx
  8036b0:	83 ec 1c             	sub    $0x1c,%esp
  8036b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036c3:	89 ca                	mov    %ecx,%edx
  8036c5:	89 f8                	mov    %edi,%eax
  8036c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8036cb:	85 f6                	test   %esi,%esi
  8036cd:	75 2d                	jne    8036fc <__udivdi3+0x50>
  8036cf:	39 cf                	cmp    %ecx,%edi
  8036d1:	77 65                	ja     803738 <__udivdi3+0x8c>
  8036d3:	89 fd                	mov    %edi,%ebp
  8036d5:	85 ff                	test   %edi,%edi
  8036d7:	75 0b                	jne    8036e4 <__udivdi3+0x38>
  8036d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8036de:	31 d2                	xor    %edx,%edx
  8036e0:	f7 f7                	div    %edi
  8036e2:	89 c5                	mov    %eax,%ebp
  8036e4:	31 d2                	xor    %edx,%edx
  8036e6:	89 c8                	mov    %ecx,%eax
  8036e8:	f7 f5                	div    %ebp
  8036ea:	89 c1                	mov    %eax,%ecx
  8036ec:	89 d8                	mov    %ebx,%eax
  8036ee:	f7 f5                	div    %ebp
  8036f0:	89 cf                	mov    %ecx,%edi
  8036f2:	89 fa                	mov    %edi,%edx
  8036f4:	83 c4 1c             	add    $0x1c,%esp
  8036f7:	5b                   	pop    %ebx
  8036f8:	5e                   	pop    %esi
  8036f9:	5f                   	pop    %edi
  8036fa:	5d                   	pop    %ebp
  8036fb:	c3                   	ret    
  8036fc:	39 ce                	cmp    %ecx,%esi
  8036fe:	77 28                	ja     803728 <__udivdi3+0x7c>
  803700:	0f bd fe             	bsr    %esi,%edi
  803703:	83 f7 1f             	xor    $0x1f,%edi
  803706:	75 40                	jne    803748 <__udivdi3+0x9c>
  803708:	39 ce                	cmp    %ecx,%esi
  80370a:	72 0a                	jb     803716 <__udivdi3+0x6a>
  80370c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803710:	0f 87 9e 00 00 00    	ja     8037b4 <__udivdi3+0x108>
  803716:	b8 01 00 00 00       	mov    $0x1,%eax
  80371b:	89 fa                	mov    %edi,%edx
  80371d:	83 c4 1c             	add    $0x1c,%esp
  803720:	5b                   	pop    %ebx
  803721:	5e                   	pop    %esi
  803722:	5f                   	pop    %edi
  803723:	5d                   	pop    %ebp
  803724:	c3                   	ret    
  803725:	8d 76 00             	lea    0x0(%esi),%esi
  803728:	31 ff                	xor    %edi,%edi
  80372a:	31 c0                	xor    %eax,%eax
  80372c:	89 fa                	mov    %edi,%edx
  80372e:	83 c4 1c             	add    $0x1c,%esp
  803731:	5b                   	pop    %ebx
  803732:	5e                   	pop    %esi
  803733:	5f                   	pop    %edi
  803734:	5d                   	pop    %ebp
  803735:	c3                   	ret    
  803736:	66 90                	xchg   %ax,%ax
  803738:	89 d8                	mov    %ebx,%eax
  80373a:	f7 f7                	div    %edi
  80373c:	31 ff                	xor    %edi,%edi
  80373e:	89 fa                	mov    %edi,%edx
  803740:	83 c4 1c             	add    $0x1c,%esp
  803743:	5b                   	pop    %ebx
  803744:	5e                   	pop    %esi
  803745:	5f                   	pop    %edi
  803746:	5d                   	pop    %ebp
  803747:	c3                   	ret    
  803748:	bd 20 00 00 00       	mov    $0x20,%ebp
  80374d:	89 eb                	mov    %ebp,%ebx
  80374f:	29 fb                	sub    %edi,%ebx
  803751:	89 f9                	mov    %edi,%ecx
  803753:	d3 e6                	shl    %cl,%esi
  803755:	89 c5                	mov    %eax,%ebp
  803757:	88 d9                	mov    %bl,%cl
  803759:	d3 ed                	shr    %cl,%ebp
  80375b:	89 e9                	mov    %ebp,%ecx
  80375d:	09 f1                	or     %esi,%ecx
  80375f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803763:	89 f9                	mov    %edi,%ecx
  803765:	d3 e0                	shl    %cl,%eax
  803767:	89 c5                	mov    %eax,%ebp
  803769:	89 d6                	mov    %edx,%esi
  80376b:	88 d9                	mov    %bl,%cl
  80376d:	d3 ee                	shr    %cl,%esi
  80376f:	89 f9                	mov    %edi,%ecx
  803771:	d3 e2                	shl    %cl,%edx
  803773:	8b 44 24 08          	mov    0x8(%esp),%eax
  803777:	88 d9                	mov    %bl,%cl
  803779:	d3 e8                	shr    %cl,%eax
  80377b:	09 c2                	or     %eax,%edx
  80377d:	89 d0                	mov    %edx,%eax
  80377f:	89 f2                	mov    %esi,%edx
  803781:	f7 74 24 0c          	divl   0xc(%esp)
  803785:	89 d6                	mov    %edx,%esi
  803787:	89 c3                	mov    %eax,%ebx
  803789:	f7 e5                	mul    %ebp
  80378b:	39 d6                	cmp    %edx,%esi
  80378d:	72 19                	jb     8037a8 <__udivdi3+0xfc>
  80378f:	74 0b                	je     80379c <__udivdi3+0xf0>
  803791:	89 d8                	mov    %ebx,%eax
  803793:	31 ff                	xor    %edi,%edi
  803795:	e9 58 ff ff ff       	jmp    8036f2 <__udivdi3+0x46>
  80379a:	66 90                	xchg   %ax,%ax
  80379c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037a0:	89 f9                	mov    %edi,%ecx
  8037a2:	d3 e2                	shl    %cl,%edx
  8037a4:	39 c2                	cmp    %eax,%edx
  8037a6:	73 e9                	jae    803791 <__udivdi3+0xe5>
  8037a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037ab:	31 ff                	xor    %edi,%edi
  8037ad:	e9 40 ff ff ff       	jmp    8036f2 <__udivdi3+0x46>
  8037b2:	66 90                	xchg   %ax,%ax
  8037b4:	31 c0                	xor    %eax,%eax
  8037b6:	e9 37 ff ff ff       	jmp    8036f2 <__udivdi3+0x46>
  8037bb:	90                   	nop

008037bc <__umoddi3>:
  8037bc:	55                   	push   %ebp
  8037bd:	57                   	push   %edi
  8037be:	56                   	push   %esi
  8037bf:	53                   	push   %ebx
  8037c0:	83 ec 1c             	sub    $0x1c,%esp
  8037c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8037cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8037cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8037d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8037db:	89 f3                	mov    %esi,%ebx
  8037dd:	89 fa                	mov    %edi,%edx
  8037df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037e3:	89 34 24             	mov    %esi,(%esp)
  8037e6:	85 c0                	test   %eax,%eax
  8037e8:	75 1a                	jne    803804 <__umoddi3+0x48>
  8037ea:	39 f7                	cmp    %esi,%edi
  8037ec:	0f 86 a2 00 00 00    	jbe    803894 <__umoddi3+0xd8>
  8037f2:	89 c8                	mov    %ecx,%eax
  8037f4:	89 f2                	mov    %esi,%edx
  8037f6:	f7 f7                	div    %edi
  8037f8:	89 d0                	mov    %edx,%eax
  8037fa:	31 d2                	xor    %edx,%edx
  8037fc:	83 c4 1c             	add    $0x1c,%esp
  8037ff:	5b                   	pop    %ebx
  803800:	5e                   	pop    %esi
  803801:	5f                   	pop    %edi
  803802:	5d                   	pop    %ebp
  803803:	c3                   	ret    
  803804:	39 f0                	cmp    %esi,%eax
  803806:	0f 87 ac 00 00 00    	ja     8038b8 <__umoddi3+0xfc>
  80380c:	0f bd e8             	bsr    %eax,%ebp
  80380f:	83 f5 1f             	xor    $0x1f,%ebp
  803812:	0f 84 ac 00 00 00    	je     8038c4 <__umoddi3+0x108>
  803818:	bf 20 00 00 00       	mov    $0x20,%edi
  80381d:	29 ef                	sub    %ebp,%edi
  80381f:	89 fe                	mov    %edi,%esi
  803821:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803825:	89 e9                	mov    %ebp,%ecx
  803827:	d3 e0                	shl    %cl,%eax
  803829:	89 d7                	mov    %edx,%edi
  80382b:	89 f1                	mov    %esi,%ecx
  80382d:	d3 ef                	shr    %cl,%edi
  80382f:	09 c7                	or     %eax,%edi
  803831:	89 e9                	mov    %ebp,%ecx
  803833:	d3 e2                	shl    %cl,%edx
  803835:	89 14 24             	mov    %edx,(%esp)
  803838:	89 d8                	mov    %ebx,%eax
  80383a:	d3 e0                	shl    %cl,%eax
  80383c:	89 c2                	mov    %eax,%edx
  80383e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803842:	d3 e0                	shl    %cl,%eax
  803844:	89 44 24 04          	mov    %eax,0x4(%esp)
  803848:	8b 44 24 08          	mov    0x8(%esp),%eax
  80384c:	89 f1                	mov    %esi,%ecx
  80384e:	d3 e8                	shr    %cl,%eax
  803850:	09 d0                	or     %edx,%eax
  803852:	d3 eb                	shr    %cl,%ebx
  803854:	89 da                	mov    %ebx,%edx
  803856:	f7 f7                	div    %edi
  803858:	89 d3                	mov    %edx,%ebx
  80385a:	f7 24 24             	mull   (%esp)
  80385d:	89 c6                	mov    %eax,%esi
  80385f:	89 d1                	mov    %edx,%ecx
  803861:	39 d3                	cmp    %edx,%ebx
  803863:	0f 82 87 00 00 00    	jb     8038f0 <__umoddi3+0x134>
  803869:	0f 84 91 00 00 00    	je     803900 <__umoddi3+0x144>
  80386f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803873:	29 f2                	sub    %esi,%edx
  803875:	19 cb                	sbb    %ecx,%ebx
  803877:	89 d8                	mov    %ebx,%eax
  803879:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80387d:	d3 e0                	shl    %cl,%eax
  80387f:	89 e9                	mov    %ebp,%ecx
  803881:	d3 ea                	shr    %cl,%edx
  803883:	09 d0                	or     %edx,%eax
  803885:	89 e9                	mov    %ebp,%ecx
  803887:	d3 eb                	shr    %cl,%ebx
  803889:	89 da                	mov    %ebx,%edx
  80388b:	83 c4 1c             	add    $0x1c,%esp
  80388e:	5b                   	pop    %ebx
  80388f:	5e                   	pop    %esi
  803890:	5f                   	pop    %edi
  803891:	5d                   	pop    %ebp
  803892:	c3                   	ret    
  803893:	90                   	nop
  803894:	89 fd                	mov    %edi,%ebp
  803896:	85 ff                	test   %edi,%edi
  803898:	75 0b                	jne    8038a5 <__umoddi3+0xe9>
  80389a:	b8 01 00 00 00       	mov    $0x1,%eax
  80389f:	31 d2                	xor    %edx,%edx
  8038a1:	f7 f7                	div    %edi
  8038a3:	89 c5                	mov    %eax,%ebp
  8038a5:	89 f0                	mov    %esi,%eax
  8038a7:	31 d2                	xor    %edx,%edx
  8038a9:	f7 f5                	div    %ebp
  8038ab:	89 c8                	mov    %ecx,%eax
  8038ad:	f7 f5                	div    %ebp
  8038af:	89 d0                	mov    %edx,%eax
  8038b1:	e9 44 ff ff ff       	jmp    8037fa <__umoddi3+0x3e>
  8038b6:	66 90                	xchg   %ax,%ax
  8038b8:	89 c8                	mov    %ecx,%eax
  8038ba:	89 f2                	mov    %esi,%edx
  8038bc:	83 c4 1c             	add    $0x1c,%esp
  8038bf:	5b                   	pop    %ebx
  8038c0:	5e                   	pop    %esi
  8038c1:	5f                   	pop    %edi
  8038c2:	5d                   	pop    %ebp
  8038c3:	c3                   	ret    
  8038c4:	3b 04 24             	cmp    (%esp),%eax
  8038c7:	72 06                	jb     8038cf <__umoddi3+0x113>
  8038c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8038cd:	77 0f                	ja     8038de <__umoddi3+0x122>
  8038cf:	89 f2                	mov    %esi,%edx
  8038d1:	29 f9                	sub    %edi,%ecx
  8038d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8038d7:	89 14 24             	mov    %edx,(%esp)
  8038da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8038de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8038e2:	8b 14 24             	mov    (%esp),%edx
  8038e5:	83 c4 1c             	add    $0x1c,%esp
  8038e8:	5b                   	pop    %ebx
  8038e9:	5e                   	pop    %esi
  8038ea:	5f                   	pop    %edi
  8038eb:	5d                   	pop    %ebp
  8038ec:	c3                   	ret    
  8038ed:	8d 76 00             	lea    0x0(%esi),%esi
  8038f0:	2b 04 24             	sub    (%esp),%eax
  8038f3:	19 fa                	sbb    %edi,%edx
  8038f5:	89 d1                	mov    %edx,%ecx
  8038f7:	89 c6                	mov    %eax,%esi
  8038f9:	e9 71 ff ff ff       	jmp    80386f <__umoddi3+0xb3>
  8038fe:	66 90                	xchg   %ax,%ax
  803900:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803904:	72 ea                	jb     8038f0 <__umoddi3+0x134>
  803906:	89 d9                	mov    %ebx,%ecx
  803908:	e9 62 ff ff ff       	jmp    80386f <__umoddi3+0xb3>
