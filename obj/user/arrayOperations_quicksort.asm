
obj/user/arrayOperations_quicksort:     file format elf32-i386


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
  800031:	e8 20 03 00 00       	call   800356 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 27 1c 00 00       	call   801c6a <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 51 1c 00 00       	call   801c9c <sys_getparentenvid>
  80004b:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  80004e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	int *sharedArray = NULL;
  800055:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	sharedArray = sget(parentenvID,"arr") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 c0 34 80 00       	push   $0x8034c0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 e9 16 00 00       	call   801755 <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 c4 34 80 00       	push   $0x8034c4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 d3 16 00 00       	call   801755 <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 cc 34 80 00       	push   $0x8034cc
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 b6 16 00 00       	call   801755 <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 da 34 80 00       	push   $0x8034da
  8000b8:	e8 c3 15 00 00       	call   801680 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		sortedArray[i] = sharedArray[i];
  8000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8000d9:	01 c2                	add    %eax,%edx
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e8:	01 c8                	add    %ecx,%eax
  8000ea:	8b 00                	mov    (%eax),%eax
  8000ec:	89 02                	mov    %eax,(%edx)
	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;
	sortedArray = smalloc("quicksortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		sortedArray[i] = sharedArray[i];
	}
	QuickSort(sortedArray, *numOfElements);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	ff 75 dc             	pushl  -0x24(%ebp)
  800107:	e8 23 00 00 00       	call   80012f <QuickSort>
  80010c:	83 c4 10             	add    $0x10,%esp
	cprintf("Quick sort is Finished!!!!\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 e9 34 80 00       	push   $0x8034e9
  800117:	e8 4a 04 00 00       	call   800566 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  80011f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800122:	8b 00                	mov    (%eax),%eax
  800124:	8d 50 01             	lea    0x1(%eax),%edx
  800127:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012a:	89 10                	mov    %edx,(%eax)

}
  80012c:	90                   	nop
  80012d:	c9                   	leave  
  80012e:	c3                   	ret    

0080012f <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  800135:	8b 45 0c             	mov    0xc(%ebp),%eax
  800138:	48                   	dec    %eax
  800139:	50                   	push   %eax
  80013a:	6a 00                	push   $0x0
  80013c:	ff 75 0c             	pushl  0xc(%ebp)
  80013f:	ff 75 08             	pushl  0x8(%ebp)
  800142:	e8 06 00 00 00       	call   80014d <QSort>
  800147:	83 c4 10             	add    $0x10,%esp
}
  80014a:	90                   	nop
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    

0080014d <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return;
  800153:	8b 45 10             	mov    0x10(%ebp),%eax
  800156:	3b 45 14             	cmp    0x14(%ebp),%eax
  800159:	0f 8d 1b 01 00 00    	jge    80027a <QSort+0x12d>
	int pvtIndex = RAND(startIndex, finalIndex) ;
  80015f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	50                   	push   %eax
  800166:	e8 64 1b 00 00       	call   801ccf <sys_get_virtual_time>
  80016b:	83 c4 0c             	add    $0xc,%esp
  80016e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800171:	8b 55 14             	mov    0x14(%ebp),%edx
  800174:	2b 55 10             	sub    0x10(%ebp),%edx
  800177:	89 d1                	mov    %edx,%ecx
  800179:	ba 00 00 00 00       	mov    $0x0,%edx
  80017e:	f7 f1                	div    %ecx
  800180:	8b 45 10             	mov    0x10(%ebp),%eax
  800183:	01 d0                	add    %edx,%eax
  800185:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800188:	83 ec 04             	sub    $0x4,%esp
  80018b:	ff 75 ec             	pushl  -0x14(%ebp)
  80018e:	ff 75 10             	pushl  0x10(%ebp)
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 e4 00 00 00       	call   80027d <Swap>
  800199:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  80019c:	8b 45 10             	mov    0x10(%ebp),%eax
  80019f:	40                   	inc    %eax
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a6:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  8001a9:	e9 80 00 00 00       	jmp    80022e <QSort+0xe1>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  8001ae:	ff 45 f4             	incl   -0xc(%ebp)
  8001b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b4:	3b 45 14             	cmp    0x14(%ebp),%eax
  8001b7:	7f 2b                	jg     8001e4 <QSort+0x97>
  8001b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	8b 10                	mov    (%eax),%edx
  8001ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001cd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	01 c8                	add    %ecx,%eax
  8001d9:	8b 00                	mov    (%eax),%eax
  8001db:	39 c2                	cmp    %eax,%edx
  8001dd:	7d cf                	jge    8001ae <QSort+0x61>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8001df:	eb 03                	jmp    8001e4 <QSort+0x97>
  8001e1:	ff 4d f0             	decl   -0x10(%ebp)
  8001e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8001ea:	7e 26                	jle    800212 <QSort+0xc5>
  8001ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f9:	01 d0                	add    %edx,%eax
  8001fb:	8b 10                	mov    (%eax),%edx
  8001fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800200:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800207:	8b 45 08             	mov    0x8(%ebp),%eax
  80020a:	01 c8                	add    %ecx,%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	39 c2                	cmp    %eax,%edx
  800210:	7e cf                	jle    8001e1 <QSort+0x94>

		if (i <= j)
  800212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800215:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800218:	7f 14                	jg     80022e <QSort+0xe1>
		{
			Swap(Elements, i, j);
  80021a:	83 ec 04             	sub    $0x4,%esp
  80021d:	ff 75 f0             	pushl  -0x10(%ebp)
  800220:	ff 75 f4             	pushl  -0xc(%ebp)
  800223:	ff 75 08             	pushl  0x8(%ebp)
  800226:	e8 52 00 00 00       	call   80027d <Swap>
  80022b:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  80022e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800231:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800234:	0f 8e 77 ff ff ff    	jle    8001b1 <QSort+0x64>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  80023a:	83 ec 04             	sub    $0x4,%esp
  80023d:	ff 75 f0             	pushl  -0x10(%ebp)
  800240:	ff 75 10             	pushl  0x10(%ebp)
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 32 00 00 00       	call   80027d <Swap>
  80024b:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  80024e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800251:	48                   	dec    %eax
  800252:	50                   	push   %eax
  800253:	ff 75 10             	pushl  0x10(%ebp)
  800256:	ff 75 0c             	pushl  0xc(%ebp)
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 ec fe ff ff       	call   80014d <QSort>
  800261:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  800264:	ff 75 14             	pushl  0x14(%ebp)
  800267:	ff 75 f4             	pushl  -0xc(%ebp)
  80026a:	ff 75 0c             	pushl  0xc(%ebp)
  80026d:	ff 75 08             	pushl  0x8(%ebp)
  800270:	e8 d8 fe ff ff       	call   80014d <QSort>
  800275:	83 c4 10             	add    $0x10,%esp
  800278:	eb 01                	jmp    80027b <QSort+0x12e>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  80027a:	90                   	nop
	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);

	//cprintf("qs,after sorting: start = %d, end = %d\n", startIndex, finalIndex);

}
  80027b:	c9                   	leave  
  80027c:	c3                   	ret    

0080027d <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80027d:	55                   	push   %ebp
  80027e:	89 e5                	mov    %esp,%ebp
  800280:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800283:	8b 45 0c             	mov    0xc(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	01 c2                	add    %eax,%edx
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b3:	01 c8                	add    %ecx,%eax
  8002b5:	8b 00                	mov    (%eax),%eax
  8002b7:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8002b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c6:	01 c2                	add    %eax,%edx
  8002c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8002cb:	89 02                	mov    %eax,(%edx)
}
  8002cd:	90                   	nop
  8002ce:	c9                   	leave  
  8002cf:	c3                   	ret    

008002d0 <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8002d6:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8002dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8002e4:	eb 42                	jmp    800328 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8002e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002e9:	99                   	cltd   
  8002ea:	f7 7d f0             	idivl  -0x10(%ebp)
  8002ed:	89 d0                	mov    %edx,%eax
  8002ef:	85 c0                	test   %eax,%eax
  8002f1:	75 10                	jne    800303 <PrintElements+0x33>
			cprintf("\n");
  8002f3:	83 ec 0c             	sub    $0xc,%esp
  8002f6:	68 05 35 80 00       	push   $0x803505
  8002fb:	e8 66 02 00 00       	call   800566 <cprintf>
  800300:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800306:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030d:	8b 45 08             	mov    0x8(%ebp),%eax
  800310:	01 d0                	add    %edx,%eax
  800312:	8b 00                	mov    (%eax),%eax
  800314:	83 ec 08             	sub    $0x8,%esp
  800317:	50                   	push   %eax
  800318:	68 07 35 80 00       	push   $0x803507
  80031d:	e8 44 02 00 00       	call   800566 <cprintf>
  800322:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800325:	ff 45 f4             	incl   -0xc(%ebp)
  800328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032b:	48                   	dec    %eax
  80032c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80032f:	7f b5                	jg     8002e6 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800334:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033b:	8b 45 08             	mov    0x8(%ebp),%eax
  80033e:	01 d0                	add    %edx,%eax
  800340:	8b 00                	mov    (%eax),%eax
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	50                   	push   %eax
  800346:	68 0c 35 80 00       	push   $0x80350c
  80034b:	e8 16 02 00 00       	call   800566 <cprintf>
  800350:	83 c4 10             	add    $0x10,%esp

}
  800353:	90                   	nop
  800354:	c9                   	leave  
  800355:	c3                   	ret    

00800356 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80035c:	e8 22 19 00 00       	call   801c83 <sys_getenvindex>
  800361:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800364:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800367:	89 d0                	mov    %edx,%eax
  800369:	c1 e0 03             	shl    $0x3,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	01 c0                	add    %eax,%eax
  800370:	01 d0                	add    %edx,%eax
  800372:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800379:	01 d0                	add    %edx,%eax
  80037b:	c1 e0 04             	shl    $0x4,%eax
  80037e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800383:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800388:	a1 20 40 80 00       	mov    0x804020,%eax
  80038d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800393:	84 c0                	test   %al,%al
  800395:	74 0f                	je     8003a6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003aa:	7e 0a                	jle    8003b6 <libmain+0x60>
		binaryname = argv[0];
  8003ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003af:	8b 00                	mov    (%eax),%eax
  8003b1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003b6:	83 ec 08             	sub    $0x8,%esp
  8003b9:	ff 75 0c             	pushl  0xc(%ebp)
  8003bc:	ff 75 08             	pushl  0x8(%ebp)
  8003bf:	e8 74 fc ff ff       	call   800038 <_main>
  8003c4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003c7:	e8 c4 16 00 00       	call   801a90 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 28 35 80 00       	push   $0x803528
  8003d4:	e8 8d 01 00 00       	call   800566 <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f2:	83 ec 04             	sub    $0x4,%esp
  8003f5:	52                   	push   %edx
  8003f6:	50                   	push   %eax
  8003f7:	68 50 35 80 00       	push   $0x803550
  8003fc:	e8 65 01 00 00       	call   800566 <cprintf>
  800401:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800404:	a1 20 40 80 00       	mov    0x804020,%eax
  800409:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80040f:	a1 20 40 80 00       	mov    0x804020,%eax
  800414:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80041a:	a1 20 40 80 00       	mov    0x804020,%eax
  80041f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800425:	51                   	push   %ecx
  800426:	52                   	push   %edx
  800427:	50                   	push   %eax
  800428:	68 78 35 80 00       	push   $0x803578
  80042d:	e8 34 01 00 00       	call   800566 <cprintf>
  800432:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800435:	a1 20 40 80 00       	mov    0x804020,%eax
  80043a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800440:	83 ec 08             	sub    $0x8,%esp
  800443:	50                   	push   %eax
  800444:	68 d0 35 80 00       	push   $0x8035d0
  800449:	e8 18 01 00 00       	call   800566 <cprintf>
  80044e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800451:	83 ec 0c             	sub    $0xc,%esp
  800454:	68 28 35 80 00       	push   $0x803528
  800459:	e8 08 01 00 00       	call   800566 <cprintf>
  80045e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800461:	e8 44 16 00 00       	call   801aaa <sys_enable_interrupt>

	// exit gracefully
	exit();
  800466:	e8 19 00 00 00       	call   800484 <exit>
}
  80046b:	90                   	nop
  80046c:	c9                   	leave  
  80046d:	c3                   	ret    

0080046e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800474:	83 ec 0c             	sub    $0xc,%esp
  800477:	6a 00                	push   $0x0
  800479:	e8 d1 17 00 00       	call   801c4f <sys_destroy_env>
  80047e:	83 c4 10             	add    $0x10,%esp
}
  800481:	90                   	nop
  800482:	c9                   	leave  
  800483:	c3                   	ret    

00800484 <exit>:

void
exit(void)
{
  800484:	55                   	push   %ebp
  800485:	89 e5                	mov    %esp,%ebp
  800487:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80048a:	e8 26 18 00 00       	call   801cb5 <sys_exit_env>
}
  80048f:	90                   	nop
  800490:	c9                   	leave  
  800491:	c3                   	ret    

00800492 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800492:	55                   	push   %ebp
  800493:	89 e5                	mov    %esp,%ebp
  800495:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800498:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a3:	89 0a                	mov    %ecx,(%edx)
  8004a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a8:	88 d1                	mov    %dl,%cl
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bb:	75 2c                	jne    8004e9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004bd:	a0 24 40 80 00       	mov    0x804024,%al
  8004c2:	0f b6 c0             	movzbl %al,%eax
  8004c5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c8:	8b 12                	mov    (%edx),%edx
  8004ca:	89 d1                	mov    %edx,%ecx
  8004cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cf:	83 c2 08             	add    $0x8,%edx
  8004d2:	83 ec 04             	sub    $0x4,%esp
  8004d5:	50                   	push   %eax
  8004d6:	51                   	push   %ecx
  8004d7:	52                   	push   %edx
  8004d8:	e8 05 14 00 00       	call   8018e2 <sys_cputs>
  8004dd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ec:	8b 40 04             	mov    0x4(%eax),%eax
  8004ef:	8d 50 01             	lea    0x1(%eax),%edx
  8004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004f8:	90                   	nop
  8004f9:	c9                   	leave  
  8004fa:	c3                   	ret    

008004fb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004fb:	55                   	push   %ebp
  8004fc:	89 e5                	mov    %esp,%ebp
  8004fe:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800504:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050b:	00 00 00 
	b.cnt = 0;
  80050e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800515:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800518:	ff 75 0c             	pushl  0xc(%ebp)
  80051b:	ff 75 08             	pushl  0x8(%ebp)
  80051e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800524:	50                   	push   %eax
  800525:	68 92 04 80 00       	push   $0x800492
  80052a:	e8 11 02 00 00       	call   800740 <vprintfmt>
  80052f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800532:	a0 24 40 80 00       	mov    0x804024,%al
  800537:	0f b6 c0             	movzbl %al,%eax
  80053a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800540:	83 ec 04             	sub    $0x4,%esp
  800543:	50                   	push   %eax
  800544:	52                   	push   %edx
  800545:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054b:	83 c0 08             	add    $0x8,%eax
  80054e:	50                   	push   %eax
  80054f:	e8 8e 13 00 00       	call   8018e2 <sys_cputs>
  800554:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800557:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80055e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800564:	c9                   	leave  
  800565:	c3                   	ret    

00800566 <cprintf>:

int cprintf(const char *fmt, ...) {
  800566:	55                   	push   %ebp
  800567:	89 e5                	mov    %esp,%ebp
  800569:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80056c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800573:	8d 45 0c             	lea    0xc(%ebp),%eax
  800576:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800579:	8b 45 08             	mov    0x8(%ebp),%eax
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	ff 75 f4             	pushl  -0xc(%ebp)
  800582:	50                   	push   %eax
  800583:	e8 73 ff ff ff       	call   8004fb <vcprintf>
  800588:	83 c4 10             	add    $0x10,%esp
  80058b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800599:	e8 f2 14 00 00       	call   801a90 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80059e:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a7:	83 ec 08             	sub    $0x8,%esp
  8005aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ad:	50                   	push   %eax
  8005ae:	e8 48 ff ff ff       	call   8004fb <vcprintf>
  8005b3:	83 c4 10             	add    $0x10,%esp
  8005b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005b9:	e8 ec 14 00 00       	call   801aaa <sys_enable_interrupt>
	return cnt;
  8005be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c1:	c9                   	leave  
  8005c2:	c3                   	ret    

008005c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c3:	55                   	push   %ebp
  8005c4:	89 e5                	mov    %esp,%ebp
  8005c6:	53                   	push   %ebx
  8005c7:	83 ec 14             	sub    $0x14,%esp
  8005ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8005cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005d6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005de:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e1:	77 55                	ja     800638 <printnum+0x75>
  8005e3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e6:	72 05                	jb     8005ed <printnum+0x2a>
  8005e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005eb:	77 4b                	ja     800638 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ed:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fb:	52                   	push   %edx
  8005fc:	50                   	push   %eax
  8005fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800600:	ff 75 f0             	pushl  -0x10(%ebp)
  800603:	e8 44 2c 00 00       	call   80324c <__udivdi3>
  800608:	83 c4 10             	add    $0x10,%esp
  80060b:	83 ec 04             	sub    $0x4,%esp
  80060e:	ff 75 20             	pushl  0x20(%ebp)
  800611:	53                   	push   %ebx
  800612:	ff 75 18             	pushl  0x18(%ebp)
  800615:	52                   	push   %edx
  800616:	50                   	push   %eax
  800617:	ff 75 0c             	pushl  0xc(%ebp)
  80061a:	ff 75 08             	pushl  0x8(%ebp)
  80061d:	e8 a1 ff ff ff       	call   8005c3 <printnum>
  800622:	83 c4 20             	add    $0x20,%esp
  800625:	eb 1a                	jmp    800641 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 0c             	pushl  0xc(%ebp)
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	8b 45 08             	mov    0x8(%ebp),%eax
  800633:	ff d0                	call   *%eax
  800635:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800638:	ff 4d 1c             	decl   0x1c(%ebp)
  80063b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80063f:	7f e6                	jg     800627 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800641:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800644:	bb 00 00 00 00       	mov    $0x0,%ebx
  800649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80064c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80064f:	53                   	push   %ebx
  800650:	51                   	push   %ecx
  800651:	52                   	push   %edx
  800652:	50                   	push   %eax
  800653:	e8 04 2d 00 00       	call   80335c <__umoddi3>
  800658:	83 c4 10             	add    $0x10,%esp
  80065b:	05 14 38 80 00       	add    $0x803814,%eax
  800660:	8a 00                	mov    (%eax),%al
  800662:	0f be c0             	movsbl %al,%eax
  800665:	83 ec 08             	sub    $0x8,%esp
  800668:	ff 75 0c             	pushl  0xc(%ebp)
  80066b:	50                   	push   %eax
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	ff d0                	call   *%eax
  800671:	83 c4 10             	add    $0x10,%esp
}
  800674:	90                   	nop
  800675:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800678:	c9                   	leave  
  800679:	c3                   	ret    

