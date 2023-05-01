
obj/user/tst_malloc_2:     file format elf32-i386


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
  800031:	e8 80 03 00 00       	call   8003b6 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	81 ec 94 00 00 00    	sub    $0x94,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  800042:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800046:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004d:	eb 29                	jmp    800078 <_main+0x40>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004f:	a1 20 40 80 00       	mov    0x804020,%eax
  800054:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80005a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005d:	89 d0                	mov    %edx,%eax
  80005f:	01 c0                	add    %eax,%eax
  800061:	01 d0                	add    %edx,%eax
  800063:	c1 e0 03             	shl    $0x3,%eax
  800066:	01 c8                	add    %ecx,%eax
  800068:	8a 40 04             	mov    0x4(%eax),%al
  80006b:	84 c0                	test   %al,%al
  80006d:	74 06                	je     800075 <_main+0x3d>
			{
				fullWS = 0;
  80006f:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800073:	eb 12                	jmp    800087 <_main+0x4f>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800075:	ff 45 f0             	incl   -0x10(%ebp)
  800078:	a1 20 40 80 00       	mov    0x804020,%eax
  80007d:	8b 50 74             	mov    0x74(%eax),%edx
  800080:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800083:	39 c2                	cmp    %eax,%edx
  800085:	77 c8                	ja     80004f <_main+0x17>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800087:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80008b:	74 14                	je     8000a1 <_main+0x69>
  80008d:	83 ec 04             	sub    $0x4,%esp
  800090:	68 20 35 80 00       	push   $0x803520
  800095:	6a 1a                	push   $0x1a
  800097:	68 3c 35 80 00       	push   $0x80353c
  80009c:	e8 51 04 00 00       	call   8004f2 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 9a 16 00 00       	call   801745 <malloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ae:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	char minByte = 1<<7;
  8000bc:	c6 45 e7 80          	movb   $0x80,-0x19(%ebp)
	char maxByte = 0x7F;
  8000c0:	c6 45 e6 7f          	movb   $0x7f,-0x1a(%ebp)
	short minShort = 1<<15 ;
  8000c4:	66 c7 45 e4 00 80    	movw   $0x8000,-0x1c(%ebp)
	short maxShort = 0x7FFF;
  8000ca:	66 c7 45 e2 ff 7f    	movw   $0x7fff,-0x1e(%ebp)
	int minInt = 1<<31 ;
  8000d0:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
	int maxInt = 0x7FFFFFFF;
  8000d7:	c7 45 d8 ff ff ff 7f 	movl   $0x7fffffff,-0x28(%ebp)

	void* ptr_allocations[20] = {0};
  8000de:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  8000e4:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8000ee:	89 d7                	mov    %edx,%edi
  8000f0:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000f5:	01 c0                	add    %eax,%eax
  8000f7:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	50                   	push   %eax
  8000fe:	e8 42 16 00 00       	call   801745 <malloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  80010c:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800112:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  800115:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800118:	01 c0                	add    %eax,%eax
  80011a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80011d:	48                   	dec    %eax
  80011e:	89 45 d0             	mov    %eax,-0x30(%ebp)
		byteArr[0] = minByte ;
  800121:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800124:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800127:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  800129:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80012c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80012f:	01 c2                	add    %eax,%edx
  800131:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800134:	88 02                	mov    %al,(%edx)

		ptr_allocations[1] = malloc(2*Mega-kilo);
  800136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800139:	01 c0                	add    %eax,%eax
  80013b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80013e:	83 ec 0c             	sub    $0xc,%esp
  800141:	50                   	push   %eax
  800142:	e8 fe 15 00 00       	call   801745 <malloc>
  800147:	83 c4 10             	add    $0x10,%esp
  80014a:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800150:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800156:	89 45 cc             	mov    %eax,-0x34(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800159:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80015c:	01 c0                	add    %eax,%eax
  80015e:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800161:	d1 e8                	shr    %eax
  800163:	48                   	dec    %eax
  800164:	89 45 c8             	mov    %eax,-0x38(%ebp)
		shortArr[0] = minShort;
  800167:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80016a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80016d:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800170:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800173:	01 c0                	add    %eax,%eax
  800175:	89 c2                	mov    %eax,%edx
  800177:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80017a:	01 c2                	add    %eax,%edx
  80017c:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  800180:	66 89 02             	mov    %ax,(%edx)

		ptr_allocations[2] = malloc(3*kilo);
  800183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800186:	89 c2                	mov    %eax,%edx
  800188:	01 d2                	add    %edx,%edx
  80018a:	01 d0                	add    %edx,%eax
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	e8 b0 15 00 00       	call   801745 <malloc>
  800195:	83 c4 10             	add    $0x10,%esp
  800198:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  80019e:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  8001a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  8001a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	c1 e8 02             	shr    $0x2,%eax
  8001af:	48                   	dec    %eax
  8001b0:	89 45 c0             	mov    %eax,-0x40(%ebp)
		intArr[0] = minInt;
  8001b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8001b9:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8001bb:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8001c8:	01 c2                	add    %eax,%edx
  8001ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001cd:	89 02                	mov    %eax,(%edx)

		ptr_allocations[3] = malloc(7*kilo);
  8001cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001d2:	89 d0                	mov    %edx,%eax
  8001d4:	01 c0                	add    %eax,%eax
  8001d6:	01 d0                	add    %edx,%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	01 d0                	add    %edx,%eax
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	50                   	push   %eax
  8001e0:	e8 60 15 00 00       	call   801745 <malloc>
  8001e5:	83 c4 10             	add    $0x10,%esp
  8001e8:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8001ee:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8001f4:	89 45 bc             	mov    %eax,-0x44(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8001f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001fa:	89 d0                	mov    %edx,%eax
  8001fc:	01 c0                	add    %eax,%eax
  8001fe:	01 d0                	add    %edx,%eax
  800200:	01 c0                	add    %eax,%eax
  800202:	01 d0                	add    %edx,%eax
  800204:	c1 e8 03             	shr    $0x3,%eax
  800207:	48                   	dec    %eax
  800208:	89 45 b8             	mov    %eax,-0x48(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  80020b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020e:	8a 55 e7             	mov    -0x19(%ebp),%dl
  800211:	88 10                	mov    %dl,(%eax)
  800213:	8b 55 bc             	mov    -0x44(%ebp),%edx
  800216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800219:	66 89 42 02          	mov    %ax,0x2(%edx)
  80021d:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800220:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800223:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  800226:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800229:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800230:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800233:	01 c2                	add    %eax,%edx
  800235:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800238:	88 02                	mov    %al,(%edx)
  80023a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80023d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800244:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800247:	01 c2                	add    %eax,%edx
  800249:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
  80024d:	66 89 42 02          	mov    %ax,0x2(%edx)
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80025b:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80025e:	01 c2                	add    %eax,%edx
  800260:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800263:	89 42 04             	mov    %eax,0x4(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800266:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800269:	8a 00                	mov    (%eax),%al
  80026b:	3a 45 e7             	cmp    -0x19(%ebp),%al
  80026e:	75 0f                	jne    80027f <_main+0x247>
  800270:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800273:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800276:	01 d0                	add    %edx,%eax
  800278:	8a 00                	mov    (%eax),%al
  80027a:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80027d:	74 14                	je     800293 <_main+0x25b>
  80027f:	83 ec 04             	sub    $0x4,%esp
  800282:	68 50 35 80 00       	push   $0x803550
  800287:	6a 45                	push   $0x45
  800289:	68 3c 35 80 00       	push   $0x80353c
  80028e:	e8 5f 02 00 00       	call   8004f2 <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800293:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800296:	66 8b 00             	mov    (%eax),%ax
  800299:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80029d:	75 15                	jne    8002b4 <_main+0x27c>
  80029f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8002a2:	01 c0                	add    %eax,%eax
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8002a9:	01 d0                	add    %edx,%eax
  8002ab:	66 8b 00             	mov    (%eax),%ax
  8002ae:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  8002b2:	74 14                	je     8002c8 <_main+0x290>
  8002b4:	83 ec 04             	sub    $0x4,%esp
  8002b7:	68 50 35 80 00       	push   $0x803550
  8002bc:	6a 46                	push   $0x46
  8002be:	68 3c 35 80 00       	push   $0x80353c
  8002c3:	e8 2a 02 00 00       	call   8004f2 <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8002c8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002cb:	8b 00                	mov    (%eax),%eax
  8002cd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002d0:	75 16                	jne    8002e8 <_main+0x2b0>
  8002d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8002d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002dc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8002df:	01 d0                	add    %edx,%eax
  8002e1:	8b 00                	mov    (%eax),%eax
  8002e3:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 50 35 80 00       	push   $0x803550
  8002f0:	6a 47                	push   $0x47
  8002f2:	68 3c 35 80 00       	push   $0x80353c
  8002f7:	e8 f6 01 00 00       	call   8004f2 <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  8002fc:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8002ff:	8a 00                	mov    (%eax),%al
  800301:	3a 45 e7             	cmp    -0x19(%ebp),%al
  800304:	75 16                	jne    80031c <_main+0x2e4>
  800306:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800309:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800310:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	8a 00                	mov    (%eax),%al
  800317:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  80031a:	74 14                	je     800330 <_main+0x2f8>
  80031c:	83 ec 04             	sub    $0x4,%esp
  80031f:	68 50 35 80 00       	push   $0x803550
  800324:	6a 49                	push   $0x49
  800326:	68 3c 35 80 00       	push   $0x80353c
  80032b:	e8 c2 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  800330:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800333:	66 8b 40 02          	mov    0x2(%eax),%ax
  800337:	66 3b 45 e4          	cmp    -0x1c(%ebp),%ax
  80033b:	75 19                	jne    800356 <_main+0x31e>
  80033d:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800340:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800347:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034a:	01 d0                	add    %edx,%eax
  80034c:	66 8b 40 02          	mov    0x2(%eax),%ax
  800350:	66 3b 45 e2          	cmp    -0x1e(%ebp),%ax
  800354:	74 14                	je     80036a <_main+0x332>
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	68 50 35 80 00       	push   $0x803550
  80035e:	6a 4a                	push   $0x4a
  800360:	68 3c 35 80 00       	push   $0x80353c
  800365:	e8 88 01 00 00       	call   8004f2 <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  80036a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80036d:	8b 40 04             	mov    0x4(%eax),%eax
  800370:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800373:	75 17                	jne    80038c <_main+0x354>
  800375:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800378:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80037f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800382:	01 d0                	add    %edx,%eax
  800384:	8b 40 04             	mov    0x4(%eax),%eax
  800387:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80038a:	74 14                	je     8003a0 <_main+0x368>
  80038c:	83 ec 04             	sub    $0x4,%esp
  80038f:	68 50 35 80 00       	push   $0x803550
  800394:	6a 4b                	push   $0x4b
  800396:	68 3c 35 80 00       	push   $0x80353c
  80039b:	e8 52 01 00 00       	call   8004f2 <_panic>


	}

	cprintf("Congratulations!! test malloc (2) completed successfully.\n");
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	68 88 35 80 00       	push   $0x803588
  8003a8:	e8 f9 03 00 00       	call   8007a6 <cprintf>
  8003ad:	83 c4 10             	add    $0x10,%esp

	return;
  8003b0:	90                   	nop
}
  8003b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b4:	c9                   	leave  
  8003b5:	c3                   	ret    

008003b6 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003b6:	55                   	push   %ebp
  8003b7:	89 e5                	mov    %esp,%ebp
  8003b9:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003bc:	e8 02 1b 00 00       	call   801ec3 <sys_getenvindex>
  8003c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003c7:	89 d0                	mov    %edx,%eax
  8003c9:	c1 e0 03             	shl    $0x3,%eax
  8003cc:	01 d0                	add    %edx,%eax
  8003ce:	01 c0                	add    %eax,%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003d9:	01 d0                	add    %edx,%eax
  8003db:	c1 e0 04             	shl    $0x4,%eax
  8003de:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003e3:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003e8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ed:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003f3:	84 c0                	test   %al,%al
  8003f5:	74 0f                	je     800406 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fc:	05 5c 05 00 00       	add    $0x55c,%eax
  800401:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800406:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80040a:	7e 0a                	jle    800416 <libmain+0x60>
		binaryname = argv[0];
  80040c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040f:	8b 00                	mov    (%eax),%eax
  800411:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	ff 75 0c             	pushl  0xc(%ebp)
  80041c:	ff 75 08             	pushl  0x8(%ebp)
  80041f:	e8 14 fc ff ff       	call   800038 <_main>
  800424:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800427:	e8 a4 18 00 00       	call   801cd0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80042c:	83 ec 0c             	sub    $0xc,%esp
  80042f:	68 dc 35 80 00       	push   $0x8035dc
  800434:	e8 6d 03 00 00       	call   8007a6 <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800447:	a1 20 40 80 00       	mov    0x804020,%eax
  80044c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	52                   	push   %edx
  800456:	50                   	push   %eax
  800457:	68 04 36 80 00       	push   $0x803604
  80045c:	e8 45 03 00 00       	call   8007a6 <cprintf>
  800461:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800464:	a1 20 40 80 00       	mov    0x804020,%eax
  800469:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80047a:	a1 20 40 80 00       	mov    0x804020,%eax
  80047f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800485:	51                   	push   %ecx
  800486:	52                   	push   %edx
  800487:	50                   	push   %eax
  800488:	68 2c 36 80 00       	push   $0x80362c
  80048d:	e8 14 03 00 00       	call   8007a6 <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800495:	a1 20 40 80 00       	mov    0x804020,%eax
  80049a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004a0:	83 ec 08             	sub    $0x8,%esp
  8004a3:	50                   	push   %eax
  8004a4:	68 84 36 80 00       	push   $0x803684
  8004a9:	e8 f8 02 00 00       	call   8007a6 <cprintf>
  8004ae:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004b1:	83 ec 0c             	sub    $0xc,%esp
  8004b4:	68 dc 35 80 00       	push   $0x8035dc
  8004b9:	e8 e8 02 00 00       	call   8007a6 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004c1:	e8 24 18 00 00       	call   801cea <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004c6:	e8 19 00 00 00       	call   8004e4 <exit>
}
  8004cb:	90                   	nop
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004d4:	83 ec 0c             	sub    $0xc,%esp
  8004d7:	6a 00                	push   $0x0
  8004d9:	e8 b1 19 00 00       	call   801e8f <sys_destroy_env>
  8004de:	83 c4 10             	add    $0x10,%esp
}
  8004e1:	90                   	nop
  8004e2:	c9                   	leave  
  8004e3:	c3                   	ret    

008004e4 <exit>:

void
exit(void)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ea:	e8 06 1a 00 00       	call   801ef5 <sys_exit_env>
}
  8004ef:	90                   	nop
  8004f0:	c9                   	leave  
  8004f1:	c3                   	ret    

008004f2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004f2:	55                   	push   %ebp
  8004f3:	89 e5                	mov    %esp,%ebp
  8004f5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004f8:	8d 45 10             	lea    0x10(%ebp),%eax
  8004fb:	83 c0 04             	add    $0x4,%eax
  8004fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800501:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	74 16                	je     800520 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80050a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80050f:	83 ec 08             	sub    $0x8,%esp
  800512:	50                   	push   %eax
  800513:	68 98 36 80 00       	push   $0x803698
  800518:	e8 89 02 00 00       	call   8007a6 <cprintf>
  80051d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800520:	a1 00 40 80 00       	mov    0x804000,%eax
  800525:	ff 75 0c             	pushl  0xc(%ebp)
  800528:	ff 75 08             	pushl  0x8(%ebp)
  80052b:	50                   	push   %eax
  80052c:	68 9d 36 80 00       	push   $0x80369d
  800531:	e8 70 02 00 00       	call   8007a6 <cprintf>
  800536:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800539:	8b 45 10             	mov    0x10(%ebp),%eax
  80053c:	83 ec 08             	sub    $0x8,%esp
  80053f:	ff 75 f4             	pushl  -0xc(%ebp)
  800542:	50                   	push   %eax
  800543:	e8 f3 01 00 00       	call   80073b <vcprintf>
  800548:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	6a 00                	push   $0x0
  800550:	68 b9 36 80 00       	push   $0x8036b9
  800555:	e8 e1 01 00 00       	call   80073b <vcprintf>
  80055a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80055d:	e8 82 ff ff ff       	call   8004e4 <exit>

	// should not return here
	while (1) ;
  800562:	eb fe                	jmp    800562 <_panic+0x70>

00800564 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800564:	55                   	push   %ebp
  800565:	89 e5                	mov    %esp,%ebp
  800567:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80056a:	a1 20 40 80 00       	mov    0x804020,%eax
  80056f:	8b 50 74             	mov    0x74(%eax),%edx
  800572:	8b 45 0c             	mov    0xc(%ebp),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	74 14                	je     80058d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800579:	83 ec 04             	sub    $0x4,%esp
  80057c:	68 bc 36 80 00       	push   $0x8036bc
  800581:	6a 26                	push   $0x26
  800583:	68 08 37 80 00       	push   $0x803708
  800588:	e8 65 ff ff ff       	call   8004f2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80058d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80059b:	e9 c2 00 00 00       	jmp    800662 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8b 00                	mov    (%eax),%eax
  8005b1:	85 c0                	test   %eax,%eax
  8005b3:	75 08                	jne    8005bd <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005b5:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005b8:	e9 a2 00 00 00       	jmp    80065f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005c4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005cb:	eb 69                	jmp    800636 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005d8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005db:	89 d0                	mov    %edx,%eax
  8005dd:	01 c0                	add    %eax,%eax
  8005df:	01 d0                	add    %edx,%eax
  8005e1:	c1 e0 03             	shl    $0x3,%eax
  8005e4:	01 c8                	add    %ecx,%eax
  8005e6:	8a 40 04             	mov    0x4(%eax),%al
  8005e9:	84 c0                	test   %al,%al
  8005eb:	75 46                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8005f2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005f8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	01 c0                	add    %eax,%eax
  8005ff:	01 d0                	add    %edx,%eax
  800601:	c1 e0 03             	shl    $0x3,%eax
  800604:	01 c8                	add    %ecx,%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80060b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800613:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800618:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80061f:	8b 45 08             	mov    0x8(%ebp),%eax
  800622:	01 c8                	add    %ecx,%eax
  800624:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800626:	39 c2                	cmp    %eax,%edx
  800628:	75 09                	jne    800633 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80062a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800631:	eb 12                	jmp    800645 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800633:	ff 45 e8             	incl   -0x18(%ebp)
  800636:	a1 20 40 80 00       	mov    0x804020,%eax
  80063b:	8b 50 74             	mov    0x74(%eax),%edx
  80063e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800641:	39 c2                	cmp    %eax,%edx
  800643:	77 88                	ja     8005cd <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800645:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800649:	75 14                	jne    80065f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80064b:	83 ec 04             	sub    $0x4,%esp
  80064e:	68 14 37 80 00       	push   $0x803714
  800653:	6a 3a                	push   $0x3a
  800655:	68 08 37 80 00       	push   $0x803708
  80065a:	e8 93 fe ff ff       	call   8004f2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80065f:	ff 45 f0             	incl   -0x10(%ebp)
  800662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800665:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800668:	0f 8c 32 ff ff ff    	jl     8005a0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800675:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80067c:	eb 26                	jmp    8006a4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80067e:	a1 20 40 80 00       	mov    0x804020,%eax
  800683:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800689:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80068c:	89 d0                	mov    %edx,%eax
  80068e:	01 c0                	add    %eax,%eax
  800690:	01 d0                	add    %edx,%eax
  800692:	c1 e0 03             	shl    $0x3,%eax
  800695:	01 c8                	add    %ecx,%eax
  800697:	8a 40 04             	mov    0x4(%eax),%al
  80069a:	3c 01                	cmp    $0x1,%al
  80069c:	75 03                	jne    8006a1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80069e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a1:	ff 45 e0             	incl   -0x20(%ebp)
  8006a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8006a9:	8b 50 74             	mov    0x74(%eax),%edx
  8006ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006af:	39 c2                	cmp    %eax,%edx
  8006b1:	77 cb                	ja     80067e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006b6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006b9:	74 14                	je     8006cf <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006bb:	83 ec 04             	sub    $0x4,%esp
  8006be:	68 68 37 80 00       	push   $0x803768
  8006c3:	6a 44                	push   $0x44
  8006c5:	68 08 37 80 00       	push   $0x803708
  8006ca:	e8 23 fe ff ff       	call   8004f2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006cf:	90                   	nop
  8006d0:	c9                   	leave  
  8006d1:	c3                   	ret    

