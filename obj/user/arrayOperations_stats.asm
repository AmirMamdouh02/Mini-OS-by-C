
obj/user/arrayOperations_stats:     file format elf32-i386


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
  800031:	e8 f7 04 00 00       	call   80052d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med);
int KthElement(int *Elements, int NumOfElements, int k);
int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 58             	sub    $0x58,%esp
	int32 envID = sys_getenvid();
  80003e:	e8 fe 1d 00 00       	call   801e41 <sys_getenvid>
  800043:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int32 parentenvID = sys_getparentenvid();
  800046:	e8 28 1e 00 00       	call   801e73 <sys_getparentenvid>
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
  80005f:	68 a0 36 80 00       	push   $0x8036a0
  800064:	ff 75 ec             	pushl  -0x14(%ebp)
  800067:	e8 c0 18 00 00       	call   80192c <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	numOfElements = sget(parentenvID,"arrSize") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 a4 36 80 00       	push   $0x8036a4
  80007a:	ff 75 ec             	pushl  -0x14(%ebp)
  80007d:	e8 aa 18 00 00       	call   80192c <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	//Get the check-finishing counter
	int *finishedCount = NULL;
  800088:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	finishedCount = sget(parentenvID,"finishedCount") ;
  80008f:	83 ec 08             	sub    $0x8,%esp
  800092:	68 ac 36 80 00       	push   $0x8036ac
  800097:	ff 75 ec             	pushl  -0x14(%ebp)
  80009a:	e8 8d 18 00 00       	call   80192c <sget>
  80009f:	83 c4 10             	add    $0x10,%esp
  8000a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int max ;
	int med ;

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
  8000a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000a8:	8b 00                	mov    (%eax),%eax
  8000aa:	c1 e0 02             	shl    $0x2,%eax
  8000ad:	83 ec 04             	sub    $0x4,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	50                   	push   %eax
  8000b3:	68 ba 36 80 00       	push   $0x8036ba
  8000b8:	e8 9a 17 00 00       	call   801857 <smalloc>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8000ca:	eb 25                	jmp    8000f1 <_main+0xb9>
	{
		tmpArray[i] = sharedArray[i];
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

	//take a copy from the original array
	int *tmpArray;
	tmpArray = smalloc("tmpArr", sizeof(int) * *numOfElements, 0) ;
	int i ;
	for (i = 0 ; i < *numOfElements ; i++)
  8000ee:	ff 45 f4             	incl   -0xc(%ebp)
  8000f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f9:	7f d1                	jg     8000cc <_main+0x94>
	{
		tmpArray[i] = sharedArray[i];
	}

	ArrayStats(tmpArray ,*numOfElements, &mean, &var, &min, &max, &med);
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	8b 00                	mov    (%eax),%eax
  800100:	83 ec 04             	sub    $0x4,%esp
  800103:	8d 55 b4             	lea    -0x4c(%ebp),%edx
  800106:	52                   	push   %edx
  800107:	8d 55 b8             	lea    -0x48(%ebp),%edx
  80010a:	52                   	push   %edx
  80010b:	8d 55 bc             	lea    -0x44(%ebp),%edx
  80010e:	52                   	push   %edx
  80010f:	8d 55 c0             	lea    -0x40(%ebp),%edx
  800112:	52                   	push   %edx
  800113:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800116:	52                   	push   %edx
  800117:	50                   	push   %eax
  800118:	ff 75 dc             	pushl  -0x24(%ebp)
  80011b:	e8 55 02 00 00       	call   800375 <ArrayStats>
  800120:	83 c4 20             	add    $0x20,%esp
	cprintf("Stats Calculations are Finished!!!!\n") ;
  800123:	83 ec 0c             	sub    $0xc,%esp
  800126:	68 c4 36 80 00       	push   $0x8036c4
  80012b:	e8 0d 06 00 00       	call   80073d <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THE RESULTS & DECLARE FINISHING*/
	int *shMean, *shVar, *shMin, *shMax, *shMed;
	shMean = smalloc("mean", sizeof(int), 0) ; *shMean = mean;
  800133:	83 ec 04             	sub    $0x4,%esp
  800136:	6a 00                	push   $0x0
  800138:	6a 04                	push   $0x4
  80013a:	68 e9 36 80 00       	push   $0x8036e9
  80013f:	e8 13 17 00 00       	call   801857 <smalloc>
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80014a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80014d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800150:	89 10                	mov    %edx,(%eax)
	shVar = smalloc("var", sizeof(int), 0) ; *shVar = var;
  800152:	83 ec 04             	sub    $0x4,%esp
  800155:	6a 00                	push   $0x0
  800157:	6a 04                	push   $0x4
  800159:	68 ee 36 80 00       	push   $0x8036ee
  80015e:	e8 f4 16 00 00       	call   801857 <smalloc>
  800163:	83 c4 10             	add    $0x10,%esp
  800166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800169:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80016c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80016f:	89 10                	mov    %edx,(%eax)
	shMin = smalloc("min", sizeof(int), 0) ; *shMin = min;
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	6a 00                	push   $0x0
  800176:	6a 04                	push   $0x4
  800178:	68 f2 36 80 00       	push   $0x8036f2
  80017d:	e8 d5 16 00 00       	call   801857 <smalloc>
  800182:	83 c4 10             	add    $0x10,%esp
  800185:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800188:	8b 55 bc             	mov    -0x44(%ebp),%edx
  80018b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80018e:	89 10                	mov    %edx,(%eax)
	shMax = smalloc("max", sizeof(int), 0) ; *shMax = max;
  800190:	83 ec 04             	sub    $0x4,%esp
  800193:	6a 00                	push   $0x0
  800195:	6a 04                	push   $0x4
  800197:	68 f6 36 80 00       	push   $0x8036f6
  80019c:	e8 b6 16 00 00       	call   801857 <smalloc>
  8001a1:	83 c4 10             	add    $0x10,%esp
  8001a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001a7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  8001aa:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ad:	89 10                	mov    %edx,(%eax)
	shMed = smalloc("med", sizeof(int), 0) ; *shMed = med;
  8001af:	83 ec 04             	sub    $0x4,%esp
  8001b2:	6a 00                	push   $0x0
  8001b4:	6a 04                	push   $0x4
  8001b6:	68 fa 36 80 00       	push   $0x8036fa
  8001bb:	e8 97 16 00 00       	call   801857 <smalloc>
  8001c0:	83 c4 10             	add    $0x10,%esp
  8001c3:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8001c6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  8001c9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001cc:	89 10                	mov    %edx,(%eax)

	(*finishedCount)++ ;
  8001ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d1:	8b 00                	mov    (%eax),%eax
  8001d3:	8d 50 01             	lea    0x1(%eax),%edx
  8001d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001d9:	89 10                	mov    %edx,(%eax)

}
  8001db:	90                   	nop
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <KthElement>:



///Kth Element
int KthElement(int *Elements, int NumOfElements, int k)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 08             	sub    $0x8,%esp
	return QSort(Elements, NumOfElements, 0, NumOfElements-1, k-1) ;
  8001e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001e7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8001ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ed:	48                   	dec    %eax
  8001ee:	83 ec 0c             	sub    $0xc,%esp
  8001f1:	52                   	push   %edx
  8001f2:	50                   	push   %eax
  8001f3:	6a 00                	push   $0x0
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 05 00 00 00       	call   800205 <QSort>
  800200:	83 c4 20             	add    $0x20,%esp
}
  800203:	c9                   	leave  
  800204:	c3                   	ret    

00800205 <QSort>:


int QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex, int kIndex)
{
  800205:	55                   	push   %ebp
  800206:	89 e5                	mov    %esp,%ebp
  800208:	83 ec 28             	sub    $0x28,%esp
	if (startIndex >= finalIndex) return Elements[finalIndex];
  80020b:	8b 45 10             	mov    0x10(%ebp),%eax
  80020e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800211:	7c 16                	jl     800229 <QSort+0x24>
  800213:	8b 45 14             	mov    0x14(%ebp),%eax
  800216:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021d:	8b 45 08             	mov    0x8(%ebp),%eax
  800220:	01 d0                	add    %edx,%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	e9 4a 01 00 00       	jmp    800373 <QSort+0x16e>

	int pvtIndex = RAND(startIndex, finalIndex) ;
  800229:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80022c:	83 ec 0c             	sub    $0xc,%esp
  80022f:	50                   	push   %eax
  800230:	e8 71 1c 00 00       	call   801ea6 <sys_get_virtual_time>
  800235:	83 c4 0c             	add    $0xc,%esp
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 55 14             	mov    0x14(%ebp),%edx
  80023e:	2b 55 10             	sub    0x10(%ebp),%edx
  800241:	89 d1                	mov    %edx,%ecx
  800243:	ba 00 00 00 00       	mov    $0x0,%edx
  800248:	f7 f1                	div    %ecx
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	01 d0                	add    %edx,%eax
  80024f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	Swap(Elements, startIndex, pvtIndex);
  800252:	83 ec 04             	sub    $0x4,%esp
  800255:	ff 75 ec             	pushl  -0x14(%ebp)
  800258:	ff 75 10             	pushl  0x10(%ebp)
  80025b:	ff 75 08             	pushl  0x8(%ebp)
  80025e:	e8 77 02 00 00       	call   8004da <Swap>
  800263:	83 c4 10             	add    $0x10,%esp

	int i = startIndex+1, j = finalIndex;
  800266:	8b 45 10             	mov    0x10(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80026d:	8b 45 14             	mov    0x14(%ebp),%eax
  800270:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800273:	e9 80 00 00 00       	jmp    8002f8 <QSort+0xf3>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800278:	ff 45 f4             	incl   -0xc(%ebp)
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	7f 2b                	jg     8002ae <QSort+0xa9>
  800283:	8b 45 10             	mov    0x10(%ebp),%eax
  800286:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80028d:	8b 45 08             	mov    0x8(%ebp),%eax
  800290:	01 d0                	add    %edx,%eax
  800292:	8b 10                	mov    (%eax),%edx
  800294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800297:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	01 c8                	add    %ecx,%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	39 c2                	cmp    %eax,%edx
  8002a7:	7d cf                	jge    800278 <QSort+0x73>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002a9:	eb 03                	jmp    8002ae <QSort+0xa9>
  8002ab:	ff 4d f0             	decl   -0x10(%ebp)
  8002ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002b4:	7e 26                	jle    8002dc <QSort+0xd7>
  8002b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	8b 10                	mov    (%eax),%edx
  8002c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002ca:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	01 c8                	add    %ecx,%eax
  8002d6:	8b 00                	mov    (%eax),%eax
  8002d8:	39 c2                	cmp    %eax,%edx
  8002da:	7e cf                	jle    8002ab <QSort+0xa6>

		if (i <= j)
  8002dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002e2:	7f 14                	jg     8002f8 <QSort+0xf3>
		{
			Swap(Elements, i, j);
  8002e4:	83 ec 04             	sub    $0x4,%esp
  8002e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8002ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ed:	ff 75 08             	pushl  0x8(%ebp)
  8002f0:	e8 e5 01 00 00       	call   8004da <Swap>
  8002f5:	83 c4 10             	add    $0x10,%esp
	int pvtIndex = RAND(startIndex, finalIndex) ;
	Swap(Elements, startIndex, pvtIndex);

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  8002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8002fe:	0f 8e 77 ff ff ff    	jle    80027b <QSort+0x76>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800304:	83 ec 04             	sub    $0x4,%esp
  800307:	ff 75 f0             	pushl  -0x10(%ebp)
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 08             	pushl  0x8(%ebp)
  800310:	e8 c5 01 00 00       	call   8004da <Swap>
  800315:	83 c4 10             	add    $0x10,%esp

	if (kIndex == j)
  800318:	8b 45 18             	mov    0x18(%ebp),%eax
  80031b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031e:	75 13                	jne    800333 <QSort+0x12e>
		return Elements[kIndex] ;
  800320:	8b 45 18             	mov    0x18(%ebp),%eax
  800323:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	8b 00                	mov    (%eax),%eax
  800331:	eb 40                	jmp    800373 <QSort+0x16e>
	else if (kIndex < j)
  800333:	8b 45 18             	mov    0x18(%ebp),%eax
  800336:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800339:	7d 1e                	jge    800359 <QSort+0x154>
		return QSort(Elements, NumOfElements, startIndex, j - 1, kIndex);
  80033b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033e:	48                   	dec    %eax
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	ff 75 18             	pushl  0x18(%ebp)
  800345:	50                   	push   %eax
  800346:	ff 75 10             	pushl  0x10(%ebp)
  800349:	ff 75 0c             	pushl  0xc(%ebp)
  80034c:	ff 75 08             	pushl  0x8(%ebp)
  80034f:	e8 b1 fe ff ff       	call   800205 <QSort>
  800354:	83 c4 20             	add    $0x20,%esp
  800357:	eb 1a                	jmp    800373 <QSort+0x16e>
	else
		return QSort(Elements, NumOfElements, i, finalIndex, kIndex);
  800359:	83 ec 0c             	sub    $0xc,%esp
  80035c:	ff 75 18             	pushl  0x18(%ebp)
  80035f:	ff 75 14             	pushl  0x14(%ebp)
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	ff 75 0c             	pushl  0xc(%ebp)
  800368:	ff 75 08             	pushl  0x8(%ebp)
  80036b:	e8 95 fe ff ff       	call   800205 <QSort>
  800370:	83 c4 20             	add    $0x20,%esp
}
  800373:	c9                   	leave  
  800374:	c3                   	ret    

00800375 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var, int *min, int *max, int *med)
{
  800375:	55                   	push   %ebp
  800376:	89 e5                	mov    %esp,%ebp
  800378:	53                   	push   %ebx
  800379:	83 ec 14             	sub    $0x14,%esp
	int i ;
	*mean =0 ;
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*min = 0x7FFFFFFF ;
  800385:	8b 45 18             	mov    0x18(%ebp),%eax
  800388:	c7 00 ff ff ff 7f    	movl   $0x7fffffff,(%eax)
	*max = 0x80000000 ;
  80038e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800391:	c7 00 00 00 00 80    	movl   $0x80000000,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800397:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80039e:	e9 80 00 00 00       	jmp    800423 <ArrayStats+0xae>
	{
		(*mean) += Elements[i];
  8003a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003a6:	8b 10                	mov    (%eax),%edx
  8003a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ab:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b5:	01 c8                	add    %ecx,%eax
  8003b7:	8b 00                	mov    (%eax),%eax
  8003b9:	01 c2                	add    %eax,%edx
  8003bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003be:	89 10                	mov    %edx,(%eax)
		if (Elements[i] < (*min))
  8003c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8003cd:	01 d0                	add    %edx,%eax
  8003cf:	8b 10                	mov    (%eax),%edx
  8003d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	7d 16                	jge    8003f0 <ArrayStats+0x7b>
		{
			(*min) = Elements[i];
  8003da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003dd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e7:	01 d0                	add    %edx,%eax
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	89 10                	mov    %edx,(%eax)
		}
		if (Elements[i] > (*max))
  8003f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fd:	01 d0                	add    %edx,%eax
  8003ff:	8b 10                	mov    (%eax),%edx
  800401:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800404:	8b 00                	mov    (%eax),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	7e 16                	jle    800420 <ArrayStats+0xab>
		{
			(*max) = Elements[i];
  80040a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80040d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800414:	8b 45 08             	mov    0x8(%ebp),%eax
  800417:	01 d0                	add    %edx,%eax
  800419:	8b 10                	mov    (%eax),%edx
  80041b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80041e:	89 10                	mov    %edx,(%eax)
{
	int i ;
	*mean =0 ;
	*min = 0x7FFFFFFF ;
	*max = 0x80000000 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800420:	ff 45 f4             	incl   -0xc(%ebp)
  800423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800426:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800429:	0f 8c 74 ff ff ff    	jl     8003a3 <ArrayStats+0x2e>
		{
			(*max) = Elements[i];
		}
	}

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);
  80042f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800432:	89 c2                	mov    %eax,%edx
  800434:	c1 ea 1f             	shr    $0x1f,%edx
  800437:	01 d0                	add    %edx,%eax
  800439:	d1 f8                	sar    %eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	50                   	push   %eax
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 08             	pushl  0x8(%ebp)
  800445:	e8 94 fd ff ff       	call   8001de <KthElement>
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	89 c2                	mov    %eax,%edx
  80044f:	8b 45 20             	mov    0x20(%ebp),%eax
  800452:	89 10                	mov    %edx,(%eax)

	(*mean) /= NumOfElements;
  800454:	8b 45 10             	mov    0x10(%ebp),%eax
  800457:	8b 00                	mov    (%eax),%eax
  800459:	99                   	cltd   
  80045a:	f7 7d 0c             	idivl  0xc(%ebp)
  80045d:	89 c2                	mov    %eax,%edx
  80045f:	8b 45 10             	mov    0x10(%ebp),%eax
  800462:	89 10                	mov    %edx,(%eax)
	(*var) = 0;
  800464:	8b 45 14             	mov    0x14(%ebp),%eax
  800467:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  80046d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800474:	eb 46                	jmp    8004bc <ArrayStats+0x147>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800485:	8b 45 08             	mov    0x8(%ebp),%eax
  800488:	01 c8                	add    %ecx,%eax
  80048a:	8b 08                	mov    (%eax),%ecx
  80048c:	8b 45 10             	mov    0x10(%ebp),%eax
  80048f:	8b 00                	mov    (%eax),%eax
  800491:	89 cb                	mov    %ecx,%ebx
  800493:	29 c3                	sub    %eax,%ebx
  800495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800498:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80049f:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 08                	mov    (%eax),%ecx
  8004a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	29 c1                	sub    %eax,%ecx
  8004ad:	89 c8                	mov    %ecx,%eax
  8004af:	0f af c3             	imul   %ebx,%eax
  8004b2:	01 c2                	add    %eax,%edx
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	89 10                	mov    %edx,(%eax)

	(*med) = KthElement(Elements, NumOfElements, NumOfElements/2);

	(*mean) /= NumOfElements;
	(*var) = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b9:	ff 45 f4             	incl   -0xc(%ebp)
  8004bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004bf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004c2:	7c b2                	jl     800476 <ArrayStats+0x101>
	{
		(*var) += (Elements[i] - (*mean))*(Elements[i] - (*mean));
	}
	(*var) /= NumOfElements;
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	8b 00                	mov    (%eax),%eax
  8004c9:	99                   	cltd   
  8004ca:	f7 7d 0c             	idivl  0xc(%ebp)
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d2:	89 10                	mov    %edx,(%eax)
}
  8004d4:	90                   	nop
  8004d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <Swap>:

///Private Functions
void Swap(int *Elements, int First, int Second)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8004e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	01 d0                	add    %edx,%eax
  8004ef:	8b 00                	mov    (%eax),%eax
  8004f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	01 c2                	add    %eax,%edx
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	01 c8                	add    %ecx,%eax
  800512:	8b 00                	mov    (%eax),%eax
  800514:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800516:	8b 45 10             	mov    0x10(%ebp),%eax
  800519:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	01 c2                	add    %eax,%edx
  800525:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800528:	89 02                	mov    %eax,(%edx)
}
  80052a:	90                   	nop
  80052b:	c9                   	leave  
  80052c:	c3                   	ret    

0080052d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800533:	e8 22 19 00 00       	call   801e5a <sys_getenvindex>
  800538:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80053b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80053e:	89 d0                	mov    %edx,%eax
  800540:	c1 e0 03             	shl    $0x3,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800550:	01 d0                	add    %edx,%eax
  800552:	c1 e0 04             	shl    $0x4,%eax
  800555:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80055a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80055f:	a1 20 40 80 00       	mov    0x804020,%eax
  800564:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80056a:	84 c0                	test   %al,%al
  80056c:	74 0f                	je     80057d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80056e:	a1 20 40 80 00       	mov    0x804020,%eax
  800573:	05 5c 05 00 00       	add    $0x55c,%eax
  800578:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80057d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800581:	7e 0a                	jle    80058d <libmain+0x60>
		binaryname = argv[0];
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	ff 75 0c             	pushl  0xc(%ebp)
  800593:	ff 75 08             	pushl  0x8(%ebp)
  800596:	e8 9d fa ff ff       	call   800038 <_main>
  80059b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80059e:	e8 c4 16 00 00       	call   801c67 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005a3:	83 ec 0c             	sub    $0xc,%esp
  8005a6:	68 18 37 80 00       	push   $0x803718
  8005ab:	e8 8d 01 00 00       	call   80073d <cprintf>
  8005b0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8005be:	a1 20 40 80 00       	mov    0x804020,%eax
  8005c3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8005c9:	83 ec 04             	sub    $0x4,%esp
  8005cc:	52                   	push   %edx
  8005cd:	50                   	push   %eax
  8005ce:	68 40 37 80 00       	push   $0x803740
  8005d3:	e8 65 01 00 00       	call   80073d <cprintf>
  8005d8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8005db:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8005e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005eb:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8005f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8005fc:	51                   	push   %ecx
  8005fd:	52                   	push   %edx
  8005fe:	50                   	push   %eax
  8005ff:	68 68 37 80 00       	push   $0x803768
  800604:	e8 34 01 00 00       	call   80073d <cprintf>
  800609:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80060c:	a1 20 40 80 00       	mov    0x804020,%eax
  800611:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800617:	83 ec 08             	sub    $0x8,%esp
  80061a:	50                   	push   %eax
  80061b:	68 c0 37 80 00       	push   $0x8037c0
  800620:	e8 18 01 00 00       	call   80073d <cprintf>
  800625:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800628:	83 ec 0c             	sub    $0xc,%esp
  80062b:	68 18 37 80 00       	push   $0x803718
  800630:	e8 08 01 00 00       	call   80073d <cprintf>
  800635:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800638:	e8 44 16 00 00       	call   801c81 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80063d:	e8 19 00 00 00       	call   80065b <exit>
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	6a 00                	push   $0x0
  800650:	e8 d1 17 00 00       	call   801e26 <sys_destroy_env>
  800655:	83 c4 10             	add    $0x10,%esp
}
  800658:	90                   	nop
  800659:	c9                   	leave  
  80065a:	c3                   	ret    

