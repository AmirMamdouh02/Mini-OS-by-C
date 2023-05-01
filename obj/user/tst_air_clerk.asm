
obj/user/tst_air_clerk:     file format elf32-i386


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
  800031:	e8 e7 05 00 00       	call   80061d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>
#include <user/air.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
	int parentenvID = sys_getparentenvid();
  800044:	e8 fa 20 00 00       	call   802143 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// Get the shared variables from the main program ***********************************

	char _customers[] = "customers";
  80004c:	8d 45 ae             	lea    -0x52(%ebp),%eax
  80004f:	bb b5 37 80 00       	mov    $0x8037b5,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 a2             	lea    -0x5e(%ebp),%eax
  800064:	bb bf 37 80 00       	mov    $0x8037bf,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800079:	bb cb 37 80 00       	mov    $0x8037cb,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80008e:	bb da 37 80 00       	mov    $0x8037da,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  8000a6:	bb e9 37 80 00       	mov    $0x8037e9,%ebx
  8000ab:	ba 15 00 00 00       	mov    $0x15,%edx
  8000b0:	89 c7                	mov    %eax,%edi
  8000b2:	89 de                	mov    %ebx,%esi
  8000b4:	89 d1                	mov    %edx,%ecx
  8000b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b8:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  8000be:	bb fe 37 80 00       	mov    $0x8037fe,%ebx
  8000c3:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c8:	89 c7                	mov    %eax,%edi
  8000ca:	89 de                	mov    %ebx,%esi
  8000cc:	89 d1                	mov    %edx,%ecx
  8000ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000d0:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  8000d6:	bb 13 38 80 00       	mov    $0x803813,%ebx
  8000db:	ba 11 00 00 00       	mov    $0x11,%edx
  8000e0:	89 c7                	mov    %eax,%edi
  8000e2:	89 de                	mov    %ebx,%esi
  8000e4:	89 d1                	mov    %edx,%ecx
  8000e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e8:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8000ee:	bb 24 38 80 00       	mov    $0x803824,%ebx
  8000f3:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f8:	89 c7                	mov    %eax,%edi
  8000fa:	89 de                	mov    %ebx,%esi
  8000fc:	89 d1                	mov    %edx,%ecx
  8000fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800100:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  800106:	bb 35 38 80 00       	mov    $0x803835,%ebx
  80010b:	ba 11 00 00 00       	mov    $0x11,%edx
  800110:	89 c7                	mov    %eax,%edi
  800112:	89 de                	mov    %ebx,%esi
  800114:	89 d1                	mov    %edx,%ecx
  800116:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800118:	8d 85 1e ff ff ff    	lea    -0xe2(%ebp),%eax
  80011e:	bb 46 38 80 00       	mov    $0x803846,%ebx
  800123:	ba 09 00 00 00       	mov    $0x9,%edx
  800128:	89 c7                	mov    %eax,%edi
  80012a:	89 de                	mov    %ebx,%esi
  80012c:	89 d1                	mov    %edx,%ecx
  80012e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800130:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  800136:	bb 4f 38 80 00       	mov    $0x80384f,%ebx
  80013b:	ba 0a 00 00 00       	mov    $0xa,%edx
  800140:	89 c7                	mov    %eax,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	89 d1                	mov    %edx,%ecx
  800146:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800148:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  80014e:	bb 59 38 80 00       	mov    $0x803859,%ebx
  800153:	ba 0b 00 00 00       	mov    $0xb,%edx
  800158:	89 c7                	mov    %eax,%edi
  80015a:	89 de                	mov    %ebx,%esi
  80015c:	89 d1                	mov    %edx,%ecx
  80015e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800160:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800166:	bb 64 38 80 00       	mov    $0x803864,%ebx
  80016b:	ba 03 00 00 00       	mov    $0x3,%edx
  800170:	89 c7                	mov    %eax,%edi
  800172:	89 de                	mov    %ebx,%esi
  800174:	89 d1                	mov    %edx,%ecx
  800176:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800178:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  80017e:	bb 70 38 80 00       	mov    $0x803870,%ebx
  800183:	ba 0a 00 00 00       	mov    $0xa,%edx
  800188:	89 c7                	mov    %eax,%edi
  80018a:	89 de                	mov    %ebx,%esi
  80018c:	89 d1                	mov    %edx,%ecx
  80018e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  800190:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800196:	bb 7a 38 80 00       	mov    $0x80387a,%ebx
  80019b:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001a0:	89 c7                	mov    %eax,%edi
  8001a2:	89 de                	mov    %ebx,%esi
  8001a4:	89 d1                	mov    %edx,%ecx
  8001a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a8:	c7 85 e3 fe ff ff 63 	movl   $0x72656c63,-0x11d(%ebp)
  8001af:	6c 65 72 
  8001b2:	66 c7 85 e7 fe ff ff 	movw   $0x6b,-0x119(%ebp)
  8001b9:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001bb:	8d 85 d5 fe ff ff    	lea    -0x12b(%ebp),%eax
  8001c1:	bb 84 38 80 00       	mov    $0x803884,%ebx
  8001c6:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001cb:	89 c7                	mov    %eax,%edi
  8001cd:	89 de                	mov    %ebx,%esi
  8001cf:	89 d1                	mov    %edx,%ecx
  8001d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d3:	8d 85 c6 fe ff ff    	lea    -0x13a(%ebp),%eax
  8001d9:	bb 92 38 80 00       	mov    $0x803892,%ebx
  8001de:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e3:	89 c7                	mov    %eax,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	89 d1                	mov    %edx,%ecx
  8001e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001eb:	8d 85 bf fe ff ff    	lea    -0x141(%ebp),%eax
  8001f1:	bb a1 38 80 00       	mov    $0x8038a1,%ebx
  8001f6:	ba 07 00 00 00       	mov    $0x7,%edx
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 de                	mov    %ebx,%esi
  8001ff:	89 d1                	mov    %edx,%ecx
  800201:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800203:	8d 85 b8 fe ff ff    	lea    -0x148(%ebp),%eax
  800209:	bb a8 38 80 00       	mov    $0x8038a8,%ebx
  80020e:	ba 07 00 00 00       	mov    $0x7,%edx
  800213:	89 c7                	mov    %eax,%edi
  800215:	89 de                	mov    %ebx,%esi
  800217:	89 d1                	mov    %edx,%ecx
  800219:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * customers = sget(parentenvID, _customers);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	8d 45 ae             	lea    -0x52(%ebp),%eax
  800221:	50                   	push   %eax
  800222:	ff 75 e4             	pushl  -0x1c(%ebp)
  800225:	e8 d2 19 00 00       	call   801bfc <sget>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* flight1Counter = sget(parentenvID, _flight1Counter);
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	8d 45 93             	lea    -0x6d(%ebp),%eax
  800236:	50                   	push   %eax
  800237:	ff 75 e4             	pushl  -0x1c(%ebp)
  80023a:	e8 bd 19 00 00       	call   801bfc <sget>
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int* flight2Counter = sget(parentenvID, _flight2Counter);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	8d 45 84             	lea    -0x7c(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 a8 19 00 00       	call   801bfc <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* flight1BookedCounter = sget(parentenvID, _flightBooked1Counter);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 6f ff ff ff    	lea    -0x91(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 90 19 00 00       	call   801bfc <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	int* flight2BookedCounter = sget(parentenvID, _flightBooked2Counter);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 5a ff ff ff    	lea    -0xa6(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 78 19 00 00       	call   801bfc <sget>
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	89 45 d0             	mov    %eax,-0x30(%ebp)

	int* flight1BookedArr = sget(parentenvID, _flightBooked1Arr);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	8d 85 49 ff ff ff    	lea    -0xb7(%ebp),%eax
  800293:	50                   	push   %eax
  800294:	ff 75 e4             	pushl  -0x1c(%ebp)
  800297:	e8 60 19 00 00       	call   801bfc <sget>
  80029c:	83 c4 10             	add    $0x10,%esp
  80029f:	89 45 cc             	mov    %eax,-0x34(%ebp)
	int* flight2BookedArr = sget(parentenvID, _flightBooked2Arr);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
  8002ab:	50                   	push   %eax
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	e8 48 19 00 00       	call   801bfc <sget>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	89 45 c8             	mov    %eax,-0x38(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  8002ba:	83 ec 08             	sub    $0x8,%esp
  8002bd:	8d 85 27 ff ff ff    	lea    -0xd9(%ebp),%eax
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c7:	e8 30 19 00 00       	call   801bfc <sget>
  8002cc:	83 c4 10             	add    $0x10,%esp
  8002cf:	89 45 c4             	mov    %eax,-0x3c(%ebp)

	int* queue_out = sget(parentenvID, _queue_out);
  8002d2:	83 ec 08             	sub    $0x8,%esp
  8002d5:	8d 85 14 ff ff ff    	lea    -0xec(%ebp),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	e8 18 19 00 00       	call   801bfc <sget>
  8002e4:	83 c4 10             	add    $0x10,%esp
  8002e7:	89 45 c0             	mov    %eax,-0x40(%ebp)

	while(1==1)
	{
		int custId;
		//wait for a customer
		sys_waitSemaphore(parentenvID, _cust_ready);
  8002ea:	83 ec 08             	sub    $0x8,%esp
  8002ed:	8d 85 09 ff ff ff    	lea    -0xf7(%ebp),%eax
  8002f3:	50                   	push   %eax
  8002f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f7:	e8 e8 1c 00 00       	call   801fe4 <sys_waitSemaphore>
  8002fc:	83 c4 10             	add    $0x10,%esp

		//dequeue the customer info
		sys_waitSemaphore(parentenvID, _custQueueCS);
  8002ff:	83 ec 08             	sub    $0x8,%esp
  800302:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800308:	50                   	push   %eax
  800309:	ff 75 e4             	pushl  -0x1c(%ebp)
  80030c:	e8 d3 1c 00 00       	call   801fe4 <sys_waitSemaphore>
  800311:	83 c4 10             	add    $0x10,%esp
		{
			//cprintf("*queue_out = %d\n", *queue_out);
			custId = cust_ready_queue[*queue_out];
  800314:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800317:	8b 00                	mov    (%eax),%eax
  800319:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800320:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800323:	01 d0                	add    %edx,%eax
  800325:	8b 00                	mov    (%eax),%eax
  800327:	89 45 bc             	mov    %eax,-0x44(%ebp)
			*queue_out = *queue_out +1;
  80032a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80032d:	8b 00                	mov    (%eax),%eax
  80032f:	8d 50 01             	lea    0x1(%eax),%edx
  800332:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800335:	89 10                	mov    %edx,(%eax)
		}
		sys_signalSemaphore(parentenvID, _custQueueCS);
  800337:	83 ec 08             	sub    $0x8,%esp
  80033a:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800340:	50                   	push   %eax
  800341:	ff 75 e4             	pushl  -0x1c(%ebp)
  800344:	e8 b9 1c 00 00       	call   802002 <sys_signalSemaphore>
  800349:	83 c4 10             	add    $0x10,%esp

		//try reserving on the required flight
		int custFlightType = customers[custId].flightType;
  80034c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80034f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800356:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800359:	01 d0                	add    %edx,%eax
  80035b:	8b 00                	mov    (%eax),%eax
  80035d:	89 45 b8             	mov    %eax,-0x48(%ebp)
		//cprintf("custId dequeued = %d, ft = %d\n", custId, customers[custId].flightType);

		switch (custFlightType)
  800360:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800363:	83 f8 02             	cmp    $0x2,%eax
  800366:	0f 84 90 00 00 00    	je     8003fc <_main+0x3c4>
  80036c:	83 f8 03             	cmp    $0x3,%eax
  80036f:	0f 84 05 01 00 00    	je     80047a <_main+0x442>
  800375:	83 f8 01             	cmp    $0x1,%eax
  800378:	0f 85 f8 01 00 00    	jne    800576 <_main+0x53e>
		{
		case 1:
		{
			//Check and update Flight1
			sys_waitSemaphore(parentenvID, _flight1CS);
  80037e:	83 ec 08             	sub    $0x8,%esp
  800381:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800387:	50                   	push   %eax
  800388:	ff 75 e4             	pushl  -0x1c(%ebp)
  80038b:	e8 54 1c 00 00       	call   801fe4 <sys_waitSemaphore>
  800390:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0)
  800393:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	85 c0                	test   %eax,%eax
  80039a:	7e 46                	jle    8003e2 <_main+0x3aa>
				{
					*flight1Counter = *flight1Counter - 1;
  80039c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	8d 50 ff             	lea    -0x1(%eax),%edx
  8003a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003a7:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8003a9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b6:	01 d0                	add    %edx,%eax
  8003b8:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8003bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c2:	8b 00                	mov    (%eax),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8003d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003d8:	8b 00                	mov    (%eax),%eax
  8003da:	8d 50 01             	lea    0x1(%eax),%edx
  8003dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003e0:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight1CS);
  8003e2:	83 ec 08             	sub    $0x8,%esp
  8003e5:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  8003eb:	50                   	push   %eax
  8003ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003ef:	e8 0e 1c 00 00       	call   802002 <sys_signalSemaphore>
  8003f4:	83 c4 10             	add    $0x10,%esp
		}

		break;
  8003f7:	e9 91 01 00 00       	jmp    80058d <_main+0x555>
		case 2:
		{
			//Check and update Flight2
			sys_waitSemaphore(parentenvID, _flight2CS);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800405:	50                   	push   %eax
  800406:	ff 75 e4             	pushl  -0x1c(%ebp)
  800409:	e8 d6 1b 00 00       	call   801fe4 <sys_waitSemaphore>
  80040e:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight2Counter > 0)
  800411:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800414:	8b 00                	mov    (%eax),%eax
  800416:	85 c0                	test   %eax,%eax
  800418:	7e 46                	jle    800460 <_main+0x428>
				{
					*flight2Counter = *flight2Counter - 1;
  80041a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041d:	8b 00                	mov    (%eax),%eax
  80041f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800422:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800425:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800427:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80042a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	01 d0                	add    %edx,%eax
  800436:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  80043d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800440:	8b 00                	mov    (%eax),%eax
  800442:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800449:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044c:	01 c2                	add    %eax,%edx
  80044e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800451:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  800453:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	8d 50 01             	lea    0x1(%eax),%edx
  80045b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80045e:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS);
  800460:	83 ec 08             	sub    $0x8,%esp
  800463:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800469:	50                   	push   %eax
  80046a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80046d:	e8 90 1b 00 00       	call   802002 <sys_signalSemaphore>
  800472:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800475:	e9 13 01 00 00       	jmp    80058d <_main+0x555>
		case 3:
		{
			//Check and update Both Flights
			sys_waitSemaphore(parentenvID, _flight1CS); sys_waitSemaphore(parentenvID, _flight2CS);
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800483:	50                   	push   %eax
  800484:	ff 75 e4             	pushl  -0x1c(%ebp)
  800487:	e8 58 1b 00 00       	call   801fe4 <sys_waitSemaphore>
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	83 ec 08             	sub    $0x8,%esp
  800492:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800498:	50                   	push   %eax
  800499:	ff 75 e4             	pushl  -0x1c(%ebp)
  80049c:	e8 43 1b 00 00       	call   801fe4 <sys_waitSemaphore>
  8004a1:	83 c4 10             	add    $0x10,%esp
			{
				if(*flight1Counter > 0 && *flight2Counter >0 )
  8004a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a7:	8b 00                	mov    (%eax),%eax
  8004a9:	85 c0                	test   %eax,%eax
  8004ab:	0f 8e 99 00 00 00    	jle    80054a <_main+0x512>
  8004b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	85 c0                	test   %eax,%eax
  8004b8:	0f 8e 8c 00 00 00    	jle    80054a <_main+0x512>
				{
					*flight1Counter = *flight1Counter - 1;
  8004be:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c9:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  8004cb:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8004d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d8:	01 d0                	add    %edx,%eax
  8004da:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight1BookedArr[*flight1BookedCounter] = custId;
  8004e1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004e4:	8b 00                	mov    (%eax),%eax
  8004e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004f0:	01 c2                	add    %eax,%edx
  8004f2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004f5:	89 02                	mov    %eax,(%edx)
					*flight1BookedCounter =*flight1BookedCounter+1;
  8004f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	8d 50 01             	lea    0x1(%eax),%edx
  8004ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800502:	89 10                	mov    %edx,(%eax)

					*flight2Counter = *flight2Counter - 1;
  800504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800507:	8b 00                	mov    (%eax),%eax
  800509:	8d 50 ff             	lea    -0x1(%eax),%edx
  80050c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
					customers[custId].booked = 1;
  800511:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800514:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80051b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80051e:	01 d0                	add    %edx,%eax
  800520:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
					flight2BookedArr[*flight2BookedCounter] = custId;
  800527:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80052a:	8b 00                	mov    (%eax),%eax
  80052c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800533:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800536:	01 c2                	add    %eax,%edx
  800538:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80053b:	89 02                	mov    %eax,(%edx)
					*flight2BookedCounter =*flight2BookedCounter+1;
  80053d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	8d 50 01             	lea    0x1(%eax),%edx
  800545:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800548:	89 10                	mov    %edx,(%eax)
				else
				{

				}
			}
			sys_signalSemaphore(parentenvID, _flight2CS); sys_signalSemaphore(parentenvID, _flight1CS);
  80054a:	83 ec 08             	sub    $0x8,%esp
  80054d:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  800553:	50                   	push   %eax
  800554:	ff 75 e4             	pushl  -0x1c(%ebp)
  800557:	e8 a6 1a 00 00       	call   802002 <sys_signalSemaphore>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	83 ec 08             	sub    $0x8,%esp
  800562:	8d 85 f3 fe ff ff    	lea    -0x10d(%ebp),%eax
  800568:	50                   	push   %eax
  800569:	ff 75 e4             	pushl  -0x1c(%ebp)
  80056c:	e8 91 1a 00 00       	call   802002 <sys_signalSemaphore>
  800571:	83 c4 10             	add    $0x10,%esp
		}
		break;
  800574:	eb 17                	jmp    80058d <_main+0x555>
		default:
			panic("customer must have flight type\n");
  800576:	83 ec 04             	sub    $0x4,%esp
  800579:	68 80 37 80 00       	push   $0x803780
  80057e:	68 8f 00 00 00       	push   $0x8f
  800583:	68 a0 37 80 00       	push   $0x8037a0
  800588:	e8 cc 01 00 00       	call   800759 <_panic>
		}

		//signal finished
		char prefix[30]="cust_finished";
  80058d:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  800593:	bb af 38 80 00       	mov    $0x8038af,%ebx
  800598:	ba 0e 00 00 00       	mov    $0xe,%edx
  80059d:	89 c7                	mov    %eax,%edi
  80059f:	89 de                	mov    %ebx,%esi
  8005a1:	89 d1                	mov    %edx,%ecx
  8005a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8005a5:	8d 95 a8 fe ff ff    	lea    -0x158(%ebp),%edx
  8005ab:	b9 04 00 00 00       	mov    $0x4,%ecx
  8005b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005b5:	89 d7                	mov    %edx,%edi
  8005b7:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(custId, id);
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005c2:	50                   	push   %eax
  8005c3:	ff 75 bc             	pushl  -0x44(%ebp)
  8005c6:	e8 6a 0f 00 00       	call   801535 <ltostr>
  8005cb:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  8005ce:	83 ec 04             	sub    $0x4,%esp
  8005d1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005d7:	50                   	push   %eax
  8005d8:	8d 85 95 fe ff ff    	lea    -0x16b(%ebp),%eax
  8005de:	50                   	push   %eax
  8005df:	8d 85 9a fe ff ff    	lea    -0x166(%ebp),%eax
  8005e5:	50                   	push   %eax
  8005e6:	e8 42 10 00 00       	call   80162d <strcconcat>
  8005eb:	83 c4 10             	add    $0x10,%esp
		sys_signalSemaphore(parentenvID, sname);
  8005ee:	83 ec 08             	sub    $0x8,%esp
  8005f1:	8d 85 63 fe ff ff    	lea    -0x19d(%ebp),%eax
  8005f7:	50                   	push   %eax
  8005f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005fb:	e8 02 1a 00 00       	call   802002 <sys_signalSemaphore>
  800600:	83 c4 10             	add    $0x10,%esp

		//signal the clerk
		sys_signalSemaphore(parentenvID, _clerk);
  800603:	83 ec 08             	sub    $0x8,%esp
  800606:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80060c:	50                   	push   %eax
  80060d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800610:	e8 ed 19 00 00       	call   802002 <sys_signalSemaphore>
  800615:	83 c4 10             	add    $0x10,%esp
	}
  800618:	e9 cd fc ff ff       	jmp    8002ea <_main+0x2b2>

0080061d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
  800620:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800623:	e8 02 1b 00 00       	call   80212a <sys_getenvindex>
  800628:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80062b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062e:	89 d0                	mov    %edx,%eax
  800630:	c1 e0 03             	shl    $0x3,%eax
  800633:	01 d0                	add    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800640:	01 d0                	add    %edx,%eax
  800642:	c1 e0 04             	shl    $0x4,%eax
  800645:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80064a:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80064f:	a1 20 50 80 00       	mov    0x805020,%eax
  800654:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80065a:	84 c0                	test   %al,%al
  80065c:	74 0f                	je     80066d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80065e:	a1 20 50 80 00       	mov    0x805020,%eax
  800663:	05 5c 05 00 00       	add    $0x55c,%eax
  800668:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80066d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800671:	7e 0a                	jle    80067d <libmain+0x60>
		binaryname = argv[0];
  800673:	8b 45 0c             	mov    0xc(%ebp),%eax
  800676:	8b 00                	mov    (%eax),%eax
  800678:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	ff 75 0c             	pushl  0xc(%ebp)
  800683:	ff 75 08             	pushl  0x8(%ebp)
  800686:	e8 ad f9 ff ff       	call   800038 <_main>
  80068b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80068e:	e8 a4 18 00 00       	call   801f37 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800693:	83 ec 0c             	sub    $0xc,%esp
  800696:	68 e8 38 80 00       	push   $0x8038e8
  80069b:	e8 6d 03 00 00       	call   800a0d <cprintf>
  8006a0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006a3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8006b3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	52                   	push   %edx
  8006bd:	50                   	push   %eax
  8006be:	68 10 39 80 00       	push   $0x803910
  8006c3:	e8 45 03 00 00       	call   800a0d <cprintf>
  8006c8:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8006cb:	a1 20 50 80 00       	mov    0x805020,%eax
  8006d0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006e6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006ec:	51                   	push   %ecx
  8006ed:	52                   	push   %edx
  8006ee:	50                   	push   %eax
  8006ef:	68 38 39 80 00       	push   $0x803938
  8006f4:	e8 14 03 00 00       	call   800a0d <cprintf>
  8006f9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	50                   	push   %eax
  80070b:	68 90 39 80 00       	push   $0x803990
  800710:	e8 f8 02 00 00       	call   800a0d <cprintf>
  800715:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800718:	83 ec 0c             	sub    $0xc,%esp
  80071b:	68 e8 38 80 00       	push   $0x8038e8
  800720:	e8 e8 02 00 00       	call   800a0d <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800728:	e8 24 18 00 00       	call   801f51 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80072d:	e8 19 00 00 00       	call   80074b <exit>
}
  800732:	90                   	nop
  800733:	c9                   	leave  
  800734:	c3                   	ret    

00800735 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80073b:	83 ec 0c             	sub    $0xc,%esp
  80073e:	6a 00                	push   $0x0
  800740:	e8 b1 19 00 00       	call   8020f6 <sys_destroy_env>
  800745:	83 c4 10             	add    $0x10,%esp
}
  800748:	90                   	nop
  800749:	c9                   	leave  
  80074a:	c3                   	ret    

0080074b <exit>:

void
exit(void)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800751:	e8 06 1a 00 00       	call   80215c <sys_exit_env>
}
  800756:	90                   	nop
  800757:	c9                   	leave  
  800758:	c3                   	ret    

00800759 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800759:	55                   	push   %ebp
  80075a:	89 e5                	mov    %esp,%ebp
  80075c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80075f:	8d 45 10             	lea    0x10(%ebp),%eax
  800762:	83 c0 04             	add    $0x4,%eax
  800765:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800768:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80076d:	85 c0                	test   %eax,%eax
  80076f:	74 16                	je     800787 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800771:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800776:	83 ec 08             	sub    $0x8,%esp
  800779:	50                   	push   %eax
  80077a:	68 a4 39 80 00       	push   $0x8039a4
  80077f:	e8 89 02 00 00       	call   800a0d <cprintf>
  800784:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800787:	a1 00 50 80 00       	mov    0x805000,%eax
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	ff 75 08             	pushl  0x8(%ebp)
  800792:	50                   	push   %eax
  800793:	68 a9 39 80 00       	push   $0x8039a9
  800798:	e8 70 02 00 00       	call   800a0d <cprintf>
  80079d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a3:	83 ec 08             	sub    $0x8,%esp
  8007a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a9:	50                   	push   %eax
  8007aa:	e8 f3 01 00 00       	call   8009a2 <vcprintf>
  8007af:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	6a 00                	push   $0x0
  8007b7:	68 c5 39 80 00       	push   $0x8039c5
  8007bc:	e8 e1 01 00 00       	call   8009a2 <vcprintf>
  8007c1:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8007c4:	e8 82 ff ff ff       	call   80074b <exit>

	// should not return here
	while (1) ;
  8007c9:	eb fe                	jmp    8007c9 <_panic+0x70>

008007cb <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8007cb:	55                   	push   %ebp
  8007cc:	89 e5                	mov    %esp,%ebp
  8007ce:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8007d1:	a1 20 50 80 00       	mov    0x805020,%eax
  8007d6:	8b 50 74             	mov    0x74(%eax),%edx
  8007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007dc:	39 c2                	cmp    %eax,%edx
  8007de:	74 14                	je     8007f4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007e0:	83 ec 04             	sub    $0x4,%esp
  8007e3:	68 c8 39 80 00       	push   $0x8039c8
  8007e8:	6a 26                	push   $0x26
  8007ea:	68 14 3a 80 00       	push   $0x803a14
  8007ef:	e8 65 ff ff ff       	call   800759 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800802:	e9 c2 00 00 00       	jmp    8008c9 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80080a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	01 d0                	add    %edx,%eax
  800816:	8b 00                	mov    (%eax),%eax
  800818:	85 c0                	test   %eax,%eax
  80081a:	75 08                	jne    800824 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80081c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80081f:	e9 a2 00 00 00       	jmp    8008c6 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800824:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80082b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800832:	eb 69                	jmp    80089d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800834:	a1 20 50 80 00       	mov    0x805020,%eax
  800839:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80083f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800842:	89 d0                	mov    %edx,%eax
  800844:	01 c0                	add    %eax,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	c1 e0 03             	shl    $0x3,%eax
  80084b:	01 c8                	add    %ecx,%eax
  80084d:	8a 40 04             	mov    0x4(%eax),%al
  800850:	84 c0                	test   %al,%al
  800852:	75 46                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800854:	a1 20 50 80 00       	mov    0x805020,%eax
  800859:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800862:	89 d0                	mov    %edx,%eax
  800864:	01 c0                	add    %eax,%eax
  800866:	01 d0                	add    %edx,%eax
  800868:	c1 e0 03             	shl    $0x3,%eax
  80086b:	01 c8                	add    %ecx,%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800872:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800875:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80087c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800886:	8b 45 08             	mov    0x8(%ebp),%eax
  800889:	01 c8                	add    %ecx,%eax
  80088b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80088d:	39 c2                	cmp    %eax,%edx
  80088f:	75 09                	jne    80089a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800891:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800898:	eb 12                	jmp    8008ac <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80089a:	ff 45 e8             	incl   -0x18(%ebp)
  80089d:	a1 20 50 80 00       	mov    0x805020,%eax
  8008a2:	8b 50 74             	mov    0x74(%eax),%edx
  8008a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a8:	39 c2                	cmp    %eax,%edx
  8008aa:	77 88                	ja     800834 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008b0:	75 14                	jne    8008c6 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 20 3a 80 00       	push   $0x803a20
  8008ba:	6a 3a                	push   $0x3a
  8008bc:	68 14 3a 80 00       	push   $0x803a14
  8008c1:	e8 93 fe ff ff       	call   800759 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8008c6:	ff 45 f0             	incl   -0x10(%ebp)
  8008c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8008cf:	0f 8c 32 ff ff ff    	jl     800807 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e3:	eb 26                	jmp    80090b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8008ea:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008f0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f3:	89 d0                	mov    %edx,%eax
  8008f5:	01 c0                	add    %eax,%eax
  8008f7:	01 d0                	add    %edx,%eax
  8008f9:	c1 e0 03             	shl    $0x3,%eax
  8008fc:	01 c8                	add    %ecx,%eax
  8008fe:	8a 40 04             	mov    0x4(%eax),%al
  800901:	3c 01                	cmp    $0x1,%al
  800903:	75 03                	jne    800908 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800905:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800908:	ff 45 e0             	incl   -0x20(%ebp)
  80090b:	a1 20 50 80 00       	mov    0x805020,%eax
  800910:	8b 50 74             	mov    0x74(%eax),%edx
  800913:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800916:	39 c2                	cmp    %eax,%edx
  800918:	77 cb                	ja     8008e5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80091a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80091d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800920:	74 14                	je     800936 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800922:	83 ec 04             	sub    $0x4,%esp
  800925:	68 74 3a 80 00       	push   $0x803a74
  80092a:	6a 44                	push   $0x44
  80092c:	68 14 3a 80 00       	push   $0x803a14
  800931:	e8 23 fe ff ff       	call   800759 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800936:	90                   	nop
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80093f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800942:	8b 00                	mov    (%eax),%eax
  800944:	8d 48 01             	lea    0x1(%eax),%ecx
  800947:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094a:	89 0a                	mov    %ecx,(%edx)
  80094c:	8b 55 08             	mov    0x8(%ebp),%edx
  80094f:	88 d1                	mov    %dl,%cl
  800951:	8b 55 0c             	mov    0xc(%ebp),%edx
  800954:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 00                	mov    (%eax),%eax
  80095d:	3d ff 00 00 00       	cmp    $0xff,%eax
  800962:	75 2c                	jne    800990 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800964:	a0 24 50 80 00       	mov    0x805024,%al
  800969:	0f b6 c0             	movzbl %al,%eax
  80096c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80096f:	8b 12                	mov    (%edx),%edx
  800971:	89 d1                	mov    %edx,%ecx
  800973:	8b 55 0c             	mov    0xc(%ebp),%edx
  800976:	83 c2 08             	add    $0x8,%edx
  800979:	83 ec 04             	sub    $0x4,%esp
  80097c:	50                   	push   %eax
  80097d:	51                   	push   %ecx
  80097e:	52                   	push   %edx
  80097f:	e8 05 14 00 00       	call   801d89 <sys_cputs>
  800984:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800990:	8b 45 0c             	mov    0xc(%ebp),%eax
  800993:	8b 40 04             	mov    0x4(%eax),%eax
  800996:	8d 50 01             	lea    0x1(%eax),%edx
  800999:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ab:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009b2:	00 00 00 
	b.cnt = 0;
  8009b5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009bc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	ff 75 08             	pushl  0x8(%ebp)
  8009c5:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009cb:	50                   	push   %eax
  8009cc:	68 39 09 80 00       	push   $0x800939
  8009d1:	e8 11 02 00 00       	call   800be7 <vprintfmt>
  8009d6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009d9:	a0 24 50 80 00       	mov    0x805024,%al
  8009de:	0f b6 c0             	movzbl %al,%eax
  8009e1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	50                   	push   %eax
  8009eb:	52                   	push   %edx
  8009ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009f2:	83 c0 08             	add    $0x8,%eax
  8009f5:	50                   	push   %eax
  8009f6:	e8 8e 13 00 00       	call   801d89 <sys_cputs>
  8009fb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009fe:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a05:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a0b:	c9                   	leave  
  800a0c:	c3                   	ret    

00800a0d <cprintf>:

int cprintf(const char *fmt, ...) {
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a13:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a1a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	83 ec 08             	sub    $0x8,%esp
  800a26:	ff 75 f4             	pushl  -0xc(%ebp)
  800a29:	50                   	push   %eax
  800a2a:	e8 73 ff ff ff       	call   8009a2 <vcprintf>
  800a2f:	83 c4 10             	add    $0x10,%esp
  800a32:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a38:	c9                   	leave  
  800a39:	c3                   	ret    

00800a3a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a40:	e8 f2 14 00 00       	call   801f37 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a45:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 f4             	pushl  -0xc(%ebp)
  800a54:	50                   	push   %eax
  800a55:	e8 48 ff ff ff       	call   8009a2 <vcprintf>
  800a5a:	83 c4 10             	add    $0x10,%esp
  800a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a60:	e8 ec 14 00 00       	call   801f51 <sys_enable_interrupt>
	return cnt;
  800a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a68:	c9                   	leave  
  800a69:	c3                   	ret    

00800a6a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a6a:	55                   	push   %ebp
  800a6b:	89 e5                	mov    %esp,%ebp
  800a6d:	53                   	push   %ebx
  800a6e:	83 ec 14             	sub    $0x14,%esp
  800a71:	8b 45 10             	mov    0x10(%ebp),%eax
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a7d:	8b 45 18             	mov    0x18(%ebp),%eax
  800a80:	ba 00 00 00 00       	mov    $0x0,%edx
  800a85:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a88:	77 55                	ja     800adf <printnum+0x75>
  800a8a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a8d:	72 05                	jb     800a94 <printnum+0x2a>
  800a8f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a92:	77 4b                	ja     800adf <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a94:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a97:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a9a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa2:	52                   	push   %edx
  800aa3:	50                   	push   %eax
  800aa4:	ff 75 f4             	pushl  -0xc(%ebp)
  800aa7:	ff 75 f0             	pushl  -0x10(%ebp)
  800aaa:	e8 65 2a 00 00       	call   803514 <__udivdi3>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	83 ec 04             	sub    $0x4,%esp
  800ab5:	ff 75 20             	pushl  0x20(%ebp)
  800ab8:	53                   	push   %ebx
  800ab9:	ff 75 18             	pushl  0x18(%ebp)
  800abc:	52                   	push   %edx
  800abd:	50                   	push   %eax
  800abe:	ff 75 0c             	pushl  0xc(%ebp)
  800ac1:	ff 75 08             	pushl  0x8(%ebp)
  800ac4:	e8 a1 ff ff ff       	call   800a6a <printnum>
  800ac9:	83 c4 20             	add    $0x20,%esp
  800acc:	eb 1a                	jmp    800ae8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ace:	83 ec 08             	sub    $0x8,%esp
  800ad1:	ff 75 0c             	pushl  0xc(%ebp)
  800ad4:	ff 75 20             	pushl  0x20(%ebp)
  800ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ada:	ff d0                	call   *%eax
  800adc:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800adf:	ff 4d 1c             	decl   0x1c(%ebp)
  800ae2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ae6:	7f e6                	jg     800ace <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ae8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800aeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	53                   	push   %ebx
  800af7:	51                   	push   %ecx
  800af8:	52                   	push   %edx
  800af9:	50                   	push   %eax
  800afa:	e8 25 2b 00 00       	call   803624 <__umoddi3>
  800aff:	83 c4 10             	add    $0x10,%esp
  800b02:	05 d4 3c 80 00       	add    $0x803cd4,%eax
  800b07:	8a 00                	mov    (%eax),%al
  800b09:	0f be c0             	movsbl %al,%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	50                   	push   %eax
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
}
  800b1b:	90                   	nop
  800b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b1f:	c9                   	leave  
  800b20:	c3                   	ret    

00800b21 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b24:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b28:	7e 1c                	jle    800b46 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2d:	8b 00                	mov    (%eax),%eax
  800b2f:	8d 50 08             	lea    0x8(%eax),%edx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	89 10                	mov    %edx,(%eax)
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	83 e8 08             	sub    $0x8,%eax
  800b3f:	8b 50 04             	mov    0x4(%eax),%edx
  800b42:	8b 00                	mov    (%eax),%eax
  800b44:	eb 40                	jmp    800b86 <getuint+0x65>
	else if (lflag)
  800b46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4a:	74 1e                	je     800b6a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	8b 00                	mov    (%eax),%eax
  800b51:	8d 50 04             	lea    0x4(%eax),%edx
  800b54:	8b 45 08             	mov    0x8(%ebp),%eax
  800b57:	89 10                	mov    %edx,(%eax)
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	83 e8 04             	sub    $0x4,%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	ba 00 00 00 00       	mov    $0x0,%edx
  800b68:	eb 1c                	jmp    800b86 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	8d 50 04             	lea    0x4(%eax),%edx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	89 10                	mov    %edx,(%eax)
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 00                	mov    (%eax),%eax
  800b81:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b8b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b8f:	7e 1c                	jle    800bad <getint+0x25>
		return va_arg(*ap, long long);
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 00                	mov    (%eax),%eax
  800b96:	8d 50 08             	lea    0x8(%eax),%edx
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	89 10                	mov    %edx,(%eax)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	83 e8 08             	sub    $0x8,%eax
  800ba6:	8b 50 04             	mov    0x4(%eax),%edx
  800ba9:	8b 00                	mov    (%eax),%eax
  800bab:	eb 38                	jmp    800be5 <getint+0x5d>
	else if (lflag)
  800bad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb1:	74 1a                	je     800bcd <getint+0x45>
		return va_arg(*ap, long);
  800bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb6:	8b 00                	mov    (%eax),%eax
  800bb8:	8d 50 04             	lea    0x4(%eax),%edx
  800bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbe:	89 10                	mov    %edx,(%eax)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	8b 00                	mov    (%eax),%eax
  800bc5:	83 e8 04             	sub    $0x4,%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	99                   	cltd   
  800bcb:	eb 18                	jmp    800be5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8b 00                	mov    (%eax),%eax
  800bd2:	8d 50 04             	lea    0x4(%eax),%edx
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 10                	mov    %edx,(%eax)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8b 00                	mov    (%eax),%eax
  800bdf:	83 e8 04             	sub    $0x4,%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	99                   	cltd   
}
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
  800bec:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bef:	eb 17                	jmp    800c08 <vprintfmt+0x21>
			if (ch == '\0')
  800bf1:	85 db                	test   %ebx,%ebx
  800bf3:	0f 84 af 03 00 00    	je     800fa8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bf9:	83 ec 08             	sub    $0x8,%esp
  800bfc:	ff 75 0c             	pushl  0xc(%ebp)
  800bff:	53                   	push   %ebx
  800c00:	8b 45 08             	mov    0x8(%ebp),%eax
  800c03:	ff d0                	call   *%eax
  800c05:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	83 fb 25             	cmp    $0x25,%ebx
  800c19:	75 d6                	jne    800bf1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c1b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c1f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c26:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c2d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c34:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	8d 50 01             	lea    0x1(%eax),%edx
  800c41:	89 55 10             	mov    %edx,0x10(%ebp)
  800c44:	8a 00                	mov    (%eax),%al
  800c46:	0f b6 d8             	movzbl %al,%ebx
  800c49:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c4c:	83 f8 55             	cmp    $0x55,%eax
  800c4f:	0f 87 2b 03 00 00    	ja     800f80 <vprintfmt+0x399>
  800c55:	8b 04 85 f8 3c 80 00 	mov    0x803cf8(,%eax,4),%eax
  800c5c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c5e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c62:	eb d7                	jmp    800c3b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c64:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c68:	eb d1                	jmp    800c3b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c6a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c71:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c74:	89 d0                	mov    %edx,%eax
  800c76:	c1 e0 02             	shl    $0x2,%eax
  800c79:	01 d0                	add    %edx,%eax
  800c7b:	01 c0                	add    %eax,%eax
  800c7d:	01 d8                	add    %ebx,%eax
  800c7f:	83 e8 30             	sub    $0x30,%eax
  800c82:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	8a 00                	mov    (%eax),%al
  800c8a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c8d:	83 fb 2f             	cmp    $0x2f,%ebx
  800c90:	7e 3e                	jle    800cd0 <vprintfmt+0xe9>
  800c92:	83 fb 39             	cmp    $0x39,%ebx
  800c95:	7f 39                	jg     800cd0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c97:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c9a:	eb d5                	jmp    800c71 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c9c:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9f:	83 c0 04             	add    $0x4,%eax
  800ca2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca8:	83 e8 04             	sub    $0x4,%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cb0:	eb 1f                	jmp    800cd1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cb2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cb6:	79 83                	jns    800c3b <vprintfmt+0x54>
				width = 0;
  800cb8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800cbf:	e9 77 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800cc4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800ccb:	e9 6b ff ff ff       	jmp    800c3b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800cd0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800cd1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cd5:	0f 89 60 ff ff ff    	jns    800c3b <vprintfmt+0x54>
				width = precision, precision = -1;
  800cdb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ce1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ce8:	e9 4e ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ced:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cf0:	e9 46 ff ff ff       	jmp    800c3b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cf5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf8:	83 c0 04             	add    $0x4,%eax
  800cfb:	89 45 14             	mov    %eax,0x14(%ebp)
  800cfe:	8b 45 14             	mov    0x14(%ebp),%eax
  800d01:	83 e8 04             	sub    $0x4,%eax
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	83 ec 08             	sub    $0x8,%esp
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	50                   	push   %eax
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	ff d0                	call   *%eax
  800d12:	83 c4 10             	add    $0x10,%esp
			break;
  800d15:	e9 89 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800d1d:	83 c0 04             	add    $0x4,%eax
  800d20:	89 45 14             	mov    %eax,0x14(%ebp)
  800d23:	8b 45 14             	mov    0x14(%ebp),%eax
  800d26:	83 e8 04             	sub    $0x4,%eax
  800d29:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d2b:	85 db                	test   %ebx,%ebx
  800d2d:	79 02                	jns    800d31 <vprintfmt+0x14a>
				err = -err;
  800d2f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d31:	83 fb 64             	cmp    $0x64,%ebx
  800d34:	7f 0b                	jg     800d41 <vprintfmt+0x15a>
  800d36:	8b 34 9d 40 3b 80 00 	mov    0x803b40(,%ebx,4),%esi
  800d3d:	85 f6                	test   %esi,%esi
  800d3f:	75 19                	jne    800d5a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d41:	53                   	push   %ebx
  800d42:	68 e5 3c 80 00       	push   $0x803ce5
  800d47:	ff 75 0c             	pushl  0xc(%ebp)
  800d4a:	ff 75 08             	pushl  0x8(%ebp)
  800d4d:	e8 5e 02 00 00       	call   800fb0 <printfmt>
  800d52:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d55:	e9 49 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d5a:	56                   	push   %esi
  800d5b:	68 ee 3c 80 00       	push   $0x803cee
  800d60:	ff 75 0c             	pushl  0xc(%ebp)
  800d63:	ff 75 08             	pushl  0x8(%ebp)
  800d66:	e8 45 02 00 00       	call   800fb0 <printfmt>
  800d6b:	83 c4 10             	add    $0x10,%esp
			break;
  800d6e:	e9 30 02 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d73:	8b 45 14             	mov    0x14(%ebp),%eax
  800d76:	83 c0 04             	add    $0x4,%eax
  800d79:	89 45 14             	mov    %eax,0x14(%ebp)
  800d7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d7f:	83 e8 04             	sub    $0x4,%eax
  800d82:	8b 30                	mov    (%eax),%esi
  800d84:	85 f6                	test   %esi,%esi
  800d86:	75 05                	jne    800d8d <vprintfmt+0x1a6>
				p = "(null)";
  800d88:	be f1 3c 80 00       	mov    $0x803cf1,%esi
			if (width > 0 && padc != '-')
  800d8d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d91:	7e 6d                	jle    800e00 <vprintfmt+0x219>
  800d93:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d97:	74 67                	je     800e00 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d99:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d9c:	83 ec 08             	sub    $0x8,%esp
  800d9f:	50                   	push   %eax
  800da0:	56                   	push   %esi
  800da1:	e8 0c 03 00 00       	call   8010b2 <strnlen>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dac:	eb 16                	jmp    800dc4 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800dae:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800db2:	83 ec 08             	sub    $0x8,%esp
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	ff d0                	call   *%eax
  800dbe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800dc1:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dc8:	7f e4                	jg     800dae <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	eb 34                	jmp    800e00 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800dcc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800dd0:	74 1c                	je     800dee <vprintfmt+0x207>
  800dd2:	83 fb 1f             	cmp    $0x1f,%ebx
  800dd5:	7e 05                	jle    800ddc <vprintfmt+0x1f5>
  800dd7:	83 fb 7e             	cmp    $0x7e,%ebx
  800dda:	7e 12                	jle    800dee <vprintfmt+0x207>
					putch('?', putdat);
  800ddc:	83 ec 08             	sub    $0x8,%esp
  800ddf:	ff 75 0c             	pushl  0xc(%ebp)
  800de2:	6a 3f                	push   $0x3f
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	ff d0                	call   *%eax
  800de9:	83 c4 10             	add    $0x10,%esp
  800dec:	eb 0f                	jmp    800dfd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dee:	83 ec 08             	sub    $0x8,%esp
  800df1:	ff 75 0c             	pushl  0xc(%ebp)
  800df4:	53                   	push   %ebx
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	ff d0                	call   *%eax
  800dfa:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dfd:	ff 4d e4             	decl   -0x1c(%ebp)
  800e00:	89 f0                	mov    %esi,%eax
  800e02:	8d 70 01             	lea    0x1(%eax),%esi
  800e05:	8a 00                	mov    (%eax),%al
  800e07:	0f be d8             	movsbl %al,%ebx
  800e0a:	85 db                	test   %ebx,%ebx
  800e0c:	74 24                	je     800e32 <vprintfmt+0x24b>
  800e0e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e12:	78 b8                	js     800dcc <vprintfmt+0x1e5>
  800e14:	ff 4d e0             	decl   -0x20(%ebp)
  800e17:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e1b:	79 af                	jns    800dcc <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e1d:	eb 13                	jmp    800e32 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e1f:	83 ec 08             	sub    $0x8,%esp
  800e22:	ff 75 0c             	pushl  0xc(%ebp)
  800e25:	6a 20                	push   $0x20
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	ff d0                	call   *%eax
  800e2c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e2f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e32:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e36:	7f e7                	jg     800e1f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e38:	e9 66 01 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e3d:	83 ec 08             	sub    $0x8,%esp
  800e40:	ff 75 e8             	pushl  -0x18(%ebp)
  800e43:	8d 45 14             	lea    0x14(%ebp),%eax
  800e46:	50                   	push   %eax
  800e47:	e8 3c fd ff ff       	call   800b88 <getint>
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e52:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e5b:	85 d2                	test   %edx,%edx
  800e5d:	79 23                	jns    800e82 <vprintfmt+0x29b>
				putch('-', putdat);
  800e5f:	83 ec 08             	sub    $0x8,%esp
  800e62:	ff 75 0c             	pushl  0xc(%ebp)
  800e65:	6a 2d                	push   $0x2d
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	ff d0                	call   *%eax
  800e6c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e75:	f7 d8                	neg    %eax
  800e77:	83 d2 00             	adc    $0x0,%edx
  800e7a:	f7 da                	neg    %edx
  800e7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e89:	e9 bc 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e8e:	83 ec 08             	sub    $0x8,%esp
  800e91:	ff 75 e8             	pushl  -0x18(%ebp)
  800e94:	8d 45 14             	lea    0x14(%ebp),%eax
  800e97:	50                   	push   %eax
  800e98:	e8 84 fc ff ff       	call   800b21 <getuint>
  800e9d:	83 c4 10             	add    $0x10,%esp
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ea6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ead:	e9 98 00 00 00       	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800eb2:	83 ec 08             	sub    $0x8,%esp
  800eb5:	ff 75 0c             	pushl  0xc(%ebp)
  800eb8:	6a 58                	push   $0x58
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	ff d0                	call   *%eax
  800ebf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ec2:	83 ec 08             	sub    $0x8,%esp
  800ec5:	ff 75 0c             	pushl  0xc(%ebp)
  800ec8:	6a 58                	push   $0x58
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	ff d0                	call   *%eax
  800ecf:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ed2:	83 ec 08             	sub    $0x8,%esp
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	6a 58                	push   $0x58
  800eda:	8b 45 08             	mov    0x8(%ebp),%eax
  800edd:	ff d0                	call   *%eax
  800edf:	83 c4 10             	add    $0x10,%esp
			break;
  800ee2:	e9 bc 00 00 00       	jmp    800fa3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ee7:	83 ec 08             	sub    $0x8,%esp
  800eea:	ff 75 0c             	pushl  0xc(%ebp)
  800eed:	6a 30                	push   $0x30
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	ff d0                	call   *%eax
  800ef4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	6a 78                	push   $0x78
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	ff d0                	call   *%eax
  800f04:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f07:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0a:	83 c0 04             	add    $0x4,%eax
  800f0d:	89 45 14             	mov    %eax,0x14(%ebp)
  800f10:	8b 45 14             	mov    0x14(%ebp),%eax
  800f13:	83 e8 04             	sub    $0x4,%eax
  800f16:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f22:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f29:	eb 1f                	jmp    800f4a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f2b:	83 ec 08             	sub    $0x8,%esp
  800f2e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f31:	8d 45 14             	lea    0x14(%ebp),%eax
  800f34:	50                   	push   %eax
  800f35:	e8 e7 fb ff ff       	call   800b21 <getuint>
  800f3a:	83 c4 10             	add    $0x10,%esp
  800f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f40:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f43:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f4a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f51:	83 ec 04             	sub    $0x4,%esp
  800f54:	52                   	push   %edx
  800f55:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f58:	50                   	push   %eax
  800f59:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800f5f:	ff 75 0c             	pushl  0xc(%ebp)
  800f62:	ff 75 08             	pushl  0x8(%ebp)
  800f65:	e8 00 fb ff ff       	call   800a6a <printnum>
  800f6a:	83 c4 20             	add    $0x20,%esp
			break;
  800f6d:	eb 34                	jmp    800fa3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f6f:	83 ec 08             	sub    $0x8,%esp
  800f72:	ff 75 0c             	pushl  0xc(%ebp)
  800f75:	53                   	push   %ebx
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	ff d0                	call   *%eax
  800f7b:	83 c4 10             	add    $0x10,%esp
			break;
  800f7e:	eb 23                	jmp    800fa3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f80:	83 ec 08             	sub    $0x8,%esp
  800f83:	ff 75 0c             	pushl  0xc(%ebp)
  800f86:	6a 25                	push   $0x25
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	ff d0                	call   *%eax
  800f8d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f90:	ff 4d 10             	decl   0x10(%ebp)
  800f93:	eb 03                	jmp    800f98 <vprintfmt+0x3b1>
  800f95:	ff 4d 10             	decl   0x10(%ebp)
  800f98:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9b:	48                   	dec    %eax
  800f9c:	8a 00                	mov    (%eax),%al
  800f9e:	3c 25                	cmp    $0x25,%al
  800fa0:	75 f3                	jne    800f95 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fa2:	90                   	nop
		}
	}
  800fa3:	e9 47 fc ff ff       	jmp    800bef <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fa8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800fb6:	8d 45 10             	lea    0x10(%ebp),%eax
  800fb9:	83 c0 04             	add    $0x4,%eax
  800fbc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fc5:	50                   	push   %eax
  800fc6:	ff 75 0c             	pushl  0xc(%ebp)
  800fc9:	ff 75 08             	pushl  0x8(%ebp)
  800fcc:	e8 16 fc ff ff       	call   800be7 <vprintfmt>
  800fd1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fd4:	90                   	nop
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdd:	8b 40 08             	mov    0x8(%eax),%eax
  800fe0:	8d 50 01             	lea    0x1(%eax),%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fec:	8b 10                	mov    (%eax),%edx
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	8b 40 04             	mov    0x4(%eax),%eax
  800ff4:	39 c2                	cmp    %eax,%edx
  800ff6:	73 12                	jae    80100a <sprintputch+0x33>
		*b->buf++ = ch;
  800ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffb:	8b 00                	mov    (%eax),%eax
  800ffd:	8d 48 01             	lea    0x1(%eax),%ecx
  801000:	8b 55 0c             	mov    0xc(%ebp),%edx
  801003:	89 0a                	mov    %ecx,(%edx)
  801005:	8b 55 08             	mov    0x8(%ebp),%edx
  801008:	88 10                	mov    %dl,(%eax)
}
  80100a:	90                   	nop
  80100b:	5d                   	pop    %ebp
  80100c:	c3                   	ret    