008006d2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006d2:	55                   	push   %ebp
  8006d3:	89 e5                	mov    %esp,%ebp
  8006d5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	8d 48 01             	lea    0x1(%eax),%ecx
  8006e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e3:	89 0a                	mov    %ecx,(%edx)
  8006e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8006e8:	88 d1                	mov    %dl,%cl
  8006ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ed:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006fb:	75 2c                	jne    800729 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006fd:	a0 24 40 80 00       	mov    0x804024,%al
  800702:	0f b6 c0             	movzbl %al,%eax
  800705:	8b 55 0c             	mov    0xc(%ebp),%edx
  800708:	8b 12                	mov    (%edx),%edx
  80070a:	89 d1                	mov    %edx,%ecx
  80070c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070f:	83 c2 08             	add    $0x8,%edx
  800712:	83 ec 04             	sub    $0x4,%esp
  800715:	50                   	push   %eax
  800716:	51                   	push   %ecx
  800717:	52                   	push   %edx
  800718:	e8 05 14 00 00       	call   801b22 <sys_cputs>
  80071d:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800720:	8b 45 0c             	mov    0xc(%ebp),%eax
  800723:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072c:	8b 40 04             	mov    0x4(%eax),%eax
  80072f:	8d 50 01             	lea    0x1(%eax),%edx
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 50 04             	mov    %edx,0x4(%eax)
}
  800738:	90                   	nop
  800739:	c9                   	leave  
  80073a:	c3                   	ret    

0080073b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80073b:	55                   	push   %ebp
  80073c:	89 e5                	mov    %esp,%ebp
  80073e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800744:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80074b:	00 00 00 
	b.cnt = 0;
  80074e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800755:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800758:	ff 75 0c             	pushl  0xc(%ebp)
  80075b:	ff 75 08             	pushl  0x8(%ebp)
  80075e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800764:	50                   	push   %eax
  800765:	68 d2 06 80 00       	push   $0x8006d2
  80076a:	e8 11 02 00 00       	call   800980 <vprintfmt>
  80076f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800772:	a0 24 40 80 00       	mov    0x804024,%al
  800777:	0f b6 c0             	movzbl %al,%eax
  80077a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800780:	83 ec 04             	sub    $0x4,%esp
  800783:	50                   	push   %eax
  800784:	52                   	push   %edx
  800785:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80078b:	83 c0 08             	add    $0x8,%eax
  80078e:	50                   	push   %eax
  80078f:	e8 8e 13 00 00       	call   801b22 <sys_cputs>
  800794:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800797:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80079e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007a4:	c9                   	leave  
  8007a5:	c3                   	ret    

008007a6 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007a6:	55                   	push   %ebp
  8007a7:	89 e5                	mov    %esp,%ebp
  8007a9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007ac:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8007b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bc:	83 ec 08             	sub    $0x8,%esp
  8007bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8007c2:	50                   	push   %eax
  8007c3:	e8 73 ff ff ff       	call   80073b <vcprintf>
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007d9:	e8 f2 14 00 00       	call   801cd0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007de:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	83 ec 08             	sub    $0x8,%esp
  8007ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	e8 48 ff ff ff       	call   80073b <vcprintf>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007f9:	e8 ec 14 00 00       	call   801cea <sys_enable_interrupt>
	return cnt;
  8007fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800801:	c9                   	leave  
  800802:	c3                   	ret    

00800803 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 14             	sub    $0x14,%esp
  80080a:	8b 45 10             	mov    0x10(%ebp),%eax
  80080d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800816:	8b 45 18             	mov    0x18(%ebp),%eax
  800819:	ba 00 00 00 00       	mov    $0x0,%edx
  80081e:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800821:	77 55                	ja     800878 <printnum+0x75>
  800823:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800826:	72 05                	jb     80082d <printnum+0x2a>
  800828:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80082b:	77 4b                	ja     800878 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80082d:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800830:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800833:	8b 45 18             	mov    0x18(%ebp),%eax
  800836:	ba 00 00 00 00       	mov    $0x0,%edx
  80083b:	52                   	push   %edx
  80083c:	50                   	push   %eax
  80083d:	ff 75 f4             	pushl  -0xc(%ebp)
  800840:	ff 75 f0             	pushl  -0x10(%ebp)
  800843:	e8 64 2a 00 00       	call   8032ac <__udivdi3>
  800848:	83 c4 10             	add    $0x10,%esp
  80084b:	83 ec 04             	sub    $0x4,%esp
  80084e:	ff 75 20             	pushl  0x20(%ebp)
  800851:	53                   	push   %ebx
  800852:	ff 75 18             	pushl  0x18(%ebp)
  800855:	52                   	push   %edx
  800856:	50                   	push   %eax
  800857:	ff 75 0c             	pushl  0xc(%ebp)
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 a1 ff ff ff       	call   800803 <printnum>
  800862:	83 c4 20             	add    $0x20,%esp
  800865:	eb 1a                	jmp    800881 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800867:	83 ec 08             	sub    $0x8,%esp
  80086a:	ff 75 0c             	pushl  0xc(%ebp)
  80086d:	ff 75 20             	pushl  0x20(%ebp)
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	ff d0                	call   *%eax
  800875:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800878:	ff 4d 1c             	decl   0x1c(%ebp)
  80087b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80087f:	7f e6                	jg     800867 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800881:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800884:	bb 00 00 00 00       	mov    $0x0,%ebx
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	53                   	push   %ebx
  800890:	51                   	push   %ecx
  800891:	52                   	push   %edx
  800892:	50                   	push   %eax
  800893:	e8 24 2b 00 00       	call   8033bc <__umoddi3>
  800898:	83 c4 10             	add    $0x10,%esp
  80089b:	05 d4 39 80 00       	add    $0x8039d4,%eax
  8008a0:	8a 00                	mov    (%eax),%al
  8008a2:	0f be c0             	movsbl %al,%eax
  8008a5:	83 ec 08             	sub    $0x8,%esp
  8008a8:	ff 75 0c             	pushl  0xc(%ebp)
  8008ab:	50                   	push   %eax
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	ff d0                	call   *%eax
  8008b1:	83 c4 10             	add    $0x10,%esp
}
  8008b4:	90                   	nop
  8008b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b8:	c9                   	leave  
  8008b9:	c3                   	ret    

008008ba <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008ba:	55                   	push   %ebp
  8008bb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008c1:	7e 1c                	jle    8008df <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c6:	8b 00                	mov    (%eax),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ce:	89 10                	mov    %edx,(%eax)
  8008d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d3:	8b 00                	mov    (%eax),%eax
  8008d5:	83 e8 08             	sub    $0x8,%eax
  8008d8:	8b 50 04             	mov    0x4(%eax),%edx
  8008db:	8b 00                	mov    (%eax),%eax
  8008dd:	eb 40                	jmp    80091f <getuint+0x65>
	else if (lflag)
  8008df:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008e3:	74 1e                	je     800903 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	8b 00                	mov    (%eax),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	89 10                	mov    %edx,(%eax)
  8008f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 00                	mov    (%eax),%eax
  8008fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800901:	eb 1c                	jmp    80091f <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800903:	8b 45 08             	mov    0x8(%ebp),%eax
  800906:	8b 00                	mov    (%eax),%eax
  800908:	8d 50 04             	lea    0x4(%eax),%edx
  80090b:	8b 45 08             	mov    0x8(%ebp),%eax
  80090e:	89 10                	mov    %edx,(%eax)
  800910:	8b 45 08             	mov    0x8(%ebp),%eax
  800913:	8b 00                	mov    (%eax),%eax
  800915:	83 e8 04             	sub    $0x4,%eax
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800924:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800928:	7e 1c                	jle    800946 <getint+0x25>
		return va_arg(*ap, long long);
  80092a:	8b 45 08             	mov    0x8(%ebp),%eax
  80092d:	8b 00                	mov    (%eax),%eax
  80092f:	8d 50 08             	lea    0x8(%eax),%edx
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	89 10                	mov    %edx,(%eax)
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 00                	mov    (%eax),%eax
  80093c:	83 e8 08             	sub    $0x8,%eax
  80093f:	8b 50 04             	mov    0x4(%eax),%edx
  800942:	8b 00                	mov    (%eax),%eax
  800944:	eb 38                	jmp    80097e <getint+0x5d>
	else if (lflag)
  800946:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80094a:	74 1a                	je     800966 <getint+0x45>
		return va_arg(*ap, long);
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 00                	mov    (%eax),%eax
  800951:	8d 50 04             	lea    0x4(%eax),%edx
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 10                	mov    %edx,(%eax)
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 00                	mov    (%eax),%eax
  80095e:	83 e8 04             	sub    $0x4,%eax
  800961:	8b 00                	mov    (%eax),%eax
  800963:	99                   	cltd   
  800964:	eb 18                	jmp    80097e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800966:	8b 45 08             	mov    0x8(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 50 04             	lea    0x4(%eax),%edx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	89 10                	mov    %edx,(%eax)
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	8b 00                	mov    (%eax),%eax
  800978:	83 e8 04             	sub    $0x4,%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	99                   	cltd   
}
  80097e:	5d                   	pop    %ebp
  80097f:	c3                   	ret    

00800980 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800988:	eb 17                	jmp    8009a1 <vprintfmt+0x21>
			if (ch == '\0')
  80098a:	85 db                	test   %ebx,%ebx
  80098c:	0f 84 af 03 00 00    	je     800d41 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800992:	83 ec 08             	sub    $0x8,%esp
  800995:	ff 75 0c             	pushl  0xc(%ebp)
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	ff d0                	call   *%eax
  80099e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009a4:	8d 50 01             	lea    0x1(%eax),%edx
  8009a7:	89 55 10             	mov    %edx,0x10(%ebp)
  8009aa:	8a 00                	mov    (%eax),%al
  8009ac:	0f b6 d8             	movzbl %al,%ebx
  8009af:	83 fb 25             	cmp    $0x25,%ebx
  8009b2:	75 d6                	jne    80098a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009bf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009cd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d7:	8d 50 01             	lea    0x1(%eax),%edx
  8009da:	89 55 10             	mov    %edx,0x10(%ebp)
  8009dd:	8a 00                	mov    (%eax),%al
  8009df:	0f b6 d8             	movzbl %al,%ebx
  8009e2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009e5:	83 f8 55             	cmp    $0x55,%eax
  8009e8:	0f 87 2b 03 00 00    	ja     800d19 <vprintfmt+0x399>
  8009ee:	8b 04 85 f8 39 80 00 	mov    0x8039f8(,%eax,4),%eax
  8009f5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009f7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009fb:	eb d7                	jmp    8009d4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009fd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a01:	eb d1                	jmp    8009d4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a03:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a0a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a0d:	89 d0                	mov    %edx,%eax
  800a0f:	c1 e0 02             	shl    $0x2,%eax
  800a12:	01 d0                	add    %edx,%eax
  800a14:	01 c0                	add    %eax,%eax
  800a16:	01 d8                	add    %ebx,%eax
  800a18:	83 e8 30             	sub    $0x30,%eax
  800a1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a21:	8a 00                	mov    (%eax),%al
  800a23:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a26:	83 fb 2f             	cmp    $0x2f,%ebx
  800a29:	7e 3e                	jle    800a69 <vprintfmt+0xe9>
  800a2b:	83 fb 39             	cmp    $0x39,%ebx
  800a2e:	7f 39                	jg     800a69 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a30:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a33:	eb d5                	jmp    800a0a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a49:	eb 1f                	jmp    800a6a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a4b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4f:	79 83                	jns    8009d4 <vprintfmt+0x54>
				width = 0;
  800a51:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a58:	e9 77 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a5d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a64:	e9 6b ff ff ff       	jmp    8009d4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a69:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a6a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6e:	0f 89 60 ff ff ff    	jns    8009d4 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a74:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a7a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a81:	e9 4e ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a86:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a89:	e9 46 ff ff ff       	jmp    8009d4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a8e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a91:	83 c0 04             	add    $0x4,%eax
  800a94:	89 45 14             	mov    %eax,0x14(%ebp)
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 e8 04             	sub    $0x4,%eax
  800a9d:	8b 00                	mov    (%eax),%eax
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	50                   	push   %eax
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 89 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ac4:	85 db                	test   %ebx,%ebx
  800ac6:	79 02                	jns    800aca <vprintfmt+0x14a>
				err = -err;
  800ac8:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aca:	83 fb 64             	cmp    $0x64,%ebx
  800acd:	7f 0b                	jg     800ada <vprintfmt+0x15a>
  800acf:	8b 34 9d 40 38 80 00 	mov    0x803840(,%ebx,4),%esi
  800ad6:	85 f6                	test   %esi,%esi
  800ad8:	75 19                	jne    800af3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ada:	53                   	push   %ebx
  800adb:	68 e5 39 80 00       	push   $0x8039e5
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	ff 75 08             	pushl  0x8(%ebp)
  800ae6:	e8 5e 02 00 00       	call   800d49 <printfmt>
  800aeb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aee:	e9 49 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800af3:	56                   	push   %esi
  800af4:	68 ee 39 80 00       	push   $0x8039ee
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	ff 75 08             	pushl  0x8(%ebp)
  800aff:	e8 45 02 00 00       	call   800d49 <printfmt>
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 30 02 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0f:	83 c0 04             	add    $0x4,%eax
  800b12:	89 45 14             	mov    %eax,0x14(%ebp)
  800b15:	8b 45 14             	mov    0x14(%ebp),%eax
  800b18:	83 e8 04             	sub    $0x4,%eax
  800b1b:	8b 30                	mov    (%eax),%esi
  800b1d:	85 f6                	test   %esi,%esi
  800b1f:	75 05                	jne    800b26 <vprintfmt+0x1a6>
				p = "(null)";
  800b21:	be f1 39 80 00       	mov    $0x8039f1,%esi
			if (width > 0 && padc != '-')
  800b26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2a:	7e 6d                	jle    800b99 <vprintfmt+0x219>
  800b2c:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b30:	74 67                	je     800b99 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b35:	83 ec 08             	sub    $0x8,%esp
  800b38:	50                   	push   %eax
  800b39:	56                   	push   %esi
  800b3a:	e8 0c 03 00 00       	call   800e4b <strnlen>
  800b3f:	83 c4 10             	add    $0x10,%esp
  800b42:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b45:	eb 16                	jmp    800b5d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b47:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	50                   	push   %eax
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b61:	7f e4                	jg     800b47 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b63:	eb 34                	jmp    800b99 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b65:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b69:	74 1c                	je     800b87 <vprintfmt+0x207>
  800b6b:	83 fb 1f             	cmp    $0x1f,%ebx
  800b6e:	7e 05                	jle    800b75 <vprintfmt+0x1f5>
  800b70:	83 fb 7e             	cmp    $0x7e,%ebx
  800b73:	7e 12                	jle    800b87 <vprintfmt+0x207>
					putch('?', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 3f                	push   $0x3f
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
  800b85:	eb 0f                	jmp    800b96 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	ff d0                	call   *%eax
  800b93:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b96:	ff 4d e4             	decl   -0x1c(%ebp)
  800b99:	89 f0                	mov    %esi,%eax
  800b9b:	8d 70 01             	lea    0x1(%eax),%esi
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f be d8             	movsbl %al,%ebx
  800ba3:	85 db                	test   %ebx,%ebx
  800ba5:	74 24                	je     800bcb <vprintfmt+0x24b>
  800ba7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bab:	78 b8                	js     800b65 <vprintfmt+0x1e5>
  800bad:	ff 4d e0             	decl   -0x20(%ebp)
  800bb0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bb4:	79 af                	jns    800b65 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bb6:	eb 13                	jmp    800bcb <vprintfmt+0x24b>
				putch(' ', putdat);
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	ff 75 0c             	pushl  0xc(%ebp)
  800bbe:	6a 20                	push   $0x20
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	ff d0                	call   *%eax
  800bc5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bc8:	ff 4d e4             	decl   -0x1c(%ebp)
  800bcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bcf:	7f e7                	jg     800bb8 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bd1:	e9 66 01 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bd6:	83 ec 08             	sub    $0x8,%esp
  800bd9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bdc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bdf:	50                   	push   %eax
  800be0:	e8 3c fd ff ff       	call   800921 <getint>
  800be5:	83 c4 10             	add    $0x10,%esp
  800be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800beb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf4:	85 d2                	test   %edx,%edx
  800bf6:	79 23                	jns    800c1b <vprintfmt+0x29b>
				putch('-', putdat);
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	ff 75 0c             	pushl  0xc(%ebp)
  800bfe:	6a 2d                	push   $0x2d
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	f7 d8                	neg    %eax
  800c10:	83 d2 00             	adc    $0x0,%edx
  800c13:	f7 da                	neg    %edx
  800c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 e8             	pushl  -0x18(%ebp)
  800c2d:	8d 45 14             	lea    0x14(%ebp),%eax
  800c30:	50                   	push   %eax
  800c31:	e8 84 fc ff ff       	call   8008ba <getuint>
  800c36:	83 c4 10             	add    $0x10,%esp
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c3f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c46:	e9 98 00 00 00       	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	ff 75 0c             	pushl  0xc(%ebp)
  800c51:	6a 58                	push   $0x58
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
  800c56:	ff d0                	call   *%eax
  800c58:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	ff 75 0c             	pushl  0xc(%ebp)
  800c61:	6a 58                	push   $0x58
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	ff d0                	call   *%eax
  800c68:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	6a 58                	push   $0x58
  800c73:	8b 45 08             	mov    0x8(%ebp),%eax
  800c76:	ff d0                	call   *%eax
  800c78:	83 c4 10             	add    $0x10,%esp
			break;
  800c7b:	e9 bc 00 00 00       	jmp    800d3c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c80:	83 ec 08             	sub    $0x8,%esp
  800c83:	ff 75 0c             	pushl  0xc(%ebp)
  800c86:	6a 30                	push   $0x30
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	ff d0                	call   *%eax
  800c8d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c90:	83 ec 08             	sub    $0x8,%esp
  800c93:	ff 75 0c             	pushl  0xc(%ebp)
  800c96:	6a 78                	push   $0x78
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	ff d0                	call   *%eax
  800c9d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cbb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cc2:	eb 1f                	jmp    800ce3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cc4:	83 ec 08             	sub    $0x8,%esp
  800cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cca:	8d 45 14             	lea    0x14(%ebp),%eax
  800ccd:	50                   	push   %eax
  800cce:	e8 e7 fb ff ff       	call   8008ba <getuint>
  800cd3:	83 c4 10             	add    $0x10,%esp
  800cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cdc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ce3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cea:	83 ec 04             	sub    $0x4,%esp
  800ced:	52                   	push   %edx
  800cee:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cf1:	50                   	push   %eax
  800cf2:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf5:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf8:	ff 75 0c             	pushl  0xc(%ebp)
  800cfb:	ff 75 08             	pushl  0x8(%ebp)
  800cfe:	e8 00 fb ff ff       	call   800803 <printnum>
  800d03:	83 c4 20             	add    $0x20,%esp
			break;
  800d06:	eb 34                	jmp    800d3c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	53                   	push   %ebx
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	ff d0                	call   *%eax
  800d14:	83 c4 10             	add    $0x10,%esp
			break;
  800d17:	eb 23                	jmp    800d3c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d19:	83 ec 08             	sub    $0x8,%esp
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	6a 25                	push   $0x25
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	ff d0                	call   *%eax
  800d26:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	ff 4d 10             	decl   0x10(%ebp)
  800d2c:	eb 03                	jmp    800d31 <vprintfmt+0x3b1>
  800d2e:	ff 4d 10             	decl   0x10(%ebp)
  800d31:	8b 45 10             	mov    0x10(%ebp),%eax
  800d34:	48                   	dec    %eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	3c 25                	cmp    $0x25,%al
  800d39:	75 f3                	jne    800d2e <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d3b:	90                   	nop
		}
	}
  800d3c:	e9 47 fc ff ff       	jmp    800988 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d41:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d45:	5b                   	pop    %ebx
  800d46:	5e                   	pop    %esi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d4f:	8d 45 10             	lea    0x10(%ebp),%eax
  800d52:	83 c0 04             	add    $0x4,%eax
  800d55:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d58:	8b 45 10             	mov    0x10(%ebp),%eax
  800d5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800d5e:	50                   	push   %eax
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	ff 75 08             	pushl  0x8(%ebp)
  800d65:	e8 16 fc ff ff       	call   800980 <vprintfmt>
  800d6a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d6d:	90                   	nop
  800d6e:	c9                   	leave  
  800d6f:	c3                   	ret    

