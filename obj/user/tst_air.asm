
obj/user/tst_air:     file format elf32-i386


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
  800031:	e8 15 0b 00 00       	call   800b4b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <user/air.h>
int find(int* arr, int size, int val);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec fc 01 00 00    	sub    $0x1fc,%esp
	int envID = sys_getenvid();
  800044:	e8 f6 25 00 00       	call   80263f <sys_getenvid>
  800049:	89 45 bc             	mov    %eax,-0x44(%ebp)

	// *************************************************************************************************
	/// Shared Variables Region ************************************************************************
	// *************************************************************************************************

	int numOfCustomers = 15;
  80004c:	c7 45 b8 0f 00 00 00 	movl   $0xf,-0x48(%ebp)
	int flight1Customers = 3;
  800053:	c7 45 b4 03 00 00 00 	movl   $0x3,-0x4c(%ebp)
	int flight2Customers = 8;
  80005a:	c7 45 b0 08 00 00 00 	movl   $0x8,-0x50(%ebp)
	int flight3Customers = 4;
  800061:	c7 45 ac 04 00 00 00 	movl   $0x4,-0x54(%ebp)

	int flight1NumOfTickets = 8;
  800068:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%ebp)
	int flight2NumOfTickets = 15;
  80006f:	c7 45 a4 0f 00 00 00 	movl   $0xf,-0x5c(%ebp)

	char _customers[] = "customers";
  800076:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  80007c:	bb 36 40 80 00       	mov    $0x804036,%ebx
  800081:	ba 0a 00 00 00       	mov    $0xa,%edx
  800086:	89 c7                	mov    %eax,%edi
  800088:	89 de                	mov    %ebx,%esi
  80008a:	89 d1                	mov    %edx,%ecx
  80008c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custCounter[] = "custCounter";
  80008e:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800094:	bb 40 40 80 00       	mov    $0x804040,%ebx
  800099:	ba 03 00 00 00       	mov    $0x3,%edx
  80009e:	89 c7                	mov    %eax,%edi
  8000a0:	89 de                	mov    %ebx,%esi
  8000a2:	89 d1                	mov    %edx,%ecx
  8000a4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1Counter[] = "flight1Counter";
  8000a6:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  8000ac:	bb 4c 40 80 00       	mov    $0x80404c,%ebx
  8000b1:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000b6:	89 c7                	mov    %eax,%edi
  8000b8:	89 de                	mov    %ebx,%esi
  8000ba:	89 d1                	mov    %edx,%ecx
  8000bc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2Counter[] = "flight2Counter";
  8000be:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  8000c4:	bb 5b 40 80 00       	mov    $0x80405b,%ebx
  8000c9:	ba 0f 00 00 00       	mov    $0xf,%edx
  8000ce:	89 c7                	mov    %eax,%edi
  8000d0:	89 de                	mov    %ebx,%esi
  8000d2:	89 d1                	mov    %edx,%ecx
  8000d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Counter[] = "flightBooked1Counter";
  8000d6:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8000dc:	bb 6a 40 80 00       	mov    $0x80406a,%ebx
  8000e1:	ba 15 00 00 00       	mov    $0x15,%edx
  8000e6:	89 c7                	mov    %eax,%edi
  8000e8:	89 de                	mov    %ebx,%esi
  8000ea:	89 d1                	mov    %edx,%ecx
  8000ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Counter[] = "flightBooked2Counter";
  8000ee:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8000f4:	bb 7f 40 80 00       	mov    $0x80407f,%ebx
  8000f9:	ba 15 00 00 00       	mov    $0x15,%edx
  8000fe:	89 c7                	mov    %eax,%edi
  800100:	89 de                	mov    %ebx,%esi
  800102:	89 d1                	mov    %edx,%ecx
  800104:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked1Arr[] = "flightBooked1Arr";
  800106:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  80010c:	bb 94 40 80 00       	mov    $0x804094,%ebx
  800111:	ba 11 00 00 00       	mov    $0x11,%edx
  800116:	89 c7                	mov    %eax,%edi
  800118:	89 de                	mov    %ebx,%esi
  80011a:	89 d1                	mov    %edx,%ecx
  80011c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flightBooked2Arr[] = "flightBooked2Arr";
  80011e:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  800124:	bb a5 40 80 00       	mov    $0x8040a5,%ebx
  800129:	ba 11 00 00 00       	mov    $0x11,%edx
  80012e:	89 c7                	mov    %eax,%edi
  800130:	89 de                	mov    %ebx,%esi
  800132:	89 d1                	mov    %edx,%ecx
  800134:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _cust_ready_queue[] = "cust_ready_queue";
  800136:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80013c:	bb b6 40 80 00       	mov    $0x8040b6,%ebx
  800141:	ba 11 00 00 00       	mov    $0x11,%edx
  800146:	89 c7                	mov    %eax,%edi
  800148:	89 de                	mov    %ebx,%esi
  80014a:	89 d1                	mov    %edx,%ecx
  80014c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_in[] = "queue_in";
  80014e:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800154:	bb c7 40 80 00       	mov    $0x8040c7,%ebx
  800159:	ba 09 00 00 00       	mov    $0x9,%edx
  80015e:	89 c7                	mov    %eax,%edi
  800160:	89 de                	mov    %ebx,%esi
  800162:	89 d1                	mov    %edx,%ecx
  800164:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _queue_out[] = "queue_out";
  800166:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80016c:	bb d0 40 80 00       	mov    $0x8040d0,%ebx
  800171:	ba 0a 00 00 00       	mov    $0xa,%edx
  800176:	89 c7                	mov    %eax,%edi
  800178:	89 de                	mov    %ebx,%esi
  80017a:	89 d1                	mov    %edx,%ecx
  80017c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _cust_ready[] = "cust_ready";
  80017e:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800184:	bb da 40 80 00       	mov    $0x8040da,%ebx
  800189:	ba 0b 00 00 00       	mov    $0xb,%edx
  80018e:	89 c7                	mov    %eax,%edi
  800190:	89 de                	mov    %ebx,%esi
  800192:	89 d1                	mov    %edx,%ecx
  800194:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custQueueCS[] = "custQueueCS";
  800196:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  80019c:	bb e5 40 80 00       	mov    $0x8040e5,%ebx
  8001a1:	ba 03 00 00 00       	mov    $0x3,%edx
  8001a6:	89 c7                	mov    %eax,%edi
  8001a8:	89 de                	mov    %ebx,%esi
  8001aa:	89 d1                	mov    %edx,%ecx
  8001ac:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	char _flight1CS[] = "flight1CS";
  8001ae:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8001b4:	bb f1 40 80 00       	mov    $0x8040f1,%ebx
  8001b9:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001be:	89 c7                	mov    %eax,%edi
  8001c0:	89 de                	mov    %ebx,%esi
  8001c2:	89 d1                	mov    %edx,%ecx
  8001c4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _flight2CS[] = "flight2CS";
  8001c6:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8001cc:	bb fb 40 80 00       	mov    $0x8040fb,%ebx
  8001d1:	ba 0a 00 00 00       	mov    $0xa,%edx
  8001d6:	89 c7                	mov    %eax,%edi
  8001d8:	89 de                	mov    %ebx,%esi
  8001da:	89 d1                	mov    %edx,%ecx
  8001dc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _clerk[] = "clerk";
  8001de:	c7 85 9f fe ff ff 63 	movl   $0x72656c63,-0x161(%ebp)
  8001e5:	6c 65 72 
  8001e8:	66 c7 85 a3 fe ff ff 	movw   $0x6b,-0x15d(%ebp)
  8001ef:	6b 00 
	char _custCounterCS[] = "custCounterCS";
  8001f1:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8001f7:	bb 05 41 80 00       	mov    $0x804105,%ebx
  8001fc:	ba 0e 00 00 00       	mov    $0xe,%edx
  800201:	89 c7                	mov    %eax,%edi
  800203:	89 de                	mov    %ebx,%esi
  800205:	89 d1                	mov    %edx,%ecx
  800207:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _custTerminated[] = "custTerminated";
  800209:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  80020f:	bb 13 41 80 00       	mov    $0x804113,%ebx
  800214:	ba 0f 00 00 00       	mov    $0xf,%edx
  800219:	89 c7                	mov    %eax,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	89 d1                	mov    %edx,%ecx
  80021f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	char _taircl[] = "taircl";
  800221:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800227:	bb 22 41 80 00       	mov    $0x804122,%ebx
  80022c:	ba 07 00 00 00       	mov    $0x7,%edx
  800231:	89 c7                	mov    %eax,%edi
  800233:	89 de                	mov    %ebx,%esi
  800235:	89 d1                	mov    %edx,%ecx
  800237:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	char _taircu[] = "taircu";
  800239:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  80023f:	bb 29 41 80 00       	mov    $0x804129,%ebx
  800244:	ba 07 00 00 00       	mov    $0x7,%edx
  800249:	89 c7                	mov    %eax,%edi
  80024b:	89 de                	mov    %ebx,%esi
  80024d:	89 d1                	mov    %edx,%ecx
  80024f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)

	struct Customer * custs;
	custs = smalloc(_customers, sizeof(struct Customer)*numOfCustomers, 1);
  800251:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800254:	c1 e0 03             	shl    $0x3,%eax
  800257:	83 ec 04             	sub    $0x4,%esp
  80025a:	6a 01                	push   $0x1
  80025c:	50                   	push   %eax
  80025d:	8d 85 6a ff ff ff    	lea    -0x96(%ebp),%eax
  800263:	50                   	push   %eax
  800264:	e8 ec 1d 00 00       	call   802055 <smalloc>
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
  80026f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for(;f1<flight1Customers; ++f1)
  800276:	eb 2e                	jmp    8002a6 <_main+0x26e>
		{
			custs[f1].booked = 0;
  800278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80027b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800282:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800285:	01 d0                	add    %edx,%eax
  800287:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f1].flightType = 1;
  80028e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800291:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800298:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80029b:	01 d0                	add    %edx,%eax
  80029d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	//sys_createSharedObject("customers", sizeof(struct Customer)*numOfCustomers, 1, (void**)&custs);


	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  8002a3:	ff 45 e4             	incl   -0x1c(%ebp)
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  8002ac:	7c ca                	jl     800278 <_main+0x240>
		{
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
  8002ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  8002b4:	eb 2e                	jmp    8002e4 <_main+0x2ac>
		{
			custs[f2].booked = 0;
  8002b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002c0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f2].flightType = 2;
  8002cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8002d6:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8002d9:	01 d0                	add    %edx,%eax
  8002db:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
			custs[f1].booked = 0;
			custs[f1].flightType = 1;
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  8002e1:	ff 45 e0             	incl   -0x20(%ebp)
  8002e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002ea:	01 d0                	add    %edx,%eax
  8002ec:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002ef:	7f c5                	jg     8002b6 <_main+0x27e>
		{
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
  8002f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f4:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  8002f7:	eb 2e                	jmp    800327 <_main+0x2ef>
		{
			custs[f3].booked = 0;
  8002f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002fc:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800303:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800306:	01 d0                	add    %edx,%eax
  800308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
			custs[f3].flightType = 3;
  80030f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80031c:	01 d0                	add    %edx,%eax
  80031e:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
			custs[f2].booked = 0;
			custs[f2].flightType = 2;
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  800324:	ff 45 dc             	incl   -0x24(%ebp)
  800327:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80032a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80032d:	01 d0                	add    %edx,%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	7f c5                	jg     8002f9 <_main+0x2c1>
			custs[f3].booked = 0;
			custs[f3].flightType = 3;
		}
	}

	int* custCounter = smalloc(_custCounter, sizeof(int), 1);
  800334:	83 ec 04             	sub    $0x4,%esp
  800337:	6a 01                	push   $0x1
  800339:	6a 04                	push   $0x4
  80033b:	8d 85 5e ff ff ff    	lea    -0xa2(%ebp),%eax
  800341:	50                   	push   %eax
  800342:	e8 0e 1d 00 00       	call   802055 <smalloc>
  800347:	83 c4 10             	add    $0x10,%esp
  80034a:	89 45 9c             	mov    %eax,-0x64(%ebp)
	*custCounter = 0;
  80034d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800350:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1Counter = smalloc(_flight1Counter, sizeof(int), 1);
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	6a 01                	push   $0x1
  80035b:	6a 04                	push   $0x4
  80035d:	8d 85 4f ff ff ff    	lea    -0xb1(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	e8 ec 1c 00 00       	call   802055 <smalloc>
  800369:	83 c4 10             	add    $0x10,%esp
  80036c:	89 45 98             	mov    %eax,-0x68(%ebp)
	*flight1Counter = flight1NumOfTickets;
  80036f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800372:	8b 55 a8             	mov    -0x58(%ebp),%edx
  800375:	89 10                	mov    %edx,(%eax)

	int* flight2Counter = smalloc(_flight2Counter, sizeof(int), 1);
  800377:	83 ec 04             	sub    $0x4,%esp
  80037a:	6a 01                	push   $0x1
  80037c:	6a 04                	push   $0x4
  80037e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
  800384:	50                   	push   %eax
  800385:	e8 cb 1c 00 00       	call   802055 <smalloc>
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	89 45 94             	mov    %eax,-0x6c(%ebp)
	*flight2Counter = flight2NumOfTickets;
  800390:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800393:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  800396:	89 10                	mov    %edx,(%eax)

	int* flight1BookedCounter = smalloc(_flightBooked1Counter, sizeof(int), 1);
  800398:	83 ec 04             	sub    $0x4,%esp
  80039b:	6a 01                	push   $0x1
  80039d:	6a 04                	push   $0x4
  80039f:	8d 85 2b ff ff ff    	lea    -0xd5(%ebp),%eax
  8003a5:	50                   	push   %eax
  8003a6:	e8 aa 1c 00 00       	call   802055 <smalloc>
  8003ab:	83 c4 10             	add    $0x10,%esp
  8003ae:	89 45 90             	mov    %eax,-0x70(%ebp)
	*flight1BookedCounter = 0;
  8003b1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8003b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight2BookedCounter = smalloc(_flightBooked2Counter, sizeof(int), 1);
  8003ba:	83 ec 04             	sub    $0x4,%esp
  8003bd:	6a 01                	push   $0x1
  8003bf:	6a 04                	push   $0x4
  8003c1:	8d 85 16 ff ff ff    	lea    -0xea(%ebp),%eax
  8003c7:	50                   	push   %eax
  8003c8:	e8 88 1c 00 00       	call   802055 <smalloc>
  8003cd:	83 c4 10             	add    $0x10,%esp
  8003d0:	89 45 8c             	mov    %eax,-0x74(%ebp)
	*flight2BookedCounter = 0;
  8003d3:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8003d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* flight1BookedArr = smalloc(_flightBooked1Arr, sizeof(int)*flight1NumOfTickets, 1);
  8003dc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003df:	c1 e0 02             	shl    $0x2,%eax
  8003e2:	83 ec 04             	sub    $0x4,%esp
  8003e5:	6a 01                	push   $0x1
  8003e7:	50                   	push   %eax
  8003e8:	8d 85 05 ff ff ff    	lea    -0xfb(%ebp),%eax
  8003ee:	50                   	push   %eax
  8003ef:	e8 61 1c 00 00       	call   802055 <smalloc>
  8003f4:	83 c4 10             	add    $0x10,%esp
  8003f7:	89 45 88             	mov    %eax,-0x78(%ebp)
	int* flight2BookedArr = smalloc(_flightBooked2Arr, sizeof(int)*flight2NumOfTickets, 1);
  8003fa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003fd:	c1 e0 02             	shl    $0x2,%eax
  800400:	83 ec 04             	sub    $0x4,%esp
  800403:	6a 01                	push   $0x1
  800405:	50                   	push   %eax
  800406:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
  80040c:	50                   	push   %eax
  80040d:	e8 43 1c 00 00       	call   802055 <smalloc>
  800412:	83 c4 10             	add    $0x10,%esp
  800415:	89 45 84             	mov    %eax,-0x7c(%ebp)

	int* cust_ready_queue = smalloc(_cust_ready_queue, sizeof(int)*numOfCustomers, 1);
  800418:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80041b:	c1 e0 02             	shl    $0x2,%eax
  80041e:	83 ec 04             	sub    $0x4,%esp
  800421:	6a 01                	push   $0x1
  800423:	50                   	push   %eax
  800424:	8d 85 e3 fe ff ff    	lea    -0x11d(%ebp),%eax
  80042a:	50                   	push   %eax
  80042b:	e8 25 1c 00 00       	call   802055 <smalloc>
  800430:	83 c4 10             	add    $0x10,%esp
  800433:	89 45 80             	mov    %eax,-0x80(%ebp)

	int* queue_in = smalloc(_queue_in, sizeof(int), 1);
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	6a 01                	push   $0x1
  80043b:	6a 04                	push   $0x4
  80043d:	8d 85 da fe ff ff    	lea    -0x126(%ebp),%eax
  800443:	50                   	push   %eax
  800444:	e8 0c 1c 00 00       	call   802055 <smalloc>
  800449:	83 c4 10             	add    $0x10,%esp
  80044c:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	*queue_in = 0;
  800452:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int* queue_out = smalloc(_queue_out, sizeof(int), 1);
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	6a 01                	push   $0x1
  800463:	6a 04                	push   $0x4
  800465:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
  80046b:	50                   	push   %eax
  80046c:	e8 e4 1b 00 00       	call   802055 <smalloc>
  800471:	83 c4 10             	add    $0x10,%esp
  800474:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
	*queue_out = 0;
  80047a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	// *************************************************************************************************
	/// Semaphores Region ******************************************************************************
	// *************************************************************************************************
	sys_createSemaphore(_flight1CS, 1);
  800486:	83 ec 08             	sub    $0x8,%esp
  800489:	6a 01                	push   $0x1
  80048b:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  800491:	50                   	push   %eax
  800492:	e8 42 20 00 00       	call   8024d9 <sys_createSemaphore>
  800497:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_flight2CS, 1);
  80049a:	83 ec 08             	sub    $0x8,%esp
  80049d:	6a 01                	push   $0x1
  80049f:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  8004a5:	50                   	push   %eax
  8004a6:	e8 2e 20 00 00       	call   8024d9 <sys_createSemaphore>
  8004ab:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custCounterCS, 1);
  8004ae:	83 ec 08             	sub    $0x8,%esp
  8004b1:	6a 01                	push   $0x1
  8004b3:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  8004b9:	50                   	push   %eax
  8004ba:	e8 1a 20 00 00       	call   8024d9 <sys_createSemaphore>
  8004bf:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_custQueueCS, 1);
  8004c2:	83 ec 08             	sub    $0x8,%esp
  8004c5:	6a 01                	push   $0x1
  8004c7:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	e8 06 20 00 00       	call   8024d9 <sys_createSemaphore>
  8004d3:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_clerk, 3);
  8004d6:	83 ec 08             	sub    $0x8,%esp
  8004d9:	6a 03                	push   $0x3
  8004db:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8004e1:	50                   	push   %eax
  8004e2:	e8 f2 1f 00 00       	call   8024d9 <sys_createSemaphore>
  8004e7:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_cust_ready, 0);
  8004ea:	83 ec 08             	sub    $0x8,%esp
  8004ed:	6a 00                	push   $0x0
  8004ef:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8004f5:	50                   	push   %eax
  8004f6:	e8 de 1f 00 00       	call   8024d9 <sys_createSemaphore>
  8004fb:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore(_custTerminated, 0);
  8004fe:	83 ec 08             	sub    $0x8,%esp
  800501:	6a 00                	push   $0x0
  800503:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800509:	50                   	push   %eax
  80050a:	e8 ca 1f 00 00       	call   8024d9 <sys_createSemaphore>
  80050f:	83 c4 10             	add    $0x10,%esp

	int s=0;
  800512:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
	for(s=0; s<numOfCustomers; ++s)
  800519:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800520:	eb 78                	jmp    80059a <_main+0x562>
	{
		char prefix[30]="cust_finished";
  800522:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  800528:	bb 30 41 80 00       	mov    $0x804130,%ebx
  80052d:	ba 0e 00 00 00       	mov    $0xe,%edx
  800532:	89 c7                	mov    %eax,%edi
  800534:	89 de                	mov    %ebx,%esi
  800536:	89 d1                	mov    %edx,%ecx
  800538:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80053a:	8d 95 64 fe ff ff    	lea    -0x19c(%ebp),%edx
  800540:	b9 04 00 00 00       	mov    $0x4,%ecx
  800545:	b8 00 00 00 00       	mov    $0x0,%eax
  80054a:	89 d7                	mov    %edx,%edi
  80054c:	f3 ab                	rep stos %eax,%es:(%edi)
		char id[5]; char sname[50];
		ltostr(s, id);
  80054e:	83 ec 08             	sub    $0x8,%esp
  800551:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800557:	50                   	push   %eax
  800558:	ff 75 d8             	pushl  -0x28(%ebp)
  80055b:	e8 03 15 00 00       	call   801a63 <ltostr>
  800560:	83 c4 10             	add    $0x10,%esp
		strcconcat(prefix, id, sname);
  800563:	83 ec 04             	sub    $0x4,%esp
  800566:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80056c:	50                   	push   %eax
  80056d:	8d 85 51 fe ff ff    	lea    -0x1af(%ebp),%eax
  800573:	50                   	push   %eax
  800574:	8d 85 56 fe ff ff    	lea    -0x1aa(%ebp),%eax
  80057a:	50                   	push   %eax
  80057b:	e8 db 15 00 00       	call   801b5b <strcconcat>
  800580:	83 c4 10             	add    $0x10,%esp
		sys_createSemaphore(sname, 0);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	6a 00                	push   $0x0
  800588:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  80058e:	50                   	push   %eax
  80058f:	e8 45 1f 00 00       	call   8024d9 <sys_createSemaphore>
  800594:	83 c4 10             	add    $0x10,%esp
	sys_createSemaphore(_cust_ready, 0);

	sys_createSemaphore(_custTerminated, 0);

	int s=0;
	for(s=0; s<numOfCustomers; ++s)
  800597:	ff 45 d8             	incl   -0x28(%ebp)
  80059a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80059d:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8005a0:	7c 80                	jl     800522 <_main+0x4ea>
	// start all clerks and customers ******************************************************************
	// *************************************************************************************************

	//3 clerks
	uint32 envId;
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8005a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005a7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005ad:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8005b8:	89 c1                	mov    %eax,%ecx
  8005ba:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bf:	8b 40 74             	mov    0x74(%eax),%eax
  8005c2:	52                   	push   %edx
  8005c3:	51                   	push   %ecx
  8005c4:	50                   	push   %eax
  8005c5:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  8005cb:	50                   	push   %eax
  8005cc:	e8 19 20 00 00       	call   8025ea <sys_create_env>
  8005d1:	83 c4 10             	add    $0x10,%esp
  8005d4:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  8005da:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8005e0:	83 ec 0c             	sub    $0xc,%esp
  8005e3:	50                   	push   %eax
  8005e4:	e8 1f 20 00 00       	call   802608 <sys_run_env>
  8005e9:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  8005ec:	a1 20 50 80 00       	mov    0x805020,%eax
  8005f1:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8005f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005fc:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800602:	89 c1                	mov    %eax,%ecx
  800604:	a1 20 50 80 00       	mov    0x805020,%eax
  800609:	8b 40 74             	mov    0x74(%eax),%eax
  80060c:	52                   	push   %edx
  80060d:	51                   	push   %ecx
  80060e:	50                   	push   %eax
  80060f:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  800615:	50                   	push   %eax
  800616:	e8 cf 1f 00 00       	call   8025ea <sys_create_env>
  80061b:	83 c4 10             	add    $0x10,%esp
  80061e:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  800624:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  80062a:	83 ec 0c             	sub    $0xc,%esp
  80062d:	50                   	push   %eax
  80062e:	e8 d5 1f 00 00       	call   802608 <sys_run_env>
  800633:	83 c4 10             	add    $0x10,%esp

	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80064c:	89 c1                	mov    %eax,%ecx
  80064e:	a1 20 50 80 00       	mov    0x805020,%eax
  800653:	8b 40 74             	mov    0x74(%eax),%eax
  800656:	52                   	push   %edx
  800657:	51                   	push   %ecx
  800658:	50                   	push   %eax
  800659:	8d 85 7b fe ff ff    	lea    -0x185(%ebp),%eax
  80065f:	50                   	push   %eax
  800660:	e8 85 1f 00 00       	call   8025ea <sys_create_env>
  800665:	83 c4 10             	add    $0x10,%esp
  800668:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	sys_run_env(envId);
  80066e:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	50                   	push   %eax
  800678:	e8 8b 1f 00 00       	call   802608 <sys_run_env>
  80067d:	83 c4 10             	add    $0x10,%esp

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  800680:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800687:	eb 6d                	jmp    8006f6 <_main+0x6be>
	{
		envId = sys_create_env(_taircu, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800689:	a1 20 50 80 00       	mov    0x805020,%eax
  80068e:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800694:	a1 20 50 80 00       	mov    0x805020,%eax
  800699:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a6:	8b 40 74             	mov    0x74(%eax),%eax
  8006a9:	52                   	push   %edx
  8006aa:	51                   	push   %ecx
  8006ab:	50                   	push   %eax
  8006ac:	8d 85 74 fe ff ff    	lea    -0x18c(%ebp),%eax
  8006b2:	50                   	push   %eax
  8006b3:	e8 32 1f 00 00       	call   8025ea <sys_create_env>
  8006b8:	83 c4 10             	add    $0x10,%esp
  8006bb:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
		if (envId == E_ENV_CREATION_ERROR)
  8006c1:	83 bd 74 ff ff ff ef 	cmpl   $0xffffffef,-0x8c(%ebp)
  8006c8:	75 17                	jne    8006e1 <_main+0x6a9>
			panic("NO AVAILABLE ENVs... Please reduce the num of customers and try again");
  8006ca:	83 ec 04             	sub    $0x4,%esp
  8006cd:	68 60 3d 80 00       	push   $0x803d60
  8006d2:	68 95 00 00 00       	push   $0x95
  8006d7:	68 a6 3d 80 00       	push   $0x803da6
  8006dc:	e8 a6 05 00 00       	call   800c87 <_panic>

		sys_run_env(envId);
  8006e1:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006e7:	83 ec 0c             	sub    $0xc,%esp
  8006ea:	50                   	push   %eax
  8006eb:	e8 18 1f 00 00       	call   802608 <sys_run_env>
  8006f0:	83 c4 10             	add    $0x10,%esp
	envId = sys_create_env(_taircl, (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
	sys_run_env(envId);

	//customers
	int c;
	for(c=0; c< numOfCustomers;++c)
  8006f3:	ff 45 d4             	incl   -0x2c(%ebp)
  8006f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f9:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  8006fc:	7c 8b                	jl     800689 <_main+0x651>

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  8006fe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  800705:	eb 18                	jmp    80071f <_main+0x6e7>
	{
		sys_waitSemaphore(envID, _custTerminated);
  800707:	83 ec 08             	sub    $0x8,%esp
  80070a:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800710:	50                   	push   %eax
  800711:	ff 75 bc             	pushl  -0x44(%ebp)
  800714:	e8 f9 1d 00 00       	call   802512 <sys_waitSemaphore>
  800719:	83 c4 10             	add    $0x10,%esp

		sys_run_env(envId);
	}

	//wait until all customers terminated
	for(c=0; c< numOfCustomers;++c)
  80071c:	ff 45 d4             	incl   -0x2c(%ebp)
  80071f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800722:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800725:	7c e0                	jl     800707 <_main+0x6cf>
	{
		sys_waitSemaphore(envID, _custTerminated);
	}

	env_sleep(1500);
  800727:	83 ec 0c             	sub    $0xc,%esp
  80072a:	68 dc 05 00 00       	push   $0x5dc
  80072f:	e8 0b 33 00 00       	call   803a3f <env_sleep>
  800734:	83 c4 10             	add    $0x10,%esp

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800737:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80073e:	eb 45                	jmp    800785 <_main+0x74d>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
  800740:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80074a:	8b 45 88             	mov    -0x78(%ebp),%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800758:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80075b:	01 d0                	add    %edx,%eax
  80075d:	8b 10                	mov    (%eax),%edx
  80075f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800762:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800769:	8b 45 88             	mov    -0x78(%ebp),%eax
  80076c:	01 c8                	add    %ecx,%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 ec 04             	sub    $0x4,%esp
  800773:	52                   	push   %edx
  800774:	50                   	push   %eax
  800775:	68 b8 3d 80 00       	push   $0x803db8
  80077a:	e8 bc 07 00 00       	call   800f3b <cprintf>
  80077f:	83 c4 10             	add    $0x10,%esp

	env_sleep(1500);

	//print out the results
	int b;
	for(b=0; b< (*flight1BookedCounter);++b)
  800782:	ff 45 d0             	incl   -0x30(%ebp)
  800785:	8b 45 90             	mov    -0x70(%ebp),%eax
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  80078d:	7f b1                	jg     800740 <_main+0x708>
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  80078f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800796:	eb 45                	jmp    8007dd <_main+0x7a5>
	{
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
  800798:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80079b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007a2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007a5:	01 d0                	add    %edx,%eax
  8007a7:	8b 00                	mov    (%eax),%eax
  8007a9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8007b0:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8007b3:	01 d0                	add    %edx,%eax
  8007b5:	8b 10                	mov    (%eax),%edx
  8007b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007ba:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007c1:	8b 45 84             	mov    -0x7c(%ebp),%eax
  8007c4:	01 c8                	add    %ecx,%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 ec 04             	sub    $0x4,%esp
  8007cb:	52                   	push   %edx
  8007cc:	50                   	push   %eax
  8007cd:	68 e8 3d 80 00       	push   $0x803de8
  8007d2:	e8 64 07 00 00       	call   800f3b <cprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
	for(b=0; b< (*flight1BookedCounter);++b)
	{
		cprintf("cust %d booked flight 1, originally ordered %d\n", flight1BookedArr[b], custs[flight1BookedArr[b]].flightType);
	}

	for(b=0; b< (*flight2BookedCounter);++b)
  8007da:	ff 45 d0             	incl   -0x30(%ebp)
  8007dd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8007e5:	7f b1                	jg     800798 <_main+0x760>
		cprintf("cust %d booked flight 2, originally ordered %d\n", flight2BookedArr[b], custs[flight2BookedArr[b]].flightType);
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
  8007e7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
		for(;f1<flight1Customers; ++f1)
  8007ee:	eb 33                	jmp    800823 <_main+0x7eb>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f1) != 1)
  8007f0:	83 ec 04             	sub    $0x4,%esp
  8007f3:	ff 75 cc             	pushl  -0x34(%ebp)
  8007f6:	ff 75 a8             	pushl  -0x58(%ebp)
  8007f9:	ff 75 88             	pushl  -0x78(%ebp)
  8007fc:	e8 05 03 00 00       	call   800b06 <find>
  800801:	83 c4 10             	add    $0x10,%esp
  800804:	83 f8 01             	cmp    $0x1,%eax
  800807:	74 17                	je     800820 <_main+0x7e8>
			{
				panic("Error, wrong booking for user %d\n", f1);
  800809:	ff 75 cc             	pushl  -0x34(%ebp)
  80080c:	68 18 3e 80 00       	push   $0x803e18
  800811:	68 b5 00 00 00       	push   $0xb5
  800816:	68 a6 3d 80 00       	push   $0x803da6
  80081b:	e8 67 04 00 00       	call   800c87 <_panic>
	}

	//check out the final results and semaphores
	{
		int f1 = 0;
		for(;f1<flight1Customers; ++f1)
  800820:	ff 45 cc             	incl   -0x34(%ebp)
  800823:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800826:	3b 45 b4             	cmp    -0x4c(%ebp),%eax
  800829:	7c c5                	jl     8007f0 <_main+0x7b8>
			{
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
  80082b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80082e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		for(;f2<f1+flight2Customers; ++f2)
  800831:	eb 33                	jmp    800866 <_main+0x82e>
		{
			if(find(flight2BookedArr, flight2NumOfTickets, f2) != 1)
  800833:	83 ec 04             	sub    $0x4,%esp
  800836:	ff 75 c8             	pushl  -0x38(%ebp)
  800839:	ff 75 a4             	pushl  -0x5c(%ebp)
  80083c:	ff 75 84             	pushl  -0x7c(%ebp)
  80083f:	e8 c2 02 00 00       	call   800b06 <find>
  800844:	83 c4 10             	add    $0x10,%esp
  800847:	83 f8 01             	cmp    $0x1,%eax
  80084a:	74 17                	je     800863 <_main+0x82b>
			{
				panic("Error, wrong booking for user %d\n", f2);
  80084c:	ff 75 c8             	pushl  -0x38(%ebp)
  80084f:	68 18 3e 80 00       	push   $0x803e18
  800854:	68 be 00 00 00       	push   $0xbe
  800859:	68 a6 3d 80 00       	push   $0x803da6
  80085e:	e8 24 04 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f1);
			}
		}

		int f2=f1;
		for(;f2<f1+flight2Customers; ++f2)
  800863:	ff 45 c8             	incl   -0x38(%ebp)
  800866:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800869:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80086c:	01 d0                	add    %edx,%eax
  80086e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  800871:	7f c0                	jg     800833 <_main+0x7fb>
			{
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
  800873:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800876:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		for(;f3<f2+flight3Customers; ++f3)
  800879:	eb 4c                	jmp    8008c7 <_main+0x88f>
		{
			if(find(flight1BookedArr, flight1NumOfTickets, f3) != 1 || find(flight2BookedArr, flight2NumOfTickets, f3) != 1)
  80087b:	83 ec 04             	sub    $0x4,%esp
  80087e:	ff 75 c4             	pushl  -0x3c(%ebp)
  800881:	ff 75 a8             	pushl  -0x58(%ebp)
  800884:	ff 75 88             	pushl  -0x78(%ebp)
  800887:	e8 7a 02 00 00       	call   800b06 <find>
  80088c:	83 c4 10             	add    $0x10,%esp
  80088f:	83 f8 01             	cmp    $0x1,%eax
  800892:	75 19                	jne    8008ad <_main+0x875>
  800894:	83 ec 04             	sub    $0x4,%esp
  800897:	ff 75 c4             	pushl  -0x3c(%ebp)
  80089a:	ff 75 a4             	pushl  -0x5c(%ebp)
  80089d:	ff 75 84             	pushl  -0x7c(%ebp)
  8008a0:	e8 61 02 00 00       	call   800b06 <find>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	83 f8 01             	cmp    $0x1,%eax
  8008ab:	74 17                	je     8008c4 <_main+0x88c>
			{
				panic("Error, wrong booking for user %d\n", f3);
  8008ad:	ff 75 c4             	pushl  -0x3c(%ebp)
  8008b0:	68 18 3e 80 00       	push   $0x803e18
  8008b5:	68 c7 00 00 00       	push   $0xc7
  8008ba:	68 a6 3d 80 00       	push   $0x803da6
  8008bf:	e8 c3 03 00 00       	call   800c87 <_panic>
				panic("Error, wrong booking for user %d\n", f2);
			}
		}

		int f3=f2;
		for(;f3<f2+flight3Customers; ++f3)
  8008c4:	ff 45 c4             	incl   -0x3c(%ebp)
  8008c7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8008ca:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8008cd:	01 d0                	add    %edx,%eax
  8008cf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
  8008d2:	7f a7                	jg     80087b <_main+0x843>
			{
				panic("Error, wrong booking for user %d\n", f3);
			}
		}

		assert(sys_getSemaphoreValue(envID, _flight1CS) == 1);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	8d 85 af fe ff ff    	lea    -0x151(%ebp),%eax
  8008dd:	50                   	push   %eax
  8008de:	ff 75 bc             	pushl  -0x44(%ebp)
  8008e1:	e8 0f 1c 00 00       	call   8024f5 <sys_getSemaphoreValue>
  8008e6:	83 c4 10             	add    $0x10,%esp
  8008e9:	83 f8 01             	cmp    $0x1,%eax
  8008ec:	74 19                	je     800907 <_main+0x8cf>
  8008ee:	68 3c 3e 80 00       	push   $0x803e3c
  8008f3:	68 6a 3e 80 00       	push   $0x803e6a
  8008f8:	68 cb 00 00 00       	push   $0xcb
  8008fd:	68 a6 3d 80 00       	push   $0x803da6
  800902:	e8 80 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _flight2CS) == 1);
  800907:	83 ec 08             	sub    $0x8,%esp
  80090a:	8d 85 a5 fe ff ff    	lea    -0x15b(%ebp),%eax
  800910:	50                   	push   %eax
  800911:	ff 75 bc             	pushl  -0x44(%ebp)
  800914:	e8 dc 1b 00 00       	call   8024f5 <sys_getSemaphoreValue>
  800919:	83 c4 10             	add    $0x10,%esp
  80091c:	83 f8 01             	cmp    $0x1,%eax
  80091f:	74 19                	je     80093a <_main+0x902>
  800921:	68 80 3e 80 00       	push   $0x803e80
  800926:	68 6a 3e 80 00       	push   $0x803e6a
  80092b:	68 cc 00 00 00       	push   $0xcc
  800930:	68 a6 3d 80 00       	push   $0x803da6
  800935:	e8 4d 03 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custCounterCS) ==  1);
  80093a:	83 ec 08             	sub    $0x8,%esp
  80093d:	8d 85 91 fe ff ff    	lea    -0x16f(%ebp),%eax
  800943:	50                   	push   %eax
  800944:	ff 75 bc             	pushl  -0x44(%ebp)
  800947:	e8 a9 1b 00 00       	call   8024f5 <sys_getSemaphoreValue>
  80094c:	83 c4 10             	add    $0x10,%esp
  80094f:	83 f8 01             	cmp    $0x1,%eax
  800952:	74 19                	je     80096d <_main+0x935>
  800954:	68 b0 3e 80 00       	push   $0x803eb0
  800959:	68 6a 3e 80 00       	push   $0x803e6a
  80095e:	68 ce 00 00 00       	push   $0xce
  800963:	68 a6 3d 80 00       	push   $0x803da6
  800968:	e8 1a 03 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _custQueueCS) ==  1);
  80096d:	83 ec 08             	sub    $0x8,%esp
  800970:	8d 85 b9 fe ff ff    	lea    -0x147(%ebp),%eax
  800976:	50                   	push   %eax
  800977:	ff 75 bc             	pushl  -0x44(%ebp)
  80097a:	e8 76 1b 00 00       	call   8024f5 <sys_getSemaphoreValue>
  80097f:	83 c4 10             	add    $0x10,%esp
  800982:	83 f8 01             	cmp    $0x1,%eax
  800985:	74 19                	je     8009a0 <_main+0x968>
  800987:	68 e4 3e 80 00       	push   $0x803ee4
  80098c:	68 6a 3e 80 00       	push   $0x803e6a
  800991:	68 cf 00 00 00       	push   $0xcf
  800996:	68 a6 3d 80 00       	push   $0x803da6
  80099b:	e8 e7 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _clerk) == 3);
  8009a0:	83 ec 08             	sub    $0x8,%esp
  8009a3:	8d 85 9f fe ff ff    	lea    -0x161(%ebp),%eax
  8009a9:	50                   	push   %eax
  8009aa:	ff 75 bc             	pushl  -0x44(%ebp)
  8009ad:	e8 43 1b 00 00       	call   8024f5 <sys_getSemaphoreValue>
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	83 f8 03             	cmp    $0x3,%eax
  8009b8:	74 19                	je     8009d3 <_main+0x99b>
  8009ba:	68 14 3f 80 00       	push   $0x803f14
  8009bf:	68 6a 3e 80 00       	push   $0x803e6a
  8009c4:	68 d1 00 00 00       	push   $0xd1
  8009c9:	68 a6 3d 80 00       	push   $0x803da6
  8009ce:	e8 b4 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  8009dc:	50                   	push   %eax
  8009dd:	ff 75 bc             	pushl  -0x44(%ebp)
  8009e0:	e8 10 1b 00 00       	call   8024f5 <sys_getSemaphoreValue>
  8009e5:	83 c4 10             	add    $0x10,%esp
  8009e8:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8009eb:	74 19                	je     800a06 <_main+0x9ce>
  8009ed:	68 40 3f 80 00       	push   $0x803f40
  8009f2:	68 6a 3e 80 00       	push   $0x803e6a
  8009f7:	68 d3 00 00 00       	push   $0xd3
  8009fc:	68 a6 3d 80 00       	push   $0x803da6
  800a01:	e8 81 02 00 00       	call   800c87 <_panic>

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	8d 85 82 fe ff ff    	lea    -0x17e(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	ff 75 bc             	pushl  -0x44(%ebp)
  800a13:	e8 dd 1a 00 00       	call   8024f5 <sys_getSemaphoreValue>
  800a18:	83 c4 10             	add    $0x10,%esp
  800a1b:	85 c0                	test   %eax,%eax
  800a1d:	74 19                	je     800a38 <_main+0xa00>
  800a1f:	68 70 3f 80 00       	push   $0x803f70
  800a24:	68 6a 3e 80 00       	push   $0x803e6a
  800a29:	68 d5 00 00 00       	push   $0xd5
  800a2e:	68 a6 3d 80 00       	push   $0x803da6
  800a33:	e8 4f 02 00 00       	call   800c87 <_panic>

		int s=0;
  800a38:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
		for(s=0; s<numOfCustomers; ++s)
  800a3f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  800a46:	e9 96 00 00 00       	jmp    800ae1 <_main+0xaa9>
		{
			char prefix[30]="cust_finished";
  800a4b:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800a51:	bb 30 41 80 00       	mov    $0x804130,%ebx
  800a56:	ba 0e 00 00 00       	mov    $0xe,%edx
  800a5b:	89 c7                	mov    %eax,%edi
  800a5d:	89 de                	mov    %ebx,%esi
  800a5f:	89 d1                	mov    %edx,%ecx
  800a61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800a63:	8d 95 41 fe ff ff    	lea    -0x1bf(%ebp),%edx
  800a69:	b9 04 00 00 00       	mov    $0x4,%ecx
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	89 d7                	mov    %edx,%edi
  800a75:	f3 ab                	rep stos %eax,%es:(%edi)
			char id[5]; char cust_finishedSemaphoreName[50];
			ltostr(s, id);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a80:	50                   	push   %eax
  800a81:	ff 75 c0             	pushl  -0x40(%ebp)
  800a84:	e8 da 0f 00 00       	call   801a63 <ltostr>
  800a89:	83 c4 10             	add    $0x10,%esp
			strcconcat(prefix, id, cust_finishedSemaphoreName);
  800a8c:	83 ec 04             	sub    $0x4,%esp
  800a8f:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800a95:	50                   	push   %eax
  800a96:	8d 85 2e fe ff ff    	lea    -0x1d2(%ebp),%eax
  800a9c:	50                   	push   %eax
  800a9d:	8d 85 33 fe ff ff    	lea    -0x1cd(%ebp),%eax
  800aa3:	50                   	push   %eax
  800aa4:	e8 b2 10 00 00       	call   801b5b <strcconcat>
  800aa9:	83 c4 10             	add    $0x10,%esp
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
  800aac:	83 ec 08             	sub    $0x8,%esp
  800aaf:	8d 85 fc fd ff ff    	lea    -0x204(%ebp),%eax
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 bc             	pushl  -0x44(%ebp)
  800ab9:	e8 37 1a 00 00       	call   8024f5 <sys_getSemaphoreValue>
  800abe:	83 c4 10             	add    $0x10,%esp
  800ac1:	85 c0                	test   %eax,%eax
  800ac3:	74 19                	je     800ade <_main+0xaa6>
  800ac5:	68 a4 3f 80 00       	push   $0x803fa4
  800aca:	68 6a 3e 80 00       	push   $0x803e6a
  800acf:	68 de 00 00 00       	push   $0xde
  800ad4:	68 a6 3d 80 00       	push   $0x803da6
  800ad9:	e8 a9 01 00 00       	call   800c87 <_panic>
		assert(sys_getSemaphoreValue(envID, _cust_ready) == -3);

		assert(sys_getSemaphoreValue(envID, _custTerminated) ==  0);

		int s=0;
		for(s=0; s<numOfCustomers; ++s)
  800ade:	ff 45 c0             	incl   -0x40(%ebp)
  800ae1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800ae4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  800ae7:	0f 8c 5e ff ff ff    	jl     800a4b <_main+0xa13>
			ltostr(s, id);
			strcconcat(prefix, id, cust_finishedSemaphoreName);
			assert(sys_getSemaphoreValue(envID, cust_finishedSemaphoreName) ==  0);
		}

		cprintf("Congratulations, All reservations are successfully done... have a nice flight :)\n");
  800aed:	83 ec 0c             	sub    $0xc,%esp
  800af0:	68 e4 3f 80 00       	push   $0x803fe4
  800af5:	e8 41 04 00 00       	call   800f3b <cprintf>
  800afa:	83 c4 10             	add    $0x10,%esp
	}

}
  800afd:	90                   	nop
  800afe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b01:	5b                   	pop    %ebx
  800b02:	5e                   	pop    %esi
  800b03:	5f                   	pop    %edi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <find>:


int find(int* arr, int size, int val)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 10             	sub    $0x10,%esp

	int result = 0;
  800b0c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)

	int i;
	for(i=0; i<size;++i )
  800b13:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800b1a:	eb 22                	jmp    800b3e <find+0x38>
	{
		if(arr[i] == val)
  800b1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	01 d0                	add    %edx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b30:	75 09                	jne    800b3b <find+0x35>
		{
			result = 1;
  800b32:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
			break;
  800b39:	eb 0b                	jmp    800b46 <find+0x40>
{

	int result = 0;

	int i;
	for(i=0; i<size;++i )
  800b3b:	ff 45 f8             	incl   -0x8(%ebp)
  800b3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800b41:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b44:	7c d6                	jl     800b1c <find+0x16>
			result = 1;
			break;
		}
	}

	return result;
  800b46:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b51:	e8 02 1b 00 00       	call   802658 <sys_getenvindex>
  800b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b5c:	89 d0                	mov    %edx,%eax
  800b5e:	c1 e0 03             	shl    $0x3,%eax
  800b61:	01 d0                	add    %edx,%eax
  800b63:	01 c0                	add    %eax,%eax
  800b65:	01 d0                	add    %edx,%eax
  800b67:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b6e:	01 d0                	add    %edx,%eax
  800b70:	c1 e0 04             	shl    $0x4,%eax
  800b73:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b78:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b7d:	a1 20 50 80 00       	mov    0x805020,%eax
  800b82:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b88:	84 c0                	test   %al,%al
  800b8a:	74 0f                	je     800b9b <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b8c:	a1 20 50 80 00       	mov    0x805020,%eax
  800b91:	05 5c 05 00 00       	add    $0x55c,%eax
  800b96:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b9f:	7e 0a                	jle    800bab <libmain+0x60>
		binaryname = argv[0];
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	ff 75 0c             	pushl  0xc(%ebp)
  800bb1:	ff 75 08             	pushl  0x8(%ebp)
  800bb4:	e8 7f f4 ff ff       	call   800038 <_main>
  800bb9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800bbc:	e8 a4 18 00 00       	call   802465 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	68 68 41 80 00       	push   $0x804168
  800bc9:	e8 6d 03 00 00       	call   800f3b <cprintf>
  800bce:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800bd1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800bdc:	a1 20 50 80 00       	mov    0x805020,%eax
  800be1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800be7:	83 ec 04             	sub    $0x4,%esp
  800bea:	52                   	push   %edx
  800beb:	50                   	push   %eax
  800bec:	68 90 41 80 00       	push   $0x804190
  800bf1:	e8 45 03 00 00       	call   800f3b <cprintf>
  800bf6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bf9:	a1 20 50 80 00       	mov    0x805020,%eax
  800bfe:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800c04:	a1 20 50 80 00       	mov    0x805020,%eax
  800c09:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800c0f:	a1 20 50 80 00       	mov    0x805020,%eax
  800c14:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800c1a:	51                   	push   %ecx
  800c1b:	52                   	push   %edx
  800c1c:	50                   	push   %eax
  800c1d:	68 b8 41 80 00       	push   $0x8041b8
  800c22:	e8 14 03 00 00       	call   800f3b <cprintf>
  800c27:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800c2a:	a1 20 50 80 00       	mov    0x805020,%eax
  800c2f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800c35:	83 ec 08             	sub    $0x8,%esp
  800c38:	50                   	push   %eax
  800c39:	68 10 42 80 00       	push   $0x804210
  800c3e:	e8 f8 02 00 00       	call   800f3b <cprintf>
  800c43:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c46:	83 ec 0c             	sub    $0xc,%esp
  800c49:	68 68 41 80 00       	push   $0x804168
  800c4e:	e8 e8 02 00 00       	call   800f3b <cprintf>
  800c53:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c56:	e8 24 18 00 00       	call   80247f <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c5b:	e8 19 00 00 00       	call   800c79 <exit>
}
  800c60:	90                   	nop
  800c61:	c9                   	leave  
  800c62:	c3                   	ret    

00800c63 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	6a 00                	push   $0x0
  800c6e:	e8 b1 19 00 00       	call   802624 <sys_destroy_env>
  800c73:	83 c4 10             	add    $0x10,%esp
}
  800c76:	90                   	nop
  800c77:	c9                   	leave  
  800c78:	c3                   	ret    

00800c79 <exit>:

void
exit(void)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c7f:	e8 06 1a 00 00       	call   80268a <sys_exit_env>
}
  800c84:	90                   	nop
  800c85:	c9                   	leave  
  800c86:	c3                   	ret    

00800c87 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c87:	55                   	push   %ebp
  800c88:	89 e5                	mov    %esp,%ebp
  800c8a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c8d:	8d 45 10             	lea    0x10(%ebp),%eax
  800c90:	83 c0 04             	add    $0x4,%eax
  800c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c96:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c9b:	85 c0                	test   %eax,%eax
  800c9d:	74 16                	je     800cb5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c9f:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ca4:	83 ec 08             	sub    $0x8,%esp
  800ca7:	50                   	push   %eax
  800ca8:	68 24 42 80 00       	push   $0x804224
  800cad:	e8 89 02 00 00       	call   800f3b <cprintf>
  800cb2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800cb5:	a1 00 50 80 00       	mov    0x805000,%eax
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	50                   	push   %eax
  800cc1:	68 29 42 80 00       	push   $0x804229
  800cc6:	e8 70 02 00 00       	call   800f3b <cprintf>
  800ccb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800cce:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd1:	83 ec 08             	sub    $0x8,%esp
  800cd4:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd7:	50                   	push   %eax
  800cd8:	e8 f3 01 00 00       	call   800ed0 <vcprintf>
  800cdd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800ce0:	83 ec 08             	sub    $0x8,%esp
  800ce3:	6a 00                	push   $0x0
  800ce5:	68 45 42 80 00       	push   $0x804245
  800cea:	e8 e1 01 00 00       	call   800ed0 <vcprintf>
  800cef:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800cf2:	e8 82 ff ff ff       	call   800c79 <exit>

	// should not return here
	while (1) ;
  800cf7:	eb fe                	jmp    800cf7 <_panic+0x70>

00800cf9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
  800cfc:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cff:	a1 20 50 80 00       	mov    0x805020,%eax
  800d04:	8b 50 74             	mov    0x74(%eax),%edx
  800d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d0a:	39 c2                	cmp    %eax,%edx
  800d0c:	74 14                	je     800d22 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800d0e:	83 ec 04             	sub    $0x4,%esp
  800d11:	68 48 42 80 00       	push   $0x804248
  800d16:	6a 26                	push   $0x26
  800d18:	68 94 42 80 00       	push   $0x804294
  800d1d:	e8 65 ff ff ff       	call   800c87 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800d22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800d29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d30:	e9 c2 00 00 00       	jmp    800df7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d38:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	01 d0                	add    %edx,%eax
  800d44:	8b 00                	mov    (%eax),%eax
  800d46:	85 c0                	test   %eax,%eax
  800d48:	75 08                	jne    800d52 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d4a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d4d:	e9 a2 00 00 00       	jmp    800df4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d52:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d59:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d60:	eb 69                	jmp    800dcb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d62:	a1 20 50 80 00       	mov    0x805020,%eax
  800d67:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d70:	89 d0                	mov    %edx,%eax
  800d72:	01 c0                	add    %eax,%eax
  800d74:	01 d0                	add    %edx,%eax
  800d76:	c1 e0 03             	shl    $0x3,%eax
  800d79:	01 c8                	add    %ecx,%eax
  800d7b:	8a 40 04             	mov    0x4(%eax),%al
  800d7e:	84 c0                	test   %al,%al
  800d80:	75 46                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d82:	a1 20 50 80 00       	mov    0x805020,%eax
  800d87:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d8d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d90:	89 d0                	mov    %edx,%eax
  800d92:	01 c0                	add    %eax,%eax
  800d94:	01 d0                	add    %edx,%eax
  800d96:	c1 e0 03             	shl    $0x3,%eax
  800d99:	01 c8                	add    %ecx,%eax
  800d9b:	8b 00                	mov    (%eax),%eax
  800d9d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800da0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800da3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800da8:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800daa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dad:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	01 c8                	add    %ecx,%eax
  800db9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800dbb:	39 c2                	cmp    %eax,%edx
  800dbd:	75 09                	jne    800dc8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800dbf:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800dc6:	eb 12                	jmp    800dda <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc8:	ff 45 e8             	incl   -0x18(%ebp)
  800dcb:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd0:	8b 50 74             	mov    0x74(%eax),%edx
  800dd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800dd6:	39 c2                	cmp    %eax,%edx
  800dd8:	77 88                	ja     800d62 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800dda:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800dde:	75 14                	jne    800df4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	68 a0 42 80 00       	push   $0x8042a0
  800de8:	6a 3a                	push   $0x3a
  800dea:	68 94 42 80 00       	push   $0x804294
  800def:	e8 93 fe ff ff       	call   800c87 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800df4:	ff 45 f0             	incl   -0x10(%ebp)
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dfd:	0f 8c 32 ff ff ff    	jl     800d35 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800e03:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e0a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800e11:	eb 26                	jmp    800e39 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800e13:	a1 20 50 80 00       	mov    0x805020,%eax
  800e18:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800e1e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800e21:	89 d0                	mov    %edx,%eax
  800e23:	01 c0                	add    %eax,%eax
  800e25:	01 d0                	add    %edx,%eax
  800e27:	c1 e0 03             	shl    $0x3,%eax
  800e2a:	01 c8                	add    %ecx,%eax
  800e2c:	8a 40 04             	mov    0x4(%eax),%al
  800e2f:	3c 01                	cmp    $0x1,%al
  800e31:	75 03                	jne    800e36 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800e33:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800e36:	ff 45 e0             	incl   -0x20(%ebp)
  800e39:	a1 20 50 80 00       	mov    0x805020,%eax
  800e3e:	8b 50 74             	mov    0x74(%eax),%edx
  800e41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e44:	39 c2                	cmp    %eax,%edx
  800e46:	77 cb                	ja     800e13 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e4b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e4e:	74 14                	je     800e64 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e50:	83 ec 04             	sub    $0x4,%esp
  800e53:	68 f4 42 80 00       	push   $0x8042f4
  800e58:	6a 44                	push   $0x44
  800e5a:	68 94 42 80 00       	push   $0x804294
  800e5f:	e8 23 fe ff ff       	call   800c87 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e64:	90                   	nop
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e70:	8b 00                	mov    (%eax),%eax
  800e72:	8d 48 01             	lea    0x1(%eax),%ecx
  800e75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e78:	89 0a                	mov    %ecx,(%edx)
  800e7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7d:	88 d1                	mov    %dl,%cl
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e82:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e89:	8b 00                	mov    (%eax),%eax
  800e8b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e90:	75 2c                	jne    800ebe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e92:	a0 24 50 80 00       	mov    0x805024,%al
  800e97:	0f b6 c0             	movzbl %al,%eax
  800e9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e9d:	8b 12                	mov    (%edx),%edx
  800e9f:	89 d1                	mov    %edx,%ecx
  800ea1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ea4:	83 c2 08             	add    $0x8,%edx
  800ea7:	83 ec 04             	sub    $0x4,%esp
  800eaa:	50                   	push   %eax
  800eab:	51                   	push   %ecx
  800eac:	52                   	push   %edx
  800ead:	e8 05 14 00 00       	call   8022b7 <sys_cputs>
  800eb2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	8b 40 04             	mov    0x4(%eax),%eax
  800ec4:	8d 50 01             	lea    0x1(%eax),%edx
  800ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eca:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ecd:	90                   	nop
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800ed9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800ee0:	00 00 00 
	b.cnt = 0;
  800ee3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800eea:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eed:	ff 75 0c             	pushl  0xc(%ebp)
  800ef0:	ff 75 08             	pushl  0x8(%ebp)
  800ef3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	68 67 0e 80 00       	push   $0x800e67
  800eff:	e8 11 02 00 00       	call   801115 <vprintfmt>
  800f04:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800f07:	a0 24 50 80 00       	mov    0x805024,%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800f15:	83 ec 04             	sub    $0x4,%esp
  800f18:	50                   	push   %eax
  800f19:	52                   	push   %edx
  800f1a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800f20:	83 c0 08             	add    $0x8,%eax
  800f23:	50                   	push   %eax
  800f24:	e8 8e 13 00 00       	call   8022b7 <sys_cputs>
  800f29:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800f2c:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800f33:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800f39:	c9                   	leave  
  800f3a:	c3                   	ret    

