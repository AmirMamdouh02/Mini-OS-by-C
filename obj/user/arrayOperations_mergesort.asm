
obj/user/arrayOperations_mergesort:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

//int *Left;
//int *Right;

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 76 1d 00 00       	call   801db9 <sys_getparentenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)

	int ret;
	/*[1] GET SHARED VARs*/
	//Get the shared array & its size
	int *numOfElements = NULL;
  800046:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int *sharedArray = NULL;
  80004d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	sharedArray = sget(parentenvID, "arr") ;
  800054:	83 ec 08             	sub    $0x8,%esp
  800057:	68 e0 35 80 00       	push   $0x8035e0
  80005c:	ff 75 f0             	pushl  -0x10(%ebp)
  80005f:	e8 0e 18 00 00       	call   801872 <sget>
  800064:	83 c4 10             	add    $0x10,%esp
  800067:	89 45 e8             	mov    %eax,-0x18(%ebp)
	numOfElements = sget(parentenvID, "arrSize") ;
  80006a:	83 ec 08             	sub    $0x8,%esp
  80006d:	68 e4 35 80 00       	push   $0x8035e4
  800072:	ff 75 f0             	pushl  -0x10(%ebp)
  800075:	e8 f8 17 00 00       	call   801872 <sget>
  80007a:	83 c4 10             	add    $0x10,%esp
  80007d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//PrintElements(sharedArray, *numOfElements);

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800080:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	finishedCount = sget(parentenvID, "finishedCount") ;
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	68 ec 35 80 00       	push   $0x8035ec
  80008f:	ff 75 f0             	pushl  -0x10(%ebp)
  800092:	e8 db 17 00 00       	call   801872 <sget>
  800097:	83 c4 10             	add    $0x10,%esp
  80009a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	/*[2] DO THE JOB*/
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
  80009d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000a0:	8b 00                	mov    (%eax),%eax
  8000a2:	c1 e0 02             	shl    $0x2,%eax
  8000a5:	83 ec 04             	sub    $0x4,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	50                   	push   %eax
  8000ab:	68 fa 35 80 00       	push   $0x8035fa
  8000b0:	e8 e8 16 00 00       	call   80179d <smalloc>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000c2:	eb 25                	jmp    8000e9 <_main+0xb1>
	{
		sortedArray[i] = sharedArray[i];
  8000c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000d1:	01 c2                	add    %eax,%edx
  8000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8000dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e0:	01 c8                	add    %ecx,%eax
  8000e2:	8b 00                	mov    (%eax),%eax
  8000e4:	89 02                	mov    %eax,(%edx)
	//take a copy from the original array
	int *sortedArray;

	sortedArray = smalloc("mergesortedArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000e6:	ff 45 f4             	incl   -0xc(%ebp)
  8000e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ec:	8b 00                	mov    (%eax),%eax
  8000ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f1:	7f d1                	jg     8000c4 <_main+0x8c>
	}
//	//Create two temps array for "left" & "right"
//	Left = smalloc("mergesortLeftArr", sizeof(int) * (*numOfElements), 1) ;
//	Right = smalloc("mergesortRightArr", sizeof(int) * (*numOfElements), 1) ;

	MSort(sortedArray, 1, *numOfElements);
  8000f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f6:	8b 00                	mov    (%eax),%eax
  8000f8:	83 ec 04             	sub    $0x4,%esp
  8000fb:	50                   	push   %eax
  8000fc:	6a 01                	push   $0x1
  8000fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800101:	e8 fc 00 00 00       	call   800202 <MSort>
  800106:	83 c4 10             	add    $0x10,%esp
	cprintf("Merge sort is Finished!!!!\n") ;
  800109:	83 ec 0c             	sub    $0xc,%esp
  80010c:	68 09 36 80 00       	push   $0x803609
  800111:	e8 6d 05 00 00       	call   800683 <cprintf>
  800116:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	(*finishedCount)++ ;
  800119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80011c:	8b 00                	mov    (%eax),%eax
  80011e:	8d 50 01             	lea    0x1(%eax),%edx
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	89 10                	mov    %edx,(%eax)

}
  800126:	90                   	nop
  800127:	c9                   	leave  
  800128:	c3                   	ret    

00800129 <Swap>:

void Swap(int *Elements, int First, int Second)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  80012f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800132:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800139:	8b 45 08             	mov    0x8(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8b 00                	mov    (%eax),%eax
  800140:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800143:	8b 45 0c             	mov    0xc(%ebp),%eax
  800146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80014d:	8b 45 08             	mov    0x8(%ebp),%eax
  800150:	01 c2                	add    %eax,%edx
  800152:	8b 45 10             	mov    0x10(%ebp),%eax
  800155:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80015c:	8b 45 08             	mov    0x8(%ebp),%eax
  80015f:	01 c8                	add    %ecx,%eax
  800161:	8b 00                	mov    (%eax),%eax
  800163:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800165:	8b 45 10             	mov    0x10(%ebp),%eax
  800168:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	01 c2                	add    %eax,%edx
  800174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800177:	89 02                	mov    %eax,(%edx)
}
  800179:	90                   	nop
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <PrintElements>:


void PrintElements(int *Elements, int NumOfElements)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800182:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800189:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800190:	eb 42                	jmp    8001d4 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800195:	99                   	cltd   
  800196:	f7 7d f0             	idivl  -0x10(%ebp)
  800199:	89 d0                	mov    %edx,%eax
  80019b:	85 c0                	test   %eax,%eax
  80019d:	75 10                	jne    8001af <PrintElements+0x33>
			cprintf("\n");
  80019f:	83 ec 0c             	sub    $0xc,%esp
  8001a2:	68 25 36 80 00       	push   $0x803625
  8001a7:	e8 d7 04 00 00       	call   800683 <cprintf>
  8001ac:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8001af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	01 d0                	add    %edx,%eax
  8001be:	8b 00                	mov    (%eax),%eax
  8001c0:	83 ec 08             	sub    $0x8,%esp
  8001c3:	50                   	push   %eax
  8001c4:	68 27 36 80 00       	push   $0x803627
  8001c9:	e8 b5 04 00 00       	call   800683 <cprintf>
  8001ce:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8001d1:	ff 45 f4             	incl   -0xc(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	48                   	dec    %eax
  8001d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8001db:	7f b5                	jg     800192 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8001dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001e0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ea:	01 d0                	add    %edx,%eax
  8001ec:	8b 00                	mov    (%eax),%eax
  8001ee:	83 ec 08             	sub    $0x8,%esp
  8001f1:	50                   	push   %eax
  8001f2:	68 2c 36 80 00       	push   $0x80362c
  8001f7:	e8 87 04 00 00       	call   800683 <cprintf>
  8001fc:	83 c4 10             	add    $0x10,%esp

}
  8001ff:	90                   	nop
  800200:	c9                   	leave  
  800201:	c3                   	ret    

00800202 <MSort>:


