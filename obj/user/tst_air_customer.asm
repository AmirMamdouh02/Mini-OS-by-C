
obj/user/tst_air_customer:     file format elf32-i386


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
  800031:	e8 dc 03 00 00       	call   800412 <libmain>
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
  80003e:	81 ec 8c 01 00 00    	sub    $0x18c,%esp
	int32 parentenvID = sys_getparentenvid();
  800044:	e8 0f 1d 00 00       	call   801d58 <sys_getparentenvid>
  800049:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	char _customers[] = "customers";
  80004c:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80004f:	bb c9 35 80 00       	mov    $0x8035c9,%ebx
  800054:	ba 0a 00 00 00       	mov    $0xa,%edx
  800059:	89 c7                	mov    %eax,%edi
  80005b:	89 de                	mov    %ebx,%esi
  80005d:	89 d1                	mov    %edx,%ecx
  80005f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  800061:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800064:	bb d3 35 80 00       	mov    $0x8035d3,%ebx
  800069:	ba 03 00 00 00       	mov    $0x3,%edx
  80006e:	89 c7                	mov    %eax,%edi
  800070:	89 de                	mov    %ebx,%esi
  800072:	89 d1                	mov    %edx,%ecx
  800074:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  800076:	8d 45 a7             	lea    -0x59(%ebp),%eax
  800079:	bb df 35 80 00       	mov    $0x8035df,%ebx
  80007e:	ba 0f 00 00 00       	mov    $0xf,%edx
  800083:	89 c7                	mov    %eax,%edi
  800085:	89 de                	mov    %ebx,%esi
  800087:	89 d1                	mov    %edx,%ecx
  800089:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  80008b:	8d 45 98             	lea    -0x68(%ebp),%eax
  80008e:	bb ee 35 80 00       	mov    $0x8035ee,%ebx
  800093:	ba 0f 00 00 00       	mov    $0xf,%edx
  800098:	89 c7                	mov    %eax,%edi
  80009a:	89 de                	mov    %ebx,%esi
  80009c:	89 d1                	mov    %edx,%ecx
  80009e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000a0:	8d 45 83             	lea    -0x7d(%ebp),%eax
  8000a3:	bb fd 35 80 00       	mov    $0x8035fd,%ebx
  8000a8:	ba 15 00 00 00       	mov    $0x15,%edx
  8000ad:	89 c7                	mov    %eax,%edi
  8000af:	89 de                	mov    %ebx,%esi
  8000b1:	89 d1                	mov    %edx,%ecx
  8000b3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000b5:	8d 85 6e ff ff ff    	lea    -0x92(%ebp),%eax
  8000bb:	bb 12 36 80 00       	mov    $0x803612,%ebx
  8000c0:	ba 15 00 00 00       	mov    $0x15,%edx
  8000c5:	89 c7                	mov    %eax,%edi
  8000c7:	89 de                	mov    %ebx,%esi
  8000c9:	89 d1                	mov    %edx,%ecx
  8000cb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  8000cd:	8d 85 5d ff ff ff    	lea    -0xa3(%ebp),%eax
  8000d3:	bb 27 36 80 00       	mov    $0x803627,%ebx
  8000d8:	ba 11 00 00 00       	mov    $0x11,%edx
  8000dd:	89 c7                	mov    %eax,%edi
  8000df:	89 de                	mov    %ebx,%esi
  8000e1:	89 d1                	mov    %edx,%ecx
  8000e3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  8000e5:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  8000eb:	bb 38 36 80 00       	mov    $0x803638,%ebx
  8000f0:	ba 11 00 00 00       	mov    $0x11,%edx
  8000f5:	89 c7                	mov    %eax,%edi
  8000f7:	89 de                	mov    %ebx,%esi
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  8000fd:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  800103:	bb 49 36 80 00       	mov    $0x803649,%ebx
  800108:	ba 11 00 00 00       	mov    $0x11,%edx
  80010d:	89 c7                	mov    %eax,%edi
  80010f:	89 de                	mov    %ebx,%esi
  800111:	89 d1                	mov    %edx,%ecx
  800113:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  800115:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  80011b:	bb 5a 36 80 00       	mov    $0x80365a,%ebx
  800120:	ba 09 00 00 00       	mov    $0x9,%edx
  800125:	89 c7                	mov    %eax,%edi
  800127:	89 de                	mov    %ebx,%esi
  800129:	89 d1                	mov    %edx,%ecx
  80012b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  80012d:	8d 85 28 ff ff ff    	lea    -0xd8(%ebp),%eax
  800133:	bb 63 36 80 00       	mov    $0x803663,%ebx
  800138:	ba 0a 00 00 00       	mov    $0xa,%edx
  80013d:	89 c7                	mov    %eax,%edi
  80013f:	89 de                	mov    %ebx,%esi
  800141:	89 d1                	mov    %edx,%ecx
  800143:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  800145:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  80014b:	bb 6d 36 80 00       	mov    $0x80366d,%ebx
  800150:	ba 0b 00 00 00       	mov    $0xb,%edx
  800155:	89 c7                	mov    %eax,%edi
  800157:	89 de                	mov    %ebx,%esi
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  80015d:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  800163:	bb 78 36 80 00       	mov    $0x803678,%ebx
  800168:	ba 03 00 00 00       	mov    $0x3,%edx
  80016d:	89 c7                	mov    %eax,%edi
  80016f:	89 de                	mov    %ebx,%esi
  800171:	89 d1                	mov    %edx,%ecx
  800173:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  800175:	8d 85 07 ff ff ff    	lea    -0xf9(%ebp),%eax
  80017b:	bb 84 36 80 00       	mov    $0x803684,%ebx
  800180:	ba 0a 00 00 00       	mov    $0xa,%edx
  800185:	89 c7                	mov    %eax,%edi
  800187:	89 de                	mov    %ebx,%esi
  800189:	89 d1                	mov    %edx,%ecx
  80018b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  80018d:	8d 85 fd fe ff ff    	lea    -0x103(%ebp),%eax
  800193:	bb 8e 36 80 00       	mov    $0x80368e,%ebx
  800198:	ba 0a 00 00 00       	mov    $0xa,%edx
  80019d:	89 c7                	mov    %eax,%edi
  80019f:	89 de                	mov    %ebx,%esi
  8001a1:	89 d1                	mov    %edx,%ecx
  8001a3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001a5:	c7 85 f7 fe ff ff 63 	movl   $0x72656c63,-0x109(%ebp)
  8001ac:	6c 65 72 
  8001af:	66 c7 85 fb fe ff ff 	movw   $0x6b,-0x105(%ebp)
  8001b6:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001b8:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8001be:	bb 98 36 80 00       	mov    $0x803698,%ebx
  8001c3:	ba 0e 00 00 00       	mov    $0xe,%edx
  8001c8:	89 c7                	mov    %eax,%edi
  8001ca:	89 de                	mov    %ebx,%esi
  8001cc:	89 d1                	mov    %edx,%ecx
  8001ce:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  8001d0:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8001d6:	bb a6 36 80 00       	mov    $0x8036a6,%ebx
  8001db:	ba 0f 00 00 00       	mov    $0xf,%edx
  8001e0:	89 c7                	mov    %eax,%edi
  8001e2:	89 de                	mov    %ebx,%esi
  8001e4:	89 d1                	mov    %edx,%ecx
  8001e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  8001e8:	8d 85 d3 fe ff ff    	lea    -0x12d(%ebp),%eax
  8001ee:	bb b5 36 80 00       	mov    $0x8036b5,%ebx
  8001f3:	ba 07 00 00 00       	mov    $0x7,%edx
  8001f8:	89 c7                	mov    %eax,%edi
  8001fa:	89 de                	mov    %ebx,%esi
  8001fc:	89 d1                	mov    %edx,%ecx
  8001fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800200:	8d 85 cc fe ff ff    	lea    -0x134(%ebp),%eax
  800206:	bb bc 36 80 00       	mov    $0x8036bc,%ebx
  80020b:	ba 07 00 00 00       	mov    $0x7,%edx
  800210:	89 c7                	mov    %eax,%edi
  800212:	89 de                	mov    %ebx,%esi
  800214:	89 d1                	mov    %edx,%ecx
  800216:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	// Get the shared variables from the main program ***********************************

	struct Customer * customers = sget(parentenvID, _customers);
  800218:	83 ec 08             	sub    $0x8,%esp
  80021b:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  80021e:	50                   	push   %eax
  80021f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800222:	e8 ea 15 00 00       	call   801811 <sget>
  800227:	83 c4 10             	add    $0x10,%esp
  80022a:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int* custCounter = sget(parentenvID, _custCounter);
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	8d 45 b6             	lea    -0x4a(%ebp),%eax
  800233:	50                   	push   %eax
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	e8 d5 15 00 00       	call   801811 <sget>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int* cust_ready_queue = sget(parentenvID, _cust_ready_queue);
  800242:	83 ec 08             	sub    $0x8,%esp
  800245:	8d 85 3b ff ff ff    	lea    -0xc5(%ebp),%eax
  80024b:	50                   	push   %eax
  80024c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024f:	e8 bd 15 00 00       	call   801811 <sget>
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)

	int* queue_in = sget(parentenvID, _queue_in);
  80025a:	83 ec 08             	sub    $0x8,%esp
  80025d:	8d 85 32 ff ff ff    	lea    -0xce(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	ff 75 e4             	pushl  -0x1c(%ebp)
  800267:	e8 a5 15 00 00       	call   801811 <sget>
  80026c:	83 c4 10             	add    $0x10,%esp
  80026f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	// *********************************************************************************

	int custId, flightType;
	sys_waitSemaphore(parentenvID, _custCounterCS);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  80027b:	50                   	push   %eax
  80027c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80027f:	e8 75 19 00 00       	call   801bf9 <sys_waitSemaphore>
  800284:	83 c4 10             	add    $0x10,%esp
	{
		custId = *custCounter;
  800287:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80028a:	8b 00                	mov    (%eax),%eax
  80028c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		//cprintf("custCounter= %d\n", *custCounter);
		*custCounter = *custCounter +1;
  80028f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800292:	8b 00                	mov    (%eax),%eax
  800294:	8d 50 01             	lea    0x1(%eax),%edx
  800297:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80029a:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custCounterCS);
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	8d 85 e9 fe ff ff    	lea    -0x117(%ebp),%eax
  8002a5:	50                   	push   %eax
  8002a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a9:	e8 69 19 00 00       	call   801c17 <sys_signalSemaphore>
  8002ae:	83 c4 10             	add    $0x10,%esp

	//wait on one of the clerks
	sys_waitSemaphore(parentenvID, _clerk);
  8002b1:	83 ec 08             	sub    $0x8,%esp
  8002b4:	8d 85 f7 fe ff ff    	lea    -0x109(%ebp),%eax
  8002ba:	50                   	push   %eax
  8002bb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002be:	e8 36 19 00 00       	call   801bf9 <sys_waitSemaphore>
  8002c3:	83 c4 10             	add    $0x10,%esp

	//enqueue the request
	flightType = customers[custId].flightType;
  8002c6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002d3:	01 d0                	add    %edx,%eax
  8002d5:	8b 00                	mov    (%eax),%eax
  8002d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
	sys_waitSemaphore(parentenvID, _custQueueCS);
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  8002e3:	50                   	push   %eax
  8002e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e7:	e8 0d 19 00 00       	call   801bf9 <sys_waitSemaphore>
  8002ec:	83 c4 10             	add    $0x10,%esp
	{
		cust_ready_queue[*queue_in] = custId;
  8002ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002f2:	8b 00                	mov    (%eax),%eax
  8002f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002fe:	01 c2                	add    %eax,%edx
  800300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800303:	89 02                	mov    %eax,(%edx)
		*queue_in = *queue_in +1;
  800305:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800308:	8b 00                	mov    (%eax),%eax
  80030a:	8d 50 01             	lea    0x1(%eax),%edx
  80030d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800310:	89 10                	mov    %edx,(%eax)
	}
	sys_signalSemaphore(parentenvID, _custQueueCS);
  800312:	83 ec 08             	sub    $0x8,%esp
  800315:	8d 85 11 ff ff ff    	lea    -0xef(%ebp),%eax
  80031b:	50                   	push   %eax
  80031c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80031f:	e8 f3 18 00 00       	call   801c17 <sys_signalSemaphore>
  800324:	83 c4 10             	add    $0x10,%esp

	//signal ready
	sys_signalSemaphore(parentenvID, _cust_ready);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	8d 85 1d ff ff ff    	lea    -0xe3(%ebp),%eax
  800330:	50                   	push   %eax
  800331:	ff 75 e4             	pushl  -0x1c(%ebp)
  800334:	e8 de 18 00 00       	call   801c17 <sys_signalSemaphore>
  800339:	83 c4 10             	add    $0x10,%esp

	//wait on finished
	char prefix[30]="cust_finished";
  80033c:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800342:	bb c3 36 80 00       	mov    $0x8036c3,%ebx
  800347:	ba 0e 00 00 00       	mov    $0xe,%edx
  80034c:	89 c7                	mov    %eax,%edi
  80034e:	89 de                	mov    %ebx,%esi
  800350:	89 d1                	mov    %edx,%ecx
  800352:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800354:	8d 95 bc fe ff ff    	lea    -0x144(%ebp),%edx
  80035a:	b9 04 00 00 00       	mov    $0x4,%ecx
  80035f:	b8 00 00 00 00       	mov    $0x0,%eax
  800364:	89 d7                	mov    %edx,%edi
  800366:	f3 ab                	rep stos %eax,%es:(%edi)
	char id[5]; char sname[50];
	ltostr(custId, id);
  800368:	83 ec 08             	sub    $0x8,%esp
  80036b:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  800371:	50                   	push   %eax
  800372:	ff 75 d0             	pushl  -0x30(%ebp)
  800375:	e8 d0 0d 00 00       	call   80114a <ltostr>
  80037a:	83 c4 10             	add    $0x10,%esp
	strcconcat(prefix, id, sname);
  80037d:	83 ec 04             	sub    $0x4,%esp
  800380:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  800386:	50                   	push   %eax
  800387:	8d 85 a9 fe ff ff    	lea    -0x157(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	8d 85 ae fe ff ff    	lea    -0x152(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 a8 0e 00 00       	call   801242 <strcconcat>
  80039a:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(parentenvID, sname);
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	8d 85 77 fe ff ff    	lea    -0x189(%ebp),%eax
  8003a6:	50                   	push   %eax
  8003a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003aa:	e8 4a 18 00 00       	call   801bf9 <sys_waitSemaphore>
  8003af:	83 c4 10             	add    $0x10,%esp

	//print the customer status
	if(customers[custId].booked == 1)
  8003b2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8003bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bf:	01 d0                	add    %edx,%eax
  8003c1:	8b 40 04             	mov    0x4(%eax),%eax
  8003c4:	83 f8 01             	cmp    $0x1,%eax
  8003c7:	75 18                	jne    8003e1 <_main+0x3a9>
	{
		cprintf("cust %d: finished (BOOKED flight %d) \n", custId, flightType);
  8003c9:	83 ec 04             	sub    $0x4,%esp
  8003cc:	ff 75 cc             	pushl  -0x34(%ebp)
  8003cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d2:	68 80 35 80 00       	push   $0x803580
  8003d7:	e8 46 02 00 00       	call   800622 <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	eb 13                	jmp    8003f4 <_main+0x3bc>
	}
	else
	{
		cprintf("cust %d: finished (NOT BOOKED) \n", custId);
  8003e1:	83 ec 08             	sub    $0x8,%esp
  8003e4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003e7:	68 a8 35 80 00       	push   $0x8035a8
  8003ec:	e8 31 02 00 00       	call   800622 <cprintf>
  8003f1:	83 c4 10             	add    $0x10,%esp
	}

	//customer is terminated
	sys_signalSemaphore(parentenvID, _custTerminated);
  8003f4:	83 ec 08             	sub    $0x8,%esp
  8003f7:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  8003fd:	50                   	push   %eax
  8003fe:	ff 75 e4             	pushl  -0x1c(%ebp)
  800401:	e8 11 18 00 00       	call   801c17 <sys_signalSemaphore>
  800406:	83 c4 10             	add    $0x10,%esp

	return;
  800409:	90                   	nop
}
  80040a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80040d:	5b                   	pop    %ebx
  80040e:	5e                   	pop    %esi
  80040f:	5f                   	pop    %edi
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800418:	e8 22 19 00 00       	call   801d3f <sys_getenvindex>
  80041d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800423:	89 d0                	mov    %edx,%eax
  800425:	c1 e0 03             	shl    $0x3,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	01 c0                	add    %eax,%eax
  80042c:	01 d0                	add    %edx,%eax
  80042e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800435:	01 d0                	add    %edx,%eax
  800437:	c1 e0 04             	shl    $0x4,%eax
  80043a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800444:	a1 20 40 80 00       	mov    0x804020,%eax
  800449:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044f:	84 c0                	test   %al,%al
  800451:	74 0f                	je     800462 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	05 5c 05 00 00       	add    $0x55c,%eax
  80045d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800466:	7e 0a                	jle    800472 <libmain+0x60>
		binaryname = argv[0];
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	ff 75 08             	pushl  0x8(%ebp)
  80047b:	e8 b8 fb ff ff       	call   800038 <_main>
  800480:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800483:	e8 c4 16 00 00       	call   801b4c <sys_disable_interrupt>
	cprintf("**************************************\n");
  800488:	83 ec 0c             	sub    $0xc,%esp
  80048b:	68 fc 36 80 00       	push   $0x8036fc
  800490:	e8 8d 01 00 00       	call   800622 <cprintf>
  800495:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8004a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004ae:	83 ec 04             	sub    $0x4,%esp
  8004b1:	52                   	push   %edx
  8004b2:	50                   	push   %eax
  8004b3:	68 24 37 80 00       	push   $0x803724
  8004b8:	e8 65 01 00 00       	call   800622 <cprintf>
  8004bd:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004cb:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004db:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	50                   	push   %eax
  8004e4:	68 4c 37 80 00       	push   $0x80374c
  8004e9:	e8 34 01 00 00       	call   800622 <cprintf>
  8004ee:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004fc:	83 ec 08             	sub    $0x8,%esp
  8004ff:	50                   	push   %eax
  800500:	68 a4 37 80 00       	push   $0x8037a4
  800505:	e8 18 01 00 00       	call   800622 <cprintf>
  80050a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80050d:	83 ec 0c             	sub    $0xc,%esp
  800510:	68 fc 36 80 00       	push   $0x8036fc
  800515:	e8 08 01 00 00       	call   800622 <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80051d:	e8 44 16 00 00       	call   801b66 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800522:	e8 19 00 00 00       	call   800540 <exit>
}
  800527:	90                   	nop
  800528:	c9                   	leave  
  800529:	c3                   	ret    

0080052a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80052a:	55                   	push   %ebp
  80052b:	89 e5                	mov    %esp,%ebp
  80052d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800530:	83 ec 0c             	sub    $0xc,%esp
  800533:	6a 00                	push   $0x0
  800535:	e8 d1 17 00 00       	call   801d0b <sys_destroy_env>
  80053a:	83 c4 10             	add    $0x10,%esp
}
  80053d:	90                   	nop
  80053e:	c9                   	leave  
  80053f:	c3                   	ret    

00800540 <exit>:

void
exit(void)
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800546:	e8 26 18 00 00       	call   801d71 <sys_exit_env>
}
  80054b:	90                   	nop
  80054c:	c9                   	leave  
  80054d:	c3                   	ret    

0080054e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054e:	55                   	push   %ebp
  80054f:	89 e5                	mov    %esp,%ebp
  800551:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	8b 00                	mov    (%eax),%eax
  800559:	8d 48 01             	lea    0x1(%eax),%ecx
  80055c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055f:	89 0a                	mov    %ecx,(%edx)
  800561:	8b 55 08             	mov    0x8(%ebp),%edx
  800564:	88 d1                	mov    %dl,%cl
  800566:	8b 55 0c             	mov    0xc(%ebp),%edx
  800569:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	3d ff 00 00 00       	cmp    $0xff,%eax
  800577:	75 2c                	jne    8005a5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800579:	a0 24 40 80 00       	mov    0x804024,%al
  80057e:	0f b6 c0             	movzbl %al,%eax
  800581:	8b 55 0c             	mov    0xc(%ebp),%edx
  800584:	8b 12                	mov    (%edx),%edx
  800586:	89 d1                	mov    %edx,%ecx
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	83 c2 08             	add    $0x8,%edx
  80058e:	83 ec 04             	sub    $0x4,%esp
  800591:	50                   	push   %eax
  800592:	51                   	push   %ecx
  800593:	52                   	push   %edx
  800594:	e8 05 14 00 00       	call   80199e <sys_cputs>
  800599:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	8b 40 04             	mov    0x4(%eax),%eax
  8005ab:	8d 50 01             	lea    0x1(%eax),%edx
  8005ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b4:	90                   	nop
  8005b5:	c9                   	leave  
  8005b6:	c3                   	ret    