00800f3b <cprintf>:

int cprintf(const char *fmt, ...) {
  800f3b:	55                   	push   %ebp
  800f3c:	89 e5                	mov    %esp,%ebp
  800f3e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800f41:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f48:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 f4             	pushl  -0xc(%ebp)
  800f57:	50                   	push   %eax
  800f58:	e8 73 ff ff ff       	call   800ed0 <vcprintf>
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f66:	c9                   	leave  
  800f67:	c3                   	ret    

00800f68 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f68:	55                   	push   %ebp
  800f69:	89 e5                	mov    %esp,%ebp
  800f6b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f6e:	e8 f2 14 00 00       	call   802465 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f73:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f82:	50                   	push   %eax
  800f83:	e8 48 ff ff ff       	call   800ed0 <vcprintf>
  800f88:	83 c4 10             	add    $0x10,%esp
  800f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f8e:	e8 ec 14 00 00       	call   80247f <sys_enable_interrupt>
	return cnt;
  800f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f96:	c9                   	leave  
  800f97:	c3                   	ret    

00800f98 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	53                   	push   %ebx
  800f9c:	83 ec 14             	sub    $0x14,%esp
  800f9f:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800fab:	8b 45 18             	mov    0x18(%ebp),%eax
  800fae:	ba 00 00 00 00       	mov    $0x0,%edx
  800fb3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fb6:	77 55                	ja     80100d <printnum+0x75>
  800fb8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800fbb:	72 05                	jb     800fc2 <printnum+0x2a>
  800fbd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800fc0:	77 4b                	ja     80100d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800fc2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800fc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800fc8:	8b 45 18             	mov    0x18(%ebp),%eax
  800fcb:	ba 00 00 00 00       	mov    $0x0,%edx
  800fd0:	52                   	push   %edx
  800fd1:	50                   	push   %eax
  800fd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd5:	ff 75 f0             	pushl  -0x10(%ebp)
  800fd8:	e8 17 2b 00 00       	call   803af4 <__udivdi3>
  800fdd:	83 c4 10             	add    $0x10,%esp
  800fe0:	83 ec 04             	sub    $0x4,%esp
  800fe3:	ff 75 20             	pushl  0x20(%ebp)
  800fe6:	53                   	push   %ebx
  800fe7:	ff 75 18             	pushl  0x18(%ebp)
  800fea:	52                   	push   %edx
  800feb:	50                   	push   %eax
  800fec:	ff 75 0c             	pushl  0xc(%ebp)
  800fef:	ff 75 08             	pushl  0x8(%ebp)
  800ff2:	e8 a1 ff ff ff       	call   800f98 <printnum>
  800ff7:	83 c4 20             	add    $0x20,%esp
  800ffa:	eb 1a                	jmp    801016 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800ffc:	83 ec 08             	sub    $0x8,%esp
  800fff:	ff 75 0c             	pushl  0xc(%ebp)
  801002:	ff 75 20             	pushl  0x20(%ebp)
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	ff d0                	call   *%eax
  80100a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80100d:	ff 4d 1c             	decl   0x1c(%ebp)
  801010:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  801014:	7f e6                	jg     800ffc <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801016:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801021:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801024:	53                   	push   %ebx
  801025:	51                   	push   %ecx
  801026:	52                   	push   %edx
  801027:	50                   	push   %eax
  801028:	e8 d7 2b 00 00       	call   803c04 <__umoddi3>
  80102d:	83 c4 10             	add    $0x10,%esp
  801030:	05 54 45 80 00       	add    $0x804554,%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f be c0             	movsbl %al,%eax
  80103a:	83 ec 08             	sub    $0x8,%esp
  80103d:	ff 75 0c             	pushl  0xc(%ebp)
  801040:	50                   	push   %eax
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	ff d0                	call   *%eax
  801046:	83 c4 10             	add    $0x10,%esp
}
  801049:	90                   	nop
  80104a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801052:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801056:	7e 1c                	jle    801074 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8b 00                	mov    (%eax),%eax
  80105d:	8d 50 08             	lea    0x8(%eax),%edx
  801060:	8b 45 08             	mov    0x8(%ebp),%eax
  801063:	89 10                	mov    %edx,(%eax)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8b 00                	mov    (%eax),%eax
  80106a:	83 e8 08             	sub    $0x8,%eax
  80106d:	8b 50 04             	mov    0x4(%eax),%edx
  801070:	8b 00                	mov    (%eax),%eax
  801072:	eb 40                	jmp    8010b4 <getuint+0x65>
	else if (lflag)
  801074:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801078:	74 1e                	je     801098 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8b 00                	mov    (%eax),%eax
  80107f:	8d 50 04             	lea    0x4(%eax),%edx
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	89 10                	mov    %edx,(%eax)
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8b 00                	mov    (%eax),%eax
  80108c:	83 e8 04             	sub    $0x4,%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	ba 00 00 00 00       	mov    $0x0,%edx
  801096:	eb 1c                	jmp    8010b4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8b 00                	mov    (%eax),%eax
  80109d:	8d 50 04             	lea    0x4(%eax),%edx
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	89 10                	mov    %edx,(%eax)
  8010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a8:	8b 00                	mov    (%eax),%eax
  8010aa:	83 e8 04             	sub    $0x4,%eax
  8010ad:	8b 00                	mov    (%eax),%eax
  8010af:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8010b9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8010bd:	7e 1c                	jle    8010db <getint+0x25>
		return va_arg(*ap, long long);
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	8b 00                	mov    (%eax),%eax
  8010c4:	8d 50 08             	lea    0x8(%eax),%edx
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ca:	89 10                	mov    %edx,(%eax)
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	8b 00                	mov    (%eax),%eax
  8010d1:	83 e8 08             	sub    $0x8,%eax
  8010d4:	8b 50 04             	mov    0x4(%eax),%edx
  8010d7:	8b 00                	mov    (%eax),%eax
  8010d9:	eb 38                	jmp    801113 <getint+0x5d>
	else if (lflag)
  8010db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010df:	74 1a                	je     8010fb <getint+0x45>
		return va_arg(*ap, long);
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	8b 00                	mov    (%eax),%eax
  8010e6:	8d 50 04             	lea    0x4(%eax),%edx
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	89 10                	mov    %edx,(%eax)
  8010ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f1:	8b 00                	mov    (%eax),%eax
  8010f3:	83 e8 04             	sub    $0x4,%eax
  8010f6:	8b 00                	mov    (%eax),%eax
  8010f8:	99                   	cltd   
  8010f9:	eb 18                	jmp    801113 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fe:	8b 00                	mov    (%eax),%eax
  801100:	8d 50 04             	lea    0x4(%eax),%edx
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	89 10                	mov    %edx,(%eax)
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8b 00                	mov    (%eax),%eax
  80110d:	83 e8 04             	sub    $0x4,%eax
  801110:	8b 00                	mov    (%eax),%eax
  801112:	99                   	cltd   
}
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	56                   	push   %esi
  801119:	53                   	push   %ebx
  80111a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80111d:	eb 17                	jmp    801136 <vprintfmt+0x21>
			if (ch == '\0')
  80111f:	85 db                	test   %ebx,%ebx
  801121:	0f 84 af 03 00 00    	je     8014d6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	53                   	push   %ebx
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	ff d0                	call   *%eax
  801133:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801136:	8b 45 10             	mov    0x10(%ebp),%eax
  801139:	8d 50 01             	lea    0x1(%eax),%edx
  80113c:	89 55 10             	mov    %edx,0x10(%ebp)
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f b6 d8             	movzbl %al,%ebx
  801144:	83 fb 25             	cmp    $0x25,%ebx
  801147:	75 d6                	jne    80111f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801149:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80114d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801154:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80115b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801162:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801169:	8b 45 10             	mov    0x10(%ebp),%eax
  80116c:	8d 50 01             	lea    0x1(%eax),%edx
  80116f:	89 55 10             	mov    %edx,0x10(%ebp)
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 d8             	movzbl %al,%ebx
  801177:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80117a:	83 f8 55             	cmp    $0x55,%eax
  80117d:	0f 87 2b 03 00 00    	ja     8014ae <vprintfmt+0x399>
  801183:	8b 04 85 78 45 80 00 	mov    0x804578(,%eax,4),%eax
  80118a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80118c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801190:	eb d7                	jmp    801169 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801192:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801196:	eb d1                	jmp    801169 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801198:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80119f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8011a2:	89 d0                	mov    %edx,%eax
  8011a4:	c1 e0 02             	shl    $0x2,%eax
  8011a7:	01 d0                	add    %edx,%eax
  8011a9:	01 c0                	add    %eax,%eax
  8011ab:	01 d8                	add    %ebx,%eax
  8011ad:	83 e8 30             	sub    $0x30,%eax
  8011b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8011b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b6:	8a 00                	mov    (%eax),%al
  8011b8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8011bb:	83 fb 2f             	cmp    $0x2f,%ebx
  8011be:	7e 3e                	jle    8011fe <vprintfmt+0xe9>
  8011c0:	83 fb 39             	cmp    $0x39,%ebx
  8011c3:	7f 39                	jg     8011fe <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8011c5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8011c8:	eb d5                	jmp    80119f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8011ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cd:	83 c0 04             	add    $0x4,%eax
  8011d0:	89 45 14             	mov    %eax,0x14(%ebp)
  8011d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d6:	83 e8 04             	sub    $0x4,%eax
  8011d9:	8b 00                	mov    (%eax),%eax
  8011db:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8011de:	eb 1f                	jmp    8011ff <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8011e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011e4:	79 83                	jns    801169 <vprintfmt+0x54>
				width = 0;
  8011e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011ed:	e9 77 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011f2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011f9:	e9 6b ff ff ff       	jmp    801169 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011fe:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801203:	0f 89 60 ff ff ff    	jns    801169 <vprintfmt+0x54>
				width = precision, precision = -1;
  801209:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80120c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80120f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801216:	e9 4e ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80121b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80121e:	e9 46 ff ff ff       	jmp    801169 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	83 c0 04             	add    $0x4,%eax
  801229:	89 45 14             	mov    %eax,0x14(%ebp)
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	83 e8 04             	sub    $0x4,%eax
  801232:	8b 00                	mov    (%eax),%eax
  801234:	83 ec 08             	sub    $0x8,%esp
  801237:	ff 75 0c             	pushl  0xc(%ebp)
  80123a:	50                   	push   %eax
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	ff d0                	call   *%eax
  801240:	83 c4 10             	add    $0x10,%esp
			break;
  801243:	e9 89 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801248:	8b 45 14             	mov    0x14(%ebp),%eax
  80124b:	83 c0 04             	add    $0x4,%eax
  80124e:	89 45 14             	mov    %eax,0x14(%ebp)
  801251:	8b 45 14             	mov    0x14(%ebp),%eax
  801254:	83 e8 04             	sub    $0x4,%eax
  801257:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801259:	85 db                	test   %ebx,%ebx
  80125b:	79 02                	jns    80125f <vprintfmt+0x14a>
				err = -err;
  80125d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80125f:	83 fb 64             	cmp    $0x64,%ebx
  801262:	7f 0b                	jg     80126f <vprintfmt+0x15a>
  801264:	8b 34 9d c0 43 80 00 	mov    0x8043c0(,%ebx,4),%esi
  80126b:	85 f6                	test   %esi,%esi
  80126d:	75 19                	jne    801288 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80126f:	53                   	push   %ebx
  801270:	68 65 45 80 00       	push   $0x804565
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	e8 5e 02 00 00       	call   8014de <printfmt>
  801280:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801283:	e9 49 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801288:	56                   	push   %esi
  801289:	68 6e 45 80 00       	push   $0x80456e
  80128e:	ff 75 0c             	pushl  0xc(%ebp)
  801291:	ff 75 08             	pushl  0x8(%ebp)
  801294:	e8 45 02 00 00       	call   8014de <printfmt>
  801299:	83 c4 10             	add    $0x10,%esp
			break;
  80129c:	e9 30 02 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8012a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a4:	83 c0 04             	add    $0x4,%eax
  8012a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8012aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ad:	83 e8 04             	sub    $0x4,%eax
  8012b0:	8b 30                	mov    (%eax),%esi
  8012b2:	85 f6                	test   %esi,%esi
  8012b4:	75 05                	jne    8012bb <vprintfmt+0x1a6>
				p = "(null)";
  8012b6:	be 71 45 80 00       	mov    $0x804571,%esi
			if (width > 0 && padc != '-')
  8012bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012bf:	7e 6d                	jle    80132e <vprintfmt+0x219>
  8012c1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8012c5:	74 67                	je     80132e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8012c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ca:	83 ec 08             	sub    $0x8,%esp
  8012cd:	50                   	push   %eax
  8012ce:	56                   	push   %esi
  8012cf:	e8 0c 03 00 00       	call   8015e0 <strnlen>
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8012da:	eb 16                	jmp    8012f2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8012dc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	ff 75 0c             	pushl  0xc(%ebp)
  8012e6:	50                   	push   %eax
  8012e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ea:	ff d0                	call   *%eax
  8012ec:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ef:	ff 4d e4             	decl   -0x1c(%ebp)
  8012f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012f6:	7f e4                	jg     8012dc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012f8:	eb 34                	jmp    80132e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012fa:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012fe:	74 1c                	je     80131c <vprintfmt+0x207>
  801300:	83 fb 1f             	cmp    $0x1f,%ebx
  801303:	7e 05                	jle    80130a <vprintfmt+0x1f5>
  801305:	83 fb 7e             	cmp    $0x7e,%ebx
  801308:	7e 12                	jle    80131c <vprintfmt+0x207>
					putch('?', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 3f                	push   $0x3f
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	eb 0f                	jmp    80132b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80131c:	83 ec 08             	sub    $0x8,%esp
  80131f:	ff 75 0c             	pushl  0xc(%ebp)
  801322:	53                   	push   %ebx
  801323:	8b 45 08             	mov    0x8(%ebp),%eax
  801326:	ff d0                	call   *%eax
  801328:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80132b:	ff 4d e4             	decl   -0x1c(%ebp)
  80132e:	89 f0                	mov    %esi,%eax
  801330:	8d 70 01             	lea    0x1(%eax),%esi
  801333:	8a 00                	mov    (%eax),%al
  801335:	0f be d8             	movsbl %al,%ebx
  801338:	85 db                	test   %ebx,%ebx
  80133a:	74 24                	je     801360 <vprintfmt+0x24b>
  80133c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801340:	78 b8                	js     8012fa <vprintfmt+0x1e5>
  801342:	ff 4d e0             	decl   -0x20(%ebp)
  801345:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801349:	79 af                	jns    8012fa <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80134b:	eb 13                	jmp    801360 <vprintfmt+0x24b>
				putch(' ', putdat);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	6a 20                	push   $0x20
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	ff d0                	call   *%eax
  80135a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80135d:	ff 4d e4             	decl   -0x1c(%ebp)
  801360:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801364:	7f e7                	jg     80134d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801366:	e9 66 01 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80136b:	83 ec 08             	sub    $0x8,%esp
  80136e:	ff 75 e8             	pushl  -0x18(%ebp)
  801371:	8d 45 14             	lea    0x14(%ebp),%eax
  801374:	50                   	push   %eax
  801375:	e8 3c fd ff ff       	call   8010b6 <getint>
  80137a:	83 c4 10             	add    $0x10,%esp
  80137d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801380:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801386:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801389:	85 d2                	test   %edx,%edx
  80138b:	79 23                	jns    8013b0 <vprintfmt+0x29b>
				putch('-', putdat);
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	ff 75 0c             	pushl  0xc(%ebp)
  801393:	6a 2d                	push   $0x2d
  801395:	8b 45 08             	mov    0x8(%ebp),%eax
  801398:	ff d0                	call   *%eax
  80139a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80139d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a3:	f7 d8                	neg    %eax
  8013a5:	83 d2 00             	adc    $0x0,%edx
  8013a8:	f7 da                	neg    %edx
  8013aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8013b0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013b7:	e9 bc 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8013bc:	83 ec 08             	sub    $0x8,%esp
  8013bf:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c2:	8d 45 14             	lea    0x14(%ebp),%eax
  8013c5:	50                   	push   %eax
  8013c6:	e8 84 fc ff ff       	call   80104f <getuint>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8013d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8013db:	e9 98 00 00 00       	jmp    801478 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8013e0:	83 ec 08             	sub    $0x8,%esp
  8013e3:	ff 75 0c             	pushl  0xc(%ebp)
  8013e6:	6a 58                	push   $0x58
  8013e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013eb:	ff d0                	call   *%eax
  8013ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013f0:	83 ec 08             	sub    $0x8,%esp
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	6a 58                	push   $0x58
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	ff d0                	call   *%eax
  8013fd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801400:	83 ec 08             	sub    $0x8,%esp
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	6a 58                	push   $0x58
  801408:	8b 45 08             	mov    0x8(%ebp),%eax
  80140b:	ff d0                	call   *%eax
  80140d:	83 c4 10             	add    $0x10,%esp
			break;
  801410:	e9 bc 00 00 00       	jmp    8014d1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	ff 75 0c             	pushl  0xc(%ebp)
  80141b:	6a 30                	push   $0x30
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	ff d0                	call   *%eax
  801422:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 0c             	pushl  0xc(%ebp)
  80142b:	6a 78                	push   $0x78
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	ff d0                	call   *%eax
  801432:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801435:	8b 45 14             	mov    0x14(%ebp),%eax
  801438:	83 c0 04             	add    $0x4,%eax
  80143b:	89 45 14             	mov    %eax,0x14(%ebp)
  80143e:	8b 45 14             	mov    0x14(%ebp),%eax
  801441:	83 e8 04             	sub    $0x4,%eax
  801444:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801446:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801449:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801450:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801457:	eb 1f                	jmp    801478 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801459:	83 ec 08             	sub    $0x8,%esp
  80145c:	ff 75 e8             	pushl  -0x18(%ebp)
  80145f:	8d 45 14             	lea    0x14(%ebp),%eax
  801462:	50                   	push   %eax
  801463:	e8 e7 fb ff ff       	call   80104f <getuint>
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80146e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801471:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801478:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147f:	83 ec 04             	sub    $0x4,%esp
  801482:	52                   	push   %edx
  801483:	ff 75 e4             	pushl  -0x1c(%ebp)
  801486:	50                   	push   %eax
  801487:	ff 75 f4             	pushl  -0xc(%ebp)
  80148a:	ff 75 f0             	pushl  -0x10(%ebp)
  80148d:	ff 75 0c             	pushl  0xc(%ebp)
  801490:	ff 75 08             	pushl  0x8(%ebp)
  801493:	e8 00 fb ff ff       	call   800f98 <printnum>
  801498:	83 c4 20             	add    $0x20,%esp
			break;
  80149b:	eb 34                	jmp    8014d1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80149d:	83 ec 08             	sub    $0x8,%esp
  8014a0:	ff 75 0c             	pushl  0xc(%ebp)
  8014a3:	53                   	push   %ebx
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	ff d0                	call   *%eax
  8014a9:	83 c4 10             	add    $0x10,%esp
			break;
  8014ac:	eb 23                	jmp    8014d1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8014ae:	83 ec 08             	sub    $0x8,%esp
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	6a 25                	push   $0x25
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	ff d0                	call   *%eax
  8014bb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8014be:	ff 4d 10             	decl   0x10(%ebp)
  8014c1:	eb 03                	jmp    8014c6 <vprintfmt+0x3b1>
  8014c3:	ff 4d 10             	decl   0x10(%ebp)
  8014c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c9:	48                   	dec    %eax
  8014ca:	8a 00                	mov    (%eax),%al
  8014cc:	3c 25                	cmp    $0x25,%al
  8014ce:	75 f3                	jne    8014c3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8014d0:	90                   	nop
		}
	}
  8014d1:	e9 47 fc ff ff       	jmp    80111d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8014d6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8014d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014da:	5b                   	pop    %ebx
  8014db:	5e                   	pop    %esi
  8014dc:	5d                   	pop    %ebp
  8014dd:	c3                   	ret    

008014de <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014e4:	8d 45 10             	lea    0x10(%ebp),%eax
  8014e7:	83 c0 04             	add    $0x4,%eax
  8014ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8014f3:	50                   	push   %eax
  8014f4:	ff 75 0c             	pushl  0xc(%ebp)
  8014f7:	ff 75 08             	pushl  0x8(%ebp)
  8014fa:	e8 16 fc ff ff       	call   801115 <vprintfmt>
  8014ff:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801502:	90                   	nop
  801503:	c9                   	leave  
  801504:	c3                   	ret    

00801505 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	8b 40 08             	mov    0x8(%eax),%eax
  80150e:	8d 50 01             	lea    0x1(%eax),%edx
  801511:	8b 45 0c             	mov    0xc(%ebp),%eax
  801514:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151a:	8b 10                	mov    (%eax),%edx
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	8b 40 04             	mov    0x4(%eax),%eax
  801522:	39 c2                	cmp    %eax,%edx
  801524:	73 12                	jae    801538 <sprintputch+0x33>
		*b->buf++ = ch;
  801526:	8b 45 0c             	mov    0xc(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	8d 48 01             	lea    0x1(%eax),%ecx
  80152e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801531:	89 0a                	mov    %ecx,(%edx)
  801533:	8b 55 08             	mov    0x8(%ebp),%edx
  801536:	88 10                	mov    %dl,(%eax)
}
  801538:	90                   	nop
  801539:	5d                   	pop    %ebp
  80153a:	c3                   	ret    

0080153b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80153b:	55                   	push   %ebp
  80153c:	89 e5                	mov    %esp,%ebp
  80153e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801541:	8b 45 08             	mov    0x8(%ebp),%eax
  801544:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	01 d0                	add    %edx,%eax
  801552:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801555:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80155c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801560:	74 06                	je     801568 <vsnprintf+0x2d>
  801562:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801566:	7f 07                	jg     80156f <vsnprintf+0x34>
		return -E_INVAL;
  801568:	b8 03 00 00 00       	mov    $0x3,%eax
  80156d:	eb 20                	jmp    80158f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80156f:	ff 75 14             	pushl  0x14(%ebp)
  801572:	ff 75 10             	pushl  0x10(%ebp)
  801575:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801578:	50                   	push   %eax
  801579:	68 05 15 80 00       	push   $0x801505
  80157e:	e8 92 fb ff ff       	call   801115 <vprintfmt>
  801583:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801586:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801589:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80158c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80158f:	c9                   	leave  
  801590:	c3                   	ret    

00801591 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801591:	55                   	push   %ebp
  801592:	89 e5                	mov    %esp,%ebp
  801594:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801597:	8d 45 10             	lea    0x10(%ebp),%eax
  80159a:	83 c0 04             	add    $0x4,%eax
  80159d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8015a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a6:	50                   	push   %eax
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	ff 75 08             	pushl  0x8(%ebp)
  8015ad:	e8 89 ff ff ff       	call   80153b <vsnprintf>
  8015b2:	83 c4 10             	add    $0x10,%esp
  8015b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8015c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ca:	eb 06                	jmp    8015d2 <strlen+0x15>
		n++;
  8015cc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8015cf:	ff 45 08             	incl   0x8(%ebp)
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	8a 00                	mov    (%eax),%al
  8015d7:	84 c0                	test   %al,%al
  8015d9:	75 f1                	jne    8015cc <strlen+0xf>
		n++;
	return n;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015de:	c9                   	leave  
  8015df:	c3                   	ret    

008015e0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015ed:	eb 09                	jmp    8015f8 <strnlen+0x18>
		n++;
  8015ef:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015f2:	ff 45 08             	incl   0x8(%ebp)
  8015f5:	ff 4d 0c             	decl   0xc(%ebp)
  8015f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015fc:	74 09                	je     801607 <strnlen+0x27>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 00                	mov    (%eax),%al
  801603:	84 c0                	test   %al,%al
  801605:	75 e8                	jne    8015ef <strnlen+0xf>
		n++;
	return n;
  801607:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80160a:	c9                   	leave  
  80160b:	c3                   	ret    

0080160c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80160c:	55                   	push   %ebp
  80160d:	89 e5                	mov    %esp,%ebp
  80160f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801612:	8b 45 08             	mov    0x8(%ebp),%eax
  801615:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801618:	90                   	nop
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	8d 50 01             	lea    0x1(%eax),%edx
  80161f:	89 55 08             	mov    %edx,0x8(%ebp)
  801622:	8b 55 0c             	mov    0xc(%ebp),%edx
  801625:	8d 4a 01             	lea    0x1(%edx),%ecx
  801628:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80162b:	8a 12                	mov    (%edx),%dl
  80162d:	88 10                	mov    %dl,(%eax)
  80162f:	8a 00                	mov    (%eax),%al
  801631:	84 c0                	test   %al,%al
  801633:	75 e4                	jne    801619 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801635:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801638:	c9                   	leave  
  801639:	c3                   	ret    

0080163a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801646:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80164d:	eb 1f                	jmp    80166e <strncpy+0x34>
		*dst++ = *src;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8d 50 01             	lea    0x1(%eax),%edx
  801655:	89 55 08             	mov    %edx,0x8(%ebp)
  801658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80165b:	8a 12                	mov    (%edx),%dl
  80165d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80165f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801662:	8a 00                	mov    (%eax),%al
  801664:	84 c0                	test   %al,%al
  801666:	74 03                	je     80166b <strncpy+0x31>
			src++;
  801668:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80166b:	ff 45 fc             	incl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	3b 45 10             	cmp    0x10(%ebp),%eax
  801674:	72 d9                	jb     80164f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801676:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801679:	c9                   	leave  
  80167a:	c3                   	ret    