0080065b <exit>:

void
exit(void)
{
  80065b:	55                   	push   %ebp
  80065c:	89 e5                	mov    %esp,%ebp
  80065e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800661:	e8 26 18 00 00       	call   801e8c <sys_exit_env>
}
  800666:	90                   	nop
  800667:	c9                   	leave  
  800668:	c3                   	ret    

00800669 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800669:	55                   	push   %ebp
  80066a:	89 e5                	mov    %esp,%ebp
  80066c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	8d 48 01             	lea    0x1(%eax),%ecx
  800677:	8b 55 0c             	mov    0xc(%ebp),%edx
  80067a:	89 0a                	mov    %ecx,(%edx)
  80067c:	8b 55 08             	mov    0x8(%ebp),%edx
  80067f:	88 d1                	mov    %dl,%cl
  800681:	8b 55 0c             	mov    0xc(%ebp),%edx
  800684:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800688:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800692:	75 2c                	jne    8006c0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800694:	a0 24 40 80 00       	mov    0x804024,%al
  800699:	0f b6 c0             	movzbl %al,%eax
  80069c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80069f:	8b 12                	mov    (%edx),%edx
  8006a1:	89 d1                	mov    %edx,%ecx
  8006a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a6:	83 c2 08             	add    $0x8,%edx
  8006a9:	83 ec 04             	sub    $0x4,%esp
  8006ac:	50                   	push   %eax
  8006ad:	51                   	push   %ecx
  8006ae:	52                   	push   %edx
  8006af:	e8 05 14 00 00       	call   801ab9 <sys_cputs>
  8006b4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006c3:	8b 40 04             	mov    0x4(%eax),%eax
  8006c6:	8d 50 01             	lea    0x1(%eax),%edx
  8006c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006cc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006db:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006e2:	00 00 00 
	b.cnt = 0;
  8006e5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ec:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ef:	ff 75 0c             	pushl  0xc(%ebp)
  8006f2:	ff 75 08             	pushl  0x8(%ebp)
  8006f5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006fb:	50                   	push   %eax
  8006fc:	68 69 06 80 00       	push   $0x800669
  800701:	e8 11 02 00 00       	call   800917 <vprintfmt>
  800706:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800709:	a0 24 40 80 00       	mov    0x804024,%al
  80070e:	0f b6 c0             	movzbl %al,%eax
  800711:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800717:	83 ec 04             	sub    $0x4,%esp
  80071a:	50                   	push   %eax
  80071b:	52                   	push   %edx
  80071c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800722:	83 c0 08             	add    $0x8,%eax
  800725:	50                   	push   %eax
  800726:	e8 8e 13 00 00       	call   801ab9 <sys_cputs>
  80072b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80072e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800735:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80073b:	c9                   	leave  
  80073c:	c3                   	ret    

0080073d <cprintf>:

int cprintf(const char *fmt, ...) {
  80073d:	55                   	push   %ebp
  80073e:	89 e5                	mov    %esp,%ebp
  800740:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800743:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80074a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80074d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 f4             	pushl  -0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	e8 73 ff ff ff       	call   8006d2 <vcprintf>
  80075f:	83 c4 10             	add    $0x10,%esp
  800762:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800765:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800770:	e8 f2 14 00 00       	call   801c67 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800775:	8d 45 0c             	lea    0xc(%ebp),%eax
  800778:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	ff 75 f4             	pushl  -0xc(%ebp)
  800784:	50                   	push   %eax
  800785:	e8 48 ff ff ff       	call   8006d2 <vcprintf>
  80078a:	83 c4 10             	add    $0x10,%esp
  80078d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800790:	e8 ec 14 00 00       	call   801c81 <sys_enable_interrupt>
	return cnt;
  800795:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800798:	c9                   	leave  
  800799:	c3                   	ret    

0080079a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	53                   	push   %ebx
  80079e:	83 ec 14             	sub    $0x14,%esp
  8007a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007ad:	8b 45 18             	mov    0x18(%ebp),%eax
  8007b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007b5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007b8:	77 55                	ja     80080f <printnum+0x75>
  8007ba:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007bd:	72 05                	jb     8007c4 <printnum+0x2a>
  8007bf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007c2:	77 4b                	ja     80080f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007c4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8007cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007d2:	52                   	push   %edx
  8007d3:	50                   	push   %eax
  8007d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007da:	e8 45 2c 00 00       	call   803424 <__udivdi3>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	83 ec 04             	sub    $0x4,%esp
  8007e5:	ff 75 20             	pushl  0x20(%ebp)
  8007e8:	53                   	push   %ebx
  8007e9:	ff 75 18             	pushl  0x18(%ebp)
  8007ec:	52                   	push   %edx
  8007ed:	50                   	push   %eax
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	ff 75 08             	pushl  0x8(%ebp)
  8007f4:	e8 a1 ff ff ff       	call   80079a <printnum>
  8007f9:	83 c4 20             	add    $0x20,%esp
  8007fc:	eb 1a                	jmp    800818 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	ff 75 0c             	pushl  0xc(%ebp)
  800804:	ff 75 20             	pushl  0x20(%ebp)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	ff d0                	call   *%eax
  80080c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80080f:	ff 4d 1c             	decl   0x1c(%ebp)
  800812:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800816:	7f e6                	jg     8007fe <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800818:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80081b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800823:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800826:	53                   	push   %ebx
  800827:	51                   	push   %ecx
  800828:	52                   	push   %edx
  800829:	50                   	push   %eax
  80082a:	e8 05 2d 00 00       	call   803534 <__umoddi3>
  80082f:	83 c4 10             	add    $0x10,%esp
  800832:	05 f4 39 80 00       	add    $0x8039f4,%eax
  800837:	8a 00                	mov    (%eax),%al
  800839:	0f be c0             	movsbl %al,%eax
  80083c:	83 ec 08             	sub    $0x8,%esp
  80083f:	ff 75 0c             	pushl  0xc(%ebp)
  800842:	50                   	push   %eax
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	ff d0                	call   *%eax
  800848:	83 c4 10             	add    $0x10,%esp
}
  80084b:	90                   	nop
  80084c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80084f:	c9                   	leave  
  800850:	c3                   	ret    

00800851 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800854:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800858:	7e 1c                	jle    800876 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 00                	mov    (%eax),%eax
  80085f:	8d 50 08             	lea    0x8(%eax),%edx
  800862:	8b 45 08             	mov    0x8(%ebp),%eax
  800865:	89 10                	mov    %edx,(%eax)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	83 e8 08             	sub    $0x8,%eax
  80086f:	8b 50 04             	mov    0x4(%eax),%edx
  800872:	8b 00                	mov    (%eax),%eax
  800874:	eb 40                	jmp    8008b6 <getuint+0x65>
	else if (lflag)
  800876:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80087a:	74 1e                	je     80089a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80087c:	8b 45 08             	mov    0x8(%ebp),%eax
  80087f:	8b 00                	mov    (%eax),%eax
  800881:	8d 50 04             	lea    0x4(%eax),%edx
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	89 10                	mov    %edx,(%eax)
  800889:	8b 45 08             	mov    0x8(%ebp),%eax
  80088c:	8b 00                	mov    (%eax),%eax
  80088e:	83 e8 04             	sub    $0x4,%eax
  800891:	8b 00                	mov    (%eax),%eax
  800893:	ba 00 00 00 00       	mov    $0x0,%edx
  800898:	eb 1c                	jmp    8008b6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 00                	mov    (%eax),%eax
  80089f:	8d 50 04             	lea    0x4(%eax),%edx
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	89 10                	mov    %edx,(%eax)
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	83 e8 04             	sub    $0x4,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008bf:	7e 1c                	jle    8008dd <getint+0x25>
		return va_arg(*ap, long long);
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	8b 00                	mov    (%eax),%eax
  8008c6:	8d 50 08             	lea    0x8(%eax),%edx
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	89 10                	mov    %edx,(%eax)
  8008ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 e8 08             	sub    $0x8,%eax
  8008d6:	8b 50 04             	mov    0x4(%eax),%edx
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	eb 38                	jmp    800915 <getint+0x5d>
	else if (lflag)
  8008dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e1:	74 1a                	je     8008fd <getint+0x45>
		return va_arg(*ap, long);
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	8b 00                	mov    (%eax),%eax
  8008e8:	8d 50 04             	lea    0x4(%eax),%edx
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	89 10                	mov    %edx,(%eax)
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	8b 00                	mov    (%eax),%eax
  8008f5:	83 e8 04             	sub    $0x4,%eax
  8008f8:	8b 00                	mov    (%eax),%eax
  8008fa:	99                   	cltd   
  8008fb:	eb 18                	jmp    800915 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8008fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800900:	8b 00                	mov    (%eax),%eax
  800902:	8d 50 04             	lea    0x4(%eax),%edx
  800905:	8b 45 08             	mov    0x8(%ebp),%eax
  800908:	89 10                	mov    %edx,(%eax)
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	8b 00                	mov    (%eax),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 00                	mov    (%eax),%eax
  800914:	99                   	cltd   
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	56                   	push   %esi
  80091b:	53                   	push   %ebx
  80091c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80091f:	eb 17                	jmp    800938 <vprintfmt+0x21>
			if (ch == '\0')
  800921:	85 db                	test   %ebx,%ebx
  800923:	0f 84 af 03 00 00    	je     800cd8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800929:	83 ec 08             	sub    $0x8,%esp
  80092c:	ff 75 0c             	pushl  0xc(%ebp)
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	ff d0                	call   *%eax
  800935:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800938:	8b 45 10             	mov    0x10(%ebp),%eax
  80093b:	8d 50 01             	lea    0x1(%eax),%edx
  80093e:	89 55 10             	mov    %edx,0x10(%ebp)
  800941:	8a 00                	mov    (%eax),%al
  800943:	0f b6 d8             	movzbl %al,%ebx
  800946:	83 fb 25             	cmp    $0x25,%ebx
  800949:	75 d6                	jne    800921 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80094b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80094f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800956:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80095d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800964:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80096b:	8b 45 10             	mov    0x10(%ebp),%eax
  80096e:	8d 50 01             	lea    0x1(%eax),%edx
  800971:	89 55 10             	mov    %edx,0x10(%ebp)
  800974:	8a 00                	mov    (%eax),%al
  800976:	0f b6 d8             	movzbl %al,%ebx
  800979:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80097c:	83 f8 55             	cmp    $0x55,%eax
  80097f:	0f 87 2b 03 00 00    	ja     800cb0 <vprintfmt+0x399>
  800985:	8b 04 85 18 3a 80 00 	mov    0x803a18(,%eax,4),%eax
  80098c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80098e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800992:	eb d7                	jmp    80096b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800994:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800998:	eb d1                	jmp    80096b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80099a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a4:	89 d0                	mov    %edx,%eax
  8009a6:	c1 e0 02             	shl    $0x2,%eax
  8009a9:	01 d0                	add    %edx,%eax
  8009ab:	01 c0                	add    %eax,%eax
  8009ad:	01 d8                	add    %ebx,%eax
  8009af:	83 e8 30             	sub    $0x30,%eax
  8009b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009b8:	8a 00                	mov    (%eax),%al
  8009ba:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009bd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009c0:	7e 3e                	jle    800a00 <vprintfmt+0xe9>
  8009c2:	83 fb 39             	cmp    $0x39,%ebx
  8009c5:	7f 39                	jg     800a00 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009ca:	eb d5                	jmp    8009a1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cf:	83 c0 04             	add    $0x4,%eax
  8009d2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d8:	83 e8 04             	sub    $0x4,%eax
  8009db:	8b 00                	mov    (%eax),%eax
  8009dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009e0:	eb 1f                	jmp    800a01 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009e6:	79 83                	jns    80096b <vprintfmt+0x54>
				width = 0;
  8009e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ef:	e9 77 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8009f4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8009fb:	e9 6b ff ff ff       	jmp    80096b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a00:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a01:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a05:	0f 89 60 ff ff ff    	jns    80096b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a11:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a18:	e9 4e ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a20:	e9 46 ff ff ff       	jmp    80096b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	50                   	push   %eax
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	ff d0                	call   *%eax
  800a42:	83 c4 10             	add    $0x10,%esp
			break;
  800a45:	e9 89 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a4a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4d:	83 c0 04             	add    $0x4,%eax
  800a50:	89 45 14             	mov    %eax,0x14(%ebp)
  800a53:	8b 45 14             	mov    0x14(%ebp),%eax
  800a56:	83 e8 04             	sub    $0x4,%eax
  800a59:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a5b:	85 db                	test   %ebx,%ebx
  800a5d:	79 02                	jns    800a61 <vprintfmt+0x14a>
				err = -err;
  800a5f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a61:	83 fb 64             	cmp    $0x64,%ebx
  800a64:	7f 0b                	jg     800a71 <vprintfmt+0x15a>
  800a66:	8b 34 9d 60 38 80 00 	mov    0x803860(,%ebx,4),%esi
  800a6d:	85 f6                	test   %esi,%esi
  800a6f:	75 19                	jne    800a8a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a71:	53                   	push   %ebx
  800a72:	68 05 3a 80 00       	push   $0x803a05
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 5e 02 00 00       	call   800ce0 <printfmt>
  800a82:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a85:	e9 49 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8a:	56                   	push   %esi
  800a8b:	68 0e 3a 80 00       	push   $0x803a0e
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	ff 75 08             	pushl  0x8(%ebp)
  800a96:	e8 45 02 00 00       	call   800ce0 <printfmt>
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 30 02 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	83 c0 04             	add    $0x4,%eax
  800aa9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aac:	8b 45 14             	mov    0x14(%ebp),%eax
  800aaf:	83 e8 04             	sub    $0x4,%eax
  800ab2:	8b 30                	mov    (%eax),%esi
  800ab4:	85 f6                	test   %esi,%esi
  800ab6:	75 05                	jne    800abd <vprintfmt+0x1a6>
				p = "(null)";
  800ab8:	be 11 3a 80 00       	mov    $0x803a11,%esi
			if (width > 0 && padc != '-')
  800abd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac1:	7e 6d                	jle    800b30 <vprintfmt+0x219>
  800ac3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ac7:	74 67                	je     800b30 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	50                   	push   %eax
  800ad0:	56                   	push   %esi
  800ad1:	e8 0c 03 00 00       	call   800de2 <strnlen>
  800ad6:	83 c4 10             	add    $0x10,%esp
  800ad9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800adc:	eb 16                	jmp    800af4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ade:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 0c             	pushl  0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  800aec:	ff d0                	call   *%eax
  800aee:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af1:	ff 4d e4             	decl   -0x1c(%ebp)
  800af4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800af8:	7f e4                	jg     800ade <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800afa:	eb 34                	jmp    800b30 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800afc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b00:	74 1c                	je     800b1e <vprintfmt+0x207>
  800b02:	83 fb 1f             	cmp    $0x1f,%ebx
  800b05:	7e 05                	jle    800b0c <vprintfmt+0x1f5>
  800b07:	83 fb 7e             	cmp    $0x7e,%ebx
  800b0a:	7e 12                	jle    800b1e <vprintfmt+0x207>
					putch('?', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 3f                	push   $0x3f
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
  800b1c:	eb 0f                	jmp    800b2d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	53                   	push   %ebx
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	ff d0                	call   *%eax
  800b2a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b2d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b30:	89 f0                	mov    %esi,%eax
  800b32:	8d 70 01             	lea    0x1(%eax),%esi
  800b35:	8a 00                	mov    (%eax),%al
  800b37:	0f be d8             	movsbl %al,%ebx
  800b3a:	85 db                	test   %ebx,%ebx
  800b3c:	74 24                	je     800b62 <vprintfmt+0x24b>
  800b3e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b42:	78 b8                	js     800afc <vprintfmt+0x1e5>
  800b44:	ff 4d e0             	decl   -0x20(%ebp)
  800b47:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b4b:	79 af                	jns    800afc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b4d:	eb 13                	jmp    800b62 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b4f:	83 ec 08             	sub    $0x8,%esp
  800b52:	ff 75 0c             	pushl  0xc(%ebp)
  800b55:	6a 20                	push   $0x20
  800b57:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5a:	ff d0                	call   *%eax
  800b5c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b66:	7f e7                	jg     800b4f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b68:	e9 66 01 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 e8             	pushl  -0x18(%ebp)
  800b73:	8d 45 14             	lea    0x14(%ebp),%eax
  800b76:	50                   	push   %eax
  800b77:	e8 3c fd ff ff       	call   8008b8 <getint>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b8b:	85 d2                	test   %edx,%edx
  800b8d:	79 23                	jns    800bb2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b8f:	83 ec 08             	sub    $0x8,%esp
  800b92:	ff 75 0c             	pushl  0xc(%ebp)
  800b95:	6a 2d                	push   $0x2d
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	ff d0                	call   *%eax
  800b9c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ba2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ba5:	f7 d8                	neg    %eax
  800ba7:	83 d2 00             	adc    $0x0,%edx
  800baa:	f7 da                	neg    %edx
  800bac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800baf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bb2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bb9:	e9 bc 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc7:	50                   	push   %eax
  800bc8:	e8 84 fc ff ff       	call   800851 <getuint>
  800bcd:	83 c4 10             	add    $0x10,%esp
  800bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800bd6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bdd:	e9 98 00 00 00       	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	ff 75 0c             	pushl  0xc(%ebp)
  800be8:	6a 58                	push   $0x58
  800bea:	8b 45 08             	mov    0x8(%ebp),%eax
  800bed:	ff d0                	call   *%eax
  800bef:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	ff 75 0c             	pushl  0xc(%ebp)
  800bf8:	6a 58                	push   $0x58
  800bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfd:	ff d0                	call   *%eax
  800bff:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 0c             	pushl  0xc(%ebp)
  800c08:	6a 58                	push   $0x58
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	ff d0                	call   *%eax
  800c0f:	83 c4 10             	add    $0x10,%esp
			break;
  800c12:	e9 bc 00 00 00       	jmp    800cd3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	ff 75 0c             	pushl  0xc(%ebp)
  800c1d:	6a 30                	push   $0x30
  800c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c22:	ff d0                	call   *%eax
  800c24:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 78                	push   $0x78
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	83 c0 04             	add    $0x4,%eax
  800c3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c40:	8b 45 14             	mov    0x14(%ebp),%eax
  800c43:	83 e8 04             	sub    $0x4,%eax
  800c46:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c52:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c59:	eb 1f                	jmp    800c7a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c61:	8d 45 14             	lea    0x14(%ebp),%eax
  800c64:	50                   	push   %eax
  800c65:	e8 e7 fb ff ff       	call   800851 <getuint>
  800c6a:	83 c4 10             	add    $0x10,%esp
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c73:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c7a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c81:	83 ec 04             	sub    $0x4,%esp
  800c84:	52                   	push   %edx
  800c85:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c88:	50                   	push   %eax
  800c89:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c8f:	ff 75 0c             	pushl  0xc(%ebp)
  800c92:	ff 75 08             	pushl  0x8(%ebp)
  800c95:	e8 00 fb ff ff       	call   80079a <printnum>
  800c9a:	83 c4 20             	add    $0x20,%esp
			break;
  800c9d:	eb 34                	jmp    800cd3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c9f:	83 ec 08             	sub    $0x8,%esp
  800ca2:	ff 75 0c             	pushl  0xc(%ebp)
  800ca5:	53                   	push   %ebx
  800ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca9:	ff d0                	call   *%eax
  800cab:	83 c4 10             	add    $0x10,%esp
			break;
  800cae:	eb 23                	jmp    800cd3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	6a 25                	push   $0x25
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	ff d0                	call   *%eax
  800cbd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cc0:	ff 4d 10             	decl   0x10(%ebp)
  800cc3:	eb 03                	jmp    800cc8 <vprintfmt+0x3b1>
  800cc5:	ff 4d 10             	decl   0x10(%ebp)
  800cc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ccb:	48                   	dec    %eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	3c 25                	cmp    $0x25,%al
  800cd0:	75 f3                	jne    800cc5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cd2:	90                   	nop
		}
	}
  800cd3:	e9 47 fc ff ff       	jmp    80091f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800cd8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800cd9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cdc:	5b                   	pop    %ebx
  800cdd:	5e                   	pop    %esi
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ce6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ce9:	83 c0 04             	add    $0x4,%eax
  800cec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cef:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	50                   	push   %eax
  800cf6:	ff 75 0c             	pushl  0xc(%ebp)
  800cf9:	ff 75 08             	pushl  0x8(%ebp)
  800cfc:	e8 16 fc ff ff       	call   800917 <vprintfmt>
  800d01:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d04:	90                   	nop
  800d05:	c9                   	leave  
  800d06:	c3                   	ret    