008005b7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b7:	55                   	push   %ebp
  8005b8:	89 e5                	mov    %esp,%ebp
  8005ba:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005c0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c7:	00 00 00 
	b.cnt = 0;
  8005ca:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005d1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d4:	ff 75 0c             	pushl  0xc(%ebp)
  8005d7:	ff 75 08             	pushl  0x8(%ebp)
  8005da:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005e0:	50                   	push   %eax
  8005e1:	68 4e 05 80 00       	push   $0x80054e
  8005e6:	e8 11 02 00 00       	call   8007fc <vprintfmt>
  8005eb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ee:	a0 24 40 80 00       	mov    0x804024,%al
  8005f3:	0f b6 c0             	movzbl %al,%eax
  8005f6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005fc:	83 ec 04             	sub    $0x4,%esp
  8005ff:	50                   	push   %eax
  800600:	52                   	push   %edx
  800601:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800607:	83 c0 08             	add    $0x8,%eax
  80060a:	50                   	push   %eax
  80060b:	e8 8e 13 00 00       	call   80199e <sys_cputs>
  800610:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800613:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80061a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800620:	c9                   	leave  
  800621:	c3                   	ret    

00800622 <cprintf>:

int cprintf(const char *fmt, ...) {
  800622:	55                   	push   %ebp
  800623:	89 e5                	mov    %esp,%ebp
  800625:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800628:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800632:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800635:	8b 45 08             	mov    0x8(%ebp),%eax
  800638:	83 ec 08             	sub    $0x8,%esp
  80063b:	ff 75 f4             	pushl  -0xc(%ebp)
  80063e:	50                   	push   %eax
  80063f:	e8 73 ff ff ff       	call   8005b7 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
  800647:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80064a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80064d:	c9                   	leave  
  80064e:	c3                   	ret    

0080064f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064f:	55                   	push   %ebp
  800650:	89 e5                	mov    %esp,%ebp
  800652:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800655:	e8 f2 14 00 00       	call   801b4c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80065a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80065d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	83 ec 08             	sub    $0x8,%esp
  800666:	ff 75 f4             	pushl  -0xc(%ebp)
  800669:	50                   	push   %eax
  80066a:	e8 48 ff ff ff       	call   8005b7 <vcprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
  800672:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800675:	e8 ec 14 00 00       	call   801b66 <sys_enable_interrupt>
	return cnt;
  80067a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067d:	c9                   	leave  
  80067e:	c3                   	ret    

0080067f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067f:	55                   	push   %ebp
  800680:	89 e5                	mov    %esp,%ebp
  800682:	53                   	push   %ebx
  800683:	83 ec 14             	sub    $0x14,%esp
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800692:	8b 45 18             	mov    0x18(%ebp),%eax
  800695:	ba 00 00 00 00       	mov    $0x0,%edx
  80069a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069d:	77 55                	ja     8006f4 <printnum+0x75>
  80069f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006a2:	72 05                	jb     8006a9 <printnum+0x2a>
  8006a4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a7:	77 4b                	ja     8006f4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ac:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006af:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b7:	52                   	push   %edx
  8006b8:	50                   	push   %eax
  8006b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006bc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bf:	e8 44 2c 00 00       	call   803308 <__udivdi3>
  8006c4:	83 c4 10             	add    $0x10,%esp
  8006c7:	83 ec 04             	sub    $0x4,%esp
  8006ca:	ff 75 20             	pushl  0x20(%ebp)
  8006cd:	53                   	push   %ebx
  8006ce:	ff 75 18             	pushl  0x18(%ebp)
  8006d1:	52                   	push   %edx
  8006d2:	50                   	push   %eax
  8006d3:	ff 75 0c             	pushl  0xc(%ebp)
  8006d6:	ff 75 08             	pushl  0x8(%ebp)
  8006d9:	e8 a1 ff ff ff       	call   80067f <printnum>
  8006de:	83 c4 20             	add    $0x20,%esp
  8006e1:	eb 1a                	jmp    8006fd <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006e3:	83 ec 08             	sub    $0x8,%esp
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 20             	pushl  0x20(%ebp)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	ff d0                	call   *%eax
  8006f1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f4:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006fb:	7f e6                	jg     8006e3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006fd:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800700:	bb 00 00 00 00       	mov    $0x0,%ebx
  800705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800708:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80070b:	53                   	push   %ebx
  80070c:	51                   	push   %ecx
  80070d:	52                   	push   %edx
  80070e:	50                   	push   %eax
  80070f:	e8 04 2d 00 00       	call   803418 <__umoddi3>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	05 d4 39 80 00       	add    $0x8039d4,%eax
  80071c:	8a 00                	mov    (%eax),%al
  80071e:	0f be c0             	movsbl %al,%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
}
  800730:	90                   	nop
  800731:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800734:	c9                   	leave  
  800735:	c3                   	ret    

