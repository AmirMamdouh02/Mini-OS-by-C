
obj/user/tst_first_fit_3:     file format elf32-i386


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
  800031:	e8 50 0d 00 00       	call   800d86 <libmain>
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

	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 7e 2a 00 00       	call   802ac8 <sys_set_uheap_strategy>
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
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

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
  80009b:	68 e0 3e 80 00       	push   $0x803ee0
  8000a0:	6a 16                	push   $0x16
  8000a2:	68 fc 3e 80 00       	push   $0x803efc
  8000a7:	e8 16 0e 00 00       	call   800ec2 <_panic>
	}

	int envID = sys_getenvid();
  8000ac:	e8 c9 27 00 00       	call   80287a <sys_getenvid>
  8000b1:	89 45 ec             	mov    %eax,-0x14(%ebp)

	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  8000b4:	83 ec 0c             	sub    $0xc,%esp
  8000b7:	6a 00                	push   $0x0
  8000b9:	e8 57 20 00 00       	call   802115 <malloc>
  8000be:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int Mega = 1024*1024;
  8000c1:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  8000c8:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  8000cf:	8d 55 8c             	lea    -0x74(%ebp),%edx
  8000d2:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8000dc:	89 d7                	mov    %edx,%edi
  8000de:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	//[1] Allocate all
	{
		//Allocate Shared 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8000e0:	e8 ce 24 00 00       	call   8025b3 <sys_calculate_free_frames>
  8000e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8000e8:	e8 66 25 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8000ed:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = smalloc("x", 1*Mega, 1);
  8000f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f3:	83 ec 04             	sub    $0x4,%esp
  8000f6:	6a 01                	push   $0x1
  8000f8:	50                   	push   %eax
  8000f9:	68 13 3f 80 00       	push   $0x803f13
  8000fe:	e8 8d 21 00 00       	call   802290 <smalloc>
  800103:	83 c4 10             	add    $0x10,%esp
  800106:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if (ptr_allocations[0] != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800109:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80010c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800111:	74 14                	je     800127 <_main+0xef>
  800113:	83 ec 04             	sub    $0x4,%esp
  800116:	68 18 3f 80 00       	push   $0x803f18
  80011b:	6a 2a                	push   $0x2a
  80011d:	68 fc 3e 80 00       	push   $0x803efc
  800122:	e8 9b 0d 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  256+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800127:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80012a:	e8 84 24 00 00       	call   8025b3 <sys_calculate_free_frames>
  80012f:	29 c3                	sub    %eax,%ebx
  800131:	89 d8                	mov    %ebx,%eax
  800133:	3d 03 01 00 00       	cmp    $0x103,%eax
  800138:	74 14                	je     80014e <_main+0x116>
  80013a:	83 ec 04             	sub    $0x4,%esp
  80013d:	68 84 3f 80 00       	push   $0x803f84
  800142:	6a 2b                	push   $0x2b
  800144:	68 fc 3e 80 00       	push   $0x803efc
  800149:	e8 74 0d 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80014e:	e8 00 25 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800153:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800156:	74 14                	je     80016c <_main+0x134>
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 02 40 80 00       	push   $0x804002
  800160:	6a 2c                	push   $0x2c
  800162:	68 fc 3e 80 00       	push   $0x803efc
  800167:	e8 56 0d 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  80016c:	e8 42 24 00 00       	call   8025b3 <sys_calculate_free_frames>
  800171:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800174:	e8 da 24 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800179:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  80017c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80017f:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	50                   	push   %eax
  800186:	e8 8a 1f 00 00       	call   802115 <malloc>
  80018b:	83 c4 10             	add    $0x10,%esp
  80018e:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  800191:	8b 45 90             	mov    -0x70(%ebp),%eax
  800194:	89 c2                	mov    %eax,%edx
  800196:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800199:	05 00 00 00 80       	add    $0x80000000,%eax
  80019e:	39 c2                	cmp    %eax,%edx
  8001a0:	74 14                	je     8001b6 <_main+0x17e>
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 20 40 80 00       	push   $0x804020
  8001aa:	6a 32                	push   $0x32
  8001ac:	68 fc 3e 80 00       	push   $0x803efc
  8001b1:	e8 0c 0d 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8001b6:	e8 98 24 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8001bb:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 02 40 80 00       	push   $0x804002
  8001c8:	6a 34                	push   $0x34
  8001ca:	68 fc 3e 80 00       	push   $0x803efc
  8001cf:	e8 ee 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8001d4:	e8 da 23 00 00       	call   8025b3 <sys_calculate_free_frames>
  8001d9:	89 c2                	mov    %eax,%edx
  8001db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001de:	39 c2                	cmp    %eax,%edx
  8001e0:	74 14                	je     8001f6 <_main+0x1be>
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	68 50 40 80 00       	push   $0x804050
  8001ea:	6a 35                	push   $0x35
  8001ec:	68 fc 3e 80 00       	push   $0x803efc
  8001f1:	e8 cc 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  8001f6:	e8 b8 23 00 00       	call   8025b3 <sys_calculate_free_frames>
  8001fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001fe:	e8 50 24 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800203:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  800206:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800209:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80020c:	83 ec 0c             	sub    $0xc,%esp
  80020f:	50                   	push   %eax
  800210:	e8 00 1f 00 00       	call   802115 <malloc>
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  80021b:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80021e:	89 c2                	mov    %eax,%edx
  800220:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800223:	01 c0                	add    %eax,%eax
  800225:	05 00 00 00 80       	add    $0x80000000,%eax
  80022a:	39 c2                	cmp    %eax,%edx
  80022c:	74 14                	je     800242 <_main+0x20a>
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	68 20 40 80 00       	push   $0x804020
  800236:	6a 3b                	push   $0x3b
  800238:	68 fc 3e 80 00       	push   $0x803efc
  80023d:	e8 80 0c 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800242:	e8 0c 24 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800247:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80024a:	74 14                	je     800260 <_main+0x228>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	68 02 40 80 00       	push   $0x804002
  800254:	6a 3d                	push   $0x3d
  800256:	68 fc 3e 80 00       	push   $0x803efc
  80025b:	e8 62 0c 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  800260:	e8 4e 23 00 00       	call   8025b3 <sys_calculate_free_frames>
  800265:	89 c2                	mov    %eax,%edx
  800267:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80026a:	39 c2                	cmp    %eax,%edx
  80026c:	74 14                	je     800282 <_main+0x24a>
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	68 50 40 80 00       	push   $0x804050
  800276:	6a 3e                	push   $0x3e
  800278:	68 fc 3e 80 00       	push   $0x803efc
  80027d:	e8 40 0c 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800282:	e8 2c 23 00 00       	call   8025b3 <sys_calculate_free_frames>
  800287:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80028a:	e8 c4 23 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  80028f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800292:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800295:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	50                   	push   %eax
  80029c:	e8 74 1e 00 00       	call   802115 <malloc>
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 3*Mega) ) panic("Wrong start address for the allocated space... ");
  8002a7:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002aa:	89 c1                	mov    %eax,%ecx
  8002ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002af:	89 c2                	mov    %eax,%edx
  8002b1:	01 d2                	add    %edx,%edx
  8002b3:	01 d0                	add    %edx,%eax
  8002b5:	05 00 00 00 80       	add    $0x80000000,%eax
  8002ba:	39 c1                	cmp    %eax,%ecx
  8002bc:	74 14                	je     8002d2 <_main+0x29a>
  8002be:	83 ec 04             	sub    $0x4,%esp
  8002c1:	68 20 40 80 00       	push   $0x804020
  8002c6:	6a 44                	push   $0x44
  8002c8:	68 fc 3e 80 00       	push   $0x803efc
  8002cd:	e8 f0 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8002d2:	e8 7c 23 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8002d7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002da:	74 14                	je     8002f0 <_main+0x2b8>
  8002dc:	83 ec 04             	sub    $0x4,%esp
  8002df:	68 02 40 80 00       	push   $0x804002
  8002e4:	6a 46                	push   $0x46
  8002e6:	68 fc 3e 80 00       	push   $0x803efc
  8002eb:	e8 d2 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  8002f0:	e8 be 22 00 00       	call   8025b3 <sys_calculate_free_frames>
  8002f5:	89 c2                	mov    %eax,%edx
  8002f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <_main+0x2da>
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 50 40 80 00       	push   $0x804050
  800306:	6a 47                	push   $0x47
  800308:	68 fc 3e 80 00       	push   $0x803efc
  80030d:	e8 b0 0b 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800312:	e8 9c 22 00 00       	call   8025b3 <sys_calculate_free_frames>
  800317:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80031a:	e8 34 23 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  80031f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  800322:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800325:	01 c0                	add    %eax,%eax
  800327:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80032a:	83 ec 0c             	sub    $0xc,%esp
  80032d:	50                   	push   %eax
  80032e:	e8 e2 1d 00 00       	call   802115 <malloc>
  800333:	83 c4 10             	add    $0x10,%esp
  800336:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800339:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80033c:	89 c2                	mov    %eax,%edx
  80033e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800341:	c1 e0 02             	shl    $0x2,%eax
  800344:	05 00 00 00 80       	add    $0x80000000,%eax
  800349:	39 c2                	cmp    %eax,%edx
  80034b:	74 14                	je     800361 <_main+0x329>
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	68 20 40 80 00       	push   $0x804020
  800355:	6a 4d                	push   $0x4d
  800357:	68 fc 3e 80 00       	push   $0x803efc
  80035c:	e8 61 0b 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800361:	e8 ed 22 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800366:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800369:	74 14                	je     80037f <_main+0x347>
  80036b:	83 ec 04             	sub    $0x4,%esp
  80036e:	68 02 40 80 00       	push   $0x804002
  800373:	6a 4f                	push   $0x4f
  800375:	68 fc 3e 80 00       	push   $0x803efc
  80037a:	e8 43 0b 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80037f:	e8 2f 22 00 00       	call   8025b3 <sys_calculate_free_frames>
  800384:	89 c2                	mov    %eax,%edx
  800386:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	74 14                	je     8003a1 <_main+0x369>
  80038d:	83 ec 04             	sub    $0x4,%esp
  800390:	68 50 40 80 00       	push   $0x804050
  800395:	6a 50                	push   $0x50
  800397:	68 fc 3e 80 00       	push   $0x803efc
  80039c:	e8 21 0b 00 00       	call   800ec2 <_panic>

		//Allocate Shared 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8003a1:	e8 0d 22 00 00       	call   8025b3 <sys_calculate_free_frames>
  8003a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003a9:	e8 a5 22 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8003ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = smalloc("y", 2*Mega, 1);
  8003b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003b4:	01 c0                	add    %eax,%eax
  8003b6:	83 ec 04             	sub    $0x4,%esp
  8003b9:	6a 01                	push   $0x1
  8003bb:	50                   	push   %eax
  8003bc:	68 63 40 80 00       	push   $0x804063
  8003c1:	e8 ca 1e 00 00       	call   802290 <smalloc>
  8003c6:	83 c4 10             	add    $0x10,%esp
  8003c9:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if (ptr_allocations[5] != (uint32*)(USER_HEAP_START + 6*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8003cc:	8b 4d a0             	mov    -0x60(%ebp),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	01 c0                	add    %eax,%eax
  8003da:	05 00 00 00 80       	add    $0x80000000,%eax
  8003df:	39 c1                	cmp    %eax,%ecx
  8003e1:	74 14                	je     8003f7 <_main+0x3bf>
  8003e3:	83 ec 04             	sub    $0x4,%esp
  8003e6:	68 18 3f 80 00       	push   $0x803f18
  8003eb:	6a 56                	push   $0x56
  8003ed:	68 fc 3e 80 00       	push   $0x803efc
  8003f2:	e8 cb 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  512+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8003f7:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8003fa:	e8 b4 21 00 00       	call   8025b3 <sys_calculate_free_frames>
  8003ff:	29 c3                	sub    %eax,%ebx
  800401:	89 d8                	mov    %ebx,%eax
  800403:	3d 03 02 00 00       	cmp    $0x203,%eax
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 84 3f 80 00       	push   $0x803f84
  800412:	6a 57                	push   $0x57
  800414:	68 fc 3e 80 00       	push   $0x803efc
  800419:	e8 a4 0a 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80041e:	e8 30 22 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800423:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800426:	74 14                	je     80043c <_main+0x404>
  800428:	83 ec 04             	sub    $0x4,%esp
  80042b:	68 02 40 80 00       	push   $0x804002
  800430:	6a 58                	push   $0x58
  800432:	68 fc 3e 80 00       	push   $0x803efc
  800437:	e8 86 0a 00 00       	call   800ec2 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  80043c:	e8 72 21 00 00       	call   8025b3 <sys_calculate_free_frames>
  800441:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800444:	e8 0a 22 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800449:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  80044c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044f:	89 c2                	mov    %eax,%edx
  800451:	01 d2                	add    %edx,%edx
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	50                   	push   %eax
  80045c:	e8 b4 1c 00 00       	call   802115 <malloc>
  800461:	83 c4 10             	add    $0x10,%esp
  800464:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800467:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80046a:	89 c2                	mov    %eax,%edx
  80046c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80046f:	c1 e0 03             	shl    $0x3,%eax
  800472:	05 00 00 00 80       	add    $0x80000000,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 20 40 80 00       	push   $0x804020
  800483:	6a 5e                	push   $0x5e
  800485:	68 fc 3e 80 00       	push   $0x803efc
  80048a:	e8 33 0a 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80048f:	e8 bf 21 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800494:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800497:	74 14                	je     8004ad <_main+0x475>
  800499:	83 ec 04             	sub    $0x4,%esp
  80049c:	68 02 40 80 00       	push   $0x804002
  8004a1:	6a 60                	push   $0x60
  8004a3:	68 fc 3e 80 00       	push   $0x803efc
  8004a8:	e8 15 0a 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8004ad:	e8 01 21 00 00       	call   8025b3 <sys_calculate_free_frames>
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004b7:	39 c2                	cmp    %eax,%edx
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 50 40 80 00       	push   $0x804050
  8004c3:	6a 61                	push   $0x61
  8004c5:	68 fc 3e 80 00       	push   $0x803efc
  8004ca:	e8 f3 09 00 00       	call   800ec2 <_panic>

		//Allocate Shared 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8004cf:	e8 df 20 00 00       	call   8025b3 <sys_calculate_free_frames>
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004d7:	e8 77 21 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8004dc:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = smalloc("z", 3*Mega, 0);
  8004df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004e2:	89 c2                	mov    %eax,%edx
  8004e4:	01 d2                	add    %edx,%edx
  8004e6:	01 d0                	add    %edx,%eax
  8004e8:	83 ec 04             	sub    $0x4,%esp
  8004eb:	6a 00                	push   $0x0
  8004ed:	50                   	push   %eax
  8004ee:	68 65 40 80 00       	push   $0x804065
  8004f3:	e8 98 1d 00 00       	call   802290 <smalloc>
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if (ptr_allocations[7] != (uint32*)(USER_HEAP_START + 11*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8004fe:	8b 4d a8             	mov    -0x58(%ebp),%ecx
  800501:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	c1 e0 02             	shl    $0x2,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	01 c0                	add    %eax,%eax
  80050d:	01 d0                	add    %edx,%eax
  80050f:	05 00 00 00 80       	add    $0x80000000,%eax
  800514:	39 c1                	cmp    %eax,%ecx
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 18 3f 80 00       	push   $0x803f18
  800520:	6a 67                	push   $0x67
  800522:	68 fc 3e 80 00       	push   $0x803efc
  800527:	e8 96 09 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  768+2+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  80052c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80052f:	e8 7f 20 00 00       	call   8025b3 <sys_calculate_free_frames>
  800534:	29 c3                	sub    %eax,%ebx
  800536:	89 d8                	mov    %ebx,%eax
  800538:	3d 04 03 00 00       	cmp    $0x304,%eax
  80053d:	74 14                	je     800553 <_main+0x51b>
  80053f:	83 ec 04             	sub    $0x4,%esp
  800542:	68 84 3f 80 00       	push   $0x803f84
  800547:	6a 68                	push   $0x68
  800549:	68 fc 3e 80 00       	push   $0x803efc
  80054e:	e8 6f 09 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800553:	e8 fb 20 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800558:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 02 40 80 00       	push   $0x804002
  800565:	6a 69                	push   $0x69
  800567:	68 fc 3e 80 00       	push   $0x803efc
  80056c:	e8 51 09 00 00       	call   800ec2 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800571:	e8 3d 20 00 00       	call   8025b3 <sys_calculate_free_frames>
  800576:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800579:	e8 d5 20 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  80057e:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  800581:	8b 45 90             	mov    -0x70(%ebp),%eax
  800584:	83 ec 0c             	sub    $0xc,%esp
  800587:	50                   	push   %eax
  800588:	e8 21 1c 00 00       	call   8021ae <free>
  80058d:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800590:	e8 be 20 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800595:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800598:	74 14                	je     8005ae <_main+0x576>
  80059a:	83 ec 04             	sub    $0x4,%esp
  80059d:	68 67 40 80 00       	push   $0x804067
  8005a2:	6a 73                	push   $0x73
  8005a4:	68 fc 3e 80 00       	push   $0x803efc
  8005a9:	e8 14 09 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8005ae:	e8 00 20 00 00       	call   8025b3 <sys_calculate_free_frames>
  8005b3:	89 c2                	mov    %eax,%edx
  8005b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b8:	39 c2                	cmp    %eax,%edx
  8005ba:	74 14                	je     8005d0 <_main+0x598>
  8005bc:	83 ec 04             	sub    $0x4,%esp
  8005bf:	68 7e 40 80 00       	push   $0x80407e
  8005c4:	6a 74                	push   $0x74
  8005c6:	68 fc 3e 80 00       	push   $0x803efc
  8005cb:	e8 f2 08 00 00       	call   800ec2 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005d0:	e8 de 1f 00 00       	call   8025b3 <sys_calculate_free_frames>
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005d8:	e8 76 20 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  8005e0:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8005e3:	83 ec 0c             	sub    $0xc,%esp
  8005e6:	50                   	push   %eax
  8005e7:	e8 c2 1b 00 00       	call   8021ae <free>
  8005ec:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8005ef:	e8 5f 20 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8005f4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8005f7:	74 14                	je     80060d <_main+0x5d5>
  8005f9:	83 ec 04             	sub    $0x4,%esp
  8005fc:	68 67 40 80 00       	push   $0x804067
  800601:	6a 7b                	push   $0x7b
  800603:	68 fc 3e 80 00       	push   $0x803efc
  800608:	e8 b5 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80060d:	e8 a1 1f 00 00       	call   8025b3 <sys_calculate_free_frames>
  800612:	89 c2                	mov    %eax,%edx
  800614:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800617:	39 c2                	cmp    %eax,%edx
  800619:	74 14                	je     80062f <_main+0x5f7>
  80061b:	83 ec 04             	sub    $0x4,%esp
  80061e:	68 7e 40 80 00       	push   $0x80407e
  800623:	6a 7c                	push   $0x7c
  800625:	68 fc 3e 80 00       	push   $0x803efc
  80062a:	e8 93 08 00 00       	call   800ec2 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80062f:	e8 7f 1f 00 00       	call   8025b3 <sys_calculate_free_frames>
  800634:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800637:	e8 17 20 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  80063c:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  80063f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800642:	83 ec 0c             	sub    $0xc,%esp
  800645:	50                   	push   %eax
  800646:	e8 63 1b 00 00       	call   8021ae <free>
  80064b:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  80064e:	e8 00 20 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800653:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800656:	74 17                	je     80066f <_main+0x637>
  800658:	83 ec 04             	sub    $0x4,%esp
  80065b:	68 67 40 80 00       	push   $0x804067
  800660:	68 83 00 00 00       	push   $0x83
  800665:	68 fc 3e 80 00       	push   $0x803efc
  80066a:	e8 53 08 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  80066f:	e8 3f 1f 00 00       	call   8025b3 <sys_calculate_free_frames>
  800674:	89 c2                	mov    %eax,%edx
  800676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800679:	39 c2                	cmp    %eax,%edx
  80067b:	74 17                	je     800694 <_main+0x65c>
  80067d:	83 ec 04             	sub    $0x4,%esp
  800680:	68 7e 40 80 00       	push   $0x80407e
  800685:	68 84 00 00 00       	push   $0x84
  80068a:	68 fc 3e 80 00       	push   $0x803efc
  80068f:	e8 2e 08 00 00       	call   800ec2 <_panic>
	}

	//[3] Allocate again [test first fit]
	{
		//Allocate 512 KB - should be placed in 1st hole
		freeFrames = sys_calculate_free_frames() ;
  800694:	e8 1a 1f 00 00       	call   8025b3 <sys_calculate_free_frames>
  800699:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80069c:	e8 b2 1f 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8006a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc(512*kilo - kilo);
  8006a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006a7:	89 d0                	mov    %edx,%eax
  8006a9:	c1 e0 09             	shl    $0x9,%eax
  8006ac:	29 d0                	sub    %edx,%eax
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	50                   	push   %eax
  8006b2:	e8 5e 1a 00 00       	call   802115 <malloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  8006bd:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006c5:	05 00 00 00 80       	add    $0x80000000,%eax
  8006ca:	39 c2                	cmp    %eax,%edx
  8006cc:	74 17                	je     8006e5 <_main+0x6ad>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 20 40 80 00       	push   $0x804020
  8006d6:	68 8d 00 00 00       	push   $0x8d
  8006db:	68 fc 3e 80 00       	push   $0x803efc
  8006e0:	e8 dd 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 128) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8006e5:	e8 69 1f 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8006ea:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8006ed:	74 17                	je     800706 <_main+0x6ce>
  8006ef:	83 ec 04             	sub    $0x4,%esp
  8006f2:	68 02 40 80 00       	push   $0x804002
  8006f7:	68 8f 00 00 00       	push   $0x8f
  8006fc:	68 fc 3e 80 00       	push   $0x803efc
  800701:	e8 bc 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800706:	e8 a8 1e 00 00       	call   8025b3 <sys_calculate_free_frames>
  80070b:	89 c2                	mov    %eax,%edx
  80070d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800710:	39 c2                	cmp    %eax,%edx
  800712:	74 17                	je     80072b <_main+0x6f3>
  800714:	83 ec 04             	sub    $0x4,%esp
  800717:	68 50 40 80 00       	push   $0x804050
  80071c:	68 90 00 00 00       	push   $0x90
  800721:	68 fc 3e 80 00       	push   $0x803efc
  800726:	e8 97 07 00 00       	call   800ec2 <_panic>

		//Allocate 1 MB - should be placed in 2nd hole
		freeFrames = sys_calculate_free_frames() ;
  80072b:	e8 83 1e 00 00       	call   8025b3 <sys_calculate_free_frames>
  800730:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800733:	e8 1b 1f 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800738:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[9] = malloc(1*Mega - kilo);
  80073b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80073e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	50                   	push   %eax
  800745:	e8 cb 19 00 00       	call   802115 <malloc>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  800750:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800753:	89 c2                	mov    %eax,%edx
  800755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800758:	c1 e0 02             	shl    $0x2,%eax
  80075b:	05 00 00 00 80       	add    $0x80000000,%eax
  800760:	39 c2                	cmp    %eax,%edx
  800762:	74 17                	je     80077b <_main+0x743>
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	68 20 40 80 00       	push   $0x804020
  80076c:	68 96 00 00 00       	push   $0x96
  800771:	68 fc 3e 80 00       	push   $0x803efc
  800776:	e8 47 07 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  80077b:	e8 d3 1e 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800780:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800783:	74 17                	je     80079c <_main+0x764>
  800785:	83 ec 04             	sub    $0x4,%esp
  800788:	68 02 40 80 00       	push   $0x804002
  80078d:	68 98 00 00 00       	push   $0x98
  800792:	68 fc 3e 80 00       	push   $0x803efc
  800797:	e8 26 07 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  80079c:	e8 12 1e 00 00       	call   8025b3 <sys_calculate_free_frames>
  8007a1:	89 c2                	mov    %eax,%edx
  8007a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007a6:	39 c2                	cmp    %eax,%edx
  8007a8:	74 17                	je     8007c1 <_main+0x789>
  8007aa:	83 ec 04             	sub    $0x4,%esp
  8007ad:	68 50 40 80 00       	push   $0x804050
  8007b2:	68 99 00 00 00       	push   $0x99
  8007b7:	68 fc 3e 80 00       	push   $0x803efc
  8007bc:	e8 01 07 00 00       	call   800ec2 <_panic>

		//Allocate Shared 256 KB - should be placed in remaining of 1st hole
		freeFrames = sys_calculate_free_frames() ;
  8007c1:	e8 ed 1d 00 00       	call   8025b3 <sys_calculate_free_frames>
  8007c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8007c9:	e8 85 1e 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8007ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[10] = malloc(256*kilo - kilo);
		ptr_allocations[10] = smalloc("a", 256*kilo - kilo, 0);
  8007d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007d4:	89 d0                	mov    %edx,%eax
  8007d6:	c1 e0 08             	shl    $0x8,%eax
  8007d9:	29 d0                	sub    %edx,%eax
  8007db:	83 ec 04             	sub    $0x4,%esp
  8007de:	6a 00                	push   $0x0
  8007e0:	50                   	push   %eax
  8007e1:	68 8b 40 80 00       	push   $0x80408b
  8007e6:	e8 a5 1a 00 00       	call   802290 <smalloc>
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 1*Mega + 512*kilo)) panic("Wrong start address for the allocated space... ");
  8007f1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8007f4:	89 c2                	mov    %eax,%edx
  8007f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007f9:	c1 e0 09             	shl    $0x9,%eax
  8007fc:	89 c1                	mov    %eax,%ecx
  8007fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800801:	01 c8                	add    %ecx,%eax
  800803:	05 00 00 00 80       	add    $0x80000000,%eax
  800808:	39 c2                	cmp    %eax,%edx
  80080a:	74 17                	je     800823 <_main+0x7eb>
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 20 40 80 00       	push   $0x804020
  800814:	68 a0 00 00 00       	push   $0xa0
  800819:	68 fc 3e 80 00       	push   $0x803efc
  80081e:	e8 9f 06 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800823:	e8 2b 1e 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800828:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  80082b:	74 17                	je     800844 <_main+0x80c>
  80082d:	83 ec 04             	sub    $0x4,%esp
  800830:	68 02 40 80 00       	push   $0x804002
  800835:	68 a1 00 00 00       	push   $0xa1
  80083a:	68 fc 3e 80 00       	push   $0x803efc
  80083f:	e8 7e 06 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 64+0+2) panic("Wrong allocation: %d", (freeFrames - sys_calculate_free_frames()));
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800847:	e8 67 1d 00 00       	call   8025b3 <sys_calculate_free_frames>
  80084c:	29 c3                	sub    %eax,%ebx
  80084e:	89 d8                	mov    %ebx,%eax
  800850:	83 f8 42             	cmp    $0x42,%eax
  800853:	74 21                	je     800876 <_main+0x83e>
  800855:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800858:	e8 56 1d 00 00       	call   8025b3 <sys_calculate_free_frames>
  80085d:	29 c3                	sub    %eax,%ebx
  80085f:	89 d8                	mov    %ebx,%eax
  800861:	50                   	push   %eax
  800862:	68 8d 40 80 00       	push   $0x80408d
  800867:	68 a2 00 00 00       	push   $0xa2
  80086c:	68 fc 3e 80 00       	push   $0x803efc
  800871:	e8 4c 06 00 00       	call   800ec2 <_panic>

		//Allocate 2 MB - should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800876:	e8 38 1d 00 00       	call   8025b3 <sys_calculate_free_frames>
  80087b:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80087e:	e8 d0 1d 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800883:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[11] = malloc(2*Mega);
  800886:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	83 ec 0c             	sub    $0xc,%esp
  80088e:	50                   	push   %eax
  80088f:	e8 81 18 00 00       	call   802115 <malloc>
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  80089a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80089d:	89 c2                	mov    %eax,%edx
  80089f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008a2:	c1 e0 03             	shl    $0x3,%eax
  8008a5:	05 00 00 00 80       	add    $0x80000000,%eax
  8008aa:	39 c2                	cmp    %eax,%edx
  8008ac:	74 17                	je     8008c5 <_main+0x88d>
  8008ae:	83 ec 04             	sub    $0x4,%esp
  8008b1:	68 20 40 80 00       	push   $0x804020
  8008b6:	68 a8 00 00 00       	push   $0xa8
  8008bb:	68 fc 3e 80 00       	push   $0x803efc
  8008c0:	e8 fd 05 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  8008c5:	e8 89 1d 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8008ca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8008cd:	74 17                	je     8008e6 <_main+0x8ae>
  8008cf:	83 ec 04             	sub    $0x4,%esp
  8008d2:	68 02 40 80 00       	push   $0x804002
  8008d7:	68 aa 00 00 00       	push   $0xaa
  8008dc:	68 fc 3e 80 00       	push   $0x803efc
  8008e1:	e8 dc 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  8008e6:	e8 c8 1c 00 00       	call   8025b3 <sys_calculate_free_frames>
  8008eb:	89 c2                	mov    %eax,%edx
  8008ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f0:	39 c2                	cmp    %eax,%edx
  8008f2:	74 17                	je     80090b <_main+0x8d3>
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 50 40 80 00       	push   $0x804050
  8008fc:	68 ab 00 00 00       	push   $0xab
  800901:	68 fc 3e 80 00       	push   $0x803efc
  800906:	e8 b7 05 00 00       	call   800ec2 <_panic>

		//Allocate 4 MB - should be placed in end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  80090b:	e8 a3 1c 00 00       	call   8025b3 <sys_calculate_free_frames>
  800910:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800913:	e8 3b 1d 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800918:	89 45 dc             	mov    %eax,-0x24(%ebp)
		//ptr_allocations[12] = malloc(4*Mega - kilo);
		ptr_allocations[12] = smalloc("b", 4*Mega - kilo, 0);
  80091b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091e:	c1 e0 02             	shl    $0x2,%eax
  800921:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	6a 00                	push   $0x0
  800929:	50                   	push   %eax
  80092a:	68 a2 40 80 00       	push   $0x8040a2
  80092f:	e8 5c 19 00 00       	call   802290 <smalloc>
  800934:	83 c4 10             	add    $0x10,%esp
  800937:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[12] != (USER_HEAP_START + 14*Mega) ) panic("Wrong start address for the allocated space... ");
  80093a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80093d:	89 c1                	mov    %eax,%ecx
  80093f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800942:	89 d0                	mov    %edx,%eax
  800944:	01 c0                	add    %eax,%eax
  800946:	01 d0                	add    %edx,%eax
  800948:	01 c0                	add    %eax,%eax
  80094a:	01 d0                	add    %edx,%eax
  80094c:	01 c0                	add    %eax,%eax
  80094e:	05 00 00 00 80       	add    $0x80000000,%eax
  800953:	39 c1                	cmp    %eax,%ecx
  800955:	74 17                	je     80096e <_main+0x936>
  800957:	83 ec 04             	sub    $0x4,%esp
  80095a:	68 20 40 80 00       	push   $0x804020
  80095f:	68 b2 00 00 00       	push   $0xb2
  800964:	68 fc 3e 80 00       	push   $0x803efc
  800969:	e8 54 05 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 1024+1+2) panic("Wrong allocation: ");
  80096e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800971:	e8 3d 1c 00 00       	call   8025b3 <sys_calculate_free_frames>
  800976:	29 c3                	sub    %eax,%ebx
  800978:	89 d8                	mov    %ebx,%eax
  80097a:	3d 03 04 00 00       	cmp    $0x403,%eax
  80097f:	74 17                	je     800998 <_main+0x960>
  800981:	83 ec 04             	sub    $0x4,%esp
  800984:	68 50 40 80 00       	push   $0x804050
  800989:	68 b3 00 00 00       	push   $0xb3
  80098e:	68 fc 3e 80 00       	push   $0x803efc
  800993:	e8 2a 05 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800998:	e8 b6 1c 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  80099d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009a0:	74 17                	je     8009b9 <_main+0x981>
  8009a2:	83 ec 04             	sub    $0x4,%esp
  8009a5:	68 02 40 80 00       	push   $0x804002
  8009aa:	68 b4 00 00 00       	push   $0xb4
  8009af:	68 fc 3e 80 00       	push   $0x803efc
  8009b4:	e8 09 05 00 00       	call   800ec2 <_panic>
	}

	//[4] Free contiguous allocations
	{
		//1 MB Hole appended to previous 256 KB hole
		freeFrames = sys_calculate_free_frames() ;
  8009b9:	e8 f5 1b 00 00       	call   8025b3 <sys_calculate_free_frames>
  8009be:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8009c1:	e8 8d 1c 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8009c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[2]);
  8009c9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8009cc:	83 ec 0c             	sub    $0xc,%esp
  8009cf:	50                   	push   %eax
  8009d0:	e8 d9 17 00 00       	call   8021ae <free>
  8009d5:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  8009d8:	e8 76 1c 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  8009dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8009e0:	74 17                	je     8009f9 <_main+0x9c1>
  8009e2:	83 ec 04             	sub    $0x4,%esp
  8009e5:	68 67 40 80 00       	push   $0x804067
  8009ea:	68 bf 00 00 00       	push   $0xbf
  8009ef:	68 fc 3e 80 00       	push   $0x803efc
  8009f4:	e8 c9 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  8009f9:	e8 b5 1b 00 00       	call   8025b3 <sys_calculate_free_frames>
  8009fe:	89 c2                	mov    %eax,%edx
  800a00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a03:	39 c2                	cmp    %eax,%edx
  800a05:	74 17                	je     800a1e <_main+0x9e6>
  800a07:	83 ec 04             	sub    $0x4,%esp
  800a0a:	68 7e 40 80 00       	push   $0x80407e
  800a0f:	68 c0 00 00 00       	push   $0xc0
  800a14:	68 fc 3e 80 00       	push   $0x803efc
  800a19:	e8 a4 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to next 1 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a1e:	e8 90 1b 00 00       	call   8025b3 <sys_calculate_free_frames>
  800a23:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a26:	e8 28 1c 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800a2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[9]);
  800a2e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800a31:	83 ec 0c             	sub    $0xc,%esp
  800a34:	50                   	push   %eax
  800a35:	e8 74 17 00 00       	call   8021ae <free>
  800a3a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800a3d:	e8 11 1c 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800a42:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800a45:	74 17                	je     800a5e <_main+0xa26>
  800a47:	83 ec 04             	sub    $0x4,%esp
  800a4a:	68 67 40 80 00       	push   $0x804067
  800a4f:	68 c7 00 00 00       	push   $0xc7
  800a54:	68 fc 3e 80 00       	push   $0x803efc
  800a59:	e8 64 04 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800a5e:	e8 50 1b 00 00       	call   8025b3 <sys_calculate_free_frames>
  800a63:	89 c2                	mov    %eax,%edx
  800a65:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a68:	39 c2                	cmp    %eax,%edx
  800a6a:	74 17                	je     800a83 <_main+0xa4b>
  800a6c:	83 ec 04             	sub    $0x4,%esp
  800a6f:	68 7e 40 80 00       	push   $0x80407e
  800a74:	68 c8 00 00 00       	push   $0xc8
  800a79:	68 fc 3e 80 00       	push   $0x803efc
  800a7e:	e8 3f 04 00 00       	call   800ec2 <_panic>

		//1 MB Hole appended to previous 1 MB + 256 KB hole and next 2 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800a83:	e8 2b 1b 00 00       	call   8025b3 <sys_calculate_free_frames>
  800a88:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800a8b:	e8 c3 1b 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800a90:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800a93:	8b 45 98             	mov    -0x68(%ebp),%eax
  800a96:	83 ec 0c             	sub    $0xc,%esp
  800a99:	50                   	push   %eax
  800a9a:	e8 0f 17 00 00       	call   8021ae <free>
  800a9f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  0) panic("Wrong page file free: ");
  800aa2:	e8 ac 1b 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800aa7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800aaa:	74 17                	je     800ac3 <_main+0xa8b>
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	68 67 40 80 00       	push   $0x804067
  800ab4:	68 cf 00 00 00       	push   $0xcf
  800ab9:	68 fc 3e 80 00       	push   $0x803efc
  800abe:	e8 ff 03 00 00       	call   800ec2 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: ");
  800ac3:	e8 eb 1a 00 00       	call   8025b3 <sys_calculate_free_frames>
  800ac8:	89 c2                	mov    %eax,%edx
  800aca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acd:	39 c2                	cmp    %eax,%edx
  800acf:	74 17                	je     800ae8 <_main+0xab0>
  800ad1:	83 ec 04             	sub    $0x4,%esp
  800ad4:	68 7e 40 80 00       	push   $0x80407e
  800ad9:	68 d0 00 00 00       	push   $0xd0
  800ade:	68 fc 3e 80 00       	push   $0x803efc
  800ae3:	e8 da 03 00 00       	call   800ec2 <_panic>

	//[5] Allocate again [test first fit]
	{
		//[FIRST FIT Case]
		//Allocate 1 MB + 256 KB - should be placed in the contiguous hole (256 KB + 4 MB)
		freeFrames = sys_calculate_free_frames() ;
  800ae8:	e8 c6 1a 00 00       	call   8025b3 <sys_calculate_free_frames>
  800aed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800af0:	e8 5e 1b 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800af5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[13] = malloc(1*Mega + 256*kilo - kilo);
  800af8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800afb:	c1 e0 08             	shl    $0x8,%eax
  800afe:	89 c2                	mov    %eax,%edx
  800b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b03:	01 d0                	add    %edx,%eax
  800b05:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800b08:	83 ec 0c             	sub    $0xc,%esp
  800b0b:	50                   	push   %eax
  800b0c:	e8 04 16 00 00       	call   802115 <malloc>
  800b11:	83 c4 10             	add    $0x10,%esp
  800b14:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((uint32) ptr_allocations[13] != (USER_HEAP_START + 1*Mega + 768*kilo)) panic("Wrong start address for the allocated space... ");
  800b17:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800b1a:	89 c1                	mov    %eax,%ecx
  800b1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b1f:	89 d0                	mov    %edx,%eax
  800b21:	01 c0                	add    %eax,%eax
  800b23:	01 d0                	add    %edx,%eax
  800b25:	c1 e0 08             	shl    $0x8,%eax
  800b28:	89 c2                	mov    %eax,%edx
  800b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b2d:	01 d0                	add    %edx,%eax
  800b2f:	05 00 00 00 80       	add    $0x80000000,%eax
  800b34:	39 c1                	cmp    %eax,%ecx
  800b36:	74 17                	je     800b4f <_main+0xb17>
  800b38:	83 ec 04             	sub    $0x4,%esp
  800b3b:	68 20 40 80 00       	push   $0x804020
  800b40:	68 da 00 00 00       	push   $0xda
  800b45:	68 fc 3e 80 00       	push   $0x803efc
  800b4a:	e8 73 03 00 00       	call   800ec2 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+32) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800b4f:	e8 ff 1a 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800b54:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800b57:	74 17                	je     800b70 <_main+0xb38>
  800b59:	83 ec 04             	sub    $0x4,%esp
  800b5c:	68 02 40 80 00       	push   $0x804002
  800b61:	68 dc 00 00 00       	push   $0xdc
  800b66:	68 fc 3e 80 00       	push   $0x803efc
  800b6b:	e8 52 03 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");
  800b70:	e8 3e 1a 00 00       	call   8025b3 <sys_calculate_free_frames>
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b7a:	39 c2                	cmp    %eax,%edx
  800b7c:	74 17                	je     800b95 <_main+0xb5d>
  800b7e:	83 ec 04             	sub    $0x4,%esp
  800b81:	68 50 40 80 00       	push   $0x804050
  800b86:	68 dd 00 00 00       	push   $0xdd
  800b8b:	68 fc 3e 80 00       	push   $0x803efc
  800b90:	e8 2d 03 00 00       	call   800ec2 <_panic>

		//Allocate Shared 4 MB [should be placed at the end of all allocations
		freeFrames = sys_calculate_free_frames() ;
  800b95:	e8 19 1a 00 00       	call   8025b3 <sys_calculate_free_frames>
  800b9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800b9d:	e8 b1 1a 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[14] = smalloc("w", 4*Mega, 0);
  800ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ba8:	c1 e0 02             	shl    $0x2,%eax
  800bab:	83 ec 04             	sub    $0x4,%esp
  800bae:	6a 00                	push   $0x0
  800bb0:	50                   	push   %eax
  800bb1:	68 a4 40 80 00       	push   $0x8040a4
  800bb6:	e8 d5 16 00 00       	call   802290 <smalloc>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if (ptr_allocations[14] != (uint32*)(USER_HEAP_START + 18*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800bc1:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800bc4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bc7:	89 d0                	mov    %edx,%eax
  800bc9:	c1 e0 03             	shl    $0x3,%eax
  800bcc:	01 d0                	add    %edx,%eax
  800bce:	01 c0                	add    %eax,%eax
  800bd0:	05 00 00 00 80       	add    $0x80000000,%eax
  800bd5:	39 c1                	cmp    %eax,%ecx
  800bd7:	74 17                	je     800bf0 <_main+0xbb8>
  800bd9:	83 ec 04             	sub    $0x4,%esp
  800bdc:	68 18 3f 80 00       	push   $0x803f18
  800be1:	68 e3 00 00 00       	push   $0xe3
  800be6:	68 fc 3e 80 00       	push   $0x803efc
  800beb:	e8 d2 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1024+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800bf0:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800bf3:	e8 bb 19 00 00       	call   8025b3 <sys_calculate_free_frames>
  800bf8:	29 c3                	sub    %eax,%ebx
  800bfa:	89 d8                	mov    %ebx,%eax
  800bfc:	3d 03 04 00 00       	cmp    $0x403,%eax
  800c01:	74 17                	je     800c1a <_main+0xbe2>
  800c03:	83 ec 04             	sub    $0x4,%esp
  800c06:	68 84 3f 80 00       	push   $0x803f84
  800c0b:	68 e4 00 00 00       	push   $0xe4
  800c10:	68 fc 3e 80 00       	push   $0x803efc
  800c15:	e8 a8 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800c1a:	e8 34 1a 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800c1f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800c22:	74 17                	je     800c3b <_main+0xc03>
  800c24:	83 ec 04             	sub    $0x4,%esp
  800c27:	68 02 40 80 00       	push   $0x804002
  800c2c:	68 e5 00 00 00       	push   $0xe5
  800c31:	68 fc 3e 80 00       	push   $0x803efc
  800c36:	e8 87 02 00 00       	call   800ec2 <_panic>

		//Get shared of 3 MB [should be placed in the remaining part of the contiguous (256 KB + 4 MB) hole
		freeFrames = sys_calculate_free_frames() ;
  800c3b:	e8 73 19 00 00       	call   8025b3 <sys_calculate_free_frames>
  800c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800c43:	e8 0b 1a 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800c48:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[15] = sget(envID, "z");
  800c4b:	83 ec 08             	sub    $0x8,%esp
  800c4e:	68 65 40 80 00       	push   $0x804065
  800c53:	ff 75 ec             	pushl  -0x14(%ebp)
  800c56:	e8 0a 17 00 00       	call   802365 <sget>
  800c5b:	83 c4 10             	add    $0x10,%esp
  800c5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if (ptr_allocations[15] != (uint32*)(USER_HEAP_START + 3*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800c61:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c67:	89 c1                	mov    %eax,%ecx
  800c69:	01 c9                	add    %ecx,%ecx
  800c6b:	01 c8                	add    %ecx,%eax
  800c6d:	05 00 00 00 80       	add    $0x80000000,%eax
  800c72:	39 c2                	cmp    %eax,%edx
  800c74:	74 17                	je     800c8d <_main+0xc55>
  800c76:	83 ec 04             	sub    $0x4,%esp
  800c79:	68 18 3f 80 00       	push   $0x803f18
  800c7e:	68 eb 00 00 00       	push   $0xeb
  800c83:	68 fc 3e 80 00       	push   $0x803efc
  800c88:	e8 35 02 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800c8d:	e8 21 19 00 00       	call   8025b3 <sys_calculate_free_frames>
  800c92:	89 c2                	mov    %eax,%edx
  800c94:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	74 17                	je     800cb2 <_main+0xc7a>
  800c9b:	83 ec 04             	sub    $0x4,%esp
  800c9e:	68 84 3f 80 00       	push   $0x803f84
  800ca3:	68 ec 00 00 00       	push   $0xec
  800ca8:	68 fc 3e 80 00       	push   $0x803efc
  800cad:	e8 10 02 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800cb2:	e8 9c 19 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800cb7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800cba:	74 17                	je     800cd3 <_main+0xc9b>
  800cbc:	83 ec 04             	sub    $0x4,%esp
  800cbf:	68 02 40 80 00       	push   $0x804002
  800cc4:	68 ed 00 00 00       	push   $0xed
  800cc9:	68 fc 3e 80 00       	push   $0x803efc
  800cce:	e8 ef 01 00 00       	call   800ec2 <_panic>

		//Get shared of 1st 1 MB [should be placed in the remaining part of the 3 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800cd3:	e8 db 18 00 00       	call   8025b3 <sys_calculate_free_frames>
  800cd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800cdb:	e8 73 19 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800ce0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[16] = sget(envID, "x");
  800ce3:	83 ec 08             	sub    $0x8,%esp
  800ce6:	68 13 3f 80 00       	push   $0x803f13
  800ceb:	ff 75 ec             	pushl  -0x14(%ebp)
  800cee:	e8 72 16 00 00       	call   802365 <sget>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if (ptr_allocations[16] != (uint32*)(USER_HEAP_START + 10*Mega)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800cf9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800cfc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800cff:	89 d0                	mov    %edx,%eax
  800d01:	c1 e0 02             	shl    $0x2,%eax
  800d04:	01 d0                	add    %edx,%eax
  800d06:	01 c0                	add    %eax,%eax
  800d08:	05 00 00 00 80       	add    $0x80000000,%eax
  800d0d:	39 c1                	cmp    %eax,%ecx
  800d0f:	74 17                	je     800d28 <_main+0xcf0>
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	68 18 3f 80 00       	push   $0x803f18
  800d19:	68 f3 00 00 00       	push   $0xf3
  800d1e:	68 fc 3e 80 00       	push   $0x803efc
  800d23:	e8 9a 01 00 00       	call   800ec2 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0+0+0) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800d28:	e8 86 18 00 00       	call   8025b3 <sys_calculate_free_frames>
  800d2d:	89 c2                	mov    %eax,%edx
  800d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d32:	39 c2                	cmp    %eax,%edx
  800d34:	74 17                	je     800d4d <_main+0xd15>
  800d36:	83 ec 04             	sub    $0x4,%esp
  800d39:	68 84 3f 80 00       	push   $0x803f84
  800d3e:	68 f4 00 00 00       	push   $0xf4
  800d43:	68 fc 3e 80 00       	push   $0x803efc
  800d48:	e8 75 01 00 00       	call   800ec2 <_panic>
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("Wrong page file allocation: ");
  800d4d:	e8 01 19 00 00       	call   802653 <sys_pf_calculate_allocated_pages>
  800d52:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800d55:	74 17                	je     800d6e <_main+0xd36>
  800d57:	83 ec 04             	sub    $0x4,%esp
  800d5a:	68 02 40 80 00       	push   $0x804002
  800d5f:	68 f5 00 00 00       	push   $0xf5
  800d64:	68 fc 3e 80 00       	push   $0x803efc
  800d69:	e8 54 01 00 00       	call   800ec2 <_panic>

	}
	cprintf("Congratulations!! test FIRST FIT allocation (3) completed successfully.\n");
  800d6e:	83 ec 0c             	sub    $0xc,%esp
  800d71:	68 a8 40 80 00       	push   $0x8040a8
  800d76:	e8 fb 03 00 00       	call   801176 <cprintf>
  800d7b:	83 c4 10             	add    $0x10,%esp

	return;
  800d7e:	90                   	nop
}
  800d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d82:	5b                   	pop    %ebx
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800d8c:	e8 02 1b 00 00       	call   802893 <sys_getenvindex>
  800d91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800d94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d97:	89 d0                	mov    %edx,%eax
  800d99:	c1 e0 03             	shl    $0x3,%eax
  800d9c:	01 d0                	add    %edx,%eax
  800d9e:	01 c0                	add    %eax,%eax
  800da0:	01 d0                	add    %edx,%eax
  800da2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800da9:	01 d0                	add    %edx,%eax
  800dab:	c1 e0 04             	shl    $0x4,%eax
  800dae:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800db3:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800db8:	a1 20 50 80 00       	mov    0x805020,%eax
  800dbd:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 0f                	je     800dd6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800dc7:	a1 20 50 80 00       	mov    0x805020,%eax
  800dcc:	05 5c 05 00 00       	add    $0x55c,%eax
  800dd1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800dd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dda:	7e 0a                	jle    800de6 <libmain+0x60>
		binaryname = argv[0];
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	8b 00                	mov    (%eax),%eax
  800de1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800de6:	83 ec 08             	sub    $0x8,%esp
  800de9:	ff 75 0c             	pushl  0xc(%ebp)
  800dec:	ff 75 08             	pushl  0x8(%ebp)
  800def:	e8 44 f2 ff ff       	call   800038 <_main>
  800df4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800df7:	e8 a4 18 00 00       	call   8026a0 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	68 0c 41 80 00       	push   $0x80410c
  800e04:	e8 6d 03 00 00       	call   801176 <cprintf>
  800e09:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800e0c:	a1 20 50 80 00       	mov    0x805020,%eax
  800e11:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800e17:	a1 20 50 80 00       	mov    0x805020,%eax
  800e1c:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800e22:	83 ec 04             	sub    $0x4,%esp
  800e25:	52                   	push   %edx
  800e26:	50                   	push   %eax
  800e27:	68 34 41 80 00       	push   $0x804134
  800e2c:	e8 45 03 00 00       	call   801176 <cprintf>
  800e31:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800e34:	a1 20 50 80 00       	mov    0x805020,%eax
  800e39:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800e3f:	a1 20 50 80 00       	mov    0x805020,%eax
  800e44:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800e4a:	a1 20 50 80 00       	mov    0x805020,%eax
  800e4f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800e55:	51                   	push   %ecx
  800e56:	52                   	push   %edx
  800e57:	50                   	push   %eax
  800e58:	68 5c 41 80 00       	push   $0x80415c
  800e5d:	e8 14 03 00 00       	call   801176 <cprintf>
  800e62:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800e65:	a1 20 50 80 00       	mov    0x805020,%eax
  800e6a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	50                   	push   %eax
  800e74:	68 b4 41 80 00       	push   $0x8041b4
  800e79:	e8 f8 02 00 00       	call   801176 <cprintf>
  800e7e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800e81:	83 ec 0c             	sub    $0xc,%esp
  800e84:	68 0c 41 80 00       	push   $0x80410c
  800e89:	e8 e8 02 00 00       	call   801176 <cprintf>
  800e8e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800e91:	e8 24 18 00 00       	call   8026ba <sys_enable_interrupt>

	// exit gracefully
	exit();
  800e96:	e8 19 00 00 00       	call   800eb4 <exit>
}
  800e9b:	90                   	nop
  800e9c:	c9                   	leave  
  800e9d:	c3                   	ret    

00800e9e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	6a 00                	push   $0x0
  800ea9:	e8 b1 19 00 00       	call   80285f <sys_destroy_env>
  800eae:	83 c4 10             	add    $0x10,%esp
}
  800eb1:	90                   	nop
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <exit>:

void
exit(void)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800eba:	e8 06 1a 00 00       	call   8028c5 <sys_exit_env>
}
  800ebf:	90                   	nop
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800ec8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ecb:	83 c0 04             	add    $0x4,%eax
  800ece:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800ed1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800ed6:	85 c0                	test   %eax,%eax
  800ed8:	74 16                	je     800ef0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800eda:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800edf:	83 ec 08             	sub    $0x8,%esp
  800ee2:	50                   	push   %eax
  800ee3:	68 c8 41 80 00       	push   $0x8041c8
  800ee8:	e8 89 02 00 00       	call   801176 <cprintf>
  800eed:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ef0:	a1 00 50 80 00       	mov    0x805000,%eax
  800ef5:	ff 75 0c             	pushl  0xc(%ebp)
  800ef8:	ff 75 08             	pushl  0x8(%ebp)
  800efb:	50                   	push   %eax
  800efc:	68 cd 41 80 00       	push   $0x8041cd
  800f01:	e8 70 02 00 00       	call   801176 <cprintf>
  800f06:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800f09:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0c:	83 ec 08             	sub    $0x8,%esp
  800f0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f12:	50                   	push   %eax
  800f13:	e8 f3 01 00 00       	call   80110b <vcprintf>
  800f18:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800f1b:	83 ec 08             	sub    $0x8,%esp
  800f1e:	6a 00                	push   $0x0
  800f20:	68 e9 41 80 00       	push   $0x8041e9
  800f25:	e8 e1 01 00 00       	call   80110b <vcprintf>
  800f2a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800f2d:	e8 82 ff ff ff       	call   800eb4 <exit>

	// should not return here
	while (1) ;
  800f32:	eb fe                	jmp    800f32 <_panic+0x70>

00800f34 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800f3a:	a1 20 50 80 00       	mov    0x805020,%eax
  800f3f:	8b 50 74             	mov    0x74(%eax),%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	39 c2                	cmp    %eax,%edx
  800f47:	74 14                	je     800f5d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800f49:	83 ec 04             	sub    $0x4,%esp
  800f4c:	68 ec 41 80 00       	push   $0x8041ec
  800f51:	6a 26                	push   $0x26
  800f53:	68 38 42 80 00       	push   $0x804238
  800f58:	e8 65 ff ff ff       	call   800ec2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800f64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f6b:	e9 c2 00 00 00       	jmp    801032 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f73:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	01 d0                	add    %edx,%eax
  800f7f:	8b 00                	mov    (%eax),%eax
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 08                	jne    800f8d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800f85:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800f88:	e9 a2 00 00 00       	jmp    80102f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800f8d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800f94:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800f9b:	eb 69                	jmp    801006 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800f9d:	a1 20 50 80 00       	mov    0x805020,%eax
  800fa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fab:	89 d0                	mov    %edx,%eax
  800fad:	01 c0                	add    %eax,%eax
  800faf:	01 d0                	add    %edx,%eax
  800fb1:	c1 e0 03             	shl    $0x3,%eax
  800fb4:	01 c8                	add    %ecx,%eax
  800fb6:	8a 40 04             	mov    0x4(%eax),%al
  800fb9:	84 c0                	test   %al,%al
  800fbb:	75 46                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800fbd:	a1 20 50 80 00       	mov    0x805020,%eax
  800fc2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800fc8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800fcb:	89 d0                	mov    %edx,%eax
  800fcd:	01 c0                	add    %eax,%eax
  800fcf:	01 d0                	add    %edx,%eax
  800fd1:	c1 e0 03             	shl    $0x3,%eax
  800fd4:	01 c8                	add    %ecx,%eax
  800fd6:	8b 00                	mov    (%eax),%eax
  800fd8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800fdb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fe3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fe8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	01 c8                	add    %ecx,%eax
  800ff4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ff6:	39 c2                	cmp    %eax,%edx
  800ff8:	75 09                	jne    801003 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ffa:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801001:	eb 12                	jmp    801015 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801003:	ff 45 e8             	incl   -0x18(%ebp)
  801006:	a1 20 50 80 00       	mov    0x805020,%eax
  80100b:	8b 50 74             	mov    0x74(%eax),%edx
  80100e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801011:	39 c2                	cmp    %eax,%edx
  801013:	77 88                	ja     800f9d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  801015:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801019:	75 14                	jne    80102f <CheckWSWithoutLastIndex+0xfb>
			panic(
  80101b:	83 ec 04             	sub    $0x4,%esp
  80101e:	68 44 42 80 00       	push   $0x804244
  801023:	6a 3a                	push   $0x3a
  801025:	68 38 42 80 00       	push   $0x804238
  80102a:	e8 93 fe ff ff       	call   800ec2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80102f:	ff 45 f0             	incl   -0x10(%ebp)
  801032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801035:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801038:	0f 8c 32 ff ff ff    	jl     800f70 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80103e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801045:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80104c:	eb 26                	jmp    801074 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80104e:	a1 20 50 80 00       	mov    0x805020,%eax
  801053:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801059:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80105c:	89 d0                	mov    %edx,%eax
  80105e:	01 c0                	add    %eax,%eax
  801060:	01 d0                	add    %edx,%eax
  801062:	c1 e0 03             	shl    $0x3,%eax
  801065:	01 c8                	add    %ecx,%eax
  801067:	8a 40 04             	mov    0x4(%eax),%al
  80106a:	3c 01                	cmp    $0x1,%al
  80106c:	75 03                	jne    801071 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80106e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801071:	ff 45 e0             	incl   -0x20(%ebp)
  801074:	a1 20 50 80 00       	mov    0x805020,%eax
  801079:	8b 50 74             	mov    0x74(%eax),%edx
  80107c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80107f:	39 c2                	cmp    %eax,%edx
  801081:	77 cb                	ja     80104e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801089:	74 14                	je     80109f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80108b:	83 ec 04             	sub    $0x4,%esp
  80108e:	68 98 42 80 00       	push   $0x804298
  801093:	6a 44                	push   $0x44
  801095:	68 38 42 80 00       	push   $0x804238
  80109a:	e8 23 fe ff ff       	call   800ec2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80109f:	90                   	nop
  8010a0:	c9                   	leave  
  8010a1:	c3                   	ret    

008010a2 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8010a2:	55                   	push   %ebp
  8010a3:	89 e5                	mov    %esp,%ebp
  8010a5:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8010a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ab:	8b 00                	mov    (%eax),%eax
  8010ad:	8d 48 01             	lea    0x1(%eax),%ecx
  8010b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b3:	89 0a                	mov    %ecx,(%edx)
  8010b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b8:	88 d1                	mov    %dl,%cl
  8010ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bd:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8010c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c4:	8b 00                	mov    (%eax),%eax
  8010c6:	3d ff 00 00 00       	cmp    $0xff,%eax
  8010cb:	75 2c                	jne    8010f9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8010cd:	a0 24 50 80 00       	mov    0x805024,%al
  8010d2:	0f b6 c0             	movzbl %al,%eax
  8010d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d8:	8b 12                	mov    (%edx),%edx
  8010da:	89 d1                	mov    %edx,%ecx
  8010dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010df:	83 c2 08             	add    $0x8,%edx
  8010e2:	83 ec 04             	sub    $0x4,%esp
  8010e5:	50                   	push   %eax
  8010e6:	51                   	push   %ecx
  8010e7:	52                   	push   %edx
  8010e8:	e8 05 14 00 00       	call   8024f2 <sys_cputs>
  8010ed:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8010f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fc:	8b 40 04             	mov    0x4(%eax),%eax
  8010ff:	8d 50 01             	lea    0x1(%eax),%edx
  801102:	8b 45 0c             	mov    0xc(%ebp),%eax
  801105:	89 50 04             	mov    %edx,0x4(%eax)
}
  801108:	90                   	nop
  801109:	c9                   	leave  
  80110a:	c3                   	ret    