void MSort(int* A, int p, int r)
{
  800202:	55                   	push   %ebp
  800203:	89 e5                	mov    %esp,%ebp
  800205:	83 ec 18             	sub    $0x18,%esp
	if (p >= r)
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80020e:	7d 54                	jge    800264 <MSort+0x62>
	{
		return;
	}

	int q = (p + r) / 2;
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	8b 45 10             	mov    0x10(%ebp),%eax
  800216:	01 d0                	add    %edx,%eax
  800218:	89 c2                	mov    %eax,%edx
  80021a:	c1 ea 1f             	shr    $0x1f,%edx
  80021d:	01 d0                	add    %edx,%eax
  80021f:	d1 f8                	sar    %eax
  800221:	89 45 f4             	mov    %eax,-0xc(%ebp)

	MSort(A, p, q);
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	ff 75 f4             	pushl  -0xc(%ebp)
  80022a:	ff 75 0c             	pushl  0xc(%ebp)
  80022d:	ff 75 08             	pushl  0x8(%ebp)
  800230:	e8 cd ff ff ff       	call   800202 <MSort>
  800235:	83 c4 10             	add    $0x10,%esp
//	cprintf("LEFT is sorted: from %d to %d\n", p, q);

	MSort(A, q + 1, r);
  800238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023b:	40                   	inc    %eax
  80023c:	83 ec 04             	sub    $0x4,%esp
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	50                   	push   %eax
  800243:	ff 75 08             	pushl  0x8(%ebp)
  800246:	e8 b7 ff ff ff       	call   800202 <MSort>
  80024b:	83 c4 10             	add    $0x10,%esp
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
  80024e:	ff 75 10             	pushl  0x10(%ebp)
  800251:	ff 75 f4             	pushl  -0xc(%ebp)
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	e8 08 00 00 00       	call   800267 <Merge>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	eb 01                	jmp    800265 <MSort+0x63>

void MSort(int* A, int p, int r)
{
	if (p >= r)
	{
		return;
  800264:	90                   	nop
//	cprintf("RIGHT is sorted: from %d to %d\n", q+1, r);

	Merge(A, p, q, r);
	//cprintf("[%d %d] + [%d %d] = [%d %d]\n", p, q, q+1, r, p, r);

}
  800265:	c9                   	leave  
  800266:	c3                   	ret    

00800267 <Merge>:

void Merge(int* A, int p, int q, int r)
{
  800267:	55                   	push   %ebp
  800268:	89 e5                	mov    %esp,%ebp
  80026a:	83 ec 38             	sub    $0x38,%esp
	int leftCapacity = q - p + 1;
  80026d:	8b 45 10             	mov    0x10(%ebp),%eax
  800270:	2b 45 0c             	sub    0xc(%ebp),%eax
  800273:	40                   	inc    %eax
  800274:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int rightCapacity = r - q;
  800277:	8b 45 14             	mov    0x14(%ebp),%eax
  80027a:	2b 45 10             	sub    0x10(%ebp),%eax
  80027d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int leftIndex = 0;
  800280:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int rightIndex = 0;
  800287:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int* Left = malloc(sizeof(int) * leftCapacity);
  80028e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800291:	c1 e0 02             	shl    $0x2,%eax
  800294:	83 ec 0c             	sub    $0xc,%esp
  800297:	50                   	push   %eax
  800298:	e8 85 13 00 00       	call   801622 <malloc>
  80029d:	83 c4 10             	add    $0x10,%esp
  8002a0:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* Right = malloc(sizeof(int) * rightCapacity);
  8002a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002a6:	c1 e0 02             	shl    $0x2,%eax
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	e8 70 13 00 00       	call   801622 <malloc>
  8002b2:	83 c4 10             	add    $0x10,%esp
  8002b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8002bf:	eb 2f                	jmp    8002f0 <Merge+0x89>
	{
		Left[i] = A[p + i - 1];
  8002c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002ce:	01 c2                	add    %eax,%edx
  8002d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8002dd:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e7:	01 c8                	add    %ecx,%eax
  8002e9:	8b 00                	mov    (%eax),%eax
  8002eb:	89 02                	mov    %eax,(%edx)
	int* Left = malloc(sizeof(int) * leftCapacity);

	int* Right = malloc(sizeof(int) * rightCapacity);

	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
  8002ed:	ff 45 ec             	incl   -0x14(%ebp)
  8002f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002f3:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002f6:	7c c9                	jl     8002c1 <Merge+0x5a>
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  8002f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8002ff:	eb 2a                	jmp    80032b <Merge+0xc4>
	{
		Right[j] = A[q + j];
  800301:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800304:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80030b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80030e:	01 c2                	add    %eax,%edx
  800310:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800313:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800316:	01 c8                	add    %ecx,%eax
  800318:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80031f:	8b 45 08             	mov    0x8(%ebp),%eax
  800322:	01 c8                	add    %ecx,%eax
  800324:	8b 00                	mov    (%eax),%eax
  800326:	89 02                	mov    %eax,(%edx)
	int i, j, k;
	for (i = 0; i < leftCapacity; i++)
	{
		Left[i] = A[p + i - 1];
	}
	for (j = 0; j < rightCapacity; j++)
  800328:	ff 45 e8             	incl   -0x18(%ebp)
  80032b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80032e:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800331:	7c ce                	jl     800301 <Merge+0x9a>
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800333:	8b 45 0c             	mov    0xc(%ebp),%eax
  800336:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800339:	e9 0a 01 00 00       	jmp    800448 <Merge+0x1e1>
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
  80033e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800341:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800344:	0f 8d 95 00 00 00    	jge    8003df <Merge+0x178>
  80034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80034d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800350:	0f 8d 89 00 00 00    	jge    8003df <Merge+0x178>
		{
			if (Left[leftIndex] < Right[rightIndex] )
  800356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800359:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	8b 10                	mov    (%eax),%edx
  800367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800371:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8b 00                	mov    (%eax),%eax
  800378:	39 c2                	cmp    %eax,%edx
  80037a:	7d 33                	jge    8003af <Merge+0x148>
			{
				A[k - 1] = Left[leftIndex++];
  80037c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037f:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  800384:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80038b:	8b 45 08             	mov    0x8(%ebp),%eax
  80038e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800394:	8d 50 01             	lea    0x1(%eax),%edx
  800397:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003aa:	e9 96 00 00 00       	jmp    800445 <Merge+0x1de>
			{
				A[k - 1] = Left[leftIndex++];
			}
			else
			{
				A[k - 1] = Right[rightIndex++];
  8003af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b2:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003b7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c7:	8d 50 01             	lea    0x1(%eax),%edx
  8003ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8003cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d7:	01 d0                	add    %edx,%eax
  8003d9:	8b 00                	mov    (%eax),%eax
  8003db:	89 01                	mov    %eax,(%ecx)

	for ( k = p; k <= r; k++)
	{
		if (leftIndex < leftCapacity && rightIndex < rightCapacity)
		{
			if (Left[leftIndex] < Right[rightIndex] )
  8003dd:	eb 66                	jmp    800445 <Merge+0x1de>
			else
			{
				A[k - 1] = Right[rightIndex++];
			}
		}
		else if (leftIndex < leftCapacity)
  8003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003e2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003e5:	7d 30                	jge    800417 <Merge+0x1b0>
		{
			A[k - 1] = Left[leftIndex++];
  8003e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ea:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  8003ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ff:	8d 50 01             	lea    0x1(%eax),%edx
  800402:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800405:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	8b 00                	mov    (%eax),%eax
  800413:	89 01                	mov    %eax,(%ecx)
  800415:	eb 2e                	jmp    800445 <Merge+0x1de>
		}
		else
		{
			A[k - 1] = Right[rightIndex++];
  800417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041a:	05 ff ff ff 3f       	add    $0x3fffffff,%eax
  80041f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800426:	8b 45 08             	mov    0x8(%ebp),%eax
  800429:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 50 01             	lea    0x1(%eax),%edx
  800432:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800435:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80043c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043f:	01 d0                	add    %edx,%eax
  800441:	8b 00                	mov    (%eax),%eax
  800443:	89 01                	mov    %eax,(%ecx)
	for (j = 0; j < rightCapacity; j++)
	{
		Right[j] = A[q + j];
	}

	for ( k = p; k <= r; k++)
  800445:	ff 45 e4             	incl   -0x1c(%ebp)
  800448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80044e:	0f 8e ea fe ff ff    	jle    80033e <Merge+0xd7>
		{
			A[k - 1] = Right[rightIndex++];
		}
	}

	free(Left);
  800454:	83 ec 0c             	sub    $0xc,%esp
  800457:	ff 75 d8             	pushl  -0x28(%ebp)
  80045a:	e8 5c 12 00 00       	call   8016bb <free>
  80045f:	83 c4 10             	add    $0x10,%esp
	free(Right);
  800462:	83 ec 0c             	sub    $0xc,%esp
  800465:	ff 75 d4             	pushl  -0x2c(%ebp)
  800468:	e8 4e 12 00 00       	call   8016bb <free>
  80046d:	83 c4 10             	add    $0x10,%esp

}
  800470:	90                   	nop
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 22 19 00 00       	call   801da0 <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 c4 16 00 00       	call   801bad <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 48 36 80 00       	push   $0x803648
  8004f1:	e8 8d 01 00 00       	call   800683 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 40 80 00       	mov    0x804020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 70 36 80 00       	push   $0x803670
  800519:	e8 65 01 00 00       	call   800683 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 40 80 00       	mov    0x804020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 40 80 00       	mov    0x804020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 40 80 00       	mov    0x804020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 98 36 80 00       	push   $0x803698
  80054a:	e8 34 01 00 00       	call   800683 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 40 80 00       	mov    0x804020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 f0 36 80 00       	push   $0x8036f0
  800566:	e8 18 01 00 00       	call   800683 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 48 36 80 00       	push   $0x803648
  800576:	e8 08 01 00 00       	call   800683 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 44 16 00 00       	call   801bc7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 d1 17 00 00       	call   801d6c <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 26 18 00 00       	call   801dd2 <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 00                	mov    (%eax),%eax
  8005ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8005bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005c0:	89 0a                	mov    %ecx,(%edx)
  8005c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8005c5:	88 d1                	mov    %dl,%cl
  8005c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005d8:	75 2c                	jne    800606 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005da:	a0 24 40 80 00       	mov    0x804024,%al
  8005df:	0f b6 c0             	movzbl %al,%eax
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	8b 12                	mov    (%edx),%edx
  8005e7:	89 d1                	mov    %edx,%ecx
  8005e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ec:	83 c2 08             	add    $0x8,%edx
  8005ef:	83 ec 04             	sub    $0x4,%esp
  8005f2:	50                   	push   %eax
  8005f3:	51                   	push   %ecx
  8005f4:	52                   	push   %edx
  8005f5:	e8 05 14 00 00       	call   8019ff <sys_cputs>
  8005fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800600:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800606:	8b 45 0c             	mov    0xc(%ebp),%eax
  800609:	8b 40 04             	mov    0x4(%eax),%eax
  80060c:	8d 50 01             	lea    0x1(%eax),%edx
  80060f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800612:	89 50 04             	mov    %edx,0x4(%eax)
}
  800615:	90                   	nop
  800616:	c9                   	leave  
  800617:	c3                   	ret    

00800618 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800618:	55                   	push   %ebp
  800619:	89 e5                	mov    %esp,%ebp
  80061b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800621:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800628:	00 00 00 
	b.cnt = 0;
  80062b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800632:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 08             	pushl  0x8(%ebp)
  80063b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800641:	50                   	push   %eax
  800642:	68 af 05 80 00       	push   $0x8005af
  800647:	e8 11 02 00 00       	call   80085d <vprintfmt>
  80064c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80064f:	a0 24 40 80 00       	mov    0x804024,%al
  800654:	0f b6 c0             	movzbl %al,%eax
  800657:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	50                   	push   %eax
  800661:	52                   	push   %edx
  800662:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800668:	83 c0 08             	add    $0x8,%eax
  80066b:	50                   	push   %eax
  80066c:	e8 8e 13 00 00       	call   8019ff <sys_cputs>
  800671:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800674:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80067b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800681:	c9                   	leave  
  800682:	c3                   	ret    

00800683 <cprintf>:

int cprintf(const char *fmt, ...) {
  800683:	55                   	push   %ebp
  800684:	89 e5                	mov    %esp,%ebp
  800686:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800689:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800690:	8d 45 0c             	lea    0xc(%ebp),%eax
  800693:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	83 ec 08             	sub    $0x8,%esp
  80069c:	ff 75 f4             	pushl  -0xc(%ebp)
  80069f:	50                   	push   %eax
  8006a0:	e8 73 ff ff ff       	call   800618 <vcprintf>
  8006a5:	83 c4 10             	add    $0x10,%esp
  8006a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006b6:	e8 f2 14 00 00       	call   801bad <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	83 ec 08             	sub    $0x8,%esp
  8006c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ca:	50                   	push   %eax
  8006cb:	e8 48 ff ff ff       	call   800618 <vcprintf>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006d6:	e8 ec 14 00 00       	call   801bc7 <sys_enable_interrupt>
	return cnt;
  8006db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	53                   	push   %ebx
  8006e4:	83 ec 14             	sub    $0x14,%esp
  8006e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006fe:	77 55                	ja     800755 <printnum+0x75>
  800700:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800703:	72 05                	jb     80070a <printnum+0x2a>
  800705:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800708:	77 4b                	ja     800755 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80070a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80070d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800710:	8b 45 18             	mov    0x18(%ebp),%eax
  800713:	ba 00 00 00 00       	mov    $0x0,%edx
  800718:	52                   	push   %edx
  800719:	50                   	push   %eax
  80071a:	ff 75 f4             	pushl  -0xc(%ebp)
  80071d:	ff 75 f0             	pushl  -0x10(%ebp)
  800720:	e8 43 2c 00 00       	call   803368 <__udivdi3>
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	ff 75 20             	pushl  0x20(%ebp)
  80072e:	53                   	push   %ebx
  80072f:	ff 75 18             	pushl  0x18(%ebp)
  800732:	52                   	push   %edx
  800733:	50                   	push   %eax
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	ff 75 08             	pushl  0x8(%ebp)
  80073a:	e8 a1 ff ff ff       	call   8006e0 <printnum>
  80073f:	83 c4 20             	add    $0x20,%esp
  800742:	eb 1a                	jmp    80075e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800744:	83 ec 08             	sub    $0x8,%esp
  800747:	ff 75 0c             	pushl  0xc(%ebp)
  80074a:	ff 75 20             	pushl  0x20(%ebp)
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	ff d0                	call   *%eax
  800752:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800755:	ff 4d 1c             	decl   0x1c(%ebp)
  800758:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80075c:	7f e6                	jg     800744 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80075e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800761:	bb 00 00 00 00       	mov    $0x0,%ebx
  800766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800769:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80076c:	53                   	push   %ebx
  80076d:	51                   	push   %ecx
  80076e:	52                   	push   %edx
  80076f:	50                   	push   %eax
  800770:	e8 03 2d 00 00       	call   803478 <__umoddi3>
  800775:	83 c4 10             	add    $0x10,%esp
  800778:	05 34 39 80 00       	add    $0x803934,%eax
  80077d:	8a 00                	mov    (%eax),%al
  80077f:	0f be c0             	movsbl %al,%eax
  800782:	83 ec 08             	sub    $0x8,%esp
  800785:	ff 75 0c             	pushl  0xc(%ebp)
  800788:	50                   	push   %eax
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	ff d0                	call   *%eax
  80078e:	83 c4 10             	add    $0x10,%esp
}
  800791:	90                   	nop
  800792:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800795:	c9                   	leave  
  800796:	c3                   	ret    

00800797 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800797:	55                   	push   %ebp
  800798:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80079e:	7e 1c                	jle    8007bc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a3:	8b 00                	mov    (%eax),%eax
  8007a5:	8d 50 08             	lea    0x8(%eax),%edx
  8007a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ab:	89 10                	mov    %edx,(%eax)
  8007ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 e8 08             	sub    $0x8,%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	eb 40                	jmp    8007fc <getuint+0x65>
	else if (lflag)
  8007bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c0:	74 1e                	je     8007e0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	8b 00                	mov    (%eax),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cd:	89 10                	mov    %edx,(%eax)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	83 e8 04             	sub    $0x4,%eax
  8007d7:	8b 00                	mov    (%eax),%eax
  8007d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007de:	eb 1c                	jmp    8007fc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	8d 50 04             	lea    0x4(%eax),%edx
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	89 10                	mov    %edx,(%eax)
  8007ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	83 e8 04             	sub    $0x4,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007fc:	5d                   	pop    %ebp
  8007fd:	c3                   	ret    

008007fe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800801:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800805:	7e 1c                	jle    800823 <getint+0x25>
		return va_arg(*ap, long long);
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	8d 50 08             	lea    0x8(%eax),%edx
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	89 10                	mov    %edx,(%eax)
  800814:	8b 45 08             	mov    0x8(%ebp),%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	83 e8 08             	sub    $0x8,%eax
  80081c:	8b 50 04             	mov    0x4(%eax),%edx
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	eb 38                	jmp    80085b <getint+0x5d>
	else if (lflag)
  800823:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800827:	74 1a                	je     800843 <getint+0x45>
		return va_arg(*ap, long);
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	8b 00                	mov    (%eax),%eax
  80082e:	8d 50 04             	lea    0x4(%eax),%edx
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	89 10                	mov    %edx,(%eax)
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	83 e8 04             	sub    $0x4,%eax
  80083e:	8b 00                	mov    (%eax),%eax
  800840:	99                   	cltd   
  800841:	eb 18                	jmp    80085b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	8d 50 04             	lea    0x4(%eax),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 10                	mov    %edx,(%eax)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	99                   	cltd   
}
  80085b:	5d                   	pop    %ebp
  80085c:	c3                   	ret    

0080085d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80085d:	55                   	push   %ebp
  80085e:	89 e5                	mov    %esp,%ebp
  800860:	56                   	push   %esi
  800861:	53                   	push   %ebx
  800862:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800865:	eb 17                	jmp    80087e <vprintfmt+0x21>
			if (ch == '\0')
  800867:	85 db                	test   %ebx,%ebx
  800869:	0f 84 af 03 00 00    	je     800c1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	ff 75 0c             	pushl  0xc(%ebp)
  800875:	53                   	push   %ebx
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	ff d0                	call   *%eax
  80087b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087e:	8b 45 10             	mov    0x10(%ebp),%eax
  800881:	8d 50 01             	lea    0x1(%eax),%edx
  800884:	89 55 10             	mov    %edx,0x10(%ebp)
  800887:	8a 00                	mov    (%eax),%al
  800889:	0f b6 d8             	movzbl %al,%ebx
  80088c:	83 fb 25             	cmp    $0x25,%ebx
  80088f:	75 d6                	jne    800867 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800891:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800895:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80089c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008b4:	8d 50 01             	lea    0x1(%eax),%edx
  8008b7:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ba:	8a 00                	mov    (%eax),%al
  8008bc:	0f b6 d8             	movzbl %al,%ebx
  8008bf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008c2:	83 f8 55             	cmp    $0x55,%eax
  8008c5:	0f 87 2b 03 00 00    	ja     800bf6 <vprintfmt+0x399>
  8008cb:	8b 04 85 58 39 80 00 	mov    0x803958(,%eax,4),%eax
  8008d2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008d4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008d8:	eb d7                	jmp    8008b1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008da:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008de:	eb d1                	jmp    8008b1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008e7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ea:	89 d0                	mov    %edx,%eax
  8008ec:	c1 e0 02             	shl    $0x2,%eax
  8008ef:	01 d0                	add    %edx,%eax
  8008f1:	01 c0                	add    %eax,%eax
  8008f3:	01 d8                	add    %ebx,%eax
  8008f5:	83 e8 30             	sub    $0x30,%eax
  8008f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fe:	8a 00                	mov    (%eax),%al
  800900:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800903:	83 fb 2f             	cmp    $0x2f,%ebx
  800906:	7e 3e                	jle    800946 <vprintfmt+0xe9>
  800908:	83 fb 39             	cmp    $0x39,%ebx
  80090b:	7f 39                	jg     800946 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800910:	eb d5                	jmp    8008e7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800912:	8b 45 14             	mov    0x14(%ebp),%eax
  800915:	83 c0 04             	add    $0x4,%eax
  800918:	89 45 14             	mov    %eax,0x14(%ebp)
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	83 e8 04             	sub    $0x4,%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800926:	eb 1f                	jmp    800947 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	79 83                	jns    8008b1 <vprintfmt+0x54>
				width = 0;
  80092e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800935:	e9 77 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80093a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800941:	e9 6b ff ff ff       	jmp    8008b1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800946:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800947:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094b:	0f 89 60 ff ff ff    	jns    8008b1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800951:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800954:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800957:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80095e:	e9 4e ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800963:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800966:	e9 46 ff ff ff       	jmp    8008b1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80096b:	8b 45 14             	mov    0x14(%ebp),%eax
  80096e:	83 c0 04             	add    $0x4,%eax
  800971:	89 45 14             	mov    %eax,0x14(%ebp)
  800974:	8b 45 14             	mov    0x14(%ebp),%eax
  800977:	83 e8 04             	sub    $0x4,%eax
  80097a:	8b 00                	mov    (%eax),%eax
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	50                   	push   %eax
  800983:	8b 45 08             	mov    0x8(%ebp),%eax
  800986:	ff d0                	call   *%eax
  800988:	83 c4 10             	add    $0x10,%esp
			break;
  80098b:	e9 89 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009a1:	85 db                	test   %ebx,%ebx
  8009a3:	79 02                	jns    8009a7 <vprintfmt+0x14a>
				err = -err;
  8009a5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009a7:	83 fb 64             	cmp    $0x64,%ebx
  8009aa:	7f 0b                	jg     8009b7 <vprintfmt+0x15a>
  8009ac:	8b 34 9d a0 37 80 00 	mov    0x8037a0(,%ebx,4),%esi
  8009b3:	85 f6                	test   %esi,%esi
  8009b5:	75 19                	jne    8009d0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009b7:	53                   	push   %ebx
  8009b8:	68 45 39 80 00       	push   $0x803945
  8009bd:	ff 75 0c             	pushl  0xc(%ebp)
  8009c0:	ff 75 08             	pushl  0x8(%ebp)
  8009c3:	e8 5e 02 00 00       	call   800c26 <printfmt>
  8009c8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009cb:	e9 49 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009d0:	56                   	push   %esi
  8009d1:	68 4e 39 80 00       	push   $0x80394e
  8009d6:	ff 75 0c             	pushl  0xc(%ebp)
  8009d9:	ff 75 08             	pushl  0x8(%ebp)
  8009dc:	e8 45 02 00 00       	call   800c26 <printfmt>
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 30 02 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ec:	83 c0 04             	add    $0x4,%eax
  8009ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8009f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f5:	83 e8 04             	sub    $0x4,%eax
  8009f8:	8b 30                	mov    (%eax),%esi
  8009fa:	85 f6                	test   %esi,%esi
  8009fc:	75 05                	jne    800a03 <vprintfmt+0x1a6>
				p = "(null)";
  8009fe:	be 51 39 80 00       	mov    $0x803951,%esi
			if (width > 0 && padc != '-')
  800a03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a07:	7e 6d                	jle    800a76 <vprintfmt+0x219>
  800a09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a0d:	74 67                	je     800a76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a12:	83 ec 08             	sub    $0x8,%esp
  800a15:	50                   	push   %eax
  800a16:	56                   	push   %esi
  800a17:	e8 0c 03 00 00       	call   800d28 <strnlen>
  800a1c:	83 c4 10             	add    $0x10,%esp
  800a1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a22:	eb 16                	jmp    800a3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	50                   	push   %eax
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a37:	ff 4d e4             	decl   -0x1c(%ebp)
  800a3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a3e:	7f e4                	jg     800a24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a40:	eb 34                	jmp    800a76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a46:	74 1c                	je     800a64 <vprintfmt+0x207>
  800a48:	83 fb 1f             	cmp    $0x1f,%ebx
  800a4b:	7e 05                	jle    800a52 <vprintfmt+0x1f5>
  800a4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800a50:	7e 12                	jle    800a64 <vprintfmt+0x207>
					putch('?', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 3f                	push   $0x3f
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
  800a62:	eb 0f                	jmp    800a73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 0c             	pushl  0xc(%ebp)
  800a6a:	53                   	push   %ebx
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	89 f0                	mov    %esi,%eax
  800a78:	8d 70 01             	lea    0x1(%eax),%esi
  800a7b:	8a 00                	mov    (%eax),%al
  800a7d:	0f be d8             	movsbl %al,%ebx
  800a80:	85 db                	test   %ebx,%ebx
  800a82:	74 24                	je     800aa8 <vprintfmt+0x24b>
  800a84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a88:	78 b8                	js     800a42 <vprintfmt+0x1e5>
  800a8a:	ff 4d e0             	decl   -0x20(%ebp)
  800a8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a91:	79 af                	jns    800a42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a93:	eb 13                	jmp    800aa8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	6a 20                	push   $0x20
  800a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa0:	ff d0                	call   *%eax
  800aa2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aa5:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aac:	7f e7                	jg     800a95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800aae:	e9 66 01 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 3c fd ff ff       	call   8007fe <getint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800acb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ad1:	85 d2                	test   %edx,%edx
  800ad3:	79 23                	jns    800af8 <vprintfmt+0x29b>
				putch('-', putdat);
  800ad5:	83 ec 08             	sub    $0x8,%esp
  800ad8:	ff 75 0c             	pushl  0xc(%ebp)
  800adb:	6a 2d                	push   $0x2d
  800add:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae0:	ff d0                	call   *%eax
  800ae2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aeb:	f7 d8                	neg    %eax
  800aed:	83 d2 00             	adc    $0x0,%edx
  800af0:	f7 da                	neg    %edx
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800af8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aff:	e9 bc 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b04:	83 ec 08             	sub    $0x8,%esp
  800b07:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800b0d:	50                   	push   %eax
  800b0e:	e8 84 fc ff ff       	call   800797 <getuint>
  800b13:	83 c4 10             	add    $0x10,%esp
  800b16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b23:	e9 98 00 00 00       	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	ff 75 0c             	pushl  0xc(%ebp)
  800b2e:	6a 58                	push   $0x58
  800b30:	8b 45 08             	mov    0x8(%ebp),%eax
  800b33:	ff d0                	call   *%eax
  800b35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b38:	83 ec 08             	sub    $0x8,%esp
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	6a 58                	push   $0x58
  800b40:	8b 45 08             	mov    0x8(%ebp),%eax
  800b43:	ff d0                	call   *%eax
  800b45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	6a 58                	push   $0x58
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	ff d0                	call   *%eax
  800b55:	83 c4 10             	add    $0x10,%esp
			break;
  800b58:	e9 bc 00 00 00       	jmp    800c19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 30                	push   $0x30
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 78                	push   $0x78
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b80:	83 c0 04             	add    $0x4,%eax
  800b83:	89 45 14             	mov    %eax,0x14(%ebp)
  800b86:	8b 45 14             	mov    0x14(%ebp),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b9f:	eb 1f                	jmp    800bc0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ba7:	8d 45 14             	lea    0x14(%ebp),%eax
  800baa:	50                   	push   %eax
  800bab:	e8 e7 fb ff ff       	call   800797 <getuint>
  800bb0:	83 c4 10             	add    $0x10,%esp
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bc0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bc7:	83 ec 04             	sub    $0x4,%esp
  800bca:	52                   	push   %edx
  800bcb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bce:	50                   	push   %eax
  800bcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd2:	ff 75 f0             	pushl  -0x10(%ebp)
  800bd5:	ff 75 0c             	pushl  0xc(%ebp)
  800bd8:	ff 75 08             	pushl  0x8(%ebp)
  800bdb:	e8 00 fb ff ff       	call   8006e0 <printnum>
  800be0:	83 c4 20             	add    $0x20,%esp
			break;
  800be3:	eb 34                	jmp    800c19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800be5:	83 ec 08             	sub    $0x8,%esp
  800be8:	ff 75 0c             	pushl  0xc(%ebp)
  800beb:	53                   	push   %ebx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			break;
  800bf4:	eb 23                	jmp    800c19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bf6:	83 ec 08             	sub    $0x8,%esp
  800bf9:	ff 75 0c             	pushl  0xc(%ebp)
  800bfc:	6a 25                	push   $0x25
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	ff d0                	call   *%eax
  800c03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c06:	ff 4d 10             	decl   0x10(%ebp)
  800c09:	eb 03                	jmp    800c0e <vprintfmt+0x3b1>
  800c0b:	ff 4d 10             	decl   0x10(%ebp)
  800c0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c11:	48                   	dec    %eax
  800c12:	8a 00                	mov    (%eax),%al
  800c14:	3c 25                	cmp    $0x25,%al
  800c16:	75 f3                	jne    800c0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c18:	90                   	nop
		}
	}
  800c19:	e9 47 fc ff ff       	jmp    800865 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800c2f:	83 c0 04             	add    $0x4,%eax
  800c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c35:	8b 45 10             	mov    0x10(%ebp),%eax
  800c38:	ff 75 f4             	pushl  -0xc(%ebp)
  800c3b:	50                   	push   %eax
  800c3c:	ff 75 0c             	pushl  0xc(%ebp)
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 16 fc ff ff       	call   80085d <vprintfmt>
  800c47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c4a:	90                   	nop
  800c4b:	c9                   	leave  
  800c4c:	c3                   	ret    

00800c4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c4d:	55                   	push   %ebp
  800c4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8b 40 08             	mov    0x8(%eax),%eax
  800c56:	8d 50 01             	lea    0x1(%eax),%edx
  800c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c62:	8b 10                	mov    (%eax),%edx
  800c64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c67:	8b 40 04             	mov    0x4(%eax),%eax
  800c6a:	39 c2                	cmp    %eax,%edx
  800c6c:	73 12                	jae    800c80 <sprintputch+0x33>
		*b->buf++ = ch;
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 48 01             	lea    0x1(%eax),%ecx
  800c76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c79:	89 0a                	mov    %ecx,(%edx)
  800c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7e:	88 10                	mov    %dl,(%eax)
}
  800c80:	90                   	nop
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c89:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	01 d0                	add    %edx,%eax
  800c9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ca8:	74 06                	je     800cb0 <vsnprintf+0x2d>
  800caa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cae:	7f 07                	jg     800cb7 <vsnprintf+0x34>
		return -E_INVAL;
  800cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb5:	eb 20                	jmp    800cd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cb7:	ff 75 14             	pushl  0x14(%ebp)
  800cba:	ff 75 10             	pushl  0x10(%ebp)
  800cbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cc0:	50                   	push   %eax
  800cc1:	68 4d 0c 80 00       	push   $0x800c4d
  800cc6:	e8 92 fb ff ff       	call   80085d <vprintfmt>
  800ccb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ceb:	ff 75 f4             	pushl  -0xc(%ebp)
  800cee:	50                   	push   %eax
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	ff 75 08             	pushl  0x8(%ebp)
  800cf5:	e8 89 ff ff ff       	call   800c83 <vsnprintf>
  800cfa:	83 c4 10             	add    $0x10,%esp
  800cfd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d03:	c9                   	leave  
  800d04:	c3                   	ret    

00800d05 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d12:	eb 06                	jmp    800d1a <strlen+0x15>
		n++;
  800d14:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d17:	ff 45 08             	incl   0x8(%ebp)
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	84 c0                	test   %al,%al
  800d21:	75 f1                	jne    800d14 <strlen+0xf>
		n++;
	return n;
  800d23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d26:	c9                   	leave  
  800d27:	c3                   	ret    

00800d28 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d35:	eb 09                	jmp    800d40 <strnlen+0x18>
		n++;
  800d37:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d3a:	ff 45 08             	incl   0x8(%ebp)
  800d3d:	ff 4d 0c             	decl   0xc(%ebp)
  800d40:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d44:	74 09                	je     800d4f <strnlen+0x27>
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	75 e8                	jne    800d37 <strnlen+0xf>
		n++;
	return n;
  800d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
  800d57:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d60:	90                   	nop
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8d 50 01             	lea    0x1(%eax),%edx
  800d67:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d70:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d73:	8a 12                	mov    (%edx),%dl
  800d75:	88 10                	mov    %dl,(%eax)
  800d77:	8a 00                	mov    (%eax),%al
  800d79:	84 c0                	test   %al,%al
  800d7b:	75 e4                	jne    800d61 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d8e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d95:	eb 1f                	jmp    800db6 <strncpy+0x34>
		*dst++ = *src;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8d 50 01             	lea    0x1(%eax),%edx
  800d9d:	89 55 08             	mov    %edx,0x8(%ebp)
  800da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da3:	8a 12                	mov    (%edx),%dl
  800da5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	84 c0                	test   %al,%al
  800dae:	74 03                	je     800db3 <strncpy+0x31>
			src++;
  800db0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800db3:	ff 45 fc             	incl   -0x4(%ebp)
  800db6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db9:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dbc:	72 d9                	jb     800d97 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dc1:	c9                   	leave  
  800dc2:	c3                   	ret    

00800dc3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dcf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd3:	74 30                	je     800e05 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dd5:	eb 16                	jmp    800ded <strlcpy+0x2a>
			*dst++ = *src++;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8d 50 01             	lea    0x1(%eax),%edx
  800ddd:	89 55 08             	mov    %edx,0x8(%ebp)
  800de0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800de3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800de9:	8a 12                	mov    (%edx),%dl
  800deb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	74 09                	je     800dff <strlcpy+0x3c>
  800df6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df9:	8a 00                	mov    (%eax),%al
  800dfb:	84 c0                	test   %al,%al
  800dfd:	75 d8                	jne    800dd7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0b:	29 c2                	sub    %eax,%edx
  800e0d:	89 d0                	mov    %edx,%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e14:	eb 06                	jmp    800e1c <strcmp+0xb>
		p++, q++;
  800e16:	ff 45 08             	incl   0x8(%ebp)
  800e19:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	84 c0                	test   %al,%al
  800e23:	74 0e                	je     800e33 <strcmp+0x22>
  800e25:	8b 45 08             	mov    0x8(%ebp),%eax
  800e28:	8a 10                	mov    (%eax),%dl
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	38 c2                	cmp    %al,%dl
  800e31:	74 e3                	je     800e16 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	0f b6 d0             	movzbl %al,%edx
  800e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	0f b6 c0             	movzbl %al,%eax
  800e43:	29 c2                	sub    %eax,%edx
  800e45:	89 d0                	mov    %edx,%eax
}
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e4c:	eb 09                	jmp    800e57 <strncmp+0xe>
		n--, p++, q++;
  800e4e:	ff 4d 10             	decl   0x10(%ebp)
  800e51:	ff 45 08             	incl   0x8(%ebp)
  800e54:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e5b:	74 17                	je     800e74 <strncmp+0x2b>
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	8a 00                	mov    (%eax),%al
  800e62:	84 c0                	test   %al,%al
  800e64:	74 0e                	je     800e74 <strncmp+0x2b>
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 10                	mov    (%eax),%dl
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	8a 00                	mov    (%eax),%al
  800e70:	38 c2                	cmp    %al,%dl
  800e72:	74 da                	je     800e4e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e74:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e78:	75 07                	jne    800e81 <strncmp+0x38>
		return 0;
  800e7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800e7f:	eb 14                	jmp    800e95 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	0f b6 d0             	movzbl %al,%edx
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 c0             	movzbl %al,%eax
  800e91:	29 c2                	sub    %eax,%edx
  800e93:	89 d0                	mov    %edx,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 04             	sub    $0x4,%esp
  800e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea3:	eb 12                	jmp    800eb7 <strchr+0x20>
		if (*s == c)
  800ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ead:	75 05                	jne    800eb4 <strchr+0x1d>
			return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	eb 11                	jmp    800ec5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eb4:	ff 45 08             	incl   0x8(%ebp)
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	8a 00                	mov    (%eax),%al
  800ebc:	84 c0                	test   %al,%al
  800ebe:	75 e5                	jne    800ea5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec5:	c9                   	leave  
  800ec6:	c3                   	ret    

00800ec7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	83 ec 04             	sub    $0x4,%esp
  800ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed3:	eb 0d                	jmp    800ee2 <strfind+0x1b>
		if (*s == c)
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	8a 00                	mov    (%eax),%al
  800eda:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800edd:	74 0e                	je     800eed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800edf:	ff 45 08             	incl   0x8(%ebp)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	84 c0                	test   %al,%al
  800ee9:	75 ea                	jne    800ed5 <strfind+0xe>
  800eeb:	eb 01                	jmp    800eee <strfind+0x27>
		if (*s == c)
			break;
  800eed:	90                   	nop
	return (char *) s;
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef1:	c9                   	leave  
  800ef2:	c3                   	ret    

00800ef3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eff:	8b 45 10             	mov    0x10(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f05:	eb 0e                	jmp    800f15 <memset+0x22>
		*p++ = c;
  800f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0a:	8d 50 01             	lea    0x1(%eax),%edx
  800f0d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f10:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f13:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f15:	ff 4d f8             	decl   -0x8(%ebp)
  800f18:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f1c:	79 e9                	jns    800f07 <memset+0x14>
		*p++ = c;

	return v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f21:	c9                   	leave  
  800f22:	c3                   	ret    

00800f23 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f23:	55                   	push   %ebp
  800f24:	89 e5                	mov    %esp,%ebp
  800f26:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f35:	eb 16                	jmp    800f4d <memcpy+0x2a>
		*d++ = *s++;
  800f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f43:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f46:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f49:	8a 12                	mov    (%edx),%dl
  800f4b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f53:	89 55 10             	mov    %edx,0x10(%ebp)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	75 dd                	jne    800f37 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f77:	73 50                	jae    800fc9 <memmove+0x6a>
  800f79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f84:	76 43                	jbe    800fc9 <memmove+0x6a>
		s += n;
  800f86:	8b 45 10             	mov    0x10(%ebp),%eax
  800f89:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f92:	eb 10                	jmp    800fa4 <memmove+0x45>
			*--d = *--s;
  800f94:	ff 4d f8             	decl   -0x8(%ebp)
  800f97:	ff 4d fc             	decl   -0x4(%ebp)
  800f9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9d:	8a 10                	mov    (%eax),%dl
  800f9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fa4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800faa:	89 55 10             	mov    %edx,0x10(%ebp)
  800fad:	85 c0                	test   %eax,%eax
  800faf:	75 e3                	jne    800f94 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb1:	eb 23                	jmp    800fd6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb6:	8d 50 01             	lea    0x1(%eax),%edx
  800fb9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fbc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fbf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fc5:	8a 12                	mov    (%edx),%dl
  800fc7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 dd                	jne    800fb3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd9:	c9                   	leave  
  800fda:	c3                   	ret    

00800fdb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fdb:	55                   	push   %ebp
  800fdc:	89 e5                	mov    %esp,%ebp
  800fde:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fed:	eb 2a                	jmp    801019 <memcmp+0x3e>
		if (*s1 != *s2)
  800fef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ff2:	8a 10                	mov    (%eax),%dl
  800ff4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	38 c2                	cmp    %al,%dl
  800ffb:	74 16                	je     801013 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f b6 d0             	movzbl %al,%edx
  801005:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f b6 c0             	movzbl %al,%eax
  80100d:	29 c2                	sub    %eax,%edx
  80100f:	89 d0                	mov    %edx,%eax
  801011:	eb 18                	jmp    80102b <memcmp+0x50>
		s1++, s2++;
  801013:	ff 45 fc             	incl   -0x4(%ebp)
  801016:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801019:	8b 45 10             	mov    0x10(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	89 55 10             	mov    %edx,0x10(%ebp)
  801022:	85 c0                	test   %eax,%eax
  801024:	75 c9                	jne    800fef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80102b:	c9                   	leave  
  80102c:	c3                   	ret    

0080102d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80102d:	55                   	push   %ebp
  80102e:	89 e5                	mov    %esp,%ebp
  801030:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80103e:	eb 15                	jmp    801055 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	0f b6 d0             	movzbl %al,%edx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	0f b6 c0             	movzbl %al,%eax
  80104e:	39 c2                	cmp    %eax,%edx
  801050:	74 0d                	je     80105f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80105b:	72 e3                	jb     801040 <memfind+0x13>
  80105d:	eb 01                	jmp    801060 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80105f:	90                   	nop
	return (void *) s;
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801063:	c9                   	leave  
  801064:	c3                   	ret    

00801065 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80106b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801072:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801079:	eb 03                	jmp    80107e <strtol+0x19>
		s++;
  80107b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 20                	cmp    $0x20,%al
  801085:	74 f4                	je     80107b <strtol+0x16>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 09                	cmp    $0x9,%al
  80108e:	74 eb                	je     80107b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	3c 2b                	cmp    $0x2b,%al
  801097:	75 05                	jne    80109e <strtol+0x39>
		s++;
  801099:	ff 45 08             	incl   0x8(%ebp)
  80109c:	eb 13                	jmp    8010b1 <strtol+0x4c>
	else if (*s == '-')
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8a 00                	mov    (%eax),%al
  8010a3:	3c 2d                	cmp    $0x2d,%al
  8010a5:	75 0a                	jne    8010b1 <strtol+0x4c>
		s++, neg = 1;
  8010a7:	ff 45 08             	incl   0x8(%ebp)
  8010aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b5:	74 06                	je     8010bd <strtol+0x58>
  8010b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010bb:	75 20                	jne    8010dd <strtol+0x78>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 30                	cmp    $0x30,%al
  8010c4:	75 17                	jne    8010dd <strtol+0x78>
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	40                   	inc    %eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	3c 78                	cmp    $0x78,%al
  8010ce:	75 0d                	jne    8010dd <strtol+0x78>
		s += 2, base = 16;
  8010d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010db:	eb 28                	jmp    801105 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e1:	75 15                	jne    8010f8 <strtol+0x93>
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	8a 00                	mov    (%eax),%al
  8010e8:	3c 30                	cmp    $0x30,%al
  8010ea:	75 0c                	jne    8010f8 <strtol+0x93>
		s++, base = 8;
  8010ec:	ff 45 08             	incl   0x8(%ebp)
  8010ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010f6:	eb 0d                	jmp    801105 <strtol+0xa0>
	else if (base == 0)
  8010f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fc:	75 07                	jne    801105 <strtol+0xa0>
		base = 10;
  8010fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801105:	8b 45 08             	mov    0x8(%ebp),%eax
  801108:	8a 00                	mov    (%eax),%al
  80110a:	3c 2f                	cmp    $0x2f,%al
  80110c:	7e 19                	jle    801127 <strtol+0xc2>
  80110e:	8b 45 08             	mov    0x8(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	3c 39                	cmp    $0x39,%al
  801115:	7f 10                	jg     801127 <strtol+0xc2>
			dig = *s - '0';
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f be c0             	movsbl %al,%eax
  80111f:	83 e8 30             	sub    $0x30,%eax
  801122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801125:	eb 42                	jmp    801169 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801127:	8b 45 08             	mov    0x8(%ebp),%eax
  80112a:	8a 00                	mov    (%eax),%al
  80112c:	3c 60                	cmp    $0x60,%al
  80112e:	7e 19                	jle    801149 <strtol+0xe4>
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	8a 00                	mov    (%eax),%al
  801135:	3c 7a                	cmp    $0x7a,%al
  801137:	7f 10                	jg     801149 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	8a 00                	mov    (%eax),%al
  80113e:	0f be c0             	movsbl %al,%eax
  801141:	83 e8 57             	sub    $0x57,%eax
  801144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801147:	eb 20                	jmp    801169 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801149:	8b 45 08             	mov    0x8(%ebp),%eax
  80114c:	8a 00                	mov    (%eax),%al
  80114e:	3c 40                	cmp    $0x40,%al
  801150:	7e 39                	jle    80118b <strtol+0x126>
  801152:	8b 45 08             	mov    0x8(%ebp),%eax
  801155:	8a 00                	mov    (%eax),%al
  801157:	3c 5a                	cmp    $0x5a,%al
  801159:	7f 30                	jg     80118b <strtol+0x126>
			dig = *s - 'A' + 10;
  80115b:	8b 45 08             	mov    0x8(%ebp),%eax
  80115e:	8a 00                	mov    (%eax),%al
  801160:	0f be c0             	movsbl %al,%eax
  801163:	83 e8 37             	sub    $0x37,%eax
  801166:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80116c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80116f:	7d 19                	jge    80118a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801177:	0f af 45 10          	imul   0x10(%ebp),%eax
  80117b:	89 c2                	mov    %eax,%edx
  80117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801180:	01 d0                	add    %edx,%eax
  801182:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801185:	e9 7b ff ff ff       	jmp    801105 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80118a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80118b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80118f:	74 08                	je     801199 <strtol+0x134>
		*endptr = (char *) s;
  801191:	8b 45 0c             	mov    0xc(%ebp),%eax
  801194:	8b 55 08             	mov    0x8(%ebp),%edx
  801197:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801199:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80119d:	74 07                	je     8011a6 <strtol+0x141>
  80119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a2:	f7 d8                	neg    %eax
  8011a4:	eb 03                	jmp    8011a9 <strtol+0x144>
  8011a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <ltostr>:

void
ltostr(long value, char *str)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011c3:	79 13                	jns    8011d8 <ltostr+0x2d>
	{
		neg = 1;
  8011c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011e0:	99                   	cltd   
  8011e1:	f7 f9                	idiv   %ecx
  8011e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011ef:	89 c2                	mov    %eax,%edx
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	01 d0                	add    %edx,%eax
  8011f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011f9:	83 c2 30             	add    $0x30,%edx
  8011fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801201:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801206:	f7 e9                	imul   %ecx
  801208:	c1 fa 02             	sar    $0x2,%edx
  80120b:	89 c8                	mov    %ecx,%eax
  80120d:	c1 f8 1f             	sar    $0x1f,%eax
  801210:	29 c2                	sub    %eax,%edx
  801212:	89 d0                	mov    %edx,%eax
  801214:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801217:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80121f:	f7 e9                	imul   %ecx
  801221:	c1 fa 02             	sar    $0x2,%edx
  801224:	89 c8                	mov    %ecx,%eax
  801226:	c1 f8 1f             	sar    $0x1f,%eax
  801229:	29 c2                	sub    %eax,%edx
  80122b:	89 d0                	mov    %edx,%eax
  80122d:	c1 e0 02             	shl    $0x2,%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	01 c0                	add    %eax,%eax
  801234:	29 c1                	sub    %eax,%ecx
  801236:	89 ca                	mov    %ecx,%edx
  801238:	85 d2                	test   %edx,%edx
  80123a:	75 9c                	jne    8011d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80123c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801243:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801246:	48                   	dec    %eax
  801247:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80124a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80124e:	74 3d                	je     80128d <ltostr+0xe2>
		start = 1 ;
  801250:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801257:	eb 34                	jmp    80128d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801259:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125f:	01 d0                	add    %edx,%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801266:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801271:	8b 45 0c             	mov    0xc(%ebp),%eax
  801274:	01 c8                	add    %ecx,%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80127a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c2                	add    %eax,%edx
  801282:	8a 45 eb             	mov    -0x15(%ebp),%al
  801285:	88 02                	mov    %al,(%edx)
		start++ ;
  801287:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80128a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80128d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801290:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801293:	7c c4                	jl     801259 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801295:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	01 d0                	add    %edx,%eax
  80129d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012a0:	90                   	nop
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    

008012a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012a9:	ff 75 08             	pushl  0x8(%ebp)
  8012ac:	e8 54 fa ff ff       	call   800d05 <strlen>
  8012b1:	83 c4 04             	add    $0x4,%esp
  8012b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012b7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ba:	e8 46 fa ff ff       	call   800d05 <strlen>
  8012bf:	83 c4 04             	add    $0x4,%esp
  8012c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012d3:	eb 17                	jmp    8012ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8012d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	01 c2                	add    %eax,%edx
  8012dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	01 c8                	add    %ecx,%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012e9:	ff 45 fc             	incl   -0x4(%ebp)
  8012ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012f2:	7c e1                	jl     8012d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801302:	eb 1f                	jmp    801323 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801304:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801307:	8d 50 01             	lea    0x1(%eax),%edx
  80130a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80130d:	89 c2                	mov    %eax,%edx
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
  801312:	01 c2                	add    %eax,%edx
  801314:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801317:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131a:	01 c8                	add    %ecx,%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801320:	ff 45 f8             	incl   -0x8(%ebp)
  801323:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801326:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801329:	7c d9                	jl     801304 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80132b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	01 d0                	add    %edx,%eax
  801333:	c6 00 00             	movb   $0x0,(%eax)
}
  801336:	90                   	nop
  801337:	c9                   	leave  
  801338:	c3                   	ret    

00801339 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801339:	55                   	push   %ebp
  80133a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80133c:	8b 45 14             	mov    0x14(%ebp),%eax
  80133f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801345:	8b 45 14             	mov    0x14(%ebp),%eax
  801348:	8b 00                	mov    (%eax),%eax
  80134a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	01 d0                	add    %edx,%eax
  801356:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80135c:	eb 0c                	jmp    80136a <strsplit+0x31>
			*string++ = 0;
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 08             	mov    %edx,0x8(%ebp)
  801367:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80136a:	8b 45 08             	mov    0x8(%ebp),%eax
  80136d:	8a 00                	mov    (%eax),%al
  80136f:	84 c0                	test   %al,%al
  801371:	74 18                	je     80138b <strsplit+0x52>
  801373:	8b 45 08             	mov    0x8(%ebp),%eax
  801376:	8a 00                	mov    (%eax),%al
  801378:	0f be c0             	movsbl %al,%eax
  80137b:	50                   	push   %eax
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	e8 13 fb ff ff       	call   800e97 <strchr>
  801384:	83 c4 08             	add    $0x8,%esp
  801387:	85 c0                	test   %eax,%eax
  801389:	75 d3                	jne    80135e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8a 00                	mov    (%eax),%al
  801390:	84 c0                	test   %al,%al
  801392:	74 5a                	je     8013ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801394:	8b 45 14             	mov    0x14(%ebp),%eax
  801397:	8b 00                	mov    (%eax),%eax
  801399:	83 f8 0f             	cmp    $0xf,%eax
  80139c:	75 07                	jne    8013a5 <strsplit+0x6c>
		{
			return 0;
  80139e:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a3:	eb 66                	jmp    80140b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a8:	8b 00                	mov    (%eax),%eax
  8013aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8013ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8013b0:	89 0a                	mov    %ecx,(%edx)
  8013b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bc:	01 c2                	add    %eax,%edx
  8013be:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c3:	eb 03                	jmp    8013c8 <strsplit+0x8f>
			string++;
  8013c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	84 c0                	test   %al,%al
  8013cf:	74 8b                	je     80135c <strsplit+0x23>
  8013d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f be c0             	movsbl %al,%eax
  8013d9:	50                   	push   %eax
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 b5 fa ff ff       	call   800e97 <strchr>
  8013e2:	83 c4 08             	add    $0x8,%esp
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	74 dc                	je     8013c5 <strsplit+0x8c>
			string++;
	}
  8013e9:	e9 6e ff ff ff       	jmp    80135c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f2:	8b 00                	mov    (%eax),%eax
  8013f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 d0                	add    %edx,%eax
  801400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801406:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801413:	a1 04 40 80 00       	mov    0x804004,%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 1f                	je     80143b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80141c:	e8 1d 00 00 00       	call   80143e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801421:	83 ec 0c             	sub    $0xc,%esp
  801424:	68 b0 3a 80 00       	push   $0x803ab0
  801429:	e8 55 f2 ff ff       	call   800683 <cprintf>
  80142e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801431:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801438:	00 00 00 
	}
}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801444:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80144b:	00 00 00 
  80144e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801455:	00 00 00 
  801458:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80145f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801462:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801469:	00 00 00 
  80146c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801473:	00 00 00 
  801476:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80147d:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801480:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148a:	c1 e8 0c             	shr    $0xc,%eax
  80148d:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801492:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801499:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014a6:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  8014ab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8014b2:	a1 20 41 80 00       	mov    0x804120,%eax
  8014b7:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8014bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8014be:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8014c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	48                   	dec    %eax
  8014ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d9:	f7 75 e4             	divl   -0x1c(%ebp)
  8014dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014df:	29 d0                	sub    %edx,%eax
  8014e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8014e4:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8014eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014f3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014f8:	83 ec 04             	sub    $0x4,%esp
  8014fb:	6a 07                	push   $0x7
  8014fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801500:	50                   	push   %eax
  801501:	e8 3d 06 00 00       	call   801b43 <sys_allocate_chunk>
  801506:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801509:	a1 20 41 80 00       	mov    0x804120,%eax
  80150e:	83 ec 0c             	sub    $0xc,%esp
  801511:	50                   	push   %eax
  801512:	e8 b2 0c 00 00       	call   8021c9 <initialize_MemBlocksList>
  801517:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  80151a:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80151f:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801522:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801526:	0f 84 f3 00 00 00    	je     80161f <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80152c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801530:	75 14                	jne    801546 <initialize_dyn_block_system+0x108>
  801532:	83 ec 04             	sub    $0x4,%esp
  801535:	68 d5 3a 80 00       	push   $0x803ad5
  80153a:	6a 36                	push   $0x36
  80153c:	68 f3 3a 80 00       	push   $0x803af3
  801541:	e8 41 1c 00 00       	call   803187 <_panic>
  801546:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801549:	8b 00                	mov    (%eax),%eax
  80154b:	85 c0                	test   %eax,%eax
  80154d:	74 10                	je     80155f <initialize_dyn_block_system+0x121>
  80154f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801552:	8b 00                	mov    (%eax),%eax
  801554:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801557:	8b 52 04             	mov    0x4(%edx),%edx
  80155a:	89 50 04             	mov    %edx,0x4(%eax)
  80155d:	eb 0b                	jmp    80156a <initialize_dyn_block_system+0x12c>
  80155f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801562:	8b 40 04             	mov    0x4(%eax),%eax
  801565:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80156a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80156d:	8b 40 04             	mov    0x4(%eax),%eax
  801570:	85 c0                	test   %eax,%eax
  801572:	74 0f                	je     801583 <initialize_dyn_block_system+0x145>
  801574:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801577:	8b 40 04             	mov    0x4(%eax),%eax
  80157a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80157d:	8b 12                	mov    (%edx),%edx
  80157f:	89 10                	mov    %edx,(%eax)
  801581:	eb 0a                	jmp    80158d <initialize_dyn_block_system+0x14f>
  801583:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801586:	8b 00                	mov    (%eax),%eax
  801588:	a3 48 41 80 00       	mov    %eax,0x804148
  80158d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801590:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801596:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801599:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015a0:	a1 54 41 80 00       	mov    0x804154,%eax
  8015a5:	48                   	dec    %eax
  8015a6:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8015ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015ae:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8015b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015b8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8015bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8015c3:	75 14                	jne    8015d9 <initialize_dyn_block_system+0x19b>
  8015c5:	83 ec 04             	sub    $0x4,%esp
  8015c8:	68 00 3b 80 00       	push   $0x803b00
  8015cd:	6a 3e                	push   $0x3e
  8015cf:	68 f3 3a 80 00       	push   $0x803af3
  8015d4:	e8 ae 1b 00 00       	call   803187 <_panic>
  8015d9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8015df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015e2:	89 10                	mov    %edx,(%eax)
  8015e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015e7:	8b 00                	mov    (%eax),%eax
  8015e9:	85 c0                	test   %eax,%eax
  8015eb:	74 0d                	je     8015fa <initialize_dyn_block_system+0x1bc>
  8015ed:	a1 38 41 80 00       	mov    0x804138,%eax
  8015f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015f5:	89 50 04             	mov    %edx,0x4(%eax)
  8015f8:	eb 08                	jmp    801602 <initialize_dyn_block_system+0x1c4>
  8015fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015fd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801602:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801605:	a3 38 41 80 00       	mov    %eax,0x804138
  80160a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80160d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801614:	a1 44 41 80 00       	mov    0x804144,%eax
  801619:	40                   	inc    %eax
  80161a:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  80161f:	90                   	nop
  801620:	c9                   	leave  
  801621:	c3                   	ret    

00801622 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
  801625:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801628:	e8 e0 fd ff ff       	call   80140d <InitializeUHeap>
		if (size == 0) return NULL ;
  80162d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801631:	75 07                	jne    80163a <malloc+0x18>
  801633:	b8 00 00 00 00       	mov    $0x0,%eax
  801638:	eb 7f                	jmp    8016b9 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80163a:	e8 d2 08 00 00       	call   801f11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80163f:	85 c0                	test   %eax,%eax
  801641:	74 71                	je     8016b4 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801643:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80164a:	8b 55 08             	mov    0x8(%ebp),%edx
  80164d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801650:	01 d0                	add    %edx,%eax
  801652:	48                   	dec    %eax
  801653:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801656:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801659:	ba 00 00 00 00       	mov    $0x0,%edx
  80165e:	f7 75 f4             	divl   -0xc(%ebp)
  801661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801664:	29 d0                	sub    %edx,%eax
  801666:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801669:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801670:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801677:	76 07                	jbe    801680 <malloc+0x5e>
					return NULL ;
  801679:	b8 00 00 00 00       	mov    $0x0,%eax
  80167e:	eb 39                	jmp    8016b9 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801680:	83 ec 0c             	sub    $0xc,%esp
  801683:	ff 75 08             	pushl  0x8(%ebp)
  801686:	e8 e6 0d 00 00       	call   802471 <alloc_block_FF>
  80168b:	83 c4 10             	add    $0x10,%esp
  80168e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801691:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801695:	74 16                	je     8016ad <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801697:	83 ec 0c             	sub    $0xc,%esp
  80169a:	ff 75 ec             	pushl  -0x14(%ebp)
  80169d:	e8 37 0c 00 00       	call   8022d9 <insert_sorted_allocList>
  8016a2:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8016a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a8:	8b 40 08             	mov    0x8(%eax),%eax
  8016ab:	eb 0c                	jmp    8016b9 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8016ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b2:	eb 05                	jmp    8016b9 <malloc+0x97>
				}
		}
	return 0;
  8016b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b9:	c9                   	leave  
  8016ba:	c3                   	ret    

008016bb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016bb:	55                   	push   %ebp
  8016bc:	89 e5                	mov    %esp,%ebp
  8016be:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8016c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8016c7:	83 ec 08             	sub    $0x8,%esp
  8016ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8016cd:	68 40 40 80 00       	push   $0x804040
  8016d2:	e8 cf 0b 00 00       	call   8022a6 <find_block>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8016dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8016e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e9:	8b 40 08             	mov    0x8(%eax),%eax
  8016ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8016ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f3:	0f 84 a1 00 00 00    	je     80179a <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8016f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016fd:	75 17                	jne    801716 <free+0x5b>
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	68 d5 3a 80 00       	push   $0x803ad5
  801707:	68 80 00 00 00       	push   $0x80
  80170c:	68 f3 3a 80 00       	push   $0x803af3
  801711:	e8 71 1a 00 00       	call   803187 <_panic>
  801716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801719:	8b 00                	mov    (%eax),%eax
  80171b:	85 c0                	test   %eax,%eax
  80171d:	74 10                	je     80172f <free+0x74>
  80171f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801722:	8b 00                	mov    (%eax),%eax
  801724:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801727:	8b 52 04             	mov    0x4(%edx),%edx
  80172a:	89 50 04             	mov    %edx,0x4(%eax)
  80172d:	eb 0b                	jmp    80173a <free+0x7f>
  80172f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801732:	8b 40 04             	mov    0x4(%eax),%eax
  801735:	a3 44 40 80 00       	mov    %eax,0x804044
  80173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173d:	8b 40 04             	mov    0x4(%eax),%eax
  801740:	85 c0                	test   %eax,%eax
  801742:	74 0f                	je     801753 <free+0x98>
  801744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801747:	8b 40 04             	mov    0x4(%eax),%eax
  80174a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174d:	8b 12                	mov    (%edx),%edx
  80174f:	89 10                	mov    %edx,(%eax)
  801751:	eb 0a                	jmp    80175d <free+0xa2>
  801753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801756:	8b 00                	mov    (%eax),%eax
  801758:	a3 40 40 80 00       	mov    %eax,0x804040
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801760:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801766:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801769:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801770:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801775:	48                   	dec    %eax
  801776:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80177b:	83 ec 0c             	sub    $0xc,%esp
  80177e:	ff 75 f0             	pushl  -0x10(%ebp)
  801781:	e8 29 12 00 00       	call   8029af <insert_sorted_with_merge_freeList>
  801786:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	ff 75 ec             	pushl  -0x14(%ebp)
  80178f:	ff 75 e8             	pushl  -0x18(%ebp)
  801792:	e8 74 03 00 00       	call   801b0b <sys_free_user_mem>
  801797:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80179a:	90                   	nop
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 38             	sub    $0x38,%esp
  8017a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a9:	e8 5f fc ff ff       	call   80140d <InitializeUHeap>
	if (size == 0) return NULL ;
  8017ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017b2:	75 0a                	jne    8017be <smalloc+0x21>
  8017b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b9:	e9 b2 00 00 00       	jmp    801870 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8017be:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8017c5:	76 0a                	jbe    8017d1 <smalloc+0x34>
		return NULL;
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cc:	e9 9f 00 00 00       	jmp    801870 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017d1:	e8 3b 07 00 00       	call   801f11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	0f 84 8d 00 00 00    	je     80186b <smalloc+0xce>
	struct MemBlock *b = NULL;
  8017de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8017e5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f2:	01 d0                	add    %edx,%eax
  8017f4:	48                   	dec    %eax
  8017f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801800:	f7 75 f0             	divl   -0x10(%ebp)
  801803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801806:	29 d0                	sub    %edx,%eax
  801808:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  80180b:	83 ec 0c             	sub    $0xc,%esp
  80180e:	ff 75 e8             	pushl  -0x18(%ebp)
  801811:	e8 5b 0c 00 00       	call   802471 <alloc_block_FF>
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  80181c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801820:	75 07                	jne    801829 <smalloc+0x8c>
			return NULL;
  801822:	b8 00 00 00 00       	mov    $0x0,%eax
  801827:	eb 47                	jmp    801870 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801829:	83 ec 0c             	sub    $0xc,%esp
  80182c:	ff 75 f4             	pushl  -0xc(%ebp)
  80182f:	e8 a5 0a 00 00       	call   8022d9 <insert_sorted_allocList>
  801834:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80183a:	8b 40 08             	mov    0x8(%eax),%eax
  80183d:	89 c2                	mov    %eax,%edx
  80183f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801843:	52                   	push   %edx
  801844:	50                   	push   %eax
  801845:	ff 75 0c             	pushl  0xc(%ebp)
  801848:	ff 75 08             	pushl  0x8(%ebp)
  80184b:	e8 46 04 00 00       	call   801c96 <sys_createSharedObject>
  801850:	83 c4 10             	add    $0x10,%esp
  801853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801856:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80185a:	78 08                	js     801864 <smalloc+0xc7>
		return (void *)b->sva;
  80185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185f:	8b 40 08             	mov    0x8(%eax),%eax
  801862:	eb 0c                	jmp    801870 <smalloc+0xd3>
		}else{
		return NULL;
  801864:	b8 00 00 00 00       	mov    $0x0,%eax
  801869:	eb 05                	jmp    801870 <smalloc+0xd3>
			}

	}return NULL;
  80186b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801878:	e8 90 fb ff ff       	call   80140d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80187d:	e8 8f 06 00 00       	call   801f11 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801882:	85 c0                	test   %eax,%eax
  801884:	0f 84 ad 00 00 00    	je     801937 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80188a:	83 ec 08             	sub    $0x8,%esp
  80188d:	ff 75 0c             	pushl  0xc(%ebp)
  801890:	ff 75 08             	pushl  0x8(%ebp)
  801893:	e8 28 04 00 00       	call   801cc0 <sys_getSizeOfSharedObject>
  801898:	83 c4 10             	add    $0x10,%esp
  80189b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80189e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018a2:	79 0a                	jns    8018ae <sget+0x3c>
    {
    	return NULL;
  8018a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a9:	e9 8e 00 00 00       	jmp    80193c <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8018ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8018b5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c2:	01 d0                	add    %edx,%eax
  8018c4:	48                   	dec    %eax
  8018c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d0:	f7 75 ec             	divl   -0x14(%ebp)
  8018d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018d6:	29 d0                	sub    %edx,%eax
  8018d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8018db:	83 ec 0c             	sub    $0xc,%esp
  8018de:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018e1:	e8 8b 0b 00 00       	call   802471 <alloc_block_FF>
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8018ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018f0:	75 07                	jne    8018f9 <sget+0x87>
				return NULL;
  8018f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f7:	eb 43                	jmp    80193c <sget+0xca>
			}
			insert_sorted_allocList(b);
  8018f9:	83 ec 0c             	sub    $0xc,%esp
  8018fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8018ff:	e8 d5 09 00 00       	call   8022d9 <insert_sorted_allocList>
  801904:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190a:	8b 40 08             	mov    0x8(%eax),%eax
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	50                   	push   %eax
  801911:	ff 75 0c             	pushl  0xc(%ebp)
  801914:	ff 75 08             	pushl  0x8(%ebp)
  801917:	e8 c1 03 00 00       	call   801cdd <sys_getSharedObject>
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801922:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801926:	78 08                	js     801930 <sget+0xbe>
			return (void *)b->sva;
  801928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192b:	8b 40 08             	mov    0x8(%eax),%eax
  80192e:	eb 0c                	jmp    80193c <sget+0xca>
			}else{
			return NULL;
  801930:	b8 00 00 00 00       	mov    $0x0,%eax
  801935:	eb 05                	jmp    80193c <sget+0xca>
			}
    }}return NULL;
  801937:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801944:	e8 c4 fa ff ff       	call   80140d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801949:	83 ec 04             	sub    $0x4,%esp
  80194c:	68 24 3b 80 00       	push   $0x803b24
  801951:	68 03 01 00 00       	push   $0x103
  801956:	68 f3 3a 80 00       	push   $0x803af3
  80195b:	e8 27 18 00 00       	call   803187 <_panic>