0080100d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801019:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801027:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80102e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801032:	74 06                	je     80103a <vsnprintf+0x2d>
  801034:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801038:	7f 07                	jg     801041 <vsnprintf+0x34>
		return -E_INVAL;
  80103a:	b8 03 00 00 00       	mov    $0x3,%eax
  80103f:	eb 20                	jmp    801061 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801041:	ff 75 14             	pushl  0x14(%ebp)
  801044:	ff 75 10             	pushl  0x10(%ebp)
  801047:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80104a:	50                   	push   %eax
  80104b:	68 d7 0f 80 00       	push   $0x800fd7
  801050:	e8 92 fb ff ff       	call   800be7 <vprintfmt>
  801055:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801058:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80105b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80105e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    

00801063 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801069:	8d 45 10             	lea    0x10(%ebp),%eax
  80106c:	83 c0 04             	add    $0x4,%eax
  80106f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801072:	8b 45 10             	mov    0x10(%ebp),%eax
  801075:	ff 75 f4             	pushl  -0xc(%ebp)
  801078:	50                   	push   %eax
  801079:	ff 75 0c             	pushl  0xc(%ebp)
  80107c:	ff 75 08             	pushl  0x8(%ebp)
  80107f:	e8 89 ff ff ff       	call   80100d <vsnprintf>
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80108a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80108d:	c9                   	leave  
  80108e:	c3                   	ret    