0080110b <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801114:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80111b:	00 00 00 
	b.cnt = 0;
  80111e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801125:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  801128:	ff 75 0c             	pushl  0xc(%ebp)
  80112b:	ff 75 08             	pushl  0x8(%ebp)
  80112e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801134:	50                   	push   %eax
  801135:	68 a2 10 80 00       	push   $0x8010a2
  80113a:	e8 11 02 00 00       	call   801350 <vprintfmt>
  80113f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  801142:	a0 24 50 80 00       	mov    0x805024,%al
  801147:	0f b6 c0             	movzbl %al,%eax
  80114a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  801150:	83 ec 04             	sub    $0x4,%esp
  801153:	50                   	push   %eax
  801154:	52                   	push   %edx
  801155:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80115b:	83 c0 08             	add    $0x8,%eax
  80115e:	50                   	push   %eax
  80115f:	e8 8e 13 00 00       	call   8024f2 <sys_cputs>
  801164:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801167:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80116e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801174:	c9                   	leave  
  801175:	c3                   	ret    

00801176 <cprintf>:

int cprintf(const char *fmt, ...) {
  801176:	55                   	push   %ebp
  801177:	89 e5                	mov    %esp,%ebp
  801179:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80117c:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  801183:	8d 45 0c             	lea    0xc(%ebp),%eax
  801186:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	83 ec 08             	sub    $0x8,%esp
  80118f:	ff 75 f4             	pushl  -0xc(%ebp)
  801192:	50                   	push   %eax
  801193:	e8 73 ff ff ff       	call   80110b <vcprintf>
  801198:	83 c4 10             	add    $0x10,%esp
  80119b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80119e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011a1:	c9                   	leave  
  8011a2:	c3                   	ret    

008011a3 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8011a9:	e8 f2 14 00 00       	call   8026a0 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8011ae:	8d 45 0c             	lea    0xc(%ebp),%eax
  8011b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8011b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b7:	83 ec 08             	sub    $0x8,%esp
  8011ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bd:	50                   	push   %eax
  8011be:	e8 48 ff ff ff       	call   80110b <vcprintf>
  8011c3:	83 c4 10             	add    $0x10,%esp
  8011c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8011c9:	e8 ec 14 00 00       	call   8026ba <sys_enable_interrupt>
	return cnt;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	53                   	push   %ebx
  8011d7:	83 ec 14             	sub    $0x14,%esp
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8011e6:	8b 45 18             	mov    0x18(%ebp),%eax
  8011e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f1:	77 55                	ja     801248 <printnum+0x75>
  8011f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8011f6:	72 05                	jb     8011fd <printnum+0x2a>
  8011f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011fb:	77 4b                	ja     801248 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8011fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801200:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801203:	8b 45 18             	mov    0x18(%ebp),%eax
  801206:	ba 00 00 00 00       	mov    $0x0,%edx
  80120b:	52                   	push   %edx
  80120c:	50                   	push   %eax
  80120d:	ff 75 f4             	pushl  -0xc(%ebp)
  801210:	ff 75 f0             	pushl  -0x10(%ebp)
  801213:	e8 64 2a 00 00       	call   803c7c <__udivdi3>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	83 ec 04             	sub    $0x4,%esp
  80121e:	ff 75 20             	pushl  0x20(%ebp)
  801221:	53                   	push   %ebx
  801222:	ff 75 18             	pushl  0x18(%ebp)
  801225:	52                   	push   %edx
  801226:	50                   	push   %eax
  801227:	ff 75 0c             	pushl  0xc(%ebp)
  80122a:	ff 75 08             	pushl  0x8(%ebp)
  80122d:	e8 a1 ff ff ff       	call   8011d3 <printnum>
  801232:	83 c4 20             	add    $0x20,%esp
  801235:	eb 1a                	jmp    801251 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801237:	83 ec 08             	sub    $0x8,%esp
  80123a:	ff 75 0c             	pushl  0xc(%ebp)
  80123d:	ff 75 20             	pushl  0x20(%ebp)
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	ff d0                	call   *%eax
  801245:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801248:	ff 4d 1c             	decl   0x1c(%ebp)
  80124b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80124f:	7f e6                	jg     801237 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801251:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801254:	bb 00 00 00 00       	mov    $0x0,%ebx
  801259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80125f:	53                   	push   %ebx
  801260:	51                   	push   %ecx
  801261:	52                   	push   %edx
  801262:	50                   	push   %eax
  801263:	e8 24 2b 00 00       	call   803d8c <__umoddi3>
  801268:	83 c4 10             	add    $0x10,%esp
  80126b:	05 14 45 80 00       	add    $0x804514,%eax
  801270:	8a 00                	mov    (%eax),%al
  801272:	0f be c0             	movsbl %al,%eax
  801275:	83 ec 08             	sub    $0x8,%esp
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	50                   	push   %eax
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	ff d0                	call   *%eax
  801281:	83 c4 10             	add    $0x10,%esp
}
  801284:	90                   	nop
  801285:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801288:	c9                   	leave  
  801289:	c3                   	ret    

0080128a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80128d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801291:	7e 1c                	jle    8012af <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801293:	8b 45 08             	mov    0x8(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 50 08             	lea    0x8(%eax),%edx
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	89 10                	mov    %edx,(%eax)
  8012a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a3:	8b 00                	mov    (%eax),%eax
  8012a5:	83 e8 08             	sub    $0x8,%eax
  8012a8:	8b 50 04             	mov    0x4(%eax),%edx
  8012ab:	8b 00                	mov    (%eax),%eax
  8012ad:	eb 40                	jmp    8012ef <getuint+0x65>
	else if (lflag)
  8012af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012b3:	74 1e                	je     8012d3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8b 00                	mov    (%eax),%eax
  8012ba:	8d 50 04             	lea    0x4(%eax),%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 10                	mov    %edx,(%eax)
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	8b 00                	mov    (%eax),%eax
  8012c7:	83 e8 04             	sub    $0x4,%eax
  8012ca:	8b 00                	mov    (%eax),%eax
  8012cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d1:	eb 1c                	jmp    8012ef <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8b 00                	mov    (%eax),%eax
  8012d8:	8d 50 04             	lea    0x4(%eax),%edx
  8012db:	8b 45 08             	mov    0x8(%ebp),%eax
  8012de:	89 10                	mov    %edx,(%eax)
  8012e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	83 e8 04             	sub    $0x4,%eax
  8012e8:	8b 00                	mov    (%eax),%eax
  8012ea:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8012f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8012f8:	7e 1c                	jle    801316 <getint+0x25>
		return va_arg(*ap, long long);
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	8d 50 08             	lea    0x8(%eax),%edx
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	89 10                	mov    %edx,(%eax)
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8b 00                	mov    (%eax),%eax
  80130c:	83 e8 08             	sub    $0x8,%eax
  80130f:	8b 50 04             	mov    0x4(%eax),%edx
  801312:	8b 00                	mov    (%eax),%eax
  801314:	eb 38                	jmp    80134e <getint+0x5d>
	else if (lflag)
  801316:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80131a:	74 1a                	je     801336 <getint+0x45>
		return va_arg(*ap, long);
  80131c:	8b 45 08             	mov    0x8(%ebp),%eax
  80131f:	8b 00                	mov    (%eax),%eax
  801321:	8d 50 04             	lea    0x4(%eax),%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 10                	mov    %edx,(%eax)
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8b 00                	mov    (%eax),%eax
  80132e:	83 e8 04             	sub    $0x4,%eax
  801331:	8b 00                	mov    (%eax),%eax
  801333:	99                   	cltd   
  801334:	eb 18                	jmp    80134e <getint+0x5d>
	else
		return va_arg(*ap, int);
  801336:	8b 45 08             	mov    0x8(%ebp),%eax
  801339:	8b 00                	mov    (%eax),%eax
  80133b:	8d 50 04             	lea    0x4(%eax),%edx
  80133e:	8b 45 08             	mov    0x8(%ebp),%eax
  801341:	89 10                	mov    %edx,(%eax)
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 e8 04             	sub    $0x4,%eax
  80134b:	8b 00                	mov    (%eax),%eax
  80134d:	99                   	cltd   
}
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    

00801350 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	56                   	push   %esi
  801354:	53                   	push   %ebx
  801355:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801358:	eb 17                	jmp    801371 <vprintfmt+0x21>
			if (ch == '\0')
  80135a:	85 db                	test   %ebx,%ebx
  80135c:	0f 84 af 03 00 00    	je     801711 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801362:	83 ec 08             	sub    $0x8,%esp
  801365:	ff 75 0c             	pushl  0xc(%ebp)
  801368:	53                   	push   %ebx
  801369:	8b 45 08             	mov    0x8(%ebp),%eax
  80136c:	ff d0                	call   *%eax
  80136e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801371:	8b 45 10             	mov    0x10(%ebp),%eax
  801374:	8d 50 01             	lea    0x1(%eax),%edx
  801377:	89 55 10             	mov    %edx,0x10(%ebp)
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	0f b6 d8             	movzbl %al,%ebx
  80137f:	83 fb 25             	cmp    $0x25,%ebx
  801382:	75 d6                	jne    80135a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801384:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801388:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80138f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801396:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80139d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8013a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a7:	8d 50 01             	lea    0x1(%eax),%edx
  8013aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ad:	8a 00                	mov    (%eax),%al
  8013af:	0f b6 d8             	movzbl %al,%ebx
  8013b2:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8013b5:	83 f8 55             	cmp    $0x55,%eax
  8013b8:	0f 87 2b 03 00 00    	ja     8016e9 <vprintfmt+0x399>
  8013be:	8b 04 85 38 45 80 00 	mov    0x804538(,%eax,4),%eax
  8013c5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8013c7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8013cb:	eb d7                	jmp    8013a4 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8013cd:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8013d1:	eb d1                	jmp    8013a4 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8013d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8013da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013dd:	89 d0                	mov    %edx,%eax
  8013df:	c1 e0 02             	shl    $0x2,%eax
  8013e2:	01 d0                	add    %edx,%eax
  8013e4:	01 c0                	add    %eax,%eax
  8013e6:	01 d8                	add    %ebx,%eax
  8013e8:	83 e8 30             	sub    $0x30,%eax
  8013eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8013ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8013f6:	83 fb 2f             	cmp    $0x2f,%ebx
  8013f9:	7e 3e                	jle    801439 <vprintfmt+0xe9>
  8013fb:	83 fb 39             	cmp    $0x39,%ebx
  8013fe:	7f 39                	jg     801439 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801400:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801403:	eb d5                	jmp    8013da <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801405:	8b 45 14             	mov    0x14(%ebp),%eax
  801408:	83 c0 04             	add    $0x4,%eax
  80140b:	89 45 14             	mov    %eax,0x14(%ebp)
  80140e:	8b 45 14             	mov    0x14(%ebp),%eax
  801411:	83 e8 04             	sub    $0x4,%eax
  801414:	8b 00                	mov    (%eax),%eax
  801416:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801419:	eb 1f                	jmp    80143a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80141b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80141f:	79 83                	jns    8013a4 <vprintfmt+0x54>
				width = 0;
  801421:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801428:	e9 77 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80142d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801434:	e9 6b ff ff ff       	jmp    8013a4 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801439:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80143a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80143e:	0f 89 60 ff ff ff    	jns    8013a4 <vprintfmt+0x54>
				width = precision, precision = -1;
  801444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801447:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80144a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801451:	e9 4e ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801456:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801459:	e9 46 ff ff ff       	jmp    8013a4 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	83 c0 04             	add    $0x4,%eax
  801464:	89 45 14             	mov    %eax,0x14(%ebp)
  801467:	8b 45 14             	mov    0x14(%ebp),%eax
  80146a:	83 e8 04             	sub    $0x4,%eax
  80146d:	8b 00                	mov    (%eax),%eax
  80146f:	83 ec 08             	sub    $0x8,%esp
  801472:	ff 75 0c             	pushl  0xc(%ebp)
  801475:	50                   	push   %eax
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	ff d0                	call   *%eax
  80147b:	83 c4 10             	add    $0x10,%esp
			break;
  80147e:	e9 89 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801483:	8b 45 14             	mov    0x14(%ebp),%eax
  801486:	83 c0 04             	add    $0x4,%eax
  801489:	89 45 14             	mov    %eax,0x14(%ebp)
  80148c:	8b 45 14             	mov    0x14(%ebp),%eax
  80148f:	83 e8 04             	sub    $0x4,%eax
  801492:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801494:	85 db                	test   %ebx,%ebx
  801496:	79 02                	jns    80149a <vprintfmt+0x14a>
				err = -err;
  801498:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80149a:	83 fb 64             	cmp    $0x64,%ebx
  80149d:	7f 0b                	jg     8014aa <vprintfmt+0x15a>
  80149f:	8b 34 9d 80 43 80 00 	mov    0x804380(,%ebx,4),%esi
  8014a6:	85 f6                	test   %esi,%esi
  8014a8:	75 19                	jne    8014c3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8014aa:	53                   	push   %ebx
  8014ab:	68 25 45 80 00       	push   $0x804525
  8014b0:	ff 75 0c             	pushl  0xc(%ebp)
  8014b3:	ff 75 08             	pushl  0x8(%ebp)
  8014b6:	e8 5e 02 00 00       	call   801719 <printfmt>
  8014bb:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8014be:	e9 49 02 00 00       	jmp    80170c <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8014c3:	56                   	push   %esi
  8014c4:	68 2e 45 80 00       	push   $0x80452e
  8014c9:	ff 75 0c             	pushl  0xc(%ebp)
  8014cc:	ff 75 08             	pushl  0x8(%ebp)
  8014cf:	e8 45 02 00 00       	call   801719 <printfmt>
  8014d4:	83 c4 10             	add    $0x10,%esp
			break;
  8014d7:	e9 30 02 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8014dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8014df:	83 c0 04             	add    $0x4,%eax
  8014e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8014e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e8:	83 e8 04             	sub    $0x4,%eax
  8014eb:	8b 30                	mov    (%eax),%esi
  8014ed:	85 f6                	test   %esi,%esi
  8014ef:	75 05                	jne    8014f6 <vprintfmt+0x1a6>
				p = "(null)";
  8014f1:	be 31 45 80 00       	mov    $0x804531,%esi
			if (width > 0 && padc != '-')
  8014f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8014fa:	7e 6d                	jle    801569 <vprintfmt+0x219>
  8014fc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801500:	74 67                	je     801569 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	50                   	push   %eax
  801509:	56                   	push   %esi
  80150a:	e8 0c 03 00 00       	call   80181b <strnlen>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801515:	eb 16                	jmp    80152d <vprintfmt+0x1dd>
					putch(padc, putdat);
  801517:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	50                   	push   %eax
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	ff d0                	call   *%eax
  801527:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80152a:	ff 4d e4             	decl   -0x1c(%ebp)
  80152d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801531:	7f e4                	jg     801517 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801533:	eb 34                	jmp    801569 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801535:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801539:	74 1c                	je     801557 <vprintfmt+0x207>
  80153b:	83 fb 1f             	cmp    $0x1f,%ebx
  80153e:	7e 05                	jle    801545 <vprintfmt+0x1f5>
  801540:	83 fb 7e             	cmp    $0x7e,%ebx
  801543:	7e 12                	jle    801557 <vprintfmt+0x207>
					putch('?', putdat);
  801545:	83 ec 08             	sub    $0x8,%esp
  801548:	ff 75 0c             	pushl  0xc(%ebp)
  80154b:	6a 3f                	push   $0x3f
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	ff d0                	call   *%eax
  801552:	83 c4 10             	add    $0x10,%esp
  801555:	eb 0f                	jmp    801566 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	ff 75 0c             	pushl  0xc(%ebp)
  80155d:	53                   	push   %ebx
  80155e:	8b 45 08             	mov    0x8(%ebp),%eax
  801561:	ff d0                	call   *%eax
  801563:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801566:	ff 4d e4             	decl   -0x1c(%ebp)
  801569:	89 f0                	mov    %esi,%eax
  80156b:	8d 70 01             	lea    0x1(%eax),%esi
  80156e:	8a 00                	mov    (%eax),%al
  801570:	0f be d8             	movsbl %al,%ebx
  801573:	85 db                	test   %ebx,%ebx
  801575:	74 24                	je     80159b <vprintfmt+0x24b>
  801577:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80157b:	78 b8                	js     801535 <vprintfmt+0x1e5>
  80157d:	ff 4d e0             	decl   -0x20(%ebp)
  801580:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801584:	79 af                	jns    801535 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801586:	eb 13                	jmp    80159b <vprintfmt+0x24b>
				putch(' ', putdat);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	ff 75 0c             	pushl  0xc(%ebp)
  80158e:	6a 20                	push   $0x20
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	ff d0                	call   *%eax
  801595:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801598:	ff 4d e4             	decl   -0x1c(%ebp)
  80159b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80159f:	7f e7                	jg     801588 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8015a1:	e9 66 01 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8015a6:	83 ec 08             	sub    $0x8,%esp
  8015a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	e8 3c fd ff ff       	call   8012f1 <getint>
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c4:	85 d2                	test   %edx,%edx
  8015c6:	79 23                	jns    8015eb <vprintfmt+0x29b>
				putch('-', putdat);
  8015c8:	83 ec 08             	sub    $0x8,%esp
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	6a 2d                	push   $0x2d
  8015d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d3:	ff d0                	call   *%eax
  8015d5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8015d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015de:	f7 d8                	neg    %eax
  8015e0:	83 d2 00             	adc    $0x0,%edx
  8015e3:	f7 da                	neg    %edx
  8015e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015e8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8015eb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8015f2:	e9 bc 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8015f7:	83 ec 08             	sub    $0x8,%esp
  8015fa:	ff 75 e8             	pushl  -0x18(%ebp)
  8015fd:	8d 45 14             	lea    0x14(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	e8 84 fc ff ff       	call   80128a <getuint>
  801606:	83 c4 10             	add    $0x10,%esp
  801609:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80160c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  80160f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801616:	e9 98 00 00 00       	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  80161b:	83 ec 08             	sub    $0x8,%esp
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	6a 58                	push   $0x58
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	ff d0                	call   *%eax
  801628:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	ff 75 0c             	pushl  0xc(%ebp)
  801631:	6a 58                	push   $0x58
  801633:	8b 45 08             	mov    0x8(%ebp),%eax
  801636:	ff d0                	call   *%eax
  801638:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80163b:	83 ec 08             	sub    $0x8,%esp
  80163e:	ff 75 0c             	pushl  0xc(%ebp)
  801641:	6a 58                	push   $0x58
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	ff d0                	call   *%eax
  801648:	83 c4 10             	add    $0x10,%esp
			break;
  80164b:	e9 bc 00 00 00       	jmp    80170c <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801650:	83 ec 08             	sub    $0x8,%esp
  801653:	ff 75 0c             	pushl  0xc(%ebp)
  801656:	6a 30                	push   $0x30
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	ff d0                	call   *%eax
  80165d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	ff 75 0c             	pushl  0xc(%ebp)
  801666:	6a 78                	push   $0x78
  801668:	8b 45 08             	mov    0x8(%ebp),%eax
  80166b:	ff d0                	call   *%eax
  80166d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801670:	8b 45 14             	mov    0x14(%ebp),%eax
  801673:	83 c0 04             	add    $0x4,%eax
  801676:	89 45 14             	mov    %eax,0x14(%ebp)
  801679:	8b 45 14             	mov    0x14(%ebp),%eax
  80167c:	83 e8 04             	sub    $0x4,%eax
  80167f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801681:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801684:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80168b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801692:	eb 1f                	jmp    8016b3 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801694:	83 ec 08             	sub    $0x8,%esp
  801697:	ff 75 e8             	pushl  -0x18(%ebp)
  80169a:	8d 45 14             	lea    0x14(%ebp),%eax
  80169d:	50                   	push   %eax
  80169e:	e8 e7 fb ff ff       	call   80128a <getuint>
  8016a3:	83 c4 10             	add    $0x10,%esp
  8016a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8016ac:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8016b3:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8016b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ba:	83 ec 04             	sub    $0x4,%esp
  8016bd:	52                   	push   %edx
  8016be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016c1:	50                   	push   %eax
  8016c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c8:	ff 75 0c             	pushl  0xc(%ebp)
  8016cb:	ff 75 08             	pushl  0x8(%ebp)
  8016ce:	e8 00 fb ff ff       	call   8011d3 <printnum>
  8016d3:	83 c4 20             	add    $0x20,%esp
			break;
  8016d6:	eb 34                	jmp    80170c <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8016d8:	83 ec 08             	sub    $0x8,%esp
  8016db:	ff 75 0c             	pushl  0xc(%ebp)
  8016de:	53                   	push   %ebx
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	ff d0                	call   *%eax
  8016e4:	83 c4 10             	add    $0x10,%esp
			break;
  8016e7:	eb 23                	jmp    80170c <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8016e9:	83 ec 08             	sub    $0x8,%esp
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	6a 25                	push   $0x25
  8016f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f4:	ff d0                	call   *%eax
  8016f6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8016f9:	ff 4d 10             	decl   0x10(%ebp)
  8016fc:	eb 03                	jmp    801701 <vprintfmt+0x3b1>
  8016fe:	ff 4d 10             	decl   0x10(%ebp)
  801701:	8b 45 10             	mov    0x10(%ebp),%eax
  801704:	48                   	dec    %eax
  801705:	8a 00                	mov    (%eax),%al
  801707:	3c 25                	cmp    $0x25,%al
  801709:	75 f3                	jne    8016fe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80170b:	90                   	nop
		}
	}
  80170c:	e9 47 fc ff ff       	jmp    801358 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801711:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801715:	5b                   	pop    %ebx
  801716:	5e                   	pop    %esi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    

00801719 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80171f:	8d 45 10             	lea    0x10(%ebp),%eax
  801722:	83 c0 04             	add    $0x4,%eax
  801725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801728:	8b 45 10             	mov    0x10(%ebp),%eax
  80172b:	ff 75 f4             	pushl  -0xc(%ebp)
  80172e:	50                   	push   %eax
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 16 fc ff ff       	call   801350 <vprintfmt>
  80173a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80173d:	90                   	nop
  80173e:	c9                   	leave  
  80173f:	c3                   	ret    

00801740 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801743:	8b 45 0c             	mov    0xc(%ebp),%eax
  801746:	8b 40 08             	mov    0x8(%eax),%eax
  801749:	8d 50 01             	lea    0x1(%eax),%edx
  80174c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80174f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801752:	8b 45 0c             	mov    0xc(%ebp),%eax
  801755:	8b 10                	mov    (%eax),%edx
  801757:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175a:	8b 40 04             	mov    0x4(%eax),%eax
  80175d:	39 c2                	cmp    %eax,%edx
  80175f:	73 12                	jae    801773 <sprintputch+0x33>
		*b->buf++ = ch;
  801761:	8b 45 0c             	mov    0xc(%ebp),%eax
  801764:	8b 00                	mov    (%eax),%eax
  801766:	8d 48 01             	lea    0x1(%eax),%ecx
  801769:	8b 55 0c             	mov    0xc(%ebp),%edx
  80176c:	89 0a                	mov    %ecx,(%edx)
  80176e:	8b 55 08             	mov    0x8(%ebp),%edx
  801771:	88 10                	mov    %dl,(%eax)
}
  801773:	90                   	nop
  801774:	5d                   	pop    %ebp
  801775:	c3                   	ret    

00801776 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801776:	55                   	push   %ebp
  801777:	89 e5                	mov    %esp,%ebp
  801779:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	8d 50 ff             	lea    -0x1(%eax),%edx
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	01 d0                	add    %edx,%eax
  80178d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801790:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801797:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80179b:	74 06                	je     8017a3 <vsnprintf+0x2d>
  80179d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017a1:	7f 07                	jg     8017aa <vsnprintf+0x34>
		return -E_INVAL;
  8017a3:	b8 03 00 00 00       	mov    $0x3,%eax
  8017a8:	eb 20                	jmp    8017ca <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017aa:	ff 75 14             	pushl  0x14(%ebp)
  8017ad:	ff 75 10             	pushl  0x10(%ebp)
  8017b0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017b3:	50                   	push   %eax
  8017b4:	68 40 17 80 00       	push   $0x801740
  8017b9:	e8 92 fb ff ff       	call   801350 <vprintfmt>
  8017be:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8017c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8017ca:	c9                   	leave  
  8017cb:	c3                   	ret    

008017cc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017cc:	55                   	push   %ebp
  8017cd:	89 e5                	mov    %esp,%ebp
  8017cf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017d2:	8d 45 10             	lea    0x10(%ebp),%eax
  8017d5:	83 c0 04             	add    $0x4,%eax
  8017d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8017db:	8b 45 10             	mov    0x10(%ebp),%eax
  8017de:	ff 75 f4             	pushl  -0xc(%ebp)
  8017e1:	50                   	push   %eax
  8017e2:	ff 75 0c             	pushl  0xc(%ebp)
  8017e5:	ff 75 08             	pushl  0x8(%ebp)
  8017e8:	e8 89 ff ff ff       	call   801776 <vsnprintf>
  8017ed:	83 c4 10             	add    $0x10,%esp
  8017f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8017f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017f6:	c9                   	leave  
  8017f7:	c3                   	ret    

008017f8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8017fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801805:	eb 06                	jmp    80180d <strlen+0x15>
		n++;
  801807:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80180a:	ff 45 08             	incl   0x8(%ebp)
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	84 c0                	test   %al,%al
  801814:	75 f1                	jne    801807 <strlen+0xf>
		n++;
	return n;
  801816:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801821:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801828:	eb 09                	jmp    801833 <strnlen+0x18>
		n++;
  80182a:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80182d:	ff 45 08             	incl   0x8(%ebp)
  801830:	ff 4d 0c             	decl   0xc(%ebp)
  801833:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801837:	74 09                	je     801842 <strnlen+0x27>
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8a 00                	mov    (%eax),%al
  80183e:	84 c0                	test   %al,%al
  801840:	75 e8                	jne    80182a <strnlen+0xf>
		n++;
	return n;
  801842:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801845:	c9                   	leave  
  801846:	c3                   	ret    