00801960 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801966:	83 ec 04             	sub    $0x4,%esp
  801969:	68 4c 3b 80 00       	push   $0x803b4c
  80196e:	68 17 01 00 00       	push   $0x117
  801973:	68 f3 3a 80 00       	push   $0x803af3
  801978:	e8 0a 18 00 00       	call   803187 <_panic>

0080197d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	68 70 3b 80 00       	push   $0x803b70
  80198b:	68 22 01 00 00       	push   $0x122
  801990:	68 f3 3a 80 00       	push   $0x803af3
  801995:	e8 ed 17 00 00       	call   803187 <_panic>

0080199a <shrink>:

}
void shrink(uint32 newSize)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019a0:	83 ec 04             	sub    $0x4,%esp
  8019a3:	68 70 3b 80 00       	push   $0x803b70
  8019a8:	68 27 01 00 00       	push   $0x127
  8019ad:	68 f3 3a 80 00       	push   $0x803af3
  8019b2:	e8 d0 17 00 00       	call   803187 <_panic>

008019b7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	68 70 3b 80 00       	push   $0x803b70
  8019c5:	68 2c 01 00 00       	push   $0x12c
  8019ca:	68 f3 3a 80 00       	push   $0x803af3
  8019cf:	e8 b3 17 00 00       	call   803187 <_panic>