00800736 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800736:	55                   	push   %ebp
  800737:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800739:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80073d:	7e 1c                	jle    80075b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	8b 00                	mov    (%eax),%eax
  800744:	8d 50 08             	lea    0x8(%eax),%edx
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	89 10                	mov    %edx,(%eax)
  80074c:	8b 45 08             	mov    0x8(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	83 e8 08             	sub    $0x8,%eax
  800754:	8b 50 04             	mov    0x4(%eax),%edx
  800757:	8b 00                	mov    (%eax),%eax
  800759:	eb 40                	jmp    80079b <getuint+0x65>
	else if (lflag)
  80075b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075f:	74 1e                	je     80077f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 04             	lea    0x4(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 00                	mov    (%eax),%eax
  800778:	ba 00 00 00 00       	mov    $0x0,%edx
  80077d:	eb 1c                	jmp    80079b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 08             	mov    0x8(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	8d 50 04             	lea    0x4(%eax),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	89 10                	mov    %edx,(%eax)
  80078c:	8b 45 08             	mov    0x8(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	83 e8 04             	sub    $0x4,%eax
  800794:	8b 00                	mov    (%eax),%eax
  800796:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007a0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a4:	7e 1c                	jle    8007c2 <getint+0x25>
		return va_arg(*ap, long long);
  8007a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	8d 50 08             	lea    0x8(%eax),%edx
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	89 10                	mov    %edx,(%eax)
  8007b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	83 e8 08             	sub    $0x8,%eax
  8007bb:	8b 50 04             	mov    0x4(%eax),%edx
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	eb 38                	jmp    8007fa <getint+0x5d>
	else if (lflag)
  8007c2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c6:	74 1a                	je     8007e2 <getint+0x45>
		return va_arg(*ap, long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 04             	lea    0x4(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 04             	sub    $0x4,%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	99                   	cltd   
  8007e0:	eb 18                	jmp    8007fa <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	89 10                	mov    %edx,(%eax)
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	83 e8 04             	sub    $0x4,%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	99                   	cltd   
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	56                   	push   %esi
  800800:	53                   	push   %ebx
  800801:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800804:	eb 17                	jmp    80081d <vprintfmt+0x21>
			if (ch == '\0')
  800806:	85 db                	test   %ebx,%ebx
  800808:	0f 84 af 03 00 00    	je     800bbd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	53                   	push   %ebx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	ff d0                	call   *%eax
  80081a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80081d:	8b 45 10             	mov    0x10(%ebp),%eax
  800820:	8d 50 01             	lea    0x1(%eax),%edx
  800823:	89 55 10             	mov    %edx,0x10(%ebp)
  800826:	8a 00                	mov    (%eax),%al
  800828:	0f b6 d8             	movzbl %al,%ebx
  80082b:	83 fb 25             	cmp    $0x25,%ebx
  80082e:	75 d6                	jne    800806 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800830:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800834:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80083b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800842:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800849:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800850:	8b 45 10             	mov    0x10(%ebp),%eax
  800853:	8d 50 01             	lea    0x1(%eax),%edx
  800856:	89 55 10             	mov    %edx,0x10(%ebp)
  800859:	8a 00                	mov    (%eax),%al
  80085b:	0f b6 d8             	movzbl %al,%ebx
  80085e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800861:	83 f8 55             	cmp    $0x55,%eax
  800864:	0f 87 2b 03 00 00    	ja     800b95 <vprintfmt+0x399>
  80086a:	8b 04 85 f8 39 80 00 	mov    0x8039f8(,%eax,4),%eax
  800871:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800873:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800877:	eb d7                	jmp    800850 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800879:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80087d:	eb d1                	jmp    800850 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800886:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800889:	89 d0                	mov    %edx,%eax
  80088b:	c1 e0 02             	shl    $0x2,%eax
  80088e:	01 d0                	add    %edx,%eax
  800890:	01 c0                	add    %eax,%eax
  800892:	01 d8                	add    %ebx,%eax
  800894:	83 e8 30             	sub    $0x30,%eax
  800897:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80089a:	8b 45 10             	mov    0x10(%ebp),%eax
  80089d:	8a 00                	mov    (%eax),%al
  80089f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008a2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a5:	7e 3e                	jle    8008e5 <vprintfmt+0xe9>
  8008a7:	83 fb 39             	cmp    $0x39,%ebx
  8008aa:	7f 39                	jg     8008e5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ac:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008af:	eb d5                	jmp    800886 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c5:	eb 1f                	jmp    8008e6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008cb:	79 83                	jns    800850 <vprintfmt+0x54>
				width = 0;
  8008cd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d4:	e9 77 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008e0:	e9 6b ff ff ff       	jmp    800850 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ea:	0f 89 60 ff ff ff    	jns    800850 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008fd:	e9 4e ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800902:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800905:	e9 46 ff ff ff       	jmp    800850 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80090a:	8b 45 14             	mov    0x14(%ebp),%eax
  80090d:	83 c0 04             	add    $0x4,%eax
  800910:	89 45 14             	mov    %eax,0x14(%ebp)
  800913:	8b 45 14             	mov    0x14(%ebp),%eax
  800916:	83 e8 04             	sub    $0x4,%eax
  800919:	8b 00                	mov    (%eax),%eax
  80091b:	83 ec 08             	sub    $0x8,%esp
  80091e:	ff 75 0c             	pushl  0xc(%ebp)
  800921:	50                   	push   %eax
  800922:	8b 45 08             	mov    0x8(%ebp),%eax
  800925:	ff d0                	call   *%eax
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 89 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800940:	85 db                	test   %ebx,%ebx
  800942:	79 02                	jns    800946 <vprintfmt+0x14a>
				err = -err;
  800944:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800946:	83 fb 64             	cmp    $0x64,%ebx
  800949:	7f 0b                	jg     800956 <vprintfmt+0x15a>
  80094b:	8b 34 9d 40 38 80 00 	mov    0x803840(,%ebx,4),%esi
  800952:	85 f6                	test   %esi,%esi
  800954:	75 19                	jne    80096f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800956:	53                   	push   %ebx
  800957:	68 e5 39 80 00       	push   $0x8039e5
  80095c:	ff 75 0c             	pushl  0xc(%ebp)
  80095f:	ff 75 08             	pushl  0x8(%ebp)
  800962:	e8 5e 02 00 00       	call   800bc5 <printfmt>
  800967:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80096a:	e9 49 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096f:	56                   	push   %esi
  800970:	68 ee 39 80 00       	push   $0x8039ee
  800975:	ff 75 0c             	pushl  0xc(%ebp)
  800978:	ff 75 08             	pushl  0x8(%ebp)
  80097b:	e8 45 02 00 00       	call   800bc5 <printfmt>
  800980:	83 c4 10             	add    $0x10,%esp
			break;
  800983:	e9 30 02 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	83 c0 04             	add    $0x4,%eax
  80098e:	89 45 14             	mov    %eax,0x14(%ebp)
  800991:	8b 45 14             	mov    0x14(%ebp),%eax
  800994:	83 e8 04             	sub    $0x4,%eax
  800997:	8b 30                	mov    (%eax),%esi
  800999:	85 f6                	test   %esi,%esi
  80099b:	75 05                	jne    8009a2 <vprintfmt+0x1a6>
				p = "(null)";
  80099d:	be f1 39 80 00       	mov    $0x8039f1,%esi
			if (width > 0 && padc != '-')
  8009a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a6:	7e 6d                	jle    800a15 <vprintfmt+0x219>
  8009a8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ac:	74 67                	je     800a15 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009b1:	83 ec 08             	sub    $0x8,%esp
  8009b4:	50                   	push   %eax
  8009b5:	56                   	push   %esi
  8009b6:	e8 0c 03 00 00       	call   800cc7 <strnlen>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009c1:	eb 16                	jmp    8009d9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009c3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c7:	83 ec 08             	sub    $0x8,%esp
  8009ca:	ff 75 0c             	pushl  0xc(%ebp)
  8009cd:	50                   	push   %eax
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	ff d0                	call   *%eax
  8009d3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009dd:	7f e4                	jg     8009c3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009df:	eb 34                	jmp    800a15 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009e1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e5:	74 1c                	je     800a03 <vprintfmt+0x207>
  8009e7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009ea:	7e 05                	jle    8009f1 <vprintfmt+0x1f5>
  8009ec:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ef:	7e 12                	jle    800a03 <vprintfmt+0x207>
					putch('?', putdat);
  8009f1:	83 ec 08             	sub    $0x8,%esp
  8009f4:	ff 75 0c             	pushl  0xc(%ebp)
  8009f7:	6a 3f                	push   $0x3f
  8009f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fc:	ff d0                	call   *%eax
  8009fe:	83 c4 10             	add    $0x10,%esp
  800a01:	eb 0f                	jmp    800a12 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 0c             	pushl  0xc(%ebp)
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	ff d0                	call   *%eax
  800a0f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a12:	ff 4d e4             	decl   -0x1c(%ebp)
  800a15:	89 f0                	mov    %esi,%eax
  800a17:	8d 70 01             	lea    0x1(%eax),%esi
  800a1a:	8a 00                	mov    (%eax),%al
  800a1c:	0f be d8             	movsbl %al,%ebx
  800a1f:	85 db                	test   %ebx,%ebx
  800a21:	74 24                	je     800a47 <vprintfmt+0x24b>
  800a23:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a27:	78 b8                	js     8009e1 <vprintfmt+0x1e5>
  800a29:	ff 4d e0             	decl   -0x20(%ebp)
  800a2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a30:	79 af                	jns    8009e1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a32:	eb 13                	jmp    800a47 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a34:	83 ec 08             	sub    $0x8,%esp
  800a37:	ff 75 0c             	pushl  0xc(%ebp)
  800a3a:	6a 20                	push   $0x20
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	ff d0                	call   *%eax
  800a41:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a44:	ff 4d e4             	decl   -0x1c(%ebp)
  800a47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a4b:	7f e7                	jg     800a34 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a4d:	e9 66 01 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 e8             	pushl  -0x18(%ebp)
  800a58:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5b:	50                   	push   %eax
  800a5c:	e8 3c fd ff ff       	call   80079d <getint>
  800a61:	83 c4 10             	add    $0x10,%esp
  800a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a67:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a70:	85 d2                	test   %edx,%edx
  800a72:	79 23                	jns    800a97 <vprintfmt+0x29b>
				putch('-', putdat);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	6a 2d                	push   $0x2d
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	ff d0                	call   *%eax
  800a81:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a8a:	f7 d8                	neg    %eax
  800a8c:	83 d2 00             	adc    $0x0,%edx
  800a8f:	f7 da                	neg    %edx
  800a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 84 fc ff ff       	call   800736 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800abb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac2:	e9 98 00 00 00       	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac7:	83 ec 08             	sub    $0x8,%esp
  800aca:	ff 75 0c             	pushl  0xc(%ebp)
  800acd:	6a 58                	push   $0x58
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	ff d0                	call   *%eax
  800ad4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad7:	83 ec 08             	sub    $0x8,%esp
  800ada:	ff 75 0c             	pushl  0xc(%ebp)
  800add:	6a 58                	push   $0x58
  800adf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae2:	ff d0                	call   *%eax
  800ae4:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	6a 58                	push   $0x58
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	ff d0                	call   *%eax
  800af4:	83 c4 10             	add    $0x10,%esp
			break;
  800af7:	e9 bc 00 00 00       	jmp    800bb8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 0c             	pushl  0xc(%ebp)
  800b02:	6a 30                	push   $0x30
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	ff d0                	call   *%eax
  800b09:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 78                	push   $0x78
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1f:	83 c0 04             	add    $0x4,%eax
  800b22:	89 45 14             	mov    %eax,0x14(%ebp)
  800b25:	8b 45 14             	mov    0x14(%ebp),%eax
  800b28:	83 e8 04             	sub    $0x4,%eax
  800b2b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b37:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3e:	eb 1f                	jmp    800b5f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b40:	83 ec 08             	sub    $0x8,%esp
  800b43:	ff 75 e8             	pushl  -0x18(%ebp)
  800b46:	8d 45 14             	lea    0x14(%ebp),%eax
  800b49:	50                   	push   %eax
  800b4a:	e8 e7 fb ff ff       	call   800736 <getuint>
  800b4f:	83 c4 10             	add    $0x10,%esp
  800b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b55:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b66:	83 ec 04             	sub    $0x4,%esp
  800b69:	52                   	push   %edx
  800b6a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b71:	ff 75 f0             	pushl  -0x10(%ebp)
  800b74:	ff 75 0c             	pushl  0xc(%ebp)
  800b77:	ff 75 08             	pushl  0x8(%ebp)
  800b7a:	e8 00 fb ff ff       	call   80067f <printnum>
  800b7f:	83 c4 20             	add    $0x20,%esp
			break;
  800b82:	eb 34                	jmp    800bb8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b84:	83 ec 08             	sub    $0x8,%esp
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	53                   	push   %ebx
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	ff d0                	call   *%eax
  800b90:	83 c4 10             	add    $0x10,%esp
			break;
  800b93:	eb 23                	jmp    800bb8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b95:	83 ec 08             	sub    $0x8,%esp
  800b98:	ff 75 0c             	pushl  0xc(%ebp)
  800b9b:	6a 25                	push   $0x25
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	ff d0                	call   *%eax
  800ba2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba5:	ff 4d 10             	decl   0x10(%ebp)
  800ba8:	eb 03                	jmp    800bad <vprintfmt+0x3b1>
  800baa:	ff 4d 10             	decl   0x10(%ebp)
  800bad:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb0:	48                   	dec    %eax
  800bb1:	8a 00                	mov    (%eax),%al
  800bb3:	3c 25                	cmp    $0x25,%al
  800bb5:	75 f3                	jne    800baa <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb7:	90                   	nop
		}
	}
  800bb8:	e9 47 fc ff ff       	jmp    800804 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bbd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bcb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bce:	83 c0 04             	add    $0x4,%eax
  800bd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bda:	50                   	push   %eax
  800bdb:	ff 75 0c             	pushl  0xc(%ebp)
  800bde:	ff 75 08             	pushl  0x8(%ebp)
  800be1:	e8 16 fc ff ff       	call   8007fc <vprintfmt>
  800be6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be9:	90                   	nop
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf2:	8b 40 08             	mov    0x8(%eax),%eax
  800bf5:	8d 50 01             	lea    0x1(%eax),%edx
  800bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfb:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c01:	8b 10                	mov    (%eax),%edx
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	8b 40 04             	mov    0x4(%eax),%eax
  800c09:	39 c2                	cmp    %eax,%edx
  800c0b:	73 12                	jae    800c1f <sprintputch+0x33>
		*b->buf++ = ch;
  800c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	8d 48 01             	lea    0x1(%eax),%ecx
  800c15:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c18:	89 0a                	mov    %ecx,(%edx)
  800c1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1d:	88 10                	mov    %dl,(%eax)
}
  800c1f:	90                   	nop
  800c20:	5d                   	pop    %ebp
  800c21:	c3                   	ret    

00800c22 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c31:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	01 d0                	add    %edx,%eax
  800c39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c3c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c47:	74 06                	je     800c4f <vsnprintf+0x2d>
  800c49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c4d:	7f 07                	jg     800c56 <vsnprintf+0x34>
		return -E_INVAL;
  800c4f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c54:	eb 20                	jmp    800c76 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c56:	ff 75 14             	pushl  0x14(%ebp)
  800c59:	ff 75 10             	pushl  0x10(%ebp)
  800c5c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5f:	50                   	push   %eax
  800c60:	68 ec 0b 80 00       	push   $0x800bec
  800c65:	e8 92 fb ff ff       	call   8007fc <vprintfmt>
  800c6a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c70:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c81:	83 c0 04             	add    $0x4,%eax
  800c84:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c87:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c8d:	50                   	push   %eax
  800c8e:	ff 75 0c             	pushl  0xc(%ebp)
  800c91:	ff 75 08             	pushl  0x8(%ebp)
  800c94:	e8 89 ff ff ff       	call   800c22 <vsnprintf>
  800c99:	83 c4 10             	add    $0x10,%esp
  800c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ca2:	c9                   	leave  
  800ca3:	c3                   	ret    

00800ca4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800caa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cb1:	eb 06                	jmp    800cb9 <strlen+0x15>
		n++;
  800cb3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 f1                	jne    800cb3 <strlen+0xf>
		n++;
	return n;
  800cc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc5:	c9                   	leave  
  800cc6:	c3                   	ret    

00800cc7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc7:	55                   	push   %ebp
  800cc8:	89 e5                	mov    %esp,%ebp
  800cca:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ccd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd4:	eb 09                	jmp    800cdf <strnlen+0x18>
		n++;
  800cd6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd9:	ff 45 08             	incl   0x8(%ebp)
  800cdc:	ff 4d 0c             	decl   0xc(%ebp)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 09                	je     800cee <strnlen+0x27>
  800ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce8:	8a 00                	mov    (%eax),%al
  800cea:	84 c0                	test   %al,%al
  800cec:	75 e8                	jne    800cd6 <strnlen+0xf>
		n++;
	return n;
  800cee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cff:	90                   	nop
  800d00:	8b 45 08             	mov    0x8(%ebp),%eax
  800d03:	8d 50 01             	lea    0x1(%eax),%edx
  800d06:	89 55 08             	mov    %edx,0x8(%ebp)
  800d09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d0c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d12:	8a 12                	mov    (%edx),%dl
  800d14:	88 10                	mov    %dl,(%eax)
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e4                	jne    800d00 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1f:	c9                   	leave  
  800d20:	c3                   	ret    

00800d21 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d34:	eb 1f                	jmp    800d55 <strncpy+0x34>
		*dst++ = *src;
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8d 50 01             	lea    0x1(%eax),%edx
  800d3c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d42:	8a 12                	mov    (%edx),%dl
  800d44:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	8a 00                	mov    (%eax),%al
  800d4b:	84 c0                	test   %al,%al
  800d4d:	74 03                	je     800d52 <strncpy+0x31>
			src++;
  800d4f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d52:	ff 45 fc             	incl   -0x4(%ebp)
  800d55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d58:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d5b:	72 d9                	jb     800d36 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d72:	74 30                	je     800da4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d74:	eb 16                	jmp    800d8c <strlcpy+0x2a>
			*dst++ = *src++;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8d 50 01             	lea    0x1(%eax),%edx
  800d7c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d82:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d85:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d88:	8a 12                	mov    (%edx),%dl
  800d8a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d8c:	ff 4d 10             	decl   0x10(%ebp)
  800d8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d93:	74 09                	je     800d9e <strlcpy+0x3c>
  800d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 d8                	jne    800d76 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da4:	8b 55 08             	mov    0x8(%ebp),%edx
  800da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800daa:	29 c2                	sub    %eax,%edx
  800dac:	89 d0                	mov    %edx,%eax
}
  800dae:	c9                   	leave  
  800daf:	c3                   	ret    

00800db0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800db3:	eb 06                	jmp    800dbb <strcmp+0xb>
		p++, q++;
  800db5:	ff 45 08             	incl   0x8(%ebp)
  800db8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	8a 00                	mov    (%eax),%al
  800dc0:	84 c0                	test   %al,%al
  800dc2:	74 0e                	je     800dd2 <strcmp+0x22>
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8a 10                	mov    (%eax),%dl
  800dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	38 c2                	cmp    %al,%dl
  800dd0:	74 e3                	je     800db5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8a 00                	mov    (%eax),%al
  800dd7:	0f b6 d0             	movzbl %al,%edx
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8a 00                	mov    (%eax),%al
  800ddf:	0f b6 c0             	movzbl %al,%eax
  800de2:	29 c2                	sub    %eax,%edx
  800de4:	89 d0                	mov    %edx,%eax
}
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800deb:	eb 09                	jmp    800df6 <strncmp+0xe>
		n--, p++, q++;
  800ded:	ff 4d 10             	decl   0x10(%ebp)
  800df0:	ff 45 08             	incl   0x8(%ebp)
  800df3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dfa:	74 17                	je     800e13 <strncmp+0x2b>
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	74 0e                	je     800e13 <strncmp+0x2b>
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
  800e08:	8a 10                	mov    (%eax),%dl
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8a 00                	mov    (%eax),%al
  800e0f:	38 c2                	cmp    %al,%dl
  800e11:	74 da                	je     800ded <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e13:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e17:	75 07                	jne    800e20 <strncmp+0x38>
		return 0;
  800e19:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1e:	eb 14                	jmp    800e34 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	0f b6 d0             	movzbl %al,%edx
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	0f b6 c0             	movzbl %al,%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    

00800e36 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	83 ec 04             	sub    $0x4,%esp
  800e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e42:	eb 12                	jmp    800e56 <strchr+0x20>
		if (*s == c)
  800e44:	8b 45 08             	mov    0x8(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e4c:	75 05                	jne    800e53 <strchr+0x1d>
			return (char *) s;
  800e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e51:	eb 11                	jmp    800e64 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	8b 45 08             	mov    0x8(%ebp),%eax
  800e59:	8a 00                	mov    (%eax),%al
  800e5b:	84 c0                	test   %al,%al
  800e5d:	75 e5                	jne    800e44 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 04             	sub    $0x4,%esp
  800e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e72:	eb 0d                	jmp    800e81 <strfind+0x1b>
		if (*s == c)
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	8a 00                	mov    (%eax),%al
  800e79:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7c:	74 0e                	je     800e8c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	8b 45 08             	mov    0x8(%ebp),%eax
  800e84:	8a 00                	mov    (%eax),%al
  800e86:	84 c0                	test   %al,%al
  800e88:	75 ea                	jne    800e74 <strfind+0xe>
  800e8a:	eb 01                	jmp    800e8d <strfind+0x27>
		if (*s == c)
			break;
  800e8c:	90                   	nop
	return (char *) s;
  800e8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e90:	c9                   	leave  
  800e91:	c3                   	ret    

00800e92 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea4:	eb 0e                	jmp    800eb4 <memset+0x22>
		*p++ = c;
  800ea6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea9:	8d 50 01             	lea    0x1(%eax),%edx
  800eac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eaf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb4:	ff 4d f8             	decl   -0x8(%ebp)
  800eb7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ebb:	79 e9                	jns    800ea6 <memset+0x14>
		*p++ = c;

	return v;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ece:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed4:	eb 16                	jmp    800eec <memcpy+0x2a>
		*d++ = *s++;
  800ed6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed9:	8d 50 01             	lea    0x1(%eax),%edx
  800edc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee8:	8a 12                	mov    (%edx),%dl
  800eea:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	75 dd                	jne    800ed6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800efc:	c9                   	leave  
  800efd:	c3                   	ret    

00800efe <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efe:	55                   	push   %ebp
  800eff:	89 e5                	mov    %esp,%ebp
  800f01:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f13:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f16:	73 50                	jae    800f68 <memmove+0x6a>
  800f18:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	01 d0                	add    %edx,%eax
  800f20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f23:	76 43                	jbe    800f68 <memmove+0x6a>
		s += n;
  800f25:	8b 45 10             	mov    0x10(%ebp),%eax
  800f28:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f31:	eb 10                	jmp    800f43 <memmove+0x45>
			*--d = *--s;
  800f33:	ff 4d f8             	decl   -0x8(%ebp)
  800f36:	ff 4d fc             	decl   -0x4(%ebp)
  800f39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f3c:	8a 10                	mov    (%eax),%dl
  800f3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f41:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f49:	89 55 10             	mov    %edx,0x10(%ebp)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	75 e3                	jne    800f33 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f50:	eb 23                	jmp    800f75 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f68:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f71:	85 c0                	test   %eax,%eax
  800f73:	75 dd                	jne    800f52 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f89:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f8c:	eb 2a                	jmp    800fb8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f91:	8a 10                	mov    (%eax),%dl
  800f93:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	38 c2                	cmp    %al,%dl
  800f9a:	74 16                	je     800fb2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9f:	8a 00                	mov    (%eax),%al
  800fa1:	0f b6 d0             	movzbl %al,%edx
  800fa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	0f b6 c0             	movzbl %al,%eax
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	eb 18                	jmp    800fca <memcmp+0x50>
		s1++, s2++;
  800fb2:	ff 45 fc             	incl   -0x4(%ebp)
  800fb5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fbe:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	75 c9                	jne    800f8e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fca:	c9                   	leave  
  800fcb:	c3                   	ret    

00800fcc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd8:	01 d0                	add    %edx,%eax
  800fda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fdd:	eb 15                	jmp    800ff4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	8a 00                	mov    (%eax),%al
  800fe4:	0f b6 d0             	movzbl %al,%edx
  800fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fea:	0f b6 c0             	movzbl %al,%eax
  800fed:	39 c2                	cmp    %eax,%edx
  800fef:	74 0d                	je     800ffe <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ff1:	ff 45 08             	incl   0x8(%ebp)
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ffa:	72 e3                	jb     800fdf <memfind+0x13>
  800ffc:	eb 01                	jmp    800fff <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffe:	90                   	nop
	return (void *) s;
  800fff:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801002:	c9                   	leave  
  801003:	c3                   	ret    

00801004 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801004:	55                   	push   %ebp
  801005:	89 e5                	mov    %esp,%ebp
  801007:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80100a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801011:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801018:	eb 03                	jmp    80101d <strtol+0x19>
		s++;
  80101a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	8a 00                	mov    (%eax),%al
  801022:	3c 20                	cmp    $0x20,%al
  801024:	74 f4                	je     80101a <strtol+0x16>
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 09                	cmp    $0x9,%al
  80102d:	74 eb                	je     80101a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 2b                	cmp    $0x2b,%al
  801036:	75 05                	jne    80103d <strtol+0x39>
		s++;
  801038:	ff 45 08             	incl   0x8(%ebp)
  80103b:	eb 13                	jmp    801050 <strtol+0x4c>
	else if (*s == '-')
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	3c 2d                	cmp    $0x2d,%al
  801044:	75 0a                	jne    801050 <strtol+0x4c>
		s++, neg = 1;
  801046:	ff 45 08             	incl   0x8(%ebp)
  801049:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801050:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801054:	74 06                	je     80105c <strtol+0x58>
  801056:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80105a:	75 20                	jne    80107c <strtol+0x78>
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 30                	cmp    $0x30,%al
  801063:	75 17                	jne    80107c <strtol+0x78>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	40                   	inc    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 78                	cmp    $0x78,%al
  80106d:	75 0d                	jne    80107c <strtol+0x78>
		s += 2, base = 16;
  80106f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801073:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80107a:	eb 28                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80107c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801080:	75 15                	jne    801097 <strtol+0x93>
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	8a 00                	mov    (%eax),%al
  801087:	3c 30                	cmp    $0x30,%al
  801089:	75 0c                	jne    801097 <strtol+0x93>
		s++, base = 8;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801095:	eb 0d                	jmp    8010a4 <strtol+0xa0>
	else if (base == 0)
  801097:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80109b:	75 07                	jne    8010a4 <strtol+0xa0>
		base = 10;
  80109d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 2f                	cmp    $0x2f,%al
  8010ab:	7e 19                	jle    8010c6 <strtol+0xc2>
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	8a 00                	mov    (%eax),%al
  8010b2:	3c 39                	cmp    $0x39,%al
  8010b4:	7f 10                	jg     8010c6 <strtol+0xc2>
			dig = *s - '0';
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	8a 00                	mov    (%eax),%al
  8010bb:	0f be c0             	movsbl %al,%eax
  8010be:	83 e8 30             	sub    $0x30,%eax
  8010c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c4:	eb 42                	jmp    801108 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 60                	cmp    $0x60,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xe4>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 7a                	cmp    $0x7a,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 57             	sub    $0x57,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 20                	jmp    801108 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 40                	cmp    $0x40,%al
  8010ef:	7e 39                	jle    80112a <strtol+0x126>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 5a                	cmp    $0x5a,%al
  8010f8:	7f 30                	jg     80112a <strtol+0x126>
			dig = *s - 'A' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 37             	sub    $0x37,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801108:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110e:	7d 19                	jge    801129 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801110:	ff 45 08             	incl   0x8(%ebp)
  801113:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801116:	0f af 45 10          	imul   0x10(%ebp),%eax
  80111a:	89 c2                	mov    %eax,%edx
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	01 d0                	add    %edx,%eax
  801121:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801124:	e9 7b ff ff ff       	jmp    8010a4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801129:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80112a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112e:	74 08                	je     801138 <strtol+0x134>
		*endptr = (char *) s;
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	8b 55 08             	mov    0x8(%ebp),%edx
  801136:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 07                	je     801145 <strtol+0x141>
  80113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801141:	f7 d8                	neg    %eax
  801143:	eb 03                	jmp    801148 <strtol+0x144>
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801148:	c9                   	leave  
  801149:	c3                   	ret    

0080114a <ltostr>:

void
ltostr(long value, char *str)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801150:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801157:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801162:	79 13                	jns    801177 <ltostr+0x2d>
	{
		neg = 1;
  801164:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801171:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801174:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117f:	99                   	cltd   
  801180:	f7 f9                	idiv   %ecx
  801182:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801185:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801188:	8d 50 01             	lea    0x1(%eax),%edx
  80118b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118e:	89 c2                	mov    %eax,%edx
  801190:	8b 45 0c             	mov    0xc(%ebp),%eax
  801193:	01 d0                	add    %edx,%eax
  801195:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801198:	83 c2 30             	add    $0x30,%edx
  80119b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a5:	f7 e9                	imul   %ecx
  8011a7:	c1 fa 02             	sar    $0x2,%edx
  8011aa:	89 c8                	mov    %ecx,%eax
  8011ac:	c1 f8 1f             	sar    $0x1f,%eax
  8011af:	29 c2                	sub    %eax,%edx
  8011b1:	89 d0                	mov    %edx,%eax
  8011b3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011be:	f7 e9                	imul   %ecx
  8011c0:	c1 fa 02             	sar    $0x2,%edx
  8011c3:	89 c8                	mov    %ecx,%eax
  8011c5:	c1 f8 1f             	sar    $0x1f,%eax
  8011c8:	29 c2                	sub    %eax,%edx
  8011ca:	89 d0                	mov    %edx,%eax
  8011cc:	c1 e0 02             	shl    $0x2,%eax
  8011cf:	01 d0                	add    %edx,%eax
  8011d1:	01 c0                	add    %eax,%eax
  8011d3:	29 c1                	sub    %eax,%ecx
  8011d5:	89 ca                	mov    %ecx,%edx
  8011d7:	85 d2                	test   %edx,%edx
  8011d9:	75 9c                	jne    801177 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e5:	48                   	dec    %eax
  8011e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ed:	74 3d                	je     80122c <ltostr+0xe2>
		start = 1 ;
  8011ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f6:	eb 34                	jmp    80122c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	8a 00                	mov    (%eax),%al
  801202:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120b:	01 c2                	add    %eax,%edx
  80120d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801210:	8b 45 0c             	mov    0xc(%ebp),%eax
  801213:	01 c8                	add    %ecx,%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801219:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	01 c2                	add    %eax,%edx
  801221:	8a 45 eb             	mov    -0x15(%ebp),%al
  801224:	88 02                	mov    %al,(%edx)
		start++ ;
  801226:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801229:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80122c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7c c4                	jl     8011f8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801234:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 d0                	add    %edx,%eax
  80123c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123f:	90                   	nop
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801248:	ff 75 08             	pushl  0x8(%ebp)
  80124b:	e8 54 fa ff ff       	call   800ca4 <strlen>
  801250:	83 c4 04             	add    $0x4,%esp
  801253:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801256:	ff 75 0c             	pushl  0xc(%ebp)
  801259:	e8 46 fa ff ff       	call   800ca4 <strlen>
  80125e:	83 c4 04             	add    $0x4,%esp
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801264:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80126b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801272:	eb 17                	jmp    80128b <strcconcat+0x49>
		final[s] = str1[s] ;
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8b 45 10             	mov    0x10(%ebp),%eax
  80127a:	01 c2                	add    %eax,%edx
  80127c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	01 c8                	add    %ecx,%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801288:	ff 45 fc             	incl   -0x4(%ebp)
  80128b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801291:	7c e1                	jl     801274 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801293:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80129a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012a1:	eb 1f                	jmp    8012c2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a6:	8d 50 01             	lea    0x1(%eax),%edx
  8012a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ac:	89 c2                	mov    %eax,%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 c2                	add    %eax,%edx
  8012b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b9:	01 c8                	add    %ecx,%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bf:	ff 45 f8             	incl   -0x8(%ebp)
  8012c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c8:	7c d9                	jl     8012a3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d0:	01 d0                	add    %edx,%eax
  8012d2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d5:	90                   	nop
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012db:	8b 45 14             	mov    0x14(%ebp),%eax
  8012de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e7:	8b 00                	mov    (%eax),%eax
  8012e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f3:	01 d0                	add    %edx,%eax
  8012f5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012fb:	eb 0c                	jmp    801309 <strsplit+0x31>
			*string++ = 0;
  8012fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801300:	8d 50 01             	lea    0x1(%eax),%edx
  801303:	89 55 08             	mov    %edx,0x8(%ebp)
  801306:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801309:	8b 45 08             	mov    0x8(%ebp),%eax
  80130c:	8a 00                	mov    (%eax),%al
  80130e:	84 c0                	test   %al,%al
  801310:	74 18                	je     80132a <strsplit+0x52>
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	8a 00                	mov    (%eax),%al
  801317:	0f be c0             	movsbl %al,%eax
  80131a:	50                   	push   %eax
  80131b:	ff 75 0c             	pushl  0xc(%ebp)
  80131e:	e8 13 fb ff ff       	call   800e36 <strchr>
  801323:	83 c4 08             	add    $0x8,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	75 d3                	jne    8012fd <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80132a:	8b 45 08             	mov    0x8(%ebp),%eax
  80132d:	8a 00                	mov    (%eax),%al
  80132f:	84 c0                	test   %al,%al
  801331:	74 5a                	je     80138d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801333:	8b 45 14             	mov    0x14(%ebp),%eax
  801336:	8b 00                	mov    (%eax),%eax
  801338:	83 f8 0f             	cmp    $0xf,%eax
  80133b:	75 07                	jne    801344 <strsplit+0x6c>
		{
			return 0;
  80133d:	b8 00 00 00 00       	mov    $0x0,%eax
  801342:	eb 66                	jmp    8013aa <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801344:	8b 45 14             	mov    0x14(%ebp),%eax
  801347:	8b 00                	mov    (%eax),%eax
  801349:	8d 48 01             	lea    0x1(%eax),%ecx
  80134c:	8b 55 14             	mov    0x14(%ebp),%edx
  80134f:	89 0a                	mov    %ecx,(%edx)
  801351:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 c2                	add    %eax,%edx
  80135d:	8b 45 08             	mov    0x8(%ebp),%eax
  801360:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801362:	eb 03                	jmp    801367 <strsplit+0x8f>
			string++;
  801364:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	8a 00                	mov    (%eax),%al
  80136c:	84 c0                	test   %al,%al
  80136e:	74 8b                	je     8012fb <strsplit+0x23>
  801370:	8b 45 08             	mov    0x8(%ebp),%eax
  801373:	8a 00                	mov    (%eax),%al
  801375:	0f be c0             	movsbl %al,%eax
  801378:	50                   	push   %eax
  801379:	ff 75 0c             	pushl  0xc(%ebp)
  80137c:	e8 b5 fa ff ff       	call   800e36 <strchr>
  801381:	83 c4 08             	add    $0x8,%esp
  801384:	85 c0                	test   %eax,%eax
  801386:	74 dc                	je     801364 <strsplit+0x8c>
			string++;
	}
  801388:	e9 6e ff ff ff       	jmp    8012fb <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80138d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138e:	8b 45 14             	mov    0x14(%ebp),%eax
  801391:	8b 00                	mov    (%eax),%eax
  801393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80139a:	8b 45 10             	mov    0x10(%ebp),%eax
  80139d:	01 d0                	add    %edx,%eax
  80139f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013aa:	c9                   	leave  
  8013ab:	c3                   	ret    

008013ac <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013b2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b7:	85 c0                	test   %eax,%eax
  8013b9:	74 1f                	je     8013da <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013bb:	e8 1d 00 00 00       	call   8013dd <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013c0:	83 ec 0c             	sub    $0xc,%esp
  8013c3:	68 50 3b 80 00       	push   $0x803b50
  8013c8:	e8 55 f2 ff ff       	call   800622 <cprintf>
  8013cd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013d0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d7:	00 00 00 
	}
}
  8013da:	90                   	nop
  8013db:	c9                   	leave  
  8013dc:	c3                   	ret    

008013dd <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013dd:	55                   	push   %ebp
  8013de:	89 e5                	mov    %esp,%ebp
  8013e0:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8013e3:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013ea:	00 00 00 
  8013ed:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013f4:	00 00 00 
  8013f7:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013fe:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801401:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801408:	00 00 00 
  80140b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801412:	00 00 00 
  801415:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80141c:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80141f:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801429:	c1 e8 0c             	shr    $0xc,%eax
  80142c:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801431:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801440:	2d 00 10 00 00       	sub    $0x1000,%eax
  801445:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  80144a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801451:	a1 20 41 80 00       	mov    0x804120,%eax
  801456:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80145a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80145d:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801464:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80146a:	01 d0                	add    %edx,%eax
  80146c:	48                   	dec    %eax
  80146d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801473:	ba 00 00 00 00       	mov    $0x0,%edx
  801478:	f7 75 e4             	divl   -0x1c(%ebp)
  80147b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147e:	29 d0                	sub    %edx,%eax
  801480:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801483:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  80148a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80148d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801492:	2d 00 10 00 00       	sub    $0x1000,%eax
  801497:	83 ec 04             	sub    $0x4,%esp
  80149a:	6a 07                	push   $0x7
  80149c:	ff 75 e8             	pushl  -0x18(%ebp)
  80149f:	50                   	push   %eax
  8014a0:	e8 3d 06 00 00       	call   801ae2 <sys_allocate_chunk>
  8014a5:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014a8:	a1 20 41 80 00       	mov    0x804120,%eax
  8014ad:	83 ec 0c             	sub    $0xc,%esp
  8014b0:	50                   	push   %eax
  8014b1:	e8 b2 0c 00 00       	call   802168 <initialize_MemBlocksList>
  8014b6:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8014b9:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014be:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8014c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014c5:	0f 84 f3 00 00 00    	je     8015be <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8014cb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014cf:	75 14                	jne    8014e5 <initialize_dyn_block_system+0x108>
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	68 75 3b 80 00       	push   $0x803b75
  8014d9:	6a 36                	push   $0x36
  8014db:	68 93 3b 80 00       	push   $0x803b93
  8014e0:	e8 41 1c 00 00       	call   803126 <_panic>
  8014e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e8:	8b 00                	mov    (%eax),%eax
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	74 10                	je     8014fe <initialize_dyn_block_system+0x121>
  8014ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014f1:	8b 00                	mov    (%eax),%eax
  8014f3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014f6:	8b 52 04             	mov    0x4(%edx),%edx
  8014f9:	89 50 04             	mov    %edx,0x4(%eax)
  8014fc:	eb 0b                	jmp    801509 <initialize_dyn_block_system+0x12c>
  8014fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801501:	8b 40 04             	mov    0x4(%eax),%eax
  801504:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801509:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80150c:	8b 40 04             	mov    0x4(%eax),%eax
  80150f:	85 c0                	test   %eax,%eax
  801511:	74 0f                	je     801522 <initialize_dyn_block_system+0x145>
  801513:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801516:	8b 40 04             	mov    0x4(%eax),%eax
  801519:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80151c:	8b 12                	mov    (%edx),%edx
  80151e:	89 10                	mov    %edx,(%eax)
  801520:	eb 0a                	jmp    80152c <initialize_dyn_block_system+0x14f>
  801522:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801525:	8b 00                	mov    (%eax),%eax
  801527:	a3 48 41 80 00       	mov    %eax,0x804148
  80152c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80152f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801535:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801538:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80153f:	a1 54 41 80 00       	mov    0x804154,%eax
  801544:	48                   	dec    %eax
  801545:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80154a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80154d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801554:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801557:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80155e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801562:	75 14                	jne    801578 <initialize_dyn_block_system+0x19b>
  801564:	83 ec 04             	sub    $0x4,%esp
  801567:	68 a0 3b 80 00       	push   $0x803ba0
  80156c:	6a 3e                	push   $0x3e
  80156e:	68 93 3b 80 00       	push   $0x803b93
  801573:	e8 ae 1b 00 00       	call   803126 <_panic>
  801578:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80157e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801581:	89 10                	mov    %edx,(%eax)
  801583:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801586:	8b 00                	mov    (%eax),%eax
  801588:	85 c0                	test   %eax,%eax
  80158a:	74 0d                	je     801599 <initialize_dyn_block_system+0x1bc>
  80158c:	a1 38 41 80 00       	mov    0x804138,%eax
  801591:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801594:	89 50 04             	mov    %edx,0x4(%eax)
  801597:	eb 08                	jmp    8015a1 <initialize_dyn_block_system+0x1c4>
  801599:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80159c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8015a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015a4:	a3 38 41 80 00       	mov    %eax,0x804138
  8015a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8015b8:	40                   	inc    %eax
  8015b9:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8015be:	90                   	nop
  8015bf:	c9                   	leave  
  8015c0:	c3                   	ret    

008015c1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8015c7:	e8 e0 fd ff ff       	call   8013ac <InitializeUHeap>
		if (size == 0) return NULL ;
  8015cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015d0:	75 07                	jne    8015d9 <malloc+0x18>
  8015d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d7:	eb 7f                	jmp    801658 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8015d9:	e8 d2 08 00 00       	call   801eb0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	74 71                	je     801653 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8015e2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ef:	01 d0                	add    %edx,%eax
  8015f1:	48                   	dec    %eax
  8015f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fd:	f7 75 f4             	divl   -0xc(%ebp)
  801600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801603:	29 d0                	sub    %edx,%eax
  801605:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801608:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80160f:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801616:	76 07                	jbe    80161f <malloc+0x5e>
					return NULL ;
  801618:	b8 00 00 00 00       	mov    $0x0,%eax
  80161d:	eb 39                	jmp    801658 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80161f:	83 ec 0c             	sub    $0xc,%esp
  801622:	ff 75 08             	pushl  0x8(%ebp)
  801625:	e8 e6 0d 00 00       	call   802410 <alloc_block_FF>
  80162a:	83 c4 10             	add    $0x10,%esp
  80162d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801630:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801634:	74 16                	je     80164c <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801636:	83 ec 0c             	sub    $0xc,%esp
  801639:	ff 75 ec             	pushl  -0x14(%ebp)
  80163c:	e8 37 0c 00 00       	call   802278 <insert_sorted_allocList>
  801641:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801644:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801647:	8b 40 08             	mov    0x8(%eax),%eax
  80164a:	eb 0c                	jmp    801658 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  80164c:	b8 00 00 00 00       	mov    $0x0,%eax
  801651:	eb 05                	jmp    801658 <malloc+0x97>
				}
		}
	return 0;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801660:	8b 45 08             	mov    0x8(%ebp),%eax
  801663:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801666:	83 ec 08             	sub    $0x8,%esp
  801669:	ff 75 f4             	pushl  -0xc(%ebp)
  80166c:	68 40 40 80 00       	push   $0x804040
  801671:	e8 cf 0b 00 00       	call   802245 <find_block>
  801676:	83 c4 10             	add    $0x10,%esp
  801679:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  80167c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167f:	8b 40 0c             	mov    0xc(%eax),%eax
  801682:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801688:	8b 40 08             	mov    0x8(%eax),%eax
  80168b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  80168e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801692:	0f 84 a1 00 00 00    	je     801739 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801698:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80169c:	75 17                	jne    8016b5 <free+0x5b>
  80169e:	83 ec 04             	sub    $0x4,%esp
  8016a1:	68 75 3b 80 00       	push   $0x803b75
  8016a6:	68 80 00 00 00       	push   $0x80
  8016ab:	68 93 3b 80 00       	push   $0x803b93
  8016b0:	e8 71 1a 00 00       	call   803126 <_panic>
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	8b 00                	mov    (%eax),%eax
  8016ba:	85 c0                	test   %eax,%eax
  8016bc:	74 10                	je     8016ce <free+0x74>
  8016be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c1:	8b 00                	mov    (%eax),%eax
  8016c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c6:	8b 52 04             	mov    0x4(%edx),%edx
  8016c9:	89 50 04             	mov    %edx,0x4(%eax)
  8016cc:	eb 0b                	jmp    8016d9 <free+0x7f>
  8016ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d1:	8b 40 04             	mov    0x4(%eax),%eax
  8016d4:	a3 44 40 80 00       	mov    %eax,0x804044
  8016d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016dc:	8b 40 04             	mov    0x4(%eax),%eax
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	74 0f                	je     8016f2 <free+0x98>
  8016e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e6:	8b 40 04             	mov    0x4(%eax),%eax
  8016e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016ec:	8b 12                	mov    (%edx),%edx
  8016ee:	89 10                	mov    %edx,(%eax)
  8016f0:	eb 0a                	jmp    8016fc <free+0xa2>
  8016f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f5:	8b 00                	mov    (%eax),%eax
  8016f7:	a3 40 40 80 00       	mov    %eax,0x804040
  8016fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801708:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80170f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801714:	48                   	dec    %eax
  801715:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80171a:	83 ec 0c             	sub    $0xc,%esp
  80171d:	ff 75 f0             	pushl  -0x10(%ebp)
  801720:	e8 29 12 00 00       	call   80294e <insert_sorted_with_merge_freeList>
  801725:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801728:	83 ec 08             	sub    $0x8,%esp
  80172b:	ff 75 ec             	pushl  -0x14(%ebp)
  80172e:	ff 75 e8             	pushl  -0x18(%ebp)
  801731:	e8 74 03 00 00       	call   801aaa <sys_free_user_mem>
  801736:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801739:	90                   	nop
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 38             	sub    $0x38,%esp
  801742:	8b 45 10             	mov    0x10(%ebp),%eax
  801745:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801748:	e8 5f fc ff ff       	call   8013ac <InitializeUHeap>
	if (size == 0) return NULL ;
  80174d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801751:	75 0a                	jne    80175d <smalloc+0x21>
  801753:	b8 00 00 00 00       	mov    $0x0,%eax
  801758:	e9 b2 00 00 00       	jmp    80180f <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  80175d:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801764:	76 0a                	jbe    801770 <smalloc+0x34>
		return NULL;
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	e9 9f 00 00 00       	jmp    80180f <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801770:	e8 3b 07 00 00       	call   801eb0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801775:	85 c0                	test   %eax,%eax
  801777:	0f 84 8d 00 00 00    	je     80180a <smalloc+0xce>
	struct MemBlock *b = NULL;
  80177d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801784:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80178b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801791:	01 d0                	add    %edx,%eax
  801793:	48                   	dec    %eax
  801794:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179a:	ba 00 00 00 00       	mov    $0x0,%edx
  80179f:	f7 75 f0             	divl   -0x10(%ebp)
  8017a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a5:	29 d0                	sub    %edx,%eax
  8017a7:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8017aa:	83 ec 0c             	sub    $0xc,%esp
  8017ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b0:	e8 5b 0c 00 00       	call   802410 <alloc_block_FF>
  8017b5:	83 c4 10             	add    $0x10,%esp
  8017b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8017bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017bf:	75 07                	jne    8017c8 <smalloc+0x8c>
			return NULL;
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c6:	eb 47                	jmp    80180f <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8017c8:	83 ec 0c             	sub    $0xc,%esp
  8017cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ce:	e8 a5 0a 00 00       	call   802278 <insert_sorted_allocList>
  8017d3:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8017d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d9:	8b 40 08             	mov    0x8(%eax),%eax
  8017dc:	89 c2                	mov    %eax,%edx
  8017de:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017e2:	52                   	push   %edx
  8017e3:	50                   	push   %eax
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	ff 75 08             	pushl  0x8(%ebp)
  8017ea:	e8 46 04 00 00       	call   801c35 <sys_createSharedObject>
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8017f5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017f9:	78 08                	js     801803 <smalloc+0xc7>
		return (void *)b->sva;
  8017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fe:	8b 40 08             	mov    0x8(%eax),%eax
  801801:	eb 0c                	jmp    80180f <smalloc+0xd3>
		}else{
		return NULL;
  801803:	b8 00 00 00 00       	mov    $0x0,%eax
  801808:	eb 05                	jmp    80180f <smalloc+0xd3>
			}

	}return NULL;
  80180a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180f:	c9                   	leave  
  801810:	c3                   	ret    

