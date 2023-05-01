
obj/user/tst_best_fit_1:     file format elf32-i386


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
  800031:	e8 d2 0a 00 00       	call   800b08 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* MAKE SURE PAGE_WS_MAX_SIZE = 1000 */
/* *********************************************************** */
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 00 28 00 00       	call   80284a <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 29                	jmp    800083 <_main+0x4b>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 50 80 00       	mov    0x805020,%eax
  80005f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	89 d0                	mov    %edx,%eax
  80006a:	01 c0                	add    %eax,%eax
  80006c:	01 d0                	add    %edx,%eax
  80006e:	c1 e0 03             	shl    $0x3,%eax
  800071:	01 c8                	add    %ecx,%eax
  800073:	8a 40 04             	mov    0x4(%eax),%al
  800076:	84 c0                	test   %al,%al
  800078:	74 06                	je     800080 <_main+0x48>
			{
				fullWS = 0;
  80007a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80007e:	eb 12                	jmp    800092 <_main+0x5a>
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800080:	ff 45 f0             	incl   -0x10(%ebp)
  800083:	a1 20 50 80 00       	mov    0x805020,%eax
  800088:	8b 50 74             	mov    0x74(%eax),%edx
  80008b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80008e:	39 c2                	cmp    %eax,%edx
  800090:	77 c8                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800092:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800096:	74 14                	je     8000ac <_main+0x74>
  800098:	83 ec 04             	sub    $0x4,%esp
  80009b:	68 60 3c 80 00       	push   $0x803c60
  8000a0:	6a 15                	push   $0x15
  8000a2:	68 7c 3c 80 00       	push   $0x803c7c
  8000a7:	e8 98 0b 00 00       	call   800c44 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	6a 00                	push   $0x0
  8000b1:	e8 e1 1d 00 00       	call   801e97 <malloc>
  8000b6:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000b9:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000c0:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000c7:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000ca:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d4:	89 d7                	mov    %edx,%edi
  8000d6:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8000d8:	e8 58 22 00 00       	call   802335 <sys_calculate_free_frames>
  8000dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e0:	e8 f0 22 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(3*Mega-kilo);
  8000e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	01 d2                	add    %edx,%edx
  8000ef:	01 d0                	add    %edx,%eax
  8000f1:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 9a 1d 00 00       	call   801e97 <malloc>
  8000fd:	83 c4 10             	add    $0x10,%esp
  800100:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800103:	8b 45 90             	mov    -0x70(%ebp),%eax
  800106:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80010b:	74 14                	je     800121 <_main+0xe9>
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 94 3c 80 00       	push   $0x803c94
  800115:	6a 26                	push   $0x26
  800117:	68 7c 3c 80 00       	push   $0x803c7c
  80011c:	e8 23 0b 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  800121:	e8 af 22 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800126:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800129:	3d 00 03 00 00       	cmp    $0x300,%eax
  80012e:	74 14                	je     800144 <_main+0x10c>
  800130:	83 ec 04             	sub    $0x4,%esp
  800133:	68 c4 3c 80 00       	push   $0x803cc4
  800138:	6a 28                	push   $0x28
  80013a:	68 7c 3c 80 00       	push   $0x803c7c
  80013f:	e8 00 0b 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800144:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800147:	e8 e9 21 00 00       	call   802335 <sys_calculate_free_frames>
  80014c:	29 c3                	sub    %eax,%ebx
  80014e:	89 d8                	mov    %ebx,%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	74 14                	je     800169 <_main+0x131>
  800155:	83 ec 04             	sub    $0x4,%esp
  800158:	68 e1 3c 80 00       	push   $0x803ce1
  80015d:	6a 29                	push   $0x29
  80015f:	68 7c 3c 80 00       	push   $0x803c7c
  800164:	e8 db 0a 00 00       	call   800c44 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800169:	e8 c7 21 00 00       	call   802335 <sys_calculate_free_frames>
  80016e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800171:	e8 5f 22 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800176:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800179:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80017c:	89 c2                	mov    %eax,%edx
  80017e:	01 d2                	add    %edx,%edx
  800180:	01 d0                	add    %edx,%eax
  800182:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800185:	83 ec 0c             	sub    $0xc,%esp
  800188:	50                   	push   %eax
  800189:	e8 09 1d 00 00       	call   801e97 <malloc>
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  800194:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800197:	89 c1                	mov    %eax,%ecx
  800199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019c:	89 c2                	mov    %eax,%edx
  80019e:	01 d2                	add    %edx,%edx
  8001a0:	01 d0                	add    %edx,%eax
  8001a2:	05 00 00 00 80       	add    $0x80000000,%eax
  8001a7:	39 c1                	cmp    %eax,%ecx
  8001a9:	74 14                	je     8001bf <_main+0x187>
  8001ab:	83 ec 04             	sub    $0x4,%esp
  8001ae:	68 94 3c 80 00       	push   $0x803c94
  8001b3:	6a 2f                	push   $0x2f
  8001b5:	68 7c 3c 80 00       	push   $0x803c7c
  8001ba:	e8 85 0a 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*256) panic("Wrong page file allocation: ");
  8001bf:	e8 11 22 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8001c4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001c7:	3d 00 03 00 00       	cmp    $0x300,%eax
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 c4 3c 80 00       	push   $0x803cc4
  8001d6:	6a 31                	push   $0x31
  8001d8:	68 7c 3c 80 00       	push   $0x803c7c
  8001dd:	e8 62 0a 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  8001e2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8001e5:	e8 4b 21 00 00       	call   802335 <sys_calculate_free_frames>
  8001ea:	29 c3                	sub    %eax,%ebx
  8001ec:	89 d8                	mov    %ebx,%eax
  8001ee:	83 f8 01             	cmp    $0x1,%eax
  8001f1:	74 14                	je     800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 e1 3c 80 00       	push   $0x803ce1
  8001fb:	6a 32                	push   $0x32
  8001fd:	68 7c 3c 80 00       	push   $0x803c7c
  800202:	e8 3d 0a 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800207:	e8 29 21 00 00       	call   802335 <sys_calculate_free_frames>
  80020c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80020f:	e8 c1 21 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800214:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*Mega-kilo);
  800217:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80021a:	01 c0                	add    %eax,%eax
  80021c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80021f:	83 ec 0c             	sub    $0xc,%esp
  800222:	50                   	push   %eax
  800223:	e8 6f 1c 00 00       	call   801e97 <malloc>
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80022e:	8b 45 98             	mov    -0x68(%ebp),%eax
  800231:	89 c1                	mov    %eax,%ecx
  800233:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800236:	89 d0                	mov    %edx,%eax
  800238:	01 c0                	add    %eax,%eax
  80023a:	01 d0                	add    %edx,%eax
  80023c:	01 c0                	add    %eax,%eax
  80023e:	05 00 00 00 80       	add    $0x80000000,%eax
  800243:	39 c1                	cmp    %eax,%ecx
  800245:	74 14                	je     80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 94 3c 80 00       	push   $0x803c94
  80024f:	6a 38                	push   $0x38
  800251:	68 7c 3c 80 00       	push   $0x803c7c
  800256:	e8 e9 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  80025b:	e8 75 21 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800260:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800263:	3d 00 02 00 00       	cmp    $0x200,%eax
  800268:	74 14                	je     80027e <_main+0x246>
  80026a:	83 ec 04             	sub    $0x4,%esp
  80026d:	68 c4 3c 80 00       	push   $0x803cc4
  800272:	6a 3a                	push   $0x3a
  800274:	68 7c 3c 80 00       	push   $0x803c7c
  800279:	e8 c6 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80027e:	e8 b2 20 00 00       	call   802335 <sys_calculate_free_frames>
  800283:	89 c2                	mov    %eax,%edx
  800285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800288:	39 c2                	cmp    %eax,%edx
  80028a:	74 14                	je     8002a0 <_main+0x268>
  80028c:	83 ec 04             	sub    $0x4,%esp
  80028f:	68 e1 3c 80 00       	push   $0x803ce1
  800294:	6a 3b                	push   $0x3b
  800296:	68 7c 3c 80 00       	push   $0x803c7c
  80029b:	e8 a4 09 00 00       	call   800c44 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002a0:	e8 90 20 00 00       	call   802335 <sys_calculate_free_frames>
  8002a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002a8:	e8 28 21 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8002ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*Mega-kilo);
  8002b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002b3:	01 c0                	add    %eax,%eax
  8002b5:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	50                   	push   %eax
  8002bc:	e8 d6 1b 00 00       	call   801e97 <malloc>
  8002c1:	83 c4 10             	add    $0x10,%esp
  8002c4:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8002c7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002ca:	89 c2                	mov    %eax,%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	c1 e0 03             	shl    $0x3,%eax
  8002d2:	05 00 00 00 80       	add    $0x80000000,%eax
  8002d7:	39 c2                	cmp    %eax,%edx
  8002d9:	74 14                	je     8002ef <_main+0x2b7>
  8002db:	83 ec 04             	sub    $0x4,%esp
  8002de:	68 94 3c 80 00       	push   $0x803c94
  8002e3:	6a 41                	push   $0x41
  8002e5:	68 7c 3c 80 00       	push   $0x803c7c
  8002ea:	e8 55 09 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  8002ef:	e8 e1 20 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8002f4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8002f7:	3d 00 02 00 00       	cmp    $0x200,%eax
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 c4 3c 80 00       	push   $0x803cc4
  800306:	6a 43                	push   $0x43
  800308:	68 7c 3c 80 00       	push   $0x803c7c
  80030d:	e8 32 09 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
  800312:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  800315:	e8 1b 20 00 00       	call   802335 <sys_calculate_free_frames>
  80031a:	29 c3                	sub    %eax,%ebx
  80031c:	89 d8                	mov    %ebx,%eax
  80031e:	83 f8 01             	cmp    $0x1,%eax
  800321:	74 14                	je     800337 <_main+0x2ff>
  800323:	83 ec 04             	sub    $0x4,%esp
  800326:	68 e1 3c 80 00       	push   $0x803ce1
  80032b:	6a 44                	push   $0x44
  80032d:	68 7c 3c 80 00       	push   $0x803c7c
  800332:	e8 0d 09 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800337:	e8 f9 1f 00 00       	call   802335 <sys_calculate_free_frames>
  80033c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80033f:	e8 91 20 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800344:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(1*Mega-kilo);
  800347:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80034a:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80034d:	83 ec 0c             	sub    $0xc,%esp
  800350:	50                   	push   %eax
  800351:	e8 41 1b 00 00       	call   801e97 <malloc>
  800356:	83 c4 10             	add    $0x10,%esp
  800359:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 10*Mega) ) panic("Wrong start address for the allocated space... ");
  80035c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80035f:	89 c1                	mov    %eax,%ecx
  800361:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	c1 e0 02             	shl    $0x2,%eax
  800369:	01 d0                	add    %edx,%eax
  80036b:	01 c0                	add    %eax,%eax
  80036d:	05 00 00 00 80       	add    $0x80000000,%eax
  800372:	39 c1                	cmp    %eax,%ecx
  800374:	74 14                	je     80038a <_main+0x352>
  800376:	83 ec 04             	sub    $0x4,%esp
  800379:	68 94 3c 80 00       	push   $0x803c94
  80037e:	6a 4a                	push   $0x4a
  800380:	68 7c 3c 80 00       	push   $0x803c7c
  800385:	e8 ba 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  80038a:	e8 46 20 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  80038f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800392:	3d 00 01 00 00       	cmp    $0x100,%eax
  800397:	74 14                	je     8003ad <_main+0x375>
  800399:	83 ec 04             	sub    $0x4,%esp
  80039c:	68 c4 3c 80 00       	push   $0x803cc4
  8003a1:	6a 4c                	push   $0x4c
  8003a3:	68 7c 3c 80 00       	push   $0x803c7c
  8003a8:	e8 97 08 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8003ad:	e8 83 1f 00 00       	call   802335 <sys_calculate_free_frames>
  8003b2:	89 c2                	mov    %eax,%edx
  8003b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	74 14                	je     8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 e1 3c 80 00       	push   $0x803ce1
  8003c3:	6a 4d                	push   $0x4d
  8003c5:	68 7c 3c 80 00       	push   $0x803c7c
  8003ca:	e8 75 08 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8003cf:	e8 61 1f 00 00       	call   802335 <sys_calculate_free_frames>
  8003d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003d7:	e8 f9 1f 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8003dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(1*Mega-kilo);
  8003df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003e2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003e5:	83 ec 0c             	sub    $0xc,%esp
  8003e8:	50                   	push   %eax
  8003e9:	e8 a9 1a 00 00       	call   801e97 <malloc>
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 11*Mega) ) panic("Wrong start address for the allocated space... ");
  8003f4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003fc:	89 d0                	mov    %edx,%eax
  8003fe:	c1 e0 02             	shl    $0x2,%eax
  800401:	01 d0                	add    %edx,%eax
  800403:	01 c0                	add    %eax,%eax
  800405:	01 d0                	add    %edx,%eax
  800407:	05 00 00 00 80       	add    $0x80000000,%eax
  80040c:	39 c1                	cmp    %eax,%ecx
  80040e:	74 14                	je     800424 <_main+0x3ec>
  800410:	83 ec 04             	sub    $0x4,%esp
  800413:	68 94 3c 80 00       	push   $0x803c94
  800418:	6a 53                	push   $0x53
  80041a:	68 7c 3c 80 00       	push   $0x803c7c
  80041f:	e8 20 08 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800424:	e8 ac 1f 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800429:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80042c:	3d 00 01 00 00       	cmp    $0x100,%eax
  800431:	74 14                	je     800447 <_main+0x40f>
  800433:	83 ec 04             	sub    $0x4,%esp
  800436:	68 c4 3c 80 00       	push   $0x803cc4
  80043b:	6a 55                	push   $0x55
  80043d:	68 7c 3c 80 00       	push   $0x803c7c
  800442:	e8 fd 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800447:	e8 e9 1e 00 00       	call   802335 <sys_calculate_free_frames>
  80044c:	89 c2                	mov    %eax,%edx
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	39 c2                	cmp    %eax,%edx
  800453:	74 14                	je     800469 <_main+0x431>
  800455:	83 ec 04             	sub    $0x4,%esp
  800458:	68 e1 3c 80 00       	push   $0x803ce1
  80045d:	6a 56                	push   $0x56
  80045f:	68 7c 3c 80 00       	push   $0x803c7c
  800464:	e8 db 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800469:	e8 c7 1e 00 00       	call   802335 <sys_calculate_free_frames>
  80046e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800471:	e8 5f 1f 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(1*Mega-kilo);
  800479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80047c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80047f:	83 ec 0c             	sub    $0xc,%esp
  800482:	50                   	push   %eax
  800483:	e8 0f 1a 00 00       	call   801e97 <malloc>
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 12*Mega) ) panic("Wrong start address for the allocated space... ");
  80048e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800491:	89 c1                	mov    %eax,%ecx
  800493:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800496:	89 d0                	mov    %edx,%eax
  800498:	01 c0                	add    %eax,%eax
  80049a:	01 d0                	add    %edx,%eax
  80049c:	c1 e0 02             	shl    $0x2,%eax
  80049f:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a4:	39 c1                	cmp    %eax,%ecx
  8004a6:	74 14                	je     8004bc <_main+0x484>
  8004a8:	83 ec 04             	sub    $0x4,%esp
  8004ab:	68 94 3c 80 00       	push   $0x803c94
  8004b0:	6a 5c                	push   $0x5c
  8004b2:	68 7c 3c 80 00       	push   $0x803c7c
  8004b7:	e8 88 07 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8004bc:	e8 14 1f 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8004c1:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8004c9:	74 14                	je     8004df <_main+0x4a7>
  8004cb:	83 ec 04             	sub    $0x4,%esp
  8004ce:	68 c4 3c 80 00       	push   $0x803cc4
  8004d3:	6a 5e                	push   $0x5e
  8004d5:	68 7c 3c 80 00       	push   $0x803c7c
  8004da:	e8 65 07 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  8004df:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8004e2:	e8 4e 1e 00 00       	call   802335 <sys_calculate_free_frames>
  8004e7:	29 c3                	sub    %eax,%ebx
  8004e9:	89 d8                	mov    %ebx,%eax
  8004eb:	83 f8 01             	cmp    $0x1,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 e1 3c 80 00       	push   $0x803ce1
  8004f8:	6a 5f                	push   $0x5f
  8004fa:	68 7c 3c 80 00       	push   $0x803c7c
  8004ff:	e8 40 07 00 00       	call   800c44 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800504:	e8 2c 1e 00 00       	call   802335 <sys_calculate_free_frames>
  800509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80050c:	e8 c4 1e 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800511:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(1*Mega-kilo);
  800514:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800517:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80051a:	83 ec 0c             	sub    $0xc,%esp
  80051d:	50                   	push   %eax
  80051e:	e8 74 19 00 00       	call   801e97 <malloc>
  800523:	83 c4 10             	add    $0x10,%esp
  800526:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 13*Mega)) panic("Wrong start address for the allocated space... ");
  800529:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80052c:	89 c1                	mov    %eax,%ecx
  80052e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800531:	89 d0                	mov    %edx,%eax
  800533:	01 c0                	add    %eax,%eax
  800535:	01 d0                	add    %edx,%eax
  800537:	c1 e0 02             	shl    $0x2,%eax
  80053a:	01 d0                	add    %edx,%eax
  80053c:	05 00 00 00 80       	add    $0x80000000,%eax
  800541:	39 c1                	cmp    %eax,%ecx
  800543:	74 14                	je     800559 <_main+0x521>
  800545:	83 ec 04             	sub    $0x4,%esp
  800548:	68 94 3c 80 00       	push   $0x803c94
  80054d:	6a 65                	push   $0x65
  80054f:	68 7c 3c 80 00       	push   $0x803c7c
  800554:	e8 eb 06 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  800559:	e8 77 1e 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  80055e:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800561:	3d 00 01 00 00       	cmp    $0x100,%eax
  800566:	74 14                	je     80057c <_main+0x544>
  800568:	83 ec 04             	sub    $0x4,%esp
  80056b:	68 c4 3c 80 00       	push   $0x803cc4
  800570:	6a 67                	push   $0x67
  800572:	68 7c 3c 80 00       	push   $0x803c7c
  800577:	e8 c8 06 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80057c:	e8 b4 1d 00 00       	call   802335 <sys_calculate_free_frames>
  800581:	89 c2                	mov    %eax,%edx
  800583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800586:	39 c2                	cmp    %eax,%edx
  800588:	74 14                	je     80059e <_main+0x566>
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	68 e1 3c 80 00       	push   $0x803ce1
  800592:	6a 68                	push   $0x68
  800594:	68 7c 3c 80 00       	push   $0x803c7c
  800599:	e8 a6 06 00 00       	call   800c44 <_panic>
	}

	//[2] Free some to create holes
	{
		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80059e:	e8 92 1d 00 00       	call   802335 <sys_calculate_free_frames>
  8005a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005a6:	e8 2a 1e 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8005ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ae:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005b1:	83 ec 0c             	sub    $0xc,%esp
  8005b4:	50                   	push   %eax
  8005b5:	e8 76 19 00 00       	call   801f30 <free>
  8005ba:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  3*256) panic("Wrong page file free: ");
  8005bd:	e8 13 1e 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8005c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005c5:	29 c2                	sub    %eax,%edx
  8005c7:	89 d0                	mov    %edx,%eax
  8005c9:	3d 00 03 00 00       	cmp    $0x300,%eax
  8005ce:	74 14                	je     8005e4 <_main+0x5ac>
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	68 f4 3c 80 00       	push   $0x803cf4
  8005d8:	6a 72                	push   $0x72
  8005da:	68 7c 3c 80 00       	push   $0x803c7c
  8005df:	e8 60 06 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005e4:	e8 4c 1d 00 00       	call   802335 <sys_calculate_free_frames>
  8005e9:	89 c2                	mov    %eax,%edx
  8005eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005ee:	39 c2                	cmp    %eax,%edx
  8005f0:	74 14                	je     800606 <_main+0x5ce>
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 0b 3d 80 00       	push   $0x803d0b
  8005fa:	6a 73                	push   $0x73
  8005fc:	68 7c 3c 80 00       	push   $0x803c7c
  800601:	e8 3e 06 00 00       	call   800c44 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800606:	e8 2a 1d 00 00       	call   802335 <sys_calculate_free_frames>
  80060b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060e:	e8 c2 1d 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800613:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[3]);
  800616:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800619:	83 ec 0c             	sub    $0xc,%esp
  80061c:	50                   	push   %eax
  80061d:	e8 0e 19 00 00       	call   801f30 <free>
  800622:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  2*256) panic("Wrong page file free: ");
  800625:	e8 ab 1d 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  80062a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80062d:	29 c2                	sub    %eax,%edx
  80062f:	89 d0                	mov    %edx,%eax
  800631:	3d 00 02 00 00       	cmp    $0x200,%eax
  800636:	74 14                	je     80064c <_main+0x614>
  800638:	83 ec 04             	sub    $0x4,%esp
  80063b:	68 f4 3c 80 00       	push   $0x803cf4
  800640:	6a 7a                	push   $0x7a
  800642:	68 7c 3c 80 00       	push   $0x803c7c
  800647:	e8 f8 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80064c:	e8 e4 1c 00 00       	call   802335 <sys_calculate_free_frames>
  800651:	89 c2                	mov    %eax,%edx
  800653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	74 14                	je     80066e <_main+0x636>
  80065a:	83 ec 04             	sub    $0x4,%esp
  80065d:	68 0b 3d 80 00       	push   $0x803d0b
  800662:	6a 7b                	push   $0x7b
  800664:	68 7c 3c 80 00       	push   $0x803c7c
  800669:	e8 d6 05 00 00       	call   800c44 <_panic>

		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80066e:	e8 c2 1c 00 00       	call   802335 <sys_calculate_free_frames>
  800673:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800676:	e8 5a 1d 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  80067b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  80067e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800681:	83 ec 0c             	sub    $0xc,%esp
  800684:	50                   	push   %eax
  800685:	e8 a6 18 00 00       	call   801f30 <free>
  80068a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  80068d:	e8 43 1d 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800695:	29 c2                	sub    %eax,%edx
  800697:	89 d0                	mov    %edx,%eax
  800699:	3d 00 01 00 00       	cmp    $0x100,%eax
  80069e:	74 17                	je     8006b7 <_main+0x67f>
  8006a0:	83 ec 04             	sub    $0x4,%esp
  8006a3:	68 f4 3c 80 00       	push   $0x803cf4
  8006a8:	68 82 00 00 00       	push   $0x82
  8006ad:	68 7c 3c 80 00       	push   $0x803c7c
  8006b2:	e8 8d 05 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8006b7:	e8 79 1c 00 00       	call   802335 <sys_calculate_free_frames>
  8006bc:	89 c2                	mov    %eax,%edx
  8006be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c1:	39 c2                	cmp    %eax,%edx
  8006c3:	74 17                	je     8006dc <_main+0x6a4>
  8006c5:	83 ec 04             	sub    $0x4,%esp
  8006c8:	68 0b 3d 80 00       	push   $0x803d0b
  8006cd:	68 83 00 00 00       	push   $0x83
  8006d2:	68 7c 3c 80 00       	push   $0x803c7c
  8006d7:	e8 68 05 00 00       	call   800c44 <_panic>
	}

	//[3] Allocate again [test best fit]
	{
		//Allocate 512 KB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  8006dc:	e8 54 1c 00 00       	call   802335 <sys_calculate_free_frames>
  8006e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8006e4:	e8 ec 1c 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8006e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(512*kilo);
  8006ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ef:	c1 e0 09             	shl    $0x9,%eax
  8006f2:	83 ec 0c             	sub    $0xc,%esp
  8006f5:	50                   	push   %eax
  8006f6:	e8 9c 17 00 00       	call   801e97 <malloc>
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  800701:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800704:	89 c1                	mov    %eax,%ecx
  800706:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800709:	89 d0                	mov    %edx,%eax
  80070b:	c1 e0 02             	shl    $0x2,%eax
  80070e:	01 d0                	add    %edx,%eax
  800710:	01 c0                	add    %eax,%eax
  800712:	01 d0                	add    %edx,%eax
  800714:	05 00 00 00 80       	add    $0x80000000,%eax
  800719:	39 c1                	cmp    %eax,%ecx
  80071b:	74 17                	je     800734 <_main+0x6fc>
  80071d:	83 ec 04             	sub    $0x4,%esp
  800720:	68 94 3c 80 00       	push   $0x803c94
  800725:	68 8c 00 00 00       	push   $0x8c
  80072a:	68 7c 3c 80 00       	push   $0x803c7c
  80072f:	e8 10 05 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  128) panic("Wrong page file allocation: ");
  800734:	e8 9c 1c 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800739:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80073c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800741:	74 17                	je     80075a <_main+0x722>
  800743:	83 ec 04             	sub    $0x4,%esp
  800746:	68 c4 3c 80 00       	push   $0x803cc4
  80074b:	68 8e 00 00 00       	push   $0x8e
  800750:	68 7c 3c 80 00       	push   $0x803c7c
  800755:	e8 ea 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80075a:	e8 d6 1b 00 00       	call   802335 <sys_calculate_free_frames>
  80075f:	89 c2                	mov    %eax,%edx
  800761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 17                	je     80077f <_main+0x747>
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 e1 3c 80 00       	push   $0x803ce1
  800770:	68 8f 00 00 00       	push   $0x8f
  800775:	68 7c 3c 80 00       	push   $0x803c7c
  80077a:	e8 c5 04 00 00       	call   800c44 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80077f:	e8 b1 1b 00 00       	call   802335 <sys_calculate_free_frames>
  800784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800787:	e8 49 1c 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  80078c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80078f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800792:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800795:	83 ec 0c             	sub    $0xc,%esp
  800798:	50                   	push   %eax
  800799:	e8 f9 16 00 00       	call   801e97 <malloc>
  80079e:	83 c4 10             	add    $0x10,%esp
  8007a1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  8007a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007a7:	89 c2                	mov    %eax,%edx
  8007a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007ac:	c1 e0 03             	shl    $0x3,%eax
  8007af:	05 00 00 00 80       	add    $0x80000000,%eax
  8007b4:	39 c2                	cmp    %eax,%edx
  8007b6:	74 17                	je     8007cf <_main+0x797>
  8007b8:	83 ec 04             	sub    $0x4,%esp
  8007bb:	68 94 3c 80 00       	push   $0x803c94
  8007c0:	68 95 00 00 00       	push   $0x95
  8007c5:	68 7c 3c 80 00       	push   $0x803c7c
  8007ca:	e8 75 04 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  256) panic("Wrong page file allocation: ");
  8007cf:	e8 01 1c 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8007d4:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007d7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007dc:	74 17                	je     8007f5 <_main+0x7bd>
  8007de:	83 ec 04             	sub    $0x4,%esp
  8007e1:	68 c4 3c 80 00       	push   $0x803cc4
  8007e6:	68 97 00 00 00       	push   $0x97
  8007eb:	68 7c 3c 80 00       	push   $0x803c7c
  8007f0:	e8 4f 04 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8007f5:	e8 3b 1b 00 00       	call   802335 <sys_calculate_free_frames>
  8007fa:	89 c2                	mov    %eax,%edx
  8007fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ff:	39 c2                	cmp    %eax,%edx
  800801:	74 17                	je     80081a <_main+0x7e2>
  800803:	83 ec 04             	sub    $0x4,%esp
  800806:	68 e1 3c 80 00       	push   $0x803ce1
  80080b:	68 98 00 00 00       	push   $0x98
  800810:	68 7c 3c 80 00       	push   $0x803c7c
  800815:	e8 2a 04 00 00       	call   800c44 <_panic>

		//Allocate 256 KB - should be placed in remaining of 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  80081a:	e8 16 1b 00 00       	call   802335 <sys_calculate_free_frames>
  80081f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800822:	e8 ae 1b 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800827:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(256*kilo - kilo);
  80082a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082d:	89 d0                	mov    %edx,%eax
  80082f:	c1 e0 08             	shl    $0x8,%eax
  800832:	29 d0                	sub    %edx,%eax
  800834:	83 ec 0c             	sub    $0xc,%esp
  800837:	50                   	push   %eax
  800838:	e8 5a 16 00 00       	call   801e97 <malloc>
  80083d:	83 c4 10             	add    $0x10,%esp
  800840:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 11*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  800843:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800846:	89 c1                	mov    %eax,%ecx
  800848:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80084b:	89 d0                	mov    %edx,%eax
  80084d:	c1 e0 02             	shl    $0x2,%eax
  800850:	01 d0                	add    %edx,%eax
  800852:	01 c0                	add    %eax,%eax
  800854:	01 d0                	add    %edx,%eax
  800856:	89 c2                	mov    %eax,%edx
  800858:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80085b:	c1 e0 09             	shl    $0x9,%eax
  80085e:	01 d0                	add    %edx,%eax
  800860:	05 00 00 00 80       	add    $0x80000000,%eax
  800865:	39 c1                	cmp    %eax,%ecx
  800867:	74 17                	je     800880 <_main+0x848>
  800869:	83 ec 04             	sub    $0x4,%esp
  80086c:	68 94 3c 80 00       	push   $0x803c94
  800871:	68 9e 00 00 00       	push   $0x9e
  800876:	68 7c 3c 80 00       	push   $0x803c7c
  80087b:	e8 c4 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  64) panic("Wrong page file allocation: ");
  800880:	e8 50 1b 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800885:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800888:	83 f8 40             	cmp    $0x40,%eax
  80088b:	74 17                	je     8008a4 <_main+0x86c>
  80088d:	83 ec 04             	sub    $0x4,%esp
  800890:	68 c4 3c 80 00       	push   $0x803cc4
  800895:	68 a0 00 00 00       	push   $0xa0
  80089a:	68 7c 3c 80 00       	push   $0x803c7c
  80089f:	e8 a0 03 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008a4:	e8 8c 1a 00 00       	call   802335 <sys_calculate_free_frames>
  8008a9:	89 c2                	mov    %eax,%edx
  8008ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8008ae:	39 c2                	cmp    %eax,%edx
  8008b0:	74 17                	je     8008c9 <_main+0x891>
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 e1 3c 80 00       	push   $0x803ce1
  8008ba:	68 a1 00 00 00       	push   $0xa1
  8008bf:	68 7c 3c 80 00       	push   $0x803c7c
  8008c4:	e8 7b 03 00 00       	call   800c44 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  8008c9:	e8 67 1a 00 00       	call   802335 <sys_calculate_free_frames>
  8008ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8008d1:	e8 ff 1a 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8008d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega - kilo);
  8008d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008dc:	c1 e0 02             	shl    $0x2,%eax
  8008df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8008e2:	83 ec 0c             	sub    $0xc,%esp
  8008e5:	50                   	push   %eax
  8008e6:	e8 ac 15 00 00       	call   801e97 <malloc>
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  8008f1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8008f4:	89 c1                	mov    %eax,%ecx
  8008f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8008f9:	89 d0                	mov    %edx,%eax
  8008fb:	01 c0                	add    %eax,%eax
  8008fd:	01 d0                	add    %edx,%eax
  8008ff:	01 c0                	add    %eax,%eax
  800901:	01 d0                	add    %edx,%eax
  800903:	01 c0                	add    %eax,%eax
  800905:	05 00 00 00 80       	add    $0x80000000,%eax
  80090a:	39 c1                	cmp    %eax,%ecx
  80090c:	74 17                	je     800925 <_main+0x8ed>
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 94 3c 80 00       	push   $0x803c94
  800916:	68 a7 00 00 00       	push   $0xa7
  80091b:	68 7c 3c 80 00       	push   $0x803c7c
  800920:	e8 1f 03 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1024 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1024) panic("Wrong page file allocation: ");
  800925:	e8 ab 1a 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  80092a:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80092d:	3d 00 04 00 00       	cmp    $0x400,%eax
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 c4 3c 80 00       	push   $0x803cc4
  80093c:	68 a9 00 00 00       	push   $0xa9
  800941:	68 7c 3c 80 00       	push   $0x803c7c
  800946:	e8 f9 02 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: ");
  80094b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80094e:	e8 e2 19 00 00       	call   802335 <sys_calculate_free_frames>
  800953:	29 c3                	sub    %eax,%ebx
  800955:	89 d8                	mov    %ebx,%eax
  800957:	83 f8 01             	cmp    $0x1,%eax
  80095a:	74 17                	je     800973 <_main+0x93b>
  80095c:	83 ec 04             	sub    $0x4,%esp
  80095f:	68 e1 3c 80 00       	push   $0x803ce1
  800964:	68 aa 00 00 00       	push   $0xaa
  800969:	68 7c 3c 80 00       	push   $0x803c7c
  80096e:	e8 d1 02 00 00       	call   800c44 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1M Hole appended to already existing 1M hole in the middle
		freeFrames = sys_calculate_free_frames() ;
  800973:	e8 bd 19 00 00       	call   802335 <sys_calculate_free_frames>
  800978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80097b:	e8 55 1a 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[4]);
  800983:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800986:	83 ec 0c             	sub    $0xc,%esp
  800989:	50                   	push   %eax
  80098a:	e8 a1 15 00 00       	call   801f30 <free>
  80098f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  256) panic("Wrong page file free: ");
  800992:	e8 3e 1a 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800997:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80099a:	29 c2                	sub    %eax,%edx
  80099c:	89 d0                	mov    %edx,%eax
  80099e:	3d 00 01 00 00       	cmp    $0x100,%eax
  8009a3:	74 17                	je     8009bc <_main+0x984>
  8009a5:	83 ec 04             	sub    $0x4,%esp
  8009a8:	68 f4 3c 80 00       	push   $0x803cf4
  8009ad:	68 b4 00 00 00       	push   $0xb4
  8009b2:	68 7c 3c 80 00       	push   $0x803c7c
  8009b7:	e8 88 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009bc:	e8 74 19 00 00       	call   802335 <sys_calculate_free_frames>
  8009c1:	89 c2                	mov    %eax,%edx
  8009c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 17                	je     8009e1 <_main+0x9a9>
  8009ca:	83 ec 04             	sub    $0x4,%esp
  8009cd:	68 0b 3d 80 00       	push   $0x803d0b
  8009d2:	68 b5 00 00 00       	push   $0xb5
  8009d7:	68 7c 3c 80 00       	push   $0x803c7c
  8009dc:	e8 63 02 00 00       	call   800c44 <_panic>

		//another 512 KB Hole appended to the hole
		freeFrames = sys_calculate_free_frames() ;
  8009e1:	e8 4f 19 00 00       	call   802335 <sys_calculate_free_frames>
  8009e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009e9:	e8 e7 19 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  8009ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[8]);
  8009f1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8009f4:	83 ec 0c             	sub    $0xc,%esp
  8009f7:	50                   	push   %eax
  8009f8:	e8 33 15 00 00       	call   801f30 <free>
  8009fd:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  128) panic("Wrong page file free: ");
  800a00:	e8 d0 19 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800a05:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a08:	29 c2                	sub    %eax,%edx
  800a0a:	89 d0                	mov    %edx,%eax
  800a0c:	3d 80 00 00 00       	cmp    $0x80,%eax
  800a11:	74 17                	je     800a2a <_main+0x9f2>
  800a13:	83 ec 04             	sub    $0x4,%esp
  800a16:	68 f4 3c 80 00       	push   $0x803cf4
  800a1b:	68 bc 00 00 00       	push   $0xbc
  800a20:	68 7c 3c 80 00       	push   $0x803c7c
  800a25:	e8 1a 02 00 00       	call   800c44 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a2a:	e8 06 19 00 00       	call   802335 <sys_calculate_free_frames>
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a34:	39 c2                	cmp    %eax,%edx
  800a36:	74 17                	je     800a4f <_main+0xa17>
  800a38:	83 ec 04             	sub    $0x4,%esp
  800a3b:	68 0b 3d 80 00       	push   $0x803d0b
  800a40:	68 bd 00 00 00       	push   $0xbd
  800a45:	68 7c 3c 80 00       	push   $0x803c7c
  800a4a:	e8 f5 01 00 00       	call   800c44 <_panic>
	}

	//[5] Allocate again [test best fit]
	{
		//Allocate 2 MB - should be placed in the contiguous hole (2 MB + 512 KB)
		freeFrames = sys_calculate_free_frames();
  800a4f:	e8 e1 18 00 00       	call   802335 <sys_calculate_free_frames>
  800a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a57:	e8 79 19 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800a5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[12] = malloc(2*Mega - kilo);
  800a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a62:	01 c0                	add    %eax,%eax
  800a64:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800a67:	83 ec 0c             	sub    $0xc,%esp
  800a6a:	50                   	push   %eax
  800a6b:	e8 27 14 00 00       	call   801e97 <malloc>
  800a70:	83 c4 10             	add    $0x10,%esp
  800a73:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 9*Mega)) panic("Wrong start address for the allocated space... ");
  800a76:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800a79:	89 c1                	mov    %eax,%ecx
  800a7b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 03             	shl    $0x3,%eax
  800a83:	01 d0                	add    %edx,%eax
  800a85:	05 00 00 00 80       	add    $0x80000000,%eax
  800a8a:	39 c1                	cmp    %eax,%ecx
  800a8c:	74 17                	je     800aa5 <_main+0xa6d>
  800a8e:	83 ec 04             	sub    $0x4,%esp
  800a91:	68 94 3c 80 00       	push   $0x803c94
  800a96:	68 c6 00 00 00       	push   $0xc6
  800a9b:	68 7c 3c 80 00       	push   $0x803c7c
  800aa0:	e8 9f 01 00 00       	call   800c44 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2*256) panic("Wrong page file allocation: ");
  800aa5:	e8 2b 19 00 00       	call   8023d5 <sys_pf_calculate_allocated_pages>
  800aaa:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800aad:	3d 00 02 00 00       	cmp    $0x200,%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 c4 3c 80 00       	push   $0x803cc4
  800abc:	68 c8 00 00 00       	push   $0xc8
  800ac1:	68 7c 3c 80 00       	push   $0x803c7c
  800ac6:	e8 79 01 00 00       	call   800c44 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800acb:	e8 65 18 00 00       	call   802335 <sys_calculate_free_frames>
  800ad0:	89 c2                	mov    %eax,%edx
  800ad2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ad5:	39 c2                	cmp    %eax,%edx
  800ad7:	74 17                	je     800af0 <_main+0xab8>
  800ad9:	83 ec 04             	sub    $0x4,%esp
  800adc:	68 e1 3c 80 00       	push   $0x803ce1
  800ae1:	68 c9 00 00 00       	push   $0xc9
  800ae6:	68 7c 3c 80 00       	push   $0x803c7c
  800aeb:	e8 54 01 00 00       	call   800c44 <_panic>
	}
	cprintf("Congratulations!! test BEST FIT allocation (1) completed successfully.\n");
  800af0:	83 ec 0c             	sub    $0xc,%esp
  800af3:	68 18 3d 80 00       	push   $0x803d18
  800af8:	e8 fb 03 00 00       	call   800ef8 <cprintf>
  800afd:	83 c4 10             	add    $0x10,%esp

	return;
  800b00:	90                   	nop
}
  800b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b04:	5b                   	pop    %ebx
  800b05:	5f                   	pop    %edi
  800b06:	5d                   	pop    %ebp
  800b07:	c3                   	ret    