0080167b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801687:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80168b:	74 30                	je     8016bd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80168d:	eb 16                	jmp    8016a5 <strlcpy+0x2a>
			*dst++ = *src++;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8d 50 01             	lea    0x1(%eax),%edx
  801695:	89 55 08             	mov    %edx,0x8(%ebp)
  801698:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80169e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8016a1:	8a 12                	mov    (%edx),%dl
  8016a3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8016a5:	ff 4d 10             	decl   0x10(%ebp)
  8016a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ac:	74 09                	je     8016b7 <strlcpy+0x3c>
  8016ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	84 c0                	test   %al,%al
  8016b5:	75 d8                	jne    80168f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8016bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c3:	29 c2                	sub    %eax,%edx
  8016c5:	89 d0                	mov    %edx,%eax
}
  8016c7:	c9                   	leave  
  8016c8:	c3                   	ret    

008016c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8016c9:	55                   	push   %ebp
  8016ca:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8016cc:	eb 06                	jmp    8016d4 <strcmp+0xb>
		p++, q++;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8016d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d7:	8a 00                	mov    (%eax),%al
  8016d9:	84 c0                	test   %al,%al
  8016db:	74 0e                	je     8016eb <strcmp+0x22>
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8a 10                	mov    (%eax),%dl
  8016e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e5:	8a 00                	mov    (%eax),%al
  8016e7:	38 c2                	cmp    %al,%dl
  8016e9:	74 e3                	je     8016ce <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ee:	8a 00                	mov    (%eax),%al
  8016f0:	0f b6 d0             	movzbl %al,%edx
  8016f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f6:	8a 00                	mov    (%eax),%al
  8016f8:	0f b6 c0             	movzbl %al,%eax
  8016fb:	29 c2                	sub    %eax,%edx
  8016fd:	89 d0                	mov    %edx,%eax
}
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801704:	eb 09                	jmp    80170f <strncmp+0xe>
		n--, p++, q++;
  801706:	ff 4d 10             	decl   0x10(%ebp)
  801709:	ff 45 08             	incl   0x8(%ebp)
  80170c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80170f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801713:	74 17                	je     80172c <strncmp+0x2b>
  801715:	8b 45 08             	mov    0x8(%ebp),%eax
  801718:	8a 00                	mov    (%eax),%al
  80171a:	84 c0                	test   %al,%al
  80171c:	74 0e                	je     80172c <strncmp+0x2b>
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	8a 10                	mov    (%eax),%dl
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	8a 00                	mov    (%eax),%al
  801728:	38 c2                	cmp    %al,%dl
  80172a:	74 da                	je     801706 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80172c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801730:	75 07                	jne    801739 <strncmp+0x38>
		return 0;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	eb 14                	jmp    80174d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	0f b6 d0             	movzbl %al,%edx
  801741:	8b 45 0c             	mov    0xc(%ebp),%eax
  801744:	8a 00                	mov    (%eax),%al
  801746:	0f b6 c0             	movzbl %al,%eax
  801749:	29 c2                	sub    %eax,%edx
  80174b:	89 d0                	mov    %edx,%eax
}
  80174d:	5d                   	pop    %ebp
  80174e:	c3                   	ret    

0080174f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 04             	sub    $0x4,%esp
  801755:	8b 45 0c             	mov    0xc(%ebp),%eax
  801758:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80175b:	eb 12                	jmp    80176f <strchr+0x20>
		if (*s == c)
  80175d:	8b 45 08             	mov    0x8(%ebp),%eax
  801760:	8a 00                	mov    (%eax),%al
  801762:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801765:	75 05                	jne    80176c <strchr+0x1d>
			return (char *) s;
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	eb 11                	jmp    80177d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80176c:	ff 45 08             	incl   0x8(%ebp)
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8a 00                	mov    (%eax),%al
  801774:	84 c0                	test   %al,%al
  801776:	75 e5                	jne    80175d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    

0080177f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80177f:	55                   	push   %ebp
  801780:	89 e5                	mov    %esp,%ebp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	8b 45 0c             	mov    0xc(%ebp),%eax
  801788:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80178b:	eb 0d                	jmp    80179a <strfind+0x1b>
		if (*s == c)
  80178d:	8b 45 08             	mov    0x8(%ebp),%eax
  801790:	8a 00                	mov    (%eax),%al
  801792:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801795:	74 0e                	je     8017a5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801797:	ff 45 08             	incl   0x8(%ebp)
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	8a 00                	mov    (%eax),%al
  80179f:	84 c0                	test   %al,%al
  8017a1:	75 ea                	jne    80178d <strfind+0xe>
  8017a3:	eb 01                	jmp    8017a6 <strfind+0x27>
		if (*s == c)
			break;
  8017a5:	90                   	nop
	return (char *) s;
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017a9:	c9                   	leave  
  8017aa:	c3                   	ret    

008017ab <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8017b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8017b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8017bd:	eb 0e                	jmp    8017cd <memset+0x22>
		*p++ = c;
  8017bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017c2:	8d 50 01             	lea    0x1(%eax),%edx
  8017c5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8017cd:	ff 4d f8             	decl   -0x8(%ebp)
  8017d0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8017d4:	79 e9                	jns    8017bf <memset+0x14>
		*p++ = c;

	return v;
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017ed:	eb 16                	jmp    801805 <memcpy+0x2a>
		*d++ = *s++;
  8017ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017f2:	8d 50 01             	lea    0x1(%eax),%edx
  8017f5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017f8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017fb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017fe:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801801:	8a 12                	mov    (%edx),%dl
  801803:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801805:	8b 45 10             	mov    0x10(%ebp),%eax
  801808:	8d 50 ff             	lea    -0x1(%eax),%edx
  80180b:	89 55 10             	mov    %edx,0x10(%ebp)
  80180e:	85 c0                	test   %eax,%eax
  801810:	75 dd                	jne    8017ef <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801815:	c9                   	leave  
  801816:	c3                   	ret    

00801817 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80181d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801820:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801829:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80182c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80182f:	73 50                	jae    801881 <memmove+0x6a>
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8b 45 10             	mov    0x10(%ebp),%eax
  801837:	01 d0                	add    %edx,%eax
  801839:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80183c:	76 43                	jbe    801881 <memmove+0x6a>
		s += n;
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801844:	8b 45 10             	mov    0x10(%ebp),%eax
  801847:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80184a:	eb 10                	jmp    80185c <memmove+0x45>
			*--d = *--s;
  80184c:	ff 4d f8             	decl   -0x8(%ebp)
  80184f:	ff 4d fc             	decl   -0x4(%ebp)
  801852:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801855:	8a 10                	mov    (%eax),%dl
  801857:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80185a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80185c:	8b 45 10             	mov    0x10(%ebp),%eax
  80185f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801862:	89 55 10             	mov    %edx,0x10(%ebp)
  801865:	85 c0                	test   %eax,%eax
  801867:	75 e3                	jne    80184c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801869:	eb 23                	jmp    80188e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80186b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186e:	8d 50 01             	lea    0x1(%eax),%edx
  801871:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801874:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801877:	8d 4a 01             	lea    0x1(%edx),%ecx
  80187a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80187d:	8a 12                	mov    (%edx),%dl
  80187f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801881:	8b 45 10             	mov    0x10(%ebp),%eax
  801884:	8d 50 ff             	lea    -0x1(%eax),%edx
  801887:	89 55 10             	mov    %edx,0x10(%ebp)
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 dd                	jne    80186b <memmove+0x54>
			*d++ = *s++;

	return dst;
  80188e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801891:	c9                   	leave  
  801892:	c3                   	ret    

00801893 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801893:	55                   	push   %ebp
  801894:	89 e5                	mov    %esp,%ebp
  801896:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801899:	8b 45 08             	mov    0x8(%ebp),%eax
  80189c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8018a5:	eb 2a                	jmp    8018d1 <memcmp+0x3e>
		if (*s1 != *s2)
  8018a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018aa:	8a 10                	mov    (%eax),%dl
  8018ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	38 c2                	cmp    %al,%dl
  8018b3:	74 16                	je     8018cb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018c0:	8a 00                	mov    (%eax),%al
  8018c2:	0f b6 c0             	movzbl %al,%eax
  8018c5:	29 c2                	sub    %eax,%edx
  8018c7:	89 d0                	mov    %edx,%eax
  8018c9:	eb 18                	jmp    8018e3 <memcmp+0x50>
		s1++, s2++;
  8018cb:	ff 45 fc             	incl   -0x4(%ebp)
  8018ce:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8018d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  8018d7:	89 55 10             	mov    %edx,0x10(%ebp)
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	75 c9                	jne    8018a7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8018de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f1:	01 d0                	add    %edx,%eax
  8018f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018f6:	eb 15                	jmp    80190d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fb:	8a 00                	mov    (%eax),%al
  8018fd:	0f b6 d0             	movzbl %al,%edx
  801900:	8b 45 0c             	mov    0xc(%ebp),%eax
  801903:	0f b6 c0             	movzbl %al,%eax
  801906:	39 c2                	cmp    %eax,%edx
  801908:	74 0d                	je     801917 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80190a:	ff 45 08             	incl   0x8(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801913:	72 e3                	jb     8018f8 <memfind+0x13>
  801915:	eb 01                	jmp    801918 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801917:	90                   	nop
	return (void *) s;
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801923:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80192a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801931:	eb 03                	jmp    801936 <strtol+0x19>
		s++;
  801933:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	8a 00                	mov    (%eax),%al
  80193b:	3c 20                	cmp    $0x20,%al
  80193d:	74 f4                	je     801933 <strtol+0x16>
  80193f:	8b 45 08             	mov    0x8(%ebp),%eax
  801942:	8a 00                	mov    (%eax),%al
  801944:	3c 09                	cmp    $0x9,%al
  801946:	74 eb                	je     801933 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	8a 00                	mov    (%eax),%al
  80194d:	3c 2b                	cmp    $0x2b,%al
  80194f:	75 05                	jne    801956 <strtol+0x39>
		s++;
  801951:	ff 45 08             	incl   0x8(%ebp)
  801954:	eb 13                	jmp    801969 <strtol+0x4c>
	else if (*s == '-')
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	8a 00                	mov    (%eax),%al
  80195b:	3c 2d                	cmp    $0x2d,%al
  80195d:	75 0a                	jne    801969 <strtol+0x4c>
		s++, neg = 1;
  80195f:	ff 45 08             	incl   0x8(%ebp)
  801962:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801969:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196d:	74 06                	je     801975 <strtol+0x58>
  80196f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801973:	75 20                	jne    801995 <strtol+0x78>
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	8a 00                	mov    (%eax),%al
  80197a:	3c 30                	cmp    $0x30,%al
  80197c:	75 17                	jne    801995 <strtol+0x78>
  80197e:	8b 45 08             	mov    0x8(%ebp),%eax
  801981:	40                   	inc    %eax
  801982:	8a 00                	mov    (%eax),%al
  801984:	3c 78                	cmp    $0x78,%al
  801986:	75 0d                	jne    801995 <strtol+0x78>
		s += 2, base = 16;
  801988:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80198c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801993:	eb 28                	jmp    8019bd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801995:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801999:	75 15                	jne    8019b0 <strtol+0x93>
  80199b:	8b 45 08             	mov    0x8(%ebp),%eax
  80199e:	8a 00                	mov    (%eax),%al
  8019a0:	3c 30                	cmp    $0x30,%al
  8019a2:	75 0c                	jne    8019b0 <strtol+0x93>
		s++, base = 8;
  8019a4:	ff 45 08             	incl   0x8(%ebp)
  8019a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8019ae:	eb 0d                	jmp    8019bd <strtol+0xa0>
	else if (base == 0)
  8019b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019b4:	75 07                	jne    8019bd <strtol+0xa0>
		base = 10;
  8019b6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8019bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c0:	8a 00                	mov    (%eax),%al
  8019c2:	3c 2f                	cmp    $0x2f,%al
  8019c4:	7e 19                	jle    8019df <strtol+0xc2>
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	8a 00                	mov    (%eax),%al
  8019cb:	3c 39                	cmp    $0x39,%al
  8019cd:	7f 10                	jg     8019df <strtol+0xc2>
			dig = *s - '0';
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	8a 00                	mov    (%eax),%al
  8019d4:	0f be c0             	movsbl %al,%eax
  8019d7:	83 e8 30             	sub    $0x30,%eax
  8019da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019dd:	eb 42                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8a 00                	mov    (%eax),%al
  8019e4:	3c 60                	cmp    $0x60,%al
  8019e6:	7e 19                	jle    801a01 <strtol+0xe4>
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	8a 00                	mov    (%eax),%al
  8019ed:	3c 7a                	cmp    $0x7a,%al
  8019ef:	7f 10                	jg     801a01 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	8a 00                	mov    (%eax),%al
  8019f6:	0f be c0             	movsbl %al,%eax
  8019f9:	83 e8 57             	sub    $0x57,%eax
  8019fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019ff:	eb 20                	jmp    801a21 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	3c 40                	cmp    $0x40,%al
  801a08:	7e 39                	jle    801a43 <strtol+0x126>
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	3c 5a                	cmp    $0x5a,%al
  801a11:	7f 30                	jg     801a43 <strtol+0x126>
			dig = *s - 'A' + 10;
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	8a 00                	mov    (%eax),%al
  801a18:	0f be c0             	movsbl %al,%eax
  801a1b:	83 e8 37             	sub    $0x37,%eax
  801a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a24:	3b 45 10             	cmp    0x10(%ebp),%eax
  801a27:	7d 19                	jge    801a42 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801a29:	ff 45 08             	incl   0x8(%ebp)
  801a2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801a3d:	e9 7b ff ff ff       	jmp    8019bd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801a42:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a43:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a47:	74 08                	je     801a51 <strtol+0x134>
		*endptr = (char *) s;
  801a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a51:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a55:	74 07                	je     801a5e <strtol+0x141>
  801a57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5a:	f7 d8                	neg    %eax
  801a5c:	eb 03                	jmp    801a61 <strtol+0x144>
  801a5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <ltostr>:

void
ltostr(long value, char *str)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a69:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a7b:	79 13                	jns    801a90 <ltostr+0x2d>
	{
		neg = 1;
  801a7d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a87:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a8a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a8d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a98:	99                   	cltd   
  801a99:	f7 f9                	idiv   %ecx
  801a9b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa1:	8d 50 01             	lea    0x1(%eax),%edx
  801aa4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aa7:	89 c2                	mov    %eax,%edx
  801aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aac:	01 d0                	add    %edx,%eax
  801aae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801ab1:	83 c2 30             	add    $0x30,%edx
  801ab4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801ab6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ab9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801abe:	f7 e9                	imul   %ecx
  801ac0:	c1 fa 02             	sar    $0x2,%edx
  801ac3:	89 c8                	mov    %ecx,%eax
  801ac5:	c1 f8 1f             	sar    $0x1f,%eax
  801ac8:	29 c2                	sub    %eax,%edx
  801aca:	89 d0                	mov    %edx,%eax
  801acc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801acf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ad2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801ad7:	f7 e9                	imul   %ecx
  801ad9:	c1 fa 02             	sar    $0x2,%edx
  801adc:	89 c8                	mov    %ecx,%eax
  801ade:	c1 f8 1f             	sar    $0x1f,%eax
  801ae1:	29 c2                	sub    %eax,%edx
  801ae3:	89 d0                	mov    %edx,%eax
  801ae5:	c1 e0 02             	shl    $0x2,%eax
  801ae8:	01 d0                	add    %edx,%eax
  801aea:	01 c0                	add    %eax,%eax
  801aec:	29 c1                	sub    %eax,%ecx
  801aee:	89 ca                	mov    %ecx,%edx
  801af0:	85 d2                	test   %edx,%edx
  801af2:	75 9c                	jne    801a90 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801af4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afe:	48                   	dec    %eax
  801aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801b02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801b06:	74 3d                	je     801b45 <ltostr+0xe2>
		start = 1 ;
  801b08:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801b0f:	eb 34                	jmp    801b45 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801b11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b17:	01 d0                	add    %edx,%eax
  801b19:	8a 00                	mov    (%eax),%al
  801b1b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801b1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b24:	01 c2                	add    %eax,%edx
  801b26:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801b29:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2c:	01 c8                	add    %ecx,%eax
  801b2e:	8a 00                	mov    (%eax),%al
  801b30:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801b32:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b38:	01 c2                	add    %eax,%edx
  801b3a:	8a 45 eb             	mov    -0x15(%ebp),%al
  801b3d:	88 02                	mov    %al,(%edx)
		start++ ;
  801b3f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801b42:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b48:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b4b:	7c c4                	jl     801b11 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b4d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	01 d0                	add    %edx,%eax
  801b55:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b61:	ff 75 08             	pushl  0x8(%ebp)
  801b64:	e8 54 fa ff ff       	call   8015bd <strlen>
  801b69:	83 c4 04             	add    $0x4,%esp
  801b6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	e8 46 fa ff ff       	call   8015bd <strlen>
  801b77:	83 c4 04             	add    $0x4,%esp
  801b7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b84:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b8b:	eb 17                	jmp    801ba4 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b8d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b90:	8b 45 10             	mov    0x10(%ebp),%eax
  801b93:	01 c2                	add    %eax,%edx
  801b95:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	01 c8                	add    %ecx,%eax
  801b9d:	8a 00                	mov    (%eax),%al
  801b9f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ba1:	ff 45 fc             	incl   -0x4(%ebp)
  801ba4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ba7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801baa:	7c e1                	jl     801b8d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801bac:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801bb3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801bba:	eb 1f                	jmp    801bdb <strcconcat+0x80>
		final[s++] = str2[i] ;
  801bbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bbf:	8d 50 01             	lea    0x1(%eax),%edx
  801bc2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801bc5:	89 c2                	mov    %eax,%edx
  801bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bca:	01 c2                	add    %eax,%edx
  801bcc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801bcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd2:	01 c8                	add    %ecx,%eax
  801bd4:	8a 00                	mov    (%eax),%al
  801bd6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801bd8:	ff 45 f8             	incl   -0x8(%ebp)
  801bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bde:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801be1:	7c d9                	jl     801bbc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801be3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801be6:	8b 45 10             	mov    0x10(%ebp),%eax
  801be9:	01 d0                	add    %edx,%eax
  801beb:	c6 00 00             	movb   $0x0,(%eax)
}
  801bee:	90                   	nop
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bf4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bfd:	8b 45 14             	mov    0x14(%ebp),%eax
  801c00:	8b 00                	mov    (%eax),%eax
  801c02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c09:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0c:	01 d0                	add    %edx,%eax
  801c0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c14:	eb 0c                	jmp    801c22 <strsplit+0x31>
			*string++ = 0;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8d 50 01             	lea    0x1(%eax),%edx
  801c1c:	89 55 08             	mov    %edx,0x8(%ebp)
  801c1f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	8a 00                	mov    (%eax),%al
  801c27:	84 c0                	test   %al,%al
  801c29:	74 18                	je     801c43 <strsplit+0x52>
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8a 00                	mov    (%eax),%al
  801c30:	0f be c0             	movsbl %al,%eax
  801c33:	50                   	push   %eax
  801c34:	ff 75 0c             	pushl  0xc(%ebp)
  801c37:	e8 13 fb ff ff       	call   80174f <strchr>
  801c3c:	83 c4 08             	add    $0x8,%esp
  801c3f:	85 c0                	test   %eax,%eax
  801c41:	75 d3                	jne    801c16 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c43:	8b 45 08             	mov    0x8(%ebp),%eax
  801c46:	8a 00                	mov    (%eax),%al
  801c48:	84 c0                	test   %al,%al
  801c4a:	74 5a                	je     801ca6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801c4f:	8b 00                	mov    (%eax),%eax
  801c51:	83 f8 0f             	cmp    $0xf,%eax
  801c54:	75 07                	jne    801c5d <strsplit+0x6c>
		{
			return 0;
  801c56:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5b:	eb 66                	jmp    801cc3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801c60:	8b 00                	mov    (%eax),%eax
  801c62:	8d 48 01             	lea    0x1(%eax),%ecx
  801c65:	8b 55 14             	mov    0x14(%ebp),%edx
  801c68:	89 0a                	mov    %ecx,(%edx)
  801c6a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c71:	8b 45 10             	mov    0x10(%ebp),%eax
  801c74:	01 c2                	add    %eax,%edx
  801c76:	8b 45 08             	mov    0x8(%ebp),%eax
  801c79:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c7b:	eb 03                	jmp    801c80 <strsplit+0x8f>
			string++;
  801c7d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	8a 00                	mov    (%eax),%al
  801c85:	84 c0                	test   %al,%al
  801c87:	74 8b                	je     801c14 <strsplit+0x23>
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	8a 00                	mov    (%eax),%al
  801c8e:	0f be c0             	movsbl %al,%eax
  801c91:	50                   	push   %eax
  801c92:	ff 75 0c             	pushl  0xc(%ebp)
  801c95:	e8 b5 fa ff ff       	call   80174f <strchr>
  801c9a:	83 c4 08             	add    $0x8,%esp
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	74 dc                	je     801c7d <strsplit+0x8c>
			string++;
	}
  801ca1:	e9 6e ff ff ff       	jmp    801c14 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ca6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	8b 00                	mov    (%eax),%eax
  801cac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801cb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb6:	01 d0                	add    %edx,%eax
  801cb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801cbe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801cc3:	c9                   	leave  
  801cc4:	c3                   	ret    

00801cc5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801cc5:	55                   	push   %ebp
  801cc6:	89 e5                	mov    %esp,%ebp
  801cc8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ccb:	a1 04 50 80 00       	mov    0x805004,%eax
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	74 1f                	je     801cf3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801cd4:	e8 1d 00 00 00       	call   801cf6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801cd9:	83 ec 0c             	sub    $0xc,%esp
  801cdc:	68 d0 46 80 00       	push   $0x8046d0
  801ce1:	e8 55 f2 ff ff       	call   800f3b <cprintf>
  801ce6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ce9:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cf0:	00 00 00 
	}
}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801cfc:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801d03:	00 00 00 
  801d06:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801d0d:	00 00 00 
  801d10:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801d17:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801d1a:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801d21:	00 00 00 
  801d24:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801d2b:	00 00 00 
  801d2e:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801d35:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801d38:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d42:	c1 e8 0c             	shr    $0xc,%eax
  801d45:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801d4a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d59:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d5e:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801d63:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801d6a:	a1 20 51 80 00       	mov    0x805120,%eax
  801d6f:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801d73:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801d76:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801d7d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d83:	01 d0                	add    %edx,%eax
  801d85:	48                   	dec    %eax
  801d86:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d89:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d8c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d91:	f7 75 e4             	divl   -0x1c(%ebp)
  801d94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d97:	29 d0                	sub    %edx,%eax
  801d99:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801d9c:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801da3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801da6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801dab:	2d 00 10 00 00       	sub    $0x1000,%eax
  801db0:	83 ec 04             	sub    $0x4,%esp
  801db3:	6a 07                	push   $0x7
  801db5:	ff 75 e8             	pushl  -0x18(%ebp)
  801db8:	50                   	push   %eax
  801db9:	e8 3d 06 00 00       	call   8023fb <sys_allocate_chunk>
  801dbe:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801dc1:	a1 20 51 80 00       	mov    0x805120,%eax
  801dc6:	83 ec 0c             	sub    $0xc,%esp
  801dc9:	50                   	push   %eax
  801dca:	e8 b2 0c 00 00       	call   802a81 <initialize_MemBlocksList>
  801dcf:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801dd2:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801dd7:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801dda:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801dde:	0f 84 f3 00 00 00    	je     801ed7 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801de4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801de8:	75 14                	jne    801dfe <initialize_dyn_block_system+0x108>
  801dea:	83 ec 04             	sub    $0x4,%esp
  801ded:	68 f5 46 80 00       	push   $0x8046f5
  801df2:	6a 36                	push   $0x36
  801df4:	68 13 47 80 00       	push   $0x804713
  801df9:	e8 89 ee ff ff       	call   800c87 <_panic>
  801dfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e01:	8b 00                	mov    (%eax),%eax
  801e03:	85 c0                	test   %eax,%eax
  801e05:	74 10                	je     801e17 <initialize_dyn_block_system+0x121>
  801e07:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e0a:	8b 00                	mov    (%eax),%eax
  801e0c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e0f:	8b 52 04             	mov    0x4(%edx),%edx
  801e12:	89 50 04             	mov    %edx,0x4(%eax)
  801e15:	eb 0b                	jmp    801e22 <initialize_dyn_block_system+0x12c>
  801e17:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e1a:	8b 40 04             	mov    0x4(%eax),%eax
  801e1d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801e22:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e25:	8b 40 04             	mov    0x4(%eax),%eax
  801e28:	85 c0                	test   %eax,%eax
  801e2a:	74 0f                	je     801e3b <initialize_dyn_block_system+0x145>
  801e2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e2f:	8b 40 04             	mov    0x4(%eax),%eax
  801e32:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e35:	8b 12                	mov    (%edx),%edx
  801e37:	89 10                	mov    %edx,(%eax)
  801e39:	eb 0a                	jmp    801e45 <initialize_dyn_block_system+0x14f>
  801e3b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e3e:	8b 00                	mov    (%eax),%eax
  801e40:	a3 48 51 80 00       	mov    %eax,0x805148
  801e45:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e58:	a1 54 51 80 00       	mov    0x805154,%eax
  801e5d:	48                   	dec    %eax
  801e5e:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801e63:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e66:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801e6d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e70:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801e77:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801e7b:	75 14                	jne    801e91 <initialize_dyn_block_system+0x19b>
  801e7d:	83 ec 04             	sub    $0x4,%esp
  801e80:	68 20 47 80 00       	push   $0x804720
  801e85:	6a 3e                	push   $0x3e
  801e87:	68 13 47 80 00       	push   $0x804713
  801e8c:	e8 f6 ed ff ff       	call   800c87 <_panic>
  801e91:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801e97:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e9a:	89 10                	mov    %edx,(%eax)
  801e9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e9f:	8b 00                	mov    (%eax),%eax
  801ea1:	85 c0                	test   %eax,%eax
  801ea3:	74 0d                	je     801eb2 <initialize_dyn_block_system+0x1bc>
  801ea5:	a1 38 51 80 00       	mov    0x805138,%eax
  801eaa:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ead:	89 50 04             	mov    %edx,0x4(%eax)
  801eb0:	eb 08                	jmp    801eba <initialize_dyn_block_system+0x1c4>
  801eb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801eb5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801eba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ebd:	a3 38 51 80 00       	mov    %eax,0x805138
  801ec2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ec5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ecc:	a1 44 51 80 00       	mov    0x805144,%eax
  801ed1:	40                   	inc    %eax
  801ed2:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801ed7:	90                   	nop
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801ee0:	e8 e0 fd ff ff       	call   801cc5 <InitializeUHeap>
		if (size == 0) return NULL ;
  801ee5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ee9:	75 07                	jne    801ef2 <malloc+0x18>
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef0:	eb 7f                	jmp    801f71 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801ef2:	e8 d2 08 00 00       	call   8027c9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	74 71                	je     801f6c <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801efb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801f02:	8b 55 08             	mov    0x8(%ebp),%edx
  801f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f08:	01 d0                	add    %edx,%eax
  801f0a:	48                   	dec    %eax
  801f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f11:	ba 00 00 00 00       	mov    $0x0,%edx
  801f16:	f7 75 f4             	divl   -0xc(%ebp)
  801f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1c:	29 d0                	sub    %edx,%eax
  801f1e:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801f21:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801f28:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801f2f:	76 07                	jbe    801f38 <malloc+0x5e>
					return NULL ;
  801f31:	b8 00 00 00 00       	mov    $0x0,%eax
  801f36:	eb 39                	jmp    801f71 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801f38:	83 ec 0c             	sub    $0xc,%esp
  801f3b:	ff 75 08             	pushl  0x8(%ebp)
  801f3e:	e8 e6 0d 00 00       	call   802d29 <alloc_block_FF>
  801f43:	83 c4 10             	add    $0x10,%esp
  801f46:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801f49:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f4d:	74 16                	je     801f65 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801f4f:	83 ec 0c             	sub    $0xc,%esp
  801f52:	ff 75 ec             	pushl  -0x14(%ebp)
  801f55:	e8 37 0c 00 00       	call   802b91 <insert_sorted_allocList>
  801f5a:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801f5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f60:	8b 40 08             	mov    0x8(%eax),%eax
  801f63:	eb 0c                	jmp    801f71 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801f65:	b8 00 00 00 00       	mov    $0x0,%eax
  801f6a:	eb 05                	jmp    801f71 <malloc+0x97>
				}
		}
	return 0;
  801f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f71:	c9                   	leave  
  801f72:	c3                   	ret    