00801811 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801817:	e8 90 fb ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80181c:	e8 8f 06 00 00       	call   801eb0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801821:	85 c0                	test   %eax,%eax
  801823:	0f 84 ad 00 00 00    	je     8018d6 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801829:	83 ec 08             	sub    $0x8,%esp
  80182c:	ff 75 0c             	pushl  0xc(%ebp)
  80182f:	ff 75 08             	pushl  0x8(%ebp)
  801832:	e8 28 04 00 00       	call   801c5f <sys_getSizeOfSharedObject>
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80183d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801841:	79 0a                	jns    80184d <sget+0x3c>
    {
    	return NULL;
  801843:	b8 00 00 00 00       	mov    $0x0,%eax
  801848:	e9 8e 00 00 00       	jmp    8018db <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  80184d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801854:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80185b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801861:	01 d0                	add    %edx,%eax
  801863:	48                   	dec    %eax
  801864:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801867:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80186a:	ba 00 00 00 00       	mov    $0x0,%edx
  80186f:	f7 75 ec             	divl   -0x14(%ebp)
  801872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801875:	29 d0                	sub    %edx,%eax
  801877:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  80187a:	83 ec 0c             	sub    $0xc,%esp
  80187d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801880:	e8 8b 0b 00 00       	call   802410 <alloc_block_FF>
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  80188b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80188f:	75 07                	jne    801898 <sget+0x87>
				return NULL;
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	eb 43                	jmp    8018db <sget+0xca>
			}
			insert_sorted_allocList(b);
  801898:	83 ec 0c             	sub    $0xc,%esp
  80189b:	ff 75 f0             	pushl  -0x10(%ebp)
  80189e:	e8 d5 09 00 00       	call   802278 <insert_sorted_allocList>
  8018a3:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8018a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a9:	8b 40 08             	mov    0x8(%eax),%eax
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	50                   	push   %eax
  8018b0:	ff 75 0c             	pushl  0xc(%ebp)
  8018b3:	ff 75 08             	pushl  0x8(%ebp)
  8018b6:	e8 c1 03 00 00       	call   801c7c <sys_getSharedObject>
  8018bb:	83 c4 10             	add    $0x10,%esp
  8018be:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8018c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018c5:	78 08                	js     8018cf <sget+0xbe>
			return (void *)b->sva;
  8018c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ca:	8b 40 08             	mov    0x8(%eax),%eax
  8018cd:	eb 0c                	jmp    8018db <sget+0xca>
			}else{
			return NULL;
  8018cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d4:	eb 05                	jmp    8018db <sget+0xca>
			}
    }}return NULL;
  8018d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
  8018e0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018e3:	e8 c4 fa ff ff       	call   8013ac <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	68 c4 3b 80 00       	push   $0x803bc4
  8018f0:	68 03 01 00 00       	push   $0x103
  8018f5:	68 93 3b 80 00       	push   $0x803b93
  8018fa:	e8 27 18 00 00       	call   803126 <_panic>

008018ff <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801905:	83 ec 04             	sub    $0x4,%esp
  801908:	68 ec 3b 80 00       	push   $0x803bec
  80190d:	68 17 01 00 00       	push   $0x117
  801912:	68 93 3b 80 00       	push   $0x803b93
  801917:	e8 0a 18 00 00       	call   803126 <_panic>

0080191c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	68 10 3c 80 00       	push   $0x803c10
  80192a:	68 22 01 00 00       	push   $0x122
  80192f:	68 93 3b 80 00       	push   $0x803b93
  801934:	e8 ed 17 00 00       	call   803126 <_panic>

00801939 <shrink>:

}
void shrink(uint32 newSize)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
  80193c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193f:	83 ec 04             	sub    $0x4,%esp
  801942:	68 10 3c 80 00       	push   $0x803c10
  801947:	68 27 01 00 00       	push   $0x127
  80194c:	68 93 3b 80 00       	push   $0x803b93
  801951:	e8 d0 17 00 00       	call   803126 <_panic>

00801956 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80195c:	83 ec 04             	sub    $0x4,%esp
  80195f:	68 10 3c 80 00       	push   $0x803c10
  801964:	68 2c 01 00 00       	push   $0x12c
  801969:	68 93 3b 80 00       	push   $0x803b93
  80196e:	e8 b3 17 00 00       	call   803126 <_panic>

00801973 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
  801976:	57                   	push   %edi
  801977:	56                   	push   %esi
  801978:	53                   	push   %ebx
  801979:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801982:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801985:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801988:	8b 7d 18             	mov    0x18(%ebp),%edi
  80198b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80198e:	cd 30                	int    $0x30
  801990:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801993:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801996:	83 c4 10             	add    $0x10,%esp
  801999:	5b                   	pop    %ebx
  80199a:	5e                   	pop    %esi
  80199b:	5f                   	pop    %edi
  80199c:	5d                   	pop    %ebp
  80199d:	c3                   	ret    

0080199e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
  8019a1:	83 ec 04             	sub    $0x4,%esp
  8019a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019aa:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	52                   	push   %edx
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	50                   	push   %eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	e8 b2 ff ff ff       	call   801973 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	90                   	nop
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 01                	push   $0x1
  8019d6:	e8 98 ff ff ff       	call   801973 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	52                   	push   %edx
  8019f0:	50                   	push   %eax
  8019f1:	6a 05                	push   $0x5
  8019f3:	e8 7b ff ff ff       	call   801973 <syscall>
  8019f8:	83 c4 18             	add    $0x18,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	56                   	push   %esi
  801a01:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a02:	8b 75 18             	mov    0x18(%ebp),%esi
  801a05:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a11:	56                   	push   %esi
  801a12:	53                   	push   %ebx
  801a13:	51                   	push   %ecx
  801a14:	52                   	push   %edx
  801a15:	50                   	push   %eax
  801a16:	6a 06                	push   $0x6
  801a18:	e8 56 ff ff ff       	call   801973 <syscall>
  801a1d:	83 c4 18             	add    $0x18,%esp
}
  801a20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a23:	5b                   	pop    %ebx
  801a24:	5e                   	pop    %esi
  801a25:	5d                   	pop    %ebp
  801a26:	c3                   	ret    