00800b08 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800b0e:	e8 02 1b 00 00       	call   802615 <sys_getenvindex>
  800b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b19:	89 d0                	mov    %edx,%eax
  800b1b:	c1 e0 03             	shl    $0x3,%eax
  800b1e:	01 d0                	add    %edx,%eax
  800b20:	01 c0                	add    %eax,%eax
  800b22:	01 d0                	add    %edx,%eax
  800b24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b2b:	01 d0                	add    %edx,%eax
  800b2d:	c1 e0 04             	shl    $0x4,%eax
  800b30:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800b35:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800b3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800b3f:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800b45:	84 c0                	test   %al,%al
  800b47:	74 0f                	je     800b58 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800b49:	a1 20 50 80 00       	mov    0x805020,%eax
  800b4e:	05 5c 05 00 00       	add    $0x55c,%eax
  800b53:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800b58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5c:	7e 0a                	jle    800b68 <libmain+0x60>
		binaryname = argv[0];
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	ff 75 0c             	pushl  0xc(%ebp)
  800b6e:	ff 75 08             	pushl  0x8(%ebp)
  800b71:	e8 c2 f4 ff ff       	call   800038 <_main>
  800b76:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800b79:	e8 a4 18 00 00       	call   802422 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800b7e:	83 ec 0c             	sub    $0xc,%esp
  800b81:	68 78 3d 80 00       	push   $0x803d78
  800b86:	e8 6d 03 00 00       	call   800ef8 <cprintf>
  800b8b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800b8e:	a1 20 50 80 00       	mov    0x805020,%eax
  800b93:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800b99:	a1 20 50 80 00       	mov    0x805020,%eax
  800b9e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800ba4:	83 ec 04             	sub    $0x4,%esp
  800ba7:	52                   	push   %edx
  800ba8:	50                   	push   %eax
  800ba9:	68 a0 3d 80 00       	push   $0x803da0
  800bae:	e8 45 03 00 00       	call   800ef8 <cprintf>
  800bb3:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800bb6:	a1 20 50 80 00       	mov    0x805020,%eax
  800bbb:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800bc1:	a1 20 50 80 00       	mov    0x805020,%eax
  800bc6:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800bcc:	a1 20 50 80 00       	mov    0x805020,%eax
  800bd1:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800bd7:	51                   	push   %ecx
  800bd8:	52                   	push   %edx
  800bd9:	50                   	push   %eax
  800bda:	68 c8 3d 80 00       	push   $0x803dc8
  800bdf:	e8 14 03 00 00       	call   800ef8 <cprintf>
  800be4:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800be7:	a1 20 50 80 00       	mov    0x805020,%eax
  800bec:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	68 20 3e 80 00       	push   $0x803e20
  800bfb:	e8 f8 02 00 00       	call   800ef8 <cprintf>
  800c00:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800c03:	83 ec 0c             	sub    $0xc,%esp
  800c06:	68 78 3d 80 00       	push   $0x803d78
  800c0b:	e8 e8 02 00 00       	call   800ef8 <cprintf>
  800c10:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800c13:	e8 24 18 00 00       	call   80243c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800c18:	e8 19 00 00 00       	call   800c36 <exit>
}
  800c1d:	90                   	nop
  800c1e:	c9                   	leave  
  800c1f:	c3                   	ret    

00800c20 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	6a 00                	push   $0x0
  800c2b:	e8 b1 19 00 00       	call   8025e1 <sys_destroy_env>
  800c30:	83 c4 10             	add    $0x10,%esp
}
  800c33:	90                   	nop
  800c34:	c9                   	leave  
  800c35:	c3                   	ret    

00800c36 <exit>:

void
exit(void)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800c3c:	e8 06 1a 00 00       	call   802647 <sys_exit_env>
}
  800c41:	90                   	nop
  800c42:	c9                   	leave  
  800c43:	c3                   	ret    

00800c44 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800c4a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c4d:	83 c0 04             	add    $0x4,%eax
  800c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800c53:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c58:	85 c0                	test   %eax,%eax
  800c5a:	74 16                	je     800c72 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800c5c:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	50                   	push   %eax
  800c65:	68 34 3e 80 00       	push   $0x803e34
  800c6a:	e8 89 02 00 00       	call   800ef8 <cprintf>
  800c6f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800c72:	a1 00 50 80 00       	mov    0x805000,%eax
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	ff 75 08             	pushl  0x8(%ebp)
  800c7d:	50                   	push   %eax
  800c7e:	68 39 3e 80 00       	push   $0x803e39
  800c83:	e8 70 02 00 00       	call   800ef8 <cprintf>
  800c88:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800c8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 f4             	pushl  -0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	e8 f3 01 00 00       	call   800e8d <vcprintf>
  800c9a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800c9d:	83 ec 08             	sub    $0x8,%esp
  800ca0:	6a 00                	push   $0x0
  800ca2:	68 55 3e 80 00       	push   $0x803e55
  800ca7:	e8 e1 01 00 00       	call   800e8d <vcprintf>
  800cac:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800caf:	e8 82 ff ff ff       	call   800c36 <exit>

	// should not return here
	while (1) ;
  800cb4:	eb fe                	jmp    800cb4 <_panic+0x70>

00800cb6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800cb6:	55                   	push   %ebp
  800cb7:	89 e5                	mov    %esp,%ebp
  800cb9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800cbc:	a1 20 50 80 00       	mov    0x805020,%eax
  800cc1:	8b 50 74             	mov    0x74(%eax),%edx
  800cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc7:	39 c2                	cmp    %eax,%edx
  800cc9:	74 14                	je     800cdf <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800ccb:	83 ec 04             	sub    $0x4,%esp
  800cce:	68 58 3e 80 00       	push   $0x803e58
  800cd3:	6a 26                	push   $0x26
  800cd5:	68 a4 3e 80 00       	push   $0x803ea4
  800cda:	e8 65 ff ff ff       	call   800c44 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800cdf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800ce6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ced:	e9 c2 00 00 00       	jmp    800db4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cf5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	01 d0                	add    %edx,%eax
  800d01:	8b 00                	mov    (%eax),%eax
  800d03:	85 c0                	test   %eax,%eax
  800d05:	75 08                	jne    800d0f <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800d07:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800d0a:	e9 a2 00 00 00       	jmp    800db1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800d0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d16:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800d1d:	eb 69                	jmp    800d88 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800d1f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d24:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d2a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d2d:	89 d0                	mov    %edx,%eax
  800d2f:	01 c0                	add    %eax,%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	c1 e0 03             	shl    $0x3,%eax
  800d36:	01 c8                	add    %ecx,%eax
  800d38:	8a 40 04             	mov    0x4(%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	75 46                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800d44:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800d4a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d4d:	89 d0                	mov    %edx,%eax
  800d4f:	01 c0                	add    %eax,%eax
  800d51:	01 d0                	add    %edx,%eax
  800d53:	c1 e0 03             	shl    $0x3,%eax
  800d56:	01 c8                	add    %ecx,%eax
  800d58:	8b 00                	mov    (%eax),%eax
  800d5a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800d5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800d60:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d65:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800d67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d6a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d71:	8b 45 08             	mov    0x8(%ebp),%eax
  800d74:	01 c8                	add    %ecx,%eax
  800d76:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800d78:	39 c2                	cmp    %eax,%edx
  800d7a:	75 09                	jne    800d85 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800d7c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800d83:	eb 12                	jmp    800d97 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800d85:	ff 45 e8             	incl   -0x18(%ebp)
  800d88:	a1 20 50 80 00       	mov    0x805020,%eax
  800d8d:	8b 50 74             	mov    0x74(%eax),%edx
  800d90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800d93:	39 c2                	cmp    %eax,%edx
  800d95:	77 88                	ja     800d1f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800d97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800d9b:	75 14                	jne    800db1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800d9d:	83 ec 04             	sub    $0x4,%esp
  800da0:	68 b0 3e 80 00       	push   $0x803eb0
  800da5:	6a 3a                	push   $0x3a
  800da7:	68 a4 3e 80 00       	push   $0x803ea4
  800dac:	e8 93 fe ff ff       	call   800c44 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800db1:	ff 45 f0             	incl   -0x10(%ebp)
  800db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800dba:	0f 8c 32 ff ff ff    	jl     800cf2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800dc0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800dc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800dce:	eb 26                	jmp    800df6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800dd0:	a1 20 50 80 00       	mov    0x805020,%eax
  800dd5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ddb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800dde:	89 d0                	mov    %edx,%eax
  800de0:	01 c0                	add    %eax,%eax
  800de2:	01 d0                	add    %edx,%eax
  800de4:	c1 e0 03             	shl    $0x3,%eax
  800de7:	01 c8                	add    %ecx,%eax
  800de9:	8a 40 04             	mov    0x4(%eax),%al
  800dec:	3c 01                	cmp    $0x1,%al
  800dee:	75 03                	jne    800df3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800df0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800df3:	ff 45 e0             	incl   -0x20(%ebp)
  800df6:	a1 20 50 80 00       	mov    0x805020,%eax
  800dfb:	8b 50 74             	mov    0x74(%eax),%edx
  800dfe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e01:	39 c2                	cmp    %eax,%edx
  800e03:	77 cb                	ja     800dd0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e08:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800e0b:	74 14                	je     800e21 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800e0d:	83 ec 04             	sub    $0x4,%esp
  800e10:	68 04 3f 80 00       	push   $0x803f04
  800e15:	6a 44                	push   $0x44
  800e17:	68 a4 3e 80 00       	push   $0x803ea4
  800e1c:	e8 23 fe ff ff       	call   800c44 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800e21:	90                   	nop
  800e22:	c9                   	leave  
  800e23:	c3                   	ret    

00800e24 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800e24:	55                   	push   %ebp
  800e25:	89 e5                	mov    %esp,%ebp
  800e27:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2d:	8b 00                	mov    (%eax),%eax
  800e2f:	8d 48 01             	lea    0x1(%eax),%ecx
  800e32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e35:	89 0a                	mov    %ecx,(%edx)
  800e37:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3a:	88 d1                	mov    %dl,%cl
  800e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e3f:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	8b 00                	mov    (%eax),%eax
  800e48:	3d ff 00 00 00       	cmp    $0xff,%eax
  800e4d:	75 2c                	jne    800e7b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800e4f:	a0 24 50 80 00       	mov    0x805024,%al
  800e54:	0f b6 c0             	movzbl %al,%eax
  800e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5a:	8b 12                	mov    (%edx),%edx
  800e5c:	89 d1                	mov    %edx,%ecx
  800e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e61:	83 c2 08             	add    $0x8,%edx
  800e64:	83 ec 04             	sub    $0x4,%esp
  800e67:	50                   	push   %eax
  800e68:	51                   	push   %ecx
  800e69:	52                   	push   %edx
  800e6a:	e8 05 14 00 00       	call   802274 <sys_cputs>
  800e6f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800e72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7e:	8b 40 04             	mov    0x4(%eax),%eax
  800e81:	8d 50 01             	lea    0x1(%eax),%edx
  800e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e87:	89 50 04             	mov    %edx,0x4(%eax)
}
  800e8a:	90                   	nop
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800e96:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800e9d:	00 00 00 
	b.cnt = 0;
  800ea0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800ea7:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800eaa:	ff 75 0c             	pushl  0xc(%ebp)
  800ead:	ff 75 08             	pushl  0x8(%ebp)
  800eb0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800eb6:	50                   	push   %eax
  800eb7:	68 24 0e 80 00       	push   $0x800e24
  800ebc:	e8 11 02 00 00       	call   8010d2 <vprintfmt>
  800ec1:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800ec4:	a0 24 50 80 00       	mov    0x805024,%al
  800ec9:	0f b6 c0             	movzbl %al,%eax
  800ecc:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ed2:	83 ec 04             	sub    $0x4,%esp
  800ed5:	50                   	push   %eax
  800ed6:	52                   	push   %edx
  800ed7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800edd:	83 c0 08             	add    $0x8,%eax
  800ee0:	50                   	push   %eax
  800ee1:	e8 8e 13 00 00       	call   802274 <sys_cputs>
  800ee6:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800ee9:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800ef0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ef6:	c9                   	leave  
  800ef7:	c3                   	ret    

00800ef8 <cprintf>:

int cprintf(const char *fmt, ...) {
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800efe:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800f05:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f08:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0e:	83 ec 08             	sub    $0x8,%esp
  800f11:	ff 75 f4             	pushl  -0xc(%ebp)
  800f14:	50                   	push   %eax
  800f15:	e8 73 ff ff ff       	call   800e8d <vcprintf>
  800f1a:	83 c4 10             	add    $0x10,%esp
  800f1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f23:	c9                   	leave  
  800f24:	c3                   	ret    

00800f25 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800f2b:	e8 f2 14 00 00       	call   802422 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800f30:	8d 45 0c             	lea    0xc(%ebp),%eax
  800f33:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800f36:	8b 45 08             	mov    0x8(%ebp),%eax
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3f:	50                   	push   %eax
  800f40:	e8 48 ff ff ff       	call   800e8d <vcprintf>
  800f45:	83 c4 10             	add    $0x10,%esp
  800f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800f4b:	e8 ec 14 00 00       	call   80243c <sys_enable_interrupt>
	return cnt;
  800f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800f53:	c9                   	leave  
  800f54:	c3                   	ret    

00800f55 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800f55:	55                   	push   %ebp
  800f56:	89 e5                	mov    %esp,%ebp
  800f58:	53                   	push   %ebx
  800f59:	83 ec 14             	sub    $0x14,%esp
  800f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f62:	8b 45 14             	mov    0x14(%ebp),%eax
  800f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800f68:	8b 45 18             	mov    0x18(%ebp),%eax
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f73:	77 55                	ja     800fca <printnum+0x75>
  800f75:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800f78:	72 05                	jb     800f7f <printnum+0x2a>
  800f7a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f7d:	77 4b                	ja     800fca <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800f7f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800f82:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800f85:	8b 45 18             	mov    0x18(%ebp),%eax
  800f88:	ba 00 00 00 00       	mov    $0x0,%edx
  800f8d:	52                   	push   %edx
  800f8e:	50                   	push   %eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	ff 75 f0             	pushl  -0x10(%ebp)
  800f95:	e8 62 2a 00 00       	call   8039fc <__udivdi3>
  800f9a:	83 c4 10             	add    $0x10,%esp
  800f9d:	83 ec 04             	sub    $0x4,%esp
  800fa0:	ff 75 20             	pushl  0x20(%ebp)
  800fa3:	53                   	push   %ebx
  800fa4:	ff 75 18             	pushl  0x18(%ebp)
  800fa7:	52                   	push   %edx
  800fa8:	50                   	push   %eax
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 a1 ff ff ff       	call   800f55 <printnum>
  800fb4:	83 c4 20             	add    $0x20,%esp
  800fb7:	eb 1a                	jmp    800fd3 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800fb9:	83 ec 08             	sub    $0x8,%esp
  800fbc:	ff 75 0c             	pushl  0xc(%ebp)
  800fbf:	ff 75 20             	pushl  0x20(%ebp)
  800fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc5:	ff d0                	call   *%eax
  800fc7:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800fca:	ff 4d 1c             	decl   0x1c(%ebp)
  800fcd:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800fd1:	7f e6                	jg     800fb9 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800fd3:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fe1:	53                   	push   %ebx
  800fe2:	51                   	push   %ecx
  800fe3:	52                   	push   %edx
  800fe4:	50                   	push   %eax
  800fe5:	e8 22 2b 00 00       	call   803b0c <__umoddi3>
  800fea:	83 c4 10             	add    $0x10,%esp
  800fed:	05 74 41 80 00       	add    $0x804174,%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f be c0             	movsbl %al,%eax
  800ff7:	83 ec 08             	sub    $0x8,%esp
  800ffa:	ff 75 0c             	pushl  0xc(%ebp)
  800ffd:	50                   	push   %eax
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
}
  801006:	90                   	nop
  801007:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80100f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801013:	7e 1c                	jle    801031 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8b 00                	mov    (%eax),%eax
  80101a:	8d 50 08             	lea    0x8(%eax),%edx
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	89 10                	mov    %edx,(%eax)
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8b 00                	mov    (%eax),%eax
  801027:	83 e8 08             	sub    $0x8,%eax
  80102a:	8b 50 04             	mov    0x4(%eax),%edx
  80102d:	8b 00                	mov    (%eax),%eax
  80102f:	eb 40                	jmp    801071 <getuint+0x65>
	else if (lflag)
  801031:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801035:	74 1e                	je     801055 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8b 00                	mov    (%eax),%eax
  80103c:	8d 50 04             	lea    0x4(%eax),%edx
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	89 10                	mov    %edx,(%eax)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	8b 00                	mov    (%eax),%eax
  801049:	83 e8 04             	sub    $0x4,%eax
  80104c:	8b 00                	mov    (%eax),%eax
  80104e:	ba 00 00 00 00       	mov    $0x0,%edx
  801053:	eb 1c                	jmp    801071 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8b 00                	mov    (%eax),%eax
  80105a:	8d 50 04             	lea    0x4(%eax),%edx
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 10                	mov    %edx,(%eax)
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8b 00                	mov    (%eax),%eax
  801067:	83 e8 04             	sub    $0x4,%eax
  80106a:	8b 00                	mov    (%eax),%eax
  80106c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801071:	5d                   	pop    %ebp
  801072:	c3                   	ret    

00801073 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801073:	55                   	push   %ebp
  801074:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801076:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80107a:	7e 1c                	jle    801098 <getint+0x25>
		return va_arg(*ap, long long);
  80107c:	8b 45 08             	mov    0x8(%ebp),%eax
  80107f:	8b 00                	mov    (%eax),%eax
  801081:	8d 50 08             	lea    0x8(%eax),%edx
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 10                	mov    %edx,(%eax)
  801089:	8b 45 08             	mov    0x8(%ebp),%eax
  80108c:	8b 00                	mov    (%eax),%eax
  80108e:	83 e8 08             	sub    $0x8,%eax
  801091:	8b 50 04             	mov    0x4(%eax),%edx
  801094:	8b 00                	mov    (%eax),%eax
  801096:	eb 38                	jmp    8010d0 <getint+0x5d>
	else if (lflag)
  801098:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80109c:	74 1a                	je     8010b8 <getint+0x45>
		return va_arg(*ap, long);
  80109e:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 50 04             	lea    0x4(%eax),%edx
  8010a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a9:	89 10                	mov    %edx,(%eax)
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8b 00                	mov    (%eax),%eax
  8010b0:	83 e8 04             	sub    $0x4,%eax
  8010b3:	8b 00                	mov    (%eax),%eax
  8010b5:	99                   	cltd   
  8010b6:	eb 18                	jmp    8010d0 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8b 00                	mov    (%eax),%eax
  8010bd:	8d 50 04             	lea    0x4(%eax),%edx
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	89 10                	mov    %edx,(%eax)
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	83 e8 04             	sub    $0x4,%eax
  8010cd:	8b 00                	mov    (%eax),%eax
  8010cf:	99                   	cltd   
}
  8010d0:	5d                   	pop    %ebp
  8010d1:	c3                   	ret    

008010d2 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8010d2:	55                   	push   %ebp
  8010d3:	89 e5                	mov    %esp,%ebp
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010da:	eb 17                	jmp    8010f3 <vprintfmt+0x21>
			if (ch == '\0')
  8010dc:	85 db                	test   %ebx,%ebx
  8010de:	0f 84 af 03 00 00    	je     801493 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8010e4:	83 ec 08             	sub    $0x8,%esp
  8010e7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ea:	53                   	push   %ebx
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	ff d0                	call   *%eax
  8010f0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	8d 50 01             	lea    0x1(%eax),%edx
  8010f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fc:	8a 00                	mov    (%eax),%al
  8010fe:	0f b6 d8             	movzbl %al,%ebx
  801101:	83 fb 25             	cmp    $0x25,%ebx
  801104:	75 d6                	jne    8010dc <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801106:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80110a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801111:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801118:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80111f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801126:	8b 45 10             	mov    0x10(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 10             	mov    %edx,0x10(%ebp)
  80112f:	8a 00                	mov    (%eax),%al
  801131:	0f b6 d8             	movzbl %al,%ebx
  801134:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801137:	83 f8 55             	cmp    $0x55,%eax
  80113a:	0f 87 2b 03 00 00    	ja     80146b <vprintfmt+0x399>
  801140:	8b 04 85 98 41 80 00 	mov    0x804198(,%eax,4),%eax
  801147:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801149:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80114d:	eb d7                	jmp    801126 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80114f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801153:	eb d1                	jmp    801126 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801155:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80115c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80115f:	89 d0                	mov    %edx,%eax
  801161:	c1 e0 02             	shl    $0x2,%eax
  801164:	01 d0                	add    %edx,%eax
  801166:	01 c0                	add    %eax,%eax
  801168:	01 d8                	add    %ebx,%eax
  80116a:	83 e8 30             	sub    $0x30,%eax
  80116d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801170:	8b 45 10             	mov    0x10(%ebp),%eax
  801173:	8a 00                	mov    (%eax),%al
  801175:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801178:	83 fb 2f             	cmp    $0x2f,%ebx
  80117b:	7e 3e                	jle    8011bb <vprintfmt+0xe9>
  80117d:	83 fb 39             	cmp    $0x39,%ebx
  801180:	7f 39                	jg     8011bb <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801182:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801185:	eb d5                	jmp    80115c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801187:	8b 45 14             	mov    0x14(%ebp),%eax
  80118a:	83 c0 04             	add    $0x4,%eax
  80118d:	89 45 14             	mov    %eax,0x14(%ebp)
  801190:	8b 45 14             	mov    0x14(%ebp),%eax
  801193:	83 e8 04             	sub    $0x4,%eax
  801196:	8b 00                	mov    (%eax),%eax
  801198:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80119b:	eb 1f                	jmp    8011bc <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80119d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011a1:	79 83                	jns    801126 <vprintfmt+0x54>
				width = 0;
  8011a3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8011aa:	e9 77 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8011af:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8011b6:	e9 6b ff ff ff       	jmp    801126 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8011bb:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8011bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8011c0:	0f 89 60 ff ff ff    	jns    801126 <vprintfmt+0x54>
				width = precision, precision = -1;
  8011c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011cc:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8011d3:	e9 4e ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8011d8:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8011db:	e9 46 ff ff ff       	jmp    801126 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	83 c0 04             	add    $0x4,%eax
  8011e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8011e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ec:	83 e8 04             	sub    $0x4,%eax
  8011ef:	8b 00                	mov    (%eax),%eax
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	50                   	push   %eax
  8011f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fb:	ff d0                	call   *%eax
  8011fd:	83 c4 10             	add    $0x10,%esp
			break;
  801200:	e9 89 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801205:	8b 45 14             	mov    0x14(%ebp),%eax
  801208:	83 c0 04             	add    $0x4,%eax
  80120b:	89 45 14             	mov    %eax,0x14(%ebp)
  80120e:	8b 45 14             	mov    0x14(%ebp),%eax
  801211:	83 e8 04             	sub    $0x4,%eax
  801214:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801216:	85 db                	test   %ebx,%ebx
  801218:	79 02                	jns    80121c <vprintfmt+0x14a>
				err = -err;
  80121a:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80121c:	83 fb 64             	cmp    $0x64,%ebx
  80121f:	7f 0b                	jg     80122c <vprintfmt+0x15a>
  801221:	8b 34 9d e0 3f 80 00 	mov    0x803fe0(,%ebx,4),%esi
  801228:	85 f6                	test   %esi,%esi
  80122a:	75 19                	jne    801245 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80122c:	53                   	push   %ebx
  80122d:	68 85 41 80 00       	push   $0x804185
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	ff 75 08             	pushl  0x8(%ebp)
  801238:	e8 5e 02 00 00       	call   80149b <printfmt>
  80123d:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801240:	e9 49 02 00 00       	jmp    80148e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801245:	56                   	push   %esi
  801246:	68 8e 41 80 00       	push   $0x80418e
  80124b:	ff 75 0c             	pushl  0xc(%ebp)
  80124e:	ff 75 08             	pushl  0x8(%ebp)
  801251:	e8 45 02 00 00       	call   80149b <printfmt>
  801256:	83 c4 10             	add    $0x10,%esp
			break;
  801259:	e9 30 02 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80125e:	8b 45 14             	mov    0x14(%ebp),%eax
  801261:	83 c0 04             	add    $0x4,%eax
  801264:	89 45 14             	mov    %eax,0x14(%ebp)
  801267:	8b 45 14             	mov    0x14(%ebp),%eax
  80126a:	83 e8 04             	sub    $0x4,%eax
  80126d:	8b 30                	mov    (%eax),%esi
  80126f:	85 f6                	test   %esi,%esi
  801271:	75 05                	jne    801278 <vprintfmt+0x1a6>
				p = "(null)";
  801273:	be 91 41 80 00       	mov    $0x804191,%esi
			if (width > 0 && padc != '-')
  801278:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80127c:	7e 6d                	jle    8012eb <vprintfmt+0x219>
  80127e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801282:	74 67                	je     8012eb <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801284:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801287:	83 ec 08             	sub    $0x8,%esp
  80128a:	50                   	push   %eax
  80128b:	56                   	push   %esi
  80128c:	e8 0c 03 00 00       	call   80159d <strnlen>
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801297:	eb 16                	jmp    8012af <vprintfmt+0x1dd>
					putch(padc, putdat);
  801299:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80129d:	83 ec 08             	sub    $0x8,%esp
  8012a0:	ff 75 0c             	pushl  0xc(%ebp)
  8012a3:	50                   	push   %eax
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	ff d0                	call   *%eax
  8012a9:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8012ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8012af:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8012b3:	7f e4                	jg     801299 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012b5:	eb 34                	jmp    8012eb <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8012b7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8012bb:	74 1c                	je     8012d9 <vprintfmt+0x207>
  8012bd:	83 fb 1f             	cmp    $0x1f,%ebx
  8012c0:	7e 05                	jle    8012c7 <vprintfmt+0x1f5>
  8012c2:	83 fb 7e             	cmp    $0x7e,%ebx
  8012c5:	7e 12                	jle    8012d9 <vprintfmt+0x207>
					putch('?', putdat);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	ff 75 0c             	pushl  0xc(%ebp)
  8012cd:	6a 3f                	push   $0x3f
  8012cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d2:	ff d0                	call   *%eax
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	eb 0f                	jmp    8012e8 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8012d9:	83 ec 08             	sub    $0x8,%esp
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	53                   	push   %ebx
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	ff d0                	call   *%eax
  8012e5:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8012e8:	ff 4d e4             	decl   -0x1c(%ebp)
  8012eb:	89 f0                	mov    %esi,%eax
  8012ed:	8d 70 01             	lea    0x1(%eax),%esi
  8012f0:	8a 00                	mov    (%eax),%al
  8012f2:	0f be d8             	movsbl %al,%ebx
  8012f5:	85 db                	test   %ebx,%ebx
  8012f7:	74 24                	je     80131d <vprintfmt+0x24b>
  8012f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012fd:	78 b8                	js     8012b7 <vprintfmt+0x1e5>
  8012ff:	ff 4d e0             	decl   -0x20(%ebp)
  801302:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801306:	79 af                	jns    8012b7 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801308:	eb 13                	jmp    80131d <vprintfmt+0x24b>
				putch(' ', putdat);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	ff 75 0c             	pushl  0xc(%ebp)
  801310:	6a 20                	push   $0x20
  801312:	8b 45 08             	mov    0x8(%ebp),%eax
  801315:	ff d0                	call   *%eax
  801317:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80131a:	ff 4d e4             	decl   -0x1c(%ebp)
  80131d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801321:	7f e7                	jg     80130a <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801323:	e9 66 01 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801328:	83 ec 08             	sub    $0x8,%esp
  80132b:	ff 75 e8             	pushl  -0x18(%ebp)
  80132e:	8d 45 14             	lea    0x14(%ebp),%eax
  801331:	50                   	push   %eax
  801332:	e8 3c fd ff ff       	call   801073 <getint>
  801337:	83 c4 10             	add    $0x10,%esp
  80133a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80133d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801346:	85 d2                	test   %edx,%edx
  801348:	79 23                	jns    80136d <vprintfmt+0x29b>
				putch('-', putdat);
  80134a:	83 ec 08             	sub    $0x8,%esp
  80134d:	ff 75 0c             	pushl  0xc(%ebp)
  801350:	6a 2d                	push   $0x2d
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	ff d0                	call   *%eax
  801357:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801360:	f7 d8                	neg    %eax
  801362:	83 d2 00             	adc    $0x0,%edx
  801365:	f7 da                	neg    %edx
  801367:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80136a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80136d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801374:	e9 bc 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801379:	83 ec 08             	sub    $0x8,%esp
  80137c:	ff 75 e8             	pushl  -0x18(%ebp)
  80137f:	8d 45 14             	lea    0x14(%ebp),%eax
  801382:	50                   	push   %eax
  801383:	e8 84 fc ff ff       	call   80100c <getuint>
  801388:	83 c4 10             	add    $0x10,%esp
  80138b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80138e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801391:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801398:	e9 98 00 00 00       	jmp    801435 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	ff 75 0c             	pushl  0xc(%ebp)
  8013a3:	6a 58                	push   $0x58
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	ff d0                	call   *%eax
  8013aa:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013ad:	83 ec 08             	sub    $0x8,%esp
  8013b0:	ff 75 0c             	pushl  0xc(%ebp)
  8013b3:	6a 58                	push   $0x58
  8013b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b8:	ff d0                	call   *%eax
  8013ba:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8013bd:	83 ec 08             	sub    $0x8,%esp
  8013c0:	ff 75 0c             	pushl  0xc(%ebp)
  8013c3:	6a 58                	push   $0x58
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	ff d0                	call   *%eax
  8013ca:	83 c4 10             	add    $0x10,%esp
			break;
  8013cd:	e9 bc 00 00 00       	jmp    80148e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	ff 75 0c             	pushl  0xc(%ebp)
  8013d8:	6a 30                	push   $0x30
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	ff d0                	call   *%eax
  8013df:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	ff 75 0c             	pushl  0xc(%ebp)
  8013e8:	6a 78                	push   $0x78
  8013ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ed:	ff d0                	call   *%eax
  8013ef:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	83 c0 04             	add    $0x4,%eax
  8013f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	83 e8 04             	sub    $0x4,%eax
  801401:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80140d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801414:	eb 1f                	jmp    801435 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801416:	83 ec 08             	sub    $0x8,%esp
  801419:	ff 75 e8             	pushl  -0x18(%ebp)
  80141c:	8d 45 14             	lea    0x14(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	e8 e7 fb ff ff       	call   80100c <getuint>
  801425:	83 c4 10             	add    $0x10,%esp
  801428:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80142e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801435:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801439:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80143c:	83 ec 04             	sub    $0x4,%esp
  80143f:	52                   	push   %edx
  801440:	ff 75 e4             	pushl  -0x1c(%ebp)
  801443:	50                   	push   %eax
  801444:	ff 75 f4             	pushl  -0xc(%ebp)
  801447:	ff 75 f0             	pushl  -0x10(%ebp)
  80144a:	ff 75 0c             	pushl  0xc(%ebp)
  80144d:	ff 75 08             	pushl  0x8(%ebp)
  801450:	e8 00 fb ff ff       	call   800f55 <printnum>
  801455:	83 c4 20             	add    $0x20,%esp
			break;
  801458:	eb 34                	jmp    80148e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80145a:	83 ec 08             	sub    $0x8,%esp
  80145d:	ff 75 0c             	pushl  0xc(%ebp)
  801460:	53                   	push   %ebx
  801461:	8b 45 08             	mov    0x8(%ebp),%eax
  801464:	ff d0                	call   *%eax
  801466:	83 c4 10             	add    $0x10,%esp
			break;
  801469:	eb 23                	jmp    80148e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80146b:	83 ec 08             	sub    $0x8,%esp
  80146e:	ff 75 0c             	pushl  0xc(%ebp)
  801471:	6a 25                	push   $0x25
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	ff d0                	call   *%eax
  801478:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80147b:	ff 4d 10             	decl   0x10(%ebp)
  80147e:	eb 03                	jmp    801483 <vprintfmt+0x3b1>
  801480:	ff 4d 10             	decl   0x10(%ebp)
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	48                   	dec    %eax
  801487:	8a 00                	mov    (%eax),%al
  801489:	3c 25                	cmp    $0x25,%al
  80148b:	75 f3                	jne    801480 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80148d:	90                   	nop
		}
	}
  80148e:	e9 47 fc ff ff       	jmp    8010da <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801493:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801494:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801497:	5b                   	pop    %ebx
  801498:	5e                   	pop    %esi
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8014a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8014a4:	83 c0 04             	add    $0x4,%eax
  8014a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	ff 75 0c             	pushl  0xc(%ebp)
  8014b4:	ff 75 08             	pushl  0x8(%ebp)
  8014b7:	e8 16 fc ff ff       	call   8010d2 <vprintfmt>
  8014bc:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8014bf:	90                   	nop
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 40 08             	mov    0x8(%eax),%eax
  8014cb:	8d 50 01             	lea    0x1(%eax),%edx
  8014ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d1:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8014d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d7:	8b 10                	mov    (%eax),%edx
  8014d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dc:	8b 40 04             	mov    0x4(%eax),%eax
  8014df:	39 c2                	cmp    %eax,%edx
  8014e1:	73 12                	jae    8014f5 <sprintputch+0x33>
		*b->buf++ = ch;
  8014e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	8d 48 01             	lea    0x1(%eax),%ecx
  8014eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ee:	89 0a                	mov    %ecx,(%edx)
  8014f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f3:	88 10                	mov    %dl,(%eax)
}
  8014f5:	90                   	nop
  8014f6:	5d                   	pop    %ebp
  8014f7:	c3                   	ret    

008014f8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8014fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801501:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8d 50 ff             	lea    -0x1(%eax),%edx
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	01 d0                	add    %edx,%eax
  80150f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801512:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801519:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151d:	74 06                	je     801525 <vsnprintf+0x2d>
  80151f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801523:	7f 07                	jg     80152c <vsnprintf+0x34>
		return -E_INVAL;
  801525:	b8 03 00 00 00       	mov    $0x3,%eax
  80152a:	eb 20                	jmp    80154c <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80152c:	ff 75 14             	pushl  0x14(%ebp)
  80152f:	ff 75 10             	pushl  0x10(%ebp)
  801532:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801535:	50                   	push   %eax
  801536:	68 c2 14 80 00       	push   $0x8014c2
  80153b:	e8 92 fb ff ff       	call   8010d2 <vprintfmt>
  801540:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801543:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801546:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801554:	8d 45 10             	lea    0x10(%ebp),%eax
  801557:	83 c0 04             	add    $0x4,%eax
  80155a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80155d:	8b 45 10             	mov    0x10(%ebp),%eax
  801560:	ff 75 f4             	pushl  -0xc(%ebp)
  801563:	50                   	push   %eax
  801564:	ff 75 0c             	pushl  0xc(%ebp)
  801567:	ff 75 08             	pushl  0x8(%ebp)
  80156a:	e8 89 ff ff ff       	call   8014f8 <vsnprintf>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801575:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801587:	eb 06                	jmp    80158f <strlen+0x15>
		n++;
  801589:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80158c:	ff 45 08             	incl   0x8(%ebp)
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	8a 00                	mov    (%eax),%al
  801594:	84 c0                	test   %al,%al
  801596:	75 f1                	jne    801589 <strlen+0xf>
		n++;
	return n;
  801598:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80159b:	c9                   	leave  
  80159c:	c3                   	ret    

0080159d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015aa:	eb 09                	jmp    8015b5 <strnlen+0x18>
		n++;
  8015ac:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	ff 4d 0c             	decl   0xc(%ebp)
  8015b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015b9:	74 09                	je     8015c4 <strnlen+0x27>
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	8a 00                	mov    (%eax),%al
  8015c0:	84 c0                	test   %al,%al
  8015c2:	75 e8                	jne    8015ac <strnlen+0xf>
		n++;
	return n;
  8015c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8015d5:	90                   	nop
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	8d 50 01             	lea    0x1(%eax),%edx
  8015dc:	89 55 08             	mov    %edx,0x8(%ebp)
  8015df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015e5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015e8:	8a 12                	mov    (%edx),%dl
  8015ea:	88 10                	mov    %dl,(%eax)
  8015ec:	8a 00                	mov    (%eax),%al
  8015ee:	84 c0                	test   %al,%al
  8015f0:	75 e4                	jne    8015d6 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8015f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8015fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801600:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801603:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80160a:	eb 1f                	jmp    80162b <strncpy+0x34>
		*dst++ = *src;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8d 50 01             	lea    0x1(%eax),%edx
  801612:	89 55 08             	mov    %edx,0x8(%ebp)
  801615:	8b 55 0c             	mov    0xc(%ebp),%edx
  801618:	8a 12                	mov    (%edx),%dl
  80161a:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80161c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161f:	8a 00                	mov    (%eax),%al
  801621:	84 c0                	test   %al,%al
  801623:	74 03                	je     801628 <strncpy+0x31>
			src++;
  801625:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801628:	ff 45 fc             	incl   -0x4(%ebp)
  80162b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801631:	72 d9                	jb     80160c <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801633:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801644:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801648:	74 30                	je     80167a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80164a:	eb 16                	jmp    801662 <strlcpy+0x2a>
			*dst++ = *src++;
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8d 50 01             	lea    0x1(%eax),%edx
  801652:	89 55 08             	mov    %edx,0x8(%ebp)
  801655:	8b 55 0c             	mov    0xc(%ebp),%edx
  801658:	8d 4a 01             	lea    0x1(%edx),%ecx
  80165b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80165e:	8a 12                	mov    (%edx),%dl
  801660:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801662:	ff 4d 10             	decl   0x10(%ebp)
  801665:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801669:	74 09                	je     801674 <strlcpy+0x3c>
  80166b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	84 c0                	test   %al,%al
  801672:	75 d8                	jne    80164c <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80167a:	8b 55 08             	mov    0x8(%ebp),%edx
  80167d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801689:	eb 06                	jmp    801691 <strcmp+0xb>
		p++, q++;
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8a 00                	mov    (%eax),%al
  801696:	84 c0                	test   %al,%al
  801698:	74 0e                	je     8016a8 <strcmp+0x22>
  80169a:	8b 45 08             	mov    0x8(%ebp),%eax
  80169d:	8a 10                	mov    (%eax),%dl
  80169f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a2:	8a 00                	mov    (%eax),%al
  8016a4:	38 c2                	cmp    %al,%dl
  8016a6:	74 e3                	je     80168b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8016a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ab:	8a 00                	mov    (%eax),%al
  8016ad:	0f b6 d0             	movzbl %al,%edx
  8016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b3:	8a 00                	mov    (%eax),%al
  8016b5:	0f b6 c0             	movzbl %al,%eax
  8016b8:	29 c2                	sub    %eax,%edx
  8016ba:	89 d0                	mov    %edx,%eax
}
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8016c1:	eb 09                	jmp    8016cc <strncmp+0xe>
		n--, p++, q++;
  8016c3:	ff 4d 10             	decl   0x10(%ebp)
  8016c6:	ff 45 08             	incl   0x8(%ebp)
  8016c9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8016cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016d0:	74 17                	je     8016e9 <strncmp+0x2b>
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	8a 00                	mov    (%eax),%al
  8016d7:	84 c0                	test   %al,%al
  8016d9:	74 0e                	je     8016e9 <strncmp+0x2b>
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8a 10                	mov    (%eax),%dl
  8016e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e3:	8a 00                	mov    (%eax),%al
  8016e5:	38 c2                	cmp    %al,%dl
  8016e7:	74 da                	je     8016c3 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8016e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ed:	75 07                	jne    8016f6 <strncmp+0x38>
		return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f4:	eb 14                	jmp    80170a <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	0f b6 d0             	movzbl %al,%edx
  8016fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801701:	8a 00                	mov    (%eax),%al
  801703:	0f b6 c0             	movzbl %al,%eax
  801706:	29 c2                	sub    %eax,%edx
  801708:	89 d0                	mov    %edx,%eax
}
  80170a:	5d                   	pop    %ebp
  80170b:	c3                   	ret    