00800d70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8b 40 08             	mov    0x8(%eax),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d85:	8b 10                	mov    (%eax),%edx
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 40 04             	mov    0x4(%eax),%eax
  800d8d:	39 c2                	cmp    %eax,%edx
  800d8f:	73 12                	jae    800da3 <sprintputch+0x33>
		*b->buf++ = ch;
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8b 00                	mov    (%eax),%eax
  800d96:	8d 48 01             	lea    0x1(%eax),%ecx
  800d99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9c:	89 0a                	mov    %ecx,(%edx)
  800d9e:	8b 55 08             	mov    0x8(%ebp),%edx
  800da1:	88 10                	mov    %dl,(%eax)
}
  800da3:	90                   	nop
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    

00800da6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800db2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	01 d0                	add    %edx,%eax
  800dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dcb:	74 06                	je     800dd3 <vsnprintf+0x2d>
  800dcd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd1:	7f 07                	jg     800dda <vsnprintf+0x34>
		return -E_INVAL;
  800dd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800dd8:	eb 20                	jmp    800dfa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dda:	ff 75 14             	pushl  0x14(%ebp)
  800ddd:	ff 75 10             	pushl  0x10(%ebp)
  800de0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800de3:	50                   	push   %eax
  800de4:	68 70 0d 80 00       	push   $0x800d70
  800de9:	e8 92 fb ff ff       	call   800980 <vprintfmt>
  800dee:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800df4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dfa:	c9                   	leave  
  800dfb:	c3                   	ret    

00800dfc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e02:	8d 45 10             	lea    0x10(%ebp),%eax
  800e05:	83 c0 04             	add    $0x4,%eax
  800e08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e11:	50                   	push   %eax
  800e12:	ff 75 0c             	pushl  0xc(%ebp)
  800e15:	ff 75 08             	pushl  0x8(%ebp)
  800e18:	e8 89 ff ff ff       	call   800da6 <vsnprintf>
  800e1d:	83 c4 10             	add    $0x10,%esp
  800e20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e35:	eb 06                	jmp    800e3d <strlen+0x15>
		n++;
  800e37:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e3a:	ff 45 08             	incl   0x8(%ebp)
  800e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e40:	8a 00                	mov    (%eax),%al
  800e42:	84 c0                	test   %al,%al
  800e44:	75 f1                	jne    800e37 <strlen+0xf>
		n++;
	return n;
  800e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e49:	c9                   	leave  
  800e4a:	c3                   	ret    

00800e4b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e58:	eb 09                	jmp    800e63 <strnlen+0x18>
		n++;
  800e5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e5d:	ff 45 08             	incl   0x8(%ebp)
  800e60:	ff 4d 0c             	decl   0xc(%ebp)
  800e63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e67:	74 09                	je     800e72 <strnlen+0x27>
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 e8                	jne    800e5a <strnlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e83:	90                   	nop
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e90:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e93:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e96:	8a 12                	mov    (%edx),%dl
  800e98:	88 10                	mov    %dl,(%eax)
  800e9a:	8a 00                	mov    (%eax),%al
  800e9c:	84 c0                	test   %al,%al
  800e9e:	75 e4                	jne    800e84 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800eb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb8:	eb 1f                	jmp    800ed9 <strncpy+0x34>
		*dst++ = *src;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8d 50 01             	lea    0x1(%eax),%edx
  800ec0:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec6:	8a 12                	mov    (%edx),%dl
  800ec8:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	84 c0                	test   %al,%al
  800ed1:	74 03                	je     800ed6 <strncpy+0x31>
			src++;
  800ed3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ed6:	ff 45 fc             	incl   -0x4(%ebp)
  800ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800edc:	3b 45 10             	cmp    0x10(%ebp),%eax
  800edf:	72 d9                	jb     800eba <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ee1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ef2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ef6:	74 30                	je     800f28 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ef8:	eb 16                	jmp    800f10 <strlcpy+0x2a>
			*dst++ = *src++;
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8d 50 01             	lea    0x1(%eax),%edx
  800f00:	89 55 08             	mov    %edx,0x8(%ebp)
  800f03:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f06:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f09:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f0c:	8a 12                	mov    (%edx),%dl
  800f0e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f10:	ff 4d 10             	decl   0x10(%ebp)
  800f13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f17:	74 09                	je     800f22 <strlcpy+0x3c>
  800f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1c:	8a 00                	mov    (%eax),%al
  800f1e:	84 c0                	test   %al,%al
  800f20:	75 d8                	jne    800efa <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f22:	8b 45 08             	mov    0x8(%ebp),%eax
  800f25:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f28:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2e:	29 c2                	sub    %eax,%edx
  800f30:	89 d0                	mov    %edx,%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f37:	eb 06                	jmp    800f3f <strcmp+0xb>
		p++, q++;
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	84 c0                	test   %al,%al
  800f46:	74 0e                	je     800f56 <strcmp+0x22>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 10                	mov    (%eax),%dl
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	38 c2                	cmp    %al,%dl
  800f54:	74 e3                	je     800f39 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	0f b6 d0             	movzbl %al,%edx
  800f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	0f b6 c0             	movzbl %al,%eax
  800f66:	29 c2                	sub    %eax,%edx
  800f68:	89 d0                	mov    %edx,%eax
}
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f6f:	eb 09                	jmp    800f7a <strncmp+0xe>
		n--, p++, q++;
  800f71:	ff 4d 10             	decl   0x10(%ebp)
  800f74:	ff 45 08             	incl   0x8(%ebp)
  800f77:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7e:	74 17                	je     800f97 <strncmp+0x2b>
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	84 c0                	test   %al,%al
  800f87:	74 0e                	je     800f97 <strncmp+0x2b>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 10                	mov    (%eax),%dl
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	8a 00                	mov    (%eax),%al
  800f93:	38 c2                	cmp    %al,%dl
  800f95:	74 da                	je     800f71 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f97:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9b:	75 07                	jne    800fa4 <strncmp+0x38>
		return 0;
  800f9d:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa2:	eb 14                	jmp    800fb8 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 d0             	movzbl %al,%edx
  800fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	29 c2                	sub    %eax,%edx
  800fb6:	89 d0                	mov    %edx,%eax
}
  800fb8:	5d                   	pop    %ebp
  800fb9:	c3                   	ret    

00800fba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fba:	55                   	push   %ebp
  800fbb:	89 e5                	mov    %esp,%ebp
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fc6:	eb 12                	jmp    800fda <strchr+0x20>
		if (*s == c)
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	8a 00                	mov    (%eax),%al
  800fcd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fd0:	75 05                	jne    800fd7 <strchr+0x1d>
			return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	eb 11                	jmp    800fe8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fd7:	ff 45 08             	incl   0x8(%ebp)
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	84 c0                	test   %al,%al
  800fe1:	75 e5                	jne    800fc8 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe8:	c9                   	leave  
  800fe9:	c3                   	ret    

00800fea <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fea:	55                   	push   %ebp
  800feb:	89 e5                	mov    %esp,%ebp
  800fed:	83 ec 04             	sub    $0x4,%esp
  800ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff6:	eb 0d                	jmp    801005 <strfind+0x1b>
		if (*s == c)
  800ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffb:	8a 00                	mov    (%eax),%al
  800ffd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801000:	74 0e                	je     801010 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801002:	ff 45 08             	incl   0x8(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	84 c0                	test   %al,%al
  80100c:	75 ea                	jne    800ff8 <strfind+0xe>
  80100e:	eb 01                	jmp    801011 <strfind+0x27>
		if (*s == c)
			break;
  801010:	90                   	nop
	return (char *) s;
  801011:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801022:	8b 45 10             	mov    0x10(%ebp),%eax
  801025:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801028:	eb 0e                	jmp    801038 <memset+0x22>
		*p++ = c;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8d 50 01             	lea    0x1(%eax),%edx
  801030:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801033:	8b 55 0c             	mov    0xc(%ebp),%edx
  801036:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801038:	ff 4d f8             	decl   -0x8(%ebp)
  80103b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80103f:	79 e9                	jns    80102a <memset+0x14>
		*p++ = c;

	return v;
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80104c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801052:	8b 45 08             	mov    0x8(%ebp),%eax
  801055:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801058:	eb 16                	jmp    801070 <memcpy+0x2a>
		*d++ = *s++;
  80105a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105d:	8d 50 01             	lea    0x1(%eax),%edx
  801060:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801063:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801066:	8d 4a 01             	lea    0x1(%edx),%ecx
  801069:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80106c:	8a 12                	mov    (%edx),%dl
  80106e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	8d 50 ff             	lea    -0x1(%eax),%edx
  801076:	89 55 10             	mov    %edx,0x10(%ebp)
  801079:	85 c0                	test   %eax,%eax
  80107b:	75 dd                	jne    80105a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801088:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801094:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801097:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109a:	73 50                	jae    8010ec <memmove+0x6a>
  80109c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 d0                	add    %edx,%eax
  8010a4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010a7:	76 43                	jbe    8010ec <memmove+0x6a>
		s += n;
  8010a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ac:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010b5:	eb 10                	jmp    8010c7 <memmove+0x45>
			*--d = *--s;
  8010b7:	ff 4d f8             	decl   -0x8(%ebp)
  8010ba:	ff 4d fc             	decl   -0x4(%ebp)
  8010bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c0:	8a 10                	mov    (%eax),%dl
  8010c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c5:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ca:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010cd:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d0:	85 c0                	test   %eax,%eax
  8010d2:	75 e3                	jne    8010b7 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010d4:	eb 23                	jmp    8010f9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d9:	8d 50 01             	lea    0x1(%eax),%edx
  8010dc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010e8:	8a 12                	mov    (%edx),%dl
  8010ea:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010f5:	85 c0                	test   %eax,%eax
  8010f7:	75 dd                	jne    8010d6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010fc:	c9                   	leave  
  8010fd:	c3                   	ret    

008010fe <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801104:	8b 45 08             	mov    0x8(%ebp),%eax
  801107:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80110a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801110:	eb 2a                	jmp    80113c <memcmp+0x3e>
		if (*s1 != *s2)
  801112:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801115:	8a 10                	mov    (%eax),%dl
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	38 c2                	cmp    %al,%dl
  80111e:	74 16                	je     801136 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801120:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	0f b6 d0             	movzbl %al,%edx
  801128:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	0f b6 c0             	movzbl %al,%eax
  801130:	29 c2                	sub    %eax,%edx
  801132:	89 d0                	mov    %edx,%eax
  801134:	eb 18                	jmp    80114e <memcmp+0x50>
		s1++, s2++;
  801136:	ff 45 fc             	incl   -0x4(%ebp)
  801139:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801142:	89 55 10             	mov    %edx,0x10(%ebp)
  801145:	85 c0                	test   %eax,%eax
  801147:	75 c9                	jne    801112 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801156:	8b 55 08             	mov    0x8(%ebp),%edx
  801159:	8b 45 10             	mov    0x10(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801161:	eb 15                	jmp    801178 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	0f b6 d0             	movzbl %al,%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	0f b6 c0             	movzbl %al,%eax
  801171:	39 c2                	cmp    %eax,%edx
  801173:	74 0d                	je     801182 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801175:	ff 45 08             	incl   0x8(%ebp)
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80117e:	72 e3                	jb     801163 <memfind+0x13>
  801180:	eb 01                	jmp    801183 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801182:	90                   	nop
	return (void *) s;
  801183:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801186:	c9                   	leave  
  801187:	c3                   	ret    

00801188 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801188:	55                   	push   %ebp
  801189:	89 e5                	mov    %esp,%ebp
  80118b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80118e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801195:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80119c:	eb 03                	jmp    8011a1 <strtol+0x19>
		s++;
  80119e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 20                	cmp    $0x20,%al
  8011a8:	74 f4                	je     80119e <strtol+0x16>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	8a 00                	mov    (%eax),%al
  8011af:	3c 09                	cmp    $0x9,%al
  8011b1:	74 eb                	je     80119e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	3c 2b                	cmp    $0x2b,%al
  8011ba:	75 05                	jne    8011c1 <strtol+0x39>
		s++;
  8011bc:	ff 45 08             	incl   0x8(%ebp)
  8011bf:	eb 13                	jmp    8011d4 <strtol+0x4c>
	else if (*s == '-')
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	3c 2d                	cmp    $0x2d,%al
  8011c8:	75 0a                	jne    8011d4 <strtol+0x4c>
		s++, neg = 1;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
  8011cd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011d8:	74 06                	je     8011e0 <strtol+0x58>
  8011da:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011de:	75 20                	jne    801200 <strtol+0x78>
  8011e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 30                	cmp    $0x30,%al
  8011e7:	75 17                	jne    801200 <strtol+0x78>
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	40                   	inc    %eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 78                	cmp    $0x78,%al
  8011f1:	75 0d                	jne    801200 <strtol+0x78>
		s += 2, base = 16;
  8011f3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011fe:	eb 28                	jmp    801228 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	75 15                	jne    80121b <strtol+0x93>
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	3c 30                	cmp    $0x30,%al
  80120d:	75 0c                	jne    80121b <strtol+0x93>
		s++, base = 8;
  80120f:	ff 45 08             	incl   0x8(%ebp)
  801212:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801219:	eb 0d                	jmp    801228 <strtol+0xa0>
	else if (base == 0)
  80121b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80121f:	75 07                	jne    801228 <strtol+0xa0>
		base = 10;
  801221:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801228:	8b 45 08             	mov    0x8(%ebp),%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	3c 2f                	cmp    $0x2f,%al
  80122f:	7e 19                	jle    80124a <strtol+0xc2>
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	3c 39                	cmp    $0x39,%al
  801238:	7f 10                	jg     80124a <strtol+0xc2>
			dig = *s - '0';
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	8a 00                	mov    (%eax),%al
  80123f:	0f be c0             	movsbl %al,%eax
  801242:	83 e8 30             	sub    $0x30,%eax
  801245:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801248:	eb 42                	jmp    80128c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	8a 00                	mov    (%eax),%al
  80124f:	3c 60                	cmp    $0x60,%al
  801251:	7e 19                	jle    80126c <strtol+0xe4>
  801253:	8b 45 08             	mov    0x8(%ebp),%eax
  801256:	8a 00                	mov    (%eax),%al
  801258:	3c 7a                	cmp    $0x7a,%al
  80125a:	7f 10                	jg     80126c <strtol+0xe4>
			dig = *s - 'a' + 10;
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8a 00                	mov    (%eax),%al
  801261:	0f be c0             	movsbl %al,%eax
  801264:	83 e8 57             	sub    $0x57,%eax
  801267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80126a:	eb 20                	jmp    80128c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	3c 40                	cmp    $0x40,%al
  801273:	7e 39                	jle    8012ae <strtol+0x126>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	3c 5a                	cmp    $0x5a,%al
  80127c:	7f 30                	jg     8012ae <strtol+0x126>
			dig = *s - 'A' + 10;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	0f be c0             	movsbl %al,%eax
  801286:	83 e8 37             	sub    $0x37,%eax
  801289:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80128c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80128f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801292:	7d 19                	jge    8012ad <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801294:	ff 45 08             	incl   0x8(%ebp)
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80129e:	89 c2                	mov    %eax,%edx
  8012a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012a3:	01 d0                	add    %edx,%eax
  8012a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012a8:	e9 7b ff ff ff       	jmp    801228 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012ad:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012ae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b2:	74 08                	je     8012bc <strtol+0x134>
		*endptr = (char *) s;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8012ba:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012c0:	74 07                	je     8012c9 <strtol+0x141>
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	f7 d8                	neg    %eax
  8012c7:	eb 03                	jmp    8012cc <strtol+0x144>
  8012c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <ltostr>:

void
ltostr(long value, char *str)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e6:	79 13                	jns    8012fb <ltostr+0x2d>
	{
		neg = 1;
  8012e8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012f5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012f8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801303:	99                   	cltd   
  801304:	f7 f9                	idiv   %ecx
  801306:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801309:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80130c:	8d 50 01             	lea    0x1(%eax),%edx
  80130f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801312:	89 c2                	mov    %eax,%edx
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
  801317:	01 d0                	add    %edx,%eax
  801319:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80131c:	83 c2 30             	add    $0x30,%edx
  80131f:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801321:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801324:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801329:	f7 e9                	imul   %ecx
  80132b:	c1 fa 02             	sar    $0x2,%edx
  80132e:	89 c8                	mov    %ecx,%eax
  801330:	c1 f8 1f             	sar    $0x1f,%eax
  801333:	29 c2                	sub    %eax,%edx
  801335:	89 d0                	mov    %edx,%eax
  801337:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80133a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80133d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801342:	f7 e9                	imul   %ecx
  801344:	c1 fa 02             	sar    $0x2,%edx
  801347:	89 c8                	mov    %ecx,%eax
  801349:	c1 f8 1f             	sar    $0x1f,%eax
  80134c:	29 c2                	sub    %eax,%edx
  80134e:	89 d0                	mov    %edx,%eax
  801350:	c1 e0 02             	shl    $0x2,%eax
  801353:	01 d0                	add    %edx,%eax
  801355:	01 c0                	add    %eax,%eax
  801357:	29 c1                	sub    %eax,%ecx
  801359:	89 ca                	mov    %ecx,%edx
  80135b:	85 d2                	test   %edx,%edx
  80135d:	75 9c                	jne    8012fb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80135f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801366:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80136d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801371:	74 3d                	je     8013b0 <ltostr+0xe2>
		start = 1 ;
  801373:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80137a:	eb 34                	jmp    8013b0 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80137c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80137f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801382:	01 d0                	add    %edx,%eax
  801384:	8a 00                	mov    (%eax),%al
  801386:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801389:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80138c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138f:	01 c2                	add    %eax,%edx
  801391:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801394:	8b 45 0c             	mov    0xc(%ebp),%eax
  801397:	01 c8                	add    %ecx,%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80139d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a3:	01 c2                	add    %eax,%edx
  8013a5:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013a8:	88 02                	mov    %al,(%edx)
		start++ ;
  8013aa:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013ad:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013b6:	7c c4                	jl     80137c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	01 d0                	add    %edx,%eax
  8013c0:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013c3:	90                   	nop
  8013c4:	c9                   	leave  
  8013c5:	c3                   	ret    

008013c6 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013c6:	55                   	push   %ebp
  8013c7:	89 e5                	mov    %esp,%ebp
  8013c9:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013cc:	ff 75 08             	pushl  0x8(%ebp)
  8013cf:	e8 54 fa ff ff       	call   800e28 <strlen>
  8013d4:	83 c4 04             	add    $0x4,%esp
  8013d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	e8 46 fa ff ff       	call   800e28 <strlen>
  8013e2:	83 c4 04             	add    $0x4,%esp
  8013e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013f6:	eb 17                	jmp    80140f <strcconcat+0x49>
		final[s] = str1[s] ;
  8013f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	01 c2                	add    %eax,%edx
  801400:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801403:	8b 45 08             	mov    0x8(%ebp),%eax
  801406:	01 c8                	add    %ecx,%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80140c:	ff 45 fc             	incl   -0x4(%ebp)
  80140f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801412:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801415:	7c e1                	jl     8013f8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801417:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80141e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801425:	eb 1f                	jmp    801446 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801427:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80142a:	8d 50 01             	lea    0x1(%eax),%edx
  80142d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801430:	89 c2                	mov    %eax,%edx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
  801435:	01 c2                	add    %eax,%edx
  801437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	01 c8                	add    %ecx,%eax
  80143f:	8a 00                	mov    (%eax),%al
  801441:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801443:	ff 45 f8             	incl   -0x8(%ebp)
  801446:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801449:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80144c:	7c d9                	jl     801427 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80144e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801451:	8b 45 10             	mov    0x10(%ebp),%eax
  801454:	01 d0                	add    %edx,%eax
  801456:	c6 00 00             	movb   $0x0,(%eax)
}
  801459:	90                   	nop
  80145a:	c9                   	leave  
  80145b:	c3                   	ret    

0080145c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80145f:	8b 45 14             	mov    0x14(%ebp),%eax
  801462:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801468:	8b 45 14             	mov    0x14(%ebp),%eax
  80146b:	8b 00                	mov    (%eax),%eax
  80146d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801474:	8b 45 10             	mov    0x10(%ebp),%eax
  801477:	01 d0                	add    %edx,%eax
  801479:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80147f:	eb 0c                	jmp    80148d <strsplit+0x31>
			*string++ = 0;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8d 50 01             	lea    0x1(%eax),%edx
  801487:	89 55 08             	mov    %edx,0x8(%ebp)
  80148a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80148d:	8b 45 08             	mov    0x8(%ebp),%eax
  801490:	8a 00                	mov    (%eax),%al
  801492:	84 c0                	test   %al,%al
  801494:	74 18                	je     8014ae <strsplit+0x52>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	0f be c0             	movsbl %al,%eax
  80149e:	50                   	push   %eax
  80149f:	ff 75 0c             	pushl  0xc(%ebp)
  8014a2:	e8 13 fb ff ff       	call   800fba <strchr>
  8014a7:	83 c4 08             	add    $0x8,%esp
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	75 d3                	jne    801481 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b1:	8a 00                	mov    (%eax),%al
  8014b3:	84 c0                	test   %al,%al
  8014b5:	74 5a                	je     801511 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	83 f8 0f             	cmp    $0xf,%eax
  8014bf:	75 07                	jne    8014c8 <strsplit+0x6c>
		{
			return 0;
  8014c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c6:	eb 66                	jmp    80152e <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8014cb:	8b 00                	mov    (%eax),%eax
  8014cd:	8d 48 01             	lea    0x1(%eax),%ecx
  8014d0:	8b 55 14             	mov    0x14(%ebp),%edx
  8014d3:	89 0a                	mov    %ecx,(%edx)
  8014d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014df:	01 c2                	add    %eax,%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e6:	eb 03                	jmp    8014eb <strsplit+0x8f>
			string++;
  8014e8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ee:	8a 00                	mov    (%eax),%al
  8014f0:	84 c0                	test   %al,%al
  8014f2:	74 8b                	je     80147f <strsplit+0x23>
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	8a 00                	mov    (%eax),%al
  8014f9:	0f be c0             	movsbl %al,%eax
  8014fc:	50                   	push   %eax
  8014fd:	ff 75 0c             	pushl  0xc(%ebp)
  801500:	e8 b5 fa ff ff       	call   800fba <strchr>
  801505:	83 c4 08             	add    $0x8,%esp
  801508:	85 c0                	test   %eax,%eax
  80150a:	74 dc                	je     8014e8 <strsplit+0x8c>
			string++;
	}
  80150c:	e9 6e ff ff ff       	jmp    80147f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801511:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801512:	8b 45 14             	mov    0x14(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80151e:	8b 45 10             	mov    0x10(%ebp),%eax
  801521:	01 d0                	add    %edx,%eax
  801523:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801529:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801536:	a1 04 40 80 00       	mov    0x804004,%eax
  80153b:	85 c0                	test   %eax,%eax
  80153d:	74 1f                	je     80155e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80153f:	e8 1d 00 00 00       	call   801561 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801544:	83 ec 0c             	sub    $0xc,%esp
  801547:	68 50 3b 80 00       	push   $0x803b50
  80154c:	e8 55 f2 ff ff       	call   8007a6 <cprintf>
  801551:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801554:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80155b:	00 00 00 
	}
}
  80155e:	90                   	nop
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801567:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80156e:	00 00 00 
  801571:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801578:	00 00 00 
  80157b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801582:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801585:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80158c:	00 00 00 
  80158f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801596:	00 00 00 
  801599:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8015a0:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8015a3:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ad:	c1 e8 0c             	shr    $0xc,%eax
  8015b0:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8015b5:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8015bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015c4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c9:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  8015ce:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8015d5:	a1 20 41 80 00       	mov    0x804120,%eax
  8015da:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8015de:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8015e1:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8015e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ee:	01 d0                	add    %edx,%eax
  8015f0:	48                   	dec    %eax
  8015f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fc:	f7 75 e4             	divl   -0x1c(%ebp)
  8015ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801602:	29 d0                	sub    %edx,%eax
  801604:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801607:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  80160e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801611:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801616:	2d 00 10 00 00       	sub    $0x1000,%eax
  80161b:	83 ec 04             	sub    $0x4,%esp
  80161e:	6a 07                	push   $0x7
  801620:	ff 75 e8             	pushl  -0x18(%ebp)
  801623:	50                   	push   %eax
  801624:	e8 3d 06 00 00       	call   801c66 <sys_allocate_chunk>
  801629:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80162c:	a1 20 41 80 00       	mov    0x804120,%eax
  801631:	83 ec 0c             	sub    $0xc,%esp
  801634:	50                   	push   %eax
  801635:	e8 b2 0c 00 00       	call   8022ec <initialize_MemBlocksList>
  80163a:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  80163d:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801642:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801645:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801649:	0f 84 f3 00 00 00    	je     801742 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80164f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801653:	75 14                	jne    801669 <initialize_dyn_block_system+0x108>
  801655:	83 ec 04             	sub    $0x4,%esp
  801658:	68 75 3b 80 00       	push   $0x803b75
  80165d:	6a 36                	push   $0x36
  80165f:	68 93 3b 80 00       	push   $0x803b93
  801664:	e8 89 ee ff ff       	call   8004f2 <_panic>
  801669:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80166c:	8b 00                	mov    (%eax),%eax
  80166e:	85 c0                	test   %eax,%eax
  801670:	74 10                	je     801682 <initialize_dyn_block_system+0x121>
  801672:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801675:	8b 00                	mov    (%eax),%eax
  801677:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80167a:	8b 52 04             	mov    0x4(%edx),%edx
  80167d:	89 50 04             	mov    %edx,0x4(%eax)
  801680:	eb 0b                	jmp    80168d <initialize_dyn_block_system+0x12c>
  801682:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801685:	8b 40 04             	mov    0x4(%eax),%eax
  801688:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80168d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801690:	8b 40 04             	mov    0x4(%eax),%eax
  801693:	85 c0                	test   %eax,%eax
  801695:	74 0f                	je     8016a6 <initialize_dyn_block_system+0x145>
  801697:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80169a:	8b 40 04             	mov    0x4(%eax),%eax
  80169d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016a0:	8b 12                	mov    (%edx),%edx
  8016a2:	89 10                	mov    %edx,(%eax)
  8016a4:	eb 0a                	jmp    8016b0 <initialize_dyn_block_system+0x14f>
  8016a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	a3 48 41 80 00       	mov    %eax,0x804148
  8016b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016c3:	a1 54 41 80 00       	mov    0x804154,%eax
  8016c8:	48                   	dec    %eax
  8016c9:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8016ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016d1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8016d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016db:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8016e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8016e6:	75 14                	jne    8016fc <initialize_dyn_block_system+0x19b>
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	68 a0 3b 80 00       	push   $0x803ba0
  8016f0:	6a 3e                	push   $0x3e
  8016f2:	68 93 3b 80 00       	push   $0x803b93
  8016f7:	e8 f6 ed ff ff       	call   8004f2 <_panic>
  8016fc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801702:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801705:	89 10                	mov    %edx,(%eax)
  801707:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80170a:	8b 00                	mov    (%eax),%eax
  80170c:	85 c0                	test   %eax,%eax
  80170e:	74 0d                	je     80171d <initialize_dyn_block_system+0x1bc>
  801710:	a1 38 41 80 00       	mov    0x804138,%eax
  801715:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801718:	89 50 04             	mov    %edx,0x4(%eax)
  80171b:	eb 08                	jmp    801725 <initialize_dyn_block_system+0x1c4>
  80171d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801720:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801725:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801728:	a3 38 41 80 00       	mov    %eax,0x804138
  80172d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801730:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801737:	a1 44 41 80 00       	mov    0x804144,%eax
  80173c:	40                   	inc    %eax
  80173d:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801742:	90                   	nop
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80174b:	e8 e0 fd ff ff       	call   801530 <InitializeUHeap>
		if (size == 0) return NULL ;
  801750:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801754:	75 07                	jne    80175d <malloc+0x18>
  801756:	b8 00 00 00 00       	mov    $0x0,%eax
  80175b:	eb 7f                	jmp    8017dc <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80175d:	e8 d2 08 00 00       	call   802034 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801762:	85 c0                	test   %eax,%eax
  801764:	74 71                	je     8017d7 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801766:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80176d:	8b 55 08             	mov    0x8(%ebp),%edx
  801770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801773:	01 d0                	add    %edx,%eax
  801775:	48                   	dec    %eax
  801776:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177c:	ba 00 00 00 00       	mov    $0x0,%edx
  801781:	f7 75 f4             	divl   -0xc(%ebp)
  801784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801787:	29 d0                	sub    %edx,%eax
  801789:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80178c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801793:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80179a:	76 07                	jbe    8017a3 <malloc+0x5e>
					return NULL ;
  80179c:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a1:	eb 39                	jmp    8017dc <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  8017a3:	83 ec 0c             	sub    $0xc,%esp
  8017a6:	ff 75 08             	pushl  0x8(%ebp)
  8017a9:	e8 e6 0d 00 00       	call   802594 <alloc_block_FF>
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8017b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8017b8:	74 16                	je     8017d0 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8017ba:	83 ec 0c             	sub    $0xc,%esp
  8017bd:	ff 75 ec             	pushl  -0x14(%ebp)
  8017c0:	e8 37 0c 00 00       	call   8023fc <insert_sorted_allocList>
  8017c5:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8017c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017cb:	8b 40 08             	mov    0x8(%eax),%eax
  8017ce:	eb 0c                	jmp    8017dc <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8017d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d5:	eb 05                	jmp    8017dc <malloc+0x97>
				}
		}
	return 0;
  8017d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017dc:	c9                   	leave  
  8017dd:	c3                   	ret    