00801a27 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	52                   	push   %edx
  801a37:	50                   	push   %eax
  801a38:	6a 07                	push   $0x7
  801a3a:	e8 34 ff ff ff       	call   801973 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	ff 75 08             	pushl  0x8(%ebp)
  801a53:	6a 08                	push   $0x8
  801a55:	e8 19 ff ff ff       	call   801973 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 09                	push   $0x9
  801a6e:	e8 00 ff ff ff       	call   801973 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 0a                	push   $0xa
  801a87:	e8 e7 fe ff ff       	call   801973 <syscall>
  801a8c:	83 c4 18             	add    $0x18,%esp
}
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 0b                	push   $0xb
  801aa0:	e8 ce fe ff ff       	call   801973 <syscall>
  801aa5:	83 c4 18             	add    $0x18,%esp
}
  801aa8:	c9                   	leave  
  801aa9:	c3                   	ret    

00801aaa <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aaa:	55                   	push   %ebp
  801aab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	ff 75 08             	pushl  0x8(%ebp)
  801ab9:	6a 0f                	push   $0xf
  801abb:	e8 b3 fe ff ff       	call   801973 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
	return;
  801ac3:	90                   	nop
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	ff 75 0c             	pushl  0xc(%ebp)
  801ad2:	ff 75 08             	pushl  0x8(%ebp)
  801ad5:	6a 10                	push   $0x10
  801ad7:	e8 97 fe ff ff       	call   801973 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
	return ;
  801adf:	90                   	nop
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 00                	push   $0x0
  801ae9:	ff 75 10             	pushl  0x10(%ebp)
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	ff 75 08             	pushl  0x8(%ebp)
  801af2:	6a 11                	push   $0x11
  801af4:	e8 7a fe ff ff       	call   801973 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
	return ;
  801afc:	90                   	nop
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 0c                	push   $0xc
  801b0e:	e8 60 fe ff ff       	call   801973 <syscall>
  801b13:	83 c4 18             	add    $0x18,%esp
}
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	ff 75 08             	pushl  0x8(%ebp)
  801b26:	6a 0d                	push   $0xd
  801b28:	e8 46 fe ff ff       	call   801973 <syscall>
  801b2d:	83 c4 18             	add    $0x18,%esp
}
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 0e                	push   $0xe
  801b41:	e8 2d fe ff ff       	call   801973 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 13                	push   $0x13
  801b5b:	e8 13 fe ff ff       	call   801973 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 14                	push   $0x14
  801b75:	e8 f9 fd ff ff       	call   801973 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	90                   	nop
  801b7e:	c9                   	leave  
  801b7f:	c3                   	ret    

00801b80 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b80:	55                   	push   %ebp
  801b81:	89 e5                	mov    %esp,%ebp
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b8c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	50                   	push   %eax
  801b99:	6a 15                	push   $0x15
  801b9b:	e8 d3 fd ff ff       	call   801973 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	90                   	nop
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 16                	push   $0x16
  801bb5:	e8 b9 fd ff ff       	call   801973 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	90                   	nop
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	50                   	push   %eax
  801bd0:	6a 17                	push   $0x17
  801bd2:	e8 9c fd ff ff       	call   801973 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be2:	8b 45 08             	mov    0x8(%ebp),%eax
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	52                   	push   %edx
  801bec:	50                   	push   %eax
  801bed:	6a 1a                	push   $0x1a
  801bef:	e8 7f fd ff ff       	call   801973 <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bfc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	52                   	push   %edx
  801c09:	50                   	push   %eax
  801c0a:	6a 18                	push   $0x18
  801c0c:	e8 62 fd ff ff       	call   801973 <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	52                   	push   %edx
  801c27:	50                   	push   %eax
  801c28:	6a 19                	push   $0x19
  801c2a:	e8 44 fd ff ff       	call   801973 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	90                   	nop
  801c33:	c9                   	leave  
  801c34:	c3                   	ret    

00801c35 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c41:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c44:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	6a 00                	push   $0x0
  801c4d:	51                   	push   %ecx
  801c4e:	52                   	push   %edx
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	50                   	push   %eax
  801c53:	6a 1b                	push   $0x1b
  801c55:	e8 19 fd ff ff       	call   801973 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	52                   	push   %edx
  801c6f:	50                   	push   %eax
  801c70:	6a 1c                	push   $0x1c
  801c72:	e8 fc fc ff ff       	call   801973 <syscall>
  801c77:	83 c4 18             	add    $0x18,%esp
}
  801c7a:	c9                   	leave  
  801c7b:	c3                   	ret    

00801c7c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	51                   	push   %ecx
  801c8d:	52                   	push   %edx
  801c8e:	50                   	push   %eax
  801c8f:	6a 1d                	push   $0x1d
  801c91:	e8 dd fc ff ff       	call   801973 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	52                   	push   %edx
  801cab:	50                   	push   %eax
  801cac:	6a 1e                	push   $0x1e
  801cae:	e8 c0 fc ff ff       	call   801973 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 1f                	push   $0x1f
  801cc7:	e8 a7 fc ff ff       	call   801973 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd7:	6a 00                	push   $0x0
  801cd9:	ff 75 14             	pushl  0x14(%ebp)
  801cdc:	ff 75 10             	pushl  0x10(%ebp)
  801cdf:	ff 75 0c             	pushl  0xc(%ebp)
  801ce2:	50                   	push   %eax
  801ce3:	6a 20                	push   $0x20
  801ce5:	e8 89 fc ff ff       	call   801973 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	50                   	push   %eax
  801cfe:	6a 21                	push   $0x21
  801d00:	e8 6e fc ff ff       	call   801973 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	90                   	nop
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	50                   	push   %eax
  801d1a:	6a 22                	push   $0x22
  801d1c:	e8 52 fc ff ff       	call   801973 <syscall>
  801d21:	83 c4 18             	add    $0x18,%esp
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 02                	push   $0x2
  801d35:	e8 39 fc ff ff       	call   801973 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 03                	push   $0x3
  801d4e:	e8 20 fc ff ff       	call   801973 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
}
  801d56:	c9                   	leave  
  801d57:	c3                   	ret    

00801d58 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d58:	55                   	push   %ebp
  801d59:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 04                	push   $0x4
  801d67:	e8 07 fc ff ff       	call   801973 <syscall>
  801d6c:	83 c4 18             	add    $0x18,%esp
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <sys_exit_env>:


void sys_exit_env(void)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 23                	push   $0x23
  801d80:	e8 ee fb ff ff       	call   801973 <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	90                   	nop
  801d89:	c9                   	leave  
  801d8a:	c3                   	ret    

00801d8b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d91:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d94:	8d 50 04             	lea    0x4(%eax),%edx
  801d97:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	52                   	push   %edx
  801da1:	50                   	push   %eax
  801da2:	6a 24                	push   $0x24
  801da4:	e8 ca fb ff ff       	call   801973 <syscall>
  801da9:	83 c4 18             	add    $0x18,%esp
	return result;
  801dac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801daf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801db2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801db5:	89 01                	mov    %eax,(%ecx)
  801db7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	c9                   	leave  
  801dbe:	c2 04 00             	ret    $0x4

00801dc1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	ff 75 10             	pushl  0x10(%ebp)
  801dcb:	ff 75 0c             	pushl  0xc(%ebp)
  801dce:	ff 75 08             	pushl  0x8(%ebp)
  801dd1:	6a 12                	push   $0x12
  801dd3:	e8 9b fb ff ff       	call   801973 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddb:	90                   	nop
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_rcr2>:
uint32 sys_rcr2()
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 25                	push   $0x25
  801ded:	e8 81 fb ff ff       	call   801973 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	83 ec 04             	sub    $0x4,%esp
  801dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  801e00:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e03:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	50                   	push   %eax
  801e10:	6a 26                	push   $0x26
  801e12:	e8 5c fb ff ff       	call   801973 <syscall>
  801e17:	83 c4 18             	add    $0x18,%esp
	return ;
  801e1a:	90                   	nop
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <rsttst>:
void rsttst()
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 28                	push   $0x28
  801e2c:	e8 42 fb ff ff       	call   801973 <syscall>
  801e31:	83 c4 18             	add    $0x18,%esp
	return ;
  801e34:	90                   	nop
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e40:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e43:	8b 55 18             	mov    0x18(%ebp),%edx
  801e46:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e4a:	52                   	push   %edx
  801e4b:	50                   	push   %eax
  801e4c:	ff 75 10             	pushl  0x10(%ebp)
  801e4f:	ff 75 0c             	pushl  0xc(%ebp)
  801e52:	ff 75 08             	pushl  0x8(%ebp)
  801e55:	6a 27                	push   $0x27
  801e57:	e8 17 fb ff ff       	call   801973 <syscall>
  801e5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5f:	90                   	nop
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <chktst>:
void chktst(uint32 n)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	ff 75 08             	pushl  0x8(%ebp)
  801e70:	6a 29                	push   $0x29
  801e72:	e8 fc fa ff ff       	call   801973 <syscall>
  801e77:	83 c4 18             	add    $0x18,%esp
	return ;
  801e7a:	90                   	nop
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <inctst>:

void inctst()
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 2a                	push   $0x2a
  801e8c:	e8 e2 fa ff ff       	call   801973 <syscall>
  801e91:	83 c4 18             	add    $0x18,%esp
	return ;
  801e94:	90                   	nop
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <gettst>:
uint32 gettst()
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 2b                	push   $0x2b
  801ea6:	e8 c8 fa ff ff       	call   801973 <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
}
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 2c                	push   $0x2c
  801ec2:	e8 ac fa ff ff       	call   801973 <syscall>
  801ec7:	83 c4 18             	add    $0x18,%esp
  801eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ecd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ed1:	75 07                	jne    801eda <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ed3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed8:	eb 05                	jmp    801edf <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 2c                	push   $0x2c
  801ef3:	e8 7b fa ff ff       	call   801973 <syscall>
  801ef8:	83 c4 18             	add    $0x18,%esp
  801efb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801efe:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f02:	75 07                	jne    801f0b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f04:	b8 01 00 00 00       	mov    $0x1,%eax
  801f09:	eb 05                	jmp    801f10 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 2c                	push   $0x2c
  801f24:	e8 4a fa ff ff       	call   801973 <syscall>
  801f29:	83 c4 18             	add    $0x18,%esp
  801f2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f2f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f33:	75 07                	jne    801f3c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f35:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3a:	eb 05                	jmp    801f41 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f41:	c9                   	leave  
  801f42:	c3                   	ret    

00801f43 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f43:	55                   	push   %ebp
  801f44:	89 e5                	mov    %esp,%ebp
  801f46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 2c                	push   $0x2c
  801f55:	e8 19 fa ff ff       	call   801973 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
  801f5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f60:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f64:	75 07                	jne    801f6d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f66:	b8 01 00 00 00       	mov    $0x1,%eax
  801f6b:	eb 05                	jmp    801f72 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f72:	c9                   	leave  
  801f73:	c3                   	ret    

00801f74 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f74:	55                   	push   %ebp
  801f75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	ff 75 08             	pushl  0x8(%ebp)
  801f82:	6a 2d                	push   $0x2d
  801f84:	e8 ea f9 ff ff       	call   801973 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8c:	90                   	nop
}
  801f8d:	c9                   	leave  
  801f8e:	c3                   	ret    

00801f8f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f8f:	55                   	push   %ebp
  801f90:	89 e5                	mov    %esp,%ebp
  801f92:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9f:	6a 00                	push   $0x0
  801fa1:	53                   	push   %ebx
  801fa2:	51                   	push   %ecx
  801fa3:	52                   	push   %edx
  801fa4:	50                   	push   %eax
  801fa5:	6a 2e                	push   $0x2e
  801fa7:	e8 c7 f9 ff ff       	call   801973 <syscall>
  801fac:	83 c4 18             	add    $0x18,%esp
}
  801faf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	52                   	push   %edx
  801fc4:	50                   	push   %eax
  801fc5:	6a 2f                	push   $0x2f
  801fc7:	e8 a7 f9 ff ff       	call   801973 <syscall>
  801fcc:	83 c4 18             	add    $0x18,%esp
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fd7:	83 ec 0c             	sub    $0xc,%esp
  801fda:	68 20 3c 80 00       	push   $0x803c20
  801fdf:	e8 3e e6 ff ff       	call   800622 <cprintf>
  801fe4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fe7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	68 4c 3c 80 00       	push   $0x803c4c
  801ff6:	e8 27 e6 ff ff       	call   800622 <cprintf>
  801ffb:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ffe:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802002:	a1 38 41 80 00       	mov    0x804138,%eax
  802007:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80200a:	eb 56                	jmp    802062 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80200c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802010:	74 1c                	je     80202e <print_mem_block_lists+0x5d>
  802012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802015:	8b 50 08             	mov    0x8(%eax),%edx
  802018:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201b:	8b 48 08             	mov    0x8(%eax),%ecx
  80201e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802021:	8b 40 0c             	mov    0xc(%eax),%eax
  802024:	01 c8                	add    %ecx,%eax
  802026:	39 c2                	cmp    %eax,%edx
  802028:	73 04                	jae    80202e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80202a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80202e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802031:	8b 50 08             	mov    0x8(%eax),%edx
  802034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802037:	8b 40 0c             	mov    0xc(%eax),%eax
  80203a:	01 c2                	add    %eax,%edx
  80203c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203f:	8b 40 08             	mov    0x8(%eax),%eax
  802042:	83 ec 04             	sub    $0x4,%esp
  802045:	52                   	push   %edx
  802046:	50                   	push   %eax
  802047:	68 61 3c 80 00       	push   $0x803c61
  80204c:	e8 d1 e5 ff ff       	call   800622 <cprintf>
  802051:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802054:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802057:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80205a:	a1 40 41 80 00       	mov    0x804140,%eax
  80205f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802062:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802066:	74 07                	je     80206f <print_mem_block_lists+0x9e>
  802068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206b:	8b 00                	mov    (%eax),%eax
  80206d:	eb 05                	jmp    802074 <print_mem_block_lists+0xa3>
  80206f:	b8 00 00 00 00       	mov    $0x0,%eax
  802074:	a3 40 41 80 00       	mov    %eax,0x804140
  802079:	a1 40 41 80 00       	mov    0x804140,%eax
  80207e:	85 c0                	test   %eax,%eax
  802080:	75 8a                	jne    80200c <print_mem_block_lists+0x3b>
  802082:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802086:	75 84                	jne    80200c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802088:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80208c:	75 10                	jne    80209e <print_mem_block_lists+0xcd>
  80208e:	83 ec 0c             	sub    $0xc,%esp
  802091:	68 70 3c 80 00       	push   $0x803c70
  802096:	e8 87 e5 ff ff       	call   800622 <cprintf>
  80209b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80209e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020a5:	83 ec 0c             	sub    $0xc,%esp
  8020a8:	68 94 3c 80 00       	push   $0x803c94
  8020ad:	e8 70 e5 ff ff       	call   800622 <cprintf>
  8020b2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020b5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020b9:	a1 40 40 80 00       	mov    0x804040,%eax
  8020be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c1:	eb 56                	jmp    802119 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c7:	74 1c                	je     8020e5 <print_mem_block_lists+0x114>
  8020c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cc:	8b 50 08             	mov    0x8(%eax),%edx
  8020cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d2:	8b 48 08             	mov    0x8(%eax),%ecx
  8020d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8020db:	01 c8                	add    %ecx,%eax
  8020dd:	39 c2                	cmp    %eax,%edx
  8020df:	73 04                	jae    8020e5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020e1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e8:	8b 50 08             	mov    0x8(%eax),%edx
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f1:	01 c2                	add    %eax,%edx
  8020f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f6:	8b 40 08             	mov    0x8(%eax),%eax
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	52                   	push   %edx
  8020fd:	50                   	push   %eax
  8020fe:	68 61 3c 80 00       	push   $0x803c61
  802103:	e8 1a e5 ff ff       	call   800622 <cprintf>
  802108:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80210b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802111:	a1 48 40 80 00       	mov    0x804048,%eax
  802116:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802119:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80211d:	74 07                	je     802126 <print_mem_block_lists+0x155>
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	8b 00                	mov    (%eax),%eax
  802124:	eb 05                	jmp    80212b <print_mem_block_lists+0x15a>
  802126:	b8 00 00 00 00       	mov    $0x0,%eax
  80212b:	a3 48 40 80 00       	mov    %eax,0x804048
  802130:	a1 48 40 80 00       	mov    0x804048,%eax
  802135:	85 c0                	test   %eax,%eax
  802137:	75 8a                	jne    8020c3 <print_mem_block_lists+0xf2>
  802139:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213d:	75 84                	jne    8020c3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80213f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802143:	75 10                	jne    802155 <print_mem_block_lists+0x184>
  802145:	83 ec 0c             	sub    $0xc,%esp
  802148:	68 ac 3c 80 00       	push   $0x803cac
  80214d:	e8 d0 e4 ff ff       	call   800622 <cprintf>
  802152:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802155:	83 ec 0c             	sub    $0xc,%esp
  802158:	68 20 3c 80 00       	push   $0x803c20
  80215d:	e8 c0 e4 ff ff       	call   800622 <cprintf>
  802162:	83 c4 10             	add    $0x10,%esp

}
  802165:	90                   	nop
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80216e:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802175:	00 00 00 
  802178:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80217f:	00 00 00 
  802182:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802189:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80218c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802193:	e9 9e 00 00 00       	jmp    802236 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802198:	a1 50 40 80 00       	mov    0x804050,%eax
  80219d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021a0:	c1 e2 04             	shl    $0x4,%edx
  8021a3:	01 d0                	add    %edx,%eax
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	75 14                	jne    8021bd <initialize_MemBlocksList+0x55>
  8021a9:	83 ec 04             	sub    $0x4,%esp
  8021ac:	68 d4 3c 80 00       	push   $0x803cd4
  8021b1:	6a 3d                	push   $0x3d
  8021b3:	68 f7 3c 80 00       	push   $0x803cf7
  8021b8:	e8 69 0f 00 00       	call   803126 <_panic>
  8021bd:	a1 50 40 80 00       	mov    0x804050,%eax
  8021c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c5:	c1 e2 04             	shl    $0x4,%edx
  8021c8:	01 d0                	add    %edx,%eax
  8021ca:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021d0:	89 10                	mov    %edx,(%eax)
  8021d2:	8b 00                	mov    (%eax),%eax
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	74 18                	je     8021f0 <initialize_MemBlocksList+0x88>
  8021d8:	a1 48 41 80 00       	mov    0x804148,%eax
  8021dd:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021e3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021e6:	c1 e1 04             	shl    $0x4,%ecx
  8021e9:	01 ca                	add    %ecx,%edx
  8021eb:	89 50 04             	mov    %edx,0x4(%eax)
  8021ee:	eb 12                	jmp    802202 <initialize_MemBlocksList+0x9a>
  8021f0:	a1 50 40 80 00       	mov    0x804050,%eax
  8021f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f8:	c1 e2 04             	shl    $0x4,%edx
  8021fb:	01 d0                	add    %edx,%eax
  8021fd:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802202:	a1 50 40 80 00       	mov    0x804050,%eax
  802207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80220a:	c1 e2 04             	shl    $0x4,%edx
  80220d:	01 d0                	add    %edx,%eax
  80220f:	a3 48 41 80 00       	mov    %eax,0x804148
  802214:	a1 50 40 80 00       	mov    0x804050,%eax
  802219:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221c:	c1 e2 04             	shl    $0x4,%edx
  80221f:	01 d0                	add    %edx,%eax
  802221:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802228:	a1 54 41 80 00       	mov    0x804154,%eax
  80222d:	40                   	inc    %eax
  80222e:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802233:	ff 45 f4             	incl   -0xc(%ebp)
  802236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802239:	3b 45 08             	cmp    0x8(%ebp),%eax
  80223c:	0f 82 56 ff ff ff    	jb     802198 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802242:	90                   	nop
  802243:	c9                   	leave  
  802244:	c3                   	ret    