00800d07 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0d:	8b 40 08             	mov    0x8(%eax),%eax
  800d10:	8d 50 01             	lea    0x1(%eax),%edx
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1c:	8b 10                	mov    (%eax),%edx
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8b 40 04             	mov    0x4(%eax),%eax
  800d24:	39 c2                	cmp    %eax,%edx
  800d26:	73 12                	jae    800d3a <sprintputch+0x33>
		*b->buf++ = ch;
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	8b 00                	mov    (%eax),%eax
  800d2d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d33:	89 0a                	mov    %ecx,(%edx)
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	88 10                	mov    %dl,(%eax)
}
  800d3a:	90                   	nop
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	01 d0                	add    %edx,%eax
  800d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d62:	74 06                	je     800d6a <vsnprintf+0x2d>
  800d64:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d68:	7f 07                	jg     800d71 <vsnprintf+0x34>
		return -E_INVAL;
  800d6a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6f:	eb 20                	jmp    800d91 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d71:	ff 75 14             	pushl  0x14(%ebp)
  800d74:	ff 75 10             	pushl  0x10(%ebp)
  800d77:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d7a:	50                   	push   %eax
  800d7b:	68 07 0d 80 00       	push   $0x800d07
  800d80:	e8 92 fb ff ff       	call   800917 <vprintfmt>
  800d85:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d8b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d91:	c9                   	leave  
  800d92:	c3                   	ret    

00800d93 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d99:	8d 45 10             	lea    0x10(%ebp),%eax
  800d9c:	83 c0 04             	add    $0x4,%eax
  800d9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800da2:	8b 45 10             	mov    0x10(%ebp),%eax
  800da5:	ff 75 f4             	pushl  -0xc(%ebp)
  800da8:	50                   	push   %eax
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 89 ff ff ff       	call   800d3d <vsnprintf>
  800db4:	83 c4 10             	add    $0x10,%esp
  800db7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dbd:	c9                   	leave  
  800dbe:	c3                   	ret    

00800dbf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dcc:	eb 06                	jmp    800dd4 <strlen+0x15>
		n++;
  800dce:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd1:	ff 45 08             	incl   0x8(%ebp)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	75 f1                	jne    800dce <strlen+0xf>
		n++;
	return n;
  800ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800def:	eb 09                	jmp    800dfa <strnlen+0x18>
		n++;
  800df1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df4:	ff 45 08             	incl   0x8(%ebp)
  800df7:	ff 4d 0c             	decl   0xc(%ebp)
  800dfa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfe:	74 09                	je     800e09 <strnlen+0x27>
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	8a 00                	mov    (%eax),%al
  800e05:	84 c0                	test   %al,%al
  800e07:	75 e8                	jne    800df1 <strnlen+0xf>
		n++;
	return n;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0c:	c9                   	leave  
  800e0d:	c3                   	ret    

00800e0e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e1a:	90                   	nop
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8d 50 01             	lea    0x1(%eax),%edx
  800e21:	89 55 08             	mov    %edx,0x8(%ebp)
  800e24:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e27:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e2d:	8a 12                	mov    (%edx),%dl
  800e2f:	88 10                	mov    %dl,(%eax)
  800e31:	8a 00                	mov    (%eax),%al
  800e33:	84 c0                	test   %al,%al
  800e35:	75 e4                	jne    800e1b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e37:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4f:	eb 1f                	jmp    800e70 <strncpy+0x34>
		*dst++ = *src;
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 08             	mov    %edx,0x8(%ebp)
  800e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5d:	8a 12                	mov    (%edx),%dl
  800e5f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e64:	8a 00                	mov    (%eax),%al
  800e66:	84 c0                	test   %al,%al
  800e68:	74 03                	je     800e6d <strncpy+0x31>
			src++;
  800e6a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6d:	ff 45 fc             	incl   -0x4(%ebp)
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e76:	72 d9                	jb     800e51 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e89:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8d:	74 30                	je     800ebf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e8f:	eb 16                	jmp    800ea7 <strlcpy+0x2a>
			*dst++ = *src++;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8d 50 01             	lea    0x1(%eax),%edx
  800e97:	89 55 08             	mov    %edx,0x8(%ebp)
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ea3:	8a 12                	mov    (%edx),%dl
  800ea5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea7:	ff 4d 10             	decl   0x10(%ebp)
  800eaa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eae:	74 09                	je     800eb9 <strlcpy+0x3c>
  800eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 d8                	jne    800e91 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec5:	29 c2                	sub    %eax,%edx
  800ec7:	89 d0                	mov    %edx,%eax
}
  800ec9:	c9                   	leave  
  800eca:	c3                   	ret    

00800ecb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ece:	eb 06                	jmp    800ed6 <strcmp+0xb>
		p++, q++;
  800ed0:	ff 45 08             	incl   0x8(%ebp)
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8a 00                	mov    (%eax),%al
  800edb:	84 c0                	test   %al,%al
  800edd:	74 0e                	je     800eed <strcmp+0x22>
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee2:	8a 10                	mov    (%eax),%dl
  800ee4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	38 c2                	cmp    %al,%dl
  800eeb:	74 e3                	je     800ed0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800eed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef0:	8a 00                	mov    (%eax),%al
  800ef2:	0f b6 d0             	movzbl %al,%edx
  800ef5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef8:	8a 00                	mov    (%eax),%al
  800efa:	0f b6 c0             	movzbl %al,%eax
  800efd:	29 c2                	sub    %eax,%edx
  800eff:	89 d0                	mov    %edx,%eax
}
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f06:	eb 09                	jmp    800f11 <strncmp+0xe>
		n--, p++, q++;
  800f08:	ff 4d 10             	decl   0x10(%ebp)
  800f0b:	ff 45 08             	incl   0x8(%ebp)
  800f0e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f15:	74 17                	je     800f2e <strncmp+0x2b>
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	84 c0                	test   %al,%al
  800f1e:	74 0e                	je     800f2e <strncmp+0x2b>
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 10                	mov    (%eax),%dl
  800f25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f28:	8a 00                	mov    (%eax),%al
  800f2a:	38 c2                	cmp    %al,%dl
  800f2c:	74 da                	je     800f08 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f32:	75 07                	jne    800f3b <strncmp+0x38>
		return 0;
  800f34:	b8 00 00 00 00       	mov    $0x0,%eax
  800f39:	eb 14                	jmp    800f4f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	8a 00                	mov    (%eax),%al
  800f40:	0f b6 d0             	movzbl %al,%edx
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 c0             	movzbl %al,%eax
  800f4b:	29 c2                	sub    %eax,%edx
  800f4d:	89 d0                	mov    %edx,%eax
}
  800f4f:	5d                   	pop    %ebp
  800f50:	c3                   	ret    

00800f51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f51:	55                   	push   %ebp
  800f52:	89 e5                	mov    %esp,%ebp
  800f54:	83 ec 04             	sub    $0x4,%esp
  800f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f5d:	eb 12                	jmp    800f71 <strchr+0x20>
		if (*s == c)
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f67:	75 05                	jne    800f6e <strchr+0x1d>
			return (char *) s;
  800f69:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6c:	eb 11                	jmp    800f7f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f6e:	ff 45 08             	incl   0x8(%ebp)
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 e5                	jne    800f5f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	83 ec 04             	sub    $0x4,%esp
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f8d:	eb 0d                	jmp    800f9c <strfind+0x1b>
		if (*s == c)
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f97:	74 0e                	je     800fa7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f99:	ff 45 08             	incl   0x8(%ebp)
  800f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	84 c0                	test   %al,%al
  800fa3:	75 ea                	jne    800f8f <strfind+0xe>
  800fa5:	eb 01                	jmp    800fa8 <strfind+0x27>
		if (*s == c)
			break;
  800fa7:	90                   	nop
	return (char *) s;
  800fa8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fbf:	eb 0e                	jmp    800fcf <memset+0x22>
		*p++ = c;
  800fc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc4:	8d 50 01             	lea    0x1(%eax),%edx
  800fc7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fcf:	ff 4d f8             	decl   -0x8(%ebp)
  800fd2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fd6:	79 e9                	jns    800fc1 <memset+0x14>
		*p++ = c;

	return v;
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fdb:	c9                   	leave  
  800fdc:	c3                   	ret    

00800fdd <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fef:	eb 16                	jmp    801007 <memcpy+0x2a>
		*d++ = *s++;
  800ff1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ff4:	8d 50 01             	lea    0x1(%eax),%edx
  800ff7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ffa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ffd:	8d 4a 01             	lea    0x1(%edx),%ecx
  801000:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801003:	8a 12                	mov    (%edx),%dl
  801005:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80100d:	89 55 10             	mov    %edx,0x10(%ebp)
  801010:	85 c0                	test   %eax,%eax
  801012:	75 dd                	jne    800ff1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80101f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801022:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80102b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801031:	73 50                	jae    801083 <memmove+0x6a>
  801033:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801036:	8b 45 10             	mov    0x10(%ebp),%eax
  801039:	01 d0                	add    %edx,%eax
  80103b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80103e:	76 43                	jbe    801083 <memmove+0x6a>
		s += n;
  801040:	8b 45 10             	mov    0x10(%ebp),%eax
  801043:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80104c:	eb 10                	jmp    80105e <memmove+0x45>
			*--d = *--s;
  80104e:	ff 4d f8             	decl   -0x8(%ebp)
  801051:	ff 4d fc             	decl   -0x4(%ebp)
  801054:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801057:	8a 10                	mov    (%eax),%dl
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80105e:	8b 45 10             	mov    0x10(%ebp),%eax
  801061:	8d 50 ff             	lea    -0x1(%eax),%edx
  801064:	89 55 10             	mov    %edx,0x10(%ebp)
  801067:	85 c0                	test   %eax,%eax
  801069:	75 e3                	jne    80104e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80106b:	eb 23                	jmp    801090 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80106d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801070:	8d 50 01             	lea    0x1(%eax),%edx
  801073:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801076:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801079:	8d 4a 01             	lea    0x1(%edx),%ecx
  80107c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80107f:	8a 12                	mov    (%edx),%dl
  801081:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	8d 50 ff             	lea    -0x1(%eax),%edx
  801089:	89 55 10             	mov    %edx,0x10(%ebp)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	75 dd                	jne    80106d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80109b:	8b 45 08             	mov    0x8(%ebp),%eax
  80109e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010a7:	eb 2a                	jmp    8010d3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ac:	8a 10                	mov    (%eax),%dl
  8010ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b1:	8a 00                	mov    (%eax),%al
  8010b3:	38 c2                	cmp    %al,%dl
  8010b5:	74 16                	je     8010cd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ba:	8a 00                	mov    (%eax),%al
  8010bc:	0f b6 d0             	movzbl %al,%edx
  8010bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c2:	8a 00                	mov    (%eax),%al
  8010c4:	0f b6 c0             	movzbl %al,%eax
  8010c7:	29 c2                	sub    %eax,%edx
  8010c9:	89 d0                	mov    %edx,%eax
  8010cb:	eb 18                	jmp    8010e5 <memcmp+0x50>
		s1++, s2++;
  8010cd:	ff 45 fc             	incl   -0x4(%ebp)
  8010d0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	75 c9                	jne    8010a9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e5:	c9                   	leave  
  8010e6:	c3                   	ret    

008010e7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8010f8:	eb 15                	jmp    80110f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f b6 d0             	movzbl %al,%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	0f b6 c0             	movzbl %al,%eax
  801108:	39 c2                	cmp    %eax,%edx
  80110a:	74 0d                	je     801119 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801115:	72 e3                	jb     8010fa <memfind+0x13>
  801117:	eb 01                	jmp    80111a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801119:	90                   	nop
	return (void *) s;
  80111a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80111d:	c9                   	leave  
  80111e:	c3                   	ret    

0080111f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801125:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80112c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801133:	eb 03                	jmp    801138 <strtol+0x19>
		s++;
  801135:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	8a 00                	mov    (%eax),%al
  80113d:	3c 20                	cmp    $0x20,%al
  80113f:	74 f4                	je     801135 <strtol+0x16>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 09                	cmp    $0x9,%al
  801148:	74 eb                	je     801135 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 2b                	cmp    $0x2b,%al
  801151:	75 05                	jne    801158 <strtol+0x39>
		s++;
  801153:	ff 45 08             	incl   0x8(%ebp)
  801156:	eb 13                	jmp    80116b <strtol+0x4c>
	else if (*s == '-')
  801158:	8b 45 08             	mov    0x8(%ebp),%eax
  80115b:	8a 00                	mov    (%eax),%al
  80115d:	3c 2d                	cmp    $0x2d,%al
  80115f:	75 0a                	jne    80116b <strtol+0x4c>
		s++, neg = 1;
  801161:	ff 45 08             	incl   0x8(%ebp)
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116f:	74 06                	je     801177 <strtol+0x58>
  801171:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801175:	75 20                	jne    801197 <strtol+0x78>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 30                	cmp    $0x30,%al
  80117e:	75 17                	jne    801197 <strtol+0x78>
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	40                   	inc    %eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	3c 78                	cmp    $0x78,%al
  801188:	75 0d                	jne    801197 <strtol+0x78>
		s += 2, base = 16;
  80118a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80118e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801195:	eb 28                	jmp    8011bf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801197:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119b:	75 15                	jne    8011b2 <strtol+0x93>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	3c 30                	cmp    $0x30,%al
  8011a4:	75 0c                	jne    8011b2 <strtol+0x93>
		s++, base = 8;
  8011a6:	ff 45 08             	incl   0x8(%ebp)
  8011a9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011b0:	eb 0d                	jmp    8011bf <strtol+0xa0>
	else if (base == 0)
  8011b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011b6:	75 07                	jne    8011bf <strtol+0xa0>
		base = 10;
  8011b8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	8a 00                	mov    (%eax),%al
  8011c4:	3c 2f                	cmp    $0x2f,%al
  8011c6:	7e 19                	jle    8011e1 <strtol+0xc2>
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	8a 00                	mov    (%eax),%al
  8011cd:	3c 39                	cmp    $0x39,%al
  8011cf:	7f 10                	jg     8011e1 <strtol+0xc2>
			dig = *s - '0';
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	8a 00                	mov    (%eax),%al
  8011d6:	0f be c0             	movsbl %al,%eax
  8011d9:	83 e8 30             	sub    $0x30,%eax
  8011dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011df:	eb 42                	jmp    801223 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	3c 60                	cmp    $0x60,%al
  8011e8:	7e 19                	jle    801203 <strtol+0xe4>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 7a                	cmp    $0x7a,%al
  8011f1:	7f 10                	jg     801203 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	8a 00                	mov    (%eax),%al
  8011f8:	0f be c0             	movsbl %al,%eax
  8011fb:	83 e8 57             	sub    $0x57,%eax
  8011fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801201:	eb 20                	jmp    801223 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	3c 40                	cmp    $0x40,%al
  80120a:	7e 39                	jle    801245 <strtol+0x126>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 5a                	cmp    $0x5a,%al
  801213:	7f 30                	jg     801245 <strtol+0x126>
			dig = *s - 'A' + 10;
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	83 e8 37             	sub    $0x37,%eax
  801220:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801223:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801226:	3b 45 10             	cmp    0x10(%ebp),%eax
  801229:	7d 19                	jge    801244 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80122b:	ff 45 08             	incl   0x8(%ebp)
  80122e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801231:	0f af 45 10          	imul   0x10(%ebp),%eax
  801235:	89 c2                	mov    %eax,%edx
  801237:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80123f:	e9 7b ff ff ff       	jmp    8011bf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801244:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801245:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801249:	74 08                	je     801253 <strtol+0x134>
		*endptr = (char *) s;
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801253:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801257:	74 07                	je     801260 <strtol+0x141>
  801259:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125c:	f7 d8                	neg    %eax
  80125e:	eb 03                	jmp    801263 <strtol+0x144>
  801260:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801263:	c9                   	leave  
  801264:	c3                   	ret    

00801265 <ltostr>:

void
ltostr(long value, char *str)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801272:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801279:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127d:	79 13                	jns    801292 <ltostr+0x2d>
	{
		neg = 1;
  80127f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801286:	8b 45 0c             	mov    0xc(%ebp),%eax
  801289:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80128c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80128f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80129a:	99                   	cltd   
  80129b:	f7 f9                	idiv   %ecx
  80129d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a3:	8d 50 01             	lea    0x1(%eax),%edx
  8012a6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a9:	89 c2                	mov    %eax,%edx
  8012ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012b3:	83 c2 30             	add    $0x30,%edx
  8012b6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012bb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012c0:	f7 e9                	imul   %ecx
  8012c2:	c1 fa 02             	sar    $0x2,%edx
  8012c5:	89 c8                	mov    %ecx,%eax
  8012c7:	c1 f8 1f             	sar    $0x1f,%eax
  8012ca:	29 c2                	sub    %eax,%edx
  8012cc:	89 d0                	mov    %edx,%eax
  8012ce:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012d4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d9:	f7 e9                	imul   %ecx
  8012db:	c1 fa 02             	sar    $0x2,%edx
  8012de:	89 c8                	mov    %ecx,%eax
  8012e0:	c1 f8 1f             	sar    $0x1f,%eax
  8012e3:	29 c2                	sub    %eax,%edx
  8012e5:	89 d0                	mov    %edx,%eax
  8012e7:	c1 e0 02             	shl    $0x2,%eax
  8012ea:	01 d0                	add    %edx,%eax
  8012ec:	01 c0                	add    %eax,%eax
  8012ee:	29 c1                	sub    %eax,%ecx
  8012f0:	89 ca                	mov    %ecx,%edx
  8012f2:	85 d2                	test   %edx,%edx
  8012f4:	75 9c                	jne    801292 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8012f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8012fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801300:	48                   	dec    %eax
  801301:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801304:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801308:	74 3d                	je     801347 <ltostr+0xe2>
		start = 1 ;
  80130a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801311:	eb 34                	jmp    801347 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801316:	8b 45 0c             	mov    0xc(%ebp),%eax
  801319:	01 d0                	add    %edx,%eax
  80131b:	8a 00                	mov    (%eax),%al
  80131d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	01 c2                	add    %eax,%edx
  801328:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80132b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132e:	01 c8                	add    %ecx,%eax
  801330:	8a 00                	mov    (%eax),%al
  801332:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801334:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	01 c2                	add    %eax,%edx
  80133c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80133f:	88 02                	mov    %al,(%edx)
		start++ ;
  801341:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801344:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134d:	7c c4                	jl     801313 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80134f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801352:	8b 45 0c             	mov    0xc(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80135a:	90                   	nop
  80135b:	c9                   	leave  
  80135c:	c3                   	ret    

0080135d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801363:	ff 75 08             	pushl  0x8(%ebp)
  801366:	e8 54 fa ff ff       	call   800dbf <strlen>
  80136b:	83 c4 04             	add    $0x4,%esp
  80136e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801371:	ff 75 0c             	pushl  0xc(%ebp)
  801374:	e8 46 fa ff ff       	call   800dbf <strlen>
  801379:	83 c4 04             	add    $0x4,%esp
  80137c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80137f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80138d:	eb 17                	jmp    8013a6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80138f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801392:	8b 45 10             	mov    0x10(%ebp),%eax
  801395:	01 c2                	add    %eax,%edx
  801397:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	01 c8                	add    %ecx,%eax
  80139f:	8a 00                	mov    (%eax),%al
  8013a1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013a3:	ff 45 fc             	incl   -0x4(%ebp)
  8013a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013ac:	7c e1                	jl     80138f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013bc:	eb 1f                	jmp    8013dd <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c1:	8d 50 01             	lea    0x1(%eax),%edx
  8013c4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013c7:	89 c2                	mov    %eax,%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 c2                	add    %eax,%edx
  8013ce:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 c8                	add    %ecx,%eax
  8013d6:	8a 00                	mov    (%eax),%al
  8013d8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013da:	ff 45 f8             	incl   -0x8(%ebp)
  8013dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e3:	7c d9                	jl     8013be <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013eb:	01 d0                	add    %edx,%eax
  8013ed:	c6 00 00             	movb   $0x0,(%eax)
}
  8013f0:	90                   	nop
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8013f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8013ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80140b:	8b 45 10             	mov    0x10(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801416:	eb 0c                	jmp    801424 <strsplit+0x31>
			*string++ = 0;
  801418:	8b 45 08             	mov    0x8(%ebp),%eax
  80141b:	8d 50 01             	lea    0x1(%eax),%edx
  80141e:	89 55 08             	mov    %edx,0x8(%ebp)
  801421:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801424:	8b 45 08             	mov    0x8(%ebp),%eax
  801427:	8a 00                	mov    (%eax),%al
  801429:	84 c0                	test   %al,%al
  80142b:	74 18                	je     801445 <strsplit+0x52>
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	0f be c0             	movsbl %al,%eax
  801435:	50                   	push   %eax
  801436:	ff 75 0c             	pushl  0xc(%ebp)
  801439:	e8 13 fb ff ff       	call   800f51 <strchr>
  80143e:	83 c4 08             	add    $0x8,%esp
  801441:	85 c0                	test   %eax,%eax
  801443:	75 d3                	jne    801418 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801445:	8b 45 08             	mov    0x8(%ebp),%eax
  801448:	8a 00                	mov    (%eax),%al
  80144a:	84 c0                	test   %al,%al
  80144c:	74 5a                	je     8014a8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80144e:	8b 45 14             	mov    0x14(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	83 f8 0f             	cmp    $0xf,%eax
  801456:	75 07                	jne    80145f <strsplit+0x6c>
		{
			return 0;
  801458:	b8 00 00 00 00       	mov    $0x0,%eax
  80145d:	eb 66                	jmp    8014c5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	8b 00                	mov    (%eax),%eax
  801464:	8d 48 01             	lea    0x1(%eax),%ecx
  801467:	8b 55 14             	mov    0x14(%ebp),%edx
  80146a:	89 0a                	mov    %ecx,(%edx)
  80146c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801473:	8b 45 10             	mov    0x10(%ebp),%eax
  801476:	01 c2                	add    %eax,%edx
  801478:	8b 45 08             	mov    0x8(%ebp),%eax
  80147b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80147d:	eb 03                	jmp    801482 <strsplit+0x8f>
			string++;
  80147f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801482:	8b 45 08             	mov    0x8(%ebp),%eax
  801485:	8a 00                	mov    (%eax),%al
  801487:	84 c0                	test   %al,%al
  801489:	74 8b                	je     801416 <strsplit+0x23>
  80148b:	8b 45 08             	mov    0x8(%ebp),%eax
  80148e:	8a 00                	mov    (%eax),%al
  801490:	0f be c0             	movsbl %al,%eax
  801493:	50                   	push   %eax
  801494:	ff 75 0c             	pushl  0xc(%ebp)
  801497:	e8 b5 fa ff ff       	call   800f51 <strchr>
  80149c:	83 c4 08             	add    $0x8,%esp
  80149f:	85 c0                	test   %eax,%eax
  8014a1:	74 dc                	je     80147f <strsplit+0x8c>
			string++;
	}
  8014a3:	e9 6e ff ff ff       	jmp    801416 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014a8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014b8:	01 d0                	add    %edx,%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014c0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014c5:	c9                   	leave  
  8014c6:	c3                   	ret    

008014c7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014c7:	55                   	push   %ebp
  8014c8:	89 e5                	mov    %esp,%ebp
  8014ca:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014cd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	74 1f                	je     8014f5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014d6:	e8 1d 00 00 00       	call   8014f8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014db:	83 ec 0c             	sub    $0xc,%esp
  8014de:	68 70 3b 80 00       	push   $0x803b70
  8014e3:	e8 55 f2 ff ff       	call   80073d <cprintf>
  8014e8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014eb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8014f2:	00 00 00 
	}
}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8014fe:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801505:	00 00 00 
  801508:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80150f:	00 00 00 
  801512:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801519:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80151c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801523:	00 00 00 
  801526:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80152d:	00 00 00 
  801530:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801537:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80153a:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801544:	c1 e8 0c             	shr    $0xc,%eax
  801547:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80154c:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801556:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80155b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801560:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801565:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80156c:	a1 20 41 80 00       	mov    0x804120,%eax
  801571:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801575:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801578:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80157f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801582:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801585:	01 d0                	add    %edx,%eax
  801587:	48                   	dec    %eax
  801588:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80158b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80158e:	ba 00 00 00 00       	mov    $0x0,%edx
  801593:	f7 75 e4             	divl   -0x1c(%ebp)
  801596:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801599:	29 d0                	sub    %edx,%eax
  80159b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  80159e:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8015a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015ad:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	6a 07                	push   $0x7
  8015b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ba:	50                   	push   %eax
  8015bb:	e8 3d 06 00 00       	call   801bfd <sys_allocate_chunk>
  8015c0:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015c3:	a1 20 41 80 00       	mov    0x804120,%eax
  8015c8:	83 ec 0c             	sub    $0xc,%esp
  8015cb:	50                   	push   %eax
  8015cc:	e8 b2 0c 00 00       	call   802283 <initialize_MemBlocksList>
  8015d1:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8015d4:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8015d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8015dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8015e0:	0f 84 f3 00 00 00    	je     8016d9 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8015e6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8015ea:	75 14                	jne    801600 <initialize_dyn_block_system+0x108>
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	68 95 3b 80 00       	push   $0x803b95
  8015f4:	6a 36                	push   $0x36
  8015f6:	68 b3 3b 80 00       	push   $0x803bb3
  8015fb:	e8 41 1c 00 00       	call   803241 <_panic>
  801600:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801603:	8b 00                	mov    (%eax),%eax
  801605:	85 c0                	test   %eax,%eax
  801607:	74 10                	je     801619 <initialize_dyn_block_system+0x121>
  801609:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80160c:	8b 00                	mov    (%eax),%eax
  80160e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801611:	8b 52 04             	mov    0x4(%edx),%edx
  801614:	89 50 04             	mov    %edx,0x4(%eax)
  801617:	eb 0b                	jmp    801624 <initialize_dyn_block_system+0x12c>
  801619:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80161c:	8b 40 04             	mov    0x4(%eax),%eax
  80161f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801624:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801627:	8b 40 04             	mov    0x4(%eax),%eax
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 0f                	je     80163d <initialize_dyn_block_system+0x145>
  80162e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801631:	8b 40 04             	mov    0x4(%eax),%eax
  801634:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801637:	8b 12                	mov    (%edx),%edx
  801639:	89 10                	mov    %edx,(%eax)
  80163b:	eb 0a                	jmp    801647 <initialize_dyn_block_system+0x14f>
  80163d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801640:	8b 00                	mov    (%eax),%eax
  801642:	a3 48 41 80 00       	mov    %eax,0x804148
  801647:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80164a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801650:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801653:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80165a:	a1 54 41 80 00       	mov    0x804154,%eax
  80165f:	48                   	dec    %eax
  801660:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801665:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801668:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80166f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801672:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801679:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80167d:	75 14                	jne    801693 <initialize_dyn_block_system+0x19b>
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	68 c0 3b 80 00       	push   $0x803bc0
  801687:	6a 3e                	push   $0x3e
  801689:	68 b3 3b 80 00       	push   $0x803bb3
  80168e:	e8 ae 1b 00 00       	call   803241 <_panic>
  801693:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801699:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80169c:	89 10                	mov    %edx,(%eax)
  80169e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016a1:	8b 00                	mov    (%eax),%eax
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	74 0d                	je     8016b4 <initialize_dyn_block_system+0x1bc>
  8016a7:	a1 38 41 80 00       	mov    0x804138,%eax
  8016ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016af:	89 50 04             	mov    %edx,0x4(%eax)
  8016b2:	eb 08                	jmp    8016bc <initialize_dyn_block_system+0x1c4>
  8016b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016b7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016bf:	a3 38 41 80 00       	mov    %eax,0x804138
  8016c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016ce:	a1 44 41 80 00       	mov    0x804144,%eax
  8016d3:	40                   	inc    %eax
  8016d4:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8016d9:	90                   	nop
  8016da:	c9                   	leave  
  8016db:	c3                   	ret    

008016dc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8016e2:	e8 e0 fd ff ff       	call   8014c7 <InitializeUHeap>
		if (size == 0) return NULL ;
  8016e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016eb:	75 07                	jne    8016f4 <malloc+0x18>
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 7f                	jmp    801773 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016f4:	e8 d2 08 00 00       	call   801fcb <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016f9:	85 c0                	test   %eax,%eax
  8016fb:	74 71                	je     80176e <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8016fd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801704:	8b 55 08             	mov    0x8(%ebp),%edx
  801707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170a:	01 d0                	add    %edx,%eax
  80170c:	48                   	dec    %eax
  80170d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801713:	ba 00 00 00 00       	mov    $0x0,%edx
  801718:	f7 75 f4             	divl   -0xc(%ebp)
  80171b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171e:	29 d0                	sub    %edx,%eax
  801720:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801723:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80172a:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801731:	76 07                	jbe    80173a <malloc+0x5e>
					return NULL ;
  801733:	b8 00 00 00 00       	mov    $0x0,%eax
  801738:	eb 39                	jmp    801773 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80173a:	83 ec 0c             	sub    $0xc,%esp
  80173d:	ff 75 08             	pushl  0x8(%ebp)
  801740:	e8 e6 0d 00 00       	call   80252b <alloc_block_FF>
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80174b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80174f:	74 16                	je     801767 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801751:	83 ec 0c             	sub    $0xc,%esp
  801754:	ff 75 ec             	pushl  -0x14(%ebp)
  801757:	e8 37 0c 00 00       	call   802393 <insert_sorted_allocList>
  80175c:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80175f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801762:	8b 40 08             	mov    0x8(%eax),%eax
  801765:	eb 0c                	jmp    801773 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801767:	b8 00 00 00 00       	mov    $0x0,%eax
  80176c:	eb 05                	jmp    801773 <malloc+0x97>
				}
		}
	return 0;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801773:	c9                   	leave  
  801774:	c3                   	ret    

00801775 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801781:	83 ec 08             	sub    $0x8,%esp
  801784:	ff 75 f4             	pushl  -0xc(%ebp)
  801787:	68 40 40 80 00       	push   $0x804040
  80178c:	e8 cf 0b 00 00       	call   802360 <find_block>
  801791:	83 c4 10             	add    $0x10,%esp
  801794:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179a:	8b 40 0c             	mov    0xc(%eax),%eax
  80179d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8017a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a3:	8b 40 08             	mov    0x8(%eax),%eax
  8017a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8017a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017ad:	0f 84 a1 00 00 00    	je     801854 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8017b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017b7:	75 17                	jne    8017d0 <free+0x5b>
  8017b9:	83 ec 04             	sub    $0x4,%esp
  8017bc:	68 95 3b 80 00       	push   $0x803b95
  8017c1:	68 80 00 00 00       	push   $0x80
  8017c6:	68 b3 3b 80 00       	push   $0x803bb3
  8017cb:	e8 71 1a 00 00       	call   803241 <_panic>
  8017d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d3:	8b 00                	mov    (%eax),%eax
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	74 10                	je     8017e9 <free+0x74>
  8017d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017dc:	8b 00                	mov    (%eax),%eax
  8017de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017e1:	8b 52 04             	mov    0x4(%edx),%edx
  8017e4:	89 50 04             	mov    %edx,0x4(%eax)
  8017e7:	eb 0b                	jmp    8017f4 <free+0x7f>
  8017e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ec:	8b 40 04             	mov    0x4(%eax),%eax
  8017ef:	a3 44 40 80 00       	mov    %eax,0x804044
  8017f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f7:	8b 40 04             	mov    0x4(%eax),%eax
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	74 0f                	je     80180d <free+0x98>
  8017fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801801:	8b 40 04             	mov    0x4(%eax),%eax
  801804:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801807:	8b 12                	mov    (%edx),%edx
  801809:	89 10                	mov    %edx,(%eax)
  80180b:	eb 0a                	jmp    801817 <free+0xa2>
  80180d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801810:	8b 00                	mov    (%eax),%eax
  801812:	a3 40 40 80 00       	mov    %eax,0x804040
  801817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801820:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801823:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80182a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80182f:	48                   	dec    %eax
  801830:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801835:	83 ec 0c             	sub    $0xc,%esp
  801838:	ff 75 f0             	pushl  -0x10(%ebp)
  80183b:	e8 29 12 00 00       	call   802a69 <insert_sorted_with_merge_freeList>
  801840:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801843:	83 ec 08             	sub    $0x8,%esp
  801846:	ff 75 ec             	pushl  -0x14(%ebp)
  801849:	ff 75 e8             	pushl  -0x18(%ebp)
  80184c:	e8 74 03 00 00       	call   801bc5 <sys_free_user_mem>
  801851:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801854:	90                   	nop
  801855:	c9                   	leave  
  801856:	c3                   	ret    

00801857 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 38             	sub    $0x38,%esp
  80185d:	8b 45 10             	mov    0x10(%ebp),%eax
  801860:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801863:	e8 5f fc ff ff       	call   8014c7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801868:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80186c:	75 0a                	jne    801878 <smalloc+0x21>
  80186e:	b8 00 00 00 00       	mov    $0x0,%eax
  801873:	e9 b2 00 00 00       	jmp    80192a <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801878:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80187f:	76 0a                	jbe    80188b <smalloc+0x34>
		return NULL;
  801881:	b8 00 00 00 00       	mov    $0x0,%eax
  801886:	e9 9f 00 00 00       	jmp    80192a <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80188b:	e8 3b 07 00 00       	call   801fcb <sys_isUHeapPlacementStrategyFIRSTFIT>
  801890:	85 c0                	test   %eax,%eax
  801892:	0f 84 8d 00 00 00    	je     801925 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801898:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80189f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ac:	01 d0                	add    %edx,%eax
  8018ae:	48                   	dec    %eax
  8018af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ba:	f7 75 f0             	divl   -0x10(%ebp)
  8018bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c0:	29 d0                	sub    %edx,%eax
  8018c2:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8018c5:	83 ec 0c             	sub    $0xc,%esp
  8018c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8018cb:	e8 5b 0c 00 00       	call   80252b <alloc_block_FF>
  8018d0:	83 c4 10             	add    $0x10,%esp
  8018d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8018d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018da:	75 07                	jne    8018e3 <smalloc+0x8c>
			return NULL;
  8018dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e1:	eb 47                	jmp    80192a <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8018e3:	83 ec 0c             	sub    $0xc,%esp
  8018e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e9:	e8 a5 0a 00 00       	call   802393 <insert_sorted_allocList>
  8018ee:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8018f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f4:	8b 40 08             	mov    0x8(%eax),%eax
  8018f7:	89 c2                	mov    %eax,%edx
  8018f9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8018fd:	52                   	push   %edx
  8018fe:	50                   	push   %eax
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	e8 46 04 00 00       	call   801d50 <sys_createSharedObject>
  80190a:	83 c4 10             	add    $0x10,%esp
  80190d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801910:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801914:	78 08                	js     80191e <smalloc+0xc7>
		return (void *)b->sva;
  801916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801919:	8b 40 08             	mov    0x8(%eax),%eax
  80191c:	eb 0c                	jmp    80192a <smalloc+0xd3>
		}else{
		return NULL;
  80191e:	b8 00 00 00 00       	mov    $0x0,%eax
  801923:	eb 05                	jmp    80192a <smalloc+0xd3>
			}

	}return NULL;
  801925:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192a:	c9                   	leave  
  80192b:	c3                   	ret    

0080192c <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801932:	e8 90 fb ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801937:	e8 8f 06 00 00       	call   801fcb <sys_isUHeapPlacementStrategyFIRSTFIT>
  80193c:	85 c0                	test   %eax,%eax
  80193e:	0f 84 ad 00 00 00    	je     8019f1 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801944:	83 ec 08             	sub    $0x8,%esp
  801947:	ff 75 0c             	pushl  0xc(%ebp)
  80194a:	ff 75 08             	pushl  0x8(%ebp)
  80194d:	e8 28 04 00 00       	call   801d7a <sys_getSizeOfSharedObject>
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80195c:	79 0a                	jns    801968 <sget+0x3c>
    {
    	return NULL;
  80195e:	b8 00 00 00 00       	mov    $0x0,%eax
  801963:	e9 8e 00 00 00       	jmp    8019f6 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801968:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80196f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801979:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80197c:	01 d0                	add    %edx,%eax
  80197e:	48                   	dec    %eax
  80197f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801985:	ba 00 00 00 00       	mov    $0x0,%edx
  80198a:	f7 75 ec             	divl   -0x14(%ebp)
  80198d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801990:	29 d0                	sub    %edx,%eax
  801992:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801995:	83 ec 0c             	sub    $0xc,%esp
  801998:	ff 75 e4             	pushl  -0x1c(%ebp)
  80199b:	e8 8b 0b 00 00       	call   80252b <alloc_block_FF>
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8019a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019aa:	75 07                	jne    8019b3 <sget+0x87>
				return NULL;
  8019ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b1:	eb 43                	jmp    8019f6 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8019b3:	83 ec 0c             	sub    $0xc,%esp
  8019b6:	ff 75 f0             	pushl  -0x10(%ebp)
  8019b9:	e8 d5 09 00 00       	call   802393 <insert_sorted_allocList>
  8019be:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8019c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c4:	8b 40 08             	mov    0x8(%eax),%eax
  8019c7:	83 ec 04             	sub    $0x4,%esp
  8019ca:	50                   	push   %eax
  8019cb:	ff 75 0c             	pushl  0xc(%ebp)
  8019ce:	ff 75 08             	pushl  0x8(%ebp)
  8019d1:	e8 c1 03 00 00       	call   801d97 <sys_getSharedObject>
  8019d6:	83 c4 10             	add    $0x10,%esp
  8019d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8019dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019e0:	78 08                	js     8019ea <sget+0xbe>
			return (void *)b->sva;
  8019e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e5:	8b 40 08             	mov    0x8(%eax),%eax
  8019e8:	eb 0c                	jmp    8019f6 <sget+0xca>
			}else{
			return NULL;
  8019ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ef:	eb 05                	jmp    8019f6 <sget+0xca>
			}
    }}return NULL;
  8019f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
  8019fb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019fe:	e8 c4 fa ff ff       	call   8014c7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a03:	83 ec 04             	sub    $0x4,%esp
  801a06:	68 e4 3b 80 00       	push   $0x803be4
  801a0b:	68 03 01 00 00       	push   $0x103
  801a10:	68 b3 3b 80 00       	push   $0x803bb3
  801a15:	e8 27 18 00 00       	call   803241 <_panic>

00801a1a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a20:	83 ec 04             	sub    $0x4,%esp
  801a23:	68 0c 3c 80 00       	push   $0x803c0c
  801a28:	68 17 01 00 00       	push   $0x117
  801a2d:	68 b3 3b 80 00       	push   $0x803bb3
  801a32:	e8 0a 18 00 00       	call   803241 <_panic>

00801a37 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
  801a3a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a3d:	83 ec 04             	sub    $0x4,%esp
  801a40:	68 30 3c 80 00       	push   $0x803c30
  801a45:	68 22 01 00 00       	push   $0x122
  801a4a:	68 b3 3b 80 00       	push   $0x803bb3
  801a4f:	e8 ed 17 00 00       	call   803241 <_panic>

00801a54 <shrink>:

}
void shrink(uint32 newSize)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
  801a57:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a5a:	83 ec 04             	sub    $0x4,%esp
  801a5d:	68 30 3c 80 00       	push   $0x803c30
  801a62:	68 27 01 00 00       	push   $0x127
  801a67:	68 b3 3b 80 00       	push   $0x803bb3
  801a6c:	e8 d0 17 00 00       	call   803241 <_panic>

00801a71 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a77:	83 ec 04             	sub    $0x4,%esp
  801a7a:	68 30 3c 80 00       	push   $0x803c30
  801a7f:	68 2c 01 00 00       	push   $0x12c
  801a84:	68 b3 3b 80 00       	push   $0x803bb3
  801a89:	e8 b3 17 00 00       	call   803241 <_panic>

00801a8e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
  801a91:	57                   	push   %edi
  801a92:	56                   	push   %esi
  801a93:	53                   	push   %ebx
  801a94:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aa0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aa3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801aa6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801aa9:	cd 30                	int    $0x30
  801aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ab1:	83 c4 10             	add    $0x10,%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5f                   	pop    %edi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    

00801ab9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 04             	sub    $0x4,%esp
  801abf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ac5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	52                   	push   %edx
  801ad1:	ff 75 0c             	pushl  0xc(%ebp)
  801ad4:	50                   	push   %eax
  801ad5:	6a 00                	push   $0x0
  801ad7:	e8 b2 ff ff ff       	call   801a8e <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	90                   	nop
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 01                	push   $0x1
  801af1:	e8 98 ff ff ff       	call   801a8e <syscall>
  801af6:	83 c4 18             	add    $0x18,%esp
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	52                   	push   %edx
  801b0b:	50                   	push   %eax
  801b0c:	6a 05                	push   $0x5
  801b0e:	e8 7b ff ff ff       	call   801a8e <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	56                   	push   %esi
  801b1c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b1d:	8b 75 18             	mov    0x18(%ebp),%esi
  801b20:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b23:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b29:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2c:	56                   	push   %esi
  801b2d:	53                   	push   %ebx
  801b2e:	51                   	push   %ecx
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 06                	push   $0x6
  801b33:	e8 56 ff ff ff       	call   801a8e <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3e:	5b                   	pop    %ebx
  801b3f:	5e                   	pop    %esi
  801b40:	5d                   	pop    %ebp
  801b41:	c3                   	ret    