0080170c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80170c:	55                   	push   %ebp
  80170d:	89 e5                	mov    %esp,%ebp
  80170f:	83 ec 04             	sub    $0x4,%esp
  801712:	8b 45 0c             	mov    0xc(%ebp),%eax
  801715:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801718:	eb 12                	jmp    80172c <strchr+0x20>
		if (*s == c)
  80171a:	8b 45 08             	mov    0x8(%ebp),%eax
  80171d:	8a 00                	mov    (%eax),%al
  80171f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801722:	75 05                	jne    801729 <strchr+0x1d>
			return (char *) s;
  801724:	8b 45 08             	mov    0x8(%ebp),%eax
  801727:	eb 11                	jmp    80173a <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801729:	ff 45 08             	incl   0x8(%ebp)
  80172c:	8b 45 08             	mov    0x8(%ebp),%eax
  80172f:	8a 00                	mov    (%eax),%al
  801731:	84 c0                	test   %al,%al
  801733:	75 e5                	jne    80171a <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801735:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173a:	c9                   	leave  
  80173b:	c3                   	ret    

0080173c <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 04             	sub    $0x4,%esp
  801742:	8b 45 0c             	mov    0xc(%ebp),%eax
  801745:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801748:	eb 0d                	jmp    801757 <strfind+0x1b>
		if (*s == c)
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8a 00                	mov    (%eax),%al
  80174f:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801752:	74 0e                	je     801762 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801754:	ff 45 08             	incl   0x8(%ebp)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	75 ea                	jne    80174a <strfind+0xe>
  801760:	eb 01                	jmp    801763 <strfind+0x27>
		if (*s == c)
			break;
  801762:	90                   	nop
	return (char *) s;
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801766:	c9                   	leave  
  801767:	c3                   	ret    

00801768 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80176e:	8b 45 08             	mov    0x8(%ebp),%eax
  801771:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801774:	8b 45 10             	mov    0x10(%ebp),%eax
  801777:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80177a:	eb 0e                	jmp    80178a <memset+0x22>
		*p++ = c;
  80177c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80177f:	8d 50 01             	lea    0x1(%eax),%edx
  801782:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801785:	8b 55 0c             	mov    0xc(%ebp),%edx
  801788:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80178a:	ff 4d f8             	decl   -0x8(%ebp)
  80178d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801791:	79 e9                	jns    80177c <memset+0x14>
		*p++ = c;

	return v;
  801793:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801796:	c9                   	leave  
  801797:	c3                   	ret    

00801798 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801798:	55                   	push   %ebp
  801799:	89 e5                	mov    %esp,%ebp
  80179b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80179e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8017aa:	eb 16                	jmp    8017c2 <memcpy+0x2a>
		*d++ = *s++;
  8017ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017af:	8d 50 01             	lea    0x1(%eax),%edx
  8017b2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8017b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017b8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8017bb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8017be:	8a 12                	mov    (%edx),%dl
  8017c0:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8017c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017c8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017cb:	85 c0                	test   %eax,%eax
  8017cd:	75 dd                	jne    8017ac <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8017cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017d2:	c9                   	leave  
  8017d3:	c3                   	ret    

008017d4 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8017d4:	55                   	push   %ebp
  8017d5:	89 e5                	mov    %esp,%ebp
  8017d7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8017e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017e9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017ec:	73 50                	jae    80183e <memmove+0x6a>
  8017ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8017f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f4:	01 d0                	add    %edx,%eax
  8017f6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8017f9:	76 43                	jbe    80183e <memmove+0x6a>
		s += n;
  8017fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8017fe:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801801:	8b 45 10             	mov    0x10(%ebp),%eax
  801804:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801807:	eb 10                	jmp    801819 <memmove+0x45>
			*--d = *--s;
  801809:	ff 4d f8             	decl   -0x8(%ebp)
  80180c:	ff 4d fc             	decl   -0x4(%ebp)
  80180f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801812:	8a 10                	mov    (%eax),%dl
  801814:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801817:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801819:	8b 45 10             	mov    0x10(%ebp),%eax
  80181c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80181f:	89 55 10             	mov    %edx,0x10(%ebp)
  801822:	85 c0                	test   %eax,%eax
  801824:	75 e3                	jne    801809 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801826:	eb 23                	jmp    80184b <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801828:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80182b:	8d 50 01             	lea    0x1(%eax),%edx
  80182e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801831:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801834:	8d 4a 01             	lea    0x1(%edx),%ecx
  801837:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80183a:	8a 12                	mov    (%edx),%dl
  80183c:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80183e:	8b 45 10             	mov    0x10(%ebp),%eax
  801841:	8d 50 ff             	lea    -0x1(%eax),%edx
  801844:	89 55 10             	mov    %edx,0x10(%ebp)
  801847:	85 c0                	test   %eax,%eax
  801849:	75 dd                	jne    801828 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80184b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801862:	eb 2a                	jmp    80188e <memcmp+0x3e>
		if (*s1 != *s2)
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	8a 10                	mov    (%eax),%dl
  801869:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	38 c2                	cmp    %al,%dl
  801870:	74 16                	je     801888 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801872:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801875:	8a 00                	mov    (%eax),%al
  801877:	0f b6 d0             	movzbl %al,%edx
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187d:	8a 00                	mov    (%eax),%al
  80187f:	0f b6 c0             	movzbl %al,%eax
  801882:	29 c2                	sub    %eax,%edx
  801884:	89 d0                	mov    %edx,%eax
  801886:	eb 18                	jmp    8018a0 <memcmp+0x50>
		s1++, s2++;
  801888:	ff 45 fc             	incl   -0x4(%ebp)
  80188b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80188e:	8b 45 10             	mov    0x10(%ebp),%eax
  801891:	8d 50 ff             	lea    -0x1(%eax),%edx
  801894:	89 55 10             	mov    %edx,0x10(%ebp)
  801897:	85 c0                	test   %eax,%eax
  801899:	75 c9                	jne    801864 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8018a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ae:	01 d0                	add    %edx,%eax
  8018b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8018b3:	eb 15                	jmp    8018ca <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	8a 00                	mov    (%eax),%al
  8018ba:	0f b6 d0             	movzbl %al,%edx
  8018bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c0:	0f b6 c0             	movzbl %al,%eax
  8018c3:	39 c2                	cmp    %eax,%edx
  8018c5:	74 0d                	je     8018d4 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8018c7:	ff 45 08             	incl   0x8(%ebp)
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8018d0:	72 e3                	jb     8018b5 <memfind+0x13>
  8018d2:	eb 01                	jmp    8018d5 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8018d4:	90                   	nop
	return (void *) s;
  8018d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8018e7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018ee:	eb 03                	jmp    8018f3 <strtol+0x19>
		s++;
  8018f0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	8a 00                	mov    (%eax),%al
  8018f8:	3c 20                	cmp    $0x20,%al
  8018fa:	74 f4                	je     8018f0 <strtol+0x16>
  8018fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ff:	8a 00                	mov    (%eax),%al
  801901:	3c 09                	cmp    $0x9,%al
  801903:	74 eb                	je     8018f0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8a 00                	mov    (%eax),%al
  80190a:	3c 2b                	cmp    $0x2b,%al
  80190c:	75 05                	jne    801913 <strtol+0x39>
		s++;
  80190e:	ff 45 08             	incl   0x8(%ebp)
  801911:	eb 13                	jmp    801926 <strtol+0x4c>
	else if (*s == '-')
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	8a 00                	mov    (%eax),%al
  801918:	3c 2d                	cmp    $0x2d,%al
  80191a:	75 0a                	jne    801926 <strtol+0x4c>
		s++, neg = 1;
  80191c:	ff 45 08             	incl   0x8(%ebp)
  80191f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801926:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80192a:	74 06                	je     801932 <strtol+0x58>
  80192c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801930:	75 20                	jne    801952 <strtol+0x78>
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	3c 30                	cmp    $0x30,%al
  801939:	75 17                	jne    801952 <strtol+0x78>
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	40                   	inc    %eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	3c 78                	cmp    $0x78,%al
  801943:	75 0d                	jne    801952 <strtol+0x78>
		s += 2, base = 16;
  801945:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801949:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801950:	eb 28                	jmp    80197a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801952:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801956:	75 15                	jne    80196d <strtol+0x93>
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	8a 00                	mov    (%eax),%al
  80195d:	3c 30                	cmp    $0x30,%al
  80195f:	75 0c                	jne    80196d <strtol+0x93>
		s++, base = 8;
  801961:	ff 45 08             	incl   0x8(%ebp)
  801964:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80196b:	eb 0d                	jmp    80197a <strtol+0xa0>
	else if (base == 0)
  80196d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801971:	75 07                	jne    80197a <strtol+0xa0>
		base = 10;
  801973:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80197a:	8b 45 08             	mov    0x8(%ebp),%eax
  80197d:	8a 00                	mov    (%eax),%al
  80197f:	3c 2f                	cmp    $0x2f,%al
  801981:	7e 19                	jle    80199c <strtol+0xc2>
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	8a 00                	mov    (%eax),%al
  801988:	3c 39                	cmp    $0x39,%al
  80198a:	7f 10                	jg     80199c <strtol+0xc2>
			dig = *s - '0';
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8a 00                	mov    (%eax),%al
  801991:	0f be c0             	movsbl %al,%eax
  801994:	83 e8 30             	sub    $0x30,%eax
  801997:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80199a:	eb 42                	jmp    8019de <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	8a 00                	mov    (%eax),%al
  8019a1:	3c 60                	cmp    $0x60,%al
  8019a3:	7e 19                	jle    8019be <strtol+0xe4>
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	8a 00                	mov    (%eax),%al
  8019aa:	3c 7a                	cmp    $0x7a,%al
  8019ac:	7f 10                	jg     8019be <strtol+0xe4>
			dig = *s - 'a' + 10;
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	8a 00                	mov    (%eax),%al
  8019b3:	0f be c0             	movsbl %al,%eax
  8019b6:	83 e8 57             	sub    $0x57,%eax
  8019b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8019bc:	eb 20                	jmp    8019de <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	8a 00                	mov    (%eax),%al
  8019c3:	3c 40                	cmp    $0x40,%al
  8019c5:	7e 39                	jle    801a00 <strtol+0x126>
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8a 00                	mov    (%eax),%al
  8019cc:	3c 5a                	cmp    $0x5a,%al
  8019ce:	7f 30                	jg     801a00 <strtol+0x126>
			dig = *s - 'A' + 10;
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8a 00                	mov    (%eax),%al
  8019d5:	0f be c0             	movsbl %al,%eax
  8019d8:	83 e8 37             	sub    $0x37,%eax
  8019db:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8019de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e1:	3b 45 10             	cmp    0x10(%ebp),%eax
  8019e4:	7d 19                	jge    8019ff <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8019e6:	ff 45 08             	incl   0x8(%ebp)
  8019e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ec:	0f af 45 10          	imul   0x10(%ebp),%eax
  8019f0:	89 c2                	mov    %eax,%edx
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	01 d0                	add    %edx,%eax
  8019f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8019fa:	e9 7b ff ff ff       	jmp    80197a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8019ff:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801a00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a04:	74 08                	je     801a0e <strtol+0x134>
		*endptr = (char *) s;
  801a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a09:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0c:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801a0e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a12:	74 07                	je     801a1b <strtol+0x141>
  801a14:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a17:	f7 d8                	neg    %eax
  801a19:	eb 03                	jmp    801a1e <strtol+0x144>
  801a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <ltostr>:

void
ltostr(long value, char *str)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801a2d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801a34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801a38:	79 13                	jns    801a4d <ltostr+0x2d>
	{
		neg = 1;
  801a3a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801a47:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801a4a:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a50:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801a55:	99                   	cltd   
  801a56:	f7 f9                	idiv   %ecx
  801a58:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801a5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a5e:	8d 50 01             	lea    0x1(%eax),%edx
  801a61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a64:	89 c2                	mov    %eax,%edx
  801a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a69:	01 d0                	add    %edx,%eax
  801a6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801a6e:	83 c2 30             	add    $0x30,%edx
  801a71:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a76:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a7b:	f7 e9                	imul   %ecx
  801a7d:	c1 fa 02             	sar    $0x2,%edx
  801a80:	89 c8                	mov    %ecx,%eax
  801a82:	c1 f8 1f             	sar    $0x1f,%eax
  801a85:	29 c2                	sub    %eax,%edx
  801a87:	89 d0                	mov    %edx,%eax
  801a89:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801a94:	f7 e9                	imul   %ecx
  801a96:	c1 fa 02             	sar    $0x2,%edx
  801a99:	89 c8                	mov    %ecx,%eax
  801a9b:	c1 f8 1f             	sar    $0x1f,%eax
  801a9e:	29 c2                	sub    %eax,%edx
  801aa0:	89 d0                	mov    %edx,%eax
  801aa2:	c1 e0 02             	shl    $0x2,%eax
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	01 c0                	add    %eax,%eax
  801aa9:	29 c1                	sub    %eax,%ecx
  801aab:	89 ca                	mov    %ecx,%edx
  801aad:	85 d2                	test   %edx,%edx
  801aaf:	75 9c                	jne    801a4d <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801ab1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801ab8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801abb:	48                   	dec    %eax
  801abc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801abf:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801ac3:	74 3d                	je     801b02 <ltostr+0xe2>
		start = 1 ;
  801ac5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801acc:	eb 34                	jmp    801b02 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad4:	01 d0                	add    %edx,%eax
  801ad6:	8a 00                	mov    (%eax),%al
  801ad8:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae1:	01 c2                	add    %eax,%edx
  801ae3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	01 c8                	add    %ecx,%eax
  801aeb:	8a 00                	mov    (%eax),%al
  801aed:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801aef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af5:	01 c2                	add    %eax,%edx
  801af7:	8a 45 eb             	mov    -0x15(%ebp),%al
  801afa:	88 02                	mov    %al,(%edx)
		start++ ;
  801afc:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801aff:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b08:	7c c4                	jl     801ace <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801b0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b10:	01 d0                	add    %edx,%eax
  801b12:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801b15:	90                   	nop
  801b16:	c9                   	leave  
  801b17:	c3                   	ret    

00801b18 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801b18:	55                   	push   %ebp
  801b19:	89 e5                	mov    %esp,%ebp
  801b1b:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	e8 54 fa ff ff       	call   80157a <strlen>
  801b26:	83 c4 04             	add    $0x4,%esp
  801b29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	e8 46 fa ff ff       	call   80157a <strlen>
  801b34:	83 c4 04             	add    $0x4,%esp
  801b37:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801b3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801b41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801b48:	eb 17                	jmp    801b61 <strcconcat+0x49>
		final[s] = str1[s] ;
  801b4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b50:	01 c2                	add    %eax,%edx
  801b52:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	01 c8                	add    %ecx,%eax
  801b5a:	8a 00                	mov    (%eax),%al
  801b5c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801b5e:	ff 45 fc             	incl   -0x4(%ebp)
  801b61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b64:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b67:	7c e1                	jl     801b4a <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801b69:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801b70:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801b77:	eb 1f                	jmp    801b98 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b7c:	8d 50 01             	lea    0x1(%eax),%edx
  801b7f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801b82:	89 c2                	mov    %eax,%edx
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	01 c2                	add    %eax,%edx
  801b89:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8f:	01 c8                	add    %ecx,%eax
  801b91:	8a 00                	mov    (%eax),%al
  801b93:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801b95:	ff 45 f8             	incl   -0x8(%ebp)
  801b98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b9b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b9e:	7c d9                	jl     801b79 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801ba0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ba3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba6:	01 d0                	add    %edx,%eax
  801ba8:	c6 00 00             	movb   $0x0,(%eax)
}
  801bab:	90                   	nop
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801bb1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801bba:	8b 45 14             	mov    0x14(%ebp),%eax
  801bbd:	8b 00                	mov    (%eax),%eax
  801bbf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bc6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc9:	01 d0                	add    %edx,%eax
  801bcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bd1:	eb 0c                	jmp    801bdf <strsplit+0x31>
			*string++ = 0;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	8d 50 01             	lea    0x1(%eax),%edx
  801bd9:	89 55 08             	mov    %edx,0x8(%ebp)
  801bdc:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	8a 00                	mov    (%eax),%al
  801be4:	84 c0                	test   %al,%al
  801be6:	74 18                	je     801c00 <strsplit+0x52>
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	8a 00                	mov    (%eax),%al
  801bed:	0f be c0             	movsbl %al,%eax
  801bf0:	50                   	push   %eax
  801bf1:	ff 75 0c             	pushl  0xc(%ebp)
  801bf4:	e8 13 fb ff ff       	call   80170c <strchr>
  801bf9:	83 c4 08             	add    $0x8,%esp
  801bfc:	85 c0                	test   %eax,%eax
  801bfe:	75 d3                	jne    801bd3 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	8a 00                	mov    (%eax),%al
  801c05:	84 c0                	test   %al,%al
  801c07:	74 5a                	je     801c63 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801c09:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0c:	8b 00                	mov    (%eax),%eax
  801c0e:	83 f8 0f             	cmp    $0xf,%eax
  801c11:	75 07                	jne    801c1a <strsplit+0x6c>
		{
			return 0;
  801c13:	b8 00 00 00 00       	mov    $0x0,%eax
  801c18:	eb 66                	jmp    801c80 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801c1a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	8d 48 01             	lea    0x1(%eax),%ecx
  801c22:	8b 55 14             	mov    0x14(%ebp),%edx
  801c25:	89 0a                	mov    %ecx,(%edx)
  801c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  801c31:	01 c2                	add    %eax,%edx
  801c33:	8b 45 08             	mov    0x8(%ebp),%eax
  801c36:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c38:	eb 03                	jmp    801c3d <strsplit+0x8f>
			string++;
  801c3a:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	8a 00                	mov    (%eax),%al
  801c42:	84 c0                	test   %al,%al
  801c44:	74 8b                	je     801bd1 <strsplit+0x23>
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	8a 00                	mov    (%eax),%al
  801c4b:	0f be c0             	movsbl %al,%eax
  801c4e:	50                   	push   %eax
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 b5 fa ff ff       	call   80170c <strchr>
  801c57:	83 c4 08             	add    $0x8,%esp
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 dc                	je     801c3a <strsplit+0x8c>
			string++;
	}
  801c5e:	e9 6e ff ff ff       	jmp    801bd1 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801c63:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801c64:	8b 45 14             	mov    0x14(%ebp),%eax
  801c67:	8b 00                	mov    (%eax),%eax
  801c69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801c70:	8b 45 10             	mov    0x10(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801c7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
  801c85:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801c88:	a1 04 50 80 00       	mov    0x805004,%eax
  801c8d:	85 c0                	test   %eax,%eax
  801c8f:	74 1f                	je     801cb0 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801c91:	e8 1d 00 00 00       	call   801cb3 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801c96:	83 ec 0c             	sub    $0xc,%esp
  801c99:	68 f0 42 80 00       	push   $0x8042f0
  801c9e:	e8 55 f2 ff ff       	call   800ef8 <cprintf>
  801ca3:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801ca6:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801cad:	00 00 00 
	}
}
  801cb0:	90                   	nop
  801cb1:	c9                   	leave  
  801cb2:	c3                   	ret    

00801cb3 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801cb3:	55                   	push   %ebp
  801cb4:	89 e5                	mov    %esp,%ebp
  801cb6:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801cb9:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801cc0:	00 00 00 
  801cc3:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801cca:	00 00 00 
  801ccd:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801cd4:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801cd7:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801cde:	00 00 00 
  801ce1:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801ce8:	00 00 00 
  801ceb:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801cf2:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801cf5:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801cfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cff:	c1 e8 0c             	shr    $0xc,%eax
  801d02:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801d07:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d11:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d16:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d1b:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801d20:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801d27:	a1 20 51 80 00       	mov    0x805120,%eax
  801d2c:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801d30:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801d33:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801d3a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801d3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d40:	01 d0                	add    %edx,%eax
  801d42:	48                   	dec    %eax
  801d43:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d46:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d49:	ba 00 00 00 00       	mov    $0x0,%edx
  801d4e:	f7 75 e4             	divl   -0x1c(%ebp)
  801d51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801d54:	29 d0                	sub    %edx,%eax
  801d56:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801d59:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801d60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d63:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d68:	2d 00 10 00 00       	sub    $0x1000,%eax
  801d6d:	83 ec 04             	sub    $0x4,%esp
  801d70:	6a 07                	push   $0x7
  801d72:	ff 75 e8             	pushl  -0x18(%ebp)
  801d75:	50                   	push   %eax
  801d76:	e8 3d 06 00 00       	call   8023b8 <sys_allocate_chunk>
  801d7b:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801d7e:	a1 20 51 80 00       	mov    0x805120,%eax
  801d83:	83 ec 0c             	sub    $0xc,%esp
  801d86:	50                   	push   %eax
  801d87:	e8 b2 0c 00 00       	call   802a3e <initialize_MemBlocksList>
  801d8c:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801d8f:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801d94:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801d97:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801d9b:	0f 84 f3 00 00 00    	je     801e94 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801da1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801da5:	75 14                	jne    801dbb <initialize_dyn_block_system+0x108>
  801da7:	83 ec 04             	sub    $0x4,%esp
  801daa:	68 15 43 80 00       	push   $0x804315
  801daf:	6a 36                	push   $0x36
  801db1:	68 33 43 80 00       	push   $0x804333
  801db6:	e8 89 ee ff ff       	call   800c44 <_panic>
  801dbb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dbe:	8b 00                	mov    (%eax),%eax
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	74 10                	je     801dd4 <initialize_dyn_block_system+0x121>
  801dc4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dc7:	8b 00                	mov    (%eax),%eax
  801dc9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801dcc:	8b 52 04             	mov    0x4(%edx),%edx
  801dcf:	89 50 04             	mov    %edx,0x4(%eax)
  801dd2:	eb 0b                	jmp    801ddf <initialize_dyn_block_system+0x12c>
  801dd4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dd7:	8b 40 04             	mov    0x4(%eax),%eax
  801dda:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ddf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801de2:	8b 40 04             	mov    0x4(%eax),%eax
  801de5:	85 c0                	test   %eax,%eax
  801de7:	74 0f                	je     801df8 <initialize_dyn_block_system+0x145>
  801de9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dec:	8b 40 04             	mov    0x4(%eax),%eax
  801def:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801df2:	8b 12                	mov    (%edx),%edx
  801df4:	89 10                	mov    %edx,(%eax)
  801df6:	eb 0a                	jmp    801e02 <initialize_dyn_block_system+0x14f>
  801df8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dfb:	8b 00                	mov    (%eax),%eax
  801dfd:	a3 48 51 80 00       	mov    %eax,0x805148
  801e02:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e05:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e0e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e15:	a1 54 51 80 00       	mov    0x805154,%eax
  801e1a:	48                   	dec    %eax
  801e1b:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801e20:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e23:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801e2a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e2d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801e34:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801e38:	75 14                	jne    801e4e <initialize_dyn_block_system+0x19b>
  801e3a:	83 ec 04             	sub    $0x4,%esp
  801e3d:	68 40 43 80 00       	push   $0x804340
  801e42:	6a 3e                	push   $0x3e
  801e44:	68 33 43 80 00       	push   $0x804333
  801e49:	e8 f6 ed ff ff       	call   800c44 <_panic>
  801e4e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801e54:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e57:	89 10                	mov    %edx,(%eax)
  801e59:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e5c:	8b 00                	mov    (%eax),%eax
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	74 0d                	je     801e6f <initialize_dyn_block_system+0x1bc>
  801e62:	a1 38 51 80 00       	mov    0x805138,%eax
  801e67:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e6a:	89 50 04             	mov    %edx,0x4(%eax)
  801e6d:	eb 08                	jmp    801e77 <initialize_dyn_block_system+0x1c4>
  801e6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e72:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801e77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e7a:	a3 38 51 80 00       	mov    %eax,0x805138
  801e7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e89:	a1 44 51 80 00       	mov    0x805144,%eax
  801e8e:	40                   	inc    %eax
  801e8f:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801e94:	90                   	nop
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801e9d:	e8 e0 fd ff ff       	call   801c82 <InitializeUHeap>
		if (size == 0) return NULL ;
  801ea2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ea6:	75 07                	jne    801eaf <malloc+0x18>
  801ea8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ead:	eb 7f                	jmp    801f2e <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801eaf:	e8 d2 08 00 00       	call   802786 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	74 71                	je     801f29 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801eb8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  801ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec5:	01 d0                	add    %edx,%eax
  801ec7:	48                   	dec    %eax
  801ec8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801ecb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ece:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed3:	f7 75 f4             	divl   -0xc(%ebp)
  801ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed9:	29 d0                	sub    %edx,%eax
  801edb:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801ede:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801ee5:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801eec:	76 07                	jbe    801ef5 <malloc+0x5e>
					return NULL ;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef3:	eb 39                	jmp    801f2e <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801ef5:	83 ec 0c             	sub    $0xc,%esp
  801ef8:	ff 75 08             	pushl  0x8(%ebp)
  801efb:	e8 e6 0d 00 00       	call   802ce6 <alloc_block_FF>
  801f00:	83 c4 10             	add    $0x10,%esp
  801f03:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801f06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801f0a:	74 16                	je     801f22 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801f0c:	83 ec 0c             	sub    $0xc,%esp
  801f0f:	ff 75 ec             	pushl  -0x14(%ebp)
  801f12:	e8 37 0c 00 00       	call   802b4e <insert_sorted_allocList>
  801f17:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f1d:	8b 40 08             	mov    0x8(%eax),%eax
  801f20:	eb 0c                	jmp    801f2e <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801f22:	b8 00 00 00 00       	mov    $0x0,%eax
  801f27:	eb 05                	jmp    801f2e <malloc+0x97>
				}
		}
	return 0;
  801f29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801f3c:	83 ec 08             	sub    $0x8,%esp
  801f3f:	ff 75 f4             	pushl  -0xc(%ebp)
  801f42:	68 40 50 80 00       	push   $0x805040
  801f47:	e8 cf 0b 00 00       	call   802b1b <find_block>
  801f4c:	83 c4 10             	add    $0x10,%esp
  801f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801f52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f55:	8b 40 0c             	mov    0xc(%eax),%eax
  801f58:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801f5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5e:	8b 40 08             	mov    0x8(%eax),%eax
  801f61:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801f64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f68:	0f 84 a1 00 00 00    	je     80200f <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801f6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f72:	75 17                	jne    801f8b <free+0x5b>
  801f74:	83 ec 04             	sub    $0x4,%esp
  801f77:	68 15 43 80 00       	push   $0x804315
  801f7c:	68 80 00 00 00       	push   $0x80
  801f81:	68 33 43 80 00       	push   $0x804333
  801f86:	e8 b9 ec ff ff       	call   800c44 <_panic>
  801f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8e:	8b 00                	mov    (%eax),%eax
  801f90:	85 c0                	test   %eax,%eax
  801f92:	74 10                	je     801fa4 <free+0x74>
  801f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f97:	8b 00                	mov    (%eax),%eax
  801f99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f9c:	8b 52 04             	mov    0x4(%edx),%edx
  801f9f:	89 50 04             	mov    %edx,0x4(%eax)
  801fa2:	eb 0b                	jmp    801faf <free+0x7f>
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	8b 40 04             	mov    0x4(%eax),%eax
  801faa:	a3 44 50 80 00       	mov    %eax,0x805044
  801faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb2:	8b 40 04             	mov    0x4(%eax),%eax
  801fb5:	85 c0                	test   %eax,%eax
  801fb7:	74 0f                	je     801fc8 <free+0x98>
  801fb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbc:	8b 40 04             	mov    0x4(%eax),%eax
  801fbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fc2:	8b 12                	mov    (%edx),%edx
  801fc4:	89 10                	mov    %edx,(%eax)
  801fc6:	eb 0a                	jmp    801fd2 <free+0xa2>
  801fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcb:	8b 00                	mov    (%eax),%eax
  801fcd:	a3 40 50 80 00       	mov    %eax,0x805040
  801fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fde:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fe5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801fea:	48                   	dec    %eax
  801feb:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801ff0:	83 ec 0c             	sub    $0xc,%esp
  801ff3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ff6:	e8 29 12 00 00       	call   803224 <insert_sorted_with_merge_freeList>
  801ffb:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801ffe:	83 ec 08             	sub    $0x8,%esp
  802001:	ff 75 ec             	pushl  -0x14(%ebp)
  802004:	ff 75 e8             	pushl  -0x18(%ebp)
  802007:	e8 74 03 00 00       	call   802380 <sys_free_user_mem>
  80200c:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80200f:	90                   	nop
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 38             	sub    $0x38,%esp
  802018:	8b 45 10             	mov    0x10(%ebp),%eax
  80201b:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80201e:	e8 5f fc ff ff       	call   801c82 <InitializeUHeap>
	if (size == 0) return NULL ;
  802023:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802027:	75 0a                	jne    802033 <smalloc+0x21>
  802029:	b8 00 00 00 00       	mov    $0x0,%eax
  80202e:	e9 b2 00 00 00       	jmp    8020e5 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  802033:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80203a:	76 0a                	jbe    802046 <smalloc+0x34>
		return NULL;
  80203c:	b8 00 00 00 00       	mov    $0x0,%eax
  802041:	e9 9f 00 00 00       	jmp    8020e5 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  802046:	e8 3b 07 00 00       	call   802786 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80204b:	85 c0                	test   %eax,%eax
  80204d:	0f 84 8d 00 00 00    	je     8020e0 <smalloc+0xce>
	struct MemBlock *b = NULL;
  802053:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80205a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802061:	8b 55 0c             	mov    0xc(%ebp),%edx
  802064:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802067:	01 d0                	add    %edx,%eax
  802069:	48                   	dec    %eax
  80206a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80206d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802070:	ba 00 00 00 00       	mov    $0x0,%edx
  802075:	f7 75 f0             	divl   -0x10(%ebp)
  802078:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80207b:	29 d0                	sub    %edx,%eax
  80207d:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  802080:	83 ec 0c             	sub    $0xc,%esp
  802083:	ff 75 e8             	pushl  -0x18(%ebp)
  802086:	e8 5b 0c 00 00       	call   802ce6 <alloc_block_FF>
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  802091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802095:	75 07                	jne    80209e <smalloc+0x8c>
			return NULL;
  802097:	b8 00 00 00 00       	mov    $0x0,%eax
  80209c:	eb 47                	jmp    8020e5 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  80209e:	83 ec 0c             	sub    $0xc,%esp
  8020a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8020a4:	e8 a5 0a 00 00       	call   802b4e <insert_sorted_allocList>
  8020a9:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	8b 40 08             	mov    0x8(%eax),%eax
  8020b2:	89 c2                	mov    %eax,%edx
  8020b4:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8020b8:	52                   	push   %edx
  8020b9:	50                   	push   %eax
  8020ba:	ff 75 0c             	pushl  0xc(%ebp)
  8020bd:	ff 75 08             	pushl  0x8(%ebp)
  8020c0:	e8 46 04 00 00       	call   80250b <sys_createSharedObject>
  8020c5:	83 c4 10             	add    $0x10,%esp
  8020c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8020cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8020cf:	78 08                	js     8020d9 <smalloc+0xc7>
		return (void *)b->sva;
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	8b 40 08             	mov    0x8(%eax),%eax
  8020d7:	eb 0c                	jmp    8020e5 <smalloc+0xd3>
		}else{
		return NULL;
  8020d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8020de:	eb 05                	jmp    8020e5 <smalloc+0xd3>
			}

	}return NULL;
  8020e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    