00801847 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80184d:	8b 45 08             	mov    0x8(%ebp),%eax
  801850:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801853:	90                   	nop
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	8d 50 01             	lea    0x1(%eax),%edx
  80185a:	89 55 08             	mov    %edx,0x8(%ebp)
  80185d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801860:	8d 4a 01             	lea    0x1(%edx),%ecx
  801863:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801866:	8a 12                	mov    (%edx),%dl
  801868:	88 10                	mov    %dl,(%eax)
  80186a:	8a 00                	mov    (%eax),%al
  80186c:	84 c0                	test   %al,%al
  80186e:	75 e4                	jne    801854 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801870:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801881:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801888:	eb 1f                	jmp    8018a9 <strncpy+0x34>
		*dst++ = *src;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8d 50 01             	lea    0x1(%eax),%edx
  801890:	89 55 08             	mov    %edx,0x8(%ebp)
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8a 12                	mov    (%edx),%dl
  801898:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	8a 00                	mov    (%eax),%al
  80189f:	84 c0                	test   %al,%al
  8018a1:	74 03                	je     8018a6 <strncpy+0x31>
			src++;
  8018a3:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8018a6:	ff 45 fc             	incl   -0x4(%ebp)
  8018a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018ac:	3b 45 10             	cmp    0x10(%ebp),%eax
  8018af:	72 d9                	jb     80188a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8018b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8018c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018c6:	74 30                	je     8018f8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8018c8:	eb 16                	jmp    8018e0 <strlcpy+0x2a>
			*dst++ = *src++;
  8018ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cd:	8d 50 01             	lea    0x1(%eax),%edx
  8018d0:	89 55 08             	mov    %edx,0x8(%ebp)
  8018d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8018d9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8018dc:	8a 12                	mov    (%edx),%dl
  8018de:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8018e0:	ff 4d 10             	decl   0x10(%ebp)
  8018e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018e7:	74 09                	je     8018f2 <strlcpy+0x3c>
  8018e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ec:	8a 00                	mov    (%eax),%al
  8018ee:	84 c0                	test   %al,%al
  8018f0:	75 d8                	jne    8018ca <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8018f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018fe:	29 c2                	sub    %eax,%edx
  801900:	89 d0                	mov    %edx,%eax
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801907:	eb 06                	jmp    80190f <strcmp+0xb>
		p++, q++;
  801909:	ff 45 08             	incl   0x8(%ebp)
  80190c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80190f:	8b 45 08             	mov    0x8(%ebp),%eax
  801912:	8a 00                	mov    (%eax),%al
  801914:	84 c0                	test   %al,%al
  801916:	74 0e                	je     801926 <strcmp+0x22>
  801918:	8b 45 08             	mov    0x8(%ebp),%eax
  80191b:	8a 10                	mov    (%eax),%dl
  80191d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801920:	8a 00                	mov    (%eax),%al
  801922:	38 c2                	cmp    %al,%dl
  801924:	74 e3                	je     801909 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	8a 00                	mov    (%eax),%al
  80192b:	0f b6 d0             	movzbl %al,%edx
  80192e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f b6 c0             	movzbl %al,%eax
  801936:	29 c2                	sub    %eax,%edx
  801938:	89 d0                	mov    %edx,%eax
}
  80193a:	5d                   	pop    %ebp
  80193b:	c3                   	ret    

0080193c <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80193f:	eb 09                	jmp    80194a <strncmp+0xe>
		n--, p++, q++;
  801941:	ff 4d 10             	decl   0x10(%ebp)
  801944:	ff 45 08             	incl   0x8(%ebp)
  801947:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80194a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80194e:	74 17                	je     801967 <strncmp+0x2b>
  801950:	8b 45 08             	mov    0x8(%ebp),%eax
  801953:	8a 00                	mov    (%eax),%al
  801955:	84 c0                	test   %al,%al
  801957:	74 0e                	je     801967 <strncmp+0x2b>
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	8a 10                	mov    (%eax),%dl
  80195e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801961:	8a 00                	mov    (%eax),%al
  801963:	38 c2                	cmp    %al,%dl
  801965:	74 da                	je     801941 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801967:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196b:	75 07                	jne    801974 <strncmp+0x38>
		return 0;
  80196d:	b8 00 00 00 00       	mov    $0x0,%eax
  801972:	eb 14                	jmp    801988 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	8a 00                	mov    (%eax),%al
  801979:	0f b6 d0             	movzbl %al,%edx
  80197c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80197f:	8a 00                	mov    (%eax),%al
  801981:	0f b6 c0             	movzbl %al,%eax
  801984:	29 c2                	sub    %eax,%edx
  801986:	89 d0                	mov    %edx,%eax
}
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	8b 45 0c             	mov    0xc(%ebp),%eax
  801993:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801996:	eb 12                	jmp    8019aa <strchr+0x20>
		if (*s == c)
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8a 00                	mov    (%eax),%al
  80199d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019a0:	75 05                	jne    8019a7 <strchr+0x1d>
			return (char *) s;
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	eb 11                	jmp    8019b8 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8019a7:	ff 45 08             	incl   0x8(%ebp)
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	8a 00                	mov    (%eax),%al
  8019af:	84 c0                	test   %al,%al
  8019b1:	75 e5                	jne    801998 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8019b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b8:	c9                   	leave  
  8019b9:	c3                   	ret    

008019ba <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8019c6:	eb 0d                	jmp    8019d5 <strfind+0x1b>
		if (*s == c)
  8019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019cb:	8a 00                	mov    (%eax),%al
  8019cd:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8019d0:	74 0e                	je     8019e0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8019d2:	ff 45 08             	incl   0x8(%ebp)
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	8a 00                	mov    (%eax),%al
  8019da:	84 c0                	test   %al,%al
  8019dc:	75 ea                	jne    8019c8 <strfind+0xe>
  8019de:	eb 01                	jmp    8019e1 <strfind+0x27>
		if (*s == c)
			break;
  8019e0:	90                   	nop
	return (char *) s;
  8019e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8019ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8019f8:	eb 0e                	jmp    801a08 <memset+0x22>
		*p++ = c;
  8019fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019fd:	8d 50 01             	lea    0x1(%eax),%edx
  801a00:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801a03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a06:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801a08:	ff 4d f8             	decl   -0x8(%ebp)
  801a0b:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801a0f:	79 e9                	jns    8019fa <memset+0x14>
		*p++ = c;

	return v;
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
  801a19:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801a28:	eb 16                	jmp    801a40 <memcpy+0x2a>
		*d++ = *s++;
  801a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a2d:	8d 50 01             	lea    0x1(%eax),%edx
  801a30:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801a33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a36:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a39:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801a3c:	8a 12                	mov    (%edx),%dl
  801a3e:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801a40:	8b 45 10             	mov    0x10(%ebp),%eax
  801a43:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a46:	89 55 10             	mov    %edx,0x10(%ebp)
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	75 dd                	jne    801a2a <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801a4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a61:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801a64:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a67:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a6a:	73 50                	jae    801abc <memmove+0x6a>
  801a6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a72:	01 d0                	add    %edx,%eax
  801a74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801a77:	76 43                	jbe    801abc <memmove+0x6a>
		s += n;
  801a79:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801a7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801a82:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801a85:	eb 10                	jmp    801a97 <memmove+0x45>
			*--d = *--s;
  801a87:	ff 4d f8             	decl   -0x8(%ebp)
  801a8a:	ff 4d fc             	decl   -0x4(%ebp)
  801a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801a90:	8a 10                	mov    (%eax),%dl
  801a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a95:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801a97:	8b 45 10             	mov    0x10(%ebp),%eax
  801a9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  801a9d:	89 55 10             	mov    %edx,0x10(%ebp)
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	75 e3                	jne    801a87 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801aa4:	eb 23                	jmp    801ac9 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801aa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aa9:	8d 50 01             	lea    0x1(%eax),%edx
  801aac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801aaf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab2:	8d 4a 01             	lea    0x1(%edx),%ecx
  801ab5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801ab8:	8a 12                	mov    (%edx),%dl
  801aba:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801abc:	8b 45 10             	mov    0x10(%ebp),%eax
  801abf:	8d 50 ff             	lea    -0x1(%eax),%edx
  801ac2:	89 55 10             	mov    %edx,0x10(%ebp)
  801ac5:	85 c0                	test   %eax,%eax
  801ac7:	75 dd                	jne    801aa6 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801acc:	c9                   	leave  
  801acd:	c3                   	ret    

00801ace <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801ace:	55                   	push   %ebp
  801acf:	89 e5                	mov    %esp,%ebp
  801ad1:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801ae0:	eb 2a                	jmp    801b0c <memcmp+0x3e>
		if (*s1 != *s2)
  801ae2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae5:	8a 10                	mov    (%eax),%dl
  801ae7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aea:	8a 00                	mov    (%eax),%al
  801aec:	38 c2                	cmp    %al,%dl
  801aee:	74 16                	je     801b06 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801af3:	8a 00                	mov    (%eax),%al
  801af5:	0f b6 d0             	movzbl %al,%edx
  801af8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801afb:	8a 00                	mov    (%eax),%al
  801afd:	0f b6 c0             	movzbl %al,%eax
  801b00:	29 c2                	sub    %eax,%edx
  801b02:	89 d0                	mov    %edx,%eax
  801b04:	eb 18                	jmp    801b1e <memcmp+0x50>
		s1++, s2++;
  801b06:	ff 45 fc             	incl   -0x4(%ebp)
  801b09:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0f:	8d 50 ff             	lea    -0x1(%eax),%edx
  801b12:	89 55 10             	mov    %edx,0x10(%ebp)
  801b15:	85 c0                	test   %eax,%eax
  801b17:	75 c9                	jne    801ae2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801b19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
  801b23:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801b26:	8b 55 08             	mov    0x8(%ebp),%edx
  801b29:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2c:	01 d0                	add    %edx,%eax
  801b2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801b31:	eb 15                	jmp    801b48 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	8a 00                	mov    (%eax),%al
  801b38:	0f b6 d0             	movzbl %al,%edx
  801b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3e:	0f b6 c0             	movzbl %al,%eax
  801b41:	39 c2                	cmp    %eax,%edx
  801b43:	74 0d                	je     801b52 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801b45:	ff 45 08             	incl   0x8(%ebp)
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801b4e:	72 e3                	jb     801b33 <memfind+0x13>
  801b50:	eb 01                	jmp    801b53 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801b52:	90                   	nop
	return (void *) s;
  801b53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801b56:	c9                   	leave  
  801b57:	c3                   	ret    

00801b58 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
  801b5b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801b5e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801b65:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b6c:	eb 03                	jmp    801b71 <strtol+0x19>
		s++;
  801b6e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	8a 00                	mov    (%eax),%al
  801b76:	3c 20                	cmp    $0x20,%al
  801b78:	74 f4                	je     801b6e <strtol+0x16>
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	8a 00                	mov    (%eax),%al
  801b7f:	3c 09                	cmp    $0x9,%al
  801b81:	74 eb                	je     801b6e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801b83:	8b 45 08             	mov    0x8(%ebp),%eax
  801b86:	8a 00                	mov    (%eax),%al
  801b88:	3c 2b                	cmp    $0x2b,%al
  801b8a:	75 05                	jne    801b91 <strtol+0x39>
		s++;
  801b8c:	ff 45 08             	incl   0x8(%ebp)
  801b8f:	eb 13                	jmp    801ba4 <strtol+0x4c>
	else if (*s == '-')
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8a 00                	mov    (%eax),%al
  801b96:	3c 2d                	cmp    $0x2d,%al
  801b98:	75 0a                	jne    801ba4 <strtol+0x4c>
		s++, neg = 1;
  801b9a:	ff 45 08             	incl   0x8(%ebp)
  801b9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ba4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ba8:	74 06                	je     801bb0 <strtol+0x58>
  801baa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801bae:	75 20                	jne    801bd0 <strtol+0x78>
  801bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb3:	8a 00                	mov    (%eax),%al
  801bb5:	3c 30                	cmp    $0x30,%al
  801bb7:	75 17                	jne    801bd0 <strtol+0x78>
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	40                   	inc    %eax
  801bbd:	8a 00                	mov    (%eax),%al
  801bbf:	3c 78                	cmp    $0x78,%al
  801bc1:	75 0d                	jne    801bd0 <strtol+0x78>
		s += 2, base = 16;
  801bc3:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801bc7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801bce:	eb 28                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801bd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd4:	75 15                	jne    801beb <strtol+0x93>
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	8a 00                	mov    (%eax),%al
  801bdb:	3c 30                	cmp    $0x30,%al
  801bdd:	75 0c                	jne    801beb <strtol+0x93>
		s++, base = 8;
  801bdf:	ff 45 08             	incl   0x8(%ebp)
  801be2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801be9:	eb 0d                	jmp    801bf8 <strtol+0xa0>
	else if (base == 0)
  801beb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bef:	75 07                	jne    801bf8 <strtol+0xa0>
		base = 10;
  801bf1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	8a 00                	mov    (%eax),%al
  801bfd:	3c 2f                	cmp    $0x2f,%al
  801bff:	7e 19                	jle    801c1a <strtol+0xc2>
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	8a 00                	mov    (%eax),%al
  801c06:	3c 39                	cmp    $0x39,%al
  801c08:	7f 10                	jg     801c1a <strtol+0xc2>
			dig = *s - '0';
  801c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0d:	8a 00                	mov    (%eax),%al
  801c0f:	0f be c0             	movsbl %al,%eax
  801c12:	83 e8 30             	sub    $0x30,%eax
  801c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c18:	eb 42                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8a 00                	mov    (%eax),%al
  801c1f:	3c 60                	cmp    $0x60,%al
  801c21:	7e 19                	jle    801c3c <strtol+0xe4>
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	8a 00                	mov    (%eax),%al
  801c28:	3c 7a                	cmp    $0x7a,%al
  801c2a:	7f 10                	jg     801c3c <strtol+0xe4>
			dig = *s - 'a' + 10;
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	8a 00                	mov    (%eax),%al
  801c31:	0f be c0             	movsbl %al,%eax
  801c34:	83 e8 57             	sub    $0x57,%eax
  801c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801c3a:	eb 20                	jmp    801c5c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3f:	8a 00                	mov    (%eax),%al
  801c41:	3c 40                	cmp    $0x40,%al
  801c43:	7e 39                	jle    801c7e <strtol+0x126>
  801c45:	8b 45 08             	mov    0x8(%ebp),%eax
  801c48:	8a 00                	mov    (%eax),%al
  801c4a:	3c 5a                	cmp    $0x5a,%al
  801c4c:	7f 30                	jg     801c7e <strtol+0x126>
			dig = *s - 'A' + 10;
  801c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c51:	8a 00                	mov    (%eax),%al
  801c53:	0f be c0             	movsbl %al,%eax
  801c56:	83 e8 37             	sub    $0x37,%eax
  801c59:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801c5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801c62:	7d 19                	jge    801c7d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801c64:	ff 45 08             	incl   0x8(%ebp)
  801c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c6a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801c6e:	89 c2                	mov    %eax,%edx
  801c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c73:	01 d0                	add    %edx,%eax
  801c75:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801c78:	e9 7b ff ff ff       	jmp    801bf8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801c7d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801c7e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c82:	74 08                	je     801c8c <strtol+0x134>
		*endptr = (char *) s;
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	8b 55 08             	mov    0x8(%ebp),%edx
  801c8a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801c8c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801c90:	74 07                	je     801c99 <strtol+0x141>
  801c92:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c95:	f7 d8                	neg    %eax
  801c97:	eb 03                	jmp    801c9c <strtol+0x144>
  801c99:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <ltostr>:

void
ltostr(long value, char *str)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801ca4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801cab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801cb6:	79 13                	jns    801ccb <ltostr+0x2d>
	{
		neg = 1;
  801cb8:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc2:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801cc5:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801cc8:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801cd3:	99                   	cltd   
  801cd4:	f7 f9                	idiv   %ecx
  801cd6:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801cd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cdc:	8d 50 01             	lea    0x1(%eax),%edx
  801cdf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801ce2:	89 c2                	mov    %eax,%edx
  801ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce7:	01 d0                	add    %edx,%eax
  801ce9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801cec:	83 c2 30             	add    $0x30,%edx
  801cef:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801cf1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801cf9:	f7 e9                	imul   %ecx
  801cfb:	c1 fa 02             	sar    $0x2,%edx
  801cfe:	89 c8                	mov    %ecx,%eax
  801d00:	c1 f8 1f             	sar    $0x1f,%eax
  801d03:	29 c2                	sub    %eax,%edx
  801d05:	89 d0                	mov    %edx,%eax
  801d07:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801d0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801d12:	f7 e9                	imul   %ecx
  801d14:	c1 fa 02             	sar    $0x2,%edx
  801d17:	89 c8                	mov    %ecx,%eax
  801d19:	c1 f8 1f             	sar    $0x1f,%eax
  801d1c:	29 c2                	sub    %eax,%edx
  801d1e:	89 d0                	mov    %edx,%eax
  801d20:	c1 e0 02             	shl    $0x2,%eax
  801d23:	01 d0                	add    %edx,%eax
  801d25:	01 c0                	add    %eax,%eax
  801d27:	29 c1                	sub    %eax,%ecx
  801d29:	89 ca                	mov    %ecx,%edx
  801d2b:	85 d2                	test   %edx,%edx
  801d2d:	75 9c                	jne    801ccb <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801d36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d39:	48                   	dec    %eax
  801d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801d3d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801d41:	74 3d                	je     801d80 <ltostr+0xe2>
		start = 1 ;
  801d43:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801d4a:	eb 34                	jmp    801d80 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d52:	01 d0                	add    %edx,%eax
  801d54:	8a 00                	mov    (%eax),%al
  801d56:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801d59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5f:	01 c2                	add    %eax,%edx
  801d61:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d67:	01 c8                	add    %ecx,%eax
  801d69:	8a 00                	mov    (%eax),%al
  801d6b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801d6d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d73:	01 c2                	add    %eax,%edx
  801d75:	8a 45 eb             	mov    -0x15(%ebp),%al
  801d78:	88 02                	mov    %al,(%edx)
		start++ ;
  801d7a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801d7d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d83:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801d86:	7c c4                	jl     801d4c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801d88:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	01 d0                	add    %edx,%eax
  801d90:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801d93:	90                   	nop
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801d9c:	ff 75 08             	pushl  0x8(%ebp)
  801d9f:	e8 54 fa ff ff       	call   8017f8 <strlen>
  801da4:	83 c4 04             	add    $0x4,%esp
  801da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801daa:	ff 75 0c             	pushl  0xc(%ebp)
  801dad:	e8 46 fa ff ff       	call   8017f8 <strlen>
  801db2:	83 c4 04             	add    $0x4,%esp
  801db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801db8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801dc6:	eb 17                	jmp    801ddf <strcconcat+0x49>
		final[s] = str1[s] ;
  801dc8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dce:	01 c2                	add    %eax,%edx
  801dd0:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd6:	01 c8                	add    %ecx,%eax
  801dd8:	8a 00                	mov    (%eax),%al
  801dda:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ddc:	ff 45 fc             	incl   -0x4(%ebp)
  801ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801de2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801de5:	7c e1                	jl     801dc8 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801de7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801dee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801df5:	eb 1f                	jmp    801e16 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801df7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801dfa:	8d 50 01             	lea    0x1(%eax),%edx
  801dfd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801e00:	89 c2                	mov    %eax,%edx
  801e02:	8b 45 10             	mov    0x10(%ebp),%eax
  801e05:	01 c2                	add    %eax,%edx
  801e07:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0d:	01 c8                	add    %ecx,%eax
  801e0f:	8a 00                	mov    (%eax),%al
  801e11:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801e13:	ff 45 f8             	incl   -0x8(%ebp)
  801e16:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e19:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801e1c:	7c d9                	jl     801df7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801e1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e21:	8b 45 10             	mov    0x10(%ebp),%eax
  801e24:	01 d0                	add    %edx,%eax
  801e26:	c6 00 00             	movb   $0x0,(%eax)
}
  801e29:	90                   	nop
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801e2f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e32:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801e38:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3b:	8b 00                	mov    (%eax),%eax
  801e3d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801e44:	8b 45 10             	mov    0x10(%ebp),%eax
  801e47:	01 d0                	add    %edx,%eax
  801e49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e4f:	eb 0c                	jmp    801e5d <strsplit+0x31>
			*string++ = 0;
  801e51:	8b 45 08             	mov    0x8(%ebp),%eax
  801e54:	8d 50 01             	lea    0x1(%eax),%edx
  801e57:	89 55 08             	mov    %edx,0x8(%ebp)
  801e5a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e60:	8a 00                	mov    (%eax),%al
  801e62:	84 c0                	test   %al,%al
  801e64:	74 18                	je     801e7e <strsplit+0x52>
  801e66:	8b 45 08             	mov    0x8(%ebp),%eax
  801e69:	8a 00                	mov    (%eax),%al
  801e6b:	0f be c0             	movsbl %al,%eax
  801e6e:	50                   	push   %eax
  801e6f:	ff 75 0c             	pushl  0xc(%ebp)
  801e72:	e8 13 fb ff ff       	call   80198a <strchr>
  801e77:	83 c4 08             	add    $0x8,%esp
  801e7a:	85 c0                	test   %eax,%eax
  801e7c:	75 d3                	jne    801e51 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e81:	8a 00                	mov    (%eax),%al
  801e83:	84 c0                	test   %al,%al
  801e85:	74 5a                	je     801ee1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801e87:	8b 45 14             	mov    0x14(%ebp),%eax
  801e8a:	8b 00                	mov    (%eax),%eax
  801e8c:	83 f8 0f             	cmp    $0xf,%eax
  801e8f:	75 07                	jne    801e98 <strsplit+0x6c>
		{
			return 0;
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
  801e96:	eb 66                	jmp    801efe <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801e98:	8b 45 14             	mov    0x14(%ebp),%eax
  801e9b:	8b 00                	mov    (%eax),%eax
  801e9d:	8d 48 01             	lea    0x1(%eax),%ecx
  801ea0:	8b 55 14             	mov    0x14(%ebp),%edx
  801ea3:	89 0a                	mov    %ecx,(%edx)
  801ea5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	01 c2                	add    %eax,%edx
  801eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb4:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801eb6:	eb 03                	jmp    801ebb <strsplit+0x8f>
			string++;
  801eb8:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebe:	8a 00                	mov    (%eax),%al
  801ec0:	84 c0                	test   %al,%al
  801ec2:	74 8b                	je     801e4f <strsplit+0x23>
  801ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec7:	8a 00                	mov    (%eax),%al
  801ec9:	0f be c0             	movsbl %al,%eax
  801ecc:	50                   	push   %eax
  801ecd:	ff 75 0c             	pushl  0xc(%ebp)
  801ed0:	e8 b5 fa ff ff       	call   80198a <strchr>
  801ed5:	83 c4 08             	add    $0x8,%esp
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	74 dc                	je     801eb8 <strsplit+0x8c>
			string++;
	}
  801edc:	e9 6e ff ff ff       	jmp    801e4f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ee1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ee2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ee5:	8b 00                	mov    (%eax),%eax
  801ee7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801eee:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef1:	01 d0                	add    %edx,%eax
  801ef3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ef9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801efe:	c9                   	leave  
  801eff:	c3                   	ret    