0080067a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067a:	55                   	push   %ebp
  80067b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80067d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800681:	7e 1c                	jle    80069f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 08             	lea    0x8(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 08             	sub    $0x8,%eax
  800698:	8b 50 04             	mov    0x4(%eax),%edx
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	eb 40                	jmp    8006df <getuint+0x65>
	else if (lflag)
  80069f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a3:	74 1e                	je     8006c3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	8d 50 04             	lea    0x4(%eax),%edx
  8006ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b0:	89 10                	mov    %edx,(%eax)
  8006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	83 e8 04             	sub    $0x4,%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c1:	eb 1c                	jmp    8006df <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	8b 00                	mov    (%eax),%eax
  8006c8:	8d 50 04             	lea    0x4(%eax),%edx
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	89 10                	mov    %edx,(%eax)
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	83 e8 04             	sub    $0x4,%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006df:	5d                   	pop    %ebp
  8006e0:	c3                   	ret    

008006e1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e8:	7e 1c                	jle    800706 <getint+0x25>
		return va_arg(*ap, long long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 08             	lea    0x8(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 08             	sub    $0x8,%eax
  8006ff:	8b 50 04             	mov    0x4(%eax),%edx
  800702:	8b 00                	mov    (%eax),%eax
  800704:	eb 38                	jmp    80073e <getint+0x5d>
	else if (lflag)
  800706:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070a:	74 1a                	je     800726 <getint+0x45>
		return va_arg(*ap, long);
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	8b 45 08             	mov    0x8(%ebp),%eax
  800717:	89 10                	mov    %edx,(%eax)
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	83 e8 04             	sub    $0x4,%eax
  800721:	8b 00                	mov    (%eax),%eax
  800723:	99                   	cltd   
  800724:	eb 18                	jmp    80073e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	99                   	cltd   
}
  80073e:	5d                   	pop    %ebp
  80073f:	c3                   	ret    

00800740 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	56                   	push   %esi
  800744:	53                   	push   %ebx
  800745:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800748:	eb 17                	jmp    800761 <vprintfmt+0x21>
			if (ch == '\0')
  80074a:	85 db                	test   %ebx,%ebx
  80074c:	0f 84 af 03 00 00    	je     800b01 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800752:	83 ec 08             	sub    $0x8,%esp
  800755:	ff 75 0c             	pushl  0xc(%ebp)
  800758:	53                   	push   %ebx
  800759:	8b 45 08             	mov    0x8(%ebp),%eax
  80075c:	ff d0                	call   *%eax
  80075e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	83 fb 25             	cmp    $0x25,%ebx
  800772:	75 d6                	jne    80074a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800774:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800778:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80077f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800786:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80078d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800794:	8b 45 10             	mov    0x10(%ebp),%eax
  800797:	8d 50 01             	lea    0x1(%eax),%edx
  80079a:	89 55 10             	mov    %edx,0x10(%ebp)
  80079d:	8a 00                	mov    (%eax),%al
  80079f:	0f b6 d8             	movzbl %al,%ebx
  8007a2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a5:	83 f8 55             	cmp    $0x55,%eax
  8007a8:	0f 87 2b 03 00 00    	ja     800ad9 <vprintfmt+0x399>
  8007ae:	8b 04 85 38 38 80 00 	mov    0x803838(,%eax,4),%eax
  8007b5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007b7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bb:	eb d7                	jmp    800794 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007bd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c1:	eb d1                	jmp    800794 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007cd:	89 d0                	mov    %edx,%eax
  8007cf:	c1 e0 02             	shl    $0x2,%eax
  8007d2:	01 d0                	add    %edx,%eax
  8007d4:	01 c0                	add    %eax,%eax
  8007d6:	01 d8                	add    %ebx,%eax
  8007d8:	83 e8 30             	sub    $0x30,%eax
  8007db:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007de:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e1:	8a 00                	mov    (%eax),%al
  8007e3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007e6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007e9:	7e 3e                	jle    800829 <vprintfmt+0xe9>
  8007eb:	83 fb 39             	cmp    $0x39,%ebx
  8007ee:	7f 39                	jg     800829 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f3:	eb d5                	jmp    8007ca <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f8:	83 c0 04             	add    $0x4,%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800809:	eb 1f                	jmp    80082a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080f:	79 83                	jns    800794 <vprintfmt+0x54>
				width = 0;
  800811:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800818:	e9 77 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80081d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800824:	e9 6b ff ff ff       	jmp    800794 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800829:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	0f 89 60 ff ff ff    	jns    800794 <vprintfmt+0x54>
				width = precision, precision = -1;
  800834:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800837:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800841:	e9 4e ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800846:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800849:	e9 46 ff ff ff       	jmp    800794 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	83 c0 04             	add    $0x4,%eax
  800854:	89 45 14             	mov    %eax,0x14(%ebp)
  800857:	8b 45 14             	mov    0x14(%ebp),%eax
  80085a:	83 e8 04             	sub    $0x4,%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	83 ec 08             	sub    $0x8,%esp
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	50                   	push   %eax
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
			break;
  80086e:	e9 89 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 c0 04             	add    $0x4,%eax
  800879:	89 45 14             	mov    %eax,0x14(%ebp)
  80087c:	8b 45 14             	mov    0x14(%ebp),%eax
  80087f:	83 e8 04             	sub    $0x4,%eax
  800882:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800884:	85 db                	test   %ebx,%ebx
  800886:	79 02                	jns    80088a <vprintfmt+0x14a>
				err = -err;
  800888:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088a:	83 fb 64             	cmp    $0x64,%ebx
  80088d:	7f 0b                	jg     80089a <vprintfmt+0x15a>
  80088f:	8b 34 9d 80 36 80 00 	mov    0x803680(,%ebx,4),%esi
  800896:	85 f6                	test   %esi,%esi
  800898:	75 19                	jne    8008b3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089a:	53                   	push   %ebx
  80089b:	68 25 38 80 00       	push   $0x803825
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	ff 75 08             	pushl  0x8(%ebp)
  8008a6:	e8 5e 02 00 00       	call   800b09 <printfmt>
  8008ab:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ae:	e9 49 02 00 00       	jmp    800afc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b3:	56                   	push   %esi
  8008b4:	68 2e 38 80 00       	push   $0x80382e
  8008b9:	ff 75 0c             	pushl  0xc(%ebp)
  8008bc:	ff 75 08             	pushl  0x8(%ebp)
  8008bf:	e8 45 02 00 00       	call   800b09 <printfmt>
  8008c4:	83 c4 10             	add    $0x10,%esp
			break;
  8008c7:	e9 30 02 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cf:	83 c0 04             	add    $0x4,%eax
  8008d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d8:	83 e8 04             	sub    $0x4,%eax
  8008db:	8b 30                	mov    (%eax),%esi
  8008dd:	85 f6                	test   %esi,%esi
  8008df:	75 05                	jne    8008e6 <vprintfmt+0x1a6>
				p = "(null)";
  8008e1:	be 31 38 80 00       	mov    $0x803831,%esi
			if (width > 0 && padc != '-')
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	7e 6d                	jle    800959 <vprintfmt+0x219>
  8008ec:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f0:	74 67                	je     800959 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f5:	83 ec 08             	sub    $0x8,%esp
  8008f8:	50                   	push   %eax
  8008f9:	56                   	push   %esi
  8008fa:	e8 0c 03 00 00       	call   800c0b <strnlen>
  8008ff:	83 c4 10             	add    $0x10,%esp
  800902:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800905:	eb 16                	jmp    80091d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800907:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090b:	83 ec 08             	sub    $0x8,%esp
  80090e:	ff 75 0c             	pushl  0xc(%ebp)
  800911:	50                   	push   %eax
  800912:	8b 45 08             	mov    0x8(%ebp),%eax
  800915:	ff d0                	call   *%eax
  800917:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091a:	ff 4d e4             	decl   -0x1c(%ebp)
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7f e4                	jg     800907 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	eb 34                	jmp    800959 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800925:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800929:	74 1c                	je     800947 <vprintfmt+0x207>
  80092b:	83 fb 1f             	cmp    $0x1f,%ebx
  80092e:	7e 05                	jle    800935 <vprintfmt+0x1f5>
  800930:	83 fb 7e             	cmp    $0x7e,%ebx
  800933:	7e 12                	jle    800947 <vprintfmt+0x207>
					putch('?', putdat);
  800935:	83 ec 08             	sub    $0x8,%esp
  800938:	ff 75 0c             	pushl  0xc(%ebp)
  80093b:	6a 3f                	push   $0x3f
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	ff d0                	call   *%eax
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	eb 0f                	jmp    800956 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	ff d0                	call   *%eax
  800953:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800956:	ff 4d e4             	decl   -0x1c(%ebp)
  800959:	89 f0                	mov    %esi,%eax
  80095b:	8d 70 01             	lea    0x1(%eax),%esi
  80095e:	8a 00                	mov    (%eax),%al
  800960:	0f be d8             	movsbl %al,%ebx
  800963:	85 db                	test   %ebx,%ebx
  800965:	74 24                	je     80098b <vprintfmt+0x24b>
  800967:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096b:	78 b8                	js     800925 <vprintfmt+0x1e5>
  80096d:	ff 4d e0             	decl   -0x20(%ebp)
  800970:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800974:	79 af                	jns    800925 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800976:	eb 13                	jmp    80098b <vprintfmt+0x24b>
				putch(' ', putdat);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	6a 20                	push   $0x20
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	ff d0                	call   *%eax
  800985:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800988:	ff 4d e4             	decl   -0x1c(%ebp)
  80098b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80098f:	7f e7                	jg     800978 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800991:	e9 66 01 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 e8             	pushl  -0x18(%ebp)
  80099c:	8d 45 14             	lea    0x14(%ebp),%eax
  80099f:	50                   	push   %eax
  8009a0:	e8 3c fd ff ff       	call   8006e1 <getint>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b4:	85 d2                	test   %edx,%edx
  8009b6:	79 23                	jns    8009db <vprintfmt+0x29b>
				putch('-', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 2d                	push   $0x2d
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ce:	f7 d8                	neg    %eax
  8009d0:	83 d2 00             	adc    $0x0,%edx
  8009d3:	f7 da                	neg    %edx
  8009d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e2:	e9 bc 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009e7:	83 ec 08             	sub    $0x8,%esp
  8009ea:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ed:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f0:	50                   	push   %eax
  8009f1:	e8 84 fc ff ff       	call   80067a <getuint>
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a06:	e9 98 00 00 00       	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0b:	83 ec 08             	sub    $0x8,%esp
  800a0e:	ff 75 0c             	pushl  0xc(%ebp)
  800a11:	6a 58                	push   $0x58
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	ff d0                	call   *%eax
  800a18:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 58                	push   $0x58
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2b:	83 ec 08             	sub    $0x8,%esp
  800a2e:	ff 75 0c             	pushl  0xc(%ebp)
  800a31:	6a 58                	push   $0x58
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	ff d0                	call   *%eax
  800a38:	83 c4 10             	add    $0x10,%esp
			break;
  800a3b:	e9 bc 00 00 00       	jmp    800afc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	ff 75 0c             	pushl  0xc(%ebp)
  800a46:	6a 30                	push   $0x30
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	ff d0                	call   *%eax
  800a4d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a50:	83 ec 08             	sub    $0x8,%esp
  800a53:	ff 75 0c             	pushl  0xc(%ebp)
  800a56:	6a 78                	push   $0x78
  800a58:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5b:	ff d0                	call   *%eax
  800a5d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a60:	8b 45 14             	mov    0x14(%ebp),%eax
  800a63:	83 c0 04             	add    $0x4,%eax
  800a66:	89 45 14             	mov    %eax,0x14(%ebp)
  800a69:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6c:	83 e8 04             	sub    $0x4,%eax
  800a6f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a82:	eb 1f                	jmp    800aa3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8d:	50                   	push   %eax
  800a8e:	e8 e7 fb ff ff       	call   80067a <getuint>
  800a93:	83 c4 10             	add    $0x10,%esp
  800a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a99:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aaa:	83 ec 04             	sub    $0x4,%esp
  800aad:	52                   	push   %edx
  800aae:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab1:	50                   	push   %eax
  800ab2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab5:	ff 75 f0             	pushl  -0x10(%ebp)
  800ab8:	ff 75 0c             	pushl  0xc(%ebp)
  800abb:	ff 75 08             	pushl  0x8(%ebp)
  800abe:	e8 00 fb ff ff       	call   8005c3 <printnum>
  800ac3:	83 c4 20             	add    $0x20,%esp
			break;
  800ac6:	eb 34                	jmp    800afc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ac8:	83 ec 08             	sub    $0x8,%esp
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	53                   	push   %ebx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			break;
  800ad7:	eb 23                	jmp    800afc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	6a 25                	push   $0x25
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	ff d0                	call   *%eax
  800ae6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ae9:	ff 4d 10             	decl   0x10(%ebp)
  800aec:	eb 03                	jmp    800af1 <vprintfmt+0x3b1>
  800aee:	ff 4d 10             	decl   0x10(%ebp)
  800af1:	8b 45 10             	mov    0x10(%ebp),%eax
  800af4:	48                   	dec    %eax
  800af5:	8a 00                	mov    (%eax),%al
  800af7:	3c 25                	cmp    $0x25,%al
  800af9:	75 f3                	jne    800aee <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800afb:	90                   	nop
		}
	}
  800afc:	e9 47 fc ff ff       	jmp    800748 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b01:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b02:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b05:	5b                   	pop    %ebx
  800b06:	5e                   	pop    %esi
  800b07:	5d                   	pop    %ebp
  800b08:	c3                   	ret    

00800b09 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b0f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b12:	83 c0 04             	add    $0x4,%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b18:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b1e:	50                   	push   %eax
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	ff 75 08             	pushl  0x8(%ebp)
  800b25:	e8 16 fc ff ff       	call   800740 <vprintfmt>
  800b2a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b2d:	90                   	nop
  800b2e:	c9                   	leave  
  800b2f:	c3                   	ret    

00800b30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8b 40 08             	mov    0x8(%eax),%eax
  800b39:	8d 50 01             	lea    0x1(%eax),%edx
  800b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8b 10                	mov    (%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	8b 40 04             	mov    0x4(%eax),%eax
  800b4d:	39 c2                	cmp    %eax,%edx
  800b4f:	73 12                	jae    800b63 <sprintputch+0x33>
		*b->buf++ = ch;
  800b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b54:	8b 00                	mov    (%eax),%eax
  800b56:	8d 48 01             	lea    0x1(%eax),%ecx
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	89 0a                	mov    %ecx,(%edx)
  800b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b61:	88 10                	mov    %dl,(%eax)
}
  800b63:	90                   	nop
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	01 d0                	add    %edx,%eax
  800b7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8b:	74 06                	je     800b93 <vsnprintf+0x2d>
  800b8d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b91:	7f 07                	jg     800b9a <vsnprintf+0x34>
		return -E_INVAL;
  800b93:	b8 03 00 00 00       	mov    $0x3,%eax
  800b98:	eb 20                	jmp    800bba <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9a:	ff 75 14             	pushl  0x14(%ebp)
  800b9d:	ff 75 10             	pushl  0x10(%ebp)
  800ba0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba3:	50                   	push   %eax
  800ba4:	68 30 0b 80 00       	push   $0x800b30
  800ba9:	e8 92 fb ff ff       	call   800740 <vprintfmt>
  800bae:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bba:	c9                   	leave  
  800bbb:	c3                   	ret    

00800bbc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc2:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc5:	83 c0 04             	add    $0x4,%eax
  800bc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bce:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd1:	50                   	push   %eax
  800bd2:	ff 75 0c             	pushl  0xc(%ebp)
  800bd5:	ff 75 08             	pushl  0x8(%ebp)
  800bd8:	e8 89 ff ff ff       	call   800b66 <vsnprintf>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf5:	eb 06                	jmp    800bfd <strlen+0x15>
		n++;
  800bf7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfa:	ff 45 08             	incl   0x8(%ebp)
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	8a 00                	mov    (%eax),%al
  800c02:	84 c0                	test   %al,%al
  800c04:	75 f1                	jne    800bf7 <strlen+0xf>
		n++;
	return n;
  800c06:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c09:	c9                   	leave  
  800c0a:	c3                   	ret    

00800c0b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c18:	eb 09                	jmp    800c23 <strnlen+0x18>
		n++;
  800c1a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1d:	ff 45 08             	incl   0x8(%ebp)
  800c20:	ff 4d 0c             	decl   0xc(%ebp)
  800c23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c27:	74 09                	je     800c32 <strnlen+0x27>
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	84 c0                	test   %al,%al
  800c30:	75 e8                	jne    800c1a <strnlen+0xf>
		n++;
	return n;
  800c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c35:	c9                   	leave  
  800c36:	c3                   	ret    

00800c37 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c43:	90                   	nop
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8d 50 01             	lea    0x1(%eax),%edx
  800c4a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c50:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c53:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	75 e4                	jne    800c44 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 1f                	jmp    800c99 <strncpy+0x34>
		*dst++ = *src;
  800c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7d:	8d 50 01             	lea    0x1(%eax),%edx
  800c80:	89 55 08             	mov    %edx,0x8(%ebp)
  800c83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c86:	8a 12                	mov    (%edx),%dl
  800c88:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8d:	8a 00                	mov    (%eax),%al
  800c8f:	84 c0                	test   %al,%al
  800c91:	74 03                	je     800c96 <strncpy+0x31>
			src++;
  800c93:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c96:	ff 45 fc             	incl   -0x4(%ebp)
  800c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c9c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c9f:	72 d9                	jb     800c7a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca4:	c9                   	leave  
  800ca5:	c3                   	ret    

00800ca6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb6:	74 30                	je     800ce8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cb8:	eb 16                	jmp    800cd0 <strlcpy+0x2a>
			*dst++ = *src++;
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	8d 50 01             	lea    0x1(%eax),%edx
  800cc0:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ccc:	8a 12                	mov    (%edx),%dl
  800cce:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd7:	74 09                	je     800ce2 <strlcpy+0x3c>
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	84 c0                	test   %al,%al
  800ce0:	75 d8                	jne    800cba <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  800ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cee:	29 c2                	sub    %eax,%edx
  800cf0:	89 d0                	mov    %edx,%eax
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cf7:	eb 06                	jmp    800cff <strcmp+0xb>
		p++, q++;
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strcmp+0x22>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 e3                	je     800cf9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	0f b6 d0             	movzbl %al,%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	0f b6 c0             	movzbl %al,%eax
  800d26:	29 c2                	sub    %eax,%edx
  800d28:	89 d0                	mov    %edx,%eax
}
  800d2a:	5d                   	pop    %ebp
  800d2b:	c3                   	ret    