008020e7 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8020e7:	55                   	push   %ebp
  8020e8:	89 e5                	mov    %esp,%ebp
  8020ea:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8020ed:	e8 90 fb ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8020f2:	e8 8f 06 00 00       	call   802786 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	0f 84 ad 00 00 00    	je     8021ac <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8020ff:	83 ec 08             	sub    $0x8,%esp
  802102:	ff 75 0c             	pushl  0xc(%ebp)
  802105:	ff 75 08             	pushl  0x8(%ebp)
  802108:	e8 28 04 00 00       	call   802535 <sys_getSizeOfSharedObject>
  80210d:	83 c4 10             	add    $0x10,%esp
  802110:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  802113:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802117:	79 0a                	jns    802123 <sget+0x3c>
    {
    	return NULL;
  802119:	b8 00 00 00 00       	mov    $0x0,%eax
  80211e:	e9 8e 00 00 00       	jmp    8021b1 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  802123:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80212a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802131:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802134:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802137:	01 d0                	add    %edx,%eax
  802139:	48                   	dec    %eax
  80213a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80213d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802140:	ba 00 00 00 00       	mov    $0x0,%edx
  802145:	f7 75 ec             	divl   -0x14(%ebp)
  802148:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80214b:	29 d0                	sub    %edx,%eax
  80214d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  802150:	83 ec 0c             	sub    $0xc,%esp
  802153:	ff 75 e4             	pushl  -0x1c(%ebp)
  802156:	e8 8b 0b 00 00       	call   802ce6 <alloc_block_FF>
  80215b:	83 c4 10             	add    $0x10,%esp
  80215e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  802161:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802165:	75 07                	jne    80216e <sget+0x87>
				return NULL;
  802167:	b8 00 00 00 00       	mov    $0x0,%eax
  80216c:	eb 43                	jmp    8021b1 <sget+0xca>
			}
			insert_sorted_allocList(b);
  80216e:	83 ec 0c             	sub    $0xc,%esp
  802171:	ff 75 f0             	pushl  -0x10(%ebp)
  802174:	e8 d5 09 00 00       	call   802b4e <insert_sorted_allocList>
  802179:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  80217c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80217f:	8b 40 08             	mov    0x8(%eax),%eax
  802182:	83 ec 04             	sub    $0x4,%esp
  802185:	50                   	push   %eax
  802186:	ff 75 0c             	pushl  0xc(%ebp)
  802189:	ff 75 08             	pushl  0x8(%ebp)
  80218c:	e8 c1 03 00 00       	call   802552 <sys_getSharedObject>
  802191:	83 c4 10             	add    $0x10,%esp
  802194:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  802197:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80219b:	78 08                	js     8021a5 <sget+0xbe>
			return (void *)b->sva;
  80219d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021a0:	8b 40 08             	mov    0x8(%eax),%eax
  8021a3:	eb 0c                	jmp    8021b1 <sget+0xca>
			}else{
			return NULL;
  8021a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8021aa:	eb 05                	jmp    8021b1 <sget+0xca>
			}
    }}return NULL;
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8021b9:	e8 c4 fa ff ff       	call   801c82 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8021be:	83 ec 04             	sub    $0x4,%esp
  8021c1:	68 64 43 80 00       	push   $0x804364
  8021c6:	68 03 01 00 00       	push   $0x103
  8021cb:	68 33 43 80 00       	push   $0x804333
  8021d0:	e8 6f ea ff ff       	call   800c44 <_panic>

008021d5 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
  8021d8:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8021db:	83 ec 04             	sub    $0x4,%esp
  8021de:	68 8c 43 80 00       	push   $0x80438c
  8021e3:	68 17 01 00 00       	push   $0x117
  8021e8:	68 33 43 80 00       	push   $0x804333
  8021ed:	e8 52 ea ff ff       	call   800c44 <_panic>

008021f2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8021f2:	55                   	push   %ebp
  8021f3:	89 e5                	mov    %esp,%ebp
  8021f5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8021f8:	83 ec 04             	sub    $0x4,%esp
  8021fb:	68 b0 43 80 00       	push   $0x8043b0
  802200:	68 22 01 00 00       	push   $0x122
  802205:	68 33 43 80 00       	push   $0x804333
  80220a:	e8 35 ea ff ff       	call   800c44 <_panic>

0080220f <shrink>:

}
void shrink(uint32 newSize)
{
  80220f:	55                   	push   %ebp
  802210:	89 e5                	mov    %esp,%ebp
  802212:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802215:	83 ec 04             	sub    $0x4,%esp
  802218:	68 b0 43 80 00       	push   $0x8043b0
  80221d:	68 27 01 00 00       	push   $0x127
  802222:	68 33 43 80 00       	push   $0x804333
  802227:	e8 18 ea ff ff       	call   800c44 <_panic>

0080222c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	68 b0 43 80 00       	push   $0x8043b0
  80223a:	68 2c 01 00 00       	push   $0x12c
  80223f:	68 33 43 80 00       	push   $0x804333
  802244:	e8 fb e9 ff ff       	call   800c44 <_panic>

00802249 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802249:	55                   	push   %ebp
  80224a:	89 e5                	mov    %esp,%ebp
  80224c:	57                   	push   %edi
  80224d:	56                   	push   %esi
  80224e:	53                   	push   %ebx
  80224f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	8b 55 0c             	mov    0xc(%ebp),%edx
  802258:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80225b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80225e:	8b 7d 18             	mov    0x18(%ebp),%edi
  802261:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802264:	cd 30                	int    $0x30
  802266:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802269:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80226c:	83 c4 10             	add    $0x10,%esp
  80226f:	5b                   	pop    %ebx
  802270:	5e                   	pop    %esi
  802271:	5f                   	pop    %edi
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    

00802274 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 04             	sub    $0x4,%esp
  80227a:	8b 45 10             	mov    0x10(%ebp),%eax
  80227d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802280:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	52                   	push   %edx
  80228c:	ff 75 0c             	pushl  0xc(%ebp)
  80228f:	50                   	push   %eax
  802290:	6a 00                	push   $0x0
  802292:	e8 b2 ff ff ff       	call   802249 <syscall>
  802297:	83 c4 18             	add    $0x18,%esp
}
  80229a:	90                   	nop
  80229b:	c9                   	leave  
  80229c:	c3                   	ret    

0080229d <sys_cgetc>:

int
sys_cgetc(void)
{
  80229d:	55                   	push   %ebp
  80229e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 00                	push   $0x0
  8022aa:	6a 01                	push   $0x1
  8022ac:	e8 98 ff ff ff       	call   802249 <syscall>
  8022b1:	83 c4 18             	add    $0x18,%esp
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8022b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bf:	6a 00                	push   $0x0
  8022c1:	6a 00                	push   $0x0
  8022c3:	6a 00                	push   $0x0
  8022c5:	52                   	push   %edx
  8022c6:	50                   	push   %eax
  8022c7:	6a 05                	push   $0x5
  8022c9:	e8 7b ff ff ff       	call   802249 <syscall>
  8022ce:	83 c4 18             	add    $0x18,%esp
}
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	56                   	push   %esi
  8022d7:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8022d8:	8b 75 18             	mov    0x18(%ebp),%esi
  8022db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022de:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	56                   	push   %esi
  8022e8:	53                   	push   %ebx
  8022e9:	51                   	push   %ecx
  8022ea:	52                   	push   %edx
  8022eb:	50                   	push   %eax
  8022ec:	6a 06                	push   $0x6
  8022ee:	e8 56 ff ff ff       	call   802249 <syscall>
  8022f3:	83 c4 18             	add    $0x18,%esp
}
  8022f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022f9:	5b                   	pop    %ebx
  8022fa:	5e                   	pop    %esi
  8022fb:	5d                   	pop    %ebp
  8022fc:	c3                   	ret    

008022fd <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802300:	8b 55 0c             	mov    0xc(%ebp),%edx
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 00                	push   $0x0
  80230c:	52                   	push   %edx
  80230d:	50                   	push   %eax
  80230e:	6a 07                	push   $0x7
  802310:	e8 34 ff ff ff       	call   802249 <syscall>
  802315:	83 c4 18             	add    $0x18,%esp
}
  802318:	c9                   	leave  
  802319:	c3                   	ret    

0080231a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80231a:	55                   	push   %ebp
  80231b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	ff 75 0c             	pushl  0xc(%ebp)
  802326:	ff 75 08             	pushl  0x8(%ebp)
  802329:	6a 08                	push   $0x8
  80232b:	e8 19 ff ff ff       	call   802249 <syscall>
  802330:	83 c4 18             	add    $0x18,%esp
}
  802333:	c9                   	leave  
  802334:	c3                   	ret    

00802335 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 09                	push   $0x9
  802344:	e8 00 ff ff ff       	call   802249 <syscall>
  802349:	83 c4 18             	add    $0x18,%esp
}
  80234c:	c9                   	leave  
  80234d:	c3                   	ret    

0080234e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80234e:	55                   	push   %ebp
  80234f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802351:	6a 00                	push   $0x0
  802353:	6a 00                	push   $0x0
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 0a                	push   $0xa
  80235d:	e8 e7 fe ff ff       	call   802249 <syscall>
  802362:	83 c4 18             	add    $0x18,%esp
}
  802365:	c9                   	leave  
  802366:	c3                   	ret    

00802367 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802367:	55                   	push   %ebp
  802368:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80236a:	6a 00                	push   $0x0
  80236c:	6a 00                	push   $0x0
  80236e:	6a 00                	push   $0x0
  802370:	6a 00                	push   $0x0
  802372:	6a 00                	push   $0x0
  802374:	6a 0b                	push   $0xb
  802376:	e8 ce fe ff ff       	call   802249 <syscall>
  80237b:	83 c4 18             	add    $0x18,%esp
}
  80237e:	c9                   	leave  
  80237f:	c3                   	ret    

00802380 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802383:	6a 00                	push   $0x0
  802385:	6a 00                	push   $0x0
  802387:	6a 00                	push   $0x0
  802389:	ff 75 0c             	pushl  0xc(%ebp)
  80238c:	ff 75 08             	pushl  0x8(%ebp)
  80238f:	6a 0f                	push   $0xf
  802391:	e8 b3 fe ff ff       	call   802249 <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
	return;
  802399:	90                   	nop
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	ff 75 0c             	pushl  0xc(%ebp)
  8023a8:	ff 75 08             	pushl  0x8(%ebp)
  8023ab:	6a 10                	push   $0x10
  8023ad:	e8 97 fe ff ff       	call   802249 <syscall>
  8023b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b5:	90                   	nop
}
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8023bb:	6a 00                	push   $0x0
  8023bd:	6a 00                	push   $0x0
  8023bf:	ff 75 10             	pushl  0x10(%ebp)
  8023c2:	ff 75 0c             	pushl  0xc(%ebp)
  8023c5:	ff 75 08             	pushl  0x8(%ebp)
  8023c8:	6a 11                	push   $0x11
  8023ca:	e8 7a fe ff ff       	call   802249 <syscall>
  8023cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d2:	90                   	nop
}
  8023d3:	c9                   	leave  
  8023d4:	c3                   	ret    

008023d5 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8023d5:	55                   	push   %ebp
  8023d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8023d8:	6a 00                	push   $0x0
  8023da:	6a 00                	push   $0x0
  8023dc:	6a 00                	push   $0x0
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 0c                	push   $0xc
  8023e4:	e8 60 fe ff ff       	call   802249 <syscall>
  8023e9:	83 c4 18             	add    $0x18,%esp
}
  8023ec:	c9                   	leave  
  8023ed:	c3                   	ret    

008023ee <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8023ee:	55                   	push   %ebp
  8023ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8023f1:	6a 00                	push   $0x0
  8023f3:	6a 00                	push   $0x0
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	ff 75 08             	pushl  0x8(%ebp)
  8023fc:	6a 0d                	push   $0xd
  8023fe:	e8 46 fe ff ff       	call   802249 <syscall>
  802403:	83 c4 18             	add    $0x18,%esp
}
  802406:	c9                   	leave  
  802407:	c3                   	ret    

00802408 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802408:	55                   	push   %ebp
  802409:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	6a 00                	push   $0x0
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 0e                	push   $0xe
  802417:	e8 2d fe ff ff       	call   802249 <syscall>
  80241c:	83 c4 18             	add    $0x18,%esp
}
  80241f:	90                   	nop
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	6a 00                	push   $0x0
  80242f:	6a 13                	push   $0x13
  802431:	e8 13 fe ff ff       	call   802249 <syscall>
  802436:	83 c4 18             	add    $0x18,%esp
}
  802439:	90                   	nop
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80243f:	6a 00                	push   $0x0
  802441:	6a 00                	push   $0x0
  802443:	6a 00                	push   $0x0
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 14                	push   $0x14
  80244b:	e8 f9 fd ff ff       	call   802249 <syscall>
  802450:	83 c4 18             	add    $0x18,%esp
}
  802453:	90                   	nop
  802454:	c9                   	leave  
  802455:	c3                   	ret    

00802456 <sys_cputc>:


void
sys_cputc(const char c)
{
  802456:	55                   	push   %ebp
  802457:	89 e5                	mov    %esp,%ebp
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802462:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802466:	6a 00                	push   $0x0
  802468:	6a 00                	push   $0x0
  80246a:	6a 00                	push   $0x0
  80246c:	6a 00                	push   $0x0
  80246e:	50                   	push   %eax
  80246f:	6a 15                	push   $0x15
  802471:	e8 d3 fd ff ff       	call   802249 <syscall>
  802476:	83 c4 18             	add    $0x18,%esp
}
  802479:	90                   	nop
  80247a:	c9                   	leave  
  80247b:	c3                   	ret    

0080247c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80247c:	55                   	push   %ebp
  80247d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80247f:	6a 00                	push   $0x0
  802481:	6a 00                	push   $0x0
  802483:	6a 00                	push   $0x0
  802485:	6a 00                	push   $0x0
  802487:	6a 00                	push   $0x0
  802489:	6a 16                	push   $0x16
  80248b:	e8 b9 fd ff ff       	call   802249 <syscall>
  802490:	83 c4 18             	add    $0x18,%esp
}
  802493:	90                   	nop
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	6a 00                	push   $0x0
  80249e:	6a 00                	push   $0x0
  8024a0:	6a 00                	push   $0x0
  8024a2:	ff 75 0c             	pushl  0xc(%ebp)
  8024a5:	50                   	push   %eax
  8024a6:	6a 17                	push   $0x17
  8024a8:	e8 9c fd ff ff       	call   802249 <syscall>
  8024ad:	83 c4 18             	add    $0x18,%esp
}
  8024b0:	c9                   	leave  
  8024b1:	c3                   	ret    

008024b2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bb:	6a 00                	push   $0x0
  8024bd:	6a 00                	push   $0x0
  8024bf:	6a 00                	push   $0x0
  8024c1:	52                   	push   %edx
  8024c2:	50                   	push   %eax
  8024c3:	6a 1a                	push   $0x1a
  8024c5:	e8 7f fd ff ff       	call   802249 <syscall>
  8024ca:	83 c4 18             	add    $0x18,%esp
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	52                   	push   %edx
  8024df:	50                   	push   %eax
  8024e0:	6a 18                	push   $0x18
  8024e2:	e8 62 fd ff ff       	call   802249 <syscall>
  8024e7:	83 c4 18             	add    $0x18,%esp
}
  8024ea:	90                   	nop
  8024eb:	c9                   	leave  
  8024ec:	c3                   	ret    

008024ed <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8024f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f6:	6a 00                	push   $0x0
  8024f8:	6a 00                	push   $0x0
  8024fa:	6a 00                	push   $0x0
  8024fc:	52                   	push   %edx
  8024fd:	50                   	push   %eax
  8024fe:	6a 19                	push   $0x19
  802500:	e8 44 fd ff ff       	call   802249 <syscall>
  802505:	83 c4 18             	add    $0x18,%esp
}
  802508:	90                   	nop
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
  80250e:	83 ec 04             	sub    $0x4,%esp
  802511:	8b 45 10             	mov    0x10(%ebp),%eax
  802514:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802517:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80251a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	6a 00                	push   $0x0
  802523:	51                   	push   %ecx
  802524:	52                   	push   %edx
  802525:	ff 75 0c             	pushl  0xc(%ebp)
  802528:	50                   	push   %eax
  802529:	6a 1b                	push   $0x1b
  80252b:	e8 19 fd ff ff       	call   802249 <syscall>
  802530:	83 c4 18             	add    $0x18,%esp
}
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802538:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	52                   	push   %edx
  802545:	50                   	push   %eax
  802546:	6a 1c                	push   $0x1c
  802548:	e8 fc fc ff ff       	call   802249 <syscall>
  80254d:	83 c4 18             	add    $0x18,%esp
}
  802550:	c9                   	leave  
  802551:	c3                   	ret    

00802552 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802555:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	6a 00                	push   $0x0
  802560:	6a 00                	push   $0x0
  802562:	51                   	push   %ecx
  802563:	52                   	push   %edx
  802564:	50                   	push   %eax
  802565:	6a 1d                	push   $0x1d
  802567:	e8 dd fc ff ff       	call   802249 <syscall>
  80256c:	83 c4 18             	add    $0x18,%esp
}
  80256f:	c9                   	leave  
  802570:	c3                   	ret    

00802571 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802571:	55                   	push   %ebp
  802572:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802574:	8b 55 0c             	mov    0xc(%ebp),%edx
  802577:	8b 45 08             	mov    0x8(%ebp),%eax
  80257a:	6a 00                	push   $0x0
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	52                   	push   %edx
  802581:	50                   	push   %eax
  802582:	6a 1e                	push   $0x1e
  802584:	e8 c0 fc ff ff       	call   802249 <syscall>
  802589:	83 c4 18             	add    $0x18,%esp
}
  80258c:	c9                   	leave  
  80258d:	c3                   	ret    

0080258e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80258e:	55                   	push   %ebp
  80258f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802591:	6a 00                	push   $0x0
  802593:	6a 00                	push   $0x0
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 1f                	push   $0x1f
  80259d:	e8 a7 fc ff ff       	call   802249 <syscall>
  8025a2:	83 c4 18             	add    $0x18,%esp
}
  8025a5:	c9                   	leave  
  8025a6:	c3                   	ret    

008025a7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8025a7:	55                   	push   %ebp
  8025a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8025aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ad:	6a 00                	push   $0x0
  8025af:	ff 75 14             	pushl  0x14(%ebp)
  8025b2:	ff 75 10             	pushl  0x10(%ebp)
  8025b5:	ff 75 0c             	pushl  0xc(%ebp)
  8025b8:	50                   	push   %eax
  8025b9:	6a 20                	push   $0x20
  8025bb:	e8 89 fc ff ff       	call   802249 <syscall>
  8025c0:	83 c4 18             	add    $0x18,%esp
}
  8025c3:	c9                   	leave  
  8025c4:	c3                   	ret    

008025c5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8025c5:	55                   	push   %ebp
  8025c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	6a 00                	push   $0x0
  8025cd:	6a 00                	push   $0x0
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	50                   	push   %eax
  8025d4:	6a 21                	push   $0x21
  8025d6:	e8 6e fc ff ff       	call   802249 <syscall>
  8025db:	83 c4 18             	add    $0x18,%esp
}
  8025de:	90                   	nop
  8025df:	c9                   	leave  
  8025e0:	c3                   	ret    

008025e1 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8025e1:	55                   	push   %ebp
  8025e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8025e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e7:	6a 00                	push   $0x0
  8025e9:	6a 00                	push   $0x0
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	50                   	push   %eax
  8025f0:	6a 22                	push   $0x22
  8025f2:	e8 52 fc ff ff       	call   802249 <syscall>
  8025f7:	83 c4 18             	add    $0x18,%esp
}
  8025fa:	c9                   	leave  
  8025fb:	c3                   	ret    

008025fc <sys_getenvid>:

int32 sys_getenvid(void)
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8025ff:	6a 00                	push   $0x0
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	6a 00                	push   $0x0
  802609:	6a 02                	push   $0x2
  80260b:	e8 39 fc ff ff       	call   802249 <syscall>
  802610:	83 c4 18             	add    $0x18,%esp
}
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802618:	6a 00                	push   $0x0
  80261a:	6a 00                	push   $0x0
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 03                	push   $0x3
  802624:	e8 20 fc ff ff       	call   802249 <syscall>
  802629:	83 c4 18             	add    $0x18,%esp
}
  80262c:	c9                   	leave  
  80262d:	c3                   	ret    

0080262e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80262e:	55                   	push   %ebp
  80262f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802631:	6a 00                	push   $0x0
  802633:	6a 00                	push   $0x0
  802635:	6a 00                	push   $0x0
  802637:	6a 00                	push   $0x0
  802639:	6a 00                	push   $0x0
  80263b:	6a 04                	push   $0x4
  80263d:	e8 07 fc ff ff       	call   802249 <syscall>
  802642:	83 c4 18             	add    $0x18,%esp
}
  802645:	c9                   	leave  
  802646:	c3                   	ret    

00802647 <sys_exit_env>:


void sys_exit_env(void)
{
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80264a:	6a 00                	push   $0x0
  80264c:	6a 00                	push   $0x0
  80264e:	6a 00                	push   $0x0
  802650:	6a 00                	push   $0x0
  802652:	6a 00                	push   $0x0
  802654:	6a 23                	push   $0x23
  802656:	e8 ee fb ff ff       	call   802249 <syscall>
  80265b:	83 c4 18             	add    $0x18,%esp
}
  80265e:	90                   	nop
  80265f:	c9                   	leave  
  802660:	c3                   	ret    