0080108f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801095:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80109c:	eb 06                	jmp    8010a4 <strlen+0x15>
		n++;
  80109e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010a1:	ff 45 08             	incl   0x8(%ebp)
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	84 c0                	test   %al,%al
  8010ab:	75 f1                	jne    80109e <strlen+0xf>
		n++;
	return n;
  8010ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b0:	c9                   	leave  
  8010b1:	c3                   	ret    

008010b2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010b2:	55                   	push   %ebp
  8010b3:	89 e5                	mov    %esp,%ebp
  8010b5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010bf:	eb 09                	jmp    8010ca <strnlen+0x18>
		n++;
  8010c1:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010c4:	ff 45 08             	incl   0x8(%ebp)
  8010c7:	ff 4d 0c             	decl   0xc(%ebp)
  8010ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010ce:	74 09                	je     8010d9 <strnlen+0x27>
  8010d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d3:	8a 00                	mov    (%eax),%al
  8010d5:	84 c0                	test   %al,%al
  8010d7:	75 e8                	jne    8010c1 <strnlen+0xf>
		n++;
	return n;
  8010d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010dc:	c9                   	leave  
  8010dd:	c3                   	ret    

008010de <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
  8010e1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010ea:	90                   	nop
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	8d 50 01             	lea    0x1(%eax),%edx
  8010f1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010fa:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fd:	8a 12                	mov    (%edx),%dl
  8010ff:	88 10                	mov    %dl,(%eax)
  801101:	8a 00                	mov    (%eax),%al
  801103:	84 c0                	test   %al,%al
  801105:	75 e4                	jne    8010eb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801107:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    

0080110c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80110c:	55                   	push   %ebp
  80110d:	89 e5                	mov    %esp,%ebp
  80110f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801118:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80111f:	eb 1f                	jmp    801140 <strncpy+0x34>
		*dst++ = *src;
  801121:	8b 45 08             	mov    0x8(%ebp),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	89 55 08             	mov    %edx,0x8(%ebp)
  80112a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80112d:	8a 12                	mov    (%edx),%dl
  80112f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801131:	8b 45 0c             	mov    0xc(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	84 c0                	test   %al,%al
  801138:	74 03                	je     80113d <strncpy+0x31>
			src++;
  80113a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80113d:	ff 45 fc             	incl   -0x4(%ebp)
  801140:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801143:	3b 45 10             	cmp    0x10(%ebp),%eax
  801146:	72 d9                	jb     801121 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801148:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80114b:	c9                   	leave  
  80114c:	c3                   	ret    

0080114d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80114d:	55                   	push   %ebp
  80114e:	89 e5                	mov    %esp,%ebp
  801150:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801159:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115d:	74 30                	je     80118f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80115f:	eb 16                	jmp    801177 <strlcpy+0x2a>
			*dst++ = *src++;
  801161:	8b 45 08             	mov    0x8(%ebp),%eax
  801164:	8d 50 01             	lea    0x1(%eax),%edx
  801167:	89 55 08             	mov    %edx,0x8(%ebp)
  80116a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801170:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801173:	8a 12                	mov    (%edx),%dl
  801175:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801177:	ff 4d 10             	decl   0x10(%ebp)
  80117a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117e:	74 09                	je     801189 <strlcpy+0x3c>
  801180:	8b 45 0c             	mov    0xc(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	84 c0                	test   %al,%al
  801187:	75 d8                	jne    801161 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80118f:	8b 55 08             	mov    0x8(%ebp),%edx
  801192:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801195:	29 c2                	sub    %eax,%edx
  801197:	89 d0                	mov    %edx,%eax
}
  801199:	c9                   	leave  
  80119a:	c3                   	ret    

0080119b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80119e:	eb 06                	jmp    8011a6 <strcmp+0xb>
		p++, q++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	8a 00                	mov    (%eax),%al
  8011ab:	84 c0                	test   %al,%al
  8011ad:	74 0e                	je     8011bd <strcmp+0x22>
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	8a 10                	mov    (%eax),%dl
  8011b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b7:	8a 00                	mov    (%eax),%al
  8011b9:	38 c2                	cmp    %al,%dl
  8011bb:	74 e3                	je     8011a0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 d0             	movzbl %al,%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	8a 00                	mov    (%eax),%al
  8011ca:	0f b6 c0             	movzbl %al,%eax
  8011cd:	29 c2                	sub    %eax,%edx
  8011cf:	89 d0                	mov    %edx,%eax
}
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8011d6:	eb 09                	jmp    8011e1 <strncmp+0xe>
		n--, p++, q++;
  8011d8:	ff 4d 10             	decl   0x10(%ebp)
  8011db:	ff 45 08             	incl   0x8(%ebp)
  8011de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e5:	74 17                	je     8011fe <strncmp+0x2b>
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	84 c0                	test   %al,%al
  8011ee:	74 0e                	je     8011fe <strncmp+0x2b>
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8a 10                	mov    (%eax),%dl
  8011f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f8:	8a 00                	mov    (%eax),%al
  8011fa:	38 c2                	cmp    %al,%dl
  8011fc:	74 da                	je     8011d8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801202:	75 07                	jne    80120b <strncmp+0x38>
		return 0;
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	eb 14                	jmp    80121f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	0f b6 d0             	movzbl %al,%edx
  801213:	8b 45 0c             	mov    0xc(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	0f b6 c0             	movzbl %al,%eax
  80121b:	29 c2                	sub    %eax,%edx
  80121d:	89 d0                	mov    %edx,%eax
}
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 04             	sub    $0x4,%esp
  801227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80122d:	eb 12                	jmp    801241 <strchr+0x20>
		if (*s == c)
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	8a 00                	mov    (%eax),%al
  801234:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801237:	75 05                	jne    80123e <strchr+0x1d>
			return (char *) s;
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	eb 11                	jmp    80124f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80123e:	ff 45 08             	incl   0x8(%ebp)
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	84 c0                	test   %al,%al
  801248:	75 e5                	jne    80122f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80124a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80124f:	c9                   	leave  
  801250:	c3                   	ret    

00801251 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801251:	55                   	push   %ebp
  801252:	89 e5                	mov    %esp,%ebp
  801254:	83 ec 04             	sub    $0x4,%esp
  801257:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80125d:	eb 0d                	jmp    80126c <strfind+0x1b>
		if (*s == c)
  80125f:	8b 45 08             	mov    0x8(%ebp),%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801267:	74 0e                	je     801277 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801269:	ff 45 08             	incl   0x8(%ebp)
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	75 ea                	jne    80125f <strfind+0xe>
  801275:	eb 01                	jmp    801278 <strfind+0x27>
		if (*s == c)
			break;
  801277:	90                   	nop
	return (char *) s;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801289:	8b 45 10             	mov    0x10(%ebp),%eax
  80128c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80128f:	eb 0e                	jmp    80129f <memset+0x22>
		*p++ = c;
  801291:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801294:	8d 50 01             	lea    0x1(%eax),%edx
  801297:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80129a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80129d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80129f:	ff 4d f8             	decl   -0x8(%ebp)
  8012a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012a6:	79 e9                	jns    801291 <memset+0x14>
		*p++ = c;

	return v;
  8012a8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ab:	c9                   	leave  
  8012ac:	c3                   	ret    

008012ad <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
  8012b0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8012bf:	eb 16                	jmp    8012d7 <memcpy+0x2a>
		*d++ = *s++;
  8012c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c4:	8d 50 01             	lea    0x1(%eax),%edx
  8012c7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d3:	8a 12                	mov    (%edx),%dl
  8012d5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012dd:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	75 dd                	jne    8012c1 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012e7:	c9                   	leave  
  8012e8:	c3                   	ret    

008012e9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012fe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801301:	73 50                	jae    801353 <memmove+0x6a>
  801303:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801306:	8b 45 10             	mov    0x10(%ebp),%eax
  801309:	01 d0                	add    %edx,%eax
  80130b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80130e:	76 43                	jbe    801353 <memmove+0x6a>
		s += n;
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801316:	8b 45 10             	mov    0x10(%ebp),%eax
  801319:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80131c:	eb 10                	jmp    80132e <memmove+0x45>
			*--d = *--s;
  80131e:	ff 4d f8             	decl   -0x8(%ebp)
  801321:	ff 4d fc             	decl   -0x4(%ebp)
  801324:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801327:	8a 10                	mov    (%eax),%dl
  801329:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80132e:	8b 45 10             	mov    0x10(%ebp),%eax
  801331:	8d 50 ff             	lea    -0x1(%eax),%edx
  801334:	89 55 10             	mov    %edx,0x10(%ebp)
  801337:	85 c0                	test   %eax,%eax
  801339:	75 e3                	jne    80131e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80133b:	eb 23                	jmp    801360 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	8d 50 01             	lea    0x1(%eax),%edx
  801343:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801346:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801349:	8d 4a 01             	lea    0x1(%edx),%ecx
  80134c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80134f:	8a 12                	mov    (%edx),%dl
  801351:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	8d 50 ff             	lea    -0x1(%eax),%edx
  801359:	89 55 10             	mov    %edx,0x10(%ebp)
  80135c:	85 c0                	test   %eax,%eax
  80135e:	75 dd                	jne    80133d <memmove+0x54>
			*d++ = *s++;

	return dst;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801377:	eb 2a                	jmp    8013a3 <memcmp+0x3e>
		if (*s1 != *s2)
  801379:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80137c:	8a 10                	mov    (%eax),%dl
  80137e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	38 c2                	cmp    %al,%dl
  801385:	74 16                	je     80139d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801387:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	0f b6 d0             	movzbl %al,%edx
  80138f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 c0             	movzbl %al,%eax
  801397:	29 c2                	sub    %eax,%edx
  801399:	89 d0                	mov    %edx,%eax
  80139b:	eb 18                	jmp    8013b5 <memcmp+0x50>
		s1++, s2++;
  80139d:	ff 45 fc             	incl   -0x4(%ebp)
  8013a0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 c9                	jne    801379 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b5:	c9                   	leave  
  8013b6:	c3                   	ret    

008013b7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c3:	01 d0                	add    %edx,%eax
  8013c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8013c8:	eb 15                	jmp    8013df <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8013ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cd:	8a 00                	mov    (%eax),%al
  8013cf:	0f b6 d0             	movzbl %al,%edx
  8013d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d5:	0f b6 c0             	movzbl %al,%eax
  8013d8:	39 c2                	cmp    %eax,%edx
  8013da:	74 0d                	je     8013e9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013dc:	ff 45 08             	incl   0x8(%ebp)
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013e5:	72 e3                	jb     8013ca <memfind+0x13>
  8013e7:	eb 01                	jmp    8013ea <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013e9:	90                   	nop
	return (void *) s;
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013ed:	c9                   	leave  
  8013ee:	c3                   	ret    