008017de <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8017ea:	83 ec 08             	sub    $0x8,%esp
  8017ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f0:	68 40 40 80 00       	push   $0x804040
  8017f5:	e8 cf 0b 00 00       	call   8023c9 <find_block>
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801803:	8b 40 0c             	mov    0xc(%eax),%eax
  801806:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180c:	8b 40 08             	mov    0x8(%eax),%eax
  80180f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801812:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801816:	0f 84 a1 00 00 00    	je     8018bd <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  80181c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801820:	75 17                	jne    801839 <free+0x5b>
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	68 75 3b 80 00       	push   $0x803b75
  80182a:	68 80 00 00 00       	push   $0x80
  80182f:	68 93 3b 80 00       	push   $0x803b93
  801834:	e8 b9 ec ff ff       	call   8004f2 <_panic>
  801839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183c:	8b 00                	mov    (%eax),%eax
  80183e:	85 c0                	test   %eax,%eax
  801840:	74 10                	je     801852 <free+0x74>
  801842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801845:	8b 00                	mov    (%eax),%eax
  801847:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80184a:	8b 52 04             	mov    0x4(%edx),%edx
  80184d:	89 50 04             	mov    %edx,0x4(%eax)
  801850:	eb 0b                	jmp    80185d <free+0x7f>
  801852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801855:	8b 40 04             	mov    0x4(%eax),%eax
  801858:	a3 44 40 80 00       	mov    %eax,0x804044
  80185d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801860:	8b 40 04             	mov    0x4(%eax),%eax
  801863:	85 c0                	test   %eax,%eax
  801865:	74 0f                	je     801876 <free+0x98>
  801867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80186a:	8b 40 04             	mov    0x4(%eax),%eax
  80186d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801870:	8b 12                	mov    (%edx),%edx
  801872:	89 10                	mov    %edx,(%eax)
  801874:	eb 0a                	jmp    801880 <free+0xa2>
  801876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	a3 40 40 80 00       	mov    %eax,0x804040
  801880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801893:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801898:	48                   	dec    %eax
  801899:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80189e:	83 ec 0c             	sub    $0xc,%esp
  8018a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018a4:	e8 29 12 00 00       	call   802ad2 <insert_sorted_with_merge_freeList>
  8018a9:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  8018ac:	83 ec 08             	sub    $0x8,%esp
  8018af:	ff 75 ec             	pushl  -0x14(%ebp)
  8018b2:	ff 75 e8             	pushl  -0x18(%ebp)
  8018b5:	e8 74 03 00 00       	call   801c2e <sys_free_user_mem>
  8018ba:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8018bd:	90                   	nop
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 38             	sub    $0x38,%esp
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018cc:	e8 5f fc ff ff       	call   801530 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018d5:	75 0a                	jne    8018e1 <smalloc+0x21>
  8018d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8018dc:	e9 b2 00 00 00       	jmp    801993 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8018e1:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8018e8:	76 0a                	jbe    8018f4 <smalloc+0x34>
		return NULL;
  8018ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ef:	e9 9f 00 00 00       	jmp    801993 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8018f4:	e8 3b 07 00 00       	call   802034 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	0f 84 8d 00 00 00    	je     80198e <smalloc+0xce>
	struct MemBlock *b = NULL;
  801901:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801908:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80190f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801912:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801915:	01 d0                	add    %edx,%eax
  801917:	48                   	dec    %eax
  801918:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80191b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80191e:	ba 00 00 00 00       	mov    $0x0,%edx
  801923:	f7 75 f0             	divl   -0x10(%ebp)
  801926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801929:	29 d0                	sub    %edx,%eax
  80192b:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  80192e:	83 ec 0c             	sub    $0xc,%esp
  801931:	ff 75 e8             	pushl  -0x18(%ebp)
  801934:	e8 5b 0c 00 00       	call   802594 <alloc_block_FF>
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  80193f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801943:	75 07                	jne    80194c <smalloc+0x8c>
			return NULL;
  801945:	b8 00 00 00 00       	mov    $0x0,%eax
  80194a:	eb 47                	jmp    801993 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  80194c:	83 ec 0c             	sub    $0xc,%esp
  80194f:	ff 75 f4             	pushl  -0xc(%ebp)
  801952:	e8 a5 0a 00 00       	call   8023fc <insert_sorted_allocList>
  801957:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80195a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195d:	8b 40 08             	mov    0x8(%eax),%eax
  801960:	89 c2                	mov    %eax,%edx
  801962:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801966:	52                   	push   %edx
  801967:	50                   	push   %eax
  801968:	ff 75 0c             	pushl  0xc(%ebp)
  80196b:	ff 75 08             	pushl  0x8(%ebp)
  80196e:	e8 46 04 00 00       	call   801db9 <sys_createSharedObject>
  801973:	83 c4 10             	add    $0x10,%esp
  801976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801979:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80197d:	78 08                	js     801987 <smalloc+0xc7>
		return (void *)b->sva;
  80197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801982:	8b 40 08             	mov    0x8(%eax),%eax
  801985:	eb 0c                	jmp    801993 <smalloc+0xd3>
		}else{
		return NULL;
  801987:	b8 00 00 00 00       	mov    $0x0,%eax
  80198c:	eb 05                	jmp    801993 <smalloc+0xd3>
			}

	}return NULL;
  80198e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80199b:	e8 90 fb ff ff       	call   801530 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8019a0:	e8 8f 06 00 00       	call   802034 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	0f 84 ad 00 00 00    	je     801a5a <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8019ad:	83 ec 08             	sub    $0x8,%esp
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	e8 28 04 00 00       	call   801de3 <sys_getSizeOfSharedObject>
  8019bb:	83 c4 10             	add    $0x10,%esp
  8019be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8019c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019c5:	79 0a                	jns    8019d1 <sget+0x3c>
    {
    	return NULL;
  8019c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019cc:	e9 8e 00 00 00       	jmp    801a5f <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8019d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8019d8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e5:	01 d0                	add    %edx,%eax
  8019e7:	48                   	dec    %eax
  8019e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f3:	f7 75 ec             	divl   -0x14(%ebp)
  8019f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019f9:	29 d0                	sub    %edx,%eax
  8019fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8019fe:	83 ec 0c             	sub    $0xc,%esp
  801a01:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a04:	e8 8b 0b 00 00       	call   802594 <alloc_block_FF>
  801a09:	83 c4 10             	add    $0x10,%esp
  801a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801a0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a13:	75 07                	jne    801a1c <sget+0x87>
				return NULL;
  801a15:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1a:	eb 43                	jmp    801a5f <sget+0xca>
			}
			insert_sorted_allocList(b);
  801a1c:	83 ec 0c             	sub    $0xc,%esp
  801a1f:	ff 75 f0             	pushl  -0x10(%ebp)
  801a22:	e8 d5 09 00 00       	call   8023fc <insert_sorted_allocList>
  801a27:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2d:	8b 40 08             	mov    0x8(%eax),%eax
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	50                   	push   %eax
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	e8 c1 03 00 00       	call   801e00 <sys_getSharedObject>
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801a45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a49:	78 08                	js     801a53 <sget+0xbe>
			return (void *)b->sva;
  801a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4e:	8b 40 08             	mov    0x8(%eax),%eax
  801a51:	eb 0c                	jmp    801a5f <sget+0xca>
			}else{
			return NULL;
  801a53:	b8 00 00 00 00       	mov    $0x0,%eax
  801a58:	eb 05                	jmp    801a5f <sget+0xca>
			}
    }}return NULL;
  801a5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a67:	e8 c4 fa ff ff       	call   801530 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a6c:	83 ec 04             	sub    $0x4,%esp
  801a6f:	68 c4 3b 80 00       	push   $0x803bc4
  801a74:	68 03 01 00 00       	push   $0x103
  801a79:	68 93 3b 80 00       	push   $0x803b93
  801a7e:	e8 6f ea ff ff       	call   8004f2 <_panic>

00801a83 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a89:	83 ec 04             	sub    $0x4,%esp
  801a8c:	68 ec 3b 80 00       	push   $0x803bec
  801a91:	68 17 01 00 00       	push   $0x117
  801a96:	68 93 3b 80 00       	push   $0x803b93
  801a9b:	e8 52 ea ff ff       	call   8004f2 <_panic>

00801aa0 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa6:	83 ec 04             	sub    $0x4,%esp
  801aa9:	68 10 3c 80 00       	push   $0x803c10
  801aae:	68 22 01 00 00       	push   $0x122
  801ab3:	68 93 3b 80 00       	push   $0x803b93
  801ab8:	e8 35 ea ff ff       	call   8004f2 <_panic>

00801abd <shrink>:

}
void shrink(uint32 newSize)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
  801ac0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac3:	83 ec 04             	sub    $0x4,%esp
  801ac6:	68 10 3c 80 00       	push   $0x803c10
  801acb:	68 27 01 00 00       	push   $0x127
  801ad0:	68 93 3b 80 00       	push   $0x803b93
  801ad5:	e8 18 ea ff ff       	call   8004f2 <_panic>

00801ada <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
  801add:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ae0:	83 ec 04             	sub    $0x4,%esp
  801ae3:	68 10 3c 80 00       	push   $0x803c10
  801ae8:	68 2c 01 00 00       	push   $0x12c
  801aed:	68 93 3b 80 00       	push   $0x803b93
  801af2:	e8 fb e9 ff ff       	call   8004f2 <_panic>

00801af7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	57                   	push   %edi
  801afb:	56                   	push   %esi
  801afc:	53                   	push   %ebx
  801afd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b06:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b09:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b0c:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b0f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b12:	cd 30                	int    $0x30
  801b14:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b1a:	83 c4 10             	add    $0x10,%esp
  801b1d:	5b                   	pop    %ebx
  801b1e:	5e                   	pop    %esi
  801b1f:	5f                   	pop    %edi
  801b20:	5d                   	pop    %ebp
  801b21:	c3                   	ret    