00801b42 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 07                	push   $0x7
  801b55:	e8 34 ff ff ff       	call   801a8e <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	ff 75 0c             	pushl  0xc(%ebp)
  801b6b:	ff 75 08             	pushl  0x8(%ebp)
  801b6e:	6a 08                	push   $0x8
  801b70:	e8 19 ff ff ff       	call   801a8e <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 09                	push   $0x9
  801b89:	e8 00 ff ff ff       	call   801a8e <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 0a                	push   $0xa
  801ba2:	e8 e7 fe ff ff       	call   801a8e <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 0b                	push   $0xb
  801bbb:	e8 ce fe ff ff       	call   801a8e <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	ff 75 0c             	pushl  0xc(%ebp)
  801bd1:	ff 75 08             	pushl  0x8(%ebp)
  801bd4:	6a 0f                	push   $0xf
  801bd6:	e8 b3 fe ff ff       	call   801a8e <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
	return;
  801bde:	90                   	nop
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	ff 75 0c             	pushl  0xc(%ebp)
  801bed:	ff 75 08             	pushl  0x8(%ebp)
  801bf0:	6a 10                	push   $0x10
  801bf2:	e8 97 fe ff ff       	call   801a8e <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
	return ;
  801bfa:	90                   	nop
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	ff 75 10             	pushl  0x10(%ebp)
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	ff 75 08             	pushl  0x8(%ebp)
  801c0d:	6a 11                	push   $0x11
  801c0f:	e8 7a fe ff ff       	call   801a8e <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
	return ;
  801c17:	90                   	nop
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 0c                	push   $0xc
  801c29:	e8 60 fe ff ff       	call   801a8e <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	ff 75 08             	pushl  0x8(%ebp)
  801c41:	6a 0d                	push   $0xd
  801c43:	e8 46 fe ff ff       	call   801a8e <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 0e                	push   $0xe
  801c5c:	e8 2d fe ff ff       	call   801a8e <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
}
  801c64:	90                   	nop
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 13                	push   $0x13
  801c76:	e8 13 fe ff ff       	call   801a8e <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	90                   	nop
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 14                	push   $0x14
  801c90:	e8 f9 fd ff ff       	call   801a8e <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	90                   	nop
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_cputc>:


void
sys_cputc(const char c)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 04             	sub    $0x4,%esp
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ca7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	50                   	push   %eax
  801cb4:	6a 15                	push   $0x15
  801cb6:	e8 d3 fd ff ff       	call   801a8e <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	90                   	nop
  801cbf:	c9                   	leave  
  801cc0:	c3                   	ret    

00801cc1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cc1:	55                   	push   %ebp
  801cc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 16                	push   $0x16
  801cd0:	e8 b9 fd ff ff       	call   801a8e <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	90                   	nop
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cde:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	ff 75 0c             	pushl  0xc(%ebp)
  801cea:	50                   	push   %eax
  801ceb:	6a 17                	push   $0x17
  801ced:	e8 9c fd ff ff       	call   801a8e <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	52                   	push   %edx
  801d07:	50                   	push   %eax
  801d08:	6a 1a                	push   $0x1a
  801d0a:	e8 7f fd ff ff       	call   801a8e <syscall>
  801d0f:	83 c4 18             	add    $0x18,%esp
}
  801d12:	c9                   	leave  
  801d13:	c3                   	ret    

00801d14 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	52                   	push   %edx
  801d24:	50                   	push   %eax
  801d25:	6a 18                	push   $0x18
  801d27:	e8 62 fd ff ff       	call   801a8e <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	90                   	nop
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d38:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	52                   	push   %edx
  801d42:	50                   	push   %eax
  801d43:	6a 19                	push   $0x19
  801d45:	e8 44 fd ff ff       	call   801a8e <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	90                   	nop
  801d4e:	c9                   	leave  
  801d4f:	c3                   	ret    

00801d50 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	83 ec 04             	sub    $0x4,%esp
  801d56:	8b 45 10             	mov    0x10(%ebp),%eax
  801d59:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d5c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d5f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d63:	8b 45 08             	mov    0x8(%ebp),%eax
  801d66:	6a 00                	push   $0x0
  801d68:	51                   	push   %ecx
  801d69:	52                   	push   %edx
  801d6a:	ff 75 0c             	pushl  0xc(%ebp)
  801d6d:	50                   	push   %eax
  801d6e:	6a 1b                	push   $0x1b
  801d70:	e8 19 fd ff ff       	call   801a8e <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 1c                	push   $0x1c
  801d8d:	e8 fc fc ff ff       	call   801a8e <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	51                   	push   %ecx
  801da8:	52                   	push   %edx
  801da9:	50                   	push   %eax
  801daa:	6a 1d                	push   $0x1d
  801dac:	e8 dd fc ff ff       	call   801a8e <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801db9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	52                   	push   %edx
  801dc6:	50                   	push   %eax
  801dc7:	6a 1e                	push   $0x1e
  801dc9:	e8 c0 fc ff ff       	call   801a8e <syscall>
  801dce:	83 c4 18             	add    $0x18,%esp
}
  801dd1:	c9                   	leave  
  801dd2:	c3                   	ret    

00801dd3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801dd3:	55                   	push   %ebp
  801dd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 1f                	push   $0x1f
  801de2:	e8 a7 fc ff ff       	call   801a8e <syscall>
  801de7:	83 c4 18             	add    $0x18,%esp
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801def:	8b 45 08             	mov    0x8(%ebp),%eax
  801df2:	6a 00                	push   $0x0
  801df4:	ff 75 14             	pushl  0x14(%ebp)
  801df7:	ff 75 10             	pushl  0x10(%ebp)
  801dfa:	ff 75 0c             	pushl  0xc(%ebp)
  801dfd:	50                   	push   %eax
  801dfe:	6a 20                	push   $0x20
  801e00:	e8 89 fc ff ff       	call   801a8e <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
}
  801e08:	c9                   	leave  
  801e09:	c3                   	ret    

00801e0a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e0a:	55                   	push   %ebp
  801e0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	50                   	push   %eax
  801e19:	6a 21                	push   $0x21
  801e1b:	e8 6e fc ff ff       	call   801a8e <syscall>
  801e20:	83 c4 18             	add    $0x18,%esp
}
  801e23:	90                   	nop
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	50                   	push   %eax
  801e35:	6a 22                	push   $0x22
  801e37:	e8 52 fc ff ff       	call   801a8e <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 02                	push   $0x2
  801e50:	e8 39 fc ff ff       	call   801a8e <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 03                	push   $0x3
  801e69:	e8 20 fc ff ff       	call   801a8e <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 04                	push   $0x4
  801e82:	e8 07 fc ff ff       	call   801a8e <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_exit_env>:


void sys_exit_env(void)
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 23                	push   $0x23
  801e9b:	e8 ee fb ff ff       	call   801a8e <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	90                   	nop
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801eac:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eaf:	8d 50 04             	lea    0x4(%eax),%edx
  801eb2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 00                	push   $0x0
  801ebb:	52                   	push   %edx
  801ebc:	50                   	push   %eax
  801ebd:	6a 24                	push   $0x24
  801ebf:	e8 ca fb ff ff       	call   801a8e <syscall>
  801ec4:	83 c4 18             	add    $0x18,%esp
	return result;
  801ec7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ecd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ed0:	89 01                	mov    %eax,(%ecx)
  801ed2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed8:	c9                   	leave  
  801ed9:	c2 04 00             	ret    $0x4

00801edc <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	ff 75 10             	pushl  0x10(%ebp)
  801ee6:	ff 75 0c             	pushl  0xc(%ebp)
  801ee9:	ff 75 08             	pushl  0x8(%ebp)
  801eec:	6a 12                	push   $0x12
  801eee:	e8 9b fb ff ff       	call   801a8e <syscall>
  801ef3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ef6:	90                   	nop
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 25                	push   $0x25
  801f08:	e8 81 fb ff ff       	call   801a8e <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f1e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	50                   	push   %eax
  801f2b:	6a 26                	push   $0x26
  801f2d:	e8 5c fb ff ff       	call   801a8e <syscall>
  801f32:	83 c4 18             	add    $0x18,%esp
	return ;
  801f35:	90                   	nop
}
  801f36:	c9                   	leave  
  801f37:	c3                   	ret    

00801f38 <rsttst>:
void rsttst()
{
  801f38:	55                   	push   %ebp
  801f39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 00                	push   $0x0
  801f43:	6a 00                	push   $0x0
  801f45:	6a 28                	push   $0x28
  801f47:	e8 42 fb ff ff       	call   801a8e <syscall>
  801f4c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f4f:	90                   	nop
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 04             	sub    $0x4,%esp
  801f58:	8b 45 14             	mov    0x14(%ebp),%eax
  801f5b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f5e:	8b 55 18             	mov    0x18(%ebp),%edx
  801f61:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f65:	52                   	push   %edx
  801f66:	50                   	push   %eax
  801f67:	ff 75 10             	pushl  0x10(%ebp)
  801f6a:	ff 75 0c             	pushl  0xc(%ebp)
  801f6d:	ff 75 08             	pushl  0x8(%ebp)
  801f70:	6a 27                	push   $0x27
  801f72:	e8 17 fb ff ff       	call   801a8e <syscall>
  801f77:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7a:	90                   	nop
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <chktst>:
void chktst(uint32 n)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	ff 75 08             	pushl  0x8(%ebp)
  801f8b:	6a 29                	push   $0x29
  801f8d:	e8 fc fa ff ff       	call   801a8e <syscall>
  801f92:	83 c4 18             	add    $0x18,%esp
	return ;
  801f95:	90                   	nop
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <inctst>:

void inctst()
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	6a 00                	push   $0x0
  801fa3:	6a 00                	push   $0x0
  801fa5:	6a 2a                	push   $0x2a
  801fa7:	e8 e2 fa ff ff       	call   801a8e <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
	return ;
  801faf:	90                   	nop
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <gettst>:
uint32 gettst()
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 2b                	push   $0x2b
  801fc1:	e8 c8 fa ff ff       	call   801a8e <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 2c                	push   $0x2c
  801fdd:	e8 ac fa ff ff       	call   801a8e <syscall>
  801fe2:	83 c4 18             	add    $0x18,%esp
  801fe5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801fe8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801fec:	75 07                	jne    801ff5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801fee:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff3:	eb 05                	jmp    801ffa <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ff5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
  801fff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 2c                	push   $0x2c
  80200e:	e8 7b fa ff ff       	call   801a8e <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
  802016:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802019:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80201d:	75 07                	jne    802026 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80201f:	b8 01 00 00 00       	mov    $0x1,%eax
  802024:	eb 05                	jmp    80202b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80202b:	c9                   	leave  
  80202c:	c3                   	ret    

0080202d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80202d:	55                   	push   %ebp
  80202e:	89 e5                	mov    %esp,%ebp
  802030:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802033:	6a 00                	push   $0x0
  802035:	6a 00                	push   $0x0
  802037:	6a 00                	push   $0x0
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 2c                	push   $0x2c
  80203f:	e8 4a fa ff ff       	call   801a8e <syscall>
  802044:	83 c4 18             	add    $0x18,%esp
  802047:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80204a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80204e:	75 07                	jne    802057 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802050:	b8 01 00 00 00       	mov    $0x1,%eax
  802055:	eb 05                	jmp    80205c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802057:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802064:	6a 00                	push   $0x0
  802066:	6a 00                	push   $0x0
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 2c                	push   $0x2c
  802070:	e8 19 fa ff ff       	call   801a8e <syscall>
  802075:	83 c4 18             	add    $0x18,%esp
  802078:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80207b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80207f:	75 07                	jne    802088 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802081:	b8 01 00 00 00       	mov    $0x1,%eax
  802086:	eb 05                	jmp    80208d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802088:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    

0080208f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80208f:	55                   	push   %ebp
  802090:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	ff 75 08             	pushl  0x8(%ebp)
  80209d:	6a 2d                	push   $0x2d
  80209f:	e8 ea f9 ff ff       	call   801a8e <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a7:	90                   	nop
}
  8020a8:	c9                   	leave  
  8020a9:	c3                   	ret    

008020aa <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020ae:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ba:	6a 00                	push   $0x0
  8020bc:	53                   	push   %ebx
  8020bd:	51                   	push   %ecx
  8020be:	52                   	push   %edx
  8020bf:	50                   	push   %eax
  8020c0:	6a 2e                	push   $0x2e
  8020c2:	e8 c7 f9 ff ff       	call   801a8e <syscall>
  8020c7:	83 c4 18             	add    $0x18,%esp
}
  8020ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	6a 00                	push   $0x0
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	52                   	push   %edx
  8020df:	50                   	push   %eax
  8020e0:	6a 2f                	push   $0x2f
  8020e2:	e8 a7 f9 ff ff       	call   801a8e <syscall>
  8020e7:	83 c4 18             	add    $0x18,%esp
}
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8020f2:	83 ec 0c             	sub    $0xc,%esp
  8020f5:	68 40 3c 80 00       	push   $0x803c40
  8020fa:	e8 3e e6 ff ff       	call   80073d <cprintf>
  8020ff:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802102:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802109:	83 ec 0c             	sub    $0xc,%esp
  80210c:	68 6c 3c 80 00       	push   $0x803c6c
  802111:	e8 27 e6 ff ff       	call   80073d <cprintf>
  802116:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802119:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80211d:	a1 38 41 80 00       	mov    0x804138,%eax
  802122:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802125:	eb 56                	jmp    80217d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802127:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80212b:	74 1c                	je     802149 <print_mem_block_lists+0x5d>
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	8b 50 08             	mov    0x8(%eax),%edx
  802133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802136:	8b 48 08             	mov    0x8(%eax),%ecx
  802139:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80213c:	8b 40 0c             	mov    0xc(%eax),%eax
  80213f:	01 c8                	add    %ecx,%eax
  802141:	39 c2                	cmp    %eax,%edx
  802143:	73 04                	jae    802149 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802145:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	8b 50 08             	mov    0x8(%eax),%edx
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	8b 40 0c             	mov    0xc(%eax),%eax
  802155:	01 c2                	add    %eax,%edx
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 40 08             	mov    0x8(%eax),%eax
  80215d:	83 ec 04             	sub    $0x4,%esp
  802160:	52                   	push   %edx
  802161:	50                   	push   %eax
  802162:	68 81 3c 80 00       	push   $0x803c81
  802167:	e8 d1 e5 ff ff       	call   80073d <cprintf>
  80216c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802175:	a1 40 41 80 00       	mov    0x804140,%eax
  80217a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802181:	74 07                	je     80218a <print_mem_block_lists+0x9e>
  802183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802186:	8b 00                	mov    (%eax),%eax
  802188:	eb 05                	jmp    80218f <print_mem_block_lists+0xa3>
  80218a:	b8 00 00 00 00       	mov    $0x0,%eax
  80218f:	a3 40 41 80 00       	mov    %eax,0x804140
  802194:	a1 40 41 80 00       	mov    0x804140,%eax
  802199:	85 c0                	test   %eax,%eax
  80219b:	75 8a                	jne    802127 <print_mem_block_lists+0x3b>
  80219d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a1:	75 84                	jne    802127 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021a3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021a7:	75 10                	jne    8021b9 <print_mem_block_lists+0xcd>
  8021a9:	83 ec 0c             	sub    $0xc,%esp
  8021ac:	68 90 3c 80 00       	push   $0x803c90
  8021b1:	e8 87 e5 ff ff       	call   80073d <cprintf>
  8021b6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021c0:	83 ec 0c             	sub    $0xc,%esp
  8021c3:	68 b4 3c 80 00       	push   $0x803cb4
  8021c8:	e8 70 e5 ff ff       	call   80073d <cprintf>
  8021cd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021d0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021d4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021dc:	eb 56                	jmp    802234 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e2:	74 1c                	je     802200 <print_mem_block_lists+0x114>
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ed:	8b 48 08             	mov    0x8(%eax),%ecx
  8021f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f6:	01 c8                	add    %ecx,%eax
  8021f8:	39 c2                	cmp    %eax,%edx
  8021fa:	73 04                	jae    802200 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8021fc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802200:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802203:	8b 50 08             	mov    0x8(%eax),%edx
  802206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802209:	8b 40 0c             	mov    0xc(%eax),%eax
  80220c:	01 c2                	add    %eax,%edx
  80220e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802211:	8b 40 08             	mov    0x8(%eax),%eax
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	52                   	push   %edx
  802218:	50                   	push   %eax
  802219:	68 81 3c 80 00       	push   $0x803c81
  80221e:	e8 1a e5 ff ff       	call   80073d <cprintf>
  802223:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802226:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802229:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80222c:	a1 48 40 80 00       	mov    0x804048,%eax
  802231:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802234:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802238:	74 07                	je     802241 <print_mem_block_lists+0x155>
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	8b 00                	mov    (%eax),%eax
  80223f:	eb 05                	jmp    802246 <print_mem_block_lists+0x15a>
  802241:	b8 00 00 00 00       	mov    $0x0,%eax
  802246:	a3 48 40 80 00       	mov    %eax,0x804048
  80224b:	a1 48 40 80 00       	mov    0x804048,%eax
  802250:	85 c0                	test   %eax,%eax
  802252:	75 8a                	jne    8021de <print_mem_block_lists+0xf2>
  802254:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802258:	75 84                	jne    8021de <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80225a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80225e:	75 10                	jne    802270 <print_mem_block_lists+0x184>
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	68 cc 3c 80 00       	push   $0x803ccc
  802268:	e8 d0 e4 ff ff       	call   80073d <cprintf>
  80226d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802270:	83 ec 0c             	sub    $0xc,%esp
  802273:	68 40 3c 80 00       	push   $0x803c40
  802278:	e8 c0 e4 ff ff       	call   80073d <cprintf>
  80227d:	83 c4 10             	add    $0x10,%esp

}
  802280:	90                   	nop
  802281:	c9                   	leave  
  802282:	c3                   	ret    

00802283 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802289:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802290:	00 00 00 
  802293:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80229a:	00 00 00 
  80229d:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8022a4:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8022a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022ae:	e9 9e 00 00 00       	jmp    802351 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8022b3:	a1 50 40 80 00       	mov    0x804050,%eax
  8022b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bb:	c1 e2 04             	shl    $0x4,%edx
  8022be:	01 d0                	add    %edx,%eax
  8022c0:	85 c0                	test   %eax,%eax
  8022c2:	75 14                	jne    8022d8 <initialize_MemBlocksList+0x55>
  8022c4:	83 ec 04             	sub    $0x4,%esp
  8022c7:	68 f4 3c 80 00       	push   $0x803cf4
  8022cc:	6a 3d                	push   $0x3d
  8022ce:	68 17 3d 80 00       	push   $0x803d17
  8022d3:	e8 69 0f 00 00       	call   803241 <_panic>
  8022d8:	a1 50 40 80 00       	mov    0x804050,%eax
  8022dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e0:	c1 e2 04             	shl    $0x4,%edx
  8022e3:	01 d0                	add    %edx,%eax
  8022e5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8022eb:	89 10                	mov    %edx,(%eax)
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	74 18                	je     80230b <initialize_MemBlocksList+0x88>
  8022f3:	a1 48 41 80 00       	mov    0x804148,%eax
  8022f8:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8022fe:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802301:	c1 e1 04             	shl    $0x4,%ecx
  802304:	01 ca                	add    %ecx,%edx
  802306:	89 50 04             	mov    %edx,0x4(%eax)
  802309:	eb 12                	jmp    80231d <initialize_MemBlocksList+0x9a>
  80230b:	a1 50 40 80 00       	mov    0x804050,%eax
  802310:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802313:	c1 e2 04             	shl    $0x4,%edx
  802316:	01 d0                	add    %edx,%eax
  802318:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80231d:	a1 50 40 80 00       	mov    0x804050,%eax
  802322:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802325:	c1 e2 04             	shl    $0x4,%edx
  802328:	01 d0                	add    %edx,%eax
  80232a:	a3 48 41 80 00       	mov    %eax,0x804148
  80232f:	a1 50 40 80 00       	mov    0x804050,%eax
  802334:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802337:	c1 e2 04             	shl    $0x4,%edx
  80233a:	01 d0                	add    %edx,%eax
  80233c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802343:	a1 54 41 80 00       	mov    0x804154,%eax
  802348:	40                   	inc    %eax
  802349:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80234e:	ff 45 f4             	incl   -0xc(%ebp)
  802351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802354:	3b 45 08             	cmp    0x8(%ebp),%eax
  802357:	0f 82 56 ff ff ff    	jb     8022b3 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80235d:	90                   	nop
  80235e:	c9                   	leave  
  80235f:	c3                   	ret    