008013ef <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013fc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801403:	eb 03                	jmp    801408 <strtol+0x19>
		s++;
  801405:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	8a 00                	mov    (%eax),%al
  80140d:	3c 20                	cmp    $0x20,%al
  80140f:	74 f4                	je     801405 <strtol+0x16>
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	8a 00                	mov    (%eax),%al
  801416:	3c 09                	cmp    $0x9,%al
  801418:	74 eb                	je     801405 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	3c 2b                	cmp    $0x2b,%al
  801421:	75 05                	jne    801428 <strtol+0x39>
		s++;
  801423:	ff 45 08             	incl   0x8(%ebp)
  801426:	eb 13                	jmp    80143b <strtol+0x4c>
	else if (*s == '-')
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8a 00                	mov    (%eax),%al
  80142d:	3c 2d                	cmp    $0x2d,%al
  80142f:	75 0a                	jne    80143b <strtol+0x4c>
		s++, neg = 1;
  801431:	ff 45 08             	incl   0x8(%ebp)
  801434:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80143b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80143f:	74 06                	je     801447 <strtol+0x58>
  801441:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801445:	75 20                	jne    801467 <strtol+0x78>
  801447:	8b 45 08             	mov    0x8(%ebp),%eax
  80144a:	8a 00                	mov    (%eax),%al
  80144c:	3c 30                	cmp    $0x30,%al
  80144e:	75 17                	jne    801467 <strtol+0x78>
  801450:	8b 45 08             	mov    0x8(%ebp),%eax
  801453:	40                   	inc    %eax
  801454:	8a 00                	mov    (%eax),%al
  801456:	3c 78                	cmp    $0x78,%al
  801458:	75 0d                	jne    801467 <strtol+0x78>
		s += 2, base = 16;
  80145a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80145e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801465:	eb 28                	jmp    80148f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80146b:	75 15                	jne    801482 <strtol+0x93>
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	3c 30                	cmp    $0x30,%al
  801474:	75 0c                	jne    801482 <strtol+0x93>
		s++, base = 8;
  801476:	ff 45 08             	incl   0x8(%ebp)
  801479:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801480:	eb 0d                	jmp    80148f <strtol+0xa0>
	else if (base == 0)
  801482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801486:	75 07                	jne    80148f <strtol+0xa0>
		base = 10;
  801488:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	3c 2f                	cmp    $0x2f,%al
  801496:	7e 19                	jle    8014b1 <strtol+0xc2>
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 39                	cmp    $0x39,%al
  80149f:	7f 10                	jg     8014b1 <strtol+0xc2>
			dig = *s - '0';
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	0f be c0             	movsbl %al,%eax
  8014a9:	83 e8 30             	sub    $0x30,%eax
  8014ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014af:	eb 42                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b4:	8a 00                	mov    (%eax),%al
  8014b6:	3c 60                	cmp    $0x60,%al
  8014b8:	7e 19                	jle    8014d3 <strtol+0xe4>
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	3c 7a                	cmp    $0x7a,%al
  8014c1:	7f 10                	jg     8014d3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	8a 00                	mov    (%eax),%al
  8014c8:	0f be c0             	movsbl %al,%eax
  8014cb:	83 e8 57             	sub    $0x57,%eax
  8014ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014d1:	eb 20                	jmp    8014f3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	8a 00                	mov    (%eax),%al
  8014d8:	3c 40                	cmp    $0x40,%al
  8014da:	7e 39                	jle    801515 <strtol+0x126>
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	8a 00                	mov    (%eax),%al
  8014e1:	3c 5a                	cmp    $0x5a,%al
  8014e3:	7f 30                	jg     801515 <strtol+0x126>
			dig = *s - 'A' + 10;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	0f be c0             	movsbl %al,%eax
  8014ed:	83 e8 37             	sub    $0x37,%eax
  8014f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014f9:	7d 19                	jge    801514 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014fb:	ff 45 08             	incl   0x8(%ebp)
  8014fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801501:	0f af 45 10          	imul   0x10(%ebp),%eax
  801505:	89 c2                	mov    %eax,%edx
  801507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80150a:	01 d0                	add    %edx,%eax
  80150c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80150f:	e9 7b ff ff ff       	jmp    80148f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801514:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801515:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801519:	74 08                	je     801523 <strtol+0x134>
		*endptr = (char *) s;
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	8b 55 08             	mov    0x8(%ebp),%edx
  801521:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801523:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801527:	74 07                	je     801530 <strtol+0x141>
  801529:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152c:	f7 d8                	neg    %eax
  80152e:	eb 03                	jmp    801533 <strtol+0x144>
  801530:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801533:	c9                   	leave  
  801534:	c3                   	ret    

00801535 <ltostr>:

void
ltostr(long value, char *str)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80153b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801542:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801549:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80154d:	79 13                	jns    801562 <ltostr+0x2d>
	{
		neg = 1;
  80154f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80155c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80155f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80156a:	99                   	cltd   
  80156b:	f7 f9                	idiv   %ecx
  80156d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801579:	89 c2                	mov    %eax,%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 d0                	add    %edx,%eax
  801580:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801583:	83 c2 30             	add    $0x30,%edx
  801586:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801588:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801590:	f7 e9                	imul   %ecx
  801592:	c1 fa 02             	sar    $0x2,%edx
  801595:	89 c8                	mov    %ecx,%eax
  801597:	c1 f8 1f             	sar    $0x1f,%eax
  80159a:	29 c2                	sub    %eax,%edx
  80159c:	89 d0                	mov    %edx,%eax
  80159e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015a9:	f7 e9                	imul   %ecx
  8015ab:	c1 fa 02             	sar    $0x2,%edx
  8015ae:	89 c8                	mov    %ecx,%eax
  8015b0:	c1 f8 1f             	sar    $0x1f,%eax
  8015b3:	29 c2                	sub    %eax,%edx
  8015b5:	89 d0                	mov    %edx,%eax
  8015b7:	c1 e0 02             	shl    $0x2,%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	01 c0                	add    %eax,%eax
  8015be:	29 c1                	sub    %eax,%ecx
  8015c0:	89 ca                	mov    %ecx,%edx
  8015c2:	85 d2                	test   %edx,%edx
  8015c4:	75 9c                	jne    801562 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8015c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8015cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015d0:	48                   	dec    %eax
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8015d4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015d8:	74 3d                	je     801617 <ltostr+0xe2>
		start = 1 ;
  8015da:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015e1:	eb 34                	jmp    801617 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e9:	01 d0                	add    %edx,%eax
  8015eb:	8a 00                	mov    (%eax),%al
  8015ed:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801604:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801607:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160a:	01 c2                	add    %eax,%edx
  80160c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80160f:	88 02                	mov    %al,(%edx)
		start++ ;
  801611:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801614:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80161d:	7c c4                	jl     8015e3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80161f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801622:	8b 45 0c             	mov    0xc(%ebp),%eax
  801625:	01 d0                	add    %edx,%eax
  801627:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80162a:	90                   	nop
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801633:	ff 75 08             	pushl  0x8(%ebp)
  801636:	e8 54 fa ff ff       	call   80108f <strlen>
  80163b:	83 c4 04             	add    $0x4,%esp
  80163e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	e8 46 fa ff ff       	call   80108f <strlen>
  801649:	83 c4 04             	add    $0x4,%esp
  80164c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80164f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801656:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80165d:	eb 17                	jmp    801676 <strcconcat+0x49>
		final[s] = str1[s] ;
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 c2                	add    %eax,%edx
  801667:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	01 c8                	add    %ecx,%eax
  80166f:	8a 00                	mov    (%eax),%al
  801671:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801673:	ff 45 fc             	incl   -0x4(%ebp)
  801676:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801679:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80167c:	7c e1                	jl     80165f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80167e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801685:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80168c:	eb 1f                	jmp    8016ad <strcconcat+0x80>
		final[s++] = str2[i] ;
  80168e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801691:	8d 50 01             	lea    0x1(%eax),%edx
  801694:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801697:	89 c2                	mov    %eax,%edx
  801699:	8b 45 10             	mov    0x10(%ebp),%eax
  80169c:	01 c2                	add    %eax,%edx
  80169e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a4:	01 c8                	add    %ecx,%eax
  8016a6:	8a 00                	mov    (%eax),%al
  8016a8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016aa:	ff 45 f8             	incl   -0x8(%ebp)
  8016ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016b0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016b3:	7c d9                	jl     80168e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bb:	01 d0                	add    %edx,%eax
  8016bd:	c6 00 00             	movb   $0x0,(%eax)
}
  8016c0:	90                   	nop
  8016c1:	c9                   	leave  
  8016c2:	c3                   	ret    

008016c3 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8016c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8016cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d2:	8b 00                	mov    (%eax),%eax
  8016d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 d0                	add    %edx,%eax
  8016e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016e6:	eb 0c                	jmp    8016f4 <strsplit+0x31>
			*string++ = 0;
  8016e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016eb:	8d 50 01             	lea    0x1(%eax),%edx
  8016ee:	89 55 08             	mov    %edx,0x8(%ebp)
  8016f1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f7:	8a 00                	mov    (%eax),%al
  8016f9:	84 c0                	test   %al,%al
  8016fb:	74 18                	je     801715 <strsplit+0x52>
  8016fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801700:	8a 00                	mov    (%eax),%al
  801702:	0f be c0             	movsbl %al,%eax
  801705:	50                   	push   %eax
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	e8 13 fb ff ff       	call   801221 <strchr>
  80170e:	83 c4 08             	add    $0x8,%esp
  801711:	85 c0                	test   %eax,%eax
  801713:	75 d3                	jne    8016e8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 5a                	je     801778 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80171e:	8b 45 14             	mov    0x14(%ebp),%eax
  801721:	8b 00                	mov    (%eax),%eax
  801723:	83 f8 0f             	cmp    $0xf,%eax
  801726:	75 07                	jne    80172f <strsplit+0x6c>
		{
			return 0;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 66                	jmp    801795 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80172f:	8b 45 14             	mov    0x14(%ebp),%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	8d 48 01             	lea    0x1(%eax),%ecx
  801737:	8b 55 14             	mov    0x14(%ebp),%edx
  80173a:	89 0a                	mov    %ecx,(%edx)
  80173c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801743:	8b 45 10             	mov    0x10(%ebp),%eax
  801746:	01 c2                	add    %eax,%edx
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80174d:	eb 03                	jmp    801752 <strsplit+0x8f>
			string++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	84 c0                	test   %al,%al
  801759:	74 8b                	je     8016e6 <strsplit+0x23>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	0f be c0             	movsbl %al,%eax
  801763:	50                   	push   %eax
  801764:	ff 75 0c             	pushl  0xc(%ebp)
  801767:	e8 b5 fa ff ff       	call   801221 <strchr>
  80176c:	83 c4 08             	add    $0x8,%esp
  80176f:	85 c0                	test   %eax,%eax
  801771:	74 dc                	je     80174f <strsplit+0x8c>
			string++;
	}
  801773:	e9 6e ff ff ff       	jmp    8016e6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801778:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801779:	8b 45 14             	mov    0x14(%ebp),%eax
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801790:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801795:	c9                   	leave  
  801796:	c3                   	ret    

00801797 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801797:	55                   	push   %ebp
  801798:	89 e5                	mov    %esp,%ebp
  80179a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80179d:	a1 04 50 80 00       	mov    0x805004,%eax
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	74 1f                	je     8017c5 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017a6:	e8 1d 00 00 00       	call   8017c8 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ab:	83 ec 0c             	sub    $0xc,%esp
  8017ae:	68 50 3e 80 00       	push   $0x803e50
  8017b3:	e8 55 f2 ff ff       	call   800a0d <cprintf>
  8017b8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017bb:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8017c2:	00 00 00 
	}
}
  8017c5:	90                   	nop
  8017c6:	c9                   	leave  
  8017c7:	c3                   	ret    

008017c8 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8017ce:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8017d5:	00 00 00 
  8017d8:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017df:	00 00 00 
  8017e2:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8017e9:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8017ec:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8017f3:	00 00 00 
  8017f6:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017fd:	00 00 00 
  801800:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801807:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80180a:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801814:	c1 e8 0c             	shr    $0xc,%eax
  801817:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80181c:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801826:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80182b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801830:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801835:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80183c:	a1 20 51 80 00       	mov    0x805120,%eax
  801841:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801845:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801848:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80184f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801852:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	48                   	dec    %eax
  801858:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80185b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80185e:	ba 00 00 00 00       	mov    $0x0,%edx
  801863:	f7 75 e4             	divl   -0x1c(%ebp)
  801866:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801869:	29 d0                	sub    %edx,%eax
  80186b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  80186e:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801875:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801878:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80187d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	6a 07                	push   $0x7
  801887:	ff 75 e8             	pushl  -0x18(%ebp)
  80188a:	50                   	push   %eax
  80188b:	e8 3d 06 00 00       	call   801ecd <sys_allocate_chunk>
  801890:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801893:	a1 20 51 80 00       	mov    0x805120,%eax
  801898:	83 ec 0c             	sub    $0xc,%esp
  80189b:	50                   	push   %eax
  80189c:	e8 b2 0c 00 00       	call   802553 <initialize_MemBlocksList>
  8018a1:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8018a4:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8018a9:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8018ac:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018b0:	0f 84 f3 00 00 00    	je     8019a9 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8018b6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018ba:	75 14                	jne    8018d0 <initialize_dyn_block_system+0x108>
  8018bc:	83 ec 04             	sub    $0x4,%esp
  8018bf:	68 75 3e 80 00       	push   $0x803e75
  8018c4:	6a 36                	push   $0x36
  8018c6:	68 93 3e 80 00       	push   $0x803e93
  8018cb:	e8 89 ee ff ff       	call   800759 <_panic>
  8018d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018d3:	8b 00                	mov    (%eax),%eax
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	74 10                	je     8018e9 <initialize_dyn_block_system+0x121>
  8018d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018dc:	8b 00                	mov    (%eax),%eax
  8018de:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018e1:	8b 52 04             	mov    0x4(%edx),%edx
  8018e4:	89 50 04             	mov    %edx,0x4(%eax)
  8018e7:	eb 0b                	jmp    8018f4 <initialize_dyn_block_system+0x12c>
  8018e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018ec:	8b 40 04             	mov    0x4(%eax),%eax
  8018ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8018f4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018f7:	8b 40 04             	mov    0x4(%eax),%eax
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	74 0f                	je     80190d <initialize_dyn_block_system+0x145>
  8018fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801901:	8b 40 04             	mov    0x4(%eax),%eax
  801904:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801907:	8b 12                	mov    (%edx),%edx
  801909:	89 10                	mov    %edx,(%eax)
  80190b:	eb 0a                	jmp    801917 <initialize_dyn_block_system+0x14f>
  80190d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801910:	8b 00                	mov    (%eax),%eax
  801912:	a3 48 51 80 00       	mov    %eax,0x805148
  801917:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80191a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801920:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801923:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80192a:	a1 54 51 80 00       	mov    0x805154,%eax
  80192f:	48                   	dec    %eax
  801930:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801935:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801938:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80193f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801942:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801949:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80194d:	75 14                	jne    801963 <initialize_dyn_block_system+0x19b>
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	68 a0 3e 80 00       	push   $0x803ea0
  801957:	6a 3e                	push   $0x3e
  801959:	68 93 3e 80 00       	push   $0x803e93
  80195e:	e8 f6 ed ff ff       	call   800759 <_panic>
  801963:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801969:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80196c:	89 10                	mov    %edx,(%eax)
  80196e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801971:	8b 00                	mov    (%eax),%eax
  801973:	85 c0                	test   %eax,%eax
  801975:	74 0d                	je     801984 <initialize_dyn_block_system+0x1bc>
  801977:	a1 38 51 80 00       	mov    0x805138,%eax
  80197c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80197f:	89 50 04             	mov    %edx,0x4(%eax)
  801982:	eb 08                	jmp    80198c <initialize_dyn_block_system+0x1c4>
  801984:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801987:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80198c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80198f:	a3 38 51 80 00       	mov    %eax,0x805138
  801994:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801997:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80199e:	a1 44 51 80 00       	mov    0x805144,%eax
  8019a3:	40                   	inc    %eax
  8019a4:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  8019a9:	90                   	nop
  8019aa:	c9                   	leave  
  8019ab:	c3                   	ret    

008019ac <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8019ac:	55                   	push   %ebp
  8019ad:	89 e5                	mov    %esp,%ebp
  8019af:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8019b2:	e8 e0 fd ff ff       	call   801797 <InitializeUHeap>
		if (size == 0) return NULL ;
  8019b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019bb:	75 07                	jne    8019c4 <malloc+0x18>
  8019bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c2:	eb 7f                	jmp    801a43 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8019c4:	e8 d2 08 00 00       	call   80229b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	74 71                	je     801a3e <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8019cd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8019d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	01 d0                	add    %edx,%eax
  8019dc:	48                   	dec    %eax
  8019dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e8:	f7 75 f4             	divl   -0xc(%ebp)
  8019eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ee:	29 d0                	sub    %edx,%eax
  8019f0:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  8019f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  8019fa:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801a01:	76 07                	jbe    801a0a <malloc+0x5e>
					return NULL ;
  801a03:	b8 00 00 00 00       	mov    $0x0,%eax
  801a08:	eb 39                	jmp    801a43 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801a0a:	83 ec 0c             	sub    $0xc,%esp
  801a0d:	ff 75 08             	pushl  0x8(%ebp)
  801a10:	e8 e6 0d 00 00       	call   8027fb <alloc_block_FF>
  801a15:	83 c4 10             	add    $0x10,%esp
  801a18:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801a1b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a1f:	74 16                	je     801a37 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801a21:	83 ec 0c             	sub    $0xc,%esp
  801a24:	ff 75 ec             	pushl  -0x14(%ebp)
  801a27:	e8 37 0c 00 00       	call   802663 <insert_sorted_allocList>
  801a2c:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801a2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a32:	8b 40 08             	mov    0x8(%eax),%eax
  801a35:	eb 0c                	jmp    801a43 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801a37:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3c:	eb 05                	jmp    801a43 <malloc+0x97>
				}
		}
	return 0;
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801a51:	83 ec 08             	sub    $0x8,%esp
  801a54:	ff 75 f4             	pushl  -0xc(%ebp)
  801a57:	68 40 50 80 00       	push   $0x805040
  801a5c:	e8 cf 0b 00 00       	call   802630 <find_block>
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a6a:	8b 40 0c             	mov    0xc(%eax),%eax
  801a6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a73:	8b 40 08             	mov    0x8(%eax),%eax
  801a76:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801a79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a7d:	0f 84 a1 00 00 00    	je     801b24 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801a83:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a87:	75 17                	jne    801aa0 <free+0x5b>
  801a89:	83 ec 04             	sub    $0x4,%esp
  801a8c:	68 75 3e 80 00       	push   $0x803e75
  801a91:	68 80 00 00 00       	push   $0x80
  801a96:	68 93 3e 80 00       	push   $0x803e93
  801a9b:	e8 b9 ec ff ff       	call   800759 <_panic>
  801aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa3:	8b 00                	mov    (%eax),%eax
  801aa5:	85 c0                	test   %eax,%eax
  801aa7:	74 10                	je     801ab9 <free+0x74>
  801aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aac:	8b 00                	mov    (%eax),%eax
  801aae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ab1:	8b 52 04             	mov    0x4(%edx),%edx
  801ab4:	89 50 04             	mov    %edx,0x4(%eax)
  801ab7:	eb 0b                	jmp    801ac4 <free+0x7f>
  801ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abc:	8b 40 04             	mov    0x4(%eax),%eax
  801abf:	a3 44 50 80 00       	mov    %eax,0x805044
  801ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ac7:	8b 40 04             	mov    0x4(%eax),%eax
  801aca:	85 c0                	test   %eax,%eax
  801acc:	74 0f                	je     801add <free+0x98>
  801ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad1:	8b 40 04             	mov    0x4(%eax),%eax
  801ad4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ad7:	8b 12                	mov    (%edx),%edx
  801ad9:	89 10                	mov    %edx,(%eax)
  801adb:	eb 0a                	jmp    801ae7 <free+0xa2>
  801add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae0:	8b 00                	mov    (%eax),%eax
  801ae2:	a3 40 50 80 00       	mov    %eax,0x805040
  801ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801afa:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801aff:	48                   	dec    %eax
  801b00:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801b05:	83 ec 0c             	sub    $0xc,%esp
  801b08:	ff 75 f0             	pushl  -0x10(%ebp)
  801b0b:	e8 29 12 00 00       	call   802d39 <insert_sorted_with_merge_freeList>
  801b10:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801b13:	83 ec 08             	sub    $0x8,%esp
  801b16:	ff 75 ec             	pushl  -0x14(%ebp)
  801b19:	ff 75 e8             	pushl  -0x18(%ebp)
  801b1c:	e8 74 03 00 00       	call   801e95 <sys_free_user_mem>
  801b21:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801b24:	90                   	nop
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 38             	sub    $0x38,%esp
  801b2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b30:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b33:	e8 5f fc ff ff       	call   801797 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b3c:	75 0a                	jne    801b48 <smalloc+0x21>
  801b3e:	b8 00 00 00 00       	mov    $0x0,%eax
  801b43:	e9 b2 00 00 00       	jmp    801bfa <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801b48:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801b4f:	76 0a                	jbe    801b5b <smalloc+0x34>
		return NULL;
  801b51:	b8 00 00 00 00       	mov    $0x0,%eax
  801b56:	e9 9f 00 00 00       	jmp    801bfa <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b5b:	e8 3b 07 00 00       	call   80229b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b60:	85 c0                	test   %eax,%eax
  801b62:	0f 84 8d 00 00 00    	je     801bf5 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801b68:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801b6f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b7c:	01 d0                	add    %edx,%eax
  801b7e:	48                   	dec    %eax
  801b7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b85:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8a:	f7 75 f0             	divl   -0x10(%ebp)
  801b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b90:	29 d0                	sub    %edx,%eax
  801b92:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801b95:	83 ec 0c             	sub    $0xc,%esp
  801b98:	ff 75 e8             	pushl  -0x18(%ebp)
  801b9b:	e8 5b 0c 00 00       	call   8027fb <alloc_block_FF>
  801ba0:	83 c4 10             	add    $0x10,%esp
  801ba3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801ba6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801baa:	75 07                	jne    801bb3 <smalloc+0x8c>
			return NULL;
  801bac:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb1:	eb 47                	jmp    801bfa <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801bb3:	83 ec 0c             	sub    $0xc,%esp
  801bb6:	ff 75 f4             	pushl  -0xc(%ebp)
  801bb9:	e8 a5 0a 00 00       	call   802663 <insert_sorted_allocList>
  801bbe:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc4:	8b 40 08             	mov    0x8(%eax),%eax
  801bc7:	89 c2                	mov    %eax,%edx
  801bc9:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801bcd:	52                   	push   %edx
  801bce:	50                   	push   %eax
  801bcf:	ff 75 0c             	pushl  0xc(%ebp)
  801bd2:	ff 75 08             	pushl  0x8(%ebp)
  801bd5:	e8 46 04 00 00       	call   802020 <sys_createSharedObject>
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801be0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801be4:	78 08                	js     801bee <smalloc+0xc7>
		return (void *)b->sva;
  801be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801be9:	8b 40 08             	mov    0x8(%eax),%eax
  801bec:	eb 0c                	jmp    801bfa <smalloc+0xd3>
		}else{
		return NULL;
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf3:	eb 05                	jmp    801bfa <smalloc+0xd3>
			}

	}return NULL;
  801bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c02:	e8 90 fb ff ff       	call   801797 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801c07:	e8 8f 06 00 00       	call   80229b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	0f 84 ad 00 00 00    	je     801cc1 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c14:	83 ec 08             	sub    $0x8,%esp
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	e8 28 04 00 00       	call   80204a <sys_getSizeOfSharedObject>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801c28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c2c:	79 0a                	jns    801c38 <sget+0x3c>
    {
    	return NULL;
  801c2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801c33:	e9 8e 00 00 00       	jmp    801cc6 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801c38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801c3f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c4c:	01 d0                	add    %edx,%eax
  801c4e:	48                   	dec    %eax
  801c4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c55:	ba 00 00 00 00       	mov    $0x0,%edx
  801c5a:	f7 75 ec             	divl   -0x14(%ebp)
  801c5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c60:	29 d0                	sub    %edx,%eax
  801c62:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801c65:	83 ec 0c             	sub    $0xc,%esp
  801c68:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c6b:	e8 8b 0b 00 00       	call   8027fb <alloc_block_FF>
  801c70:	83 c4 10             	add    $0x10,%esp
  801c73:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801c76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c7a:	75 07                	jne    801c83 <sget+0x87>
				return NULL;
  801c7c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c81:	eb 43                	jmp    801cc6 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801c83:	83 ec 0c             	sub    $0xc,%esp
  801c86:	ff 75 f0             	pushl  -0x10(%ebp)
  801c89:	e8 d5 09 00 00       	call   802663 <insert_sorted_allocList>
  801c8e:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c94:	8b 40 08             	mov    0x8(%eax),%eax
  801c97:	83 ec 04             	sub    $0x4,%esp
  801c9a:	50                   	push   %eax
  801c9b:	ff 75 0c             	pushl  0xc(%ebp)
  801c9e:	ff 75 08             	pushl  0x8(%ebp)
  801ca1:	e8 c1 03 00 00       	call   802067 <sys_getSharedObject>
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801cac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cb0:	78 08                	js     801cba <sget+0xbe>
			return (void *)b->sva;
  801cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb5:	8b 40 08             	mov    0x8(%eax),%eax
  801cb8:	eb 0c                	jmp    801cc6 <sget+0xca>
			}else{
			return NULL;
  801cba:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbf:	eb 05                	jmp    801cc6 <sget+0xca>
			}
    }}return NULL;
  801cc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801cce:	e8 c4 fa ff ff       	call   801797 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801cd3:	83 ec 04             	sub    $0x4,%esp
  801cd6:	68 c4 3e 80 00       	push   $0x803ec4
  801cdb:	68 03 01 00 00       	push   $0x103
  801ce0:	68 93 3e 80 00       	push   $0x803e93
  801ce5:	e8 6f ea ff ff       	call   800759 <_panic>