00801f73 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f73:	55                   	push   %ebp
  801f74:	89 e5                	mov    %esp,%ebp
  801f76:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801f7f:	83 ec 08             	sub    $0x8,%esp
  801f82:	ff 75 f4             	pushl  -0xc(%ebp)
  801f85:	68 40 50 80 00       	push   $0x805040
  801f8a:	e8 cf 0b 00 00       	call   802b5e <find_block>
  801f8f:	83 c4 10             	add    $0x10,%esp
  801f92:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f98:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa1:	8b 40 08             	mov    0x8(%eax),%eax
  801fa4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801fa7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fab:	0f 84 a1 00 00 00    	je     802052 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801fb1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb5:	75 17                	jne    801fce <free+0x5b>
  801fb7:	83 ec 04             	sub    $0x4,%esp
  801fba:	68 f5 46 80 00       	push   $0x8046f5
  801fbf:	68 80 00 00 00       	push   $0x80
  801fc4:	68 13 47 80 00       	push   $0x804713
  801fc9:	e8 b9 ec ff ff       	call   800c87 <_panic>
  801fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd1:	8b 00                	mov    (%eax),%eax
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	74 10                	je     801fe7 <free+0x74>
  801fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fda:	8b 00                	mov    (%eax),%eax
  801fdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fdf:	8b 52 04             	mov    0x4(%edx),%edx
  801fe2:	89 50 04             	mov    %edx,0x4(%eax)
  801fe5:	eb 0b                	jmp    801ff2 <free+0x7f>
  801fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fea:	8b 40 04             	mov    0x4(%eax),%eax
  801fed:	a3 44 50 80 00       	mov    %eax,0x805044
  801ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff5:	8b 40 04             	mov    0x4(%eax),%eax
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	74 0f                	je     80200b <free+0x98>
  801ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fff:	8b 40 04             	mov    0x4(%eax),%eax
  802002:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802005:	8b 12                	mov    (%edx),%edx
  802007:	89 10                	mov    %edx,(%eax)
  802009:	eb 0a                	jmp    802015 <free+0xa2>
  80200b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80200e:	8b 00                	mov    (%eax),%eax
  802010:	a3 40 50 80 00       	mov    %eax,0x805040
  802015:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80201e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802021:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802028:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80202d:	48                   	dec    %eax
  80202e:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	ff 75 f0             	pushl  -0x10(%ebp)
  802039:	e8 29 12 00 00       	call   803267 <insert_sorted_with_merge_freeList>
  80203e:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  802041:	83 ec 08             	sub    $0x8,%esp
  802044:	ff 75 ec             	pushl  -0x14(%ebp)
  802047:	ff 75 e8             	pushl  -0x18(%ebp)
  80204a:	e8 74 03 00 00       	call   8023c3 <sys_free_user_mem>
  80204f:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  802052:	90                   	nop
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 38             	sub    $0x38,%esp
  80205b:	8b 45 10             	mov    0x10(%ebp),%eax
  80205e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802061:	e8 5f fc ff ff       	call   801cc5 <InitializeUHeap>
	if (size == 0) return NULL ;
  802066:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80206a:	75 0a                	jne    802076 <smalloc+0x21>
  80206c:	b8 00 00 00 00       	mov    $0x0,%eax
  802071:	e9 b2 00 00 00       	jmp    802128 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  802076:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80207d:	76 0a                	jbe    802089 <smalloc+0x34>
		return NULL;
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	e9 9f 00 00 00       	jmp    802128 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  802089:	e8 3b 07 00 00       	call   8027c9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80208e:	85 c0                	test   %eax,%eax
  802090:	0f 84 8d 00 00 00    	je     802123 <smalloc+0xce>
	struct MemBlock *b = NULL;
  802096:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80209d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8020a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020aa:	01 d0                	add    %edx,%eax
  8020ac:	48                   	dec    %eax
  8020ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8020b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8020b8:	f7 75 f0             	divl   -0x10(%ebp)
  8020bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8020be:	29 d0                	sub    %edx,%eax
  8020c0:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8020c3:	83 ec 0c             	sub    $0xc,%esp
  8020c6:	ff 75 e8             	pushl  -0x18(%ebp)
  8020c9:	e8 5b 0c 00 00       	call   802d29 <alloc_block_FF>
  8020ce:	83 c4 10             	add    $0x10,%esp
  8020d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8020d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d8:	75 07                	jne    8020e1 <smalloc+0x8c>
			return NULL;
  8020da:	b8 00 00 00 00       	mov    $0x0,%eax
  8020df:	eb 47                	jmp    802128 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8020e1:	83 ec 0c             	sub    $0xc,%esp
  8020e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e7:	e8 a5 0a 00 00       	call   802b91 <insert_sorted_allocList>
  8020ec:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8020ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f2:	8b 40 08             	mov    0x8(%eax),%eax
  8020f5:	89 c2                	mov    %eax,%edx
  8020f7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8020fb:	52                   	push   %edx
  8020fc:	50                   	push   %eax
  8020fd:	ff 75 0c             	pushl  0xc(%ebp)
  802100:	ff 75 08             	pushl  0x8(%ebp)
  802103:	e8 46 04 00 00       	call   80254e <sys_createSharedObject>
  802108:	83 c4 10             	add    $0x10,%esp
  80210b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80210e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802112:	78 08                	js     80211c <smalloc+0xc7>
		return (void *)b->sva;
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	8b 40 08             	mov    0x8(%eax),%eax
  80211a:	eb 0c                	jmp    802128 <smalloc+0xd3>
		}else{
		return NULL;
  80211c:	b8 00 00 00 00       	mov    $0x0,%eax
  802121:	eb 05                	jmp    802128 <smalloc+0xd3>
			}

	}return NULL;
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802130:	e8 90 fb ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802135:	e8 8f 06 00 00       	call   8027c9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80213a:	85 c0                	test   %eax,%eax
  80213c:	0f 84 ad 00 00 00    	je     8021ef <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802142:	83 ec 08             	sub    $0x8,%esp
  802145:	ff 75 0c             	pushl  0xc(%ebp)
  802148:	ff 75 08             	pushl  0x8(%ebp)
  80214b:	e8 28 04 00 00       	call   802578 <sys_getSizeOfSharedObject>
  802150:	83 c4 10             	add    $0x10,%esp
  802153:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  802156:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215a:	79 0a                	jns    802166 <sget+0x3c>
    {
    	return NULL;
  80215c:	b8 00 00 00 00       	mov    $0x0,%eax
  802161:	e9 8e 00 00 00       	jmp    8021f4 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  802166:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80216d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802174:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802177:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80217a:	01 d0                	add    %edx,%eax
  80217c:	48                   	dec    %eax
  80217d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802180:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802183:	ba 00 00 00 00       	mov    $0x0,%edx
  802188:	f7 75 ec             	divl   -0x14(%ebp)
  80218b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80218e:	29 d0                	sub    %edx,%eax
  802190:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  802193:	83 ec 0c             	sub    $0xc,%esp
  802196:	ff 75 e4             	pushl  -0x1c(%ebp)
  802199:	e8 8b 0b 00 00       	call   802d29 <alloc_block_FF>
  80219e:	83 c4 10             	add    $0x10,%esp
  8021a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8021a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021a8:	75 07                	jne    8021b1 <sget+0x87>
				return NULL;
  8021aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8021af:	eb 43                	jmp    8021f4 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8021b1:	83 ec 0c             	sub    $0xc,%esp
  8021b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8021b7:	e8 d5 09 00 00       	call   802b91 <insert_sorted_allocList>
  8021bc:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8021bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021c2:	8b 40 08             	mov    0x8(%eax),%eax
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	50                   	push   %eax
  8021c9:	ff 75 0c             	pushl  0xc(%ebp)
  8021cc:	ff 75 08             	pushl  0x8(%ebp)
  8021cf:	e8 c1 03 00 00       	call   802595 <sys_getSharedObject>
  8021d4:	83 c4 10             	add    $0x10,%esp
  8021d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8021da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8021de:	78 08                	js     8021e8 <sget+0xbe>
			return (void *)b->sva;
  8021e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e3:	8b 40 08             	mov    0x8(%eax),%eax
  8021e6:	eb 0c                	jmp    8021f4 <sget+0xca>
			}else{
			return NULL;
  8021e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ed:	eb 05                	jmp    8021f4 <sget+0xca>
			}
    }}return NULL;
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021fc:	e8 c4 fa ff ff       	call   801cc5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802201:	83 ec 04             	sub    $0x4,%esp
  802204:	68 44 47 80 00       	push   $0x804744
  802209:	68 03 01 00 00       	push   $0x103
  80220e:	68 13 47 80 00       	push   $0x804713
  802213:	e8 6f ea ff ff       	call   800c87 <_panic>

00802218 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802218:	55                   	push   %ebp
  802219:	89 e5                	mov    %esp,%ebp
  80221b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	68 6c 47 80 00       	push   $0x80476c
  802226:	68 17 01 00 00       	push   $0x117
  80222b:	68 13 47 80 00       	push   $0x804713
  802230:	e8 52 ea ff ff       	call   800c87 <_panic>

00802235 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 90 47 80 00       	push   $0x804790
  802243:	68 22 01 00 00       	push   $0x122
  802248:	68 13 47 80 00       	push   $0x804713
  80224d:	e8 35 ea ff ff       	call   800c87 <_panic>

00802252 <shrink>:

}
void shrink(uint32 newSize)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
  802255:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802258:	83 ec 04             	sub    $0x4,%esp
  80225b:	68 90 47 80 00       	push   $0x804790
  802260:	68 27 01 00 00       	push   $0x127
  802265:	68 13 47 80 00       	push   $0x804713
  80226a:	e8 18 ea ff ff       	call   800c87 <_panic>

0080226f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80226f:	55                   	push   %ebp
  802270:	89 e5                	mov    %esp,%ebp
  802272:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802275:	83 ec 04             	sub    $0x4,%esp
  802278:	68 90 47 80 00       	push   $0x804790
  80227d:	68 2c 01 00 00       	push   $0x12c
  802282:	68 13 47 80 00       	push   $0x804713
  802287:	e8 fb e9 ff ff       	call   800c87 <_panic>

0080228c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80228c:	55                   	push   %ebp
  80228d:	89 e5                	mov    %esp,%ebp
  80228f:	57                   	push   %edi
  802290:	56                   	push   %esi
  802291:	53                   	push   %ebx
  802292:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802295:	8b 45 08             	mov    0x8(%ebp),%eax
  802298:	8b 55 0c             	mov    0xc(%ebp),%edx
  80229b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80229e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022a1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8022a4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8022a7:	cd 30                	int    $0x30
  8022a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8022ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8022af:	83 c4 10             	add    $0x10,%esp
  8022b2:	5b                   	pop    %ebx
  8022b3:	5e                   	pop    %esi
  8022b4:	5f                   	pop    %edi
  8022b5:	5d                   	pop    %ebp
  8022b6:	c3                   	ret    

008022b7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8022b7:	55                   	push   %ebp
  8022b8:	89 e5                	mov    %esp,%ebp
  8022ba:	83 ec 04             	sub    $0x4,%esp
  8022bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8022c0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8022c3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8022c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	52                   	push   %edx
  8022cf:	ff 75 0c             	pushl  0xc(%ebp)
  8022d2:	50                   	push   %eax
  8022d3:	6a 00                	push   $0x0
  8022d5:	e8 b2 ff ff ff       	call   80228c <syscall>
  8022da:	83 c4 18             	add    $0x18,%esp
}
  8022dd:	90                   	nop
  8022de:	c9                   	leave  
  8022df:	c3                   	ret    

008022e0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8022e0:	55                   	push   %ebp
  8022e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 01                	push   $0x1
  8022ef:	e8 98 ff ff ff       	call   80228c <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
}
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	52                   	push   %edx
  802309:	50                   	push   %eax
  80230a:	6a 05                	push   $0x5
  80230c:	e8 7b ff ff ff       	call   80228c <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	56                   	push   %esi
  80231a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80231b:	8b 75 18             	mov    0x18(%ebp),%esi
  80231e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802321:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802324:	8b 55 0c             	mov    0xc(%ebp),%edx
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	56                   	push   %esi
  80232b:	53                   	push   %ebx
  80232c:	51                   	push   %ecx
  80232d:	52                   	push   %edx
  80232e:	50                   	push   %eax
  80232f:	6a 06                	push   $0x6
  802331:	e8 56 ff ff ff       	call   80228c <syscall>
  802336:	83 c4 18             	add    $0x18,%esp
}
  802339:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5e                   	pop    %esi
  80233e:	5d                   	pop    %ebp
  80233f:	c3                   	ret    

00802340 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802340:	55                   	push   %ebp
  802341:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802343:	8b 55 0c             	mov    0xc(%ebp),%edx
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	52                   	push   %edx
  802350:	50                   	push   %eax
  802351:	6a 07                	push   $0x7
  802353:	e8 34 ff ff ff       	call   80228c <syscall>
  802358:	83 c4 18             	add    $0x18,%esp
}
  80235b:	c9                   	leave  
  80235c:	c3                   	ret    

0080235d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80235d:	55                   	push   %ebp
  80235e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802360:	6a 00                	push   $0x0
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	ff 75 0c             	pushl  0xc(%ebp)
  802369:	ff 75 08             	pushl  0x8(%ebp)
  80236c:	6a 08                	push   $0x8
  80236e:	e8 19 ff ff ff       	call   80228c <syscall>
  802373:	83 c4 18             	add    $0x18,%esp
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 09                	push   $0x9
  802387:	e8 00 ff ff ff       	call   80228c <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
}
  80238f:	c9                   	leave  
  802390:	c3                   	ret    

00802391 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802391:	55                   	push   %ebp
  802392:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802394:	6a 00                	push   $0x0
  802396:	6a 00                	push   $0x0
  802398:	6a 00                	push   $0x0
  80239a:	6a 00                	push   $0x0
  80239c:	6a 00                	push   $0x0
  80239e:	6a 0a                	push   $0xa
  8023a0:	e8 e7 fe ff ff       	call   80228c <syscall>
  8023a5:	83 c4 18             	add    $0x18,%esp
}
  8023a8:	c9                   	leave  
  8023a9:	c3                   	ret    

008023aa <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8023ad:	6a 00                	push   $0x0
  8023af:	6a 00                	push   $0x0
  8023b1:	6a 00                	push   $0x0
  8023b3:	6a 00                	push   $0x0
  8023b5:	6a 00                	push   $0x0
  8023b7:	6a 0b                	push   $0xb
  8023b9:	e8 ce fe ff ff       	call   80228c <syscall>
  8023be:	83 c4 18             	add    $0x18,%esp
}
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8023c6:	6a 00                	push   $0x0
  8023c8:	6a 00                	push   $0x0
  8023ca:	6a 00                	push   $0x0
  8023cc:	ff 75 0c             	pushl  0xc(%ebp)
  8023cf:	ff 75 08             	pushl  0x8(%ebp)
  8023d2:	6a 0f                	push   $0xf
  8023d4:	e8 b3 fe ff ff       	call   80228c <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
	return;
  8023dc:	90                   	nop
}
  8023dd:	c9                   	leave  
  8023de:	c3                   	ret    

008023df <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8023df:	55                   	push   %ebp
  8023e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	ff 75 0c             	pushl  0xc(%ebp)
  8023eb:	ff 75 08             	pushl  0x8(%ebp)
  8023ee:	6a 10                	push   $0x10
  8023f0:	e8 97 fe ff ff       	call   80228c <syscall>
  8023f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f8:	90                   	nop
}
  8023f9:	c9                   	leave  
  8023fa:	c3                   	ret    

008023fb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023fb:	55                   	push   %ebp
  8023fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023fe:	6a 00                	push   $0x0
  802400:	6a 00                	push   $0x0
  802402:	ff 75 10             	pushl  0x10(%ebp)
  802405:	ff 75 0c             	pushl  0xc(%ebp)
  802408:	ff 75 08             	pushl  0x8(%ebp)
  80240b:	6a 11                	push   $0x11
  80240d:	e8 7a fe ff ff       	call   80228c <syscall>
  802412:	83 c4 18             	add    $0x18,%esp
	return ;
  802415:	90                   	nop
}
  802416:	c9                   	leave  
  802417:	c3                   	ret    

00802418 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802418:	55                   	push   %ebp
  802419:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80241b:	6a 00                	push   $0x0
  80241d:	6a 00                	push   $0x0
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	6a 0c                	push   $0xc
  802427:	e8 60 fe ff ff       	call   80228c <syscall>
  80242c:	83 c4 18             	add    $0x18,%esp
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802434:	6a 00                	push   $0x0
  802436:	6a 00                	push   $0x0
  802438:	6a 00                	push   $0x0
  80243a:	6a 00                	push   $0x0
  80243c:	ff 75 08             	pushl  0x8(%ebp)
  80243f:	6a 0d                	push   $0xd
  802441:	e8 46 fe ff ff       	call   80228c <syscall>
  802446:	83 c4 18             	add    $0x18,%esp
}
  802449:	c9                   	leave  
  80244a:	c3                   	ret    

0080244b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80244e:	6a 00                	push   $0x0
  802450:	6a 00                	push   $0x0
  802452:	6a 00                	push   $0x0
  802454:	6a 00                	push   $0x0
  802456:	6a 00                	push   $0x0
  802458:	6a 0e                	push   $0xe
  80245a:	e8 2d fe ff ff       	call   80228c <syscall>
  80245f:	83 c4 18             	add    $0x18,%esp
}
  802462:	90                   	nop
  802463:	c9                   	leave  
  802464:	c3                   	ret    

00802465 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802465:	55                   	push   %ebp
  802466:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	6a 00                	push   $0x0
  802470:	6a 00                	push   $0x0
  802472:	6a 13                	push   $0x13
  802474:	e8 13 fe ff ff       	call   80228c <syscall>
  802479:	83 c4 18             	add    $0x18,%esp
}
  80247c:	90                   	nop
  80247d:	c9                   	leave  
  80247e:	c3                   	ret    

0080247f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80247f:	55                   	push   %ebp
  802480:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802482:	6a 00                	push   $0x0
  802484:	6a 00                	push   $0x0
  802486:	6a 00                	push   $0x0
  802488:	6a 00                	push   $0x0
  80248a:	6a 00                	push   $0x0
  80248c:	6a 14                	push   $0x14
  80248e:	e8 f9 fd ff ff       	call   80228c <syscall>
  802493:	83 c4 18             	add    $0x18,%esp
}
  802496:	90                   	nop
  802497:	c9                   	leave  
  802498:	c3                   	ret    

00802499 <sys_cputc>:


void
sys_cputc(const char c)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
  80249c:	83 ec 04             	sub    $0x4,%esp
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8024a5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	50                   	push   %eax
  8024b2:	6a 15                	push   $0x15
  8024b4:	e8 d3 fd ff ff       	call   80228c <syscall>
  8024b9:	83 c4 18             	add    $0x18,%esp
}
  8024bc:	90                   	nop
  8024bd:	c9                   	leave  
  8024be:	c3                   	ret    

008024bf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8024bf:	55                   	push   %ebp
  8024c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	6a 00                	push   $0x0
  8024c8:	6a 00                	push   $0x0
  8024ca:	6a 00                	push   $0x0
  8024cc:	6a 16                	push   $0x16
  8024ce:	e8 b9 fd ff ff       	call   80228c <syscall>
  8024d3:	83 c4 18             	add    $0x18,%esp
}
  8024d6:	90                   	nop
  8024d7:	c9                   	leave  
  8024d8:	c3                   	ret    

008024d9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8024d9:	55                   	push   %ebp
  8024da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	6a 00                	push   $0x0
  8024e1:	6a 00                	push   $0x0
  8024e3:	6a 00                	push   $0x0
  8024e5:	ff 75 0c             	pushl  0xc(%ebp)
  8024e8:	50                   	push   %eax
  8024e9:	6a 17                	push   $0x17
  8024eb:	e8 9c fd ff ff       	call   80228c <syscall>
  8024f0:	83 c4 18             	add    $0x18,%esp
}
  8024f3:	c9                   	leave  
  8024f4:	c3                   	ret    

008024f5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	6a 00                	push   $0x0
  802500:	6a 00                	push   $0x0
  802502:	6a 00                	push   $0x0
  802504:	52                   	push   %edx
  802505:	50                   	push   %eax
  802506:	6a 1a                	push   $0x1a
  802508:	e8 7f fd ff ff       	call   80228c <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
}
  802510:	c9                   	leave  
  802511:	c3                   	ret    

00802512 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802512:	55                   	push   %ebp
  802513:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802515:	8b 55 0c             	mov    0xc(%ebp),%edx
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	6a 00                	push   $0x0
  80251d:	6a 00                	push   $0x0
  80251f:	6a 00                	push   $0x0
  802521:	52                   	push   %edx
  802522:	50                   	push   %eax
  802523:	6a 18                	push   $0x18
  802525:	e8 62 fd ff ff       	call   80228c <syscall>
  80252a:	83 c4 18             	add    $0x18,%esp
}
  80252d:	90                   	nop
  80252e:	c9                   	leave  
  80252f:	c3                   	ret    

00802530 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802533:	8b 55 0c             	mov    0xc(%ebp),%edx
  802536:	8b 45 08             	mov    0x8(%ebp),%eax
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	6a 00                	push   $0x0
  80253f:	52                   	push   %edx
  802540:	50                   	push   %eax
  802541:	6a 19                	push   $0x19
  802543:	e8 44 fd ff ff       	call   80228c <syscall>
  802548:	83 c4 18             	add    $0x18,%esp
}
  80254b:	90                   	nop
  80254c:	c9                   	leave  
  80254d:	c3                   	ret    

0080254e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80254e:	55                   	push   %ebp
  80254f:	89 e5                	mov    %esp,%ebp
  802551:	83 ec 04             	sub    $0x4,%esp
  802554:	8b 45 10             	mov    0x10(%ebp),%eax
  802557:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80255a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80255d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802561:	8b 45 08             	mov    0x8(%ebp),%eax
  802564:	6a 00                	push   $0x0
  802566:	51                   	push   %ecx
  802567:	52                   	push   %edx
  802568:	ff 75 0c             	pushl  0xc(%ebp)
  80256b:	50                   	push   %eax
  80256c:	6a 1b                	push   $0x1b
  80256e:	e8 19 fd ff ff       	call   80228c <syscall>
  802573:	83 c4 18             	add    $0x18,%esp
}
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80257b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	6a 00                	push   $0x0
  802583:	6a 00                	push   $0x0
  802585:	6a 00                	push   $0x0
  802587:	52                   	push   %edx
  802588:	50                   	push   %eax
  802589:	6a 1c                	push   $0x1c
  80258b:	e8 fc fc ff ff       	call   80228c <syscall>
  802590:	83 c4 18             	add    $0x18,%esp
}
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802598:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80259b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	6a 00                	push   $0x0
  8025a3:	6a 00                	push   $0x0
  8025a5:	51                   	push   %ecx
  8025a6:	52                   	push   %edx
  8025a7:	50                   	push   %eax
  8025a8:	6a 1d                	push   $0x1d
  8025aa:	e8 dd fc ff ff       	call   80228c <syscall>
  8025af:	83 c4 18             	add    $0x18,%esp
}
  8025b2:	c9                   	leave  
  8025b3:	c3                   	ret    

008025b4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8025b4:	55                   	push   %ebp
  8025b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8025b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	52                   	push   %edx
  8025c4:	50                   	push   %eax
  8025c5:	6a 1e                	push   $0x1e
  8025c7:	e8 c0 fc ff ff       	call   80228c <syscall>
  8025cc:	83 c4 18             	add    $0x18,%esp
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	6a 00                	push   $0x0
  8025dc:	6a 00                	push   $0x0
  8025de:	6a 1f                	push   $0x1f
  8025e0:	e8 a7 fc ff ff       	call   80228c <syscall>
  8025e5:	83 c4 18             	add    $0x18,%esp
}
  8025e8:	c9                   	leave  
  8025e9:	c3                   	ret    

008025ea <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025ea:	55                   	push   %ebp
  8025eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f0:	6a 00                	push   $0x0
  8025f2:	ff 75 14             	pushl  0x14(%ebp)
  8025f5:	ff 75 10             	pushl  0x10(%ebp)
  8025f8:	ff 75 0c             	pushl  0xc(%ebp)
  8025fb:	50                   	push   %eax
  8025fc:	6a 20                	push   $0x20
  8025fe:	e8 89 fc ff ff       	call   80228c <syscall>
  802603:	83 c4 18             	add    $0x18,%esp
}
  802606:	c9                   	leave  
  802607:	c3                   	ret    

00802608 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	6a 00                	push   $0x0
  802610:	6a 00                	push   $0x0
  802612:	6a 00                	push   $0x0
  802614:	6a 00                	push   $0x0
  802616:	50                   	push   %eax
  802617:	6a 21                	push   $0x21
  802619:	e8 6e fc ff ff       	call   80228c <syscall>
  80261e:	83 c4 18             	add    $0x18,%esp
}
  802621:	90                   	nop
  802622:	c9                   	leave  
  802623:	c3                   	ret    

00802624 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802624:	55                   	push   %ebp
  802625:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 00                	push   $0x0
  802630:	6a 00                	push   $0x0
  802632:	50                   	push   %eax
  802633:	6a 22                	push   $0x22
  802635:	e8 52 fc ff ff       	call   80228c <syscall>
  80263a:	83 c4 18             	add    $0x18,%esp
}
  80263d:	c9                   	leave  
  80263e:	c3                   	ret    

0080263f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80263f:	55                   	push   %ebp
  802640:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802642:	6a 00                	push   $0x0
  802644:	6a 00                	push   $0x0
  802646:	6a 00                	push   $0x0
  802648:	6a 00                	push   $0x0
  80264a:	6a 00                	push   $0x0
  80264c:	6a 02                	push   $0x2
  80264e:	e8 39 fc ff ff       	call   80228c <syscall>
  802653:	83 c4 18             	add    $0x18,%esp
}
  802656:	c9                   	leave  
  802657:	c3                   	ret    

00802658 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802658:	55                   	push   %ebp
  802659:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 00                	push   $0x0
  802661:	6a 00                	push   $0x0
  802663:	6a 00                	push   $0x0
  802665:	6a 03                	push   $0x3
  802667:	e8 20 fc ff ff       	call   80228c <syscall>
  80266c:	83 c4 18             	add    $0x18,%esp
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802674:	6a 00                	push   $0x0
  802676:	6a 00                	push   $0x0
  802678:	6a 00                	push   $0x0
  80267a:	6a 00                	push   $0x0
  80267c:	6a 00                	push   $0x0
  80267e:	6a 04                	push   $0x4
  802680:	e8 07 fc ff ff       	call   80228c <syscall>
  802685:	83 c4 18             	add    $0x18,%esp
}
  802688:	c9                   	leave  
  802689:	c3                   	ret    