00802661 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
  802664:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802667:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80266a:	8d 50 04             	lea    0x4(%eax),%edx
  80266d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802670:	6a 00                	push   $0x0
  802672:	6a 00                	push   $0x0
  802674:	6a 00                	push   $0x0
  802676:	52                   	push   %edx
  802677:	50                   	push   %eax
  802678:	6a 24                	push   $0x24
  80267a:	e8 ca fb ff ff       	call   802249 <syscall>
  80267f:	83 c4 18             	add    $0x18,%esp
	return result;
  802682:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802685:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802688:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80268b:	89 01                	mov    %eax,(%ecx)
  80268d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802690:	8b 45 08             	mov    0x8(%ebp),%eax
  802693:	c9                   	leave  
  802694:	c2 04 00             	ret    $0x4

00802697 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802697:	55                   	push   %ebp
  802698:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80269a:	6a 00                	push   $0x0
  80269c:	6a 00                	push   $0x0
  80269e:	ff 75 10             	pushl  0x10(%ebp)
  8026a1:	ff 75 0c             	pushl  0xc(%ebp)
  8026a4:	ff 75 08             	pushl  0x8(%ebp)
  8026a7:	6a 12                	push   $0x12
  8026a9:	e8 9b fb ff ff       	call   802249 <syscall>
  8026ae:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b1:	90                   	nop
}
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <sys_rcr2>:
uint32 sys_rcr2()
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8026b7:	6a 00                	push   $0x0
  8026b9:	6a 00                	push   $0x0
  8026bb:	6a 00                	push   $0x0
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 25                	push   $0x25
  8026c3:	e8 81 fb ff ff       	call   802249 <syscall>
  8026c8:	83 c4 18             	add    $0x18,%esp
}
  8026cb:	c9                   	leave  
  8026cc:	c3                   	ret    

008026cd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
  8026d0:	83 ec 04             	sub    $0x4,%esp
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8026d9:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8026dd:	6a 00                	push   $0x0
  8026df:	6a 00                	push   $0x0
  8026e1:	6a 00                	push   $0x0
  8026e3:	6a 00                	push   $0x0
  8026e5:	50                   	push   %eax
  8026e6:	6a 26                	push   $0x26
  8026e8:	e8 5c fb ff ff       	call   802249 <syscall>
  8026ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8026f0:	90                   	nop
}
  8026f1:	c9                   	leave  
  8026f2:	c3                   	ret    

008026f3 <rsttst>:
void rsttst()
{
  8026f3:	55                   	push   %ebp
  8026f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	6a 28                	push   $0x28
  802702:	e8 42 fb ff ff       	call   802249 <syscall>
  802707:	83 c4 18             	add    $0x18,%esp
	return ;
  80270a:	90                   	nop
}
  80270b:	c9                   	leave  
  80270c:	c3                   	ret    

0080270d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80270d:	55                   	push   %ebp
  80270e:	89 e5                	mov    %esp,%ebp
  802710:	83 ec 04             	sub    $0x4,%esp
  802713:	8b 45 14             	mov    0x14(%ebp),%eax
  802716:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802719:	8b 55 18             	mov    0x18(%ebp),%edx
  80271c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802720:	52                   	push   %edx
  802721:	50                   	push   %eax
  802722:	ff 75 10             	pushl  0x10(%ebp)
  802725:	ff 75 0c             	pushl  0xc(%ebp)
  802728:	ff 75 08             	pushl  0x8(%ebp)
  80272b:	6a 27                	push   $0x27
  80272d:	e8 17 fb ff ff       	call   802249 <syscall>
  802732:	83 c4 18             	add    $0x18,%esp
	return ;
  802735:	90                   	nop
}
  802736:	c9                   	leave  
  802737:	c3                   	ret    

00802738 <chktst>:
void chktst(uint32 n)
{
  802738:	55                   	push   %ebp
  802739:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	6a 00                	push   $0x0
  802741:	6a 00                	push   $0x0
  802743:	ff 75 08             	pushl  0x8(%ebp)
  802746:	6a 29                	push   $0x29
  802748:	e8 fc fa ff ff       	call   802249 <syscall>
  80274d:	83 c4 18             	add    $0x18,%esp
	return ;
  802750:	90                   	nop
}
  802751:	c9                   	leave  
  802752:	c3                   	ret    

00802753 <inctst>:

void inctst()
{
  802753:	55                   	push   %ebp
  802754:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	6a 00                	push   $0x0
  80275e:	6a 00                	push   $0x0
  802760:	6a 2a                	push   $0x2a
  802762:	e8 e2 fa ff ff       	call   802249 <syscall>
  802767:	83 c4 18             	add    $0x18,%esp
	return ;
  80276a:	90                   	nop
}
  80276b:	c9                   	leave  
  80276c:	c3                   	ret    

0080276d <gettst>:
uint32 gettst()
{
  80276d:	55                   	push   %ebp
  80276e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802770:	6a 00                	push   $0x0
  802772:	6a 00                	push   $0x0
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	6a 2b                	push   $0x2b
  80277c:	e8 c8 fa ff ff       	call   802249 <syscall>
  802781:	83 c4 18             	add    $0x18,%esp
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80278c:	6a 00                	push   $0x0
  80278e:	6a 00                	push   $0x0
  802790:	6a 00                	push   $0x0
  802792:	6a 00                	push   $0x0
  802794:	6a 00                	push   $0x0
  802796:	6a 2c                	push   $0x2c
  802798:	e8 ac fa ff ff       	call   802249 <syscall>
  80279d:	83 c4 18             	add    $0x18,%esp
  8027a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8027a3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8027a7:	75 07                	jne    8027b0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8027a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8027ae:	eb 05                	jmp    8027b5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8027b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027b5:	c9                   	leave  
  8027b6:	c3                   	ret    

008027b7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8027b7:	55                   	push   %ebp
  8027b8:	89 e5                	mov    %esp,%ebp
  8027ba:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027bd:	6a 00                	push   $0x0
  8027bf:	6a 00                	push   $0x0
  8027c1:	6a 00                	push   $0x0
  8027c3:	6a 00                	push   $0x0
  8027c5:	6a 00                	push   $0x0
  8027c7:	6a 2c                	push   $0x2c
  8027c9:	e8 7b fa ff ff       	call   802249 <syscall>
  8027ce:	83 c4 18             	add    $0x18,%esp
  8027d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8027d4:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8027d8:	75 07                	jne    8027e1 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8027da:	b8 01 00 00 00       	mov    $0x1,%eax
  8027df:	eb 05                	jmp    8027e6 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8027e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027e6:	c9                   	leave  
  8027e7:	c3                   	ret    

008027e8 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8027e8:	55                   	push   %ebp
  8027e9:	89 e5                	mov    %esp,%ebp
  8027eb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8027ee:	6a 00                	push   $0x0
  8027f0:	6a 00                	push   $0x0
  8027f2:	6a 00                	push   $0x0
  8027f4:	6a 00                	push   $0x0
  8027f6:	6a 00                	push   $0x0
  8027f8:	6a 2c                	push   $0x2c
  8027fa:	e8 4a fa ff ff       	call   802249 <syscall>
  8027ff:	83 c4 18             	add    $0x18,%esp
  802802:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802805:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802809:	75 07                	jne    802812 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80280b:	b8 01 00 00 00       	mov    $0x1,%eax
  802810:	eb 05                	jmp    802817 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802812:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    

00802819 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802819:	55                   	push   %ebp
  80281a:	89 e5                	mov    %esp,%ebp
  80281c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80281f:	6a 00                	push   $0x0
  802821:	6a 00                	push   $0x0
  802823:	6a 00                	push   $0x0
  802825:	6a 00                	push   $0x0
  802827:	6a 00                	push   $0x0
  802829:	6a 2c                	push   $0x2c
  80282b:	e8 19 fa ff ff       	call   802249 <syscall>
  802830:	83 c4 18             	add    $0x18,%esp
  802833:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802836:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80283a:	75 07                	jne    802843 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80283c:	b8 01 00 00 00       	mov    $0x1,%eax
  802841:	eb 05                	jmp    802848 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802843:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802848:	c9                   	leave  
  802849:	c3                   	ret    

0080284a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80284a:	55                   	push   %ebp
  80284b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	6a 00                	push   $0x0
  802853:	6a 00                	push   $0x0
  802855:	ff 75 08             	pushl  0x8(%ebp)
  802858:	6a 2d                	push   $0x2d
  80285a:	e8 ea f9 ff ff       	call   802249 <syscall>
  80285f:	83 c4 18             	add    $0x18,%esp
	return ;
  802862:	90                   	nop
}
  802863:	c9                   	leave  
  802864:	c3                   	ret    

00802865 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802865:	55                   	push   %ebp
  802866:	89 e5                	mov    %esp,%ebp
  802868:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802869:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80286c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80286f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	6a 00                	push   $0x0
  802877:	53                   	push   %ebx
  802878:	51                   	push   %ecx
  802879:	52                   	push   %edx
  80287a:	50                   	push   %eax
  80287b:	6a 2e                	push   $0x2e
  80287d:	e8 c7 f9 ff ff       	call   802249 <syscall>
  802882:	83 c4 18             	add    $0x18,%esp
}
  802885:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802888:	c9                   	leave  
  802889:	c3                   	ret    

0080288a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80288d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	6a 00                	push   $0x0
  802895:	6a 00                	push   $0x0
  802897:	6a 00                	push   $0x0
  802899:	52                   	push   %edx
  80289a:	50                   	push   %eax
  80289b:	6a 2f                	push   $0x2f
  80289d:	e8 a7 f9 ff ff       	call   802249 <syscall>
  8028a2:	83 c4 18             	add    $0x18,%esp
}
  8028a5:	c9                   	leave  
  8028a6:	c3                   	ret    

008028a7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8028a7:	55                   	push   %ebp
  8028a8:	89 e5                	mov    %esp,%ebp
  8028aa:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8028ad:	83 ec 0c             	sub    $0xc,%esp
  8028b0:	68 c0 43 80 00       	push   $0x8043c0
  8028b5:	e8 3e e6 ff ff       	call   800ef8 <cprintf>
  8028ba:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8028bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8028c4:	83 ec 0c             	sub    $0xc,%esp
  8028c7:	68 ec 43 80 00       	push   $0x8043ec
  8028cc:	e8 27 e6 ff ff       	call   800ef8 <cprintf>
  8028d1:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8028d4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8028d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8028dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028e0:	eb 56                	jmp    802938 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028e6:	74 1c                	je     802904 <print_mem_block_lists+0x5d>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	8b 50 08             	mov    0x8(%eax),%edx
  8028ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f1:	8b 48 08             	mov    0x8(%eax),%ecx
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fa:	01 c8                	add    %ecx,%eax
  8028fc:	39 c2                	cmp    %eax,%edx
  8028fe:	73 04                	jae    802904 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802900:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 50 08             	mov    0x8(%eax),%edx
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 40 0c             	mov    0xc(%eax),%eax
  802910:	01 c2                	add    %eax,%edx
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 40 08             	mov    0x8(%eax),%eax
  802918:	83 ec 04             	sub    $0x4,%esp
  80291b:	52                   	push   %edx
  80291c:	50                   	push   %eax
  80291d:	68 01 44 80 00       	push   $0x804401
  802922:	e8 d1 e5 ff ff       	call   800ef8 <cprintf>
  802927:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802930:	a1 40 51 80 00       	mov    0x805140,%eax
  802935:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802938:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293c:	74 07                	je     802945 <print_mem_block_lists+0x9e>
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	eb 05                	jmp    80294a <print_mem_block_lists+0xa3>
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
  80294a:	a3 40 51 80 00       	mov    %eax,0x805140
  80294f:	a1 40 51 80 00       	mov    0x805140,%eax
  802954:	85 c0                	test   %eax,%eax
  802956:	75 8a                	jne    8028e2 <print_mem_block_lists+0x3b>
  802958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295c:	75 84                	jne    8028e2 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80295e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802962:	75 10                	jne    802974 <print_mem_block_lists+0xcd>
  802964:	83 ec 0c             	sub    $0xc,%esp
  802967:	68 10 44 80 00       	push   $0x804410
  80296c:	e8 87 e5 ff ff       	call   800ef8 <cprintf>
  802971:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802974:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80297b:	83 ec 0c             	sub    $0xc,%esp
  80297e:	68 34 44 80 00       	push   $0x804434
  802983:	e8 70 e5 ff ff       	call   800ef8 <cprintf>
  802988:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80298b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80298f:	a1 40 50 80 00       	mov    0x805040,%eax
  802994:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802997:	eb 56                	jmp    8029ef <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802999:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80299d:	74 1c                	je     8029bb <print_mem_block_lists+0x114>
  80299f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a2:	8b 50 08             	mov    0x8(%eax),%edx
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	8b 48 08             	mov    0x8(%eax),%ecx
  8029ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b1:	01 c8                	add    %ecx,%eax
  8029b3:	39 c2                	cmp    %eax,%edx
  8029b5:	73 04                	jae    8029bb <print_mem_block_lists+0x114>
			sorted = 0 ;
  8029b7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 50 08             	mov    0x8(%eax),%edx
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029c7:	01 c2                	add    %eax,%edx
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 40 08             	mov    0x8(%eax),%eax
  8029cf:	83 ec 04             	sub    $0x4,%esp
  8029d2:	52                   	push   %edx
  8029d3:	50                   	push   %eax
  8029d4:	68 01 44 80 00       	push   $0x804401
  8029d9:	e8 1a e5 ff ff       	call   800ef8 <cprintf>
  8029de:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8029e7:	a1 48 50 80 00       	mov    0x805048,%eax
  8029ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f3:	74 07                	je     8029fc <print_mem_block_lists+0x155>
  8029f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f8:	8b 00                	mov    (%eax),%eax
  8029fa:	eb 05                	jmp    802a01 <print_mem_block_lists+0x15a>
  8029fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802a01:	a3 48 50 80 00       	mov    %eax,0x805048
  802a06:	a1 48 50 80 00       	mov    0x805048,%eax
  802a0b:	85 c0                	test   %eax,%eax
  802a0d:	75 8a                	jne    802999 <print_mem_block_lists+0xf2>
  802a0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a13:	75 84                	jne    802999 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802a15:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802a19:	75 10                	jne    802a2b <print_mem_block_lists+0x184>
  802a1b:	83 ec 0c             	sub    $0xc,%esp
  802a1e:	68 4c 44 80 00       	push   $0x80444c
  802a23:	e8 d0 e4 ff ff       	call   800ef8 <cprintf>
  802a28:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802a2b:	83 ec 0c             	sub    $0xc,%esp
  802a2e:	68 c0 43 80 00       	push   $0x8043c0
  802a33:	e8 c0 e4 ff ff       	call   800ef8 <cprintf>
  802a38:	83 c4 10             	add    $0x10,%esp

}
  802a3b:	90                   	nop
  802a3c:	c9                   	leave  
  802a3d:	c3                   	ret    

00802a3e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802a3e:	55                   	push   %ebp
  802a3f:	89 e5                	mov    %esp,%ebp
  802a41:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802a44:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802a4b:	00 00 00 
  802a4e:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802a55:	00 00 00 
  802a58:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802a5f:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802a62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802a69:	e9 9e 00 00 00       	jmp    802b0c <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802a6e:	a1 50 50 80 00       	mov    0x805050,%eax
  802a73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a76:	c1 e2 04             	shl    $0x4,%edx
  802a79:	01 d0                	add    %edx,%eax
  802a7b:	85 c0                	test   %eax,%eax
  802a7d:	75 14                	jne    802a93 <initialize_MemBlocksList+0x55>
  802a7f:	83 ec 04             	sub    $0x4,%esp
  802a82:	68 74 44 80 00       	push   $0x804474
  802a87:	6a 3d                	push   $0x3d
  802a89:	68 97 44 80 00       	push   $0x804497
  802a8e:	e8 b1 e1 ff ff       	call   800c44 <_panic>
  802a93:	a1 50 50 80 00       	mov    0x805050,%eax
  802a98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9b:	c1 e2 04             	shl    $0x4,%edx
  802a9e:	01 d0                	add    %edx,%eax
  802aa0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802aa6:	89 10                	mov    %edx,(%eax)
  802aa8:	8b 00                	mov    (%eax),%eax
  802aaa:	85 c0                	test   %eax,%eax
  802aac:	74 18                	je     802ac6 <initialize_MemBlocksList+0x88>
  802aae:	a1 48 51 80 00       	mov    0x805148,%eax
  802ab3:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802ab9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802abc:	c1 e1 04             	shl    $0x4,%ecx
  802abf:	01 ca                	add    %ecx,%edx
  802ac1:	89 50 04             	mov    %edx,0x4(%eax)
  802ac4:	eb 12                	jmp    802ad8 <initialize_MemBlocksList+0x9a>
  802ac6:	a1 50 50 80 00       	mov    0x805050,%eax
  802acb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ace:	c1 e2 04             	shl    $0x4,%edx
  802ad1:	01 d0                	add    %edx,%eax
  802ad3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ad8:	a1 50 50 80 00       	mov    0x805050,%eax
  802add:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae0:	c1 e2 04             	shl    $0x4,%edx
  802ae3:	01 d0                	add    %edx,%eax
  802ae5:	a3 48 51 80 00       	mov    %eax,0x805148
  802aea:	a1 50 50 80 00       	mov    0x805050,%eax
  802aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af2:	c1 e2 04             	shl    $0x4,%edx
  802af5:	01 d0                	add    %edx,%eax
  802af7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802afe:	a1 54 51 80 00       	mov    0x805154,%eax
  802b03:	40                   	inc    %eax
  802b04:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802b09:	ff 45 f4             	incl   -0xc(%ebp)
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b12:	0f 82 56 ff ff ff    	jb     802a6e <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802b18:	90                   	nop
  802b19:	c9                   	leave  
  802b1a:	c3                   	ret    

00802b1b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802b1b:	55                   	push   %ebp
  802b1c:	89 e5                	mov    %esp,%ebp
  802b1e:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	8b 00                	mov    (%eax),%eax
  802b26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802b29:	eb 18                	jmp    802b43 <find_block+0x28>

		if(tmp->sva == va){
  802b2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b2e:	8b 40 08             	mov    0x8(%eax),%eax
  802b31:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802b34:	75 05                	jne    802b3b <find_block+0x20>
			return tmp ;
  802b36:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b39:	eb 11                	jmp    802b4c <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b3e:	8b 00                	mov    (%eax),%eax
  802b40:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802b43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802b47:	75 e2                	jne    802b2b <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802b49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802b4c:	c9                   	leave  
  802b4d:	c3                   	ret    

00802b4e <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802b4e:	55                   	push   %ebp
  802b4f:	89 e5                	mov    %esp,%ebp
  802b51:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802b54:	a1 40 50 80 00       	mov    0x805040,%eax
  802b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802b5c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b61:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802b64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b68:	75 65                	jne    802bcf <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802b6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b6e:	75 14                	jne    802b84 <insert_sorted_allocList+0x36>
  802b70:	83 ec 04             	sub    $0x4,%esp
  802b73:	68 74 44 80 00       	push   $0x804474
  802b78:	6a 62                	push   $0x62
  802b7a:	68 97 44 80 00       	push   $0x804497
  802b7f:	e8 c0 e0 ff ff       	call   800c44 <_panic>
  802b84:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	89 10                	mov    %edx,(%eax)
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	8b 00                	mov    (%eax),%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	74 0d                	je     802ba5 <insert_sorted_allocList+0x57>
  802b98:	a1 40 50 80 00       	mov    0x805040,%eax
  802b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba0:	89 50 04             	mov    %edx,0x4(%eax)
  802ba3:	eb 08                	jmp    802bad <insert_sorted_allocList+0x5f>
  802ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba8:	a3 44 50 80 00       	mov    %eax,0x805044
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	a3 40 50 80 00       	mov    %eax,0x805040
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802bc4:	40                   	inc    %eax
  802bc5:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802bca:	e9 14 01 00 00       	jmp    802ce3 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	8b 50 08             	mov    0x8(%eax),%edx
  802bd5:	a1 44 50 80 00       	mov    0x805044,%eax
  802bda:	8b 40 08             	mov    0x8(%eax),%eax
  802bdd:	39 c2                	cmp    %eax,%edx
  802bdf:	76 65                	jbe    802c46 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802be1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be5:	75 14                	jne    802bfb <insert_sorted_allocList+0xad>
  802be7:	83 ec 04             	sub    $0x4,%esp
  802bea:	68 b0 44 80 00       	push   $0x8044b0
  802bef:	6a 64                	push   $0x64
  802bf1:	68 97 44 80 00       	push   $0x804497
  802bf6:	e8 49 e0 ff ff       	call   800c44 <_panic>
  802bfb:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	89 50 04             	mov    %edx,0x4(%eax)
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	8b 40 04             	mov    0x4(%eax),%eax
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	74 0c                	je     802c1d <insert_sorted_allocList+0xcf>
  802c11:	a1 44 50 80 00       	mov    0x805044,%eax
  802c16:	8b 55 08             	mov    0x8(%ebp),%edx
  802c19:	89 10                	mov    %edx,(%eax)
  802c1b:	eb 08                	jmp    802c25 <insert_sorted_allocList+0xd7>
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	a3 40 50 80 00       	mov    %eax,0x805040
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	a3 44 50 80 00       	mov    %eax,0x805044
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c36:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c3b:	40                   	inc    %eax
  802c3c:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802c41:	e9 9d 00 00 00       	jmp    802ce3 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802c46:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802c4d:	e9 85 00 00 00       	jmp    802cd7 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	8b 50 08             	mov    0x8(%eax),%edx
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	8b 40 08             	mov    0x8(%eax),%eax
  802c5e:	39 c2                	cmp    %eax,%edx
  802c60:	73 6a                	jae    802ccc <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802c62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c66:	74 06                	je     802c6e <insert_sorted_allocList+0x120>
  802c68:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c6c:	75 14                	jne    802c82 <insert_sorted_allocList+0x134>
  802c6e:	83 ec 04             	sub    $0x4,%esp
  802c71:	68 d4 44 80 00       	push   $0x8044d4
  802c76:	6a 6b                	push   $0x6b
  802c78:	68 97 44 80 00       	push   $0x804497
  802c7d:	e8 c2 df ff ff       	call   800c44 <_panic>
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 50 04             	mov    0x4(%eax),%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	89 50 04             	mov    %edx,0x4(%eax)
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c94:	89 10                	mov    %edx,(%eax)
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 40 04             	mov    0x4(%eax),%eax
  802c9c:	85 c0                	test   %eax,%eax
  802c9e:	74 0d                	je     802cad <insert_sorted_allocList+0x15f>
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 40 04             	mov    0x4(%eax),%eax
  802ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca9:	89 10                	mov    %edx,(%eax)
  802cab:	eb 08                	jmp    802cb5 <insert_sorted_allocList+0x167>
  802cad:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb0:	a3 40 50 80 00       	mov    %eax,0x805040
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbb:	89 50 04             	mov    %edx,0x4(%eax)
  802cbe:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802cc3:	40                   	inc    %eax
  802cc4:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802cc9:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802cca:	eb 17                	jmp    802ce3 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802cd4:	ff 45 f0             	incl   -0x10(%ebp)
  802cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cda:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802cdd:	0f 8c 6f ff ff ff    	jl     802c52 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802ce3:	90                   	nop
  802ce4:	c9                   	leave  
  802ce5:	c3                   	ret    

00802ce6 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802ce6:	55                   	push   %ebp
  802ce7:	89 e5                	mov    %esp,%ebp
  802ce9:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802cec:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802cf4:	e9 7c 01 00 00       	jmp    802e75 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d02:	0f 86 cf 00 00 00    	jbe    802dd7 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802d08:	a1 48 51 80 00       	mov    0x805148,%eax
  802d0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d13:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802d16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d19:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1c:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d22:	8b 50 08             	mov    0x8(%eax),%edx
  802d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d28:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d31:	2b 45 08             	sub    0x8(%ebp),%eax
  802d34:	89 c2                	mov    %eax,%edx
  802d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d39:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3f:	8b 50 08             	mov    0x8(%eax),%edx
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	01 c2                	add    %eax,%edx
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802d4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d51:	75 17                	jne    802d6a <alloc_block_FF+0x84>
  802d53:	83 ec 04             	sub    $0x4,%esp
  802d56:	68 09 45 80 00       	push   $0x804509
  802d5b:	68 83 00 00 00       	push   $0x83
  802d60:	68 97 44 80 00       	push   $0x804497
  802d65:	e8 da de ff ff       	call   800c44 <_panic>
  802d6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d6d:	8b 00                	mov    (%eax),%eax
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	74 10                	je     802d83 <alloc_block_FF+0x9d>
  802d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d76:	8b 00                	mov    (%eax),%eax
  802d78:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d7b:	8b 52 04             	mov    0x4(%edx),%edx
  802d7e:	89 50 04             	mov    %edx,0x4(%eax)
  802d81:	eb 0b                	jmp    802d8e <alloc_block_FF+0xa8>
  802d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d86:	8b 40 04             	mov    0x4(%eax),%eax
  802d89:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d91:	8b 40 04             	mov    0x4(%eax),%eax
  802d94:	85 c0                	test   %eax,%eax
  802d96:	74 0f                	je     802da7 <alloc_block_FF+0xc1>
  802d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9b:	8b 40 04             	mov    0x4(%eax),%eax
  802d9e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802da1:	8b 12                	mov    (%edx),%edx
  802da3:	89 10                	mov    %edx,(%eax)
  802da5:	eb 0a                	jmp    802db1 <alloc_block_FF+0xcb>
  802da7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802daa:	8b 00                	mov    (%eax),%eax
  802dac:	a3 48 51 80 00       	mov    %eax,0x805148
  802db1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802db4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc4:	a1 54 51 80 00       	mov    0x805154,%eax
  802dc9:	48                   	dec    %eax
  802dca:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802dcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dd2:	e9 ad 00 00 00       	jmp    802e84 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	8b 40 0c             	mov    0xc(%eax),%eax
  802ddd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802de0:	0f 85 87 00 00 00    	jne    802e6d <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802de6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dea:	75 17                	jne    802e03 <alloc_block_FF+0x11d>
  802dec:	83 ec 04             	sub    $0x4,%esp
  802def:	68 09 45 80 00       	push   $0x804509
  802df4:	68 87 00 00 00       	push   $0x87
  802df9:	68 97 44 80 00       	push   $0x804497
  802dfe:	e8 41 de ff ff       	call   800c44 <_panic>
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 00                	mov    (%eax),%eax
  802e08:	85 c0                	test   %eax,%eax
  802e0a:	74 10                	je     802e1c <alloc_block_FF+0x136>
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	8b 00                	mov    (%eax),%eax
  802e11:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e14:	8b 52 04             	mov    0x4(%edx),%edx
  802e17:	89 50 04             	mov    %edx,0x4(%eax)
  802e1a:	eb 0b                	jmp    802e27 <alloc_block_FF+0x141>
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 40 04             	mov    0x4(%eax),%eax
  802e22:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 40 04             	mov    0x4(%eax),%eax
  802e2d:	85 c0                	test   %eax,%eax
  802e2f:	74 0f                	je     802e40 <alloc_block_FF+0x15a>
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 04             	mov    0x4(%eax),%eax
  802e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3a:	8b 12                	mov    (%edx),%edx
  802e3c:	89 10                	mov    %edx,(%eax)
  802e3e:	eb 0a                	jmp    802e4a <alloc_block_FF+0x164>
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	8b 00                	mov    (%eax),%eax
  802e45:	a3 38 51 80 00       	mov    %eax,0x805138
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5d:	a1 44 51 80 00       	mov    0x805144,%eax
  802e62:	48                   	dec    %eax
  802e63:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	eb 17                	jmp    802e84 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 00                	mov    (%eax),%eax
  802e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802e75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e79:	0f 85 7a fe ff ff    	jne    802cf9 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802e7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e84:	c9                   	leave  
  802e85:	c3                   	ret    

00802e86 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802e86:	55                   	push   %ebp
  802e87:	89 e5                	mov    %esp,%ebp
  802e89:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802e8c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802e94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802e9b:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802ea2:	a1 38 51 80 00       	mov    0x805138,%eax
  802ea7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eaa:	e9 d0 00 00 00       	jmp    802f7f <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eb8:	0f 82 b8 00 00 00    	jb     802f76 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ec7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802eca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ecd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802ed0:	0f 83 a1 00 00 00    	jae    802f77 <alloc_block_BF+0xf1>
				differsize = differance ;
  802ed6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ed9:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802ee2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ee6:	0f 85 8b 00 00 00    	jne    802f77 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802eec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef0:	75 17                	jne    802f09 <alloc_block_BF+0x83>
  802ef2:	83 ec 04             	sub    $0x4,%esp
  802ef5:	68 09 45 80 00       	push   $0x804509
  802efa:	68 a0 00 00 00       	push   $0xa0
  802eff:	68 97 44 80 00       	push   $0x804497
  802f04:	e8 3b dd ff ff       	call   800c44 <_panic>
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	74 10                	je     802f22 <alloc_block_BF+0x9c>
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f1a:	8b 52 04             	mov    0x4(%edx),%edx
  802f1d:	89 50 04             	mov    %edx,0x4(%eax)
  802f20:	eb 0b                	jmp    802f2d <alloc_block_BF+0xa7>
  802f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f25:	8b 40 04             	mov    0x4(%eax),%eax
  802f28:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 40 04             	mov    0x4(%eax),%eax
  802f33:	85 c0                	test   %eax,%eax
  802f35:	74 0f                	je     802f46 <alloc_block_BF+0xc0>
  802f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3a:	8b 40 04             	mov    0x4(%eax),%eax
  802f3d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f40:	8b 12                	mov    (%edx),%edx
  802f42:	89 10                	mov    %edx,(%eax)
  802f44:	eb 0a                	jmp    802f50 <alloc_block_BF+0xca>
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 00                	mov    (%eax),%eax
  802f4b:	a3 38 51 80 00       	mov    %eax,0x805138
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f63:	a1 44 51 80 00       	mov    0x805144,%eax
  802f68:	48                   	dec    %eax
  802f69:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f71:	e9 0c 01 00 00       	jmp    803082 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802f76:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802f77:	a1 40 51 80 00       	mov    0x805140,%eax
  802f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f83:	74 07                	je     802f8c <alloc_block_BF+0x106>
  802f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f88:	8b 00                	mov    (%eax),%eax
  802f8a:	eb 05                	jmp    802f91 <alloc_block_BF+0x10b>
  802f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f91:	a3 40 51 80 00       	mov    %eax,0x805140
  802f96:	a1 40 51 80 00       	mov    0x805140,%eax
  802f9b:	85 c0                	test   %eax,%eax
  802f9d:	0f 85 0c ff ff ff    	jne    802eaf <alloc_block_BF+0x29>
  802fa3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fa7:	0f 85 02 ff ff ff    	jne    802eaf <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802fad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802fb1:	0f 84 c6 00 00 00    	je     80307d <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802fb7:	a1 48 51 80 00       	mov    0x805148,%eax
  802fbc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc5:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fcb:	8b 50 08             	mov    0x8(%eax),%edx
  802fce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fd1:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fda:	2b 45 08             	sub    0x8(%ebp),%eax
  802fdd:	89 c2                	mov    %eax,%edx
  802fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe2:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe8:	8b 50 08             	mov    0x8(%eax),%edx
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	01 c2                	add    %eax,%edx
  802ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff3:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802ff6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ffa:	75 17                	jne    803013 <alloc_block_BF+0x18d>
  802ffc:	83 ec 04             	sub    $0x4,%esp
  802fff:	68 09 45 80 00       	push   $0x804509
  803004:	68 af 00 00 00       	push   $0xaf
  803009:	68 97 44 80 00       	push   $0x804497
  80300e:	e8 31 dc ff ff       	call   800c44 <_panic>
  803013:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	85 c0                	test   %eax,%eax
  80301a:	74 10                	je     80302c <alloc_block_BF+0x1a6>
  80301c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80301f:	8b 00                	mov    (%eax),%eax
  803021:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803024:	8b 52 04             	mov    0x4(%edx),%edx
  803027:	89 50 04             	mov    %edx,0x4(%eax)
  80302a:	eb 0b                	jmp    803037 <alloc_block_BF+0x1b1>
  80302c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80302f:	8b 40 04             	mov    0x4(%eax),%eax
  803032:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803037:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80303a:	8b 40 04             	mov    0x4(%eax),%eax
  80303d:	85 c0                	test   %eax,%eax
  80303f:	74 0f                	je     803050 <alloc_block_BF+0x1ca>
  803041:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803044:	8b 40 04             	mov    0x4(%eax),%eax
  803047:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80304a:	8b 12                	mov    (%edx),%edx
  80304c:	89 10                	mov    %edx,(%eax)
  80304e:	eb 0a                	jmp    80305a <alloc_block_BF+0x1d4>
  803050:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	a3 48 51 80 00       	mov    %eax,0x805148
  80305a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80305d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803063:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803066:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80306d:	a1 54 51 80 00       	mov    0x805154,%eax
  803072:	48                   	dec    %eax
  803073:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  803078:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80307b:	eb 05                	jmp    803082 <alloc_block_BF+0x1fc>
	}

	return NULL;
  80307d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803082:	c9                   	leave  
  803083:	c3                   	ret    