00800d2c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d2f:	eb 09                	jmp    800d3a <strncmp+0xe>
		n--, p++, q++;
  800d31:	ff 4d 10             	decl   0x10(%ebp)
  800d34:	ff 45 08             	incl   0x8(%ebp)
  800d37:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3e:	74 17                	je     800d57 <strncmp+0x2b>
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	8a 00                	mov    (%eax),%al
  800d45:	84 c0                	test   %al,%al
  800d47:	74 0e                	je     800d57 <strncmp+0x2b>
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	8a 10                	mov    (%eax),%dl
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	8a 00                	mov    (%eax),%al
  800d53:	38 c2                	cmp    %al,%dl
  800d55:	74 da                	je     800d31 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5b:	75 07                	jne    800d64 <strncmp+0x38>
		return 0;
  800d5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d62:	eb 14                	jmp    800d78 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	8a 00                	mov    (%eax),%al
  800d69:	0f b6 d0             	movzbl %al,%edx
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	8a 00                	mov    (%eax),%al
  800d71:	0f b6 c0             	movzbl %al,%eax
  800d74:	29 c2                	sub    %eax,%edx
  800d76:	89 d0                	mov    %edx,%eax
}
  800d78:	5d                   	pop    %ebp
  800d79:	c3                   	ret    

00800d7a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 12                	jmp    800d9a <strchr+0x20>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	75 05                	jne    800d97 <strchr+0x1d>
			return (char *) s;
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	eb 11                	jmp    800da8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	8a 00                	mov    (%eax),%al
  800d9f:	84 c0                	test   %al,%al
  800da1:	75 e5                	jne    800d88 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da8:	c9                   	leave  
  800da9:	c3                   	ret    

00800daa <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	83 ec 04             	sub    $0x4,%esp
  800db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800db6:	eb 0d                	jmp    800dc5 <strfind+0x1b>
		if (*s == c)
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	8a 00                	mov    (%eax),%al
  800dbd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc0:	74 0e                	je     800dd0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc2:	ff 45 08             	incl   0x8(%ebp)
  800dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	84 c0                	test   %al,%al
  800dcc:	75 ea                	jne    800db8 <strfind+0xe>
  800dce:	eb 01                	jmp    800dd1 <strfind+0x27>
		if (*s == c)
			break;
  800dd0:	90                   	nop
	return (char *) s;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de2:	8b 45 10             	mov    0x10(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800de8:	eb 0e                	jmp    800df8 <memset+0x22>
		*p++ = c;
  800dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800df8:	ff 4d f8             	decl   -0x8(%ebp)
  800dfb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dff:	79 e9                	jns    800dea <memset+0x14>
		*p++ = c;

	return v;
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e04:	c9                   	leave  
  800e05:	c3                   	ret    

00800e06 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e18:	eb 16                	jmp    800e30 <memcpy+0x2a>
		*d++ = *s++;
  800e1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e1d:	8d 50 01             	lea    0x1(%eax),%edx
  800e20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e23:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e26:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e29:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e2c:	8a 12                	mov    (%edx),%dl
  800e2e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 dd                	jne    800e1a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e57:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5a:	73 50                	jae    800eac <memmove+0x6a>
  800e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e62:	01 d0                	add    %edx,%eax
  800e64:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e67:	76 43                	jbe    800eac <memmove+0x6a>
		s += n;
  800e69:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e72:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e75:	eb 10                	jmp    800e87 <memmove+0x45>
			*--d = *--s;
  800e77:	ff 4d f8             	decl   -0x8(%ebp)
  800e7a:	ff 4d fc             	decl   -0x4(%ebp)
  800e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e80:	8a 10                	mov    (%eax),%dl
  800e82:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e85:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e87:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e8d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e90:	85 c0                	test   %eax,%eax
  800e92:	75 e3                	jne    800e77 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e94:	eb 23                	jmp    800eb9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8d 50 01             	lea    0x1(%eax),%edx
  800e9c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea8:	8a 12                	mov    (%edx),%dl
  800eaa:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eac:	8b 45 10             	mov    0x10(%ebp),%eax
  800eaf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb2:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 dd                	jne    800e96 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed0:	eb 2a                	jmp    800efc <memcmp+0x3e>
		if (*s1 != *s2)
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	8a 10                	mov    (%eax),%dl
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eda:	8a 00                	mov    (%eax),%al
  800edc:	38 c2                	cmp    %al,%dl
  800ede:	74 16                	je     800ef6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 00                	mov    (%eax),%al
  800ee5:	0f b6 d0             	movzbl %al,%edx
  800ee8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	29 c2                	sub    %eax,%edx
  800ef2:	89 d0                	mov    %edx,%eax
  800ef4:	eb 18                	jmp    800f0e <memcmp+0x50>
		s1++, s2++;
  800ef6:	ff 45 fc             	incl   -0x4(%ebp)
  800ef9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 c9                	jne    800ed2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0e:	c9                   	leave  
  800f0f:	c3                   	ret    

00800f10 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f16:	8b 55 08             	mov    0x8(%ebp),%edx
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	01 d0                	add    %edx,%eax
  800f1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f21:	eb 15                	jmp    800f38 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	0f b6 d0             	movzbl %al,%edx
  800f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2e:	0f b6 c0             	movzbl %al,%eax
  800f31:	39 c2                	cmp    %eax,%edx
  800f33:	74 0d                	je     800f42 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f3e:	72 e3                	jb     800f23 <memfind+0x13>
  800f40:	eb 01                	jmp    800f43 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f42:	90                   	nop
	return (void *) s;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f55:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f5c:	eb 03                	jmp    800f61 <strtol+0x19>
		s++;
  800f5e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8a 00                	mov    (%eax),%al
  800f66:	3c 20                	cmp    $0x20,%al
  800f68:	74 f4                	je     800f5e <strtol+0x16>
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	8a 00                	mov    (%eax),%al
  800f6f:	3c 09                	cmp    $0x9,%al
  800f71:	74 eb                	je     800f5e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f73:	8b 45 08             	mov    0x8(%ebp),%eax
  800f76:	8a 00                	mov    (%eax),%al
  800f78:	3c 2b                	cmp    $0x2b,%al
  800f7a:	75 05                	jne    800f81 <strtol+0x39>
		s++;
  800f7c:	ff 45 08             	incl   0x8(%ebp)
  800f7f:	eb 13                	jmp    800f94 <strtol+0x4c>
	else if (*s == '-')
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	3c 2d                	cmp    $0x2d,%al
  800f88:	75 0a                	jne    800f94 <strtol+0x4c>
		s++, neg = 1;
  800f8a:	ff 45 08             	incl   0x8(%ebp)
  800f8d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f94:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f98:	74 06                	je     800fa0 <strtol+0x58>
  800f9a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f9e:	75 20                	jne    800fc0 <strtol+0x78>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 30                	cmp    $0x30,%al
  800fa7:	75 17                	jne    800fc0 <strtol+0x78>
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	40                   	inc    %eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 78                	cmp    $0x78,%al
  800fb1:	75 0d                	jne    800fc0 <strtol+0x78>
		s += 2, base = 16;
  800fb3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fb7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fbe:	eb 28                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc4:	75 15                	jne    800fdb <strtol+0x93>
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 30                	cmp    $0x30,%al
  800fcd:	75 0c                	jne    800fdb <strtol+0x93>
		s++, base = 8;
  800fcf:	ff 45 08             	incl   0x8(%ebp)
  800fd2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fd9:	eb 0d                	jmp    800fe8 <strtol+0xa0>
	else if (base == 0)
  800fdb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fdf:	75 07                	jne    800fe8 <strtol+0xa0>
		base = 10;
  800fe1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 2f                	cmp    $0x2f,%al
  800fef:	7e 19                	jle    80100a <strtol+0xc2>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 39                	cmp    $0x39,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xc2>
			dig = *s - '0';
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 30             	sub    $0x30,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 42                	jmp    80104c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 60                	cmp    $0x60,%al
  801011:	7e 19                	jle    80102c <strtol+0xe4>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 7a                	cmp    $0x7a,%al
  80101a:	7f 10                	jg     80102c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 57             	sub    $0x57,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102a:	eb 20                	jmp    80104c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	3c 40                	cmp    $0x40,%al
  801033:	7e 39                	jle    80106e <strtol+0x126>
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	3c 5a                	cmp    $0x5a,%al
  80103c:	7f 30                	jg     80106e <strtol+0x126>
			dig = *s - 'A' + 10;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	8a 00                	mov    (%eax),%al
  801043:	0f be c0             	movsbl %al,%eax
  801046:	83 e8 37             	sub    $0x37,%eax
  801049:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80104c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80104f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801052:	7d 19                	jge    80106d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801054:	ff 45 08             	incl   0x8(%ebp)
  801057:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80105e:	89 c2                	mov    %eax,%edx
  801060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801068:	e9 7b ff ff ff       	jmp    800fe8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80106d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80106e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801072:	74 08                	je     80107c <strtol+0x134>
		*endptr = (char *) s;
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	8b 55 08             	mov    0x8(%ebp),%edx
  80107a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80107c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801080:	74 07                	je     801089 <strtol+0x141>
  801082:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801085:	f7 d8                	neg    %eax
  801087:	eb 03                	jmp    80108c <strtol+0x144>
  801089:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80108c:	c9                   	leave  
  80108d:	c3                   	ret    

0080108e <ltostr>:

void
ltostr(long value, char *str)
{
  80108e:	55                   	push   %ebp
  80108f:	89 e5                	mov    %esp,%ebp
  801091:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801094:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010a6:	79 13                	jns    8010bb <ltostr+0x2d>
	{
		neg = 1;
  8010a8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010b8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c3:	99                   	cltd   
  8010c4:	f7 f9                	idiv   %ecx
  8010c6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cc:	8d 50 01             	lea    0x1(%eax),%edx
  8010cf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010dc:	83 c2 30             	add    $0x30,%edx
  8010df:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e9:	f7 e9                	imul   %ecx
  8010eb:	c1 fa 02             	sar    $0x2,%edx
  8010ee:	89 c8                	mov    %ecx,%eax
  8010f0:	c1 f8 1f             	sar    $0x1f,%eax
  8010f3:	29 c2                	sub    %eax,%edx
  8010f5:	89 d0                	mov    %edx,%eax
  8010f7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010fd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801102:	f7 e9                	imul   %ecx
  801104:	c1 fa 02             	sar    $0x2,%edx
  801107:	89 c8                	mov    %ecx,%eax
  801109:	c1 f8 1f             	sar    $0x1f,%eax
  80110c:	29 c2                	sub    %eax,%edx
  80110e:	89 d0                	mov    %edx,%eax
  801110:	c1 e0 02             	shl    $0x2,%eax
  801113:	01 d0                	add    %edx,%eax
  801115:	01 c0                	add    %eax,%eax
  801117:	29 c1                	sub    %eax,%ecx
  801119:	89 ca                	mov    %ecx,%edx
  80111b:	85 d2                	test   %edx,%edx
  80111d:	75 9c                	jne    8010bb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80111f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801126:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801129:	48                   	dec    %eax
  80112a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80112d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801131:	74 3d                	je     801170 <ltostr+0xe2>
		start = 1 ;
  801133:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113a:	eb 34                	jmp    801170 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80113c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801142:	01 d0                	add    %edx,%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114f:	01 c2                	add    %eax,%edx
  801151:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801154:	8b 45 0c             	mov    0xc(%ebp),%eax
  801157:	01 c8                	add    %ecx,%eax
  801159:	8a 00                	mov    (%eax),%al
  80115b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80115d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	01 c2                	add    %eax,%edx
  801165:	8a 45 eb             	mov    -0x15(%ebp),%al
  801168:	88 02                	mov    %al,(%edx)
		start++ ;
  80116a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80116d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801173:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801176:	7c c4                	jl     80113c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801178:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801183:	90                   	nop
  801184:	c9                   	leave  
  801185:	c3                   	ret    

00801186 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80118c:	ff 75 08             	pushl  0x8(%ebp)
  80118f:	e8 54 fa ff ff       	call   800be8 <strlen>
  801194:	83 c4 04             	add    $0x4,%esp
  801197:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119a:	ff 75 0c             	pushl  0xc(%ebp)
  80119d:	e8 46 fa ff ff       	call   800be8 <strlen>
  8011a2:	83 c4 04             	add    $0x4,%esp
  8011a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011b6:	eb 17                	jmp    8011cf <strcconcat+0x49>
		final[s] = str1[s] ;
  8011b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8011be:	01 c2                	add    %eax,%edx
  8011c0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c6:	01 c8                	add    %ecx,%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011cc:	ff 45 fc             	incl   -0x4(%ebp)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d5:	7c e1                	jl     8011b8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011d7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e5:	eb 1f                	jmp    801206 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ea:	8d 50 01             	lea    0x1(%eax),%edx
  8011ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f0:	89 c2                	mov    %eax,%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801203:	ff 45 f8             	incl   -0x8(%ebp)
  801206:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801209:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120c:	7c d9                	jl     8011e7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80120e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 d0                	add    %edx,%eax
  801216:	c6 00 00             	movb   $0x0,(%eax)
}
  801219:	90                   	nop
  80121a:	c9                   	leave  
  80121b:	c3                   	ret    

0080121c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80121c:	55                   	push   %ebp
  80121d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80121f:	8b 45 14             	mov    0x14(%ebp),%eax
  801222:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801228:	8b 45 14             	mov    0x14(%ebp),%eax
  80122b:	8b 00                	mov    (%eax),%eax
  80122d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801234:	8b 45 10             	mov    0x10(%ebp),%eax
  801237:	01 d0                	add    %edx,%eax
  801239:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80123f:	eb 0c                	jmp    80124d <strsplit+0x31>
			*string++ = 0;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8d 50 01             	lea    0x1(%eax),%edx
  801247:	89 55 08             	mov    %edx,0x8(%ebp)
  80124a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	74 18                	je     80126e <strsplit+0x52>
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8a 00                	mov    (%eax),%al
  80125b:	0f be c0             	movsbl %al,%eax
  80125e:	50                   	push   %eax
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	e8 13 fb ff ff       	call   800d7a <strchr>
  801267:	83 c4 08             	add    $0x8,%esp
  80126a:	85 c0                	test   %eax,%eax
  80126c:	75 d3                	jne    801241 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	8a 00                	mov    (%eax),%al
  801273:	84 c0                	test   %al,%al
  801275:	74 5a                	je     8012d1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801277:	8b 45 14             	mov    0x14(%ebp),%eax
  80127a:	8b 00                	mov    (%eax),%eax
  80127c:	83 f8 0f             	cmp    $0xf,%eax
  80127f:	75 07                	jne    801288 <strsplit+0x6c>
		{
			return 0;
  801281:	b8 00 00 00 00       	mov    $0x0,%eax
  801286:	eb 66                	jmp    8012ee <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801288:	8b 45 14             	mov    0x14(%ebp),%eax
  80128b:	8b 00                	mov    (%eax),%eax
  80128d:	8d 48 01             	lea    0x1(%eax),%ecx
  801290:	8b 55 14             	mov    0x14(%ebp),%edx
  801293:	89 0a                	mov    %ecx,(%edx)
  801295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	01 c2                	add    %eax,%edx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012a6:	eb 03                	jmp    8012ab <strsplit+0x8f>
			string++;
  8012a8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	84 c0                	test   %al,%al
  8012b2:	74 8b                	je     80123f <strsplit+0x23>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	50                   	push   %eax
  8012bd:	ff 75 0c             	pushl  0xc(%ebp)
  8012c0:	e8 b5 fa ff ff       	call   800d7a <strchr>
  8012c5:	83 c4 08             	add    $0x8,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 dc                	je     8012a8 <strsplit+0x8c>
			string++;
	}
  8012cc:	e9 6e ff ff ff       	jmp    80123f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d5:	8b 00                	mov    (%eax),%eax
  8012d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012de:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e1:	01 d0                	add    %edx,%eax
  8012e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012e9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ee:	c9                   	leave  
  8012ef:	c3                   	ret    

008012f0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012f6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	74 1f                	je     80131e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012ff:	e8 1d 00 00 00       	call   801321 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801304:	83 ec 0c             	sub    $0xc,%esp
  801307:	68 90 39 80 00       	push   $0x803990
  80130c:	e8 55 f2 ff ff       	call   800566 <cprintf>
  801311:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801314:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131b:	00 00 00 
	}
}
  80131e:	90                   	nop
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801327:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80132e:	00 00 00 
  801331:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801338:	00 00 00 
  80133b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801342:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801345:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80134c:	00 00 00 
  80134f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801356:	00 00 00 
  801359:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801360:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801363:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  80136a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136d:	c1 e8 0c             	shr    $0xc,%eax
  801370:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801375:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80137c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80137f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801384:	2d 00 10 00 00       	sub    $0x1000,%eax
  801389:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  80138e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801395:	a1 20 41 80 00       	mov    0x804120,%eax
  80139a:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80139e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8013a1:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8013a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ae:	01 d0                	add    %edx,%eax
  8013b0:	48                   	dec    %eax
  8013b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013bc:	f7 75 e4             	divl   -0x1c(%ebp)
  8013bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c2:	29 d0                	sub    %edx,%eax
  8013c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8013c7:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8013ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013d6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013db:	83 ec 04             	sub    $0x4,%esp
  8013de:	6a 07                	push   $0x7
  8013e0:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e3:	50                   	push   %eax
  8013e4:	e8 3d 06 00 00       	call   801a26 <sys_allocate_chunk>
  8013e9:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ec:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f1:	83 ec 0c             	sub    $0xc,%esp
  8013f4:	50                   	push   %eax
  8013f5:	e8 b2 0c 00 00       	call   8020ac <initialize_MemBlocksList>
  8013fa:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8013fd:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801402:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801405:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801409:	0f 84 f3 00 00 00    	je     801502 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80140f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801413:	75 14                	jne    801429 <initialize_dyn_block_system+0x108>
  801415:	83 ec 04             	sub    $0x4,%esp
  801418:	68 b5 39 80 00       	push   $0x8039b5
  80141d:	6a 36                	push   $0x36
  80141f:	68 d3 39 80 00       	push   $0x8039d3
  801424:	e8 41 1c 00 00       	call   80306a <_panic>
  801429:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80142c:	8b 00                	mov    (%eax),%eax
  80142e:	85 c0                	test   %eax,%eax
  801430:	74 10                	je     801442 <initialize_dyn_block_system+0x121>
  801432:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801435:	8b 00                	mov    (%eax),%eax
  801437:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80143a:	8b 52 04             	mov    0x4(%edx),%edx
  80143d:	89 50 04             	mov    %edx,0x4(%eax)
  801440:	eb 0b                	jmp    80144d <initialize_dyn_block_system+0x12c>
  801442:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801445:	8b 40 04             	mov    0x4(%eax),%eax
  801448:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80144d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801450:	8b 40 04             	mov    0x4(%eax),%eax
  801453:	85 c0                	test   %eax,%eax
  801455:	74 0f                	je     801466 <initialize_dyn_block_system+0x145>
  801457:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80145a:	8b 40 04             	mov    0x4(%eax),%eax
  80145d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801460:	8b 12                	mov    (%edx),%edx
  801462:	89 10                	mov    %edx,(%eax)
  801464:	eb 0a                	jmp    801470 <initialize_dyn_block_system+0x14f>
  801466:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801469:	8b 00                	mov    (%eax),%eax
  80146b:	a3 48 41 80 00       	mov    %eax,0x804148
  801470:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801473:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801479:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80147c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801483:	a1 54 41 80 00       	mov    0x804154,%eax
  801488:	48                   	dec    %eax
  801489:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80148e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801491:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801498:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80149b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8014a2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014a6:	75 14                	jne    8014bc <initialize_dyn_block_system+0x19b>
  8014a8:	83 ec 04             	sub    $0x4,%esp
  8014ab:	68 e0 39 80 00       	push   $0x8039e0
  8014b0:	6a 3e                	push   $0x3e
  8014b2:	68 d3 39 80 00       	push   $0x8039d3
  8014b7:	e8 ae 1b 00 00       	call   80306a <_panic>
  8014bc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c5:	89 10                	mov    %edx,(%eax)
  8014c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	74 0d                	je     8014dd <initialize_dyn_block_system+0x1bc>
  8014d0:	a1 38 41 80 00       	mov    0x804138,%eax
  8014d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014d8:	89 50 04             	mov    %edx,0x4(%eax)
  8014db:	eb 08                	jmp    8014e5 <initialize_dyn_block_system+0x1c4>
  8014dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e8:	a3 38 41 80 00       	mov    %eax,0x804138
  8014ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014f7:	a1 44 41 80 00       	mov    0x804144,%eax
  8014fc:	40                   	inc    %eax
  8014fd:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80150b:	e8 e0 fd ff ff       	call   8012f0 <InitializeUHeap>
		if (size == 0) return NULL ;
  801510:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801514:	75 07                	jne    80151d <malloc+0x18>
  801516:	b8 00 00 00 00       	mov    $0x0,%eax
  80151b:	eb 7f                	jmp    80159c <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80151d:	e8 d2 08 00 00       	call   801df4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801522:	85 c0                	test   %eax,%eax
  801524:	74 71                	je     801597 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801526:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80152d:	8b 55 08             	mov    0x8(%ebp),%edx
  801530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801533:	01 d0                	add    %edx,%eax
  801535:	48                   	dec    %eax
  801536:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153c:	ba 00 00 00 00       	mov    $0x0,%edx
  801541:	f7 75 f4             	divl   -0xc(%ebp)
  801544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801547:	29 d0                	sub    %edx,%eax
  801549:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80154c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801553:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80155a:	76 07                	jbe    801563 <malloc+0x5e>
					return NULL ;
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
  801561:	eb 39                	jmp    80159c <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801563:	83 ec 0c             	sub    $0xc,%esp
  801566:	ff 75 08             	pushl  0x8(%ebp)
  801569:	e8 e6 0d 00 00       	call   802354 <alloc_block_FF>
  80156e:	83 c4 10             	add    $0x10,%esp
  801571:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801574:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801578:	74 16                	je     801590 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80157a:	83 ec 0c             	sub    $0xc,%esp
  80157d:	ff 75 ec             	pushl  -0x14(%ebp)
  801580:	e8 37 0c 00 00       	call   8021bc <insert_sorted_allocList>
  801585:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801588:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158b:	8b 40 08             	mov    0x8(%eax),%eax
  80158e:	eb 0c                	jmp    80159c <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801590:	b8 00 00 00 00       	mov    $0x0,%eax
  801595:	eb 05                	jmp    80159c <malloc+0x97>
				}
		}
	return 0;
  801597:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80159c:	c9                   	leave  
  80159d:	c3                   	ret    