00801cea <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801cea:	55                   	push   %ebp
  801ceb:	89 e5                	mov    %esp,%ebp
  801ced:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cf0:	83 ec 04             	sub    $0x4,%esp
  801cf3:	68 ec 3e 80 00       	push   $0x803eec
  801cf8:	68 17 01 00 00       	push   $0x117
  801cfd:	68 93 3e 80 00       	push   $0x803e93
  801d02:	e8 52 ea ff ff       	call   800759 <_panic>

00801d07 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d0d:	83 ec 04             	sub    $0x4,%esp
  801d10:	68 10 3f 80 00       	push   $0x803f10
  801d15:	68 22 01 00 00       	push   $0x122
  801d1a:	68 93 3e 80 00       	push   $0x803e93
  801d1f:	e8 35 ea ff ff       	call   800759 <_panic>

00801d24 <shrink>:

}
void shrink(uint32 newSize)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d2a:	83 ec 04             	sub    $0x4,%esp
  801d2d:	68 10 3f 80 00       	push   $0x803f10
  801d32:	68 27 01 00 00       	push   $0x127
  801d37:	68 93 3e 80 00       	push   $0x803e93
  801d3c:	e8 18 ea ff ff       	call   800759 <_panic>

00801d41 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d47:	83 ec 04             	sub    $0x4,%esp
  801d4a:	68 10 3f 80 00       	push   $0x803f10
  801d4f:	68 2c 01 00 00       	push   $0x12c
  801d54:	68 93 3e 80 00       	push   $0x803e93
  801d59:	e8 fb e9 ff ff       	call   800759 <_panic>

00801d5e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	57                   	push   %edi
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d70:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d73:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d76:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d79:	cd 30                	int    $0x30
  801d7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d81:	83 c4 10             	add    $0x10,%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5f                   	pop    %edi
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    

00801d89 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	83 ec 04             	sub    $0x4,%esp
  801d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d95:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	52                   	push   %edx
  801da1:	ff 75 0c             	pushl  0xc(%ebp)
  801da4:	50                   	push   %eax
  801da5:	6a 00                	push   $0x0
  801da7:	e8 b2 ff ff ff       	call   801d5e <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
}
  801daf:	90                   	nop
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 01                	push   $0x1
  801dc1:	e8 98 ff ff ff       	call   801d5e <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
}
  801dc9:	c9                   	leave  
  801dca:	c3                   	ret    

00801dcb <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801dce:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	52                   	push   %edx
  801ddb:	50                   	push   %eax
  801ddc:	6a 05                	push   $0x5
  801dde:	e8 7b ff ff ff       	call   801d5e <syscall>
  801de3:	83 c4 18             	add    $0x18,%esp
}
  801de6:	c9                   	leave  
  801de7:	c3                   	ret    

00801de8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	56                   	push   %esi
  801dec:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801ded:	8b 75 18             	mov    0x18(%ebp),%esi
  801df0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801df6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	56                   	push   %esi
  801dfd:	53                   	push   %ebx
  801dfe:	51                   	push   %ecx
  801dff:	52                   	push   %edx
  801e00:	50                   	push   %eax
  801e01:	6a 06                	push   $0x6
  801e03:	e8 56 ff ff ff       	call   801d5e <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0e:	5b                   	pop    %ebx
  801e0f:	5e                   	pop    %esi
  801e10:	5d                   	pop    %ebp
  801e11:	c3                   	ret    

00801e12 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e15:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	52                   	push   %edx
  801e22:	50                   	push   %eax
  801e23:	6a 07                	push   $0x7
  801e25:	e8 34 ff ff ff       	call   801d5e <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
}
  801e2d:	c9                   	leave  
  801e2e:	c3                   	ret    

00801e2f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e2f:	55                   	push   %ebp
  801e30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	ff 75 0c             	pushl  0xc(%ebp)
  801e3b:	ff 75 08             	pushl  0x8(%ebp)
  801e3e:	6a 08                	push   $0x8
  801e40:	e8 19 ff ff ff       	call   801d5e <syscall>
  801e45:	83 c4 18             	add    $0x18,%esp
}
  801e48:	c9                   	leave  
  801e49:	c3                   	ret    

00801e4a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 09                	push   $0x9
  801e59:	e8 00 ff ff ff       	call   801d5e <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
}
  801e61:	c9                   	leave  
  801e62:	c3                   	ret    

00801e63 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e63:	55                   	push   %ebp
  801e64:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 0a                	push   $0xa
  801e72:	e8 e7 fe ff ff       	call   801d5e <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 00                	push   $0x0
  801e89:	6a 0b                	push   $0xb
  801e8b:	e8 ce fe ff ff       	call   801d5e <syscall>
  801e90:	83 c4 18             	add    $0x18,%esp
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ea1:	ff 75 08             	pushl  0x8(%ebp)
  801ea4:	6a 0f                	push   $0xf
  801ea6:	e8 b3 fe ff ff       	call   801d5e <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
	return;
  801eae:	90                   	nop
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	ff 75 0c             	pushl  0xc(%ebp)
  801ebd:	ff 75 08             	pushl  0x8(%ebp)
  801ec0:	6a 10                	push   $0x10
  801ec2:	e8 97 fe ff ff       	call   801d5e <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eca:	90                   	nop
}
  801ecb:	c9                   	leave  
  801ecc:	c3                   	ret    

00801ecd <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ecd:	55                   	push   %ebp
  801ece:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	ff 75 10             	pushl  0x10(%ebp)
  801ed7:	ff 75 0c             	pushl  0xc(%ebp)
  801eda:	ff 75 08             	pushl  0x8(%ebp)
  801edd:	6a 11                	push   $0x11
  801edf:	e8 7a fe ff ff       	call   801d5e <syscall>
  801ee4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee7:	90                   	nop
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 0c                	push   $0xc
  801ef9:	e8 60 fe ff ff       	call   801d5e <syscall>
  801efe:	83 c4 18             	add    $0x18,%esp
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	ff 75 08             	pushl  0x8(%ebp)
  801f11:	6a 0d                	push   $0xd
  801f13:	e8 46 fe ff ff       	call   801d5e <syscall>
  801f18:	83 c4 18             	add    $0x18,%esp
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 0e                	push   $0xe
  801f2c:	e8 2d fe ff ff       	call   801d5e <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
}
  801f34:	90                   	nop
  801f35:	c9                   	leave  
  801f36:	c3                   	ret    

00801f37 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f37:	55                   	push   %ebp
  801f38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 13                	push   $0x13
  801f46:	e8 13 fe ff ff       	call   801d5e <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
}
  801f4e:	90                   	nop
  801f4f:	c9                   	leave  
  801f50:	c3                   	ret    

00801f51 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 14                	push   $0x14
  801f60:	e8 f9 fd ff ff       	call   801d5e <syscall>
  801f65:	83 c4 18             	add    $0x18,%esp
}
  801f68:	90                   	nop
  801f69:	c9                   	leave  
  801f6a:	c3                   	ret    

00801f6b <sys_cputc>:


void
sys_cputc(const char c)
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 04             	sub    $0x4,%esp
  801f71:	8b 45 08             	mov    0x8(%ebp),%eax
  801f74:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f77:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 00                	push   $0x0
  801f81:	6a 00                	push   $0x0
  801f83:	50                   	push   %eax
  801f84:	6a 15                	push   $0x15
  801f86:	e8 d3 fd ff ff       	call   801d5e <syscall>
  801f8b:	83 c4 18             	add    $0x18,%esp
}
  801f8e:	90                   	nop
  801f8f:	c9                   	leave  
  801f90:	c3                   	ret    

00801f91 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f91:	55                   	push   %ebp
  801f92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 16                	push   $0x16
  801fa0:	e8 b9 fd ff ff       	call   801d5e <syscall>
  801fa5:	83 c4 18             	add    $0x18,%esp
}
  801fa8:	90                   	nop
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801fae:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 00                	push   $0x0
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	50                   	push   %eax
  801fbb:	6a 17                	push   $0x17
  801fbd:	e8 9c fd ff ff       	call   801d5e <syscall>
  801fc2:	83 c4 18             	add    $0x18,%esp
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	6a 1a                	push   $0x1a
  801fda:	e8 7f fd ff ff       	call   801d5e <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	c9                   	leave  
  801fe3:	c3                   	ret    

00801fe4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	6a 00                	push   $0x0
  801fef:	6a 00                	push   $0x0
  801ff1:	6a 00                	push   $0x0
  801ff3:	52                   	push   %edx
  801ff4:	50                   	push   %eax
  801ff5:	6a 18                	push   $0x18
  801ff7:	e8 62 fd ff ff       	call   801d5e <syscall>
  801ffc:	83 c4 18             	add    $0x18,%esp
}
  801fff:	90                   	nop
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802005:	8b 55 0c             	mov    0xc(%ebp),%edx
  802008:	8b 45 08             	mov    0x8(%ebp),%eax
  80200b:	6a 00                	push   $0x0
  80200d:	6a 00                	push   $0x0
  80200f:	6a 00                	push   $0x0
  802011:	52                   	push   %edx
  802012:	50                   	push   %eax
  802013:	6a 19                	push   $0x19
  802015:	e8 44 fd ff ff       	call   801d5e <syscall>
  80201a:	83 c4 18             	add    $0x18,%esp
}
  80201d:	90                   	nop
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 04             	sub    $0x4,%esp
  802026:	8b 45 10             	mov    0x10(%ebp),%eax
  802029:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80202c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80202f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802033:	8b 45 08             	mov    0x8(%ebp),%eax
  802036:	6a 00                	push   $0x0
  802038:	51                   	push   %ecx
  802039:	52                   	push   %edx
  80203a:	ff 75 0c             	pushl  0xc(%ebp)
  80203d:	50                   	push   %eax
  80203e:	6a 1b                	push   $0x1b
  802040:	e8 19 fd ff ff       	call   801d5e <syscall>
  802045:	83 c4 18             	add    $0x18,%esp
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    

0080204a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80204a:	55                   	push   %ebp
  80204b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	8b 45 08             	mov    0x8(%ebp),%eax
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	52                   	push   %edx
  80205a:	50                   	push   %eax
  80205b:	6a 1c                	push   $0x1c
  80205d:	e8 fc fc ff ff       	call   801d5e <syscall>
  802062:	83 c4 18             	add    $0x18,%esp
}
  802065:	c9                   	leave  
  802066:	c3                   	ret    

00802067 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802067:	55                   	push   %ebp
  802068:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80206a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80206d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	6a 00                	push   $0x0
  802075:	6a 00                	push   $0x0
  802077:	51                   	push   %ecx
  802078:	52                   	push   %edx
  802079:	50                   	push   %eax
  80207a:	6a 1d                	push   $0x1d
  80207c:	e8 dd fc ff ff       	call   801d5e <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802089:	8b 55 0c             	mov    0xc(%ebp),%edx
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	6a 00                	push   $0x0
  802091:	6a 00                	push   $0x0
  802093:	6a 00                	push   $0x0
  802095:	52                   	push   %edx
  802096:	50                   	push   %eax
  802097:	6a 1e                	push   $0x1e
  802099:	e8 c0 fc ff ff       	call   801d5e <syscall>
  80209e:	83 c4 18             	add    $0x18,%esp
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 1f                	push   $0x1f
  8020b2:	e8 a7 fc ff ff       	call   801d5e <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
}
  8020ba:	c9                   	leave  
  8020bb:	c3                   	ret    

008020bc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020bc:	55                   	push   %ebp
  8020bd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	6a 00                	push   $0x0
  8020c4:	ff 75 14             	pushl  0x14(%ebp)
  8020c7:	ff 75 10             	pushl  0x10(%ebp)
  8020ca:	ff 75 0c             	pushl  0xc(%ebp)
  8020cd:	50                   	push   %eax
  8020ce:	6a 20                	push   $0x20
  8020d0:	e8 89 fc ff ff       	call   801d5e <syscall>
  8020d5:	83 c4 18             	add    $0x18,%esp
}
  8020d8:	c9                   	leave  
  8020d9:	c3                   	ret    

008020da <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e0:	6a 00                	push   $0x0
  8020e2:	6a 00                	push   $0x0
  8020e4:	6a 00                	push   $0x0
  8020e6:	6a 00                	push   $0x0
  8020e8:	50                   	push   %eax
  8020e9:	6a 21                	push   $0x21
  8020eb:	e8 6e fc ff ff       	call   801d5e <syscall>
  8020f0:	83 c4 18             	add    $0x18,%esp
}
  8020f3:	90                   	nop
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 00                	push   $0x0
  802100:	6a 00                	push   $0x0
  802102:	6a 00                	push   $0x0
  802104:	50                   	push   %eax
  802105:	6a 22                	push   $0x22
  802107:	e8 52 fc ff ff       	call   801d5e <syscall>
  80210c:	83 c4 18             	add    $0x18,%esp
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 00                	push   $0x0
  80211a:	6a 00                	push   $0x0
  80211c:	6a 00                	push   $0x0
  80211e:	6a 02                	push   $0x2
  802120:	e8 39 fc ff ff       	call   801d5e <syscall>
  802125:	83 c4 18             	add    $0x18,%esp
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 00                	push   $0x0
  802133:	6a 00                	push   $0x0
  802135:	6a 00                	push   $0x0
  802137:	6a 03                	push   $0x3
  802139:	e8 20 fc ff ff       	call   801d5e <syscall>
  80213e:	83 c4 18             	add    $0x18,%esp
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 04                	push   $0x4
  802152:	e8 07 fc ff ff       	call   801d5e <syscall>
  802157:	83 c4 18             	add    $0x18,%esp
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <sys_exit_env>:


void sys_exit_env(void)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 00                	push   $0x0
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 23                	push   $0x23
  80216b:	e8 ee fb ff ff       	call   801d5e <syscall>
  802170:	83 c4 18             	add    $0x18,%esp
}
  802173:	90                   	nop
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80217c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80217f:	8d 50 04             	lea    0x4(%eax),%edx
  802182:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	52                   	push   %edx
  80218c:	50                   	push   %eax
  80218d:	6a 24                	push   $0x24
  80218f:	e8 ca fb ff ff       	call   801d5e <syscall>
  802194:	83 c4 18             	add    $0x18,%esp
	return result;
  802197:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80219a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80219d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021a0:	89 01                	mov    %eax,(%ecx)
  8021a2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a8:	c9                   	leave  
  8021a9:	c2 04 00             	ret    $0x4

008021ac <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021af:	6a 00                	push   $0x0
  8021b1:	6a 00                	push   $0x0
  8021b3:	ff 75 10             	pushl  0x10(%ebp)
  8021b6:	ff 75 0c             	pushl  0xc(%ebp)
  8021b9:	ff 75 08             	pushl  0x8(%ebp)
  8021bc:	6a 12                	push   $0x12
  8021be:	e8 9b fb ff ff       	call   801d5e <syscall>
  8021c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c6:	90                   	nop
}
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <sys_rcr2>:
uint32 sys_rcr2()
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8021cc:	6a 00                	push   $0x0
  8021ce:	6a 00                	push   $0x0
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 25                	push   $0x25
  8021d8:	e8 81 fb ff ff       	call   801d5e <syscall>
  8021dd:	83 c4 18             	add    $0x18,%esp
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	83 ec 04             	sub    $0x4,%esp
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021ee:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021f2:	6a 00                	push   $0x0
  8021f4:	6a 00                	push   $0x0
  8021f6:	6a 00                	push   $0x0
  8021f8:	6a 00                	push   $0x0
  8021fa:	50                   	push   %eax
  8021fb:	6a 26                	push   $0x26
  8021fd:	e8 5c fb ff ff       	call   801d5e <syscall>
  802202:	83 c4 18             	add    $0x18,%esp
	return ;
  802205:	90                   	nop
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <rsttst>:
void rsttst()
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80220b:	6a 00                	push   $0x0
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 28                	push   $0x28
  802217:	e8 42 fb ff ff       	call   801d5e <syscall>
  80221c:	83 c4 18             	add    $0x18,%esp
	return ;
  80221f:	90                   	nop
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	8b 45 14             	mov    0x14(%ebp),%eax
  80222b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80222e:	8b 55 18             	mov    0x18(%ebp),%edx
  802231:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802235:	52                   	push   %edx
  802236:	50                   	push   %eax
  802237:	ff 75 10             	pushl  0x10(%ebp)
  80223a:	ff 75 0c             	pushl  0xc(%ebp)
  80223d:	ff 75 08             	pushl  0x8(%ebp)
  802240:	6a 27                	push   $0x27
  802242:	e8 17 fb ff ff       	call   801d5e <syscall>
  802247:	83 c4 18             	add    $0x18,%esp
	return ;
  80224a:	90                   	nop
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <chktst>:
void chktst(uint32 n)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	6a 29                	push   $0x29
  80225d:	e8 fc fa ff ff       	call   801d5e <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
	return ;
  802265:	90                   	nop
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <inctst>:

void inctst()
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	6a 00                	push   $0x0
  802273:	6a 00                	push   $0x0
  802275:	6a 2a                	push   $0x2a
  802277:	e8 e2 fa ff ff       	call   801d5e <syscall>
  80227c:	83 c4 18             	add    $0x18,%esp
	return ;
  80227f:	90                   	nop
}
  802280:	c9                   	leave  
  802281:	c3                   	ret    

00802282 <gettst>:
uint32 gettst()
{
  802282:	55                   	push   %ebp
  802283:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802285:	6a 00                	push   $0x0
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 2b                	push   $0x2b
  802291:	e8 c8 fa ff ff       	call   801d5e <syscall>
  802296:	83 c4 18             	add    $0x18,%esp
}
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
  80229e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022a1:	6a 00                	push   $0x0
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 2c                	push   $0x2c
  8022ad:	e8 ac fa ff ff       	call   801d5e <syscall>
  8022b2:	83 c4 18             	add    $0x18,%esp
  8022b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022b8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022bc:	75 07                	jne    8022c5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8022be:	b8 01 00 00 00       	mov    $0x1,%eax
  8022c3:	eb 05                	jmp    8022ca <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8022c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022ca:	c9                   	leave  
  8022cb:	c3                   	ret    

008022cc <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 2c                	push   $0x2c
  8022de:	e8 7b fa ff ff       	call   801d5e <syscall>
  8022e3:	83 c4 18             	add    $0x18,%esp
  8022e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022e9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022ed:	75 07                	jne    8022f6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022ef:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f4:	eb 05                	jmp    8022fb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	6a 00                	push   $0x0
  80230b:	6a 00                	push   $0x0
  80230d:	6a 2c                	push   $0x2c
  80230f:	e8 4a fa ff ff       	call   801d5e <syscall>
  802314:	83 c4 18             	add    $0x18,%esp
  802317:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80231a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80231e:	75 07                	jne    802327 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802320:	b8 01 00 00 00       	mov    $0x1,%eax
  802325:	eb 05                	jmp    80232c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802327:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 2c                	push   $0x2c
  802340:	e8 19 fa ff ff       	call   801d5e <syscall>
  802345:	83 c4 18             	add    $0x18,%esp
  802348:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80234b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80234f:	75 07                	jne    802358 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802351:	b8 01 00 00 00       	mov    $0x1,%eax
  802356:	eb 05                	jmp    80235d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802358:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	ff 75 08             	pushl  0x8(%ebp)
  80236d:	6a 2d                	push   $0x2d
  80236f:	e8 ea f9 ff ff       	call   801d5e <syscall>
  802374:	83 c4 18             	add    $0x18,%esp
	return ;
  802377:	90                   	nop
}
  802378:	c9                   	leave  
  802379:	c3                   	ret    

0080237a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80237a:	55                   	push   %ebp
  80237b:	89 e5                	mov    %esp,%ebp
  80237d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80237e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802381:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802384:	8b 55 0c             	mov    0xc(%ebp),%edx
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	6a 00                	push   $0x0
  80238c:	53                   	push   %ebx
  80238d:	51                   	push   %ecx
  80238e:	52                   	push   %edx
  80238f:	50                   	push   %eax
  802390:	6a 2e                	push   $0x2e
  802392:	e8 c7 f9 ff ff       	call   801d5e <syscall>
  802397:	83 c4 18             	add    $0x18,%esp
}
  80239a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80239d:	c9                   	leave  
  80239e:	c3                   	ret    