008019d4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	57                   	push   %edi
  8019d8:	56                   	push   %esi
  8019d9:	53                   	push   %ebx
  8019da:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019e9:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019ec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019ef:	cd 30                	int    $0x30
  8019f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019f7:	83 c4 10             	add    $0x10,%esp
  8019fa:	5b                   	pop    %ebx
  8019fb:	5e                   	pop    %esi
  8019fc:	5f                   	pop    %edi
  8019fd:	5d                   	pop    %ebp
  8019fe:	c3                   	ret    

008019ff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019ff:	55                   	push   %ebp
  801a00:	89 e5                	mov    %esp,%ebp
  801a02:	83 ec 04             	sub    $0x4,%esp
  801a05:	8b 45 10             	mov    0x10(%ebp),%eax
  801a08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a0b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	52                   	push   %edx
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	50                   	push   %eax
  801a1b:	6a 00                	push   $0x0
  801a1d:	e8 b2 ff ff ff       	call   8019d4 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	90                   	nop
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 01                	push   $0x1
  801a37:	e8 98 ff ff ff       	call   8019d4 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	52                   	push   %edx
  801a51:	50                   	push   %eax
  801a52:	6a 05                	push   $0x5
  801a54:	e8 7b ff ff ff       	call   8019d4 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
}
  801a5c:	c9                   	leave  
  801a5d:	c3                   	ret    

00801a5e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	56                   	push   %esi
  801a62:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a63:	8b 75 18             	mov    0x18(%ebp),%esi
  801a66:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	56                   	push   %esi
  801a73:	53                   	push   %ebx
  801a74:	51                   	push   %ecx
  801a75:	52                   	push   %edx
  801a76:	50                   	push   %eax
  801a77:	6a 06                	push   $0x6
  801a79:	e8 56 ff ff ff       	call   8019d4 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    

00801a88 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	52                   	push   %edx
  801a98:	50                   	push   %eax
  801a99:	6a 07                	push   $0x7
  801a9b:	e8 34 ff ff ff       	call   8019d4 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	6a 08                	push   $0x8
  801ab6:	e8 19 ff ff ff       	call   8019d4 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 09                	push   $0x9
  801acf:	e8 00 ff ff ff       	call   8019d4 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 0a                	push   $0xa
  801ae8:	e8 e7 fe ff ff       	call   8019d4 <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 0b                	push   $0xb
  801b01:	e8 ce fe ff ff       	call   8019d4 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	ff 75 08             	pushl  0x8(%ebp)
  801b1a:	6a 0f                	push   $0xf
  801b1c:	e8 b3 fe ff ff       	call   8019d4 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
	return;
  801b24:	90                   	nop
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	ff 75 0c             	pushl  0xc(%ebp)
  801b33:	ff 75 08             	pushl  0x8(%ebp)
  801b36:	6a 10                	push   $0x10
  801b38:	e8 97 fe ff ff       	call   8019d4 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801b40:	90                   	nop
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	ff 75 10             	pushl  0x10(%ebp)
  801b4d:	ff 75 0c             	pushl  0xc(%ebp)
  801b50:	ff 75 08             	pushl  0x8(%ebp)
  801b53:	6a 11                	push   $0x11
  801b55:	e8 7a fe ff ff       	call   8019d4 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b5d:	90                   	nop
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 0c                	push   $0xc
  801b6f:	e8 60 fe ff ff       	call   8019d4 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	c9                   	leave  
  801b78:	c3                   	ret    

00801b79 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	ff 75 08             	pushl  0x8(%ebp)
  801b87:	6a 0d                	push   $0xd
  801b89:	e8 46 fe ff ff       	call   8019d4 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 0e                	push   $0xe
  801ba2:	e8 2d fe ff ff       	call   8019d4 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	90                   	nop
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 13                	push   $0x13
  801bbc:	e8 13 fe ff ff       	call   8019d4 <syscall>
  801bc1:	83 c4 18             	add    $0x18,%esp
}
  801bc4:	90                   	nop
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 14                	push   $0x14
  801bd6:	e8 f9 fd ff ff       	call   8019d4 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	90                   	nop
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_cputc>:


void
sys_cputc(const char c)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 04             	sub    $0x4,%esp
  801be7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	50                   	push   %eax
  801bfa:	6a 15                	push   $0x15
  801bfc:	e8 d3 fd ff ff       	call   8019d4 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	90                   	nop
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 16                	push   $0x16
  801c16:	e8 b9 fd ff ff       	call   8019d4 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	90                   	nop
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	ff 75 0c             	pushl  0xc(%ebp)
  801c30:	50                   	push   %eax
  801c31:	6a 17                	push   $0x17
  801c33:	e8 9c fd ff ff       	call   8019d4 <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	52                   	push   %edx
  801c4d:	50                   	push   %eax
  801c4e:	6a 1a                	push   $0x1a
  801c50:	e8 7f fd ff ff       	call   8019d4 <syscall>
  801c55:	83 c4 18             	add    $0x18,%esp
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c60:	8b 45 08             	mov    0x8(%ebp),%eax
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	52                   	push   %edx
  801c6a:	50                   	push   %eax
  801c6b:	6a 18                	push   $0x18
  801c6d:	e8 62 fd ff ff       	call   8019d4 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	90                   	nop
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	52                   	push   %edx
  801c88:	50                   	push   %eax
  801c89:	6a 19                	push   $0x19
  801c8b:	e8 44 fd ff ff       	call   8019d4 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	90                   	nop
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ca2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ca5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cac:	6a 00                	push   $0x0
  801cae:	51                   	push   %ecx
  801caf:	52                   	push   %edx
  801cb0:	ff 75 0c             	pushl  0xc(%ebp)
  801cb3:	50                   	push   %eax
  801cb4:	6a 1b                	push   $0x1b
  801cb6:	e8 19 fd ff ff       	call   8019d4 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	52                   	push   %edx
  801cd0:	50                   	push   %eax
  801cd1:	6a 1c                	push   $0x1c
  801cd3:	e8 fc fc ff ff       	call   8019d4 <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ce0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	51                   	push   %ecx
  801cee:	52                   	push   %edx
  801cef:	50                   	push   %eax
  801cf0:	6a 1d                	push   $0x1d
  801cf2:	e8 dd fc ff ff       	call   8019d4 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	52                   	push   %edx
  801d0c:	50                   	push   %eax
  801d0d:	6a 1e                	push   $0x1e
  801d0f:	e8 c0 fc ff ff       	call   8019d4 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 1f                	push   $0x1f
  801d28:	e8 a7 fc ff ff       	call   8019d4 <syscall>
  801d2d:	83 c4 18             	add    $0x18,%esp
}
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	6a 00                	push   $0x0
  801d3a:	ff 75 14             	pushl  0x14(%ebp)
  801d3d:	ff 75 10             	pushl  0x10(%ebp)
  801d40:	ff 75 0c             	pushl  0xc(%ebp)
  801d43:	50                   	push   %eax
  801d44:	6a 20                	push   $0x20
  801d46:	e8 89 fc ff ff       	call   8019d4 <syscall>
  801d4b:	83 c4 18             	add    $0x18,%esp
}
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	50                   	push   %eax
  801d5f:	6a 21                	push   $0x21
  801d61:	e8 6e fc ff ff       	call   8019d4 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
}
  801d69:	90                   	nop
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	50                   	push   %eax
  801d7b:	6a 22                	push   $0x22
  801d7d:	e8 52 fc ff ff       	call   8019d4 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 02                	push   $0x2
  801d96:	e8 39 fc ff ff       	call   8019d4 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 03                	push   $0x3
  801daf:	e8 20 fc ff ff       	call   8019d4 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 04                	push   $0x4
  801dc8:	e8 07 fc ff ff       	call   8019d4 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_exit_env>:


void sys_exit_env(void)
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 23                	push   $0x23
  801de1:	e8 ee fb ff ff       	call   8019d4 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	90                   	nop
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801df2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801df5:	8d 50 04             	lea    0x4(%eax),%edx
  801df8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	52                   	push   %edx
  801e02:	50                   	push   %eax
  801e03:	6a 24                	push   $0x24
  801e05:	e8 ca fb ff ff       	call   8019d4 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
	return result;
  801e0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e10:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e16:	89 01                	mov    %eax,(%ecx)
  801e18:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1e:	c9                   	leave  
  801e1f:	c2 04 00             	ret    $0x4

00801e22 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	ff 75 10             	pushl  0x10(%ebp)
  801e2c:	ff 75 0c             	pushl  0xc(%ebp)
  801e2f:	ff 75 08             	pushl  0x8(%ebp)
  801e32:	6a 12                	push   $0x12
  801e34:	e8 9b fb ff ff       	call   8019d4 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3c:	90                   	nop
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <sys_rcr2>:
uint32 sys_rcr2()
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 25                	push   $0x25
  801e4e:	e8 81 fb ff ff       	call   8019d4 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
  801e5b:	83 ec 04             	sub    $0x4,%esp
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e64:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	50                   	push   %eax
  801e71:	6a 26                	push   $0x26
  801e73:	e8 5c fb ff ff       	call   8019d4 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7b:	90                   	nop
}
  801e7c:	c9                   	leave  
  801e7d:	c3                   	ret    

00801e7e <rsttst>:
void rsttst()
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 28                	push   $0x28
  801e8d:	e8 42 fb ff ff       	call   8019d4 <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
	return ;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ea1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ea4:	8b 55 18             	mov    0x18(%ebp),%edx
  801ea7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801eab:	52                   	push   %edx
  801eac:	50                   	push   %eax
  801ead:	ff 75 10             	pushl  0x10(%ebp)
  801eb0:	ff 75 0c             	pushl  0xc(%ebp)
  801eb3:	ff 75 08             	pushl  0x8(%ebp)
  801eb6:	6a 27                	push   $0x27
  801eb8:	e8 17 fb ff ff       	call   8019d4 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec0:	90                   	nop
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <chktst>:
void chktst(uint32 n)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	ff 75 08             	pushl  0x8(%ebp)
  801ed1:	6a 29                	push   $0x29
  801ed3:	e8 fc fa ff ff       	call   8019d4 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
	return ;
  801edb:	90                   	nop
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <inctst>:

void inctst()
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 2a                	push   $0x2a
  801eed:	e8 e2 fa ff ff       	call   8019d4 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef5:	90                   	nop
}
  801ef6:	c9                   	leave  
  801ef7:	c3                   	ret    

00801ef8 <gettst>:
uint32 gettst()
{
  801ef8:	55                   	push   %ebp
  801ef9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 2b                	push   $0x2b
  801f07:	e8 c8 fa ff ff       	call   8019d4 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	c9                   	leave  
  801f10:	c3                   	ret    

00801f11 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f11:	55                   	push   %ebp
  801f12:	89 e5                	mov    %esp,%ebp
  801f14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f17:	6a 00                	push   $0x0
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 2c                	push   $0x2c
  801f23:	e8 ac fa ff ff       	call   8019d4 <syscall>
  801f28:	83 c4 18             	add    $0x18,%esp
  801f2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f2e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f32:	75 07                	jne    801f3b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f34:	b8 01 00 00 00       	mov    $0x1,%eax
  801f39:	eb 05                	jmp    801f40 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	6a 00                	push   $0x0
  801f52:	6a 2c                	push   $0x2c
  801f54:	e8 7b fa ff ff       	call   8019d4 <syscall>
  801f59:	83 c4 18             	add    $0x18,%esp
  801f5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f5f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f63:	75 07                	jne    801f6c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f65:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6a:	eb 05                	jmp    801f71 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	6a 2c                	push   $0x2c
  801f85:	e8 4a fa ff ff       	call   8019d4 <syscall>
  801f8a:	83 c4 18             	add    $0x18,%esp
  801f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f90:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f94:	75 07                	jne    801f9d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f96:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9b:	eb 05                	jmp    801fa2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 00                	push   $0x0
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 2c                	push   $0x2c
  801fb6:	e8 19 fa ff ff       	call   8019d4 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
  801fbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fc1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fc5:	75 07                	jne    801fce <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fc7:	b8 01 00 00 00       	mov    $0x1,%eax
  801fcc:	eb 05                	jmp    801fd3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801fce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fd3:	c9                   	leave  
  801fd4:	c3                   	ret    

00801fd5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fd5:	55                   	push   %ebp
  801fd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	ff 75 08             	pushl  0x8(%ebp)
  801fe3:	6a 2d                	push   $0x2d
  801fe5:	e8 ea f9 ff ff       	call   8019d4 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
	return ;
  801fed:	90                   	nop
}
  801fee:	c9                   	leave  
  801fef:	c3                   	ret    