00803084 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  803084:	55                   	push   %ebp
  803085:	89 e5                	mov    %esp,%ebp
  803087:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80308a:	a1 38 51 80 00       	mov    0x805138,%eax
  80308f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  803092:	e9 7c 01 00 00       	jmp    803213 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 40 0c             	mov    0xc(%eax),%eax
  80309d:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030a0:	0f 86 cf 00 00 00    	jbe    803175 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8030a6:	a1 48 51 80 00       	mov    0x805148,%eax
  8030ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8030ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8030b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030ba:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 50 08             	mov    0x8(%eax),%edx
  8030c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c6:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cf:	2b 45 08             	sub    0x8(%ebp),%eax
  8030d2:	89 c2                	mov    %eax,%edx
  8030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d7:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  8030da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dd:	8b 50 08             	mov    0x8(%eax),%edx
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	01 c2                	add    %eax,%edx
  8030e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e8:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8030eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030ef:	75 17                	jne    803108 <alloc_block_NF+0x84>
  8030f1:	83 ec 04             	sub    $0x4,%esp
  8030f4:	68 09 45 80 00       	push   $0x804509
  8030f9:	68 c4 00 00 00       	push   $0xc4
  8030fe:	68 97 44 80 00       	push   $0x804497
  803103:	e8 3c db ff ff       	call   800c44 <_panic>
  803108:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310b:	8b 00                	mov    (%eax),%eax
  80310d:	85 c0                	test   %eax,%eax
  80310f:	74 10                	je     803121 <alloc_block_NF+0x9d>
  803111:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803119:	8b 52 04             	mov    0x4(%edx),%edx
  80311c:	89 50 04             	mov    %edx,0x4(%eax)
  80311f:	eb 0b                	jmp    80312c <alloc_block_NF+0xa8>
  803121:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803124:	8b 40 04             	mov    0x4(%eax),%eax
  803127:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80312c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312f:	8b 40 04             	mov    0x4(%eax),%eax
  803132:	85 c0                	test   %eax,%eax
  803134:	74 0f                	je     803145 <alloc_block_NF+0xc1>
  803136:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803139:	8b 40 04             	mov    0x4(%eax),%eax
  80313c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80313f:	8b 12                	mov    (%edx),%edx
  803141:	89 10                	mov    %edx,(%eax)
  803143:	eb 0a                	jmp    80314f <alloc_block_NF+0xcb>
  803145:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803148:	8b 00                	mov    (%eax),%eax
  80314a:	a3 48 51 80 00       	mov    %eax,0x805148
  80314f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803152:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803158:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80315b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803162:	a1 54 51 80 00       	mov    0x805154,%eax
  803167:	48                   	dec    %eax
  803168:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  80316d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803170:	e9 ad 00 00 00       	jmp    803222 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  803175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803178:	8b 40 0c             	mov    0xc(%eax),%eax
  80317b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80317e:	0f 85 87 00 00 00    	jne    80320b <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  803184:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803188:	75 17                	jne    8031a1 <alloc_block_NF+0x11d>
  80318a:	83 ec 04             	sub    $0x4,%esp
  80318d:	68 09 45 80 00       	push   $0x804509
  803192:	68 c8 00 00 00       	push   $0xc8
  803197:	68 97 44 80 00       	push   $0x804497
  80319c:	e8 a3 da ff ff       	call   800c44 <_panic>
  8031a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a4:	8b 00                	mov    (%eax),%eax
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	74 10                	je     8031ba <alloc_block_NF+0x136>
  8031aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ad:	8b 00                	mov    (%eax),%eax
  8031af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031b2:	8b 52 04             	mov    0x4(%edx),%edx
  8031b5:	89 50 04             	mov    %edx,0x4(%eax)
  8031b8:	eb 0b                	jmp    8031c5 <alloc_block_NF+0x141>
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	8b 40 04             	mov    0x4(%eax),%eax
  8031c0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c8:	8b 40 04             	mov    0x4(%eax),%eax
  8031cb:	85 c0                	test   %eax,%eax
  8031cd:	74 0f                	je     8031de <alloc_block_NF+0x15a>
  8031cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d2:	8b 40 04             	mov    0x4(%eax),%eax
  8031d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031d8:	8b 12                	mov    (%edx),%edx
  8031da:	89 10                	mov    %edx,(%eax)
  8031dc:	eb 0a                	jmp    8031e8 <alloc_block_NF+0x164>
  8031de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031e1:	8b 00                	mov    (%eax),%eax
  8031e3:	a3 38 51 80 00       	mov    %eax,0x805138
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031fb:	a1 44 51 80 00       	mov    0x805144,%eax
  803200:	48                   	dec    %eax
  803201:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  803206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803209:	eb 17                	jmp    803222 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80320b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80320e:	8b 00                	mov    (%eax),%eax
  803210:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  803213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803217:	0f 85 7a fe ff ff    	jne    803097 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80321d:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803222:	c9                   	leave  
  803223:	c3                   	ret    

00803224 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803224:	55                   	push   %ebp
  803225:	89 e5                	mov    %esp,%ebp
  803227:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80322a:	a1 38 51 80 00       	mov    0x805138,%eax
  80322f:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803232:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803237:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80323a:	a1 44 51 80 00       	mov    0x805144,%eax
  80323f:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  803242:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803246:	75 68                	jne    8032b0 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  803248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80324c:	75 17                	jne    803265 <insert_sorted_with_merge_freeList+0x41>
  80324e:	83 ec 04             	sub    $0x4,%esp
  803251:	68 74 44 80 00       	push   $0x804474
  803256:	68 da 00 00 00       	push   $0xda
  80325b:	68 97 44 80 00       	push   $0x804497
  803260:	e8 df d9 ff ff       	call   800c44 <_panic>
  803265:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80326b:	8b 45 08             	mov    0x8(%ebp),%eax
  80326e:	89 10                	mov    %edx,(%eax)
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	8b 00                	mov    (%eax),%eax
  803275:	85 c0                	test   %eax,%eax
  803277:	74 0d                	je     803286 <insert_sorted_with_merge_freeList+0x62>
  803279:	a1 38 51 80 00       	mov    0x805138,%eax
  80327e:	8b 55 08             	mov    0x8(%ebp),%edx
  803281:	89 50 04             	mov    %edx,0x4(%eax)
  803284:	eb 08                	jmp    80328e <insert_sorted_with_merge_freeList+0x6a>
  803286:	8b 45 08             	mov    0x8(%ebp),%eax
  803289:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	a3 38 51 80 00       	mov    %eax,0x805138
  803296:	8b 45 08             	mov    0x8(%ebp),%eax
  803299:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032a0:	a1 44 51 80 00       	mov    0x805144,%eax
  8032a5:	40                   	inc    %eax
  8032a6:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  8032ab:	e9 49 07 00 00       	jmp    8039f9 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8032b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b3:	8b 50 08             	mov    0x8(%eax),%edx
  8032b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bc:	01 c2                	add    %eax,%edx
  8032be:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c1:	8b 40 08             	mov    0x8(%eax),%eax
  8032c4:	39 c2                	cmp    %eax,%edx
  8032c6:	73 77                	jae    80333f <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8032c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032cb:	8b 00                	mov    (%eax),%eax
  8032cd:	85 c0                	test   %eax,%eax
  8032cf:	75 6e                	jne    80333f <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8032d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032d5:	74 68                	je     80333f <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  8032d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032db:	75 17                	jne    8032f4 <insert_sorted_with_merge_freeList+0xd0>
  8032dd:	83 ec 04             	sub    $0x4,%esp
  8032e0:	68 b0 44 80 00       	push   $0x8044b0
  8032e5:	68 e0 00 00 00       	push   $0xe0
  8032ea:	68 97 44 80 00       	push   $0x804497
  8032ef:	e8 50 d9 ff ff       	call   800c44 <_panic>
  8032f4:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8032fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fd:	89 50 04             	mov    %edx,0x4(%eax)
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	8b 40 04             	mov    0x4(%eax),%eax
  803306:	85 c0                	test   %eax,%eax
  803308:	74 0c                	je     803316 <insert_sorted_with_merge_freeList+0xf2>
  80330a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80330f:	8b 55 08             	mov    0x8(%ebp),%edx
  803312:	89 10                	mov    %edx,(%eax)
  803314:	eb 08                	jmp    80331e <insert_sorted_with_merge_freeList+0xfa>
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	a3 38 51 80 00       	mov    %eax,0x805138
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803326:	8b 45 08             	mov    0x8(%ebp),%eax
  803329:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80332f:	a1 44 51 80 00       	mov    0x805144,%eax
  803334:	40                   	inc    %eax
  803335:	a3 44 51 80 00       	mov    %eax,0x805144
  80333a:	e9 ba 06 00 00       	jmp    8039f9 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  80333f:	8b 45 08             	mov    0x8(%ebp),%eax
  803342:	8b 50 0c             	mov    0xc(%eax),%edx
  803345:	8b 45 08             	mov    0x8(%ebp),%eax
  803348:	8b 40 08             	mov    0x8(%eax),%eax
  80334b:	01 c2                	add    %eax,%edx
  80334d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803350:	8b 40 08             	mov    0x8(%eax),%eax
  803353:	39 c2                	cmp    %eax,%edx
  803355:	73 78                	jae    8033cf <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	8b 40 04             	mov    0x4(%eax),%eax
  80335d:	85 c0                	test   %eax,%eax
  80335f:	75 6e                	jne    8033cf <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803361:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803365:	74 68                	je     8033cf <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  803367:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80336b:	75 17                	jne    803384 <insert_sorted_with_merge_freeList+0x160>
  80336d:	83 ec 04             	sub    $0x4,%esp
  803370:	68 74 44 80 00       	push   $0x804474
  803375:	68 e6 00 00 00       	push   $0xe6
  80337a:	68 97 44 80 00       	push   $0x804497
  80337f:	e8 c0 d8 ff ff       	call   800c44 <_panic>
  803384:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	89 10                	mov    %edx,(%eax)
  80338f:	8b 45 08             	mov    0x8(%ebp),%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	85 c0                	test   %eax,%eax
  803396:	74 0d                	je     8033a5 <insert_sorted_with_merge_freeList+0x181>
  803398:	a1 38 51 80 00       	mov    0x805138,%eax
  80339d:	8b 55 08             	mov    0x8(%ebp),%edx
  8033a0:	89 50 04             	mov    %edx,0x4(%eax)
  8033a3:	eb 08                	jmp    8033ad <insert_sorted_with_merge_freeList+0x189>
  8033a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8033b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033bf:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c4:	40                   	inc    %eax
  8033c5:	a3 44 51 80 00       	mov    %eax,0x805144
  8033ca:	e9 2a 06 00 00       	jmp    8039f9 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8033cf:	a1 38 51 80 00       	mov    0x805138,%eax
  8033d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033d7:	e9 ed 05 00 00       	jmp    8039c9 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  8033dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033df:	8b 00                	mov    (%eax),%eax
  8033e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  8033e4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8033e8:	0f 84 a7 00 00 00    	je     803495 <insert_sorted_with_merge_freeList+0x271>
  8033ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8033f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f7:	8b 40 08             	mov    0x8(%eax),%eax
  8033fa:	01 c2                	add    %eax,%edx
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	8b 40 08             	mov    0x8(%eax),%eax
  803402:	39 c2                	cmp    %eax,%edx
  803404:	0f 83 8b 00 00 00    	jae    803495 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	8b 50 0c             	mov    0xc(%eax),%edx
  803410:	8b 45 08             	mov    0x8(%ebp),%eax
  803413:	8b 40 08             	mov    0x8(%eax),%eax
  803416:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  803418:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80341b:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  80341e:	39 c2                	cmp    %eax,%edx
  803420:	73 73                	jae    803495 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803422:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803426:	74 06                	je     80342e <insert_sorted_with_merge_freeList+0x20a>
  803428:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342c:	75 17                	jne    803445 <insert_sorted_with_merge_freeList+0x221>
  80342e:	83 ec 04             	sub    $0x4,%esp
  803431:	68 28 45 80 00       	push   $0x804528
  803436:	68 f0 00 00 00       	push   $0xf0
  80343b:	68 97 44 80 00       	push   $0x804497
  803440:	e8 ff d7 ff ff       	call   800c44 <_panic>
  803445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803448:	8b 10                	mov    (%eax),%edx
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	89 10                	mov    %edx,(%eax)
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	85 c0                	test   %eax,%eax
  803456:	74 0b                	je     803463 <insert_sorted_with_merge_freeList+0x23f>
  803458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345b:	8b 00                	mov    (%eax),%eax
  80345d:	8b 55 08             	mov    0x8(%ebp),%edx
  803460:	89 50 04             	mov    %edx,0x4(%eax)
  803463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803466:	8b 55 08             	mov    0x8(%ebp),%edx
  803469:	89 10                	mov    %edx,(%eax)
  80346b:	8b 45 08             	mov    0x8(%ebp),%eax
  80346e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803471:	89 50 04             	mov    %edx,0x4(%eax)
  803474:	8b 45 08             	mov    0x8(%ebp),%eax
  803477:	8b 00                	mov    (%eax),%eax
  803479:	85 c0                	test   %eax,%eax
  80347b:	75 08                	jne    803485 <insert_sorted_with_merge_freeList+0x261>
  80347d:	8b 45 08             	mov    0x8(%ebp),%eax
  803480:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803485:	a1 44 51 80 00       	mov    0x805144,%eax
  80348a:	40                   	inc    %eax
  80348b:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  803490:	e9 64 05 00 00       	jmp    8039f9 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803495:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80349a:	8b 50 0c             	mov    0xc(%eax),%edx
  80349d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034a2:	8b 40 08             	mov    0x8(%eax),%eax
  8034a5:	01 c2                	add    %eax,%edx
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	8b 40 08             	mov    0x8(%eax),%eax
  8034ad:	39 c2                	cmp    %eax,%edx
  8034af:	0f 85 b1 00 00 00    	jne    803566 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  8034b5:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034ba:	85 c0                	test   %eax,%eax
  8034bc:	0f 84 a4 00 00 00    	je     803566 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  8034c2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034c7:	8b 00                	mov    (%eax),%eax
  8034c9:	85 c0                	test   %eax,%eax
  8034cb:	0f 85 95 00 00 00    	jne    803566 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  8034d1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034d6:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8034dc:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8034df:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e2:	8b 52 0c             	mov    0xc(%edx),%edx
  8034e5:	01 ca                	add    %ecx,%edx
  8034e7:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  8034ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8034fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803502:	75 17                	jne    80351b <insert_sorted_with_merge_freeList+0x2f7>
  803504:	83 ec 04             	sub    $0x4,%esp
  803507:	68 74 44 80 00       	push   $0x804474
  80350c:	68 ff 00 00 00       	push   $0xff
  803511:	68 97 44 80 00       	push   $0x804497
  803516:	e8 29 d7 ff ff       	call   800c44 <_panic>
  80351b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	89 10                	mov    %edx,(%eax)
  803526:	8b 45 08             	mov    0x8(%ebp),%eax
  803529:	8b 00                	mov    (%eax),%eax
  80352b:	85 c0                	test   %eax,%eax
  80352d:	74 0d                	je     80353c <insert_sorted_with_merge_freeList+0x318>
  80352f:	a1 48 51 80 00       	mov    0x805148,%eax
  803534:	8b 55 08             	mov    0x8(%ebp),%edx
  803537:	89 50 04             	mov    %edx,0x4(%eax)
  80353a:	eb 08                	jmp    803544 <insert_sorted_with_merge_freeList+0x320>
  80353c:	8b 45 08             	mov    0x8(%ebp),%eax
  80353f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	a3 48 51 80 00       	mov    %eax,0x805148
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803556:	a1 54 51 80 00       	mov    0x805154,%eax
  80355b:	40                   	inc    %eax
  80355c:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803561:	e9 93 04 00 00       	jmp    8039f9 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  803566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803569:	8b 50 08             	mov    0x8(%eax),%edx
  80356c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80356f:	8b 40 0c             	mov    0xc(%eax),%eax
  803572:	01 c2                	add    %eax,%edx
  803574:	8b 45 08             	mov    0x8(%ebp),%eax
  803577:	8b 40 08             	mov    0x8(%eax),%eax
  80357a:	39 c2                	cmp    %eax,%edx
  80357c:	0f 85 ae 00 00 00    	jne    803630 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803582:	8b 45 08             	mov    0x8(%ebp),%eax
  803585:	8b 50 0c             	mov    0xc(%eax),%edx
  803588:	8b 45 08             	mov    0x8(%ebp),%eax
  80358b:	8b 40 08             	mov    0x8(%eax),%eax
  80358e:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803593:	8b 00                	mov    (%eax),%eax
  803595:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803598:	39 c2                	cmp    %eax,%edx
  80359a:	0f 84 90 00 00 00    	je     803630 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  8035a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a3:	8b 50 0c             	mov    0xc(%eax),%edx
  8035a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035ac:	01 c2                	add    %eax,%edx
  8035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b1:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8035b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8035be:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8035c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035cc:	75 17                	jne    8035e5 <insert_sorted_with_merge_freeList+0x3c1>
  8035ce:	83 ec 04             	sub    $0x4,%esp
  8035d1:	68 74 44 80 00       	push   $0x804474
  8035d6:	68 0b 01 00 00       	push   $0x10b
  8035db:	68 97 44 80 00       	push   $0x804497
  8035e0:	e8 5f d6 ff ff       	call   800c44 <_panic>
  8035e5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035ee:	89 10                	mov    %edx,(%eax)
  8035f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f3:	8b 00                	mov    (%eax),%eax
  8035f5:	85 c0                	test   %eax,%eax
  8035f7:	74 0d                	je     803606 <insert_sorted_with_merge_freeList+0x3e2>
  8035f9:	a1 48 51 80 00       	mov    0x805148,%eax
  8035fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803601:	89 50 04             	mov    %edx,0x4(%eax)
  803604:	eb 08                	jmp    80360e <insert_sorted_with_merge_freeList+0x3ea>
  803606:	8b 45 08             	mov    0x8(%ebp),%eax
  803609:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80360e:	8b 45 08             	mov    0x8(%ebp),%eax
  803611:	a3 48 51 80 00       	mov    %eax,0x805148
  803616:	8b 45 08             	mov    0x8(%ebp),%eax
  803619:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803620:	a1 54 51 80 00       	mov    0x805154,%eax
  803625:	40                   	inc    %eax
  803626:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80362b:	e9 c9 03 00 00       	jmp    8039f9 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803630:	8b 45 08             	mov    0x8(%ebp),%eax
  803633:	8b 50 0c             	mov    0xc(%eax),%edx
  803636:	8b 45 08             	mov    0x8(%ebp),%eax
  803639:	8b 40 08             	mov    0x8(%eax),%eax
  80363c:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  80363e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803641:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803644:	39 c2                	cmp    %eax,%edx
  803646:	0f 85 bb 00 00 00    	jne    803707 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  80364c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803650:	0f 84 b1 00 00 00    	je     803707 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803659:	8b 40 04             	mov    0x4(%eax),%eax
  80365c:	85 c0                	test   %eax,%eax
  80365e:	0f 85 a3 00 00 00    	jne    803707 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803664:	a1 38 51 80 00       	mov    0x805138,%eax
  803669:	8b 55 08             	mov    0x8(%ebp),%edx
  80366c:	8b 52 08             	mov    0x8(%edx),%edx
  80366f:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803672:	a1 38 51 80 00       	mov    0x805138,%eax
  803677:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80367d:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803680:	8b 55 08             	mov    0x8(%ebp),%edx
  803683:	8b 52 0c             	mov    0xc(%edx),%edx
  803686:	01 ca                	add    %ecx,%edx
  803688:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80368b:	8b 45 08             	mov    0x8(%ebp),%eax
  80368e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803695:	8b 45 08             	mov    0x8(%ebp),%eax
  803698:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80369f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036a3:	75 17                	jne    8036bc <insert_sorted_with_merge_freeList+0x498>
  8036a5:	83 ec 04             	sub    $0x4,%esp
  8036a8:	68 74 44 80 00       	push   $0x804474
  8036ad:	68 17 01 00 00       	push   $0x117
  8036b2:	68 97 44 80 00       	push   $0x804497
  8036b7:	e8 88 d5 ff ff       	call   800c44 <_panic>
  8036bc:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036c5:	89 10                	mov    %edx,(%eax)
  8036c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ca:	8b 00                	mov    (%eax),%eax
  8036cc:	85 c0                	test   %eax,%eax
  8036ce:	74 0d                	je     8036dd <insert_sorted_with_merge_freeList+0x4b9>
  8036d0:	a1 48 51 80 00       	mov    0x805148,%eax
  8036d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8036d8:	89 50 04             	mov    %edx,0x4(%eax)
  8036db:	eb 08                	jmp    8036e5 <insert_sorted_with_merge_freeList+0x4c1>
  8036dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e8:	a3 48 51 80 00       	mov    %eax,0x805148
  8036ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8036f7:	a1 54 51 80 00       	mov    0x805154,%eax
  8036fc:	40                   	inc    %eax
  8036fd:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803702:	e9 f2 02 00 00       	jmp    8039f9 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803707:	8b 45 08             	mov    0x8(%ebp),%eax
  80370a:	8b 50 08             	mov    0x8(%eax),%edx
  80370d:	8b 45 08             	mov    0x8(%ebp),%eax
  803710:	8b 40 0c             	mov    0xc(%eax),%eax
  803713:	01 c2                	add    %eax,%edx
  803715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803718:	8b 40 08             	mov    0x8(%eax),%eax
  80371b:	39 c2                	cmp    %eax,%edx
  80371d:	0f 85 be 00 00 00    	jne    8037e1 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803726:	8b 40 04             	mov    0x4(%eax),%eax
  803729:	8b 50 08             	mov    0x8(%eax),%edx
  80372c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372f:	8b 40 04             	mov    0x4(%eax),%eax
  803732:	8b 40 0c             	mov    0xc(%eax),%eax
  803735:	01 c2                	add    %eax,%edx
  803737:	8b 45 08             	mov    0x8(%ebp),%eax
  80373a:	8b 40 08             	mov    0x8(%eax),%eax
  80373d:	39 c2                	cmp    %eax,%edx
  80373f:	0f 84 9c 00 00 00    	je     8037e1 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  803745:	8b 45 08             	mov    0x8(%ebp),%eax
  803748:	8b 50 08             	mov    0x8(%eax),%edx
  80374b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374e:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803754:	8b 50 0c             	mov    0xc(%eax),%edx
  803757:	8b 45 08             	mov    0x8(%ebp),%eax
  80375a:	8b 40 0c             	mov    0xc(%eax),%eax
  80375d:	01 c2                	add    %eax,%edx
  80375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803762:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803765:	8b 45 08             	mov    0x8(%ebp),%eax
  803768:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80376f:	8b 45 08             	mov    0x8(%ebp),%eax
  803772:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803779:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80377d:	75 17                	jne    803796 <insert_sorted_with_merge_freeList+0x572>
  80377f:	83 ec 04             	sub    $0x4,%esp
  803782:	68 74 44 80 00       	push   $0x804474
  803787:	68 26 01 00 00       	push   $0x126
  80378c:	68 97 44 80 00       	push   $0x804497
  803791:	e8 ae d4 ff ff       	call   800c44 <_panic>
  803796:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80379c:	8b 45 08             	mov    0x8(%ebp),%eax
  80379f:	89 10                	mov    %edx,(%eax)
  8037a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a4:	8b 00                	mov    (%eax),%eax
  8037a6:	85 c0                	test   %eax,%eax
  8037a8:	74 0d                	je     8037b7 <insert_sorted_with_merge_freeList+0x593>
  8037aa:	a1 48 51 80 00       	mov    0x805148,%eax
  8037af:	8b 55 08             	mov    0x8(%ebp),%edx
  8037b2:	89 50 04             	mov    %edx,0x4(%eax)
  8037b5:	eb 08                	jmp    8037bf <insert_sorted_with_merge_freeList+0x59b>
  8037b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c2:	a3 48 51 80 00       	mov    %eax,0x805148
  8037c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d1:	a1 54 51 80 00       	mov    0x805154,%eax
  8037d6:	40                   	inc    %eax
  8037d7:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  8037dc:	e9 18 02 00 00       	jmp    8039f9 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  8037e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e4:	8b 50 0c             	mov    0xc(%eax),%edx
  8037e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ea:	8b 40 08             	mov    0x8(%eax),%eax
  8037ed:	01 c2                	add    %eax,%edx
  8037ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f2:	8b 40 08             	mov    0x8(%eax),%eax
  8037f5:	39 c2                	cmp    %eax,%edx
  8037f7:	0f 85 c4 01 00 00    	jne    8039c1 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  8037fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803800:	8b 50 0c             	mov    0xc(%eax),%edx
  803803:	8b 45 08             	mov    0x8(%ebp),%eax
  803806:	8b 40 08             	mov    0x8(%eax),%eax
  803809:	01 c2                	add    %eax,%edx
  80380b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380e:	8b 00                	mov    (%eax),%eax
  803810:	8b 40 08             	mov    0x8(%eax),%eax
  803813:	39 c2                	cmp    %eax,%edx
  803815:	0f 85 a6 01 00 00    	jne    8039c1 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  80381b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80381f:	0f 84 9c 01 00 00    	je     8039c1 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803828:	8b 50 0c             	mov    0xc(%eax),%edx
  80382b:	8b 45 08             	mov    0x8(%ebp),%eax
  80382e:	8b 40 0c             	mov    0xc(%eax),%eax
  803831:	01 c2                	add    %eax,%edx
  803833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803836:	8b 00                	mov    (%eax),%eax
  803838:	8b 40 0c             	mov    0xc(%eax),%eax
  80383b:	01 c2                	add    %eax,%edx
  80383d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803840:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803843:	8b 45 08             	mov    0x8(%ebp),%eax
  803846:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  80384d:	8b 45 08             	mov    0x8(%ebp),%eax
  803850:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  803857:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80385b:	75 17                	jne    803874 <insert_sorted_with_merge_freeList+0x650>
  80385d:	83 ec 04             	sub    $0x4,%esp
  803860:	68 74 44 80 00       	push   $0x804474
  803865:	68 32 01 00 00       	push   $0x132
  80386a:	68 97 44 80 00       	push   $0x804497
  80386f:	e8 d0 d3 ff ff       	call   800c44 <_panic>
  803874:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80387a:	8b 45 08             	mov    0x8(%ebp),%eax
  80387d:	89 10                	mov    %edx,(%eax)
  80387f:	8b 45 08             	mov    0x8(%ebp),%eax
  803882:	8b 00                	mov    (%eax),%eax
  803884:	85 c0                	test   %eax,%eax
  803886:	74 0d                	je     803895 <insert_sorted_with_merge_freeList+0x671>
  803888:	a1 48 51 80 00       	mov    0x805148,%eax
  80388d:	8b 55 08             	mov    0x8(%ebp),%edx
  803890:	89 50 04             	mov    %edx,0x4(%eax)
  803893:	eb 08                	jmp    80389d <insert_sorted_with_merge_freeList+0x679>
  803895:	8b 45 08             	mov    0x8(%ebp),%eax
  803898:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80389d:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a0:	a3 48 51 80 00       	mov    %eax,0x805148
  8038a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038af:	a1 54 51 80 00       	mov    0x805154,%eax
  8038b4:	40                   	inc    %eax
  8038b5:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  8038ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bd:	8b 00                	mov    (%eax),%eax
  8038bf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  8038c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c9:	8b 00                	mov    (%eax),%eax
  8038cb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  8038d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d5:	8b 00                	mov    (%eax),%eax
  8038d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  8038da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038de:	75 17                	jne    8038f7 <insert_sorted_with_merge_freeList+0x6d3>
  8038e0:	83 ec 04             	sub    $0x4,%esp
  8038e3:	68 09 45 80 00       	push   $0x804509
  8038e8:	68 36 01 00 00       	push   $0x136
  8038ed:	68 97 44 80 00       	push   $0x804497
  8038f2:	e8 4d d3 ff ff       	call   800c44 <_panic>
  8038f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038fa:	8b 00                	mov    (%eax),%eax
  8038fc:	85 c0                	test   %eax,%eax
  8038fe:	74 10                	je     803910 <insert_sorted_with_merge_freeList+0x6ec>
  803900:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803903:	8b 00                	mov    (%eax),%eax
  803905:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803908:	8b 52 04             	mov    0x4(%edx),%edx
  80390b:	89 50 04             	mov    %edx,0x4(%eax)
  80390e:	eb 0b                	jmp    80391b <insert_sorted_with_merge_freeList+0x6f7>
  803910:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803913:	8b 40 04             	mov    0x4(%eax),%eax
  803916:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80391b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80391e:	8b 40 04             	mov    0x4(%eax),%eax
  803921:	85 c0                	test   %eax,%eax
  803923:	74 0f                	je     803934 <insert_sorted_with_merge_freeList+0x710>
  803925:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803928:	8b 40 04             	mov    0x4(%eax),%eax
  80392b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80392e:	8b 12                	mov    (%edx),%edx
  803930:	89 10                	mov    %edx,(%eax)
  803932:	eb 0a                	jmp    80393e <insert_sorted_with_merge_freeList+0x71a>
  803934:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803937:	8b 00                	mov    (%eax),%eax
  803939:	a3 38 51 80 00       	mov    %eax,0x805138
  80393e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803941:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80394a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803951:	a1 44 51 80 00       	mov    0x805144,%eax
  803956:	48                   	dec    %eax
  803957:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80395c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803960:	75 17                	jne    803979 <insert_sorted_with_merge_freeList+0x755>
  803962:	83 ec 04             	sub    $0x4,%esp
  803965:	68 74 44 80 00       	push   $0x804474
  80396a:	68 37 01 00 00       	push   $0x137
  80396f:	68 97 44 80 00       	push   $0x804497
  803974:	e8 cb d2 ff ff       	call   800c44 <_panic>
  803979:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80397f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803982:	89 10                	mov    %edx,(%eax)
  803984:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803987:	8b 00                	mov    (%eax),%eax
  803989:	85 c0                	test   %eax,%eax
  80398b:	74 0d                	je     80399a <insert_sorted_with_merge_freeList+0x776>
  80398d:	a1 48 51 80 00       	mov    0x805148,%eax
  803992:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803995:	89 50 04             	mov    %edx,0x4(%eax)
  803998:	eb 08                	jmp    8039a2 <insert_sorted_with_merge_freeList+0x77e>
  80399a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80399d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8039a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039a5:	a3 48 51 80 00       	mov    %eax,0x805148
  8039aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8039ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b4:	a1 54 51 80 00       	mov    0x805154,%eax
  8039b9:	40                   	inc    %eax
  8039ba:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  8039bf:	eb 38                	jmp    8039f9 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8039c1:	a1 40 51 80 00       	mov    0x805140,%eax
  8039c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8039c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039cd:	74 07                	je     8039d6 <insert_sorted_with_merge_freeList+0x7b2>
  8039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d2:	8b 00                	mov    (%eax),%eax
  8039d4:	eb 05                	jmp    8039db <insert_sorted_with_merge_freeList+0x7b7>
  8039d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8039db:	a3 40 51 80 00       	mov    %eax,0x805140
  8039e0:	a1 40 51 80 00       	mov    0x805140,%eax
  8039e5:	85 c0                	test   %eax,%eax
  8039e7:	0f 85 ef f9 ff ff    	jne    8033dc <insert_sorted_with_merge_freeList+0x1b8>
  8039ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039f1:	0f 85 e5 f9 ff ff    	jne    8033dc <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8039f7:	eb 00                	jmp    8039f9 <insert_sorted_with_merge_freeList+0x7d5>
  8039f9:	90                   	nop
  8039fa:	c9                   	leave  
  8039fb:	c3                   	ret    