0080239f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80239f:	55                   	push   %ebp
  8023a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	6a 00                	push   $0x0
  8023ae:	52                   	push   %edx
  8023af:	50                   	push   %eax
  8023b0:	6a 2f                	push   $0x2f
  8023b2:	e8 a7 f9 ff ff       	call   801d5e <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8023c2:	83 ec 0c             	sub    $0xc,%esp
  8023c5:	68 20 3f 80 00       	push   $0x803f20
  8023ca:	e8 3e e6 ff ff       	call   800a0d <cprintf>
  8023cf:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8023d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8023d9:	83 ec 0c             	sub    $0xc,%esp
  8023dc:	68 4c 3f 80 00       	push   $0x803f4c
  8023e1:	e8 27 e6 ff ff       	call   800a0d <cprintf>
  8023e6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023e9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023ed:	a1 38 51 80 00       	mov    0x805138,%eax
  8023f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f5:	eb 56                	jmp    80244d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023fb:	74 1c                	je     802419 <print_mem_block_lists+0x5d>
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	8b 50 08             	mov    0x8(%eax),%edx
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	8b 48 08             	mov    0x8(%eax),%ecx
  802409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240c:	8b 40 0c             	mov    0xc(%eax),%eax
  80240f:	01 c8                	add    %ecx,%eax
  802411:	39 c2                	cmp    %eax,%edx
  802413:	73 04                	jae    802419 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802415:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802419:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241c:	8b 50 08             	mov    0x8(%eax),%edx
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 40 0c             	mov    0xc(%eax),%eax
  802425:	01 c2                	add    %eax,%edx
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	8b 40 08             	mov    0x8(%eax),%eax
  80242d:	83 ec 04             	sub    $0x4,%esp
  802430:	52                   	push   %edx
  802431:	50                   	push   %eax
  802432:	68 61 3f 80 00       	push   $0x803f61
  802437:	e8 d1 e5 ff ff       	call   800a0d <cprintf>
  80243c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802445:	a1 40 51 80 00       	mov    0x805140,%eax
  80244a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80244d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802451:	74 07                	je     80245a <print_mem_block_lists+0x9e>
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 00                	mov    (%eax),%eax
  802458:	eb 05                	jmp    80245f <print_mem_block_lists+0xa3>
  80245a:	b8 00 00 00 00       	mov    $0x0,%eax
  80245f:	a3 40 51 80 00       	mov    %eax,0x805140
  802464:	a1 40 51 80 00       	mov    0x805140,%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	75 8a                	jne    8023f7 <print_mem_block_lists+0x3b>
  80246d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802471:	75 84                	jne    8023f7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802473:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802477:	75 10                	jne    802489 <print_mem_block_lists+0xcd>
  802479:	83 ec 0c             	sub    $0xc,%esp
  80247c:	68 70 3f 80 00       	push   $0x803f70
  802481:	e8 87 e5 ff ff       	call   800a0d <cprintf>
  802486:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802489:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802490:	83 ec 0c             	sub    $0xc,%esp
  802493:	68 94 3f 80 00       	push   $0x803f94
  802498:	e8 70 e5 ff ff       	call   800a0d <cprintf>
  80249d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8024a0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024a4:	a1 40 50 80 00       	mov    0x805040,%eax
  8024a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ac:	eb 56                	jmp    802504 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024b2:	74 1c                	je     8024d0 <print_mem_block_lists+0x114>
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bd:	8b 48 08             	mov    0x8(%eax),%ecx
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c6:	01 c8                	add    %ecx,%eax
  8024c8:	39 c2                	cmp    %eax,%edx
  8024ca:	73 04                	jae    8024d0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8024cc:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	8b 50 08             	mov    0x8(%eax),%edx
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024dc:	01 c2                	add    %eax,%edx
  8024de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e1:	8b 40 08             	mov    0x8(%eax),%eax
  8024e4:	83 ec 04             	sub    $0x4,%esp
  8024e7:	52                   	push   %edx
  8024e8:	50                   	push   %eax
  8024e9:	68 61 3f 80 00       	push   $0x803f61
  8024ee:	e8 1a e5 ff ff       	call   800a0d <cprintf>
  8024f3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024fc:	a1 48 50 80 00       	mov    0x805048,%eax
  802501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802508:	74 07                	je     802511 <print_mem_block_lists+0x155>
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 00                	mov    (%eax),%eax
  80250f:	eb 05                	jmp    802516 <print_mem_block_lists+0x15a>
  802511:	b8 00 00 00 00       	mov    $0x0,%eax
  802516:	a3 48 50 80 00       	mov    %eax,0x805048
  80251b:	a1 48 50 80 00       	mov    0x805048,%eax
  802520:	85 c0                	test   %eax,%eax
  802522:	75 8a                	jne    8024ae <print_mem_block_lists+0xf2>
  802524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802528:	75 84                	jne    8024ae <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80252a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80252e:	75 10                	jne    802540 <print_mem_block_lists+0x184>
  802530:	83 ec 0c             	sub    $0xc,%esp
  802533:	68 ac 3f 80 00       	push   $0x803fac
  802538:	e8 d0 e4 ff ff       	call   800a0d <cprintf>
  80253d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802540:	83 ec 0c             	sub    $0xc,%esp
  802543:	68 20 3f 80 00       	push   $0x803f20
  802548:	e8 c0 e4 ff ff       	call   800a0d <cprintf>
  80254d:	83 c4 10             	add    $0x10,%esp

}
  802550:	90                   	nop
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802559:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802560:	00 00 00 
  802563:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80256a:	00 00 00 
  80256d:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802574:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802577:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80257e:	e9 9e 00 00 00       	jmp    802621 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802583:	a1 50 50 80 00       	mov    0x805050,%eax
  802588:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258b:	c1 e2 04             	shl    $0x4,%edx
  80258e:	01 d0                	add    %edx,%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	75 14                	jne    8025a8 <initialize_MemBlocksList+0x55>
  802594:	83 ec 04             	sub    $0x4,%esp
  802597:	68 d4 3f 80 00       	push   $0x803fd4
  80259c:	6a 3d                	push   $0x3d
  80259e:	68 f7 3f 80 00       	push   $0x803ff7
  8025a3:	e8 b1 e1 ff ff       	call   800759 <_panic>
  8025a8:	a1 50 50 80 00       	mov    0x805050,%eax
  8025ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b0:	c1 e2 04             	shl    $0x4,%edx
  8025b3:	01 d0                	add    %edx,%eax
  8025b5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8025bb:	89 10                	mov    %edx,(%eax)
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	74 18                	je     8025db <initialize_MemBlocksList+0x88>
  8025c3:	a1 48 51 80 00       	mov    0x805148,%eax
  8025c8:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8025ce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8025d1:	c1 e1 04             	shl    $0x4,%ecx
  8025d4:	01 ca                	add    %ecx,%edx
  8025d6:	89 50 04             	mov    %edx,0x4(%eax)
  8025d9:	eb 12                	jmp    8025ed <initialize_MemBlocksList+0x9a>
  8025db:	a1 50 50 80 00       	mov    0x805050,%eax
  8025e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e3:	c1 e2 04             	shl    $0x4,%edx
  8025e6:	01 d0                	add    %edx,%eax
  8025e8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025ed:	a1 50 50 80 00       	mov    0x805050,%eax
  8025f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f5:	c1 e2 04             	shl    $0x4,%edx
  8025f8:	01 d0                	add    %edx,%eax
  8025fa:	a3 48 51 80 00       	mov    %eax,0x805148
  8025ff:	a1 50 50 80 00       	mov    0x805050,%eax
  802604:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802607:	c1 e2 04             	shl    $0x4,%edx
  80260a:	01 d0                	add    %edx,%eax
  80260c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802613:	a1 54 51 80 00       	mov    0x805154,%eax
  802618:	40                   	inc    %eax
  802619:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80261e:	ff 45 f4             	incl   -0xc(%ebp)
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	3b 45 08             	cmp    0x8(%ebp),%eax
  802627:	0f 82 56 ff ff ff    	jb     802583 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80262d:	90                   	nop
  80262e:	c9                   	leave  
  80262f:	c3                   	ret    