0080159e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8015aa:	83 ec 08             	sub    $0x8,%esp
  8015ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b0:	68 40 40 80 00       	push   $0x804040
  8015b5:	e8 cf 0b 00 00       	call   802189 <find_block>
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8015c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cc:	8b 40 08             	mov    0x8(%eax),%eax
  8015cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8015d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015d6:	0f 84 a1 00 00 00    	je     80167d <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8015dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015e0:	75 17                	jne    8015f9 <free+0x5b>
  8015e2:	83 ec 04             	sub    $0x4,%esp
  8015e5:	68 b5 39 80 00       	push   $0x8039b5
  8015ea:	68 80 00 00 00       	push   $0x80
  8015ef:	68 d3 39 80 00       	push   $0x8039d3
  8015f4:	e8 71 1a 00 00       	call   80306a <_panic>
  8015f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fc:	8b 00                	mov    (%eax),%eax
  8015fe:	85 c0                	test   %eax,%eax
  801600:	74 10                	je     801612 <free+0x74>
  801602:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801605:	8b 00                	mov    (%eax),%eax
  801607:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80160a:	8b 52 04             	mov    0x4(%edx),%edx
  80160d:	89 50 04             	mov    %edx,0x4(%eax)
  801610:	eb 0b                	jmp    80161d <free+0x7f>
  801612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801615:	8b 40 04             	mov    0x4(%eax),%eax
  801618:	a3 44 40 80 00       	mov    %eax,0x804044
  80161d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801620:	8b 40 04             	mov    0x4(%eax),%eax
  801623:	85 c0                	test   %eax,%eax
  801625:	74 0f                	je     801636 <free+0x98>
  801627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162a:	8b 40 04             	mov    0x4(%eax),%eax
  80162d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801630:	8b 12                	mov    (%edx),%edx
  801632:	89 10                	mov    %edx,(%eax)
  801634:	eb 0a                	jmp    801640 <free+0xa2>
  801636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801639:	8b 00                	mov    (%eax),%eax
  80163b:	a3 40 40 80 00       	mov    %eax,0x804040
  801640:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801643:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801653:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801658:	48                   	dec    %eax
  801659:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80165e:	83 ec 0c             	sub    $0xc,%esp
  801661:	ff 75 f0             	pushl  -0x10(%ebp)
  801664:	e8 29 12 00 00       	call   802892 <insert_sorted_with_merge_freeList>
  801669:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  80166c:	83 ec 08             	sub    $0x8,%esp
  80166f:	ff 75 ec             	pushl  -0x14(%ebp)
  801672:	ff 75 e8             	pushl  -0x18(%ebp)
  801675:	e8 74 03 00 00       	call   8019ee <sys_free_user_mem>
  80167a:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80167d:	90                   	nop
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 38             	sub    $0x38,%esp
  801686:	8b 45 10             	mov    0x10(%ebp),%eax
  801689:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80168c:	e8 5f fc ff ff       	call   8012f0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801691:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801695:	75 0a                	jne    8016a1 <smalloc+0x21>
  801697:	b8 00 00 00 00       	mov    $0x0,%eax
  80169c:	e9 b2 00 00 00       	jmp    801753 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8016a1:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016a8:	76 0a                	jbe    8016b4 <smalloc+0x34>
		return NULL;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	e9 9f 00 00 00       	jmp    801753 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016b4:	e8 3b 07 00 00       	call   801df4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b9:	85 c0                	test   %eax,%eax
  8016bb:	0f 84 8d 00 00 00    	je     80174e <smalloc+0xce>
	struct MemBlock *b = NULL;
  8016c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8016c8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d5:	01 d0                	add    %edx,%eax
  8016d7:	48                   	dec    %eax
  8016d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016de:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e3:	f7 75 f0             	divl   -0x10(%ebp)
  8016e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e9:	29 d0                	sub    %edx,%eax
  8016eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8016ee:	83 ec 0c             	sub    $0xc,%esp
  8016f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8016f4:	e8 5b 0c 00 00       	call   802354 <alloc_block_FF>
  8016f9:	83 c4 10             	add    $0x10,%esp
  8016fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8016ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801703:	75 07                	jne    80170c <smalloc+0x8c>
			return NULL;
  801705:	b8 00 00 00 00       	mov    $0x0,%eax
  80170a:	eb 47                	jmp    801753 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  80170c:	83 ec 0c             	sub    $0xc,%esp
  80170f:	ff 75 f4             	pushl  -0xc(%ebp)
  801712:	e8 a5 0a 00 00       	call   8021bc <insert_sorted_allocList>
  801717:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80171a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171d:	8b 40 08             	mov    0x8(%eax),%eax
  801720:	89 c2                	mov    %eax,%edx
  801722:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801726:	52                   	push   %edx
  801727:	50                   	push   %eax
  801728:	ff 75 0c             	pushl  0xc(%ebp)
  80172b:	ff 75 08             	pushl  0x8(%ebp)
  80172e:	e8 46 04 00 00       	call   801b79 <sys_createSharedObject>
  801733:	83 c4 10             	add    $0x10,%esp
  801736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801739:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80173d:	78 08                	js     801747 <smalloc+0xc7>
		return (void *)b->sva;
  80173f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801742:	8b 40 08             	mov    0x8(%eax),%eax
  801745:	eb 0c                	jmp    801753 <smalloc+0xd3>
		}else{
		return NULL;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
  80174c:	eb 05                	jmp    801753 <smalloc+0xd3>
			}

	}return NULL;
  80174e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801753:	c9                   	leave  
  801754:	c3                   	ret    

00801755 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80175b:	e8 90 fb ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801760:	e8 8f 06 00 00       	call   801df4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801765:	85 c0                	test   %eax,%eax
  801767:	0f 84 ad 00 00 00    	je     80181a <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80176d:	83 ec 08             	sub    $0x8,%esp
  801770:	ff 75 0c             	pushl  0xc(%ebp)
  801773:	ff 75 08             	pushl  0x8(%ebp)
  801776:	e8 28 04 00 00       	call   801ba3 <sys_getSizeOfSharedObject>
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801781:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801785:	79 0a                	jns    801791 <sget+0x3c>
    {
    	return NULL;
  801787:	b8 00 00 00 00       	mov    $0x0,%eax
  80178c:	e9 8e 00 00 00       	jmp    80181f <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801791:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801798:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80179f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a5:	01 d0                	add    %edx,%eax
  8017a7:	48                   	dec    %eax
  8017a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b3:	f7 75 ec             	divl   -0x14(%ebp)
  8017b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b9:	29 d0                	sub    %edx,%eax
  8017bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8017be:	83 ec 0c             	sub    $0xc,%esp
  8017c1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017c4:	e8 8b 0b 00 00       	call   802354 <alloc_block_FF>
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8017cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017d3:	75 07                	jne    8017dc <sget+0x87>
				return NULL;
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017da:	eb 43                	jmp    80181f <sget+0xca>
			}
			insert_sorted_allocList(b);
  8017dc:	83 ec 0c             	sub    $0xc,%esp
  8017df:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e2:	e8 d5 09 00 00       	call   8021bc <insert_sorted_allocList>
  8017e7:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8017ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ed:	8b 40 08             	mov    0x8(%eax),%eax
  8017f0:	83 ec 04             	sub    $0x4,%esp
  8017f3:	50                   	push   %eax
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	ff 75 08             	pushl  0x8(%ebp)
  8017fa:	e8 c1 03 00 00       	call   801bc0 <sys_getSharedObject>
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801805:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801809:	78 08                	js     801813 <sget+0xbe>
			return (void *)b->sva;
  80180b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180e:	8b 40 08             	mov    0x8(%eax),%eax
  801811:	eb 0c                	jmp    80181f <sget+0xca>
			}else{
			return NULL;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	eb 05                	jmp    80181f <sget+0xca>
			}
    }}return NULL;
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801827:	e8 c4 fa ff ff       	call   8012f0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	68 04 3a 80 00       	push   $0x803a04
  801834:	68 03 01 00 00       	push   $0x103
  801839:	68 d3 39 80 00       	push   $0x8039d3
  80183e:	e8 27 18 00 00       	call   80306a <_panic>

00801843 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801849:	83 ec 04             	sub    $0x4,%esp
  80184c:	68 2c 3a 80 00       	push   $0x803a2c
  801851:	68 17 01 00 00       	push   $0x117
  801856:	68 d3 39 80 00       	push   $0x8039d3
  80185b:	e8 0a 18 00 00       	call   80306a <_panic>

00801860 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801866:	83 ec 04             	sub    $0x4,%esp
  801869:	68 50 3a 80 00       	push   $0x803a50
  80186e:	68 22 01 00 00       	push   $0x122
  801873:	68 d3 39 80 00       	push   $0x8039d3
  801878:	e8 ed 17 00 00       	call   80306a <_panic>

0080187d <shrink>:

}
void shrink(uint32 newSize)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
  801880:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801883:	83 ec 04             	sub    $0x4,%esp
  801886:	68 50 3a 80 00       	push   $0x803a50
  80188b:	68 27 01 00 00       	push   $0x127
  801890:	68 d3 39 80 00       	push   $0x8039d3
  801895:	e8 d0 17 00 00       	call   80306a <_panic>

0080189a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	68 50 3a 80 00       	push   $0x803a50
  8018a8:	68 2c 01 00 00       	push   $0x12c
  8018ad:	68 d3 39 80 00       	push   $0x8039d3
  8018b2:	e8 b3 17 00 00       	call   80306a <_panic>

008018b7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	57                   	push   %edi
  8018bb:	56                   	push   %esi
  8018bc:	53                   	push   %ebx
  8018bd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018cc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018cf:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018d2:	cd 30                	int    $0x30
  8018d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018da:	83 c4 10             	add    $0x10,%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5e                   	pop    %esi
  8018df:	5f                   	pop    %edi
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	83 ec 04             	sub    $0x4,%esp
  8018e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018ee:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	52                   	push   %edx
  8018fa:	ff 75 0c             	pushl  0xc(%ebp)
  8018fd:	50                   	push   %eax
  8018fe:	6a 00                	push   $0x0
  801900:	e8 b2 ff ff ff       	call   8018b7 <syscall>
  801905:	83 c4 18             	add    $0x18,%esp
}
  801908:	90                   	nop
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_cgetc>:

int
sys_cgetc(void)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 01                	push   $0x1
  80191a:	e8 98 ff ff ff       	call   8018b7 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192a:	8b 45 08             	mov    0x8(%ebp),%eax
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	52                   	push   %edx
  801934:	50                   	push   %eax
  801935:	6a 05                	push   $0x5
  801937:	e8 7b ff ff ff       	call   8018b7 <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
  801944:	56                   	push   %esi
  801945:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801946:	8b 75 18             	mov    0x18(%ebp),%esi
  801949:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80194c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	56                   	push   %esi
  801956:	53                   	push   %ebx
  801957:	51                   	push   %ecx
  801958:	52                   	push   %edx
  801959:	50                   	push   %eax
  80195a:	6a 06                	push   $0x6
  80195c:	e8 56 ff ff ff       	call   8018b7 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801967:	5b                   	pop    %ebx
  801968:	5e                   	pop    %esi
  801969:	5d                   	pop    %ebp
  80196a:	c3                   	ret    

0080196b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80196e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	52                   	push   %edx
  80197b:	50                   	push   %eax
  80197c:	6a 07                	push   $0x7
  80197e:	e8 34 ff ff ff       	call   8018b7 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 08                	push   $0x8
  801999:	e8 19 ff ff ff       	call   8018b7 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	c9                   	leave  
  8019a2:	c3                   	ret    

008019a3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019a3:	55                   	push   %ebp
  8019a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 09                	push   $0x9
  8019b2:	e8 00 ff ff ff       	call   8018b7 <syscall>
  8019b7:	83 c4 18             	add    $0x18,%esp
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 0a                	push   $0xa
  8019cb:	e8 e7 fe ff ff       	call   8018b7 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 0b                	push   $0xb
  8019e4:	e8 ce fe ff ff       	call   8018b7 <syscall>
  8019e9:	83 c4 18             	add    $0x18,%esp
}
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	ff 75 0c             	pushl  0xc(%ebp)
  8019fa:	ff 75 08             	pushl  0x8(%ebp)
  8019fd:	6a 0f                	push   $0xf
  8019ff:	e8 b3 fe ff ff       	call   8018b7 <syscall>
  801a04:	83 c4 18             	add    $0x18,%esp
	return;
  801a07:	90                   	nop
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	ff 75 08             	pushl  0x8(%ebp)
  801a19:	6a 10                	push   $0x10
  801a1b:	e8 97 fe ff ff       	call   8018b7 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
	return ;
  801a23:	90                   	nop
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	ff 75 10             	pushl  0x10(%ebp)
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	6a 11                	push   $0x11
  801a38:	e8 7a fe ff ff       	call   8018b7 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a40:	90                   	nop
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 0c                	push   $0xc
  801a52:	e8 60 fe ff ff       	call   8018b7 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	c9                   	leave  
  801a5b:	c3                   	ret    

00801a5c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a5c:	55                   	push   %ebp
  801a5d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	ff 75 08             	pushl  0x8(%ebp)
  801a6a:	6a 0d                	push   $0xd
  801a6c:	e8 46 fe ff ff       	call   8018b7 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 0e                	push   $0xe
  801a85:	e8 2d fe ff ff       	call   8018b7 <syscall>
  801a8a:	83 c4 18             	add    $0x18,%esp
}
  801a8d:	90                   	nop
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 13                	push   $0x13
  801a9f:	e8 13 fe ff ff       	call   8018b7 <syscall>
  801aa4:	83 c4 18             	add    $0x18,%esp
}
  801aa7:	90                   	nop
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 14                	push   $0x14
  801ab9:	e8 f9 fd ff ff       	call   8018b7 <syscall>
  801abe:	83 c4 18             	add    $0x18,%esp
}
  801ac1:	90                   	nop
  801ac2:	c9                   	leave  
  801ac3:	c3                   	ret    

00801ac4 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	83 ec 04             	sub    $0x4,%esp
  801aca:	8b 45 08             	mov    0x8(%ebp),%eax
  801acd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ad0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	50                   	push   %eax
  801add:	6a 15                	push   $0x15
  801adf:	e8 d3 fd ff ff       	call   8018b7 <syscall>
  801ae4:	83 c4 18             	add    $0x18,%esp
}
  801ae7:	90                   	nop
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 16                	push   $0x16
  801af9:	e8 b9 fd ff ff       	call   8018b7 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	90                   	nop
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	50                   	push   %eax
  801b14:	6a 17                	push   $0x17
  801b16:	e8 9c fd ff ff       	call   8018b7 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 1a                	push   $0x1a
  801b33:	e8 7f fd ff ff       	call   8018b7 <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	52                   	push   %edx
  801b4d:	50                   	push   %eax
  801b4e:	6a 18                	push   $0x18
  801b50:	e8 62 fd ff ff       	call   8018b7 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b61:	8b 45 08             	mov    0x8(%ebp),%eax
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	52                   	push   %edx
  801b6b:	50                   	push   %eax
  801b6c:	6a 19                	push   $0x19
  801b6e:	e8 44 fd ff ff       	call   8018b7 <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	90                   	nop
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 04             	sub    $0x4,%esp
  801b7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b82:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b85:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b88:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8f:	6a 00                	push   $0x0
  801b91:	51                   	push   %ecx
  801b92:	52                   	push   %edx
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	50                   	push   %eax
  801b97:	6a 1b                	push   $0x1b
  801b99:	e8 19 fd ff ff       	call   8018b7 <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	52                   	push   %edx
  801bb3:	50                   	push   %eax
  801bb4:	6a 1c                	push   $0x1c
  801bb6:	e8 fc fc ff ff       	call   8018b7 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	51                   	push   %ecx
  801bd1:	52                   	push   %edx
  801bd2:	50                   	push   %eax
  801bd3:	6a 1d                	push   $0x1d
  801bd5:	e8 dd fc ff ff       	call   8018b7 <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	52                   	push   %edx
  801bef:	50                   	push   %eax
  801bf0:	6a 1e                	push   $0x1e
  801bf2:	e8 c0 fc ff ff       	call   8018b7 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 1f                	push   $0x1f
  801c0b:	e8 a7 fc ff ff       	call   8018b7 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	ff 75 14             	pushl  0x14(%ebp)
  801c20:	ff 75 10             	pushl  0x10(%ebp)
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	50                   	push   %eax
  801c27:	6a 20                	push   $0x20
  801c29:	e8 89 fc ff ff       	call   8018b7 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	50                   	push   %eax
  801c42:	6a 21                	push   $0x21
  801c44:	e8 6e fc ff ff       	call   8018b7 <syscall>
  801c49:	83 c4 18             	add    $0x18,%esp
}
  801c4c:	90                   	nop
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	50                   	push   %eax
  801c5e:	6a 22                	push   $0x22
  801c60:	e8 52 fc ff ff       	call   8018b7 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 02                	push   $0x2
  801c79:	e8 39 fc ff ff       	call   8018b7 <syscall>
  801c7e:	83 c4 18             	add    $0x18,%esp
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 03                	push   $0x3
  801c92:	e8 20 fc ff ff       	call   8018b7 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 04                	push   $0x4
  801cab:	e8 07 fc ff ff       	call   8018b7 <syscall>
  801cb0:	83 c4 18             	add    $0x18,%esp
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <sys_exit_env>:


void sys_exit_env(void)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 23                	push   $0x23
  801cc4:	e8 ee fb ff ff       	call   8018b7 <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
}
  801ccc:	90                   	nop
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cd5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cd8:	8d 50 04             	lea    0x4(%eax),%edx
  801cdb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	52                   	push   %edx
  801ce5:	50                   	push   %eax
  801ce6:	6a 24                	push   $0x24
  801ce8:	e8 ca fb ff ff       	call   8018b7 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
	return result;
  801cf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cf6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cf9:	89 01                	mov    %eax,(%ecx)
  801cfb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801d01:	c9                   	leave  
  801d02:	c2 04 00             	ret    $0x4

00801d05 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	ff 75 10             	pushl  0x10(%ebp)
  801d0f:	ff 75 0c             	pushl  0xc(%ebp)
  801d12:	ff 75 08             	pushl  0x8(%ebp)
  801d15:	6a 12                	push   $0x12
  801d17:	e8 9b fb ff ff       	call   8018b7 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1f:	90                   	nop
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 25                	push   $0x25
  801d31:	e8 81 fb ff ff       	call   8018b7 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 04             	sub    $0x4,%esp
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d47:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	50                   	push   %eax
  801d54:	6a 26                	push   $0x26
  801d56:	e8 5c fb ff ff       	call   8018b7 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5e:	90                   	nop
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <rsttst>:
void rsttst()
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 28                	push   $0x28
  801d70:	e8 42 fb ff ff       	call   8018b7 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
	return ;
  801d78:	90                   	nop
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 04             	sub    $0x4,%esp
  801d81:	8b 45 14             	mov    0x14(%ebp),%eax
  801d84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d87:	8b 55 18             	mov    0x18(%ebp),%edx
  801d8a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d8e:	52                   	push   %edx
  801d8f:	50                   	push   %eax
  801d90:	ff 75 10             	pushl  0x10(%ebp)
  801d93:	ff 75 0c             	pushl  0xc(%ebp)
  801d96:	ff 75 08             	pushl  0x8(%ebp)
  801d99:	6a 27                	push   $0x27
  801d9b:	e8 17 fb ff ff       	call   8018b7 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
	return ;
  801da3:	90                   	nop
}
  801da4:	c9                   	leave  
  801da5:	c3                   	ret    

00801da6 <chktst>:
void chktst(uint32 n)
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	ff 75 08             	pushl  0x8(%ebp)
  801db4:	6a 29                	push   $0x29
  801db6:	e8 fc fa ff ff       	call   8018b7 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbe:	90                   	nop
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <inctst>:

void inctst()
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 2a                	push   $0x2a
  801dd0:	e8 e2 fa ff ff       	call   8018b7 <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd8:	90                   	nop
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <gettst>:
uint32 gettst()
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 2b                	push   $0x2b
  801dea:	e8 c8 fa ff ff       	call   8018b7 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 2c                	push   $0x2c
  801e06:	e8 ac fa ff ff       	call   8018b7 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
  801e0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e11:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e15:	75 07                	jne    801e1e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e17:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1c:	eb 05                	jmp    801e23 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 2c                	push   $0x2c
  801e37:	e8 7b fa ff ff       	call   8018b7 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
  801e3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e42:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e46:	75 07                	jne    801e4f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e48:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4d:	eb 05                	jmp    801e54 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 2c                	push   $0x2c
  801e68:	e8 4a fa ff ff       	call   8018b7 <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
  801e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e73:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e77:	75 07                	jne    801e80 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e79:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7e:	eb 05                	jmp    801e85 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 2c                	push   $0x2c
  801e99:	e8 19 fa ff ff       	call   8018b7 <syscall>
  801e9e:	83 c4 18             	add    $0x18,%esp
  801ea1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ea4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ea8:	75 07                	jne    801eb1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801eaf:	eb 05                	jmp    801eb6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb6:	c9                   	leave  
  801eb7:	c3                   	ret    

00801eb8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eb8:	55                   	push   %ebp
  801eb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ebb:	6a 00                	push   $0x0
  801ebd:	6a 00                	push   $0x0
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	ff 75 08             	pushl  0x8(%ebp)
  801ec6:	6a 2d                	push   $0x2d
  801ec8:	e8 ea f9 ff ff       	call   8018b7 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed0:	90                   	nop
}
  801ed1:	c9                   	leave  
  801ed2:	c3                   	ret    

00801ed3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ed3:	55                   	push   %ebp
  801ed4:	89 e5                	mov    %esp,%ebp
  801ed6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ed7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eda:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801edd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	6a 00                	push   $0x0
  801ee5:	53                   	push   %ebx
  801ee6:	51                   	push   %ecx
  801ee7:	52                   	push   %edx
  801ee8:	50                   	push   %eax
  801ee9:	6a 2e                	push   $0x2e
  801eeb:	e8 c7 f9 ff ff       	call   8018b7 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801efb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efe:	8b 45 08             	mov    0x8(%ebp),%eax
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	52                   	push   %edx
  801f08:	50                   	push   %eax
  801f09:	6a 2f                	push   $0x2f
  801f0b:	e8 a7 f9 ff ff       	call   8018b7 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
}
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	68 60 3a 80 00       	push   $0x803a60
  801f23:	e8 3e e6 ff ff       	call   800566 <cprintf>
  801f28:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	68 8c 3a 80 00       	push   $0x803a8c
  801f3a:	e8 27 e6 ff ff       	call   800566 <cprintf>
  801f3f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f42:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f46:	a1 38 41 80 00       	mov    0x804138,%eax
  801f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4e:	eb 56                	jmp    801fa6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f54:	74 1c                	je     801f72 <print_mem_block_lists+0x5d>
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	8b 50 08             	mov    0x8(%eax),%edx
  801f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5f:	8b 48 08             	mov    0x8(%eax),%ecx
  801f62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f65:	8b 40 0c             	mov    0xc(%eax),%eax
  801f68:	01 c8                	add    %ecx,%eax
  801f6a:	39 c2                	cmp    %eax,%edx
  801f6c:	73 04                	jae    801f72 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f6e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	8b 50 08             	mov    0x8(%eax),%edx
  801f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f7e:	01 c2                	add    %eax,%edx
  801f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f83:	8b 40 08             	mov    0x8(%eax),%eax
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	52                   	push   %edx
  801f8a:	50                   	push   %eax
  801f8b:	68 a1 3a 80 00       	push   $0x803aa1
  801f90:	e8 d1 e5 ff ff       	call   800566 <cprintf>
  801f95:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f9e:	a1 40 41 80 00       	mov    0x804140,%eax
  801fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801faa:	74 07                	je     801fb3 <print_mem_block_lists+0x9e>
  801fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faf:	8b 00                	mov    (%eax),%eax
  801fb1:	eb 05                	jmp    801fb8 <print_mem_block_lists+0xa3>
  801fb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb8:	a3 40 41 80 00       	mov    %eax,0x804140
  801fbd:	a1 40 41 80 00       	mov    0x804140,%eax
  801fc2:	85 c0                	test   %eax,%eax
  801fc4:	75 8a                	jne    801f50 <print_mem_block_lists+0x3b>
  801fc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fca:	75 84                	jne    801f50 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fcc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fd0:	75 10                	jne    801fe2 <print_mem_block_lists+0xcd>
  801fd2:	83 ec 0c             	sub    $0xc,%esp
  801fd5:	68 b0 3a 80 00       	push   $0x803ab0
  801fda:	e8 87 e5 ff ff       	call   800566 <cprintf>
  801fdf:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fe2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fe9:	83 ec 0c             	sub    $0xc,%esp
  801fec:	68 d4 3a 80 00       	push   $0x803ad4
  801ff1:	e8 70 e5 ff ff       	call   800566 <cprintf>
  801ff6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ff9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ffd:	a1 40 40 80 00       	mov    0x804040,%eax
  802002:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802005:	eb 56                	jmp    80205d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802007:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80200b:	74 1c                	je     802029 <print_mem_block_lists+0x114>
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	8b 50 08             	mov    0x8(%eax),%edx
  802013:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802016:	8b 48 08             	mov    0x8(%eax),%ecx
  802019:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201c:	8b 40 0c             	mov    0xc(%eax),%eax
  80201f:	01 c8                	add    %ecx,%eax
  802021:	39 c2                	cmp    %eax,%edx
  802023:	73 04                	jae    802029 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802025:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202c:	8b 50 08             	mov    0x8(%eax),%edx
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	8b 40 0c             	mov    0xc(%eax),%eax
  802035:	01 c2                	add    %eax,%edx
  802037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203a:	8b 40 08             	mov    0x8(%eax),%eax
  80203d:	83 ec 04             	sub    $0x4,%esp
  802040:	52                   	push   %edx
  802041:	50                   	push   %eax
  802042:	68 a1 3a 80 00       	push   $0x803aa1
  802047:	e8 1a e5 ff ff       	call   800566 <cprintf>
  80204c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80204f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802052:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802055:	a1 48 40 80 00       	mov    0x804048,%eax
  80205a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802061:	74 07                	je     80206a <print_mem_block_lists+0x155>
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	8b 00                	mov    (%eax),%eax
  802068:	eb 05                	jmp    80206f <print_mem_block_lists+0x15a>
  80206a:	b8 00 00 00 00       	mov    $0x0,%eax
  80206f:	a3 48 40 80 00       	mov    %eax,0x804048
  802074:	a1 48 40 80 00       	mov    0x804048,%eax
  802079:	85 c0                	test   %eax,%eax
  80207b:	75 8a                	jne    802007 <print_mem_block_lists+0xf2>
  80207d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802081:	75 84                	jne    802007 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802083:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802087:	75 10                	jne    802099 <print_mem_block_lists+0x184>
  802089:	83 ec 0c             	sub    $0xc,%esp
  80208c:	68 ec 3a 80 00       	push   $0x803aec
  802091:	e8 d0 e4 ff ff       	call   800566 <cprintf>
  802096:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802099:	83 ec 0c             	sub    $0xc,%esp
  80209c:	68 60 3a 80 00       	push   $0x803a60
  8020a1:	e8 c0 e4 ff ff       	call   800566 <cprintf>
  8020a6:	83 c4 10             	add    $0x10,%esp

}
  8020a9:	90                   	nop
  8020aa:	c9                   	leave  
  8020ab:	c3                   	ret    