00801b22 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 04             	sub    $0x4,%esp
  801b28:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b2e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b32:	8b 45 08             	mov    0x8(%ebp),%eax
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	52                   	push   %edx
  801b3a:	ff 75 0c             	pushl  0xc(%ebp)
  801b3d:	50                   	push   %eax
  801b3e:	6a 00                	push   $0x0
  801b40:	e8 b2 ff ff ff       	call   801af7 <syscall>
  801b45:	83 c4 18             	add    $0x18,%esp
}
  801b48:	90                   	nop
  801b49:	c9                   	leave  
  801b4a:	c3                   	ret    

00801b4b <sys_cgetc>:

int
sys_cgetc(void)
{
  801b4b:	55                   	push   %ebp
  801b4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 01                	push   $0x1
  801b5a:	e8 98 ff ff ff       	call   801af7 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	52                   	push   %edx
  801b74:	50                   	push   %eax
  801b75:	6a 05                	push   $0x5
  801b77:	e8 7b ff ff ff       	call   801af7 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
  801b84:	56                   	push   %esi
  801b85:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b86:	8b 75 18             	mov    0x18(%ebp),%esi
  801b89:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b8c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	56                   	push   %esi
  801b96:	53                   	push   %ebx
  801b97:	51                   	push   %ecx
  801b98:	52                   	push   %edx
  801b99:	50                   	push   %eax
  801b9a:	6a 06                	push   $0x6
  801b9c:	e8 56 ff ff ff       	call   801af7 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ba7:	5b                   	pop    %ebx
  801ba8:	5e                   	pop    %esi
  801ba9:	5d                   	pop    %ebp
  801baa:	c3                   	ret    

00801bab <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	52                   	push   %edx
  801bbb:	50                   	push   %eax
  801bbc:	6a 07                	push   $0x7
  801bbe:	e8 34 ff ff ff       	call   801af7 <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	ff 75 0c             	pushl  0xc(%ebp)
  801bd4:	ff 75 08             	pushl  0x8(%ebp)
  801bd7:	6a 08                	push   $0x8
  801bd9:	e8 19 ff ff ff       	call   801af7 <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 09                	push   $0x9
  801bf2:	e8 00 ff ff ff       	call   801af7 <syscall>
  801bf7:	83 c4 18             	add    $0x18,%esp
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 0a                	push   $0xa
  801c0b:	e8 e7 fe ff ff       	call   801af7 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 0b                	push   $0xb
  801c24:	e8 ce fe ff ff       	call   801af7 <syscall>
  801c29:	83 c4 18             	add    $0x18,%esp
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	ff 75 0c             	pushl  0xc(%ebp)
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	6a 0f                	push   $0xf
  801c3f:	e8 b3 fe ff ff       	call   801af7 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
	return;
  801c47:	90                   	nop
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	ff 75 08             	pushl  0x8(%ebp)
  801c59:	6a 10                	push   $0x10
  801c5b:	e8 97 fe ff ff       	call   801af7 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
	return ;
  801c63:	90                   	nop
}
  801c64:	c9                   	leave  
  801c65:	c3                   	ret    

00801c66 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	ff 75 10             	pushl  0x10(%ebp)
  801c70:	ff 75 0c             	pushl  0xc(%ebp)
  801c73:	ff 75 08             	pushl  0x8(%ebp)
  801c76:	6a 11                	push   $0x11
  801c78:	e8 7a fe ff ff       	call   801af7 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c80:	90                   	nop
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 0c                	push   $0xc
  801c92:	e8 60 fe ff ff       	call   801af7 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	ff 75 08             	pushl  0x8(%ebp)
  801caa:	6a 0d                	push   $0xd
  801cac:	e8 46 fe ff ff       	call   801af7 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 0e                	push   $0xe
  801cc5:	e8 2d fe ff ff       	call   801af7 <syscall>
  801cca:	83 c4 18             	add    $0x18,%esp
}
  801ccd:	90                   	nop
  801cce:	c9                   	leave  
  801ccf:	c3                   	ret    

00801cd0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 13                	push   $0x13
  801cdf:	e8 13 fe ff ff       	call   801af7 <syscall>
  801ce4:	83 c4 18             	add    $0x18,%esp
}
  801ce7:	90                   	nop
  801ce8:	c9                   	leave  
  801ce9:	c3                   	ret    

00801cea <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 14                	push   $0x14
  801cf9:	e8 f9 fd ff ff       	call   801af7 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
}
  801d01:	90                   	nop
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_cputc>:


void
sys_cputc(const char c)
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
  801d07:	83 ec 04             	sub    $0x4,%esp
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d10:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	50                   	push   %eax
  801d1d:	6a 15                	push   $0x15
  801d1f:	e8 d3 fd ff ff       	call   801af7 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	90                   	nop
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 16                	push   $0x16
  801d39:	e8 b9 fd ff ff       	call   801af7 <syscall>
  801d3e:	83 c4 18             	add    $0x18,%esp
}
  801d41:	90                   	nop
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	ff 75 0c             	pushl  0xc(%ebp)
  801d53:	50                   	push   %eax
  801d54:	6a 17                	push   $0x17
  801d56:	e8 9c fd ff ff       	call   801af7 <syscall>
  801d5b:	83 c4 18             	add    $0x18,%esp
}
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d66:	8b 45 08             	mov    0x8(%ebp),%eax
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	52                   	push   %edx
  801d70:	50                   	push   %eax
  801d71:	6a 1a                	push   $0x1a
  801d73:	e8 7f fd ff ff       	call   801af7 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	52                   	push   %edx
  801d8d:	50                   	push   %eax
  801d8e:	6a 18                	push   $0x18
  801d90:	e8 62 fd ff ff       	call   801af7 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	90                   	nop
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da1:	8b 45 08             	mov    0x8(%ebp),%eax
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	52                   	push   %edx
  801dab:	50                   	push   %eax
  801dac:	6a 19                	push   $0x19
  801dae:	e8 44 fd ff ff       	call   801af7 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	90                   	nop
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 04             	sub    $0x4,%esp
  801dbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801dc5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dc8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	6a 00                	push   $0x0
  801dd1:	51                   	push   %ecx
  801dd2:	52                   	push   %edx
  801dd3:	ff 75 0c             	pushl  0xc(%ebp)
  801dd6:	50                   	push   %eax
  801dd7:	6a 1b                	push   $0x1b
  801dd9:	e8 19 fd ff ff       	call   801af7 <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801de6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	52                   	push   %edx
  801df3:	50                   	push   %eax
  801df4:	6a 1c                	push   $0x1c
  801df6:	e8 fc fc ff ff       	call   801af7 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e03:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	51                   	push   %ecx
  801e11:	52                   	push   %edx
  801e12:	50                   	push   %eax
  801e13:	6a 1d                	push   $0x1d
  801e15:	e8 dd fc ff ff       	call   801af7 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
}
  801e1d:	c9                   	leave  
  801e1e:	c3                   	ret    

00801e1f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e1f:	55                   	push   %ebp
  801e20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e25:	8b 45 08             	mov    0x8(%ebp),%eax
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	52                   	push   %edx
  801e2f:	50                   	push   %eax
  801e30:	6a 1e                	push   $0x1e
  801e32:	e8 c0 fc ff ff       	call   801af7 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 1f                	push   $0x1f
  801e4b:	e8 a7 fc ff ff       	call   801af7 <syscall>
  801e50:	83 c4 18             	add    $0x18,%esp
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	6a 00                	push   $0x0
  801e5d:	ff 75 14             	pushl  0x14(%ebp)
  801e60:	ff 75 10             	pushl  0x10(%ebp)
  801e63:	ff 75 0c             	pushl  0xc(%ebp)
  801e66:	50                   	push   %eax
  801e67:	6a 20                	push   $0x20
  801e69:	e8 89 fc ff ff       	call   801af7 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	50                   	push   %eax
  801e82:	6a 21                	push   $0x21
  801e84:	e8 6e fc ff ff       	call   801af7 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
}
  801e8c:	90                   	nop
  801e8d:	c9                   	leave  
  801e8e:	c3                   	ret    

00801e8f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e8f:	55                   	push   %ebp
  801e90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e92:	8b 45 08             	mov    0x8(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	50                   	push   %eax
  801e9e:	6a 22                	push   $0x22
  801ea0:	e8 52 fc ff ff       	call   801af7 <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
}
  801ea8:	c9                   	leave  
  801ea9:	c3                   	ret    

00801eaa <sys_getenvid>:

int32 sys_getenvid(void)
{
  801eaa:	55                   	push   %ebp
  801eab:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 02                	push   $0x2
  801eb9:	e8 39 fc ff ff       	call   801af7 <syscall>
  801ebe:	83 c4 18             	add    $0x18,%esp
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 03                	push   $0x3
  801ed2:	e8 20 fc ff ff       	call   801af7 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 04                	push   $0x4
  801eeb:	e8 07 fc ff ff       	call   801af7 <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_exit_env>:


void sys_exit_env(void)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 23                	push   $0x23
  801f04:	e8 ee fb ff ff       	call   801af7 <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
}
  801f0c:	90                   	nop
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
  801f12:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f15:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f18:	8d 50 04             	lea    0x4(%eax),%edx
  801f1b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	52                   	push   %edx
  801f25:	50                   	push   %eax
  801f26:	6a 24                	push   $0x24
  801f28:	e8 ca fb ff ff       	call   801af7 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
	return result;
  801f30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f33:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f36:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f39:	89 01                	mov    %eax,(%ecx)
  801f3b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	c9                   	leave  
  801f42:	c2 04 00             	ret    $0x4

00801f45 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	ff 75 10             	pushl  0x10(%ebp)
  801f4f:	ff 75 0c             	pushl  0xc(%ebp)
  801f52:	ff 75 08             	pushl  0x8(%ebp)
  801f55:	6a 12                	push   $0x12
  801f57:	e8 9b fb ff ff       	call   801af7 <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5f:	90                   	nop
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 25                	push   $0x25
  801f71:	e8 81 fb ff ff       	call   801af7 <syscall>
  801f76:	83 c4 18             	add    $0x18,%esp
}
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
  801f7e:	83 ec 04             	sub    $0x4,%esp
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f87:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	6a 00                	push   $0x0
  801f91:	6a 00                	push   $0x0
  801f93:	50                   	push   %eax
  801f94:	6a 26                	push   $0x26
  801f96:	e8 5c fb ff ff       	call   801af7 <syscall>
  801f9b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9e:	90                   	nop
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <rsttst>:
void rsttst()
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 28                	push   $0x28
  801fb0:	e8 42 fb ff ff       	call   801af7 <syscall>
  801fb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb8:	90                   	nop
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	83 ec 04             	sub    $0x4,%esp
  801fc1:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fc7:	8b 55 18             	mov    0x18(%ebp),%edx
  801fca:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fce:	52                   	push   %edx
  801fcf:	50                   	push   %eax
  801fd0:	ff 75 10             	pushl  0x10(%ebp)
  801fd3:	ff 75 0c             	pushl  0xc(%ebp)
  801fd6:	ff 75 08             	pushl  0x8(%ebp)
  801fd9:	6a 27                	push   $0x27
  801fdb:	e8 17 fb ff ff       	call   801af7 <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe3:	90                   	nop
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <chktst>:
void chktst(uint32 n)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	ff 75 08             	pushl  0x8(%ebp)
  801ff4:	6a 29                	push   $0x29
  801ff6:	e8 fc fa ff ff       	call   801af7 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffe:	90                   	nop
}
  801fff:	c9                   	leave  
  802000:	c3                   	ret    

00802001 <inctst>:

void inctst()
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 00                	push   $0x0
  80200e:	6a 2a                	push   $0x2a
  802010:	e8 e2 fa ff ff       	call   801af7 <syscall>
  802015:	83 c4 18             	add    $0x18,%esp
	return ;
  802018:	90                   	nop
}
  802019:	c9                   	leave  
  80201a:	c3                   	ret    

0080201b <gettst>:
uint32 gettst()
{
  80201b:	55                   	push   %ebp
  80201c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 2b                	push   $0x2b
  80202a:	e8 c8 fa ff ff       	call   801af7 <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 2c                	push   $0x2c
  802046:	e8 ac fa ff ff       	call   801af7 <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
  80204e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802051:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802055:	75 07                	jne    80205e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802057:	b8 01 00 00 00       	mov    $0x1,%eax
  80205c:	eb 05                	jmp    802063 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802063:	c9                   	leave  
  802064:	c3                   	ret    

00802065 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802065:	55                   	push   %ebp
  802066:	89 e5                	mov    %esp,%ebp
  802068:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 2c                	push   $0x2c
  802077:	e8 7b fa ff ff       	call   801af7 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
  80207f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802082:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802086:	75 07                	jne    80208f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802088:	b8 01 00 00 00       	mov    $0x1,%eax
  80208d:	eb 05                	jmp    802094 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80208f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802094:	c9                   	leave  
  802095:	c3                   	ret    

00802096 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 2c                	push   $0x2c
  8020a8:	e8 4a fa ff ff       	call   801af7 <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
  8020b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8020b3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8020b7:	75 07                	jne    8020c0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8020b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020be:	eb 05                	jmp    8020c5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020c5:	c9                   	leave  
  8020c6:	c3                   	ret    

008020c7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020cd:	6a 00                	push   $0x0
  8020cf:	6a 00                	push   $0x0
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 2c                	push   $0x2c
  8020d9:	e8 19 fa ff ff       	call   801af7 <syscall>
  8020de:	83 c4 18             	add    $0x18,%esp
  8020e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020e4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020e8:	75 07                	jne    8020f1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ef:	eb 05                	jmp    8020f6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f6:	c9                   	leave  
  8020f7:	c3                   	ret    

008020f8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020f8:	55                   	push   %ebp
  8020f9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	ff 75 08             	pushl  0x8(%ebp)
  802106:	6a 2d                	push   $0x2d
  802108:	e8 ea f9 ff ff       	call   801af7 <syscall>
  80210d:	83 c4 18             	add    $0x18,%esp
	return ;
  802110:	90                   	nop
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802117:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80211a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80211d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	6a 00                	push   $0x0
  802125:	53                   	push   %ebx
  802126:	51                   	push   %ecx
  802127:	52                   	push   %edx
  802128:	50                   	push   %eax
  802129:	6a 2e                	push   $0x2e
  80212b:	e8 c7 f9 ff ff       	call   801af7 <syscall>
  802130:	83 c4 18             	add    $0x18,%esp
}
  802133:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80213b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80213e:	8b 45 08             	mov    0x8(%ebp),%eax
  802141:	6a 00                	push   $0x0
  802143:	6a 00                	push   $0x0
  802145:	6a 00                	push   $0x0
  802147:	52                   	push   %edx
  802148:	50                   	push   %eax
  802149:	6a 2f                	push   $0x2f
  80214b:	e8 a7 f9 ff ff       	call   801af7 <syscall>
  802150:	83 c4 18             	add    $0x18,%esp
}
  802153:	c9                   	leave  
  802154:	c3                   	ret    

00802155 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802155:	55                   	push   %ebp
  802156:	89 e5                	mov    %esp,%ebp
  802158:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80215b:	83 ec 0c             	sub    $0xc,%esp
  80215e:	68 20 3c 80 00       	push   $0x803c20
  802163:	e8 3e e6 ff ff       	call   8007a6 <cprintf>
  802168:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80216b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802172:	83 ec 0c             	sub    $0xc,%esp
  802175:	68 4c 3c 80 00       	push   $0x803c4c
  80217a:	e8 27 e6 ff ff       	call   8007a6 <cprintf>
  80217f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802182:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802186:	a1 38 41 80 00       	mov    0x804138,%eax
  80218b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218e:	eb 56                	jmp    8021e6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802190:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802194:	74 1c                	je     8021b2 <print_mem_block_lists+0x5d>
  802196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802199:	8b 50 08             	mov    0x8(%eax),%edx
  80219c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80219f:	8b 48 08             	mov    0x8(%eax),%ecx
  8021a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a8:	01 c8                	add    %ecx,%eax
  8021aa:	39 c2                	cmp    %eax,%edx
  8021ac:	73 04                	jae    8021b2 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8021ae:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8021b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b5:	8b 50 08             	mov    0x8(%eax),%edx
  8021b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8021be:	01 c2                	add    %eax,%edx
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 40 08             	mov    0x8(%eax),%eax
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	52                   	push   %edx
  8021ca:	50                   	push   %eax
  8021cb:	68 61 3c 80 00       	push   $0x803c61
  8021d0:	e8 d1 e5 ff ff       	call   8007a6 <cprintf>
  8021d5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021de:	a1 40 41 80 00       	mov    0x804140,%eax
  8021e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ea:	74 07                	je     8021f3 <print_mem_block_lists+0x9e>
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	8b 00                	mov    (%eax),%eax
  8021f1:	eb 05                	jmp    8021f8 <print_mem_block_lists+0xa3>
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f8:	a3 40 41 80 00       	mov    %eax,0x804140
  8021fd:	a1 40 41 80 00       	mov    0x804140,%eax
  802202:	85 c0                	test   %eax,%eax
  802204:	75 8a                	jne    802190 <print_mem_block_lists+0x3b>
  802206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220a:	75 84                	jne    802190 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80220c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802210:	75 10                	jne    802222 <print_mem_block_lists+0xcd>
  802212:	83 ec 0c             	sub    $0xc,%esp
  802215:	68 70 3c 80 00       	push   $0x803c70
  80221a:	e8 87 e5 ff ff       	call   8007a6 <cprintf>
  80221f:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802222:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802229:	83 ec 0c             	sub    $0xc,%esp
  80222c:	68 94 3c 80 00       	push   $0x803c94
  802231:	e8 70 e5 ff ff       	call   8007a6 <cprintf>
  802236:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802239:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80223d:	a1 40 40 80 00       	mov    0x804040,%eax
  802242:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802245:	eb 56                	jmp    80229d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802247:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80224b:	74 1c                	je     802269 <print_mem_block_lists+0x114>
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 50 08             	mov    0x8(%eax),%edx
  802253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802256:	8b 48 08             	mov    0x8(%eax),%ecx
  802259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225c:	8b 40 0c             	mov    0xc(%eax),%eax
  80225f:	01 c8                	add    %ecx,%eax
  802261:	39 c2                	cmp    %eax,%edx
  802263:	73 04                	jae    802269 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802265:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	8b 50 08             	mov    0x8(%eax),%edx
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 40 0c             	mov    0xc(%eax),%eax
  802275:	01 c2                	add    %eax,%edx
  802277:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227a:	8b 40 08             	mov    0x8(%eax),%eax
  80227d:	83 ec 04             	sub    $0x4,%esp
  802280:	52                   	push   %edx
  802281:	50                   	push   %eax
  802282:	68 61 3c 80 00       	push   $0x803c61
  802287:	e8 1a e5 ff ff       	call   8007a6 <cprintf>
  80228c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802295:	a1 48 40 80 00       	mov    0x804048,%eax
  80229a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a1:	74 07                	je     8022aa <print_mem_block_lists+0x155>
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 00                	mov    (%eax),%eax
  8022a8:	eb 05                	jmp    8022af <print_mem_block_lists+0x15a>
  8022aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022af:	a3 48 40 80 00       	mov    %eax,0x804048
  8022b4:	a1 48 40 80 00       	mov    0x804048,%eax
  8022b9:	85 c0                	test   %eax,%eax
  8022bb:	75 8a                	jne    802247 <print_mem_block_lists+0xf2>
  8022bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c1:	75 84                	jne    802247 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022c3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022c7:	75 10                	jne    8022d9 <print_mem_block_lists+0x184>
  8022c9:	83 ec 0c             	sub    $0xc,%esp
  8022cc:	68 ac 3c 80 00       	push   $0x803cac
  8022d1:	e8 d0 e4 ff ff       	call   8007a6 <cprintf>
  8022d6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022d9:	83 ec 0c             	sub    $0xc,%esp
  8022dc:	68 20 3c 80 00       	push   $0x803c20
  8022e1:	e8 c0 e4 ff ff       	call   8007a6 <cprintf>
  8022e6:	83 c4 10             	add    $0x10,%esp

}
  8022e9:	90                   	nop
  8022ea:	c9                   	leave  
  8022eb:	c3                   	ret    