00801ff0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ff4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ff7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ffa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  802000:	6a 00                	push   $0x0
  802002:	53                   	push   %ebx
  802003:	51                   	push   %ecx
  802004:	52                   	push   %edx
  802005:	50                   	push   %eax
  802006:	6a 2e                	push   $0x2e
  802008:	e8 c7 f9 ff ff       	call   8019d4 <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
}
  802010:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802018:	8b 55 0c             	mov    0xc(%ebp),%edx
  80201b:	8b 45 08             	mov    0x8(%ebp),%eax
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	52                   	push   %edx
  802025:	50                   	push   %eax
  802026:	6a 2f                	push   $0x2f
  802028:	e8 a7 f9 ff ff       	call   8019d4 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802038:	83 ec 0c             	sub    $0xc,%esp
  80203b:	68 80 3b 80 00       	push   $0x803b80
  802040:	e8 3e e6 ff ff       	call   800683 <cprintf>
  802045:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802048:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80204f:	83 ec 0c             	sub    $0xc,%esp
  802052:	68 ac 3b 80 00       	push   $0x803bac
  802057:	e8 27 e6 ff ff       	call   800683 <cprintf>
  80205c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80205f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802063:	a1 38 41 80 00       	mov    0x804138,%eax
  802068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80206b:	eb 56                	jmp    8020c3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80206d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802071:	74 1c                	je     80208f <print_mem_block_lists+0x5d>
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	8b 50 08             	mov    0x8(%eax),%edx
  802079:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207c:	8b 48 08             	mov    0x8(%eax),%ecx
  80207f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802082:	8b 40 0c             	mov    0xc(%eax),%eax
  802085:	01 c8                	add    %ecx,%eax
  802087:	39 c2                	cmp    %eax,%edx
  802089:	73 04                	jae    80208f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80208b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80208f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802092:	8b 50 08             	mov    0x8(%eax),%edx
  802095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802098:	8b 40 0c             	mov    0xc(%eax),%eax
  80209b:	01 c2                	add    %eax,%edx
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	8b 40 08             	mov    0x8(%eax),%eax
  8020a3:	83 ec 04             	sub    $0x4,%esp
  8020a6:	52                   	push   %edx
  8020a7:	50                   	push   %eax
  8020a8:	68 c1 3b 80 00       	push   $0x803bc1
  8020ad:	e8 d1 e5 ff ff       	call   800683 <cprintf>
  8020b2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020bb:	a1 40 41 80 00       	mov    0x804140,%eax
  8020c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c7:	74 07                	je     8020d0 <print_mem_block_lists+0x9e>
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	8b 00                	mov    (%eax),%eax
  8020ce:	eb 05                	jmp    8020d5 <print_mem_block_lists+0xa3>
  8020d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d5:	a3 40 41 80 00       	mov    %eax,0x804140
  8020da:	a1 40 41 80 00       	mov    0x804140,%eax
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	75 8a                	jne    80206d <print_mem_block_lists+0x3b>
  8020e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e7:	75 84                	jne    80206d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020e9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ed:	75 10                	jne    8020ff <print_mem_block_lists+0xcd>
  8020ef:	83 ec 0c             	sub    $0xc,%esp
  8020f2:	68 d0 3b 80 00       	push   $0x803bd0
  8020f7:	e8 87 e5 ff ff       	call   800683 <cprintf>
  8020fc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	68 f4 3b 80 00       	push   $0x803bf4
  80210e:	e8 70 e5 ff ff       	call   800683 <cprintf>
  802113:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802116:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80211a:	a1 40 40 80 00       	mov    0x804040,%eax
  80211f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802122:	eb 56                	jmp    80217a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802124:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802128:	74 1c                	je     802146 <print_mem_block_lists+0x114>
  80212a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212d:	8b 50 08             	mov    0x8(%eax),%edx
  802130:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802133:	8b 48 08             	mov    0x8(%eax),%ecx
  802136:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802139:	8b 40 0c             	mov    0xc(%eax),%eax
  80213c:	01 c8                	add    %ecx,%eax
  80213e:	39 c2                	cmp    %eax,%edx
  802140:	73 04                	jae    802146 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802142:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802146:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802149:	8b 50 08             	mov    0x8(%eax),%edx
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 40 0c             	mov    0xc(%eax),%eax
  802152:	01 c2                	add    %eax,%edx
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	8b 40 08             	mov    0x8(%eax),%eax
  80215a:	83 ec 04             	sub    $0x4,%esp
  80215d:	52                   	push   %edx
  80215e:	50                   	push   %eax
  80215f:	68 c1 3b 80 00       	push   $0x803bc1
  802164:	e8 1a e5 ff ff       	call   800683 <cprintf>
  802169:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80216c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802172:	a1 48 40 80 00       	mov    0x804048,%eax
  802177:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80217e:	74 07                	je     802187 <print_mem_block_lists+0x155>
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	8b 00                	mov    (%eax),%eax
  802185:	eb 05                	jmp    80218c <print_mem_block_lists+0x15a>
  802187:	b8 00 00 00 00       	mov    $0x0,%eax
  80218c:	a3 48 40 80 00       	mov    %eax,0x804048
  802191:	a1 48 40 80 00       	mov    0x804048,%eax
  802196:	85 c0                	test   %eax,%eax
  802198:	75 8a                	jne    802124 <print_mem_block_lists+0xf2>
  80219a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80219e:	75 84                	jne    802124 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021a0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021a4:	75 10                	jne    8021b6 <print_mem_block_lists+0x184>
  8021a6:	83 ec 0c             	sub    $0xc,%esp
  8021a9:	68 0c 3c 80 00       	push   $0x803c0c
  8021ae:	e8 d0 e4 ff ff       	call   800683 <cprintf>
  8021b3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021b6:	83 ec 0c             	sub    $0xc,%esp
  8021b9:	68 80 3b 80 00       	push   $0x803b80
  8021be:	e8 c0 e4 ff ff       	call   800683 <cprintf>
  8021c3:	83 c4 10             	add    $0x10,%esp

}
  8021c6:	90                   	nop
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8021cf:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021d6:	00 00 00 
  8021d9:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8021e0:	00 00 00 
  8021e3:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8021ea:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8021ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021f4:	e9 9e 00 00 00       	jmp    802297 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8021f9:	a1 50 40 80 00       	mov    0x804050,%eax
  8021fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802201:	c1 e2 04             	shl    $0x4,%edx
  802204:	01 d0                	add    %edx,%eax
  802206:	85 c0                	test   %eax,%eax
  802208:	75 14                	jne    80221e <initialize_MemBlocksList+0x55>
  80220a:	83 ec 04             	sub    $0x4,%esp
  80220d:	68 34 3c 80 00       	push   $0x803c34
  802212:	6a 3d                	push   $0x3d
  802214:	68 57 3c 80 00       	push   $0x803c57
  802219:	e8 69 0f 00 00       	call   803187 <_panic>
  80221e:	a1 50 40 80 00       	mov    0x804050,%eax
  802223:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802226:	c1 e2 04             	shl    $0x4,%edx
  802229:	01 d0                	add    %edx,%eax
  80222b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802231:	89 10                	mov    %edx,(%eax)
  802233:	8b 00                	mov    (%eax),%eax
  802235:	85 c0                	test   %eax,%eax
  802237:	74 18                	je     802251 <initialize_MemBlocksList+0x88>
  802239:	a1 48 41 80 00       	mov    0x804148,%eax
  80223e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802244:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802247:	c1 e1 04             	shl    $0x4,%ecx
  80224a:	01 ca                	add    %ecx,%edx
  80224c:	89 50 04             	mov    %edx,0x4(%eax)
  80224f:	eb 12                	jmp    802263 <initialize_MemBlocksList+0x9a>
  802251:	a1 50 40 80 00       	mov    0x804050,%eax
  802256:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802259:	c1 e2 04             	shl    $0x4,%edx
  80225c:	01 d0                	add    %edx,%eax
  80225e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802263:	a1 50 40 80 00       	mov    0x804050,%eax
  802268:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226b:	c1 e2 04             	shl    $0x4,%edx
  80226e:	01 d0                	add    %edx,%eax
  802270:	a3 48 41 80 00       	mov    %eax,0x804148
  802275:	a1 50 40 80 00       	mov    0x804050,%eax
  80227a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227d:	c1 e2 04             	shl    $0x4,%edx
  802280:	01 d0                	add    %edx,%eax
  802282:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802289:	a1 54 41 80 00       	mov    0x804154,%eax
  80228e:	40                   	inc    %eax
  80228f:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802294:	ff 45 f4             	incl   -0xc(%ebp)
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80229d:	0f 82 56 ff ff ff    	jb     8021f9 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8022a3:	90                   	nop
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8b 00                	mov    (%eax),%eax
  8022b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8022b4:	eb 18                	jmp    8022ce <find_block+0x28>

		if(tmp->sva == va){
  8022b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022b9:	8b 40 08             	mov    0x8(%eax),%eax
  8022bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022bf:	75 05                	jne    8022c6 <find_block+0x20>
			return tmp ;
  8022c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022c4:	eb 11                	jmp    8022d7 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8022c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8022ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022d2:	75 e2                	jne    8022b6 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8022d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022d7:	c9                   	leave  
  8022d8:	c3                   	ret    

008022d9 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8022df:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8022e7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8022ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022f3:	75 65                	jne    80235a <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8022f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f9:	75 14                	jne    80230f <insert_sorted_allocList+0x36>
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 34 3c 80 00       	push   $0x803c34
  802303:	6a 62                	push   $0x62
  802305:	68 57 3c 80 00       	push   $0x803c57
  80230a:	e8 78 0e 00 00       	call   803187 <_panic>
  80230f:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	89 10                	mov    %edx,(%eax)
  80231a:	8b 45 08             	mov    0x8(%ebp),%eax
  80231d:	8b 00                	mov    (%eax),%eax
  80231f:	85 c0                	test   %eax,%eax
  802321:	74 0d                	je     802330 <insert_sorted_allocList+0x57>
  802323:	a1 40 40 80 00       	mov    0x804040,%eax
  802328:	8b 55 08             	mov    0x8(%ebp),%edx
  80232b:	89 50 04             	mov    %edx,0x4(%eax)
  80232e:	eb 08                	jmp    802338 <insert_sorted_allocList+0x5f>
  802330:	8b 45 08             	mov    0x8(%ebp),%eax
  802333:	a3 44 40 80 00       	mov    %eax,0x804044
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	a3 40 40 80 00       	mov    %eax,0x804040
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80234a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80234f:	40                   	inc    %eax
  802350:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802355:	e9 14 01 00 00       	jmp    80246e <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	8b 50 08             	mov    0x8(%eax),%edx
  802360:	a1 44 40 80 00       	mov    0x804044,%eax
  802365:	8b 40 08             	mov    0x8(%eax),%eax
  802368:	39 c2                	cmp    %eax,%edx
  80236a:	76 65                	jbe    8023d1 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80236c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802370:	75 14                	jne    802386 <insert_sorted_allocList+0xad>
  802372:	83 ec 04             	sub    $0x4,%esp
  802375:	68 70 3c 80 00       	push   $0x803c70
  80237a:	6a 64                	push   $0x64
  80237c:	68 57 3c 80 00       	push   $0x803c57
  802381:	e8 01 0e 00 00       	call   803187 <_panic>
  802386:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	89 50 04             	mov    %edx,0x4(%eax)
  802392:	8b 45 08             	mov    0x8(%ebp),%eax
  802395:	8b 40 04             	mov    0x4(%eax),%eax
  802398:	85 c0                	test   %eax,%eax
  80239a:	74 0c                	je     8023a8 <insert_sorted_allocList+0xcf>
  80239c:	a1 44 40 80 00       	mov    0x804044,%eax
  8023a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a4:	89 10                	mov    %edx,(%eax)
  8023a6:	eb 08                	jmp    8023b0 <insert_sorted_allocList+0xd7>
  8023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ab:	a3 40 40 80 00       	mov    %eax,0x804040
  8023b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b3:	a3 44 40 80 00       	mov    %eax,0x804044
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023c1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023c6:	40                   	inc    %eax
  8023c7:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8023cc:	e9 9d 00 00 00       	jmp    80246e <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8023d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8023d8:	e9 85 00 00 00       	jmp    802462 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	8b 50 08             	mov    0x8(%eax),%edx
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 40 08             	mov    0x8(%eax),%eax
  8023e9:	39 c2                	cmp    %eax,%edx
  8023eb:	73 6a                	jae    802457 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8023ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f1:	74 06                	je     8023f9 <insert_sorted_allocList+0x120>
  8023f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023f7:	75 14                	jne    80240d <insert_sorted_allocList+0x134>
  8023f9:	83 ec 04             	sub    $0x4,%esp
  8023fc:	68 94 3c 80 00       	push   $0x803c94
  802401:	6a 6b                	push   $0x6b
  802403:	68 57 3c 80 00       	push   $0x803c57
  802408:	e8 7a 0d 00 00       	call   803187 <_panic>
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 50 04             	mov    0x4(%eax),%edx
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	89 50 04             	mov    %edx,0x4(%eax)
  802419:	8b 45 08             	mov    0x8(%ebp),%eax
  80241c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241f:	89 10                	mov    %edx,(%eax)
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	8b 40 04             	mov    0x4(%eax),%eax
  802427:	85 c0                	test   %eax,%eax
  802429:	74 0d                	je     802438 <insert_sorted_allocList+0x15f>
  80242b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242e:	8b 40 04             	mov    0x4(%eax),%eax
  802431:	8b 55 08             	mov    0x8(%ebp),%edx
  802434:	89 10                	mov    %edx,(%eax)
  802436:	eb 08                	jmp    802440 <insert_sorted_allocList+0x167>
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	a3 40 40 80 00       	mov    %eax,0x804040
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	8b 55 08             	mov    0x8(%ebp),%edx
  802446:	89 50 04             	mov    %edx,0x4(%eax)
  802449:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80244e:	40                   	inc    %eax
  80244f:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802454:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802455:	eb 17                	jmp    80246e <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80245f:	ff 45 f0             	incl   -0x10(%ebp)
  802462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802465:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802468:	0f 8c 6f ff ff ff    	jl     8023dd <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80246e:	90                   	nop
  80246f:	c9                   	leave  
  802470:	c3                   	ret    

00802471 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802477:	a1 38 41 80 00       	mov    0x804138,%eax
  80247c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80247f:	e9 7c 01 00 00       	jmp    802600 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80248d:	0f 86 cf 00 00 00    	jbe    802562 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802493:	a1 48 41 80 00       	mov    0x804148,%eax
  802498:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80249b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249e:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8024a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a7:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 50 08             	mov    0x8(%eax),%edx
  8024b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b3:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8024bf:	89 c2                	mov    %eax,%edx
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 50 08             	mov    0x8(%eax),%edx
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	01 c2                	add    %eax,%edx
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8024d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024dc:	75 17                	jne    8024f5 <alloc_block_FF+0x84>
  8024de:	83 ec 04             	sub    $0x4,%esp
  8024e1:	68 c9 3c 80 00       	push   $0x803cc9
  8024e6:	68 83 00 00 00       	push   $0x83
  8024eb:	68 57 3c 80 00       	push   $0x803c57
  8024f0:	e8 92 0c 00 00       	call   803187 <_panic>
  8024f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f8:	8b 00                	mov    (%eax),%eax
  8024fa:	85 c0                	test   %eax,%eax
  8024fc:	74 10                	je     80250e <alloc_block_FF+0x9d>
  8024fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802501:	8b 00                	mov    (%eax),%eax
  802503:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802506:	8b 52 04             	mov    0x4(%edx),%edx
  802509:	89 50 04             	mov    %edx,0x4(%eax)
  80250c:	eb 0b                	jmp    802519 <alloc_block_FF+0xa8>
  80250e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802511:	8b 40 04             	mov    0x4(%eax),%eax
  802514:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802519:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251c:	8b 40 04             	mov    0x4(%eax),%eax
  80251f:	85 c0                	test   %eax,%eax
  802521:	74 0f                	je     802532 <alloc_block_FF+0xc1>
  802523:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802526:	8b 40 04             	mov    0x4(%eax),%eax
  802529:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80252c:	8b 12                	mov    (%edx),%edx
  80252e:	89 10                	mov    %edx,(%eax)
  802530:	eb 0a                	jmp    80253c <alloc_block_FF+0xcb>
  802532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	a3 48 41 80 00       	mov    %eax,0x804148
  80253c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802545:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802548:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80254f:	a1 54 41 80 00       	mov    0x804154,%eax
  802554:	48                   	dec    %eax
  802555:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  80255a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255d:	e9 ad 00 00 00       	jmp    80260f <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 40 0c             	mov    0xc(%eax),%eax
  802568:	3b 45 08             	cmp    0x8(%ebp),%eax
  80256b:	0f 85 87 00 00 00    	jne    8025f8 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802571:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802575:	75 17                	jne    80258e <alloc_block_FF+0x11d>
  802577:	83 ec 04             	sub    $0x4,%esp
  80257a:	68 c9 3c 80 00       	push   $0x803cc9
  80257f:	68 87 00 00 00       	push   $0x87
  802584:	68 57 3c 80 00       	push   $0x803c57
  802589:	e8 f9 0b 00 00       	call   803187 <_panic>
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 00                	mov    (%eax),%eax
  802593:	85 c0                	test   %eax,%eax
  802595:	74 10                	je     8025a7 <alloc_block_FF+0x136>
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 00                	mov    (%eax),%eax
  80259c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259f:	8b 52 04             	mov    0x4(%edx),%edx
  8025a2:	89 50 04             	mov    %edx,0x4(%eax)
  8025a5:	eb 0b                	jmp    8025b2 <alloc_block_FF+0x141>
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 40 04             	mov    0x4(%eax),%eax
  8025ad:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 40 04             	mov    0x4(%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	74 0f                	je     8025cb <alloc_block_FF+0x15a>
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 40 04             	mov    0x4(%eax),%eax
  8025c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c5:	8b 12                	mov    (%edx),%edx
  8025c7:	89 10                	mov    %edx,(%eax)
  8025c9:	eb 0a                	jmp    8025d5 <alloc_block_FF+0x164>
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 00                	mov    (%eax),%eax
  8025d0:	a3 38 41 80 00       	mov    %eax,0x804138
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e8:	a1 44 41 80 00       	mov    0x804144,%eax
  8025ed:	48                   	dec    %eax
  8025ee:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	eb 17                	jmp    80260f <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802600:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802604:	0f 85 7a fe ff ff    	jne    802484 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  80260a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80260f:	c9                   	leave  
  802610:	c3                   	ret    

00802611 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802611:	55                   	push   %ebp
  802612:	89 e5                	mov    %esp,%ebp
  802614:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802617:	a1 38 41 80 00       	mov    0x804138,%eax
  80261c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  80261f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802626:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80262d:	a1 38 41 80 00       	mov    0x804138,%eax
  802632:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802635:	e9 d0 00 00 00       	jmp    80270a <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80263a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263d:	8b 40 0c             	mov    0xc(%eax),%eax
  802640:	3b 45 08             	cmp    0x8(%ebp),%eax
  802643:	0f 82 b8 00 00 00    	jb     802701 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 40 0c             	mov    0xc(%eax),%eax
  80264f:	2b 45 08             	sub    0x8(%ebp),%eax
  802652:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802658:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80265b:	0f 83 a1 00 00 00    	jae    802702 <alloc_block_BF+0xf1>
				differsize = differance ;
  802661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802664:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80266d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802671:	0f 85 8b 00 00 00    	jne    802702 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802677:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267b:	75 17                	jne    802694 <alloc_block_BF+0x83>
  80267d:	83 ec 04             	sub    $0x4,%esp
  802680:	68 c9 3c 80 00       	push   $0x803cc9
  802685:	68 a0 00 00 00       	push   $0xa0
  80268a:	68 57 3c 80 00       	push   $0x803c57
  80268f:	e8 f3 0a 00 00       	call   803187 <_panic>
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	8b 00                	mov    (%eax),%eax
  802699:	85 c0                	test   %eax,%eax
  80269b:	74 10                	je     8026ad <alloc_block_BF+0x9c>
  80269d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a5:	8b 52 04             	mov    0x4(%edx),%edx
  8026a8:	89 50 04             	mov    %edx,0x4(%eax)
  8026ab:	eb 0b                	jmp    8026b8 <alloc_block_BF+0xa7>
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 40 04             	mov    0x4(%eax),%eax
  8026b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 40 04             	mov    0x4(%eax),%eax
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	74 0f                	je     8026d1 <alloc_block_BF+0xc0>
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 40 04             	mov    0x4(%eax),%eax
  8026c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cb:	8b 12                	mov    (%edx),%edx
  8026cd:	89 10                	mov    %edx,(%eax)
  8026cf:	eb 0a                	jmp    8026db <alloc_block_BF+0xca>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 00                	mov    (%eax),%eax
  8026d6:	a3 38 41 80 00       	mov    %eax,0x804138
  8026db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ee:	a1 44 41 80 00       	mov    0x804144,%eax
  8026f3:	48                   	dec    %eax
  8026f4:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8026f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fc:	e9 0c 01 00 00       	jmp    80280d <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802701:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802702:	a1 40 41 80 00       	mov    0x804140,%eax
  802707:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80270a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270e:	74 07                	je     802717 <alloc_block_BF+0x106>
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 00                	mov    (%eax),%eax
  802715:	eb 05                	jmp    80271c <alloc_block_BF+0x10b>
  802717:	b8 00 00 00 00       	mov    $0x0,%eax
  80271c:	a3 40 41 80 00       	mov    %eax,0x804140
  802721:	a1 40 41 80 00       	mov    0x804140,%eax
  802726:	85 c0                	test   %eax,%eax
  802728:	0f 85 0c ff ff ff    	jne    80263a <alloc_block_BF+0x29>
  80272e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802732:	0f 85 02 ff ff ff    	jne    80263a <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802738:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80273c:	0f 84 c6 00 00 00    	je     802808 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802742:	a1 48 41 80 00       	mov    0x804148,%eax
  802747:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80274a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274d:	8b 55 08             	mov    0x8(%ebp),%edx
  802750:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802756:	8b 50 08             	mov    0x8(%eax),%edx
  802759:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275c:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	8b 40 0c             	mov    0xc(%eax),%eax
  802765:	2b 45 08             	sub    0x8(%ebp),%eax
  802768:	89 c2                	mov    %eax,%edx
  80276a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276d:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802773:	8b 50 08             	mov    0x8(%eax),%edx
  802776:	8b 45 08             	mov    0x8(%ebp),%eax
  802779:	01 c2                	add    %eax,%edx
  80277b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277e:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802781:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802785:	75 17                	jne    80279e <alloc_block_BF+0x18d>
  802787:	83 ec 04             	sub    $0x4,%esp
  80278a:	68 c9 3c 80 00       	push   $0x803cc9
  80278f:	68 af 00 00 00       	push   $0xaf
  802794:	68 57 3c 80 00       	push   $0x803c57
  802799:	e8 e9 09 00 00       	call   803187 <_panic>
  80279e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a1:	8b 00                	mov    (%eax),%eax
  8027a3:	85 c0                	test   %eax,%eax
  8027a5:	74 10                	je     8027b7 <alloc_block_BF+0x1a6>
  8027a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027aa:	8b 00                	mov    (%eax),%eax
  8027ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027af:	8b 52 04             	mov    0x4(%edx),%edx
  8027b2:	89 50 04             	mov    %edx,0x4(%eax)
  8027b5:	eb 0b                	jmp    8027c2 <alloc_block_BF+0x1b1>
  8027b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ba:	8b 40 04             	mov    0x4(%eax),%eax
  8027bd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c5:	8b 40 04             	mov    0x4(%eax),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 0f                	je     8027db <alloc_block_BF+0x1ca>
  8027cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027cf:	8b 40 04             	mov    0x4(%eax),%eax
  8027d2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027d5:	8b 12                	mov    (%edx),%edx
  8027d7:	89 10                	mov    %edx,(%eax)
  8027d9:	eb 0a                	jmp    8027e5 <alloc_block_BF+0x1d4>
  8027db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	a3 48 41 80 00       	mov    %eax,0x804148
  8027e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f8:	a1 54 41 80 00       	mov    0x804154,%eax
  8027fd:	48                   	dec    %eax
  8027fe:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  802803:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802806:	eb 05                	jmp    80280d <alloc_block_BF+0x1fc>
	}

	return NULL;
  802808:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80280d:	c9                   	leave  
  80280e:	c3                   	ret    

0080280f <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  80280f:	55                   	push   %ebp
  802810:	89 e5                	mov    %esp,%ebp
  802812:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802815:	a1 38 41 80 00       	mov    0x804138,%eax
  80281a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  80281d:	e9 7c 01 00 00       	jmp    80299e <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 40 0c             	mov    0xc(%eax),%eax
  802828:	3b 45 08             	cmp    0x8(%ebp),%eax
  80282b:	0f 86 cf 00 00 00    	jbe    802900 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802831:	a1 48 41 80 00       	mov    0x804148,%eax
  802836:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  80283f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802842:	8b 55 08             	mov    0x8(%ebp),%edx
  802845:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 50 08             	mov    0x8(%eax),%edx
  80284e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802851:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 40 0c             	mov    0xc(%eax),%eax
  80285a:	2b 45 08             	sub    0x8(%ebp),%eax
  80285d:	89 c2                	mov    %eax,%edx
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802865:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802868:	8b 50 08             	mov    0x8(%eax),%edx
  80286b:	8b 45 08             	mov    0x8(%ebp),%eax
  80286e:	01 c2                	add    %eax,%edx
  802870:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802873:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802876:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80287a:	75 17                	jne    802893 <alloc_block_NF+0x84>
  80287c:	83 ec 04             	sub    $0x4,%esp
  80287f:	68 c9 3c 80 00       	push   $0x803cc9
  802884:	68 c4 00 00 00       	push   $0xc4
  802889:	68 57 3c 80 00       	push   $0x803c57
  80288e:	e8 f4 08 00 00       	call   803187 <_panic>
  802893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802896:	8b 00                	mov    (%eax),%eax
  802898:	85 c0                	test   %eax,%eax
  80289a:	74 10                	je     8028ac <alloc_block_NF+0x9d>
  80289c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289f:	8b 00                	mov    (%eax),%eax
  8028a1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028a4:	8b 52 04             	mov    0x4(%edx),%edx
  8028a7:	89 50 04             	mov    %edx,0x4(%eax)
  8028aa:	eb 0b                	jmp    8028b7 <alloc_block_NF+0xa8>
  8028ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028af:	8b 40 04             	mov    0x4(%eax),%eax
  8028b2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ba:	8b 40 04             	mov    0x4(%eax),%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	74 0f                	je     8028d0 <alloc_block_NF+0xc1>
  8028c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c4:	8b 40 04             	mov    0x4(%eax),%eax
  8028c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ca:	8b 12                	mov    (%edx),%edx
  8028cc:	89 10                	mov    %edx,(%eax)
  8028ce:	eb 0a                	jmp    8028da <alloc_block_NF+0xcb>
  8028d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	a3 48 41 80 00       	mov    %eax,0x804148
  8028da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ed:	a1 54 41 80 00       	mov    0x804154,%eax
  8028f2:	48                   	dec    %eax
  8028f3:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8028f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fb:	e9 ad 00 00 00       	jmp    8029ad <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802900:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802903:	8b 40 0c             	mov    0xc(%eax),%eax
  802906:	3b 45 08             	cmp    0x8(%ebp),%eax
  802909:	0f 85 87 00 00 00    	jne    802996 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  80290f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802913:	75 17                	jne    80292c <alloc_block_NF+0x11d>
  802915:	83 ec 04             	sub    $0x4,%esp
  802918:	68 c9 3c 80 00       	push   $0x803cc9
  80291d:	68 c8 00 00 00       	push   $0xc8
  802922:	68 57 3c 80 00       	push   $0x803c57
  802927:	e8 5b 08 00 00       	call   803187 <_panic>
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	74 10                	je     802945 <alloc_block_NF+0x136>
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293d:	8b 52 04             	mov    0x4(%edx),%edx
  802940:	89 50 04             	mov    %edx,0x4(%eax)
  802943:	eb 0b                	jmp    802950 <alloc_block_NF+0x141>
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 40 04             	mov    0x4(%eax),%eax
  80294b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 40 04             	mov    0x4(%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 0f                	je     802969 <alloc_block_NF+0x15a>
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 40 04             	mov    0x4(%eax),%eax
  802960:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802963:	8b 12                	mov    (%edx),%edx
  802965:	89 10                	mov    %edx,(%eax)
  802967:	eb 0a                	jmp    802973 <alloc_block_NF+0x164>
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	8b 00                	mov    (%eax),%eax
  80296e:	a3 38 41 80 00       	mov    %eax,0x804138
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802986:	a1 44 41 80 00       	mov    0x804144,%eax
  80298b:	48                   	dec    %eax
  80298c:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	eb 17                	jmp    8029ad <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 00                	mov    (%eax),%eax
  80299b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  80299e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029a2:	0f 85 7a fe ff ff    	jne    802822 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8029a8:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8029ad:	c9                   	leave  
  8029ae:	c3                   	ret    

008029af <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029af:	55                   	push   %ebp
  8029b0:	89 e5                	mov    %esp,%ebp
  8029b2:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8029b5:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8029bd:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8029c5:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8029cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029d1:	75 68                	jne    802a3b <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d7:	75 17                	jne    8029f0 <insert_sorted_with_merge_freeList+0x41>
  8029d9:	83 ec 04             	sub    $0x4,%esp
  8029dc:	68 34 3c 80 00       	push   $0x803c34
  8029e1:	68 da 00 00 00       	push   $0xda
  8029e6:	68 57 3c 80 00       	push   $0x803c57
  8029eb:	e8 97 07 00 00       	call   803187 <_panic>
  8029f0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f9:	89 10                	mov    %edx,(%eax)
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	8b 00                	mov    (%eax),%eax
  802a00:	85 c0                	test   %eax,%eax
  802a02:	74 0d                	je     802a11 <insert_sorted_with_merge_freeList+0x62>
  802a04:	a1 38 41 80 00       	mov    0x804138,%eax
  802a09:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0c:	89 50 04             	mov    %edx,0x4(%eax)
  802a0f:	eb 08                	jmp    802a19 <insert_sorted_with_merge_freeList+0x6a>
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a19:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1c:	a3 38 41 80 00       	mov    %eax,0x804138
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a2b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a30:	40                   	inc    %eax
  802a31:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802a36:	e9 49 07 00 00       	jmp    803184 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3e:	8b 50 08             	mov    0x8(%eax),%edx
  802a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a44:	8b 40 0c             	mov    0xc(%eax),%eax
  802a47:	01 c2                	add    %eax,%edx
  802a49:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4c:	8b 40 08             	mov    0x8(%eax),%eax
  802a4f:	39 c2                	cmp    %eax,%edx
  802a51:	73 77                	jae    802aca <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	75 6e                	jne    802aca <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802a5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a60:	74 68                	je     802aca <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802a62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a66:	75 17                	jne    802a7f <insert_sorted_with_merge_freeList+0xd0>
  802a68:	83 ec 04             	sub    $0x4,%esp
  802a6b:	68 70 3c 80 00       	push   $0x803c70
  802a70:	68 e0 00 00 00       	push   $0xe0
  802a75:	68 57 3c 80 00       	push   $0x803c57
  802a7a:	e8 08 07 00 00       	call   803187 <_panic>
  802a7f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	89 50 04             	mov    %edx,0x4(%eax)
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	8b 40 04             	mov    0x4(%eax),%eax
  802a91:	85 c0                	test   %eax,%eax
  802a93:	74 0c                	je     802aa1 <insert_sorted_with_merge_freeList+0xf2>
  802a95:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9d:	89 10                	mov    %edx,(%eax)
  802a9f:	eb 08                	jmp    802aa9 <insert_sorted_with_merge_freeList+0xfa>
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	a3 38 41 80 00       	mov    %eax,0x804138
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aba:	a1 44 41 80 00       	mov    0x804144,%eax
  802abf:	40                   	inc    %eax
  802ac0:	a3 44 41 80 00       	mov    %eax,0x804144
  802ac5:	e9 ba 06 00 00       	jmp    803184 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	8b 40 08             	mov    0x8(%eax),%eax
  802ad6:	01 c2                	add    %eax,%edx
  802ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adb:	8b 40 08             	mov    0x8(%eax),%eax
  802ade:	39 c2                	cmp    %eax,%edx
  802ae0:	73 78                	jae    802b5a <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 40 04             	mov    0x4(%eax),%eax
  802ae8:	85 c0                	test   %eax,%eax
  802aea:	75 6e                	jne    802b5a <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802aec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802af0:	74 68                	je     802b5a <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802af2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af6:	75 17                	jne    802b0f <insert_sorted_with_merge_freeList+0x160>
  802af8:	83 ec 04             	sub    $0x4,%esp
  802afb:	68 34 3c 80 00       	push   $0x803c34
  802b00:	68 e6 00 00 00       	push   $0xe6
  802b05:	68 57 3c 80 00       	push   $0x803c57
  802b0a:	e8 78 06 00 00       	call   803187 <_panic>
  802b0f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	89 10                	mov    %edx,(%eax)
  802b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1d:	8b 00                	mov    (%eax),%eax
  802b1f:	85 c0                	test   %eax,%eax
  802b21:	74 0d                	je     802b30 <insert_sorted_with_merge_freeList+0x181>
  802b23:	a1 38 41 80 00       	mov    0x804138,%eax
  802b28:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2b:	89 50 04             	mov    %edx,0x4(%eax)
  802b2e:	eb 08                	jmp    802b38 <insert_sorted_with_merge_freeList+0x189>
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	a3 38 41 80 00       	mov    %eax,0x804138
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4a:	a1 44 41 80 00       	mov    0x804144,%eax
  802b4f:	40                   	inc    %eax
  802b50:	a3 44 41 80 00       	mov    %eax,0x804144
  802b55:	e9 2a 06 00 00       	jmp    803184 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802b5a:	a1 38 41 80 00       	mov    0x804138,%eax
  802b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b62:	e9 ed 05 00 00       	jmp    803154 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6a:	8b 00                	mov    (%eax),%eax
  802b6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802b6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b73:	0f 84 a7 00 00 00    	je     802c20 <insert_sorted_with_merge_freeList+0x271>
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 40 08             	mov    0x8(%eax),%eax
  802b85:	01 c2                	add    %eax,%edx
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	8b 40 08             	mov    0x8(%eax),%eax
  802b8d:	39 c2                	cmp    %eax,%edx
  802b8f:	0f 83 8b 00 00 00    	jae    802c20 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	8b 50 0c             	mov    0xc(%eax),%edx
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ba1:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802ba3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ba6:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802ba9:	39 c2                	cmp    %eax,%edx
  802bab:	73 73                	jae    802c20 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802bad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb1:	74 06                	je     802bb9 <insert_sorted_with_merge_freeList+0x20a>
  802bb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb7:	75 17                	jne    802bd0 <insert_sorted_with_merge_freeList+0x221>
  802bb9:	83 ec 04             	sub    $0x4,%esp
  802bbc:	68 e8 3c 80 00       	push   $0x803ce8
  802bc1:	68 f0 00 00 00       	push   $0xf0
  802bc6:	68 57 3c 80 00       	push   $0x803c57
  802bcb:	e8 b7 05 00 00       	call   803187 <_panic>
  802bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd3:	8b 10                	mov    (%eax),%edx
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	89 10                	mov    %edx,(%eax)
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 00                	mov    (%eax),%eax
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	74 0b                	je     802bee <insert_sorted_with_merge_freeList+0x23f>
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	8b 00                	mov    (%eax),%eax
  802be8:	8b 55 08             	mov    0x8(%ebp),%edx
  802beb:	89 50 04             	mov    %edx,0x4(%eax)
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf4:	89 10                	mov    %edx,(%eax)
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bfc:	89 50 04             	mov    %edx,0x4(%eax)
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	8b 00                	mov    (%eax),%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	75 08                	jne    802c10 <insert_sorted_with_merge_freeList+0x261>
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c10:	a1 44 41 80 00       	mov    0x804144,%eax
  802c15:	40                   	inc    %eax
  802c16:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802c1b:	e9 64 05 00 00       	jmp    803184 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802c20:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c25:	8b 50 0c             	mov    0xc(%eax),%edx
  802c28:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c2d:	8b 40 08             	mov    0x8(%eax),%eax
  802c30:	01 c2                	add    %eax,%edx
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	8b 40 08             	mov    0x8(%eax),%eax
  802c38:	39 c2                	cmp    %eax,%edx
  802c3a:	0f 85 b1 00 00 00    	jne    802cf1 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802c40:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c45:	85 c0                	test   %eax,%eax
  802c47:	0f 84 a4 00 00 00    	je     802cf1 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802c4d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c52:	8b 00                	mov    (%eax),%eax
  802c54:	85 c0                	test   %eax,%eax
  802c56:	0f 85 95 00 00 00    	jne    802cf1 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802c5c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c61:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c67:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6d:	8b 52 0c             	mov    0xc(%edx),%edx
  802c70:	01 ca                	add    %ecx,%edx
  802c72:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c8d:	75 17                	jne    802ca6 <insert_sorted_with_merge_freeList+0x2f7>
  802c8f:	83 ec 04             	sub    $0x4,%esp
  802c92:	68 34 3c 80 00       	push   $0x803c34
  802c97:	68 ff 00 00 00       	push   $0xff
  802c9c:	68 57 3c 80 00       	push   $0x803c57
  802ca1:	e8 e1 04 00 00       	call   803187 <_panic>
  802ca6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	89 10                	mov    %edx,(%eax)
  802cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb4:	8b 00                	mov    (%eax),%eax
  802cb6:	85 c0                	test   %eax,%eax
  802cb8:	74 0d                	je     802cc7 <insert_sorted_with_merge_freeList+0x318>
  802cba:	a1 48 41 80 00       	mov    0x804148,%eax
  802cbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc2:	89 50 04             	mov    %edx,0x4(%eax)
  802cc5:	eb 08                	jmp    802ccf <insert_sorted_with_merge_freeList+0x320>
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	a3 48 41 80 00       	mov    %eax,0x804148
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ce1:	a1 54 41 80 00       	mov    0x804154,%eax
  802ce6:	40                   	inc    %eax
  802ce7:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802cec:	e9 93 04 00 00       	jmp    803184 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802cf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf4:	8b 50 08             	mov    0x8(%eax),%edx
  802cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfa:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfd:	01 c2                	add    %eax,%edx
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	8b 40 08             	mov    0x8(%eax),%eax
  802d05:	39 c2                	cmp    %eax,%edx
  802d07:	0f 85 ae 00 00 00    	jne    802dbb <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	8b 50 0c             	mov    0xc(%eax),%edx
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	8b 40 08             	mov    0x8(%eax),%eax
  802d19:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	8b 00                	mov    (%eax),%eax
  802d20:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802d23:	39 c2                	cmp    %eax,%edx
  802d25:	0f 84 90 00 00 00    	je     802dbb <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	01 c2                	add    %eax,%edx
  802d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d57:	75 17                	jne    802d70 <insert_sorted_with_merge_freeList+0x3c1>
  802d59:	83 ec 04             	sub    $0x4,%esp
  802d5c:	68 34 3c 80 00       	push   $0x803c34
  802d61:	68 0b 01 00 00       	push   $0x10b
  802d66:	68 57 3c 80 00       	push   $0x803c57
  802d6b:	e8 17 04 00 00       	call   803187 <_panic>
  802d70:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	89 10                	mov    %edx,(%eax)
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	74 0d                	je     802d91 <insert_sorted_with_merge_freeList+0x3e2>
  802d84:	a1 48 41 80 00       	mov    0x804148,%eax
  802d89:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8c:	89 50 04             	mov    %edx,0x4(%eax)
  802d8f:	eb 08                	jmp    802d99 <insert_sorted_with_merge_freeList+0x3ea>
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	a3 48 41 80 00       	mov    %eax,0x804148
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dab:	a1 54 41 80 00       	mov    0x804154,%eax
  802db0:	40                   	inc    %eax
  802db1:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802db6:	e9 c9 03 00 00       	jmp    803184 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	8b 40 08             	mov    0x8(%eax),%eax
  802dc7:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcc:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802dcf:	39 c2                	cmp    %eax,%edx
  802dd1:	0f 85 bb 00 00 00    	jne    802e92 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802dd7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddb:	0f 84 b1 00 00 00    	je     802e92 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de4:	8b 40 04             	mov    0x4(%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	0f 85 a3 00 00 00    	jne    802e92 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802def:	a1 38 41 80 00       	mov    0x804138,%eax
  802df4:	8b 55 08             	mov    0x8(%ebp),%edx
  802df7:	8b 52 08             	mov    0x8(%edx),%edx
  802dfa:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802dfd:	a1 38 41 80 00       	mov    0x804138,%eax
  802e02:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802e08:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0e:	8b 52 0c             	mov    0xc(%edx),%edx
  802e11:	01 ca                	add    %ecx,%edx
  802e13:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e2e:	75 17                	jne    802e47 <insert_sorted_with_merge_freeList+0x498>
  802e30:	83 ec 04             	sub    $0x4,%esp
  802e33:	68 34 3c 80 00       	push   $0x803c34
  802e38:	68 17 01 00 00       	push   $0x117
  802e3d:	68 57 3c 80 00       	push   $0x803c57
  802e42:	e8 40 03 00 00       	call   803187 <_panic>
  802e47:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	89 10                	mov    %edx,(%eax)
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	85 c0                	test   %eax,%eax
  802e59:	74 0d                	je     802e68 <insert_sorted_with_merge_freeList+0x4b9>
  802e5b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e60:	8b 55 08             	mov    0x8(%ebp),%edx
  802e63:	89 50 04             	mov    %edx,0x4(%eax)
  802e66:	eb 08                	jmp    802e70 <insert_sorted_with_merge_freeList+0x4c1>
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	a3 48 41 80 00       	mov    %eax,0x804148
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e82:	a1 54 41 80 00       	mov    0x804154,%eax
  802e87:	40                   	inc    %eax
  802e88:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802e8d:	e9 f2 02 00 00       	jmp    803184 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	8b 50 08             	mov    0x8(%eax),%edx
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9e:	01 c2                	add    %eax,%edx
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	8b 40 08             	mov    0x8(%eax),%eax
  802ea6:	39 c2                	cmp    %eax,%edx
  802ea8:	0f 85 be 00 00 00    	jne    802f6c <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 40 04             	mov    0x4(%eax),%eax
  802eb4:	8b 50 08             	mov    0x8(%eax),%edx
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 40 04             	mov    0x4(%eax),%eax
  802ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec0:	01 c2                	add    %eax,%edx
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 40 08             	mov    0x8(%eax),%eax
  802ec8:	39 c2                	cmp    %eax,%edx
  802eca:	0f 84 9c 00 00 00    	je     802f6c <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	8b 50 08             	mov    0x8(%eax),%edx
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee8:	01 c2                	add    %eax,%edx
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f08:	75 17                	jne    802f21 <insert_sorted_with_merge_freeList+0x572>
  802f0a:	83 ec 04             	sub    $0x4,%esp
  802f0d:	68 34 3c 80 00       	push   $0x803c34
  802f12:	68 26 01 00 00       	push   $0x126
  802f17:	68 57 3c 80 00       	push   $0x803c57
  802f1c:	e8 66 02 00 00       	call   803187 <_panic>
  802f21:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	89 10                	mov    %edx,(%eax)
  802f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	85 c0                	test   %eax,%eax
  802f33:	74 0d                	je     802f42 <insert_sorted_with_merge_freeList+0x593>
  802f35:	a1 48 41 80 00       	mov    0x804148,%eax
  802f3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3d:	89 50 04             	mov    %edx,0x4(%eax)
  802f40:	eb 08                	jmp    802f4a <insert_sorted_with_merge_freeList+0x59b>
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	a3 48 41 80 00       	mov    %eax,0x804148
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f5c:	a1 54 41 80 00       	mov    0x804154,%eax
  802f61:	40                   	inc    %eax
  802f62:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802f67:	e9 18 02 00 00       	jmp    803184 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	8b 40 08             	mov    0x8(%eax),%eax
  802f78:	01 c2                	add    %eax,%edx
  802f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7d:	8b 40 08             	mov    0x8(%eax),%eax
  802f80:	39 c2                	cmp    %eax,%edx
  802f82:	0f 85 c4 01 00 00    	jne    80314c <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	8b 40 08             	mov    0x8(%eax),%eax
  802f94:	01 c2                	add    %eax,%edx
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	8b 00                	mov    (%eax),%eax
  802f9b:	8b 40 08             	mov    0x8(%eax),%eax
  802f9e:	39 c2                	cmp    %eax,%edx
  802fa0:	0f 85 a6 01 00 00    	jne    80314c <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802faa:	0f 84 9c 01 00 00    	je     80314c <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	8b 40 0c             	mov    0xc(%eax),%eax
  802fbc:	01 c2                	add    %eax,%edx
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc6:	01 c2                	add    %eax,%edx
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802fe2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe6:	75 17                	jne    802fff <insert_sorted_with_merge_freeList+0x650>
  802fe8:	83 ec 04             	sub    $0x4,%esp
  802feb:	68 34 3c 80 00       	push   $0x803c34
  802ff0:	68 32 01 00 00       	push   $0x132
  802ff5:	68 57 3c 80 00       	push   $0x803c57
  802ffa:	e8 88 01 00 00       	call   803187 <_panic>
  802fff:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	89 10                	mov    %edx,(%eax)
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	85 c0                	test   %eax,%eax
  803011:	74 0d                	je     803020 <insert_sorted_with_merge_freeList+0x671>
  803013:	a1 48 41 80 00       	mov    0x804148,%eax
  803018:	8b 55 08             	mov    0x8(%ebp),%edx
  80301b:	89 50 04             	mov    %edx,0x4(%eax)
  80301e:	eb 08                	jmp    803028 <insert_sorted_with_merge_freeList+0x679>
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	a3 48 41 80 00       	mov    %eax,0x804148
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303a:	a1 54 41 80 00       	mov    0x804154,%eax
  80303f:	40                   	inc    %eax
  803040:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  803045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803048:	8b 00                	mov    (%eax),%eax
  80304a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	8b 00                	mov    (%eax),%eax
  803056:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80305d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803060:	8b 00                	mov    (%eax),%eax
  803062:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803065:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803069:	75 17                	jne    803082 <insert_sorted_with_merge_freeList+0x6d3>
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	68 c9 3c 80 00       	push   $0x803cc9
  803073:	68 36 01 00 00       	push   $0x136
  803078:	68 57 3c 80 00       	push   $0x803c57
  80307d:	e8 05 01 00 00       	call   803187 <_panic>
  803082:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803085:	8b 00                	mov    (%eax),%eax
  803087:	85 c0                	test   %eax,%eax
  803089:	74 10                	je     80309b <insert_sorted_with_merge_freeList+0x6ec>
  80308b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308e:	8b 00                	mov    (%eax),%eax
  803090:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803093:	8b 52 04             	mov    0x4(%edx),%edx
  803096:	89 50 04             	mov    %edx,0x4(%eax)
  803099:	eb 0b                	jmp    8030a6 <insert_sorted_with_merge_freeList+0x6f7>
  80309b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309e:	8b 40 04             	mov    0x4(%eax),%eax
  8030a1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a9:	8b 40 04             	mov    0x4(%eax),%eax
  8030ac:	85 c0                	test   %eax,%eax
  8030ae:	74 0f                	je     8030bf <insert_sorted_with_merge_freeList+0x710>
  8030b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b3:	8b 40 04             	mov    0x4(%eax),%eax
  8030b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030b9:	8b 12                	mov    (%edx),%edx
  8030bb:	89 10                	mov    %edx,(%eax)
  8030bd:	eb 0a                	jmp    8030c9 <insert_sorted_with_merge_freeList+0x71a>
  8030bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c2:	8b 00                	mov    (%eax),%eax
  8030c4:	a3 38 41 80 00       	mov    %eax,0x804138
  8030c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030dc:	a1 44 41 80 00       	mov    0x804144,%eax
  8030e1:	48                   	dec    %eax
  8030e2:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8030e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030eb:	75 17                	jne    803104 <insert_sorted_with_merge_freeList+0x755>
  8030ed:	83 ec 04             	sub    $0x4,%esp
  8030f0:	68 34 3c 80 00       	push   $0x803c34
  8030f5:	68 37 01 00 00       	push   $0x137
  8030fa:	68 57 3c 80 00       	push   $0x803c57
  8030ff:	e8 83 00 00 00       	call   803187 <_panic>
  803104:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80310a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80310d:	89 10                	mov    %edx,(%eax)
  80310f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803112:	8b 00                	mov    (%eax),%eax
  803114:	85 c0                	test   %eax,%eax
  803116:	74 0d                	je     803125 <insert_sorted_with_merge_freeList+0x776>
  803118:	a1 48 41 80 00       	mov    0x804148,%eax
  80311d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803120:	89 50 04             	mov    %edx,0x4(%eax)
  803123:	eb 08                	jmp    80312d <insert_sorted_with_merge_freeList+0x77e>
  803125:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803128:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80312d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803130:	a3 48 41 80 00       	mov    %eax,0x804148
  803135:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803138:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313f:	a1 54 41 80 00       	mov    0x804154,%eax
  803144:	40                   	inc    %eax
  803145:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  80314a:	eb 38                	jmp    803184 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80314c:	a1 40 41 80 00       	mov    0x804140,%eax
  803151:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803154:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803158:	74 07                	je     803161 <insert_sorted_with_merge_freeList+0x7b2>
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	8b 00                	mov    (%eax),%eax
  80315f:	eb 05                	jmp    803166 <insert_sorted_with_merge_freeList+0x7b7>
  803161:	b8 00 00 00 00       	mov    $0x0,%eax
  803166:	a3 40 41 80 00       	mov    %eax,0x804140
  80316b:	a1 40 41 80 00       	mov    0x804140,%eax
  803170:	85 c0                	test   %eax,%eax
  803172:	0f 85 ef f9 ff ff    	jne    802b67 <insert_sorted_with_merge_freeList+0x1b8>
  803178:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317c:	0f 85 e5 f9 ff ff    	jne    802b67 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803182:	eb 00                	jmp    803184 <insert_sorted_with_merge_freeList+0x7d5>
  803184:	90                   	nop
  803185:	c9                   	leave  
  803186:	c3                   	ret    

00803187 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803187:	55                   	push   %ebp
  803188:	89 e5                	mov    %esp,%ebp
  80318a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80318d:	8d 45 10             	lea    0x10(%ebp),%eax
  803190:	83 c0 04             	add    $0x4,%eax
  803193:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803196:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80319b:	85 c0                	test   %eax,%eax
  80319d:	74 16                	je     8031b5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80319f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8031a4:	83 ec 08             	sub    $0x8,%esp
  8031a7:	50                   	push   %eax
  8031a8:	68 1c 3d 80 00       	push   $0x803d1c
  8031ad:	e8 d1 d4 ff ff       	call   800683 <cprintf>
  8031b2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8031b5:	a1 00 40 80 00       	mov    0x804000,%eax
  8031ba:	ff 75 0c             	pushl  0xc(%ebp)
  8031bd:	ff 75 08             	pushl  0x8(%ebp)
  8031c0:	50                   	push   %eax
  8031c1:	68 21 3d 80 00       	push   $0x803d21
  8031c6:	e8 b8 d4 ff ff       	call   800683 <cprintf>
  8031cb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8031ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8031d1:	83 ec 08             	sub    $0x8,%esp
  8031d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8031d7:	50                   	push   %eax
  8031d8:	e8 3b d4 ff ff       	call   800618 <vcprintf>
  8031dd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8031e0:	83 ec 08             	sub    $0x8,%esp
  8031e3:	6a 00                	push   $0x0
  8031e5:	68 3d 3d 80 00       	push   $0x803d3d
  8031ea:	e8 29 d4 ff ff       	call   800618 <vcprintf>
  8031ef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8031f2:	e8 aa d3 ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  8031f7:	eb fe                	jmp    8031f7 <_panic+0x70>

008031f9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8031f9:	55                   	push   %ebp
  8031fa:	89 e5                	mov    %esp,%ebp
  8031fc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8031ff:	a1 20 40 80 00       	mov    0x804020,%eax
  803204:	8b 50 74             	mov    0x74(%eax),%edx
  803207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80320a:	39 c2                	cmp    %eax,%edx
  80320c:	74 14                	je     803222 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80320e:	83 ec 04             	sub    $0x4,%esp
  803211:	68 40 3d 80 00       	push   $0x803d40
  803216:	6a 26                	push   $0x26
  803218:	68 8c 3d 80 00       	push   $0x803d8c
  80321d:	e8 65 ff ff ff       	call   803187 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  803222:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803229:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803230:	e9 c2 00 00 00       	jmp    8032f7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  803235:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	01 d0                	add    %edx,%eax
  803244:	8b 00                	mov    (%eax),%eax
  803246:	85 c0                	test   %eax,%eax
  803248:	75 08                	jne    803252 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80324a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80324d:	e9 a2 00 00 00       	jmp    8032f4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803252:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803259:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803260:	eb 69                	jmp    8032cb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803262:	a1 20 40 80 00       	mov    0x804020,%eax
  803267:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80326d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803270:	89 d0                	mov    %edx,%eax
  803272:	01 c0                	add    %eax,%eax
  803274:	01 d0                	add    %edx,%eax
  803276:	c1 e0 03             	shl    $0x3,%eax
  803279:	01 c8                	add    %ecx,%eax
  80327b:	8a 40 04             	mov    0x4(%eax),%al
  80327e:	84 c0                	test   %al,%al
  803280:	75 46                	jne    8032c8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803282:	a1 20 40 80 00       	mov    0x804020,%eax
  803287:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80328d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803290:	89 d0                	mov    %edx,%eax
  803292:	01 c0                	add    %eax,%eax
  803294:	01 d0                	add    %edx,%eax
  803296:	c1 e0 03             	shl    $0x3,%eax
  803299:	01 c8                	add    %ecx,%eax
  80329b:	8b 00                	mov    (%eax),%eax
  80329d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8032a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8032a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8032a8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8032aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032ad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8032b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b7:	01 c8                	add    %ecx,%eax
  8032b9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8032bb:	39 c2                	cmp    %eax,%edx
  8032bd:	75 09                	jne    8032c8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8032bf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8032c6:	eb 12                	jmp    8032da <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032c8:	ff 45 e8             	incl   -0x18(%ebp)
  8032cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8032d0:	8b 50 74             	mov    0x74(%eax),%edx
  8032d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d6:	39 c2                	cmp    %eax,%edx
  8032d8:	77 88                	ja     803262 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8032da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032de:	75 14                	jne    8032f4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8032e0:	83 ec 04             	sub    $0x4,%esp
  8032e3:	68 98 3d 80 00       	push   $0x803d98
  8032e8:	6a 3a                	push   $0x3a
  8032ea:	68 8c 3d 80 00       	push   $0x803d8c
  8032ef:	e8 93 fe ff ff       	call   803187 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8032f4:	ff 45 f0             	incl   -0x10(%ebp)
  8032f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8032fd:	0f 8c 32 ff ff ff    	jl     803235 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  803303:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80330a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  803311:	eb 26                	jmp    803339 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  803313:	a1 20 40 80 00       	mov    0x804020,%eax
  803318:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80331e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803321:	89 d0                	mov    %edx,%eax
  803323:	01 c0                	add    %eax,%eax
  803325:	01 d0                	add    %edx,%eax
  803327:	c1 e0 03             	shl    $0x3,%eax
  80332a:	01 c8                	add    %ecx,%eax
  80332c:	8a 40 04             	mov    0x4(%eax),%al
  80332f:	3c 01                	cmp    $0x1,%al
  803331:	75 03                	jne    803336 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  803333:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803336:	ff 45 e0             	incl   -0x20(%ebp)
  803339:	a1 20 40 80 00       	mov    0x804020,%eax
  80333e:	8b 50 74             	mov    0x74(%eax),%edx
  803341:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803344:	39 c2                	cmp    %eax,%edx
  803346:	77 cb                	ja     803313 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80334e:	74 14                	je     803364 <CheckWSWithoutLastIndex+0x16b>
		panic(
  803350:	83 ec 04             	sub    $0x4,%esp
  803353:	68 ec 3d 80 00       	push   $0x803dec
  803358:	6a 44                	push   $0x44
  80335a:	68 8c 3d 80 00       	push   $0x803d8c
  80335f:	e8 23 fe ff ff       	call   803187 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803364:	90                   	nop
  803365:	c9                   	leave  
  803366:	c3                   	ret    
  803367:	90                   	nop

00803368 <__udivdi3>:
  803368:	55                   	push   %ebp
  803369:	57                   	push   %edi
  80336a:	56                   	push   %esi
  80336b:	53                   	push   %ebx
  80336c:	83 ec 1c             	sub    $0x1c,%esp
  80336f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803373:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803377:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80337b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80337f:	89 ca                	mov    %ecx,%edx
  803381:	89 f8                	mov    %edi,%eax
  803383:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803387:	85 f6                	test   %esi,%esi
  803389:	75 2d                	jne    8033b8 <__udivdi3+0x50>
  80338b:	39 cf                	cmp    %ecx,%edi
  80338d:	77 65                	ja     8033f4 <__udivdi3+0x8c>
  80338f:	89 fd                	mov    %edi,%ebp
  803391:	85 ff                	test   %edi,%edi
  803393:	75 0b                	jne    8033a0 <__udivdi3+0x38>
  803395:	b8 01 00 00 00       	mov    $0x1,%eax
  80339a:	31 d2                	xor    %edx,%edx
  80339c:	f7 f7                	div    %edi
  80339e:	89 c5                	mov    %eax,%ebp
  8033a0:	31 d2                	xor    %edx,%edx
  8033a2:	89 c8                	mov    %ecx,%eax
  8033a4:	f7 f5                	div    %ebp
  8033a6:	89 c1                	mov    %eax,%ecx
  8033a8:	89 d8                	mov    %ebx,%eax
  8033aa:	f7 f5                	div    %ebp
  8033ac:	89 cf                	mov    %ecx,%edi
  8033ae:	89 fa                	mov    %edi,%edx
  8033b0:	83 c4 1c             	add    $0x1c,%esp
  8033b3:	5b                   	pop    %ebx
  8033b4:	5e                   	pop    %esi
  8033b5:	5f                   	pop    %edi
  8033b6:	5d                   	pop    %ebp
  8033b7:	c3                   	ret    
  8033b8:	39 ce                	cmp    %ecx,%esi
  8033ba:	77 28                	ja     8033e4 <__udivdi3+0x7c>
  8033bc:	0f bd fe             	bsr    %esi,%edi
  8033bf:	83 f7 1f             	xor    $0x1f,%edi
  8033c2:	75 40                	jne    803404 <__udivdi3+0x9c>
  8033c4:	39 ce                	cmp    %ecx,%esi
  8033c6:	72 0a                	jb     8033d2 <__udivdi3+0x6a>
  8033c8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8033cc:	0f 87 9e 00 00 00    	ja     803470 <__udivdi3+0x108>
  8033d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8033d7:	89 fa                	mov    %edi,%edx
  8033d9:	83 c4 1c             	add    $0x1c,%esp
  8033dc:	5b                   	pop    %ebx
  8033dd:	5e                   	pop    %esi
  8033de:	5f                   	pop    %edi
  8033df:	5d                   	pop    %ebp
  8033e0:	c3                   	ret    
  8033e1:	8d 76 00             	lea    0x0(%esi),%esi
  8033e4:	31 ff                	xor    %edi,%edi
  8033e6:	31 c0                	xor    %eax,%eax
  8033e8:	89 fa                	mov    %edi,%edx
  8033ea:	83 c4 1c             	add    $0x1c,%esp
  8033ed:	5b                   	pop    %ebx
  8033ee:	5e                   	pop    %esi
  8033ef:	5f                   	pop    %edi
  8033f0:	5d                   	pop    %ebp
  8033f1:	c3                   	ret    
  8033f2:	66 90                	xchg   %ax,%ax
  8033f4:	89 d8                	mov    %ebx,%eax
  8033f6:	f7 f7                	div    %edi
  8033f8:	31 ff                	xor    %edi,%edi
  8033fa:	89 fa                	mov    %edi,%edx
  8033fc:	83 c4 1c             	add    $0x1c,%esp
  8033ff:	5b                   	pop    %ebx
  803400:	5e                   	pop    %esi
  803401:	5f                   	pop    %edi
  803402:	5d                   	pop    %ebp
  803403:	c3                   	ret    
  803404:	bd 20 00 00 00       	mov    $0x20,%ebp
  803409:	89 eb                	mov    %ebp,%ebx
  80340b:	29 fb                	sub    %edi,%ebx
  80340d:	89 f9                	mov    %edi,%ecx
  80340f:	d3 e6                	shl    %cl,%esi
  803411:	89 c5                	mov    %eax,%ebp
  803413:	88 d9                	mov    %bl,%cl
  803415:	d3 ed                	shr    %cl,%ebp
  803417:	89 e9                	mov    %ebp,%ecx
  803419:	09 f1                	or     %esi,%ecx
  80341b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80341f:	89 f9                	mov    %edi,%ecx
  803421:	d3 e0                	shl    %cl,%eax
  803423:	89 c5                	mov    %eax,%ebp
  803425:	89 d6                	mov    %edx,%esi
  803427:	88 d9                	mov    %bl,%cl
  803429:	d3 ee                	shr    %cl,%esi
  80342b:	89 f9                	mov    %edi,%ecx
  80342d:	d3 e2                	shl    %cl,%edx
  80342f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803433:	88 d9                	mov    %bl,%cl
  803435:	d3 e8                	shr    %cl,%eax
  803437:	09 c2                	or     %eax,%edx
  803439:	89 d0                	mov    %edx,%eax
  80343b:	89 f2                	mov    %esi,%edx
  80343d:	f7 74 24 0c          	divl   0xc(%esp)
  803441:	89 d6                	mov    %edx,%esi
  803443:	89 c3                	mov    %eax,%ebx
  803445:	f7 e5                	mul    %ebp
  803447:	39 d6                	cmp    %edx,%esi
  803449:	72 19                	jb     803464 <__udivdi3+0xfc>
  80344b:	74 0b                	je     803458 <__udivdi3+0xf0>
  80344d:	89 d8                	mov    %ebx,%eax
  80344f:	31 ff                	xor    %edi,%edi
  803451:	e9 58 ff ff ff       	jmp    8033ae <__udivdi3+0x46>
  803456:	66 90                	xchg   %ax,%ax
  803458:	8b 54 24 08          	mov    0x8(%esp),%edx
  80345c:	89 f9                	mov    %edi,%ecx
  80345e:	d3 e2                	shl    %cl,%edx
  803460:	39 c2                	cmp    %eax,%edx
  803462:	73 e9                	jae    80344d <__udivdi3+0xe5>
  803464:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803467:	31 ff                	xor    %edi,%edi
  803469:	e9 40 ff ff ff       	jmp    8033ae <__udivdi3+0x46>
  80346e:	66 90                	xchg   %ax,%ax
  803470:	31 c0                	xor    %eax,%eax
  803472:	e9 37 ff ff ff       	jmp    8033ae <__udivdi3+0x46>
  803477:	90                   	nop

00803478 <__umoddi3>:
  803478:	55                   	push   %ebp
  803479:	57                   	push   %edi
  80347a:	56                   	push   %esi
  80347b:	53                   	push   %ebx
  80347c:	83 ec 1c             	sub    $0x1c,%esp
  80347f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803483:	8b 74 24 34          	mov    0x34(%esp),%esi
  803487:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80348b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80348f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803493:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803497:	89 f3                	mov    %esi,%ebx
  803499:	89 fa                	mov    %edi,%edx
  80349b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80349f:	89 34 24             	mov    %esi,(%esp)
  8034a2:	85 c0                	test   %eax,%eax
  8034a4:	75 1a                	jne    8034c0 <__umoddi3+0x48>
  8034a6:	39 f7                	cmp    %esi,%edi
  8034a8:	0f 86 a2 00 00 00    	jbe    803550 <__umoddi3+0xd8>
  8034ae:	89 c8                	mov    %ecx,%eax
  8034b0:	89 f2                	mov    %esi,%edx
  8034b2:	f7 f7                	div    %edi
  8034b4:	89 d0                	mov    %edx,%eax
  8034b6:	31 d2                	xor    %edx,%edx
  8034b8:	83 c4 1c             	add    $0x1c,%esp
  8034bb:	5b                   	pop    %ebx
  8034bc:	5e                   	pop    %esi
  8034bd:	5f                   	pop    %edi
  8034be:	5d                   	pop    %ebp
  8034bf:	c3                   	ret    
  8034c0:	39 f0                	cmp    %esi,%eax
  8034c2:	0f 87 ac 00 00 00    	ja     803574 <__umoddi3+0xfc>
  8034c8:	0f bd e8             	bsr    %eax,%ebp
  8034cb:	83 f5 1f             	xor    $0x1f,%ebp
  8034ce:	0f 84 ac 00 00 00    	je     803580 <__umoddi3+0x108>
  8034d4:	bf 20 00 00 00       	mov    $0x20,%edi
  8034d9:	29 ef                	sub    %ebp,%edi
  8034db:	89 fe                	mov    %edi,%esi
  8034dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8034e1:	89 e9                	mov    %ebp,%ecx
  8034e3:	d3 e0                	shl    %cl,%eax
  8034e5:	89 d7                	mov    %edx,%edi
  8034e7:	89 f1                	mov    %esi,%ecx
  8034e9:	d3 ef                	shr    %cl,%edi
  8034eb:	09 c7                	or     %eax,%edi
  8034ed:	89 e9                	mov    %ebp,%ecx
  8034ef:	d3 e2                	shl    %cl,%edx
  8034f1:	89 14 24             	mov    %edx,(%esp)
  8034f4:	89 d8                	mov    %ebx,%eax
  8034f6:	d3 e0                	shl    %cl,%eax
  8034f8:	89 c2                	mov    %eax,%edx
  8034fa:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034fe:	d3 e0                	shl    %cl,%eax
  803500:	89 44 24 04          	mov    %eax,0x4(%esp)
  803504:	8b 44 24 08          	mov    0x8(%esp),%eax
  803508:	89 f1                	mov    %esi,%ecx
  80350a:	d3 e8                	shr    %cl,%eax
  80350c:	09 d0                	or     %edx,%eax
  80350e:	d3 eb                	shr    %cl,%ebx
  803510:	89 da                	mov    %ebx,%edx
  803512:	f7 f7                	div    %edi
  803514:	89 d3                	mov    %edx,%ebx
  803516:	f7 24 24             	mull   (%esp)
  803519:	89 c6                	mov    %eax,%esi
  80351b:	89 d1                	mov    %edx,%ecx
  80351d:	39 d3                	cmp    %edx,%ebx
  80351f:	0f 82 87 00 00 00    	jb     8035ac <__umoddi3+0x134>
  803525:	0f 84 91 00 00 00    	je     8035bc <__umoddi3+0x144>
  80352b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80352f:	29 f2                	sub    %esi,%edx
  803531:	19 cb                	sbb    %ecx,%ebx
  803533:	89 d8                	mov    %ebx,%eax
  803535:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803539:	d3 e0                	shl    %cl,%eax
  80353b:	89 e9                	mov    %ebp,%ecx
  80353d:	d3 ea                	shr    %cl,%edx
  80353f:	09 d0                	or     %edx,%eax
  803541:	89 e9                	mov    %ebp,%ecx
  803543:	d3 eb                	shr    %cl,%ebx
  803545:	89 da                	mov    %ebx,%edx
  803547:	83 c4 1c             	add    $0x1c,%esp
  80354a:	5b                   	pop    %ebx
  80354b:	5e                   	pop    %esi
  80354c:	5f                   	pop    %edi
  80354d:	5d                   	pop    %ebp
  80354e:	c3                   	ret    
  80354f:	90                   	nop
  803550:	89 fd                	mov    %edi,%ebp
  803552:	85 ff                	test   %edi,%edi
  803554:	75 0b                	jne    803561 <__umoddi3+0xe9>
  803556:	b8 01 00 00 00       	mov    $0x1,%eax
  80355b:	31 d2                	xor    %edx,%edx
  80355d:	f7 f7                	div    %edi
  80355f:	89 c5                	mov    %eax,%ebp
  803561:	89 f0                	mov    %esi,%eax
  803563:	31 d2                	xor    %edx,%edx
  803565:	f7 f5                	div    %ebp
  803567:	89 c8                	mov    %ecx,%eax
  803569:	f7 f5                	div    %ebp
  80356b:	89 d0                	mov    %edx,%eax
  80356d:	e9 44 ff ff ff       	jmp    8034b6 <__umoddi3+0x3e>
  803572:	66 90                	xchg   %ax,%ax
  803574:	89 c8                	mov    %ecx,%eax
  803576:	89 f2                	mov    %esi,%edx
  803578:	83 c4 1c             	add    $0x1c,%esp
  80357b:	5b                   	pop    %ebx
  80357c:	5e                   	pop    %esi
  80357d:	5f                   	pop    %edi
  80357e:	5d                   	pop    %ebp
  80357f:	c3                   	ret    
  803580:	3b 04 24             	cmp    (%esp),%eax
  803583:	72 06                	jb     80358b <__umoddi3+0x113>
  803585:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803589:	77 0f                	ja     80359a <__umoddi3+0x122>
  80358b:	89 f2                	mov    %esi,%edx
  80358d:	29 f9                	sub    %edi,%ecx
  80358f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803593:	89 14 24             	mov    %edx,(%esp)
  803596:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80359a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80359e:	8b 14 24             	mov    (%esp),%edx
  8035a1:	83 c4 1c             	add    $0x1c,%esp
  8035a4:	5b                   	pop    %ebx
  8035a5:	5e                   	pop    %esi
  8035a6:	5f                   	pop    %edi
  8035a7:	5d                   	pop    %ebp
  8035a8:	c3                   	ret    
  8035a9:	8d 76 00             	lea    0x0(%esi),%esi
  8035ac:	2b 04 24             	sub    (%esp),%eax
  8035af:	19 fa                	sbb    %edi,%edx
  8035b1:	89 d1                	mov    %edx,%ecx
  8035b3:	89 c6                	mov    %eax,%esi
  8035b5:	e9 71 ff ff ff       	jmp    80352b <__umoddi3+0xb3>
  8035ba:	66 90                	xchg   %ax,%ax
  8035bc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8035c0:	72 ea                	jb     8035ac <__umoddi3+0x134>
  8035c2:	89 d9                	mov    %ebx,%ecx
  8035c4:	e9 62 ff ff ff       	jmp    80352b <__umoddi3+0xb3>