0080268a <sys_exit_env>:


void sys_exit_env(void)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 00                	push   $0x0
  802695:	6a 00                	push   $0x0
  802697:	6a 23                	push   $0x23
  802699:	e8 ee fb ff ff       	call   80228c <syscall>
  80269e:	83 c4 18             	add    $0x18,%esp
}
  8026a1:	90                   	nop
  8026a2:	c9                   	leave  
  8026a3:	c3                   	ret    

008026a4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8026a4:	55                   	push   %ebp
  8026a5:	89 e5                	mov    %esp,%ebp
  8026a7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8026aa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026ad:	8d 50 04             	lea    0x4(%eax),%edx
  8026b0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8026b3:	6a 00                	push   $0x0
  8026b5:	6a 00                	push   $0x0
  8026b7:	6a 00                	push   $0x0
  8026b9:	52                   	push   %edx
  8026ba:	50                   	push   %eax
  8026bb:	6a 24                	push   $0x24
  8026bd:	e8 ca fb ff ff       	call   80228c <syscall>
  8026c2:	83 c4 18             	add    $0x18,%esp
	return result;
  8026c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8026cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8026ce:	89 01                	mov    %eax,(%ecx)
  8026d0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	c9                   	leave  
  8026d7:	c2 04 00             	ret    $0x4

008026da <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8026da:	55                   	push   %ebp
  8026db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	ff 75 10             	pushl  0x10(%ebp)
  8026e4:	ff 75 0c             	pushl  0xc(%ebp)
  8026e7:	ff 75 08             	pushl  0x8(%ebp)
  8026ea:	6a 12                	push   $0x12
  8026ec:	e8 9b fb ff ff       	call   80228c <syscall>
  8026f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f4:	90                   	nop
}
  8026f5:	c9                   	leave  
  8026f6:	c3                   	ret    

008026f7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8026f7:	55                   	push   %ebp
  8026f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 00                	push   $0x0
  802702:	6a 00                	push   $0x0
  802704:	6a 25                	push   $0x25
  802706:	e8 81 fb ff ff       	call   80228c <syscall>
  80270b:	83 c4 18             	add    $0x18,%esp
}
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	83 ec 04             	sub    $0x4,%esp
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80271c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802720:	6a 00                	push   $0x0
  802722:	6a 00                	push   $0x0
  802724:	6a 00                	push   $0x0
  802726:	6a 00                	push   $0x0
  802728:	50                   	push   %eax
  802729:	6a 26                	push   $0x26
  80272b:	e8 5c fb ff ff       	call   80228c <syscall>
  802730:	83 c4 18             	add    $0x18,%esp
	return ;
  802733:	90                   	nop
}
  802734:	c9                   	leave  
  802735:	c3                   	ret    

00802736 <rsttst>:
void rsttst()
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	6a 28                	push   $0x28
  802745:	e8 42 fb ff ff       	call   80228c <syscall>
  80274a:	83 c4 18             	add    $0x18,%esp
	return ;
  80274d:	90                   	nop
}
  80274e:	c9                   	leave  
  80274f:	c3                   	ret    

00802750 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
  802753:	83 ec 04             	sub    $0x4,%esp
  802756:	8b 45 14             	mov    0x14(%ebp),%eax
  802759:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80275c:	8b 55 18             	mov    0x18(%ebp),%edx
  80275f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802763:	52                   	push   %edx
  802764:	50                   	push   %eax
  802765:	ff 75 10             	pushl  0x10(%ebp)
  802768:	ff 75 0c             	pushl  0xc(%ebp)
  80276b:	ff 75 08             	pushl  0x8(%ebp)
  80276e:	6a 27                	push   $0x27
  802770:	e8 17 fb ff ff       	call   80228c <syscall>
  802775:	83 c4 18             	add    $0x18,%esp
	return ;
  802778:	90                   	nop
}
  802779:	c9                   	leave  
  80277a:	c3                   	ret    

0080277b <chktst>:
void chktst(uint32 n)
{
  80277b:	55                   	push   %ebp
  80277c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80277e:	6a 00                	push   $0x0
  802780:	6a 00                	push   $0x0
  802782:	6a 00                	push   $0x0
  802784:	6a 00                	push   $0x0
  802786:	ff 75 08             	pushl  0x8(%ebp)
  802789:	6a 29                	push   $0x29
  80278b:	e8 fc fa ff ff       	call   80228c <syscall>
  802790:	83 c4 18             	add    $0x18,%esp
	return ;
  802793:	90                   	nop
}
  802794:	c9                   	leave  
  802795:	c3                   	ret    

00802796 <inctst>:

void inctst()
{
  802796:	55                   	push   %ebp
  802797:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802799:	6a 00                	push   $0x0
  80279b:	6a 00                	push   $0x0
  80279d:	6a 00                	push   $0x0
  80279f:	6a 00                	push   $0x0
  8027a1:	6a 00                	push   $0x0
  8027a3:	6a 2a                	push   $0x2a
  8027a5:	e8 e2 fa ff ff       	call   80228c <syscall>
  8027aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8027ad:	90                   	nop
}
  8027ae:	c9                   	leave  
  8027af:	c3                   	ret    

008027b0 <gettst>:
uint32 gettst()
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	6a 00                	push   $0x0
  8027bb:	6a 00                	push   $0x0
  8027bd:	6a 2b                	push   $0x2b
  8027bf:	e8 c8 fa ff ff       	call   80228c <syscall>
  8027c4:	83 c4 18             	add    $0x18,%esp
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027cf:	6a 00                	push   $0x0
  8027d1:	6a 00                	push   $0x0
  8027d3:	6a 00                	push   $0x0
  8027d5:	6a 00                	push   $0x0
  8027d7:	6a 00                	push   $0x0
  8027d9:	6a 2c                	push   $0x2c
  8027db:	e8 ac fa ff ff       	call   80228c <syscall>
  8027e0:	83 c4 18             	add    $0x18,%esp
  8027e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027e6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8027ea:	75 07                	jne    8027f3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8027ec:	b8 01 00 00 00       	mov    $0x1,%eax
  8027f1:	eb 05                	jmp    8027f8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8027f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f8:	c9                   	leave  
  8027f9:	c3                   	ret    

008027fa <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8027fa:	55                   	push   %ebp
  8027fb:	89 e5                	mov    %esp,%ebp
  8027fd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802800:	6a 00                	push   $0x0
  802802:	6a 00                	push   $0x0
  802804:	6a 00                	push   $0x0
  802806:	6a 00                	push   $0x0
  802808:	6a 00                	push   $0x0
  80280a:	6a 2c                	push   $0x2c
  80280c:	e8 7b fa ff ff       	call   80228c <syscall>
  802811:	83 c4 18             	add    $0x18,%esp
  802814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802817:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80281b:	75 07                	jne    802824 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80281d:	b8 01 00 00 00       	mov    $0x1,%eax
  802822:	eb 05                	jmp    802829 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802829:	c9                   	leave  
  80282a:	c3                   	ret    

0080282b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80282b:	55                   	push   %ebp
  80282c:	89 e5                	mov    %esp,%ebp
  80282e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802831:	6a 00                	push   $0x0
  802833:	6a 00                	push   $0x0
  802835:	6a 00                	push   $0x0
  802837:	6a 00                	push   $0x0
  802839:	6a 00                	push   $0x0
  80283b:	6a 2c                	push   $0x2c
  80283d:	e8 4a fa ff ff       	call   80228c <syscall>
  802842:	83 c4 18             	add    $0x18,%esp
  802845:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802848:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80284c:	75 07                	jne    802855 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80284e:	b8 01 00 00 00       	mov    $0x1,%eax
  802853:	eb 05                	jmp    80285a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802855:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80285a:	c9                   	leave  
  80285b:	c3                   	ret    

0080285c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80285c:	55                   	push   %ebp
  80285d:	89 e5                	mov    %esp,%ebp
  80285f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802862:	6a 00                	push   $0x0
  802864:	6a 00                	push   $0x0
  802866:	6a 00                	push   $0x0
  802868:	6a 00                	push   $0x0
  80286a:	6a 00                	push   $0x0
  80286c:	6a 2c                	push   $0x2c
  80286e:	e8 19 fa ff ff       	call   80228c <syscall>
  802873:	83 c4 18             	add    $0x18,%esp
  802876:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802879:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80287d:	75 07                	jne    802886 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80287f:	b8 01 00 00 00       	mov    $0x1,%eax
  802884:	eb 05                	jmp    80288b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802886:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80288b:	c9                   	leave  
  80288c:	c3                   	ret    

0080288d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80288d:	55                   	push   %ebp
  80288e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802890:	6a 00                	push   $0x0
  802892:	6a 00                	push   $0x0
  802894:	6a 00                	push   $0x0
  802896:	6a 00                	push   $0x0
  802898:	ff 75 08             	pushl  0x8(%ebp)
  80289b:	6a 2d                	push   $0x2d
  80289d:	e8 ea f9 ff ff       	call   80228c <syscall>
  8028a2:	83 c4 18             	add    $0x18,%esp
	return ;
  8028a5:	90                   	nop
}
  8028a6:	c9                   	leave  
  8028a7:	c3                   	ret    

008028a8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8028a8:	55                   	push   %ebp
  8028a9:	89 e5                	mov    %esp,%ebp
  8028ab:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8028ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8028af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8028b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b8:	6a 00                	push   $0x0
  8028ba:	53                   	push   %ebx
  8028bb:	51                   	push   %ecx
  8028bc:	52                   	push   %edx
  8028bd:	50                   	push   %eax
  8028be:	6a 2e                	push   $0x2e
  8028c0:	e8 c7 f9 ff ff       	call   80228c <syscall>
  8028c5:	83 c4 18             	add    $0x18,%esp
}
  8028c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8028cb:	c9                   	leave  
  8028cc:	c3                   	ret    

008028cd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8028cd:	55                   	push   %ebp
  8028ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8028d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	6a 00                	push   $0x0
  8028d8:	6a 00                	push   $0x0
  8028da:	6a 00                	push   $0x0
  8028dc:	52                   	push   %edx
  8028dd:	50                   	push   %eax
  8028de:	6a 2f                	push   $0x2f
  8028e0:	e8 a7 f9 ff ff       	call   80228c <syscall>
  8028e5:	83 c4 18             	add    $0x18,%esp
}
  8028e8:	c9                   	leave  
  8028e9:	c3                   	ret    

008028ea <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
  8028ed:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8028f0:	83 ec 0c             	sub    $0xc,%esp
  8028f3:	68 a0 47 80 00       	push   $0x8047a0
  8028f8:	e8 3e e6 ff ff       	call   800f3b <cprintf>
  8028fd:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802900:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802907:	83 ec 0c             	sub    $0xc,%esp
  80290a:	68 cc 47 80 00       	push   $0x8047cc
  80290f:	e8 27 e6 ff ff       	call   800f3b <cprintf>
  802914:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802917:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80291b:	a1 38 51 80 00       	mov    0x805138,%eax
  802920:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802923:	eb 56                	jmp    80297b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802925:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802929:	74 1c                	je     802947 <print_mem_block_lists+0x5d>
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	8b 50 08             	mov    0x8(%eax),%edx
  802931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802934:	8b 48 08             	mov    0x8(%eax),%ecx
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 40 0c             	mov    0xc(%eax),%eax
  80293d:	01 c8                	add    %ecx,%eax
  80293f:	39 c2                	cmp    %eax,%edx
  802941:	73 04                	jae    802947 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802943:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 50 08             	mov    0x8(%eax),%edx
  80294d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802950:	8b 40 0c             	mov    0xc(%eax),%eax
  802953:	01 c2                	add    %eax,%edx
  802955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802958:	8b 40 08             	mov    0x8(%eax),%eax
  80295b:	83 ec 04             	sub    $0x4,%esp
  80295e:	52                   	push   %edx
  80295f:	50                   	push   %eax
  802960:	68 e1 47 80 00       	push   $0x8047e1
  802965:	e8 d1 e5 ff ff       	call   800f3b <cprintf>
  80296a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80296d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802970:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802973:	a1 40 51 80 00       	mov    0x805140,%eax
  802978:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80297b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297f:	74 07                	je     802988 <print_mem_block_lists+0x9e>
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	eb 05                	jmp    80298d <print_mem_block_lists+0xa3>
  802988:	b8 00 00 00 00       	mov    $0x0,%eax
  80298d:	a3 40 51 80 00       	mov    %eax,0x805140
  802992:	a1 40 51 80 00       	mov    0x805140,%eax
  802997:	85 c0                	test   %eax,%eax
  802999:	75 8a                	jne    802925 <print_mem_block_lists+0x3b>
  80299b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80299f:	75 84                	jne    802925 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8029a1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8029a5:	75 10                	jne    8029b7 <print_mem_block_lists+0xcd>
  8029a7:	83 ec 0c             	sub    $0xc,%esp
  8029aa:	68 f0 47 80 00       	push   $0x8047f0
  8029af:	e8 87 e5 ff ff       	call   800f3b <cprintf>
  8029b4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8029b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8029be:	83 ec 0c             	sub    $0xc,%esp
  8029c1:	68 14 48 80 00       	push   $0x804814
  8029c6:	e8 70 e5 ff ff       	call   800f3b <cprintf>
  8029cb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8029ce:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029d2:	a1 40 50 80 00       	mov    0x805040,%eax
  8029d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029da:	eb 56                	jmp    802a32 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8029dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8029e0:	74 1c                	je     8029fe <print_mem_block_lists+0x114>
  8029e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e5:	8b 50 08             	mov    0x8(%eax),%edx
  8029e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029eb:	8b 48 08             	mov    0x8(%eax),%ecx
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f4:	01 c8                	add    %ecx,%eax
  8029f6:	39 c2                	cmp    %eax,%edx
  8029f8:	73 04                	jae    8029fe <print_mem_block_lists+0x114>
			sorted = 0 ;
  8029fa:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8029fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a01:	8b 50 08             	mov    0x8(%eax),%edx
  802a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a07:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0a:	01 c2                	add    %eax,%edx
  802a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0f:	8b 40 08             	mov    0x8(%eax),%eax
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	52                   	push   %edx
  802a16:	50                   	push   %eax
  802a17:	68 e1 47 80 00       	push   $0x8047e1
  802a1c:	e8 1a e5 ff ff       	call   800f3b <cprintf>
  802a21:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802a2a:	a1 48 50 80 00       	mov    0x805048,%eax
  802a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a36:	74 07                	je     802a3f <print_mem_block_lists+0x155>
  802a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3b:	8b 00                	mov    (%eax),%eax
  802a3d:	eb 05                	jmp    802a44 <print_mem_block_lists+0x15a>
  802a3f:	b8 00 00 00 00       	mov    $0x0,%eax
  802a44:	a3 48 50 80 00       	mov    %eax,0x805048
  802a49:	a1 48 50 80 00       	mov    0x805048,%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	75 8a                	jne    8029dc <print_mem_block_lists+0xf2>
  802a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a56:	75 84                	jne    8029dc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a58:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a5c:	75 10                	jne    802a6e <print_mem_block_lists+0x184>
  802a5e:	83 ec 0c             	sub    $0xc,%esp
  802a61:	68 2c 48 80 00       	push   $0x80482c
  802a66:	e8 d0 e4 ff ff       	call   800f3b <cprintf>
  802a6b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a6e:	83 ec 0c             	sub    $0xc,%esp
  802a71:	68 a0 47 80 00       	push   $0x8047a0
  802a76:	e8 c0 e4 ff ff       	call   800f3b <cprintf>
  802a7b:	83 c4 10             	add    $0x10,%esp

}
  802a7e:	90                   	nop
  802a7f:	c9                   	leave  
  802a80:	c3                   	ret    

00802a81 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a81:	55                   	push   %ebp
  802a82:	89 e5                	mov    %esp,%ebp
  802a84:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802a87:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a8e:	00 00 00 
  802a91:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a98:	00 00 00 
  802a9b:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802aa2:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802aa5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802aac:	e9 9e 00 00 00       	jmp    802b4f <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802ab1:	a1 50 50 80 00       	mov    0x805050,%eax
  802ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab9:	c1 e2 04             	shl    $0x4,%edx
  802abc:	01 d0                	add    %edx,%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	75 14                	jne    802ad6 <initialize_MemBlocksList+0x55>
  802ac2:	83 ec 04             	sub    $0x4,%esp
  802ac5:	68 54 48 80 00       	push   $0x804854
  802aca:	6a 3d                	push   $0x3d
  802acc:	68 77 48 80 00       	push   $0x804877
  802ad1:	e8 b1 e1 ff ff       	call   800c87 <_panic>
  802ad6:	a1 50 50 80 00       	mov    0x805050,%eax
  802adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ade:	c1 e2 04             	shl    $0x4,%edx
  802ae1:	01 d0                	add    %edx,%eax
  802ae3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ae9:	89 10                	mov    %edx,(%eax)
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 18                	je     802b09 <initialize_MemBlocksList+0x88>
  802af1:	a1 48 51 80 00       	mov    0x805148,%eax
  802af6:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802afc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802aff:	c1 e1 04             	shl    $0x4,%ecx
  802b02:	01 ca                	add    %ecx,%edx
  802b04:	89 50 04             	mov    %edx,0x4(%eax)
  802b07:	eb 12                	jmp    802b1b <initialize_MemBlocksList+0x9a>
  802b09:	a1 50 50 80 00       	mov    0x805050,%eax
  802b0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b11:	c1 e2 04             	shl    $0x4,%edx
  802b14:	01 d0                	add    %edx,%eax
  802b16:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b1b:	a1 50 50 80 00       	mov    0x805050,%eax
  802b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b23:	c1 e2 04             	shl    $0x4,%edx
  802b26:	01 d0                	add    %edx,%eax
  802b28:	a3 48 51 80 00       	mov    %eax,0x805148
  802b2d:	a1 50 50 80 00       	mov    0x805050,%eax
  802b32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b35:	c1 e2 04             	shl    $0x4,%edx
  802b38:	01 d0                	add    %edx,%eax
  802b3a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b41:	a1 54 51 80 00       	mov    0x805154,%eax
  802b46:	40                   	inc    %eax
  802b47:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802b4c:	ff 45 f4             	incl   -0xc(%ebp)
  802b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b52:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b55:	0f 82 56 ff ff ff    	jb     802ab1 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802b5b:	90                   	nop
  802b5c:	c9                   	leave  
  802b5d:	c3                   	ret    