00802630 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802636:	8b 45 08             	mov    0x8(%ebp),%eax
  802639:	8b 00                	mov    (%eax),%eax
  80263b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80263e:	eb 18                	jmp    802658 <find_block+0x28>

		if(tmp->sva == va){
  802640:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802643:	8b 40 08             	mov    0x8(%eax),%eax
  802646:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802649:	75 05                	jne    802650 <find_block+0x20>
			return tmp ;
  80264b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80264e:	eb 11                	jmp    802661 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802650:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802653:	8b 00                	mov    (%eax),%eax
  802655:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802658:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80265c:	75 e2                	jne    802640 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80265e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802661:	c9                   	leave  
  802662:	c3                   	ret    

00802663 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802663:	55                   	push   %ebp
  802664:	89 e5                	mov    %esp,%ebp
  802666:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802669:	a1 40 50 80 00       	mov    0x805040,%eax
  80266e:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802671:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802676:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802679:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80267d:	75 65                	jne    8026e4 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  80267f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802683:	75 14                	jne    802699 <insert_sorted_allocList+0x36>
  802685:	83 ec 04             	sub    $0x4,%esp
  802688:	68 d4 3f 80 00       	push   $0x803fd4
  80268d:	6a 62                	push   $0x62
  80268f:	68 f7 3f 80 00       	push   $0x803ff7
  802694:	e8 c0 e0 ff ff       	call   800759 <_panic>
  802699:	8b 15 40 50 80 00    	mov    0x805040,%edx
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a2:	89 10                	mov    %edx,(%eax)
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	8b 00                	mov    (%eax),%eax
  8026a9:	85 c0                	test   %eax,%eax
  8026ab:	74 0d                	je     8026ba <insert_sorted_allocList+0x57>
  8026ad:	a1 40 50 80 00       	mov    0x805040,%eax
  8026b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b5:	89 50 04             	mov    %edx,0x4(%eax)
  8026b8:	eb 08                	jmp    8026c2 <insert_sorted_allocList+0x5f>
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	a3 44 50 80 00       	mov    %eax,0x805044
  8026c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c5:	a3 40 50 80 00       	mov    %eax,0x805040
  8026ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026d4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d9:	40                   	inc    %eax
  8026da:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8026df:	e9 14 01 00 00       	jmp    8027f8 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	8b 50 08             	mov    0x8(%eax),%edx
  8026ea:	a1 44 50 80 00       	mov    0x805044,%eax
  8026ef:	8b 40 08             	mov    0x8(%eax),%eax
  8026f2:	39 c2                	cmp    %eax,%edx
  8026f4:	76 65                	jbe    80275b <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8026f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026fa:	75 14                	jne    802710 <insert_sorted_allocList+0xad>
  8026fc:	83 ec 04             	sub    $0x4,%esp
  8026ff:	68 10 40 80 00       	push   $0x804010
  802704:	6a 64                	push   $0x64
  802706:	68 f7 3f 80 00       	push   $0x803ff7
  80270b:	e8 49 e0 ff ff       	call   800759 <_panic>
  802710:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	89 50 04             	mov    %edx,0x4(%eax)
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	8b 40 04             	mov    0x4(%eax),%eax
  802722:	85 c0                	test   %eax,%eax
  802724:	74 0c                	je     802732 <insert_sorted_allocList+0xcf>
  802726:	a1 44 50 80 00       	mov    0x805044,%eax
  80272b:	8b 55 08             	mov    0x8(%ebp),%edx
  80272e:	89 10                	mov    %edx,(%eax)
  802730:	eb 08                	jmp    80273a <insert_sorted_allocList+0xd7>
  802732:	8b 45 08             	mov    0x8(%ebp),%eax
  802735:	a3 40 50 80 00       	mov    %eax,0x805040
  80273a:	8b 45 08             	mov    0x8(%ebp),%eax
  80273d:	a3 44 50 80 00       	mov    %eax,0x805044
  802742:	8b 45 08             	mov    0x8(%ebp),%eax
  802745:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80274b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802750:	40                   	inc    %eax
  802751:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802756:	e9 9d 00 00 00       	jmp    8027f8 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80275b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802762:	e9 85 00 00 00       	jmp    8027ec <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802767:	8b 45 08             	mov    0x8(%ebp),%eax
  80276a:	8b 50 08             	mov    0x8(%eax),%edx
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 40 08             	mov    0x8(%eax),%eax
  802773:	39 c2                	cmp    %eax,%edx
  802775:	73 6a                	jae    8027e1 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802777:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277b:	74 06                	je     802783 <insert_sorted_allocList+0x120>
  80277d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802781:	75 14                	jne    802797 <insert_sorted_allocList+0x134>
  802783:	83 ec 04             	sub    $0x4,%esp
  802786:	68 34 40 80 00       	push   $0x804034
  80278b:	6a 6b                	push   $0x6b
  80278d:	68 f7 3f 80 00       	push   $0x803ff7
  802792:	e8 c2 df ff ff       	call   800759 <_panic>
  802797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279a:	8b 50 04             	mov    0x4(%eax),%edx
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	89 50 04             	mov    %edx,0x4(%eax)
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a9:	89 10                	mov    %edx,(%eax)
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 40 04             	mov    0x4(%eax),%eax
  8027b1:	85 c0                	test   %eax,%eax
  8027b3:	74 0d                	je     8027c2 <insert_sorted_allocList+0x15f>
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 04             	mov    0x4(%eax),%eax
  8027bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027be:	89 10                	mov    %edx,(%eax)
  8027c0:	eb 08                	jmp    8027ca <insert_sorted_allocList+0x167>
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	a3 40 50 80 00       	mov    %eax,0x805040
  8027ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8027d0:	89 50 04             	mov    %edx,0x4(%eax)
  8027d3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8027d8:	40                   	inc    %eax
  8027d9:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  8027de:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8027df:	eb 17                	jmp    8027f8 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8027e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e4:	8b 00                	mov    (%eax),%eax
  8027e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8027e9:	ff 45 f0             	incl   -0x10(%ebp)
  8027ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027f2:	0f 8c 6f ff ff ff    	jl     802767 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8027f8:	90                   	nop
  8027f9:	c9                   	leave  
  8027fa:	c3                   	ret    

008027fb <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027fb:	55                   	push   %ebp
  8027fc:	89 e5                	mov    %esp,%ebp
  8027fe:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802801:	a1 38 51 80 00       	mov    0x805138,%eax
  802806:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802809:	e9 7c 01 00 00       	jmp    80298a <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	8b 40 0c             	mov    0xc(%eax),%eax
  802814:	3b 45 08             	cmp    0x8(%ebp),%eax
  802817:	0f 86 cf 00 00 00    	jbe    8028ec <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80281d:	a1 48 51 80 00       	mov    0x805148,%eax
  802822:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802825:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802828:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80282b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282e:	8b 55 08             	mov    0x8(%ebp),%edx
  802831:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 50 08             	mov    0x8(%eax),%edx
  80283a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283d:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	8b 40 0c             	mov    0xc(%eax),%eax
  802846:	2b 45 08             	sub    0x8(%ebp),%eax
  802849:	89 c2                	mov    %eax,%edx
  80284b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284e:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802854:	8b 50 08             	mov    0x8(%eax),%edx
  802857:	8b 45 08             	mov    0x8(%ebp),%eax
  80285a:	01 c2                	add    %eax,%edx
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802862:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802866:	75 17                	jne    80287f <alloc_block_FF+0x84>
  802868:	83 ec 04             	sub    $0x4,%esp
  80286b:	68 69 40 80 00       	push   $0x804069
  802870:	68 83 00 00 00       	push   $0x83
  802875:	68 f7 3f 80 00       	push   $0x803ff7
  80287a:	e8 da de ff ff       	call   800759 <_panic>
  80287f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	85 c0                	test   %eax,%eax
  802886:	74 10                	je     802898 <alloc_block_FF+0x9d>
  802888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802890:	8b 52 04             	mov    0x4(%edx),%edx
  802893:	89 50 04             	mov    %edx,0x4(%eax)
  802896:	eb 0b                	jmp    8028a3 <alloc_block_FF+0xa8>
  802898:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289b:	8b 40 04             	mov    0x4(%eax),%eax
  80289e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a6:	8b 40 04             	mov    0x4(%eax),%eax
  8028a9:	85 c0                	test   %eax,%eax
  8028ab:	74 0f                	je     8028bc <alloc_block_FF+0xc1>
  8028ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b0:	8b 40 04             	mov    0x4(%eax),%eax
  8028b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b6:	8b 12                	mov    (%edx),%edx
  8028b8:	89 10                	mov    %edx,(%eax)
  8028ba:	eb 0a                	jmp    8028c6 <alloc_block_FF+0xcb>
  8028bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bf:	8b 00                	mov    (%eax),%eax
  8028c1:	a3 48 51 80 00       	mov    %eax,0x805148
  8028c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d9:	a1 54 51 80 00       	mov    0x805154,%eax
  8028de:	48                   	dec    %eax
  8028df:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  8028e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e7:	e9 ad 00 00 00       	jmp    802999 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f5:	0f 85 87 00 00 00    	jne    802982 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  8028fb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ff:	75 17                	jne    802918 <alloc_block_FF+0x11d>
  802901:	83 ec 04             	sub    $0x4,%esp
  802904:	68 69 40 80 00       	push   $0x804069
  802909:	68 87 00 00 00       	push   $0x87
  80290e:	68 f7 3f 80 00       	push   $0x803ff7
  802913:	e8 41 de ff ff       	call   800759 <_panic>
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	74 10                	je     802931 <alloc_block_FF+0x136>
  802921:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802924:	8b 00                	mov    (%eax),%eax
  802926:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802929:	8b 52 04             	mov    0x4(%edx),%edx
  80292c:	89 50 04             	mov    %edx,0x4(%eax)
  80292f:	eb 0b                	jmp    80293c <alloc_block_FF+0x141>
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 40 04             	mov    0x4(%eax),%eax
  802937:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293f:	8b 40 04             	mov    0x4(%eax),%eax
  802942:	85 c0                	test   %eax,%eax
  802944:	74 0f                	je     802955 <alloc_block_FF+0x15a>
  802946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802949:	8b 40 04             	mov    0x4(%eax),%eax
  80294c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80294f:	8b 12                	mov    (%edx),%edx
  802951:	89 10                	mov    %edx,(%eax)
  802953:	eb 0a                	jmp    80295f <alloc_block_FF+0x164>
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	a3 38 51 80 00       	mov    %eax,0x805138
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802972:	a1 44 51 80 00       	mov    0x805144,%eax
  802977:	48                   	dec    %eax
  802978:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	eb 17                	jmp    802999 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	8b 00                	mov    (%eax),%eax
  802987:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  80298a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298e:	0f 85 7a fe ff ff    	jne    80280e <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802994:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802999:	c9                   	leave  
  80299a:	c3                   	ret    

0080299b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80299b:	55                   	push   %ebp
  80299c:	89 e5                	mov    %esp,%ebp
  80299e:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8029a1:	a1 38 51 80 00       	mov    0x805138,%eax
  8029a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8029a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8029b0:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8029b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8029bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029bf:	e9 d0 00 00 00       	jmp    802a94 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029cd:	0f 82 b8 00 00 00    	jb     802a8b <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8029d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d9:	2b 45 08             	sub    0x8(%ebp),%eax
  8029dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8029df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029e5:	0f 83 a1 00 00 00    	jae    802a8c <alloc_block_BF+0xf1>
				differsize = differance ;
  8029eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  8029f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  8029f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029fb:	0f 85 8b 00 00 00    	jne    802a8c <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802a01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a05:	75 17                	jne    802a1e <alloc_block_BF+0x83>
  802a07:	83 ec 04             	sub    $0x4,%esp
  802a0a:	68 69 40 80 00       	push   $0x804069
  802a0f:	68 a0 00 00 00       	push   $0xa0
  802a14:	68 f7 3f 80 00       	push   $0x803ff7
  802a19:	e8 3b dd ff ff       	call   800759 <_panic>
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 00                	mov    (%eax),%eax
  802a23:	85 c0                	test   %eax,%eax
  802a25:	74 10                	je     802a37 <alloc_block_BF+0x9c>
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 00                	mov    (%eax),%eax
  802a2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2f:	8b 52 04             	mov    0x4(%edx),%edx
  802a32:	89 50 04             	mov    %edx,0x4(%eax)
  802a35:	eb 0b                	jmp    802a42 <alloc_block_BF+0xa7>
  802a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3a:	8b 40 04             	mov    0x4(%eax),%eax
  802a3d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 40 04             	mov    0x4(%eax),%eax
  802a48:	85 c0                	test   %eax,%eax
  802a4a:	74 0f                	je     802a5b <alloc_block_BF+0xc0>
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 40 04             	mov    0x4(%eax),%eax
  802a52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a55:	8b 12                	mov    (%edx),%edx
  802a57:	89 10                	mov    %edx,(%eax)
  802a59:	eb 0a                	jmp    802a65 <alloc_block_BF+0xca>
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	a3 38 51 80 00       	mov    %eax,0x805138
  802a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a78:	a1 44 51 80 00       	mov    0x805144,%eax
  802a7d:	48                   	dec    %eax
  802a7e:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	e9 0c 01 00 00       	jmp    802b97 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802a8b:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802a8c:	a1 40 51 80 00       	mov    0x805140,%eax
  802a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a98:	74 07                	je     802aa1 <alloc_block_BF+0x106>
  802a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9d:	8b 00                	mov    (%eax),%eax
  802a9f:	eb 05                	jmp    802aa6 <alloc_block_BF+0x10b>
  802aa1:	b8 00 00 00 00       	mov    $0x0,%eax
  802aa6:	a3 40 51 80 00       	mov    %eax,0x805140
  802aab:	a1 40 51 80 00       	mov    0x805140,%eax
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	0f 85 0c ff ff ff    	jne    8029c4 <alloc_block_BF+0x29>
  802ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802abc:	0f 85 02 ff ff ff    	jne    8029c4 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802ac2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ac6:	0f 84 c6 00 00 00    	je     802b92 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802acc:	a1 48 51 80 00       	mov    0x805148,%eax
  802ad1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ada:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 50 08             	mov    0x8(%eax),%edx
  802ae3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae6:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aec:	8b 40 0c             	mov    0xc(%eax),%eax
  802aef:	2b 45 08             	sub    0x8(%ebp),%eax
  802af2:	89 c2                	mov    %eax,%edx
  802af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802af7:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afd:	8b 50 08             	mov    0x8(%eax),%edx
  802b00:	8b 45 08             	mov    0x8(%ebp),%eax
  802b03:	01 c2                	add    %eax,%edx
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802b0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b0f:	75 17                	jne    802b28 <alloc_block_BF+0x18d>
  802b11:	83 ec 04             	sub    $0x4,%esp
  802b14:	68 69 40 80 00       	push   $0x804069
  802b19:	68 af 00 00 00       	push   $0xaf
  802b1e:	68 f7 3f 80 00       	push   $0x803ff7
  802b23:	e8 31 dc ff ff       	call   800759 <_panic>
  802b28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	74 10                	je     802b41 <alloc_block_BF+0x1a6>
  802b31:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b39:	8b 52 04             	mov    0x4(%edx),%edx
  802b3c:	89 50 04             	mov    %edx,0x4(%eax)
  802b3f:	eb 0b                	jmp    802b4c <alloc_block_BF+0x1b1>
  802b41:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b44:	8b 40 04             	mov    0x4(%eax),%eax
  802b47:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4f:	8b 40 04             	mov    0x4(%eax),%eax
  802b52:	85 c0                	test   %eax,%eax
  802b54:	74 0f                	je     802b65 <alloc_block_BF+0x1ca>
  802b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b59:	8b 40 04             	mov    0x4(%eax),%eax
  802b5c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b5f:	8b 12                	mov    (%edx),%edx
  802b61:	89 10                	mov    %edx,(%eax)
  802b63:	eb 0a                	jmp    802b6f <alloc_block_BF+0x1d4>
  802b65:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	a3 48 51 80 00       	mov    %eax,0x805148
  802b6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b82:	a1 54 51 80 00       	mov    0x805154,%eax
  802b87:	48                   	dec    %eax
  802b88:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802b8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b90:	eb 05                	jmp    802b97 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802b92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b97:	c9                   	leave  
  802b98:	c3                   	ret    

00802b99 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802b99:	55                   	push   %ebp
  802b9a:	89 e5                	mov    %esp,%ebp
  802b9c:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802b9f:	a1 38 51 80 00       	mov    0x805138,%eax
  802ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802ba7:	e9 7c 01 00 00       	jmp    802d28 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bb5:	0f 86 cf 00 00 00    	jbe    802c8a <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802bbb:	a1 48 51 80 00       	mov    0x805148,%eax
  802bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc6:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcf:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 50 08             	mov    0x8(%eax),%edx
  802bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdb:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	8b 40 0c             	mov    0xc(%eax),%eax
  802be4:	2b 45 08             	sub    0x8(%ebp),%eax
  802be7:	89 c2                	mov    %eax,%edx
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf2:	8b 50 08             	mov    0x8(%eax),%edx
  802bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf8:	01 c2                	add    %eax,%edx
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802c00:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c04:	75 17                	jne    802c1d <alloc_block_NF+0x84>
  802c06:	83 ec 04             	sub    $0x4,%esp
  802c09:	68 69 40 80 00       	push   $0x804069
  802c0e:	68 c4 00 00 00       	push   $0xc4
  802c13:	68 f7 3f 80 00       	push   $0x803ff7
  802c18:	e8 3c db ff ff       	call   800759 <_panic>
  802c1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	74 10                	je     802c36 <alloc_block_NF+0x9d>
  802c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c29:	8b 00                	mov    (%eax),%eax
  802c2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c2e:	8b 52 04             	mov    0x4(%edx),%edx
  802c31:	89 50 04             	mov    %edx,0x4(%eax)
  802c34:	eb 0b                	jmp    802c41 <alloc_block_NF+0xa8>
  802c36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c39:	8b 40 04             	mov    0x4(%eax),%eax
  802c3c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c44:	8b 40 04             	mov    0x4(%eax),%eax
  802c47:	85 c0                	test   %eax,%eax
  802c49:	74 0f                	je     802c5a <alloc_block_NF+0xc1>
  802c4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4e:	8b 40 04             	mov    0x4(%eax),%eax
  802c51:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c54:	8b 12                	mov    (%edx),%edx
  802c56:	89 10                	mov    %edx,(%eax)
  802c58:	eb 0a                	jmp    802c64 <alloc_block_NF+0xcb>
  802c5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c5d:	8b 00                	mov    (%eax),%eax
  802c5f:	a3 48 51 80 00       	mov    %eax,0x805148
  802c64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c67:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c77:	a1 54 51 80 00       	mov    0x805154,%eax
  802c7c:	48                   	dec    %eax
  802c7d:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802c82:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c85:	e9 ad 00 00 00       	jmp    802d37 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c90:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c93:	0f 85 87 00 00 00    	jne    802d20 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9d:	75 17                	jne    802cb6 <alloc_block_NF+0x11d>
  802c9f:	83 ec 04             	sub    $0x4,%esp
  802ca2:	68 69 40 80 00       	push   $0x804069
  802ca7:	68 c8 00 00 00       	push   $0xc8
  802cac:	68 f7 3f 80 00       	push   $0x803ff7
  802cb1:	e8 a3 da ff ff       	call   800759 <_panic>
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	85 c0                	test   %eax,%eax
  802cbd:	74 10                	je     802ccf <alloc_block_NF+0x136>
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 00                	mov    (%eax),%eax
  802cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc7:	8b 52 04             	mov    0x4(%edx),%edx
  802cca:	89 50 04             	mov    %edx,0x4(%eax)
  802ccd:	eb 0b                	jmp    802cda <alloc_block_NF+0x141>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 40 04             	mov    0x4(%eax),%eax
  802ce0:	85 c0                	test   %eax,%eax
  802ce2:	74 0f                	je     802cf3 <alloc_block_NF+0x15a>
  802ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce7:	8b 40 04             	mov    0x4(%eax),%eax
  802cea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ced:	8b 12                	mov    (%edx),%edx
  802cef:	89 10                	mov    %edx,(%eax)
  802cf1:	eb 0a                	jmp    802cfd <alloc_block_NF+0x164>
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 00                	mov    (%eax),%eax
  802cf8:	a3 38 51 80 00       	mov    %eax,0x805138
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d09:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d10:	a1 44 51 80 00       	mov    0x805144,%eax
  802d15:	48                   	dec    %eax
  802d16:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1e:	eb 17                	jmp    802d37 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 00                	mov    (%eax),%eax
  802d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802d28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2c:	0f 85 7a fe ff ff    	jne    802bac <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802d32:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802d37:	c9                   	leave  
  802d38:	c3                   	ret    

00802d39 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d39:	55                   	push   %ebp
  802d3a:	89 e5                	mov    %esp,%ebp
  802d3c:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802d3f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802d47:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802d4f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d54:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802d57:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d5b:	75 68                	jne    802dc5 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802d5d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d61:	75 17                	jne    802d7a <insert_sorted_with_merge_freeList+0x41>
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	68 d4 3f 80 00       	push   $0x803fd4
  802d6b:	68 da 00 00 00       	push   $0xda
  802d70:	68 f7 3f 80 00       	push   $0x803ff7
  802d75:	e8 df d9 ff ff       	call   800759 <_panic>
  802d7a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	89 10                	mov    %edx,(%eax)
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	8b 00                	mov    (%eax),%eax
  802d8a:	85 c0                	test   %eax,%eax
  802d8c:	74 0d                	je     802d9b <insert_sorted_with_merge_freeList+0x62>
  802d8e:	a1 38 51 80 00       	mov    0x805138,%eax
  802d93:	8b 55 08             	mov    0x8(%ebp),%edx
  802d96:	89 50 04             	mov    %edx,0x4(%eax)
  802d99:	eb 08                	jmp    802da3 <insert_sorted_with_merge_freeList+0x6a>
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	a3 38 51 80 00       	mov    %eax,0x805138
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802db5:	a1 44 51 80 00       	mov    0x805144,%eax
  802dba:	40                   	inc    %eax
  802dbb:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802dc0:	e9 49 07 00 00       	jmp    80350e <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802dc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dc8:	8b 50 08             	mov    0x8(%eax),%edx
  802dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802dce:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd1:	01 c2                	add    %eax,%edx
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	8b 40 08             	mov    0x8(%eax),%eax
  802dd9:	39 c2                	cmp    %eax,%edx
  802ddb:	73 77                	jae    802e54 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802de0:	8b 00                	mov    (%eax),%eax
  802de2:	85 c0                	test   %eax,%eax
  802de4:	75 6e                	jne    802e54 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802de6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dea:	74 68                	je     802e54 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802dec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df0:	75 17                	jne    802e09 <insert_sorted_with_merge_freeList+0xd0>
  802df2:	83 ec 04             	sub    $0x4,%esp
  802df5:	68 10 40 80 00       	push   $0x804010
  802dfa:	68 e0 00 00 00       	push   $0xe0
  802dff:	68 f7 3f 80 00       	push   $0x803ff7
  802e04:	e8 50 d9 ff ff       	call   800759 <_panic>
  802e09:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	89 50 04             	mov    %edx,0x4(%eax)
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	8b 40 04             	mov    0x4(%eax),%eax
  802e1b:	85 c0                	test   %eax,%eax
  802e1d:	74 0c                	je     802e2b <insert_sorted_with_merge_freeList+0xf2>
  802e1f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e24:	8b 55 08             	mov    0x8(%ebp),%edx
  802e27:	89 10                	mov    %edx,(%eax)
  802e29:	eb 08                	jmp    802e33 <insert_sorted_with_merge_freeList+0xfa>
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	a3 38 51 80 00       	mov    %eax,0x805138
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e44:	a1 44 51 80 00       	mov    0x805144,%eax
  802e49:	40                   	inc    %eax
  802e4a:	a3 44 51 80 00       	mov    %eax,0x805144
  802e4f:	e9 ba 06 00 00       	jmp    80350e <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 50 0c             	mov    0xc(%eax),%edx
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	8b 40 08             	mov    0x8(%eax),%eax
  802e60:	01 c2                	add    %eax,%edx
  802e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e65:	8b 40 08             	mov    0x8(%eax),%eax
  802e68:	39 c2                	cmp    %eax,%edx
  802e6a:	73 78                	jae    802ee4 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 40 04             	mov    0x4(%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	75 6e                	jne    802ee4 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802e76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e7a:	74 68                	je     802ee4 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802e7c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e80:	75 17                	jne    802e99 <insert_sorted_with_merge_freeList+0x160>
  802e82:	83 ec 04             	sub    $0x4,%esp
  802e85:	68 d4 3f 80 00       	push   $0x803fd4
  802e8a:	68 e6 00 00 00       	push   $0xe6
  802e8f:	68 f7 3f 80 00       	push   $0x803ff7
  802e94:	e8 c0 d8 ff ff       	call   800759 <_panic>
  802e99:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	89 10                	mov    %edx,(%eax)
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	8b 00                	mov    (%eax),%eax
  802ea9:	85 c0                	test   %eax,%eax
  802eab:	74 0d                	je     802eba <insert_sorted_with_merge_freeList+0x181>
  802ead:	a1 38 51 80 00       	mov    0x805138,%eax
  802eb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802eb5:	89 50 04             	mov    %edx,0x4(%eax)
  802eb8:	eb 08                	jmp    802ec2 <insert_sorted_with_merge_freeList+0x189>
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	a3 38 51 80 00       	mov    %eax,0x805138
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ed9:	40                   	inc    %eax
  802eda:	a3 44 51 80 00       	mov    %eax,0x805144
  802edf:	e9 2a 06 00 00       	jmp    80350e <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802ee4:	a1 38 51 80 00       	mov    0x805138,%eax
  802ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eec:	e9 ed 05 00 00       	jmp    8034de <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802ef9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802efd:	0f 84 a7 00 00 00    	je     802faa <insert_sorted_with_merge_freeList+0x271>
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	8b 50 0c             	mov    0xc(%eax),%edx
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	8b 40 08             	mov    0x8(%eax),%eax
  802f0f:	01 c2                	add    %eax,%edx
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	8b 40 08             	mov    0x8(%eax),%eax
  802f17:	39 c2                	cmp    %eax,%edx
  802f19:	0f 83 8b 00 00 00    	jae    802faa <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 50 0c             	mov    0xc(%eax),%edx
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	8b 40 08             	mov    0x8(%eax),%eax
  802f2b:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802f2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f30:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802f33:	39 c2                	cmp    %eax,%edx
  802f35:	73 73                	jae    802faa <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f3b:	74 06                	je     802f43 <insert_sorted_with_merge_freeList+0x20a>
  802f3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f41:	75 17                	jne    802f5a <insert_sorted_with_merge_freeList+0x221>
  802f43:	83 ec 04             	sub    $0x4,%esp
  802f46:	68 88 40 80 00       	push   $0x804088
  802f4b:	68 f0 00 00 00       	push   $0xf0
  802f50:	68 f7 3f 80 00       	push   $0x803ff7
  802f55:	e8 ff d7 ff ff       	call   800759 <_panic>
  802f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5d:	8b 10                	mov    (%eax),%edx
  802f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f62:	89 10                	mov    %edx,(%eax)
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	8b 00                	mov    (%eax),%eax
  802f69:	85 c0                	test   %eax,%eax
  802f6b:	74 0b                	je     802f78 <insert_sorted_with_merge_freeList+0x23f>
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	8b 55 08             	mov    0x8(%ebp),%edx
  802f75:	89 50 04             	mov    %edx,0x4(%eax)
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7e:	89 10                	mov    %edx,(%eax)
  802f80:	8b 45 08             	mov    0x8(%ebp),%eax
  802f83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f86:	89 50 04             	mov    %edx,0x4(%eax)
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 00                	mov    (%eax),%eax
  802f8e:	85 c0                	test   %eax,%eax
  802f90:	75 08                	jne    802f9a <insert_sorted_with_merge_freeList+0x261>
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f9a:	a1 44 51 80 00       	mov    0x805144,%eax
  802f9f:	40                   	inc    %eax
  802fa0:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  802fa5:	e9 64 05 00 00       	jmp    80350e <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802faa:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802faf:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fb7:	8b 40 08             	mov    0x8(%eax),%eax
  802fba:	01 c2                	add    %eax,%edx
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	8b 40 08             	mov    0x8(%eax),%eax
  802fc2:	39 c2                	cmp    %eax,%edx
  802fc4:	0f 85 b1 00 00 00    	jne    80307b <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802fca:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fcf:	85 c0                	test   %eax,%eax
  802fd1:	0f 84 a4 00 00 00    	je     80307b <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802fd7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	85 c0                	test   %eax,%eax
  802fe0:	0f 85 95 00 00 00    	jne    80307b <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802fe6:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802feb:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ff1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ff7:	8b 52 0c             	mov    0xc(%edx),%edx
  802ffa:	01 ca                	add    %ecx,%edx
  802ffc:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803009:	8b 45 08             	mov    0x8(%ebp),%eax
  80300c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803013:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803017:	75 17                	jne    803030 <insert_sorted_with_merge_freeList+0x2f7>
  803019:	83 ec 04             	sub    $0x4,%esp
  80301c:	68 d4 3f 80 00       	push   $0x803fd4
  803021:	68 ff 00 00 00       	push   $0xff
  803026:	68 f7 3f 80 00       	push   $0x803ff7
  80302b:	e8 29 d7 ff ff       	call   800759 <_panic>
  803030:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	89 10                	mov    %edx,(%eax)
  80303b:	8b 45 08             	mov    0x8(%ebp),%eax
  80303e:	8b 00                	mov    (%eax),%eax
  803040:	85 c0                	test   %eax,%eax
  803042:	74 0d                	je     803051 <insert_sorted_with_merge_freeList+0x318>
  803044:	a1 48 51 80 00       	mov    0x805148,%eax
  803049:	8b 55 08             	mov    0x8(%ebp),%edx
  80304c:	89 50 04             	mov    %edx,0x4(%eax)
  80304f:	eb 08                	jmp    803059 <insert_sorted_with_merge_freeList+0x320>
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	a3 48 51 80 00       	mov    %eax,0x805148
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306b:	a1 54 51 80 00       	mov    0x805154,%eax
  803070:	40                   	inc    %eax
  803071:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803076:	e9 93 04 00 00       	jmp    80350e <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  80307b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307e:	8b 50 08             	mov    0x8(%eax),%edx
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 40 0c             	mov    0xc(%eax),%eax
  803087:	01 c2                	add    %eax,%edx
  803089:	8b 45 08             	mov    0x8(%ebp),%eax
  80308c:	8b 40 08             	mov    0x8(%eax),%eax
  80308f:	39 c2                	cmp    %eax,%edx
  803091:	0f 85 ae 00 00 00    	jne    803145 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803097:	8b 45 08             	mov    0x8(%ebp),%eax
  80309a:	8b 50 0c             	mov    0xc(%eax),%edx
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	8b 40 08             	mov    0x8(%eax),%eax
  8030a3:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 00                	mov    (%eax),%eax
  8030aa:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  8030ad:	39 c2                	cmp    %eax,%edx
  8030af:	0f 84 90 00 00 00    	je     803145 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  8030b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b8:	8b 50 0c             	mov    0xc(%eax),%edx
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c1:	01 c2                	add    %eax,%edx
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8030c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8030dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e1:	75 17                	jne    8030fa <insert_sorted_with_merge_freeList+0x3c1>
  8030e3:	83 ec 04             	sub    $0x4,%esp
  8030e6:	68 d4 3f 80 00       	push   $0x803fd4
  8030eb:	68 0b 01 00 00       	push   $0x10b
  8030f0:	68 f7 3f 80 00       	push   $0x803ff7
  8030f5:	e8 5f d6 ff ff       	call   800759 <_panic>
  8030fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803100:	8b 45 08             	mov    0x8(%ebp),%eax
  803103:	89 10                	mov    %edx,(%eax)
  803105:	8b 45 08             	mov    0x8(%ebp),%eax
  803108:	8b 00                	mov    (%eax),%eax
  80310a:	85 c0                	test   %eax,%eax
  80310c:	74 0d                	je     80311b <insert_sorted_with_merge_freeList+0x3e2>
  80310e:	a1 48 51 80 00       	mov    0x805148,%eax
  803113:	8b 55 08             	mov    0x8(%ebp),%edx
  803116:	89 50 04             	mov    %edx,0x4(%eax)
  803119:	eb 08                	jmp    803123 <insert_sorted_with_merge_freeList+0x3ea>
  80311b:	8b 45 08             	mov    0x8(%ebp),%eax
  80311e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	a3 48 51 80 00       	mov    %eax,0x805148
  80312b:	8b 45 08             	mov    0x8(%ebp),%eax
  80312e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803135:	a1 54 51 80 00       	mov    0x805154,%eax
  80313a:	40                   	inc    %eax
  80313b:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803140:	e9 c9 03 00 00       	jmp    80350e <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803145:	8b 45 08             	mov    0x8(%ebp),%eax
  803148:	8b 50 0c             	mov    0xc(%eax),%edx
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	8b 40 08             	mov    0x8(%eax),%eax
  803151:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803156:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803159:	39 c2                	cmp    %eax,%edx
  80315b:	0f 85 bb 00 00 00    	jne    80321c <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  803161:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803165:	0f 84 b1 00 00 00    	je     80321c <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  80316b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316e:	8b 40 04             	mov    0x4(%eax),%eax
  803171:	85 c0                	test   %eax,%eax
  803173:	0f 85 a3 00 00 00    	jne    80321c <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803179:	a1 38 51 80 00       	mov    0x805138,%eax
  80317e:	8b 55 08             	mov    0x8(%ebp),%edx
  803181:	8b 52 08             	mov    0x8(%edx),%edx
  803184:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803187:	a1 38 51 80 00       	mov    0x805138,%eax
  80318c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803192:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803195:	8b 55 08             	mov    0x8(%ebp),%edx
  803198:	8b 52 0c             	mov    0xc(%edx),%edx
  80319b:	01 ca                	add    %ecx,%edx
  80319d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8031a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8031b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b8:	75 17                	jne    8031d1 <insert_sorted_with_merge_freeList+0x498>
  8031ba:	83 ec 04             	sub    $0x4,%esp
  8031bd:	68 d4 3f 80 00       	push   $0x803fd4
  8031c2:	68 17 01 00 00       	push   $0x117
  8031c7:	68 f7 3f 80 00       	push   $0x803ff7
  8031cc:	e8 88 d5 ff ff       	call   800759 <_panic>
  8031d1:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031da:	89 10                	mov    %edx,(%eax)
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	8b 00                	mov    (%eax),%eax
  8031e1:	85 c0                	test   %eax,%eax
  8031e3:	74 0d                	je     8031f2 <insert_sorted_with_merge_freeList+0x4b9>
  8031e5:	a1 48 51 80 00       	mov    0x805148,%eax
  8031ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ed:	89 50 04             	mov    %edx,0x4(%eax)
  8031f0:	eb 08                	jmp    8031fa <insert_sorted_with_merge_freeList+0x4c1>
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	a3 48 51 80 00       	mov    %eax,0x805148
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80320c:	a1 54 51 80 00       	mov    0x805154,%eax
  803211:	40                   	inc    %eax
  803212:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803217:	e9 f2 02 00 00       	jmp    80350e <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  80321c:	8b 45 08             	mov    0x8(%ebp),%eax
  80321f:	8b 50 08             	mov    0x8(%eax),%edx
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	8b 40 0c             	mov    0xc(%eax),%eax
  803228:	01 c2                	add    %eax,%edx
  80322a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322d:	8b 40 08             	mov    0x8(%eax),%eax
  803230:	39 c2                	cmp    %eax,%edx
  803232:	0f 85 be 00 00 00    	jne    8032f6 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323b:	8b 40 04             	mov    0x4(%eax),%eax
  80323e:	8b 50 08             	mov    0x8(%eax),%edx
  803241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803244:	8b 40 04             	mov    0x4(%eax),%eax
  803247:	8b 40 0c             	mov    0xc(%eax),%eax
  80324a:	01 c2                	add    %eax,%edx
  80324c:	8b 45 08             	mov    0x8(%ebp),%eax
  80324f:	8b 40 08             	mov    0x8(%eax),%eax
  803252:	39 c2                	cmp    %eax,%edx
  803254:	0f 84 9c 00 00 00    	je     8032f6 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  80325a:	8b 45 08             	mov    0x8(%ebp),%eax
  80325d:	8b 50 08             	mov    0x8(%eax),%edx
  803260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803263:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803266:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803269:	8b 50 0c             	mov    0xc(%eax),%edx
  80326c:	8b 45 08             	mov    0x8(%ebp),%eax
  80326f:	8b 40 0c             	mov    0xc(%eax),%eax
  803272:	01 c2                	add    %eax,%edx
  803274:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803277:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803284:	8b 45 08             	mov    0x8(%ebp),%eax
  803287:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80328e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803292:	75 17                	jne    8032ab <insert_sorted_with_merge_freeList+0x572>
  803294:	83 ec 04             	sub    $0x4,%esp
  803297:	68 d4 3f 80 00       	push   $0x803fd4
  80329c:	68 26 01 00 00       	push   $0x126
  8032a1:	68 f7 3f 80 00       	push   $0x803ff7
  8032a6:	e8 ae d4 ff ff       	call   800759 <_panic>
  8032ab:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b4:	89 10                	mov    %edx,(%eax)
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	8b 00                	mov    (%eax),%eax
  8032bb:	85 c0                	test   %eax,%eax
  8032bd:	74 0d                	je     8032cc <insert_sorted_with_merge_freeList+0x593>
  8032bf:	a1 48 51 80 00       	mov    0x805148,%eax
  8032c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c7:	89 50 04             	mov    %edx,0x4(%eax)
  8032ca:	eb 08                	jmp    8032d4 <insert_sorted_with_merge_freeList+0x59b>
  8032cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8032eb:	40                   	inc    %eax
  8032ec:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  8032f1:	e9 18 02 00 00       	jmp    80350e <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  8032f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ff:	8b 40 08             	mov    0x8(%eax),%eax
  803302:	01 c2                	add    %eax,%edx
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	8b 40 08             	mov    0x8(%eax),%eax
  80330a:	39 c2                	cmp    %eax,%edx
  80330c:	0f 85 c4 01 00 00    	jne    8034d6 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803312:	8b 45 08             	mov    0x8(%ebp),%eax
  803315:	8b 50 0c             	mov    0xc(%eax),%edx
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	8b 40 08             	mov    0x8(%eax),%eax
  80331e:	01 c2                	add    %eax,%edx
  803320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803323:	8b 00                	mov    (%eax),%eax
  803325:	8b 40 08             	mov    0x8(%eax),%eax
  803328:	39 c2                	cmp    %eax,%edx
  80332a:	0f 85 a6 01 00 00    	jne    8034d6 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803330:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803334:	0f 84 9c 01 00 00    	je     8034d6 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 50 0c             	mov    0xc(%eax),%edx
  803340:	8b 45 08             	mov    0x8(%ebp),%eax
  803343:	8b 40 0c             	mov    0xc(%eax),%eax
  803346:	01 c2                	add    %eax,%edx
  803348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334b:	8b 00                	mov    (%eax),%eax
  80334d:	8b 40 0c             	mov    0xc(%eax),%eax
  803350:	01 c2                	add    %eax,%edx
  803352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803355:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803358:	8b 45 08             	mov    0x8(%ebp),%eax
  80335b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803362:	8b 45 08             	mov    0x8(%ebp),%eax
  803365:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80336c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803370:	75 17                	jne    803389 <insert_sorted_with_merge_freeList+0x650>
  803372:	83 ec 04             	sub    $0x4,%esp
  803375:	68 d4 3f 80 00       	push   $0x803fd4
  80337a:	68 32 01 00 00       	push   $0x132
  80337f:	68 f7 3f 80 00       	push   $0x803ff7
  803384:	e8 d0 d3 ff ff       	call   800759 <_panic>
  803389:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	89 10                	mov    %edx,(%eax)
  803394:	8b 45 08             	mov    0x8(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	85 c0                	test   %eax,%eax
  80339b:	74 0d                	je     8033aa <insert_sorted_with_merge_freeList+0x671>
  80339d:	a1 48 51 80 00       	mov    0x805148,%eax
  8033a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a5:	89 50 04             	mov    %edx,0x4(%eax)
  8033a8:	eb 08                	jmp    8033b2 <insert_sorted_with_merge_freeList+0x679>
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b5:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c4:	a1 54 51 80 00       	mov    0x805154,%eax
  8033c9:	40                   	inc    %eax
  8033ca:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  8033cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033d2:	8b 00                	mov    (%eax),%eax
  8033d4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  8033db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033de:	8b 00                	mov    (%eax),%eax
  8033e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  8033e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ea:	8b 00                	mov    (%eax),%eax
  8033ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  8033ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033f3:	75 17                	jne    80340c <insert_sorted_with_merge_freeList+0x6d3>
  8033f5:	83 ec 04             	sub    $0x4,%esp
  8033f8:	68 69 40 80 00       	push   $0x804069
  8033fd:	68 36 01 00 00       	push   $0x136
  803402:	68 f7 3f 80 00       	push   $0x803ff7
  803407:	e8 4d d3 ff ff       	call   800759 <_panic>
  80340c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340f:	8b 00                	mov    (%eax),%eax
  803411:	85 c0                	test   %eax,%eax
  803413:	74 10                	je     803425 <insert_sorted_with_merge_freeList+0x6ec>
  803415:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803418:	8b 00                	mov    (%eax),%eax
  80341a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80341d:	8b 52 04             	mov    0x4(%edx),%edx
  803420:	89 50 04             	mov    %edx,0x4(%eax)
  803423:	eb 0b                	jmp    803430 <insert_sorted_with_merge_freeList+0x6f7>
  803425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803428:	8b 40 04             	mov    0x4(%eax),%eax
  80342b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803430:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803433:	8b 40 04             	mov    0x4(%eax),%eax
  803436:	85 c0                	test   %eax,%eax
  803438:	74 0f                	je     803449 <insert_sorted_with_merge_freeList+0x710>
  80343a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343d:	8b 40 04             	mov    0x4(%eax),%eax
  803440:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803443:	8b 12                	mov    (%edx),%edx
  803445:	89 10                	mov    %edx,(%eax)
  803447:	eb 0a                	jmp    803453 <insert_sorted_with_merge_freeList+0x71a>
  803449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344c:	8b 00                	mov    (%eax),%eax
  80344e:	a3 38 51 80 00       	mov    %eax,0x805138
  803453:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803456:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80345c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803466:	a1 44 51 80 00       	mov    0x805144,%eax
  80346b:	48                   	dec    %eax
  80346c:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803475:	75 17                	jne    80348e <insert_sorted_with_merge_freeList+0x755>
  803477:	83 ec 04             	sub    $0x4,%esp
  80347a:	68 d4 3f 80 00       	push   $0x803fd4
  80347f:	68 37 01 00 00       	push   $0x137
  803484:	68 f7 3f 80 00       	push   $0x803ff7
  803489:	e8 cb d2 ff ff       	call   800759 <_panic>
  80348e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803497:	89 10                	mov    %edx,(%eax)
  803499:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80349c:	8b 00                	mov    (%eax),%eax
  80349e:	85 c0                	test   %eax,%eax
  8034a0:	74 0d                	je     8034af <insert_sorted_with_merge_freeList+0x776>
  8034a2:	a1 48 51 80 00       	mov    0x805148,%eax
  8034a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034aa:	89 50 04             	mov    %edx,0x4(%eax)
  8034ad:	eb 08                	jmp    8034b7 <insert_sorted_with_merge_freeList+0x77e>
  8034af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034b2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ba:	a3 48 51 80 00       	mov    %eax,0x805148
  8034bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034c2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034c9:	a1 54 51 80 00       	mov    0x805154,%eax
  8034ce:	40                   	inc    %eax
  8034cf:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  8034d4:	eb 38                	jmp    80350e <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8034d6:	a1 40 51 80 00       	mov    0x805140,%eax
  8034db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034e2:	74 07                	je     8034eb <insert_sorted_with_merge_freeList+0x7b2>
  8034e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e7:	8b 00                	mov    (%eax),%eax
  8034e9:	eb 05                	jmp    8034f0 <insert_sorted_with_merge_freeList+0x7b7>
  8034eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8034f0:	a3 40 51 80 00       	mov    %eax,0x805140
  8034f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8034fa:	85 c0                	test   %eax,%eax
  8034fc:	0f 85 ef f9 ff ff    	jne    802ef1 <insert_sorted_with_merge_freeList+0x1b8>
  803502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803506:	0f 85 e5 f9 ff ff    	jne    802ef1 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80350c:	eb 00                	jmp    80350e <insert_sorted_with_merge_freeList+0x7d5>
  80350e:	90                   	nop
  80350f:	c9                   	leave  
  803510:	c3                   	ret    
  803511:	66 90                	xchg   %ax,%ax
  803513:	90                   	nop

00803514 <__udivdi3>:
  803514:	55                   	push   %ebp
  803515:	57                   	push   %edi
  803516:	56                   	push   %esi
  803517:	53                   	push   %ebx
  803518:	83 ec 1c             	sub    $0x1c,%esp
  80351b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80351f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803523:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803527:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80352b:	89 ca                	mov    %ecx,%edx
  80352d:	89 f8                	mov    %edi,%eax
  80352f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803533:	85 f6                	test   %esi,%esi
  803535:	75 2d                	jne    803564 <__udivdi3+0x50>
  803537:	39 cf                	cmp    %ecx,%edi
  803539:	77 65                	ja     8035a0 <__udivdi3+0x8c>
  80353b:	89 fd                	mov    %edi,%ebp
  80353d:	85 ff                	test   %edi,%edi
  80353f:	75 0b                	jne    80354c <__udivdi3+0x38>
  803541:	b8 01 00 00 00       	mov    $0x1,%eax
  803546:	31 d2                	xor    %edx,%edx
  803548:	f7 f7                	div    %edi
  80354a:	89 c5                	mov    %eax,%ebp
  80354c:	31 d2                	xor    %edx,%edx
  80354e:	89 c8                	mov    %ecx,%eax
  803550:	f7 f5                	div    %ebp
  803552:	89 c1                	mov    %eax,%ecx
  803554:	89 d8                	mov    %ebx,%eax
  803556:	f7 f5                	div    %ebp
  803558:	89 cf                	mov    %ecx,%edi
  80355a:	89 fa                	mov    %edi,%edx
  80355c:	83 c4 1c             	add    $0x1c,%esp
  80355f:	5b                   	pop    %ebx
  803560:	5e                   	pop    %esi
  803561:	5f                   	pop    %edi
  803562:	5d                   	pop    %ebp
  803563:	c3                   	ret    
  803564:	39 ce                	cmp    %ecx,%esi
  803566:	77 28                	ja     803590 <__udivdi3+0x7c>
  803568:	0f bd fe             	bsr    %esi,%edi
  80356b:	83 f7 1f             	xor    $0x1f,%edi
  80356e:	75 40                	jne    8035b0 <__udivdi3+0x9c>
  803570:	39 ce                	cmp    %ecx,%esi
  803572:	72 0a                	jb     80357e <__udivdi3+0x6a>
  803574:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803578:	0f 87 9e 00 00 00    	ja     80361c <__udivdi3+0x108>
  80357e:	b8 01 00 00 00       	mov    $0x1,%eax
  803583:	89 fa                	mov    %edi,%edx
  803585:	83 c4 1c             	add    $0x1c,%esp
  803588:	5b                   	pop    %ebx
  803589:	5e                   	pop    %esi
  80358a:	5f                   	pop    %edi
  80358b:	5d                   	pop    %ebp
  80358c:	c3                   	ret    
  80358d:	8d 76 00             	lea    0x0(%esi),%esi
  803590:	31 ff                	xor    %edi,%edi
  803592:	31 c0                	xor    %eax,%eax
  803594:	89 fa                	mov    %edi,%edx
  803596:	83 c4 1c             	add    $0x1c,%esp
  803599:	5b                   	pop    %ebx
  80359a:	5e                   	pop    %esi
  80359b:	5f                   	pop    %edi
  80359c:	5d                   	pop    %ebp
  80359d:	c3                   	ret    
  80359e:	66 90                	xchg   %ax,%ax
  8035a0:	89 d8                	mov    %ebx,%eax
  8035a2:	f7 f7                	div    %edi
  8035a4:	31 ff                	xor    %edi,%edi
  8035a6:	89 fa                	mov    %edi,%edx
  8035a8:	83 c4 1c             	add    $0x1c,%esp
  8035ab:	5b                   	pop    %ebx
  8035ac:	5e                   	pop    %esi
  8035ad:	5f                   	pop    %edi
  8035ae:	5d                   	pop    %ebp
  8035af:	c3                   	ret    
  8035b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035b5:	89 eb                	mov    %ebp,%ebx
  8035b7:	29 fb                	sub    %edi,%ebx
  8035b9:	89 f9                	mov    %edi,%ecx
  8035bb:	d3 e6                	shl    %cl,%esi
  8035bd:	89 c5                	mov    %eax,%ebp
  8035bf:	88 d9                	mov    %bl,%cl
  8035c1:	d3 ed                	shr    %cl,%ebp
  8035c3:	89 e9                	mov    %ebp,%ecx
  8035c5:	09 f1                	or     %esi,%ecx
  8035c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8035cb:	89 f9                	mov    %edi,%ecx
  8035cd:	d3 e0                	shl    %cl,%eax
  8035cf:	89 c5                	mov    %eax,%ebp
  8035d1:	89 d6                	mov    %edx,%esi
  8035d3:	88 d9                	mov    %bl,%cl
  8035d5:	d3 ee                	shr    %cl,%esi
  8035d7:	89 f9                	mov    %edi,%ecx
  8035d9:	d3 e2                	shl    %cl,%edx
  8035db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035df:	88 d9                	mov    %bl,%cl
  8035e1:	d3 e8                	shr    %cl,%eax
  8035e3:	09 c2                	or     %eax,%edx
  8035e5:	89 d0                	mov    %edx,%eax
  8035e7:	89 f2                	mov    %esi,%edx
  8035e9:	f7 74 24 0c          	divl   0xc(%esp)
  8035ed:	89 d6                	mov    %edx,%esi
  8035ef:	89 c3                	mov    %eax,%ebx
  8035f1:	f7 e5                	mul    %ebp
  8035f3:	39 d6                	cmp    %edx,%esi
  8035f5:	72 19                	jb     803610 <__udivdi3+0xfc>
  8035f7:	74 0b                	je     803604 <__udivdi3+0xf0>
  8035f9:	89 d8                	mov    %ebx,%eax
  8035fb:	31 ff                	xor    %edi,%edi
  8035fd:	e9 58 ff ff ff       	jmp    80355a <__udivdi3+0x46>
  803602:	66 90                	xchg   %ax,%ax
  803604:	8b 54 24 08          	mov    0x8(%esp),%edx
  803608:	89 f9                	mov    %edi,%ecx
  80360a:	d3 e2                	shl    %cl,%edx
  80360c:	39 c2                	cmp    %eax,%edx
  80360e:	73 e9                	jae    8035f9 <__udivdi3+0xe5>
  803610:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803613:	31 ff                	xor    %edi,%edi
  803615:	e9 40 ff ff ff       	jmp    80355a <__udivdi3+0x46>
  80361a:	66 90                	xchg   %ax,%ax
  80361c:	31 c0                	xor    %eax,%eax
  80361e:	e9 37 ff ff ff       	jmp    80355a <__udivdi3+0x46>
  803623:	90                   	nop

00803624 <__umoddi3>:
  803624:	55                   	push   %ebp
  803625:	57                   	push   %edi
  803626:	56                   	push   %esi
  803627:	53                   	push   %ebx
  803628:	83 ec 1c             	sub    $0x1c,%esp
  80362b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80362f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803633:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803637:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80363b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80363f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803643:	89 f3                	mov    %esi,%ebx
  803645:	89 fa                	mov    %edi,%edx
  803647:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80364b:	89 34 24             	mov    %esi,(%esp)
  80364e:	85 c0                	test   %eax,%eax
  803650:	75 1a                	jne    80366c <__umoddi3+0x48>
  803652:	39 f7                	cmp    %esi,%edi
  803654:	0f 86 a2 00 00 00    	jbe    8036fc <__umoddi3+0xd8>
  80365a:	89 c8                	mov    %ecx,%eax
  80365c:	89 f2                	mov    %esi,%edx
  80365e:	f7 f7                	div    %edi
  803660:	89 d0                	mov    %edx,%eax
  803662:	31 d2                	xor    %edx,%edx
  803664:	83 c4 1c             	add    $0x1c,%esp
  803667:	5b                   	pop    %ebx
  803668:	5e                   	pop    %esi
  803669:	5f                   	pop    %edi
  80366a:	5d                   	pop    %ebp
  80366b:	c3                   	ret    
  80366c:	39 f0                	cmp    %esi,%eax
  80366e:	0f 87 ac 00 00 00    	ja     803720 <__umoddi3+0xfc>
  803674:	0f bd e8             	bsr    %eax,%ebp
  803677:	83 f5 1f             	xor    $0x1f,%ebp
  80367a:	0f 84 ac 00 00 00    	je     80372c <__umoddi3+0x108>
  803680:	bf 20 00 00 00       	mov    $0x20,%edi
  803685:	29 ef                	sub    %ebp,%edi
  803687:	89 fe                	mov    %edi,%esi
  803689:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80368d:	89 e9                	mov    %ebp,%ecx
  80368f:	d3 e0                	shl    %cl,%eax
  803691:	89 d7                	mov    %edx,%edi
  803693:	89 f1                	mov    %esi,%ecx
  803695:	d3 ef                	shr    %cl,%edi
  803697:	09 c7                	or     %eax,%edi
  803699:	89 e9                	mov    %ebp,%ecx
  80369b:	d3 e2                	shl    %cl,%edx
  80369d:	89 14 24             	mov    %edx,(%esp)
  8036a0:	89 d8                	mov    %ebx,%eax
  8036a2:	d3 e0                	shl    %cl,%eax
  8036a4:	89 c2                	mov    %eax,%edx
  8036a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036aa:	d3 e0                	shl    %cl,%eax
  8036ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036b4:	89 f1                	mov    %esi,%ecx
  8036b6:	d3 e8                	shr    %cl,%eax
  8036b8:	09 d0                	or     %edx,%eax
  8036ba:	d3 eb                	shr    %cl,%ebx
  8036bc:	89 da                	mov    %ebx,%edx
  8036be:	f7 f7                	div    %edi
  8036c0:	89 d3                	mov    %edx,%ebx
  8036c2:	f7 24 24             	mull   (%esp)
  8036c5:	89 c6                	mov    %eax,%esi
  8036c7:	89 d1                	mov    %edx,%ecx
  8036c9:	39 d3                	cmp    %edx,%ebx
  8036cb:	0f 82 87 00 00 00    	jb     803758 <__umoddi3+0x134>
  8036d1:	0f 84 91 00 00 00    	je     803768 <__umoddi3+0x144>
  8036d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8036db:	29 f2                	sub    %esi,%edx
  8036dd:	19 cb                	sbb    %ecx,%ebx
  8036df:	89 d8                	mov    %ebx,%eax
  8036e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8036e5:	d3 e0                	shl    %cl,%eax
  8036e7:	89 e9                	mov    %ebp,%ecx
  8036e9:	d3 ea                	shr    %cl,%edx
  8036eb:	09 d0                	or     %edx,%eax
  8036ed:	89 e9                	mov    %ebp,%ecx
  8036ef:	d3 eb                	shr    %cl,%ebx
  8036f1:	89 da                	mov    %ebx,%edx
  8036f3:	83 c4 1c             	add    $0x1c,%esp
  8036f6:	5b                   	pop    %ebx
  8036f7:	5e                   	pop    %esi
  8036f8:	5f                   	pop    %edi
  8036f9:	5d                   	pop    %ebp
  8036fa:	c3                   	ret    
  8036fb:	90                   	nop
  8036fc:	89 fd                	mov    %edi,%ebp
  8036fe:	85 ff                	test   %edi,%edi
  803700:	75 0b                	jne    80370d <__umoddi3+0xe9>
  803702:	b8 01 00 00 00       	mov    $0x1,%eax
  803707:	31 d2                	xor    %edx,%edx
  803709:	f7 f7                	div    %edi
  80370b:	89 c5                	mov    %eax,%ebp
  80370d:	89 f0                	mov    %esi,%eax
  80370f:	31 d2                	xor    %edx,%edx
  803711:	f7 f5                	div    %ebp
  803713:	89 c8                	mov    %ecx,%eax
  803715:	f7 f5                	div    %ebp
  803717:	89 d0                	mov    %edx,%eax
  803719:	e9 44 ff ff ff       	jmp    803662 <__umoddi3+0x3e>
  80371e:	66 90                	xchg   %ax,%ax
  803720:	89 c8                	mov    %ecx,%eax
  803722:	89 f2                	mov    %esi,%edx
  803724:	83 c4 1c             	add    $0x1c,%esp
  803727:	5b                   	pop    %ebx
  803728:	5e                   	pop    %esi
  803729:	5f                   	pop    %edi
  80372a:	5d                   	pop    %ebp
  80372b:	c3                   	ret    
  80372c:	3b 04 24             	cmp    (%esp),%eax
  80372f:	72 06                	jb     803737 <__umoddi3+0x113>
  803731:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803735:	77 0f                	ja     803746 <__umoddi3+0x122>
  803737:	89 f2                	mov    %esi,%edx
  803739:	29 f9                	sub    %edi,%ecx
  80373b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80373f:	89 14 24             	mov    %edx,(%esp)
  803742:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803746:	8b 44 24 04          	mov    0x4(%esp),%eax
  80374a:	8b 14 24             	mov    (%esp),%edx
  80374d:	83 c4 1c             	add    $0x1c,%esp
  803750:	5b                   	pop    %ebx
  803751:	5e                   	pop    %esi
  803752:	5f                   	pop    %edi
  803753:	5d                   	pop    %ebp
  803754:	c3                   	ret    
  803755:	8d 76 00             	lea    0x0(%esi),%esi
  803758:	2b 04 24             	sub    (%esp),%eax
  80375b:	19 fa                	sbb    %edi,%edx
  80375d:	89 d1                	mov    %edx,%ecx
  80375f:	89 c6                	mov    %eax,%esi
  803761:	e9 71 ff ff ff       	jmp    8036d7 <__umoddi3+0xb3>
  803766:	66 90                	xchg   %ax,%ax
  803768:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80376c:	72 ea                	jb     803758 <__umoddi3+0x134>
  80376e:	89 d9                	mov    %ebx,%ecx
  803770:	e9 62 ff ff ff       	jmp    8036d7 <__umoddi3+0xb3>