008022ec <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8022f2:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8022f9:	00 00 00 
  8022fc:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802303:	00 00 00 
  802306:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80230d:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802310:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802317:	e9 9e 00 00 00       	jmp    8023ba <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  80231c:	a1 50 40 80 00       	mov    0x804050,%eax
  802321:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802324:	c1 e2 04             	shl    $0x4,%edx
  802327:	01 d0                	add    %edx,%eax
  802329:	85 c0                	test   %eax,%eax
  80232b:	75 14                	jne    802341 <initialize_MemBlocksList+0x55>
  80232d:	83 ec 04             	sub    $0x4,%esp
  802330:	68 d4 3c 80 00       	push   $0x803cd4
  802335:	6a 3d                	push   $0x3d
  802337:	68 f7 3c 80 00       	push   $0x803cf7
  80233c:	e8 b1 e1 ff ff       	call   8004f2 <_panic>
  802341:	a1 50 40 80 00       	mov    0x804050,%eax
  802346:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802349:	c1 e2 04             	shl    $0x4,%edx
  80234c:	01 d0                	add    %edx,%eax
  80234e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802354:	89 10                	mov    %edx,(%eax)
  802356:	8b 00                	mov    (%eax),%eax
  802358:	85 c0                	test   %eax,%eax
  80235a:	74 18                	je     802374 <initialize_MemBlocksList+0x88>
  80235c:	a1 48 41 80 00       	mov    0x804148,%eax
  802361:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802367:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80236a:	c1 e1 04             	shl    $0x4,%ecx
  80236d:	01 ca                	add    %ecx,%edx
  80236f:	89 50 04             	mov    %edx,0x4(%eax)
  802372:	eb 12                	jmp    802386 <initialize_MemBlocksList+0x9a>
  802374:	a1 50 40 80 00       	mov    0x804050,%eax
  802379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237c:	c1 e2 04             	shl    $0x4,%edx
  80237f:	01 d0                	add    %edx,%eax
  802381:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802386:	a1 50 40 80 00       	mov    0x804050,%eax
  80238b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80238e:	c1 e2 04             	shl    $0x4,%edx
  802391:	01 d0                	add    %edx,%eax
  802393:	a3 48 41 80 00       	mov    %eax,0x804148
  802398:	a1 50 40 80 00       	mov    0x804050,%eax
  80239d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a0:	c1 e2 04             	shl    $0x4,%edx
  8023a3:	01 d0                	add    %edx,%eax
  8023a5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ac:	a1 54 41 80 00       	mov    0x804154,%eax
  8023b1:	40                   	inc    %eax
  8023b2:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8023b7:	ff 45 f4             	incl   -0xc(%ebp)
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c0:	0f 82 56 ff ff ff    	jb     80231c <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8023c6:	90                   	nop
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	8b 00                	mov    (%eax),%eax
  8023d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8023d7:	eb 18                	jmp    8023f1 <find_block+0x28>

		if(tmp->sva == va){
  8023d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023dc:	8b 40 08             	mov    0x8(%eax),%eax
  8023df:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023e2:	75 05                	jne    8023e9 <find_block+0x20>
			return tmp ;
  8023e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023e7:	eb 11                	jmp    8023fa <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8023e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023ec:	8b 00                	mov    (%eax),%eax
  8023ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8023f1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023f5:	75 e2                	jne    8023d9 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8023f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8023fa:	c9                   	leave  
  8023fb:	c3                   	ret    

008023fc <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023fc:	55                   	push   %ebp
  8023fd:	89 e5                	mov    %esp,%ebp
  8023ff:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802402:	a1 40 40 80 00       	mov    0x804040,%eax
  802407:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  80240a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80240f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802412:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802416:	75 65                	jne    80247d <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802418:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80241c:	75 14                	jne    802432 <insert_sorted_allocList+0x36>
  80241e:	83 ec 04             	sub    $0x4,%esp
  802421:	68 d4 3c 80 00       	push   $0x803cd4
  802426:	6a 62                	push   $0x62
  802428:	68 f7 3c 80 00       	push   $0x803cf7
  80242d:	e8 c0 e0 ff ff       	call   8004f2 <_panic>
  802432:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	89 10                	mov    %edx,(%eax)
  80243d:	8b 45 08             	mov    0x8(%ebp),%eax
  802440:	8b 00                	mov    (%eax),%eax
  802442:	85 c0                	test   %eax,%eax
  802444:	74 0d                	je     802453 <insert_sorted_allocList+0x57>
  802446:	a1 40 40 80 00       	mov    0x804040,%eax
  80244b:	8b 55 08             	mov    0x8(%ebp),%edx
  80244e:	89 50 04             	mov    %edx,0x4(%eax)
  802451:	eb 08                	jmp    80245b <insert_sorted_allocList+0x5f>
  802453:	8b 45 08             	mov    0x8(%ebp),%eax
  802456:	a3 44 40 80 00       	mov    %eax,0x804044
  80245b:	8b 45 08             	mov    0x8(%ebp),%eax
  80245e:	a3 40 40 80 00       	mov    %eax,0x804040
  802463:	8b 45 08             	mov    0x8(%ebp),%eax
  802466:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80246d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802472:	40                   	inc    %eax
  802473:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802478:	e9 14 01 00 00       	jmp    802591 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80247d:	8b 45 08             	mov    0x8(%ebp),%eax
  802480:	8b 50 08             	mov    0x8(%eax),%edx
  802483:	a1 44 40 80 00       	mov    0x804044,%eax
  802488:	8b 40 08             	mov    0x8(%eax),%eax
  80248b:	39 c2                	cmp    %eax,%edx
  80248d:	76 65                	jbe    8024f4 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80248f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802493:	75 14                	jne    8024a9 <insert_sorted_allocList+0xad>
  802495:	83 ec 04             	sub    $0x4,%esp
  802498:	68 10 3d 80 00       	push   $0x803d10
  80249d:	6a 64                	push   $0x64
  80249f:	68 f7 3c 80 00       	push   $0x803cf7
  8024a4:	e8 49 e0 ff ff       	call   8004f2 <_panic>
  8024a9:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	89 50 04             	mov    %edx,0x4(%eax)
  8024b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b8:	8b 40 04             	mov    0x4(%eax),%eax
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	74 0c                	je     8024cb <insert_sorted_allocList+0xcf>
  8024bf:	a1 44 40 80 00       	mov    0x804044,%eax
  8024c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c7:	89 10                	mov    %edx,(%eax)
  8024c9:	eb 08                	jmp    8024d3 <insert_sorted_allocList+0xd7>
  8024cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ce:	a3 40 40 80 00       	mov    %eax,0x804040
  8024d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d6:	a3 44 40 80 00       	mov    %eax,0x804044
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024e9:	40                   	inc    %eax
  8024ea:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8024ef:	e9 9d 00 00 00       	jmp    802591 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8024f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8024fb:	e9 85 00 00 00       	jmp    802585 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802500:	8b 45 08             	mov    0x8(%ebp),%eax
  802503:	8b 50 08             	mov    0x8(%eax),%edx
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 40 08             	mov    0x8(%eax),%eax
  80250c:	39 c2                	cmp    %eax,%edx
  80250e:	73 6a                	jae    80257a <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802514:	74 06                	je     80251c <insert_sorted_allocList+0x120>
  802516:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80251a:	75 14                	jne    802530 <insert_sorted_allocList+0x134>
  80251c:	83 ec 04             	sub    $0x4,%esp
  80251f:	68 34 3d 80 00       	push   $0x803d34
  802524:	6a 6b                	push   $0x6b
  802526:	68 f7 3c 80 00       	push   $0x803cf7
  80252b:	e8 c2 df ff ff       	call   8004f2 <_panic>
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 50 04             	mov    0x4(%eax),%edx
  802536:	8b 45 08             	mov    0x8(%ebp),%eax
  802539:	89 50 04             	mov    %edx,0x4(%eax)
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802542:	89 10                	mov    %edx,(%eax)
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 40 04             	mov    0x4(%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 0d                	je     80255b <insert_sorted_allocList+0x15f>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 40 04             	mov    0x4(%eax),%eax
  802554:	8b 55 08             	mov    0x8(%ebp),%edx
  802557:	89 10                	mov    %edx,(%eax)
  802559:	eb 08                	jmp    802563 <insert_sorted_allocList+0x167>
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	a3 40 40 80 00       	mov    %eax,0x804040
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 55 08             	mov    0x8(%ebp),%edx
  802569:	89 50 04             	mov    %edx,0x4(%eax)
  80256c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802571:	40                   	inc    %eax
  802572:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802577:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802578:	eb 17                	jmp    802591 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802582:	ff 45 f0             	incl   -0x10(%ebp)
  802585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802588:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80258b:	0f 8c 6f ff ff ff    	jl     802500 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802591:	90                   	nop
  802592:	c9                   	leave  
  802593:	c3                   	ret    

00802594 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802594:	55                   	push   %ebp
  802595:	89 e5                	mov    %esp,%ebp
  802597:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80259a:	a1 38 41 80 00       	mov    0x804138,%eax
  80259f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8025a2:	e9 7c 01 00 00       	jmp    802723 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ad:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b0:	0f 86 cf 00 00 00    	jbe    802685 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8025b6:	a1 48 41 80 00       	mov    0x804148,%eax
  8025bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8025be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8025c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ca:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 50 08             	mov    0x8(%eax),%edx
  8025d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d6:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025df:	2b 45 08             	sub    0x8(%ebp),%eax
  8025e2:	89 c2                	mov    %eax,%edx
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8025ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ed:	8b 50 08             	mov    0x8(%eax),%edx
  8025f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f3:	01 c2                	add    %eax,%edx
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8025fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025ff:	75 17                	jne    802618 <alloc_block_FF+0x84>
  802601:	83 ec 04             	sub    $0x4,%esp
  802604:	68 69 3d 80 00       	push   $0x803d69
  802609:	68 83 00 00 00       	push   $0x83
  80260e:	68 f7 3c 80 00       	push   $0x803cf7
  802613:	e8 da de ff ff       	call   8004f2 <_panic>
  802618:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261b:	8b 00                	mov    (%eax),%eax
  80261d:	85 c0                	test   %eax,%eax
  80261f:	74 10                	je     802631 <alloc_block_FF+0x9d>
  802621:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802624:	8b 00                	mov    (%eax),%eax
  802626:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802629:	8b 52 04             	mov    0x4(%edx),%edx
  80262c:	89 50 04             	mov    %edx,0x4(%eax)
  80262f:	eb 0b                	jmp    80263c <alloc_block_FF+0xa8>
  802631:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802634:	8b 40 04             	mov    0x4(%eax),%eax
  802637:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80263c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263f:	8b 40 04             	mov    0x4(%eax),%eax
  802642:	85 c0                	test   %eax,%eax
  802644:	74 0f                	je     802655 <alloc_block_FF+0xc1>
  802646:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802649:	8b 40 04             	mov    0x4(%eax),%eax
  80264c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80264f:	8b 12                	mov    (%edx),%edx
  802651:	89 10                	mov    %edx,(%eax)
  802653:	eb 0a                	jmp    80265f <alloc_block_FF+0xcb>
  802655:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802658:	8b 00                	mov    (%eax),%eax
  80265a:	a3 48 41 80 00       	mov    %eax,0x804148
  80265f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802662:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802668:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802672:	a1 54 41 80 00       	mov    0x804154,%eax
  802677:	48                   	dec    %eax
  802678:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  80267d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802680:	e9 ad 00 00 00       	jmp    802732 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802688:	8b 40 0c             	mov    0xc(%eax),%eax
  80268b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80268e:	0f 85 87 00 00 00    	jne    80271b <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802698:	75 17                	jne    8026b1 <alloc_block_FF+0x11d>
  80269a:	83 ec 04             	sub    $0x4,%esp
  80269d:	68 69 3d 80 00       	push   $0x803d69
  8026a2:	68 87 00 00 00       	push   $0x87
  8026a7:	68 f7 3c 80 00       	push   $0x803cf7
  8026ac:	e8 41 de ff ff       	call   8004f2 <_panic>
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 00                	mov    (%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 10                	je     8026ca <alloc_block_FF+0x136>
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	8b 00                	mov    (%eax),%eax
  8026bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026c2:	8b 52 04             	mov    0x4(%edx),%edx
  8026c5:	89 50 04             	mov    %edx,0x4(%eax)
  8026c8:	eb 0b                	jmp    8026d5 <alloc_block_FF+0x141>
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 40 04             	mov    0x4(%eax),%eax
  8026d0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 04             	mov    0x4(%eax),%eax
  8026db:	85 c0                	test   %eax,%eax
  8026dd:	74 0f                	je     8026ee <alloc_block_FF+0x15a>
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 40 04             	mov    0x4(%eax),%eax
  8026e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026e8:	8b 12                	mov    (%edx),%edx
  8026ea:	89 10                	mov    %edx,(%eax)
  8026ec:	eb 0a                	jmp    8026f8 <alloc_block_FF+0x164>
  8026ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f1:	8b 00                	mov    (%eax),%eax
  8026f3:	a3 38 41 80 00       	mov    %eax,0x804138
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80270b:	a1 44 41 80 00       	mov    0x804144,%eax
  802710:	48                   	dec    %eax
  802711:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  802716:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802719:	eb 17                	jmp    802732 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  80271b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271e:	8b 00                	mov    (%eax),%eax
  802720:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802727:	0f 85 7a fe ff ff    	jne    8025a7 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  80272d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802732:	c9                   	leave  
  802733:	c3                   	ret    

00802734 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802734:	55                   	push   %ebp
  802735:	89 e5                	mov    %esp,%ebp
  802737:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  80273a:	a1 38 41 80 00       	mov    0x804138,%eax
  80273f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802742:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802749:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802750:	a1 38 41 80 00       	mov    0x804138,%eax
  802755:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802758:	e9 d0 00 00 00       	jmp    80282d <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80275d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802760:	8b 40 0c             	mov    0xc(%eax),%eax
  802763:	3b 45 08             	cmp    0x8(%ebp),%eax
  802766:	0f 82 b8 00 00 00    	jb     802824 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80276c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276f:	8b 40 0c             	mov    0xc(%eax),%eax
  802772:	2b 45 08             	sub    0x8(%ebp),%eax
  802775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80277b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80277e:	0f 83 a1 00 00 00    	jae    802825 <alloc_block_BF+0xf1>
				differsize = differance ;
  802784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802787:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802790:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802794:	0f 85 8b 00 00 00    	jne    802825 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80279a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279e:	75 17                	jne    8027b7 <alloc_block_BF+0x83>
  8027a0:	83 ec 04             	sub    $0x4,%esp
  8027a3:	68 69 3d 80 00       	push   $0x803d69
  8027a8:	68 a0 00 00 00       	push   $0xa0
  8027ad:	68 f7 3c 80 00       	push   $0x803cf7
  8027b2:	e8 3b dd ff ff       	call   8004f2 <_panic>
  8027b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ba:	8b 00                	mov    (%eax),%eax
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	74 10                	je     8027d0 <alloc_block_BF+0x9c>
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 00                	mov    (%eax),%eax
  8027c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c8:	8b 52 04             	mov    0x4(%edx),%edx
  8027cb:	89 50 04             	mov    %edx,0x4(%eax)
  8027ce:	eb 0b                	jmp    8027db <alloc_block_BF+0xa7>
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 40 04             	mov    0x4(%eax),%eax
  8027d6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 40 04             	mov    0x4(%eax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	74 0f                	je     8027f4 <alloc_block_BF+0xc0>
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 40 04             	mov    0x4(%eax),%eax
  8027eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ee:	8b 12                	mov    (%edx),%edx
  8027f0:	89 10                	mov    %edx,(%eax)
  8027f2:	eb 0a                	jmp    8027fe <alloc_block_BF+0xca>
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	8b 00                	mov    (%eax),%eax
  8027f9:	a3 38 41 80 00       	mov    %eax,0x804138
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802807:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802811:	a1 44 41 80 00       	mov    0x804144,%eax
  802816:	48                   	dec    %eax
  802817:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	e9 0c 01 00 00       	jmp    802930 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802824:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802825:	a1 40 41 80 00       	mov    0x804140,%eax
  80282a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80282d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802831:	74 07                	je     80283a <alloc_block_BF+0x106>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 00                	mov    (%eax),%eax
  802838:	eb 05                	jmp    80283f <alloc_block_BF+0x10b>
  80283a:	b8 00 00 00 00       	mov    $0x0,%eax
  80283f:	a3 40 41 80 00       	mov    %eax,0x804140
  802844:	a1 40 41 80 00       	mov    0x804140,%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	0f 85 0c ff ff ff    	jne    80275d <alloc_block_BF+0x29>
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	0f 85 02 ff ff ff    	jne    80275d <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80285b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80285f:	0f 84 c6 00 00 00    	je     80292b <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802865:	a1 48 41 80 00       	mov    0x804148,%eax
  80286a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80286d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802870:	8b 55 08             	mov    0x8(%ebp),%edx
  802873:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802876:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802879:	8b 50 08             	mov    0x8(%eax),%edx
  80287c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80287f:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	8b 40 0c             	mov    0xc(%eax),%eax
  802888:	2b 45 08             	sub    0x8(%ebp),%eax
  80288b:	89 c2                	mov    %eax,%edx
  80288d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802890:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802896:	8b 50 08             	mov    0x8(%eax),%edx
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	01 c2                	add    %eax,%edx
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  8028a4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8028a8:	75 17                	jne    8028c1 <alloc_block_BF+0x18d>
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	68 69 3d 80 00       	push   $0x803d69
  8028b2:	68 af 00 00 00       	push   $0xaf
  8028b7:	68 f7 3c 80 00       	push   $0x803cf7
  8028bc:	e8 31 dc ff ff       	call   8004f2 <_panic>
  8028c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	74 10                	je     8028da <alloc_block_BF+0x1a6>
  8028ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028cd:	8b 00                	mov    (%eax),%eax
  8028cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028d2:	8b 52 04             	mov    0x4(%edx),%edx
  8028d5:	89 50 04             	mov    %edx,0x4(%eax)
  8028d8:	eb 0b                	jmp    8028e5 <alloc_block_BF+0x1b1>
  8028da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028dd:	8b 40 04             	mov    0x4(%eax),%eax
  8028e0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e8:	8b 40 04             	mov    0x4(%eax),%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	74 0f                	je     8028fe <alloc_block_BF+0x1ca>
  8028ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028f8:	8b 12                	mov    (%edx),%edx
  8028fa:	89 10                	mov    %edx,(%eax)
  8028fc:	eb 0a                	jmp    802908 <alloc_block_BF+0x1d4>
  8028fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	a3 48 41 80 00       	mov    %eax,0x804148
  802908:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802911:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802914:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291b:	a1 54 41 80 00       	mov    0x804154,%eax
  802920:	48                   	dec    %eax
  802921:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  802926:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802929:	eb 05                	jmp    802930 <alloc_block_BF+0x1fc>
	}

	return NULL;
  80292b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802930:	c9                   	leave  
  802931:	c3                   	ret    

00802932 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802932:	55                   	push   %ebp
  802933:	89 e5                	mov    %esp,%ebp
  802935:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802938:	a1 38 41 80 00       	mov    0x804138,%eax
  80293d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802940:	e9 7c 01 00 00       	jmp    802ac1 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 40 0c             	mov    0xc(%eax),%eax
  80294b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80294e:	0f 86 cf 00 00 00    	jbe    802a23 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802954:	a1 48 41 80 00       	mov    0x804148,%eax
  802959:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  80295c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802965:	8b 55 08             	mov    0x8(%ebp),%edx
  802968:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	8b 50 08             	mov    0x8(%eax),%edx
  802971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802974:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	8b 40 0c             	mov    0xc(%eax),%eax
  80297d:	2b 45 08             	sub    0x8(%ebp),%eax
  802980:	89 c2                	mov    %eax,%edx
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 50 08             	mov    0x8(%eax),%edx
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	01 c2                	add    %eax,%edx
  802993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802996:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802999:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80299d:	75 17                	jne    8029b6 <alloc_block_NF+0x84>
  80299f:	83 ec 04             	sub    $0x4,%esp
  8029a2:	68 69 3d 80 00       	push   $0x803d69
  8029a7:	68 c4 00 00 00       	push   $0xc4
  8029ac:	68 f7 3c 80 00       	push   $0x803cf7
  8029b1:	e8 3c db ff ff       	call   8004f2 <_panic>
  8029b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b9:	8b 00                	mov    (%eax),%eax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	74 10                	je     8029cf <alloc_block_NF+0x9d>
  8029bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c2:	8b 00                	mov    (%eax),%eax
  8029c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029c7:	8b 52 04             	mov    0x4(%edx),%edx
  8029ca:	89 50 04             	mov    %edx,0x4(%eax)
  8029cd:	eb 0b                	jmp    8029da <alloc_block_NF+0xa8>
  8029cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029d2:	8b 40 04             	mov    0x4(%eax),%eax
  8029d5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029dd:	8b 40 04             	mov    0x4(%eax),%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	74 0f                	je     8029f3 <alloc_block_NF+0xc1>
  8029e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ed:	8b 12                	mov    (%edx),%edx
  8029ef:	89 10                	mov    %edx,(%eax)
  8029f1:	eb 0a                	jmp    8029fd <alloc_block_NF+0xcb>
  8029f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	a3 48 41 80 00       	mov    %eax,0x804148
  8029fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a10:	a1 54 41 80 00       	mov    0x804154,%eax
  802a15:	48                   	dec    %eax
  802a16:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  802a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1e:	e9 ad 00 00 00       	jmp    802ad0 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 40 0c             	mov    0xc(%eax),%eax
  802a29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a2c:	0f 85 87 00 00 00    	jne    802ab9 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a36:	75 17                	jne    802a4f <alloc_block_NF+0x11d>
  802a38:	83 ec 04             	sub    $0x4,%esp
  802a3b:	68 69 3d 80 00       	push   $0x803d69
  802a40:	68 c8 00 00 00       	push   $0xc8
  802a45:	68 f7 3c 80 00       	push   $0x803cf7
  802a4a:	e8 a3 da ff ff       	call   8004f2 <_panic>
  802a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a52:	8b 00                	mov    (%eax),%eax
  802a54:	85 c0                	test   %eax,%eax
  802a56:	74 10                	je     802a68 <alloc_block_NF+0x136>
  802a58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5b:	8b 00                	mov    (%eax),%eax
  802a5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a60:	8b 52 04             	mov    0x4(%edx),%edx
  802a63:	89 50 04             	mov    %edx,0x4(%eax)
  802a66:	eb 0b                	jmp    802a73 <alloc_block_NF+0x141>
  802a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6b:	8b 40 04             	mov    0x4(%eax),%eax
  802a6e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 40 04             	mov    0x4(%eax),%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 0f                	je     802a8c <alloc_block_NF+0x15a>
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a86:	8b 12                	mov    (%edx),%edx
  802a88:	89 10                	mov    %edx,(%eax)
  802a8a:	eb 0a                	jmp    802a96 <alloc_block_NF+0x164>
  802a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8f:	8b 00                	mov    (%eax),%eax
  802a91:	a3 38 41 80 00       	mov    %eax,0x804138
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa9:	a1 44 41 80 00       	mov    0x804144,%eax
  802aae:	48                   	dec    %eax
  802aaf:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab7:	eb 17                	jmp    802ad0 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802ab9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac5:	0f 85 7a fe ff ff    	jne    802945 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802acb:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802ad0:	c9                   	leave  
  802ad1:	c3                   	ret    

00802ad2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ad2:	55                   	push   %ebp
  802ad3:	89 e5                	mov    %esp,%ebp
  802ad5:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802ad8:	a1 38 41 80 00       	mov    0x804138,%eax
  802add:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802ae0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802ae8:	a1 44 41 80 00       	mov    0x804144,%eax
  802aed:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802af0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802af4:	75 68                	jne    802b5e <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802af6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802afa:	75 17                	jne    802b13 <insert_sorted_with_merge_freeList+0x41>
  802afc:	83 ec 04             	sub    $0x4,%esp
  802aff:	68 d4 3c 80 00       	push   $0x803cd4
  802b04:	68 da 00 00 00       	push   $0xda
  802b09:	68 f7 3c 80 00       	push   $0x803cf7
  802b0e:	e8 df d9 ff ff       	call   8004f2 <_panic>
  802b13:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	89 10                	mov    %edx,(%eax)
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	8b 00                	mov    (%eax),%eax
  802b23:	85 c0                	test   %eax,%eax
  802b25:	74 0d                	je     802b34 <insert_sorted_with_merge_freeList+0x62>
  802b27:	a1 38 41 80 00       	mov    0x804138,%eax
  802b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2f:	89 50 04             	mov    %edx,0x4(%eax)
  802b32:	eb 08                	jmp    802b3c <insert_sorted_with_merge_freeList+0x6a>
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	a3 38 41 80 00       	mov    %eax,0x804138
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b4e:	a1 44 41 80 00       	mov    0x804144,%eax
  802b53:	40                   	inc    %eax
  802b54:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802b59:	e9 49 07 00 00       	jmp    8032a7 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b61:	8b 50 08             	mov    0x8(%eax),%edx
  802b64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b67:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6a:	01 c2                	add    %eax,%edx
  802b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6f:	8b 40 08             	mov    0x8(%eax),%eax
  802b72:	39 c2                	cmp    %eax,%edx
  802b74:	73 77                	jae    802bed <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	75 6e                	jne    802bed <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802b7f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b83:	74 68                	je     802bed <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802b85:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b89:	75 17                	jne    802ba2 <insert_sorted_with_merge_freeList+0xd0>
  802b8b:	83 ec 04             	sub    $0x4,%esp
  802b8e:	68 10 3d 80 00       	push   $0x803d10
  802b93:	68 e0 00 00 00       	push   $0xe0
  802b98:	68 f7 3c 80 00       	push   $0x803cf7
  802b9d:	e8 50 d9 ff ff       	call   8004f2 <_panic>
  802ba2:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	89 50 04             	mov    %edx,0x4(%eax)
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	8b 40 04             	mov    0x4(%eax),%eax
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	74 0c                	je     802bc4 <insert_sorted_with_merge_freeList+0xf2>
  802bb8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc0:	89 10                	mov    %edx,(%eax)
  802bc2:	eb 08                	jmp    802bcc <insert_sorted_with_merge_freeList+0xfa>
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	a3 38 41 80 00       	mov    %eax,0x804138
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bdd:	a1 44 41 80 00       	mov    0x804144,%eax
  802be2:	40                   	inc    %eax
  802be3:	a3 44 41 80 00       	mov    %eax,0x804144
  802be8:	e9 ba 06 00 00       	jmp    8032a7 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802bed:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf0:	8b 50 0c             	mov    0xc(%eax),%edx
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	8b 40 08             	mov    0x8(%eax),%eax
  802bf9:	01 c2                	add    %eax,%edx
  802bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfe:	8b 40 08             	mov    0x8(%eax),%eax
  802c01:	39 c2                	cmp    %eax,%edx
  802c03:	73 78                	jae    802c7d <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c08:	8b 40 04             	mov    0x4(%eax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	75 6e                	jne    802c7d <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802c0f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c13:	74 68                	je     802c7d <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802c15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c19:	75 17                	jne    802c32 <insert_sorted_with_merge_freeList+0x160>
  802c1b:	83 ec 04             	sub    $0x4,%esp
  802c1e:	68 d4 3c 80 00       	push   $0x803cd4
  802c23:	68 e6 00 00 00       	push   $0xe6
  802c28:	68 f7 3c 80 00       	push   $0x803cf7
  802c2d:	e8 c0 d8 ff ff       	call   8004f2 <_panic>
  802c32:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	89 10                	mov    %edx,(%eax)
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	8b 00                	mov    (%eax),%eax
  802c42:	85 c0                	test   %eax,%eax
  802c44:	74 0d                	je     802c53 <insert_sorted_with_merge_freeList+0x181>
  802c46:	a1 38 41 80 00       	mov    0x804138,%eax
  802c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4e:	89 50 04             	mov    %edx,0x4(%eax)
  802c51:	eb 08                	jmp    802c5b <insert_sorted_with_merge_freeList+0x189>
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	a3 38 41 80 00       	mov    %eax,0x804138
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6d:	a1 44 41 80 00       	mov    0x804144,%eax
  802c72:	40                   	inc    %eax
  802c73:	a3 44 41 80 00       	mov    %eax,0x804144
  802c78:	e9 2a 06 00 00       	jmp    8032a7 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802c7d:	a1 38 41 80 00       	mov    0x804138,%eax
  802c82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c85:	e9 ed 05 00 00       	jmp    803277 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 00                	mov    (%eax),%eax
  802c8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802c92:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c96:	0f 84 a7 00 00 00    	je     802d43 <insert_sorted_with_merge_freeList+0x271>
  802c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9f:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 08             	mov    0x8(%eax),%eax
  802ca8:	01 c2                	add    %eax,%edx
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	8b 40 08             	mov    0x8(%eax),%eax
  802cb0:	39 c2                	cmp    %eax,%edx
  802cb2:	0f 83 8b 00 00 00    	jae    802d43 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	8b 50 0c             	mov    0xc(%eax),%edx
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	8b 40 08             	mov    0x8(%eax),%eax
  802cc4:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802cc6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc9:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802ccc:	39 c2                	cmp    %eax,%edx
  802cce:	73 73                	jae    802d43 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802cd0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd4:	74 06                	je     802cdc <insert_sorted_with_merge_freeList+0x20a>
  802cd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cda:	75 17                	jne    802cf3 <insert_sorted_with_merge_freeList+0x221>
  802cdc:	83 ec 04             	sub    $0x4,%esp
  802cdf:	68 88 3d 80 00       	push   $0x803d88
  802ce4:	68 f0 00 00 00       	push   $0xf0
  802ce9:	68 f7 3c 80 00       	push   $0x803cf7
  802cee:	e8 ff d7 ff ff       	call   8004f2 <_panic>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 10                	mov    (%eax),%edx
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	89 10                	mov    %edx,(%eax)
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	8b 00                	mov    (%eax),%eax
  802d02:	85 c0                	test   %eax,%eax
  802d04:	74 0b                	je     802d11 <insert_sorted_with_merge_freeList+0x23f>
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	8b 00                	mov    (%eax),%eax
  802d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0e:	89 50 04             	mov    %edx,0x4(%eax)
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 55 08             	mov    0x8(%ebp),%edx
  802d17:	89 10                	mov    %edx,(%eax)
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d1f:	89 50 04             	mov    %edx,0x4(%eax)
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	8b 00                	mov    (%eax),%eax
  802d27:	85 c0                	test   %eax,%eax
  802d29:	75 08                	jne    802d33 <insert_sorted_with_merge_freeList+0x261>
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d33:	a1 44 41 80 00       	mov    0x804144,%eax
  802d38:	40                   	inc    %eax
  802d39:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802d3e:	e9 64 05 00 00       	jmp    8032a7 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802d43:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d48:	8b 50 0c             	mov    0xc(%eax),%edx
  802d4b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d50:	8b 40 08             	mov    0x8(%eax),%eax
  802d53:	01 c2                	add    %eax,%edx
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 40 08             	mov    0x8(%eax),%eax
  802d5b:	39 c2                	cmp    %eax,%edx
  802d5d:	0f 85 b1 00 00 00    	jne    802e14 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802d63:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d68:	85 c0                	test   %eax,%eax
  802d6a:	0f 84 a4 00 00 00    	je     802e14 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802d70:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d75:	8b 00                	mov    (%eax),%eax
  802d77:	85 c0                	test   %eax,%eax
  802d79:	0f 85 95 00 00 00    	jne    802e14 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802d7f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d84:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d8a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d90:	8b 52 0c             	mov    0xc(%edx),%edx
  802d93:	01 ca                	add    %ecx,%edx
  802d95:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802dac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db0:	75 17                	jne    802dc9 <insert_sorted_with_merge_freeList+0x2f7>
  802db2:	83 ec 04             	sub    $0x4,%esp
  802db5:	68 d4 3c 80 00       	push   $0x803cd4
  802dba:	68 ff 00 00 00       	push   $0xff
  802dbf:	68 f7 3c 80 00       	push   $0x803cf7
  802dc4:	e8 29 d7 ff ff       	call   8004f2 <_panic>
  802dc9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	89 10                	mov    %edx,(%eax)
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 0d                	je     802dea <insert_sorted_with_merge_freeList+0x318>
  802ddd:	a1 48 41 80 00       	mov    0x804148,%eax
  802de2:	8b 55 08             	mov    0x8(%ebp),%edx
  802de5:	89 50 04             	mov    %edx,0x4(%eax)
  802de8:	eb 08                	jmp    802df2 <insert_sorted_with_merge_freeList+0x320>
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	a3 48 41 80 00       	mov    %eax,0x804148
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e04:	a1 54 41 80 00       	mov    0x804154,%eax
  802e09:	40                   	inc    %eax
  802e0a:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802e0f:	e9 93 04 00 00       	jmp    8032a7 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 50 08             	mov    0x8(%eax),%edx
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e20:	01 c2                	add    %eax,%edx
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	8b 40 08             	mov    0x8(%eax),%eax
  802e28:	39 c2                	cmp    %eax,%edx
  802e2a:	0f 85 ae 00 00 00    	jne    802ede <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	8b 50 0c             	mov    0xc(%eax),%edx
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	8b 40 08             	mov    0x8(%eax),%eax
  802e3c:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802e46:	39 c2                	cmp    %eax,%edx
  802e48:	0f 84 90 00 00 00    	je     802ede <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	8b 50 0c             	mov    0xc(%eax),%edx
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5a:	01 c2                	add    %eax,%edx
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e62:	8b 45 08             	mov    0x8(%ebp),%eax
  802e65:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e76:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e7a:	75 17                	jne    802e93 <insert_sorted_with_merge_freeList+0x3c1>
  802e7c:	83 ec 04             	sub    $0x4,%esp
  802e7f:	68 d4 3c 80 00       	push   $0x803cd4
  802e84:	68 0b 01 00 00       	push   $0x10b
  802e89:	68 f7 3c 80 00       	push   $0x803cf7
  802e8e:	e8 5f d6 ff ff       	call   8004f2 <_panic>
  802e93:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	89 10                	mov    %edx,(%eax)
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	85 c0                	test   %eax,%eax
  802ea5:	74 0d                	je     802eb4 <insert_sorted_with_merge_freeList+0x3e2>
  802ea7:	a1 48 41 80 00       	mov    0x804148,%eax
  802eac:	8b 55 08             	mov    0x8(%ebp),%edx
  802eaf:	89 50 04             	mov    %edx,0x4(%eax)
  802eb2:	eb 08                	jmp    802ebc <insert_sorted_with_merge_freeList+0x3ea>
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	a3 48 41 80 00       	mov    %eax,0x804148
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ece:	a1 54 41 80 00       	mov    0x804154,%eax
  802ed3:	40                   	inc    %eax
  802ed4:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802ed9:	e9 c9 03 00 00       	jmp    8032a7 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	8b 40 08             	mov    0x8(%eax),%eax
  802eea:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ef2:	39 c2                	cmp    %eax,%edx
  802ef4:	0f 85 bb 00 00 00    	jne    802fb5 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802efa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802efe:	0f 84 b1 00 00 00    	je     802fb5 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 40 04             	mov    0x4(%eax),%eax
  802f0a:	85 c0                	test   %eax,%eax
  802f0c:	0f 85 a3 00 00 00    	jne    802fb5 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802f12:	a1 38 41 80 00       	mov    0x804138,%eax
  802f17:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1a:	8b 52 08             	mov    0x8(%edx),%edx
  802f1d:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802f20:	a1 38 41 80 00       	mov    0x804138,%eax
  802f25:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802f2b:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f31:	8b 52 0c             	mov    0xc(%edx),%edx
  802f34:	01 ca                	add    %ecx,%edx
  802f36:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802f39:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f4d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f51:	75 17                	jne    802f6a <insert_sorted_with_merge_freeList+0x498>
  802f53:	83 ec 04             	sub    $0x4,%esp
  802f56:	68 d4 3c 80 00       	push   $0x803cd4
  802f5b:	68 17 01 00 00       	push   $0x117
  802f60:	68 f7 3c 80 00       	push   $0x803cf7
  802f65:	e8 88 d5 ff ff       	call   8004f2 <_panic>
  802f6a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f70:	8b 45 08             	mov    0x8(%ebp),%eax
  802f73:	89 10                	mov    %edx,(%eax)
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	8b 00                	mov    (%eax),%eax
  802f7a:	85 c0                	test   %eax,%eax
  802f7c:	74 0d                	je     802f8b <insert_sorted_with_merge_freeList+0x4b9>
  802f7e:	a1 48 41 80 00       	mov    0x804148,%eax
  802f83:	8b 55 08             	mov    0x8(%ebp),%edx
  802f86:	89 50 04             	mov    %edx,0x4(%eax)
  802f89:	eb 08                	jmp    802f93 <insert_sorted_with_merge_freeList+0x4c1>
  802f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	a3 48 41 80 00       	mov    %eax,0x804148
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa5:	a1 54 41 80 00       	mov    0x804154,%eax
  802faa:	40                   	inc    %eax
  802fab:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802fb0:	e9 f2 02 00 00       	jmp    8032a7 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	8b 50 08             	mov    0x8(%eax),%edx
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc1:	01 c2                	add    %eax,%edx
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 40 08             	mov    0x8(%eax),%eax
  802fc9:	39 c2                	cmp    %eax,%edx
  802fcb:	0f 85 be 00 00 00    	jne    80308f <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802fd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd4:	8b 40 04             	mov    0x4(%eax),%eax
  802fd7:	8b 50 08             	mov    0x8(%eax),%edx
  802fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdd:	8b 40 04             	mov    0x4(%eax),%eax
  802fe0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe3:	01 c2                	add    %eax,%edx
  802fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe8:	8b 40 08             	mov    0x8(%eax),%eax
  802feb:	39 c2                	cmp    %eax,%edx
  802fed:	0f 84 9c 00 00 00    	je     80308f <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	8b 50 08             	mov    0x8(%eax),%edx
  802ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffc:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 50 0c             	mov    0xc(%eax),%edx
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	8b 40 0c             	mov    0xc(%eax),%eax
  80300b:	01 c2                	add    %eax,%edx
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803027:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80302b:	75 17                	jne    803044 <insert_sorted_with_merge_freeList+0x572>
  80302d:	83 ec 04             	sub    $0x4,%esp
  803030:	68 d4 3c 80 00       	push   $0x803cd4
  803035:	68 26 01 00 00       	push   $0x126
  80303a:	68 f7 3c 80 00       	push   $0x803cf7
  80303f:	e8 ae d4 ff ff       	call   8004f2 <_panic>
  803044:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80304a:	8b 45 08             	mov    0x8(%ebp),%eax
  80304d:	89 10                	mov    %edx,(%eax)
  80304f:	8b 45 08             	mov    0x8(%ebp),%eax
  803052:	8b 00                	mov    (%eax),%eax
  803054:	85 c0                	test   %eax,%eax
  803056:	74 0d                	je     803065 <insert_sorted_with_merge_freeList+0x593>
  803058:	a1 48 41 80 00       	mov    0x804148,%eax
  80305d:	8b 55 08             	mov    0x8(%ebp),%edx
  803060:	89 50 04             	mov    %edx,0x4(%eax)
  803063:	eb 08                	jmp    80306d <insert_sorted_with_merge_freeList+0x59b>
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	a3 48 41 80 00       	mov    %eax,0x804148
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307f:	a1 54 41 80 00       	mov    0x804154,%eax
  803084:	40                   	inc    %eax
  803085:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  80308a:	e9 18 02 00 00       	jmp    8032a7 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  80308f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803092:	8b 50 0c             	mov    0xc(%eax),%edx
  803095:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803098:	8b 40 08             	mov    0x8(%eax),%eax
  80309b:	01 c2                	add    %eax,%edx
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8b 40 08             	mov    0x8(%eax),%eax
  8030a3:	39 c2                	cmp    %eax,%edx
  8030a5:	0f 85 c4 01 00 00    	jne    80326f <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	8b 50 0c             	mov    0xc(%eax),%edx
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	8b 40 08             	mov    0x8(%eax),%eax
  8030b7:	01 c2                	add    %eax,%edx
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	8b 00                	mov    (%eax),%eax
  8030be:	8b 40 08             	mov    0x8(%eax),%eax
  8030c1:	39 c2                	cmp    %eax,%edx
  8030c3:	0f 85 a6 01 00 00    	jne    80326f <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8030c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030cd:	0f 84 9c 01 00 00    	je     80326f <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  8030d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d6:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030df:	01 c2                	add    %eax,%edx
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 00                	mov    (%eax),%eax
  8030e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e9:	01 c2                	add    %eax,%edx
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8030f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8030fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  803105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803109:	75 17                	jne    803122 <insert_sorted_with_merge_freeList+0x650>
  80310b:	83 ec 04             	sub    $0x4,%esp
  80310e:	68 d4 3c 80 00       	push   $0x803cd4
  803113:	68 32 01 00 00       	push   $0x132
  803118:	68 f7 3c 80 00       	push   $0x803cf7
  80311d:	e8 d0 d3 ff ff       	call   8004f2 <_panic>
  803122:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	89 10                	mov    %edx,(%eax)
  80312d:	8b 45 08             	mov    0x8(%ebp),%eax
  803130:	8b 00                	mov    (%eax),%eax
  803132:	85 c0                	test   %eax,%eax
  803134:	74 0d                	je     803143 <insert_sorted_with_merge_freeList+0x671>
  803136:	a1 48 41 80 00       	mov    0x804148,%eax
  80313b:	8b 55 08             	mov    0x8(%ebp),%edx
  80313e:	89 50 04             	mov    %edx,0x4(%eax)
  803141:	eb 08                	jmp    80314b <insert_sorted_with_merge_freeList+0x679>
  803143:	8b 45 08             	mov    0x8(%ebp),%eax
  803146:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	a3 48 41 80 00       	mov    %eax,0x804148
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315d:	a1 54 41 80 00       	mov    0x804154,%eax
  803162:	40                   	inc    %eax
  803163:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	8b 00                	mov    (%eax),%eax
  80316d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803177:	8b 00                	mov    (%eax),%eax
  803179:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803183:	8b 00                	mov    (%eax),%eax
  803185:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803188:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80318c:	75 17                	jne    8031a5 <insert_sorted_with_merge_freeList+0x6d3>
  80318e:	83 ec 04             	sub    $0x4,%esp
  803191:	68 69 3d 80 00       	push   $0x803d69
  803196:	68 36 01 00 00       	push   $0x136
  80319b:	68 f7 3c 80 00       	push   $0x803cf7
  8031a0:	e8 4d d3 ff ff       	call   8004f2 <_panic>
  8031a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a8:	8b 00                	mov    (%eax),%eax
  8031aa:	85 c0                	test   %eax,%eax
  8031ac:	74 10                	je     8031be <insert_sorted_with_merge_freeList+0x6ec>
  8031ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b1:	8b 00                	mov    (%eax),%eax
  8031b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031b6:	8b 52 04             	mov    0x4(%edx),%edx
  8031b9:	89 50 04             	mov    %edx,0x4(%eax)
  8031bc:	eb 0b                	jmp    8031c9 <insert_sorted_with_merge_freeList+0x6f7>
  8031be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c1:	8b 40 04             	mov    0x4(%eax),%eax
  8031c4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031cc:	8b 40 04             	mov    0x4(%eax),%eax
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	74 0f                	je     8031e2 <insert_sorted_with_merge_freeList+0x710>
  8031d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d6:	8b 40 04             	mov    0x4(%eax),%eax
  8031d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031dc:	8b 12                	mov    (%edx),%edx
  8031de:	89 10                	mov    %edx,(%eax)
  8031e0:	eb 0a                	jmp    8031ec <insert_sorted_with_merge_freeList+0x71a>
  8031e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031e5:	8b 00                	mov    (%eax),%eax
  8031e7:	a3 38 41 80 00       	mov    %eax,0x804138
  8031ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031ff:	a1 44 41 80 00       	mov    0x804144,%eax
  803204:	48                   	dec    %eax
  803205:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80320a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80320e:	75 17                	jne    803227 <insert_sorted_with_merge_freeList+0x755>
  803210:	83 ec 04             	sub    $0x4,%esp
  803213:	68 d4 3c 80 00       	push   $0x803cd4
  803218:	68 37 01 00 00       	push   $0x137
  80321d:	68 f7 3c 80 00       	push   $0x803cf7
  803222:	e8 cb d2 ff ff       	call   8004f2 <_panic>
  803227:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80322d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803230:	89 10                	mov    %edx,(%eax)
  803232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803235:	8b 00                	mov    (%eax),%eax
  803237:	85 c0                	test   %eax,%eax
  803239:	74 0d                	je     803248 <insert_sorted_with_merge_freeList+0x776>
  80323b:	a1 48 41 80 00       	mov    0x804148,%eax
  803240:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803243:	89 50 04             	mov    %edx,0x4(%eax)
  803246:	eb 08                	jmp    803250 <insert_sorted_with_merge_freeList+0x77e>
  803248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80324b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803250:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803253:	a3 48 41 80 00       	mov    %eax,0x804148
  803258:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80325b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803262:	a1 54 41 80 00       	mov    0x804154,%eax
  803267:	40                   	inc    %eax
  803268:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  80326d:	eb 38                	jmp    8032a7 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80326f:	a1 40 41 80 00       	mov    0x804140,%eax
  803274:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803277:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80327b:	74 07                	je     803284 <insert_sorted_with_merge_freeList+0x7b2>
  80327d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803280:	8b 00                	mov    (%eax),%eax
  803282:	eb 05                	jmp    803289 <insert_sorted_with_merge_freeList+0x7b7>
  803284:	b8 00 00 00 00       	mov    $0x0,%eax
  803289:	a3 40 41 80 00       	mov    %eax,0x804140
  80328e:	a1 40 41 80 00       	mov    0x804140,%eax
  803293:	85 c0                	test   %eax,%eax
  803295:	0f 85 ef f9 ff ff    	jne    802c8a <insert_sorted_with_merge_freeList+0x1b8>
  80329b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80329f:	0f 85 e5 f9 ff ff    	jne    802c8a <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8032a5:	eb 00                	jmp    8032a7 <insert_sorted_with_merge_freeList+0x7d5>
  8032a7:	90                   	nop
  8032a8:	c9                   	leave  
  8032a9:	c3                   	ret    
  8032aa:	66 90                	xchg   %ax,%ax

008032ac <__udivdi3>:
  8032ac:	55                   	push   %ebp
  8032ad:	57                   	push   %edi
  8032ae:	56                   	push   %esi
  8032af:	53                   	push   %ebx
  8032b0:	83 ec 1c             	sub    $0x1c,%esp
  8032b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8032b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8032bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032c3:	89 ca                	mov    %ecx,%edx
  8032c5:	89 f8                	mov    %edi,%eax
  8032c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032cb:	85 f6                	test   %esi,%esi
  8032cd:	75 2d                	jne    8032fc <__udivdi3+0x50>
  8032cf:	39 cf                	cmp    %ecx,%edi
  8032d1:	77 65                	ja     803338 <__udivdi3+0x8c>
  8032d3:	89 fd                	mov    %edi,%ebp
  8032d5:	85 ff                	test   %edi,%edi
  8032d7:	75 0b                	jne    8032e4 <__udivdi3+0x38>
  8032d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8032de:	31 d2                	xor    %edx,%edx
  8032e0:	f7 f7                	div    %edi
  8032e2:	89 c5                	mov    %eax,%ebp
  8032e4:	31 d2                	xor    %edx,%edx
  8032e6:	89 c8                	mov    %ecx,%eax
  8032e8:	f7 f5                	div    %ebp
  8032ea:	89 c1                	mov    %eax,%ecx
  8032ec:	89 d8                	mov    %ebx,%eax
  8032ee:	f7 f5                	div    %ebp
  8032f0:	89 cf                	mov    %ecx,%edi
  8032f2:	89 fa                	mov    %edi,%edx
  8032f4:	83 c4 1c             	add    $0x1c,%esp
  8032f7:	5b                   	pop    %ebx
  8032f8:	5e                   	pop    %esi
  8032f9:	5f                   	pop    %edi
  8032fa:	5d                   	pop    %ebp
  8032fb:	c3                   	ret    
  8032fc:	39 ce                	cmp    %ecx,%esi
  8032fe:	77 28                	ja     803328 <__udivdi3+0x7c>
  803300:	0f bd fe             	bsr    %esi,%edi
  803303:	83 f7 1f             	xor    $0x1f,%edi
  803306:	75 40                	jne    803348 <__udivdi3+0x9c>
  803308:	39 ce                	cmp    %ecx,%esi
  80330a:	72 0a                	jb     803316 <__udivdi3+0x6a>
  80330c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803310:	0f 87 9e 00 00 00    	ja     8033b4 <__udivdi3+0x108>
  803316:	b8 01 00 00 00       	mov    $0x1,%eax
  80331b:	89 fa                	mov    %edi,%edx
  80331d:	83 c4 1c             	add    $0x1c,%esp
  803320:	5b                   	pop    %ebx
  803321:	5e                   	pop    %esi
  803322:	5f                   	pop    %edi
  803323:	5d                   	pop    %ebp
  803324:	c3                   	ret    
  803325:	8d 76 00             	lea    0x0(%esi),%esi
  803328:	31 ff                	xor    %edi,%edi
  80332a:	31 c0                	xor    %eax,%eax
  80332c:	89 fa                	mov    %edi,%edx
  80332e:	83 c4 1c             	add    $0x1c,%esp
  803331:	5b                   	pop    %ebx
  803332:	5e                   	pop    %esi
  803333:	5f                   	pop    %edi
  803334:	5d                   	pop    %ebp
  803335:	c3                   	ret    
  803336:	66 90                	xchg   %ax,%ax
  803338:	89 d8                	mov    %ebx,%eax
  80333a:	f7 f7                	div    %edi
  80333c:	31 ff                	xor    %edi,%edi
  80333e:	89 fa                	mov    %edi,%edx
  803340:	83 c4 1c             	add    $0x1c,%esp
  803343:	5b                   	pop    %ebx
  803344:	5e                   	pop    %esi
  803345:	5f                   	pop    %edi
  803346:	5d                   	pop    %ebp
  803347:	c3                   	ret    
  803348:	bd 20 00 00 00       	mov    $0x20,%ebp
  80334d:	89 eb                	mov    %ebp,%ebx
  80334f:	29 fb                	sub    %edi,%ebx
  803351:	89 f9                	mov    %edi,%ecx
  803353:	d3 e6                	shl    %cl,%esi
  803355:	89 c5                	mov    %eax,%ebp
  803357:	88 d9                	mov    %bl,%cl
  803359:	d3 ed                	shr    %cl,%ebp
  80335b:	89 e9                	mov    %ebp,%ecx
  80335d:	09 f1                	or     %esi,%ecx
  80335f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803363:	89 f9                	mov    %edi,%ecx
  803365:	d3 e0                	shl    %cl,%eax
  803367:	89 c5                	mov    %eax,%ebp
  803369:	89 d6                	mov    %edx,%esi
  80336b:	88 d9                	mov    %bl,%cl
  80336d:	d3 ee                	shr    %cl,%esi
  80336f:	89 f9                	mov    %edi,%ecx
  803371:	d3 e2                	shl    %cl,%edx
  803373:	8b 44 24 08          	mov    0x8(%esp),%eax
  803377:	88 d9                	mov    %bl,%cl
  803379:	d3 e8                	shr    %cl,%eax
  80337b:	09 c2                	or     %eax,%edx
  80337d:	89 d0                	mov    %edx,%eax
  80337f:	89 f2                	mov    %esi,%edx
  803381:	f7 74 24 0c          	divl   0xc(%esp)
  803385:	89 d6                	mov    %edx,%esi
  803387:	89 c3                	mov    %eax,%ebx
  803389:	f7 e5                	mul    %ebp
  80338b:	39 d6                	cmp    %edx,%esi
  80338d:	72 19                	jb     8033a8 <__udivdi3+0xfc>
  80338f:	74 0b                	je     80339c <__udivdi3+0xf0>
  803391:	89 d8                	mov    %ebx,%eax
  803393:	31 ff                	xor    %edi,%edi
  803395:	e9 58 ff ff ff       	jmp    8032f2 <__udivdi3+0x46>
  80339a:	66 90                	xchg   %ax,%ax
  80339c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033a0:	89 f9                	mov    %edi,%ecx
  8033a2:	d3 e2                	shl    %cl,%edx
  8033a4:	39 c2                	cmp    %eax,%edx
  8033a6:	73 e9                	jae    803391 <__udivdi3+0xe5>
  8033a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8033ab:	31 ff                	xor    %edi,%edi
  8033ad:	e9 40 ff ff ff       	jmp    8032f2 <__udivdi3+0x46>
  8033b2:	66 90                	xchg   %ax,%ax
  8033b4:	31 c0                	xor    %eax,%eax
  8033b6:	e9 37 ff ff ff       	jmp    8032f2 <__udivdi3+0x46>
  8033bb:	90                   	nop

008033bc <__umoddi3>:
  8033bc:	55                   	push   %ebp
  8033bd:	57                   	push   %edi
  8033be:	56                   	push   %esi
  8033bf:	53                   	push   %ebx
  8033c0:	83 ec 1c             	sub    $0x1c,%esp
  8033c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033db:	89 f3                	mov    %esi,%ebx
  8033dd:	89 fa                	mov    %edi,%edx
  8033df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033e3:	89 34 24             	mov    %esi,(%esp)
  8033e6:	85 c0                	test   %eax,%eax
  8033e8:	75 1a                	jne    803404 <__umoddi3+0x48>
  8033ea:	39 f7                	cmp    %esi,%edi
  8033ec:	0f 86 a2 00 00 00    	jbe    803494 <__umoddi3+0xd8>
  8033f2:	89 c8                	mov    %ecx,%eax
  8033f4:	89 f2                	mov    %esi,%edx
  8033f6:	f7 f7                	div    %edi
  8033f8:	89 d0                	mov    %edx,%eax
  8033fa:	31 d2                	xor    %edx,%edx
  8033fc:	83 c4 1c             	add    $0x1c,%esp
  8033ff:	5b                   	pop    %ebx
  803400:	5e                   	pop    %esi
  803401:	5f                   	pop    %edi
  803402:	5d                   	pop    %ebp
  803403:	c3                   	ret    
  803404:	39 f0                	cmp    %esi,%eax
  803406:	0f 87 ac 00 00 00    	ja     8034b8 <__umoddi3+0xfc>
  80340c:	0f bd e8             	bsr    %eax,%ebp
  80340f:	83 f5 1f             	xor    $0x1f,%ebp
  803412:	0f 84 ac 00 00 00    	je     8034c4 <__umoddi3+0x108>
  803418:	bf 20 00 00 00       	mov    $0x20,%edi
  80341d:	29 ef                	sub    %ebp,%edi
  80341f:	89 fe                	mov    %edi,%esi
  803421:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803425:	89 e9                	mov    %ebp,%ecx
  803427:	d3 e0                	shl    %cl,%eax
  803429:	89 d7                	mov    %edx,%edi
  80342b:	89 f1                	mov    %esi,%ecx
  80342d:	d3 ef                	shr    %cl,%edi
  80342f:	09 c7                	or     %eax,%edi
  803431:	89 e9                	mov    %ebp,%ecx
  803433:	d3 e2                	shl    %cl,%edx
  803435:	89 14 24             	mov    %edx,(%esp)
  803438:	89 d8                	mov    %ebx,%eax
  80343a:	d3 e0                	shl    %cl,%eax
  80343c:	89 c2                	mov    %eax,%edx
  80343e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803442:	d3 e0                	shl    %cl,%eax
  803444:	89 44 24 04          	mov    %eax,0x4(%esp)
  803448:	8b 44 24 08          	mov    0x8(%esp),%eax
  80344c:	89 f1                	mov    %esi,%ecx
  80344e:	d3 e8                	shr    %cl,%eax
  803450:	09 d0                	or     %edx,%eax
  803452:	d3 eb                	shr    %cl,%ebx
  803454:	89 da                	mov    %ebx,%edx
  803456:	f7 f7                	div    %edi
  803458:	89 d3                	mov    %edx,%ebx
  80345a:	f7 24 24             	mull   (%esp)
  80345d:	89 c6                	mov    %eax,%esi
  80345f:	89 d1                	mov    %edx,%ecx
  803461:	39 d3                	cmp    %edx,%ebx
  803463:	0f 82 87 00 00 00    	jb     8034f0 <__umoddi3+0x134>
  803469:	0f 84 91 00 00 00    	je     803500 <__umoddi3+0x144>
  80346f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803473:	29 f2                	sub    %esi,%edx
  803475:	19 cb                	sbb    %ecx,%ebx
  803477:	89 d8                	mov    %ebx,%eax
  803479:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80347d:	d3 e0                	shl    %cl,%eax
  80347f:	89 e9                	mov    %ebp,%ecx
  803481:	d3 ea                	shr    %cl,%edx
  803483:	09 d0                	or     %edx,%eax
  803485:	89 e9                	mov    %ebp,%ecx
  803487:	d3 eb                	shr    %cl,%ebx
  803489:	89 da                	mov    %ebx,%edx
  80348b:	83 c4 1c             	add    $0x1c,%esp
  80348e:	5b                   	pop    %ebx
  80348f:	5e                   	pop    %esi
  803490:	5f                   	pop    %edi
  803491:	5d                   	pop    %ebp
  803492:	c3                   	ret    
  803493:	90                   	nop
  803494:	89 fd                	mov    %edi,%ebp
  803496:	85 ff                	test   %edi,%edi
  803498:	75 0b                	jne    8034a5 <__umoddi3+0xe9>
  80349a:	b8 01 00 00 00       	mov    $0x1,%eax
  80349f:	31 d2                	xor    %edx,%edx
  8034a1:	f7 f7                	div    %edi
  8034a3:	89 c5                	mov    %eax,%ebp
  8034a5:	89 f0                	mov    %esi,%eax
  8034a7:	31 d2                	xor    %edx,%edx
  8034a9:	f7 f5                	div    %ebp
  8034ab:	89 c8                	mov    %ecx,%eax
  8034ad:	f7 f5                	div    %ebp
  8034af:	89 d0                	mov    %edx,%eax
  8034b1:	e9 44 ff ff ff       	jmp    8033fa <__umoddi3+0x3e>
  8034b6:	66 90                	xchg   %ax,%ax
  8034b8:	89 c8                	mov    %ecx,%eax
  8034ba:	89 f2                	mov    %esi,%edx
  8034bc:	83 c4 1c             	add    $0x1c,%esp
  8034bf:	5b                   	pop    %ebx
  8034c0:	5e                   	pop    %esi
  8034c1:	5f                   	pop    %edi
  8034c2:	5d                   	pop    %ebp
  8034c3:	c3                   	ret    
  8034c4:	3b 04 24             	cmp    (%esp),%eax
  8034c7:	72 06                	jb     8034cf <__umoddi3+0x113>
  8034c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034cd:	77 0f                	ja     8034de <__umoddi3+0x122>
  8034cf:	89 f2                	mov    %esi,%edx
  8034d1:	29 f9                	sub    %edi,%ecx
  8034d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034d7:	89 14 24             	mov    %edx,(%esp)
  8034da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034e2:	8b 14 24             	mov    (%esp),%edx
  8034e5:	83 c4 1c             	add    $0x1c,%esp
  8034e8:	5b                   	pop    %ebx
  8034e9:	5e                   	pop    %esi
  8034ea:	5f                   	pop    %edi
  8034eb:	5d                   	pop    %ebp
  8034ec:	c3                   	ret    
  8034ed:	8d 76 00             	lea    0x0(%esi),%esi
  8034f0:	2b 04 24             	sub    (%esp),%eax
  8034f3:	19 fa                	sbb    %edi,%edx
  8034f5:	89 d1                	mov    %edx,%ecx
  8034f7:	89 c6                	mov    %eax,%esi
  8034f9:	e9 71 ff ff ff       	jmp    80346f <__umoddi3+0xb3>
  8034fe:	66 90                	xchg   %ax,%ax
  803500:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803504:	72 ea                	jb     8034f0 <__umoddi3+0x134>
  803506:	89 d9                	mov    %ebx,%ecx
  803508:	e9 62 ff ff ff       	jmp    80346f <__umoddi3+0xb3>