008039fc <__udivdi3>:
  8039fc:	55                   	push   %ebp
  8039fd:	57                   	push   %edi
  8039fe:	56                   	push   %esi
  8039ff:	53                   	push   %ebx
  803a00:	83 ec 1c             	sub    $0x1c,%esp
  803a03:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803a07:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803a0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a0f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a13:	89 ca                	mov    %ecx,%edx
  803a15:	89 f8                	mov    %edi,%eax
  803a17:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803a1b:	85 f6                	test   %esi,%esi
  803a1d:	75 2d                	jne    803a4c <__udivdi3+0x50>
  803a1f:	39 cf                	cmp    %ecx,%edi
  803a21:	77 65                	ja     803a88 <__udivdi3+0x8c>
  803a23:	89 fd                	mov    %edi,%ebp
  803a25:	85 ff                	test   %edi,%edi
  803a27:	75 0b                	jne    803a34 <__udivdi3+0x38>
  803a29:	b8 01 00 00 00       	mov    $0x1,%eax
  803a2e:	31 d2                	xor    %edx,%edx
  803a30:	f7 f7                	div    %edi
  803a32:	89 c5                	mov    %eax,%ebp
  803a34:	31 d2                	xor    %edx,%edx
  803a36:	89 c8                	mov    %ecx,%eax
  803a38:	f7 f5                	div    %ebp
  803a3a:	89 c1                	mov    %eax,%ecx
  803a3c:	89 d8                	mov    %ebx,%eax
  803a3e:	f7 f5                	div    %ebp
  803a40:	89 cf                	mov    %ecx,%edi
  803a42:	89 fa                	mov    %edi,%edx
  803a44:	83 c4 1c             	add    $0x1c,%esp
  803a47:	5b                   	pop    %ebx
  803a48:	5e                   	pop    %esi
  803a49:	5f                   	pop    %edi
  803a4a:	5d                   	pop    %ebp
  803a4b:	c3                   	ret    
  803a4c:	39 ce                	cmp    %ecx,%esi
  803a4e:	77 28                	ja     803a78 <__udivdi3+0x7c>
  803a50:	0f bd fe             	bsr    %esi,%edi
  803a53:	83 f7 1f             	xor    $0x1f,%edi
  803a56:	75 40                	jne    803a98 <__udivdi3+0x9c>
  803a58:	39 ce                	cmp    %ecx,%esi
  803a5a:	72 0a                	jb     803a66 <__udivdi3+0x6a>
  803a5c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803a60:	0f 87 9e 00 00 00    	ja     803b04 <__udivdi3+0x108>
  803a66:	b8 01 00 00 00       	mov    $0x1,%eax
  803a6b:	89 fa                	mov    %edi,%edx
  803a6d:	83 c4 1c             	add    $0x1c,%esp
  803a70:	5b                   	pop    %ebx
  803a71:	5e                   	pop    %esi
  803a72:	5f                   	pop    %edi
  803a73:	5d                   	pop    %ebp
  803a74:	c3                   	ret    
  803a75:	8d 76 00             	lea    0x0(%esi),%esi
  803a78:	31 ff                	xor    %edi,%edi
  803a7a:	31 c0                	xor    %eax,%eax
  803a7c:	89 fa                	mov    %edi,%edx
  803a7e:	83 c4 1c             	add    $0x1c,%esp
  803a81:	5b                   	pop    %ebx
  803a82:	5e                   	pop    %esi
  803a83:	5f                   	pop    %edi
  803a84:	5d                   	pop    %ebp
  803a85:	c3                   	ret    
  803a86:	66 90                	xchg   %ax,%ax
  803a88:	89 d8                	mov    %ebx,%eax
  803a8a:	f7 f7                	div    %edi
  803a8c:	31 ff                	xor    %edi,%edi
  803a8e:	89 fa                	mov    %edi,%edx
  803a90:	83 c4 1c             	add    $0x1c,%esp
  803a93:	5b                   	pop    %ebx
  803a94:	5e                   	pop    %esi
  803a95:	5f                   	pop    %edi
  803a96:	5d                   	pop    %ebp
  803a97:	c3                   	ret    
  803a98:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a9d:	89 eb                	mov    %ebp,%ebx
  803a9f:	29 fb                	sub    %edi,%ebx
  803aa1:	89 f9                	mov    %edi,%ecx
  803aa3:	d3 e6                	shl    %cl,%esi
  803aa5:	89 c5                	mov    %eax,%ebp
  803aa7:	88 d9                	mov    %bl,%cl
  803aa9:	d3 ed                	shr    %cl,%ebp
  803aab:	89 e9                	mov    %ebp,%ecx
  803aad:	09 f1                	or     %esi,%ecx
  803aaf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803ab3:	89 f9                	mov    %edi,%ecx
  803ab5:	d3 e0                	shl    %cl,%eax
  803ab7:	89 c5                	mov    %eax,%ebp
  803ab9:	89 d6                	mov    %edx,%esi
  803abb:	88 d9                	mov    %bl,%cl
  803abd:	d3 ee                	shr    %cl,%esi
  803abf:	89 f9                	mov    %edi,%ecx
  803ac1:	d3 e2                	shl    %cl,%edx
  803ac3:	8b 44 24 08          	mov    0x8(%esp),%eax
  803ac7:	88 d9                	mov    %bl,%cl
  803ac9:	d3 e8                	shr    %cl,%eax
  803acb:	09 c2                	or     %eax,%edx
  803acd:	89 d0                	mov    %edx,%eax
  803acf:	89 f2                	mov    %esi,%edx
  803ad1:	f7 74 24 0c          	divl   0xc(%esp)
  803ad5:	89 d6                	mov    %edx,%esi
  803ad7:	89 c3                	mov    %eax,%ebx
  803ad9:	f7 e5                	mul    %ebp
  803adb:	39 d6                	cmp    %edx,%esi
  803add:	72 19                	jb     803af8 <__udivdi3+0xfc>
  803adf:	74 0b                	je     803aec <__udivdi3+0xf0>
  803ae1:	89 d8                	mov    %ebx,%eax
  803ae3:	31 ff                	xor    %edi,%edi
  803ae5:	e9 58 ff ff ff       	jmp    803a42 <__udivdi3+0x46>
  803aea:	66 90                	xchg   %ax,%ax
  803aec:	8b 54 24 08          	mov    0x8(%esp),%edx
  803af0:	89 f9                	mov    %edi,%ecx
  803af2:	d3 e2                	shl    %cl,%edx
  803af4:	39 c2                	cmp    %eax,%edx
  803af6:	73 e9                	jae    803ae1 <__udivdi3+0xe5>
  803af8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803afb:	31 ff                	xor    %edi,%edi
  803afd:	e9 40 ff ff ff       	jmp    803a42 <__udivdi3+0x46>
  803b02:	66 90                	xchg   %ax,%ax
  803b04:	31 c0                	xor    %eax,%eax
  803b06:	e9 37 ff ff ff       	jmp    803a42 <__udivdi3+0x46>
  803b0b:	90                   	nop

00803b0c <__umoddi3>:
  803b0c:	55                   	push   %ebp
  803b0d:	57                   	push   %edi
  803b0e:	56                   	push   %esi
  803b0f:	53                   	push   %ebx
  803b10:	83 ec 1c             	sub    $0x1c,%esp
  803b13:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803b17:	8b 74 24 34          	mov    0x34(%esp),%esi
  803b1b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803b1f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803b23:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803b27:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803b2b:	89 f3                	mov    %esi,%ebx
  803b2d:	89 fa                	mov    %edi,%edx
  803b2f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b33:	89 34 24             	mov    %esi,(%esp)
  803b36:	85 c0                	test   %eax,%eax
  803b38:	75 1a                	jne    803b54 <__umoddi3+0x48>
  803b3a:	39 f7                	cmp    %esi,%edi
  803b3c:	0f 86 a2 00 00 00    	jbe    803be4 <__umoddi3+0xd8>
  803b42:	89 c8                	mov    %ecx,%eax
  803b44:	89 f2                	mov    %esi,%edx
  803b46:	f7 f7                	div    %edi
  803b48:	89 d0                	mov    %edx,%eax
  803b4a:	31 d2                	xor    %edx,%edx
  803b4c:	83 c4 1c             	add    $0x1c,%esp
  803b4f:	5b                   	pop    %ebx
  803b50:	5e                   	pop    %esi
  803b51:	5f                   	pop    %edi
  803b52:	5d                   	pop    %ebp
  803b53:	c3                   	ret    
  803b54:	39 f0                	cmp    %esi,%eax
  803b56:	0f 87 ac 00 00 00    	ja     803c08 <__umoddi3+0xfc>
  803b5c:	0f bd e8             	bsr    %eax,%ebp
  803b5f:	83 f5 1f             	xor    $0x1f,%ebp
  803b62:	0f 84 ac 00 00 00    	je     803c14 <__umoddi3+0x108>
  803b68:	bf 20 00 00 00       	mov    $0x20,%edi
  803b6d:	29 ef                	sub    %ebp,%edi
  803b6f:	89 fe                	mov    %edi,%esi
  803b71:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803b75:	89 e9                	mov    %ebp,%ecx
  803b77:	d3 e0                	shl    %cl,%eax
  803b79:	89 d7                	mov    %edx,%edi
  803b7b:	89 f1                	mov    %esi,%ecx
  803b7d:	d3 ef                	shr    %cl,%edi
  803b7f:	09 c7                	or     %eax,%edi
  803b81:	89 e9                	mov    %ebp,%ecx
  803b83:	d3 e2                	shl    %cl,%edx
  803b85:	89 14 24             	mov    %edx,(%esp)
  803b88:	89 d8                	mov    %ebx,%eax
  803b8a:	d3 e0                	shl    %cl,%eax
  803b8c:	89 c2                	mov    %eax,%edx
  803b8e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b92:	d3 e0                	shl    %cl,%eax
  803b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b98:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b9c:	89 f1                	mov    %esi,%ecx
  803b9e:	d3 e8                	shr    %cl,%eax
  803ba0:	09 d0                	or     %edx,%eax
  803ba2:	d3 eb                	shr    %cl,%ebx
  803ba4:	89 da                	mov    %ebx,%edx
  803ba6:	f7 f7                	div    %edi
  803ba8:	89 d3                	mov    %edx,%ebx
  803baa:	f7 24 24             	mull   (%esp)
  803bad:	89 c6                	mov    %eax,%esi
  803baf:	89 d1                	mov    %edx,%ecx
  803bb1:	39 d3                	cmp    %edx,%ebx
  803bb3:	0f 82 87 00 00 00    	jb     803c40 <__umoddi3+0x134>
  803bb9:	0f 84 91 00 00 00    	je     803c50 <__umoddi3+0x144>
  803bbf:	8b 54 24 04          	mov    0x4(%esp),%edx
  803bc3:	29 f2                	sub    %esi,%edx
  803bc5:	19 cb                	sbb    %ecx,%ebx
  803bc7:	89 d8                	mov    %ebx,%eax
  803bc9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803bcd:	d3 e0                	shl    %cl,%eax
  803bcf:	89 e9                	mov    %ebp,%ecx
  803bd1:	d3 ea                	shr    %cl,%edx
  803bd3:	09 d0                	or     %edx,%eax
  803bd5:	89 e9                	mov    %ebp,%ecx
  803bd7:	d3 eb                	shr    %cl,%ebx
  803bd9:	89 da                	mov    %ebx,%edx
  803bdb:	83 c4 1c             	add    $0x1c,%esp
  803bde:	5b                   	pop    %ebx
  803bdf:	5e                   	pop    %esi
  803be0:	5f                   	pop    %edi
  803be1:	5d                   	pop    %ebp
  803be2:	c3                   	ret    
  803be3:	90                   	nop
  803be4:	89 fd                	mov    %edi,%ebp
  803be6:	85 ff                	test   %edi,%edi
  803be8:	75 0b                	jne    803bf5 <__umoddi3+0xe9>
  803bea:	b8 01 00 00 00       	mov    $0x1,%eax
  803bef:	31 d2                	xor    %edx,%edx
  803bf1:	f7 f7                	div    %edi
  803bf3:	89 c5                	mov    %eax,%ebp
  803bf5:	89 f0                	mov    %esi,%eax
  803bf7:	31 d2                	xor    %edx,%edx
  803bf9:	f7 f5                	div    %ebp
  803bfb:	89 c8                	mov    %ecx,%eax
  803bfd:	f7 f5                	div    %ebp
  803bff:	89 d0                	mov    %edx,%eax
  803c01:	e9 44 ff ff ff       	jmp    803b4a <__umoddi3+0x3e>
  803c06:	66 90                	xchg   %ax,%ax
  803c08:	89 c8                	mov    %ecx,%eax
  803c0a:	89 f2                	mov    %esi,%edx
  803c0c:	83 c4 1c             	add    $0x1c,%esp
  803c0f:	5b                   	pop    %ebx
  803c10:	5e                   	pop    %esi
  803c11:	5f                   	pop    %edi
  803c12:	5d                   	pop    %ebp
  803c13:	c3                   	ret    
  803c14:	3b 04 24             	cmp    (%esp),%eax
  803c17:	72 06                	jb     803c1f <__umoddi3+0x113>
  803c19:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803c1d:	77 0f                	ja     803c2e <__umoddi3+0x122>
  803c1f:	89 f2                	mov    %esi,%edx
  803c21:	29 f9                	sub    %edi,%ecx
  803c23:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803c27:	89 14 24             	mov    %edx,(%esp)
  803c2a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803c2e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803c32:	8b 14 24             	mov    (%esp),%edx
  803c35:	83 c4 1c             	add    $0x1c,%esp
  803c38:	5b                   	pop    %ebx
  803c39:	5e                   	pop    %esi
  803c3a:	5f                   	pop    %edi
  803c3b:	5d                   	pop    %ebp
  803c3c:	c3                   	ret    
  803c3d:	8d 76 00             	lea    0x0(%esi),%esi
  803c40:	2b 04 24             	sub    (%esp),%eax
  803c43:	19 fa                	sbb    %edi,%edx
  803c45:	89 d1                	mov    %edx,%ecx
  803c47:	89 c6                	mov    %eax,%esi
  803c49:	e9 71 ff ff ff       	jmp    803bbf <__umoddi3+0xb3>
  803c4e:	66 90                	xchg   %ax,%ax
  803c50:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803c54:	72 ea                	jb     803c40 <__umoddi3+0x134>
  803c56:	89 d9                	mov    %ebx,%ecx
  803c58:	e9 62 ff ff ff       	jmp    803bbf <__umoddi3+0xb3>