00802360 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802366:	8b 45 08             	mov    0x8(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80236e:	eb 18                	jmp    802388 <find_block+0x28>

		if(tmp->sva == va){
  802370:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802373:	8b 40 08             	mov    0x8(%eax),%eax
  802376:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802379:	75 05                	jne    802380 <find_block+0x20>
			return tmp ;
  80237b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80237e:	eb 11                	jmp    802391 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802383:	8b 00                	mov    (%eax),%eax
  802385:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802388:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80238c:	75 e2                	jne    802370 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80238e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
  802396:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802399:	a1 40 40 80 00       	mov    0x804040,%eax
  80239e:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8023a1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8023a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023ad:	75 65                	jne    802414 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8023af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b3:	75 14                	jne    8023c9 <insert_sorted_allocList+0x36>
  8023b5:	83 ec 04             	sub    $0x4,%esp
  8023b8:	68 f4 3c 80 00       	push   $0x803cf4
  8023bd:	6a 62                	push   $0x62
  8023bf:	68 17 3d 80 00       	push   $0x803d17
  8023c4:	e8 78 0e 00 00       	call   803241 <_panic>
  8023c9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	89 10                	mov    %edx,(%eax)
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	74 0d                	je     8023ea <insert_sorted_allocList+0x57>
  8023dd:	a1 40 40 80 00       	mov    0x804040,%eax
  8023e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e5:	89 50 04             	mov    %edx,0x4(%eax)
  8023e8:	eb 08                	jmp    8023f2 <insert_sorted_allocList+0x5f>
  8023ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ed:	a3 44 40 80 00       	mov    %eax,0x804044
  8023f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f5:	a3 40 40 80 00       	mov    %eax,0x804040
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802404:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802409:	40                   	inc    %eax
  80240a:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80240f:	e9 14 01 00 00       	jmp    802528 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802414:	8b 45 08             	mov    0x8(%ebp),%eax
  802417:	8b 50 08             	mov    0x8(%eax),%edx
  80241a:	a1 44 40 80 00       	mov    0x804044,%eax
  80241f:	8b 40 08             	mov    0x8(%eax),%eax
  802422:	39 c2                	cmp    %eax,%edx
  802424:	76 65                	jbe    80248b <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802426:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80242a:	75 14                	jne    802440 <insert_sorted_allocList+0xad>
  80242c:	83 ec 04             	sub    $0x4,%esp
  80242f:	68 30 3d 80 00       	push   $0x803d30
  802434:	6a 64                	push   $0x64
  802436:	68 17 3d 80 00       	push   $0x803d17
  80243b:	e8 01 0e 00 00       	call   803241 <_panic>
  802440:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	89 50 04             	mov    %edx,0x4(%eax)
  80244c:	8b 45 08             	mov    0x8(%ebp),%eax
  80244f:	8b 40 04             	mov    0x4(%eax),%eax
  802452:	85 c0                	test   %eax,%eax
  802454:	74 0c                	je     802462 <insert_sorted_allocList+0xcf>
  802456:	a1 44 40 80 00       	mov    0x804044,%eax
  80245b:	8b 55 08             	mov    0x8(%ebp),%edx
  80245e:	89 10                	mov    %edx,(%eax)
  802460:	eb 08                	jmp    80246a <insert_sorted_allocList+0xd7>
  802462:	8b 45 08             	mov    0x8(%ebp),%eax
  802465:	a3 40 40 80 00       	mov    %eax,0x804040
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	a3 44 40 80 00       	mov    %eax,0x804044
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802480:	40                   	inc    %eax
  802481:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802486:	e9 9d 00 00 00       	jmp    802528 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80248b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802492:	e9 85 00 00 00       	jmp    80251c <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	8b 50 08             	mov    0x8(%eax),%edx
  80249d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a0:	8b 40 08             	mov    0x8(%eax),%eax
  8024a3:	39 c2                	cmp    %eax,%edx
  8024a5:	73 6a                	jae    802511 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8024a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ab:	74 06                	je     8024b3 <insert_sorted_allocList+0x120>
  8024ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024b1:	75 14                	jne    8024c7 <insert_sorted_allocList+0x134>
  8024b3:	83 ec 04             	sub    $0x4,%esp
  8024b6:	68 54 3d 80 00       	push   $0x803d54
  8024bb:	6a 6b                	push   $0x6b
  8024bd:	68 17 3d 80 00       	push   $0x803d17
  8024c2:	e8 7a 0d 00 00       	call   803241 <_panic>
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 50 04             	mov    0x4(%eax),%edx
  8024cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d0:	89 50 04             	mov    %edx,0x4(%eax)
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024d9:	89 10                	mov    %edx,(%eax)
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 40 04             	mov    0x4(%eax),%eax
  8024e1:	85 c0                	test   %eax,%eax
  8024e3:	74 0d                	je     8024f2 <insert_sorted_allocList+0x15f>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 40 04             	mov    0x4(%eax),%eax
  8024eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ee:	89 10                	mov    %edx,(%eax)
  8024f0:	eb 08                	jmp    8024fa <insert_sorted_allocList+0x167>
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	a3 40 40 80 00       	mov    %eax,0x804040
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802500:	89 50 04             	mov    %edx,0x4(%eax)
  802503:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802508:	40                   	inc    %eax
  802509:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  80250e:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80250f:	eb 17                	jmp    802528 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 00                	mov    (%eax),%eax
  802516:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802519:	ff 45 f0             	incl   -0x10(%ebp)
  80251c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802522:	0f 8c 6f ff ff ff    	jl     802497 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802528:	90                   	nop
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
  80252e:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802531:	a1 38 41 80 00       	mov    0x804138,%eax
  802536:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802539:	e9 7c 01 00 00       	jmp    8026ba <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 40 0c             	mov    0xc(%eax),%eax
  802544:	3b 45 08             	cmp    0x8(%ebp),%eax
  802547:	0f 86 cf 00 00 00    	jbe    80261c <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80254d:	a1 48 41 80 00       	mov    0x804148,%eax
  802552:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802558:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80255b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255e:	8b 55 08             	mov    0x8(%ebp),%edx
  802561:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 50 08             	mov    0x8(%eax),%edx
  80256a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256d:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 40 0c             	mov    0xc(%eax),%eax
  802576:	2b 45 08             	sub    0x8(%ebp),%eax
  802579:	89 c2                	mov    %eax,%edx
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 50 08             	mov    0x8(%eax),%edx
  802587:	8b 45 08             	mov    0x8(%ebp),%eax
  80258a:	01 c2                	add    %eax,%edx
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802592:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802596:	75 17                	jne    8025af <alloc_block_FF+0x84>
  802598:	83 ec 04             	sub    $0x4,%esp
  80259b:	68 89 3d 80 00       	push   $0x803d89
  8025a0:	68 83 00 00 00       	push   $0x83
  8025a5:	68 17 3d 80 00       	push   $0x803d17
  8025aa:	e8 92 0c 00 00       	call   803241 <_panic>
  8025af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	85 c0                	test   %eax,%eax
  8025b6:	74 10                	je     8025c8 <alloc_block_FF+0x9d>
  8025b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c0:	8b 52 04             	mov    0x4(%edx),%edx
  8025c3:	89 50 04             	mov    %edx,0x4(%eax)
  8025c6:	eb 0b                	jmp    8025d3 <alloc_block_FF+0xa8>
  8025c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cb:	8b 40 04             	mov    0x4(%eax),%eax
  8025ce:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d6:	8b 40 04             	mov    0x4(%eax),%eax
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	74 0f                	je     8025ec <alloc_block_FF+0xc1>
  8025dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e0:	8b 40 04             	mov    0x4(%eax),%eax
  8025e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025e6:	8b 12                	mov    (%edx),%edx
  8025e8:	89 10                	mov    %edx,(%eax)
  8025ea:	eb 0a                	jmp    8025f6 <alloc_block_FF+0xcb>
  8025ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ef:	8b 00                	mov    (%eax),%eax
  8025f1:	a3 48 41 80 00       	mov    %eax,0x804148
  8025f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802602:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802609:	a1 54 41 80 00       	mov    0x804154,%eax
  80260e:	48                   	dec    %eax
  80260f:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802614:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802617:	e9 ad 00 00 00       	jmp    8026c9 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80261c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261f:	8b 40 0c             	mov    0xc(%eax),%eax
  802622:	3b 45 08             	cmp    0x8(%ebp),%eax
  802625:	0f 85 87 00 00 00    	jne    8026b2 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80262b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262f:	75 17                	jne    802648 <alloc_block_FF+0x11d>
  802631:	83 ec 04             	sub    $0x4,%esp
  802634:	68 89 3d 80 00       	push   $0x803d89
  802639:	68 87 00 00 00       	push   $0x87
  80263e:	68 17 3d 80 00       	push   $0x803d17
  802643:	e8 f9 0b 00 00       	call   803241 <_panic>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 00                	mov    (%eax),%eax
  80264d:	85 c0                	test   %eax,%eax
  80264f:	74 10                	je     802661 <alloc_block_FF+0x136>
  802651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802659:	8b 52 04             	mov    0x4(%edx),%edx
  80265c:	89 50 04             	mov    %edx,0x4(%eax)
  80265f:	eb 0b                	jmp    80266c <alloc_block_FF+0x141>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 40 04             	mov    0x4(%eax),%eax
  802672:	85 c0                	test   %eax,%eax
  802674:	74 0f                	je     802685 <alloc_block_FF+0x15a>
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 40 04             	mov    0x4(%eax),%eax
  80267c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267f:	8b 12                	mov    (%edx),%edx
  802681:	89 10                	mov    %edx,(%eax)
  802683:	eb 0a                	jmp    80268f <alloc_block_FF+0x164>
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	a3 38 41 80 00       	mov    %eax,0x804138
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a2:	a1 44 41 80 00       	mov    0x804144,%eax
  8026a7:	48                   	dec    %eax
  8026a8:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	eb 17                	jmp    8026c9 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 00                	mov    (%eax),%eax
  8026b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8026ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026be:	0f 85 7a fe ff ff    	jne    80253e <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8026c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c9:	c9                   	leave  
  8026ca:	c3                   	ret    

008026cb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026cb:	55                   	push   %ebp
  8026cc:	89 e5                	mov    %esp,%ebp
  8026ce:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8026d1:	a1 38 41 80 00       	mov    0x804138,%eax
  8026d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8026d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8026e0:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8026e7:	a1 38 41 80 00       	mov    0x804138,%eax
  8026ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ef:	e9 d0 00 00 00       	jmp    8027c4 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8026f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026fd:	0f 82 b8 00 00 00    	jb     8027bb <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 40 0c             	mov    0xc(%eax),%eax
  802709:	2b 45 08             	sub    0x8(%ebp),%eax
  80270c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80270f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802712:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802715:	0f 83 a1 00 00 00    	jae    8027bc <alloc_block_BF+0xf1>
				differsize = differance ;
  80271b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80271e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802727:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80272b:	0f 85 8b 00 00 00    	jne    8027bc <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802735:	75 17                	jne    80274e <alloc_block_BF+0x83>
  802737:	83 ec 04             	sub    $0x4,%esp
  80273a:	68 89 3d 80 00       	push   $0x803d89
  80273f:	68 a0 00 00 00       	push   $0xa0
  802744:	68 17 3d 80 00       	push   $0x803d17
  802749:	e8 f3 0a 00 00       	call   803241 <_panic>
  80274e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	74 10                	je     802767 <alloc_block_BF+0x9c>
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275f:	8b 52 04             	mov    0x4(%edx),%edx
  802762:	89 50 04             	mov    %edx,0x4(%eax)
  802765:	eb 0b                	jmp    802772 <alloc_block_BF+0xa7>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	8b 40 04             	mov    0x4(%eax),%eax
  802778:	85 c0                	test   %eax,%eax
  80277a:	74 0f                	je     80278b <alloc_block_BF+0xc0>
  80277c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277f:	8b 40 04             	mov    0x4(%eax),%eax
  802782:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802785:	8b 12                	mov    (%edx),%edx
  802787:	89 10                	mov    %edx,(%eax)
  802789:	eb 0a                	jmp    802795 <alloc_block_BF+0xca>
  80278b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278e:	8b 00                	mov    (%eax),%eax
  802790:	a3 38 41 80 00       	mov    %eax,0x804138
  802795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a8:	a1 44 41 80 00       	mov    0x804144,%eax
  8027ad:	48                   	dec    %eax
  8027ae:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	e9 0c 01 00 00       	jmp    8028c7 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8027bb:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8027bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8027c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c8:	74 07                	je     8027d1 <alloc_block_BF+0x106>
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 00                	mov    (%eax),%eax
  8027cf:	eb 05                	jmp    8027d6 <alloc_block_BF+0x10b>
  8027d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027d6:	a3 40 41 80 00       	mov    %eax,0x804140
  8027db:	a1 40 41 80 00       	mov    0x804140,%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	0f 85 0c ff ff ff    	jne    8026f4 <alloc_block_BF+0x29>
  8027e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027ec:	0f 85 02 ff ff ff    	jne    8026f4 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8027f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027f6:	0f 84 c6 00 00 00    	je     8028c2 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8027fc:	a1 48 41 80 00       	mov    0x804148,%eax
  802801:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802804:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802807:	8b 55 08             	mov    0x8(%ebp),%edx
  80280a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80280d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802810:	8b 50 08             	mov    0x8(%eax),%edx
  802813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802816:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281c:	8b 40 0c             	mov    0xc(%eax),%eax
  80281f:	2b 45 08             	sub    0x8(%ebp),%eax
  802822:	89 c2                	mov    %eax,%edx
  802824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802827:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80282a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282d:	8b 50 08             	mov    0x8(%eax),%edx
  802830:	8b 45 08             	mov    0x8(%ebp),%eax
  802833:	01 c2                	add    %eax,%edx
  802835:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802838:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80283b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80283f:	75 17                	jne    802858 <alloc_block_BF+0x18d>
  802841:	83 ec 04             	sub    $0x4,%esp
  802844:	68 89 3d 80 00       	push   $0x803d89
  802849:	68 af 00 00 00       	push   $0xaf
  80284e:	68 17 3d 80 00       	push   $0x803d17
  802853:	e8 e9 09 00 00       	call   803241 <_panic>
  802858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80285b:	8b 00                	mov    (%eax),%eax
  80285d:	85 c0                	test   %eax,%eax
  80285f:	74 10                	je     802871 <alloc_block_BF+0x1a6>
  802861:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802869:	8b 52 04             	mov    0x4(%edx),%edx
  80286c:	89 50 04             	mov    %edx,0x4(%eax)
  80286f:	eb 0b                	jmp    80287c <alloc_block_BF+0x1b1>
  802871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802874:	8b 40 04             	mov    0x4(%eax),%eax
  802877:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80287c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80287f:	8b 40 04             	mov    0x4(%eax),%eax
  802882:	85 c0                	test   %eax,%eax
  802884:	74 0f                	je     802895 <alloc_block_BF+0x1ca>
  802886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802889:	8b 40 04             	mov    0x4(%eax),%eax
  80288c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80288f:	8b 12                	mov    (%edx),%edx
  802891:	89 10                	mov    %edx,(%eax)
  802893:	eb 0a                	jmp    80289f <alloc_block_BF+0x1d4>
  802895:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	a3 48 41 80 00       	mov    %eax,0x804148
  80289f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b2:	a1 54 41 80 00       	mov    0x804154,%eax
  8028b7:	48                   	dec    %eax
  8028b8:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8028bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c0:	eb 05                	jmp    8028c7 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8028c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    

008028c9 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
  8028cc:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8028cf:	a1 38 41 80 00       	mov    0x804138,%eax
  8028d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8028d7:	e9 7c 01 00 00       	jmp    802a58 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028e5:	0f 86 cf 00 00 00    	jbe    8029ba <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8028eb:	a1 48 41 80 00       	mov    0x804148,%eax
  8028f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8028f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8028f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ff:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802902:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802905:	8b 50 08             	mov    0x8(%eax),%edx
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	8b 40 0c             	mov    0xc(%eax),%eax
  802914:	2b 45 08             	sub    0x8(%ebp),%eax
  802917:	89 c2                	mov    %eax,%edx
  802919:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291c:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 50 08             	mov    0x8(%eax),%edx
  802925:	8b 45 08             	mov    0x8(%ebp),%eax
  802928:	01 c2                	add    %eax,%edx
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802930:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802934:	75 17                	jne    80294d <alloc_block_NF+0x84>
  802936:	83 ec 04             	sub    $0x4,%esp
  802939:	68 89 3d 80 00       	push   $0x803d89
  80293e:	68 c4 00 00 00       	push   $0xc4
  802943:	68 17 3d 80 00       	push   $0x803d17
  802948:	e8 f4 08 00 00       	call   803241 <_panic>
  80294d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802950:	8b 00                	mov    (%eax),%eax
  802952:	85 c0                	test   %eax,%eax
  802954:	74 10                	je     802966 <alloc_block_NF+0x9d>
  802956:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802959:	8b 00                	mov    (%eax),%eax
  80295b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80295e:	8b 52 04             	mov    0x4(%edx),%edx
  802961:	89 50 04             	mov    %edx,0x4(%eax)
  802964:	eb 0b                	jmp    802971 <alloc_block_NF+0xa8>
  802966:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802969:	8b 40 04             	mov    0x4(%eax),%eax
  80296c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802974:	8b 40 04             	mov    0x4(%eax),%eax
  802977:	85 c0                	test   %eax,%eax
  802979:	74 0f                	je     80298a <alloc_block_NF+0xc1>
  80297b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297e:	8b 40 04             	mov    0x4(%eax),%eax
  802981:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802984:	8b 12                	mov    (%edx),%edx
  802986:	89 10                	mov    %edx,(%eax)
  802988:	eb 0a                	jmp    802994 <alloc_block_NF+0xcb>
  80298a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	a3 48 41 80 00       	mov    %eax,0x804148
  802994:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802997:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a7:	a1 54 41 80 00       	mov    0x804154,%eax
  8029ac:	48                   	dec    %eax
  8029ad:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8029b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b5:	e9 ad 00 00 00       	jmp    802a67 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029c3:	0f 85 87 00 00 00    	jne    802a50 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8029c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cd:	75 17                	jne    8029e6 <alloc_block_NF+0x11d>
  8029cf:	83 ec 04             	sub    $0x4,%esp
  8029d2:	68 89 3d 80 00       	push   $0x803d89
  8029d7:	68 c8 00 00 00       	push   $0xc8
  8029dc:	68 17 3d 80 00       	push   $0x803d17
  8029e1:	e8 5b 08 00 00       	call   803241 <_panic>
  8029e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e9:	8b 00                	mov    (%eax),%eax
  8029eb:	85 c0                	test   %eax,%eax
  8029ed:	74 10                	je     8029ff <alloc_block_NF+0x136>
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 00                	mov    (%eax),%eax
  8029f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f7:	8b 52 04             	mov    0x4(%edx),%edx
  8029fa:	89 50 04             	mov    %edx,0x4(%eax)
  8029fd:	eb 0b                	jmp    802a0a <alloc_block_NF+0x141>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 40 04             	mov    0x4(%eax),%eax
  802a05:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	8b 40 04             	mov    0x4(%eax),%eax
  802a10:	85 c0                	test   %eax,%eax
  802a12:	74 0f                	je     802a23 <alloc_block_NF+0x15a>
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 40 04             	mov    0x4(%eax),%eax
  802a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1d:	8b 12                	mov    (%edx),%edx
  802a1f:	89 10                	mov    %edx,(%eax)
  802a21:	eb 0a                	jmp    802a2d <alloc_block_NF+0x164>
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 00                	mov    (%eax),%eax
  802a28:	a3 38 41 80 00       	mov    %eax,0x804138
  802a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a39:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a40:	a1 44 41 80 00       	mov    0x804144,%eax
  802a45:	48                   	dec    %eax
  802a46:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4e:	eb 17                	jmp    802a67 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	8b 00                	mov    (%eax),%eax
  802a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802a58:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5c:	0f 85 7a fe ff ff    	jne    8028dc <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802a62:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802a67:	c9                   	leave  
  802a68:	c3                   	ret    

00802a69 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a69:	55                   	push   %ebp
  802a6a:	89 e5                	mov    %esp,%ebp
  802a6c:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802a6f:	a1 38 41 80 00       	mov    0x804138,%eax
  802a74:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802a77:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802a7f:	a1 44 41 80 00       	mov    0x804144,%eax
  802a84:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802a87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a8b:	75 68                	jne    802af5 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802a8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a91:	75 17                	jne    802aaa <insert_sorted_with_merge_freeList+0x41>
  802a93:	83 ec 04             	sub    $0x4,%esp
  802a96:	68 f4 3c 80 00       	push   $0x803cf4
  802a9b:	68 da 00 00 00       	push   $0xda
  802aa0:	68 17 3d 80 00       	push   $0x803d17
  802aa5:	e8 97 07 00 00       	call   803241 <_panic>
  802aaa:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	89 10                	mov    %edx,(%eax)
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	74 0d                	je     802acb <insert_sorted_with_merge_freeList+0x62>
  802abe:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac6:	89 50 04             	mov    %edx,0x4(%eax)
  802ac9:	eb 08                	jmp    802ad3 <insert_sorted_with_merge_freeList+0x6a>
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	a3 38 41 80 00       	mov    %eax,0x804138
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae5:	a1 44 41 80 00       	mov    0x804144,%eax
  802aea:	40                   	inc    %eax
  802aeb:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802af0:	e9 49 07 00 00       	jmp    80323e <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af8:	8b 50 08             	mov    0x8(%eax),%edx
  802afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afe:	8b 40 0c             	mov    0xc(%eax),%eax
  802b01:	01 c2                	add    %eax,%edx
  802b03:	8b 45 08             	mov    0x8(%ebp),%eax
  802b06:	8b 40 08             	mov    0x8(%eax),%eax
  802b09:	39 c2                	cmp    %eax,%edx
  802b0b:	73 77                	jae    802b84 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b10:	8b 00                	mov    (%eax),%eax
  802b12:	85 c0                	test   %eax,%eax
  802b14:	75 6e                	jne    802b84 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802b16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b1a:	74 68                	je     802b84 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802b1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b20:	75 17                	jne    802b39 <insert_sorted_with_merge_freeList+0xd0>
  802b22:	83 ec 04             	sub    $0x4,%esp
  802b25:	68 30 3d 80 00       	push   $0x803d30
  802b2a:	68 e0 00 00 00       	push   $0xe0
  802b2f:	68 17 3d 80 00       	push   $0x803d17
  802b34:	e8 08 07 00 00       	call   803241 <_panic>
  802b39:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	89 50 04             	mov    %edx,0x4(%eax)
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	8b 40 04             	mov    0x4(%eax),%eax
  802b4b:	85 c0                	test   %eax,%eax
  802b4d:	74 0c                	je     802b5b <insert_sorted_with_merge_freeList+0xf2>
  802b4f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b54:	8b 55 08             	mov    0x8(%ebp),%edx
  802b57:	89 10                	mov    %edx,(%eax)
  802b59:	eb 08                	jmp    802b63 <insert_sorted_with_merge_freeList+0xfa>
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	a3 38 41 80 00       	mov    %eax,0x804138
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b74:	a1 44 41 80 00       	mov    0x804144,%eax
  802b79:	40                   	inc    %eax
  802b7a:	a3 44 41 80 00       	mov    %eax,0x804144
  802b7f:	e9 ba 06 00 00       	jmp    80323e <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	8b 50 0c             	mov    0xc(%eax),%edx
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	8b 40 08             	mov    0x8(%eax),%eax
  802b90:	01 c2                	add    %eax,%edx
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 40 08             	mov    0x8(%eax),%eax
  802b98:	39 c2                	cmp    %eax,%edx
  802b9a:	73 78                	jae    802c14 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9f:	8b 40 04             	mov    0x4(%eax),%eax
  802ba2:	85 c0                	test   %eax,%eax
  802ba4:	75 6e                	jne    802c14 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802ba6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802baa:	74 68                	je     802c14 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802bac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb0:	75 17                	jne    802bc9 <insert_sorted_with_merge_freeList+0x160>
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	68 f4 3c 80 00       	push   $0x803cf4
  802bba:	68 e6 00 00 00       	push   $0xe6
  802bbf:	68 17 3d 80 00       	push   $0x803d17
  802bc4:	e8 78 06 00 00       	call   803241 <_panic>
  802bc9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	89 10                	mov    %edx,(%eax)
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	8b 00                	mov    (%eax),%eax
  802bd9:	85 c0                	test   %eax,%eax
  802bdb:	74 0d                	je     802bea <insert_sorted_with_merge_freeList+0x181>
  802bdd:	a1 38 41 80 00       	mov    0x804138,%eax
  802be2:	8b 55 08             	mov    0x8(%ebp),%edx
  802be5:	89 50 04             	mov    %edx,0x4(%eax)
  802be8:	eb 08                	jmp    802bf2 <insert_sorted_with_merge_freeList+0x189>
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	a3 38 41 80 00       	mov    %eax,0x804138
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c04:	a1 44 41 80 00       	mov    0x804144,%eax
  802c09:	40                   	inc    %eax
  802c0a:	a3 44 41 80 00       	mov    %eax,0x804144
  802c0f:	e9 2a 06 00 00       	jmp    80323e <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802c14:	a1 38 41 80 00       	mov    0x804138,%eax
  802c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c1c:	e9 ed 05 00 00       	jmp    80320e <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802c29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c2d:	0f 84 a7 00 00 00    	je     802cda <insert_sorted_with_merge_freeList+0x271>
  802c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c36:	8b 50 0c             	mov    0xc(%eax),%edx
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 40 08             	mov    0x8(%eax),%eax
  802c3f:	01 c2                	add    %eax,%edx
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	8b 40 08             	mov    0x8(%eax),%eax
  802c47:	39 c2                	cmp    %eax,%edx
  802c49:	0f 83 8b 00 00 00    	jae    802cda <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	8b 50 0c             	mov    0xc(%eax),%edx
  802c55:	8b 45 08             	mov    0x8(%ebp),%eax
  802c58:	8b 40 08             	mov    0x8(%eax),%eax
  802c5b:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802c5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c60:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802c63:	39 c2                	cmp    %eax,%edx
  802c65:	73 73                	jae    802cda <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6b:	74 06                	je     802c73 <insert_sorted_with_merge_freeList+0x20a>
  802c6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c71:	75 17                	jne    802c8a <insert_sorted_with_merge_freeList+0x221>
  802c73:	83 ec 04             	sub    $0x4,%esp
  802c76:	68 a8 3d 80 00       	push   $0x803da8
  802c7b:	68 f0 00 00 00       	push   $0xf0
  802c80:	68 17 3d 80 00       	push   $0x803d17
  802c85:	e8 b7 05 00 00       	call   803241 <_panic>
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 10                	mov    (%eax),%edx
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	89 10                	mov    %edx,(%eax)
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	8b 00                	mov    (%eax),%eax
  802c99:	85 c0                	test   %eax,%eax
  802c9b:	74 0b                	je     802ca8 <insert_sorted_with_merge_freeList+0x23f>
  802c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca0:	8b 00                	mov    (%eax),%eax
  802ca2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca5:	89 50 04             	mov    %edx,0x4(%eax)
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 55 08             	mov    0x8(%ebp),%edx
  802cae:	89 10                	mov    %edx,(%eax)
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb6:	89 50 04             	mov    %edx,0x4(%eax)
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	8b 00                	mov    (%eax),%eax
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	75 08                	jne    802cca <insert_sorted_with_merge_freeList+0x261>
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cca:	a1 44 41 80 00       	mov    0x804144,%eax
  802ccf:	40                   	inc    %eax
  802cd0:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802cd5:	e9 64 05 00 00       	jmp    80323e <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802cda:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cdf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ce7:	8b 40 08             	mov    0x8(%eax),%eax
  802cea:	01 c2                	add    %eax,%edx
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	8b 40 08             	mov    0x8(%eax),%eax
  802cf2:	39 c2                	cmp    %eax,%edx
  802cf4:	0f 85 b1 00 00 00    	jne    802dab <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802cfa:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	0f 84 a4 00 00 00    	je     802dab <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802d07:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d0c:	8b 00                	mov    (%eax),%eax
  802d0e:	85 c0                	test   %eax,%eax
  802d10:	0f 85 95 00 00 00    	jne    802dab <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802d16:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d1b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d21:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d24:	8b 55 08             	mov    0x8(%ebp),%edx
  802d27:	8b 52 0c             	mov    0xc(%edx),%edx
  802d2a:	01 ca                	add    %ecx,%edx
  802d2c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d47:	75 17                	jne    802d60 <insert_sorted_with_merge_freeList+0x2f7>
  802d49:	83 ec 04             	sub    $0x4,%esp
  802d4c:	68 f4 3c 80 00       	push   $0x803cf4
  802d51:	68 ff 00 00 00       	push   $0xff
  802d56:	68 17 3d 80 00       	push   $0x803d17
  802d5b:	e8 e1 04 00 00       	call   803241 <_panic>
  802d60:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	89 10                	mov    %edx,(%eax)
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	8b 00                	mov    (%eax),%eax
  802d70:	85 c0                	test   %eax,%eax
  802d72:	74 0d                	je     802d81 <insert_sorted_with_merge_freeList+0x318>
  802d74:	a1 48 41 80 00       	mov    0x804148,%eax
  802d79:	8b 55 08             	mov    0x8(%ebp),%edx
  802d7c:	89 50 04             	mov    %edx,0x4(%eax)
  802d7f:	eb 08                	jmp    802d89 <insert_sorted_with_merge_freeList+0x320>
  802d81:	8b 45 08             	mov    0x8(%ebp),%eax
  802d84:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	a3 48 41 80 00       	mov    %eax,0x804148
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9b:	a1 54 41 80 00       	mov    0x804154,%eax
  802da0:	40                   	inc    %eax
  802da1:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802da6:	e9 93 04 00 00       	jmp    80323e <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 50 08             	mov    0x8(%eax),%edx
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 40 0c             	mov    0xc(%eax),%eax
  802db7:	01 c2                	add    %eax,%edx
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	8b 40 08             	mov    0x8(%eax),%eax
  802dbf:	39 c2                	cmp    %eax,%edx
  802dc1:	0f 85 ae 00 00 00    	jne    802e75 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 50 0c             	mov    0xc(%eax),%edx
  802dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd0:	8b 40 08             	mov    0x8(%eax),%eax
  802dd3:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 00                	mov    (%eax),%eax
  802dda:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802ddd:	39 c2                	cmp    %eax,%edx
  802ddf:	0f 84 90 00 00 00    	je     802e75 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 50 0c             	mov    0xc(%eax),%edx
  802deb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dee:	8b 40 0c             	mov    0xc(%eax),%eax
  802df1:	01 c2                	add    %eax,%edx
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e11:	75 17                	jne    802e2a <insert_sorted_with_merge_freeList+0x3c1>
  802e13:	83 ec 04             	sub    $0x4,%esp
  802e16:	68 f4 3c 80 00       	push   $0x803cf4
  802e1b:	68 0b 01 00 00       	push   $0x10b
  802e20:	68 17 3d 80 00       	push   $0x803d17
  802e25:	e8 17 04 00 00       	call   803241 <_panic>
  802e2a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	89 10                	mov    %edx,(%eax)
  802e35:	8b 45 08             	mov    0x8(%ebp),%eax
  802e38:	8b 00                	mov    (%eax),%eax
  802e3a:	85 c0                	test   %eax,%eax
  802e3c:	74 0d                	je     802e4b <insert_sorted_with_merge_freeList+0x3e2>
  802e3e:	a1 48 41 80 00       	mov    0x804148,%eax
  802e43:	8b 55 08             	mov    0x8(%ebp),%edx
  802e46:	89 50 04             	mov    %edx,0x4(%eax)
  802e49:	eb 08                	jmp    802e53 <insert_sorted_with_merge_freeList+0x3ea>
  802e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	a3 48 41 80 00       	mov    %eax,0x804148
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e65:	a1 54 41 80 00       	mov    0x804154,%eax
  802e6a:	40                   	inc    %eax
  802e6b:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802e70:	e9 c9 03 00 00       	jmp    80323e <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	8b 40 08             	mov    0x8(%eax),%eax
  802e81:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802e89:	39 c2                	cmp    %eax,%edx
  802e8b:	0f 85 bb 00 00 00    	jne    802f4c <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802e91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e95:	0f 84 b1 00 00 00    	je     802f4c <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ea1:	85 c0                	test   %eax,%eax
  802ea3:	0f 85 a3 00 00 00    	jne    802f4c <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ea9:	a1 38 41 80 00       	mov    0x804138,%eax
  802eae:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb1:	8b 52 08             	mov    0x8(%edx),%edx
  802eb4:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802eb7:	a1 38 41 80 00       	mov    0x804138,%eax
  802ebc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ec2:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ec5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec8:	8b 52 0c             	mov    0xc(%edx),%edx
  802ecb:	01 ca                	add    %ecx,%edx
  802ecd:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802ee4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee8:	75 17                	jne    802f01 <insert_sorted_with_merge_freeList+0x498>
  802eea:	83 ec 04             	sub    $0x4,%esp
  802eed:	68 f4 3c 80 00       	push   $0x803cf4
  802ef2:	68 17 01 00 00       	push   $0x117
  802ef7:	68 17 3d 80 00       	push   $0x803d17
  802efc:	e8 40 03 00 00       	call   803241 <_panic>
  802f01:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	89 10                	mov    %edx,(%eax)
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	8b 00                	mov    (%eax),%eax
  802f11:	85 c0                	test   %eax,%eax
  802f13:	74 0d                	je     802f22 <insert_sorted_with_merge_freeList+0x4b9>
  802f15:	a1 48 41 80 00       	mov    0x804148,%eax
  802f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1d:	89 50 04             	mov    %edx,0x4(%eax)
  802f20:	eb 08                	jmp    802f2a <insert_sorted_with_merge_freeList+0x4c1>
  802f22:	8b 45 08             	mov    0x8(%ebp),%eax
  802f25:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	a3 48 41 80 00       	mov    %eax,0x804148
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3c:	a1 54 41 80 00       	mov    0x804154,%eax
  802f41:	40                   	inc    %eax
  802f42:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802f47:	e9 f2 02 00 00       	jmp    80323e <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	8b 50 08             	mov    0x8(%eax),%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 40 0c             	mov    0xc(%eax),%eax
  802f58:	01 c2                	add    %eax,%edx
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	8b 40 08             	mov    0x8(%eax),%eax
  802f60:	39 c2                	cmp    %eax,%edx
  802f62:	0f 85 be 00 00 00    	jne    803026 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	8b 40 04             	mov    0x4(%eax),%eax
  802f6e:	8b 50 08             	mov    0x8(%eax),%edx
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7a:	01 c2                	add    %eax,%edx
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8b 40 08             	mov    0x8(%eax),%eax
  802f82:	39 c2                	cmp    %eax,%edx
  802f84:	0f 84 9c 00 00 00    	je     803026 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8d:	8b 50 08             	mov    0x8(%eax),%edx
  802f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f93:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	8b 50 0c             	mov    0xc(%eax),%edx
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa2:	01 c2                	add    %eax,%edx
  802fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa7:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802faa:	8b 45 08             	mov    0x8(%ebp),%eax
  802fad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802fbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc2:	75 17                	jne    802fdb <insert_sorted_with_merge_freeList+0x572>
  802fc4:	83 ec 04             	sub    $0x4,%esp
  802fc7:	68 f4 3c 80 00       	push   $0x803cf4
  802fcc:	68 26 01 00 00       	push   $0x126
  802fd1:	68 17 3d 80 00       	push   $0x803d17
  802fd6:	e8 66 02 00 00       	call   803241 <_panic>
  802fdb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	89 10                	mov    %edx,(%eax)
  802fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	85 c0                	test   %eax,%eax
  802fed:	74 0d                	je     802ffc <insert_sorted_with_merge_freeList+0x593>
  802fef:	a1 48 41 80 00       	mov    0x804148,%eax
  802ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff7:	89 50 04             	mov    %edx,0x4(%eax)
  802ffa:	eb 08                	jmp    803004 <insert_sorted_with_merge_freeList+0x59b>
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	a3 48 41 80 00       	mov    %eax,0x804148
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803016:	a1 54 41 80 00       	mov    0x804154,%eax
  80301b:	40                   	inc    %eax
  80301c:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  803021:	e9 18 02 00 00       	jmp    80323e <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803026:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803029:	8b 50 0c             	mov    0xc(%eax),%edx
  80302c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302f:	8b 40 08             	mov    0x8(%eax),%eax
  803032:	01 c2                	add    %eax,%edx
  803034:	8b 45 08             	mov    0x8(%ebp),%eax
  803037:	8b 40 08             	mov    0x8(%eax),%eax
  80303a:	39 c2                	cmp    %eax,%edx
  80303c:	0f 85 c4 01 00 00    	jne    803206 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	8b 50 0c             	mov    0xc(%eax),%edx
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	8b 40 08             	mov    0x8(%eax),%eax
  80304e:	01 c2                	add    %eax,%edx
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	8b 40 08             	mov    0x8(%eax),%eax
  803058:	39 c2                	cmp    %eax,%edx
  80305a:	0f 85 a6 01 00 00    	jne    803206 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803060:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803064:	0f 84 9c 01 00 00    	je     803206 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 50 0c             	mov    0xc(%eax),%edx
  803070:	8b 45 08             	mov    0x8(%ebp),%eax
  803073:	8b 40 0c             	mov    0xc(%eax),%eax
  803076:	01 c2                	add    %eax,%edx
  803078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307b:	8b 00                	mov    (%eax),%eax
  80307d:	8b 40 0c             	mov    0xc(%eax),%eax
  803080:	01 c2                	add    %eax,%edx
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803092:	8b 45 08             	mov    0x8(%ebp),%eax
  803095:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80309c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a0:	75 17                	jne    8030b9 <insert_sorted_with_merge_freeList+0x650>
  8030a2:	83 ec 04             	sub    $0x4,%esp
  8030a5:	68 f4 3c 80 00       	push   $0x803cf4
  8030aa:	68 32 01 00 00       	push   $0x132
  8030af:	68 17 3d 80 00       	push   $0x803d17
  8030b4:	e8 88 01 00 00       	call   803241 <_panic>
  8030b9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c2:	89 10                	mov    %edx,(%eax)
  8030c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c7:	8b 00                	mov    (%eax),%eax
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	74 0d                	je     8030da <insert_sorted_with_merge_freeList+0x671>
  8030cd:	a1 48 41 80 00       	mov    0x804148,%eax
  8030d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030d5:	89 50 04             	mov    %edx,0x4(%eax)
  8030d8:	eb 08                	jmp    8030e2 <insert_sorted_with_merge_freeList+0x679>
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e5:	a3 48 41 80 00       	mov    %eax,0x804148
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030f4:	a1 54 41 80 00       	mov    0x804154,%eax
  8030f9:	40                   	inc    %eax
  8030fa:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	8b 00                	mov    (%eax),%eax
  803104:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	8b 00                	mov    (%eax),%eax
  80311c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80311f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803123:	75 17                	jne    80313c <insert_sorted_with_merge_freeList+0x6d3>
  803125:	83 ec 04             	sub    $0x4,%esp
  803128:	68 89 3d 80 00       	push   $0x803d89
  80312d:	68 36 01 00 00       	push   $0x136
  803132:	68 17 3d 80 00       	push   $0x803d17
  803137:	e8 05 01 00 00       	call   803241 <_panic>
  80313c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	74 10                	je     803155 <insert_sorted_with_merge_freeList+0x6ec>
  803145:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80314d:	8b 52 04             	mov    0x4(%edx),%edx
  803150:	89 50 04             	mov    %edx,0x4(%eax)
  803153:	eb 0b                	jmp    803160 <insert_sorted_with_merge_freeList+0x6f7>
  803155:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803158:	8b 40 04             	mov    0x4(%eax),%eax
  80315b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803160:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803163:	8b 40 04             	mov    0x4(%eax),%eax
  803166:	85 c0                	test   %eax,%eax
  803168:	74 0f                	je     803179 <insert_sorted_with_merge_freeList+0x710>
  80316a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80316d:	8b 40 04             	mov    0x4(%eax),%eax
  803170:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803173:	8b 12                	mov    (%edx),%edx
  803175:	89 10                	mov    %edx,(%eax)
  803177:	eb 0a                	jmp    803183 <insert_sorted_with_merge_freeList+0x71a>
  803179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317c:	8b 00                	mov    (%eax),%eax
  80317e:	a3 38 41 80 00       	mov    %eax,0x804138
  803183:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803186:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803196:	a1 44 41 80 00       	mov    0x804144,%eax
  80319b:	48                   	dec    %eax
  80319c:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8031a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031a5:	75 17                	jne    8031be <insert_sorted_with_merge_freeList+0x755>
  8031a7:	83 ec 04             	sub    $0x4,%esp
  8031aa:	68 f4 3c 80 00       	push   $0x803cf4
  8031af:	68 37 01 00 00       	push   $0x137
  8031b4:	68 17 3d 80 00       	push   $0x803d17
  8031b9:	e8 83 00 00 00       	call   803241 <_panic>
  8031be:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c7:	89 10                	mov    %edx,(%eax)
  8031c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cc:	8b 00                	mov    (%eax),%eax
  8031ce:	85 c0                	test   %eax,%eax
  8031d0:	74 0d                	je     8031df <insert_sorted_with_merge_freeList+0x776>
  8031d2:	a1 48 41 80 00       	mov    0x804148,%eax
  8031d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031da:	89 50 04             	mov    %edx,0x4(%eax)
  8031dd:	eb 08                	jmp    8031e7 <insert_sorted_with_merge_freeList+0x77e>
  8031df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ea:	a3 48 41 80 00       	mov    %eax,0x804148
  8031ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031f9:	a1 54 41 80 00       	mov    0x804154,%eax
  8031fe:	40                   	inc    %eax
  8031ff:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  803204:	eb 38                	jmp    80323e <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803206:	a1 40 41 80 00       	mov    0x804140,%eax
  80320b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80320e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803212:	74 07                	je     80321b <insert_sorted_with_merge_freeList+0x7b2>
  803214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803217:	8b 00                	mov    (%eax),%eax
  803219:	eb 05                	jmp    803220 <insert_sorted_with_merge_freeList+0x7b7>
  80321b:	b8 00 00 00 00       	mov    $0x0,%eax
  803220:	a3 40 41 80 00       	mov    %eax,0x804140
  803225:	a1 40 41 80 00       	mov    0x804140,%eax
  80322a:	85 c0                	test   %eax,%eax
  80322c:	0f 85 ef f9 ff ff    	jne    802c21 <insert_sorted_with_merge_freeList+0x1b8>
  803232:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803236:	0f 85 e5 f9 ff ff    	jne    802c21 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80323c:	eb 00                	jmp    80323e <insert_sorted_with_merge_freeList+0x7d5>
  80323e:	90                   	nop
  80323f:	c9                   	leave  
  803240:	c3                   	ret    

00803241 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803241:	55                   	push   %ebp
  803242:	89 e5                	mov    %esp,%ebp
  803244:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  803247:	8d 45 10             	lea    0x10(%ebp),%eax
  80324a:	83 c0 04             	add    $0x4,%eax
  80324d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803250:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803255:	85 c0                	test   %eax,%eax
  803257:	74 16                	je     80326f <_panic+0x2e>
		cprintf("%s: ", argv0);
  803259:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80325e:	83 ec 08             	sub    $0x8,%esp
  803261:	50                   	push   %eax
  803262:	68 dc 3d 80 00       	push   $0x803ddc
  803267:	e8 d1 d4 ff ff       	call   80073d <cprintf>
  80326c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80326f:	a1 00 40 80 00       	mov    0x804000,%eax
  803274:	ff 75 0c             	pushl  0xc(%ebp)
  803277:	ff 75 08             	pushl  0x8(%ebp)
  80327a:	50                   	push   %eax
  80327b:	68 e1 3d 80 00       	push   $0x803de1
  803280:	e8 b8 d4 ff ff       	call   80073d <cprintf>
  803285:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  803288:	8b 45 10             	mov    0x10(%ebp),%eax
  80328b:	83 ec 08             	sub    $0x8,%esp
  80328e:	ff 75 f4             	pushl  -0xc(%ebp)
  803291:	50                   	push   %eax
  803292:	e8 3b d4 ff ff       	call   8006d2 <vcprintf>
  803297:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80329a:	83 ec 08             	sub    $0x8,%esp
  80329d:	6a 00                	push   $0x0
  80329f:	68 fd 3d 80 00       	push   $0x803dfd
  8032a4:	e8 29 d4 ff ff       	call   8006d2 <vcprintf>
  8032a9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8032ac:	e8 aa d3 ff ff       	call   80065b <exit>

	// should not return here
	while (1) ;
  8032b1:	eb fe                	jmp    8032b1 <_panic+0x70>

008032b3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8032b3:	55                   	push   %ebp
  8032b4:	89 e5                	mov    %esp,%ebp
  8032b6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8032b9:	a1 20 40 80 00       	mov    0x804020,%eax
  8032be:	8b 50 74             	mov    0x74(%eax),%edx
  8032c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c4:	39 c2                	cmp    %eax,%edx
  8032c6:	74 14                	je     8032dc <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8032c8:	83 ec 04             	sub    $0x4,%esp
  8032cb:	68 00 3e 80 00       	push   $0x803e00
  8032d0:	6a 26                	push   $0x26
  8032d2:	68 4c 3e 80 00       	push   $0x803e4c
  8032d7:	e8 65 ff ff ff       	call   803241 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8032dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8032e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8032ea:	e9 c2 00 00 00       	jmp    8033b1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8032ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8032f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fc:	01 d0                	add    %edx,%eax
  8032fe:	8b 00                	mov    (%eax),%eax
  803300:	85 c0                	test   %eax,%eax
  803302:	75 08                	jne    80330c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803304:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803307:	e9 a2 00 00 00       	jmp    8033ae <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80330c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803313:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80331a:	eb 69                	jmp    803385 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80331c:	a1 20 40 80 00       	mov    0x804020,%eax
  803321:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803327:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80332a:	89 d0                	mov    %edx,%eax
  80332c:	01 c0                	add    %eax,%eax
  80332e:	01 d0                	add    %edx,%eax
  803330:	c1 e0 03             	shl    $0x3,%eax
  803333:	01 c8                	add    %ecx,%eax
  803335:	8a 40 04             	mov    0x4(%eax),%al
  803338:	84 c0                	test   %al,%al
  80333a:	75 46                	jne    803382 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80333c:	a1 20 40 80 00       	mov    0x804020,%eax
  803341:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803347:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80334a:	89 d0                	mov    %edx,%eax
  80334c:	01 c0                	add    %eax,%eax
  80334e:	01 d0                	add    %edx,%eax
  803350:	c1 e0 03             	shl    $0x3,%eax
  803353:	01 c8                	add    %ecx,%eax
  803355:	8b 00                	mov    (%eax),%eax
  803357:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80335a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80335d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803362:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803367:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	01 c8                	add    %ecx,%eax
  803373:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803375:	39 c2                	cmp    %eax,%edx
  803377:	75 09                	jne    803382 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803379:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803380:	eb 12                	jmp    803394 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803382:	ff 45 e8             	incl   -0x18(%ebp)
  803385:	a1 20 40 80 00       	mov    0x804020,%eax
  80338a:	8b 50 74             	mov    0x74(%eax),%edx
  80338d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803390:	39 c2                	cmp    %eax,%edx
  803392:	77 88                	ja     80331c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803394:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803398:	75 14                	jne    8033ae <CheckWSWithoutLastIndex+0xfb>
			panic(
  80339a:	83 ec 04             	sub    $0x4,%esp
  80339d:	68 58 3e 80 00       	push   $0x803e58
  8033a2:	6a 3a                	push   $0x3a
  8033a4:	68 4c 3e 80 00       	push   $0x803e4c
  8033a9:	e8 93 fe ff ff       	call   803241 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8033ae:	ff 45 f0             	incl   -0x10(%ebp)
  8033b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8033b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8033b7:	0f 8c 32 ff ff ff    	jl     8032ef <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8033bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8033cb:	eb 26                	jmp    8033f3 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8033cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8033d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8033d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033db:	89 d0                	mov    %edx,%eax
  8033dd:	01 c0                	add    %eax,%eax
  8033df:	01 d0                	add    %edx,%eax
  8033e1:	c1 e0 03             	shl    $0x3,%eax
  8033e4:	01 c8                	add    %ecx,%eax
  8033e6:	8a 40 04             	mov    0x4(%eax),%al
  8033e9:	3c 01                	cmp    $0x1,%al
  8033eb:	75 03                	jne    8033f0 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8033ed:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8033f0:	ff 45 e0             	incl   -0x20(%ebp)
  8033f3:	a1 20 40 80 00       	mov    0x804020,%eax
  8033f8:	8b 50 74             	mov    0x74(%eax),%edx
  8033fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033fe:	39 c2                	cmp    %eax,%edx
  803400:	77 cb                	ja     8033cd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803405:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803408:	74 14                	je     80341e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80340a:	83 ec 04             	sub    $0x4,%esp
  80340d:	68 ac 3e 80 00       	push   $0x803eac
  803412:	6a 44                	push   $0x44
  803414:	68 4c 3e 80 00       	push   $0x803e4c
  803419:	e8 23 fe ff ff       	call   803241 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80341e:	90                   	nop
  80341f:	c9                   	leave  
  803420:	c3                   	ret    
  803421:	66 90                	xchg   %ax,%ax
  803423:	90                   	nop

00803424 <__udivdi3>:
  803424:	55                   	push   %ebp
  803425:	57                   	push   %edi
  803426:	56                   	push   %esi
  803427:	53                   	push   %ebx
  803428:	83 ec 1c             	sub    $0x1c,%esp
  80342b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80342f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803433:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803437:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80343b:	89 ca                	mov    %ecx,%edx
  80343d:	89 f8                	mov    %edi,%eax
  80343f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803443:	85 f6                	test   %esi,%esi
  803445:	75 2d                	jne    803474 <__udivdi3+0x50>
  803447:	39 cf                	cmp    %ecx,%edi
  803449:	77 65                	ja     8034b0 <__udivdi3+0x8c>
  80344b:	89 fd                	mov    %edi,%ebp
  80344d:	85 ff                	test   %edi,%edi
  80344f:	75 0b                	jne    80345c <__udivdi3+0x38>
  803451:	b8 01 00 00 00       	mov    $0x1,%eax
  803456:	31 d2                	xor    %edx,%edx
  803458:	f7 f7                	div    %edi
  80345a:	89 c5                	mov    %eax,%ebp
  80345c:	31 d2                	xor    %edx,%edx
  80345e:	89 c8                	mov    %ecx,%eax
  803460:	f7 f5                	div    %ebp
  803462:	89 c1                	mov    %eax,%ecx
  803464:	89 d8                	mov    %ebx,%eax
  803466:	f7 f5                	div    %ebp
  803468:	89 cf                	mov    %ecx,%edi
  80346a:	89 fa                	mov    %edi,%edx
  80346c:	83 c4 1c             	add    $0x1c,%esp
  80346f:	5b                   	pop    %ebx
  803470:	5e                   	pop    %esi
  803471:	5f                   	pop    %edi
  803472:	5d                   	pop    %ebp
  803473:	c3                   	ret    
  803474:	39 ce                	cmp    %ecx,%esi
  803476:	77 28                	ja     8034a0 <__udivdi3+0x7c>
  803478:	0f bd fe             	bsr    %esi,%edi
  80347b:	83 f7 1f             	xor    $0x1f,%edi
  80347e:	75 40                	jne    8034c0 <__udivdi3+0x9c>
  803480:	39 ce                	cmp    %ecx,%esi
  803482:	72 0a                	jb     80348e <__udivdi3+0x6a>
  803484:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803488:	0f 87 9e 00 00 00    	ja     80352c <__udivdi3+0x108>
  80348e:	b8 01 00 00 00       	mov    $0x1,%eax
  803493:	89 fa                	mov    %edi,%edx
  803495:	83 c4 1c             	add    $0x1c,%esp
  803498:	5b                   	pop    %ebx
  803499:	5e                   	pop    %esi
  80349a:	5f                   	pop    %edi
  80349b:	5d                   	pop    %ebp
  80349c:	c3                   	ret    
  80349d:	8d 76 00             	lea    0x0(%esi),%esi
  8034a0:	31 ff                	xor    %edi,%edi
  8034a2:	31 c0                	xor    %eax,%eax
  8034a4:	89 fa                	mov    %edi,%edx
  8034a6:	83 c4 1c             	add    $0x1c,%esp
  8034a9:	5b                   	pop    %ebx
  8034aa:	5e                   	pop    %esi
  8034ab:	5f                   	pop    %edi
  8034ac:	5d                   	pop    %ebp
  8034ad:	c3                   	ret    
  8034ae:	66 90                	xchg   %ax,%ax
  8034b0:	89 d8                	mov    %ebx,%eax
  8034b2:	f7 f7                	div    %edi
  8034b4:	31 ff                	xor    %edi,%edi
  8034b6:	89 fa                	mov    %edi,%edx
  8034b8:	83 c4 1c             	add    $0x1c,%esp
  8034bb:	5b                   	pop    %ebx
  8034bc:	5e                   	pop    %esi
  8034bd:	5f                   	pop    %edi
  8034be:	5d                   	pop    %ebp
  8034bf:	c3                   	ret    
  8034c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034c5:	89 eb                	mov    %ebp,%ebx
  8034c7:	29 fb                	sub    %edi,%ebx
  8034c9:	89 f9                	mov    %edi,%ecx
  8034cb:	d3 e6                	shl    %cl,%esi
  8034cd:	89 c5                	mov    %eax,%ebp
  8034cf:	88 d9                	mov    %bl,%cl
  8034d1:	d3 ed                	shr    %cl,%ebp
  8034d3:	89 e9                	mov    %ebp,%ecx
  8034d5:	09 f1                	or     %esi,%ecx
  8034d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034db:	89 f9                	mov    %edi,%ecx
  8034dd:	d3 e0                	shl    %cl,%eax
  8034df:	89 c5                	mov    %eax,%ebp
  8034e1:	89 d6                	mov    %edx,%esi
  8034e3:	88 d9                	mov    %bl,%cl
  8034e5:	d3 ee                	shr    %cl,%esi
  8034e7:	89 f9                	mov    %edi,%ecx
  8034e9:	d3 e2                	shl    %cl,%edx
  8034eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034ef:	88 d9                	mov    %bl,%cl
  8034f1:	d3 e8                	shr    %cl,%eax
  8034f3:	09 c2                	or     %eax,%edx
  8034f5:	89 d0                	mov    %edx,%eax
  8034f7:	89 f2                	mov    %esi,%edx
  8034f9:	f7 74 24 0c          	divl   0xc(%esp)
  8034fd:	89 d6                	mov    %edx,%esi
  8034ff:	89 c3                	mov    %eax,%ebx
  803501:	f7 e5                	mul    %ebp
  803503:	39 d6                	cmp    %edx,%esi
  803505:	72 19                	jb     803520 <__udivdi3+0xfc>
  803507:	74 0b                	je     803514 <__udivdi3+0xf0>
  803509:	89 d8                	mov    %ebx,%eax
  80350b:	31 ff                	xor    %edi,%edi
  80350d:	e9 58 ff ff ff       	jmp    80346a <__udivdi3+0x46>
  803512:	66 90                	xchg   %ax,%ax
  803514:	8b 54 24 08          	mov    0x8(%esp),%edx
  803518:	89 f9                	mov    %edi,%ecx
  80351a:	d3 e2                	shl    %cl,%edx
  80351c:	39 c2                	cmp    %eax,%edx
  80351e:	73 e9                	jae    803509 <__udivdi3+0xe5>
  803520:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803523:	31 ff                	xor    %edi,%edi
  803525:	e9 40 ff ff ff       	jmp    80346a <__udivdi3+0x46>
  80352a:	66 90                	xchg   %ax,%ax
  80352c:	31 c0                	xor    %eax,%eax
  80352e:	e9 37 ff ff ff       	jmp    80346a <__udivdi3+0x46>
  803533:	90                   	nop

00803534 <__umoddi3>:
  803534:	55                   	push   %ebp
  803535:	57                   	push   %edi
  803536:	56                   	push   %esi
  803537:	53                   	push   %ebx
  803538:	83 ec 1c             	sub    $0x1c,%esp
  80353b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80353f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803543:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803547:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80354b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80354f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803553:	89 f3                	mov    %esi,%ebx
  803555:	89 fa                	mov    %edi,%edx
  803557:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80355b:	89 34 24             	mov    %esi,(%esp)
  80355e:	85 c0                	test   %eax,%eax
  803560:	75 1a                	jne    80357c <__umoddi3+0x48>
  803562:	39 f7                	cmp    %esi,%edi
  803564:	0f 86 a2 00 00 00    	jbe    80360c <__umoddi3+0xd8>
  80356a:	89 c8                	mov    %ecx,%eax
  80356c:	89 f2                	mov    %esi,%edx
  80356e:	f7 f7                	div    %edi
  803570:	89 d0                	mov    %edx,%eax
  803572:	31 d2                	xor    %edx,%edx
  803574:	83 c4 1c             	add    $0x1c,%esp
  803577:	5b                   	pop    %ebx
  803578:	5e                   	pop    %esi
  803579:	5f                   	pop    %edi
  80357a:	5d                   	pop    %ebp
  80357b:	c3                   	ret    
  80357c:	39 f0                	cmp    %esi,%eax
  80357e:	0f 87 ac 00 00 00    	ja     803630 <__umoddi3+0xfc>
  803584:	0f bd e8             	bsr    %eax,%ebp
  803587:	83 f5 1f             	xor    $0x1f,%ebp
  80358a:	0f 84 ac 00 00 00    	je     80363c <__umoddi3+0x108>
  803590:	bf 20 00 00 00       	mov    $0x20,%edi
  803595:	29 ef                	sub    %ebp,%edi
  803597:	89 fe                	mov    %edi,%esi
  803599:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80359d:	89 e9                	mov    %ebp,%ecx
  80359f:	d3 e0                	shl    %cl,%eax
  8035a1:	89 d7                	mov    %edx,%edi
  8035a3:	89 f1                	mov    %esi,%ecx
  8035a5:	d3 ef                	shr    %cl,%edi
  8035a7:	09 c7                	or     %eax,%edi
  8035a9:	89 e9                	mov    %ebp,%ecx
  8035ab:	d3 e2                	shl    %cl,%edx
  8035ad:	89 14 24             	mov    %edx,(%esp)
  8035b0:	89 d8                	mov    %ebx,%eax
  8035b2:	d3 e0                	shl    %cl,%eax
  8035b4:	89 c2                	mov    %eax,%edx
  8035b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035ba:	d3 e0                	shl    %cl,%eax
  8035bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035c4:	89 f1                	mov    %esi,%ecx
  8035c6:	d3 e8                	shr    %cl,%eax
  8035c8:	09 d0                	or     %edx,%eax
  8035ca:	d3 eb                	shr    %cl,%ebx
  8035cc:	89 da                	mov    %ebx,%edx
  8035ce:	f7 f7                	div    %edi
  8035d0:	89 d3                	mov    %edx,%ebx
  8035d2:	f7 24 24             	mull   (%esp)
  8035d5:	89 c6                	mov    %eax,%esi
  8035d7:	89 d1                	mov    %edx,%ecx
  8035d9:	39 d3                	cmp    %edx,%ebx
  8035db:	0f 82 87 00 00 00    	jb     803668 <__umoddi3+0x134>
  8035e1:	0f 84 91 00 00 00    	je     803678 <__umoddi3+0x144>
  8035e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035eb:	29 f2                	sub    %esi,%edx
  8035ed:	19 cb                	sbb    %ecx,%ebx
  8035ef:	89 d8                	mov    %ebx,%eax
  8035f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035f5:	d3 e0                	shl    %cl,%eax
  8035f7:	89 e9                	mov    %ebp,%ecx
  8035f9:	d3 ea                	shr    %cl,%edx
  8035fb:	09 d0                	or     %edx,%eax
  8035fd:	89 e9                	mov    %ebp,%ecx
  8035ff:	d3 eb                	shr    %cl,%ebx
  803601:	89 da                	mov    %ebx,%edx
  803603:	83 c4 1c             	add    $0x1c,%esp
  803606:	5b                   	pop    %ebx
  803607:	5e                   	pop    %esi
  803608:	5f                   	pop    %edi
  803609:	5d                   	pop    %ebp
  80360a:	c3                   	ret    
  80360b:	90                   	nop
  80360c:	89 fd                	mov    %edi,%ebp
  80360e:	85 ff                	test   %edi,%edi
  803610:	75 0b                	jne    80361d <__umoddi3+0xe9>
  803612:	b8 01 00 00 00       	mov    $0x1,%eax
  803617:	31 d2                	xor    %edx,%edx
  803619:	f7 f7                	div    %edi
  80361b:	89 c5                	mov    %eax,%ebp
  80361d:	89 f0                	mov    %esi,%eax
  80361f:	31 d2                	xor    %edx,%edx
  803621:	f7 f5                	div    %ebp
  803623:	89 c8                	mov    %ecx,%eax
  803625:	f7 f5                	div    %ebp
  803627:	89 d0                	mov    %edx,%eax
  803629:	e9 44 ff ff ff       	jmp    803572 <__umoddi3+0x3e>
  80362e:	66 90                	xchg   %ax,%ax
  803630:	89 c8                	mov    %ecx,%eax
  803632:	89 f2                	mov    %esi,%edx
  803634:	83 c4 1c             	add    $0x1c,%esp
  803637:	5b                   	pop    %ebx
  803638:	5e                   	pop    %esi
  803639:	5f                   	pop    %edi
  80363a:	5d                   	pop    %ebp
  80363b:	c3                   	ret    
  80363c:	3b 04 24             	cmp    (%esp),%eax
  80363f:	72 06                	jb     803647 <__umoddi3+0x113>
  803641:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803645:	77 0f                	ja     803656 <__umoddi3+0x122>
  803647:	89 f2                	mov    %esi,%edx
  803649:	29 f9                	sub    %edi,%ecx
  80364b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80364f:	89 14 24             	mov    %edx,(%esp)
  803652:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803656:	8b 44 24 04          	mov    0x4(%esp),%eax
  80365a:	8b 14 24             	mov    (%esp),%edx
  80365d:	83 c4 1c             	add    $0x1c,%esp
  803660:	5b                   	pop    %ebx
  803661:	5e                   	pop    %esi
  803662:	5f                   	pop    %edi
  803663:	5d                   	pop    %ebp
  803664:	c3                   	ret    
  803665:	8d 76 00             	lea    0x0(%esi),%esi
  803668:	2b 04 24             	sub    (%esp),%eax
  80366b:	19 fa                	sbb    %edi,%edx
  80366d:	89 d1                	mov    %edx,%ecx
  80366f:	89 c6                	mov    %eax,%esi
  803671:	e9 71 ff ff ff       	jmp    8035e7 <__umoddi3+0xb3>
  803676:	66 90                	xchg   %ax,%ax
  803678:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80367c:	72 ea                	jb     803668 <__umoddi3+0x134>
  80367e:	89 d9                	mov    %ebx,%ecx
  803680:	e9 62 ff ff ff       	jmp    8035e7 <__umoddi3+0xb3>