00801f00 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801f06:	a1 04 50 80 00       	mov    0x805004,%eax
  801f0b:	85 c0                	test   %eax,%eax
  801f0d:	74 1f                	je     801f2e <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801f0f:	e8 1d 00 00 00       	call   801f31 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 90 46 80 00       	push   $0x804690
  801f1c:	e8 55 f2 ff ff       	call   801176 <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801f24:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801f2b:	00 00 00 
	}
}
  801f2e:	90                   	nop
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801f37:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801f3e:	00 00 00 
  801f41:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801f48:	00 00 00 
  801f4b:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801f52:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801f55:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801f5c:	00 00 00 
  801f5f:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801f66:	00 00 00 
  801f69:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801f70:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801f73:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	c1 e8 0c             	shr    $0xc,%eax
  801f80:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801f85:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801f8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801f94:	2d 00 10 00 00       	sub    $0x1000,%eax
  801f99:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801f9e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801fa5:	a1 20 51 80 00       	mov    0x805120,%eax
  801faa:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801fae:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801fb1:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801fb8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801fbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fbe:	01 d0                	add    %edx,%eax
  801fc0:	48                   	dec    %eax
  801fc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801fc4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fcc:	f7 75 e4             	divl   -0x1c(%ebp)
  801fcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801fd2:	29 d0                	sub    %edx,%eax
  801fd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801fd7:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801fde:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fe1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801fe6:	2d 00 10 00 00       	sub    $0x1000,%eax
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	6a 07                	push   $0x7
  801ff0:	ff 75 e8             	pushl  -0x18(%ebp)
  801ff3:	50                   	push   %eax
  801ff4:	e8 3d 06 00 00       	call   802636 <sys_allocate_chunk>
  801ff9:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ffc:	a1 20 51 80 00       	mov    0x805120,%eax
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	50                   	push   %eax
  802005:	e8 b2 0c 00 00       	call   802cbc <initialize_MemBlocksList>
  80200a:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  80200d:	a1 4c 51 80 00       	mov    0x80514c,%eax
  802012:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  802015:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802019:	0f 84 f3 00 00 00    	je     802112 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80201f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802023:	75 14                	jne    802039 <initialize_dyn_block_system+0x108>
  802025:	83 ec 04             	sub    $0x4,%esp
  802028:	68 b5 46 80 00       	push   $0x8046b5
  80202d:	6a 36                	push   $0x36
  80202f:	68 d3 46 80 00       	push   $0x8046d3
  802034:	e8 89 ee ff ff       	call   800ec2 <_panic>
  802039:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80203c:	8b 00                	mov    (%eax),%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	74 10                	je     802052 <initialize_dyn_block_system+0x121>
  802042:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802045:	8b 00                	mov    (%eax),%eax
  802047:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80204a:	8b 52 04             	mov    0x4(%edx),%edx
  80204d:	89 50 04             	mov    %edx,0x4(%eax)
  802050:	eb 0b                	jmp    80205d <initialize_dyn_block_system+0x12c>
  802052:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802055:	8b 40 04             	mov    0x4(%eax),%eax
  802058:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80205d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802060:	8b 40 04             	mov    0x4(%eax),%eax
  802063:	85 c0                	test   %eax,%eax
  802065:	74 0f                	je     802076 <initialize_dyn_block_system+0x145>
  802067:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80206a:	8b 40 04             	mov    0x4(%eax),%eax
  80206d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802070:	8b 12                	mov    (%edx),%edx
  802072:	89 10                	mov    %edx,(%eax)
  802074:	eb 0a                	jmp    802080 <initialize_dyn_block_system+0x14f>
  802076:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802079:	8b 00                	mov    (%eax),%eax
  80207b:	a3 48 51 80 00       	mov    %eax,0x805148
  802080:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802083:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802089:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80208c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802093:	a1 54 51 80 00       	mov    0x805154,%eax
  802098:	48                   	dec    %eax
  802099:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80209e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020a1:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8020a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020ab:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8020b2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8020b6:	75 14                	jne    8020cc <initialize_dyn_block_system+0x19b>
  8020b8:	83 ec 04             	sub    $0x4,%esp
  8020bb:	68 e0 46 80 00       	push   $0x8046e0
  8020c0:	6a 3e                	push   $0x3e
  8020c2:	68 d3 46 80 00       	push   $0x8046d3
  8020c7:	e8 f6 ed ff ff       	call   800ec2 <_panic>
  8020cc:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8020d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020d5:	89 10                	mov    %edx,(%eax)
  8020d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020da:	8b 00                	mov    (%eax),%eax
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	74 0d                	je     8020ed <initialize_dyn_block_system+0x1bc>
  8020e0:	a1 38 51 80 00       	mov    0x805138,%eax
  8020e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8020e8:	89 50 04             	mov    %edx,0x4(%eax)
  8020eb:	eb 08                	jmp    8020f5 <initialize_dyn_block_system+0x1c4>
  8020ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8020f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8020f8:	a3 38 51 80 00       	mov    %eax,0x805138
  8020fd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802100:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802107:	a1 44 51 80 00       	mov    0x805144,%eax
  80210c:	40                   	inc    %eax
  80210d:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  802112:	90                   	nop
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
  802118:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80211b:	e8 e0 fd ff ff       	call   801f00 <InitializeUHeap>
		if (size == 0) return NULL ;
  802120:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802124:	75 07                	jne    80212d <malloc+0x18>
  802126:	b8 00 00 00 00       	mov    $0x0,%eax
  80212b:	eb 7f                	jmp    8021ac <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80212d:	e8 d2 08 00 00       	call   802a04 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802132:	85 c0                	test   %eax,%eax
  802134:	74 71                	je     8021a7 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  802136:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80213d:	8b 55 08             	mov    0x8(%ebp),%edx
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	01 d0                	add    %edx,%eax
  802145:	48                   	dec    %eax
  802146:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214c:	ba 00 00 00 00       	mov    $0x0,%edx
  802151:	f7 75 f4             	divl   -0xc(%ebp)
  802154:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802157:	29 d0                	sub    %edx,%eax
  802159:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80215c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  802163:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80216a:	76 07                	jbe    802173 <malloc+0x5e>
					return NULL ;
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
  802171:	eb 39                	jmp    8021ac <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  802173:	83 ec 0c             	sub    $0xc,%esp
  802176:	ff 75 08             	pushl  0x8(%ebp)
  802179:	e8 e6 0d 00 00       	call   802f64 <alloc_block_FF>
  80217e:	83 c4 10             	add    $0x10,%esp
  802181:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  802184:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802188:	74 16                	je     8021a0 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80218a:	83 ec 0c             	sub    $0xc,%esp
  80218d:	ff 75 ec             	pushl  -0x14(%ebp)
  802190:	e8 37 0c 00 00       	call   802dcc <insert_sorted_allocList>
  802195:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  802198:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219b:	8b 40 08             	mov    0x8(%eax),%eax
  80219e:	eb 0c                	jmp    8021ac <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8021a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a5:	eb 05                	jmp    8021ac <malloc+0x97>
				}
		}
	return 0;
  8021a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8021ba:	83 ec 08             	sub    $0x8,%esp
  8021bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8021c0:	68 40 50 80 00       	push   $0x805040
  8021c5:	e8 cf 0b 00 00       	call   802d99 <find_block>
  8021ca:	83 c4 10             	add    $0x10,%esp
  8021cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8021d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8021d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021dc:	8b 40 08             	mov    0x8(%eax),%eax
  8021df:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8021e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021e6:	0f 84 a1 00 00 00    	je     80228d <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8021ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021f0:	75 17                	jne    802209 <free+0x5b>
  8021f2:	83 ec 04             	sub    $0x4,%esp
  8021f5:	68 b5 46 80 00       	push   $0x8046b5
  8021fa:	68 80 00 00 00       	push   $0x80
  8021ff:	68 d3 46 80 00       	push   $0x8046d3
  802204:	e8 b9 ec ff ff       	call   800ec2 <_panic>
  802209:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80220c:	8b 00                	mov    (%eax),%eax
  80220e:	85 c0                	test   %eax,%eax
  802210:	74 10                	je     802222 <free+0x74>
  802212:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802215:	8b 00                	mov    (%eax),%eax
  802217:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80221a:	8b 52 04             	mov    0x4(%edx),%edx
  80221d:	89 50 04             	mov    %edx,0x4(%eax)
  802220:	eb 0b                	jmp    80222d <free+0x7f>
  802222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802225:	8b 40 04             	mov    0x4(%eax),%eax
  802228:	a3 44 50 80 00       	mov    %eax,0x805044
  80222d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802230:	8b 40 04             	mov    0x4(%eax),%eax
  802233:	85 c0                	test   %eax,%eax
  802235:	74 0f                	je     802246 <free+0x98>
  802237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223a:	8b 40 04             	mov    0x4(%eax),%eax
  80223d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802240:	8b 12                	mov    (%edx),%edx
  802242:	89 10                	mov    %edx,(%eax)
  802244:	eb 0a                	jmp    802250 <free+0xa2>
  802246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802249:	8b 00                	mov    (%eax),%eax
  80224b:	a3 40 50 80 00       	mov    %eax,0x805040
  802250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802253:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802263:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802268:	48                   	dec    %eax
  802269:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  80226e:	83 ec 0c             	sub    $0xc,%esp
  802271:	ff 75 f0             	pushl  -0x10(%ebp)
  802274:	e8 29 12 00 00       	call   8034a2 <insert_sorted_with_merge_freeList>
  802279:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  80227c:	83 ec 08             	sub    $0x8,%esp
  80227f:	ff 75 ec             	pushl  -0x14(%ebp)
  802282:	ff 75 e8             	pushl  -0x18(%ebp)
  802285:	e8 74 03 00 00       	call   8025fe <sys_free_user_mem>
  80228a:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80228d:	90                   	nop
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
  802293:	83 ec 38             	sub    $0x38,%esp
  802296:	8b 45 10             	mov    0x10(%ebp),%eax
  802299:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80229c:	e8 5f fc ff ff       	call   801f00 <InitializeUHeap>
	if (size == 0) return NULL ;
  8022a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8022a5:	75 0a                	jne    8022b1 <smalloc+0x21>
  8022a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ac:	e9 b2 00 00 00       	jmp    802363 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8022b1:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8022b8:	76 0a                	jbe    8022c4 <smalloc+0x34>
		return NULL;
  8022ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8022bf:	e9 9f 00 00 00       	jmp    802363 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8022c4:	e8 3b 07 00 00       	call   802a04 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	0f 84 8d 00 00 00    	je     80235e <smalloc+0xce>
	struct MemBlock *b = NULL;
  8022d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8022d8:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8022df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022e5:	01 d0                	add    %edx,%eax
  8022e7:	48                   	dec    %eax
  8022e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8022eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8022f3:	f7 75 f0             	divl   -0x10(%ebp)
  8022f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f9:	29 d0                	sub    %edx,%eax
  8022fb:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8022fe:	83 ec 0c             	sub    $0xc,%esp
  802301:	ff 75 e8             	pushl  -0x18(%ebp)
  802304:	e8 5b 0c 00 00       	call   802f64 <alloc_block_FF>
  802309:	83 c4 10             	add    $0x10,%esp
  80230c:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  80230f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802313:	75 07                	jne    80231c <smalloc+0x8c>
			return NULL;
  802315:	b8 00 00 00 00       	mov    $0x0,%eax
  80231a:	eb 47                	jmp    802363 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  80231c:	83 ec 0c             	sub    $0xc,%esp
  80231f:	ff 75 f4             	pushl  -0xc(%ebp)
  802322:	e8 a5 0a 00 00       	call   802dcc <insert_sorted_allocList>
  802327:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	8b 40 08             	mov    0x8(%eax),%eax
  802330:	89 c2                	mov    %eax,%edx
  802332:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802336:	52                   	push   %edx
  802337:	50                   	push   %eax
  802338:	ff 75 0c             	pushl  0xc(%ebp)
  80233b:	ff 75 08             	pushl  0x8(%ebp)
  80233e:	e8 46 04 00 00       	call   802789 <sys_createSharedObject>
  802343:	83 c4 10             	add    $0x10,%esp
  802346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  802349:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80234d:	78 08                	js     802357 <smalloc+0xc7>
		return (void *)b->sva;
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 40 08             	mov    0x8(%eax),%eax
  802355:	eb 0c                	jmp    802363 <smalloc+0xd3>
		}else{
		return NULL;
  802357:	b8 00 00 00 00       	mov    $0x0,%eax
  80235c:	eb 05                	jmp    802363 <smalloc+0xd3>
			}

	}return NULL;
  80235e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80236b:	e8 90 fb ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802370:	e8 8f 06 00 00       	call   802a04 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802375:	85 c0                	test   %eax,%eax
  802377:	0f 84 ad 00 00 00    	je     80242a <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80237d:	83 ec 08             	sub    $0x8,%esp
  802380:	ff 75 0c             	pushl  0xc(%ebp)
  802383:	ff 75 08             	pushl  0x8(%ebp)
  802386:	e8 28 04 00 00       	call   8027b3 <sys_getSizeOfSharedObject>
  80238b:	83 c4 10             	add    $0x10,%esp
  80238e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  802391:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802395:	79 0a                	jns    8023a1 <sget+0x3c>
    {
    	return NULL;
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
  80239c:	e9 8e 00 00 00       	jmp    80242f <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8023a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8023a8:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8023af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b5:	01 d0                	add    %edx,%eax
  8023b7:	48                   	dec    %eax
  8023b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8023bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023be:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c3:	f7 75 ec             	divl   -0x14(%ebp)
  8023c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8023c9:	29 d0                	sub    %edx,%eax
  8023cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8023ce:	83 ec 0c             	sub    $0xc,%esp
  8023d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8023d4:	e8 8b 0b 00 00       	call   802f64 <alloc_block_FF>
  8023d9:	83 c4 10             	add    $0x10,%esp
  8023dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8023df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023e3:	75 07                	jne    8023ec <sget+0x87>
				return NULL;
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ea:	eb 43                	jmp    80242f <sget+0xca>
			}
			insert_sorted_allocList(b);
  8023ec:	83 ec 0c             	sub    $0xc,%esp
  8023ef:	ff 75 f0             	pushl  -0x10(%ebp)
  8023f2:	e8 d5 09 00 00       	call   802dcc <insert_sorted_allocList>
  8023f7:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8023fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fd:	8b 40 08             	mov    0x8(%eax),%eax
  802400:	83 ec 04             	sub    $0x4,%esp
  802403:	50                   	push   %eax
  802404:	ff 75 0c             	pushl  0xc(%ebp)
  802407:	ff 75 08             	pushl  0x8(%ebp)
  80240a:	e8 c1 03 00 00       	call   8027d0 <sys_getSharedObject>
  80240f:	83 c4 10             	add    $0x10,%esp
  802412:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  802415:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802419:	78 08                	js     802423 <sget+0xbe>
			return (void *)b->sva;
  80241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241e:	8b 40 08             	mov    0x8(%eax),%eax
  802421:	eb 0c                	jmp    80242f <sget+0xca>
			}else{
			return NULL;
  802423:	b8 00 00 00 00       	mov    $0x0,%eax
  802428:	eb 05                	jmp    80242f <sget+0xca>
			}
    }}return NULL;
  80242a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80242f:	c9                   	leave  
  802430:	c3                   	ret    

00802431 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802431:	55                   	push   %ebp
  802432:	89 e5                	mov    %esp,%ebp
  802434:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802437:	e8 c4 fa ff ff       	call   801f00 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	68 04 47 80 00       	push   $0x804704
  802444:	68 03 01 00 00       	push   $0x103
  802449:	68 d3 46 80 00       	push   $0x8046d3
  80244e:	e8 6f ea ff ff       	call   800ec2 <_panic>

00802453 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802453:	55                   	push   %ebp
  802454:	89 e5                	mov    %esp,%ebp
  802456:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802459:	83 ec 04             	sub    $0x4,%esp
  80245c:	68 2c 47 80 00       	push   $0x80472c
  802461:	68 17 01 00 00       	push   $0x117
  802466:	68 d3 46 80 00       	push   $0x8046d3
  80246b:	e8 52 ea ff ff       	call   800ec2 <_panic>

00802470 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
  802473:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	68 50 47 80 00       	push   $0x804750
  80247e:	68 22 01 00 00       	push   $0x122
  802483:	68 d3 46 80 00       	push   $0x8046d3
  802488:	e8 35 ea ff ff       	call   800ec2 <_panic>

0080248d <shrink>:

}
void shrink(uint32 newSize)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
  802490:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802493:	83 ec 04             	sub    $0x4,%esp
  802496:	68 50 47 80 00       	push   $0x804750
  80249b:	68 27 01 00 00       	push   $0x127
  8024a0:	68 d3 46 80 00       	push   $0x8046d3
  8024a5:	e8 18 ea ff ff       	call   800ec2 <_panic>

008024aa <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8024b0:	83 ec 04             	sub    $0x4,%esp
  8024b3:	68 50 47 80 00       	push   $0x804750
  8024b8:	68 2c 01 00 00       	push   $0x12c
  8024bd:	68 d3 46 80 00       	push   $0x8046d3
  8024c2:	e8 fb e9 ff ff       	call   800ec2 <_panic>

008024c7 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8024c7:	55                   	push   %ebp
  8024c8:	89 e5                	mov    %esp,%ebp
  8024ca:	57                   	push   %edi
  8024cb:	56                   	push   %esi
  8024cc:	53                   	push   %ebx
  8024cd:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8024d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024dc:	8b 7d 18             	mov    0x18(%ebp),%edi
  8024df:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8024e2:	cd 30                	int    $0x30
  8024e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8024e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8024ea:	83 c4 10             	add    $0x10,%esp
  8024ed:	5b                   	pop    %ebx
  8024ee:	5e                   	pop    %esi
  8024ef:	5f                   	pop    %edi
  8024f0:	5d                   	pop    %ebp
  8024f1:	c3                   	ret    

008024f2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
  8024f5:	83 ec 04             	sub    $0x4,%esp
  8024f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8024fb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8024fe:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	6a 00                	push   $0x0
  802507:	6a 00                	push   $0x0
  802509:	52                   	push   %edx
  80250a:	ff 75 0c             	pushl  0xc(%ebp)
  80250d:	50                   	push   %eax
  80250e:	6a 00                	push   $0x0
  802510:	e8 b2 ff ff ff       	call   8024c7 <syscall>
  802515:	83 c4 18             	add    $0x18,%esp
}
  802518:	90                   	nop
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <sys_cgetc>:

int
sys_cgetc(void)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 01                	push   $0x1
  80252a:	e8 98 ff ff ff       	call   8024c7 <syscall>
  80252f:	83 c4 18             	add    $0x18,%esp
}
  802532:	c9                   	leave  
  802533:	c3                   	ret    

00802534 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802537:	8b 55 0c             	mov    0xc(%ebp),%edx
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	6a 00                	push   $0x0
  80253f:	6a 00                	push   $0x0
  802541:	6a 00                	push   $0x0
  802543:	52                   	push   %edx
  802544:	50                   	push   %eax
  802545:	6a 05                	push   $0x5
  802547:	e8 7b ff ff ff       	call   8024c7 <syscall>
  80254c:	83 c4 18             	add    $0x18,%esp
}
  80254f:	c9                   	leave  
  802550:	c3                   	ret    

00802551 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	56                   	push   %esi
  802555:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802556:	8b 75 18             	mov    0x18(%ebp),%esi
  802559:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80255c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80255f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802562:	8b 45 08             	mov    0x8(%ebp),%eax
  802565:	56                   	push   %esi
  802566:	53                   	push   %ebx
  802567:	51                   	push   %ecx
  802568:	52                   	push   %edx
  802569:	50                   	push   %eax
  80256a:	6a 06                	push   $0x6
  80256c:	e8 56 ff ff ff       	call   8024c7 <syscall>
  802571:	83 c4 18             	add    $0x18,%esp
}
  802574:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5d                   	pop    %ebp
  80257a:	c3                   	ret    

0080257b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80257b:	55                   	push   %ebp
  80257c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80257e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802581:	8b 45 08             	mov    0x8(%ebp),%eax
  802584:	6a 00                	push   $0x0
  802586:	6a 00                	push   $0x0
  802588:	6a 00                	push   $0x0
  80258a:	52                   	push   %edx
  80258b:	50                   	push   %eax
  80258c:	6a 07                	push   $0x7
  80258e:	e8 34 ff ff ff       	call   8024c7 <syscall>
  802593:	83 c4 18             	add    $0x18,%esp
}
  802596:	c9                   	leave  
  802597:	c3                   	ret    

00802598 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802598:	55                   	push   %ebp
  802599:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 00                	push   $0x0
  8025a1:	ff 75 0c             	pushl  0xc(%ebp)
  8025a4:	ff 75 08             	pushl  0x8(%ebp)
  8025a7:	6a 08                	push   $0x8
  8025a9:	e8 19 ff ff ff       	call   8024c7 <syscall>
  8025ae:	83 c4 18             	add    $0x18,%esp
}
  8025b1:	c9                   	leave  
  8025b2:	c3                   	ret    

008025b3 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8025b3:	55                   	push   %ebp
  8025b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 00                	push   $0x0
  8025ba:	6a 00                	push   $0x0
  8025bc:	6a 00                	push   $0x0
  8025be:	6a 00                	push   $0x0
  8025c0:	6a 09                	push   $0x9
  8025c2:	e8 00 ff ff ff       	call   8024c7 <syscall>
  8025c7:	83 c4 18             	add    $0x18,%esp
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 0a                	push   $0xa
  8025db:	e8 e7 fe ff ff       	call   8024c7 <syscall>
  8025e0:	83 c4 18             	add    $0x18,%esp
}
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8025e8:	6a 00                	push   $0x0
  8025ea:	6a 00                	push   $0x0
  8025ec:	6a 00                	push   $0x0
  8025ee:	6a 00                	push   $0x0
  8025f0:	6a 00                	push   $0x0
  8025f2:	6a 0b                	push   $0xb
  8025f4:	e8 ce fe ff ff       	call   8024c7 <syscall>
  8025f9:	83 c4 18             	add    $0x18,%esp
}
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802601:	6a 00                	push   $0x0
  802603:	6a 00                	push   $0x0
  802605:	6a 00                	push   $0x0
  802607:	ff 75 0c             	pushl  0xc(%ebp)
  80260a:	ff 75 08             	pushl  0x8(%ebp)
  80260d:	6a 0f                	push   $0xf
  80260f:	e8 b3 fe ff ff       	call   8024c7 <syscall>
  802614:	83 c4 18             	add    $0x18,%esp
	return;
  802617:	90                   	nop
}
  802618:	c9                   	leave  
  802619:	c3                   	ret    

0080261a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80261a:	55                   	push   %ebp
  80261b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	ff 75 0c             	pushl  0xc(%ebp)
  802626:	ff 75 08             	pushl  0x8(%ebp)
  802629:	6a 10                	push   $0x10
  80262b:	e8 97 fe ff ff       	call   8024c7 <syscall>
  802630:	83 c4 18             	add    $0x18,%esp
	return ;
  802633:	90                   	nop
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802639:	6a 00                	push   $0x0
  80263b:	6a 00                	push   $0x0
  80263d:	ff 75 10             	pushl  0x10(%ebp)
  802640:	ff 75 0c             	pushl  0xc(%ebp)
  802643:	ff 75 08             	pushl  0x8(%ebp)
  802646:	6a 11                	push   $0x11
  802648:	e8 7a fe ff ff       	call   8024c7 <syscall>
  80264d:	83 c4 18             	add    $0x18,%esp
	return ;
  802650:	90                   	nop
}
  802651:	c9                   	leave  
  802652:	c3                   	ret    

00802653 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802653:	55                   	push   %ebp
  802654:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802656:	6a 00                	push   $0x0
  802658:	6a 00                	push   $0x0
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 0c                	push   $0xc
  802662:	e8 60 fe ff ff       	call   8024c7 <syscall>
  802667:	83 c4 18             	add    $0x18,%esp
}
  80266a:	c9                   	leave  
  80266b:	c3                   	ret    

0080266c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80266c:	55                   	push   %ebp
  80266d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80266f:	6a 00                	push   $0x0
  802671:	6a 00                	push   $0x0
  802673:	6a 00                	push   $0x0
  802675:	6a 00                	push   $0x0
  802677:	ff 75 08             	pushl  0x8(%ebp)
  80267a:	6a 0d                	push   $0xd
  80267c:	e8 46 fe ff ff       	call   8024c7 <syscall>
  802681:	83 c4 18             	add    $0x18,%esp
}
  802684:	c9                   	leave  
  802685:	c3                   	ret    

00802686 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802686:	55                   	push   %ebp
  802687:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802689:	6a 00                	push   $0x0
  80268b:	6a 00                	push   $0x0
  80268d:	6a 00                	push   $0x0
  80268f:	6a 00                	push   $0x0
  802691:	6a 00                	push   $0x0
  802693:	6a 0e                	push   $0xe
  802695:	e8 2d fe ff ff       	call   8024c7 <syscall>
  80269a:	83 c4 18             	add    $0x18,%esp
}
  80269d:	90                   	nop
  80269e:	c9                   	leave  
  80269f:	c3                   	ret    

008026a0 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	6a 00                	push   $0x0
  8026a9:	6a 00                	push   $0x0
  8026ab:	6a 00                	push   $0x0
  8026ad:	6a 13                	push   $0x13
  8026af:	e8 13 fe ff ff       	call   8024c7 <syscall>
  8026b4:	83 c4 18             	add    $0x18,%esp
}
  8026b7:	90                   	nop
  8026b8:	c9                   	leave  
  8026b9:	c3                   	ret    

008026ba <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8026bd:	6a 00                	push   $0x0
  8026bf:	6a 00                	push   $0x0
  8026c1:	6a 00                	push   $0x0
  8026c3:	6a 00                	push   $0x0
  8026c5:	6a 00                	push   $0x0
  8026c7:	6a 14                	push   $0x14
  8026c9:	e8 f9 fd ff ff       	call   8024c7 <syscall>
  8026ce:	83 c4 18             	add    $0x18,%esp
}
  8026d1:	90                   	nop
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <sys_cputc>:


void
sys_cputc(const char c)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 04             	sub    $0x4,%esp
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8026e0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8026e4:	6a 00                	push   $0x0
  8026e6:	6a 00                	push   $0x0
  8026e8:	6a 00                	push   $0x0
  8026ea:	6a 00                	push   $0x0
  8026ec:	50                   	push   %eax
  8026ed:	6a 15                	push   $0x15
  8026ef:	e8 d3 fd ff ff       	call   8024c7 <syscall>
  8026f4:	83 c4 18             	add    $0x18,%esp
}
  8026f7:	90                   	nop
  8026f8:	c9                   	leave  
  8026f9:	c3                   	ret    

008026fa <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8026fa:	55                   	push   %ebp
  8026fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8026fd:	6a 00                	push   $0x0
  8026ff:	6a 00                	push   $0x0
  802701:	6a 00                	push   $0x0
  802703:	6a 00                	push   $0x0
  802705:	6a 00                	push   $0x0
  802707:	6a 16                	push   $0x16
  802709:	e8 b9 fd ff ff       	call   8024c7 <syscall>
  80270e:	83 c4 18             	add    $0x18,%esp
}
  802711:	90                   	nop
  802712:	c9                   	leave  
  802713:	c3                   	ret    

00802714 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802714:	55                   	push   %ebp
  802715:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802717:	8b 45 08             	mov    0x8(%ebp),%eax
  80271a:	6a 00                	push   $0x0
  80271c:	6a 00                	push   $0x0
  80271e:	6a 00                	push   $0x0
  802720:	ff 75 0c             	pushl  0xc(%ebp)
  802723:	50                   	push   %eax
  802724:	6a 17                	push   $0x17
  802726:	e8 9c fd ff ff       	call   8024c7 <syscall>
  80272b:	83 c4 18             	add    $0x18,%esp
}
  80272e:	c9                   	leave  
  80272f:	c3                   	ret    

00802730 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802733:	8b 55 0c             	mov    0xc(%ebp),%edx
  802736:	8b 45 08             	mov    0x8(%ebp),%eax
  802739:	6a 00                	push   $0x0
  80273b:	6a 00                	push   $0x0
  80273d:	6a 00                	push   $0x0
  80273f:	52                   	push   %edx
  802740:	50                   	push   %eax
  802741:	6a 1a                	push   $0x1a
  802743:	e8 7f fd ff ff       	call   8024c7 <syscall>
  802748:	83 c4 18             	add    $0x18,%esp
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802750:	8b 55 0c             	mov    0xc(%ebp),%edx
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	52                   	push   %edx
  80275d:	50                   	push   %eax
  80275e:	6a 18                	push   $0x18
  802760:	e8 62 fd ff ff       	call   8024c7 <syscall>
  802765:	83 c4 18             	add    $0x18,%esp
}
  802768:	90                   	nop
  802769:	c9                   	leave  
  80276a:	c3                   	ret    

0080276b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80276b:	55                   	push   %ebp
  80276c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80276e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802771:	8b 45 08             	mov    0x8(%ebp),%eax
  802774:	6a 00                	push   $0x0
  802776:	6a 00                	push   $0x0
  802778:	6a 00                	push   $0x0
  80277a:	52                   	push   %edx
  80277b:	50                   	push   %eax
  80277c:	6a 19                	push   $0x19
  80277e:	e8 44 fd ff ff       	call   8024c7 <syscall>
  802783:	83 c4 18             	add    $0x18,%esp
}
  802786:	90                   	nop
  802787:	c9                   	leave  
  802788:	c3                   	ret    

00802789 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802789:	55                   	push   %ebp
  80278a:	89 e5                	mov    %esp,%ebp
  80278c:	83 ec 04             	sub    $0x4,%esp
  80278f:	8b 45 10             	mov    0x10(%ebp),%eax
  802792:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802795:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802798:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80279c:	8b 45 08             	mov    0x8(%ebp),%eax
  80279f:	6a 00                	push   $0x0
  8027a1:	51                   	push   %ecx
  8027a2:	52                   	push   %edx
  8027a3:	ff 75 0c             	pushl  0xc(%ebp)
  8027a6:	50                   	push   %eax
  8027a7:	6a 1b                	push   $0x1b
  8027a9:	e8 19 fd ff ff       	call   8024c7 <syscall>
  8027ae:	83 c4 18             	add    $0x18,%esp
}
  8027b1:	c9                   	leave  
  8027b2:	c3                   	ret    

008027b3 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8027b3:	55                   	push   %ebp
  8027b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8027b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bc:	6a 00                	push   $0x0
  8027be:	6a 00                	push   $0x0
  8027c0:	6a 00                	push   $0x0
  8027c2:	52                   	push   %edx
  8027c3:	50                   	push   %eax
  8027c4:	6a 1c                	push   $0x1c
  8027c6:	e8 fc fc ff ff       	call   8024c7 <syscall>
  8027cb:	83 c4 18             	add    $0x18,%esp
}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8027d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027dc:	6a 00                	push   $0x0
  8027de:	6a 00                	push   $0x0
  8027e0:	51                   	push   %ecx
  8027e1:	52                   	push   %edx
  8027e2:	50                   	push   %eax
  8027e3:	6a 1d                	push   $0x1d
  8027e5:	e8 dd fc ff ff       	call   8024c7 <syscall>
  8027ea:	83 c4 18             	add    $0x18,%esp
}
  8027ed:	c9                   	leave  
  8027ee:	c3                   	ret    

008027ef <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8027ef:	55                   	push   %ebp
  8027f0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8027f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f8:	6a 00                	push   $0x0
  8027fa:	6a 00                	push   $0x0
  8027fc:	6a 00                	push   $0x0
  8027fe:	52                   	push   %edx
  8027ff:	50                   	push   %eax
  802800:	6a 1e                	push   $0x1e
  802802:	e8 c0 fc ff ff       	call   8024c7 <syscall>
  802807:	83 c4 18             	add    $0x18,%esp
}
  80280a:	c9                   	leave  
  80280b:	c3                   	ret    

0080280c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80280c:	55                   	push   %ebp
  80280d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80280f:	6a 00                	push   $0x0
  802811:	6a 00                	push   $0x0
  802813:	6a 00                	push   $0x0
  802815:	6a 00                	push   $0x0
  802817:	6a 00                	push   $0x0
  802819:	6a 1f                	push   $0x1f
  80281b:	e8 a7 fc ff ff       	call   8024c7 <syscall>
  802820:	83 c4 18             	add    $0x18,%esp
}
  802823:	c9                   	leave  
  802824:	c3                   	ret    

00802825 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802825:	55                   	push   %ebp
  802826:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	6a 00                	push   $0x0
  80282d:	ff 75 14             	pushl  0x14(%ebp)
  802830:	ff 75 10             	pushl  0x10(%ebp)
  802833:	ff 75 0c             	pushl  0xc(%ebp)
  802836:	50                   	push   %eax
  802837:	6a 20                	push   $0x20
  802839:	e8 89 fc ff ff       	call   8024c7 <syscall>
  80283e:	83 c4 18             	add    $0x18,%esp
}
  802841:	c9                   	leave  
  802842:	c3                   	ret    

00802843 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802846:	8b 45 08             	mov    0x8(%ebp),%eax
  802849:	6a 00                	push   $0x0
  80284b:	6a 00                	push   $0x0
  80284d:	6a 00                	push   $0x0
  80284f:	6a 00                	push   $0x0
  802851:	50                   	push   %eax
  802852:	6a 21                	push   $0x21
  802854:	e8 6e fc ff ff       	call   8024c7 <syscall>
  802859:	83 c4 18             	add    $0x18,%esp
}
  80285c:	90                   	nop
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	6a 00                	push   $0x0
  802867:	6a 00                	push   $0x0
  802869:	6a 00                	push   $0x0
  80286b:	6a 00                	push   $0x0
  80286d:	50                   	push   %eax
  80286e:	6a 22                	push   $0x22
  802870:	e8 52 fc ff ff       	call   8024c7 <syscall>
  802875:	83 c4 18             	add    $0x18,%esp
}
  802878:	c9                   	leave  
  802879:	c3                   	ret    

0080287a <sys_getenvid>:

int32 sys_getenvid(void)
{
  80287a:	55                   	push   %ebp
  80287b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80287d:	6a 00                	push   $0x0
  80287f:	6a 00                	push   $0x0
  802881:	6a 00                	push   $0x0
  802883:	6a 00                	push   $0x0
  802885:	6a 00                	push   $0x0
  802887:	6a 02                	push   $0x2
  802889:	e8 39 fc ff ff       	call   8024c7 <syscall>
  80288e:	83 c4 18             	add    $0x18,%esp
}
  802891:	c9                   	leave  
  802892:	c3                   	ret    

00802893 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802893:	55                   	push   %ebp
  802894:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802896:	6a 00                	push   $0x0
  802898:	6a 00                	push   $0x0
  80289a:	6a 00                	push   $0x0
  80289c:	6a 00                	push   $0x0
  80289e:	6a 00                	push   $0x0
  8028a0:	6a 03                	push   $0x3
  8028a2:	e8 20 fc ff ff       	call   8024c7 <syscall>
  8028a7:	83 c4 18             	add    $0x18,%esp
}
  8028aa:	c9                   	leave  
  8028ab:	c3                   	ret    

008028ac <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8028ac:	55                   	push   %ebp
  8028ad:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8028af:	6a 00                	push   $0x0
  8028b1:	6a 00                	push   $0x0
  8028b3:	6a 00                	push   $0x0
  8028b5:	6a 00                	push   $0x0
  8028b7:	6a 00                	push   $0x0
  8028b9:	6a 04                	push   $0x4
  8028bb:	e8 07 fc ff ff       	call   8024c7 <syscall>
  8028c0:	83 c4 18             	add    $0x18,%esp
}
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    

008028c5 <sys_exit_env>:


void sys_exit_env(void)
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8028c8:	6a 00                	push   $0x0
  8028ca:	6a 00                	push   $0x0
  8028cc:	6a 00                	push   $0x0
  8028ce:	6a 00                	push   $0x0
  8028d0:	6a 00                	push   $0x0
  8028d2:	6a 23                	push   $0x23
  8028d4:	e8 ee fb ff ff       	call   8024c7 <syscall>
  8028d9:	83 c4 18             	add    $0x18,%esp
}
  8028dc:	90                   	nop
  8028dd:	c9                   	leave  
  8028de:	c3                   	ret    

008028df <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8028df:	55                   	push   %ebp
  8028e0:	89 e5                	mov    %esp,%ebp
  8028e2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8028e5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028e8:	8d 50 04             	lea    0x4(%eax),%edx
  8028eb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8028ee:	6a 00                	push   $0x0
  8028f0:	6a 00                	push   $0x0
  8028f2:	6a 00                	push   $0x0
  8028f4:	52                   	push   %edx
  8028f5:	50                   	push   %eax
  8028f6:	6a 24                	push   $0x24
  8028f8:	e8 ca fb ff ff       	call   8024c7 <syscall>
  8028fd:	83 c4 18             	add    $0x18,%esp
	return result;
  802900:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802903:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802906:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802909:	89 01                	mov    %eax,(%ecx)
  80290b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80290e:	8b 45 08             	mov    0x8(%ebp),%eax
  802911:	c9                   	leave  
  802912:	c2 04 00             	ret    $0x4

00802915 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802918:	6a 00                	push   $0x0
  80291a:	6a 00                	push   $0x0
  80291c:	ff 75 10             	pushl  0x10(%ebp)
  80291f:	ff 75 0c             	pushl  0xc(%ebp)
  802922:	ff 75 08             	pushl  0x8(%ebp)
  802925:	6a 12                	push   $0x12
  802927:	e8 9b fb ff ff       	call   8024c7 <syscall>
  80292c:	83 c4 18             	add    $0x18,%esp
	return ;
  80292f:	90                   	nop
}
  802930:	c9                   	leave  
  802931:	c3                   	ret    

00802932 <sys_rcr2>:
uint32 sys_rcr2()
{
  802932:	55                   	push   %ebp
  802933:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802935:	6a 00                	push   $0x0
  802937:	6a 00                	push   $0x0
  802939:	6a 00                	push   $0x0
  80293b:	6a 00                	push   $0x0
  80293d:	6a 00                	push   $0x0
  80293f:	6a 25                	push   $0x25
  802941:	e8 81 fb ff ff       	call   8024c7 <syscall>
  802946:	83 c4 18             	add    $0x18,%esp
}
  802949:	c9                   	leave  
  80294a:	c3                   	ret    

0080294b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80294b:	55                   	push   %ebp
  80294c:	89 e5                	mov    %esp,%ebp
  80294e:	83 ec 04             	sub    $0x4,%esp
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802957:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80295b:	6a 00                	push   $0x0
  80295d:	6a 00                	push   $0x0
  80295f:	6a 00                	push   $0x0
  802961:	6a 00                	push   $0x0
  802963:	50                   	push   %eax
  802964:	6a 26                	push   $0x26
  802966:	e8 5c fb ff ff       	call   8024c7 <syscall>
  80296b:	83 c4 18             	add    $0x18,%esp
	return ;
  80296e:	90                   	nop
}
  80296f:	c9                   	leave  
  802970:	c3                   	ret    

00802971 <rsttst>:
void rsttst()
{
  802971:	55                   	push   %ebp
  802972:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802974:	6a 00                	push   $0x0
  802976:	6a 00                	push   $0x0
  802978:	6a 00                	push   $0x0
  80297a:	6a 00                	push   $0x0
  80297c:	6a 00                	push   $0x0
  80297e:	6a 28                	push   $0x28
  802980:	e8 42 fb ff ff       	call   8024c7 <syscall>
  802985:	83 c4 18             	add    $0x18,%esp
	return ;
  802988:	90                   	nop
}
  802989:	c9                   	leave  
  80298a:	c3                   	ret    

0080298b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80298b:	55                   	push   %ebp
  80298c:	89 e5                	mov    %esp,%ebp
  80298e:	83 ec 04             	sub    $0x4,%esp
  802991:	8b 45 14             	mov    0x14(%ebp),%eax
  802994:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802997:	8b 55 18             	mov    0x18(%ebp),%edx
  80299a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80299e:	52                   	push   %edx
  80299f:	50                   	push   %eax
  8029a0:	ff 75 10             	pushl  0x10(%ebp)
  8029a3:	ff 75 0c             	pushl  0xc(%ebp)
  8029a6:	ff 75 08             	pushl  0x8(%ebp)
  8029a9:	6a 27                	push   $0x27
  8029ab:	e8 17 fb ff ff       	call   8024c7 <syscall>
  8029b0:	83 c4 18             	add    $0x18,%esp
	return ;
  8029b3:	90                   	nop
}
  8029b4:	c9                   	leave  
  8029b5:	c3                   	ret    

008029b6 <chktst>:
void chktst(uint32 n)
{
  8029b6:	55                   	push   %ebp
  8029b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8029b9:	6a 00                	push   $0x0
  8029bb:	6a 00                	push   $0x0
  8029bd:	6a 00                	push   $0x0
  8029bf:	6a 00                	push   $0x0
  8029c1:	ff 75 08             	pushl  0x8(%ebp)
  8029c4:	6a 29                	push   $0x29
  8029c6:	e8 fc fa ff ff       	call   8024c7 <syscall>
  8029cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8029ce:	90                   	nop
}
  8029cf:	c9                   	leave  
  8029d0:	c3                   	ret    

008029d1 <inctst>:

void inctst()
{
  8029d1:	55                   	push   %ebp
  8029d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8029d4:	6a 00                	push   $0x0
  8029d6:	6a 00                	push   $0x0
  8029d8:	6a 00                	push   $0x0
  8029da:	6a 00                	push   $0x0
  8029dc:	6a 00                	push   $0x0
  8029de:	6a 2a                	push   $0x2a
  8029e0:	e8 e2 fa ff ff       	call   8024c7 <syscall>
  8029e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8029e8:	90                   	nop
}
  8029e9:	c9                   	leave  
  8029ea:	c3                   	ret    

008029eb <gettst>:
uint32 gettst()
{
  8029eb:	55                   	push   %ebp
  8029ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8029ee:	6a 00                	push   $0x0
  8029f0:	6a 00                	push   $0x0
  8029f2:	6a 00                	push   $0x0
  8029f4:	6a 00                	push   $0x0
  8029f6:	6a 00                	push   $0x0
  8029f8:	6a 2b                	push   $0x2b
  8029fa:	e8 c8 fa ff ff       	call   8024c7 <syscall>
  8029ff:	83 c4 18             	add    $0x18,%esp
}
  802a02:	c9                   	leave  
  802a03:	c3                   	ret    

00802a04 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802a04:	55                   	push   %ebp
  802a05:	89 e5                	mov    %esp,%ebp
  802a07:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a0a:	6a 00                	push   $0x0
  802a0c:	6a 00                	push   $0x0
  802a0e:	6a 00                	push   $0x0
  802a10:	6a 00                	push   $0x0
  802a12:	6a 00                	push   $0x0
  802a14:	6a 2c                	push   $0x2c
  802a16:	e8 ac fa ff ff       	call   8024c7 <syscall>
  802a1b:	83 c4 18             	add    $0x18,%esp
  802a1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802a21:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802a25:	75 07                	jne    802a2e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802a27:	b8 01 00 00 00       	mov    $0x1,%eax
  802a2c:	eb 05                	jmp    802a33 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802a2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a33:	c9                   	leave  
  802a34:	c3                   	ret    

00802a35 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802a35:	55                   	push   %ebp
  802a36:	89 e5                	mov    %esp,%ebp
  802a38:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a3b:	6a 00                	push   $0x0
  802a3d:	6a 00                	push   $0x0
  802a3f:	6a 00                	push   $0x0
  802a41:	6a 00                	push   $0x0
  802a43:	6a 00                	push   $0x0
  802a45:	6a 2c                	push   $0x2c
  802a47:	e8 7b fa ff ff       	call   8024c7 <syscall>
  802a4c:	83 c4 18             	add    $0x18,%esp
  802a4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802a52:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802a56:	75 07                	jne    802a5f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802a58:	b8 01 00 00 00       	mov    $0x1,%eax
  802a5d:	eb 05                	jmp    802a64 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802a5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a64:	c9                   	leave  
  802a65:	c3                   	ret    

00802a66 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802a66:	55                   	push   %ebp
  802a67:	89 e5                	mov    %esp,%ebp
  802a69:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 00                	push   $0x0
  802a70:	6a 00                	push   $0x0
  802a72:	6a 00                	push   $0x0
  802a74:	6a 00                	push   $0x0
  802a76:	6a 2c                	push   $0x2c
  802a78:	e8 4a fa ff ff       	call   8024c7 <syscall>
  802a7d:	83 c4 18             	add    $0x18,%esp
  802a80:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802a83:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802a87:	75 07                	jne    802a90 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802a89:	b8 01 00 00 00       	mov    $0x1,%eax
  802a8e:	eb 05                	jmp    802a95 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802a90:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a95:	c9                   	leave  
  802a96:	c3                   	ret    

00802a97 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802a97:	55                   	push   %ebp
  802a98:	89 e5                	mov    %esp,%ebp
  802a9a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802a9d:	6a 00                	push   $0x0
  802a9f:	6a 00                	push   $0x0
  802aa1:	6a 00                	push   $0x0
  802aa3:	6a 00                	push   $0x0
  802aa5:	6a 00                	push   $0x0
  802aa7:	6a 2c                	push   $0x2c
  802aa9:	e8 19 fa ff ff       	call   8024c7 <syscall>
  802aae:	83 c4 18             	add    $0x18,%esp
  802ab1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802ab4:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802ab8:	75 07                	jne    802ac1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802aba:	b8 01 00 00 00       	mov    $0x1,%eax
  802abf:	eb 05                	jmp    802ac6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802ac1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ac6:	c9                   	leave  
  802ac7:	c3                   	ret    

00802ac8 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802ac8:	55                   	push   %ebp
  802ac9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802acb:	6a 00                	push   $0x0
  802acd:	6a 00                	push   $0x0
  802acf:	6a 00                	push   $0x0
  802ad1:	6a 00                	push   $0x0
  802ad3:	ff 75 08             	pushl  0x8(%ebp)
  802ad6:	6a 2d                	push   $0x2d
  802ad8:	e8 ea f9 ff ff       	call   8024c7 <syscall>
  802add:	83 c4 18             	add    $0x18,%esp
	return ;
  802ae0:	90                   	nop
}
  802ae1:	c9                   	leave  
  802ae2:	c3                   	ret    

00802ae3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802ae3:	55                   	push   %ebp
  802ae4:	89 e5                	mov    %esp,%ebp
  802ae6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802ae7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802aea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	6a 00                	push   $0x0
  802af5:	53                   	push   %ebx
  802af6:	51                   	push   %ecx
  802af7:	52                   	push   %edx
  802af8:	50                   	push   %eax
  802af9:	6a 2e                	push   $0x2e
  802afb:	e8 c7 f9 ff ff       	call   8024c7 <syscall>
  802b00:	83 c4 18             	add    $0x18,%esp
}
  802b03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b06:	c9                   	leave  
  802b07:	c3                   	ret    

00802b08 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802b08:	55                   	push   %ebp
  802b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	6a 00                	push   $0x0
  802b13:	6a 00                	push   $0x0
  802b15:	6a 00                	push   $0x0
  802b17:	52                   	push   %edx
  802b18:	50                   	push   %eax
  802b19:	6a 2f                	push   $0x2f
  802b1b:	e8 a7 f9 ff ff       	call   8024c7 <syscall>
  802b20:	83 c4 18             	add    $0x18,%esp
}
  802b23:	c9                   	leave  
  802b24:	c3                   	ret    

00802b25 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802b25:	55                   	push   %ebp
  802b26:	89 e5                	mov    %esp,%ebp
  802b28:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802b2b:	83 ec 0c             	sub    $0xc,%esp
  802b2e:	68 60 47 80 00       	push   $0x804760
  802b33:	e8 3e e6 ff ff       	call   801176 <cprintf>
  802b38:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802b3b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802b42:	83 ec 0c             	sub    $0xc,%esp
  802b45:	68 8c 47 80 00       	push   $0x80478c
  802b4a:	e8 27 e6 ff ff       	call   801176 <cprintf>
  802b4f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802b52:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802b56:	a1 38 51 80 00       	mov    0x805138,%eax
  802b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b5e:	eb 56                	jmp    802bb6 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802b60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b64:	74 1c                	je     802b82 <print_mem_block_lists+0x5d>
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 50 08             	mov    0x8(%eax),%edx
  802b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b6f:	8b 48 08             	mov    0x8(%eax),%ecx
  802b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b75:	8b 40 0c             	mov    0xc(%eax),%eax
  802b78:	01 c8                	add    %ecx,%eax
  802b7a:	39 c2                	cmp    %eax,%edx
  802b7c:	73 04                	jae    802b82 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802b7e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	8b 50 08             	mov    0x8(%eax),%edx
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b8e:	01 c2                	add    %eax,%edx
  802b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b93:	8b 40 08             	mov    0x8(%eax),%eax
  802b96:	83 ec 04             	sub    $0x4,%esp
  802b99:	52                   	push   %edx
  802b9a:	50                   	push   %eax
  802b9b:	68 a1 47 80 00       	push   $0x8047a1
  802ba0:	e8 d1 e5 ff ff       	call   801176 <cprintf>
  802ba5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bab:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802bae:	a1 40 51 80 00       	mov    0x805140,%eax
  802bb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bb6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bba:	74 07                	je     802bc3 <print_mem_block_lists+0x9e>
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 00                	mov    (%eax),%eax
  802bc1:	eb 05                	jmp    802bc8 <print_mem_block_lists+0xa3>
  802bc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc8:	a3 40 51 80 00       	mov    %eax,0x805140
  802bcd:	a1 40 51 80 00       	mov    0x805140,%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	75 8a                	jne    802b60 <print_mem_block_lists+0x3b>
  802bd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bda:	75 84                	jne    802b60 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802bdc:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802be0:	75 10                	jne    802bf2 <print_mem_block_lists+0xcd>
  802be2:	83 ec 0c             	sub    $0xc,%esp
  802be5:	68 b0 47 80 00       	push   $0x8047b0
  802bea:	e8 87 e5 ff ff       	call   801176 <cprintf>
  802bef:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802bf2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802bf9:	83 ec 0c             	sub    $0xc,%esp
  802bfc:	68 d4 47 80 00       	push   $0x8047d4
  802c01:	e8 70 e5 ff ff       	call   801176 <cprintf>
  802c06:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802c09:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c0d:	a1 40 50 80 00       	mov    0x805040,%eax
  802c12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c15:	eb 56                	jmp    802c6d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802c17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1b:	74 1c                	je     802c39 <print_mem_block_lists+0x114>
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 50 08             	mov    0x8(%eax),%edx
  802c23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c26:	8b 48 08             	mov    0x8(%eax),%ecx
  802c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2f:	01 c8                	add    %ecx,%eax
  802c31:	39 c2                	cmp    %eax,%edx
  802c33:	73 04                	jae    802c39 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802c35:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3c:	8b 50 08             	mov    0x8(%eax),%edx
  802c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c42:	8b 40 0c             	mov    0xc(%eax),%eax
  802c45:	01 c2                	add    %eax,%edx
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 40 08             	mov    0x8(%eax),%eax
  802c4d:	83 ec 04             	sub    $0x4,%esp
  802c50:	52                   	push   %edx
  802c51:	50                   	push   %eax
  802c52:	68 a1 47 80 00       	push   $0x8047a1
  802c57:	e8 1a e5 ff ff       	call   801176 <cprintf>
  802c5c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802c65:	a1 48 50 80 00       	mov    0x805048,%eax
  802c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c71:	74 07                	je     802c7a <print_mem_block_lists+0x155>
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	8b 00                	mov    (%eax),%eax
  802c78:	eb 05                	jmp    802c7f <print_mem_block_lists+0x15a>
  802c7a:	b8 00 00 00 00       	mov    $0x0,%eax
  802c7f:	a3 48 50 80 00       	mov    %eax,0x805048
  802c84:	a1 48 50 80 00       	mov    0x805048,%eax
  802c89:	85 c0                	test   %eax,%eax
  802c8b:	75 8a                	jne    802c17 <print_mem_block_lists+0xf2>
  802c8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c91:	75 84                	jne    802c17 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802c93:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802c97:	75 10                	jne    802ca9 <print_mem_block_lists+0x184>
  802c99:	83 ec 0c             	sub    $0xc,%esp
  802c9c:	68 ec 47 80 00       	push   $0x8047ec
  802ca1:	e8 d0 e4 ff ff       	call   801176 <cprintf>
  802ca6:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802ca9:	83 ec 0c             	sub    $0xc,%esp
  802cac:	68 60 47 80 00       	push   $0x804760
  802cb1:	e8 c0 e4 ff ff       	call   801176 <cprintf>
  802cb6:	83 c4 10             	add    $0x10,%esp

}
  802cb9:	90                   	nop
  802cba:	c9                   	leave  
  802cbb:	c3                   	ret    

00802cbc <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802cbc:	55                   	push   %ebp
  802cbd:	89 e5                	mov    %esp,%ebp
  802cbf:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802cc2:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802cc9:	00 00 00 
  802ccc:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  802cd3:	00 00 00 
  802cd6:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802cdd:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802ce0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802ce7:	e9 9e 00 00 00       	jmp    802d8a <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802cec:	a1 50 50 80 00       	mov    0x805050,%eax
  802cf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf4:	c1 e2 04             	shl    $0x4,%edx
  802cf7:	01 d0                	add    %edx,%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	75 14                	jne    802d11 <initialize_MemBlocksList+0x55>
  802cfd:	83 ec 04             	sub    $0x4,%esp
  802d00:	68 14 48 80 00       	push   $0x804814
  802d05:	6a 3d                	push   $0x3d
  802d07:	68 37 48 80 00       	push   $0x804837
  802d0c:	e8 b1 e1 ff ff       	call   800ec2 <_panic>
  802d11:	a1 50 50 80 00       	mov    0x805050,%eax
  802d16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d19:	c1 e2 04             	shl    $0x4,%edx
  802d1c:	01 d0                	add    %edx,%eax
  802d1e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802d24:	89 10                	mov    %edx,(%eax)
  802d26:	8b 00                	mov    (%eax),%eax
  802d28:	85 c0                	test   %eax,%eax
  802d2a:	74 18                	je     802d44 <initialize_MemBlocksList+0x88>
  802d2c:	a1 48 51 80 00       	mov    0x805148,%eax
  802d31:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802d37:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802d3a:	c1 e1 04             	shl    $0x4,%ecx
  802d3d:	01 ca                	add    %ecx,%edx
  802d3f:	89 50 04             	mov    %edx,0x4(%eax)
  802d42:	eb 12                	jmp    802d56 <initialize_MemBlocksList+0x9a>
  802d44:	a1 50 50 80 00       	mov    0x805050,%eax
  802d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d4c:	c1 e2 04             	shl    $0x4,%edx
  802d4f:	01 d0                	add    %edx,%eax
  802d51:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d56:	a1 50 50 80 00       	mov    0x805050,%eax
  802d5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d5e:	c1 e2 04             	shl    $0x4,%edx
  802d61:	01 d0                	add    %edx,%eax
  802d63:	a3 48 51 80 00       	mov    %eax,0x805148
  802d68:	a1 50 50 80 00       	mov    0x805050,%eax
  802d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d70:	c1 e2 04             	shl    $0x4,%edx
  802d73:	01 d0                	add    %edx,%eax
  802d75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7c:	a1 54 51 80 00       	mov    0x805154,%eax
  802d81:	40                   	inc    %eax
  802d82:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802d87:	ff 45 f4             	incl   -0xc(%ebp)
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d90:	0f 82 56 ff ff ff    	jb     802cec <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802d96:	90                   	nop
  802d97:	c9                   	leave  
  802d98:	c3                   	ret    