00802245 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	8b 00                	mov    (%eax),%eax
  802250:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802253:	eb 18                	jmp    80226d <find_block+0x28>

		if(tmp->sva == va){
  802255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802258:	8b 40 08             	mov    0x8(%eax),%eax
  80225b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80225e:	75 05                	jne    802265 <find_block+0x20>
			return tmp ;
  802260:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802263:	eb 11                	jmp    802276 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802265:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802268:	8b 00                	mov    (%eax),%eax
  80226a:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80226d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802271:	75 e2                	jne    802255 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802276:	c9                   	leave  
  802277:	c3                   	ret    

00802278 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802278:	55                   	push   %ebp
  802279:	89 e5                	mov    %esp,%ebp
  80227b:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80227e:	a1 40 40 80 00       	mov    0x804040,%eax
  802283:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802286:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80228b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  80228e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802292:	75 65                	jne    8022f9 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802294:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802298:	75 14                	jne    8022ae <insert_sorted_allocList+0x36>
  80229a:	83 ec 04             	sub    $0x4,%esp
  80229d:	68 d4 3c 80 00       	push   $0x803cd4
  8022a2:	6a 62                	push   $0x62
  8022a4:	68 f7 3c 80 00       	push   $0x803cf7
  8022a9:	e8 78 0e 00 00       	call   803126 <_panic>
  8022ae:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	89 10                	mov    %edx,(%eax)
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	8b 00                	mov    (%eax),%eax
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	74 0d                	je     8022cf <insert_sorted_allocList+0x57>
  8022c2:	a1 40 40 80 00       	mov    0x804040,%eax
  8022c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ca:	89 50 04             	mov    %edx,0x4(%eax)
  8022cd:	eb 08                	jmp    8022d7 <insert_sorted_allocList+0x5f>
  8022cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d2:	a3 44 40 80 00       	mov    %eax,0x804044
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	a3 40 40 80 00       	mov    %eax,0x804040
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022ee:	40                   	inc    %eax
  8022ef:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022f4:	e9 14 01 00 00       	jmp    80240d <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	8b 50 08             	mov    0x8(%eax),%edx
  8022ff:	a1 44 40 80 00       	mov    0x804044,%eax
  802304:	8b 40 08             	mov    0x8(%eax),%eax
  802307:	39 c2                	cmp    %eax,%edx
  802309:	76 65                	jbe    802370 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80230b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80230f:	75 14                	jne    802325 <insert_sorted_allocList+0xad>
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	68 10 3d 80 00       	push   $0x803d10
  802319:	6a 64                	push   $0x64
  80231b:	68 f7 3c 80 00       	push   $0x803cf7
  802320:	e8 01 0e 00 00       	call   803126 <_panic>
  802325:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80232b:	8b 45 08             	mov    0x8(%ebp),%eax
  80232e:	89 50 04             	mov    %edx,0x4(%eax)
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	8b 40 04             	mov    0x4(%eax),%eax
  802337:	85 c0                	test   %eax,%eax
  802339:	74 0c                	je     802347 <insert_sorted_allocList+0xcf>
  80233b:	a1 44 40 80 00       	mov    0x804044,%eax
  802340:	8b 55 08             	mov    0x8(%ebp),%edx
  802343:	89 10                	mov    %edx,(%eax)
  802345:	eb 08                	jmp    80234f <insert_sorted_allocList+0xd7>
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	a3 40 40 80 00       	mov    %eax,0x804040
  80234f:	8b 45 08             	mov    0x8(%ebp),%eax
  802352:	a3 44 40 80 00       	mov    %eax,0x804044
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802360:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802365:	40                   	inc    %eax
  802366:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80236b:	e9 9d 00 00 00       	jmp    80240d <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802370:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802377:	e9 85 00 00 00       	jmp    802401 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80237c:	8b 45 08             	mov    0x8(%ebp),%eax
  80237f:	8b 50 08             	mov    0x8(%eax),%edx
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 40 08             	mov    0x8(%eax),%eax
  802388:	39 c2                	cmp    %eax,%edx
  80238a:	73 6a                	jae    8023f6 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  80238c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802390:	74 06                	je     802398 <insert_sorted_allocList+0x120>
  802392:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802396:	75 14                	jne    8023ac <insert_sorted_allocList+0x134>
  802398:	83 ec 04             	sub    $0x4,%esp
  80239b:	68 34 3d 80 00       	push   $0x803d34
  8023a0:	6a 6b                	push   $0x6b
  8023a2:	68 f7 3c 80 00       	push   $0x803cf7
  8023a7:	e8 7a 0d 00 00       	call   803126 <_panic>
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 50 04             	mov    0x4(%eax),%edx
  8023b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b5:	89 50 04             	mov    %edx,0x4(%eax)
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023be:	89 10                	mov    %edx,(%eax)
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 40 04             	mov    0x4(%eax),%eax
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	74 0d                	je     8023d7 <insert_sorted_allocList+0x15f>
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 04             	mov    0x4(%eax),%eax
  8023d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d3:	89 10                	mov    %edx,(%eax)
  8023d5:	eb 08                	jmp    8023df <insert_sorted_allocList+0x167>
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	a3 40 40 80 00       	mov    %eax,0x804040
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e5:	89 50 04             	mov    %edx,0x4(%eax)
  8023e8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023ed:	40                   	inc    %eax
  8023ee:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  8023f3:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8023f4:	eb 17                	jmp    80240d <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8023f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8023fe:	ff 45 f0             	incl   -0x10(%ebp)
  802401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802404:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802407:	0f 8c 6f ff ff ff    	jl     80237c <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80240d:	90                   	nop
  80240e:	c9                   	leave  
  80240f:	c3                   	ret    

00802410 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802416:	a1 38 41 80 00       	mov    0x804138,%eax
  80241b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80241e:	e9 7c 01 00 00       	jmp    80259f <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 40 0c             	mov    0xc(%eax),%eax
  802429:	3b 45 08             	cmp    0x8(%ebp),%eax
  80242c:	0f 86 cf 00 00 00    	jbe    802501 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802432:	a1 48 41 80 00       	mov    0x804148,%eax
  802437:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80243a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243d:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802440:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802443:	8b 55 08             	mov    0x8(%ebp),%edx
  802446:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 50 08             	mov    0x8(%eax),%edx
  80244f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802452:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802458:	8b 40 0c             	mov    0xc(%eax),%eax
  80245b:	2b 45 08             	sub    0x8(%ebp),%eax
  80245e:	89 c2                	mov    %eax,%edx
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 50 08             	mov    0x8(%eax),%edx
  80246c:	8b 45 08             	mov    0x8(%ebp),%eax
  80246f:	01 c2                	add    %eax,%edx
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802477:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80247b:	75 17                	jne    802494 <alloc_block_FF+0x84>
  80247d:	83 ec 04             	sub    $0x4,%esp
  802480:	68 69 3d 80 00       	push   $0x803d69
  802485:	68 83 00 00 00       	push   $0x83
  80248a:	68 f7 3c 80 00       	push   $0x803cf7
  80248f:	e8 92 0c 00 00       	call   803126 <_panic>
  802494:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	74 10                	je     8024ad <alloc_block_FF+0x9d>
  80249d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a0:	8b 00                	mov    (%eax),%eax
  8024a2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024a5:	8b 52 04             	mov    0x4(%edx),%edx
  8024a8:	89 50 04             	mov    %edx,0x4(%eax)
  8024ab:	eb 0b                	jmp    8024b8 <alloc_block_FF+0xa8>
  8024ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b0:	8b 40 04             	mov    0x4(%eax),%eax
  8024b3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024bb:	8b 40 04             	mov    0x4(%eax),%eax
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	74 0f                	je     8024d1 <alloc_block_FF+0xc1>
  8024c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c5:	8b 40 04             	mov    0x4(%eax),%eax
  8024c8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024cb:	8b 12                	mov    (%edx),%edx
  8024cd:	89 10                	mov    %edx,(%eax)
  8024cf:	eb 0a                	jmp    8024db <alloc_block_FF+0xcb>
  8024d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d4:	8b 00                	mov    (%eax),%eax
  8024d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8024db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ee:	a1 54 41 80 00       	mov    0x804154,%eax
  8024f3:	48                   	dec    %eax
  8024f4:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  8024f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024fc:	e9 ad 00 00 00       	jmp    8025ae <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802504:	8b 40 0c             	mov    0xc(%eax),%eax
  802507:	3b 45 08             	cmp    0x8(%ebp),%eax
  80250a:	0f 85 87 00 00 00    	jne    802597 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802514:	75 17                	jne    80252d <alloc_block_FF+0x11d>
  802516:	83 ec 04             	sub    $0x4,%esp
  802519:	68 69 3d 80 00       	push   $0x803d69
  80251e:	68 87 00 00 00       	push   $0x87
  802523:	68 f7 3c 80 00       	push   $0x803cf7
  802528:	e8 f9 0b 00 00       	call   803126 <_panic>
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 00                	mov    (%eax),%eax
  802532:	85 c0                	test   %eax,%eax
  802534:	74 10                	je     802546 <alloc_block_FF+0x136>
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253e:	8b 52 04             	mov    0x4(%edx),%edx
  802541:	89 50 04             	mov    %edx,0x4(%eax)
  802544:	eb 0b                	jmp    802551 <alloc_block_FF+0x141>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 04             	mov    0x4(%eax),%eax
  80254c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 40 04             	mov    0x4(%eax),%eax
  802557:	85 c0                	test   %eax,%eax
  802559:	74 0f                	je     80256a <alloc_block_FF+0x15a>
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	8b 40 04             	mov    0x4(%eax),%eax
  802561:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802564:	8b 12                	mov    (%edx),%edx
  802566:	89 10                	mov    %edx,(%eax)
  802568:	eb 0a                	jmp    802574 <alloc_block_FF+0x164>
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 00                	mov    (%eax),%eax
  80256f:	a3 38 41 80 00       	mov    %eax,0x804138
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802587:	a1 44 41 80 00       	mov    0x804144,%eax
  80258c:	48                   	dec    %eax
  80258d:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	eb 17                	jmp    8025ae <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	8b 00                	mov    (%eax),%eax
  80259c:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  80259f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a3:	0f 85 7a fe ff ff    	jne    802423 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8025a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ae:	c9                   	leave  
  8025af:	c3                   	ret    

008025b0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8025b6:	a1 38 41 80 00       	mov    0x804138,%eax
  8025bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8025be:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8025c5:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025cc:	a1 38 41 80 00       	mov    0x804138,%eax
  8025d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d4:	e9 d0 00 00 00       	jmp    8026a9 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e2:	0f 82 b8 00 00 00    	jb     8026a0 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8025e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ee:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8025f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025fa:	0f 83 a1 00 00 00    	jae    8026a1 <alloc_block_BF+0xf1>
				differsize = differance ;
  802600:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802603:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80260c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802610:	0f 85 8b 00 00 00    	jne    8026a1 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261a:	75 17                	jne    802633 <alloc_block_BF+0x83>
  80261c:	83 ec 04             	sub    $0x4,%esp
  80261f:	68 69 3d 80 00       	push   $0x803d69
  802624:	68 a0 00 00 00       	push   $0xa0
  802629:	68 f7 3c 80 00       	push   $0x803cf7
  80262e:	e8 f3 0a 00 00       	call   803126 <_panic>
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	85 c0                	test   %eax,%eax
  80263a:	74 10                	je     80264c <alloc_block_BF+0x9c>
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 00                	mov    (%eax),%eax
  802641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802644:	8b 52 04             	mov    0x4(%edx),%edx
  802647:	89 50 04             	mov    %edx,0x4(%eax)
  80264a:	eb 0b                	jmp    802657 <alloc_block_BF+0xa7>
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 04             	mov    0x4(%eax),%eax
  802652:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 04             	mov    0x4(%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 0f                	je     802670 <alloc_block_BF+0xc0>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266a:	8b 12                	mov    (%edx),%edx
  80266c:	89 10                	mov    %edx,(%eax)
  80266e:	eb 0a                	jmp    80267a <alloc_block_BF+0xca>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	a3 38 41 80 00       	mov    %eax,0x804138
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268d:	a1 44 41 80 00       	mov    0x804144,%eax
  802692:	48                   	dec    %eax
  802693:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	e9 0c 01 00 00       	jmp    8027ac <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8026a0:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8026a1:	a1 40 41 80 00       	mov    0x804140,%eax
  8026a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ad:	74 07                	je     8026b6 <alloc_block_BF+0x106>
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 00                	mov    (%eax),%eax
  8026b4:	eb 05                	jmp    8026bb <alloc_block_BF+0x10b>
  8026b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026bb:	a3 40 41 80 00       	mov    %eax,0x804140
  8026c0:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	0f 85 0c ff ff ff    	jne    8025d9 <alloc_block_BF+0x29>
  8026cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d1:	0f 85 02 ff ff ff    	jne    8025d9 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8026d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026db:	0f 84 c6 00 00 00    	je     8027a7 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8026e1:	a1 48 41 80 00       	mov    0x804148,%eax
  8026e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8026e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ef:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8026f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f5:	8b 50 08             	mov    0x8(%eax),%edx
  8026f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026fb:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  8026fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802701:	8b 40 0c             	mov    0xc(%eax),%eax
  802704:	2b 45 08             	sub    0x8(%ebp),%eax
  802707:	89 c2                	mov    %eax,%edx
  802709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270c:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80270f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802712:	8b 50 08             	mov    0x8(%eax),%edx
  802715:	8b 45 08             	mov    0x8(%ebp),%eax
  802718:	01 c2                	add    %eax,%edx
  80271a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271d:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802720:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802724:	75 17                	jne    80273d <alloc_block_BF+0x18d>
  802726:	83 ec 04             	sub    $0x4,%esp
  802729:	68 69 3d 80 00       	push   $0x803d69
  80272e:	68 af 00 00 00       	push   $0xaf
  802733:	68 f7 3c 80 00       	push   $0x803cf7
  802738:	e8 e9 09 00 00       	call   803126 <_panic>
  80273d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	85 c0                	test   %eax,%eax
  802744:	74 10                	je     802756 <alloc_block_BF+0x1a6>
  802746:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80274e:	8b 52 04             	mov    0x4(%edx),%edx
  802751:	89 50 04             	mov    %edx,0x4(%eax)
  802754:	eb 0b                	jmp    802761 <alloc_block_BF+0x1b1>
  802756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802759:	8b 40 04             	mov    0x4(%eax),%eax
  80275c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802761:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802764:	8b 40 04             	mov    0x4(%eax),%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	74 0f                	je     80277a <alloc_block_BF+0x1ca>
  80276b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276e:	8b 40 04             	mov    0x4(%eax),%eax
  802771:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802774:	8b 12                	mov    (%edx),%edx
  802776:	89 10                	mov    %edx,(%eax)
  802778:	eb 0a                	jmp    802784 <alloc_block_BF+0x1d4>
  80277a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277d:	8b 00                	mov    (%eax),%eax
  80277f:	a3 48 41 80 00       	mov    %eax,0x804148
  802784:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802787:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802790:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802797:	a1 54 41 80 00       	mov    0x804154,%eax
  80279c:	48                   	dec    %eax
  80279d:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8027a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a5:	eb 05                	jmp    8027ac <alloc_block_BF+0x1fc>
	}

	return NULL;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8027b4:	a1 38 41 80 00       	mov    0x804138,%eax
  8027b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8027bc:	e9 7c 01 00 00       	jmp    80293d <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ca:	0f 86 cf 00 00 00    	jbe    80289f <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8027d0:	a1 48 41 80 00       	mov    0x804148,%eax
  8027d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8027de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e4:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 50 08             	mov    0x8(%eax),%edx
  8027ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f0:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8027f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f9:	2b 45 08             	sub    0x8(%ebp),%eax
  8027fc:	89 c2                	mov    %eax,%edx
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802807:	8b 50 08             	mov    0x8(%eax),%edx
  80280a:	8b 45 08             	mov    0x8(%ebp),%eax
  80280d:	01 c2                	add    %eax,%edx
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802815:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802819:	75 17                	jne    802832 <alloc_block_NF+0x84>
  80281b:	83 ec 04             	sub    $0x4,%esp
  80281e:	68 69 3d 80 00       	push   $0x803d69
  802823:	68 c4 00 00 00       	push   $0xc4
  802828:	68 f7 3c 80 00       	push   $0x803cf7
  80282d:	e8 f4 08 00 00       	call   803126 <_panic>
  802832:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802835:	8b 00                	mov    (%eax),%eax
  802837:	85 c0                	test   %eax,%eax
  802839:	74 10                	je     80284b <alloc_block_NF+0x9d>
  80283b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283e:	8b 00                	mov    (%eax),%eax
  802840:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802843:	8b 52 04             	mov    0x4(%edx),%edx
  802846:	89 50 04             	mov    %edx,0x4(%eax)
  802849:	eb 0b                	jmp    802856 <alloc_block_NF+0xa8>
  80284b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284e:	8b 40 04             	mov    0x4(%eax),%eax
  802851:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802856:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802859:	8b 40 04             	mov    0x4(%eax),%eax
  80285c:	85 c0                	test   %eax,%eax
  80285e:	74 0f                	je     80286f <alloc_block_NF+0xc1>
  802860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802863:	8b 40 04             	mov    0x4(%eax),%eax
  802866:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802869:	8b 12                	mov    (%edx),%edx
  80286b:	89 10                	mov    %edx,(%eax)
  80286d:	eb 0a                	jmp    802879 <alloc_block_NF+0xcb>
  80286f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802872:	8b 00                	mov    (%eax),%eax
  802874:	a3 48 41 80 00       	mov    %eax,0x804148
  802879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802885:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288c:	a1 54 41 80 00       	mov    0x804154,%eax
  802891:	48                   	dec    %eax
  802892:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  802897:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289a:	e9 ad 00 00 00       	jmp    80294c <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  80289f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a8:	0f 85 87 00 00 00    	jne    802935 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8028ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028b2:	75 17                	jne    8028cb <alloc_block_NF+0x11d>
  8028b4:	83 ec 04             	sub    $0x4,%esp
  8028b7:	68 69 3d 80 00       	push   $0x803d69
  8028bc:	68 c8 00 00 00       	push   $0xc8
  8028c1:	68 f7 3c 80 00       	push   $0x803cf7
  8028c6:	e8 5b 08 00 00       	call   803126 <_panic>
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 00                	mov    (%eax),%eax
  8028d0:	85 c0                	test   %eax,%eax
  8028d2:	74 10                	je     8028e4 <alloc_block_NF+0x136>
  8028d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028dc:	8b 52 04             	mov    0x4(%edx),%edx
  8028df:	89 50 04             	mov    %edx,0x4(%eax)
  8028e2:	eb 0b                	jmp    8028ef <alloc_block_NF+0x141>
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0f                	je     802908 <alloc_block_NF+0x15a>
  8028f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fc:	8b 40 04             	mov    0x4(%eax),%eax
  8028ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802902:	8b 12                	mov    (%edx),%edx
  802904:	89 10                	mov    %edx,(%eax)
  802906:	eb 0a                	jmp    802912 <alloc_block_NF+0x164>
  802908:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290b:	8b 00                	mov    (%eax),%eax
  80290d:	a3 38 41 80 00       	mov    %eax,0x804138
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802925:	a1 44 41 80 00       	mov    0x804144,%eax
  80292a:	48                   	dec    %eax
  80292b:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802933:	eb 17                	jmp    80294c <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802935:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802938:	8b 00                	mov    (%eax),%eax
  80293a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  80293d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802941:	0f 85 7a fe ff ff    	jne    8027c1 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802947:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80294c:	c9                   	leave  
  80294d:	c3                   	ret    

0080294e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802954:	a1 38 41 80 00       	mov    0x804138,%eax
  802959:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  80295c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802961:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802964:	a1 44 41 80 00       	mov    0x804144,%eax
  802969:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  80296c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802970:	75 68                	jne    8029da <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802972:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802976:	75 17                	jne    80298f <insert_sorted_with_merge_freeList+0x41>
  802978:	83 ec 04             	sub    $0x4,%esp
  80297b:	68 d4 3c 80 00       	push   $0x803cd4
  802980:	68 da 00 00 00       	push   $0xda
  802985:	68 f7 3c 80 00       	push   $0x803cf7
  80298a:	e8 97 07 00 00       	call   803126 <_panic>
  80298f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	89 10                	mov    %edx,(%eax)
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	74 0d                	je     8029b0 <insert_sorted_with_merge_freeList+0x62>
  8029a3:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ab:	89 50 04             	mov    %edx,0x4(%eax)
  8029ae:	eb 08                	jmp    8029b8 <insert_sorted_with_merge_freeList+0x6a>
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	a3 38 41 80 00       	mov    %eax,0x804138
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ca:	a1 44 41 80 00       	mov    0x804144,%eax
  8029cf:	40                   	inc    %eax
  8029d0:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8029d5:	e9 49 07 00 00       	jmp    803123 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e6:	01 c2                	add    %eax,%edx
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	8b 40 08             	mov    0x8(%eax),%eax
  8029ee:	39 c2                	cmp    %eax,%edx
  8029f0:	73 77                	jae    802a69 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8029f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f5:	8b 00                	mov    (%eax),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	75 6e                	jne    802a69 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8029fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ff:	74 68                	je     802a69 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802a01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a05:	75 17                	jne    802a1e <insert_sorted_with_merge_freeList+0xd0>
  802a07:	83 ec 04             	sub    $0x4,%esp
  802a0a:	68 10 3d 80 00       	push   $0x803d10
  802a0f:	68 e0 00 00 00       	push   $0xe0
  802a14:	68 f7 3c 80 00       	push   $0x803cf7
  802a19:	e8 08 07 00 00       	call   803126 <_panic>
  802a1e:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	89 50 04             	mov    %edx,0x4(%eax)
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	8b 40 04             	mov    0x4(%eax),%eax
  802a30:	85 c0                	test   %eax,%eax
  802a32:	74 0c                	je     802a40 <insert_sorted_with_merge_freeList+0xf2>
  802a34:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a39:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3c:	89 10                	mov    %edx,(%eax)
  802a3e:	eb 08                	jmp    802a48 <insert_sorted_with_merge_freeList+0xfa>
  802a40:	8b 45 08             	mov    0x8(%ebp),%eax
  802a43:	a3 38 41 80 00       	mov    %eax,0x804138
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a59:	a1 44 41 80 00       	mov    0x804144,%eax
  802a5e:	40                   	inc    %eax
  802a5f:	a3 44 41 80 00       	mov    %eax,0x804144
  802a64:	e9 ba 06 00 00       	jmp    803123 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	8b 50 0c             	mov    0xc(%eax),%edx
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	8b 40 08             	mov    0x8(%eax),%eax
  802a75:	01 c2                	add    %eax,%edx
  802a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7a:	8b 40 08             	mov    0x8(%eax),%eax
  802a7d:	39 c2                	cmp    %eax,%edx
  802a7f:	73 78                	jae    802af9 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 04             	mov    0x4(%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	75 6e                	jne    802af9 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802a8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a8f:	74 68                	je     802af9 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802a91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a95:	75 17                	jne    802aae <insert_sorted_with_merge_freeList+0x160>
  802a97:	83 ec 04             	sub    $0x4,%esp
  802a9a:	68 d4 3c 80 00       	push   $0x803cd4
  802a9f:	68 e6 00 00 00       	push   $0xe6
  802aa4:	68 f7 3c 80 00       	push   $0x803cf7
  802aa9:	e8 78 06 00 00       	call   803126 <_panic>
  802aae:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	89 10                	mov    %edx,(%eax)
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 0d                	je     802acf <insert_sorted_with_merge_freeList+0x181>
  802ac2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aca:	89 50 04             	mov    %edx,0x4(%eax)
  802acd:	eb 08                	jmp    802ad7 <insert_sorted_with_merge_freeList+0x189>
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	a3 38 41 80 00       	mov    %eax,0x804138
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae9:	a1 44 41 80 00       	mov    0x804144,%eax
  802aee:	40                   	inc    %eax
  802aef:	a3 44 41 80 00       	mov    %eax,0x804144
  802af4:	e9 2a 06 00 00       	jmp    803123 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802af9:	a1 38 41 80 00       	mov    0x804138,%eax
  802afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b01:	e9 ed 05 00 00       	jmp    8030f3 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 00                	mov    (%eax),%eax
  802b0b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802b0e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b12:	0f 84 a7 00 00 00    	je     802bbf <insert_sorted_with_merge_freeList+0x271>
  802b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1b:	8b 50 0c             	mov    0xc(%eax),%edx
  802b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b21:	8b 40 08             	mov    0x8(%eax),%eax
  802b24:	01 c2                	add    %eax,%edx
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	8b 40 08             	mov    0x8(%eax),%eax
  802b2c:	39 c2                	cmp    %eax,%edx
  802b2e:	0f 83 8b 00 00 00    	jae    802bbf <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	8b 50 0c             	mov    0xc(%eax),%edx
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	8b 40 08             	mov    0x8(%eax),%eax
  802b40:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802b42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b45:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802b48:	39 c2                	cmp    %eax,%edx
  802b4a:	73 73                	jae    802bbf <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802b4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b50:	74 06                	je     802b58 <insert_sorted_with_merge_freeList+0x20a>
  802b52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b56:	75 17                	jne    802b6f <insert_sorted_with_merge_freeList+0x221>
  802b58:	83 ec 04             	sub    $0x4,%esp
  802b5b:	68 88 3d 80 00       	push   $0x803d88
  802b60:	68 f0 00 00 00       	push   $0xf0
  802b65:	68 f7 3c 80 00       	push   $0x803cf7
  802b6a:	e8 b7 05 00 00       	call   803126 <_panic>
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	8b 10                	mov    (%eax),%edx
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	89 10                	mov    %edx,(%eax)
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	8b 00                	mov    (%eax),%eax
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	74 0b                	je     802b8d <insert_sorted_with_merge_freeList+0x23f>
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 00                	mov    (%eax),%eax
  802b87:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8a:	89 50 04             	mov    %edx,0x4(%eax)
  802b8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b90:	8b 55 08             	mov    0x8(%ebp),%edx
  802b93:	89 10                	mov    %edx,(%eax)
  802b95:	8b 45 08             	mov    0x8(%ebp),%eax
  802b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b9b:	89 50 04             	mov    %edx,0x4(%eax)
  802b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba1:	8b 00                	mov    (%eax),%eax
  802ba3:	85 c0                	test   %eax,%eax
  802ba5:	75 08                	jne    802baf <insert_sorted_with_merge_freeList+0x261>
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802baf:	a1 44 41 80 00       	mov    0x804144,%eax
  802bb4:	40                   	inc    %eax
  802bb5:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802bba:	e9 64 05 00 00       	jmp    803123 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802bbf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bc4:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bcc:	8b 40 08             	mov    0x8(%eax),%eax
  802bcf:	01 c2                	add    %eax,%edx
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	8b 40 08             	mov    0x8(%eax),%eax
  802bd7:	39 c2                	cmp    %eax,%edx
  802bd9:	0f 85 b1 00 00 00    	jne    802c90 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802bdf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802be4:	85 c0                	test   %eax,%eax
  802be6:	0f 84 a4 00 00 00    	je     802c90 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802bec:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bf1:	8b 00                	mov    (%eax),%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	0f 85 95 00 00 00    	jne    802c90 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802bfb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c00:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c06:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c09:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0c:	8b 52 0c             	mov    0xc(%edx),%edx
  802c0f:	01 ca                	add    %ecx,%edx
  802c11:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2c:	75 17                	jne    802c45 <insert_sorted_with_merge_freeList+0x2f7>
  802c2e:	83 ec 04             	sub    $0x4,%esp
  802c31:	68 d4 3c 80 00       	push   $0x803cd4
  802c36:	68 ff 00 00 00       	push   $0xff
  802c3b:	68 f7 3c 80 00       	push   $0x803cf7
  802c40:	e8 e1 04 00 00       	call   803126 <_panic>
  802c45:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	89 10                	mov    %edx,(%eax)
  802c50:	8b 45 08             	mov    0x8(%ebp),%eax
  802c53:	8b 00                	mov    (%eax),%eax
  802c55:	85 c0                	test   %eax,%eax
  802c57:	74 0d                	je     802c66 <insert_sorted_with_merge_freeList+0x318>
  802c59:	a1 48 41 80 00       	mov    0x804148,%eax
  802c5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c61:	89 50 04             	mov    %edx,0x4(%eax)
  802c64:	eb 08                	jmp    802c6e <insert_sorted_with_merge_freeList+0x320>
  802c66:	8b 45 08             	mov    0x8(%ebp),%eax
  802c69:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	a3 48 41 80 00       	mov    %eax,0x804148
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c80:	a1 54 41 80 00       	mov    0x804154,%eax
  802c85:	40                   	inc    %eax
  802c86:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802c8b:	e9 93 04 00 00       	jmp    803123 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 50 08             	mov    0x8(%eax),%edx
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9c:	01 c2                	add    %eax,%edx
  802c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca1:	8b 40 08             	mov    0x8(%eax),%eax
  802ca4:	39 c2                	cmp    %eax,%edx
  802ca6:	0f 85 ae 00 00 00    	jne    802d5a <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb5:	8b 40 08             	mov    0x8(%eax),%eax
  802cb8:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbd:	8b 00                	mov    (%eax),%eax
  802cbf:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802cc2:	39 c2                	cmp    %eax,%edx
  802cc4:	0f 84 90 00 00 00    	je     802d5a <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd6:	01 c2                	add    %eax,%edx
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cde:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802cf2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf6:	75 17                	jne    802d0f <insert_sorted_with_merge_freeList+0x3c1>
  802cf8:	83 ec 04             	sub    $0x4,%esp
  802cfb:	68 d4 3c 80 00       	push   $0x803cd4
  802d00:	68 0b 01 00 00       	push   $0x10b
  802d05:	68 f7 3c 80 00       	push   $0x803cf7
  802d0a:	e8 17 04 00 00       	call   803126 <_panic>
  802d0f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	89 10                	mov    %edx,(%eax)
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	8b 00                	mov    (%eax),%eax
  802d1f:	85 c0                	test   %eax,%eax
  802d21:	74 0d                	je     802d30 <insert_sorted_with_merge_freeList+0x3e2>
  802d23:	a1 48 41 80 00       	mov    0x804148,%eax
  802d28:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2b:	89 50 04             	mov    %edx,0x4(%eax)
  802d2e:	eb 08                	jmp    802d38 <insert_sorted_with_merge_freeList+0x3ea>
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d4a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d4f:	40                   	inc    %eax
  802d50:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d55:	e9 c9 03 00 00       	jmp    803123 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	8b 40 08             	mov    0x8(%eax),%eax
  802d66:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d6e:	39 c2                	cmp    %eax,%edx
  802d70:	0f 85 bb 00 00 00    	jne    802e31 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802d76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7a:	0f 84 b1 00 00 00    	je     802e31 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	85 c0                	test   %eax,%eax
  802d88:	0f 85 a3 00 00 00    	jne    802e31 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802d8e:	a1 38 41 80 00       	mov    0x804138,%eax
  802d93:	8b 55 08             	mov    0x8(%ebp),%edx
  802d96:	8b 52 08             	mov    0x8(%edx),%edx
  802d99:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802d9c:	a1 38 41 80 00       	mov    0x804138,%eax
  802da1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802da7:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802daa:	8b 55 08             	mov    0x8(%ebp),%edx
  802dad:	8b 52 0c             	mov    0xc(%edx),%edx
  802db0:	01 ca                	add    %ecx,%edx
  802db2:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802dc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dcd:	75 17                	jne    802de6 <insert_sorted_with_merge_freeList+0x498>
  802dcf:	83 ec 04             	sub    $0x4,%esp
  802dd2:	68 d4 3c 80 00       	push   $0x803cd4
  802dd7:	68 17 01 00 00       	push   $0x117
  802ddc:	68 f7 3c 80 00       	push   $0x803cf7
  802de1:	e8 40 03 00 00       	call   803126 <_panic>
  802de6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	89 10                	mov    %edx,(%eax)
  802df1:	8b 45 08             	mov    0x8(%ebp),%eax
  802df4:	8b 00                	mov    (%eax),%eax
  802df6:	85 c0                	test   %eax,%eax
  802df8:	74 0d                	je     802e07 <insert_sorted_with_merge_freeList+0x4b9>
  802dfa:	a1 48 41 80 00       	mov    0x804148,%eax
  802dff:	8b 55 08             	mov    0x8(%ebp),%edx
  802e02:	89 50 04             	mov    %edx,0x4(%eax)
  802e05:	eb 08                	jmp    802e0f <insert_sorted_with_merge_freeList+0x4c1>
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	a3 48 41 80 00       	mov    %eax,0x804148
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e21:	a1 54 41 80 00       	mov    0x804154,%eax
  802e26:	40                   	inc    %eax
  802e27:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802e2c:	e9 f2 02 00 00       	jmp    803123 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	8b 50 08             	mov    0x8(%eax),%edx
  802e37:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3d:	01 c2                	add    %eax,%edx
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	8b 40 08             	mov    0x8(%eax),%eax
  802e45:	39 c2                	cmp    %eax,%edx
  802e47:	0f 85 be 00 00 00    	jne    802f0b <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	8b 40 04             	mov    0x4(%eax),%eax
  802e53:	8b 50 08             	mov    0x8(%eax),%edx
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	8b 40 04             	mov    0x4(%eax),%eax
  802e5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5f:	01 c2                	add    %eax,%edx
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	8b 40 08             	mov    0x8(%eax),%eax
  802e67:	39 c2                	cmp    %eax,%edx
  802e69:	0f 84 9c 00 00 00    	je     802f0b <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	8b 50 08             	mov    0x8(%eax),%edx
  802e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e78:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	8b 40 0c             	mov    0xc(%eax),%eax
  802e87:	01 c2                	add    %eax,%edx
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802ea3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea7:	75 17                	jne    802ec0 <insert_sorted_with_merge_freeList+0x572>
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 d4 3c 80 00       	push   $0x803cd4
  802eb1:	68 26 01 00 00       	push   $0x126
  802eb6:	68 f7 3c 80 00       	push   $0x803cf7
  802ebb:	e8 66 02 00 00       	call   803126 <_panic>
  802ec0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	89 10                	mov    %edx,(%eax)
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	8b 00                	mov    (%eax),%eax
  802ed0:	85 c0                	test   %eax,%eax
  802ed2:	74 0d                	je     802ee1 <insert_sorted_with_merge_freeList+0x593>
  802ed4:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  802edc:	89 50 04             	mov    %edx,0x4(%eax)
  802edf:	eb 08                	jmp    802ee9 <insert_sorted_with_merge_freeList+0x59b>
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	a3 48 41 80 00       	mov    %eax,0x804148
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efb:	a1 54 41 80 00       	mov    0x804154,%eax
  802f00:	40                   	inc    %eax
  802f01:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802f06:	e9 18 02 00 00       	jmp    803123 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	8b 40 08             	mov    0x8(%eax),%eax
  802f17:	01 c2                	add    %eax,%edx
  802f19:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1c:	8b 40 08             	mov    0x8(%eax),%eax
  802f1f:	39 c2                	cmp    %eax,%edx
  802f21:	0f 85 c4 01 00 00    	jne    8030eb <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f30:	8b 40 08             	mov    0x8(%eax),%eax
  802f33:	01 c2                	add    %eax,%edx
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	8b 40 08             	mov    0x8(%eax),%eax
  802f3d:	39 c2                	cmp    %eax,%edx
  802f3f:	0f 85 a6 01 00 00    	jne    8030eb <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802f45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f49:	0f 84 9c 01 00 00    	je     8030eb <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f52:	8b 50 0c             	mov    0xc(%eax),%edx
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5b:	01 c2                	add    %eax,%edx
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	8b 00                	mov    (%eax),%eax
  802f62:	8b 40 0c             	mov    0xc(%eax),%eax
  802f65:	01 c2                	add    %eax,%edx
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802f81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f85:	75 17                	jne    802f9e <insert_sorted_with_merge_freeList+0x650>
  802f87:	83 ec 04             	sub    $0x4,%esp
  802f8a:	68 d4 3c 80 00       	push   $0x803cd4
  802f8f:	68 32 01 00 00       	push   $0x132
  802f94:	68 f7 3c 80 00       	push   $0x803cf7
  802f99:	e8 88 01 00 00       	call   803126 <_panic>
  802f9e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa7:	89 10                	mov    %edx,(%eax)
  802fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fac:	8b 00                	mov    (%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0d                	je     802fbf <insert_sorted_with_merge_freeList+0x671>
  802fb2:	a1 48 41 80 00       	mov    0x804148,%eax
  802fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fba:	89 50 04             	mov    %edx,0x4(%eax)
  802fbd:	eb 08                	jmp    802fc7 <insert_sorted_with_merge_freeList+0x679>
  802fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	a3 48 41 80 00       	mov    %eax,0x804148
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd9:	a1 54 41 80 00       	mov    0x804154,%eax
  802fde:	40                   	inc    %eax
  802fdf:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802fe4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe7:	8b 00                	mov    (%eax),%eax
  802fe9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803004:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803008:	75 17                	jne    803021 <insert_sorted_with_merge_freeList+0x6d3>
  80300a:	83 ec 04             	sub    $0x4,%esp
  80300d:	68 69 3d 80 00       	push   $0x803d69
  803012:	68 36 01 00 00       	push   $0x136
  803017:	68 f7 3c 80 00       	push   $0x803cf7
  80301c:	e8 05 01 00 00       	call   803126 <_panic>
  803021:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803024:	8b 00                	mov    (%eax),%eax
  803026:	85 c0                	test   %eax,%eax
  803028:	74 10                	je     80303a <insert_sorted_with_merge_freeList+0x6ec>
  80302a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302d:	8b 00                	mov    (%eax),%eax
  80302f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803032:	8b 52 04             	mov    0x4(%edx),%edx
  803035:	89 50 04             	mov    %edx,0x4(%eax)
  803038:	eb 0b                	jmp    803045 <insert_sorted_with_merge_freeList+0x6f7>
  80303a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303d:	8b 40 04             	mov    0x4(%eax),%eax
  803040:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803045:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803048:	8b 40 04             	mov    0x4(%eax),%eax
  80304b:	85 c0                	test   %eax,%eax
  80304d:	74 0f                	je     80305e <insert_sorted_with_merge_freeList+0x710>
  80304f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803052:	8b 40 04             	mov    0x4(%eax),%eax
  803055:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803058:	8b 12                	mov    (%edx),%edx
  80305a:	89 10                	mov    %edx,(%eax)
  80305c:	eb 0a                	jmp    803068 <insert_sorted_with_merge_freeList+0x71a>
  80305e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803061:	8b 00                	mov    (%eax),%eax
  803063:	a3 38 41 80 00       	mov    %eax,0x804138
  803068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803074:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80307b:	a1 44 41 80 00       	mov    0x804144,%eax
  803080:	48                   	dec    %eax
  803081:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803086:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80308a:	75 17                	jne    8030a3 <insert_sorted_with_merge_freeList+0x755>
  80308c:	83 ec 04             	sub    $0x4,%esp
  80308f:	68 d4 3c 80 00       	push   $0x803cd4
  803094:	68 37 01 00 00       	push   $0x137
  803099:	68 f7 3c 80 00       	push   $0x803cf7
  80309e:	e8 83 00 00 00       	call   803126 <_panic>
  8030a3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ac:	89 10                	mov    %edx,(%eax)
  8030ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b1:	8b 00                	mov    (%eax),%eax
  8030b3:	85 c0                	test   %eax,%eax
  8030b5:	74 0d                	je     8030c4 <insert_sorted_with_merge_freeList+0x776>
  8030b7:	a1 48 41 80 00       	mov    0x804148,%eax
  8030bc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030bf:	89 50 04             	mov    %edx,0x4(%eax)
  8030c2:	eb 08                	jmp    8030cc <insert_sorted_with_merge_freeList+0x77e>
  8030c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cf:	a3 48 41 80 00       	mov    %eax,0x804148
  8030d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030de:	a1 54 41 80 00       	mov    0x804154,%eax
  8030e3:	40                   	inc    %eax
  8030e4:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  8030e9:	eb 38                	jmp    803123 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8030eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8030f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f7:	74 07                	je     803100 <insert_sorted_with_merge_freeList+0x7b2>
  8030f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fc:	8b 00                	mov    (%eax),%eax
  8030fe:	eb 05                	jmp    803105 <insert_sorted_with_merge_freeList+0x7b7>
  803100:	b8 00 00 00 00       	mov    $0x0,%eax
  803105:	a3 40 41 80 00       	mov    %eax,0x804140
  80310a:	a1 40 41 80 00       	mov    0x804140,%eax
  80310f:	85 c0                	test   %eax,%eax
  803111:	0f 85 ef f9 ff ff    	jne    802b06 <insert_sorted_with_merge_freeList+0x1b8>
  803117:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80311b:	0f 85 e5 f9 ff ff    	jne    802b06 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803121:	eb 00                	jmp    803123 <insert_sorted_with_merge_freeList+0x7d5>
  803123:	90                   	nop
  803124:	c9                   	leave  
  803125:	c3                   	ret    

00803126 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  803126:	55                   	push   %ebp
  803127:	89 e5                	mov    %esp,%ebp
  803129:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80312c:	8d 45 10             	lea    0x10(%ebp),%eax
  80312f:	83 c0 04             	add    $0x4,%eax
  803132:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  803135:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80313a:	85 c0                	test   %eax,%eax
  80313c:	74 16                	je     803154 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80313e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  803143:	83 ec 08             	sub    $0x8,%esp
  803146:	50                   	push   %eax
  803147:	68 bc 3d 80 00       	push   $0x803dbc
  80314c:	e8 d1 d4 ff ff       	call   800622 <cprintf>
  803151:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  803154:	a1 00 40 80 00       	mov    0x804000,%eax
  803159:	ff 75 0c             	pushl  0xc(%ebp)
  80315c:	ff 75 08             	pushl  0x8(%ebp)
  80315f:	50                   	push   %eax
  803160:	68 c1 3d 80 00       	push   $0x803dc1
  803165:	e8 b8 d4 ff ff       	call   800622 <cprintf>
  80316a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80316d:	8b 45 10             	mov    0x10(%ebp),%eax
  803170:	83 ec 08             	sub    $0x8,%esp
  803173:	ff 75 f4             	pushl  -0xc(%ebp)
  803176:	50                   	push   %eax
  803177:	e8 3b d4 ff ff       	call   8005b7 <vcprintf>
  80317c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80317f:	83 ec 08             	sub    $0x8,%esp
  803182:	6a 00                	push   $0x0
  803184:	68 dd 3d 80 00       	push   $0x803ddd
  803189:	e8 29 d4 ff ff       	call   8005b7 <vcprintf>
  80318e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  803191:	e8 aa d3 ff ff       	call   800540 <exit>

	// should not return here
	while (1) ;
  803196:	eb fe                	jmp    803196 <_panic+0x70>

00803198 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  803198:	55                   	push   %ebp
  803199:	89 e5                	mov    %esp,%ebp
  80319b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80319e:	a1 20 40 80 00       	mov    0x804020,%eax
  8031a3:	8b 50 74             	mov    0x74(%eax),%edx
  8031a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031a9:	39 c2                	cmp    %eax,%edx
  8031ab:	74 14                	je     8031c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8031ad:	83 ec 04             	sub    $0x4,%esp
  8031b0:	68 e0 3d 80 00       	push   $0x803de0
  8031b5:	6a 26                	push   $0x26
  8031b7:	68 2c 3e 80 00       	push   $0x803e2c
  8031bc:	e8 65 ff ff ff       	call   803126 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8031c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8031c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8031cf:	e9 c2 00 00 00       	jmp    803296 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8031d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8031d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	01 d0                	add    %edx,%eax
  8031e3:	8b 00                	mov    (%eax),%eax
  8031e5:	85 c0                	test   %eax,%eax
  8031e7:	75 08                	jne    8031f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8031e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8031ec:	e9 a2 00 00 00       	jmp    803293 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8031f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8031f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8031ff:	eb 69                	jmp    80326a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803201:	a1 20 40 80 00       	mov    0x804020,%eax
  803206:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80320c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80320f:	89 d0                	mov    %edx,%eax
  803211:	01 c0                	add    %eax,%eax
  803213:	01 d0                	add    %edx,%eax
  803215:	c1 e0 03             	shl    $0x3,%eax
  803218:	01 c8                	add    %ecx,%eax
  80321a:	8a 40 04             	mov    0x4(%eax),%al
  80321d:	84 c0                	test   %al,%al
  80321f:	75 46                	jne    803267 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803221:	a1 20 40 80 00       	mov    0x804020,%eax
  803226:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80322c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80322f:	89 d0                	mov    %edx,%eax
  803231:	01 c0                	add    %eax,%eax
  803233:	01 d0                	add    %edx,%eax
  803235:	c1 e0 03             	shl    $0x3,%eax
  803238:	01 c8                	add    %ecx,%eax
  80323a:	8b 00                	mov    (%eax),%eax
  80323c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80323f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803242:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803247:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80324c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803253:	8b 45 08             	mov    0x8(%ebp),%eax
  803256:	01 c8                	add    %ecx,%eax
  803258:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80325a:	39 c2                	cmp    %eax,%edx
  80325c:	75 09                	jne    803267 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80325e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803265:	eb 12                	jmp    803279 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803267:	ff 45 e8             	incl   -0x18(%ebp)
  80326a:	a1 20 40 80 00       	mov    0x804020,%eax
  80326f:	8b 50 74             	mov    0x74(%eax),%edx
  803272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803275:	39 c2                	cmp    %eax,%edx
  803277:	77 88                	ja     803201 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803279:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80327d:	75 14                	jne    803293 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80327f:	83 ec 04             	sub    $0x4,%esp
  803282:	68 38 3e 80 00       	push   $0x803e38
  803287:	6a 3a                	push   $0x3a
  803289:	68 2c 3e 80 00       	push   $0x803e2c
  80328e:	e8 93 fe ff ff       	call   803126 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  803293:	ff 45 f0             	incl   -0x10(%ebp)
  803296:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803299:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80329c:	0f 8c 32 ff ff ff    	jl     8031d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8032a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8032b0:	eb 26                	jmp    8032d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8032b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8032b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8032bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8032c0:	89 d0                	mov    %edx,%eax
  8032c2:	01 c0                	add    %eax,%eax
  8032c4:	01 d0                	add    %edx,%eax
  8032c6:	c1 e0 03             	shl    $0x3,%eax
  8032c9:	01 c8                	add    %ecx,%eax
  8032cb:	8a 40 04             	mov    0x4(%eax),%al
  8032ce:	3c 01                	cmp    $0x1,%al
  8032d0:	75 03                	jne    8032d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8032d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8032d5:	ff 45 e0             	incl   -0x20(%ebp)
  8032d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8032dd:	8b 50 74             	mov    0x74(%eax),%edx
  8032e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8032e3:	39 c2                	cmp    %eax,%edx
  8032e5:	77 cb                	ja     8032b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8032e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8032ed:	74 14                	je     803303 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8032ef:	83 ec 04             	sub    $0x4,%esp
  8032f2:	68 8c 3e 80 00       	push   $0x803e8c
  8032f7:	6a 44                	push   $0x44
  8032f9:	68 2c 3e 80 00       	push   $0x803e2c
  8032fe:	e8 23 fe ff ff       	call   803126 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803303:	90                   	nop
  803304:	c9                   	leave  
  803305:	c3                   	ret    
  803306:	66 90                	xchg   %ax,%ax

00803308 <__udivdi3>:
  803308:	55                   	push   %ebp
  803309:	57                   	push   %edi
  80330a:	56                   	push   %esi
  80330b:	53                   	push   %ebx
  80330c:	83 ec 1c             	sub    $0x1c,%esp
  80330f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803313:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803317:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80331b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80331f:	89 ca                	mov    %ecx,%edx
  803321:	89 f8                	mov    %edi,%eax
  803323:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803327:	85 f6                	test   %esi,%esi
  803329:	75 2d                	jne    803358 <__udivdi3+0x50>
  80332b:	39 cf                	cmp    %ecx,%edi
  80332d:	77 65                	ja     803394 <__udivdi3+0x8c>
  80332f:	89 fd                	mov    %edi,%ebp
  803331:	85 ff                	test   %edi,%edi
  803333:	75 0b                	jne    803340 <__udivdi3+0x38>
  803335:	b8 01 00 00 00       	mov    $0x1,%eax
  80333a:	31 d2                	xor    %edx,%edx
  80333c:	f7 f7                	div    %edi
  80333e:	89 c5                	mov    %eax,%ebp
  803340:	31 d2                	xor    %edx,%edx
  803342:	89 c8                	mov    %ecx,%eax
  803344:	f7 f5                	div    %ebp
  803346:	89 c1                	mov    %eax,%ecx
  803348:	89 d8                	mov    %ebx,%eax
  80334a:	f7 f5                	div    %ebp
  80334c:	89 cf                	mov    %ecx,%edi
  80334e:	89 fa                	mov    %edi,%edx
  803350:	83 c4 1c             	add    $0x1c,%esp
  803353:	5b                   	pop    %ebx
  803354:	5e                   	pop    %esi
  803355:	5f                   	pop    %edi
  803356:	5d                   	pop    %ebp
  803357:	c3                   	ret    
  803358:	39 ce                	cmp    %ecx,%esi
  80335a:	77 28                	ja     803384 <__udivdi3+0x7c>
  80335c:	0f bd fe             	bsr    %esi,%edi
  80335f:	83 f7 1f             	xor    $0x1f,%edi
  803362:	75 40                	jne    8033a4 <__udivdi3+0x9c>
  803364:	39 ce                	cmp    %ecx,%esi
  803366:	72 0a                	jb     803372 <__udivdi3+0x6a>
  803368:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80336c:	0f 87 9e 00 00 00    	ja     803410 <__udivdi3+0x108>
  803372:	b8 01 00 00 00       	mov    $0x1,%eax
  803377:	89 fa                	mov    %edi,%edx
  803379:	83 c4 1c             	add    $0x1c,%esp
  80337c:	5b                   	pop    %ebx
  80337d:	5e                   	pop    %esi
  80337e:	5f                   	pop    %edi
  80337f:	5d                   	pop    %ebp
  803380:	c3                   	ret    
  803381:	8d 76 00             	lea    0x0(%esi),%esi
  803384:	31 ff                	xor    %edi,%edi
  803386:	31 c0                	xor    %eax,%eax
  803388:	89 fa                	mov    %edi,%edx
  80338a:	83 c4 1c             	add    $0x1c,%esp
  80338d:	5b                   	pop    %ebx
  80338e:	5e                   	pop    %esi
  80338f:	5f                   	pop    %edi
  803390:	5d                   	pop    %ebp
  803391:	c3                   	ret    
  803392:	66 90                	xchg   %ax,%ax
  803394:	89 d8                	mov    %ebx,%eax
  803396:	f7 f7                	div    %edi
  803398:	31 ff                	xor    %edi,%edi
  80339a:	89 fa                	mov    %edi,%edx
  80339c:	83 c4 1c             	add    $0x1c,%esp
  80339f:	5b                   	pop    %ebx
  8033a0:	5e                   	pop    %esi
  8033a1:	5f                   	pop    %edi
  8033a2:	5d                   	pop    %ebp
  8033a3:	c3                   	ret    
  8033a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8033a9:	89 eb                	mov    %ebp,%ebx
  8033ab:	29 fb                	sub    %edi,%ebx
  8033ad:	89 f9                	mov    %edi,%ecx
  8033af:	d3 e6                	shl    %cl,%esi
  8033b1:	89 c5                	mov    %eax,%ebp
  8033b3:	88 d9                	mov    %bl,%cl
  8033b5:	d3 ed                	shr    %cl,%ebp
  8033b7:	89 e9                	mov    %ebp,%ecx
  8033b9:	09 f1                	or     %esi,%ecx
  8033bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8033bf:	89 f9                	mov    %edi,%ecx
  8033c1:	d3 e0                	shl    %cl,%eax
  8033c3:	89 c5                	mov    %eax,%ebp
  8033c5:	89 d6                	mov    %edx,%esi
  8033c7:	88 d9                	mov    %bl,%cl
  8033c9:	d3 ee                	shr    %cl,%esi
  8033cb:	89 f9                	mov    %edi,%ecx
  8033cd:	d3 e2                	shl    %cl,%edx
  8033cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033d3:	88 d9                	mov    %bl,%cl
  8033d5:	d3 e8                	shr    %cl,%eax
  8033d7:	09 c2                	or     %eax,%edx
  8033d9:	89 d0                	mov    %edx,%eax
  8033db:	89 f2                	mov    %esi,%edx
  8033dd:	f7 74 24 0c          	divl   0xc(%esp)
  8033e1:	89 d6                	mov    %edx,%esi
  8033e3:	89 c3                	mov    %eax,%ebx
  8033e5:	f7 e5                	mul    %ebp
  8033e7:	39 d6                	cmp    %edx,%esi
  8033e9:	72 19                	jb     803404 <__udivdi3+0xfc>
  8033eb:	74 0b                	je     8033f8 <__udivdi3+0xf0>
  8033ed:	89 d8                	mov    %ebx,%eax
  8033ef:	31 ff                	xor    %edi,%edi
  8033f1:	e9 58 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  8033f6:	66 90                	xchg   %ax,%ax
  8033f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8033fc:	89 f9                	mov    %edi,%ecx
  8033fe:	d3 e2                	shl    %cl,%edx
  803400:	39 c2                	cmp    %eax,%edx
  803402:	73 e9                	jae    8033ed <__udivdi3+0xe5>
  803404:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803407:	31 ff                	xor    %edi,%edi
  803409:	e9 40 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  80340e:	66 90                	xchg   %ax,%ax
  803410:	31 c0                	xor    %eax,%eax
  803412:	e9 37 ff ff ff       	jmp    80334e <__udivdi3+0x46>
  803417:	90                   	nop

00803418 <__umoddi3>:
  803418:	55                   	push   %ebp
  803419:	57                   	push   %edi
  80341a:	56                   	push   %esi
  80341b:	53                   	push   %ebx
  80341c:	83 ec 1c             	sub    $0x1c,%esp
  80341f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803423:	8b 74 24 34          	mov    0x34(%esp),%esi
  803427:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80342f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803433:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803437:	89 f3                	mov    %esi,%ebx
  803439:	89 fa                	mov    %edi,%edx
  80343b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80343f:	89 34 24             	mov    %esi,(%esp)
  803442:	85 c0                	test   %eax,%eax
  803444:	75 1a                	jne    803460 <__umoddi3+0x48>
  803446:	39 f7                	cmp    %esi,%edi
  803448:	0f 86 a2 00 00 00    	jbe    8034f0 <__umoddi3+0xd8>
  80344e:	89 c8                	mov    %ecx,%eax
  803450:	89 f2                	mov    %esi,%edx
  803452:	f7 f7                	div    %edi
  803454:	89 d0                	mov    %edx,%eax
  803456:	31 d2                	xor    %edx,%edx
  803458:	83 c4 1c             	add    $0x1c,%esp
  80345b:	5b                   	pop    %ebx
  80345c:	5e                   	pop    %esi
  80345d:	5f                   	pop    %edi
  80345e:	5d                   	pop    %ebp
  80345f:	c3                   	ret    
  803460:	39 f0                	cmp    %esi,%eax
  803462:	0f 87 ac 00 00 00    	ja     803514 <__umoddi3+0xfc>
  803468:	0f bd e8             	bsr    %eax,%ebp
  80346b:	83 f5 1f             	xor    $0x1f,%ebp
  80346e:	0f 84 ac 00 00 00    	je     803520 <__umoddi3+0x108>
  803474:	bf 20 00 00 00       	mov    $0x20,%edi
  803479:	29 ef                	sub    %ebp,%edi
  80347b:	89 fe                	mov    %edi,%esi
  80347d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803481:	89 e9                	mov    %ebp,%ecx
  803483:	d3 e0                	shl    %cl,%eax
  803485:	89 d7                	mov    %edx,%edi
  803487:	89 f1                	mov    %esi,%ecx
  803489:	d3 ef                	shr    %cl,%edi
  80348b:	09 c7                	or     %eax,%edi
  80348d:	89 e9                	mov    %ebp,%ecx
  80348f:	d3 e2                	shl    %cl,%edx
  803491:	89 14 24             	mov    %edx,(%esp)
  803494:	89 d8                	mov    %ebx,%eax
  803496:	d3 e0                	shl    %cl,%eax
  803498:	89 c2                	mov    %eax,%edx
  80349a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80349e:	d3 e0                	shl    %cl,%eax
  8034a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034a8:	89 f1                	mov    %esi,%ecx
  8034aa:	d3 e8                	shr    %cl,%eax
  8034ac:	09 d0                	or     %edx,%eax
  8034ae:	d3 eb                	shr    %cl,%ebx
  8034b0:	89 da                	mov    %ebx,%edx
  8034b2:	f7 f7                	div    %edi
  8034b4:	89 d3                	mov    %edx,%ebx
  8034b6:	f7 24 24             	mull   (%esp)
  8034b9:	89 c6                	mov    %eax,%esi
  8034bb:	89 d1                	mov    %edx,%ecx
  8034bd:	39 d3                	cmp    %edx,%ebx
  8034bf:	0f 82 87 00 00 00    	jb     80354c <__umoddi3+0x134>
  8034c5:	0f 84 91 00 00 00    	je     80355c <__umoddi3+0x144>
  8034cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8034cf:	29 f2                	sub    %esi,%edx
  8034d1:	19 cb                	sbb    %ecx,%ebx
  8034d3:	89 d8                	mov    %ebx,%eax
  8034d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8034d9:	d3 e0                	shl    %cl,%eax
  8034db:	89 e9                	mov    %ebp,%ecx
  8034dd:	d3 ea                	shr    %cl,%edx
  8034df:	09 d0                	or     %edx,%eax
  8034e1:	89 e9                	mov    %ebp,%ecx
  8034e3:	d3 eb                	shr    %cl,%ebx
  8034e5:	89 da                	mov    %ebx,%edx
  8034e7:	83 c4 1c             	add    $0x1c,%esp
  8034ea:	5b                   	pop    %ebx
  8034eb:	5e                   	pop    %esi
  8034ec:	5f                   	pop    %edi
  8034ed:	5d                   	pop    %ebp
  8034ee:	c3                   	ret    
  8034ef:	90                   	nop
  8034f0:	89 fd                	mov    %edi,%ebp
  8034f2:	85 ff                	test   %edi,%edi
  8034f4:	75 0b                	jne    803501 <__umoddi3+0xe9>
  8034f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034fb:	31 d2                	xor    %edx,%edx
  8034fd:	f7 f7                	div    %edi
  8034ff:	89 c5                	mov    %eax,%ebp
  803501:	89 f0                	mov    %esi,%eax
  803503:	31 d2                	xor    %edx,%edx
  803505:	f7 f5                	div    %ebp
  803507:	89 c8                	mov    %ecx,%eax
  803509:	f7 f5                	div    %ebp
  80350b:	89 d0                	mov    %edx,%eax
  80350d:	e9 44 ff ff ff       	jmp    803456 <__umoddi3+0x3e>
  803512:	66 90                	xchg   %ax,%ax
  803514:	89 c8                	mov    %ecx,%eax
  803516:	89 f2                	mov    %esi,%edx
  803518:	83 c4 1c             	add    $0x1c,%esp
  80351b:	5b                   	pop    %ebx
  80351c:	5e                   	pop    %esi
  80351d:	5f                   	pop    %edi
  80351e:	5d                   	pop    %ebp
  80351f:	c3                   	ret    
  803520:	3b 04 24             	cmp    (%esp),%eax
  803523:	72 06                	jb     80352b <__umoddi3+0x113>
  803525:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803529:	77 0f                	ja     80353a <__umoddi3+0x122>
  80352b:	89 f2                	mov    %esi,%edx
  80352d:	29 f9                	sub    %edi,%ecx
  80352f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803533:	89 14 24             	mov    %edx,(%esp)
  803536:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80353a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80353e:	8b 14 24             	mov    (%esp),%edx
  803541:	83 c4 1c             	add    $0x1c,%esp
  803544:	5b                   	pop    %ebx
  803545:	5e                   	pop    %esi
  803546:	5f                   	pop    %edi
  803547:	5d                   	pop    %ebp
  803548:	c3                   	ret    
  803549:	8d 76 00             	lea    0x0(%esi),%esi
  80354c:	2b 04 24             	sub    (%esp),%eax
  80354f:	19 fa                	sbb    %edi,%edx
  803551:	89 d1                	mov    %edx,%ecx
  803553:	89 c6                	mov    %eax,%esi
  803555:	e9 71 ff ff ff       	jmp    8034cb <__umoddi3+0xb3>
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803560:	72 ea                	jb     80354c <__umoddi3+0x134>
  803562:	89 d9                	mov    %ebx,%ecx
  803564:	e9 62 ff ff ff       	jmp    8034cb <__umoddi3+0xb3>