008020ac <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020ac:	55                   	push   %ebp
  8020ad:	89 e5                	mov    %esp,%ebp
  8020af:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020b2:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020b9:	00 00 00 
  8020bc:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020c3:	00 00 00 
  8020c6:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020cd:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8020d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020d7:	e9 9e 00 00 00       	jmp    80217a <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8020dc:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e4:	c1 e2 04             	shl    $0x4,%edx
  8020e7:	01 d0                	add    %edx,%eax
  8020e9:	85 c0                	test   %eax,%eax
  8020eb:	75 14                	jne    802101 <initialize_MemBlocksList+0x55>
  8020ed:	83 ec 04             	sub    $0x4,%esp
  8020f0:	68 14 3b 80 00       	push   $0x803b14
  8020f5:	6a 3d                	push   $0x3d
  8020f7:	68 37 3b 80 00       	push   $0x803b37
  8020fc:	e8 69 0f 00 00       	call   80306a <_panic>
  802101:	a1 50 40 80 00       	mov    0x804050,%eax
  802106:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802109:	c1 e2 04             	shl    $0x4,%edx
  80210c:	01 d0                	add    %edx,%eax
  80210e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802114:	89 10                	mov    %edx,(%eax)
  802116:	8b 00                	mov    (%eax),%eax
  802118:	85 c0                	test   %eax,%eax
  80211a:	74 18                	je     802134 <initialize_MemBlocksList+0x88>
  80211c:	a1 48 41 80 00       	mov    0x804148,%eax
  802121:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802127:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80212a:	c1 e1 04             	shl    $0x4,%ecx
  80212d:	01 ca                	add    %ecx,%edx
  80212f:	89 50 04             	mov    %edx,0x4(%eax)
  802132:	eb 12                	jmp    802146 <initialize_MemBlocksList+0x9a>
  802134:	a1 50 40 80 00       	mov    0x804050,%eax
  802139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213c:	c1 e2 04             	shl    $0x4,%edx
  80213f:	01 d0                	add    %edx,%eax
  802141:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802146:	a1 50 40 80 00       	mov    0x804050,%eax
  80214b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80214e:	c1 e2 04             	shl    $0x4,%edx
  802151:	01 d0                	add    %edx,%eax
  802153:	a3 48 41 80 00       	mov    %eax,0x804148
  802158:	a1 50 40 80 00       	mov    0x804050,%eax
  80215d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802160:	c1 e2 04             	shl    $0x4,%edx
  802163:	01 d0                	add    %edx,%eax
  802165:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80216c:	a1 54 41 80 00       	mov    0x804154,%eax
  802171:	40                   	inc    %eax
  802172:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802177:	ff 45 f4             	incl   -0xc(%ebp)
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802180:	0f 82 56 ff ff ff    	jb     8020dc <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802186:	90                   	nop
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	8b 00                	mov    (%eax),%eax
  802194:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802197:	eb 18                	jmp    8021b1 <find_block+0x28>

		if(tmp->sva == va){
  802199:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219c:	8b 40 08             	mov    0x8(%eax),%eax
  80219f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021a2:	75 05                	jne    8021a9 <find_block+0x20>
			return tmp ;
  8021a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a7:	eb 11                	jmp    8021ba <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8021a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ac:	8b 00                	mov    (%eax),%eax
  8021ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8021b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b5:	75 e2                	jne    802199 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8021b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021ba:	c9                   	leave  
  8021bb:	c3                   	ret    

008021bc <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8021c2:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8021ca:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8021d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021d6:	75 65                	jne    80223d <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8021d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021dc:	75 14                	jne    8021f2 <insert_sorted_allocList+0x36>
  8021de:	83 ec 04             	sub    $0x4,%esp
  8021e1:	68 14 3b 80 00       	push   $0x803b14
  8021e6:	6a 62                	push   $0x62
  8021e8:	68 37 3b 80 00       	push   $0x803b37
  8021ed:	e8 78 0e 00 00       	call   80306a <_panic>
  8021f2:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fb:	89 10                	mov    %edx,(%eax)
  8021fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802200:	8b 00                	mov    (%eax),%eax
  802202:	85 c0                	test   %eax,%eax
  802204:	74 0d                	je     802213 <insert_sorted_allocList+0x57>
  802206:	a1 40 40 80 00       	mov    0x804040,%eax
  80220b:	8b 55 08             	mov    0x8(%ebp),%edx
  80220e:	89 50 04             	mov    %edx,0x4(%eax)
  802211:	eb 08                	jmp    80221b <insert_sorted_allocList+0x5f>
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	a3 44 40 80 00       	mov    %eax,0x804044
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	a3 40 40 80 00       	mov    %eax,0x804040
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80222d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802232:	40                   	inc    %eax
  802233:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802238:	e9 14 01 00 00       	jmp    802351 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	8b 50 08             	mov    0x8(%eax),%edx
  802243:	a1 44 40 80 00       	mov    0x804044,%eax
  802248:	8b 40 08             	mov    0x8(%eax),%eax
  80224b:	39 c2                	cmp    %eax,%edx
  80224d:	76 65                	jbe    8022b4 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80224f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802253:	75 14                	jne    802269 <insert_sorted_allocList+0xad>
  802255:	83 ec 04             	sub    $0x4,%esp
  802258:	68 50 3b 80 00       	push   $0x803b50
  80225d:	6a 64                	push   $0x64
  80225f:	68 37 3b 80 00       	push   $0x803b37
  802264:	e8 01 0e 00 00       	call   80306a <_panic>
  802269:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	89 50 04             	mov    %edx,0x4(%eax)
  802275:	8b 45 08             	mov    0x8(%ebp),%eax
  802278:	8b 40 04             	mov    0x4(%eax),%eax
  80227b:	85 c0                	test   %eax,%eax
  80227d:	74 0c                	je     80228b <insert_sorted_allocList+0xcf>
  80227f:	a1 44 40 80 00       	mov    0x804044,%eax
  802284:	8b 55 08             	mov    0x8(%ebp),%edx
  802287:	89 10                	mov    %edx,(%eax)
  802289:	eb 08                	jmp    802293 <insert_sorted_allocList+0xd7>
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	a3 40 40 80 00       	mov    %eax,0x804040
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	a3 44 40 80 00       	mov    %eax,0x804044
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022a9:	40                   	inc    %eax
  8022aa:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022af:	e9 9d 00 00 00       	jmp    802351 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8022b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8022bb:	e9 85 00 00 00       	jmp    802345 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	8b 50 08             	mov    0x8(%eax),%edx
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	8b 40 08             	mov    0x8(%eax),%eax
  8022cc:	39 c2                	cmp    %eax,%edx
  8022ce:	73 6a                	jae    80233a <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8022d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d4:	74 06                	je     8022dc <insert_sorted_allocList+0x120>
  8022d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022da:	75 14                	jne    8022f0 <insert_sorted_allocList+0x134>
  8022dc:	83 ec 04             	sub    $0x4,%esp
  8022df:	68 74 3b 80 00       	push   $0x803b74
  8022e4:	6a 6b                	push   $0x6b
  8022e6:	68 37 3b 80 00       	push   $0x803b37
  8022eb:	e8 7a 0d 00 00       	call   80306a <_panic>
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 50 04             	mov    0x4(%eax),%edx
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	89 50 04             	mov    %edx,0x4(%eax)
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802302:	89 10                	mov    %edx,(%eax)
  802304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802307:	8b 40 04             	mov    0x4(%eax),%eax
  80230a:	85 c0                	test   %eax,%eax
  80230c:	74 0d                	je     80231b <insert_sorted_allocList+0x15f>
  80230e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802311:	8b 40 04             	mov    0x4(%eax),%eax
  802314:	8b 55 08             	mov    0x8(%ebp),%edx
  802317:	89 10                	mov    %edx,(%eax)
  802319:	eb 08                	jmp    802323 <insert_sorted_allocList+0x167>
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	a3 40 40 80 00       	mov    %eax,0x804040
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 55 08             	mov    0x8(%ebp),%edx
  802329:	89 50 04             	mov    %edx,0x4(%eax)
  80232c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802331:	40                   	inc    %eax
  802332:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802337:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802338:	eb 17                	jmp    802351 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	8b 00                	mov    (%eax),%eax
  80233f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802342:	ff 45 f0             	incl   -0x10(%ebp)
  802345:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802348:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80234b:	0f 8c 6f ff ff ff    	jl     8022c0 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802351:	90                   	nop
  802352:	c9                   	leave  
  802353:	c3                   	ret    

00802354 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802354:	55                   	push   %ebp
  802355:	89 e5                	mov    %esp,%ebp
  802357:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80235a:	a1 38 41 80 00       	mov    0x804138,%eax
  80235f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802362:	e9 7c 01 00 00       	jmp    8024e3 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236a:	8b 40 0c             	mov    0xc(%eax),%eax
  80236d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802370:	0f 86 cf 00 00 00    	jbe    802445 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802376:	a1 48 41 80 00       	mov    0x804148,%eax
  80237b:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80237e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802381:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802387:	8b 55 08             	mov    0x8(%ebp),%edx
  80238a:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 50 08             	mov    0x8(%eax),%edx
  802393:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802396:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	8b 40 0c             	mov    0xc(%eax),%eax
  80239f:	2b 45 08             	sub    0x8(%ebp),%eax
  8023a2:	89 c2                	mov    %eax,%edx
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	8b 50 08             	mov    0x8(%eax),%edx
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	01 c2                	add    %eax,%edx
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8023bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023bf:	75 17                	jne    8023d8 <alloc_block_FF+0x84>
  8023c1:	83 ec 04             	sub    $0x4,%esp
  8023c4:	68 a9 3b 80 00       	push   $0x803ba9
  8023c9:	68 83 00 00 00       	push   $0x83
  8023ce:	68 37 3b 80 00       	push   $0x803b37
  8023d3:	e8 92 0c 00 00       	call   80306a <_panic>
  8023d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023db:	8b 00                	mov    (%eax),%eax
  8023dd:	85 c0                	test   %eax,%eax
  8023df:	74 10                	je     8023f1 <alloc_block_FF+0x9d>
  8023e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e4:	8b 00                	mov    (%eax),%eax
  8023e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023e9:	8b 52 04             	mov    0x4(%edx),%edx
  8023ec:	89 50 04             	mov    %edx,0x4(%eax)
  8023ef:	eb 0b                	jmp    8023fc <alloc_block_FF+0xa8>
  8023f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f4:	8b 40 04             	mov    0x4(%eax),%eax
  8023f7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ff:	8b 40 04             	mov    0x4(%eax),%eax
  802402:	85 c0                	test   %eax,%eax
  802404:	74 0f                	je     802415 <alloc_block_FF+0xc1>
  802406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802409:	8b 40 04             	mov    0x4(%eax),%eax
  80240c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80240f:	8b 12                	mov    (%edx),%edx
  802411:	89 10                	mov    %edx,(%eax)
  802413:	eb 0a                	jmp    80241f <alloc_block_FF+0xcb>
  802415:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802418:	8b 00                	mov    (%eax),%eax
  80241a:	a3 48 41 80 00       	mov    %eax,0x804148
  80241f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802422:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802428:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802432:	a1 54 41 80 00       	mov    0x804154,%eax
  802437:	48                   	dec    %eax
  802438:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  80243d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802440:	e9 ad 00 00 00       	jmp    8024f2 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 40 0c             	mov    0xc(%eax),%eax
  80244b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244e:	0f 85 87 00 00 00    	jne    8024db <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802458:	75 17                	jne    802471 <alloc_block_FF+0x11d>
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	68 a9 3b 80 00       	push   $0x803ba9
  802462:	68 87 00 00 00       	push   $0x87
  802467:	68 37 3b 80 00       	push   $0x803b37
  80246c:	e8 f9 0b 00 00       	call   80306a <_panic>
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	8b 00                	mov    (%eax),%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	74 10                	je     80248a <alloc_block_FF+0x136>
  80247a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247d:	8b 00                	mov    (%eax),%eax
  80247f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802482:	8b 52 04             	mov    0x4(%edx),%edx
  802485:	89 50 04             	mov    %edx,0x4(%eax)
  802488:	eb 0b                	jmp    802495 <alloc_block_FF+0x141>
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	8b 40 04             	mov    0x4(%eax),%eax
  802490:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 04             	mov    0x4(%eax),%eax
  80249b:	85 c0                	test   %eax,%eax
  80249d:	74 0f                	je     8024ae <alloc_block_FF+0x15a>
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 40 04             	mov    0x4(%eax),%eax
  8024a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a8:	8b 12                	mov    (%edx),%edx
  8024aa:	89 10                	mov    %edx,(%eax)
  8024ac:	eb 0a                	jmp    8024b8 <alloc_block_FF+0x164>
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	8b 00                	mov    (%eax),%eax
  8024b3:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cb:	a1 44 41 80 00       	mov    0x804144,%eax
  8024d0:	48                   	dec    %eax
  8024d1:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	eb 17                	jmp    8024f2 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 00                	mov    (%eax),%eax
  8024e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8024e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e7:	0f 85 7a fe ff ff    	jne    802367 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8024ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f2:	c9                   	leave  
  8024f3:	c3                   	ret    

008024f4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8024fa:	a1 38 41 80 00       	mov    0x804138,%eax
  8024ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802502:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802509:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802510:	a1 38 41 80 00       	mov    0x804138,%eax
  802515:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802518:	e9 d0 00 00 00       	jmp    8025ed <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 40 0c             	mov    0xc(%eax),%eax
  802523:	3b 45 08             	cmp    0x8(%ebp),%eax
  802526:	0f 82 b8 00 00 00    	jb     8025e4 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 40 0c             	mov    0xc(%eax),%eax
  802532:	2b 45 08             	sub    0x8(%ebp),%eax
  802535:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802538:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80253e:	0f 83 a1 00 00 00    	jae    8025e5 <alloc_block_BF+0xf1>
				differsize = differance ;
  802544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802547:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802550:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802554:	0f 85 8b 00 00 00    	jne    8025e5 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80255a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255e:	75 17                	jne    802577 <alloc_block_BF+0x83>
  802560:	83 ec 04             	sub    $0x4,%esp
  802563:	68 a9 3b 80 00       	push   $0x803ba9
  802568:	68 a0 00 00 00       	push   $0xa0
  80256d:	68 37 3b 80 00       	push   $0x803b37
  802572:	e8 f3 0a 00 00       	call   80306a <_panic>
  802577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257a:	8b 00                	mov    (%eax),%eax
  80257c:	85 c0                	test   %eax,%eax
  80257e:	74 10                	je     802590 <alloc_block_BF+0x9c>
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 00                	mov    (%eax),%eax
  802585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802588:	8b 52 04             	mov    0x4(%edx),%edx
  80258b:	89 50 04             	mov    %edx,0x4(%eax)
  80258e:	eb 0b                	jmp    80259b <alloc_block_BF+0xa7>
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	8b 40 04             	mov    0x4(%eax),%eax
  802596:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 40 04             	mov    0x4(%eax),%eax
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	74 0f                	je     8025b4 <alloc_block_BF+0xc0>
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 40 04             	mov    0x4(%eax),%eax
  8025ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ae:	8b 12                	mov    (%edx),%edx
  8025b0:	89 10                	mov    %edx,(%eax)
  8025b2:	eb 0a                	jmp    8025be <alloc_block_BF+0xca>
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	8b 00                	mov    (%eax),%eax
  8025b9:	a3 38 41 80 00       	mov    %eax,0x804138
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d1:	a1 44 41 80 00       	mov    0x804144,%eax
  8025d6:	48                   	dec    %eax
  8025d7:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	e9 0c 01 00 00       	jmp    8026f0 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8025e4:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025e5:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f1:	74 07                	je     8025fa <alloc_block_BF+0x106>
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 00                	mov    (%eax),%eax
  8025f8:	eb 05                	jmp    8025ff <alloc_block_BF+0x10b>
  8025fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ff:	a3 40 41 80 00       	mov    %eax,0x804140
  802604:	a1 40 41 80 00       	mov    0x804140,%eax
  802609:	85 c0                	test   %eax,%eax
  80260b:	0f 85 0c ff ff ff    	jne    80251d <alloc_block_BF+0x29>
  802611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802615:	0f 85 02 ff ff ff    	jne    80251d <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80261b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80261f:	0f 84 c6 00 00 00    	je     8026eb <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802625:	a1 48 41 80 00       	mov    0x804148,%eax
  80262a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80262d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802630:	8b 55 08             	mov    0x8(%ebp),%edx
  802633:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	8b 50 08             	mov    0x8(%eax),%edx
  80263c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80263f:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802645:	8b 40 0c             	mov    0xc(%eax),%eax
  802648:	2b 45 08             	sub    0x8(%ebp),%eax
  80264b:	89 c2                	mov    %eax,%edx
  80264d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802650:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802653:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802656:	8b 50 08             	mov    0x8(%eax),%edx
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	01 c2                	add    %eax,%edx
  80265e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802661:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802664:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802668:	75 17                	jne    802681 <alloc_block_BF+0x18d>
  80266a:	83 ec 04             	sub    $0x4,%esp
  80266d:	68 a9 3b 80 00       	push   $0x803ba9
  802672:	68 af 00 00 00       	push   $0xaf
  802677:	68 37 3b 80 00       	push   $0x803b37
  80267c:	e8 e9 09 00 00       	call   80306a <_panic>
  802681:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802684:	8b 00                	mov    (%eax),%eax
  802686:	85 c0                	test   %eax,%eax
  802688:	74 10                	je     80269a <alloc_block_BF+0x1a6>
  80268a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268d:	8b 00                	mov    (%eax),%eax
  80268f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802692:	8b 52 04             	mov    0x4(%edx),%edx
  802695:	89 50 04             	mov    %edx,0x4(%eax)
  802698:	eb 0b                	jmp    8026a5 <alloc_block_BF+0x1b1>
  80269a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269d:	8b 40 04             	mov    0x4(%eax),%eax
  8026a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	85 c0                	test   %eax,%eax
  8026ad:	74 0f                	je     8026be <alloc_block_BF+0x1ca>
  8026af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b2:	8b 40 04             	mov    0x4(%eax),%eax
  8026b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026b8:	8b 12                	mov    (%edx),%edx
  8026ba:	89 10                	mov    %edx,(%eax)
  8026bc:	eb 0a                	jmp    8026c8 <alloc_block_BF+0x1d4>
  8026be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c1:	8b 00                	mov    (%eax),%eax
  8026c3:	a3 48 41 80 00       	mov    %eax,0x804148
  8026c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026db:	a1 54 41 80 00       	mov    0x804154,%eax
  8026e0:	48                   	dec    %eax
  8026e1:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8026e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e9:	eb 05                	jmp    8026f0 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8026eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f0:	c9                   	leave  
  8026f1:	c3                   	ret    

008026f2 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8026f8:	a1 38 41 80 00       	mov    0x804138,%eax
  8026fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802700:	e9 7c 01 00 00       	jmp    802881 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 0c             	mov    0xc(%eax),%eax
  80270b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80270e:	0f 86 cf 00 00 00    	jbe    8027e3 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802714:	a1 48 41 80 00       	mov    0x804148,%eax
  802719:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  80271c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802722:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802725:	8b 55 08             	mov    0x8(%ebp),%edx
  802728:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 50 08             	mov    0x8(%eax),%edx
  802731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802734:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 40 0c             	mov    0xc(%eax),%eax
  80273d:	2b 45 08             	sub    0x8(%ebp),%eax
  802740:	89 c2                	mov    %eax,%edx
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	8b 50 08             	mov    0x8(%eax),%edx
  80274e:	8b 45 08             	mov    0x8(%ebp),%eax
  802751:	01 c2                	add    %eax,%edx
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802759:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80275d:	75 17                	jne    802776 <alloc_block_NF+0x84>
  80275f:	83 ec 04             	sub    $0x4,%esp
  802762:	68 a9 3b 80 00       	push   $0x803ba9
  802767:	68 c4 00 00 00       	push   $0xc4
  80276c:	68 37 3b 80 00       	push   $0x803b37
  802771:	e8 f4 08 00 00       	call   80306a <_panic>
  802776:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	85 c0                	test   %eax,%eax
  80277d:	74 10                	je     80278f <alloc_block_NF+0x9d>
  80277f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802782:	8b 00                	mov    (%eax),%eax
  802784:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802787:	8b 52 04             	mov    0x4(%edx),%edx
  80278a:	89 50 04             	mov    %edx,0x4(%eax)
  80278d:	eb 0b                	jmp    80279a <alloc_block_NF+0xa8>
  80278f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802792:	8b 40 04             	mov    0x4(%eax),%eax
  802795:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80279a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279d:	8b 40 04             	mov    0x4(%eax),%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	74 0f                	je     8027b3 <alloc_block_NF+0xc1>
  8027a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a7:	8b 40 04             	mov    0x4(%eax),%eax
  8027aa:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ad:	8b 12                	mov    (%edx),%edx
  8027af:	89 10                	mov    %edx,(%eax)
  8027b1:	eb 0a                	jmp    8027bd <alloc_block_NF+0xcb>
  8027b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b6:	8b 00                	mov    (%eax),%eax
  8027b8:	a3 48 41 80 00       	mov    %eax,0x804148
  8027bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d0:	a1 54 41 80 00       	mov    0x804154,%eax
  8027d5:	48                   	dec    %eax
  8027d6:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	e9 ad 00 00 00       	jmp    802890 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ec:	0f 85 87 00 00 00    	jne    802879 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8027f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f6:	75 17                	jne    80280f <alloc_block_NF+0x11d>
  8027f8:	83 ec 04             	sub    $0x4,%esp
  8027fb:	68 a9 3b 80 00       	push   $0x803ba9
  802800:	68 c8 00 00 00       	push   $0xc8
  802805:	68 37 3b 80 00       	push   $0x803b37
  80280a:	e8 5b 08 00 00       	call   80306a <_panic>
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	74 10                	je     802828 <alloc_block_NF+0x136>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802820:	8b 52 04             	mov    0x4(%edx),%edx
  802823:	89 50 04             	mov    %edx,0x4(%eax)
  802826:	eb 0b                	jmp    802833 <alloc_block_NF+0x141>
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 40 04             	mov    0x4(%eax),%eax
  80282e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	85 c0                	test   %eax,%eax
  80283b:	74 0f                	je     80284c <alloc_block_NF+0x15a>
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 40 04             	mov    0x4(%eax),%eax
  802843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802846:	8b 12                	mov    (%edx),%edx
  802848:	89 10                	mov    %edx,(%eax)
  80284a:	eb 0a                	jmp    802856 <alloc_block_NF+0x164>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	a3 38 41 80 00       	mov    %eax,0x804138
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802869:	a1 44 41 80 00       	mov    0x804144,%eax
  80286e:	48                   	dec    %eax
  80286f:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	eb 17                	jmp    802890 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 00                	mov    (%eax),%eax
  80287e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802881:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802885:	0f 85 7a fe ff ff    	jne    802705 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80288b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802890:	c9                   	leave  
  802891:	c3                   	ret    

00802892 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802898:	a1 38 41 80 00       	mov    0x804138,%eax
  80289d:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8028a0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8028a8:	a1 44 41 80 00       	mov    0x804144,%eax
  8028ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8028b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028b4:	75 68                	jne    80291e <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8028b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028ba:	75 17                	jne    8028d3 <insert_sorted_with_merge_freeList+0x41>
  8028bc:	83 ec 04             	sub    $0x4,%esp
  8028bf:	68 14 3b 80 00       	push   $0x803b14
  8028c4:	68 da 00 00 00       	push   $0xda
  8028c9:	68 37 3b 80 00       	push   $0x803b37
  8028ce:	e8 97 07 00 00       	call   80306a <_panic>
  8028d3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dc:	89 10                	mov    %edx,(%eax)
  8028de:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e1:	8b 00                	mov    (%eax),%eax
  8028e3:	85 c0                	test   %eax,%eax
  8028e5:	74 0d                	je     8028f4 <insert_sorted_with_merge_freeList+0x62>
  8028e7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ef:	89 50 04             	mov    %edx,0x4(%eax)
  8028f2:	eb 08                	jmp    8028fc <insert_sorted_with_merge_freeList+0x6a>
  8028f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	a3 38 41 80 00       	mov    %eax,0x804138
  802904:	8b 45 08             	mov    0x8(%ebp),%eax
  802907:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80290e:	a1 44 41 80 00       	mov    0x804144,%eax
  802913:	40                   	inc    %eax
  802914:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802919:	e9 49 07 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	8b 50 08             	mov    0x8(%eax),%edx
  802924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802927:	8b 40 0c             	mov    0xc(%eax),%eax
  80292a:	01 c2                	add    %eax,%edx
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
  80292f:	8b 40 08             	mov    0x8(%eax),%eax
  802932:	39 c2                	cmp    %eax,%edx
  802934:	73 77                	jae    8029ad <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	75 6e                	jne    8029ad <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  80293f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802943:	74 68                	je     8029ad <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802945:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802949:	75 17                	jne    802962 <insert_sorted_with_merge_freeList+0xd0>
  80294b:	83 ec 04             	sub    $0x4,%esp
  80294e:	68 50 3b 80 00       	push   $0x803b50
  802953:	68 e0 00 00 00       	push   $0xe0
  802958:	68 37 3b 80 00       	push   $0x803b37
  80295d:	e8 08 07 00 00       	call   80306a <_panic>
  802962:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	89 50 04             	mov    %edx,0x4(%eax)
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	8b 40 04             	mov    0x4(%eax),%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	74 0c                	je     802984 <insert_sorted_with_merge_freeList+0xf2>
  802978:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80297d:	8b 55 08             	mov    0x8(%ebp),%edx
  802980:	89 10                	mov    %edx,(%eax)
  802982:	eb 08                	jmp    80298c <insert_sorted_with_merge_freeList+0xfa>
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	a3 38 41 80 00       	mov    %eax,0x804138
  80298c:	8b 45 08             	mov    0x8(%ebp),%eax
  80298f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299d:	a1 44 41 80 00       	mov    0x804144,%eax
  8029a2:	40                   	inc    %eax
  8029a3:	a3 44 41 80 00       	mov    %eax,0x804144
  8029a8:	e9 ba 06 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	8b 50 0c             	mov    0xc(%eax),%edx
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	8b 40 08             	mov    0x8(%eax),%eax
  8029b9:	01 c2                	add    %eax,%edx
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 40 08             	mov    0x8(%eax),%eax
  8029c1:	39 c2                	cmp    %eax,%edx
  8029c3:	73 78                	jae    802a3d <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 40 04             	mov    0x4(%eax),%eax
  8029cb:	85 c0                	test   %eax,%eax
  8029cd:	75 6e                	jne    802a3d <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8029cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029d3:	74 68                	je     802a3d <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d9:	75 17                	jne    8029f2 <insert_sorted_with_merge_freeList+0x160>
  8029db:	83 ec 04             	sub    $0x4,%esp
  8029de:	68 14 3b 80 00       	push   $0x803b14
  8029e3:	68 e6 00 00 00       	push   $0xe6
  8029e8:	68 37 3b 80 00       	push   $0x803b37
  8029ed:	e8 78 06 00 00       	call   80306a <_panic>
  8029f2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	89 10                	mov    %edx,(%eax)
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	8b 00                	mov    (%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	74 0d                	je     802a13 <insert_sorted_with_merge_freeList+0x181>
  802a06:	a1 38 41 80 00       	mov    0x804138,%eax
  802a0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0e:	89 50 04             	mov    %edx,0x4(%eax)
  802a11:	eb 08                	jmp    802a1b <insert_sorted_with_merge_freeList+0x189>
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2d:	a1 44 41 80 00       	mov    0x804144,%eax
  802a32:	40                   	inc    %eax
  802a33:	a3 44 41 80 00       	mov    %eax,0x804144
  802a38:	e9 2a 06 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802a3d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a45:	e9 ed 05 00 00       	jmp    803037 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4d:	8b 00                	mov    (%eax),%eax
  802a4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a52:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a56:	0f 84 a7 00 00 00    	je     802b03 <insert_sorted_with_merge_freeList+0x271>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 50 0c             	mov    0xc(%eax),%edx
  802a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a65:	8b 40 08             	mov    0x8(%eax),%eax
  802a68:	01 c2                	add    %eax,%edx
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	8b 40 08             	mov    0x8(%eax),%eax
  802a70:	39 c2                	cmp    %eax,%edx
  802a72:	0f 83 8b 00 00 00    	jae    802b03 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	8b 50 0c             	mov    0xc(%eax),%edx
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	8b 40 08             	mov    0x8(%eax),%eax
  802a84:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802a86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a89:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802a8c:	39 c2                	cmp    %eax,%edx
  802a8e:	73 73                	jae    802b03 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802a90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a94:	74 06                	je     802a9c <insert_sorted_with_merge_freeList+0x20a>
  802a96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9a:	75 17                	jne    802ab3 <insert_sorted_with_merge_freeList+0x221>
  802a9c:	83 ec 04             	sub    $0x4,%esp
  802a9f:	68 c8 3b 80 00       	push   $0x803bc8
  802aa4:	68 f0 00 00 00       	push   $0xf0
  802aa9:	68 37 3b 80 00       	push   $0x803b37
  802aae:	e8 b7 05 00 00       	call   80306a <_panic>
  802ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab6:	8b 10                	mov    (%eax),%edx
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	8b 00                	mov    (%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	74 0b                	je     802ad1 <insert_sorted_with_merge_freeList+0x23f>
  802ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac9:	8b 00                	mov    (%eax),%eax
  802acb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ace:	89 50 04             	mov    %edx,0x4(%eax)
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad7:	89 10                	mov    %edx,(%eax)
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802adf:	89 50 04             	mov    %edx,0x4(%eax)
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	75 08                	jne    802af3 <insert_sorted_with_merge_freeList+0x261>
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802af3:	a1 44 41 80 00       	mov    0x804144,%eax
  802af8:	40                   	inc    %eax
  802af9:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802afe:	e9 64 05 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802b03:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b08:	8b 50 0c             	mov    0xc(%eax),%edx
  802b0b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b10:	8b 40 08             	mov    0x8(%eax),%eax
  802b13:	01 c2                	add    %eax,%edx
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	8b 40 08             	mov    0x8(%eax),%eax
  802b1b:	39 c2                	cmp    %eax,%edx
  802b1d:	0f 85 b1 00 00 00    	jne    802bd4 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802b23:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	0f 84 a4 00 00 00    	je     802bd4 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802b30:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b35:	8b 00                	mov    (%eax),%eax
  802b37:	85 c0                	test   %eax,%eax
  802b39:	0f 85 95 00 00 00    	jne    802bd4 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802b3f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b44:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b4a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b50:	8b 52 0c             	mov    0xc(%edx),%edx
  802b53:	01 ca                	add    %ecx,%edx
  802b55:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b62:	8b 45 08             	mov    0x8(%ebp),%eax
  802b65:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b70:	75 17                	jne    802b89 <insert_sorted_with_merge_freeList+0x2f7>
  802b72:	83 ec 04             	sub    $0x4,%esp
  802b75:	68 14 3b 80 00       	push   $0x803b14
  802b7a:	68 ff 00 00 00       	push   $0xff
  802b7f:	68 37 3b 80 00       	push   $0x803b37
  802b84:	e8 e1 04 00 00       	call   80306a <_panic>
  802b89:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	89 10                	mov    %edx,(%eax)
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 00                	mov    (%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 0d                	je     802baa <insert_sorted_with_merge_freeList+0x318>
  802b9d:	a1 48 41 80 00       	mov    0x804148,%eax
  802ba2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba5:	89 50 04             	mov    %edx,0x4(%eax)
  802ba8:	eb 08                	jmp    802bb2 <insert_sorted_with_merge_freeList+0x320>
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	a3 48 41 80 00       	mov    %eax,0x804148
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc4:	a1 54 41 80 00       	mov    0x804154,%eax
  802bc9:	40                   	inc    %eax
  802bca:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802bcf:	e9 93 04 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 50 08             	mov    0x8(%eax),%edx
  802bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802be0:	01 c2                	add    %eax,%edx
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	8b 40 08             	mov    0x8(%eax),%eax
  802be8:	39 c2                	cmp    %eax,%edx
  802bea:	0f 85 ae 00 00 00    	jne    802c9e <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	8b 50 0c             	mov    0xc(%eax),%edx
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	8b 40 08             	mov    0x8(%eax),%eax
  802bfc:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802c06:	39 c2                	cmp    %eax,%edx
  802c08:	0f 84 90 00 00 00    	je     802c9e <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 50 0c             	mov    0xc(%eax),%edx
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1a:	01 c2                	add    %eax,%edx
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c36:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3a:	75 17                	jne    802c53 <insert_sorted_with_merge_freeList+0x3c1>
  802c3c:	83 ec 04             	sub    $0x4,%esp
  802c3f:	68 14 3b 80 00       	push   $0x803b14
  802c44:	68 0b 01 00 00       	push   $0x10b
  802c49:	68 37 3b 80 00       	push   $0x803b37
  802c4e:	e8 17 04 00 00       	call   80306a <_panic>
  802c53:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	89 10                	mov    %edx,(%eax)
  802c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c61:	8b 00                	mov    (%eax),%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	74 0d                	je     802c74 <insert_sorted_with_merge_freeList+0x3e2>
  802c67:	a1 48 41 80 00       	mov    0x804148,%eax
  802c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6f:	89 50 04             	mov    %edx,0x4(%eax)
  802c72:	eb 08                	jmp    802c7c <insert_sorted_with_merge_freeList+0x3ea>
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	a3 48 41 80 00       	mov    %eax,0x804148
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8e:	a1 54 41 80 00       	mov    0x804154,%eax
  802c93:	40                   	inc    %eax
  802c94:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802c99:	e9 c9 03 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 40 08             	mov    0x8(%eax),%eax
  802caa:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802cb2:	39 c2                	cmp    %eax,%edx
  802cb4:	0f 85 bb 00 00 00    	jne    802d75 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802cba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cbe:	0f 84 b1 00 00 00    	je     802d75 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc7:	8b 40 04             	mov    0x4(%eax),%eax
  802cca:	85 c0                	test   %eax,%eax
  802ccc:	0f 85 a3 00 00 00    	jne    802d75 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802cd2:	a1 38 41 80 00       	mov    0x804138,%eax
  802cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cda:	8b 52 08             	mov    0x8(%edx),%edx
  802cdd:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802ce0:	a1 38 41 80 00       	mov    0x804138,%eax
  802ce5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ceb:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cee:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf1:	8b 52 0c             	mov    0xc(%edx),%edx
  802cf4:	01 ca                	add    %ecx,%edx
  802cf6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d11:	75 17                	jne    802d2a <insert_sorted_with_merge_freeList+0x498>
  802d13:	83 ec 04             	sub    $0x4,%esp
  802d16:	68 14 3b 80 00       	push   $0x803b14
  802d1b:	68 17 01 00 00       	push   $0x117
  802d20:	68 37 3b 80 00       	push   $0x803b37
  802d25:	e8 40 03 00 00       	call   80306a <_panic>
  802d2a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	89 10                	mov    %edx,(%eax)
  802d35:	8b 45 08             	mov    0x8(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	85 c0                	test   %eax,%eax
  802d3c:	74 0d                	je     802d4b <insert_sorted_with_merge_freeList+0x4b9>
  802d3e:	a1 48 41 80 00       	mov    0x804148,%eax
  802d43:	8b 55 08             	mov    0x8(%ebp),%edx
  802d46:	89 50 04             	mov    %edx,0x4(%eax)
  802d49:	eb 08                	jmp    802d53 <insert_sorted_with_merge_freeList+0x4c1>
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	a3 48 41 80 00       	mov    %eax,0x804148
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d65:	a1 54 41 80 00       	mov    0x804154,%eax
  802d6a:	40                   	inc    %eax
  802d6b:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d70:	e9 f2 02 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 50 08             	mov    0x8(%eax),%edx
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d81:	01 c2                	add    %eax,%edx
  802d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d86:	8b 40 08             	mov    0x8(%eax),%eax
  802d89:	39 c2                	cmp    %eax,%edx
  802d8b:	0f 85 be 00 00 00    	jne    802e4f <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d94:	8b 40 04             	mov    0x4(%eax),%eax
  802d97:	8b 50 08             	mov    0x8(%eax),%edx
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 40 04             	mov    0x4(%eax),%eax
  802da0:	8b 40 0c             	mov    0xc(%eax),%eax
  802da3:	01 c2                	add    %eax,%edx
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	8b 40 08             	mov    0x8(%eax),%eax
  802dab:	39 c2                	cmp    %eax,%edx
  802dad:	0f 84 9c 00 00 00    	je     802e4f <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	8b 50 08             	mov    0x8(%eax),%edx
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc2:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcb:	01 c2                	add    %eax,%edx
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802de7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802deb:	75 17                	jne    802e04 <insert_sorted_with_merge_freeList+0x572>
  802ded:	83 ec 04             	sub    $0x4,%esp
  802df0:	68 14 3b 80 00       	push   $0x803b14
  802df5:	68 26 01 00 00       	push   $0x126
  802dfa:	68 37 3b 80 00       	push   $0x803b37
  802dff:	e8 66 02 00 00       	call   80306a <_panic>
  802e04:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	89 10                	mov    %edx,(%eax)
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	8b 00                	mov    (%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	74 0d                	je     802e25 <insert_sorted_with_merge_freeList+0x593>
  802e18:	a1 48 41 80 00       	mov    0x804148,%eax
  802e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e20:	89 50 04             	mov    %edx,0x4(%eax)
  802e23:	eb 08                	jmp    802e2d <insert_sorted_with_merge_freeList+0x59b>
  802e25:	8b 45 08             	mov    0x8(%ebp),%eax
  802e28:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	a3 48 41 80 00       	mov    %eax,0x804148
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3f:	a1 54 41 80 00       	mov    0x804154,%eax
  802e44:	40                   	inc    %eax
  802e45:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e4a:	e9 18 02 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 50 0c             	mov    0xc(%eax),%edx
  802e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e58:	8b 40 08             	mov    0x8(%eax),%eax
  802e5b:	01 c2                	add    %eax,%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	8b 40 08             	mov    0x8(%eax),%eax
  802e63:	39 c2                	cmp    %eax,%edx
  802e65:	0f 85 c4 01 00 00    	jne    80302f <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 40 08             	mov    0x8(%eax),%eax
  802e77:	01 c2                	add    %eax,%edx
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	8b 40 08             	mov    0x8(%eax),%eax
  802e81:	39 c2                	cmp    %eax,%edx
  802e83:	0f 85 a6 01 00 00    	jne    80302f <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802e89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e8d:	0f 84 9c 01 00 00    	je     80302f <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 50 0c             	mov    0xc(%eax),%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9f:	01 c2                	add    %eax,%edx
  802ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea4:	8b 00                	mov    (%eax),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	01 c2                	add    %eax,%edx
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802ec5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec9:	75 17                	jne    802ee2 <insert_sorted_with_merge_freeList+0x650>
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	68 14 3b 80 00       	push   $0x803b14
  802ed3:	68 32 01 00 00       	push   $0x132
  802ed8:	68 37 3b 80 00       	push   $0x803b37
  802edd:	e8 88 01 00 00       	call   80306a <_panic>
  802ee2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	89 10                	mov    %edx,(%eax)
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 0d                	je     802f03 <insert_sorted_with_merge_freeList+0x671>
  802ef6:	a1 48 41 80 00       	mov    0x804148,%eax
  802efb:	8b 55 08             	mov    0x8(%ebp),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%eax)
  802f01:	eb 08                	jmp    802f0b <insert_sorted_with_merge_freeList+0x679>
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	a3 48 41 80 00       	mov    %eax,0x804148
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1d:	a1 54 41 80 00       	mov    0x804154,%eax
  802f22:	40                   	inc    %eax
  802f23:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	8b 00                	mov    (%eax),%eax
  802f2d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f37:	8b 00                	mov    (%eax),%eax
  802f39:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 00                	mov    (%eax),%eax
  802f45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f48:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f4c:	75 17                	jne    802f65 <insert_sorted_with_merge_freeList+0x6d3>
  802f4e:	83 ec 04             	sub    $0x4,%esp
  802f51:	68 a9 3b 80 00       	push   $0x803ba9
  802f56:	68 36 01 00 00       	push   $0x136
  802f5b:	68 37 3b 80 00       	push   $0x803b37
  802f60:	e8 05 01 00 00       	call   80306a <_panic>
  802f65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f68:	8b 00                	mov    (%eax),%eax
  802f6a:	85 c0                	test   %eax,%eax
  802f6c:	74 10                	je     802f7e <insert_sorted_with_merge_freeList+0x6ec>
  802f6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f71:	8b 00                	mov    (%eax),%eax
  802f73:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f76:	8b 52 04             	mov    0x4(%edx),%edx
  802f79:	89 50 04             	mov    %edx,0x4(%eax)
  802f7c:	eb 0b                	jmp    802f89 <insert_sorted_with_merge_freeList+0x6f7>
  802f7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f81:	8b 40 04             	mov    0x4(%eax),%eax
  802f84:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	85 c0                	test   %eax,%eax
  802f91:	74 0f                	je     802fa2 <insert_sorted_with_merge_freeList+0x710>
  802f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f96:	8b 40 04             	mov    0x4(%eax),%eax
  802f99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f9c:	8b 12                	mov    (%edx),%edx
  802f9e:	89 10                	mov    %edx,(%eax)
  802fa0:	eb 0a                	jmp    802fac <insert_sorted_with_merge_freeList+0x71a>
  802fa2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa5:	8b 00                	mov    (%eax),%eax
  802fa7:	a3 38 41 80 00       	mov    %eax,0x804138
  802fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802faf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbf:	a1 44 41 80 00       	mov    0x804144,%eax
  802fc4:	48                   	dec    %eax
  802fc5:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802fca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fce:	75 17                	jne    802fe7 <insert_sorted_with_merge_freeList+0x755>
  802fd0:	83 ec 04             	sub    $0x4,%esp
  802fd3:	68 14 3b 80 00       	push   $0x803b14
  802fd8:	68 37 01 00 00       	push   $0x137
  802fdd:	68 37 3b 80 00       	push   $0x803b37
  802fe2:	e8 83 00 00 00       	call   80306a <_panic>
  802fe7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff0:	89 10                	mov    %edx,(%eax)
  802ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff5:	8b 00                	mov    (%eax),%eax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	74 0d                	je     803008 <insert_sorted_with_merge_freeList+0x776>
  802ffb:	a1 48 41 80 00       	mov    0x804148,%eax
  803000:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803003:	89 50 04             	mov    %edx,0x4(%eax)
  803006:	eb 08                	jmp    803010 <insert_sorted_with_merge_freeList+0x77e>
  803008:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803010:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803013:	a3 48 41 80 00       	mov    %eax,0x804148
  803018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803022:	a1 54 41 80 00       	mov    0x804154,%eax
  803027:	40                   	inc    %eax
  803028:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  80302d:	eb 38                	jmp    803067 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80302f:	a1 40 41 80 00       	mov    0x804140,%eax
  803034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803037:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303b:	74 07                	je     803044 <insert_sorted_with_merge_freeList+0x7b2>
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	eb 05                	jmp    803049 <insert_sorted_with_merge_freeList+0x7b7>
  803044:	b8 00 00 00 00       	mov    $0x0,%eax
  803049:	a3 40 41 80 00       	mov    %eax,0x804140
  80304e:	a1 40 41 80 00       	mov    0x804140,%eax
  803053:	85 c0                	test   %eax,%eax
  803055:	0f 85 ef f9 ff ff    	jne    802a4a <insert_sorted_with_merge_freeList+0x1b8>
  80305b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305f:	0f 85 e5 f9 ff ff    	jne    802a4a <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803065:	eb 00                	jmp    803067 <insert_sorted_with_merge_freeList+0x7d5>
  803067:	90                   	nop
  803068:	c9                   	leave  
  803069:	c3                   	ret    

0080306a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80306a:	55                   	push   %ebp
  80306b:	89 e5                	mov    %esp,%ebp
  80306d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803070:	8d 45 10             	lea    0x10(%ebp),%eax
  803073:	83 c0 04             	add    $0x4,%eax
  803076:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803079:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80307e:	85 c0                	test   %eax,%eax
  803080:	74 16                	je     803098 <_panic+0x2e>
		cprintf("%s: ", argv0);
  803082:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803087:	83 ec 08             	sub    $0x8,%esp
  80308a:	50                   	push   %eax
  80308b:	68 fc 3b 80 00       	push   $0x803bfc
  803090:	e8 d1 d4 ff ff       	call   800566 <cprintf>
  803095:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803098:	a1 00 40 80 00       	mov    0x804000,%eax
  80309d:	ff 75 0c             	pushl  0xc(%ebp)
  8030a0:	ff 75 08             	pushl  0x8(%ebp)
  8030a3:	50                   	push   %eax
  8030a4:	68 01 3c 80 00       	push   $0x803c01
  8030a9:	e8 b8 d4 ff ff       	call   800566 <cprintf>
  8030ae:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8030b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8030b4:	83 ec 08             	sub    $0x8,%esp
  8030b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8030ba:	50                   	push   %eax
  8030bb:	e8 3b d4 ff ff       	call   8004fb <vcprintf>
  8030c0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8030c3:	83 ec 08             	sub    $0x8,%esp
  8030c6:	6a 00                	push   $0x0
  8030c8:	68 1d 3c 80 00       	push   $0x803c1d
  8030cd:	e8 29 d4 ff ff       	call   8004fb <vcprintf>
  8030d2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8030d5:	e8 aa d3 ff ff       	call   800484 <exit>

	// should not return here
	while (1) ;
  8030da:	eb fe                	jmp    8030da <_panic+0x70>

008030dc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8030dc:	55                   	push   %ebp
  8030dd:	89 e5                	mov    %esp,%ebp
  8030df:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8030e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8030e7:	8b 50 74             	mov    0x74(%eax),%edx
  8030ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ed:	39 c2                	cmp    %eax,%edx
  8030ef:	74 14                	je     803105 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8030f1:	83 ec 04             	sub    $0x4,%esp
  8030f4:	68 20 3c 80 00       	push   $0x803c20
  8030f9:	6a 26                	push   $0x26
  8030fb:	68 6c 3c 80 00       	push   $0x803c6c
  803100:	e8 65 ff ff ff       	call   80306a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803105:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80310c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803113:	e9 c2 00 00 00       	jmp    8031da <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803118:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	01 d0                	add    %edx,%eax
  803127:	8b 00                	mov    (%eax),%eax
  803129:	85 c0                	test   %eax,%eax
  80312b:	75 08                	jne    803135 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80312d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803130:	e9 a2 00 00 00       	jmp    8031d7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803135:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80313c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803143:	eb 69                	jmp    8031ae <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803145:	a1 20 40 80 00       	mov    0x804020,%eax
  80314a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803150:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803153:	89 d0                	mov    %edx,%eax
  803155:	01 c0                	add    %eax,%eax
  803157:	01 d0                	add    %edx,%eax
  803159:	c1 e0 03             	shl    $0x3,%eax
  80315c:	01 c8                	add    %ecx,%eax
  80315e:	8a 40 04             	mov    0x4(%eax),%al
  803161:	84 c0                	test   %al,%al
  803163:	75 46                	jne    8031ab <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803165:	a1 20 40 80 00       	mov    0x804020,%eax
  80316a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803170:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803173:	89 d0                	mov    %edx,%eax
  803175:	01 c0                	add    %eax,%eax
  803177:	01 d0                	add    %edx,%eax
  803179:	c1 e0 03             	shl    $0x3,%eax
  80317c:	01 c8                	add    %ecx,%eax
  80317e:	8b 00                	mov    (%eax),%eax
  803180:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803183:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803186:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80318b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80318d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803190:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	01 c8                	add    %ecx,%eax
  80319c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80319e:	39 c2                	cmp    %eax,%edx
  8031a0:	75 09                	jne    8031ab <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8031a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8031a9:	eb 12                	jmp    8031bd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031ab:	ff 45 e8             	incl   -0x18(%ebp)
  8031ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8031b3:	8b 50 74             	mov    0x74(%eax),%edx
  8031b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8031b9:	39 c2                	cmp    %eax,%edx
  8031bb:	77 88                	ja     803145 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8031bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031c1:	75 14                	jne    8031d7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8031c3:	83 ec 04             	sub    $0x4,%esp
  8031c6:	68 78 3c 80 00       	push   $0x803c78
  8031cb:	6a 3a                	push   $0x3a
  8031cd:	68 6c 3c 80 00       	push   $0x803c6c
  8031d2:	e8 93 fe ff ff       	call   80306a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8031d7:	ff 45 f0             	incl   -0x10(%ebp)
  8031da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8031e0:	0f 8c 32 ff ff ff    	jl     803118 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8031e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8031f4:	eb 26                	jmp    80321c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8031f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8031fb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803201:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803204:	89 d0                	mov    %edx,%eax
  803206:	01 c0                	add    %eax,%eax
  803208:	01 d0                	add    %edx,%eax
  80320a:	c1 e0 03             	shl    $0x3,%eax
  80320d:	01 c8                	add    %ecx,%eax
  80320f:	8a 40 04             	mov    0x4(%eax),%al
  803212:	3c 01                	cmp    $0x1,%al
  803214:	75 03                	jne    803219 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803216:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803219:	ff 45 e0             	incl   -0x20(%ebp)
  80321c:	a1 20 40 80 00       	mov    0x804020,%eax
  803221:	8b 50 74             	mov    0x74(%eax),%edx
  803224:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803227:	39 c2                	cmp    %eax,%edx
  803229:	77 cb                	ja     8031f6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803231:	74 14                	je     803247 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803233:	83 ec 04             	sub    $0x4,%esp
  803236:	68 cc 3c 80 00       	push   $0x803ccc
  80323b:	6a 44                	push   $0x44
  80323d:	68 6c 3c 80 00       	push   $0x803c6c
  803242:	e8 23 fe ff ff       	call   80306a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803247:	90                   	nop
  803248:	c9                   	leave  
  803249:	c3                   	ret    
  80324a:	66 90                	xchg   %ax,%ax

0080324c <__udivdi3>:
  80324c:	55                   	push   %ebp
  80324d:	57                   	push   %edi
  80324e:	56                   	push   %esi
  80324f:	53                   	push   %ebx
  803250:	83 ec 1c             	sub    $0x1c,%esp
  803253:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803257:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80325b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80325f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803263:	89 ca                	mov    %ecx,%edx
  803265:	89 f8                	mov    %edi,%eax
  803267:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80326b:	85 f6                	test   %esi,%esi
  80326d:	75 2d                	jne    80329c <__udivdi3+0x50>
  80326f:	39 cf                	cmp    %ecx,%edi
  803271:	77 65                	ja     8032d8 <__udivdi3+0x8c>
  803273:	89 fd                	mov    %edi,%ebp
  803275:	85 ff                	test   %edi,%edi
  803277:	75 0b                	jne    803284 <__udivdi3+0x38>
  803279:	b8 01 00 00 00       	mov    $0x1,%eax
  80327e:	31 d2                	xor    %edx,%edx
  803280:	f7 f7                	div    %edi
  803282:	89 c5                	mov    %eax,%ebp
  803284:	31 d2                	xor    %edx,%edx
  803286:	89 c8                	mov    %ecx,%eax
  803288:	f7 f5                	div    %ebp
  80328a:	89 c1                	mov    %eax,%ecx
  80328c:	89 d8                	mov    %ebx,%eax
  80328e:	f7 f5                	div    %ebp
  803290:	89 cf                	mov    %ecx,%edi
  803292:	89 fa                	mov    %edi,%edx
  803294:	83 c4 1c             	add    $0x1c,%esp
  803297:	5b                   	pop    %ebx
  803298:	5e                   	pop    %esi
  803299:	5f                   	pop    %edi
  80329a:	5d                   	pop    %ebp
  80329b:	c3                   	ret    
  80329c:	39 ce                	cmp    %ecx,%esi
  80329e:	77 28                	ja     8032c8 <__udivdi3+0x7c>
  8032a0:	0f bd fe             	bsr    %esi,%edi
  8032a3:	83 f7 1f             	xor    $0x1f,%edi
  8032a6:	75 40                	jne    8032e8 <__udivdi3+0x9c>
  8032a8:	39 ce                	cmp    %ecx,%esi
  8032aa:	72 0a                	jb     8032b6 <__udivdi3+0x6a>
  8032ac:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032b0:	0f 87 9e 00 00 00    	ja     803354 <__udivdi3+0x108>
  8032b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032bb:	89 fa                	mov    %edi,%edx
  8032bd:	83 c4 1c             	add    $0x1c,%esp
  8032c0:	5b                   	pop    %ebx
  8032c1:	5e                   	pop    %esi
  8032c2:	5f                   	pop    %edi
  8032c3:	5d                   	pop    %ebp
  8032c4:	c3                   	ret    
  8032c5:	8d 76 00             	lea    0x0(%esi),%esi
  8032c8:	31 ff                	xor    %edi,%edi
  8032ca:	31 c0                	xor    %eax,%eax
  8032cc:	89 fa                	mov    %edi,%edx
  8032ce:	83 c4 1c             	add    $0x1c,%esp
  8032d1:	5b                   	pop    %ebx
  8032d2:	5e                   	pop    %esi
  8032d3:	5f                   	pop    %edi
  8032d4:	5d                   	pop    %ebp
  8032d5:	c3                   	ret    
  8032d6:	66 90                	xchg   %ax,%ax
  8032d8:	89 d8                	mov    %ebx,%eax
  8032da:	f7 f7                	div    %edi
  8032dc:	31 ff                	xor    %edi,%edi
  8032de:	89 fa                	mov    %edi,%edx
  8032e0:	83 c4 1c             	add    $0x1c,%esp
  8032e3:	5b                   	pop    %ebx
  8032e4:	5e                   	pop    %esi
  8032e5:	5f                   	pop    %edi
  8032e6:	5d                   	pop    %ebp
  8032e7:	c3                   	ret    
  8032e8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8032ed:	89 eb                	mov    %ebp,%ebx
  8032ef:	29 fb                	sub    %edi,%ebx
  8032f1:	89 f9                	mov    %edi,%ecx
  8032f3:	d3 e6                	shl    %cl,%esi
  8032f5:	89 c5                	mov    %eax,%ebp
  8032f7:	88 d9                	mov    %bl,%cl
  8032f9:	d3 ed                	shr    %cl,%ebp
  8032fb:	89 e9                	mov    %ebp,%ecx
  8032fd:	09 f1                	or     %esi,%ecx
  8032ff:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803303:	89 f9                	mov    %edi,%ecx
  803305:	d3 e0                	shl    %cl,%eax
  803307:	89 c5                	mov    %eax,%ebp
  803309:	89 d6                	mov    %edx,%esi
  80330b:	88 d9                	mov    %bl,%cl
  80330d:	d3 ee                	shr    %cl,%esi
  80330f:	89 f9                	mov    %edi,%ecx
  803311:	d3 e2                	shl    %cl,%edx
  803313:	8b 44 24 08          	mov    0x8(%esp),%eax
  803317:	88 d9                	mov    %bl,%cl
  803319:	d3 e8                	shr    %cl,%eax
  80331b:	09 c2                	or     %eax,%edx
  80331d:	89 d0                	mov    %edx,%eax
  80331f:	89 f2                	mov    %esi,%edx
  803321:	f7 74 24 0c          	divl   0xc(%esp)
  803325:	89 d6                	mov    %edx,%esi
  803327:	89 c3                	mov    %eax,%ebx
  803329:	f7 e5                	mul    %ebp
  80332b:	39 d6                	cmp    %edx,%esi
  80332d:	72 19                	jb     803348 <__udivdi3+0xfc>
  80332f:	74 0b                	je     80333c <__udivdi3+0xf0>
  803331:	89 d8                	mov    %ebx,%eax
  803333:	31 ff                	xor    %edi,%edi
  803335:	e9 58 ff ff ff       	jmp    803292 <__udivdi3+0x46>
  80333a:	66 90                	xchg   %ax,%ax
  80333c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803340:	89 f9                	mov    %edi,%ecx
  803342:	d3 e2                	shl    %cl,%edx
  803344:	39 c2                	cmp    %eax,%edx
  803346:	73 e9                	jae    803331 <__udivdi3+0xe5>
  803348:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80334b:	31 ff                	xor    %edi,%edi
  80334d:	e9 40 ff ff ff       	jmp    803292 <__udivdi3+0x46>
  803352:	66 90                	xchg   %ax,%ax
  803354:	31 c0                	xor    %eax,%eax
  803356:	e9 37 ff ff ff       	jmp    803292 <__udivdi3+0x46>
  80335b:	90                   	nop

0080335c <__umoddi3>:
  80335c:	55                   	push   %ebp
  80335d:	57                   	push   %edi
  80335e:	56                   	push   %esi
  80335f:	53                   	push   %ebx
  803360:	83 ec 1c             	sub    $0x1c,%esp
  803363:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803367:	8b 74 24 34          	mov    0x34(%esp),%esi
  80336b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80336f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803373:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803377:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80337b:	89 f3                	mov    %esi,%ebx
  80337d:	89 fa                	mov    %edi,%edx
  80337f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803383:	89 34 24             	mov    %esi,(%esp)
  803386:	85 c0                	test   %eax,%eax
  803388:	75 1a                	jne    8033a4 <__umoddi3+0x48>
  80338a:	39 f7                	cmp    %esi,%edi
  80338c:	0f 86 a2 00 00 00    	jbe    803434 <__umoddi3+0xd8>
  803392:	89 c8                	mov    %ecx,%eax
  803394:	89 f2                	mov    %esi,%edx
  803396:	f7 f7                	div    %edi
  803398:	89 d0                	mov    %edx,%eax
  80339a:	31 d2                	xor    %edx,%edx
  80339c:	83 c4 1c             	add    $0x1c,%esp
  80339f:	5b                   	pop    %ebx
  8033a0:	5e                   	pop    %esi
  8033a1:	5f                   	pop    %edi
  8033a2:	5d                   	pop    %ebp
  8033a3:	c3                   	ret    
  8033a4:	39 f0                	cmp    %esi,%eax
  8033a6:	0f 87 ac 00 00 00    	ja     803458 <__umoddi3+0xfc>
  8033ac:	0f bd e8             	bsr    %eax,%ebp
  8033af:	83 f5 1f             	xor    $0x1f,%ebp
  8033b2:	0f 84 ac 00 00 00    	je     803464 <__umoddi3+0x108>
  8033b8:	bf 20 00 00 00       	mov    $0x20,%edi
  8033bd:	29 ef                	sub    %ebp,%edi
  8033bf:	89 fe                	mov    %edi,%esi
  8033c1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033c5:	89 e9                	mov    %ebp,%ecx
  8033c7:	d3 e0                	shl    %cl,%eax
  8033c9:	89 d7                	mov    %edx,%edi
  8033cb:	89 f1                	mov    %esi,%ecx
  8033cd:	d3 ef                	shr    %cl,%edi
  8033cf:	09 c7                	or     %eax,%edi
  8033d1:	89 e9                	mov    %ebp,%ecx
  8033d3:	d3 e2                	shl    %cl,%edx
  8033d5:	89 14 24             	mov    %edx,(%esp)
  8033d8:	89 d8                	mov    %ebx,%eax
  8033da:	d3 e0                	shl    %cl,%eax
  8033dc:	89 c2                	mov    %eax,%edx
  8033de:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033e2:	d3 e0                	shl    %cl,%eax
  8033e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033ec:	89 f1                	mov    %esi,%ecx
  8033ee:	d3 e8                	shr    %cl,%eax
  8033f0:	09 d0                	or     %edx,%eax
  8033f2:	d3 eb                	shr    %cl,%ebx
  8033f4:	89 da                	mov    %ebx,%edx
  8033f6:	f7 f7                	div    %edi
  8033f8:	89 d3                	mov    %edx,%ebx
  8033fa:	f7 24 24             	mull   (%esp)
  8033fd:	89 c6                	mov    %eax,%esi
  8033ff:	89 d1                	mov    %edx,%ecx
  803401:	39 d3                	cmp    %edx,%ebx
  803403:	0f 82 87 00 00 00    	jb     803490 <__umoddi3+0x134>
  803409:	0f 84 91 00 00 00    	je     8034a0 <__umoddi3+0x144>
  80340f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803413:	29 f2                	sub    %esi,%edx
  803415:	19 cb                	sbb    %ecx,%ebx
  803417:	89 d8                	mov    %ebx,%eax
  803419:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80341d:	d3 e0                	shl    %cl,%eax
  80341f:	89 e9                	mov    %ebp,%ecx
  803421:	d3 ea                	shr    %cl,%edx
  803423:	09 d0                	or     %edx,%eax
  803425:	89 e9                	mov    %ebp,%ecx
  803427:	d3 eb                	shr    %cl,%ebx
  803429:	89 da                	mov    %ebx,%edx
  80342b:	83 c4 1c             	add    $0x1c,%esp
  80342e:	5b                   	pop    %ebx
  80342f:	5e                   	pop    %esi
  803430:	5f                   	pop    %edi
  803431:	5d                   	pop    %ebp
  803432:	c3                   	ret    
  803433:	90                   	nop
  803434:	89 fd                	mov    %edi,%ebp
  803436:	85 ff                	test   %edi,%edi
  803438:	75 0b                	jne    803445 <__umoddi3+0xe9>
  80343a:	b8 01 00 00 00       	mov    $0x1,%eax
  80343f:	31 d2                	xor    %edx,%edx
  803441:	f7 f7                	div    %edi
  803443:	89 c5                	mov    %eax,%ebp
  803445:	89 f0                	mov    %esi,%eax
  803447:	31 d2                	xor    %edx,%edx
  803449:	f7 f5                	div    %ebp
  80344b:	89 c8                	mov    %ecx,%eax
  80344d:	f7 f5                	div    %ebp
  80344f:	89 d0                	mov    %edx,%eax
  803451:	e9 44 ff ff ff       	jmp    80339a <__umoddi3+0x3e>
  803456:	66 90                	xchg   %ax,%ax
  803458:	89 c8                	mov    %ecx,%eax
  80345a:	89 f2                	mov    %esi,%edx
  80345c:	83 c4 1c             	add    $0x1c,%esp
  80345f:	5b                   	pop    %ebx
  803460:	5e                   	pop    %esi
  803461:	5f                   	pop    %edi
  803462:	5d                   	pop    %ebp
  803463:	c3                   	ret    
  803464:	3b 04 24             	cmp    (%esp),%eax
  803467:	72 06                	jb     80346f <__umoddi3+0x113>
  803469:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80346d:	77 0f                	ja     80347e <__umoddi3+0x122>
  80346f:	89 f2                	mov    %esi,%edx
  803471:	29 f9                	sub    %edi,%ecx
  803473:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803477:	89 14 24             	mov    %edx,(%esp)
  80347a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80347e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803482:	8b 14 24             	mov    (%esp),%edx
  803485:	83 c4 1c             	add    $0x1c,%esp
  803488:	5b                   	pop    %ebx
  803489:	5e                   	pop    %esi
  80348a:	5f                   	pop    %edi
  80348b:	5d                   	pop    %ebp
  80348c:	c3                   	ret    
  80348d:	8d 76 00             	lea    0x0(%esi),%esi
  803490:	2b 04 24             	sub    (%esp),%eax
  803493:	19 fa                	sbb    %edi,%edx
  803495:	89 d1                	mov    %edx,%ecx
  803497:	89 c6                	mov    %eax,%esi
  803499:	e9 71 ff ff ff       	jmp    80340f <__umoddi3+0xb3>
  80349e:	66 90                	xchg   %ax,%ax
  8034a0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034a4:	72 ea                	jb     803490 <__umoddi3+0x134>
  8034a6:	89 d9                	mov    %ebx,%ecx
  8034a8:	e9 62 ff ff ff       	jmp    80340f <__umoddi3+0xb3>