00802d99 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802d99:	55                   	push   %ebp
  802d9a:	89 e5                	mov    %esp,%ebp
  802d9c:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	8b 00                	mov    (%eax),%eax
  802da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802da7:	eb 18                	jmp    802dc1 <find_block+0x28>

		if(tmp->sva == va){
  802da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dac:	8b 40 08             	mov    0x8(%eax),%eax
  802daf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802db2:	75 05                	jne    802db9 <find_block+0x20>
			return tmp ;
  802db4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802db7:	eb 11                	jmp    802dca <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802db9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802dbc:	8b 00                	mov    (%eax),%eax
  802dbe:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802dc1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802dc5:	75 e2                	jne    802da9 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802dca:	c9                   	leave  
  802dcb:	c3                   	ret    

00802dcc <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802dcc:	55                   	push   %ebp
  802dcd:	89 e5                	mov    %esp,%ebp
  802dcf:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802dd2:	a1 40 50 80 00       	mov    0x805040,%eax
  802dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802dda:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ddf:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802de2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802de6:	75 65                	jne    802e4d <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802de8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dec:	75 14                	jne    802e02 <insert_sorted_allocList+0x36>
  802dee:	83 ec 04             	sub    $0x4,%esp
  802df1:	68 14 48 80 00       	push   $0x804814
  802df6:	6a 62                	push   $0x62
  802df8:	68 37 48 80 00       	push   $0x804837
  802dfd:	e8 c0 e0 ff ff       	call   800ec2 <_panic>
  802e02:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	89 10                	mov    %edx,(%eax)
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	85 c0                	test   %eax,%eax
  802e14:	74 0d                	je     802e23 <insert_sorted_allocList+0x57>
  802e16:	a1 40 50 80 00       	mov    0x805040,%eax
  802e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1e:	89 50 04             	mov    %edx,0x4(%eax)
  802e21:	eb 08                	jmp    802e2b <insert_sorted_allocList+0x5f>
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	a3 44 50 80 00       	mov    %eax,0x805044
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	a3 40 50 80 00       	mov    %eax,0x805040
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802e42:	40                   	inc    %eax
  802e43:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802e48:	e9 14 01 00 00       	jmp    802f61 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	8b 50 08             	mov    0x8(%eax),%edx
  802e53:	a1 44 50 80 00       	mov    0x805044,%eax
  802e58:	8b 40 08             	mov    0x8(%eax),%eax
  802e5b:	39 c2                	cmp    %eax,%edx
  802e5d:	76 65                	jbe    802ec4 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802e5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e63:	75 14                	jne    802e79 <insert_sorted_allocList+0xad>
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	68 50 48 80 00       	push   $0x804850
  802e6d:	6a 64                	push   $0x64
  802e6f:	68 37 48 80 00       	push   $0x804837
  802e74:	e8 49 e0 ff ff       	call   800ec2 <_panic>
  802e79:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	89 50 04             	mov    %edx,0x4(%eax)
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	8b 40 04             	mov    0x4(%eax),%eax
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 0c                	je     802e9b <insert_sorted_allocList+0xcf>
  802e8f:	a1 44 50 80 00       	mov    0x805044,%eax
  802e94:	8b 55 08             	mov    0x8(%ebp),%edx
  802e97:	89 10                	mov    %edx,(%eax)
  802e99:	eb 08                	jmp    802ea3 <insert_sorted_allocList+0xd7>
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	a3 40 50 80 00       	mov    %eax,0x805040
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	a3 44 50 80 00       	mov    %eax,0x805044
  802eab:	8b 45 08             	mov    0x8(%ebp),%eax
  802eae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802eb9:	40                   	inc    %eax
  802eba:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802ebf:	e9 9d 00 00 00       	jmp    802f61 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802ec4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802ecb:	e9 85 00 00 00       	jmp    802f55 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	8b 50 08             	mov    0x8(%eax),%edx
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	8b 40 08             	mov    0x8(%eax),%eax
  802edc:	39 c2                	cmp    %eax,%edx
  802ede:	73 6a                	jae    802f4a <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802ee0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee4:	74 06                	je     802eec <insert_sorted_allocList+0x120>
  802ee6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eea:	75 14                	jne    802f00 <insert_sorted_allocList+0x134>
  802eec:	83 ec 04             	sub    $0x4,%esp
  802eef:	68 74 48 80 00       	push   $0x804874
  802ef4:	6a 6b                	push   $0x6b
  802ef6:	68 37 48 80 00       	push   $0x804837
  802efb:	e8 c2 df ff ff       	call   800ec2 <_panic>
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 50 04             	mov    0x4(%eax),%edx
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	89 50 04             	mov    %edx,0x4(%eax)
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f12:	89 10                	mov    %edx,(%eax)
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 40 04             	mov    0x4(%eax),%eax
  802f1a:	85 c0                	test   %eax,%eax
  802f1c:	74 0d                	je     802f2b <insert_sorted_allocList+0x15f>
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 40 04             	mov    0x4(%eax),%eax
  802f24:	8b 55 08             	mov    0x8(%ebp),%edx
  802f27:	89 10                	mov    %edx,(%eax)
  802f29:	eb 08                	jmp    802f33 <insert_sorted_allocList+0x167>
  802f2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2e:	a3 40 50 80 00       	mov    %eax,0x805040
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 55 08             	mov    0x8(%ebp),%edx
  802f39:	89 50 04             	mov    %edx,0x4(%eax)
  802f3c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802f41:	40                   	inc    %eax
  802f42:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802f47:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802f48:	eb 17                	jmp    802f61 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	8b 00                	mov    (%eax),%eax
  802f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802f52:	ff 45 f0             	incl   -0x10(%ebp)
  802f55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f58:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802f5b:	0f 8c 6f ff ff ff    	jl     802ed0 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802f61:	90                   	nop
  802f62:	c9                   	leave  
  802f63:	c3                   	ret    

00802f64 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802f64:	55                   	push   %ebp
  802f65:	89 e5                	mov    %esp,%ebp
  802f67:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802f6a:	a1 38 51 80 00       	mov    0x805138,%eax
  802f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802f72:	e9 7c 01 00 00       	jmp    8030f3 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f80:	0f 86 cf 00 00 00    	jbe    803055 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802f86:	a1 48 51 80 00       	mov    0x805148,%eax
  802f8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f91:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802f94:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f97:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9a:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa0:	8b 50 08             	mov    0x8(%eax),%edx
  802fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa6:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 40 0c             	mov    0xc(%eax),%eax
  802faf:	2b 45 08             	sub    0x8(%ebp),%eax
  802fb2:	89 c2                	mov    %eax,%edx
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 50 08             	mov    0x8(%eax),%edx
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	01 c2                	add    %eax,%edx
  802fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc8:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802fcb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fcf:	75 17                	jne    802fe8 <alloc_block_FF+0x84>
  802fd1:	83 ec 04             	sub    $0x4,%esp
  802fd4:	68 a9 48 80 00       	push   $0x8048a9
  802fd9:	68 83 00 00 00       	push   $0x83
  802fde:	68 37 48 80 00       	push   $0x804837
  802fe3:	e8 da de ff ff       	call   800ec2 <_panic>
  802fe8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	85 c0                	test   %eax,%eax
  802fef:	74 10                	je     803001 <alloc_block_FF+0x9d>
  802ff1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ff4:	8b 00                	mov    (%eax),%eax
  802ff6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ff9:	8b 52 04             	mov    0x4(%edx),%edx
  802ffc:	89 50 04             	mov    %edx,0x4(%eax)
  802fff:	eb 0b                	jmp    80300c <alloc_block_FF+0xa8>
  803001:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803004:	8b 40 04             	mov    0x4(%eax),%eax
  803007:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80300c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80300f:	8b 40 04             	mov    0x4(%eax),%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	74 0f                	je     803025 <alloc_block_FF+0xc1>
  803016:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803019:	8b 40 04             	mov    0x4(%eax),%eax
  80301c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80301f:	8b 12                	mov    (%edx),%edx
  803021:	89 10                	mov    %edx,(%eax)
  803023:	eb 0a                	jmp    80302f <alloc_block_FF+0xcb>
  803025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803028:	8b 00                	mov    (%eax),%eax
  80302a:	a3 48 51 80 00       	mov    %eax,0x805148
  80302f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803032:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803038:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80303b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803042:	a1 54 51 80 00       	mov    0x805154,%eax
  803047:	48                   	dec    %eax
  803048:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  80304d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803050:	e9 ad 00 00 00       	jmp    803102 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  803055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803058:	8b 40 0c             	mov    0xc(%eax),%eax
  80305b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80305e:	0f 85 87 00 00 00    	jne    8030eb <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  803064:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803068:	75 17                	jne    803081 <alloc_block_FF+0x11d>
  80306a:	83 ec 04             	sub    $0x4,%esp
  80306d:	68 a9 48 80 00       	push   $0x8048a9
  803072:	68 87 00 00 00       	push   $0x87
  803077:	68 37 48 80 00       	push   $0x804837
  80307c:	e8 41 de ff ff       	call   800ec2 <_panic>
  803081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803084:	8b 00                	mov    (%eax),%eax
  803086:	85 c0                	test   %eax,%eax
  803088:	74 10                	je     80309a <alloc_block_FF+0x136>
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803092:	8b 52 04             	mov    0x4(%edx),%edx
  803095:	89 50 04             	mov    %edx,0x4(%eax)
  803098:	eb 0b                	jmp    8030a5 <alloc_block_FF+0x141>
  80309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309d:	8b 40 04             	mov    0x4(%eax),%eax
  8030a0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a8:	8b 40 04             	mov    0x4(%eax),%eax
  8030ab:	85 c0                	test   %eax,%eax
  8030ad:	74 0f                	je     8030be <alloc_block_FF+0x15a>
  8030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b2:	8b 40 04             	mov    0x4(%eax),%eax
  8030b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030b8:	8b 12                	mov    (%edx),%edx
  8030ba:	89 10                	mov    %edx,(%eax)
  8030bc:	eb 0a                	jmp    8030c8 <alloc_block_FF+0x164>
  8030be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	a3 38 51 80 00       	mov    %eax,0x805138
  8030c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030db:	a1 44 51 80 00       	mov    0x805144,%eax
  8030e0:	48                   	dec    %eax
  8030e1:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  8030e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e9:	eb 17                	jmp    803102 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8030eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ee:	8b 00                	mov    (%eax),%eax
  8030f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8030f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f7:	0f 85 7a fe ff ff    	jne    802f77 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8030fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803102:	c9                   	leave  
  803103:	c3                   	ret    

00803104 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  803104:	55                   	push   %ebp
  803105:	89 e5                	mov    %esp,%ebp
  803107:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  80310a:	a1 38 51 80 00       	mov    0x805138,%eax
  80310f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  803112:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  803119:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  803120:	a1 38 51 80 00       	mov    0x805138,%eax
  803125:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803128:	e9 d0 00 00 00       	jmp    8031fd <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	8b 40 0c             	mov    0xc(%eax),%eax
  803133:	3b 45 08             	cmp    0x8(%ebp),%eax
  803136:	0f 82 b8 00 00 00    	jb     8031f4 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313f:	8b 40 0c             	mov    0xc(%eax),%eax
  803142:	2b 45 08             	sub    0x8(%ebp),%eax
  803145:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  803148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80314e:	0f 83 a1 00 00 00    	jae    8031f5 <alloc_block_BF+0xf1>
				differsize = differance ;
  803154:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803157:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80315a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  803160:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803164:	0f 85 8b 00 00 00    	jne    8031f5 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80316a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80316e:	75 17                	jne    803187 <alloc_block_BF+0x83>
  803170:	83 ec 04             	sub    $0x4,%esp
  803173:	68 a9 48 80 00       	push   $0x8048a9
  803178:	68 a0 00 00 00       	push   $0xa0
  80317d:	68 37 48 80 00       	push   $0x804837
  803182:	e8 3b dd ff ff       	call   800ec2 <_panic>
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	85 c0                	test   %eax,%eax
  80318e:	74 10                	je     8031a0 <alloc_block_BF+0x9c>
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 00                	mov    (%eax),%eax
  803195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803198:	8b 52 04             	mov    0x4(%edx),%edx
  80319b:	89 50 04             	mov    %edx,0x4(%eax)
  80319e:	eb 0b                	jmp    8031ab <alloc_block_BF+0xa7>
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	8b 40 04             	mov    0x4(%eax),%eax
  8031a6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ae:	8b 40 04             	mov    0x4(%eax),%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	74 0f                	je     8031c4 <alloc_block_BF+0xc0>
  8031b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b8:	8b 40 04             	mov    0x4(%eax),%eax
  8031bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8031be:	8b 12                	mov    (%edx),%edx
  8031c0:	89 10                	mov    %edx,(%eax)
  8031c2:	eb 0a                	jmp    8031ce <alloc_block_BF+0xca>
  8031c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c7:	8b 00                	mov    (%eax),%eax
  8031c9:	a3 38 51 80 00       	mov    %eax,0x805138
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e1:	a1 44 51 80 00       	mov    0x805144,%eax
  8031e6:	48                   	dec    %eax
  8031e7:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  8031ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ef:	e9 0c 01 00 00       	jmp    803300 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8031f4:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8031f5:	a1 40 51 80 00       	mov    0x805140,%eax
  8031fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803201:	74 07                	je     80320a <alloc_block_BF+0x106>
  803203:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803206:	8b 00                	mov    (%eax),%eax
  803208:	eb 05                	jmp    80320f <alloc_block_BF+0x10b>
  80320a:	b8 00 00 00 00       	mov    $0x0,%eax
  80320f:	a3 40 51 80 00       	mov    %eax,0x805140
  803214:	a1 40 51 80 00       	mov    0x805140,%eax
  803219:	85 c0                	test   %eax,%eax
  80321b:	0f 85 0c ff ff ff    	jne    80312d <alloc_block_BF+0x29>
  803221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803225:	0f 85 02 ff ff ff    	jne    80312d <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80322b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80322f:	0f 84 c6 00 00 00    	je     8032fb <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  803235:	a1 48 51 80 00       	mov    0x805148,%eax
  80323a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80323d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803240:	8b 55 08             	mov    0x8(%ebp),%edx
  803243:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  803246:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803249:	8b 50 08             	mov    0x8(%eax),%edx
  80324c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80324f:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  803252:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803255:	8b 40 0c             	mov    0xc(%eax),%eax
  803258:	2b 45 08             	sub    0x8(%ebp),%eax
  80325b:	89 c2                	mov    %eax,%edx
  80325d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803260:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  803263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803266:	8b 50 08             	mov    0x8(%eax),%edx
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	01 c2                	add    %eax,%edx
  80326e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803271:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  803274:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803278:	75 17                	jne    803291 <alloc_block_BF+0x18d>
  80327a:	83 ec 04             	sub    $0x4,%esp
  80327d:	68 a9 48 80 00       	push   $0x8048a9
  803282:	68 af 00 00 00       	push   $0xaf
  803287:	68 37 48 80 00       	push   $0x804837
  80328c:	e8 31 dc ff ff       	call   800ec2 <_panic>
  803291:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803294:	8b 00                	mov    (%eax),%eax
  803296:	85 c0                	test   %eax,%eax
  803298:	74 10                	je     8032aa <alloc_block_BF+0x1a6>
  80329a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80329d:	8b 00                	mov    (%eax),%eax
  80329f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032a2:	8b 52 04             	mov    0x4(%edx),%edx
  8032a5:	89 50 04             	mov    %edx,0x4(%eax)
  8032a8:	eb 0b                	jmp    8032b5 <alloc_block_BF+0x1b1>
  8032aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032ad:	8b 40 04             	mov    0x4(%eax),%eax
  8032b0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032b8:	8b 40 04             	mov    0x4(%eax),%eax
  8032bb:	85 c0                	test   %eax,%eax
  8032bd:	74 0f                	je     8032ce <alloc_block_BF+0x1ca>
  8032bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032c2:	8b 40 04             	mov    0x4(%eax),%eax
  8032c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8032c8:	8b 12                	mov    (%edx),%edx
  8032ca:	89 10                	mov    %edx,(%eax)
  8032cc:	eb 0a                	jmp    8032d8 <alloc_block_BF+0x1d4>
  8032ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032d1:	8b 00                	mov    (%eax),%eax
  8032d3:	a3 48 51 80 00       	mov    %eax,0x805148
  8032d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032eb:	a1 54 51 80 00       	mov    0x805154,%eax
  8032f0:	48                   	dec    %eax
  8032f1:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  8032f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8032f9:	eb 05                	jmp    803300 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8032fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803300:	c9                   	leave  
  803301:	c3                   	ret    

00803302 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  803302:	55                   	push   %ebp
  803303:	89 e5                	mov    %esp,%ebp
  803305:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  803308:	a1 38 51 80 00       	mov    0x805138,%eax
  80330d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  803310:	e9 7c 01 00 00       	jmp    803491 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  803315:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803318:	8b 40 0c             	mov    0xc(%eax),%eax
  80331b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80331e:	0f 86 cf 00 00 00    	jbe    8033f3 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  803324:	a1 48 51 80 00       	mov    0x805148,%eax
  803329:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  80332c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80332f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  803332:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803335:	8b 55 08             	mov    0x8(%ebp),%edx
  803338:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80333b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333e:	8b 50 08             	mov    0x8(%eax),%edx
  803341:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803344:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  803347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80334a:	8b 40 0c             	mov    0xc(%eax),%eax
  80334d:	2b 45 08             	sub    0x8(%ebp),%eax
  803350:	89 c2                	mov    %eax,%edx
  803352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803355:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335b:	8b 50 08             	mov    0x8(%eax),%edx
  80335e:	8b 45 08             	mov    0x8(%ebp),%eax
  803361:	01 c2                	add    %eax,%edx
  803363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803366:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  803369:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80336d:	75 17                	jne    803386 <alloc_block_NF+0x84>
  80336f:	83 ec 04             	sub    $0x4,%esp
  803372:	68 a9 48 80 00       	push   $0x8048a9
  803377:	68 c4 00 00 00       	push   $0xc4
  80337c:	68 37 48 80 00       	push   $0x804837
  803381:	e8 3c db ff ff       	call   800ec2 <_panic>
  803386:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803389:	8b 00                	mov    (%eax),%eax
  80338b:	85 c0                	test   %eax,%eax
  80338d:	74 10                	je     80339f <alloc_block_NF+0x9d>
  80338f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803392:	8b 00                	mov    (%eax),%eax
  803394:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803397:	8b 52 04             	mov    0x4(%edx),%edx
  80339a:	89 50 04             	mov    %edx,0x4(%eax)
  80339d:	eb 0b                	jmp    8033aa <alloc_block_NF+0xa8>
  80339f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033a2:	8b 40 04             	mov    0x4(%eax),%eax
  8033a5:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ad:	8b 40 04             	mov    0x4(%eax),%eax
  8033b0:	85 c0                	test   %eax,%eax
  8033b2:	74 0f                	je     8033c3 <alloc_block_NF+0xc1>
  8033b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033b7:	8b 40 04             	mov    0x4(%eax),%eax
  8033ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8033bd:	8b 12                	mov    (%edx),%edx
  8033bf:	89 10                	mov    %edx,(%eax)
  8033c1:	eb 0a                	jmp    8033cd <alloc_block_NF+0xcb>
  8033c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033c6:	8b 00                	mov    (%eax),%eax
  8033c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8033cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033e0:	a1 54 51 80 00       	mov    0x805154,%eax
  8033e5:	48                   	dec    %eax
  8033e6:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  8033eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033ee:	e9 ad 00 00 00       	jmp    8034a0 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8033f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8033f9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033fc:	0f 85 87 00 00 00    	jne    803489 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  803402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803406:	75 17                	jne    80341f <alloc_block_NF+0x11d>
  803408:	83 ec 04             	sub    $0x4,%esp
  80340b:	68 a9 48 80 00       	push   $0x8048a9
  803410:	68 c8 00 00 00       	push   $0xc8
  803415:	68 37 48 80 00       	push   $0x804837
  80341a:	e8 a3 da ff ff       	call   800ec2 <_panic>
  80341f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803422:	8b 00                	mov    (%eax),%eax
  803424:	85 c0                	test   %eax,%eax
  803426:	74 10                	je     803438 <alloc_block_NF+0x136>
  803428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803430:	8b 52 04             	mov    0x4(%edx),%edx
  803433:	89 50 04             	mov    %edx,0x4(%eax)
  803436:	eb 0b                	jmp    803443 <alloc_block_NF+0x141>
  803438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343b:	8b 40 04             	mov    0x4(%eax),%eax
  80343e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803446:	8b 40 04             	mov    0x4(%eax),%eax
  803449:	85 c0                	test   %eax,%eax
  80344b:	74 0f                	je     80345c <alloc_block_NF+0x15a>
  80344d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803450:	8b 40 04             	mov    0x4(%eax),%eax
  803453:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803456:	8b 12                	mov    (%edx),%edx
  803458:	89 10                	mov    %edx,(%eax)
  80345a:	eb 0a                	jmp    803466 <alloc_block_NF+0x164>
  80345c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345f:	8b 00                	mov    (%eax),%eax
  803461:	a3 38 51 80 00       	mov    %eax,0x805138
  803466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803469:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80346f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803472:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803479:	a1 44 51 80 00       	mov    0x805144,%eax
  80347e:	48                   	dec    %eax
  80347f:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  803484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803487:	eb 17                	jmp    8034a0 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  803489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  803491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803495:	0f 85 7a fe ff ff    	jne    803315 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80349b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8034a0:	c9                   	leave  
  8034a1:	c3                   	ret    

008034a2 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8034a2:	55                   	push   %ebp
  8034a3:	89 e5                	mov    %esp,%ebp
  8034a5:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8034a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8034ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8034b0:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8034b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8034b8:	a1 44 51 80 00       	mov    0x805144,%eax
  8034bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8034c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034c4:	75 68                	jne    80352e <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8034c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034ca:	75 17                	jne    8034e3 <insert_sorted_with_merge_freeList+0x41>
  8034cc:	83 ec 04             	sub    $0x4,%esp
  8034cf:	68 14 48 80 00       	push   $0x804814
  8034d4:	68 da 00 00 00       	push   $0xda
  8034d9:	68 37 48 80 00       	push   $0x804837
  8034de:	e8 df d9 ff ff       	call   800ec2 <_panic>
  8034e3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ec:	89 10                	mov    %edx,(%eax)
  8034ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f1:	8b 00                	mov    (%eax),%eax
  8034f3:	85 c0                	test   %eax,%eax
  8034f5:	74 0d                	je     803504 <insert_sorted_with_merge_freeList+0x62>
  8034f7:	a1 38 51 80 00       	mov    0x805138,%eax
  8034fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8034ff:	89 50 04             	mov    %edx,0x4(%eax)
  803502:	eb 08                	jmp    80350c <insert_sorted_with_merge_freeList+0x6a>
  803504:	8b 45 08             	mov    0x8(%ebp),%eax
  803507:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80350c:	8b 45 08             	mov    0x8(%ebp),%eax
  80350f:	a3 38 51 80 00       	mov    %eax,0x805138
  803514:	8b 45 08             	mov    0x8(%ebp),%eax
  803517:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80351e:	a1 44 51 80 00       	mov    0x805144,%eax
  803523:	40                   	inc    %eax
  803524:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  803529:	e9 49 07 00 00       	jmp    803c77 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  80352e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803531:	8b 50 08             	mov    0x8(%eax),%edx
  803534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803537:	8b 40 0c             	mov    0xc(%eax),%eax
  80353a:	01 c2                	add    %eax,%edx
  80353c:	8b 45 08             	mov    0x8(%ebp),%eax
  80353f:	8b 40 08             	mov    0x8(%eax),%eax
  803542:	39 c2                	cmp    %eax,%edx
  803544:	73 77                	jae    8035bd <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  803546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803549:	8b 00                	mov    (%eax),%eax
  80354b:	85 c0                	test   %eax,%eax
  80354d:	75 6e                	jne    8035bd <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  80354f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803553:	74 68                	je     8035bd <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  803555:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803559:	75 17                	jne    803572 <insert_sorted_with_merge_freeList+0xd0>
  80355b:	83 ec 04             	sub    $0x4,%esp
  80355e:	68 50 48 80 00       	push   $0x804850
  803563:	68 e0 00 00 00       	push   $0xe0
  803568:	68 37 48 80 00       	push   $0x804837
  80356d:	e8 50 d9 ff ff       	call   800ec2 <_panic>
  803572:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	89 50 04             	mov    %edx,0x4(%eax)
  80357e:	8b 45 08             	mov    0x8(%ebp),%eax
  803581:	8b 40 04             	mov    0x4(%eax),%eax
  803584:	85 c0                	test   %eax,%eax
  803586:	74 0c                	je     803594 <insert_sorted_with_merge_freeList+0xf2>
  803588:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80358d:	8b 55 08             	mov    0x8(%ebp),%edx
  803590:	89 10                	mov    %edx,(%eax)
  803592:	eb 08                	jmp    80359c <insert_sorted_with_merge_freeList+0xfa>
  803594:	8b 45 08             	mov    0x8(%ebp),%eax
  803597:	a3 38 51 80 00       	mov    %eax,0x805138
  80359c:	8b 45 08             	mov    0x8(%ebp),%eax
  80359f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8035a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8035ad:	a1 44 51 80 00       	mov    0x805144,%eax
  8035b2:	40                   	inc    %eax
  8035b3:	a3 44 51 80 00       	mov    %eax,0x805144
  8035b8:	e9 ba 06 00 00       	jmp    803c77 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8035bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c0:	8b 50 0c             	mov    0xc(%eax),%edx
  8035c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c6:	8b 40 08             	mov    0x8(%eax),%eax
  8035c9:	01 c2                	add    %eax,%edx
  8035cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ce:	8b 40 08             	mov    0x8(%eax),%eax
  8035d1:	39 c2                	cmp    %eax,%edx
  8035d3:	73 78                	jae    80364d <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d8:	8b 40 04             	mov    0x4(%eax),%eax
  8035db:	85 c0                	test   %eax,%eax
  8035dd:	75 6e                	jne    80364d <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8035df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8035e3:	74 68                	je     80364d <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8035e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035e9:	75 17                	jne    803602 <insert_sorted_with_merge_freeList+0x160>
  8035eb:	83 ec 04             	sub    $0x4,%esp
  8035ee:	68 14 48 80 00       	push   $0x804814
  8035f3:	68 e6 00 00 00       	push   $0xe6
  8035f8:	68 37 48 80 00       	push   $0x804837
  8035fd:	e8 c0 d8 ff ff       	call   800ec2 <_panic>
  803602:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803608:	8b 45 08             	mov    0x8(%ebp),%eax
  80360b:	89 10                	mov    %edx,(%eax)
  80360d:	8b 45 08             	mov    0x8(%ebp),%eax
  803610:	8b 00                	mov    (%eax),%eax
  803612:	85 c0                	test   %eax,%eax
  803614:	74 0d                	je     803623 <insert_sorted_with_merge_freeList+0x181>
  803616:	a1 38 51 80 00       	mov    0x805138,%eax
  80361b:	8b 55 08             	mov    0x8(%ebp),%edx
  80361e:	89 50 04             	mov    %edx,0x4(%eax)
  803621:	eb 08                	jmp    80362b <insert_sorted_with_merge_freeList+0x189>
  803623:	8b 45 08             	mov    0x8(%ebp),%eax
  803626:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80362b:	8b 45 08             	mov    0x8(%ebp),%eax
  80362e:	a3 38 51 80 00       	mov    %eax,0x805138
  803633:	8b 45 08             	mov    0x8(%ebp),%eax
  803636:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80363d:	a1 44 51 80 00       	mov    0x805144,%eax
  803642:	40                   	inc    %eax
  803643:	a3 44 51 80 00       	mov    %eax,0x805144
  803648:	e9 2a 06 00 00       	jmp    803c77 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80364d:	a1 38 51 80 00       	mov    0x805138,%eax
  803652:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803655:	e9 ed 05 00 00       	jmp    803c47 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80365a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80365d:	8b 00                	mov    (%eax),%eax
  80365f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803662:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803666:	0f 84 a7 00 00 00    	je     803713 <insert_sorted_with_merge_freeList+0x271>
  80366c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366f:	8b 50 0c             	mov    0xc(%eax),%edx
  803672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803675:	8b 40 08             	mov    0x8(%eax),%eax
  803678:	01 c2                	add    %eax,%edx
  80367a:	8b 45 08             	mov    0x8(%ebp),%eax
  80367d:	8b 40 08             	mov    0x8(%eax),%eax
  803680:	39 c2                	cmp    %eax,%edx
  803682:	0f 83 8b 00 00 00    	jae    803713 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  803688:	8b 45 08             	mov    0x8(%ebp),%eax
  80368b:	8b 50 0c             	mov    0xc(%eax),%edx
  80368e:	8b 45 08             	mov    0x8(%ebp),%eax
  803691:	8b 40 08             	mov    0x8(%eax),%eax
  803694:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  803696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803699:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  80369c:	39 c2                	cmp    %eax,%edx
  80369e:	73 73                	jae    803713 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  8036a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036a4:	74 06                	je     8036ac <insert_sorted_with_merge_freeList+0x20a>
  8036a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036aa:	75 17                	jne    8036c3 <insert_sorted_with_merge_freeList+0x221>
  8036ac:	83 ec 04             	sub    $0x4,%esp
  8036af:	68 c8 48 80 00       	push   $0x8048c8
  8036b4:	68 f0 00 00 00       	push   $0xf0
  8036b9:	68 37 48 80 00       	push   $0x804837
  8036be:	e8 ff d7 ff ff       	call   800ec2 <_panic>
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	8b 10                	mov    (%eax),%edx
  8036c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cb:	89 10                	mov    %edx,(%eax)
  8036cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d0:	8b 00                	mov    (%eax),%eax
  8036d2:	85 c0                	test   %eax,%eax
  8036d4:	74 0b                	je     8036e1 <insert_sorted_with_merge_freeList+0x23f>
  8036d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036d9:	8b 00                	mov    (%eax),%eax
  8036db:	8b 55 08             	mov    0x8(%ebp),%edx
  8036de:	89 50 04             	mov    %edx,0x4(%eax)
  8036e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8036e7:	89 10                	mov    %edx,(%eax)
  8036e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ef:	89 50 04             	mov    %edx,0x4(%eax)
  8036f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f5:	8b 00                	mov    (%eax),%eax
  8036f7:	85 c0                	test   %eax,%eax
  8036f9:	75 08                	jne    803703 <insert_sorted_with_merge_freeList+0x261>
  8036fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036fe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803703:	a1 44 51 80 00       	mov    0x805144,%eax
  803708:	40                   	inc    %eax
  803709:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  80370e:	e9 64 05 00 00       	jmp    803c77 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803713:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803718:	8b 50 0c             	mov    0xc(%eax),%edx
  80371b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803720:	8b 40 08             	mov    0x8(%eax),%eax
  803723:	01 c2                	add    %eax,%edx
  803725:	8b 45 08             	mov    0x8(%ebp),%eax
  803728:	8b 40 08             	mov    0x8(%eax),%eax
  80372b:	39 c2                	cmp    %eax,%edx
  80372d:	0f 85 b1 00 00 00    	jne    8037e4 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803733:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803738:	85 c0                	test   %eax,%eax
  80373a:	0f 84 a4 00 00 00    	je     8037e4 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803740:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803745:	8b 00                	mov    (%eax),%eax
  803747:	85 c0                	test   %eax,%eax
  803749:	0f 85 95 00 00 00    	jne    8037e4 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  80374f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803754:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80375a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80375d:	8b 55 08             	mov    0x8(%ebp),%edx
  803760:	8b 52 0c             	mov    0xc(%edx),%edx
  803763:	01 ca                	add    %ecx,%edx
  803765:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803768:	8b 45 08             	mov    0x8(%ebp),%eax
  80376b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803772:	8b 45 08             	mov    0x8(%ebp),%eax
  803775:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80377c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803780:	75 17                	jne    803799 <insert_sorted_with_merge_freeList+0x2f7>
  803782:	83 ec 04             	sub    $0x4,%esp
  803785:	68 14 48 80 00       	push   $0x804814
  80378a:	68 ff 00 00 00       	push   $0xff
  80378f:	68 37 48 80 00       	push   $0x804837
  803794:	e8 29 d7 ff ff       	call   800ec2 <_panic>
  803799:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80379f:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a2:	89 10                	mov    %edx,(%eax)
  8037a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8037a7:	8b 00                	mov    (%eax),%eax
  8037a9:	85 c0                	test   %eax,%eax
  8037ab:	74 0d                	je     8037ba <insert_sorted_with_merge_freeList+0x318>
  8037ad:	a1 48 51 80 00       	mov    0x805148,%eax
  8037b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8037b5:	89 50 04             	mov    %edx,0x4(%eax)
  8037b8:	eb 08                	jmp    8037c2 <insert_sorted_with_merge_freeList+0x320>
  8037ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8037bd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8037c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037c5:	a3 48 51 80 00       	mov    %eax,0x805148
  8037ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8037cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037d4:	a1 54 51 80 00       	mov    0x805154,%eax
  8037d9:	40                   	inc    %eax
  8037da:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8037df:	e9 93 04 00 00       	jmp    803c77 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8037e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037e7:	8b 50 08             	mov    0x8(%eax),%edx
  8037ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8037f0:	01 c2                	add    %eax,%edx
  8037f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8037f5:	8b 40 08             	mov    0x8(%eax),%eax
  8037f8:	39 c2                	cmp    %eax,%edx
  8037fa:	0f 85 ae 00 00 00    	jne    8038ae <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803800:	8b 45 08             	mov    0x8(%ebp),%eax
  803803:	8b 50 0c             	mov    0xc(%eax),%edx
  803806:	8b 45 08             	mov    0x8(%ebp),%eax
  803809:	8b 40 08             	mov    0x8(%eax),%eax
  80380c:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  80380e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803811:	8b 00                	mov    (%eax),%eax
  803813:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803816:	39 c2                	cmp    %eax,%edx
  803818:	0f 84 90 00 00 00    	je     8038ae <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  80381e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803821:	8b 50 0c             	mov    0xc(%eax),%edx
  803824:	8b 45 08             	mov    0x8(%ebp),%eax
  803827:	8b 40 0c             	mov    0xc(%eax),%eax
  80382a:	01 c2                	add    %eax,%edx
  80382c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80383c:	8b 45 08             	mov    0x8(%ebp),%eax
  80383f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803846:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80384a:	75 17                	jne    803863 <insert_sorted_with_merge_freeList+0x3c1>
  80384c:	83 ec 04             	sub    $0x4,%esp
  80384f:	68 14 48 80 00       	push   $0x804814
  803854:	68 0b 01 00 00       	push   $0x10b
  803859:	68 37 48 80 00       	push   $0x804837
  80385e:	e8 5f d6 ff ff       	call   800ec2 <_panic>
  803863:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803869:	8b 45 08             	mov    0x8(%ebp),%eax
  80386c:	89 10                	mov    %edx,(%eax)
  80386e:	8b 45 08             	mov    0x8(%ebp),%eax
  803871:	8b 00                	mov    (%eax),%eax
  803873:	85 c0                	test   %eax,%eax
  803875:	74 0d                	je     803884 <insert_sorted_with_merge_freeList+0x3e2>
  803877:	a1 48 51 80 00       	mov    0x805148,%eax
  80387c:	8b 55 08             	mov    0x8(%ebp),%edx
  80387f:	89 50 04             	mov    %edx,0x4(%eax)
  803882:	eb 08                	jmp    80388c <insert_sorted_with_merge_freeList+0x3ea>
  803884:	8b 45 08             	mov    0x8(%ebp),%eax
  803887:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80388c:	8b 45 08             	mov    0x8(%ebp),%eax
  80388f:	a3 48 51 80 00       	mov    %eax,0x805148
  803894:	8b 45 08             	mov    0x8(%ebp),%eax
  803897:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80389e:	a1 54 51 80 00       	mov    0x805154,%eax
  8038a3:	40                   	inc    %eax
  8038a4:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8038a9:	e9 c9 03 00 00       	jmp    803c77 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8038ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b1:	8b 50 0c             	mov    0xc(%eax),%edx
  8038b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8038b7:	8b 40 08             	mov    0x8(%eax),%eax
  8038ba:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8038bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bf:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8038c2:	39 c2                	cmp    %eax,%edx
  8038c4:	0f 85 bb 00 00 00    	jne    803985 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8038ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ce:	0f 84 b1 00 00 00    	je     803985 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8038d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d7:	8b 40 04             	mov    0x4(%eax),%eax
  8038da:	85 c0                	test   %eax,%eax
  8038dc:	0f 85 a3 00 00 00    	jne    803985 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8038e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8038e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8038ea:	8b 52 08             	mov    0x8(%edx),%edx
  8038ed:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8038f0:	a1 38 51 80 00       	mov    0x805138,%eax
  8038f5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8038fb:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8038fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803901:	8b 52 0c             	mov    0xc(%edx),%edx
  803904:	01 ca                	add    %ecx,%edx
  803906:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803909:	8b 45 08             	mov    0x8(%ebp),%eax
  80390c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803913:	8b 45 08             	mov    0x8(%ebp),%eax
  803916:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80391d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803921:	75 17                	jne    80393a <insert_sorted_with_merge_freeList+0x498>
  803923:	83 ec 04             	sub    $0x4,%esp
  803926:	68 14 48 80 00       	push   $0x804814
  80392b:	68 17 01 00 00       	push   $0x117
  803930:	68 37 48 80 00       	push   $0x804837
  803935:	e8 88 d5 ff ff       	call   800ec2 <_panic>
  80393a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803940:	8b 45 08             	mov    0x8(%ebp),%eax
  803943:	89 10                	mov    %edx,(%eax)
  803945:	8b 45 08             	mov    0x8(%ebp),%eax
  803948:	8b 00                	mov    (%eax),%eax
  80394a:	85 c0                	test   %eax,%eax
  80394c:	74 0d                	je     80395b <insert_sorted_with_merge_freeList+0x4b9>
  80394e:	a1 48 51 80 00       	mov    0x805148,%eax
  803953:	8b 55 08             	mov    0x8(%ebp),%edx
  803956:	89 50 04             	mov    %edx,0x4(%eax)
  803959:	eb 08                	jmp    803963 <insert_sorted_with_merge_freeList+0x4c1>
  80395b:	8b 45 08             	mov    0x8(%ebp),%eax
  80395e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803963:	8b 45 08             	mov    0x8(%ebp),%eax
  803966:	a3 48 51 80 00       	mov    %eax,0x805148
  80396b:	8b 45 08             	mov    0x8(%ebp),%eax
  80396e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803975:	a1 54 51 80 00       	mov    0x805154,%eax
  80397a:	40                   	inc    %eax
  80397b:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803980:	e9 f2 02 00 00       	jmp    803c77 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803985:	8b 45 08             	mov    0x8(%ebp),%eax
  803988:	8b 50 08             	mov    0x8(%eax),%edx
  80398b:	8b 45 08             	mov    0x8(%ebp),%eax
  80398e:	8b 40 0c             	mov    0xc(%eax),%eax
  803991:	01 c2                	add    %eax,%edx
  803993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803996:	8b 40 08             	mov    0x8(%eax),%eax
  803999:	39 c2                	cmp    %eax,%edx
  80399b:	0f 85 be 00 00 00    	jne    803a5f <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  8039a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a4:	8b 40 04             	mov    0x4(%eax),%eax
  8039a7:	8b 50 08             	mov    0x8(%eax),%edx
  8039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ad:	8b 40 04             	mov    0x4(%eax),%eax
  8039b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8039b3:	01 c2                	add    %eax,%edx
  8039b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039b8:	8b 40 08             	mov    0x8(%eax),%eax
  8039bb:	39 c2                	cmp    %eax,%edx
  8039bd:	0f 84 9c 00 00 00    	je     803a5f <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8039c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039c6:	8b 50 08             	mov    0x8(%eax),%edx
  8039c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039cc:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8039cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d2:	8b 50 0c             	mov    0xc(%eax),%edx
  8039d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8039d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8039db:	01 c2                	add    %eax,%edx
  8039dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e0:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8039e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8039ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8039f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8039f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8039fb:	75 17                	jne    803a14 <insert_sorted_with_merge_freeList+0x572>
  8039fd:	83 ec 04             	sub    $0x4,%esp
  803a00:	68 14 48 80 00       	push   $0x804814
  803a05:	68 26 01 00 00       	push   $0x126
  803a0a:	68 37 48 80 00       	push   $0x804837
  803a0f:	e8 ae d4 ff ff       	call   800ec2 <_panic>
  803a14:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a1d:	89 10                	mov    %edx,(%eax)
  803a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a22:	8b 00                	mov    (%eax),%eax
  803a24:	85 c0                	test   %eax,%eax
  803a26:	74 0d                	je     803a35 <insert_sorted_with_merge_freeList+0x593>
  803a28:	a1 48 51 80 00       	mov    0x805148,%eax
  803a2d:	8b 55 08             	mov    0x8(%ebp),%edx
  803a30:	89 50 04             	mov    %edx,0x4(%eax)
  803a33:	eb 08                	jmp    803a3d <insert_sorted_with_merge_freeList+0x59b>
  803a35:	8b 45 08             	mov    0x8(%ebp),%eax
  803a38:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a40:	a3 48 51 80 00       	mov    %eax,0x805148
  803a45:	8b 45 08             	mov    0x8(%ebp),%eax
  803a48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a4f:	a1 54 51 80 00       	mov    0x805154,%eax
  803a54:	40                   	inc    %eax
  803a55:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803a5a:	e9 18 02 00 00       	jmp    803c77 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a62:	8b 50 0c             	mov    0xc(%eax),%edx
  803a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a68:	8b 40 08             	mov    0x8(%eax),%eax
  803a6b:	01 c2                	add    %eax,%edx
  803a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803a70:	8b 40 08             	mov    0x8(%eax),%eax
  803a73:	39 c2                	cmp    %eax,%edx
  803a75:	0f 85 c4 01 00 00    	jne    803c3f <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7e:	8b 50 0c             	mov    0xc(%eax),%edx
  803a81:	8b 45 08             	mov    0x8(%ebp),%eax
  803a84:	8b 40 08             	mov    0x8(%eax),%eax
  803a87:	01 c2                	add    %eax,%edx
  803a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a8c:	8b 00                	mov    (%eax),%eax
  803a8e:	8b 40 08             	mov    0x8(%eax),%eax
  803a91:	39 c2                	cmp    %eax,%edx
  803a93:	0f 85 a6 01 00 00    	jne    803c3f <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803a99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803a9d:	0f 84 9c 01 00 00    	je     803c3f <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aa6:	8b 50 0c             	mov    0xc(%eax),%edx
  803aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  803aac:	8b 40 0c             	mov    0xc(%eax),%eax
  803aaf:	01 c2                	add    %eax,%edx
  803ab1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ab4:	8b 00                	mov    (%eax),%eax
  803ab6:	8b 40 0c             	mov    0xc(%eax),%eax
  803ab9:	01 c2                	add    %eax,%edx
  803abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803abe:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ac4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803acb:	8b 45 08             	mov    0x8(%ebp),%eax
  803ace:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  803ad5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ad9:	75 17                	jne    803af2 <insert_sorted_with_merge_freeList+0x650>
  803adb:	83 ec 04             	sub    $0x4,%esp
  803ade:	68 14 48 80 00       	push   $0x804814
  803ae3:	68 32 01 00 00       	push   $0x132
  803ae8:	68 37 48 80 00       	push   $0x804837
  803aed:	e8 d0 d3 ff ff       	call   800ec2 <_panic>
  803af2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803af8:	8b 45 08             	mov    0x8(%ebp),%eax
  803afb:	89 10                	mov    %edx,(%eax)
  803afd:	8b 45 08             	mov    0x8(%ebp),%eax
  803b00:	8b 00                	mov    (%eax),%eax
  803b02:	85 c0                	test   %eax,%eax
  803b04:	74 0d                	je     803b13 <insert_sorted_with_merge_freeList+0x671>
  803b06:	a1 48 51 80 00       	mov    0x805148,%eax
  803b0b:	8b 55 08             	mov    0x8(%ebp),%edx
  803b0e:	89 50 04             	mov    %edx,0x4(%eax)
  803b11:	eb 08                	jmp    803b1b <insert_sorted_with_merge_freeList+0x679>
  803b13:	8b 45 08             	mov    0x8(%ebp),%eax
  803b16:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b1e:	a3 48 51 80 00       	mov    %eax,0x805148
  803b23:	8b 45 08             	mov    0x8(%ebp),%eax
  803b26:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b2d:	a1 54 51 80 00       	mov    0x805154,%eax
  803b32:	40                   	inc    %eax
  803b33:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3b:	8b 00                	mov    (%eax),%eax
  803b3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b47:	8b 00                	mov    (%eax),%eax
  803b49:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b53:	8b 00                	mov    (%eax),%eax
  803b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803b58:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803b5c:	75 17                	jne    803b75 <insert_sorted_with_merge_freeList+0x6d3>
  803b5e:	83 ec 04             	sub    $0x4,%esp
  803b61:	68 a9 48 80 00       	push   $0x8048a9
  803b66:	68 36 01 00 00       	push   $0x136
  803b6b:	68 37 48 80 00       	push   $0x804837
  803b70:	e8 4d d3 ff ff       	call   800ec2 <_panic>
  803b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b78:	8b 00                	mov    (%eax),%eax
  803b7a:	85 c0                	test   %eax,%eax
  803b7c:	74 10                	je     803b8e <insert_sorted_with_merge_freeList+0x6ec>
  803b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b81:	8b 00                	mov    (%eax),%eax
  803b83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803b86:	8b 52 04             	mov    0x4(%edx),%edx
  803b89:	89 50 04             	mov    %edx,0x4(%eax)
  803b8c:	eb 0b                	jmp    803b99 <insert_sorted_with_merge_freeList+0x6f7>
  803b8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b91:	8b 40 04             	mov    0x4(%eax),%eax
  803b94:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803b99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803b9c:	8b 40 04             	mov    0x4(%eax),%eax
  803b9f:	85 c0                	test   %eax,%eax
  803ba1:	74 0f                	je     803bb2 <insert_sorted_with_merge_freeList+0x710>
  803ba3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803ba6:	8b 40 04             	mov    0x4(%eax),%eax
  803ba9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803bac:	8b 12                	mov    (%edx),%edx
  803bae:	89 10                	mov    %edx,(%eax)
  803bb0:	eb 0a                	jmp    803bbc <insert_sorted_with_merge_freeList+0x71a>
  803bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bb5:	8b 00                	mov    (%eax),%eax
  803bb7:	a3 38 51 80 00       	mov    %eax,0x805138
  803bbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803bc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803bc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803bcf:	a1 44 51 80 00       	mov    0x805144,%eax
  803bd4:	48                   	dec    %eax
  803bd5:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803bda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803bde:	75 17                	jne    803bf7 <insert_sorted_with_merge_freeList+0x755>
  803be0:	83 ec 04             	sub    $0x4,%esp
  803be3:	68 14 48 80 00       	push   $0x804814
  803be8:	68 37 01 00 00       	push   $0x137
  803bed:	68 37 48 80 00       	push   $0x804837
  803bf2:	e8 cb d2 ff ff       	call   800ec2 <_panic>
  803bf7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803bfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c00:	89 10                	mov    %edx,(%eax)
  803c02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c05:	8b 00                	mov    (%eax),%eax
  803c07:	85 c0                	test   %eax,%eax
  803c09:	74 0d                	je     803c18 <insert_sorted_with_merge_freeList+0x776>
  803c0b:	a1 48 51 80 00       	mov    0x805148,%eax
  803c10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803c13:	89 50 04             	mov    %edx,0x4(%eax)
  803c16:	eb 08                	jmp    803c20 <insert_sorted_with_merge_freeList+0x77e>
  803c18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c1b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803c20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c23:	a3 48 51 80 00       	mov    %eax,0x805148
  803c28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803c2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803c32:	a1 54 51 80 00       	mov    0x805154,%eax
  803c37:	40                   	inc    %eax
  803c38:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803c3d:	eb 38                	jmp    803c77 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803c3f:	a1 40 51 80 00       	mov    0x805140,%eax
  803c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c4b:	74 07                	je     803c54 <insert_sorted_with_merge_freeList+0x7b2>
  803c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c50:	8b 00                	mov    (%eax),%eax
  803c52:	eb 05                	jmp    803c59 <insert_sorted_with_merge_freeList+0x7b7>
  803c54:	b8 00 00 00 00       	mov    $0x0,%eax
  803c59:	a3 40 51 80 00       	mov    %eax,0x805140
  803c5e:	a1 40 51 80 00       	mov    0x805140,%eax
  803c63:	85 c0                	test   %eax,%eax
  803c65:	0f 85 ef f9 ff ff    	jne    80365a <insert_sorted_with_merge_freeList+0x1b8>
  803c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c6f:	0f 85 e5 f9 ff ff    	jne    80365a <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803c75:	eb 00                	jmp    803c77 <insert_sorted_with_merge_freeList+0x7d5>
  803c77:	90                   	nop
  803c78:	c9                   	leave  
  803c79:	c3                   	ret    
  803c7a:	66 90                	xchg   %ax,%ax

00803c7c <__udivdi3>:
  803c7c:	55                   	push   %ebp
  803c7d:	57                   	push   %edi
  803c7e:	56                   	push   %esi
  803c7f:	53                   	push   %ebx
  803c80:	83 ec 1c             	sub    $0x1c,%esp
  803c83:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803c87:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803c8b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803c8f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c93:	89 ca                	mov    %ecx,%edx
  803c95:	89 f8                	mov    %edi,%eax
  803c97:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803c9b:	85 f6                	test   %esi,%esi
  803c9d:	75 2d                	jne    803ccc <__udivdi3+0x50>
  803c9f:	39 cf                	cmp    %ecx,%edi
  803ca1:	77 65                	ja     803d08 <__udivdi3+0x8c>
  803ca3:	89 fd                	mov    %edi,%ebp
  803ca5:	85 ff                	test   %edi,%edi
  803ca7:	75 0b                	jne    803cb4 <__udivdi3+0x38>
  803ca9:	b8 01 00 00 00       	mov    $0x1,%eax
  803cae:	31 d2                	xor    %edx,%edx
  803cb0:	f7 f7                	div    %edi
  803cb2:	89 c5                	mov    %eax,%ebp
  803cb4:	31 d2                	xor    %edx,%edx
  803cb6:	89 c8                	mov    %ecx,%eax
  803cb8:	f7 f5                	div    %ebp
  803cba:	89 c1                	mov    %eax,%ecx
  803cbc:	89 d8                	mov    %ebx,%eax
  803cbe:	f7 f5                	div    %ebp
  803cc0:	89 cf                	mov    %ecx,%edi
  803cc2:	89 fa                	mov    %edi,%edx
  803cc4:	83 c4 1c             	add    $0x1c,%esp
  803cc7:	5b                   	pop    %ebx
  803cc8:	5e                   	pop    %esi
  803cc9:	5f                   	pop    %edi
  803cca:	5d                   	pop    %ebp
  803ccb:	c3                   	ret    
  803ccc:	39 ce                	cmp    %ecx,%esi
  803cce:	77 28                	ja     803cf8 <__udivdi3+0x7c>
  803cd0:	0f bd fe             	bsr    %esi,%edi
  803cd3:	83 f7 1f             	xor    $0x1f,%edi
  803cd6:	75 40                	jne    803d18 <__udivdi3+0x9c>
  803cd8:	39 ce                	cmp    %ecx,%esi
  803cda:	72 0a                	jb     803ce6 <__udivdi3+0x6a>
  803cdc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803ce0:	0f 87 9e 00 00 00    	ja     803d84 <__udivdi3+0x108>
  803ce6:	b8 01 00 00 00       	mov    $0x1,%eax
  803ceb:	89 fa                	mov    %edi,%edx
  803ced:	83 c4 1c             	add    $0x1c,%esp
  803cf0:	5b                   	pop    %ebx
  803cf1:	5e                   	pop    %esi
  803cf2:	5f                   	pop    %edi
  803cf3:	5d                   	pop    %ebp
  803cf4:	c3                   	ret    
  803cf5:	8d 76 00             	lea    0x0(%esi),%esi
  803cf8:	31 ff                	xor    %edi,%edi
  803cfa:	31 c0                	xor    %eax,%eax
  803cfc:	89 fa                	mov    %edi,%edx
  803cfe:	83 c4 1c             	add    $0x1c,%esp
  803d01:	5b                   	pop    %ebx
  803d02:	5e                   	pop    %esi
  803d03:	5f                   	pop    %edi
  803d04:	5d                   	pop    %ebp
  803d05:	c3                   	ret    
  803d06:	66 90                	xchg   %ax,%ax
  803d08:	89 d8                	mov    %ebx,%eax
  803d0a:	f7 f7                	div    %edi
  803d0c:	31 ff                	xor    %edi,%edi
  803d0e:	89 fa                	mov    %edi,%edx
  803d10:	83 c4 1c             	add    $0x1c,%esp
  803d13:	5b                   	pop    %ebx
  803d14:	5e                   	pop    %esi
  803d15:	5f                   	pop    %edi
  803d16:	5d                   	pop    %ebp
  803d17:	c3                   	ret    
  803d18:	bd 20 00 00 00       	mov    $0x20,%ebp
  803d1d:	89 eb                	mov    %ebp,%ebx
  803d1f:	29 fb                	sub    %edi,%ebx
  803d21:	89 f9                	mov    %edi,%ecx
  803d23:	d3 e6                	shl    %cl,%esi
  803d25:	89 c5                	mov    %eax,%ebp
  803d27:	88 d9                	mov    %bl,%cl
  803d29:	d3 ed                	shr    %cl,%ebp
  803d2b:	89 e9                	mov    %ebp,%ecx
  803d2d:	09 f1                	or     %esi,%ecx
  803d2f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803d33:	89 f9                	mov    %edi,%ecx
  803d35:	d3 e0                	shl    %cl,%eax
  803d37:	89 c5                	mov    %eax,%ebp
  803d39:	89 d6                	mov    %edx,%esi
  803d3b:	88 d9                	mov    %bl,%cl
  803d3d:	d3 ee                	shr    %cl,%esi
  803d3f:	89 f9                	mov    %edi,%ecx
  803d41:	d3 e2                	shl    %cl,%edx
  803d43:	8b 44 24 08          	mov    0x8(%esp),%eax
  803d47:	88 d9                	mov    %bl,%cl
  803d49:	d3 e8                	shr    %cl,%eax
  803d4b:	09 c2                	or     %eax,%edx
  803d4d:	89 d0                	mov    %edx,%eax
  803d4f:	89 f2                	mov    %esi,%edx
  803d51:	f7 74 24 0c          	divl   0xc(%esp)
  803d55:	89 d6                	mov    %edx,%esi
  803d57:	89 c3                	mov    %eax,%ebx
  803d59:	f7 e5                	mul    %ebp
  803d5b:	39 d6                	cmp    %edx,%esi
  803d5d:	72 19                	jb     803d78 <__udivdi3+0xfc>
  803d5f:	74 0b                	je     803d6c <__udivdi3+0xf0>
  803d61:	89 d8                	mov    %ebx,%eax
  803d63:	31 ff                	xor    %edi,%edi
  803d65:	e9 58 ff ff ff       	jmp    803cc2 <__udivdi3+0x46>
  803d6a:	66 90                	xchg   %ax,%ax
  803d6c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803d70:	89 f9                	mov    %edi,%ecx
  803d72:	d3 e2                	shl    %cl,%edx
  803d74:	39 c2                	cmp    %eax,%edx
  803d76:	73 e9                	jae    803d61 <__udivdi3+0xe5>
  803d78:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803d7b:	31 ff                	xor    %edi,%edi
  803d7d:	e9 40 ff ff ff       	jmp    803cc2 <__udivdi3+0x46>
  803d82:	66 90                	xchg   %ax,%ax
  803d84:	31 c0                	xor    %eax,%eax
  803d86:	e9 37 ff ff ff       	jmp    803cc2 <__udivdi3+0x46>
  803d8b:	90                   	nop

00803d8c <__umoddi3>:
  803d8c:	55                   	push   %ebp
  803d8d:	57                   	push   %edi
  803d8e:	56                   	push   %esi
  803d8f:	53                   	push   %ebx
  803d90:	83 ec 1c             	sub    $0x1c,%esp
  803d93:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803d97:	8b 74 24 34          	mov    0x34(%esp),%esi
  803d9b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803d9f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803da3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803da7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803dab:	89 f3                	mov    %esi,%ebx
  803dad:	89 fa                	mov    %edi,%edx
  803daf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803db3:	89 34 24             	mov    %esi,(%esp)
  803db6:	85 c0                	test   %eax,%eax
  803db8:	75 1a                	jne    803dd4 <__umoddi3+0x48>
  803dba:	39 f7                	cmp    %esi,%edi
  803dbc:	0f 86 a2 00 00 00    	jbe    803e64 <__umoddi3+0xd8>
  803dc2:	89 c8                	mov    %ecx,%eax
  803dc4:	89 f2                	mov    %esi,%edx
  803dc6:	f7 f7                	div    %edi
  803dc8:	89 d0                	mov    %edx,%eax
  803dca:	31 d2                	xor    %edx,%edx
  803dcc:	83 c4 1c             	add    $0x1c,%esp
  803dcf:	5b                   	pop    %ebx
  803dd0:	5e                   	pop    %esi
  803dd1:	5f                   	pop    %edi
  803dd2:	5d                   	pop    %ebp
  803dd3:	c3                   	ret    
  803dd4:	39 f0                	cmp    %esi,%eax
  803dd6:	0f 87 ac 00 00 00    	ja     803e88 <__umoddi3+0xfc>
  803ddc:	0f bd e8             	bsr    %eax,%ebp
  803ddf:	83 f5 1f             	xor    $0x1f,%ebp
  803de2:	0f 84 ac 00 00 00    	je     803e94 <__umoddi3+0x108>
  803de8:	bf 20 00 00 00       	mov    $0x20,%edi
  803ded:	29 ef                	sub    %ebp,%edi
  803def:	89 fe                	mov    %edi,%esi
  803df1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803df5:	89 e9                	mov    %ebp,%ecx
  803df7:	d3 e0                	shl    %cl,%eax
  803df9:	89 d7                	mov    %edx,%edi
  803dfb:	89 f1                	mov    %esi,%ecx
  803dfd:	d3 ef                	shr    %cl,%edi
  803dff:	09 c7                	or     %eax,%edi
  803e01:	89 e9                	mov    %ebp,%ecx
  803e03:	d3 e2                	shl    %cl,%edx
  803e05:	89 14 24             	mov    %edx,(%esp)
  803e08:	89 d8                	mov    %ebx,%eax
  803e0a:	d3 e0                	shl    %cl,%eax
  803e0c:	89 c2                	mov    %eax,%edx
  803e0e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e12:	d3 e0                	shl    %cl,%eax
  803e14:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e18:	8b 44 24 08          	mov    0x8(%esp),%eax
  803e1c:	89 f1                	mov    %esi,%ecx
  803e1e:	d3 e8                	shr    %cl,%eax
  803e20:	09 d0                	or     %edx,%eax
  803e22:	d3 eb                	shr    %cl,%ebx
  803e24:	89 da                	mov    %ebx,%edx
  803e26:	f7 f7                	div    %edi
  803e28:	89 d3                	mov    %edx,%ebx
  803e2a:	f7 24 24             	mull   (%esp)
  803e2d:	89 c6                	mov    %eax,%esi
  803e2f:	89 d1                	mov    %edx,%ecx
  803e31:	39 d3                	cmp    %edx,%ebx
  803e33:	0f 82 87 00 00 00    	jb     803ec0 <__umoddi3+0x134>
  803e39:	0f 84 91 00 00 00    	je     803ed0 <__umoddi3+0x144>
  803e3f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803e43:	29 f2                	sub    %esi,%edx
  803e45:	19 cb                	sbb    %ecx,%ebx
  803e47:	89 d8                	mov    %ebx,%eax
  803e49:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803e4d:	d3 e0                	shl    %cl,%eax
  803e4f:	89 e9                	mov    %ebp,%ecx
  803e51:	d3 ea                	shr    %cl,%edx
  803e53:	09 d0                	or     %edx,%eax
  803e55:	89 e9                	mov    %ebp,%ecx
  803e57:	d3 eb                	shr    %cl,%ebx
  803e59:	89 da                	mov    %ebx,%edx
  803e5b:	83 c4 1c             	add    $0x1c,%esp
  803e5e:	5b                   	pop    %ebx
  803e5f:	5e                   	pop    %esi
  803e60:	5f                   	pop    %edi
  803e61:	5d                   	pop    %ebp
  803e62:	c3                   	ret    
  803e63:	90                   	nop
  803e64:	89 fd                	mov    %edi,%ebp
  803e66:	85 ff                	test   %edi,%edi
  803e68:	75 0b                	jne    803e75 <__umoddi3+0xe9>
  803e6a:	b8 01 00 00 00       	mov    $0x1,%eax
  803e6f:	31 d2                	xor    %edx,%edx
  803e71:	f7 f7                	div    %edi
  803e73:	89 c5                	mov    %eax,%ebp
  803e75:	89 f0                	mov    %esi,%eax
  803e77:	31 d2                	xor    %edx,%edx
  803e79:	f7 f5                	div    %ebp
  803e7b:	89 c8                	mov    %ecx,%eax
  803e7d:	f7 f5                	div    %ebp
  803e7f:	89 d0                	mov    %edx,%eax
  803e81:	e9 44 ff ff ff       	jmp    803dca <__umoddi3+0x3e>
  803e86:	66 90                	xchg   %ax,%ax
  803e88:	89 c8                	mov    %ecx,%eax
  803e8a:	89 f2                	mov    %esi,%edx
  803e8c:	83 c4 1c             	add    $0x1c,%esp
  803e8f:	5b                   	pop    %ebx
  803e90:	5e                   	pop    %esi
  803e91:	5f                   	pop    %edi
  803e92:	5d                   	pop    %ebp
  803e93:	c3                   	ret    
  803e94:	3b 04 24             	cmp    (%esp),%eax
  803e97:	72 06                	jb     803e9f <__umoddi3+0x113>
  803e99:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803e9d:	77 0f                	ja     803eae <__umoddi3+0x122>
  803e9f:	89 f2                	mov    %esi,%edx
  803ea1:	29 f9                	sub    %edi,%ecx
  803ea3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803ea7:	89 14 24             	mov    %edx,(%esp)
  803eaa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803eae:	8b 44 24 04          	mov    0x4(%esp),%eax
  803eb2:	8b 14 24             	mov    (%esp),%edx
  803eb5:	83 c4 1c             	add    $0x1c,%esp
  803eb8:	5b                   	pop    %ebx
  803eb9:	5e                   	pop    %esi
  803eba:	5f                   	pop    %edi
  803ebb:	5d                   	pop    %ebp
  803ebc:	c3                   	ret    
  803ebd:	8d 76 00             	lea    0x0(%esi),%esi
  803ec0:	2b 04 24             	sub    (%esp),%eax
  803ec3:	19 fa                	sbb    %edi,%edx
  803ec5:	89 d1                	mov    %edx,%ecx
  803ec7:	89 c6                	mov    %eax,%esi
  803ec9:	e9 71 ff ff ff       	jmp    803e3f <__umoddi3+0xb3>
  803ece:	66 90                	xchg   %ax,%ax
  803ed0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ed4:	72 ea                	jb     803ec0 <__umoddi3+0x134>
  803ed6:	89 d9                	mov    %ebx,%ecx
  803ed8:	e9 62 ff ff ff       	jmp    803e3f <__umoddi3+0xb3>