00802b5e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b5e:	55                   	push   %ebp
  802b5f:	89 e5                	mov    %esp,%ebp
  802b61:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	8b 00                	mov    (%eax),%eax
  802b69:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802b6c:	eb 18                	jmp    802b86 <find_block+0x28>

		if(tmp->sva == va){
  802b6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b71:	8b 40 08             	mov    0x8(%eax),%eax
  802b74:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b77:	75 05                	jne    802b7e <find_block+0x20>
			return tmp ;
  802b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b7c:	eb 11                	jmp    802b8f <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802b7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802b86:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b8a:	75 e2                	jne    802b6e <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802b8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802b8f:	c9                   	leave  
  802b90:	c3                   	ret    

00802b91 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b91:	55                   	push   %ebp
  802b92:	89 e5                	mov    %esp,%ebp
  802b94:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802b97:	a1 40 50 80 00       	mov    0x805040,%eax
  802b9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802b9f:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ba4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802ba7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bab:	75 65                	jne    802c12 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802bad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb1:	75 14                	jne    802bc7 <insert_sorted_allocList+0x36>
  802bb3:	83 ec 04             	sub    $0x4,%esp
  802bb6:	68 54 48 80 00       	push   $0x804854
  802bbb:	6a 62                	push   $0x62
  802bbd:	68 77 48 80 00       	push   $0x804877
  802bc2:	e8 c0 e0 ff ff       	call   800c87 <_panic>
  802bc7:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	89 10                	mov    %edx,(%eax)
  802bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	85 c0                	test   %eax,%eax
  802bd9:	74 0d                	je     802be8 <insert_sorted_allocList+0x57>
  802bdb:	a1 40 50 80 00       	mov    0x805040,%eax
  802be0:	8b 55 08             	mov    0x8(%ebp),%edx
  802be3:	89 50 04             	mov    %edx,0x4(%eax)
  802be6:	eb 08                	jmp    802bf0 <insert_sorted_allocList+0x5f>
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	a3 44 50 80 00       	mov    %eax,0x805044
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	a3 40 50 80 00       	mov    %eax,0x805040
  802bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c02:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c07:	40                   	inc    %eax
  802c08:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802c0d:	e9 14 01 00 00       	jmp    802d26 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	8b 50 08             	mov    0x8(%eax),%edx
  802c18:	a1 44 50 80 00       	mov    0x805044,%eax
  802c1d:	8b 40 08             	mov    0x8(%eax),%eax
  802c20:	39 c2                	cmp    %eax,%edx
  802c22:	76 65                	jbe    802c89 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802c24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c28:	75 14                	jne    802c3e <insert_sorted_allocList+0xad>
  802c2a:	83 ec 04             	sub    $0x4,%esp
  802c2d:	68 90 48 80 00       	push   $0x804890
  802c32:	6a 64                	push   $0x64
  802c34:	68 77 48 80 00       	push   $0x804877
  802c39:	e8 49 e0 ff ff       	call   800c87 <_panic>
  802c3e:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	89 50 04             	mov    %edx,0x4(%eax)
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	8b 40 04             	mov    0x4(%eax),%eax
  802c50:	85 c0                	test   %eax,%eax
  802c52:	74 0c                	je     802c60 <insert_sorted_allocList+0xcf>
  802c54:	a1 44 50 80 00       	mov    0x805044,%eax
  802c59:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5c:	89 10                	mov    %edx,(%eax)
  802c5e:	eb 08                	jmp    802c68 <insert_sorted_allocList+0xd7>
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	a3 40 50 80 00       	mov    %eax,0x805040
  802c68:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6b:	a3 44 50 80 00       	mov    %eax,0x805044
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c79:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c7e:	40                   	inc    %eax
  802c7f:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802c84:	e9 9d 00 00 00       	jmp    802d26 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802c89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802c90:	e9 85 00 00 00       	jmp    802d1a <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	8b 50 08             	mov    0x8(%eax),%edx
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ca1:	39 c2                	cmp    %eax,%edx
  802ca3:	73 6a                	jae    802d0f <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802ca5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca9:	74 06                	je     802cb1 <insert_sorted_allocList+0x120>
  802cab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802caf:	75 14                	jne    802cc5 <insert_sorted_allocList+0x134>
  802cb1:	83 ec 04             	sub    $0x4,%esp
  802cb4:	68 b4 48 80 00       	push   $0x8048b4
  802cb9:	6a 6b                	push   $0x6b
  802cbb:	68 77 48 80 00       	push   $0x804877
  802cc0:	e8 c2 df ff ff       	call   800c87 <_panic>
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 50 04             	mov    0x4(%eax),%edx
  802ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cce:	89 50 04             	mov    %edx,0x4(%eax)
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cd7:	89 10                	mov    %edx,(%eax)
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 40 04             	mov    0x4(%eax),%eax
  802cdf:	85 c0                	test   %eax,%eax
  802ce1:	74 0d                	je     802cf0 <insert_sorted_allocList+0x15f>
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cec:	89 10                	mov    %edx,(%eax)
  802cee:	eb 08                	jmp    802cf8 <insert_sorted_allocList+0x167>
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	a3 40 50 80 00       	mov    %eax,0x805040
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfe:	89 50 04             	mov    %edx,0x4(%eax)
  802d01:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802d06:	40                   	inc    %eax
  802d07:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802d0c:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802d0d:	eb 17                	jmp    802d26 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	8b 00                	mov    (%eax),%eax
  802d14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802d17:	ff 45 f0             	incl   -0x10(%ebp)
  802d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d1d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d20:	0f 8c 6f ff ff ff    	jl     802c95 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802d26:	90                   	nop
  802d27:	c9                   	leave  
  802d28:	c3                   	ret    

00802d29 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802d29:	55                   	push   %ebp
  802d2a:	89 e5                	mov    %esp,%ebp
  802d2c:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802d2f:	a1 38 51 80 00       	mov    0x805138,%eax
  802d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802d37:	e9 7c 01 00 00       	jmp    802eb8 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d42:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d45:	0f 86 cf 00 00 00    	jbe    802e1a <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802d4b:	a1 48 51 80 00       	mov    0x805148,%eax
  802d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802d59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5f:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 50 08             	mov    0x8(%eax),%edx
  802d68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6b:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 40 0c             	mov    0xc(%eax),%eax
  802d74:	2b 45 08             	sub    0x8(%ebp),%eax
  802d77:	89 c2                	mov    %eax,%edx
  802d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7c:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 50 08             	mov    0x8(%eax),%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	01 c2                	add    %eax,%edx
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802d90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d94:	75 17                	jne    802dad <alloc_block_FF+0x84>
  802d96:	83 ec 04             	sub    $0x4,%esp
  802d99:	68 e9 48 80 00       	push   $0x8048e9
  802d9e:	68 83 00 00 00       	push   $0x83
  802da3:	68 77 48 80 00       	push   $0x804877
  802da8:	e8 da de ff ff       	call   800c87 <_panic>
  802dad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db0:	8b 00                	mov    (%eax),%eax
  802db2:	85 c0                	test   %eax,%eax
  802db4:	74 10                	je     802dc6 <alloc_block_FF+0x9d>
  802db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db9:	8b 00                	mov    (%eax),%eax
  802dbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802dbe:	8b 52 04             	mov    0x4(%edx),%edx
  802dc1:	89 50 04             	mov    %edx,0x4(%eax)
  802dc4:	eb 0b                	jmp    802dd1 <alloc_block_FF+0xa8>
  802dc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dc9:	8b 40 04             	mov    0x4(%eax),%eax
  802dcc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd4:	8b 40 04             	mov    0x4(%eax),%eax
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	74 0f                	je     802dea <alloc_block_FF+0xc1>
  802ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dde:	8b 40 04             	mov    0x4(%eax),%eax
  802de1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802de4:	8b 12                	mov    (%edx),%edx
  802de6:	89 10                	mov    %edx,(%eax)
  802de8:	eb 0a                	jmp    802df4 <alloc_block_FF+0xcb>
  802dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ded:	8b 00                	mov    (%eax),%eax
  802def:	a3 48 51 80 00       	mov    %eax,0x805148
  802df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e00:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e07:	a1 54 51 80 00       	mov    0x805154,%eax
  802e0c:	48                   	dec    %eax
  802e0d:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802e12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e15:	e9 ad 00 00 00       	jmp    802ec7 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802e20:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e23:	0f 85 87 00 00 00    	jne    802eb0 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802e29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e2d:	75 17                	jne    802e46 <alloc_block_FF+0x11d>
  802e2f:	83 ec 04             	sub    $0x4,%esp
  802e32:	68 e9 48 80 00       	push   $0x8048e9
  802e37:	68 87 00 00 00       	push   $0x87
  802e3c:	68 77 48 80 00       	push   $0x804877
  802e41:	e8 41 de ff ff       	call   800c87 <_panic>
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 10                	je     802e5f <alloc_block_FF+0x136>
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 00                	mov    (%eax),%eax
  802e54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e57:	8b 52 04             	mov    0x4(%edx),%edx
  802e5a:	89 50 04             	mov    %edx,0x4(%eax)
  802e5d:	eb 0b                	jmp    802e6a <alloc_block_FF+0x141>
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	8b 40 04             	mov    0x4(%eax),%eax
  802e65:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 40 04             	mov    0x4(%eax),%eax
  802e70:	85 c0                	test   %eax,%eax
  802e72:	74 0f                	je     802e83 <alloc_block_FF+0x15a>
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 40 04             	mov    0x4(%eax),%eax
  802e7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7d:	8b 12                	mov    (%edx),%edx
  802e7f:	89 10                	mov    %edx,(%eax)
  802e81:	eb 0a                	jmp    802e8d <alloc_block_FF+0x164>
  802e83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	a3 38 51 80 00       	mov    %eax,0x805138
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea0:	a1 44 51 80 00       	mov    0x805144,%eax
  802ea5:	48                   	dec    %eax
  802ea6:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	eb 17                	jmp    802ec7 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802eb8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebc:	0f 85 7a fe ff ff    	jne    802d3c <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802ec2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ec7:	c9                   	leave  
  802ec8:	c3                   	ret    

00802ec9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ec9:	55                   	push   %ebp
  802eca:	89 e5                	mov    %esp,%ebp
  802ecc:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802ecf:	a1 38 51 80 00       	mov    0x805138,%eax
  802ed4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802ed7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802ede:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802ee5:	a1 38 51 80 00       	mov    0x805138,%eax
  802eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eed:	e9 d0 00 00 00       	jmp    802fc2 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef8:	3b 45 08             	cmp    0x8(%ebp),%eax
  802efb:	0f 82 b8 00 00 00    	jb     802fb9 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 40 0c             	mov    0xc(%eax),%eax
  802f07:	2b 45 08             	sub    0x8(%ebp),%eax
  802f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802f0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f10:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802f13:	0f 83 a1 00 00 00    	jae    802fba <alloc_block_BF+0xf1>
				differsize = differance ;
  802f19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802f25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f29:	0f 85 8b 00 00 00    	jne    802fba <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802f2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f33:	75 17                	jne    802f4c <alloc_block_BF+0x83>
  802f35:	83 ec 04             	sub    $0x4,%esp
  802f38:	68 e9 48 80 00       	push   $0x8048e9
  802f3d:	68 a0 00 00 00       	push   $0xa0
  802f42:	68 77 48 80 00       	push   $0x804877
  802f47:	e8 3b dd ff ff       	call   800c87 <_panic>
  802f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	85 c0                	test   %eax,%eax
  802f53:	74 10                	je     802f65 <alloc_block_BF+0x9c>
  802f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f58:	8b 00                	mov    (%eax),%eax
  802f5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5d:	8b 52 04             	mov    0x4(%edx),%edx
  802f60:	89 50 04             	mov    %edx,0x4(%eax)
  802f63:	eb 0b                	jmp    802f70 <alloc_block_BF+0xa7>
  802f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f68:	8b 40 04             	mov    0x4(%eax),%eax
  802f6b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f73:	8b 40 04             	mov    0x4(%eax),%eax
  802f76:	85 c0                	test   %eax,%eax
  802f78:	74 0f                	je     802f89 <alloc_block_BF+0xc0>
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	8b 40 04             	mov    0x4(%eax),%eax
  802f80:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f83:	8b 12                	mov    (%edx),%edx
  802f85:	89 10                	mov    %edx,(%eax)
  802f87:	eb 0a                	jmp    802f93 <alloc_block_BF+0xca>
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	8b 00                	mov    (%eax),%eax
  802f8e:	a3 38 51 80 00       	mov    %eax,0x805138
  802f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f96:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa6:	a1 44 51 80 00       	mov    0x805144,%eax
  802fab:	48                   	dec    %eax
  802fac:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb4:	e9 0c 01 00 00       	jmp    8030c5 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802fb9:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802fba:	a1 40 51 80 00       	mov    0x805140,%eax
  802fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc6:	74 07                	je     802fcf <alloc_block_BF+0x106>
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	eb 05                	jmp    802fd4 <alloc_block_BF+0x10b>
  802fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd4:	a3 40 51 80 00       	mov    %eax,0x805140
  802fd9:	a1 40 51 80 00       	mov    0x805140,%eax
  802fde:	85 c0                	test   %eax,%eax
  802fe0:	0f 85 0c ff ff ff    	jne    802ef2 <alloc_block_BF+0x29>
  802fe6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fea:	0f 85 02 ff ff ff    	jne    802ef2 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802ff0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ff4:	0f 84 c6 00 00 00    	je     8030c0 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802ffa:	a1 48 51 80 00       	mov    0x805148,%eax
  802fff:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  803002:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803005:	8b 55 08             	mov    0x8(%ebp),%edx
  803008:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80300b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300e:	8b 50 08             	mov    0x8(%eax),%edx
  803011:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803014:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  803017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80301a:	8b 40 0c             	mov    0xc(%eax),%eax
  80301d:	2b 45 08             	sub    0x8(%ebp),%eax
  803020:	89 c2                	mov    %eax,%edx
  803022:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803025:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  803028:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80302b:	8b 50 08             	mov    0x8(%eax),%edx
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	01 c2                	add    %eax,%edx
  803033:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803036:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  803039:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80303d:	75 17                	jne    803056 <alloc_block_BF+0x18d>
  80303f:	83 ec 04             	sub    $0x4,%esp
  803042:	68 e9 48 80 00       	push   $0x8048e9
  803047:	68 af 00 00 00       	push   $0xaf
  80304c:	68 77 48 80 00       	push   $0x804877
  803051:	e8 31 dc ff ff       	call   800c87 <_panic>
  803056:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803059:	8b 00                	mov    (%eax),%eax
  80305b:	85 c0                	test   %eax,%eax
  80305d:	74 10                	je     80306f <alloc_block_BF+0x1a6>
  80305f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803062:	8b 00                	mov    (%eax),%eax
  803064:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803067:	8b 52 04             	mov    0x4(%edx),%edx
  80306a:	89 50 04             	mov    %edx,0x4(%eax)
  80306d:	eb 0b                	jmp    80307a <alloc_block_BF+0x1b1>
  80306f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803072:	8b 40 04             	mov    0x4(%eax),%eax
  803075:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80307a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307d:	8b 40 04             	mov    0x4(%eax),%eax
  803080:	85 c0                	test   %eax,%eax
  803082:	74 0f                	je     803093 <alloc_block_BF+0x1ca>
  803084:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803087:	8b 40 04             	mov    0x4(%eax),%eax
  80308a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80308d:	8b 12                	mov    (%edx),%edx
  80308f:	89 10                	mov    %edx,(%eax)
  803091:	eb 0a                	jmp    80309d <alloc_block_BF+0x1d4>
  803093:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803096:	8b 00                	mov    (%eax),%eax
  803098:	a3 48 51 80 00       	mov    %eax,0x805148
  80309d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030b0:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b5:	48                   	dec    %eax
  8030b6:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  8030bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030be:	eb 05                	jmp    8030c5 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8030c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8030c5:	c9                   	leave  
  8030c6:	c3                   	ret    

008030c7 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8030c7:	55                   	push   %ebp
  8030c8:	89 e5                	mov    %esp,%ebp
  8030ca:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8030cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8030d5:	e9 7c 01 00 00       	jmp    803256 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8030e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e3:	0f 86 cf 00 00 00    	jbe    8031b8 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8030e9:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8030f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8030f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8030fd:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  803100:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803103:	8b 50 08             	mov    0x8(%eax),%edx
  803106:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803109:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80310c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310f:	8b 40 0c             	mov    0xc(%eax),%eax
  803112:	2b 45 08             	sub    0x8(%ebp),%eax
  803115:	89 c2                	mov    %eax,%edx
  803117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311a:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80311d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803120:	8b 50 08             	mov    0x8(%eax),%edx
  803123:	8b 45 08             	mov    0x8(%ebp),%eax
  803126:	01 c2                	add    %eax,%edx
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80312e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803132:	75 17                	jne    80314b <alloc_block_NF+0x84>
  803134:	83 ec 04             	sub    $0x4,%esp
  803137:	68 e9 48 80 00       	push   $0x8048e9
  80313c:	68 c4 00 00 00       	push   $0xc4
  803141:	68 77 48 80 00       	push   $0x804877
  803146:	e8 3c db ff ff       	call   800c87 <_panic>
  80314b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80314e:	8b 00                	mov    (%eax),%eax
  803150:	85 c0                	test   %eax,%eax
  803152:	74 10                	je     803164 <alloc_block_NF+0x9d>
  803154:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803157:	8b 00                	mov    (%eax),%eax
  803159:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80315c:	8b 52 04             	mov    0x4(%edx),%edx
  80315f:	89 50 04             	mov    %edx,0x4(%eax)
  803162:	eb 0b                	jmp    80316f <alloc_block_NF+0xa8>
  803164:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803167:	8b 40 04             	mov    0x4(%eax),%eax
  80316a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80316f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803172:	8b 40 04             	mov    0x4(%eax),%eax
  803175:	85 c0                	test   %eax,%eax
  803177:	74 0f                	je     803188 <alloc_block_NF+0xc1>
  803179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80317c:	8b 40 04             	mov    0x4(%eax),%eax
  80317f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803182:	8b 12                	mov    (%edx),%edx
  803184:	89 10                	mov    %edx,(%eax)
  803186:	eb 0a                	jmp    803192 <alloc_block_NF+0xcb>
  803188:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80318b:	8b 00                	mov    (%eax),%eax
  80318d:	a3 48 51 80 00       	mov    %eax,0x805148
  803192:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803195:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80319e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a5:	a1 54 51 80 00       	mov    0x805154,%eax
  8031aa:	48                   	dec    %eax
  8031ab:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  8031b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8031b3:	e9 ad 00 00 00       	jmp    803265 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8031b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8031be:	3b 45 08             	cmp    0x8(%ebp),%eax
  8031c1:	0f 85 87 00 00 00    	jne    80324e <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8031c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031cb:	75 17                	jne    8031e4 <alloc_block_NF+0x11d>
  8031cd:	83 ec 04             	sub    $0x4,%esp
  8031d0:	68 e9 48 80 00       	push   $0x8048e9
  8031d5:	68 c8 00 00 00       	push   $0xc8
  8031da:	68 77 48 80 00       	push   $0x804877
  8031df:	e8 a3 da ff ff       	call   800c87 <_panic>
  8031e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e7:	8b 00                	mov    (%eax),%eax
  8031e9:	85 c0                	test   %eax,%eax
  8031eb:	74 10                	je     8031fd <alloc_block_NF+0x136>
  8031ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f0:	8b 00                	mov    (%eax),%eax
  8031f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031f5:	8b 52 04             	mov    0x4(%edx),%edx
  8031f8:	89 50 04             	mov    %edx,0x4(%eax)
  8031fb:	eb 0b                	jmp    803208 <alloc_block_NF+0x141>
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 40 04             	mov    0x4(%eax),%eax
  803203:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803208:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320b:	8b 40 04             	mov    0x4(%eax),%eax
  80320e:	85 c0                	test   %eax,%eax
  803210:	74 0f                	je     803221 <alloc_block_NF+0x15a>
  803212:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803215:	8b 40 04             	mov    0x4(%eax),%eax
  803218:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80321b:	8b 12                	mov    (%edx),%edx
  80321d:	89 10                	mov    %edx,(%eax)
  80321f:	eb 0a                	jmp    80322b <alloc_block_NF+0x164>
  803221:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803224:	8b 00                	mov    (%eax),%eax
  803226:	a3 38 51 80 00       	mov    %eax,0x805138
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803234:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803237:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323e:	a1 44 51 80 00       	mov    0x805144,%eax
  803243:	48                   	dec    %eax
  803244:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  803249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80324c:	eb 17                	jmp    803265 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80324e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803251:	8b 00                	mov    (%eax),%eax
  803253:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  803256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325a:	0f 85 7a fe ff ff    	jne    8030da <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  803260:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803265:	c9                   	leave  
  803266:	c3                   	ret    

00803267 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803267:	55                   	push   %ebp
  803268:	89 e5                	mov    %esp,%ebp
  80326a:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80326d:	a1 38 51 80 00       	mov    0x805138,%eax
  803272:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803275:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80327a:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80327d:	a1 44 51 80 00       	mov    0x805144,%eax
  803282:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  803285:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803289:	75 68                	jne    8032f3 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80328b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328f:	75 17                	jne    8032a8 <insert_sorted_with_merge_freeList+0x41>
  803291:	83 ec 04             	sub    $0x4,%esp
  803294:	68 54 48 80 00       	push   $0x804854
  803299:	68 da 00 00 00       	push   $0xda
  80329e:	68 77 48 80 00       	push   $0x804877
  8032a3:	e8 df d9 ff ff       	call   800c87 <_panic>
  8032a8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	89 10                	mov    %edx,(%eax)
  8032b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b6:	8b 00                	mov    (%eax),%eax
  8032b8:	85 c0                	test   %eax,%eax
  8032ba:	74 0d                	je     8032c9 <insert_sorted_with_merge_freeList+0x62>
  8032bc:	a1 38 51 80 00       	mov    0x805138,%eax
  8032c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c4:	89 50 04             	mov    %edx,0x4(%eax)
  8032c7:	eb 08                	jmp    8032d1 <insert_sorted_with_merge_freeList+0x6a>
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e3:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e8:	40                   	inc    %eax
  8032e9:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  8032ee:	e9 49 07 00 00       	jmp    803a3c <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8032f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f6:	8b 50 08             	mov    0x8(%eax),%edx
  8032f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ff:	01 c2                	add    %eax,%edx
  803301:	8b 45 08             	mov    0x8(%ebp),%eax
  803304:	8b 40 08             	mov    0x8(%eax),%eax
  803307:	39 c2                	cmp    %eax,%edx
  803309:	73 77                	jae    803382 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80330b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80330e:	8b 00                	mov    (%eax),%eax
  803310:	85 c0                	test   %eax,%eax
  803312:	75 6e                	jne    803382 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803314:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803318:	74 68                	je     803382 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  80331a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80331e:	75 17                	jne    803337 <insert_sorted_with_merge_freeList+0xd0>
  803320:	83 ec 04             	sub    $0x4,%esp
  803323:	68 90 48 80 00       	push   $0x804890
  803328:	68 e0 00 00 00       	push   $0xe0
  80332d:	68 77 48 80 00       	push   $0x804877
  803332:	e8 50 d9 ff ff       	call   800c87 <_panic>
  803337:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80333d:	8b 45 08             	mov    0x8(%ebp),%eax
  803340:	89 50 04             	mov    %edx,0x4(%eax)
  803343:	8b 45 08             	mov    0x8(%ebp),%eax
  803346:	8b 40 04             	mov    0x4(%eax),%eax
  803349:	85 c0                	test   %eax,%eax
  80334b:	74 0c                	je     803359 <insert_sorted_with_merge_freeList+0xf2>
  80334d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803352:	8b 55 08             	mov    0x8(%ebp),%edx
  803355:	89 10                	mov    %edx,(%eax)
  803357:	eb 08                	jmp    803361 <insert_sorted_with_merge_freeList+0xfa>
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	a3 38 51 80 00       	mov    %eax,0x805138
  803361:	8b 45 08             	mov    0x8(%ebp),%eax
  803364:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803369:	8b 45 08             	mov    0x8(%ebp),%eax
  80336c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803372:	a1 44 51 80 00       	mov    0x805144,%eax
  803377:	40                   	inc    %eax
  803378:	a3 44 51 80 00       	mov    %eax,0x805144
  80337d:	e9 ba 06 00 00       	jmp    803a3c <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803382:	8b 45 08             	mov    0x8(%ebp),%eax
  803385:	8b 50 0c             	mov    0xc(%eax),%edx
  803388:	8b 45 08             	mov    0x8(%ebp),%eax
  80338b:	8b 40 08             	mov    0x8(%eax),%eax
  80338e:	01 c2                	add    %eax,%edx
  803390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803393:	8b 40 08             	mov    0x8(%eax),%eax
  803396:	39 c2                	cmp    %eax,%edx
  803398:	73 78                	jae    803412 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  80339a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80339d:	8b 40 04             	mov    0x4(%eax),%eax
  8033a0:	85 c0                	test   %eax,%eax
  8033a2:	75 6e                	jne    803412 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8033a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8033a8:	74 68                	je     803412 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8033aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ae:	75 17                	jne    8033c7 <insert_sorted_with_merge_freeList+0x160>
  8033b0:	83 ec 04             	sub    $0x4,%esp
  8033b3:	68 54 48 80 00       	push   $0x804854
  8033b8:	68 e6 00 00 00       	push   $0xe6
  8033bd:	68 77 48 80 00       	push   $0x804877
  8033c2:	e8 c0 d8 ff ff       	call   800c87 <_panic>
  8033c7:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	89 10                	mov    %edx,(%eax)
  8033d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d5:	8b 00                	mov    (%eax),%eax
  8033d7:	85 c0                	test   %eax,%eax
  8033d9:	74 0d                	je     8033e8 <insert_sorted_with_merge_freeList+0x181>
  8033db:	a1 38 51 80 00       	mov    0x805138,%eax
  8033e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e3:	89 50 04             	mov    %edx,0x4(%eax)
  8033e6:	eb 08                	jmp    8033f0 <insert_sorted_with_merge_freeList+0x189>
  8033e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033eb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f3:	a3 38 51 80 00       	mov    %eax,0x805138
  8033f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803402:	a1 44 51 80 00       	mov    0x805144,%eax
  803407:	40                   	inc    %eax
  803408:	a3 44 51 80 00       	mov    %eax,0x805144
  80340d:	e9 2a 06 00 00       	jmp    803a3c <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803412:	a1 38 51 80 00       	mov    0x805138,%eax
  803417:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80341a:	e9 ed 05 00 00       	jmp    803a0c <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803422:	8b 00                	mov    (%eax),%eax
  803424:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803427:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80342b:	0f 84 a7 00 00 00    	je     8034d8 <insert_sorted_with_merge_freeList+0x271>
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	8b 50 0c             	mov    0xc(%eax),%edx
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	8b 40 08             	mov    0x8(%eax),%eax
  80343d:	01 c2                	add    %eax,%edx
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	8b 40 08             	mov    0x8(%eax),%eax
  803445:	39 c2                	cmp    %eax,%edx
  803447:	0f 83 8b 00 00 00    	jae    8034d8 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	8b 50 0c             	mov    0xc(%eax),%edx
  803453:	8b 45 08             	mov    0x8(%ebp),%eax
  803456:	8b 40 08             	mov    0x8(%eax),%eax
  803459:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  80345b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80345e:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803461:	39 c2                	cmp    %eax,%edx
  803463:	73 73                	jae    8034d8 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803465:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803469:	74 06                	je     803471 <insert_sorted_with_merge_freeList+0x20a>
  80346b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80346f:	75 17                	jne    803488 <insert_sorted_with_merge_freeList+0x221>
  803471:	83 ec 04             	sub    $0x4,%esp
  803474:	68 08 49 80 00       	push   $0x804908
  803479:	68 f0 00 00 00       	push   $0xf0
  80347e:	68 77 48 80 00       	push   $0x804877
  803483:	e8 ff d7 ff ff       	call   800c87 <_panic>
  803488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348b:	8b 10                	mov    (%eax),%edx
  80348d:	8b 45 08             	mov    0x8(%ebp),%eax
  803490:	89 10                	mov    %edx,(%eax)
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	8b 00                	mov    (%eax),%eax
  803497:	85 c0                	test   %eax,%eax
  803499:	74 0b                	je     8034a6 <insert_sorted_with_merge_freeList+0x23f>
  80349b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349e:	8b 00                	mov    (%eax),%eax
  8034a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a3:	89 50 04             	mov    %edx,0x4(%eax)
  8034a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ac:	89 10                	mov    %edx,(%eax)
  8034ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8034b4:	89 50 04             	mov    %edx,0x4(%eax)
  8034b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ba:	8b 00                	mov    (%eax),%eax
  8034bc:	85 c0                	test   %eax,%eax
  8034be:	75 08                	jne    8034c8 <insert_sorted_with_merge_freeList+0x261>
  8034c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034c3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8034c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8034cd:	40                   	inc    %eax
  8034ce:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  8034d3:	e9 64 05 00 00       	jmp    803a3c <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  8034d8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034dd:	8b 50 0c             	mov    0xc(%eax),%edx
  8034e0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034e5:	8b 40 08             	mov    0x8(%eax),%eax
  8034e8:	01 c2                	add    %eax,%edx
  8034ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ed:	8b 40 08             	mov    0x8(%eax),%eax
  8034f0:	39 c2                	cmp    %eax,%edx
  8034f2:	0f 85 b1 00 00 00    	jne    8035a9 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  8034f8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034fd:	85 c0                	test   %eax,%eax
  8034ff:	0f 84 a4 00 00 00    	je     8035a9 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803505:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80350a:	8b 00                	mov    (%eax),%eax
  80350c:	85 c0                	test   %eax,%eax
  80350e:	0f 85 95 00 00 00    	jne    8035a9 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803514:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803519:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80351f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803522:	8b 55 08             	mov    0x8(%ebp),%edx
  803525:	8b 52 0c             	mov    0xc(%edx),%edx
  803528:	01 ca                	add    %ecx,%edx
  80352a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  80352d:	8b 45 08             	mov    0x8(%ebp),%eax
  803530:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803537:	8b 45 08             	mov    0x8(%ebp),%eax
  80353a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803541:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803545:	75 17                	jne    80355e <insert_sorted_with_merge_freeList+0x2f7>
  803547:	83 ec 04             	sub    $0x4,%esp
  80354a:	68 54 48 80 00       	push   $0x804854
  80354f:	68 ff 00 00 00       	push   $0xff
  803554:	68 77 48 80 00       	push   $0x804877
  803559:	e8 29 d7 ff ff       	call   800c87 <_panic>
  80355e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803564:	8b 45 08             	mov    0x8(%ebp),%eax
  803567:	89 10                	mov    %edx,(%eax)
  803569:	8b 45 08             	mov    0x8(%ebp),%eax
  80356c:	8b 00                	mov    (%eax),%eax
  80356e:	85 c0                	test   %eax,%eax
  803570:	74 0d                	je     80357f <insert_sorted_with_merge_freeList+0x318>
  803572:	a1 48 51 80 00       	mov    0x805148,%eax
  803577:	8b 55 08             	mov    0x8(%ebp),%edx
  80357a:	89 50 04             	mov    %edx,0x4(%eax)
  80357d:	eb 08                	jmp    803587 <insert_sorted_with_merge_freeList+0x320>
  80357f:	8b 45 08             	mov    0x8(%ebp),%eax
  803582:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803587:	8b 45 08             	mov    0x8(%ebp),%eax
  80358a:	a3 48 51 80 00       	mov    %eax,0x805148
  80358f:	8b 45 08             	mov    0x8(%ebp),%eax
  803592:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803599:	a1 54 51 80 00       	mov    0x805154,%eax
  80359e:	40                   	inc    %eax
  80359f:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8035a4:	e9 93 04 00 00       	jmp    803a3c <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8035a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ac:	8b 50 08             	mov    0x8(%eax),%edx
  8035af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8035b5:	01 c2                	add    %eax,%edx
  8035b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ba:	8b 40 08             	mov    0x8(%eax),%eax
  8035bd:	39 c2                	cmp    %eax,%edx
  8035bf:	0f 85 ae 00 00 00    	jne    803673 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8035c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c8:	8b 50 0c             	mov    0xc(%eax),%edx
  8035cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ce:	8b 40 08             	mov    0x8(%eax),%eax
  8035d1:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  8035d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d6:	8b 00                	mov    (%eax),%eax
  8035d8:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  8035db:	39 c2                	cmp    %eax,%edx
  8035dd:	0f 84 90 00 00 00    	je     803673 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  8035e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e6:	8b 50 0c             	mov    0xc(%eax),%edx
  8035e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ef:	01 c2                	add    %eax,%edx
  8035f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8035f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803601:	8b 45 08             	mov    0x8(%ebp),%eax
  803604:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80360b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80360f:	75 17                	jne    803628 <insert_sorted_with_merge_freeList+0x3c1>
  803611:	83 ec 04             	sub    $0x4,%esp
  803614:	68 54 48 80 00       	push   $0x804854
  803619:	68 0b 01 00 00       	push   $0x10b
  80361e:	68 77 48 80 00       	push   $0x804877
  803623:	e8 5f d6 ff ff       	call   800c87 <_panic>
  803628:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80362e:	8b 45 08             	mov    0x8(%ebp),%eax
  803631:	89 10                	mov    %edx,(%eax)
  803633:	8b 45 08             	mov    0x8(%ebp),%eax
  803636:	8b 00                	mov    (%eax),%eax
  803638:	85 c0                	test   %eax,%eax
  80363a:	74 0d                	je     803649 <insert_sorted_with_merge_freeList+0x3e2>
  80363c:	a1 48 51 80 00       	mov    0x805148,%eax
  803641:	8b 55 08             	mov    0x8(%ebp),%edx
  803644:	89 50 04             	mov    %edx,0x4(%eax)
  803647:	eb 08                	jmp    803651 <insert_sorted_with_merge_freeList+0x3ea>
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	a3 48 51 80 00       	mov    %eax,0x805148
  803659:	8b 45 08             	mov    0x8(%ebp),%eax
  80365c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803663:	a1 54 51 80 00       	mov    0x805154,%eax
  803668:	40                   	inc    %eax
  803669:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80366e:	e9 c9 03 00 00       	jmp    803a3c <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803673:	8b 45 08             	mov    0x8(%ebp),%eax
  803676:	8b 50 0c             	mov    0xc(%eax),%edx
  803679:	8b 45 08             	mov    0x8(%ebp),%eax
  80367c:	8b 40 08             	mov    0x8(%eax),%eax
  80367f:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803684:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803687:	39 c2                	cmp    %eax,%edx
  803689:	0f 85 bb 00 00 00    	jne    80374a <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  80368f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803693:	0f 84 b1 00 00 00    	je     80374a <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369c:	8b 40 04             	mov    0x4(%eax),%eax
  80369f:	85 c0                	test   %eax,%eax
  8036a1:	0f 85 a3 00 00 00    	jne    80374a <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8036a7:	a1 38 51 80 00       	mov    0x805138,%eax
  8036ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8036af:	8b 52 08             	mov    0x8(%edx),%edx
  8036b2:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8036b5:	a1 38 51 80 00       	mov    0x805138,%eax
  8036ba:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8036c0:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8036c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8036c6:	8b 52 0c             	mov    0xc(%edx),%edx
  8036c9:	01 ca                	add    %ecx,%edx
  8036cb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8036ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8036d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036db:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8036e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e6:	75 17                	jne    8036ff <insert_sorted_with_merge_freeList+0x498>
  8036e8:	83 ec 04             	sub    $0x4,%esp
  8036eb:	68 54 48 80 00       	push   $0x804854
  8036f0:	68 17 01 00 00       	push   $0x117
  8036f5:	68 77 48 80 00       	push   $0x804877
  8036fa:	e8 88 d5 ff ff       	call   800c87 <_panic>
  8036ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803705:	8b 45 08             	mov    0x8(%ebp),%eax
  803708:	89 10                	mov    %edx,(%eax)
  80370a:	8b 45 08             	mov    0x8(%ebp),%eax
  80370d:	8b 00                	mov    (%eax),%eax
  80370f:	85 c0                	test   %eax,%eax
  803711:	74 0d                	je     803720 <insert_sorted_with_merge_freeList+0x4b9>
  803713:	a1 48 51 80 00       	mov    0x805148,%eax
  803718:	8b 55 08             	mov    0x8(%ebp),%edx
  80371b:	89 50 04             	mov    %edx,0x4(%eax)
  80371e:	eb 08                	jmp    803728 <insert_sorted_with_merge_freeList+0x4c1>
  803720:	8b 45 08             	mov    0x8(%ebp),%eax
  803723:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803728:	8b 45 08             	mov    0x8(%ebp),%eax
  80372b:	a3 48 51 80 00       	mov    %eax,0x805148
  803730:	8b 45 08             	mov    0x8(%ebp),%eax
  803733:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80373a:	a1 54 51 80 00       	mov    0x805154,%eax
  80373f:	40                   	inc    %eax
  803740:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803745:	e9 f2 02 00 00       	jmp    803a3c <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  80374a:	8b 45 08             	mov    0x8(%ebp),%eax
  80374d:	8b 50 08             	mov    0x8(%eax),%edx
  803750:	8b 45 08             	mov    0x8(%ebp),%eax
  803753:	8b 40 0c             	mov    0xc(%eax),%eax
  803756:	01 c2                	add    %eax,%edx
  803758:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375b:	8b 40 08             	mov    0x8(%eax),%eax
  80375e:	39 c2                	cmp    %eax,%edx
  803760:	0f 85 be 00 00 00    	jne    803824 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803769:	8b 40 04             	mov    0x4(%eax),%eax
  80376c:	8b 50 08             	mov    0x8(%eax),%edx
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 40 04             	mov    0x4(%eax),%eax
  803775:	8b 40 0c             	mov    0xc(%eax),%eax
  803778:	01 c2                	add    %eax,%edx
  80377a:	8b 45 08             	mov    0x8(%ebp),%eax
  80377d:	8b 40 08             	mov    0x8(%eax),%eax
  803780:	39 c2                	cmp    %eax,%edx
  803782:	0f 84 9c 00 00 00    	je     803824 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  803788:	8b 45 08             	mov    0x8(%ebp),%eax
  80378b:	8b 50 08             	mov    0x8(%eax),%edx
  80378e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803791:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803797:	8b 50 0c             	mov    0xc(%eax),%edx
  80379a:	8b 45 08             	mov    0x8(%ebp),%eax
  80379d:	8b 40 0c             	mov    0xc(%eax),%eax
  8037a0:	01 c2                	add    %eax,%edx
  8037a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a5:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8037a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ab:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8037b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8037bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037c0:	75 17                	jne    8037d9 <insert_sorted_with_merge_freeList+0x572>
  8037c2:	83 ec 04             	sub    $0x4,%esp
  8037c5:	68 54 48 80 00       	push   $0x804854
  8037ca:	68 26 01 00 00       	push   $0x126
  8037cf:	68 77 48 80 00       	push   $0x804877
  8037d4:	e8 ae d4 ff ff       	call   800c87 <_panic>
  8037d9:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037df:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e2:	89 10                	mov    %edx,(%eax)
  8037e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e7:	8b 00                	mov    (%eax),%eax
  8037e9:	85 c0                	test   %eax,%eax
  8037eb:	74 0d                	je     8037fa <insert_sorted_with_merge_freeList+0x593>
  8037ed:	a1 48 51 80 00       	mov    0x805148,%eax
  8037f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f5:	89 50 04             	mov    %edx,0x4(%eax)
  8037f8:	eb 08                	jmp    803802 <insert_sorted_with_merge_freeList+0x59b>
  8037fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803802:	8b 45 08             	mov    0x8(%ebp),%eax
  803805:	a3 48 51 80 00       	mov    %eax,0x805148
  80380a:	8b 45 08             	mov    0x8(%ebp),%eax
  80380d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803814:	a1 54 51 80 00       	mov    0x805154,%eax
  803819:	40                   	inc    %eax
  80381a:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  80381f:	e9 18 02 00 00       	jmp    803a3c <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803827:	8b 50 0c             	mov    0xc(%eax),%edx
  80382a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382d:	8b 40 08             	mov    0x8(%eax),%eax
  803830:	01 c2                	add    %eax,%edx
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	8b 40 08             	mov    0x8(%eax),%eax
  803838:	39 c2                	cmp    %eax,%edx
  80383a:	0f 85 c4 01 00 00    	jne    803a04 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803840:	8b 45 08             	mov    0x8(%ebp),%eax
  803843:	8b 50 0c             	mov    0xc(%eax),%edx
  803846:	8b 45 08             	mov    0x8(%ebp),%eax
  803849:	8b 40 08             	mov    0x8(%eax),%eax
  80384c:	01 c2                	add    %eax,%edx
  80384e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803851:	8b 00                	mov    (%eax),%eax
  803853:	8b 40 08             	mov    0x8(%eax),%eax
  803856:	39 c2                	cmp    %eax,%edx
  803858:	0f 85 a6 01 00 00    	jne    803a04 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  80385e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803862:	0f 84 9c 01 00 00    	je     803a04 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80386b:	8b 50 0c             	mov    0xc(%eax),%edx
  80386e:	8b 45 08             	mov    0x8(%ebp),%eax
  803871:	8b 40 0c             	mov    0xc(%eax),%eax
  803874:	01 c2                	add    %eax,%edx
  803876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803879:	8b 00                	mov    (%eax),%eax
  80387b:	8b 40 0c             	mov    0xc(%eax),%eax
  80387e:	01 c2                	add    %eax,%edx
  803880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803883:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803886:	8b 45 08             	mov    0x8(%ebp),%eax
  803889:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803890:	8b 45 08             	mov    0x8(%ebp),%eax
  803893:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80389a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80389e:	75 17                	jne    8038b7 <insert_sorted_with_merge_freeList+0x650>
  8038a0:	83 ec 04             	sub    $0x4,%esp
  8038a3:	68 54 48 80 00       	push   $0x804854
  8038a8:	68 32 01 00 00       	push   $0x132
  8038ad:	68 77 48 80 00       	push   $0x804877
  8038b2:	e8 d0 d3 ff ff       	call   800c87 <_panic>
  8038b7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c0:	89 10                	mov    %edx,(%eax)
  8038c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c5:	8b 00                	mov    (%eax),%eax
  8038c7:	85 c0                	test   %eax,%eax
  8038c9:	74 0d                	je     8038d8 <insert_sorted_with_merge_freeList+0x671>
  8038cb:	a1 48 51 80 00       	mov    0x805148,%eax
  8038d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8038d3:	89 50 04             	mov    %edx,0x4(%eax)
  8038d6:	eb 08                	jmp    8038e0 <insert_sorted_with_merge_freeList+0x679>
  8038d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038db:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8038e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8038e3:	a3 48 51 80 00       	mov    %eax,0x805148
  8038e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8038eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038f2:	a1 54 51 80 00       	mov    0x805154,%eax
  8038f7:	40                   	inc    %eax
  8038f8:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  8038fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803900:	8b 00                	mov    (%eax),%eax
  803902:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80390c:	8b 00                	mov    (%eax),%eax
  80390e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803918:	8b 00                	mov    (%eax),%eax
  80391a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80391d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803921:	75 17                	jne    80393a <insert_sorted_with_merge_freeList+0x6d3>
  803923:	83 ec 04             	sub    $0x4,%esp
  803926:	68 e9 48 80 00       	push   $0x8048e9
  80392b:	68 36 01 00 00       	push   $0x136
  803930:	68 77 48 80 00       	push   $0x804877
  803935:	e8 4d d3 ff ff       	call   800c87 <_panic>
  80393a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80393d:	8b 00                	mov    (%eax),%eax
  80393f:	85 c0                	test   %eax,%eax
  803941:	74 10                	je     803953 <insert_sorted_with_merge_freeList+0x6ec>
  803943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803946:	8b 00                	mov    (%eax),%eax
  803948:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80394b:	8b 52 04             	mov    0x4(%edx),%edx
  80394e:	89 50 04             	mov    %edx,0x4(%eax)
  803951:	eb 0b                	jmp    80395e <insert_sorted_with_merge_freeList+0x6f7>
  803953:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803956:	8b 40 04             	mov    0x4(%eax),%eax
  803959:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80395e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803961:	8b 40 04             	mov    0x4(%eax),%eax
  803964:	85 c0                	test   %eax,%eax
  803966:	74 0f                	je     803977 <insert_sorted_with_merge_freeList+0x710>
  803968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80396b:	8b 40 04             	mov    0x4(%eax),%eax
  80396e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803971:	8b 12                	mov    (%edx),%edx
  803973:	89 10                	mov    %edx,(%eax)
  803975:	eb 0a                	jmp    803981 <insert_sorted_with_merge_freeList+0x71a>
  803977:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80397a:	8b 00                	mov    (%eax),%eax
  80397c:	a3 38 51 80 00       	mov    %eax,0x805138
  803981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803984:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80398a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80398d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803994:	a1 44 51 80 00       	mov    0x805144,%eax
  803999:	48                   	dec    %eax
  80399a:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80399f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8039a3:	75 17                	jne    8039bc <insert_sorted_with_merge_freeList+0x755>
  8039a5:	83 ec 04             	sub    $0x4,%esp
  8039a8:	68 54 48 80 00       	push   $0x804854
  8039ad:	68 37 01 00 00       	push   $0x137
  8039b2:	68 77 48 80 00       	push   $0x804877
  8039b7:	e8 cb d2 ff ff       	call   800c87 <_panic>
  8039bc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8039c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039c5:	89 10                	mov    %edx,(%eax)
  8039c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ca:	8b 00                	mov    (%eax),%eax
  8039cc:	85 c0                	test   %eax,%eax
  8039ce:	74 0d                	je     8039dd <insert_sorted_with_merge_freeList+0x776>
  8039d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8039d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8039d8:	89 50 04             	mov    %edx,0x4(%eax)
  8039db:	eb 08                	jmp    8039e5 <insert_sorted_with_merge_freeList+0x77e>
  8039dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8039ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039f7:	a1 54 51 80 00       	mov    0x805154,%eax
  8039fc:	40                   	inc    %eax
  8039fd:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803a02:	eb 38                	jmp    803a3c <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803a04:	a1 40 51 80 00       	mov    0x805140,%eax
  803a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803a0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a10:	74 07                	je     803a19 <insert_sorted_with_merge_freeList+0x7b2>
  803a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a15:	8b 00                	mov    (%eax),%eax
  803a17:	eb 05                	jmp    803a1e <insert_sorted_with_merge_freeList+0x7b7>
  803a19:	b8 00 00 00 00       	mov    $0x0,%eax
  803a1e:	a3 40 51 80 00       	mov    %eax,0x805140
  803a23:	a1 40 51 80 00       	mov    0x805140,%eax
  803a28:	85 c0                	test   %eax,%eax
  803a2a:	0f 85 ef f9 ff ff    	jne    80341f <insert_sorted_with_merge_freeList+0x1b8>
  803a30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a34:	0f 85 e5 f9 ff ff    	jne    80341f <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803a3a:	eb 00                	jmp    803a3c <insert_sorted_with_merge_freeList+0x7d5>
  803a3c:	90                   	nop
  803a3d:	c9                   	leave  
  803a3e:	c3                   	ret    

00803a3f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803a3f:	55                   	push   %ebp
  803a40:	89 e5                	mov    %esp,%ebp
  803a42:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803a45:	8b 55 08             	mov    0x8(%ebp),%edx
  803a48:	89 d0                	mov    %edx,%eax
  803a4a:	c1 e0 02             	shl    $0x2,%eax
  803a4d:	01 d0                	add    %edx,%eax
  803a4f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a56:	01 d0                	add    %edx,%eax
  803a58:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a5f:	01 d0                	add    %edx,%eax
  803a61:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803a68:	01 d0                	add    %edx,%eax
  803a6a:	c1 e0 04             	shl    $0x4,%eax
  803a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803a70:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803a77:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803a7a:	83 ec 0c             	sub    $0xc,%esp
  803a7d:	50                   	push   %eax
  803a7e:	e8 21 ec ff ff       	call   8026a4 <sys_get_virtual_time>
  803a83:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803a86:	eb 41                	jmp    803ac9 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803a88:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803a8b:	83 ec 0c             	sub    $0xc,%esp
  803a8e:	50                   	push   %eax
  803a8f:	e8 10 ec ff ff       	call   8026a4 <sys_get_virtual_time>
  803a94:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803a97:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803a9d:	29 c2                	sub    %eax,%edx
  803a9f:	89 d0                	mov    %edx,%eax
  803aa1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803aa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803aa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aaa:	89 d1                	mov    %edx,%ecx
  803aac:	29 c1                	sub    %eax,%ecx
  803aae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803ab1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803ab4:	39 c2                	cmp    %eax,%edx
  803ab6:	0f 97 c0             	seta   %al
  803ab9:	0f b6 c0             	movzbl %al,%eax
  803abc:	29 c1                	sub    %eax,%ecx
  803abe:	89 c8                	mov    %ecx,%eax
  803ac0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803ac3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803acc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803acf:	72 b7                	jb     803a88 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803ad1:	90                   	nop
  803ad2:	c9                   	leave  
  803ad3:	c3                   	ret    

00803ad4 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803ad4:	55                   	push   %ebp
  803ad5:	89 e5                	mov    %esp,%ebp
  803ad7:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803ada:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803ae1:	eb 03                	jmp    803ae6 <busy_wait+0x12>
  803ae3:	ff 45 fc             	incl   -0x4(%ebp)
  803ae6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803ae9:	3b 45 08             	cmp    0x8(%ebp),%eax
  803aec:	72 f5                	jb     803ae3 <busy_wait+0xf>
	return i;
  803aee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803af1:	c9                   	leave  
  803af2:	c3                   	ret    
  803af3:	90                   	nop

00803af4 <__udivdi3>:
  803af4:	55                   	push   %ebp
  803af5:	57                   	push   %edi
  803af6:	56                   	push   %esi
  803af7:	53                   	push   %ebx
  803af8:	83 ec 1c             	sub    $0x1c,%esp
  803afb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803aff:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803b03:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b07:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b0b:	89 ca                	mov    %ecx,%edx
  803b0d:	89 f8                	mov    %edi,%eax
  803b0f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803b13:	85 f6                	test   %esi,%esi
  803b15:	75 2d                	jne    803b44 <__udivdi3+0x50>
  803b17:	39 cf                	cmp    %ecx,%edi
  803b19:	77 65                	ja     803b80 <__udivdi3+0x8c>
  803b1b:	89 fd                	mov    %edi,%ebp
  803b1d:	85 ff                	test   %edi,%edi
  803b1f:	75 0b                	jne    803b2c <__udivdi3+0x38>
  803b21:	b8 01 00 00 00       	mov    $0x1,%eax
  803b26:	31 d2                	xor    %edx,%edx
  803b28:	f7 f7                	div    %edi
  803b2a:	89 c5                	mov    %eax,%ebp
  803b2c:	31 d2                	xor    %edx,%edx
  803b2e:	89 c8                	mov    %ecx,%eax
  803b30:	f7 f5                	div    %ebp
  803b32:	89 c1                	mov    %eax,%ecx
  803b34:	89 d8                	mov    %ebx,%eax
  803b36:	f7 f5                	div    %ebp
  803b38:	89 cf                	mov    %ecx,%edi
  803b3a:	89 fa                	mov    %edi,%edx
  803b3c:	83 c4 1c             	add    $0x1c,%esp
  803b3f:	5b                   	pop    %ebx
  803b40:	5e                   	pop    %esi
  803b41:	5f                   	pop    %edi
  803b42:	5d                   	pop    %ebp
  803b43:	c3                   	ret    
  803b44:	39 ce                	cmp    %ecx,%esi
  803b46:	77 28                	ja     803b70 <__udivdi3+0x7c>
  803b48:	0f bd fe             	bsr    %esi,%edi
  803b4b:	83 f7 1f             	xor    $0x1f,%edi
  803b4e:	75 40                	jne    803b90 <__udivdi3+0x9c>
  803b50:	39 ce                	cmp    %ecx,%esi
  803b52:	72 0a                	jb     803b5e <__udivdi3+0x6a>
  803b54:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803b58:	0f 87 9e 00 00 00    	ja     803bfc <__udivdi3+0x108>
  803b5e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b63:	89 fa                	mov    %edi,%edx
  803b65:	83 c4 1c             	add    $0x1c,%esp
  803b68:	5b                   	pop    %ebx
  803b69:	5e                   	pop    %esi
  803b6a:	5f                   	pop    %edi
  803b6b:	5d                   	pop    %ebp
  803b6c:	c3                   	ret    
  803b6d:	8d 76 00             	lea    0x0(%esi),%esi
  803b70:	31 ff                	xor    %edi,%edi
  803b72:	31 c0                	xor    %eax,%eax
  803b74:	89 fa                	mov    %edi,%edx
  803b76:	83 c4 1c             	add    $0x1c,%esp
  803b79:	5b                   	pop    %ebx
  803b7a:	5e                   	pop    %esi
  803b7b:	5f                   	pop    %edi
  803b7c:	5d                   	pop    %ebp
  803b7d:	c3                   	ret    
  803b7e:	66 90                	xchg   %ax,%ax
  803b80:	89 d8                	mov    %ebx,%eax
  803b82:	f7 f7                	div    %edi
  803b84:	31 ff                	xor    %edi,%edi
  803b86:	89 fa                	mov    %edi,%edx
  803b88:	83 c4 1c             	add    $0x1c,%esp
  803b8b:	5b                   	pop    %ebx
  803b8c:	5e                   	pop    %esi
  803b8d:	5f                   	pop    %edi
  803b8e:	5d                   	pop    %ebp
  803b8f:	c3                   	ret    
  803b90:	bd 20 00 00 00       	mov    $0x20,%ebp
  803b95:	89 eb                	mov    %ebp,%ebx
  803b97:	29 fb                	sub    %edi,%ebx
  803b99:	89 f9                	mov    %edi,%ecx
  803b9b:	d3 e6                	shl    %cl,%esi
  803b9d:	89 c5                	mov    %eax,%ebp
  803b9f:	88 d9                	mov    %bl,%cl
  803ba1:	d3 ed                	shr    %cl,%ebp
  803ba3:	89 e9                	mov    %ebp,%ecx
  803ba5:	09 f1                	or     %esi,%ecx
  803ba7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803bab:	89 f9                	mov    %edi,%ecx
  803bad:	d3 e0                	shl    %cl,%eax
  803baf:	89 c5                	mov    %eax,%ebp
  803bb1:	89 d6                	mov    %edx,%esi
  803bb3:	88 d9                	mov    %bl,%cl
  803bb5:	d3 ee                	shr    %cl,%esi
  803bb7:	89 f9                	mov    %edi,%ecx
  803bb9:	d3 e2                	shl    %cl,%edx
  803bbb:	8b 44 24 08          	mov    0x8(%esp),%eax
  803bbf:	88 d9                	mov    %bl,%cl
  803bc1:	d3 e8                	shr    %cl,%eax
  803bc3:	09 c2                	or     %eax,%edx
  803bc5:	89 d0                	mov    %edx,%eax
  803bc7:	89 f2                	mov    %esi,%edx
  803bc9:	f7 74 24 0c          	divl   0xc(%esp)
  803bcd:	89 d6                	mov    %edx,%esi
  803bcf:	89 c3                	mov    %eax,%ebx
  803bd1:	f7 e5                	mul    %ebp
  803bd3:	39 d6                	cmp    %edx,%esi
  803bd5:	72 19                	jb     803bf0 <__udivdi3+0xfc>
  803bd7:	74 0b                	je     803be4 <__udivdi3+0xf0>
  803bd9:	89 d8                	mov    %ebx,%eax
  803bdb:	31 ff                	xor    %edi,%edi
  803bdd:	e9 58 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803be2:	66 90                	xchg   %ax,%ax
  803be4:	8b 54 24 08          	mov    0x8(%esp),%edx
  803be8:	89 f9                	mov    %edi,%ecx
  803bea:	d3 e2                	shl    %cl,%edx
  803bec:	39 c2                	cmp    %eax,%edx
  803bee:	73 e9                	jae    803bd9 <__udivdi3+0xe5>
  803bf0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803bf3:	31 ff                	xor    %edi,%edi
  803bf5:	e9 40 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803bfa:	66 90                	xchg   %ax,%ax
  803bfc:	31 c0                	xor    %eax,%eax
  803bfe:	e9 37 ff ff ff       	jmp    803b3a <__udivdi3+0x46>
  803c03:	90                   	nop

00803c04 <__umoddi3>:
  803c04:	55                   	push   %ebp
  803c05:	57                   	push   %edi
  803c06:	56                   	push   %esi
  803c07:	53                   	push   %ebx
  803c08:	83 ec 1c             	sub    $0x1c,%esp
  803c0b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803c0f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803c13:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c17:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803c1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803c1f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803c23:	89 f3                	mov    %esi,%ebx
  803c25:	89 fa                	mov    %edi,%edx
  803c27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c2b:	89 34 24             	mov    %esi,(%esp)
  803c2e:	85 c0                	test   %eax,%eax
  803c30:	75 1a                	jne    803c4c <__umoddi3+0x48>
  803c32:	39 f7                	cmp    %esi,%edi
  803c34:	0f 86 a2 00 00 00    	jbe    803cdc <__umoddi3+0xd8>
  803c3a:	89 c8                	mov    %ecx,%eax
  803c3c:	89 f2                	mov    %esi,%edx
  803c3e:	f7 f7                	div    %edi
  803c40:	89 d0                	mov    %edx,%eax
  803c42:	31 d2                	xor    %edx,%edx
  803c44:	83 c4 1c             	add    $0x1c,%esp
  803c47:	5b                   	pop    %ebx
  803c48:	5e                   	pop    %esi
  803c49:	5f                   	pop    %edi
  803c4a:	5d                   	pop    %ebp
  803c4b:	c3                   	ret    
  803c4c:	39 f0                	cmp    %esi,%eax
  803c4e:	0f 87 ac 00 00 00    	ja     803d00 <__umoddi3+0xfc>
  803c54:	0f bd e8             	bsr    %eax,%ebp
  803c57:	83 f5 1f             	xor    $0x1f,%ebp
  803c5a:	0f 84 ac 00 00 00    	je     803d0c <__umoddi3+0x108>
  803c60:	bf 20 00 00 00       	mov    $0x20,%edi
  803c65:	29 ef                	sub    %ebp,%edi
  803c67:	89 fe                	mov    %edi,%esi
  803c69:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803c6d:	89 e9                	mov    %ebp,%ecx
  803c6f:	d3 e0                	shl    %cl,%eax
  803c71:	89 d7                	mov    %edx,%edi
  803c73:	89 f1                	mov    %esi,%ecx
  803c75:	d3 ef                	shr    %cl,%edi
  803c77:	09 c7                	or     %eax,%edi
  803c79:	89 e9                	mov    %ebp,%ecx
  803c7b:	d3 e2                	shl    %cl,%edx
  803c7d:	89 14 24             	mov    %edx,(%esp)
  803c80:	89 d8                	mov    %ebx,%eax
  803c82:	d3 e0                	shl    %cl,%eax
  803c84:	89 c2                	mov    %eax,%edx
  803c86:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c8a:	d3 e0                	shl    %cl,%eax
  803c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c90:	8b 44 24 08          	mov    0x8(%esp),%eax
  803c94:	89 f1                	mov    %esi,%ecx
  803c96:	d3 e8                	shr    %cl,%eax
  803c98:	09 d0                	or     %edx,%eax
  803c9a:	d3 eb                	shr    %cl,%ebx
  803c9c:	89 da                	mov    %ebx,%edx
  803c9e:	f7 f7                	div    %edi
  803ca0:	89 d3                	mov    %edx,%ebx
  803ca2:	f7 24 24             	mull   (%esp)
  803ca5:	89 c6                	mov    %eax,%esi
  803ca7:	89 d1                	mov    %edx,%ecx
  803ca9:	39 d3                	cmp    %edx,%ebx
  803cab:	0f 82 87 00 00 00    	jb     803d38 <__umoddi3+0x134>
  803cb1:	0f 84 91 00 00 00    	je     803d48 <__umoddi3+0x144>
  803cb7:	8b 54 24 04          	mov    0x4(%esp),%edx
  803cbb:	29 f2                	sub    %esi,%edx
  803cbd:	19 cb                	sbb    %ecx,%ebx
  803cbf:	89 d8                	mov    %ebx,%eax
  803cc1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803cc5:	d3 e0                	shl    %cl,%eax
  803cc7:	89 e9                	mov    %ebp,%ecx
  803cc9:	d3 ea                	shr    %cl,%edx
  803ccb:	09 d0                	or     %edx,%eax
  803ccd:	89 e9                	mov    %ebp,%ecx
  803ccf:	d3 eb                	shr    %cl,%ebx
  803cd1:	89 da                	mov    %ebx,%edx
  803cd3:	83 c4 1c             	add    $0x1c,%esp
  803cd6:	5b                   	pop    %ebx
  803cd7:	5e                   	pop    %esi
  803cd8:	5f                   	pop    %edi
  803cd9:	5d                   	pop    %ebp
  803cda:	c3                   	ret    
  803cdb:	90                   	nop
  803cdc:	89 fd                	mov    %edi,%ebp
  803cde:	85 ff                	test   %edi,%edi
  803ce0:	75 0b                	jne    803ced <__umoddi3+0xe9>
  803ce2:	b8 01 00 00 00       	mov    $0x1,%eax
  803ce7:	31 d2                	xor    %edx,%edx
  803ce9:	f7 f7                	div    %edi
  803ceb:	89 c5                	mov    %eax,%ebp
  803ced:	89 f0                	mov    %esi,%eax
  803cef:	31 d2                	xor    %edx,%edx
  803cf1:	f7 f5                	div    %ebp
  803cf3:	89 c8                	mov    %ecx,%eax
  803cf5:	f7 f5                	div    %ebp
  803cf7:	89 d0                	mov    %edx,%eax
  803cf9:	e9 44 ff ff ff       	jmp    803c42 <__umoddi3+0x3e>
  803cfe:	66 90                	xchg   %ax,%ax
  803d00:	89 c8                	mov    %ecx,%eax
  803d02:	89 f2                	mov    %esi,%edx
  803d04:	83 c4 1c             	add    $0x1c,%esp
  803d07:	5b                   	pop    %ebx
  803d08:	5e                   	pop    %esi
  803d09:	5f                   	pop    %edi
  803d0a:	5d                   	pop    %ebp
  803d0b:	c3                   	ret    
  803d0c:	3b 04 24             	cmp    (%esp),%eax
  803d0f:	72 06                	jb     803d17 <__umoddi3+0x113>
  803d11:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803d15:	77 0f                	ja     803d26 <__umoddi3+0x122>
  803d17:	89 f2                	mov    %esi,%edx
  803d19:	29 f9                	sub    %edi,%ecx
  803d1b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803d1f:	89 14 24             	mov    %edx,(%esp)
  803d22:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803d26:	8b 44 24 04          	mov    0x4(%esp),%eax
  803d2a:	8b 14 24             	mov    (%esp),%edx
  803d2d:	83 c4 1c             	add    $0x1c,%esp
  803d30:	5b                   	pop    %ebx
  803d31:	5e                   	pop    %esi
  803d32:	5f                   	pop    %edi
  803d33:	5d                   	pop    %ebp
  803d34:	c3                   	ret    
  803d35:	8d 76 00             	lea    0x0(%esi),%esi
  803d38:	2b 04 24             	sub    (%esp),%eax
  803d3b:	19 fa                	sbb    %edi,%edx
  803d3d:	89 d1                	mov    %edx,%ecx
  803d3f:	89 c6                	mov    %eax,%esi
  803d41:	e9 71 ff ff ff       	jmp    803cb7 <__umoddi3+0xb3>
  803d46:	66 90                	xchg   %ax,%ax
  803d48:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803d4c:	72 ea                	jb     803d38 <__umoddi3+0x134>
  803d4e:	89 d9                	mov    %ebx,%ecx
  803d50:	e9 62 ff ff ff       	jmp    803cb7 <__umoddi3+0xb3>
