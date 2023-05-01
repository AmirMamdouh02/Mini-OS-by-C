
obj/user/tst_free_3:     file format elf32-i386


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
  800031:	e8 1d 14 00 00       	call   801453 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

#define numOfAccessesFor3MB 7
#define numOfAccessesFor8MB 4
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec 7c 01 00 00    	sub    $0x17c,%esp



	int Mega = 1024*1024;
  800044:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)
	int kilo = 1024;
  80004b:	c7 45 d0 00 04 00 00 	movl   $0x400,-0x30(%ebp)
	char minByte = 1<<7;
  800052:	c6 45 cf 80          	movb   $0x80,-0x31(%ebp)
	char maxByte = 0x7F;
  800056:	c6 45 ce 7f          	movb   $0x7f,-0x32(%ebp)
	short minShort = 1<<15 ;
  80005a:	66 c7 45 cc 00 80    	movw   $0x8000,-0x34(%ebp)
	short maxShort = 0x7FFF;
  800060:	66 c7 45 ca ff 7f    	movw   $0x7fff,-0x36(%ebp)
	int minInt = 1<<31 ;
  800066:	c7 45 c4 00 00 00 80 	movl   $0x80000000,-0x3c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006d:	c7 45 c0 ff ff ff 7f 	movl   $0x7fffffff,-0x40(%ebp)
	char *byteArr, *byteArr2 ;
	short *shortArr, *shortArr2 ;
	int *intArr;
	int lastIndexOfByte, lastIndexOfByte2, lastIndexOfShort, lastIndexOfShort2, lastIndexOfInt, lastIndexOfStruct;
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  800074:	83 ec 0c             	sub    $0xc,%esp
  800077:	6a 00                	push   $0x0
  800079:	e8 64 27 00 00       	call   8027e2 <malloc>
  80007e:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/
	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800081:	a1 20 60 80 00       	mov    0x806020,%eax
  800086:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80008c:	8b 00                	mov    (%eax),%eax
  80008e:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800091:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800094:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800099:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80009e:	74 14                	je     8000b4 <_main+0x7c>
  8000a0:	83 ec 04             	sub    $0x4,%esp
  8000a3:	68 c0 45 80 00       	push   $0x8045c0
  8000a8:	6a 20                	push   $0x20
  8000aa:	68 01 46 80 00       	push   $0x804601
  8000af:	e8 db 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000b4:	a1 20 60 80 00       	mov    0x806020,%eax
  8000b9:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000bf:	83 c0 18             	add    $0x18,%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8000c7:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8000ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000cf:	3d 00 10 20 00       	cmp    $0x201000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 c0 45 80 00       	push   $0x8045c0
  8000de:	6a 21                	push   $0x21
  8000e0:	68 01 46 80 00       	push   $0x804601
  8000e5:	e8 a5 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ea:	a1 20 60 80 00       	mov    0x806020,%eax
  8000ef:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000f5:	83 c0 30             	add    $0x30,%eax
  8000f8:	8b 00                	mov    (%eax),%eax
  8000fa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  8000fd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800105:	3d 00 20 20 00       	cmp    $0x202000,%eax
  80010a:	74 14                	je     800120 <_main+0xe8>
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 c0 45 80 00       	push   $0x8045c0
  800114:	6a 22                	push   $0x22
  800116:	68 01 46 80 00       	push   $0x804601
  80011b:	e8 6f 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800120:	a1 20 60 80 00       	mov    0x806020,%eax
  800125:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80012b:	83 c0 48             	add    $0x48,%eax
  80012e:	8b 00                	mov    (%eax),%eax
  800130:	89 45 b0             	mov    %eax,-0x50(%ebp)
  800133:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800136:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80013b:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 c0 45 80 00       	push   $0x8045c0
  80014a:	6a 23                	push   $0x23
  80014c:	68 01 46 80 00       	push   $0x804601
  800151:	e8 39 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800156:	a1 20 60 80 00       	mov    0x806020,%eax
  80015b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800161:	83 c0 60             	add    $0x60,%eax
  800164:	8b 00                	mov    (%eax),%eax
  800166:	89 45 ac             	mov    %eax,-0x54(%ebp)
  800169:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80016c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800171:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800176:	74 14                	je     80018c <_main+0x154>
  800178:	83 ec 04             	sub    $0x4,%esp
  80017b:	68 c0 45 80 00       	push   $0x8045c0
  800180:	6a 24                	push   $0x24
  800182:	68 01 46 80 00       	push   $0x804601
  800187:	e8 03 14 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80018c:	a1 20 60 80 00       	mov    0x806020,%eax
  800191:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800197:	83 c0 78             	add    $0x78,%eax
  80019a:	8b 00                	mov    (%eax),%eax
  80019c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80019f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8001a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a7:	3d 00 50 20 00       	cmp    $0x205000,%eax
  8001ac:	74 14                	je     8001c2 <_main+0x18a>
  8001ae:	83 ec 04             	sub    $0x4,%esp
  8001b1:	68 c0 45 80 00       	push   $0x8045c0
  8001b6:	6a 25                	push   $0x25
  8001b8:	68 01 46 80 00       	push   $0x804601
  8001bd:	e8 cd 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001c2:	a1 20 60 80 00       	mov    0x806020,%eax
  8001c7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001cd:	05 90 00 00 00       	add    $0x90,%eax
  8001d2:	8b 00                	mov    (%eax),%eax
  8001d4:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  8001d7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8001da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001df:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001e4:	74 14                	je     8001fa <_main+0x1c2>
  8001e6:	83 ec 04             	sub    $0x4,%esp
  8001e9:	68 c0 45 80 00       	push   $0x8045c0
  8001ee:	6a 26                	push   $0x26
  8001f0:	68 01 46 80 00       	push   $0x804601
  8001f5:	e8 95 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001fa:	a1 20 60 80 00       	mov    0x806020,%eax
  8001ff:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800205:	05 a8 00 00 00       	add    $0xa8,%eax
  80020a:	8b 00                	mov    (%eax),%eax
  80020c:	89 45 a0             	mov    %eax,-0x60(%ebp)
  80020f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800212:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800217:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80021c:	74 14                	je     800232 <_main+0x1fa>
  80021e:	83 ec 04             	sub    $0x4,%esp
  800221:	68 c0 45 80 00       	push   $0x8045c0
  800226:	6a 27                	push   $0x27
  800228:	68 01 46 80 00       	push   $0x804601
  80022d:	e8 5d 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800232:	a1 20 60 80 00       	mov    0x806020,%eax
  800237:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80023d:	05 c0 00 00 00       	add    $0xc0,%eax
  800242:	8b 00                	mov    (%eax),%eax
  800244:	89 45 9c             	mov    %eax,-0x64(%ebp)
  800247:	8b 45 9c             	mov    -0x64(%ebp),%eax
  80024a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800254:	74 14                	je     80026a <_main+0x232>
  800256:	83 ec 04             	sub    $0x4,%esp
  800259:	68 c0 45 80 00       	push   $0x8045c0
  80025e:	6a 28                	push   $0x28
  800260:	68 01 46 80 00       	push   $0x804601
  800265:	e8 25 13 00 00       	call   80158f <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80026a:	a1 20 60 80 00       	mov    0x806020,%eax
  80026f:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800275:	05 d8 00 00 00       	add    $0xd8,%eax
  80027a:	8b 00                	mov    (%eax),%eax
  80027c:	89 45 98             	mov    %eax,-0x68(%ebp)
  80027f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800282:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800287:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 c0 45 80 00       	push   $0x8045c0
  800296:	6a 29                	push   $0x29
  800298:	68 01 46 80 00       	push   $0x804601
  80029d:	e8 ed 12 00 00       	call   80158f <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
  8002a2:	a1 20 60 80 00       	mov    0x806020,%eax
  8002a7:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002ad:	85 c0                	test   %eax,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 14 46 80 00       	push   $0x804614
  8002b9:	6a 2a                	push   $0x2a
  8002bb:	68 01 46 80 00       	push   $0x804601
  8002c0:	e8 ca 12 00 00       	call   80158f <_panic>
	}

	int start_freeFrames = sys_calculate_free_frames() ;
  8002c5:	e8 b6 29 00 00       	call   802c80 <sys_calculate_free_frames>
  8002ca:	89 45 94             	mov    %eax,-0x6c(%ebp)

	int indicesOf3MB[numOfAccessesFor3MB];
	int indicesOf8MB[numOfAccessesFor8MB];
	int var, i, j;

	void* ptr_allocations[20] = {0};
  8002cd:	8d 95 80 fe ff ff    	lea    -0x180(%ebp),%edx
  8002d3:	b9 14 00 00 00       	mov    $0x14,%ecx
  8002d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8002dd:	89 d7                	mov    %edx,%edi
  8002df:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		/*ALLOCATE 2 MB*/
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002e1:	e8 3a 2a 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  8002e6:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8002e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002ec:	01 c0                	add    %eax,%eax
  8002ee:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8002f1:	83 ec 0c             	sub    $0xc,%esp
  8002f4:	50                   	push   %eax
  8002f5:	e8 e8 24 00 00       	call   8027e2 <malloc>
  8002fa:	83 c4 10             	add    $0x10,%esp
  8002fd:	89 85 80 fe ff ff    	mov    %eax,-0x180(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800303:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800309:	85 c0                	test   %eax,%eax
  80030b:	79 0d                	jns    80031a <_main+0x2e2>
  80030d:	8b 85 80 fe ff ff    	mov    -0x180(%ebp),%eax
  800313:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800318:	76 14                	jbe    80032e <_main+0x2f6>
  80031a:	83 ec 04             	sub    $0x4,%esp
  80031d:	68 5c 46 80 00       	push   $0x80465c
  800322:	6a 39                	push   $0x39
  800324:	68 01 46 80 00       	push   $0x804601
  800329:	e8 61 12 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  80032e:	e8 ed 29 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800333:	2b 45 90             	sub    -0x70(%ebp),%eax
  800336:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 c4 46 80 00       	push   $0x8046c4
  800345:	6a 3a                	push   $0x3a
  800347:	68 01 46 80 00       	push   $0x804601
  80034c:	e8 3e 12 00 00       	call   80158f <_panic>

		/*ALLOCATE 3 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 ca 29 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800356:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[1] = malloc(3*Mega-kilo);
  800359:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035c:	89 c2                	mov    %eax,%edx
  80035e:	01 d2                	add    %edx,%edx
  800360:	01 d0                	add    %edx,%eax
  800362:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800365:	83 ec 0c             	sub    $0xc,%esp
  800368:	50                   	push   %eax
  800369:	e8 74 24 00 00       	call   8027e2 <malloc>
  80036e:	83 c4 10             	add    $0x10,%esp
  800371:	89 85 84 fe ff ff    	mov    %eax,-0x17c(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START+ 2*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800377:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80037d:	89 c2                	mov    %eax,%edx
  80037f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	05 00 00 00 80       	add    $0x80000000,%eax
  800389:	39 c2                	cmp    %eax,%edx
  80038b:	72 16                	jb     8003a3 <_main+0x36b>
  80038d:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800393:	89 c2                	mov    %eax,%edx
  800395:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800398:	01 c0                	add    %eax,%eax
  80039a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80039f:	39 c2                	cmp    %eax,%edx
  8003a1:	76 14                	jbe    8003b7 <_main+0x37f>
  8003a3:	83 ec 04             	sub    $0x4,%esp
  8003a6:	68 5c 46 80 00       	push   $0x80465c
  8003ab:	6a 40                	push   $0x40
  8003ad:	68 01 46 80 00       	push   $0x804601
  8003b2:	e8 d8 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  8003b7:	e8 64 29 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  8003bc:	2b 45 90             	sub    -0x70(%ebp),%eax
  8003bf:	89 c2                	mov    %eax,%edx
  8003c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c4:	89 c1                	mov    %eax,%ecx
  8003c6:	01 c9                	add    %ecx,%ecx
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	79 05                	jns    8003d3 <_main+0x39b>
  8003ce:	05 ff 0f 00 00       	add    $0xfff,%eax
  8003d3:	c1 f8 0c             	sar    $0xc,%eax
  8003d6:	39 c2                	cmp    %eax,%edx
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 c4 46 80 00       	push   $0x8046c4
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 01 46 80 00       	push   $0x804601
  8003e9:	e8 a1 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 8 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003ee:	e8 2d 29 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  8003f3:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(8*Mega-kilo);
  8003f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003f9:	c1 e0 03             	shl    $0x3,%eax
  8003fc:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8003ff:	83 ec 0c             	sub    $0xc,%esp
  800402:	50                   	push   %eax
  800403:	e8 da 23 00 00       	call   8027e2 <malloc>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 5*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 5*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800411:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800417:	89 c1                	mov    %eax,%ecx
  800419:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	c1 e0 02             	shl    $0x2,%eax
  800421:	01 d0                	add    %edx,%eax
  800423:	05 00 00 00 80       	add    $0x80000000,%eax
  800428:	39 c1                	cmp    %eax,%ecx
  80042a:	72 1b                	jb     800447 <_main+0x40f>
  80042c:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800432:	89 c1                	mov    %eax,%ecx
  800434:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800437:	89 d0                	mov    %edx,%eax
  800439:	c1 e0 02             	shl    $0x2,%eax
  80043c:	01 d0                	add    %edx,%eax
  80043e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800443:	39 c1                	cmp    %eax,%ecx
  800445:	76 14                	jbe    80045b <_main+0x423>
  800447:	83 ec 04             	sub    $0x4,%esp
  80044a:	68 5c 46 80 00       	push   $0x80465c
  80044f:	6a 47                	push   $0x47
  800451:	68 01 46 80 00       	push   $0x804601
  800456:	e8 34 11 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80045b:	e8 c0 28 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800460:	2b 45 90             	sub    -0x70(%ebp),%eax
  800463:	89 c2                	mov    %eax,%edx
  800465:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800468:	c1 e0 03             	shl    $0x3,%eax
  80046b:	85 c0                	test   %eax,%eax
  80046d:	79 05                	jns    800474 <_main+0x43c>
  80046f:	05 ff 0f 00 00       	add    $0xfff,%eax
  800474:	c1 f8 0c             	sar    $0xc,%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <_main+0x457>
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 c4 46 80 00       	push   $0x8046c4
  800483:	6a 48                	push   $0x48
  800485:	68 01 46 80 00       	push   $0x804601
  80048a:	e8 00 11 00 00       	call   80158f <_panic>

		/*ALLOCATE 7 MB*/
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80048f:	e8 8c 28 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800494:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(7*Mega-kilo);
  800497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80049a:	89 d0                	mov    %edx,%eax
  80049c:	01 c0                	add    %eax,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	01 c0                	add    %eax,%eax
  8004a2:	01 d0                	add    %edx,%eax
  8004a4:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	50                   	push   %eax
  8004ab:	e8 32 23 00 00       	call   8027e2 <malloc>
  8004b0:	83 c4 10             	add    $0x10,%esp
  8004b3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		//check return address & page file
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 13*Mega) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 13*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  8004b9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004bf:	89 c1                	mov    %eax,%ecx
  8004c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004c4:	89 d0                	mov    %edx,%eax
  8004c6:	01 c0                	add    %eax,%eax
  8004c8:	01 d0                	add    %edx,%eax
  8004ca:	c1 e0 02             	shl    $0x2,%eax
  8004cd:	01 d0                	add    %edx,%eax
  8004cf:	05 00 00 00 80       	add    $0x80000000,%eax
  8004d4:	39 c1                	cmp    %eax,%ecx
  8004d6:	72 1f                	jb     8004f7 <_main+0x4bf>
  8004d8:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  8004de:	89 c1                	mov    %eax,%ecx
  8004e0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8004e3:	89 d0                	mov    %edx,%eax
  8004e5:	01 c0                	add    %eax,%eax
  8004e7:	01 d0                	add    %edx,%eax
  8004e9:	c1 e0 02             	shl    $0x2,%eax
  8004ec:	01 d0                	add    %edx,%eax
  8004ee:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8004f3:	39 c1                	cmp    %eax,%ecx
  8004f5:	76 14                	jbe    80050b <_main+0x4d3>
  8004f7:	83 ec 04             	sub    $0x4,%esp
  8004fa:	68 5c 46 80 00       	push   $0x80465c
  8004ff:	6a 4e                	push   $0x4e
  800501:	68 01 46 80 00       	push   $0x804601
  800506:	e8 84 10 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 7*Mega/PAGE_SIZE) panic("Extra or less pages are allocated in PageFile");
  80050b:	e8 10 28 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800510:	2b 45 90             	sub    -0x70(%ebp),%eax
  800513:	89 c1                	mov    %eax,%ecx
  800515:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	01 c0                	add    %eax,%eax
  800520:	01 d0                	add    %edx,%eax
  800522:	85 c0                	test   %eax,%eax
  800524:	79 05                	jns    80052b <_main+0x4f3>
  800526:	05 ff 0f 00 00       	add    $0xfff,%eax
  80052b:	c1 f8 0c             	sar    $0xc,%eax
  80052e:	39 c1                	cmp    %eax,%ecx
  800530:	74 14                	je     800546 <_main+0x50e>
  800532:	83 ec 04             	sub    $0x4,%esp
  800535:	68 c4 46 80 00       	push   $0x8046c4
  80053a:	6a 4f                	push   $0x4f
  80053c:	68 01 46 80 00       	push   $0x804601
  800541:	e8 49 10 00 00       	call   80158f <_panic>

		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
  800546:	e8 35 27 00 00       	call   802c80 <sys_calculate_free_frames>
  80054b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		int modFrames = sys_calculate_modified_frames();
  80054e:	e8 46 27 00 00       	call   802c99 <sys_calculate_modified_frames>
  800553:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
  800556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800559:	89 c2                	mov    %eax,%edx
  80055b:	01 d2                	add    %edx,%edx
  80055d:	01 d0                	add    %edx,%eax
  80055f:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800562:	48                   	dec    %eax
  800563:	89 45 84             	mov    %eax,-0x7c(%ebp)
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
  800566:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800569:	bf 07 00 00 00       	mov    $0x7,%edi
  80056e:	99                   	cltd   
  80056f:	f7 ff                	idiv   %edi
  800571:	89 45 80             	mov    %eax,-0x80(%ebp)
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800574:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80057b:	eb 16                	jmp    800593 <_main+0x55b>
		{
			indicesOf3MB[var] = var * inc ;
  80057d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800580:	0f af 45 80          	imul   -0x80(%ebp),%eax
  800584:	89 c2                	mov    %eax,%edx
  800586:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800589:	89 94 85 e0 fe ff ff 	mov    %edx,-0x120(%ebp,%eax,4)
		/*access 3 MB*/// should bring 6 pages into WS (3 r, 4 w)
		int freeFrames = sys_calculate_free_frames() ;
		int modFrames = sys_calculate_modified_frames();
		lastIndexOfByte = (3*Mega-kilo)/sizeof(char) - 1;
		int inc = lastIndexOfByte / numOfAccessesFor3MB;
		for (var = 0; var < numOfAccessesFor3MB; ++var)
  800590:	ff 45 e4             	incl   -0x1c(%ebp)
  800593:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800597:	7e e4                	jle    80057d <_main+0x545>
		{
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
  800599:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  80059f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		//3 reads
		int sum = 0;
  8005a5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005b3:	eb 1f                	jmp    8005d4 <_main+0x59c>
		{
			sum += byteArr[indicesOf3MB[var]] ;
  8005b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005b8:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005bf:	89 c2                	mov    %eax,%edx
  8005c1:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005c7:	01 d0                	add    %edx,%eax
  8005c9:	8a 00                	mov    (%eax),%al
  8005cb:	0f be c0             	movsbl %al,%eax
  8005ce:	01 45 dc             	add    %eax,-0x24(%ebp)
			indicesOf3MB[var] = var * inc ;
		}
		byteArr = (char *) ptr_allocations[1];
		//3 reads
		int sum = 0;
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
  8005d1:	ff 45 e4             	incl   -0x1c(%ebp)
  8005d4:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
  8005d8:	7e db                	jle    8005b5 <_main+0x57d>
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005da:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
  8005e1:	eb 1c                	jmp    8005ff <_main+0x5c7>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
  8005e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e6:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8005ed:	89 c2                	mov    %eax,%edx
  8005ef:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f5:	01 c2                	add    %eax,%edx
  8005f7:	8a 45 ce             	mov    -0x32(%ebp),%al
  8005fa:	88 02                	mov    %al,(%edx)
		for (var = 0; var < numOfAccessesFor3MB/2; ++var)
		{
			sum += byteArr[indicesOf3MB[var]] ;
		}
		//4 writes
		for (var = numOfAccessesFor3MB/2; var < numOfAccessesFor3MB; ++var)
  8005fc:	ff 45 e4             	incl   -0x1c(%ebp)
  8005ff:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800603:	7e de                	jle    8005e3 <_main+0x5ab>
		{
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800605:	8b 55 8c             	mov    -0x74(%ebp),%edx
  800608:	8b 45 88             	mov    -0x78(%ebp),%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	89 c6                	mov    %eax,%esi
  80060f:	e8 6c 26 00 00       	call   802c80 <sys_calculate_free_frames>
  800614:	89 c3                	mov    %eax,%ebx
  800616:	e8 7e 26 00 00       	call   802c99 <sys_calculate_modified_frames>
  80061b:	01 d8                	add    %ebx,%eax
  80061d:	29 c6                	sub    %eax,%esi
  80061f:	89 f0                	mov    %esi,%eax
  800621:	83 f8 02             	cmp    $0x2,%eax
  800624:	74 14                	je     80063a <_main+0x602>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	68 f4 46 80 00       	push   $0x8046f4
  80062e:	6a 67                	push   $0x67
  800630:	68 01 46 80 00       	push   $0x804601
  800635:	e8 55 0f 00 00       	call   80158f <_panic>
		int found = 0;
  80063a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800641:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800648:	eb 78                	jmp    8006c2 <_main+0x68a>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80064a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800651:	eb 5d                	jmp    8006b0 <_main+0x678>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  800653:	a1 20 60 80 00       	mov    0x806020,%eax
  800658:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80065e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800661:	89 d0                	mov    %edx,%eax
  800663:	01 c0                	add    %eax,%eax
  800665:	01 d0                	add    %edx,%eax
  800667:	c1 e0 03             	shl    $0x3,%eax
  80066a:	01 c8                	add    %ecx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  800674:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80067a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80067f:	89 c2                	mov    %eax,%edx
  800681:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800684:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  80068b:	89 c1                	mov    %eax,%ecx
  80068d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800693:	01 c8                	add    %ecx,%eax
  800695:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
  80069b:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8006a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006a6:	39 c2                	cmp    %eax,%edx
  8006a8:	75 03                	jne    8006ad <_main+0x675>
				{
					found++;
  8006aa:	ff 45 d8             	incl   -0x28(%ebp)
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8006ad:	ff 45 e0             	incl   -0x20(%ebp)
  8006b0:	a1 20 60 80 00       	mov    0x806020,%eax
  8006b5:	8b 50 74             	mov    0x74(%eax),%edx
  8006b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006bb:	39 c2                	cmp    %eax,%edx
  8006bd:	77 94                	ja     800653 <_main+0x61b>
			byteArr[indicesOf3MB[var]] = maxByte ;
		}
		//check memory & WS
		if (((freeFrames+modFrames) - (sys_calculate_free_frames()+sys_calculate_modified_frames())) != 0 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		int found = 0;
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  8006bf:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c2:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8006c6:	7e 82                	jle    80064a <_main+0x612>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor3MB) panic("malloc: page is not added to WS");
  8006c8:	83 7d d8 07          	cmpl   $0x7,-0x28(%ebp)
  8006cc:	74 14                	je     8006e2 <_main+0x6aa>
  8006ce:	83 ec 04             	sub    $0x4,%esp
  8006d1:	68 38 47 80 00       	push   $0x804738
  8006d6:	6a 73                	push   $0x73
  8006d8:	68 01 46 80 00       	push   $0x804601
  8006dd:	e8 ad 0e 00 00       	call   80158f <_panic>

		/*access 8 MB*/// should bring 4 pages into WS (2 r, 2 w) and victimize 4 pages from 3 MB allocation
		freeFrames = sys_calculate_free_frames() ;
  8006e2:	e8 99 25 00 00       	call   802c80 <sys_calculate_free_frames>
  8006e7:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8006ea:	e8 aa 25 00 00       	call   802c99 <sys_calculate_modified_frames>
  8006ef:	89 45 88             	mov    %eax,-0x78(%ebp)
		lastIndexOfShort = (8*Mega-kilo)/sizeof(short) - 1;
  8006f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8006f5:	c1 e0 03             	shl    $0x3,%eax
  8006f8:	2b 45 d0             	sub    -0x30(%ebp),%eax
  8006fb:	d1 e8                	shr    %eax
  8006fd:	48                   	dec    %eax
  8006fe:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		indicesOf8MB[0] = lastIndexOfShort * 1 / 2;
  800704:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80070a:	89 c2                	mov    %eax,%edx
  80070c:	c1 ea 1f             	shr    $0x1f,%edx
  80070f:	01 d0                	add    %edx,%eax
  800711:	d1 f8                	sar    %eax
  800713:	89 85 d0 fe ff ff    	mov    %eax,-0x130(%ebp)
		indicesOf8MB[1] = lastIndexOfShort * 2 / 3;
  800719:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80071f:	01 c0                	add    %eax,%eax
  800721:	89 c1                	mov    %eax,%ecx
  800723:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800728:	f7 e9                	imul   %ecx
  80072a:	c1 f9 1f             	sar    $0x1f,%ecx
  80072d:	89 d0                	mov    %edx,%eax
  80072f:	29 c8                	sub    %ecx,%eax
  800731:	89 85 d4 fe ff ff    	mov    %eax,-0x12c(%ebp)
		indicesOf8MB[2] = lastIndexOfShort * 3 / 4;
  800737:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  80073d:	89 c2                	mov    %eax,%edx
  80073f:	01 d2                	add    %edx,%edx
  800741:	01 d0                	add    %edx,%eax
  800743:	85 c0                	test   %eax,%eax
  800745:	79 03                	jns    80074a <_main+0x712>
  800747:	83 c0 03             	add    $0x3,%eax
  80074a:	c1 f8 02             	sar    $0x2,%eax
  80074d:	89 85 d8 fe ff ff    	mov    %eax,-0x128(%ebp)
		indicesOf8MB[3] = lastIndexOfShort ;
  800753:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800759:	89 85 dc fe ff ff    	mov    %eax,-0x124(%ebp)

		//use one of the read pages from 3 MB to avoid victimizing it
		sum += byteArr[indicesOf3MB[0]] ;
  80075f:	8b 85 e0 fe ff ff    	mov    -0x120(%ebp),%eax
  800765:	89 c2                	mov    %eax,%edx
  800767:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  80076d:	01 d0                	add    %edx,%eax
  80076f:	8a 00                	mov    (%eax),%al
  800771:	0f be c0             	movsbl %al,%eax
  800774:	01 45 dc             	add    %eax,-0x24(%ebp)

		shortArr = (short *) ptr_allocations[2];
  800777:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  80077d:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		//2 reads
		sum = 0;
  800783:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  80078a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800791:	eb 20                	jmp    8007b3 <_main+0x77b>
		{
			sum += shortArr[indicesOf8MB[var]] ;
  800793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800796:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  80079d:	01 c0                	add    %eax,%eax
  80079f:	89 c2                	mov    %eax,%edx
  8007a1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007a7:	01 d0                	add    %edx,%eax
  8007a9:	66 8b 00             	mov    (%eax),%ax
  8007ac:	98                   	cwtl   
  8007ad:	01 45 dc             	add    %eax,-0x24(%ebp)
		sum += byteArr[indicesOf3MB[0]] ;

		shortArr = (short *) ptr_allocations[2];
		//2 reads
		sum = 0;
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
  8007b0:	ff 45 e4             	incl   -0x1c(%ebp)
  8007b3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8007b7:	7e da                	jle    800793 <_main+0x75b>
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007b9:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  8007c0:	eb 20                	jmp    8007e2 <_main+0x7aa>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
  8007c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007c5:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	89 c2                	mov    %eax,%edx
  8007d0:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  8007d6:	01 c2                	add    %eax,%edx
  8007d8:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  8007dc:	66 89 02             	mov    %ax,(%edx)
		for (var = 0; var < numOfAccessesFor8MB/2; ++var)
		{
			sum += shortArr[indicesOf8MB[var]] ;
		}
		//2 writes
		for (var = numOfAccessesFor8MB/2; var < numOfAccessesFor8MB; ++var)
  8007df:	ff 45 e4             	incl   -0x1c(%ebp)
  8007e2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8007e6:	7e da                	jle    8007c2 <_main+0x78a>
		{
			shortArr[indicesOf8MB[var]] = maxShort ;
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8007e8:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8007eb:	e8 90 24 00 00       	call   802c80 <sys_calculate_free_frames>
  8007f0:	29 c3                	sub    %eax,%ebx
  8007f2:	89 d8                	mov    %ebx,%eax
  8007f4:	83 f8 04             	cmp    $0x4,%eax
  8007f7:	74 17                	je     800810 <_main+0x7d8>
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	68 f4 46 80 00       	push   $0x8046f4
  800801:	68 8e 00 00 00       	push   $0x8e
  800806:	68 01 46 80 00       	push   $0x804601
  80080b:	e8 7f 0d 00 00       	call   80158f <_panic>
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800810:	8b 5d 88             	mov    -0x78(%ebp),%ebx
  800813:	e8 81 24 00 00       	call   802c99 <sys_calculate_modified_frames>
  800818:	29 c3                	sub    %eax,%ebx
  80081a:	89 d8                	mov    %ebx,%eax
  80081c:	83 f8 fe             	cmp    $0xfffffffe,%eax
  80081f:	74 17                	je     800838 <_main+0x800>
  800821:	83 ec 04             	sub    $0x4,%esp
  800824:	68 f4 46 80 00       	push   $0x8046f4
  800829:	68 8f 00 00 00       	push   $0x8f
  80082e:	68 01 46 80 00       	push   $0x804601
  800833:	e8 57 0d 00 00       	call   80158f <_panic>
		found = 0;
  800838:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  80083f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800846:	eb 7a                	jmp    8008c2 <_main+0x88a>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800848:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80084f:	eb 5f                	jmp    8008b0 <_main+0x878>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[indicesOf8MB[var]])), PAGE_SIZE))
  800851:	a1 20 60 80 00       	mov    0x806020,%eax
  800856:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80085c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80085f:	89 d0                	mov    %edx,%eax
  800861:	01 c0                	add    %eax,%eax
  800863:	01 d0                	add    %edx,%eax
  800865:	c1 e0 03             	shl    $0x3,%eax
  800868:	01 c8                	add    %ecx,%eax
  80086a:	8b 00                	mov    (%eax),%eax
  80086c:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
  800872:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  800878:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80087d:	89 c2                	mov    %eax,%edx
  80087f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800882:	8b 84 85 d0 fe ff ff 	mov    -0x130(%ebp,%eax,4),%eax
  800889:	01 c0                	add    %eax,%eax
  80088b:	89 c1                	mov    %eax,%ecx
  80088d:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800893:	01 c8                	add    %ecx,%eax
  800895:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
  80089b:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8008a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008a6:	39 c2                	cmp    %eax,%edx
  8008a8:	75 03                	jne    8008ad <_main+0x875>
				{
					found++;
  8008aa:	ff 45 d8             	incl   -0x28(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8008ad:	ff 45 e0             	incl   -0x20(%ebp)
  8008b0:	a1 20 60 80 00       	mov    0x806020,%eax
  8008b5:	8b 50 74             	mov    0x74(%eax),%edx
  8008b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	77 92                	ja     800851 <_main+0x819>
		}
		//check memory & WS
		if ((freeFrames - sys_calculate_free_frames()) != 2 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		if ((modFrames - sys_calculate_modified_frames()) != -2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < numOfAccessesFor8MB ; ++var)
  8008bf:	ff 45 e4             	incl   -0x1c(%ebp)
  8008c2:	83 7d e4 03          	cmpl   $0x3,-0x1c(%ebp)
  8008c6:	7e 80                	jle    800848 <_main+0x810>
				{
					found++;
				}
			}
		}
		if (found != numOfAccessesFor8MB) panic("malloc: page is not added to WS");
  8008c8:	83 7d d8 04          	cmpl   $0x4,-0x28(%ebp)
  8008cc:	74 17                	je     8008e5 <_main+0x8ad>
  8008ce:	83 ec 04             	sub    $0x4,%esp
  8008d1:	68 38 47 80 00       	push   $0x804738
  8008d6:	68 9b 00 00 00       	push   $0x9b
  8008db:	68 01 46 80 00       	push   $0x804601
  8008e0:	e8 aa 0c 00 00       	call   80158f <_panic>

		/* Free 3 MB */// remove 3 pages from WS, 2 from free buffer, 2 from mod buffer and 2 tables
		freeFrames = sys_calculate_free_frames() ;
  8008e5:	e8 96 23 00 00       	call   802c80 <sys_calculate_free_frames>
  8008ea:	89 45 8c             	mov    %eax,-0x74(%ebp)
		modFrames = sys_calculate_modified_frames();
  8008ed:	e8 a7 23 00 00       	call   802c99 <sys_calculate_modified_frames>
  8008f2:	89 45 88             	mov    %eax,-0x78(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8008f5:	e8 26 24 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  8008fa:	89 45 90             	mov    %eax,-0x70(%ebp)

		free(ptr_allocations[1]);
  8008fd:	8b 85 84 fe ff ff    	mov    -0x17c(%ebp),%eax
  800903:	83 ec 0c             	sub    $0xc,%esp
  800906:	50                   	push   %eax
  800907:	e8 6f 1f 00 00       	call   80287b <free>
  80090c:	83 c4 10             	add    $0x10,%esp

		//check page file
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
  80090f:	e8 0c 24 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800914:	8b 55 90             	mov    -0x70(%ebp),%edx
  800917:	89 d1                	mov    %edx,%ecx
  800919:	29 c1                	sub    %eax,%ecx
  80091b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80091e:	89 c2                	mov    %eax,%edx
  800920:	01 d2                	add    %edx,%edx
  800922:	01 d0                	add    %edx,%eax
  800924:	85 c0                	test   %eax,%eax
  800926:	79 05                	jns    80092d <_main+0x8f5>
  800928:	05 ff 0f 00 00       	add    $0xfff,%eax
  80092d:	c1 f8 0c             	sar    $0xc,%eax
  800930:	39 c1                	cmp    %eax,%ecx
  800932:	74 17                	je     80094b <_main+0x913>
  800934:	83 ec 04             	sub    $0x4,%esp
  800937:	68 58 47 80 00       	push   $0x804758
  80093c:	68 a5 00 00 00       	push   $0xa5
  800941:	68 01 46 80 00       	push   $0x804601
  800946:	e8 44 0c 00 00       	call   80158f <_panic>
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
  80094b:	e8 30 23 00 00       	call   802c80 <sys_calculate_free_frames>
  800950:	89 c2                	mov    %eax,%edx
  800952:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800955:	29 c2                	sub    %eax,%edx
  800957:	89 d0                	mov    %edx,%eax
  800959:	83 f8 07             	cmp    $0x7,%eax
  80095c:	74 17                	je     800975 <_main+0x93d>
  80095e:	83 ec 04             	sub    $0x4,%esp
  800961:	68 94 47 80 00       	push   $0x804794
  800966:	68 a7 00 00 00       	push   $0xa7
  80096b:	68 01 46 80 00       	push   $0x804601
  800970:	e8 1a 0c 00 00       	call   80158f <_panic>
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
  800975:	e8 1f 23 00 00       	call   802c99 <sys_calculate_modified_frames>
  80097a:	89 c2                	mov    %eax,%edx
  80097c:	8b 45 88             	mov    -0x78(%ebp),%eax
  80097f:	29 c2                	sub    %eax,%edx
  800981:	89 d0                	mov    %edx,%eax
  800983:	83 f8 02             	cmp    $0x2,%eax
  800986:	74 17                	je     80099f <_main+0x967>
  800988:	83 ec 04             	sub    $0x4,%esp
  80098b:	68 e8 47 80 00       	push   $0x8047e8
  800990:	68 a8 00 00 00       	push   $0xa8
  800995:	68 01 46 80 00       	push   $0x804601
  80099a:	e8 f0 0b 00 00       	call   80158f <_panic>
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  80099f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8009a6:	e9 8c 00 00 00       	jmp    800a37 <_main+0x9ff>
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8009ab:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b2:	eb 71                	jmp    800a25 <_main+0x9ed>
			{
				if(ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr[indicesOf3MB[var]])), PAGE_SIZE))
  8009b4:	a1 20 60 80 00       	mov    0x806020,%eax
  8009b9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c2:	89 d0                	mov    %edx,%eax
  8009c4:	01 c0                	add    %eax,%eax
  8009c6:	01 d0                	add    %edx,%eax
  8009c8:	c1 e0 03             	shl    $0x3,%eax
  8009cb:	01 c8                	add    %ecx,%eax
  8009cd:	8b 00                	mov    (%eax),%eax
  8009cf:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  8009d5:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8009db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009e0:	89 c2                	mov    %eax,%edx
  8009e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8009e5:	8b 84 85 e0 fe ff ff 	mov    -0x120(%ebp,%eax,4),%eax
  8009ec:	89 c1                	mov    %eax,%ecx
  8009ee:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8009f4:	01 c8                	add    %ecx,%eax
  8009f6:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  8009fc:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800a02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800a07:	39 c2                	cmp    %eax,%edx
  800a09:	75 17                	jne    800a22 <_main+0x9ea>
				{
					panic("free: page is not removed from WS");
  800a0b:	83 ec 04             	sub    $0x4,%esp
  800a0e:	68 20 48 80 00       	push   $0x804820
  800a13:	68 b0 00 00 00       	push   $0xb0
  800a18:	68 01 46 80 00       	push   $0x804601
  800a1d:	e8 6d 0b 00 00       	call   80158f <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
		{
			for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  800a22:	ff 45 e0             	incl   -0x20(%ebp)
  800a25:	a1 20 60 80 00       	mov    0x806020,%eax
  800a2a:	8b 50 74             	mov    0x74(%eax),%edx
  800a2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a30:	39 c2                	cmp    %eax,%edx
  800a32:	77 80                	ja     8009b4 <_main+0x97c>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 3*Mega/PAGE_SIZE) panic("Wrong free: Extra or less pages are removed from PageFile");
		//check memory and buffers
		if ((sys_calculate_free_frames() - freeFrames) != 3 + 2 + 2) panic("Wrong free: WS pages in memory, buffers and/or page tables are not freed correctly");
		if ((sys_calculate_modified_frames() - modFrames) != 2) panic("Wrong free: pages mod buffers are not freed correctly");
		//check WS
		for (var = 0; var < numOfAccessesFor3MB ; ++var)
  800a34:	ff 45 e4             	incl   -0x1c(%ebp)
  800a37:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  800a3b:	0f 8e 6a ff ff ff    	jle    8009ab <_main+0x973>
			}
		}



		freeFrames = sys_calculate_free_frames() ;
  800a41:	e8 3a 22 00 00       	call   802c80 <sys_calculate_free_frames>
  800a46:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr = (short *) ptr_allocations[2];
  800a49:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800a4f:	89 85 6c ff ff ff    	mov    %eax,-0x94(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  800a55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800a58:	01 c0                	add    %eax,%eax
  800a5a:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800a5d:	d1 e8                	shr    %eax
  800a5f:	48                   	dec    %eax
  800a60:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
		shortArr[0] = minShort;
  800a66:	8b 95 6c ff ff ff    	mov    -0x94(%ebp),%edx
  800a6c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a6f:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800a72:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800a78:	01 c0                	add    %eax,%eax
  800a7a:	89 c2                	mov    %eax,%edx
  800a7c:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800a82:	01 c2                	add    %eax,%edx
  800a84:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  800a88:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800a8b:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800a8e:	e8 ed 21 00 00       	call   802c80 <sys_calculate_free_frames>
  800a93:	29 c3                	sub    %eax,%ebx
  800a95:	89 d8                	mov    %ebx,%eax
  800a97:	83 f8 02             	cmp    $0x2,%eax
  800a9a:	74 17                	je     800ab3 <_main+0xa7b>
  800a9c:	83 ec 04             	sub    $0x4,%esp
  800a9f:	68 f4 46 80 00       	push   $0x8046f4
  800aa4:	68 bc 00 00 00       	push   $0xbc
  800aa9:	68 01 46 80 00       	push   $0x804601
  800aae:	e8 dc 0a 00 00       	call   80158f <_panic>
		found = 0;
  800ab3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800aba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ac1:	e9 a7 00 00 00       	jmp    800b6d <_main+0xb35>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
  800ac6:	a1 20 60 80 00       	mov    0x806020,%eax
  800acb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800ad1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ad4:	89 d0                	mov    %edx,%eax
  800ad6:	01 c0                	add    %eax,%eax
  800ad8:	01 d0                	add    %edx,%eax
  800ada:	c1 e0 03             	shl    $0x3,%eax
  800add:	01 c8                	add    %ecx,%eax
  800adf:	8b 00                	mov    (%eax),%eax
  800ae1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
  800ae7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  800aed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800af2:	89 c2                	mov    %eax,%edx
  800af4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800afa:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800b00:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  800b06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b0b:	39 c2                	cmp    %eax,%edx
  800b0d:	75 03                	jne    800b12 <_main+0xada>
				found++;
  800b0f:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
  800b12:	a1 20 60 80 00       	mov    0x806020,%eax
  800b17:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b20:	89 d0                	mov    %edx,%eax
  800b22:	01 c0                	add    %eax,%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	c1 e0 03             	shl    $0x3,%eax
  800b29:	01 c8                	add    %ecx,%eax
  800b2b:	8b 00                	mov    (%eax),%eax
  800b2d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
  800b33:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800b39:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b3e:	89 c2                	mov    %eax,%edx
  800b40:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
  800b46:	01 c0                	add    %eax,%eax
  800b48:	89 c1                	mov    %eax,%ecx
  800b4a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
  800b50:	01 c8                	add    %ecx,%eax
  800b52:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
  800b58:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  800b5e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b63:	39 c2                	cmp    %eax,%edx
  800b65:	75 03                	jne    800b6a <_main+0xb32>
				found++;
  800b67:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
		shortArr[0] = minShort;
		shortArr[lastIndexOfShort] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2 ) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800b6a:	ff 45 e4             	incl   -0x1c(%ebp)
  800b6d:	a1 20 60 80 00       	mov    0x806020,%eax
  800b72:	8b 50 74             	mov    0x74(%eax),%edx
  800b75:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b78:	39 c2                	cmp    %eax,%edx
  800b7a:	0f 87 46 ff ff ff    	ja     800ac6 <_main+0xa8e>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr[lastIndexOfShort])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800b80:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800b84:	74 17                	je     800b9d <_main+0xb65>
  800b86:	83 ec 04             	sub    $0x4,%esp
  800b89:	68 38 47 80 00       	push   $0x804738
  800b8e:	68 c5 00 00 00       	push   $0xc5
  800b93:	68 01 46 80 00       	push   $0x804601
  800b98:	e8 f2 09 00 00       	call   80158f <_panic>

		//2 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800b9d:	e8 7e 21 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800ba2:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  800ba5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ba8:	01 c0                	add    %eax,%eax
  800baa:	83 ec 0c             	sub    $0xc,%esp
  800bad:	50                   	push   %eax
  800bae:	e8 2f 1c 00 00       	call   8027e2 <malloc>
  800bb3:	83 c4 10             	add    $0x10,%esp
  800bb6:	89 85 88 fe ff ff    	mov    %eax,-0x178(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START+ 4*Mega+PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800bbc:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bc2:	89 c2                	mov    %eax,%edx
  800bc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bc7:	c1 e0 02             	shl    $0x2,%eax
  800bca:	05 00 00 00 80       	add    $0x80000000,%eax
  800bcf:	39 c2                	cmp    %eax,%edx
  800bd1:	72 17                	jb     800bea <_main+0xbb2>
  800bd3:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800bd9:	89 c2                	mov    %eax,%edx
  800bdb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bde:	c1 e0 02             	shl    $0x2,%eax
  800be1:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800be6:	39 c2                	cmp    %eax,%edx
  800be8:	76 17                	jbe    800c01 <_main+0xbc9>
  800bea:	83 ec 04             	sub    $0x4,%esp
  800bed:	68 5c 46 80 00       	push   $0x80465c
  800bf2:	68 ca 00 00 00       	push   $0xca
  800bf7:	68 01 46 80 00       	push   $0x804601
  800bfc:	e8 8e 09 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800c01:	e8 1a 21 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800c06:	2b 45 90             	sub    -0x70(%ebp),%eax
  800c09:	83 f8 01             	cmp    $0x1,%eax
  800c0c:	74 17                	je     800c25 <_main+0xbed>
  800c0e:	83 ec 04             	sub    $0x4,%esp
  800c11:	68 c4 46 80 00       	push   $0x8046c4
  800c16:	68 cb 00 00 00       	push   $0xcb
  800c1b:	68 01 46 80 00       	push   $0x804601
  800c20:	e8 6a 09 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800c25:	e8 56 20 00 00       	call   802c80 <sys_calculate_free_frames>
  800c2a:	89 45 8c             	mov    %eax,-0x74(%ebp)
		intArr = (int *) ptr_allocations[2];
  800c2d:	8b 85 88 fe ff ff    	mov    -0x178(%ebp),%eax
  800c33:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
  800c39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c3c:	01 c0                	add    %eax,%eax
  800c3e:	c1 e8 02             	shr    $0x2,%eax
  800c41:	48                   	dec    %eax
  800c42:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
		intArr[0] = minInt;
  800c48:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800c51:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  800c53:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800c59:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c60:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c66:	01 c2                	add    %eax,%edx
  800c68:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800c6b:	89 02                	mov    %eax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  800c6d:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  800c70:	e8 0b 20 00 00       	call   802c80 <sys_calculate_free_frames>
  800c75:	29 c3                	sub    %eax,%ebx
  800c77:	89 d8                	mov    %ebx,%eax
  800c79:	83 f8 02             	cmp    $0x2,%eax
  800c7c:	74 17                	je     800c95 <_main+0xc5d>
  800c7e:	83 ec 04             	sub    $0x4,%esp
  800c81:	68 f4 46 80 00       	push   $0x8046f4
  800c86:	68 d2 00 00 00       	push   $0xd2
  800c8b:	68 01 46 80 00       	push   $0x804601
  800c90:	e8 fa 08 00 00       	call   80158f <_panic>
		found = 0;
  800c95:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800c9c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ca3:	e9 aa 00 00 00       	jmp    800d52 <_main+0xd1a>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
  800ca8:	a1 20 60 80 00       	mov    0x806020,%eax
  800cad:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800cb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	01 c0                	add    %eax,%eax
  800cba:	01 d0                	add    %edx,%eax
  800cbc:	c1 e0 03             	shl    $0x3,%eax
  800cbf:	01 c8                	add    %ecx,%eax
  800cc1:	8b 00                	mov    (%eax),%eax
  800cc3:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  800cc9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800ccf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800cd4:	89 c2                	mov    %eax,%edx
  800cd6:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800cdc:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  800ce2:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800ce8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ced:	39 c2                	cmp    %eax,%edx
  800cef:	75 03                	jne    800cf4 <_main+0xcbc>
				found++;
  800cf1:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
  800cf4:	a1 20 60 80 00       	mov    0x806020,%eax
  800cf9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800cff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800d02:	89 d0                	mov    %edx,%eax
  800d04:	01 c0                	add    %eax,%eax
  800d06:	01 d0                	add    %edx,%eax
  800d08:	c1 e0 03             	shl    $0x3,%eax
  800d0b:	01 c8                	add    %ecx,%eax
  800d0d:	8b 00                	mov    (%eax),%eax
  800d0f:	89 85 38 ff ff ff    	mov    %eax,-0xc8(%ebp)
  800d15:	8b 85 38 ff ff ff    	mov    -0xc8(%ebp),%eax
  800d1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d20:	89 c2                	mov    %eax,%edx
  800d22:	8b 85 44 ff ff ff    	mov    -0xbc(%ebp),%eax
  800d28:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800d2f:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800d35:	01 c8                	add    %ecx,%eax
  800d37:	89 85 34 ff ff ff    	mov    %eax,-0xcc(%ebp)
  800d3d:	8b 85 34 ff ff ff    	mov    -0xcc(%ebp),%eax
  800d43:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800d48:	39 c2                	cmp    %eax,%edx
  800d4a:	75 03                	jne    800d4f <_main+0xd17>
				found++;
  800d4c:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfInt = (2*kilo)/sizeof(int) - 1;
		intArr[0] = minInt;
		intArr[lastIndexOfInt] = maxInt;
		if ((freeFrames - sys_calculate_free_frames()) != 1 + 1) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  800d4f:	ff 45 e4             	incl   -0x1c(%ebp)
  800d52:	a1 20 60 80 00       	mov    0x806020,%eax
  800d57:	8b 50 74             	mov    0x74(%eax),%edx
  800d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800d5d:	39 c2                	cmp    %eax,%edx
  800d5f:	0f 87 43 ff ff ff    	ja     800ca8 <_main+0xc70>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(intArr[lastIndexOfInt])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  800d65:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  800d69:	74 17                	je     800d82 <_main+0xd4a>
  800d6b:	83 ec 04             	sub    $0x4,%esp
  800d6e:	68 38 47 80 00       	push   $0x804738
  800d73:	68 db 00 00 00       	push   $0xdb
  800d78:	68 01 46 80 00       	push   $0x804601
  800d7d:	e8 0d 08 00 00       	call   80158f <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800d82:	e8 f9 1e 00 00       	call   802c80 <sys_calculate_free_frames>
  800d87:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d8a:	e8 91 1f 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800d8f:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800d92:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d95:	01 c0                	add    %eax,%eax
  800d97:	83 ec 0c             	sub    $0xc,%esp
  800d9a:	50                   	push   %eax
  800d9b:	e8 42 1a 00 00       	call   8027e2 <malloc>
  800da0:	83 c4 10             	add    $0x10,%esp
  800da3:	89 85 8c fe ff ff    	mov    %eax,-0x174(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START+ 4*Mega + 4*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800da9:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800daf:	89 c2                	mov    %eax,%edx
  800db1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800db4:	c1 e0 02             	shl    $0x2,%eax
  800db7:	89 c1                	mov    %eax,%ecx
  800db9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800dbc:	c1 e0 02             	shl    $0x2,%eax
  800dbf:	01 c8                	add    %ecx,%eax
  800dc1:	05 00 00 00 80       	add    $0x80000000,%eax
  800dc6:	39 c2                	cmp    %eax,%edx
  800dc8:	72 21                	jb     800deb <_main+0xdb3>
  800dca:	8b 85 8c fe ff ff    	mov    -0x174(%ebp),%eax
  800dd0:	89 c2                	mov    %eax,%edx
  800dd2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dd5:	c1 e0 02             	shl    $0x2,%eax
  800dd8:	89 c1                	mov    %eax,%ecx
  800dda:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ddd:	c1 e0 02             	shl    $0x2,%eax
  800de0:	01 c8                	add    %ecx,%eax
  800de2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800de7:	39 c2                	cmp    %eax,%edx
  800de9:	76 17                	jbe    800e02 <_main+0xdca>
  800deb:	83 ec 04             	sub    $0x4,%esp
  800dee:	68 5c 46 80 00       	push   $0x80465c
  800df3:	68 e1 00 00 00       	push   $0xe1
  800df8:	68 01 46 80 00       	push   $0x804601
  800dfd:	e8 8d 07 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 1) panic("Extra or less pages are allocated in PageFile");
  800e02:	e8 19 1f 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800e07:	2b 45 90             	sub    -0x70(%ebp),%eax
  800e0a:	83 f8 01             	cmp    $0x1,%eax
  800e0d:	74 17                	je     800e26 <_main+0xdee>
  800e0f:	83 ec 04             	sub    $0x4,%esp
  800e12:	68 c4 46 80 00       	push   $0x8046c4
  800e17:	68 e2 00 00 00       	push   $0xe2
  800e1c:	68 01 46 80 00       	push   $0x804601
  800e21:	e8 69 07 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//7 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e26:	e8 f5 1e 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800e2b:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800e2e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e31:	89 d0                	mov    %edx,%eax
  800e33:	01 c0                	add    %eax,%eax
  800e35:	01 d0                	add    %edx,%eax
  800e37:	01 c0                	add    %eax,%eax
  800e39:	01 d0                	add    %edx,%eax
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	50                   	push   %eax
  800e3f:	e8 9e 19 00 00       	call   8027e2 <malloc>
  800e44:	83 c4 10             	add    $0x10,%esp
  800e47:	89 85 90 fe ff ff    	mov    %eax,-0x170(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo)|| (uint32) ptr_allocations[4] > (USER_HEAP_START+ 4*Mega + 8*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800e4d:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e53:	89 c2                	mov    %eax,%edx
  800e55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e58:	c1 e0 02             	shl    $0x2,%eax
  800e5b:	89 c1                	mov    %eax,%ecx
  800e5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e60:	c1 e0 03             	shl    $0x3,%eax
  800e63:	01 c8                	add    %ecx,%eax
  800e65:	05 00 00 00 80       	add    $0x80000000,%eax
  800e6a:	39 c2                	cmp    %eax,%edx
  800e6c:	72 21                	jb     800e8f <_main+0xe57>
  800e6e:	8b 85 90 fe ff ff    	mov    -0x170(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e79:	c1 e0 02             	shl    $0x2,%eax
  800e7c:	89 c1                	mov    %eax,%ecx
  800e7e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e81:	c1 e0 03             	shl    $0x3,%eax
  800e84:	01 c8                	add    %ecx,%eax
  800e86:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800e8b:	39 c2                	cmp    %eax,%edx
  800e8d:	76 17                	jbe    800ea6 <_main+0xe6e>
  800e8f:	83 ec 04             	sub    $0x4,%esp
  800e92:	68 5c 46 80 00       	push   $0x80465c
  800e97:	68 e8 00 00 00       	push   $0xe8
  800e9c:	68 01 46 80 00       	push   $0x804601
  800ea1:	e8 e9 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 2) panic("Extra or less pages are allocated in PageFile");
  800ea6:	e8 75 1e 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800eab:	2b 45 90             	sub    -0x70(%ebp),%eax
  800eae:	83 f8 02             	cmp    $0x2,%eax
  800eb1:	74 17                	je     800eca <_main+0xe92>
  800eb3:	83 ec 04             	sub    $0x4,%esp
  800eb6:	68 c4 46 80 00       	push   $0x8046c4
  800ebb:	68 e9 00 00 00       	push   $0xe9
  800ec0:	68 01 46 80 00       	push   $0x804601
  800ec5:	e8 c5 06 00 00       	call   80158f <_panic>


		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800eca:	e8 b1 1d 00 00       	call   802c80 <sys_calculate_free_frames>
  800ecf:	89 45 8c             	mov    %eax,-0x74(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800ed2:	e8 49 1e 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800ed7:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  800eda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800edd:	89 c2                	mov    %eax,%edx
  800edf:	01 d2                	add    %edx,%edx
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800ee6:	83 ec 0c             	sub    $0xc,%esp
  800ee9:	50                   	push   %eax
  800eea:	e8 f3 18 00 00       	call   8027e2 <malloc>
  800eef:	83 c4 10             	add    $0x10,%esp
  800ef2:	89 85 94 fe ff ff    	mov    %eax,-0x16c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START+ 4*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800ef8:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800efe:	89 c2                	mov    %eax,%edx
  800f00:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f03:	c1 e0 02             	shl    $0x2,%eax
  800f06:	89 c1                	mov    %eax,%ecx
  800f08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f0b:	c1 e0 04             	shl    $0x4,%eax
  800f0e:	01 c8                	add    %ecx,%eax
  800f10:	05 00 00 00 80       	add    $0x80000000,%eax
  800f15:	39 c2                	cmp    %eax,%edx
  800f17:	72 21                	jb     800f3a <_main+0xf02>
  800f19:	8b 85 94 fe ff ff    	mov    -0x16c(%ebp),%eax
  800f1f:	89 c2                	mov    %eax,%edx
  800f21:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f24:	c1 e0 02             	shl    $0x2,%eax
  800f27:	89 c1                	mov    %eax,%ecx
  800f29:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800f2c:	c1 e0 04             	shl    $0x4,%eax
  800f2f:	01 c8                	add    %ecx,%eax
  800f31:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800f36:	39 c2                	cmp    %eax,%edx
  800f38:	76 17                	jbe    800f51 <_main+0xf19>
  800f3a:	83 ec 04             	sub    $0x4,%esp
  800f3d:	68 5c 46 80 00       	push   $0x80465c
  800f42:	68 f0 00 00 00       	push   $0xf0
  800f47:	68 01 46 80 00       	push   $0x804601
  800f4c:	e8 3e 06 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 3*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  800f51:	e8 ca 1d 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800f56:	2b 45 90             	sub    -0x70(%ebp),%eax
  800f59:	89 c2                	mov    %eax,%edx
  800f5b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f5e:	89 c1                	mov    %eax,%ecx
  800f60:	01 c9                	add    %ecx,%ecx
  800f62:	01 c8                	add    %ecx,%eax
  800f64:	85 c0                	test   %eax,%eax
  800f66:	79 05                	jns    800f6d <_main+0xf35>
  800f68:	05 ff 0f 00 00       	add    $0xfff,%eax
  800f6d:	c1 f8 0c             	sar    $0xc,%eax
  800f70:	39 c2                	cmp    %eax,%edx
  800f72:	74 17                	je     800f8b <_main+0xf53>
  800f74:	83 ec 04             	sub    $0x4,%esp
  800f77:	68 c4 46 80 00       	push   $0x8046c4
  800f7c:	68 f1 00 00 00       	push   $0xf1
  800f81:	68 01 46 80 00       	push   $0x804601
  800f86:	e8 04 06 00 00       	call   80158f <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: ");

		//6 MB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8b:	e8 90 1d 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  800f90:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[6] = malloc(6*Mega-kilo);
  800f93:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f96:	89 d0                	mov    %edx,%eax
  800f98:	01 c0                	add    %eax,%eax
  800f9a:	01 d0                	add    %edx,%eax
  800f9c:	01 c0                	add    %eax,%eax
  800f9e:	2b 45 d0             	sub    -0x30(%ebp),%eax
  800fa1:	83 ec 0c             	sub    $0xc,%esp
  800fa4:	50                   	push   %eax
  800fa5:	e8 38 18 00 00       	call   8027e2 <malloc>
  800faa:	83 c4 10             	add    $0x10,%esp
  800fad:	89 85 98 fe ff ff    	mov    %eax,-0x168(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START+ 7*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  800fb3:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fb9:	89 c1                	mov    %eax,%ecx
  800fbb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	01 c0                	add    %eax,%eax
  800fc2:	01 d0                	add    %edx,%eax
  800fc4:	01 c0                	add    %eax,%eax
  800fc6:	01 d0                	add    %edx,%eax
  800fc8:	89 c2                	mov    %eax,%edx
  800fca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800fcd:	c1 e0 04             	shl    $0x4,%eax
  800fd0:	01 d0                	add    %edx,%eax
  800fd2:	05 00 00 00 80       	add    $0x80000000,%eax
  800fd7:	39 c1                	cmp    %eax,%ecx
  800fd9:	72 28                	jb     801003 <_main+0xfcb>
  800fdb:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  800fe1:	89 c1                	mov    %eax,%ecx
  800fe3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fe6:	89 d0                	mov    %edx,%eax
  800fe8:	01 c0                	add    %eax,%eax
  800fea:	01 d0                	add    %edx,%eax
  800fec:	01 c0                	add    %eax,%eax
  800fee:	01 d0                	add    %edx,%eax
  800ff0:	89 c2                	mov    %eax,%edx
  800ff2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800ff5:	c1 e0 04             	shl    $0x4,%eax
  800ff8:	01 d0                	add    %edx,%eax
  800ffa:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800fff:	39 c1                	cmp    %eax,%ecx
  801001:	76 17                	jbe    80101a <_main+0xfe2>
  801003:	83 ec 04             	sub    $0x4,%esp
  801006:	68 5c 46 80 00       	push   $0x80465c
  80100b:	68 f7 00 00 00       	push   $0xf7
  801010:	68 01 46 80 00       	push   $0x804601
  801015:	e8 75 05 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 6*Mega/4096) panic("Extra or less pages are allocated in PageFile");
  80101a:	e8 01 1d 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  80101f:	2b 45 90             	sub    -0x70(%ebp),%eax
  801022:	89 c1                	mov    %eax,%ecx
  801024:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801027:	89 d0                	mov    %edx,%eax
  801029:	01 c0                	add    %eax,%eax
  80102b:	01 d0                	add    %edx,%eax
  80102d:	01 c0                	add    %eax,%eax
  80102f:	85 c0                	test   %eax,%eax
  801031:	79 05                	jns    801038 <_main+0x1000>
  801033:	05 ff 0f 00 00       	add    $0xfff,%eax
  801038:	c1 f8 0c             	sar    $0xc,%eax
  80103b:	39 c1                	cmp    %eax,%ecx
  80103d:	74 17                	je     801056 <_main+0x101e>
  80103f:	83 ec 04             	sub    $0x4,%esp
  801042:	68 c4 46 80 00       	push   $0x8046c4
  801047:	68 f8 00 00 00       	push   $0xf8
  80104c:	68 01 46 80 00       	push   $0x804601
  801051:	e8 39 05 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  801056:	e8 25 1c 00 00       	call   802c80 <sys_calculate_free_frames>
  80105b:	89 45 8c             	mov    %eax,-0x74(%ebp)
		lastIndexOfByte2 = (6*Mega-kilo)/sizeof(char) - 1;
  80105e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801061:	89 d0                	mov    %edx,%eax
  801063:	01 c0                	add    %eax,%eax
  801065:	01 d0                	add    %edx,%eax
  801067:	01 c0                	add    %eax,%eax
  801069:	2b 45 d0             	sub    -0x30(%ebp),%eax
  80106c:	48                   	dec    %eax
  80106d:	89 85 30 ff ff ff    	mov    %eax,-0xd0(%ebp)
		byteArr2 = (char *) ptr_allocations[6];
  801073:	8b 85 98 fe ff ff    	mov    -0x168(%ebp),%eax
  801079:	89 85 2c ff ff ff    	mov    %eax,-0xd4(%ebp)
		byteArr2[0] = minByte ;
  80107f:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801085:	8a 55 cf             	mov    -0x31(%ebp),%dl
  801088:	88 10                	mov    %dl,(%eax)
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
  80108a:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  801090:	89 c2                	mov    %eax,%edx
  801092:	c1 ea 1f             	shr    $0x1f,%edx
  801095:	01 d0                	add    %edx,%eax
  801097:	d1 f8                	sar    %eax
  801099:	89 c2                	mov    %eax,%edx
  80109b:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010a1:	01 c2                	add    %eax,%edx
  8010a3:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010a6:	88 c1                	mov    %al,%cl
  8010a8:	c0 e9 07             	shr    $0x7,%cl
  8010ab:	01 c8                	add    %ecx,%eax
  8010ad:	d0 f8                	sar    %al
  8010af:	88 02                	mov    %al,(%edx)
		byteArr2[lastIndexOfByte2] = maxByte ;
  8010b1:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8010b7:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8010bd:	01 c2                	add    %eax,%edx
  8010bf:	8a 45 ce             	mov    -0x32(%ebp),%al
  8010c2:	88 02                	mov    %al,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  8010c4:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  8010c7:	e8 b4 1b 00 00       	call   802c80 <sys_calculate_free_frames>
  8010cc:	29 c3                	sub    %eax,%ebx
  8010ce:	89 d8                	mov    %ebx,%eax
  8010d0:	83 f8 05             	cmp    $0x5,%eax
  8010d3:	74 17                	je     8010ec <_main+0x10b4>
  8010d5:	83 ec 04             	sub    $0x4,%esp
  8010d8:	68 f4 46 80 00       	push   $0x8046f4
  8010dd:	68 00 01 00 00       	push   $0x100
  8010e2:	68 01 46 80 00       	push   $0x804601
  8010e7:	e8 a3 04 00 00       	call   80158f <_panic>
		found = 0;
  8010ec:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8010f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8010fa:	e9 02 01 00 00       	jmp    801201 <_main+0x11c9>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[0])), PAGE_SIZE))
  8010ff:	a1 20 60 80 00       	mov    0x806020,%eax
  801104:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80110a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80110d:	89 d0                	mov    %edx,%eax
  80110f:	01 c0                	add    %eax,%eax
  801111:	01 d0                	add    %edx,%eax
  801113:	c1 e0 03             	shl    $0x3,%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8b 00                	mov    (%eax),%eax
  80111a:	89 85 28 ff ff ff    	mov    %eax,-0xd8(%ebp)
  801120:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
  801126:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80112b:	89 c2                	mov    %eax,%edx
  80112d:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801133:	89 85 24 ff ff ff    	mov    %eax,-0xdc(%ebp)
  801139:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
  80113f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801144:	39 c2                	cmp    %eax,%edx
  801146:	75 03                	jne    80114b <_main+0x1113>
				found++;
  801148:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
  80114b:	a1 20 60 80 00       	mov    0x806020,%eax
  801150:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801156:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801159:	89 d0                	mov    %edx,%eax
  80115b:	01 c0                	add    %eax,%eax
  80115d:	01 d0                	add    %edx,%eax
  80115f:	c1 e0 03             	shl    $0x3,%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8b 00                	mov    (%eax),%eax
  801166:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)
  80116c:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
  801172:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801177:	89 c2                	mov    %eax,%edx
  801179:	8b 85 30 ff ff ff    	mov    -0xd0(%ebp),%eax
  80117f:	89 c1                	mov    %eax,%ecx
  801181:	c1 e9 1f             	shr    $0x1f,%ecx
  801184:	01 c8                	add    %ecx,%eax
  801186:	d1 f8                	sar    %eax
  801188:	89 c1                	mov    %eax,%ecx
  80118a:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  801190:	01 c8                	add    %ecx,%eax
  801192:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
  801198:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
  80119e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011a3:	39 c2                	cmp    %eax,%edx
  8011a5:	75 03                	jne    8011aa <_main+0x1172>
				found++;
  8011a7:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
  8011aa:	a1 20 60 80 00       	mov    0x806020,%eax
  8011af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8011b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8011b8:	89 d0                	mov    %edx,%eax
  8011ba:	01 c0                	add    %eax,%eax
  8011bc:	01 d0                	add    %edx,%eax
  8011be:	c1 e0 03             	shl    $0x3,%eax
  8011c1:	01 c8                	add    %ecx,%eax
  8011c3:	8b 00                	mov    (%eax),%eax
  8011c5:	89 85 18 ff ff ff    	mov    %eax,-0xe8(%ebp)
  8011cb:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
  8011d1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011d6:	89 c1                	mov    %eax,%ecx
  8011d8:	8b 95 30 ff ff ff    	mov    -0xd0(%ebp),%edx
  8011de:	8b 85 2c ff ff ff    	mov    -0xd4(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	89 85 14 ff ff ff    	mov    %eax,-0xec(%ebp)
  8011ec:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
  8011f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011f7:	39 c1                	cmp    %eax,%ecx
  8011f9:	75 03                	jne    8011fe <_main+0x11c6>
				found++;
  8011fb:	ff 45 d8             	incl   -0x28(%ebp)
		byteArr2[0] = minByte ;
		byteArr2[lastIndexOfByte2 / 2] = maxByte / 2;
		byteArr2[lastIndexOfByte2] = maxByte ;
		if ((freeFrames - sys_calculate_free_frames()) != 3 + 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  8011fe:	ff 45 e4             	incl   -0x1c(%ebp)
  801201:	a1 20 60 80 00       	mov    0x806020,%eax
  801206:	8b 50 74             	mov    0x74(%eax),%edx
  801209:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80120c:	39 c2                	cmp    %eax,%edx
  80120e:	0f 87 eb fe ff ff    	ja     8010ff <_main+0x10c7>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2/2])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(byteArr2[lastIndexOfByte2])), PAGE_SIZE))
				found++;
		}
		if (found != 3) panic("malloc: page is not added to WS");
  801214:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
  801218:	74 17                	je     801231 <_main+0x11f9>
  80121a:	83 ec 04             	sub    $0x4,%esp
  80121d:	68 38 47 80 00       	push   $0x804738
  801222:	68 0b 01 00 00       	push   $0x10b
  801227:	68 01 46 80 00       	push   $0x804601
  80122c:	e8 5e 03 00 00       	call   80158f <_panic>

		//14 KB
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801231:	e8 ea 1a 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  801236:	89 45 90             	mov    %eax,-0x70(%ebp)
		ptr_allocations[7] = malloc(14*kilo);
  801239:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80123c:	89 d0                	mov    %edx,%eax
  80123e:	01 c0                	add    %eax,%eax
  801240:	01 d0                	add    %edx,%eax
  801242:	01 c0                	add    %eax,%eax
  801244:	01 d0                	add    %edx,%eax
  801246:	01 c0                	add    %eax,%eax
  801248:	83 ec 0c             	sub    $0xc,%esp
  80124b:	50                   	push   %eax
  80124c:	e8 91 15 00 00       	call   8027e2 <malloc>
  801251:	83 c4 10             	add    $0x10,%esp
  801254:	89 85 9c fe ff ff    	mov    %eax,-0x164(%ebp)
		if ((uint32) ptr_allocations[7] < (USER_HEAP_START + 13*Mega + 16*kilo)|| (uint32) ptr_allocations[7] > (USER_HEAP_START+ 13*Mega + 16*kilo +PAGE_SIZE)) panic("Wrong start address for the allocated space... check return address of malloc & updating of heap ptr");
  80125a:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801260:	89 c1                	mov    %eax,%ecx
  801262:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  801265:	89 d0                	mov    %edx,%eax
  801267:	01 c0                	add    %eax,%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c1 e0 02             	shl    $0x2,%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	89 c2                	mov    %eax,%edx
  801272:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801275:	c1 e0 04             	shl    $0x4,%eax
  801278:	01 d0                	add    %edx,%eax
  80127a:	05 00 00 00 80       	add    $0x80000000,%eax
  80127f:	39 c1                	cmp    %eax,%ecx
  801281:	72 29                	jb     8012ac <_main+0x1274>
  801283:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  801289:	89 c1                	mov    %eax,%ecx
  80128b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80128e:	89 d0                	mov    %edx,%eax
  801290:	01 c0                	add    %eax,%eax
  801292:	01 d0                	add    %edx,%eax
  801294:	c1 e0 02             	shl    $0x2,%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	89 c2                	mov    %eax,%edx
  80129b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80129e:	c1 e0 04             	shl    $0x4,%eax
  8012a1:	01 d0                	add    %edx,%eax
  8012a3:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8012a8:	39 c1                	cmp    %eax,%ecx
  8012aa:	76 17                	jbe    8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 5c 46 80 00       	push   $0x80465c
  8012b4:	68 10 01 00 00       	push   $0x110
  8012b9:	68 01 46 80 00       	push   $0x804601
  8012be:	e8 cc 02 00 00       	call   80158f <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 4) panic("Extra or less pages are allocated in PageFile");
  8012c3:	e8 58 1a 00 00       	call   802d20 <sys_pf_calculate_allocated_pages>
  8012c8:	2b 45 90             	sub    -0x70(%ebp),%eax
  8012cb:	83 f8 04             	cmp    $0x4,%eax
  8012ce:	74 17                	je     8012e7 <_main+0x12af>
  8012d0:	83 ec 04             	sub    $0x4,%esp
  8012d3:	68 c4 46 80 00       	push   $0x8046c4
  8012d8:	68 11 01 00 00       	push   $0x111
  8012dd:	68 01 46 80 00       	push   $0x804601
  8012e2:	e8 a8 02 00 00       	call   80158f <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8012e7:	e8 94 19 00 00       	call   802c80 <sys_calculate_free_frames>
  8012ec:	89 45 8c             	mov    %eax,-0x74(%ebp)
		shortArr2 = (short *) ptr_allocations[7];
  8012ef:	8b 85 9c fe ff ff    	mov    -0x164(%ebp),%eax
  8012f5:	89 85 10 ff ff ff    	mov    %eax,-0xf0(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
  8012fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	01 c0                	add    %eax,%eax
  801302:	01 d0                	add    %edx,%eax
  801304:	01 c0                	add    %eax,%eax
  801306:	01 d0                	add    %edx,%eax
  801308:	01 c0                	add    %eax,%eax
  80130a:	d1 e8                	shr    %eax
  80130c:	48                   	dec    %eax
  80130d:	89 85 0c ff ff ff    	mov    %eax,-0xf4(%ebp)
		shortArr2[0] = minShort;
  801313:	8b 95 10 ff ff ff    	mov    -0xf0(%ebp),%edx
  801319:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80131c:	66 89 02             	mov    %ax,(%edx)
		shortArr2[lastIndexOfShort2] = maxShort;
  80131f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  801325:	01 c0                	add    %eax,%eax
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  80132f:	01 c2                	add    %eax,%edx
  801331:	66 8b 45 ca          	mov    -0x36(%ebp),%ax
  801335:	66 89 02             	mov    %ax,(%edx)
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
  801338:	8b 5d 8c             	mov    -0x74(%ebp),%ebx
  80133b:	e8 40 19 00 00       	call   802c80 <sys_calculate_free_frames>
  801340:	29 c3                	sub    %eax,%ebx
  801342:	89 d8                	mov    %ebx,%eax
  801344:	83 f8 02             	cmp    $0x2,%eax
  801347:	74 17                	je     801360 <_main+0x1328>
  801349:	83 ec 04             	sub    $0x4,%esp
  80134c:	68 f4 46 80 00       	push   $0x8046f4
  801351:	68 18 01 00 00       	push   $0x118
  801356:	68 01 46 80 00       	push   $0x804601
  80135b:	e8 2f 02 00 00       	call   80158f <_panic>
		found = 0;
  801360:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801367:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  80136e:	e9 a7 00 00 00       	jmp    80141a <_main+0x13e2>
		{
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
  801373:	a1 20 60 80 00       	mov    0x806020,%eax
  801378:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80137e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801381:	89 d0                	mov    %edx,%eax
  801383:	01 c0                	add    %eax,%eax
  801385:	01 d0                	add    %edx,%eax
  801387:	c1 e0 03             	shl    $0x3,%eax
  80138a:	01 c8                	add    %ecx,%eax
  80138c:	8b 00                	mov    (%eax),%eax
  80138e:	89 85 08 ff ff ff    	mov    %eax,-0xf8(%ebp)
  801394:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
  80139a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139f:	89 c2                	mov    %eax,%edx
  8013a1:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013a7:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
  8013ad:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
  8013b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b8:	39 c2                	cmp    %eax,%edx
  8013ba:	75 03                	jne    8013bf <_main+0x1387>
				found++;
  8013bc:	ff 45 d8             	incl   -0x28(%ebp)
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
  8013bf:	a1 20 60 80 00       	mov    0x806020,%eax
  8013c4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8013ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013cd:	89 d0                	mov    %edx,%eax
  8013cf:	01 c0                	add    %eax,%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	c1 e0 03             	shl    $0x3,%eax
  8013d6:	01 c8                	add    %ecx,%eax
  8013d8:	8b 00                	mov    (%eax),%eax
  8013da:	89 85 00 ff ff ff    	mov    %eax,-0x100(%ebp)
  8013e0:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
  8013e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013eb:	89 c2                	mov    %eax,%edx
  8013ed:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
  8013f3:	01 c0                	add    %eax,%eax
  8013f5:	89 c1                	mov    %eax,%ecx
  8013f7:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
  8013fd:	01 c8                	add    %ecx,%eax
  8013ff:	89 85 fc fe ff ff    	mov    %eax,-0x104(%ebp)
  801405:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
  80140b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801410:	39 c2                	cmp    %eax,%edx
  801412:	75 03                	jne    801417 <_main+0x13df>
				found++;
  801414:	ff 45 d8             	incl   -0x28(%ebp)
		lastIndexOfShort2 = (14*kilo)/sizeof(short) - 1;
		shortArr2[0] = minShort;
		shortArr2[lastIndexOfShort2] = maxShort;
		if ((freeFrames - sys_calculate_free_frames()) != 2) panic("Wrong allocation: pages are not loaded successfully into memory/WS");
		found = 0;
		for (var = 0; var < (myEnv->page_WS_max_size); ++var)
  801417:	ff 45 e4             	incl   -0x1c(%ebp)
  80141a:	a1 20 60 80 00       	mov    0x806020,%eax
  80141f:	8b 50 74             	mov    0x74(%eax),%edx
  801422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801425:	39 c2                	cmp    %eax,%edx
  801427:	0f 87 46 ff ff ff    	ja     801373 <_main+0x133b>
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[0])), PAGE_SIZE))
				found++;
			if(ROUNDDOWN(myEnv->__uptr_pws[var].virtual_address,PAGE_SIZE) == ROUNDDOWN((uint32)(&(shortArr2[lastIndexOfShort2])), PAGE_SIZE))
				found++;
		}
		if (found != 2) panic("malloc: page is not added to WS");
  80142d:	83 7d d8 02          	cmpl   $0x2,-0x28(%ebp)
  801431:	74 17                	je     80144a <_main+0x1412>
  801433:	83 ec 04             	sub    $0x4,%esp
  801436:	68 38 47 80 00       	push   $0x804738
  80143b:	68 21 01 00 00       	push   $0x121
  801440:	68 01 46 80 00       	push   $0x804601
  801445:	e8 45 01 00 00       	call   80158f <_panic>
		if(start_freeFrames != (sys_calculate_free_frames() + 4)) {panic("Wrong free: not all pages removed correctly at end");}
	}

	cprintf("Congratulations!! test free [1] completed successfully.\n");
	 */
	return;
  80144a:	90                   	nop
}
  80144b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  801459:	e8 02 1b 00 00       	call   802f60 <sys_getenvindex>
  80145e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  801461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801464:	89 d0                	mov    %edx,%eax
  801466:	c1 e0 03             	shl    $0x3,%eax
  801469:	01 d0                	add    %edx,%eax
  80146b:	01 c0                	add    %eax,%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801476:	01 d0                	add    %edx,%eax
  801478:	c1 e0 04             	shl    $0x4,%eax
  80147b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801480:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  801485:	a1 20 60 80 00       	mov    0x806020,%eax
  80148a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  801490:	84 c0                	test   %al,%al
  801492:	74 0f                	je     8014a3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  801494:	a1 20 60 80 00       	mov    0x806020,%eax
  801499:	05 5c 05 00 00       	add    $0x55c,%eax
  80149e:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	7e 0a                	jle    8014b3 <libmain+0x60>
		binaryname = argv[0];
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  8014b3:	83 ec 08             	sub    $0x8,%esp
  8014b6:	ff 75 0c             	pushl  0xc(%ebp)
  8014b9:	ff 75 08             	pushl  0x8(%ebp)
  8014bc:	e8 77 eb ff ff       	call   800038 <_main>
  8014c1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8014c4:	e8 a4 18 00 00       	call   802d6d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	68 5c 48 80 00       	push   $0x80485c
  8014d1:	e8 6d 03 00 00       	call   801843 <cprintf>
  8014d6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8014d9:	a1 20 60 80 00       	mov    0x806020,%eax
  8014de:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8014e4:	a1 20 60 80 00       	mov    0x806020,%eax
  8014e9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8014ef:	83 ec 04             	sub    $0x4,%esp
  8014f2:	52                   	push   %edx
  8014f3:	50                   	push   %eax
  8014f4:	68 84 48 80 00       	push   $0x804884
  8014f9:	e8 45 03 00 00       	call   801843 <cprintf>
  8014fe:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  801501:	a1 20 60 80 00       	mov    0x806020,%eax
  801506:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80150c:	a1 20 60 80 00       	mov    0x806020,%eax
  801511:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  801517:	a1 20 60 80 00       	mov    0x806020,%eax
  80151c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  801522:	51                   	push   %ecx
  801523:	52                   	push   %edx
  801524:	50                   	push   %eax
  801525:	68 ac 48 80 00       	push   $0x8048ac
  80152a:	e8 14 03 00 00       	call   801843 <cprintf>
  80152f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  801532:	a1 20 60 80 00       	mov    0x806020,%eax
  801537:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80153d:	83 ec 08             	sub    $0x8,%esp
  801540:	50                   	push   %eax
  801541:	68 04 49 80 00       	push   $0x804904
  801546:	e8 f8 02 00 00       	call   801843 <cprintf>
  80154b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80154e:	83 ec 0c             	sub    $0xc,%esp
  801551:	68 5c 48 80 00       	push   $0x80485c
  801556:	e8 e8 02 00 00       	call   801843 <cprintf>
  80155b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80155e:	e8 24 18 00 00       	call   802d87 <sys_enable_interrupt>

	// exit gracefully
	exit();
  801563:	e8 19 00 00 00       	call   801581 <exit>
}
  801568:	90                   	nop
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  801571:	83 ec 0c             	sub    $0xc,%esp
  801574:	6a 00                	push   $0x0
  801576:	e8 b1 19 00 00       	call   802f2c <sys_destroy_env>
  80157b:	83 c4 10             	add    $0x10,%esp
}
  80157e:	90                   	nop
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <exit>:

void
exit(void)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801587:	e8 06 1a 00 00       	call   802f92 <sys_exit_env>
}
  80158c:	90                   	nop
  80158d:	c9                   	leave  
  80158e:	c3                   	ret    

0080158f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  801595:	8d 45 10             	lea    0x10(%ebp),%eax
  801598:	83 c0 04             	add    $0x4,%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80159e:	a1 5c 61 80 00       	mov    0x80615c,%eax
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	74 16                	je     8015bd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8015a7:	a1 5c 61 80 00       	mov    0x80615c,%eax
  8015ac:	83 ec 08             	sub    $0x8,%esp
  8015af:	50                   	push   %eax
  8015b0:	68 18 49 80 00       	push   $0x804918
  8015b5:	e8 89 02 00 00       	call   801843 <cprintf>
  8015ba:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8015bd:	a1 00 60 80 00       	mov    0x806000,%eax
  8015c2:	ff 75 0c             	pushl  0xc(%ebp)
  8015c5:	ff 75 08             	pushl  0x8(%ebp)
  8015c8:	50                   	push   %eax
  8015c9:	68 1d 49 80 00       	push   $0x80491d
  8015ce:	e8 70 02 00 00       	call   801843 <cprintf>
  8015d3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8015d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d9:	83 ec 08             	sub    $0x8,%esp
  8015dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015df:	50                   	push   %eax
  8015e0:	e8 f3 01 00 00       	call   8017d8 <vcprintf>
  8015e5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8015e8:	83 ec 08             	sub    $0x8,%esp
  8015eb:	6a 00                	push   $0x0
  8015ed:	68 39 49 80 00       	push   $0x804939
  8015f2:	e8 e1 01 00 00       	call   8017d8 <vcprintf>
  8015f7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8015fa:	e8 82 ff ff ff       	call   801581 <exit>

	// should not return here
	while (1) ;
  8015ff:	eb fe                	jmp    8015ff <_panic+0x70>

00801601 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  801607:	a1 20 60 80 00       	mov    0x806020,%eax
  80160c:	8b 50 74             	mov    0x74(%eax),%edx
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	39 c2                	cmp    %eax,%edx
  801614:	74 14                	je     80162a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  801616:	83 ec 04             	sub    $0x4,%esp
  801619:	68 3c 49 80 00       	push   $0x80493c
  80161e:	6a 26                	push   $0x26
  801620:	68 88 49 80 00       	push   $0x804988
  801625:	e8 65 ff ff ff       	call   80158f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80162a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  801631:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801638:	e9 c2 00 00 00       	jmp    8016ff <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	01 d0                	add    %edx,%eax
  80164c:	8b 00                	mov    (%eax),%eax
  80164e:	85 c0                	test   %eax,%eax
  801650:	75 08                	jne    80165a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  801652:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  801655:	e9 a2 00 00 00       	jmp    8016fc <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80165a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801661:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801668:	eb 69                	jmp    8016d3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80166a:	a1 20 60 80 00       	mov    0x806020,%eax
  80166f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801675:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801678:	89 d0                	mov    %edx,%eax
  80167a:	01 c0                	add    %eax,%eax
  80167c:	01 d0                	add    %edx,%eax
  80167e:	c1 e0 03             	shl    $0x3,%eax
  801681:	01 c8                	add    %ecx,%eax
  801683:	8a 40 04             	mov    0x4(%eax),%al
  801686:	84 c0                	test   %al,%al
  801688:	75 46                	jne    8016d0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80168a:	a1 20 60 80 00       	mov    0x806020,%eax
  80168f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801698:	89 d0                	mov    %edx,%eax
  80169a:	01 c0                	add    %eax,%eax
  80169c:	01 d0                	add    %edx,%eax
  80169e:	c1 e0 03             	shl    $0x3,%eax
  8016a1:	01 c8                	add    %ecx,%eax
  8016a3:	8b 00                	mov    (%eax),%eax
  8016a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8016a8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016b0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8016b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bf:	01 c8                	add    %ecx,%eax
  8016c1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8016c3:	39 c2                	cmp    %eax,%edx
  8016c5:	75 09                	jne    8016d0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8016c7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8016ce:	eb 12                	jmp    8016e2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8016d0:	ff 45 e8             	incl   -0x18(%ebp)
  8016d3:	a1 20 60 80 00       	mov    0x806020,%eax
  8016d8:	8b 50 74             	mov    0x74(%eax),%edx
  8016db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016de:	39 c2                	cmp    %eax,%edx
  8016e0:	77 88                	ja     80166a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8016e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e6:	75 14                	jne    8016fc <CheckWSWithoutLastIndex+0xfb>
			panic(
  8016e8:	83 ec 04             	sub    $0x4,%esp
  8016eb:	68 94 49 80 00       	push   $0x804994
  8016f0:	6a 3a                	push   $0x3a
  8016f2:	68 88 49 80 00       	push   $0x804988
  8016f7:	e8 93 fe ff ff       	call   80158f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8016fc:	ff 45 f0             	incl   -0x10(%ebp)
  8016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801702:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801705:	0f 8c 32 ff ff ff    	jl     80163d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80170b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  801712:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801719:	eb 26                	jmp    801741 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80171b:	a1 20 60 80 00       	mov    0x806020,%eax
  801720:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  801726:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801729:	89 d0                	mov    %edx,%eax
  80172b:	01 c0                	add    %eax,%eax
  80172d:	01 d0                	add    %edx,%eax
  80172f:	c1 e0 03             	shl    $0x3,%eax
  801732:	01 c8                	add    %ecx,%eax
  801734:	8a 40 04             	mov    0x4(%eax),%al
  801737:	3c 01                	cmp    $0x1,%al
  801739:	75 03                	jne    80173e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80173b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80173e:	ff 45 e0             	incl   -0x20(%ebp)
  801741:	a1 20 60 80 00       	mov    0x806020,%eax
  801746:	8b 50 74             	mov    0x74(%eax),%edx
  801749:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80174c:	39 c2                	cmp    %eax,%edx
  80174e:	77 cb                	ja     80171b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  801750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801753:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  801756:	74 14                	je     80176c <CheckWSWithoutLastIndex+0x16b>
		panic(
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	68 e8 49 80 00       	push   $0x8049e8
  801760:	6a 44                	push   $0x44
  801762:	68 88 49 80 00       	push   $0x804988
  801767:	e8 23 fe ff ff       	call   80158f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80176c:	90                   	nop
  80176d:	c9                   	leave  
  80176e:	c3                   	ret    

0080176f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  801775:	8b 45 0c             	mov    0xc(%ebp),%eax
  801778:	8b 00                	mov    (%eax),%eax
  80177a:	8d 48 01             	lea    0x1(%eax),%ecx
  80177d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801780:	89 0a                	mov    %ecx,(%edx)
  801782:	8b 55 08             	mov    0x8(%ebp),%edx
  801785:	88 d1                	mov    %dl,%cl
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80178e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801791:	8b 00                	mov    (%eax),%eax
  801793:	3d ff 00 00 00       	cmp    $0xff,%eax
  801798:	75 2c                	jne    8017c6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80179a:	a0 24 60 80 00       	mov    0x806024,%al
  80179f:	0f b6 c0             	movzbl %al,%eax
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 12                	mov    (%edx),%edx
  8017a7:	89 d1                	mov    %edx,%ecx
  8017a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ac:	83 c2 08             	add    $0x8,%edx
  8017af:	83 ec 04             	sub    $0x4,%esp
  8017b2:	50                   	push   %eax
  8017b3:	51                   	push   %ecx
  8017b4:	52                   	push   %edx
  8017b5:	e8 05 14 00 00       	call   802bbf <sys_cputs>
  8017ba:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8017bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	8b 40 04             	mov    0x4(%eax),%eax
  8017cc:	8d 50 01             	lea    0x1(%eax),%edx
  8017cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8017d5:	90                   	nop
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8017e1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8017e8:	00 00 00 
	b.cnt = 0;
  8017eb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8017f2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	ff 75 08             	pushl  0x8(%ebp)
  8017fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801801:	50                   	push   %eax
  801802:	68 6f 17 80 00       	push   $0x80176f
  801807:	e8 11 02 00 00       	call   801a1d <vprintfmt>
  80180c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80180f:	a0 24 60 80 00       	mov    0x806024,%al
  801814:	0f b6 c0             	movzbl %al,%eax
  801817:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80181d:	83 ec 04             	sub    $0x4,%esp
  801820:	50                   	push   %eax
  801821:	52                   	push   %edx
  801822:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801828:	83 c0 08             	add    $0x8,%eax
  80182b:	50                   	push   %eax
  80182c:	e8 8e 13 00 00       	call   802bbf <sys_cputs>
  801831:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  801834:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  80183b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801841:	c9                   	leave  
  801842:	c3                   	ret    

00801843 <cprintf>:

int cprintf(const char *fmt, ...) {
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  801849:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  801850:	8d 45 0c             	lea    0xc(%ebp),%eax
  801853:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	83 ec 08             	sub    $0x8,%esp
  80185c:	ff 75 f4             	pushl  -0xc(%ebp)
  80185f:	50                   	push   %eax
  801860:	e8 73 ff ff ff       	call   8017d8 <vcprintf>
  801865:	83 c4 10             	add    $0x10,%esp
  801868:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80186b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801876:	e8 f2 14 00 00       	call   802d6d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80187b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80187e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	83 ec 08             	sub    $0x8,%esp
  801887:	ff 75 f4             	pushl  -0xc(%ebp)
  80188a:	50                   	push   %eax
  80188b:	e8 48 ff ff ff       	call   8017d8 <vcprintf>
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801896:	e8 ec 14 00 00       	call   802d87 <sys_enable_interrupt>
	return cnt;
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    

008018a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 14             	sub    $0x14,%esp
  8018a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8018ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8018b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8018b3:	8b 45 18             	mov    0x18(%ebp),%eax
  8018b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018be:	77 55                	ja     801915 <printnum+0x75>
  8018c0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8018c3:	72 05                	jb     8018ca <printnum+0x2a>
  8018c5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018c8:	77 4b                	ja     801915 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8018ca:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8018cd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8018d0:	8b 45 18             	mov    0x18(%ebp),%eax
  8018d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d8:	52                   	push   %edx
  8018d9:	50                   	push   %eax
  8018da:	ff 75 f4             	pushl  -0xc(%ebp)
  8018dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e0:	e8 63 2a 00 00       	call   804348 <__udivdi3>
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	83 ec 04             	sub    $0x4,%esp
  8018eb:	ff 75 20             	pushl  0x20(%ebp)
  8018ee:	53                   	push   %ebx
  8018ef:	ff 75 18             	pushl  0x18(%ebp)
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	e8 a1 ff ff ff       	call   8018a0 <printnum>
  8018ff:	83 c4 20             	add    $0x20,%esp
  801902:	eb 1a                	jmp    80191e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	ff 75 20             	pushl  0x20(%ebp)
  80190d:	8b 45 08             	mov    0x8(%ebp),%eax
  801910:	ff d0                	call   *%eax
  801912:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801915:	ff 4d 1c             	decl   0x1c(%ebp)
  801918:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80191c:	7f e6                	jg     801904 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80191e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  801921:	bb 00 00 00 00       	mov    $0x0,%ebx
  801926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801929:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80192c:	53                   	push   %ebx
  80192d:	51                   	push   %ecx
  80192e:	52                   	push   %edx
  80192f:	50                   	push   %eax
  801930:	e8 23 2b 00 00       	call   804458 <__umoddi3>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	05 54 4c 80 00       	add    $0x804c54,%eax
  80193d:	8a 00                	mov    (%eax),%al
  80193f:	0f be c0             	movsbl %al,%eax
  801942:	83 ec 08             	sub    $0x8,%esp
  801945:	ff 75 0c             	pushl  0xc(%ebp)
  801948:	50                   	push   %eax
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	ff d0                	call   *%eax
  80194e:	83 c4 10             	add    $0x10,%esp
}
  801951:	90                   	nop
  801952:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80195a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80195e:	7e 1c                	jle    80197c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  801960:	8b 45 08             	mov    0x8(%ebp),%eax
  801963:	8b 00                	mov    (%eax),%eax
  801965:	8d 50 08             	lea    0x8(%eax),%edx
  801968:	8b 45 08             	mov    0x8(%ebp),%eax
  80196b:	89 10                	mov    %edx,(%eax)
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8b 00                	mov    (%eax),%eax
  801972:	83 e8 08             	sub    $0x8,%eax
  801975:	8b 50 04             	mov    0x4(%eax),%edx
  801978:	8b 00                	mov    (%eax),%eax
  80197a:	eb 40                	jmp    8019bc <getuint+0x65>
	else if (lflag)
  80197c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801980:	74 1e                	je     8019a0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8b 00                	mov    (%eax),%eax
  801987:	8d 50 04             	lea    0x4(%eax),%edx
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	89 10                	mov    %edx,(%eax)
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	8b 00                	mov    (%eax),%eax
  801994:	83 e8 04             	sub    $0x4,%eax
  801997:	8b 00                	mov    (%eax),%eax
  801999:	ba 00 00 00 00       	mov    $0x0,%edx
  80199e:	eb 1c                	jmp    8019bc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	8b 00                	mov    (%eax),%eax
  8019a5:	8d 50 04             	lea    0x4(%eax),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	89 10                	mov    %edx,(%eax)
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	8b 00                	mov    (%eax),%eax
  8019b2:	83 e8 04             	sub    $0x4,%eax
  8019b5:	8b 00                	mov    (%eax),%eax
  8019b7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8019bc:	5d                   	pop    %ebp
  8019bd:	c3                   	ret    

008019be <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8019c1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019c5:	7e 1c                	jle    8019e3 <getint+0x25>
		return va_arg(*ap, long long);
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	8b 00                	mov    (%eax),%eax
  8019cc:	8d 50 08             	lea    0x8(%eax),%edx
  8019cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d2:	89 10                	mov    %edx,(%eax)
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	8b 00                	mov    (%eax),%eax
  8019d9:	83 e8 08             	sub    $0x8,%eax
  8019dc:	8b 50 04             	mov    0x4(%eax),%edx
  8019df:	8b 00                	mov    (%eax),%eax
  8019e1:	eb 38                	jmp    801a1b <getint+0x5d>
	else if (lflag)
  8019e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8019e7:	74 1a                	je     801a03 <getint+0x45>
		return va_arg(*ap, long);
  8019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ec:	8b 00                	mov    (%eax),%eax
  8019ee:	8d 50 04             	lea    0x4(%eax),%edx
  8019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f4:	89 10                	mov    %edx,(%eax)
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	8b 00                	mov    (%eax),%eax
  8019fb:	83 e8 04             	sub    $0x4,%eax
  8019fe:	8b 00                	mov    (%eax),%eax
  801a00:	99                   	cltd   
  801a01:	eb 18                	jmp    801a1b <getint+0x5d>
	else
		return va_arg(*ap, int);
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	8b 00                	mov    (%eax),%eax
  801a08:	8d 50 04             	lea    0x4(%eax),%edx
  801a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0e:	89 10                	mov    %edx,(%eax)
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	8b 00                	mov    (%eax),%eax
  801a15:	83 e8 04             	sub    $0x4,%eax
  801a18:	8b 00                	mov    (%eax),%eax
  801a1a:	99                   	cltd   
}
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    

00801a1d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	56                   	push   %esi
  801a21:	53                   	push   %ebx
  801a22:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a25:	eb 17                	jmp    801a3e <vprintfmt+0x21>
			if (ch == '\0')
  801a27:	85 db                	test   %ebx,%ebx
  801a29:	0f 84 af 03 00 00    	je     801dde <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  801a2f:	83 ec 08             	sub    $0x8,%esp
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	53                   	push   %ebx
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	ff d0                	call   *%eax
  801a3b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801a41:	8d 50 01             	lea    0x1(%eax),%edx
  801a44:	89 55 10             	mov    %edx,0x10(%ebp)
  801a47:	8a 00                	mov    (%eax),%al
  801a49:	0f b6 d8             	movzbl %al,%ebx
  801a4c:	83 fb 25             	cmp    $0x25,%ebx
  801a4f:	75 d6                	jne    801a27 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  801a51:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  801a55:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  801a5c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  801a63:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801a6a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801a71:	8b 45 10             	mov    0x10(%ebp),%eax
  801a74:	8d 50 01             	lea    0x1(%eax),%edx
  801a77:	89 55 10             	mov    %edx,0x10(%ebp)
  801a7a:	8a 00                	mov    (%eax),%al
  801a7c:	0f b6 d8             	movzbl %al,%ebx
  801a7f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  801a82:	83 f8 55             	cmp    $0x55,%eax
  801a85:	0f 87 2b 03 00 00    	ja     801db6 <vprintfmt+0x399>
  801a8b:	8b 04 85 78 4c 80 00 	mov    0x804c78(,%eax,4),%eax
  801a92:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  801a94:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801a98:	eb d7                	jmp    801a71 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801a9a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801a9e:	eb d1                	jmp    801a71 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801aa0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801aa7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aaa:	89 d0                	mov    %edx,%eax
  801aac:	c1 e0 02             	shl    $0x2,%eax
  801aaf:	01 d0                	add    %edx,%eax
  801ab1:	01 c0                	add    %eax,%eax
  801ab3:	01 d8                	add    %ebx,%eax
  801ab5:	83 e8 30             	sub    $0x30,%eax
  801ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801abb:	8b 45 10             	mov    0x10(%ebp),%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  801ac3:	83 fb 2f             	cmp    $0x2f,%ebx
  801ac6:	7e 3e                	jle    801b06 <vprintfmt+0xe9>
  801ac8:	83 fb 39             	cmp    $0x39,%ebx
  801acb:	7f 39                	jg     801b06 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801acd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  801ad0:	eb d5                	jmp    801aa7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801ad2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad5:	83 c0 04             	add    $0x4,%eax
  801ad8:	89 45 14             	mov    %eax,0x14(%ebp)
  801adb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ade:	83 e8 04             	sub    $0x4,%eax
  801ae1:	8b 00                	mov    (%eax),%eax
  801ae3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801ae6:	eb 1f                	jmp    801b07 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801ae8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801aec:	79 83                	jns    801a71 <vprintfmt+0x54>
				width = 0;
  801aee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  801af5:	e9 77 ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801afa:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  801b01:	e9 6b ff ff ff       	jmp    801a71 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  801b06:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b0b:	0f 89 60 ff ff ff    	jns    801a71 <vprintfmt+0x54>
				width = precision, precision = -1;
  801b11:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801b1e:	e9 4e ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801b23:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  801b26:	e9 46 ff ff ff       	jmp    801a71 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801b2b:	8b 45 14             	mov    0x14(%ebp),%eax
  801b2e:	83 c0 04             	add    $0x4,%eax
  801b31:	89 45 14             	mov    %eax,0x14(%ebp)
  801b34:	8b 45 14             	mov    0x14(%ebp),%eax
  801b37:	83 e8 04             	sub    $0x4,%eax
  801b3a:	8b 00                	mov    (%eax),%eax
  801b3c:	83 ec 08             	sub    $0x8,%esp
  801b3f:	ff 75 0c             	pushl  0xc(%ebp)
  801b42:	50                   	push   %eax
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	ff d0                	call   *%eax
  801b48:	83 c4 10             	add    $0x10,%esp
			break;
  801b4b:	e9 89 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801b50:	8b 45 14             	mov    0x14(%ebp),%eax
  801b53:	83 c0 04             	add    $0x4,%eax
  801b56:	89 45 14             	mov    %eax,0x14(%ebp)
  801b59:	8b 45 14             	mov    0x14(%ebp),%eax
  801b5c:	83 e8 04             	sub    $0x4,%eax
  801b5f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  801b61:	85 db                	test   %ebx,%ebx
  801b63:	79 02                	jns    801b67 <vprintfmt+0x14a>
				err = -err;
  801b65:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801b67:	83 fb 64             	cmp    $0x64,%ebx
  801b6a:	7f 0b                	jg     801b77 <vprintfmt+0x15a>
  801b6c:	8b 34 9d c0 4a 80 00 	mov    0x804ac0(,%ebx,4),%esi
  801b73:	85 f6                	test   %esi,%esi
  801b75:	75 19                	jne    801b90 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801b77:	53                   	push   %ebx
  801b78:	68 65 4c 80 00       	push   $0x804c65
  801b7d:	ff 75 0c             	pushl  0xc(%ebp)
  801b80:	ff 75 08             	pushl  0x8(%ebp)
  801b83:	e8 5e 02 00 00       	call   801de6 <printfmt>
  801b88:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801b8b:	e9 49 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801b90:	56                   	push   %esi
  801b91:	68 6e 4c 80 00       	push   $0x804c6e
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	ff 75 08             	pushl  0x8(%ebp)
  801b9c:	e8 45 02 00 00       	call   801de6 <printfmt>
  801ba1:	83 c4 10             	add    $0x10,%esp
			break;
  801ba4:	e9 30 02 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bac:	83 c0 04             	add    $0x4,%eax
  801baf:	89 45 14             	mov    %eax,0x14(%ebp)
  801bb2:	8b 45 14             	mov    0x14(%ebp),%eax
  801bb5:	83 e8 04             	sub    $0x4,%eax
  801bb8:	8b 30                	mov    (%eax),%esi
  801bba:	85 f6                	test   %esi,%esi
  801bbc:	75 05                	jne    801bc3 <vprintfmt+0x1a6>
				p = "(null)";
  801bbe:	be 71 4c 80 00       	mov    $0x804c71,%esi
			if (width > 0 && padc != '-')
  801bc3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bc7:	7e 6d                	jle    801c36 <vprintfmt+0x219>
  801bc9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801bcd:	74 67                	je     801c36 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bd2:	83 ec 08             	sub    $0x8,%esp
  801bd5:	50                   	push   %eax
  801bd6:	56                   	push   %esi
  801bd7:	e8 0c 03 00 00       	call   801ee8 <strnlen>
  801bdc:	83 c4 10             	add    $0x10,%esp
  801bdf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801be2:	eb 16                	jmp    801bfa <vprintfmt+0x1dd>
					putch(padc, putdat);
  801be4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801be8:	83 ec 08             	sub    $0x8,%esp
  801beb:	ff 75 0c             	pushl  0xc(%ebp)
  801bee:	50                   	push   %eax
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	ff d0                	call   *%eax
  801bf4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801bf7:	ff 4d e4             	decl   -0x1c(%ebp)
  801bfa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801bfe:	7f e4                	jg     801be4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c00:	eb 34                	jmp    801c36 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801c02:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801c06:	74 1c                	je     801c24 <vprintfmt+0x207>
  801c08:	83 fb 1f             	cmp    $0x1f,%ebx
  801c0b:	7e 05                	jle    801c12 <vprintfmt+0x1f5>
  801c0d:	83 fb 7e             	cmp    $0x7e,%ebx
  801c10:	7e 12                	jle    801c24 <vprintfmt+0x207>
					putch('?', putdat);
  801c12:	83 ec 08             	sub    $0x8,%esp
  801c15:	ff 75 0c             	pushl  0xc(%ebp)
  801c18:	6a 3f                	push   $0x3f
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	ff d0                	call   *%eax
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	eb 0f                	jmp    801c33 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801c24:	83 ec 08             	sub    $0x8,%esp
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	53                   	push   %ebx
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	ff d0                	call   *%eax
  801c30:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c33:	ff 4d e4             	decl   -0x1c(%ebp)
  801c36:	89 f0                	mov    %esi,%eax
  801c38:	8d 70 01             	lea    0x1(%eax),%esi
  801c3b:	8a 00                	mov    (%eax),%al
  801c3d:	0f be d8             	movsbl %al,%ebx
  801c40:	85 db                	test   %ebx,%ebx
  801c42:	74 24                	je     801c68 <vprintfmt+0x24b>
  801c44:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c48:	78 b8                	js     801c02 <vprintfmt+0x1e5>
  801c4a:	ff 4d e0             	decl   -0x20(%ebp)
  801c4d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c51:	79 af                	jns    801c02 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c53:	eb 13                	jmp    801c68 <vprintfmt+0x24b>
				putch(' ', putdat);
  801c55:	83 ec 08             	sub    $0x8,%esp
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	6a 20                	push   $0x20
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	ff d0                	call   *%eax
  801c62:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801c65:	ff 4d e4             	decl   -0x1c(%ebp)
  801c68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c6c:	7f e7                	jg     801c55 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801c6e:	e9 66 01 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801c73:	83 ec 08             	sub    $0x8,%esp
  801c76:	ff 75 e8             	pushl  -0x18(%ebp)
  801c79:	8d 45 14             	lea    0x14(%ebp),%eax
  801c7c:	50                   	push   %eax
  801c7d:	e8 3c fd ff ff       	call   8019be <getint>
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c88:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801c8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c91:	85 d2                	test   %edx,%edx
  801c93:	79 23                	jns    801cb8 <vprintfmt+0x29b>
				putch('-', putdat);
  801c95:	83 ec 08             	sub    $0x8,%esp
  801c98:	ff 75 0c             	pushl  0xc(%ebp)
  801c9b:	6a 2d                	push   $0x2d
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	ff d0                	call   *%eax
  801ca2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cab:	f7 d8                	neg    %eax
  801cad:	83 d2 00             	adc    $0x0,%edx
  801cb0:	f7 da                	neg    %edx
  801cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cb5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801cb8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801cbf:	e9 bc 00 00 00       	jmp    801d80 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801cc4:	83 ec 08             	sub    $0x8,%esp
  801cc7:	ff 75 e8             	pushl  -0x18(%ebp)
  801cca:	8d 45 14             	lea    0x14(%ebp),%eax
  801ccd:	50                   	push   %eax
  801cce:	e8 84 fc ff ff       	call   801957 <getuint>
  801cd3:	83 c4 10             	add    $0x10,%esp
  801cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801cdc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801ce3:	e9 98 00 00 00       	jmp    801d80 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801ce8:	83 ec 08             	sub    $0x8,%esp
  801ceb:	ff 75 0c             	pushl  0xc(%ebp)
  801cee:	6a 58                	push   $0x58
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	ff d0                	call   *%eax
  801cf5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801cf8:	83 ec 08             	sub    $0x8,%esp
  801cfb:	ff 75 0c             	pushl  0xc(%ebp)
  801cfe:	6a 58                	push   $0x58
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	ff d0                	call   *%eax
  801d05:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801d08:	83 ec 08             	sub    $0x8,%esp
  801d0b:	ff 75 0c             	pushl  0xc(%ebp)
  801d0e:	6a 58                	push   $0x58
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	ff d0                	call   *%eax
  801d15:	83 c4 10             	add    $0x10,%esp
			break;
  801d18:	e9 bc 00 00 00       	jmp    801dd9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801d1d:	83 ec 08             	sub    $0x8,%esp
  801d20:	ff 75 0c             	pushl  0xc(%ebp)
  801d23:	6a 30                	push   $0x30
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	ff d0                	call   *%eax
  801d2a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801d2d:	83 ec 08             	sub    $0x8,%esp
  801d30:	ff 75 0c             	pushl  0xc(%ebp)
  801d33:	6a 78                	push   $0x78
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	ff d0                	call   *%eax
  801d3a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801d3d:	8b 45 14             	mov    0x14(%ebp),%eax
  801d40:	83 c0 04             	add    $0x4,%eax
  801d43:	89 45 14             	mov    %eax,0x14(%ebp)
  801d46:	8b 45 14             	mov    0x14(%ebp),%eax
  801d49:	83 e8 04             	sub    $0x4,%eax
  801d4c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801d4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801d58:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801d5f:	eb 1f                	jmp    801d80 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801d61:	83 ec 08             	sub    $0x8,%esp
  801d64:	ff 75 e8             	pushl  -0x18(%ebp)
  801d67:	8d 45 14             	lea    0x14(%ebp),%eax
  801d6a:	50                   	push   %eax
  801d6b:	e8 e7 fb ff ff       	call   801957 <getuint>
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d76:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801d79:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801d80:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801d84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d87:	83 ec 04             	sub    $0x4,%esp
  801d8a:	52                   	push   %edx
  801d8b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801d8e:	50                   	push   %eax
  801d8f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d92:	ff 75 f0             	pushl  -0x10(%ebp)
  801d95:	ff 75 0c             	pushl  0xc(%ebp)
  801d98:	ff 75 08             	pushl  0x8(%ebp)
  801d9b:	e8 00 fb ff ff       	call   8018a0 <printnum>
  801da0:	83 c4 20             	add    $0x20,%esp
			break;
  801da3:	eb 34                	jmp    801dd9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801da5:	83 ec 08             	sub    $0x8,%esp
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	53                   	push   %ebx
  801dac:	8b 45 08             	mov    0x8(%ebp),%eax
  801daf:	ff d0                	call   *%eax
  801db1:	83 c4 10             	add    $0x10,%esp
			break;
  801db4:	eb 23                	jmp    801dd9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801db6:	83 ec 08             	sub    $0x8,%esp
  801db9:	ff 75 0c             	pushl  0xc(%ebp)
  801dbc:	6a 25                	push   $0x25
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	ff d0                	call   *%eax
  801dc3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801dc6:	ff 4d 10             	decl   0x10(%ebp)
  801dc9:	eb 03                	jmp    801dce <vprintfmt+0x3b1>
  801dcb:	ff 4d 10             	decl   0x10(%ebp)
  801dce:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd1:	48                   	dec    %eax
  801dd2:	8a 00                	mov    (%eax),%al
  801dd4:	3c 25                	cmp    $0x25,%al
  801dd6:	75 f3                	jne    801dcb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801dd8:	90                   	nop
		}
	}
  801dd9:	e9 47 fc ff ff       	jmp    801a25 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801dde:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5e                   	pop    %esi
  801de4:	5d                   	pop    %ebp
  801de5:	c3                   	ret    

00801de6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801dec:	8d 45 10             	lea    0x10(%ebp),%eax
  801def:	83 c0 04             	add    $0x4,%eax
  801df2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801df5:	8b 45 10             	mov    0x10(%ebp),%eax
  801df8:	ff 75 f4             	pushl  -0xc(%ebp)
  801dfb:	50                   	push   %eax
  801dfc:	ff 75 0c             	pushl  0xc(%ebp)
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	e8 16 fc ff ff       	call   801a1d <vprintfmt>
  801e07:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801e0a:	90                   	nop
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e13:	8b 40 08             	mov    0x8(%eax),%eax
  801e16:	8d 50 01             	lea    0x1(%eax),%edx
  801e19:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e1c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e22:	8b 10                	mov    (%eax),%edx
  801e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e27:	8b 40 04             	mov    0x4(%eax),%eax
  801e2a:	39 c2                	cmp    %eax,%edx
  801e2c:	73 12                	jae    801e40 <sprintputch+0x33>
		*b->buf++ = ch;
  801e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e31:	8b 00                	mov    (%eax),%eax
  801e33:	8d 48 01             	lea    0x1(%eax),%ecx
  801e36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e39:	89 0a                	mov    %ecx,(%edx)
  801e3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801e3e:	88 10                	mov    %dl,(%eax)
}
  801e40:	90                   	nop
  801e41:	5d                   	pop    %ebp
  801e42:	c3                   	ret    

00801e43 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	01 d0                	add    %edx,%eax
  801e5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801e64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e68:	74 06                	je     801e70 <vsnprintf+0x2d>
  801e6a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e6e:	7f 07                	jg     801e77 <vsnprintf+0x34>
		return -E_INVAL;
  801e70:	b8 03 00 00 00       	mov    $0x3,%eax
  801e75:	eb 20                	jmp    801e97 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801e77:	ff 75 14             	pushl  0x14(%ebp)
  801e7a:	ff 75 10             	pushl  0x10(%ebp)
  801e7d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801e80:	50                   	push   %eax
  801e81:	68 0d 1e 80 00       	push   $0x801e0d
  801e86:	e8 92 fb ff ff       	call   801a1d <vprintfmt>
  801e8b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801e9f:	8d 45 10             	lea    0x10(%ebp),%eax
  801ea2:	83 c0 04             	add    $0x4,%eax
  801ea5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801ea8:	8b 45 10             	mov    0x10(%ebp),%eax
  801eab:	ff 75 f4             	pushl  -0xc(%ebp)
  801eae:	50                   	push   %eax
  801eaf:	ff 75 0c             	pushl  0xc(%ebp)
  801eb2:	ff 75 08             	pushl  0x8(%ebp)
  801eb5:	e8 89 ff ff ff       	call   801e43 <vsnprintf>
  801eba:	83 c4 10             	add    $0x10,%esp
  801ebd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801ec0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801ecb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ed2:	eb 06                	jmp    801eda <strlen+0x15>
		n++;
  801ed4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801ed7:	ff 45 08             	incl   0x8(%ebp)
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	8a 00                	mov    (%eax),%al
  801edf:	84 c0                	test   %al,%al
  801ee1:	75 f1                	jne    801ed4 <strlen+0xf>
		n++;
	return n;
  801ee3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801eee:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801ef5:	eb 09                	jmp    801f00 <strnlen+0x18>
		n++;
  801ef7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801efa:	ff 45 08             	incl   0x8(%ebp)
  801efd:	ff 4d 0c             	decl   0xc(%ebp)
  801f00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f04:	74 09                	je     801f0f <strnlen+0x27>
  801f06:	8b 45 08             	mov    0x8(%ebp),%eax
  801f09:	8a 00                	mov    (%eax),%al
  801f0b:	84 c0                	test   %al,%al
  801f0d:	75 e8                	jne    801ef7 <strnlen+0xf>
		n++;
	return n;
  801f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801f20:	90                   	nop
  801f21:	8b 45 08             	mov    0x8(%ebp),%eax
  801f24:	8d 50 01             	lea    0x1(%eax),%edx
  801f27:	89 55 08             	mov    %edx,0x8(%ebp)
  801f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801f30:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801f33:	8a 12                	mov    (%edx),%dl
  801f35:	88 10                	mov    %dl,(%eax)
  801f37:	8a 00                	mov    (%eax),%al
  801f39:	84 c0                	test   %al,%al
  801f3b:	75 e4                	jne    801f21 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801f4e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801f55:	eb 1f                	jmp    801f76 <strncpy+0x34>
		*dst++ = *src;
  801f57:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5a:	8d 50 01             	lea    0x1(%eax),%edx
  801f5d:	89 55 08             	mov    %edx,0x8(%ebp)
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	8a 12                	mov    (%edx),%dl
  801f65:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6a:	8a 00                	mov    (%eax),%al
  801f6c:	84 c0                	test   %al,%al
  801f6e:	74 03                	je     801f73 <strncpy+0x31>
			src++;
  801f70:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f73:	ff 45 fc             	incl   -0x4(%ebp)
  801f76:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f79:	3b 45 10             	cmp    0x10(%ebp),%eax
  801f7c:	72 d9                	jb     801f57 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801f7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801f81:	c9                   	leave  
  801f82:	c3                   	ret    

00801f83 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801f83:	55                   	push   %ebp
  801f84:	89 e5                	mov    %esp,%ebp
  801f86:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801f8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801f93:	74 30                	je     801fc5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801f95:	eb 16                	jmp    801fad <strlcpy+0x2a>
			*dst++ = *src++;
  801f97:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9a:	8d 50 01             	lea    0x1(%eax),%edx
  801f9d:	89 55 08             	mov    %edx,0x8(%ebp)
  801fa0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa3:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801fa9:	8a 12                	mov    (%edx),%dl
  801fab:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801fad:	ff 4d 10             	decl   0x10(%ebp)
  801fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fb4:	74 09                	je     801fbf <strlcpy+0x3c>
  801fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb9:	8a 00                	mov    (%eax),%al
  801fbb:	84 c0                	test   %al,%al
  801fbd:	75 d8                	jne    801f97 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801fc5:	8b 55 08             	mov    0x8(%ebp),%edx
  801fc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fcb:	29 c2                	sub    %eax,%edx
  801fcd:	89 d0                	mov    %edx,%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801fd4:	eb 06                	jmp    801fdc <strcmp+0xb>
		p++, q++;
  801fd6:	ff 45 08             	incl   0x8(%ebp)
  801fd9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	8a 00                	mov    (%eax),%al
  801fe1:	84 c0                	test   %al,%al
  801fe3:	74 0e                	je     801ff3 <strcmp+0x22>
  801fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe8:	8a 10                	mov    (%eax),%dl
  801fea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fed:	8a 00                	mov    (%eax),%al
  801fef:	38 c2                	cmp    %al,%dl
  801ff1:	74 e3                	je     801fd6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff6:	8a 00                	mov    (%eax),%al
  801ff8:	0f b6 d0             	movzbl %al,%edx
  801ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffe:	8a 00                	mov    (%eax),%al
  802000:	0f b6 c0             	movzbl %al,%eax
  802003:	29 c2                	sub    %eax,%edx
  802005:	89 d0                	mov    %edx,%eax
}
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    

00802009 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80200c:	eb 09                	jmp    802017 <strncmp+0xe>
		n--, p++, q++;
  80200e:	ff 4d 10             	decl   0x10(%ebp)
  802011:	ff 45 08             	incl   0x8(%ebp)
  802014:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  802017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80201b:	74 17                	je     802034 <strncmp+0x2b>
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	8a 00                	mov    (%eax),%al
  802022:	84 c0                	test   %al,%al
  802024:	74 0e                	je     802034 <strncmp+0x2b>
  802026:	8b 45 08             	mov    0x8(%ebp),%eax
  802029:	8a 10                	mov    (%eax),%dl
  80202b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202e:	8a 00                	mov    (%eax),%al
  802030:	38 c2                	cmp    %al,%dl
  802032:	74 da                	je     80200e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  802034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802038:	75 07                	jne    802041 <strncmp+0x38>
		return 0;
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	eb 14                	jmp    802055 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802041:	8b 45 08             	mov    0x8(%ebp),%eax
  802044:	8a 00                	mov    (%eax),%al
  802046:	0f b6 d0             	movzbl %al,%edx
  802049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204c:	8a 00                	mov    (%eax),%al
  80204e:	0f b6 c0             	movzbl %al,%eax
  802051:	29 c2                	sub    %eax,%edx
  802053:	89 d0                	mov    %edx,%eax
}
  802055:	5d                   	pop    %ebp
  802056:	c3                   	ret    

00802057 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 04             	sub    $0x4,%esp
  80205d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802060:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802063:	eb 12                	jmp    802077 <strchr+0x20>
		if (*s == c)
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	8a 00                	mov    (%eax),%al
  80206a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80206d:	75 05                	jne    802074 <strchr+0x1d>
			return (char *) s;
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	eb 11                	jmp    802085 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  802074:	ff 45 08             	incl   0x8(%ebp)
  802077:	8b 45 08             	mov    0x8(%ebp),%eax
  80207a:	8a 00                	mov    (%eax),%al
  80207c:	84 c0                	test   %al,%al
  80207e:	75 e5                	jne    802065 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 04             	sub    $0x4,%esp
  80208d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802090:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  802093:	eb 0d                	jmp    8020a2 <strfind+0x1b>
		if (*s == c)
  802095:	8b 45 08             	mov    0x8(%ebp),%eax
  802098:	8a 00                	mov    (%eax),%al
  80209a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80209d:	74 0e                	je     8020ad <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80209f:	ff 45 08             	incl   0x8(%ebp)
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	8a 00                	mov    (%eax),%al
  8020a7:	84 c0                	test   %al,%al
  8020a9:	75 ea                	jne    802095 <strfind+0xe>
  8020ab:	eb 01                	jmp    8020ae <strfind+0x27>
		if (*s == c)
			break;
  8020ad:	90                   	nop
	return (char *) s;
  8020ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020b1:	c9                   	leave  
  8020b2:	c3                   	ret    

008020b3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8020b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8020bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8020c5:	eb 0e                	jmp    8020d5 <memset+0x22>
		*p++ = c;
  8020c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ca:	8d 50 01             	lea    0x1(%eax),%edx
  8020cd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8020d5:	ff 4d f8             	decl   -0x8(%ebp)
  8020d8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8020dc:	79 e9                	jns    8020c7 <memset+0x14>
		*p++ = c;

	return v;
  8020de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8020e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8020ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8020f5:	eb 16                	jmp    80210d <memcpy+0x2a>
		*d++ = *s++;
  8020f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020fa:	8d 50 01             	lea    0x1(%eax),%edx
  8020fd:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802100:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802103:	8d 4a 01             	lea    0x1(%edx),%ecx
  802106:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802109:	8a 12                	mov    (%edx),%dl
  80210b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80210d:	8b 45 10             	mov    0x10(%ebp),%eax
  802110:	8d 50 ff             	lea    -0x1(%eax),%edx
  802113:	89 55 10             	mov    %edx,0x10(%ebp)
  802116:	85 c0                	test   %eax,%eax
  802118:	75 dd                	jne    8020f7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  802125:	8b 45 0c             	mov    0xc(%ebp),%eax
  802128:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  802131:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802134:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802137:	73 50                	jae    802189 <memmove+0x6a>
  802139:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80213c:	8b 45 10             	mov    0x10(%ebp),%eax
  80213f:	01 d0                	add    %edx,%eax
  802141:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  802144:	76 43                	jbe    802189 <memmove+0x6a>
		s += n;
  802146:	8b 45 10             	mov    0x10(%ebp),%eax
  802149:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80214c:	8b 45 10             	mov    0x10(%ebp),%eax
  80214f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  802152:	eb 10                	jmp    802164 <memmove+0x45>
			*--d = *--s;
  802154:	ff 4d f8             	decl   -0x8(%ebp)
  802157:	ff 4d fc             	decl   -0x4(%ebp)
  80215a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215d:	8a 10                	mov    (%eax),%dl
  80215f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802162:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  802164:	8b 45 10             	mov    0x10(%ebp),%eax
  802167:	8d 50 ff             	lea    -0x1(%eax),%edx
  80216a:	89 55 10             	mov    %edx,0x10(%ebp)
  80216d:	85 c0                	test   %eax,%eax
  80216f:	75 e3                	jne    802154 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802171:	eb 23                	jmp    802196 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  802173:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802176:	8d 50 01             	lea    0x1(%eax),%edx
  802179:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80217c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80217f:	8d 4a 01             	lea    0x1(%edx),%ecx
  802182:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  802185:	8a 12                	mov    (%edx),%dl
  802187:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802189:	8b 45 10             	mov    0x10(%ebp),%eax
  80218c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80218f:	89 55 10             	mov    %edx,0x10(%ebp)
  802192:	85 c0                	test   %eax,%eax
  802194:	75 dd                	jne    802173 <memmove+0x54>
			*d++ = *s++;

	return dst;
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
  80219e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8021a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021aa:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8021ad:	eb 2a                	jmp    8021d9 <memcmp+0x3e>
		if (*s1 != *s2)
  8021af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b2:	8a 10                	mov    (%eax),%dl
  8021b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021b7:	8a 00                	mov    (%eax),%al
  8021b9:	38 c2                	cmp    %al,%dl
  8021bb:	74 16                	je     8021d3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8021bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c0:	8a 00                	mov    (%eax),%al
  8021c2:	0f b6 d0             	movzbl %al,%edx
  8021c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021c8:	8a 00                	mov    (%eax),%al
  8021ca:	0f b6 c0             	movzbl %al,%eax
  8021cd:	29 c2                	sub    %eax,%edx
  8021cf:	89 d0                	mov    %edx,%eax
  8021d1:	eb 18                	jmp    8021eb <memcmp+0x50>
		s1++, s2++;
  8021d3:	ff 45 fc             	incl   -0x4(%ebp)
  8021d6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8021d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021dc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8021df:	89 55 10             	mov    %edx,0x10(%ebp)
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	75 c9                	jne    8021af <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8021e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021eb:	c9                   	leave  
  8021ec:	c3                   	ret    

008021ed <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8021f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f9:	01 d0                	add    %edx,%eax
  8021fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8021fe:	eb 15                	jmp    802215 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	8a 00                	mov    (%eax),%al
  802205:	0f b6 d0             	movzbl %al,%edx
  802208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80220b:	0f b6 c0             	movzbl %al,%eax
  80220e:	39 c2                	cmp    %eax,%edx
  802210:	74 0d                	je     80221f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802212:	ff 45 08             	incl   0x8(%ebp)
  802215:	8b 45 08             	mov    0x8(%ebp),%eax
  802218:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80221b:	72 e3                	jb     802200 <memfind+0x13>
  80221d:	eb 01                	jmp    802220 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80221f:	90                   	nop
	return (void *) s;
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802223:	c9                   	leave  
  802224:	c3                   	ret    

00802225 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80222b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  802232:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802239:	eb 03                	jmp    80223e <strtol+0x19>
		s++;
  80223b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80223e:	8b 45 08             	mov    0x8(%ebp),%eax
  802241:	8a 00                	mov    (%eax),%al
  802243:	3c 20                	cmp    $0x20,%al
  802245:	74 f4                	je     80223b <strtol+0x16>
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8a 00                	mov    (%eax),%al
  80224c:	3c 09                	cmp    $0x9,%al
  80224e:	74 eb                	je     80223b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	8a 00                	mov    (%eax),%al
  802255:	3c 2b                	cmp    $0x2b,%al
  802257:	75 05                	jne    80225e <strtol+0x39>
		s++;
  802259:	ff 45 08             	incl   0x8(%ebp)
  80225c:	eb 13                	jmp    802271 <strtol+0x4c>
	else if (*s == '-')
  80225e:	8b 45 08             	mov    0x8(%ebp),%eax
  802261:	8a 00                	mov    (%eax),%al
  802263:	3c 2d                	cmp    $0x2d,%al
  802265:	75 0a                	jne    802271 <strtol+0x4c>
		s++, neg = 1;
  802267:	ff 45 08             	incl   0x8(%ebp)
  80226a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802271:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802275:	74 06                	je     80227d <strtol+0x58>
  802277:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80227b:	75 20                	jne    80229d <strtol+0x78>
  80227d:	8b 45 08             	mov    0x8(%ebp),%eax
  802280:	8a 00                	mov    (%eax),%al
  802282:	3c 30                	cmp    $0x30,%al
  802284:	75 17                	jne    80229d <strtol+0x78>
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	40                   	inc    %eax
  80228a:	8a 00                	mov    (%eax),%al
  80228c:	3c 78                	cmp    $0x78,%al
  80228e:	75 0d                	jne    80229d <strtol+0x78>
		s += 2, base = 16;
  802290:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  802294:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80229b:	eb 28                	jmp    8022c5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80229d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022a1:	75 15                	jne    8022b8 <strtol+0x93>
  8022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a6:	8a 00                	mov    (%eax),%al
  8022a8:	3c 30                	cmp    $0x30,%al
  8022aa:	75 0c                	jne    8022b8 <strtol+0x93>
		s++, base = 8;
  8022ac:	ff 45 08             	incl   0x8(%ebp)
  8022af:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8022b6:	eb 0d                	jmp    8022c5 <strtol+0xa0>
	else if (base == 0)
  8022b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022bc:	75 07                	jne    8022c5 <strtol+0xa0>
		base = 10;
  8022be:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	8a 00                	mov    (%eax),%al
  8022ca:	3c 2f                	cmp    $0x2f,%al
  8022cc:	7e 19                	jle    8022e7 <strtol+0xc2>
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8a 00                	mov    (%eax),%al
  8022d3:	3c 39                	cmp    $0x39,%al
  8022d5:	7f 10                	jg     8022e7 <strtol+0xc2>
			dig = *s - '0';
  8022d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022da:	8a 00                	mov    (%eax),%al
  8022dc:	0f be c0             	movsbl %al,%eax
  8022df:	83 e8 30             	sub    $0x30,%eax
  8022e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e5:	eb 42                	jmp    802329 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	8a 00                	mov    (%eax),%al
  8022ec:	3c 60                	cmp    $0x60,%al
  8022ee:	7e 19                	jle    802309 <strtol+0xe4>
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8a 00                	mov    (%eax),%al
  8022f5:	3c 7a                	cmp    $0x7a,%al
  8022f7:	7f 10                	jg     802309 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	8a 00                	mov    (%eax),%al
  8022fe:	0f be c0             	movsbl %al,%eax
  802301:	83 e8 57             	sub    $0x57,%eax
  802304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802307:	eb 20                	jmp    802329 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8a 00                	mov    (%eax),%al
  80230e:	3c 40                	cmp    $0x40,%al
  802310:	7e 39                	jle    80234b <strtol+0x126>
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	8a 00                	mov    (%eax),%al
  802317:	3c 5a                	cmp    $0x5a,%al
  802319:	7f 30                	jg     80234b <strtol+0x126>
			dig = *s - 'A' + 10;
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8a 00                	mov    (%eax),%al
  802320:	0f be c0             	movsbl %al,%eax
  802323:	83 e8 37             	sub    $0x37,%eax
  802326:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80232f:	7d 19                	jge    80234a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  802331:	ff 45 08             	incl   0x8(%ebp)
  802334:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802337:	0f af 45 10          	imul   0x10(%ebp),%eax
  80233b:	89 c2                	mov    %eax,%edx
  80233d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802340:	01 d0                	add    %edx,%eax
  802342:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  802345:	e9 7b ff ff ff       	jmp    8022c5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80234a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80234b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80234f:	74 08                	je     802359 <strtol+0x134>
		*endptr = (char *) s;
  802351:	8b 45 0c             	mov    0xc(%ebp),%eax
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  802359:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80235d:	74 07                	je     802366 <strtol+0x141>
  80235f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802362:	f7 d8                	neg    %eax
  802364:	eb 03                	jmp    802369 <strtol+0x144>
  802366:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802369:	c9                   	leave  
  80236a:	c3                   	ret    

0080236b <ltostr>:

void
ltostr(long value, char *str)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  802371:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802378:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80237f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802383:	79 13                	jns    802398 <ltostr+0x2d>
	{
		neg = 1;
  802385:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80238c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  802392:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  802395:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8023a0:	99                   	cltd   
  8023a1:	f7 f9                	idiv   %ecx
  8023a3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8023a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8023a9:	8d 50 01             	lea    0x1(%eax),%edx
  8023ac:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8023af:	89 c2                	mov    %eax,%edx
  8023b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b4:	01 d0                	add    %edx,%eax
  8023b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b9:	83 c2 30             	add    $0x30,%edx
  8023bc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8023be:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023c1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023c6:	f7 e9                	imul   %ecx
  8023c8:	c1 fa 02             	sar    $0x2,%edx
  8023cb:	89 c8                	mov    %ecx,%eax
  8023cd:	c1 f8 1f             	sar    $0x1f,%eax
  8023d0:	29 c2                	sub    %eax,%edx
  8023d2:	89 d0                	mov    %edx,%eax
  8023d4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8023d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8023df:	f7 e9                	imul   %ecx
  8023e1:	c1 fa 02             	sar    $0x2,%edx
  8023e4:	89 c8                	mov    %ecx,%eax
  8023e6:	c1 f8 1f             	sar    $0x1f,%eax
  8023e9:	29 c2                	sub    %eax,%edx
  8023eb:	89 d0                	mov    %edx,%eax
  8023ed:	c1 e0 02             	shl    $0x2,%eax
  8023f0:	01 d0                	add    %edx,%eax
  8023f2:	01 c0                	add    %eax,%eax
  8023f4:	29 c1                	sub    %eax,%ecx
  8023f6:	89 ca                	mov    %ecx,%edx
  8023f8:	85 d2                	test   %edx,%edx
  8023fa:	75 9c                	jne    802398 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8023fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  802403:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802406:	48                   	dec    %eax
  802407:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80240a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80240e:	74 3d                	je     80244d <ltostr+0xe2>
		start = 1 ;
  802410:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  802417:	eb 34                	jmp    80244d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  802419:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80241c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241f:	01 d0                	add    %edx,%eax
  802421:	8a 00                	mov    (%eax),%al
  802423:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  802426:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802429:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242c:	01 c2                	add    %eax,%edx
  80242e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802431:	8b 45 0c             	mov    0xc(%ebp),%eax
  802434:	01 c8                	add    %ecx,%eax
  802436:	8a 00                	mov    (%eax),%al
  802438:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80243a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802440:	01 c2                	add    %eax,%edx
  802442:	8a 45 eb             	mov    -0x15(%ebp),%al
  802445:	88 02                	mov    %al,(%edx)
		start++ ;
  802447:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80244a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802453:	7c c4                	jl     802419 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  802455:	8b 55 f8             	mov    -0x8(%ebp),%edx
  802458:	8b 45 0c             	mov    0xc(%ebp),%eax
  80245b:	01 d0                	add    %edx,%eax
  80245d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  802460:	90                   	nop
  802461:	c9                   	leave  
  802462:	c3                   	ret    

00802463 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  802463:	55                   	push   %ebp
  802464:	89 e5                	mov    %esp,%ebp
  802466:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802469:	ff 75 08             	pushl  0x8(%ebp)
  80246c:	e8 54 fa ff ff       	call   801ec5 <strlen>
  802471:	83 c4 04             	add    $0x4,%esp
  802474:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802477:	ff 75 0c             	pushl  0xc(%ebp)
  80247a:	e8 46 fa ff ff       	call   801ec5 <strlen>
  80247f:	83 c4 04             	add    $0x4,%esp
  802482:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  802485:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80248c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  802493:	eb 17                	jmp    8024ac <strcconcat+0x49>
		final[s] = str1[s] ;
  802495:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802498:	8b 45 10             	mov    0x10(%ebp),%eax
  80249b:	01 c2                	add    %eax,%edx
  80249d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8024a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a3:	01 c8                	add    %ecx,%eax
  8024a5:	8a 00                	mov    (%eax),%al
  8024a7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8024a9:	ff 45 fc             	incl   -0x4(%ebp)
  8024ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024af:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8024b2:	7c e1                	jl     802495 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8024b4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8024bb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8024c2:	eb 1f                	jmp    8024e3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8024c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024c7:	8d 50 01             	lea    0x1(%eax),%edx
  8024ca:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8024cd:	89 c2                	mov    %eax,%edx
  8024cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d2:	01 c2                	add    %eax,%edx
  8024d4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	01 c8                	add    %ecx,%eax
  8024dc:	8a 00                	mov    (%eax),%al
  8024de:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8024e0:	ff 45 f8             	incl   -0x8(%ebp)
  8024e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024e9:	7c d9                	jl     8024c4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8024eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	c6 00 00             	movb   $0x0,(%eax)
}
  8024f6:	90                   	nop
  8024f7:	c9                   	leave  
  8024f8:	c3                   	ret    

008024f9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8024f9:	55                   	push   %ebp
  8024fa:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8024fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  802505:	8b 45 14             	mov    0x14(%ebp),%eax
  802508:	8b 00                	mov    (%eax),%eax
  80250a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802511:	8b 45 10             	mov    0x10(%ebp),%eax
  802514:	01 d0                	add    %edx,%eax
  802516:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80251c:	eb 0c                	jmp    80252a <strsplit+0x31>
			*string++ = 0;
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	8d 50 01             	lea    0x1(%eax),%edx
  802524:	89 55 08             	mov    %edx,0x8(%ebp)
  802527:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80252a:	8b 45 08             	mov    0x8(%ebp),%eax
  80252d:	8a 00                	mov    (%eax),%al
  80252f:	84 c0                	test   %al,%al
  802531:	74 18                	je     80254b <strsplit+0x52>
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	8a 00                	mov    (%eax),%al
  802538:	0f be c0             	movsbl %al,%eax
  80253b:	50                   	push   %eax
  80253c:	ff 75 0c             	pushl  0xc(%ebp)
  80253f:	e8 13 fb ff ff       	call   802057 <strchr>
  802544:	83 c4 08             	add    $0x8,%esp
  802547:	85 c0                	test   %eax,%eax
  802549:	75 d3                	jne    80251e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	8a 00                	mov    (%eax),%al
  802550:	84 c0                	test   %al,%al
  802552:	74 5a                	je     8025ae <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  802554:	8b 45 14             	mov    0x14(%ebp),%eax
  802557:	8b 00                	mov    (%eax),%eax
  802559:	83 f8 0f             	cmp    $0xf,%eax
  80255c:	75 07                	jne    802565 <strsplit+0x6c>
		{
			return 0;
  80255e:	b8 00 00 00 00       	mov    $0x0,%eax
  802563:	eb 66                	jmp    8025cb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  802565:	8b 45 14             	mov    0x14(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	8d 48 01             	lea    0x1(%eax),%ecx
  80256d:	8b 55 14             	mov    0x14(%ebp),%edx
  802570:	89 0a                	mov    %ecx,(%edx)
  802572:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802579:	8b 45 10             	mov    0x10(%ebp),%eax
  80257c:	01 c2                	add    %eax,%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  802583:	eb 03                	jmp    802588 <strsplit+0x8f>
			string++;
  802585:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	8a 00                	mov    (%eax),%al
  80258d:	84 c0                	test   %al,%al
  80258f:	74 8b                	je     80251c <strsplit+0x23>
  802591:	8b 45 08             	mov    0x8(%ebp),%eax
  802594:	8a 00                	mov    (%eax),%al
  802596:	0f be c0             	movsbl %al,%eax
  802599:	50                   	push   %eax
  80259a:	ff 75 0c             	pushl  0xc(%ebp)
  80259d:	e8 b5 fa ff ff       	call   802057 <strchr>
  8025a2:	83 c4 08             	add    $0x8,%esp
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	74 dc                	je     802585 <strsplit+0x8c>
			string++;
	}
  8025a9:	e9 6e ff ff ff       	jmp    80251c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8025ae:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8025af:	8b 45 14             	mov    0x14(%ebp),%eax
  8025b2:	8b 00                	mov    (%eax),%eax
  8025b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8025bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8025be:	01 d0                	add    %edx,%eax
  8025c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8025c6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8025cb:	c9                   	leave  
  8025cc:	c3                   	ret    

008025cd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8025cd:	55                   	push   %ebp
  8025ce:	89 e5                	mov    %esp,%ebp
  8025d0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8025d3:	a1 04 60 80 00       	mov    0x806004,%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 1f                	je     8025fb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8025dc:	e8 1d 00 00 00       	call   8025fe <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8025e1:	83 ec 0c             	sub    $0xc,%esp
  8025e4:	68 d0 4d 80 00       	push   $0x804dd0
  8025e9:	e8 55 f2 ff ff       	call   801843 <cprintf>
  8025ee:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8025f1:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  8025f8:	00 00 00 
	}
}
  8025fb:	90                   	nop
  8025fc:	c9                   	leave  
  8025fd:	c3                   	ret    

008025fe <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8025fe:	55                   	push   %ebp
  8025ff:	89 e5                	mov    %esp,%ebp
  802601:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  802604:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  80260b:	00 00 00 
  80260e:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  802615:	00 00 00 
  802618:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  80261f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  802622:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  802629:	00 00 00 
  80262c:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  802633:	00 00 00 
  802636:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  80263d:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  802640:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	c1 e8 0c             	shr    $0xc,%eax
  80264d:	a3 20 61 80 00       	mov    %eax,0x806120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  802652:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  802659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802661:	2d 00 10 00 00       	sub    $0x1000,%eax
  802666:	a3 50 60 80 00       	mov    %eax,0x806050
		uint32 MEMsize=sizeof(struct MemBlock);
  80266b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  802672:	a1 20 61 80 00       	mov    0x806120,%eax
  802677:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80267b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80267e:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  802685:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80268b:	01 d0                	add    %edx,%eax
  80268d:	48                   	dec    %eax
  80268e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802691:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802694:	ba 00 00 00 00       	mov    $0x0,%edx
  802699:	f7 75 e4             	divl   -0x1c(%ebp)
  80269c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269f:	29 d0                	sub    %edx,%eax
  8026a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8026a4:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8026ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8026b3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8026b8:	83 ec 04             	sub    $0x4,%esp
  8026bb:	6a 07                	push   $0x7
  8026bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8026c0:	50                   	push   %eax
  8026c1:	e8 3d 06 00 00       	call   802d03 <sys_allocate_chunk>
  8026c6:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8026c9:	a1 20 61 80 00       	mov    0x806120,%eax
  8026ce:	83 ec 0c             	sub    $0xc,%esp
  8026d1:	50                   	push   %eax
  8026d2:	e8 b2 0c 00 00       	call   803389 <initialize_MemBlocksList>
  8026d7:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8026da:	a1 4c 61 80 00       	mov    0x80614c,%eax
  8026df:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8026e2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8026e6:	0f 84 f3 00 00 00    	je     8027df <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8026ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8026f0:	75 14                	jne    802706 <initialize_dyn_block_system+0x108>
  8026f2:	83 ec 04             	sub    $0x4,%esp
  8026f5:	68 f5 4d 80 00       	push   $0x804df5
  8026fa:	6a 36                	push   $0x36
  8026fc:	68 13 4e 80 00       	push   $0x804e13
  802701:	e8 89 ee ff ff       	call   80158f <_panic>
  802706:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802709:	8b 00                	mov    (%eax),%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	74 10                	je     80271f <initialize_dyn_block_system+0x121>
  80270f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802712:	8b 00                	mov    (%eax),%eax
  802714:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802717:	8b 52 04             	mov    0x4(%edx),%edx
  80271a:	89 50 04             	mov    %edx,0x4(%eax)
  80271d:	eb 0b                	jmp    80272a <initialize_dyn_block_system+0x12c>
  80271f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802722:	8b 40 04             	mov    0x4(%eax),%eax
  802725:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80272a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80272d:	8b 40 04             	mov    0x4(%eax),%eax
  802730:	85 c0                	test   %eax,%eax
  802732:	74 0f                	je     802743 <initialize_dyn_block_system+0x145>
  802734:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802737:	8b 40 04             	mov    0x4(%eax),%eax
  80273a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80273d:	8b 12                	mov    (%edx),%edx
  80273f:	89 10                	mov    %edx,(%eax)
  802741:	eb 0a                	jmp    80274d <initialize_dyn_block_system+0x14f>
  802743:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802746:	8b 00                	mov    (%eax),%eax
  802748:	a3 48 61 80 00       	mov    %eax,0x806148
  80274d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802750:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802756:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802759:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802760:	a1 54 61 80 00       	mov    0x806154,%eax
  802765:	48                   	dec    %eax
  802766:	a3 54 61 80 00       	mov    %eax,0x806154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80276b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80276e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  802775:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802778:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80277f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802783:	75 14                	jne    802799 <initialize_dyn_block_system+0x19b>
  802785:	83 ec 04             	sub    $0x4,%esp
  802788:	68 20 4e 80 00       	push   $0x804e20
  80278d:	6a 3e                	push   $0x3e
  80278f:	68 13 4e 80 00       	push   $0x804e13
  802794:	e8 f6 ed ff ff       	call   80158f <_panic>
  802799:	8b 15 38 61 80 00    	mov    0x806138,%edx
  80279f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027a2:	89 10                	mov    %edx,(%eax)
  8027a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	85 c0                	test   %eax,%eax
  8027ab:	74 0d                	je     8027ba <initialize_dyn_block_system+0x1bc>
  8027ad:	a1 38 61 80 00       	mov    0x806138,%eax
  8027b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8027b5:	89 50 04             	mov    %edx,0x4(%eax)
  8027b8:	eb 08                	jmp    8027c2 <initialize_dyn_block_system+0x1c4>
  8027ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027bd:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8027c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027c5:	a3 38 61 80 00       	mov    %eax,0x806138
  8027ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8027cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d4:	a1 44 61 80 00       	mov    0x806144,%eax
  8027d9:	40                   	inc    %eax
  8027da:	a3 44 61 80 00       	mov    %eax,0x806144

				}


}
  8027df:	90                   	nop
  8027e0:	c9                   	leave  
  8027e1:	c3                   	ret    

008027e2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8027e8:	e8 e0 fd ff ff       	call   8025cd <InitializeUHeap>
		if (size == 0) return NULL ;
  8027ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027f1:	75 07                	jne    8027fa <malloc+0x18>
  8027f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027f8:	eb 7f                	jmp    802879 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8027fa:	e8 d2 08 00 00       	call   8030d1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8027ff:	85 c0                	test   %eax,%eax
  802801:	74 71                	je     802874 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  802803:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80280a:	8b 55 08             	mov    0x8(%ebp),%edx
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	01 d0                	add    %edx,%eax
  802812:	48                   	dec    %eax
  802813:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	ba 00 00 00 00       	mov    $0x0,%edx
  80281e:	f7 75 f4             	divl   -0xc(%ebp)
  802821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802824:	29 d0                	sub    %edx,%eax
  802826:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  802829:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  802830:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  802837:	76 07                	jbe    802840 <malloc+0x5e>
					return NULL ;
  802839:	b8 00 00 00 00       	mov    $0x0,%eax
  80283e:	eb 39                	jmp    802879 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  802840:	83 ec 0c             	sub    $0xc,%esp
  802843:	ff 75 08             	pushl  0x8(%ebp)
  802846:	e8 e6 0d 00 00       	call   803631 <alloc_block_FF>
  80284b:	83 c4 10             	add    $0x10,%esp
  80284e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  802851:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802855:	74 16                	je     80286d <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  802857:	83 ec 0c             	sub    $0xc,%esp
  80285a:	ff 75 ec             	pushl  -0x14(%ebp)
  80285d:	e8 37 0c 00 00       	call   803499 <insert_sorted_allocList>
  802862:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  802865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802868:	8b 40 08             	mov    0x8(%eax),%eax
  80286b:	eb 0c                	jmp    802879 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  80286d:	b8 00 00 00 00       	mov    $0x0,%eax
  802872:	eb 05                	jmp    802879 <malloc+0x97>
				}
		}
	return 0;
  802874:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802879:	c9                   	leave  
  80287a:	c3                   	ret    

0080287b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80287b:	55                   	push   %ebp
  80287c:	89 e5                	mov    %esp,%ebp
  80287e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  802881:	8b 45 08             	mov    0x8(%ebp),%eax
  802884:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  802887:	83 ec 08             	sub    $0x8,%esp
  80288a:	ff 75 f4             	pushl  -0xc(%ebp)
  80288d:	68 40 60 80 00       	push   $0x806040
  802892:	e8 cf 0b 00 00       	call   803466 <find_block>
  802897:	83 c4 10             	add    $0x10,%esp
  80289a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  80289d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8028a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a9:	8b 40 08             	mov    0x8(%eax),%eax
  8028ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8028af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b3:	0f 84 a1 00 00 00    	je     80295a <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8028b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028bd:	75 17                	jne    8028d6 <free+0x5b>
  8028bf:	83 ec 04             	sub    $0x4,%esp
  8028c2:	68 f5 4d 80 00       	push   $0x804df5
  8028c7:	68 80 00 00 00       	push   $0x80
  8028cc:	68 13 4e 80 00       	push   $0x804e13
  8028d1:	e8 b9 ec ff ff       	call   80158f <_panic>
  8028d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d9:	8b 00                	mov    (%eax),%eax
  8028db:	85 c0                	test   %eax,%eax
  8028dd:	74 10                	je     8028ef <free+0x74>
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e7:	8b 52 04             	mov    0x4(%edx),%edx
  8028ea:	89 50 04             	mov    %edx,0x4(%eax)
  8028ed:	eb 0b                	jmp    8028fa <free+0x7f>
  8028ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	a3 44 60 80 00       	mov    %eax,0x806044
  8028fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fd:	8b 40 04             	mov    0x4(%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	74 0f                	je     802913 <free+0x98>
  802904:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80290d:	8b 12                	mov    (%edx),%edx
  80290f:	89 10                	mov    %edx,(%eax)
  802911:	eb 0a                	jmp    80291d <free+0xa2>
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	8b 00                	mov    (%eax),%eax
  802918:	a3 40 60 80 00       	mov    %eax,0x806040
  80291d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802920:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802926:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802929:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802930:	a1 4c 60 80 00       	mov    0x80604c,%eax
  802935:	48                   	dec    %eax
  802936:	a3 4c 60 80 00       	mov    %eax,0x80604c
			insert_sorted_with_merge_freeList(block);
  80293b:	83 ec 0c             	sub    $0xc,%esp
  80293e:	ff 75 f0             	pushl  -0x10(%ebp)
  802941:	e8 29 12 00 00       	call   803b6f <insert_sorted_with_merge_freeList>
  802946:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  802949:	83 ec 08             	sub    $0x8,%esp
  80294c:	ff 75 ec             	pushl  -0x14(%ebp)
  80294f:	ff 75 e8             	pushl  -0x18(%ebp)
  802952:	e8 74 03 00 00       	call   802ccb <sys_free_user_mem>
  802957:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80295a:	90                   	nop
  80295b:	c9                   	leave  
  80295c:	c3                   	ret    

0080295d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80295d:	55                   	push   %ebp
  80295e:	89 e5                	mov    %esp,%ebp
  802960:	83 ec 38             	sub    $0x38,%esp
  802963:	8b 45 10             	mov    0x10(%ebp),%eax
  802966:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802969:	e8 5f fc ff ff       	call   8025cd <InitializeUHeap>
	if (size == 0) return NULL ;
  80296e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802972:	75 0a                	jne    80297e <smalloc+0x21>
  802974:	b8 00 00 00 00       	mov    $0x0,%eax
  802979:	e9 b2 00 00 00       	jmp    802a30 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  80297e:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  802985:	76 0a                	jbe    802991 <smalloc+0x34>
		return NULL;
  802987:	b8 00 00 00 00       	mov    $0x0,%eax
  80298c:	e9 9f 00 00 00       	jmp    802a30 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  802991:	e8 3b 07 00 00       	call   8030d1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802996:	85 c0                	test   %eax,%eax
  802998:	0f 84 8d 00 00 00    	je     802a2b <smalloc+0xce>
	struct MemBlock *b = NULL;
  80299e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8029a5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8029ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8029af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b2:	01 d0                	add    %edx,%eax
  8029b4:	48                   	dec    %eax
  8029b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8029b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8029c0:	f7 75 f0             	divl   -0x10(%ebp)
  8029c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c6:	29 d0                	sub    %edx,%eax
  8029c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8029cb:	83 ec 0c             	sub    $0xc,%esp
  8029ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8029d1:	e8 5b 0c 00 00       	call   803631 <alloc_block_FF>
  8029d6:	83 c4 10             	add    $0x10,%esp
  8029d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8029dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029e0:	75 07                	jne    8029e9 <smalloc+0x8c>
			return NULL;
  8029e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e7:	eb 47                	jmp    802a30 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8029e9:	83 ec 0c             	sub    $0xc,%esp
  8029ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8029ef:	e8 a5 0a 00 00       	call   803499 <insert_sorted_allocList>
  8029f4:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fa:	8b 40 08             	mov    0x8(%eax),%eax
  8029fd:	89 c2                	mov    %eax,%edx
  8029ff:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  802a03:	52                   	push   %edx
  802a04:	50                   	push   %eax
  802a05:	ff 75 0c             	pushl  0xc(%ebp)
  802a08:	ff 75 08             	pushl  0x8(%ebp)
  802a0b:	e8 46 04 00 00       	call   802e56 <sys_createSharedObject>
  802a10:	83 c4 10             	add    $0x10,%esp
  802a13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  802a16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802a1a:	78 08                	js     802a24 <smalloc+0xc7>
		return (void *)b->sva;
  802a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1f:	8b 40 08             	mov    0x8(%eax),%eax
  802a22:	eb 0c                	jmp    802a30 <smalloc+0xd3>
		}else{
		return NULL;
  802a24:	b8 00 00 00 00       	mov    $0x0,%eax
  802a29:	eb 05                	jmp    802a30 <smalloc+0xd3>
			}

	}return NULL;
  802a2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a30:	c9                   	leave  
  802a31:	c3                   	ret    

00802a32 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802a32:	55                   	push   %ebp
  802a33:	89 e5                	mov    %esp,%ebp
  802a35:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802a38:	e8 90 fb ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802a3d:	e8 8f 06 00 00       	call   8030d1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  802a42:	85 c0                	test   %eax,%eax
  802a44:	0f 84 ad 00 00 00    	je     802af7 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802a4a:	83 ec 08             	sub    $0x8,%esp
  802a4d:	ff 75 0c             	pushl  0xc(%ebp)
  802a50:	ff 75 08             	pushl  0x8(%ebp)
  802a53:	e8 28 04 00 00       	call   802e80 <sys_getSizeOfSharedObject>
  802a58:	83 c4 10             	add    $0x10,%esp
  802a5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  802a5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a62:	79 0a                	jns    802a6e <sget+0x3c>
    {
    	return NULL;
  802a64:	b8 00 00 00 00       	mov    $0x0,%eax
  802a69:	e9 8e 00 00 00       	jmp    802afc <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  802a6e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  802a75:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802a7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a82:	01 d0                	add    %edx,%eax
  802a84:	48                   	dec    %eax
  802a85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802a88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  802a90:	f7 75 ec             	divl   -0x14(%ebp)
  802a93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a96:	29 d0                	sub    %edx,%eax
  802a98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  802a9b:	83 ec 0c             	sub    $0xc,%esp
  802a9e:	ff 75 e4             	pushl  -0x1c(%ebp)
  802aa1:	e8 8b 0b 00 00       	call   803631 <alloc_block_FF>
  802aa6:	83 c4 10             	add    $0x10,%esp
  802aa9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  802aac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802ab0:	75 07                	jne    802ab9 <sget+0x87>
				return NULL;
  802ab2:	b8 00 00 00 00       	mov    $0x0,%eax
  802ab7:	eb 43                	jmp    802afc <sget+0xca>
			}
			insert_sorted_allocList(b);
  802ab9:	83 ec 0c             	sub    $0xc,%esp
  802abc:	ff 75 f0             	pushl  -0x10(%ebp)
  802abf:	e8 d5 09 00 00       	call   803499 <insert_sorted_allocList>
  802ac4:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  802ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aca:	8b 40 08             	mov    0x8(%eax),%eax
  802acd:	83 ec 04             	sub    $0x4,%esp
  802ad0:	50                   	push   %eax
  802ad1:	ff 75 0c             	pushl  0xc(%ebp)
  802ad4:	ff 75 08             	pushl  0x8(%ebp)
  802ad7:	e8 c1 03 00 00       	call   802e9d <sys_getSharedObject>
  802adc:	83 c4 10             	add    $0x10,%esp
  802adf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  802ae2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802ae6:	78 08                	js     802af0 <sget+0xbe>
			return (void *)b->sva;
  802ae8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aeb:	8b 40 08             	mov    0x8(%eax),%eax
  802aee:	eb 0c                	jmp    802afc <sget+0xca>
			}else{
			return NULL;
  802af0:	b8 00 00 00 00       	mov    $0x0,%eax
  802af5:	eb 05                	jmp    802afc <sget+0xca>
			}
    }}return NULL;
  802af7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802afc:	c9                   	leave  
  802afd:	c3                   	ret    

00802afe <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802afe:	55                   	push   %ebp
  802aff:	89 e5                	mov    %esp,%ebp
  802b01:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802b04:	e8 c4 fa ff ff       	call   8025cd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802b09:	83 ec 04             	sub    $0x4,%esp
  802b0c:	68 44 4e 80 00       	push   $0x804e44
  802b11:	68 03 01 00 00       	push   $0x103
  802b16:	68 13 4e 80 00       	push   $0x804e13
  802b1b:	e8 6f ea ff ff       	call   80158f <_panic>

00802b20 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802b20:	55                   	push   %ebp
  802b21:	89 e5                	mov    %esp,%ebp
  802b23:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  802b26:	83 ec 04             	sub    $0x4,%esp
  802b29:	68 6c 4e 80 00       	push   $0x804e6c
  802b2e:	68 17 01 00 00       	push   $0x117
  802b33:	68 13 4e 80 00       	push   $0x804e13
  802b38:	e8 52 ea ff ff       	call   80158f <_panic>

00802b3d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802b3d:	55                   	push   %ebp
  802b3e:	89 e5                	mov    %esp,%ebp
  802b40:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b43:	83 ec 04             	sub    $0x4,%esp
  802b46:	68 90 4e 80 00       	push   $0x804e90
  802b4b:	68 22 01 00 00       	push   $0x122
  802b50:	68 13 4e 80 00       	push   $0x804e13
  802b55:	e8 35 ea ff ff       	call   80158f <_panic>

00802b5a <shrink>:

}
void shrink(uint32 newSize)
{
  802b5a:	55                   	push   %ebp
  802b5b:	89 e5                	mov    %esp,%ebp
  802b5d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b60:	83 ec 04             	sub    $0x4,%esp
  802b63:	68 90 4e 80 00       	push   $0x804e90
  802b68:	68 27 01 00 00       	push   $0x127
  802b6d:	68 13 4e 80 00       	push   $0x804e13
  802b72:	e8 18 ea ff ff       	call   80158f <_panic>

00802b77 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802b77:	55                   	push   %ebp
  802b78:	89 e5                	mov    %esp,%ebp
  802b7a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802b7d:	83 ec 04             	sub    $0x4,%esp
  802b80:	68 90 4e 80 00       	push   $0x804e90
  802b85:	68 2c 01 00 00       	push   $0x12c
  802b8a:	68 13 4e 80 00       	push   $0x804e13
  802b8f:	e8 fb e9 ff ff       	call   80158f <_panic>

00802b94 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802b94:	55                   	push   %ebp
  802b95:	89 e5                	mov    %esp,%ebp
  802b97:	57                   	push   %edi
  802b98:	56                   	push   %esi
  802b99:	53                   	push   %ebx
  802b9a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ba3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ba6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ba9:	8b 7d 18             	mov    0x18(%ebp),%edi
  802bac:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802baf:	cd 30                	int    $0x30
  802bb1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802bb7:	83 c4 10             	add    $0x10,%esp
  802bba:	5b                   	pop    %ebx
  802bbb:	5e                   	pop    %esi
  802bbc:	5f                   	pop    %edi
  802bbd:	5d                   	pop    %ebp
  802bbe:	c3                   	ret    

00802bbf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802bbf:	55                   	push   %ebp
  802bc0:	89 e5                	mov    %esp,%ebp
  802bc2:	83 ec 04             	sub    $0x4,%esp
  802bc5:	8b 45 10             	mov    0x10(%ebp),%eax
  802bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802bcb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	6a 00                	push   $0x0
  802bd4:	6a 00                	push   $0x0
  802bd6:	52                   	push   %edx
  802bd7:	ff 75 0c             	pushl  0xc(%ebp)
  802bda:	50                   	push   %eax
  802bdb:	6a 00                	push   $0x0
  802bdd:	e8 b2 ff ff ff       	call   802b94 <syscall>
  802be2:	83 c4 18             	add    $0x18,%esp
}
  802be5:	90                   	nop
  802be6:	c9                   	leave  
  802be7:	c3                   	ret    

00802be8 <sys_cgetc>:

int
sys_cgetc(void)
{
  802be8:	55                   	push   %ebp
  802be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802beb:	6a 00                	push   $0x0
  802bed:	6a 00                	push   $0x0
  802bef:	6a 00                	push   $0x0
  802bf1:	6a 00                	push   $0x0
  802bf3:	6a 00                	push   $0x0
  802bf5:	6a 01                	push   $0x1
  802bf7:	e8 98 ff ff ff       	call   802b94 <syscall>
  802bfc:	83 c4 18             	add    $0x18,%esp
}
  802bff:	c9                   	leave  
  802c00:	c3                   	ret    

00802c01 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802c01:	55                   	push   %ebp
  802c02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802c04:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	6a 00                	push   $0x0
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 00                	push   $0x0
  802c10:	52                   	push   %edx
  802c11:	50                   	push   %eax
  802c12:	6a 05                	push   $0x5
  802c14:	e8 7b ff ff ff       	call   802b94 <syscall>
  802c19:	83 c4 18             	add    $0x18,%esp
}
  802c1c:	c9                   	leave  
  802c1d:	c3                   	ret    

00802c1e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802c1e:	55                   	push   %ebp
  802c1f:	89 e5                	mov    %esp,%ebp
  802c21:	56                   	push   %esi
  802c22:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802c23:	8b 75 18             	mov    0x18(%ebp),%esi
  802c26:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802c29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	56                   	push   %esi
  802c33:	53                   	push   %ebx
  802c34:	51                   	push   %ecx
  802c35:	52                   	push   %edx
  802c36:	50                   	push   %eax
  802c37:	6a 06                	push   $0x6
  802c39:	e8 56 ff ff ff       	call   802b94 <syscall>
  802c3e:	83 c4 18             	add    $0x18,%esp
}
  802c41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c44:	5b                   	pop    %ebx
  802c45:	5e                   	pop    %esi
  802c46:	5d                   	pop    %ebp
  802c47:	c3                   	ret    

00802c48 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802c48:	55                   	push   %ebp
  802c49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802c4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	6a 00                	push   $0x0
  802c53:	6a 00                	push   $0x0
  802c55:	6a 00                	push   $0x0
  802c57:	52                   	push   %edx
  802c58:	50                   	push   %eax
  802c59:	6a 07                	push   $0x7
  802c5b:	e8 34 ff ff ff       	call   802b94 <syscall>
  802c60:	83 c4 18             	add    $0x18,%esp
}
  802c63:	c9                   	leave  
  802c64:	c3                   	ret    

00802c65 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802c65:	55                   	push   %ebp
  802c66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802c68:	6a 00                	push   $0x0
  802c6a:	6a 00                	push   $0x0
  802c6c:	6a 00                	push   $0x0
  802c6e:	ff 75 0c             	pushl  0xc(%ebp)
  802c71:	ff 75 08             	pushl  0x8(%ebp)
  802c74:	6a 08                	push   $0x8
  802c76:	e8 19 ff ff ff       	call   802b94 <syscall>
  802c7b:	83 c4 18             	add    $0x18,%esp
}
  802c7e:	c9                   	leave  
  802c7f:	c3                   	ret    

00802c80 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802c80:	55                   	push   %ebp
  802c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802c83:	6a 00                	push   $0x0
  802c85:	6a 00                	push   $0x0
  802c87:	6a 00                	push   $0x0
  802c89:	6a 00                	push   $0x0
  802c8b:	6a 00                	push   $0x0
  802c8d:	6a 09                	push   $0x9
  802c8f:	e8 00 ff ff ff       	call   802b94 <syscall>
  802c94:	83 c4 18             	add    $0x18,%esp
}
  802c97:	c9                   	leave  
  802c98:	c3                   	ret    

00802c99 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802c99:	55                   	push   %ebp
  802c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802c9c:	6a 00                	push   $0x0
  802c9e:	6a 00                	push   $0x0
  802ca0:	6a 00                	push   $0x0
  802ca2:	6a 00                	push   $0x0
  802ca4:	6a 00                	push   $0x0
  802ca6:	6a 0a                	push   $0xa
  802ca8:	e8 e7 fe ff ff       	call   802b94 <syscall>
  802cad:	83 c4 18             	add    $0x18,%esp
}
  802cb0:	c9                   	leave  
  802cb1:	c3                   	ret    

00802cb2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802cb2:	55                   	push   %ebp
  802cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802cb5:	6a 00                	push   $0x0
  802cb7:	6a 00                	push   $0x0
  802cb9:	6a 00                	push   $0x0
  802cbb:	6a 00                	push   $0x0
  802cbd:	6a 00                	push   $0x0
  802cbf:	6a 0b                	push   $0xb
  802cc1:	e8 ce fe ff ff       	call   802b94 <syscall>
  802cc6:	83 c4 18             	add    $0x18,%esp
}
  802cc9:	c9                   	leave  
  802cca:	c3                   	ret    

00802ccb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802ccb:	55                   	push   %ebp
  802ccc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802cce:	6a 00                	push   $0x0
  802cd0:	6a 00                	push   $0x0
  802cd2:	6a 00                	push   $0x0
  802cd4:	ff 75 0c             	pushl  0xc(%ebp)
  802cd7:	ff 75 08             	pushl  0x8(%ebp)
  802cda:	6a 0f                	push   $0xf
  802cdc:	e8 b3 fe ff ff       	call   802b94 <syscall>
  802ce1:	83 c4 18             	add    $0x18,%esp
	return;
  802ce4:	90                   	nop
}
  802ce5:	c9                   	leave  
  802ce6:	c3                   	ret    

00802ce7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802ce7:	55                   	push   %ebp
  802ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802cea:	6a 00                	push   $0x0
  802cec:	6a 00                	push   $0x0
  802cee:	6a 00                	push   $0x0
  802cf0:	ff 75 0c             	pushl  0xc(%ebp)
  802cf3:	ff 75 08             	pushl  0x8(%ebp)
  802cf6:	6a 10                	push   $0x10
  802cf8:	e8 97 fe ff ff       	call   802b94 <syscall>
  802cfd:	83 c4 18             	add    $0x18,%esp
	return ;
  802d00:	90                   	nop
}
  802d01:	c9                   	leave  
  802d02:	c3                   	ret    

00802d03 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802d03:	55                   	push   %ebp
  802d04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802d06:	6a 00                	push   $0x0
  802d08:	6a 00                	push   $0x0
  802d0a:	ff 75 10             	pushl  0x10(%ebp)
  802d0d:	ff 75 0c             	pushl  0xc(%ebp)
  802d10:	ff 75 08             	pushl  0x8(%ebp)
  802d13:	6a 11                	push   $0x11
  802d15:	e8 7a fe ff ff       	call   802b94 <syscall>
  802d1a:	83 c4 18             	add    $0x18,%esp
	return ;
  802d1d:	90                   	nop
}
  802d1e:	c9                   	leave  
  802d1f:	c3                   	ret    

00802d20 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802d20:	55                   	push   %ebp
  802d21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802d23:	6a 00                	push   $0x0
  802d25:	6a 00                	push   $0x0
  802d27:	6a 00                	push   $0x0
  802d29:	6a 00                	push   $0x0
  802d2b:	6a 00                	push   $0x0
  802d2d:	6a 0c                	push   $0xc
  802d2f:	e8 60 fe ff ff       	call   802b94 <syscall>
  802d34:	83 c4 18             	add    $0x18,%esp
}
  802d37:	c9                   	leave  
  802d38:	c3                   	ret    

00802d39 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802d39:	55                   	push   %ebp
  802d3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802d3c:	6a 00                	push   $0x0
  802d3e:	6a 00                	push   $0x0
  802d40:	6a 00                	push   $0x0
  802d42:	6a 00                	push   $0x0
  802d44:	ff 75 08             	pushl  0x8(%ebp)
  802d47:	6a 0d                	push   $0xd
  802d49:	e8 46 fe ff ff       	call   802b94 <syscall>
  802d4e:	83 c4 18             	add    $0x18,%esp
}
  802d51:	c9                   	leave  
  802d52:	c3                   	ret    

00802d53 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802d53:	55                   	push   %ebp
  802d54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802d56:	6a 00                	push   $0x0
  802d58:	6a 00                	push   $0x0
  802d5a:	6a 00                	push   $0x0
  802d5c:	6a 00                	push   $0x0
  802d5e:	6a 00                	push   $0x0
  802d60:	6a 0e                	push   $0xe
  802d62:	e8 2d fe ff ff       	call   802b94 <syscall>
  802d67:	83 c4 18             	add    $0x18,%esp
}
  802d6a:	90                   	nop
  802d6b:	c9                   	leave  
  802d6c:	c3                   	ret    

00802d6d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802d6d:	55                   	push   %ebp
  802d6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802d70:	6a 00                	push   $0x0
  802d72:	6a 00                	push   $0x0
  802d74:	6a 00                	push   $0x0
  802d76:	6a 00                	push   $0x0
  802d78:	6a 00                	push   $0x0
  802d7a:	6a 13                	push   $0x13
  802d7c:	e8 13 fe ff ff       	call   802b94 <syscall>
  802d81:	83 c4 18             	add    $0x18,%esp
}
  802d84:	90                   	nop
  802d85:	c9                   	leave  
  802d86:	c3                   	ret    

00802d87 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802d87:	55                   	push   %ebp
  802d88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802d8a:	6a 00                	push   $0x0
  802d8c:	6a 00                	push   $0x0
  802d8e:	6a 00                	push   $0x0
  802d90:	6a 00                	push   $0x0
  802d92:	6a 00                	push   $0x0
  802d94:	6a 14                	push   $0x14
  802d96:	e8 f9 fd ff ff       	call   802b94 <syscall>
  802d9b:	83 c4 18             	add    $0x18,%esp
}
  802d9e:	90                   	nop
  802d9f:	c9                   	leave  
  802da0:	c3                   	ret    

00802da1 <sys_cputc>:


void
sys_cputc(const char c)
{
  802da1:	55                   	push   %ebp
  802da2:	89 e5                	mov    %esp,%ebp
  802da4:	83 ec 04             	sub    $0x4,%esp
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802dad:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802db1:	6a 00                	push   $0x0
  802db3:	6a 00                	push   $0x0
  802db5:	6a 00                	push   $0x0
  802db7:	6a 00                	push   $0x0
  802db9:	50                   	push   %eax
  802dba:	6a 15                	push   $0x15
  802dbc:	e8 d3 fd ff ff       	call   802b94 <syscall>
  802dc1:	83 c4 18             	add    $0x18,%esp
}
  802dc4:	90                   	nop
  802dc5:	c9                   	leave  
  802dc6:	c3                   	ret    

00802dc7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802dc7:	55                   	push   %ebp
  802dc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802dca:	6a 00                	push   $0x0
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	6a 16                	push   $0x16
  802dd6:	e8 b9 fd ff ff       	call   802b94 <syscall>
  802ddb:	83 c4 18             	add    $0x18,%esp
}
  802dde:	90                   	nop
  802ddf:	c9                   	leave  
  802de0:	c3                   	ret    

00802de1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802de1:	55                   	push   %ebp
  802de2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	6a 00                	push   $0x0
  802de9:	6a 00                	push   $0x0
  802deb:	6a 00                	push   $0x0
  802ded:	ff 75 0c             	pushl  0xc(%ebp)
  802df0:	50                   	push   %eax
  802df1:	6a 17                	push   $0x17
  802df3:	e8 9c fd ff ff       	call   802b94 <syscall>
  802df8:	83 c4 18             	add    $0x18,%esp
}
  802dfb:	c9                   	leave  
  802dfc:	c3                   	ret    

00802dfd <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802dfd:	55                   	push   %ebp
  802dfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802e00:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	6a 00                	push   $0x0
  802e08:	6a 00                	push   $0x0
  802e0a:	6a 00                	push   $0x0
  802e0c:	52                   	push   %edx
  802e0d:	50                   	push   %eax
  802e0e:	6a 1a                	push   $0x1a
  802e10:	e8 7f fd ff ff       	call   802b94 <syscall>
  802e15:	83 c4 18             	add    $0x18,%esp
}
  802e18:	c9                   	leave  
  802e19:	c3                   	ret    

00802e1a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802e1a:	55                   	push   %ebp
  802e1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802e1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	6a 00                	push   $0x0
  802e25:	6a 00                	push   $0x0
  802e27:	6a 00                	push   $0x0
  802e29:	52                   	push   %edx
  802e2a:	50                   	push   %eax
  802e2b:	6a 18                	push   $0x18
  802e2d:	e8 62 fd ff ff       	call   802b94 <syscall>
  802e32:	83 c4 18             	add    $0x18,%esp
}
  802e35:	90                   	nop
  802e36:	c9                   	leave  
  802e37:	c3                   	ret    

00802e38 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802e38:	55                   	push   %ebp
  802e39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802e3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	6a 00                	push   $0x0
  802e43:	6a 00                	push   $0x0
  802e45:	6a 00                	push   $0x0
  802e47:	52                   	push   %edx
  802e48:	50                   	push   %eax
  802e49:	6a 19                	push   $0x19
  802e4b:	e8 44 fd ff ff       	call   802b94 <syscall>
  802e50:	83 c4 18             	add    $0x18,%esp
}
  802e53:	90                   	nop
  802e54:	c9                   	leave  
  802e55:	c3                   	ret    

00802e56 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802e56:	55                   	push   %ebp
  802e57:	89 e5                	mov    %esp,%ebp
  802e59:	83 ec 04             	sub    $0x4,%esp
  802e5c:	8b 45 10             	mov    0x10(%ebp),%eax
  802e5f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802e62:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802e65:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	6a 00                	push   $0x0
  802e6e:	51                   	push   %ecx
  802e6f:	52                   	push   %edx
  802e70:	ff 75 0c             	pushl  0xc(%ebp)
  802e73:	50                   	push   %eax
  802e74:	6a 1b                	push   $0x1b
  802e76:	e8 19 fd ff ff       	call   802b94 <syscall>
  802e7b:	83 c4 18             	add    $0x18,%esp
}
  802e7e:	c9                   	leave  
  802e7f:	c3                   	ret    

00802e80 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802e80:	55                   	push   %ebp
  802e81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	6a 00                	push   $0x0
  802e8b:	6a 00                	push   $0x0
  802e8d:	6a 00                	push   $0x0
  802e8f:	52                   	push   %edx
  802e90:	50                   	push   %eax
  802e91:	6a 1c                	push   $0x1c
  802e93:	e8 fc fc ff ff       	call   802b94 <syscall>
  802e98:	83 c4 18             	add    $0x18,%esp
}
  802e9b:	c9                   	leave  
  802e9c:	c3                   	ret    

00802e9d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802e9d:	55                   	push   %ebp
  802e9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802ea0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	6a 00                	push   $0x0
  802eab:	6a 00                	push   $0x0
  802ead:	51                   	push   %ecx
  802eae:	52                   	push   %edx
  802eaf:	50                   	push   %eax
  802eb0:	6a 1d                	push   $0x1d
  802eb2:	e8 dd fc ff ff       	call   802b94 <syscall>
  802eb7:	83 c4 18             	add    $0x18,%esp
}
  802eba:	c9                   	leave  
  802ebb:	c3                   	ret    

00802ebc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802ebc:	55                   	push   %ebp
  802ebd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	6a 00                	push   $0x0
  802ec7:	6a 00                	push   $0x0
  802ec9:	6a 00                	push   $0x0
  802ecb:	52                   	push   %edx
  802ecc:	50                   	push   %eax
  802ecd:	6a 1e                	push   $0x1e
  802ecf:	e8 c0 fc ff ff       	call   802b94 <syscall>
  802ed4:	83 c4 18             	add    $0x18,%esp
}
  802ed7:	c9                   	leave  
  802ed8:	c3                   	ret    

00802ed9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802ed9:	55                   	push   %ebp
  802eda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802edc:	6a 00                	push   $0x0
  802ede:	6a 00                	push   $0x0
  802ee0:	6a 00                	push   $0x0
  802ee2:	6a 00                	push   $0x0
  802ee4:	6a 00                	push   $0x0
  802ee6:	6a 1f                	push   $0x1f
  802ee8:	e8 a7 fc ff ff       	call   802b94 <syscall>
  802eed:	83 c4 18             	add    $0x18,%esp
}
  802ef0:	c9                   	leave  
  802ef1:	c3                   	ret    

00802ef2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802ef2:	55                   	push   %ebp
  802ef3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	6a 00                	push   $0x0
  802efa:	ff 75 14             	pushl  0x14(%ebp)
  802efd:	ff 75 10             	pushl  0x10(%ebp)
  802f00:	ff 75 0c             	pushl  0xc(%ebp)
  802f03:	50                   	push   %eax
  802f04:	6a 20                	push   $0x20
  802f06:	e8 89 fc ff ff       	call   802b94 <syscall>
  802f0b:	83 c4 18             	add    $0x18,%esp
}
  802f0e:	c9                   	leave  
  802f0f:	c3                   	ret    

00802f10 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802f10:	55                   	push   %ebp
  802f11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	6a 00                	push   $0x0
  802f18:	6a 00                	push   $0x0
  802f1a:	6a 00                	push   $0x0
  802f1c:	6a 00                	push   $0x0
  802f1e:	50                   	push   %eax
  802f1f:	6a 21                	push   $0x21
  802f21:	e8 6e fc ff ff       	call   802b94 <syscall>
  802f26:	83 c4 18             	add    $0x18,%esp
}
  802f29:	90                   	nop
  802f2a:	c9                   	leave  
  802f2b:	c3                   	ret    

00802f2c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802f2c:	55                   	push   %ebp
  802f2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	6a 00                	push   $0x0
  802f34:	6a 00                	push   $0x0
  802f36:	6a 00                	push   $0x0
  802f38:	6a 00                	push   $0x0
  802f3a:	50                   	push   %eax
  802f3b:	6a 22                	push   $0x22
  802f3d:	e8 52 fc ff ff       	call   802b94 <syscall>
  802f42:	83 c4 18             	add    $0x18,%esp
}
  802f45:	c9                   	leave  
  802f46:	c3                   	ret    

00802f47 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802f47:	55                   	push   %ebp
  802f48:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802f4a:	6a 00                	push   $0x0
  802f4c:	6a 00                	push   $0x0
  802f4e:	6a 00                	push   $0x0
  802f50:	6a 00                	push   $0x0
  802f52:	6a 00                	push   $0x0
  802f54:	6a 02                	push   $0x2
  802f56:	e8 39 fc ff ff       	call   802b94 <syscall>
  802f5b:	83 c4 18             	add    $0x18,%esp
}
  802f5e:	c9                   	leave  
  802f5f:	c3                   	ret    

00802f60 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802f60:	55                   	push   %ebp
  802f61:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802f63:	6a 00                	push   $0x0
  802f65:	6a 00                	push   $0x0
  802f67:	6a 00                	push   $0x0
  802f69:	6a 00                	push   $0x0
  802f6b:	6a 00                	push   $0x0
  802f6d:	6a 03                	push   $0x3
  802f6f:	e8 20 fc ff ff       	call   802b94 <syscall>
  802f74:	83 c4 18             	add    $0x18,%esp
}
  802f77:	c9                   	leave  
  802f78:	c3                   	ret    

00802f79 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802f79:	55                   	push   %ebp
  802f7a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802f7c:	6a 00                	push   $0x0
  802f7e:	6a 00                	push   $0x0
  802f80:	6a 00                	push   $0x0
  802f82:	6a 00                	push   $0x0
  802f84:	6a 00                	push   $0x0
  802f86:	6a 04                	push   $0x4
  802f88:	e8 07 fc ff ff       	call   802b94 <syscall>
  802f8d:	83 c4 18             	add    $0x18,%esp
}
  802f90:	c9                   	leave  
  802f91:	c3                   	ret    

00802f92 <sys_exit_env>:


void sys_exit_env(void)
{
  802f92:	55                   	push   %ebp
  802f93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802f95:	6a 00                	push   $0x0
  802f97:	6a 00                	push   $0x0
  802f99:	6a 00                	push   $0x0
  802f9b:	6a 00                	push   $0x0
  802f9d:	6a 00                	push   $0x0
  802f9f:	6a 23                	push   $0x23
  802fa1:	e8 ee fb ff ff       	call   802b94 <syscall>
  802fa6:	83 c4 18             	add    $0x18,%esp
}
  802fa9:	90                   	nop
  802faa:	c9                   	leave  
  802fab:	c3                   	ret    

00802fac <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802fac:	55                   	push   %ebp
  802fad:	89 e5                	mov    %esp,%ebp
  802faf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802fb2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802fb5:	8d 50 04             	lea    0x4(%eax),%edx
  802fb8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802fbb:	6a 00                	push   $0x0
  802fbd:	6a 00                	push   $0x0
  802fbf:	6a 00                	push   $0x0
  802fc1:	52                   	push   %edx
  802fc2:	50                   	push   %eax
  802fc3:	6a 24                	push   $0x24
  802fc5:	e8 ca fb ff ff       	call   802b94 <syscall>
  802fca:	83 c4 18             	add    $0x18,%esp
	return result;
  802fcd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802fd0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802fd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802fd6:	89 01                	mov    %eax,(%ecx)
  802fd8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	c9                   	leave  
  802fdf:	c2 04 00             	ret    $0x4

00802fe2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802fe2:	55                   	push   %ebp
  802fe3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802fe5:	6a 00                	push   $0x0
  802fe7:	6a 00                	push   $0x0
  802fe9:	ff 75 10             	pushl  0x10(%ebp)
  802fec:	ff 75 0c             	pushl  0xc(%ebp)
  802fef:	ff 75 08             	pushl  0x8(%ebp)
  802ff2:	6a 12                	push   $0x12
  802ff4:	e8 9b fb ff ff       	call   802b94 <syscall>
  802ff9:	83 c4 18             	add    $0x18,%esp
	return ;
  802ffc:	90                   	nop
}
  802ffd:	c9                   	leave  
  802ffe:	c3                   	ret    

00802fff <sys_rcr2>:
uint32 sys_rcr2()
{
  802fff:	55                   	push   %ebp
  803000:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  803002:	6a 00                	push   $0x0
  803004:	6a 00                	push   $0x0
  803006:	6a 00                	push   $0x0
  803008:	6a 00                	push   $0x0
  80300a:	6a 00                	push   $0x0
  80300c:	6a 25                	push   $0x25
  80300e:	e8 81 fb ff ff       	call   802b94 <syscall>
  803013:	83 c4 18             	add    $0x18,%esp
}
  803016:	c9                   	leave  
  803017:	c3                   	ret    

00803018 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  803018:	55                   	push   %ebp
  803019:	89 e5                	mov    %esp,%ebp
  80301b:	83 ec 04             	sub    $0x4,%esp
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  803024:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  803028:	6a 00                	push   $0x0
  80302a:	6a 00                	push   $0x0
  80302c:	6a 00                	push   $0x0
  80302e:	6a 00                	push   $0x0
  803030:	50                   	push   %eax
  803031:	6a 26                	push   $0x26
  803033:	e8 5c fb ff ff       	call   802b94 <syscall>
  803038:	83 c4 18             	add    $0x18,%esp
	return ;
  80303b:	90                   	nop
}
  80303c:	c9                   	leave  
  80303d:	c3                   	ret    

0080303e <rsttst>:
void rsttst()
{
  80303e:	55                   	push   %ebp
  80303f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  803041:	6a 00                	push   $0x0
  803043:	6a 00                	push   $0x0
  803045:	6a 00                	push   $0x0
  803047:	6a 00                	push   $0x0
  803049:	6a 00                	push   $0x0
  80304b:	6a 28                	push   $0x28
  80304d:	e8 42 fb ff ff       	call   802b94 <syscall>
  803052:	83 c4 18             	add    $0x18,%esp
	return ;
  803055:	90                   	nop
}
  803056:	c9                   	leave  
  803057:	c3                   	ret    

00803058 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  803058:	55                   	push   %ebp
  803059:	89 e5                	mov    %esp,%ebp
  80305b:	83 ec 04             	sub    $0x4,%esp
  80305e:	8b 45 14             	mov    0x14(%ebp),%eax
  803061:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  803064:	8b 55 18             	mov    0x18(%ebp),%edx
  803067:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80306b:	52                   	push   %edx
  80306c:	50                   	push   %eax
  80306d:	ff 75 10             	pushl  0x10(%ebp)
  803070:	ff 75 0c             	pushl  0xc(%ebp)
  803073:	ff 75 08             	pushl  0x8(%ebp)
  803076:	6a 27                	push   $0x27
  803078:	e8 17 fb ff ff       	call   802b94 <syscall>
  80307d:	83 c4 18             	add    $0x18,%esp
	return ;
  803080:	90                   	nop
}
  803081:	c9                   	leave  
  803082:	c3                   	ret    

00803083 <chktst>:
void chktst(uint32 n)
{
  803083:	55                   	push   %ebp
  803084:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  803086:	6a 00                	push   $0x0
  803088:	6a 00                	push   $0x0
  80308a:	6a 00                	push   $0x0
  80308c:	6a 00                	push   $0x0
  80308e:	ff 75 08             	pushl  0x8(%ebp)
  803091:	6a 29                	push   $0x29
  803093:	e8 fc fa ff ff       	call   802b94 <syscall>
  803098:	83 c4 18             	add    $0x18,%esp
	return ;
  80309b:	90                   	nop
}
  80309c:	c9                   	leave  
  80309d:	c3                   	ret    

0080309e <inctst>:

void inctst()
{
  80309e:	55                   	push   %ebp
  80309f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8030a1:	6a 00                	push   $0x0
  8030a3:	6a 00                	push   $0x0
  8030a5:	6a 00                	push   $0x0
  8030a7:	6a 00                	push   $0x0
  8030a9:	6a 00                	push   $0x0
  8030ab:	6a 2a                	push   $0x2a
  8030ad:	e8 e2 fa ff ff       	call   802b94 <syscall>
  8030b2:	83 c4 18             	add    $0x18,%esp
	return ;
  8030b5:	90                   	nop
}
  8030b6:	c9                   	leave  
  8030b7:	c3                   	ret    

008030b8 <gettst>:
uint32 gettst()
{
  8030b8:	55                   	push   %ebp
  8030b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8030bb:	6a 00                	push   $0x0
  8030bd:	6a 00                	push   $0x0
  8030bf:	6a 00                	push   $0x0
  8030c1:	6a 00                	push   $0x0
  8030c3:	6a 00                	push   $0x0
  8030c5:	6a 2b                	push   $0x2b
  8030c7:	e8 c8 fa ff ff       	call   802b94 <syscall>
  8030cc:	83 c4 18             	add    $0x18,%esp
}
  8030cf:	c9                   	leave  
  8030d0:	c3                   	ret    

008030d1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8030d1:	55                   	push   %ebp
  8030d2:	89 e5                	mov    %esp,%ebp
  8030d4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8030d7:	6a 00                	push   $0x0
  8030d9:	6a 00                	push   $0x0
  8030db:	6a 00                	push   $0x0
  8030dd:	6a 00                	push   $0x0
  8030df:	6a 00                	push   $0x0
  8030e1:	6a 2c                	push   $0x2c
  8030e3:	e8 ac fa ff ff       	call   802b94 <syscall>
  8030e8:	83 c4 18             	add    $0x18,%esp
  8030eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8030ee:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8030f2:	75 07                	jne    8030fb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8030f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8030f9:	eb 05                	jmp    803100 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8030fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803100:	c9                   	leave  
  803101:	c3                   	ret    

00803102 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  803102:	55                   	push   %ebp
  803103:	89 e5                	mov    %esp,%ebp
  803105:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803108:	6a 00                	push   $0x0
  80310a:	6a 00                	push   $0x0
  80310c:	6a 00                	push   $0x0
  80310e:	6a 00                	push   $0x0
  803110:	6a 00                	push   $0x0
  803112:	6a 2c                	push   $0x2c
  803114:	e8 7b fa ff ff       	call   802b94 <syscall>
  803119:	83 c4 18             	add    $0x18,%esp
  80311c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80311f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  803123:	75 07                	jne    80312c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  803125:	b8 01 00 00 00       	mov    $0x1,%eax
  80312a:	eb 05                	jmp    803131 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80312c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803131:	c9                   	leave  
  803132:	c3                   	ret    

00803133 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  803133:	55                   	push   %ebp
  803134:	89 e5                	mov    %esp,%ebp
  803136:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803139:	6a 00                	push   $0x0
  80313b:	6a 00                	push   $0x0
  80313d:	6a 00                	push   $0x0
  80313f:	6a 00                	push   $0x0
  803141:	6a 00                	push   $0x0
  803143:	6a 2c                	push   $0x2c
  803145:	e8 4a fa ff ff       	call   802b94 <syscall>
  80314a:	83 c4 18             	add    $0x18,%esp
  80314d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  803150:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  803154:	75 07                	jne    80315d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  803156:	b8 01 00 00 00       	mov    $0x1,%eax
  80315b:	eb 05                	jmp    803162 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80315d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803162:	c9                   	leave  
  803163:	c3                   	ret    

00803164 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  803164:	55                   	push   %ebp
  803165:	89 e5                	mov    %esp,%ebp
  803167:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80316a:	6a 00                	push   $0x0
  80316c:	6a 00                	push   $0x0
  80316e:	6a 00                	push   $0x0
  803170:	6a 00                	push   $0x0
  803172:	6a 00                	push   $0x0
  803174:	6a 2c                	push   $0x2c
  803176:	e8 19 fa ff ff       	call   802b94 <syscall>
  80317b:	83 c4 18             	add    $0x18,%esp
  80317e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  803181:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  803185:	75 07                	jne    80318e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803187:	b8 01 00 00 00       	mov    $0x1,%eax
  80318c:	eb 05                	jmp    803193 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80318e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803193:	c9                   	leave  
  803194:	c3                   	ret    

00803195 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  803195:	55                   	push   %ebp
  803196:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803198:	6a 00                	push   $0x0
  80319a:	6a 00                	push   $0x0
  80319c:	6a 00                	push   $0x0
  80319e:	6a 00                	push   $0x0
  8031a0:	ff 75 08             	pushl  0x8(%ebp)
  8031a3:	6a 2d                	push   $0x2d
  8031a5:	e8 ea f9 ff ff       	call   802b94 <syscall>
  8031aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8031ad:	90                   	nop
}
  8031ae:	c9                   	leave  
  8031af:	c3                   	ret    

008031b0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8031b0:	55                   	push   %ebp
  8031b1:	89 e5                	mov    %esp,%ebp
  8031b3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8031b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8031b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8031ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c0:	6a 00                	push   $0x0
  8031c2:	53                   	push   %ebx
  8031c3:	51                   	push   %ecx
  8031c4:	52                   	push   %edx
  8031c5:	50                   	push   %eax
  8031c6:	6a 2e                	push   $0x2e
  8031c8:	e8 c7 f9 ff ff       	call   802b94 <syscall>
  8031cd:	83 c4 18             	add    $0x18,%esp
}
  8031d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8031d3:	c9                   	leave  
  8031d4:	c3                   	ret    

008031d5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8031d5:	55                   	push   %ebp
  8031d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8031d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031db:	8b 45 08             	mov    0x8(%ebp),%eax
  8031de:	6a 00                	push   $0x0
  8031e0:	6a 00                	push   $0x0
  8031e2:	6a 00                	push   $0x0
  8031e4:	52                   	push   %edx
  8031e5:	50                   	push   %eax
  8031e6:	6a 2f                	push   $0x2f
  8031e8:	e8 a7 f9 ff ff       	call   802b94 <syscall>
  8031ed:	83 c4 18             	add    $0x18,%esp
}
  8031f0:	c9                   	leave  
  8031f1:	c3                   	ret    

008031f2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8031f2:	55                   	push   %ebp
  8031f3:	89 e5                	mov    %esp,%ebp
  8031f5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8031f8:	83 ec 0c             	sub    $0xc,%esp
  8031fb:	68 a0 4e 80 00       	push   $0x804ea0
  803200:	e8 3e e6 ff ff       	call   801843 <cprintf>
  803205:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  803208:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80320f:	83 ec 0c             	sub    $0xc,%esp
  803212:	68 cc 4e 80 00       	push   $0x804ecc
  803217:	e8 27 e6 ff ff       	call   801843 <cprintf>
  80321c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80321f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803223:	a1 38 61 80 00       	mov    0x806138,%eax
  803228:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80322b:	eb 56                	jmp    803283 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80322d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803231:	74 1c                	je     80324f <print_mem_block_lists+0x5d>
  803233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803236:	8b 50 08             	mov    0x8(%eax),%edx
  803239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80323c:	8b 48 08             	mov    0x8(%eax),%ecx
  80323f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803242:	8b 40 0c             	mov    0xc(%eax),%eax
  803245:	01 c8                	add    %ecx,%eax
  803247:	39 c2                	cmp    %eax,%edx
  803249:	73 04                	jae    80324f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80324b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80324f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803252:	8b 50 08             	mov    0x8(%eax),%edx
  803255:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803258:	8b 40 0c             	mov    0xc(%eax),%eax
  80325b:	01 c2                	add    %eax,%edx
  80325d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803260:	8b 40 08             	mov    0x8(%eax),%eax
  803263:	83 ec 04             	sub    $0x4,%esp
  803266:	52                   	push   %edx
  803267:	50                   	push   %eax
  803268:	68 e1 4e 80 00       	push   $0x804ee1
  80326d:	e8 d1 e5 ff ff       	call   801843 <cprintf>
  803272:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  803275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803278:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80327b:	a1 40 61 80 00       	mov    0x806140,%eax
  803280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803287:	74 07                	je     803290 <print_mem_block_lists+0x9e>
  803289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328c:	8b 00                	mov    (%eax),%eax
  80328e:	eb 05                	jmp    803295 <print_mem_block_lists+0xa3>
  803290:	b8 00 00 00 00       	mov    $0x0,%eax
  803295:	a3 40 61 80 00       	mov    %eax,0x806140
  80329a:	a1 40 61 80 00       	mov    0x806140,%eax
  80329f:	85 c0                	test   %eax,%eax
  8032a1:	75 8a                	jne    80322d <print_mem_block_lists+0x3b>
  8032a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032a7:	75 84                	jne    80322d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8032a9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8032ad:	75 10                	jne    8032bf <print_mem_block_lists+0xcd>
  8032af:	83 ec 0c             	sub    $0xc,%esp
  8032b2:	68 f0 4e 80 00       	push   $0x804ef0
  8032b7:	e8 87 e5 ff ff       	call   801843 <cprintf>
  8032bc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8032bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8032c6:	83 ec 0c             	sub    $0xc,%esp
  8032c9:	68 14 4f 80 00       	push   $0x804f14
  8032ce:	e8 70 e5 ff ff       	call   801843 <cprintf>
  8032d3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8032d6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8032da:	a1 40 60 80 00       	mov    0x806040,%eax
  8032df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032e2:	eb 56                	jmp    80333a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8032e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8032e8:	74 1c                	je     803306 <print_mem_block_lists+0x114>
  8032ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ed:	8b 50 08             	mov    0x8(%eax),%edx
  8032f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f3:	8b 48 08             	mov    0x8(%eax),%ecx
  8032f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8032f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032fc:	01 c8                	add    %ecx,%eax
  8032fe:	39 c2                	cmp    %eax,%edx
  803300:	73 04                	jae    803306 <print_mem_block_lists+0x114>
			sorted = 0 ;
  803302:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  803306:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803309:	8b 50 08             	mov    0x8(%eax),%edx
  80330c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80330f:	8b 40 0c             	mov    0xc(%eax),%eax
  803312:	01 c2                	add    %eax,%edx
  803314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803317:	8b 40 08             	mov    0x8(%eax),%eax
  80331a:	83 ec 04             	sub    $0x4,%esp
  80331d:	52                   	push   %edx
  80331e:	50                   	push   %eax
  80331f:	68 e1 4e 80 00       	push   $0x804ee1
  803324:	e8 1a e5 ff ff       	call   801843 <cprintf>
  803329:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80332c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803332:	a1 48 60 80 00       	mov    0x806048,%eax
  803337:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80333a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80333e:	74 07                	je     803347 <print_mem_block_lists+0x155>
  803340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803343:	8b 00                	mov    (%eax),%eax
  803345:	eb 05                	jmp    80334c <print_mem_block_lists+0x15a>
  803347:	b8 00 00 00 00       	mov    $0x0,%eax
  80334c:	a3 48 60 80 00       	mov    %eax,0x806048
  803351:	a1 48 60 80 00       	mov    0x806048,%eax
  803356:	85 c0                	test   %eax,%eax
  803358:	75 8a                	jne    8032e4 <print_mem_block_lists+0xf2>
  80335a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80335e:	75 84                	jne    8032e4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  803360:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803364:	75 10                	jne    803376 <print_mem_block_lists+0x184>
  803366:	83 ec 0c             	sub    $0xc,%esp
  803369:	68 2c 4f 80 00       	push   $0x804f2c
  80336e:	e8 d0 e4 ff ff       	call   801843 <cprintf>
  803373:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803376:	83 ec 0c             	sub    $0xc,%esp
  803379:	68 a0 4e 80 00       	push   $0x804ea0
  80337e:	e8 c0 e4 ff ff       	call   801843 <cprintf>
  803383:	83 c4 10             	add    $0x10,%esp

}
  803386:	90                   	nop
  803387:	c9                   	leave  
  803388:	c3                   	ret    

00803389 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803389:	55                   	push   %ebp
  80338a:	89 e5                	mov    %esp,%ebp
  80338c:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80338f:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803396:	00 00 00 
  803399:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  8033a0:	00 00 00 
  8033a3:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  8033aa:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8033ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8033b4:	e9 9e 00 00 00       	jmp    803457 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8033b9:	a1 50 60 80 00       	mov    0x806050,%eax
  8033be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033c1:	c1 e2 04             	shl    $0x4,%edx
  8033c4:	01 d0                	add    %edx,%eax
  8033c6:	85 c0                	test   %eax,%eax
  8033c8:	75 14                	jne    8033de <initialize_MemBlocksList+0x55>
  8033ca:	83 ec 04             	sub    $0x4,%esp
  8033cd:	68 54 4f 80 00       	push   $0x804f54
  8033d2:	6a 3d                	push   $0x3d
  8033d4:	68 77 4f 80 00       	push   $0x804f77
  8033d9:	e8 b1 e1 ff ff       	call   80158f <_panic>
  8033de:	a1 50 60 80 00       	mov    0x806050,%eax
  8033e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033e6:	c1 e2 04             	shl    $0x4,%edx
  8033e9:	01 d0                	add    %edx,%eax
  8033eb:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8033f1:	89 10                	mov    %edx,(%eax)
  8033f3:	8b 00                	mov    (%eax),%eax
  8033f5:	85 c0                	test   %eax,%eax
  8033f7:	74 18                	je     803411 <initialize_MemBlocksList+0x88>
  8033f9:	a1 48 61 80 00       	mov    0x806148,%eax
  8033fe:	8b 15 50 60 80 00    	mov    0x806050,%edx
  803404:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  803407:	c1 e1 04             	shl    $0x4,%ecx
  80340a:	01 ca                	add    %ecx,%edx
  80340c:	89 50 04             	mov    %edx,0x4(%eax)
  80340f:	eb 12                	jmp    803423 <initialize_MemBlocksList+0x9a>
  803411:	a1 50 60 80 00       	mov    0x806050,%eax
  803416:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803419:	c1 e2 04             	shl    $0x4,%edx
  80341c:	01 d0                	add    %edx,%eax
  80341e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803423:	a1 50 60 80 00       	mov    0x806050,%eax
  803428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80342b:	c1 e2 04             	shl    $0x4,%edx
  80342e:	01 d0                	add    %edx,%eax
  803430:	a3 48 61 80 00       	mov    %eax,0x806148
  803435:	a1 50 60 80 00       	mov    0x806050,%eax
  80343a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80343d:	c1 e2 04             	shl    $0x4,%edx
  803440:	01 d0                	add    %edx,%eax
  803442:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803449:	a1 54 61 80 00       	mov    0x806154,%eax
  80344e:	40                   	inc    %eax
  80344f:	a3 54 61 80 00       	mov    %eax,0x806154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  803454:	ff 45 f4             	incl   -0xc(%ebp)
  803457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80345d:	0f 82 56 ff ff ff    	jb     8033b9 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  803463:	90                   	nop
  803464:	c9                   	leave  
  803465:	c3                   	ret    

00803466 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803466:	55                   	push   %ebp
  803467:	89 e5                	mov    %esp,%ebp
  803469:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80346c:	8b 45 08             	mov    0x8(%ebp),%eax
  80346f:	8b 00                	mov    (%eax),%eax
  803471:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  803474:	eb 18                	jmp    80348e <find_block+0x28>

		if(tmp->sva == va){
  803476:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803479:	8b 40 08             	mov    0x8(%eax),%eax
  80347c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80347f:	75 05                	jne    803486 <find_block+0x20>
			return tmp ;
  803481:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803484:	eb 11                	jmp    803497 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  803486:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803489:	8b 00                	mov    (%eax),%eax
  80348b:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80348e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  803492:	75 e2                	jne    803476 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  803494:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803497:	c9                   	leave  
  803498:	c3                   	ret    

00803499 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803499:	55                   	push   %ebp
  80349a:	89 e5                	mov    %esp,%ebp
  80349c:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80349f:	a1 40 60 80 00       	mov    0x806040,%eax
  8034a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8034a7:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8034ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8034af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8034b3:	75 65                	jne    80351a <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8034b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8034b9:	75 14                	jne    8034cf <insert_sorted_allocList+0x36>
  8034bb:	83 ec 04             	sub    $0x4,%esp
  8034be:	68 54 4f 80 00       	push   $0x804f54
  8034c3:	6a 62                	push   $0x62
  8034c5:	68 77 4f 80 00       	push   $0x804f77
  8034ca:	e8 c0 e0 ff ff       	call   80158f <_panic>
  8034cf:	8b 15 40 60 80 00    	mov    0x806040,%edx
  8034d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034d8:	89 10                	mov    %edx,(%eax)
  8034da:	8b 45 08             	mov    0x8(%ebp),%eax
  8034dd:	8b 00                	mov    (%eax),%eax
  8034df:	85 c0                	test   %eax,%eax
  8034e1:	74 0d                	je     8034f0 <insert_sorted_allocList+0x57>
  8034e3:	a1 40 60 80 00       	mov    0x806040,%eax
  8034e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034eb:	89 50 04             	mov    %edx,0x4(%eax)
  8034ee:	eb 08                	jmp    8034f8 <insert_sorted_allocList+0x5f>
  8034f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f3:	a3 44 60 80 00       	mov    %eax,0x806044
  8034f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034fb:	a3 40 60 80 00       	mov    %eax,0x806040
  803500:	8b 45 08             	mov    0x8(%ebp),%eax
  803503:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350a:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80350f:	40                   	inc    %eax
  803510:	a3 4c 60 80 00       	mov    %eax,0x80604c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  803515:	e9 14 01 00 00       	jmp    80362e <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80351a:	8b 45 08             	mov    0x8(%ebp),%eax
  80351d:	8b 50 08             	mov    0x8(%eax),%edx
  803520:	a1 44 60 80 00       	mov    0x806044,%eax
  803525:	8b 40 08             	mov    0x8(%eax),%eax
  803528:	39 c2                	cmp    %eax,%edx
  80352a:	76 65                	jbe    803591 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80352c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803530:	75 14                	jne    803546 <insert_sorted_allocList+0xad>
  803532:	83 ec 04             	sub    $0x4,%esp
  803535:	68 90 4f 80 00       	push   $0x804f90
  80353a:	6a 64                	push   $0x64
  80353c:	68 77 4f 80 00       	push   $0x804f77
  803541:	e8 49 e0 ff ff       	call   80158f <_panic>
  803546:	8b 15 44 60 80 00    	mov    0x806044,%edx
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	89 50 04             	mov    %edx,0x4(%eax)
  803552:	8b 45 08             	mov    0x8(%ebp),%eax
  803555:	8b 40 04             	mov    0x4(%eax),%eax
  803558:	85 c0                	test   %eax,%eax
  80355a:	74 0c                	je     803568 <insert_sorted_allocList+0xcf>
  80355c:	a1 44 60 80 00       	mov    0x806044,%eax
  803561:	8b 55 08             	mov    0x8(%ebp),%edx
  803564:	89 10                	mov    %edx,(%eax)
  803566:	eb 08                	jmp    803570 <insert_sorted_allocList+0xd7>
  803568:	8b 45 08             	mov    0x8(%ebp),%eax
  80356b:	a3 40 60 80 00       	mov    %eax,0x806040
  803570:	8b 45 08             	mov    0x8(%ebp),%eax
  803573:	a3 44 60 80 00       	mov    %eax,0x806044
  803578:	8b 45 08             	mov    0x8(%ebp),%eax
  80357b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803581:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803586:	40                   	inc    %eax
  803587:	a3 4c 60 80 00       	mov    %eax,0x80604c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80358c:	e9 9d 00 00 00       	jmp    80362e <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  803591:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803598:	e9 85 00 00 00       	jmp    803622 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80359d:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a0:	8b 50 08             	mov    0x8(%eax),%edx
  8035a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a6:	8b 40 08             	mov    0x8(%eax),%eax
  8035a9:	39 c2                	cmp    %eax,%edx
  8035ab:	73 6a                	jae    803617 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8035ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b1:	74 06                	je     8035b9 <insert_sorted_allocList+0x120>
  8035b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035b7:	75 14                	jne    8035cd <insert_sorted_allocList+0x134>
  8035b9:	83 ec 04             	sub    $0x4,%esp
  8035bc:	68 b4 4f 80 00       	push   $0x804fb4
  8035c1:	6a 6b                	push   $0x6b
  8035c3:	68 77 4f 80 00       	push   $0x804f77
  8035c8:	e8 c2 df ff ff       	call   80158f <_panic>
  8035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035d0:	8b 50 04             	mov    0x4(%eax),%edx
  8035d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d6:	89 50 04             	mov    %edx,0x4(%eax)
  8035d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035df:	89 10                	mov    %edx,(%eax)
  8035e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035e4:	8b 40 04             	mov    0x4(%eax),%eax
  8035e7:	85 c0                	test   %eax,%eax
  8035e9:	74 0d                	je     8035f8 <insert_sorted_allocList+0x15f>
  8035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ee:	8b 40 04             	mov    0x4(%eax),%eax
  8035f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8035f4:	89 10                	mov    %edx,(%eax)
  8035f6:	eb 08                	jmp    803600 <insert_sorted_allocList+0x167>
  8035f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fb:	a3 40 60 80 00       	mov    %eax,0x806040
  803600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803603:	8b 55 08             	mov    0x8(%ebp),%edx
  803606:	89 50 04             	mov    %edx,0x4(%eax)
  803609:	a1 4c 60 80 00       	mov    0x80604c,%eax
  80360e:	40                   	inc    %eax
  80360f:	a3 4c 60 80 00       	mov    %eax,0x80604c
    	    			break;
  803614:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  803615:	eb 17                	jmp    80362e <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  803617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80361a:	8b 00                	mov    (%eax),%eax
  80361c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80361f:	ff 45 f0             	incl   -0x10(%ebp)
  803622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803625:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  803628:	0f 8c 6f ff ff ff    	jl     80359d <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80362e:	90                   	nop
  80362f:	c9                   	leave  
  803630:	c3                   	ret    

00803631 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  803631:	55                   	push   %ebp
  803632:	89 e5                	mov    %esp,%ebp
  803634:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  803637:	a1 38 61 80 00       	mov    0x806138,%eax
  80363c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80363f:	e9 7c 01 00 00       	jmp    8037c0 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  803644:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803647:	8b 40 0c             	mov    0xc(%eax),%eax
  80364a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80364d:	0f 86 cf 00 00 00    	jbe    803722 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  803653:	a1 48 61 80 00       	mov    0x806148,%eax
  803658:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80365b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80365e:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  803661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803664:	8b 55 08             	mov    0x8(%ebp),%edx
  803667:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  80366a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366d:	8b 50 08             	mov    0x8(%eax),%edx
  803670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803673:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  803676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803679:	8b 40 0c             	mov    0xc(%eax),%eax
  80367c:	2b 45 08             	sub    0x8(%ebp),%eax
  80367f:	89 c2                	mov    %eax,%edx
  803681:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803684:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  803687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368a:	8b 50 08             	mov    0x8(%eax),%edx
  80368d:	8b 45 08             	mov    0x8(%ebp),%eax
  803690:	01 c2                	add    %eax,%edx
  803692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803695:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  803698:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80369c:	75 17                	jne    8036b5 <alloc_block_FF+0x84>
  80369e:	83 ec 04             	sub    $0x4,%esp
  8036a1:	68 e9 4f 80 00       	push   $0x804fe9
  8036a6:	68 83 00 00 00       	push   $0x83
  8036ab:	68 77 4f 80 00       	push   $0x804f77
  8036b0:	e8 da de ff ff       	call   80158f <_panic>
  8036b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036b8:	8b 00                	mov    (%eax),%eax
  8036ba:	85 c0                	test   %eax,%eax
  8036bc:	74 10                	je     8036ce <alloc_block_FF+0x9d>
  8036be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036c1:	8b 00                	mov    (%eax),%eax
  8036c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036c6:	8b 52 04             	mov    0x4(%edx),%edx
  8036c9:	89 50 04             	mov    %edx,0x4(%eax)
  8036cc:	eb 0b                	jmp    8036d9 <alloc_block_FF+0xa8>
  8036ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036d1:	8b 40 04             	mov    0x4(%eax),%eax
  8036d4:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8036d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036dc:	8b 40 04             	mov    0x4(%eax),%eax
  8036df:	85 c0                	test   %eax,%eax
  8036e1:	74 0f                	je     8036f2 <alloc_block_FF+0xc1>
  8036e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036e6:	8b 40 04             	mov    0x4(%eax),%eax
  8036e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8036ec:	8b 12                	mov    (%edx),%edx
  8036ee:	89 10                	mov    %edx,(%eax)
  8036f0:	eb 0a                	jmp    8036fc <alloc_block_FF+0xcb>
  8036f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036f5:	8b 00                	mov    (%eax),%eax
  8036f7:	a3 48 61 80 00       	mov    %eax,0x806148
  8036fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8036ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803708:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370f:	a1 54 61 80 00       	mov    0x806154,%eax
  803714:	48                   	dec    %eax
  803715:	a3 54 61 80 00       	mov    %eax,0x806154
                    return newBlock ;
  80371a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80371d:	e9 ad 00 00 00       	jmp    8037cf <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  803722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803725:	8b 40 0c             	mov    0xc(%eax),%eax
  803728:	3b 45 08             	cmp    0x8(%ebp),%eax
  80372b:	0f 85 87 00 00 00    	jne    8037b8 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  803731:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803735:	75 17                	jne    80374e <alloc_block_FF+0x11d>
  803737:	83 ec 04             	sub    $0x4,%esp
  80373a:	68 e9 4f 80 00       	push   $0x804fe9
  80373f:	68 87 00 00 00       	push   $0x87
  803744:	68 77 4f 80 00       	push   $0x804f77
  803749:	e8 41 de ff ff       	call   80158f <_panic>
  80374e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803751:	8b 00                	mov    (%eax),%eax
  803753:	85 c0                	test   %eax,%eax
  803755:	74 10                	je     803767 <alloc_block_FF+0x136>
  803757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80375a:	8b 00                	mov    (%eax),%eax
  80375c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80375f:	8b 52 04             	mov    0x4(%edx),%edx
  803762:	89 50 04             	mov    %edx,0x4(%eax)
  803765:	eb 0b                	jmp    803772 <alloc_block_FF+0x141>
  803767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376a:	8b 40 04             	mov    0x4(%eax),%eax
  80376d:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803775:	8b 40 04             	mov    0x4(%eax),%eax
  803778:	85 c0                	test   %eax,%eax
  80377a:	74 0f                	je     80378b <alloc_block_FF+0x15a>
  80377c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377f:	8b 40 04             	mov    0x4(%eax),%eax
  803782:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803785:	8b 12                	mov    (%edx),%edx
  803787:	89 10                	mov    %edx,(%eax)
  803789:	eb 0a                	jmp    803795 <alloc_block_FF+0x164>
  80378b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378e:	8b 00                	mov    (%eax),%eax
  803790:	a3 38 61 80 00       	mov    %eax,0x806138
  803795:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803798:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80379e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037a8:	a1 44 61 80 00       	mov    0x806144,%eax
  8037ad:	48                   	dec    %eax
  8037ae:	a3 44 61 80 00       	mov    %eax,0x806144
                        return  pointertempp;
  8037b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037b6:	eb 17                	jmp    8037cf <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8037b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037bb:	8b 00                	mov    (%eax),%eax
  8037bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8037c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8037c4:	0f 85 7a fe ff ff    	jne    803644 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8037ca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037cf:	c9                   	leave  
  8037d0:	c3                   	ret    

008037d1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8037d1:	55                   	push   %ebp
  8037d2:	89 e5                	mov    %esp,%ebp
  8037d4:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8037d7:	a1 38 61 80 00       	mov    0x806138,%eax
  8037dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8037df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8037e6:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8037ed:	a1 38 61 80 00       	mov    0x806138,%eax
  8037f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8037f5:	e9 d0 00 00 00       	jmp    8038ca <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8037fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037fd:	8b 40 0c             	mov    0xc(%eax),%eax
  803800:	3b 45 08             	cmp    0x8(%ebp),%eax
  803803:	0f 82 b8 00 00 00    	jb     8038c1 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  803809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80380c:	8b 40 0c             	mov    0xc(%eax),%eax
  80380f:	2b 45 08             	sub    0x8(%ebp),%eax
  803812:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  803815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803818:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80381b:	0f 83 a1 00 00 00    	jae    8038c2 <alloc_block_BF+0xf1>
				differsize = differance ;
  803821:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803824:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  803827:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80382d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803831:	0f 85 8b 00 00 00    	jne    8038c2 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  803837:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80383b:	75 17                	jne    803854 <alloc_block_BF+0x83>
  80383d:	83 ec 04             	sub    $0x4,%esp
  803840:	68 e9 4f 80 00       	push   $0x804fe9
  803845:	68 a0 00 00 00       	push   $0xa0
  80384a:	68 77 4f 80 00       	push   $0x804f77
  80384f:	e8 3b dd ff ff       	call   80158f <_panic>
  803854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803857:	8b 00                	mov    (%eax),%eax
  803859:	85 c0                	test   %eax,%eax
  80385b:	74 10                	je     80386d <alloc_block_BF+0x9c>
  80385d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803860:	8b 00                	mov    (%eax),%eax
  803862:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803865:	8b 52 04             	mov    0x4(%edx),%edx
  803868:	89 50 04             	mov    %edx,0x4(%eax)
  80386b:	eb 0b                	jmp    803878 <alloc_block_BF+0xa7>
  80386d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803870:	8b 40 04             	mov    0x4(%eax),%eax
  803873:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387b:	8b 40 04             	mov    0x4(%eax),%eax
  80387e:	85 c0                	test   %eax,%eax
  803880:	74 0f                	je     803891 <alloc_block_BF+0xc0>
  803882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803885:	8b 40 04             	mov    0x4(%eax),%eax
  803888:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80388b:	8b 12                	mov    (%edx),%edx
  80388d:	89 10                	mov    %edx,(%eax)
  80388f:	eb 0a                	jmp    80389b <alloc_block_BF+0xca>
  803891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803894:	8b 00                	mov    (%eax),%eax
  803896:	a3 38 61 80 00       	mov    %eax,0x806138
  80389b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80389e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038ae:	a1 44 61 80 00       	mov    0x806144,%eax
  8038b3:	48                   	dec    %eax
  8038b4:	a3 44 61 80 00       	mov    %eax,0x806144
					return elementiterator;
  8038b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bc:	e9 0c 01 00 00       	jmp    8039cd <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8038c1:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8038c2:	a1 40 61 80 00       	mov    0x806140,%eax
  8038c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8038ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038ce:	74 07                	je     8038d7 <alloc_block_BF+0x106>
  8038d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d3:	8b 00                	mov    (%eax),%eax
  8038d5:	eb 05                	jmp    8038dc <alloc_block_BF+0x10b>
  8038d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8038dc:	a3 40 61 80 00       	mov    %eax,0x806140
  8038e1:	a1 40 61 80 00       	mov    0x806140,%eax
  8038e6:	85 c0                	test   %eax,%eax
  8038e8:	0f 85 0c ff ff ff    	jne    8037fa <alloc_block_BF+0x29>
  8038ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8038f2:	0f 85 02 ff ff ff    	jne    8037fa <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8038f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8038fc:	0f 84 c6 00 00 00    	je     8039c8 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  803902:	a1 48 61 80 00       	mov    0x806148,%eax
  803907:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80390a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80390d:	8b 55 08             	mov    0x8(%ebp),%edx
  803910:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  803913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803916:	8b 50 08             	mov    0x8(%eax),%edx
  803919:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80391c:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80391f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803922:	8b 40 0c             	mov    0xc(%eax),%eax
  803925:	2b 45 08             	sub    0x8(%ebp),%eax
  803928:	89 c2                	mov    %eax,%edx
  80392a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80392d:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  803930:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803933:	8b 50 08             	mov    0x8(%eax),%edx
  803936:	8b 45 08             	mov    0x8(%ebp),%eax
  803939:	01 c2                	add    %eax,%edx
  80393b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80393e:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  803941:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803945:	75 17                	jne    80395e <alloc_block_BF+0x18d>
  803947:	83 ec 04             	sub    $0x4,%esp
  80394a:	68 e9 4f 80 00       	push   $0x804fe9
  80394f:	68 af 00 00 00       	push   $0xaf
  803954:	68 77 4f 80 00       	push   $0x804f77
  803959:	e8 31 dc ff ff       	call   80158f <_panic>
  80395e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803961:	8b 00                	mov    (%eax),%eax
  803963:	85 c0                	test   %eax,%eax
  803965:	74 10                	je     803977 <alloc_block_BF+0x1a6>
  803967:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80396a:	8b 00                	mov    (%eax),%eax
  80396c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80396f:	8b 52 04             	mov    0x4(%edx),%edx
  803972:	89 50 04             	mov    %edx,0x4(%eax)
  803975:	eb 0b                	jmp    803982 <alloc_block_BF+0x1b1>
  803977:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80397a:	8b 40 04             	mov    0x4(%eax),%eax
  80397d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803982:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803985:	8b 40 04             	mov    0x4(%eax),%eax
  803988:	85 c0                	test   %eax,%eax
  80398a:	74 0f                	je     80399b <alloc_block_BF+0x1ca>
  80398c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80398f:	8b 40 04             	mov    0x4(%eax),%eax
  803992:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803995:	8b 12                	mov    (%edx),%edx
  803997:	89 10                	mov    %edx,(%eax)
  803999:	eb 0a                	jmp    8039a5 <alloc_block_BF+0x1d4>
  80399b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80399e:	8b 00                	mov    (%eax),%eax
  8039a0:	a3 48 61 80 00       	mov    %eax,0x806148
  8039a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039b8:	a1 54 61 80 00       	mov    0x806154,%eax
  8039bd:	48                   	dec    %eax
  8039be:	a3 54 61 80 00       	mov    %eax,0x806154
		return blockToUpdate;
  8039c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8039c6:	eb 05                	jmp    8039cd <alloc_block_BF+0x1fc>
	}

	return NULL;
  8039c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8039cd:	c9                   	leave  
  8039ce:	c3                   	ret    

008039cf <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8039cf:	55                   	push   %ebp
  8039d0:	89 e5                	mov    %esp,%ebp
  8039d2:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8039d5:	a1 38 61 80 00       	mov    0x806138,%eax
  8039da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8039dd:	e9 7c 01 00 00       	jmp    803b5e <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8039e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8039e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8039eb:	0f 86 cf 00 00 00    	jbe    803ac0 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8039f1:	a1 48 61 80 00       	mov    0x806148,%eax
  8039f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8039f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8039fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8039ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a02:	8b 55 08             	mov    0x8(%ebp),%edx
  803a05:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  803a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a0b:	8b 50 08             	mov    0x8(%eax),%edx
  803a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a11:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  803a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a17:	8b 40 0c             	mov    0xc(%eax),%eax
  803a1a:	2b 45 08             	sub    0x8(%ebp),%eax
  803a1d:	89 c2                	mov    %eax,%edx
  803a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a22:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  803a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a28:	8b 50 08             	mov    0x8(%eax),%edx
  803a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2e:	01 c2                	add    %eax,%edx
  803a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803a33:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  803a36:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a3a:	75 17                	jne    803a53 <alloc_block_NF+0x84>
  803a3c:	83 ec 04             	sub    $0x4,%esp
  803a3f:	68 e9 4f 80 00       	push   $0x804fe9
  803a44:	68 c4 00 00 00       	push   $0xc4
  803a49:	68 77 4f 80 00       	push   $0x804f77
  803a4e:	e8 3c db ff ff       	call   80158f <_panic>
  803a53:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a56:	8b 00                	mov    (%eax),%eax
  803a58:	85 c0                	test   %eax,%eax
  803a5a:	74 10                	je     803a6c <alloc_block_NF+0x9d>
  803a5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a5f:	8b 00                	mov    (%eax),%eax
  803a61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a64:	8b 52 04             	mov    0x4(%edx),%edx
  803a67:	89 50 04             	mov    %edx,0x4(%eax)
  803a6a:	eb 0b                	jmp    803a77 <alloc_block_NF+0xa8>
  803a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a6f:	8b 40 04             	mov    0x4(%eax),%eax
  803a72:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a7a:	8b 40 04             	mov    0x4(%eax),%eax
  803a7d:	85 c0                	test   %eax,%eax
  803a7f:	74 0f                	je     803a90 <alloc_block_NF+0xc1>
  803a81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a84:	8b 40 04             	mov    0x4(%eax),%eax
  803a87:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803a8a:	8b 12                	mov    (%edx),%edx
  803a8c:	89 10                	mov    %edx,(%eax)
  803a8e:	eb 0a                	jmp    803a9a <alloc_block_NF+0xcb>
  803a90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a93:	8b 00                	mov    (%eax),%eax
  803a95:	a3 48 61 80 00       	mov    %eax,0x806148
  803a9a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803a9d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803aa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803aa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803aad:	a1 54 61 80 00       	mov    0x806154,%eax
  803ab2:	48                   	dec    %eax
  803ab3:	a3 54 61 80 00       	mov    %eax,0x806154
	                    return newBlock ;
  803ab8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803abb:	e9 ad 00 00 00       	jmp    803b6d <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  803ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ac3:	8b 40 0c             	mov    0xc(%eax),%eax
  803ac6:	3b 45 08             	cmp    0x8(%ebp),%eax
  803ac9:	0f 85 87 00 00 00    	jne    803b56 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  803acf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803ad3:	75 17                	jne    803aec <alloc_block_NF+0x11d>
  803ad5:	83 ec 04             	sub    $0x4,%esp
  803ad8:	68 e9 4f 80 00       	push   $0x804fe9
  803add:	68 c8 00 00 00       	push   $0xc8
  803ae2:	68 77 4f 80 00       	push   $0x804f77
  803ae7:	e8 a3 da ff ff       	call   80158f <_panic>
  803aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803aef:	8b 00                	mov    (%eax),%eax
  803af1:	85 c0                	test   %eax,%eax
  803af3:	74 10                	je     803b05 <alloc_block_NF+0x136>
  803af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803af8:	8b 00                	mov    (%eax),%eax
  803afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803afd:	8b 52 04             	mov    0x4(%edx),%edx
  803b00:	89 50 04             	mov    %edx,0x4(%eax)
  803b03:	eb 0b                	jmp    803b10 <alloc_block_NF+0x141>
  803b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b08:	8b 40 04             	mov    0x4(%eax),%eax
  803b0b:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b13:	8b 40 04             	mov    0x4(%eax),%eax
  803b16:	85 c0                	test   %eax,%eax
  803b18:	74 0f                	je     803b29 <alloc_block_NF+0x15a>
  803b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b1d:	8b 40 04             	mov    0x4(%eax),%eax
  803b20:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b23:	8b 12                	mov    (%edx),%edx
  803b25:	89 10                	mov    %edx,(%eax)
  803b27:	eb 0a                	jmp    803b33 <alloc_block_NF+0x164>
  803b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b2c:	8b 00                	mov    (%eax),%eax
  803b2e:	a3 38 61 80 00       	mov    %eax,0x806138
  803b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803b46:	a1 44 61 80 00       	mov    0x806144,%eax
  803b4b:	48                   	dec    %eax
  803b4c:	a3 44 61 80 00       	mov    %eax,0x806144
	                        return  updated;
  803b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b54:	eb 17                	jmp    803b6d <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  803b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b59:	8b 00                	mov    (%eax),%eax
  803b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  803b5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803b62:	0f 85 7a fe ff ff    	jne    8039e2 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  803b68:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803b6d:	c9                   	leave  
  803b6e:	c3                   	ret    

00803b6f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803b6f:	55                   	push   %ebp
  803b70:	89 e5                	mov    %esp,%ebp
  803b72:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  803b75:	a1 38 61 80 00       	mov    0x806138,%eax
  803b7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803b7d:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803b82:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  803b85:	a1 44 61 80 00       	mov    0x806144,%eax
  803b8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  803b8d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b91:	75 68                	jne    803bfb <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  803b93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b97:	75 17                	jne    803bb0 <insert_sorted_with_merge_freeList+0x41>
  803b99:	83 ec 04             	sub    $0x4,%esp
  803b9c:	68 54 4f 80 00       	push   $0x804f54
  803ba1:	68 da 00 00 00       	push   $0xda
  803ba6:	68 77 4f 80 00       	push   $0x804f77
  803bab:	e8 df d9 ff ff       	call   80158f <_panic>
  803bb0:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bb9:	89 10                	mov    %edx,(%eax)
  803bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bbe:	8b 00                	mov    (%eax),%eax
  803bc0:	85 c0                	test   %eax,%eax
  803bc2:	74 0d                	je     803bd1 <insert_sorted_with_merge_freeList+0x62>
  803bc4:	a1 38 61 80 00       	mov    0x806138,%eax
  803bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  803bcc:	89 50 04             	mov    %edx,0x4(%eax)
  803bcf:	eb 08                	jmp    803bd9 <insert_sorted_with_merge_freeList+0x6a>
  803bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803bd4:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  803bdc:	a3 38 61 80 00       	mov    %eax,0x806138
  803be1:	8b 45 08             	mov    0x8(%ebp),%eax
  803be4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803beb:	a1 44 61 80 00       	mov    0x806144,%eax
  803bf0:	40                   	inc    %eax
  803bf1:	a3 44 61 80 00       	mov    %eax,0x806144



	}
	}
	}
  803bf6:	e9 49 07 00 00       	jmp    804344 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803bfe:	8b 50 08             	mov    0x8(%eax),%edx
  803c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c04:	8b 40 0c             	mov    0xc(%eax),%eax
  803c07:	01 c2                	add    %eax,%edx
  803c09:	8b 45 08             	mov    0x8(%ebp),%eax
  803c0c:	8b 40 08             	mov    0x8(%eax),%eax
  803c0f:	39 c2                	cmp    %eax,%edx
  803c11:	73 77                	jae    803c8a <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  803c13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803c16:	8b 00                	mov    (%eax),%eax
  803c18:	85 c0                	test   %eax,%eax
  803c1a:	75 6e                	jne    803c8a <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803c1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803c20:	74 68                	je     803c8a <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  803c22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c26:	75 17                	jne    803c3f <insert_sorted_with_merge_freeList+0xd0>
  803c28:	83 ec 04             	sub    $0x4,%esp
  803c2b:	68 90 4f 80 00       	push   $0x804f90
  803c30:	68 e0 00 00 00       	push   $0xe0
  803c35:	68 77 4f 80 00       	push   $0x804f77
  803c3a:	e8 50 d9 ff ff       	call   80158f <_panic>
  803c3f:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803c45:	8b 45 08             	mov    0x8(%ebp),%eax
  803c48:	89 50 04             	mov    %edx,0x4(%eax)
  803c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c4e:	8b 40 04             	mov    0x4(%eax),%eax
  803c51:	85 c0                	test   %eax,%eax
  803c53:	74 0c                	je     803c61 <insert_sorted_with_merge_freeList+0xf2>
  803c55:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  803c5d:	89 10                	mov    %edx,(%eax)
  803c5f:	eb 08                	jmp    803c69 <insert_sorted_with_merge_freeList+0xfa>
  803c61:	8b 45 08             	mov    0x8(%ebp),%eax
  803c64:	a3 38 61 80 00       	mov    %eax,0x806138
  803c69:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6c:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803c71:	8b 45 08             	mov    0x8(%ebp),%eax
  803c74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803c7a:	a1 44 61 80 00       	mov    0x806144,%eax
  803c7f:	40                   	inc    %eax
  803c80:	a3 44 61 80 00       	mov    %eax,0x806144
  803c85:	e9 ba 06 00 00       	jmp    804344 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8d:	8b 50 0c             	mov    0xc(%eax),%edx
  803c90:	8b 45 08             	mov    0x8(%ebp),%eax
  803c93:	8b 40 08             	mov    0x8(%eax),%eax
  803c96:	01 c2                	add    %eax,%edx
  803c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c9b:	8b 40 08             	mov    0x8(%eax),%eax
  803c9e:	39 c2                	cmp    %eax,%edx
  803ca0:	73 78                	jae    803d1a <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  803ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca5:	8b 40 04             	mov    0x4(%eax),%eax
  803ca8:	85 c0                	test   %eax,%eax
  803caa:	75 6e                	jne    803d1a <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803cac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803cb0:	74 68                	je     803d1a <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  803cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803cb6:	75 17                	jne    803ccf <insert_sorted_with_merge_freeList+0x160>
  803cb8:	83 ec 04             	sub    $0x4,%esp
  803cbb:	68 54 4f 80 00       	push   $0x804f54
  803cc0:	68 e6 00 00 00       	push   $0xe6
  803cc5:	68 77 4f 80 00       	push   $0x804f77
  803cca:	e8 c0 d8 ff ff       	call   80158f <_panic>
  803ccf:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd8:	89 10                	mov    %edx,(%eax)
  803cda:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdd:	8b 00                	mov    (%eax),%eax
  803cdf:	85 c0                	test   %eax,%eax
  803ce1:	74 0d                	je     803cf0 <insert_sorted_with_merge_freeList+0x181>
  803ce3:	a1 38 61 80 00       	mov    0x806138,%eax
  803ce8:	8b 55 08             	mov    0x8(%ebp),%edx
  803ceb:	89 50 04             	mov    %edx,0x4(%eax)
  803cee:	eb 08                	jmp    803cf8 <insert_sorted_with_merge_freeList+0x189>
  803cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  803cf3:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  803cfb:	a3 38 61 80 00       	mov    %eax,0x806138
  803d00:	8b 45 08             	mov    0x8(%ebp),%eax
  803d03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d0a:	a1 44 61 80 00       	mov    0x806144,%eax
  803d0f:	40                   	inc    %eax
  803d10:	a3 44 61 80 00       	mov    %eax,0x806144
  803d15:	e9 2a 06 00 00       	jmp    804344 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803d1a:	a1 38 61 80 00       	mov    0x806138,%eax
  803d1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803d22:	e9 ed 05 00 00       	jmp    804314 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  803d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d2a:	8b 00                	mov    (%eax),%eax
  803d2c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803d2f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803d33:	0f 84 a7 00 00 00    	je     803de0 <insert_sorted_with_merge_freeList+0x271>
  803d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d3c:	8b 50 0c             	mov    0xc(%eax),%edx
  803d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d42:	8b 40 08             	mov    0x8(%eax),%eax
  803d45:	01 c2                	add    %eax,%edx
  803d47:	8b 45 08             	mov    0x8(%ebp),%eax
  803d4a:	8b 40 08             	mov    0x8(%eax),%eax
  803d4d:	39 c2                	cmp    %eax,%edx
  803d4f:	0f 83 8b 00 00 00    	jae    803de0 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  803d55:	8b 45 08             	mov    0x8(%ebp),%eax
  803d58:	8b 50 0c             	mov    0xc(%eax),%edx
  803d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5e:	8b 40 08             	mov    0x8(%eax),%eax
  803d61:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  803d63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803d66:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803d69:	39 c2                	cmp    %eax,%edx
  803d6b:	73 73                	jae    803de0 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803d6d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803d71:	74 06                	je     803d79 <insert_sorted_with_merge_freeList+0x20a>
  803d73:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803d77:	75 17                	jne    803d90 <insert_sorted_with_merge_freeList+0x221>
  803d79:	83 ec 04             	sub    $0x4,%esp
  803d7c:	68 08 50 80 00       	push   $0x805008
  803d81:	68 f0 00 00 00       	push   $0xf0
  803d86:	68 77 4f 80 00       	push   $0x804f77
  803d8b:	e8 ff d7 ff ff       	call   80158f <_panic>
  803d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d93:	8b 10                	mov    (%eax),%edx
  803d95:	8b 45 08             	mov    0x8(%ebp),%eax
  803d98:	89 10                	mov    %edx,(%eax)
  803d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9d:	8b 00                	mov    (%eax),%eax
  803d9f:	85 c0                	test   %eax,%eax
  803da1:	74 0b                	je     803dae <insert_sorted_with_merge_freeList+0x23f>
  803da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803da6:	8b 00                	mov    (%eax),%eax
  803da8:	8b 55 08             	mov    0x8(%ebp),%edx
  803dab:	89 50 04             	mov    %edx,0x4(%eax)
  803dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803db1:	8b 55 08             	mov    0x8(%ebp),%edx
  803db4:	89 10                	mov    %edx,(%eax)
  803db6:	8b 45 08             	mov    0x8(%ebp),%eax
  803db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803dbc:	89 50 04             	mov    %edx,0x4(%eax)
  803dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  803dc2:	8b 00                	mov    (%eax),%eax
  803dc4:	85 c0                	test   %eax,%eax
  803dc6:	75 08                	jne    803dd0 <insert_sorted_with_merge_freeList+0x261>
  803dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  803dcb:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803dd0:	a1 44 61 80 00       	mov    0x806144,%eax
  803dd5:	40                   	inc    %eax
  803dd6:	a3 44 61 80 00       	mov    %eax,0x806144

		         break;
  803ddb:	e9 64 05 00 00       	jmp    804344 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803de0:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803de5:	8b 50 0c             	mov    0xc(%eax),%edx
  803de8:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803ded:	8b 40 08             	mov    0x8(%eax),%eax
  803df0:	01 c2                	add    %eax,%edx
  803df2:	8b 45 08             	mov    0x8(%ebp),%eax
  803df5:	8b 40 08             	mov    0x8(%eax),%eax
  803df8:	39 c2                	cmp    %eax,%edx
  803dfa:	0f 85 b1 00 00 00    	jne    803eb1 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803e00:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803e05:	85 c0                	test   %eax,%eax
  803e07:	0f 84 a4 00 00 00    	je     803eb1 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803e0d:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803e12:	8b 00                	mov    (%eax),%eax
  803e14:	85 c0                	test   %eax,%eax
  803e16:	0f 85 95 00 00 00    	jne    803eb1 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803e1c:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803e21:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803e27:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  803e2d:	8b 52 0c             	mov    0xc(%edx),%edx
  803e30:	01 ca                	add    %ecx,%edx
  803e32:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803e35:	8b 45 08             	mov    0x8(%ebp),%eax
  803e38:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803e49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e4d:	75 17                	jne    803e66 <insert_sorted_with_merge_freeList+0x2f7>
  803e4f:	83 ec 04             	sub    $0x4,%esp
  803e52:	68 54 4f 80 00       	push   $0x804f54
  803e57:	68 ff 00 00 00       	push   $0xff
  803e5c:	68 77 4f 80 00       	push   $0x804f77
  803e61:	e8 29 d7 ff ff       	call   80158f <_panic>
  803e66:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e6f:	89 10                	mov    %edx,(%eax)
  803e71:	8b 45 08             	mov    0x8(%ebp),%eax
  803e74:	8b 00                	mov    (%eax),%eax
  803e76:	85 c0                	test   %eax,%eax
  803e78:	74 0d                	je     803e87 <insert_sorted_with_merge_freeList+0x318>
  803e7a:	a1 48 61 80 00       	mov    0x806148,%eax
  803e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  803e82:	89 50 04             	mov    %edx,0x4(%eax)
  803e85:	eb 08                	jmp    803e8f <insert_sorted_with_merge_freeList+0x320>
  803e87:	8b 45 08             	mov    0x8(%ebp),%eax
  803e8a:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  803e92:	a3 48 61 80 00       	mov    %eax,0x806148
  803e97:	8b 45 08             	mov    0x8(%ebp),%eax
  803e9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ea1:	a1 54 61 80 00       	mov    0x806154,%eax
  803ea6:	40                   	inc    %eax
  803ea7:	a3 54 61 80 00       	mov    %eax,0x806154

	break;
  803eac:	e9 93 04 00 00       	jmp    804344 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  803eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eb4:	8b 50 08             	mov    0x8(%eax),%edx
  803eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eba:	8b 40 0c             	mov    0xc(%eax),%eax
  803ebd:	01 c2                	add    %eax,%edx
  803ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec2:	8b 40 08             	mov    0x8(%eax),%eax
  803ec5:	39 c2                	cmp    %eax,%edx
  803ec7:	0f 85 ae 00 00 00    	jne    803f7b <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed0:	8b 50 0c             	mov    0xc(%eax),%edx
  803ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed6:	8b 40 08             	mov    0x8(%eax),%eax
  803ed9:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ede:	8b 00                	mov    (%eax),%eax
  803ee0:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803ee3:	39 c2                	cmp    %eax,%edx
  803ee5:	0f 84 90 00 00 00    	je     803f7b <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803eee:	8b 50 0c             	mov    0xc(%eax),%edx
  803ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef4:	8b 40 0c             	mov    0xc(%eax),%eax
  803ef7:	01 c2                	add    %eax,%edx
  803ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803efc:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803eff:	8b 45 08             	mov    0x8(%ebp),%eax
  803f02:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803f09:	8b 45 08             	mov    0x8(%ebp),%eax
  803f0c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803f13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f17:	75 17                	jne    803f30 <insert_sorted_with_merge_freeList+0x3c1>
  803f19:	83 ec 04             	sub    $0x4,%esp
  803f1c:	68 54 4f 80 00       	push   $0x804f54
  803f21:	68 0b 01 00 00       	push   $0x10b
  803f26:	68 77 4f 80 00       	push   $0x804f77
  803f2b:	e8 5f d6 ff ff       	call   80158f <_panic>
  803f30:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803f36:	8b 45 08             	mov    0x8(%ebp),%eax
  803f39:	89 10                	mov    %edx,(%eax)
  803f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3e:	8b 00                	mov    (%eax),%eax
  803f40:	85 c0                	test   %eax,%eax
  803f42:	74 0d                	je     803f51 <insert_sorted_with_merge_freeList+0x3e2>
  803f44:	a1 48 61 80 00       	mov    0x806148,%eax
  803f49:	8b 55 08             	mov    0x8(%ebp),%edx
  803f4c:	89 50 04             	mov    %edx,0x4(%eax)
  803f4f:	eb 08                	jmp    803f59 <insert_sorted_with_merge_freeList+0x3ea>
  803f51:	8b 45 08             	mov    0x8(%ebp),%eax
  803f54:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803f59:	8b 45 08             	mov    0x8(%ebp),%eax
  803f5c:	a3 48 61 80 00       	mov    %eax,0x806148
  803f61:	8b 45 08             	mov    0x8(%ebp),%eax
  803f64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803f6b:	a1 54 61 80 00       	mov    0x806154,%eax
  803f70:	40                   	inc    %eax
  803f71:	a3 54 61 80 00       	mov    %eax,0x806154

		break;
  803f76:	e9 c9 03 00 00       	jmp    804344 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803f7e:	8b 50 0c             	mov    0xc(%eax),%edx
  803f81:	8b 45 08             	mov    0x8(%ebp),%eax
  803f84:	8b 40 08             	mov    0x8(%eax),%eax
  803f87:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f8c:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803f8f:	39 c2                	cmp    %eax,%edx
  803f91:	0f 85 bb 00 00 00    	jne    804052 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  803f97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803f9b:	0f 84 b1 00 00 00    	je     804052 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fa4:	8b 40 04             	mov    0x4(%eax),%eax
  803fa7:	85 c0                	test   %eax,%eax
  803fa9:	0f 85 a3 00 00 00    	jne    804052 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803faf:	a1 38 61 80 00       	mov    0x806138,%eax
  803fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  803fb7:	8b 52 08             	mov    0x8(%edx),%edx
  803fba:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803fbd:	a1 38 61 80 00       	mov    0x806138,%eax
  803fc2:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803fc8:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803fcb:	8b 55 08             	mov    0x8(%ebp),%edx
  803fce:	8b 52 0c             	mov    0xc(%edx),%edx
  803fd1:	01 ca                	add    %ecx,%edx
  803fd3:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  803fd9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803fea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803fee:	75 17                	jne    804007 <insert_sorted_with_merge_freeList+0x498>
  803ff0:	83 ec 04             	sub    $0x4,%esp
  803ff3:	68 54 4f 80 00       	push   $0x804f54
  803ff8:	68 17 01 00 00       	push   $0x117
  803ffd:	68 77 4f 80 00       	push   $0x804f77
  804002:	e8 88 d5 ff ff       	call   80158f <_panic>
  804007:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80400d:	8b 45 08             	mov    0x8(%ebp),%eax
  804010:	89 10                	mov    %edx,(%eax)
  804012:	8b 45 08             	mov    0x8(%ebp),%eax
  804015:	8b 00                	mov    (%eax),%eax
  804017:	85 c0                	test   %eax,%eax
  804019:	74 0d                	je     804028 <insert_sorted_with_merge_freeList+0x4b9>
  80401b:	a1 48 61 80 00       	mov    0x806148,%eax
  804020:	8b 55 08             	mov    0x8(%ebp),%edx
  804023:	89 50 04             	mov    %edx,0x4(%eax)
  804026:	eb 08                	jmp    804030 <insert_sorted_with_merge_freeList+0x4c1>
  804028:	8b 45 08             	mov    0x8(%ebp),%eax
  80402b:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804030:	8b 45 08             	mov    0x8(%ebp),%eax
  804033:	a3 48 61 80 00       	mov    %eax,0x806148
  804038:	8b 45 08             	mov    0x8(%ebp),%eax
  80403b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804042:	a1 54 61 80 00       	mov    0x806154,%eax
  804047:	40                   	inc    %eax
  804048:	a3 54 61 80 00       	mov    %eax,0x806154

		break;
  80404d:	e9 f2 02 00 00       	jmp    804344 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  804052:	8b 45 08             	mov    0x8(%ebp),%eax
  804055:	8b 50 08             	mov    0x8(%eax),%edx
  804058:	8b 45 08             	mov    0x8(%ebp),%eax
  80405b:	8b 40 0c             	mov    0xc(%eax),%eax
  80405e:	01 c2                	add    %eax,%edx
  804060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804063:	8b 40 08             	mov    0x8(%eax),%eax
  804066:	39 c2                	cmp    %eax,%edx
  804068:	0f 85 be 00 00 00    	jne    80412c <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  80406e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804071:	8b 40 04             	mov    0x4(%eax),%eax
  804074:	8b 50 08             	mov    0x8(%eax),%edx
  804077:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80407a:	8b 40 04             	mov    0x4(%eax),%eax
  80407d:	8b 40 0c             	mov    0xc(%eax),%eax
  804080:	01 c2                	add    %eax,%edx
  804082:	8b 45 08             	mov    0x8(%ebp),%eax
  804085:	8b 40 08             	mov    0x8(%eax),%eax
  804088:	39 c2                	cmp    %eax,%edx
  80408a:	0f 84 9c 00 00 00    	je     80412c <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  804090:	8b 45 08             	mov    0x8(%ebp),%eax
  804093:	8b 50 08             	mov    0x8(%eax),%edx
  804096:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804099:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  80409c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80409f:	8b 50 0c             	mov    0xc(%eax),%edx
  8040a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8040a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8040a8:	01 c2                	add    %eax,%edx
  8040aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ad:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8040b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8040b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8040ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8040bd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8040c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8040c8:	75 17                	jne    8040e1 <insert_sorted_with_merge_freeList+0x572>
  8040ca:	83 ec 04             	sub    $0x4,%esp
  8040cd:	68 54 4f 80 00       	push   $0x804f54
  8040d2:	68 26 01 00 00       	push   $0x126
  8040d7:	68 77 4f 80 00       	push   $0x804f77
  8040dc:	e8 ae d4 ff ff       	call   80158f <_panic>
  8040e1:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8040e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ea:	89 10                	mov    %edx,(%eax)
  8040ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8040ef:	8b 00                	mov    (%eax),%eax
  8040f1:	85 c0                	test   %eax,%eax
  8040f3:	74 0d                	je     804102 <insert_sorted_with_merge_freeList+0x593>
  8040f5:	a1 48 61 80 00       	mov    0x806148,%eax
  8040fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8040fd:	89 50 04             	mov    %edx,0x4(%eax)
  804100:	eb 08                	jmp    80410a <insert_sorted_with_merge_freeList+0x59b>
  804102:	8b 45 08             	mov    0x8(%ebp),%eax
  804105:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80410a:	8b 45 08             	mov    0x8(%ebp),%eax
  80410d:	a3 48 61 80 00       	mov    %eax,0x806148
  804112:	8b 45 08             	mov    0x8(%ebp),%eax
  804115:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80411c:	a1 54 61 80 00       	mov    0x806154,%eax
  804121:	40                   	inc    %eax
  804122:	a3 54 61 80 00       	mov    %eax,0x806154

		break;//8
  804127:	e9 18 02 00 00       	jmp    804344 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  80412c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80412f:	8b 50 0c             	mov    0xc(%eax),%edx
  804132:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804135:	8b 40 08             	mov    0x8(%eax),%eax
  804138:	01 c2                	add    %eax,%edx
  80413a:	8b 45 08             	mov    0x8(%ebp),%eax
  80413d:	8b 40 08             	mov    0x8(%eax),%eax
  804140:	39 c2                	cmp    %eax,%edx
  804142:	0f 85 c4 01 00 00    	jne    80430c <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  804148:	8b 45 08             	mov    0x8(%ebp),%eax
  80414b:	8b 50 0c             	mov    0xc(%eax),%edx
  80414e:	8b 45 08             	mov    0x8(%ebp),%eax
  804151:	8b 40 08             	mov    0x8(%eax),%eax
  804154:	01 c2                	add    %eax,%edx
  804156:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804159:	8b 00                	mov    (%eax),%eax
  80415b:	8b 40 08             	mov    0x8(%eax),%eax
  80415e:	39 c2                	cmp    %eax,%edx
  804160:	0f 85 a6 01 00 00    	jne    80430c <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  804166:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80416a:	0f 84 9c 01 00 00    	je     80430c <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  804170:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804173:	8b 50 0c             	mov    0xc(%eax),%edx
  804176:	8b 45 08             	mov    0x8(%ebp),%eax
  804179:	8b 40 0c             	mov    0xc(%eax),%eax
  80417c:	01 c2                	add    %eax,%edx
  80417e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804181:	8b 00                	mov    (%eax),%eax
  804183:	8b 40 0c             	mov    0xc(%eax),%eax
  804186:	01 c2                	add    %eax,%edx
  804188:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80418b:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  80418e:	8b 45 08             	mov    0x8(%ebp),%eax
  804191:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  804198:	8b 45 08             	mov    0x8(%ebp),%eax
  80419b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8041a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8041a6:	75 17                	jne    8041bf <insert_sorted_with_merge_freeList+0x650>
  8041a8:	83 ec 04             	sub    $0x4,%esp
  8041ab:	68 54 4f 80 00       	push   $0x804f54
  8041b0:	68 32 01 00 00       	push   $0x132
  8041b5:	68 77 4f 80 00       	push   $0x804f77
  8041ba:	e8 d0 d3 ff ff       	call   80158f <_panic>
  8041bf:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8041c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8041c8:	89 10                	mov    %edx,(%eax)
  8041ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8041cd:	8b 00                	mov    (%eax),%eax
  8041cf:	85 c0                	test   %eax,%eax
  8041d1:	74 0d                	je     8041e0 <insert_sorted_with_merge_freeList+0x671>
  8041d3:	a1 48 61 80 00       	mov    0x806148,%eax
  8041d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8041db:	89 50 04             	mov    %edx,0x4(%eax)
  8041de:	eb 08                	jmp    8041e8 <insert_sorted_with_merge_freeList+0x679>
  8041e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8041e3:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8041e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8041eb:	a3 48 61 80 00       	mov    %eax,0x806148
  8041f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8041fa:	a1 54 61 80 00       	mov    0x806154,%eax
  8041ff:	40                   	inc    %eax
  804200:	a3 54 61 80 00       	mov    %eax,0x806154
	    ptr->prev_next_info.le_next->sva = 0;
  804205:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804208:	8b 00                	mov    (%eax),%eax
  80420a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  804211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804214:	8b 00                	mov    (%eax),%eax
  804216:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80421d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804220:	8b 00                	mov    (%eax),%eax
  804222:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  804225:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804229:	75 17                	jne    804242 <insert_sorted_with_merge_freeList+0x6d3>
  80422b:	83 ec 04             	sub    $0x4,%esp
  80422e:	68 e9 4f 80 00       	push   $0x804fe9
  804233:	68 36 01 00 00       	push   $0x136
  804238:	68 77 4f 80 00       	push   $0x804f77
  80423d:	e8 4d d3 ff ff       	call   80158f <_panic>
  804242:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804245:	8b 00                	mov    (%eax),%eax
  804247:	85 c0                	test   %eax,%eax
  804249:	74 10                	je     80425b <insert_sorted_with_merge_freeList+0x6ec>
  80424b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80424e:	8b 00                	mov    (%eax),%eax
  804250:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804253:	8b 52 04             	mov    0x4(%edx),%edx
  804256:	89 50 04             	mov    %edx,0x4(%eax)
  804259:	eb 0b                	jmp    804266 <insert_sorted_with_merge_freeList+0x6f7>
  80425b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80425e:	8b 40 04             	mov    0x4(%eax),%eax
  804261:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804269:	8b 40 04             	mov    0x4(%eax),%eax
  80426c:	85 c0                	test   %eax,%eax
  80426e:	74 0f                	je     80427f <insert_sorted_with_merge_freeList+0x710>
  804270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804273:	8b 40 04             	mov    0x4(%eax),%eax
  804276:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804279:	8b 12                	mov    (%edx),%edx
  80427b:	89 10                	mov    %edx,(%eax)
  80427d:	eb 0a                	jmp    804289 <insert_sorted_with_merge_freeList+0x71a>
  80427f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804282:	8b 00                	mov    (%eax),%eax
  804284:	a3 38 61 80 00       	mov    %eax,0x806138
  804289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80428c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  804292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804295:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80429c:	a1 44 61 80 00       	mov    0x806144,%eax
  8042a1:	48                   	dec    %eax
  8042a2:	a3 44 61 80 00       	mov    %eax,0x806144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8042a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8042ab:	75 17                	jne    8042c4 <insert_sorted_with_merge_freeList+0x755>
  8042ad:	83 ec 04             	sub    $0x4,%esp
  8042b0:	68 54 4f 80 00       	push   $0x804f54
  8042b5:	68 37 01 00 00       	push   $0x137
  8042ba:	68 77 4f 80 00       	push   $0x804f77
  8042bf:	e8 cb d2 ff ff       	call   80158f <_panic>
  8042c4:	8b 15 48 61 80 00    	mov    0x806148,%edx
  8042ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042cd:	89 10                	mov    %edx,(%eax)
  8042cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042d2:	8b 00                	mov    (%eax),%eax
  8042d4:	85 c0                	test   %eax,%eax
  8042d6:	74 0d                	je     8042e5 <insert_sorted_with_merge_freeList+0x776>
  8042d8:	a1 48 61 80 00       	mov    0x806148,%eax
  8042dd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8042e0:	89 50 04             	mov    %edx,0x4(%eax)
  8042e3:	eb 08                	jmp    8042ed <insert_sorted_with_merge_freeList+0x77e>
  8042e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042e8:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8042ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042f0:	a3 48 61 80 00       	mov    %eax,0x806148
  8042f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8042f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8042ff:	a1 54 61 80 00       	mov    0x806154,%eax
  804304:	40                   	inc    %eax
  804305:	a3 54 61 80 00       	mov    %eax,0x806154

	    break;//9
  80430a:	eb 38                	jmp    804344 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80430c:	a1 40 61 80 00       	mov    0x806140,%eax
  804311:	89 45 f4             	mov    %eax,-0xc(%ebp)
  804314:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804318:	74 07                	je     804321 <insert_sorted_with_merge_freeList+0x7b2>
  80431a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80431d:	8b 00                	mov    (%eax),%eax
  80431f:	eb 05                	jmp    804326 <insert_sorted_with_merge_freeList+0x7b7>
  804321:	b8 00 00 00 00       	mov    $0x0,%eax
  804326:	a3 40 61 80 00       	mov    %eax,0x806140
  80432b:	a1 40 61 80 00       	mov    0x806140,%eax
  804330:	85 c0                	test   %eax,%eax
  804332:	0f 85 ef f9 ff ff    	jne    803d27 <insert_sorted_with_merge_freeList+0x1b8>
  804338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80433c:	0f 85 e5 f9 ff ff    	jne    803d27 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  804342:	eb 00                	jmp    804344 <insert_sorted_with_merge_freeList+0x7d5>
  804344:	90                   	nop
  804345:	c9                   	leave  
  804346:	c3                   	ret    
  804347:	90                   	nop

00804348 <__udivdi3>:
  804348:	55                   	push   %ebp
  804349:	57                   	push   %edi
  80434a:	56                   	push   %esi
  80434b:	53                   	push   %ebx
  80434c:	83 ec 1c             	sub    $0x1c,%esp
  80434f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  804353:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  804357:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80435b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80435f:	89 ca                	mov    %ecx,%edx
  804361:	89 f8                	mov    %edi,%eax
  804363:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804367:	85 f6                	test   %esi,%esi
  804369:	75 2d                	jne    804398 <__udivdi3+0x50>
  80436b:	39 cf                	cmp    %ecx,%edi
  80436d:	77 65                	ja     8043d4 <__udivdi3+0x8c>
  80436f:	89 fd                	mov    %edi,%ebp
  804371:	85 ff                	test   %edi,%edi
  804373:	75 0b                	jne    804380 <__udivdi3+0x38>
  804375:	b8 01 00 00 00       	mov    $0x1,%eax
  80437a:	31 d2                	xor    %edx,%edx
  80437c:	f7 f7                	div    %edi
  80437e:	89 c5                	mov    %eax,%ebp
  804380:	31 d2                	xor    %edx,%edx
  804382:	89 c8                	mov    %ecx,%eax
  804384:	f7 f5                	div    %ebp
  804386:	89 c1                	mov    %eax,%ecx
  804388:	89 d8                	mov    %ebx,%eax
  80438a:	f7 f5                	div    %ebp
  80438c:	89 cf                	mov    %ecx,%edi
  80438e:	89 fa                	mov    %edi,%edx
  804390:	83 c4 1c             	add    $0x1c,%esp
  804393:	5b                   	pop    %ebx
  804394:	5e                   	pop    %esi
  804395:	5f                   	pop    %edi
  804396:	5d                   	pop    %ebp
  804397:	c3                   	ret    
  804398:	39 ce                	cmp    %ecx,%esi
  80439a:	77 28                	ja     8043c4 <__udivdi3+0x7c>
  80439c:	0f bd fe             	bsr    %esi,%edi
  80439f:	83 f7 1f             	xor    $0x1f,%edi
  8043a2:	75 40                	jne    8043e4 <__udivdi3+0x9c>
  8043a4:	39 ce                	cmp    %ecx,%esi
  8043a6:	72 0a                	jb     8043b2 <__udivdi3+0x6a>
  8043a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8043ac:	0f 87 9e 00 00 00    	ja     804450 <__udivdi3+0x108>
  8043b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8043b7:	89 fa                	mov    %edi,%edx
  8043b9:	83 c4 1c             	add    $0x1c,%esp
  8043bc:	5b                   	pop    %ebx
  8043bd:	5e                   	pop    %esi
  8043be:	5f                   	pop    %edi
  8043bf:	5d                   	pop    %ebp
  8043c0:	c3                   	ret    
  8043c1:	8d 76 00             	lea    0x0(%esi),%esi
  8043c4:	31 ff                	xor    %edi,%edi
  8043c6:	31 c0                	xor    %eax,%eax
  8043c8:	89 fa                	mov    %edi,%edx
  8043ca:	83 c4 1c             	add    $0x1c,%esp
  8043cd:	5b                   	pop    %ebx
  8043ce:	5e                   	pop    %esi
  8043cf:	5f                   	pop    %edi
  8043d0:	5d                   	pop    %ebp
  8043d1:	c3                   	ret    
  8043d2:	66 90                	xchg   %ax,%ax
  8043d4:	89 d8                	mov    %ebx,%eax
  8043d6:	f7 f7                	div    %edi
  8043d8:	31 ff                	xor    %edi,%edi
  8043da:	89 fa                	mov    %edi,%edx
  8043dc:	83 c4 1c             	add    $0x1c,%esp
  8043df:	5b                   	pop    %ebx
  8043e0:	5e                   	pop    %esi
  8043e1:	5f                   	pop    %edi
  8043e2:	5d                   	pop    %ebp
  8043e3:	c3                   	ret    
  8043e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8043e9:	89 eb                	mov    %ebp,%ebx
  8043eb:	29 fb                	sub    %edi,%ebx
  8043ed:	89 f9                	mov    %edi,%ecx
  8043ef:	d3 e6                	shl    %cl,%esi
  8043f1:	89 c5                	mov    %eax,%ebp
  8043f3:	88 d9                	mov    %bl,%cl
  8043f5:	d3 ed                	shr    %cl,%ebp
  8043f7:	89 e9                	mov    %ebp,%ecx
  8043f9:	09 f1                	or     %esi,%ecx
  8043fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8043ff:	89 f9                	mov    %edi,%ecx
  804401:	d3 e0                	shl    %cl,%eax
  804403:	89 c5                	mov    %eax,%ebp
  804405:	89 d6                	mov    %edx,%esi
  804407:	88 d9                	mov    %bl,%cl
  804409:	d3 ee                	shr    %cl,%esi
  80440b:	89 f9                	mov    %edi,%ecx
  80440d:	d3 e2                	shl    %cl,%edx
  80440f:	8b 44 24 08          	mov    0x8(%esp),%eax
  804413:	88 d9                	mov    %bl,%cl
  804415:	d3 e8                	shr    %cl,%eax
  804417:	09 c2                	or     %eax,%edx
  804419:	89 d0                	mov    %edx,%eax
  80441b:	89 f2                	mov    %esi,%edx
  80441d:	f7 74 24 0c          	divl   0xc(%esp)
  804421:	89 d6                	mov    %edx,%esi
  804423:	89 c3                	mov    %eax,%ebx
  804425:	f7 e5                	mul    %ebp
  804427:	39 d6                	cmp    %edx,%esi
  804429:	72 19                	jb     804444 <__udivdi3+0xfc>
  80442b:	74 0b                	je     804438 <__udivdi3+0xf0>
  80442d:	89 d8                	mov    %ebx,%eax
  80442f:	31 ff                	xor    %edi,%edi
  804431:	e9 58 ff ff ff       	jmp    80438e <__udivdi3+0x46>
  804436:	66 90                	xchg   %ax,%ax
  804438:	8b 54 24 08          	mov    0x8(%esp),%edx
  80443c:	89 f9                	mov    %edi,%ecx
  80443e:	d3 e2                	shl    %cl,%edx
  804440:	39 c2                	cmp    %eax,%edx
  804442:	73 e9                	jae    80442d <__udivdi3+0xe5>
  804444:	8d 43 ff             	lea    -0x1(%ebx),%eax
  804447:	31 ff                	xor    %edi,%edi
  804449:	e9 40 ff ff ff       	jmp    80438e <__udivdi3+0x46>
  80444e:	66 90                	xchg   %ax,%ax
  804450:	31 c0                	xor    %eax,%eax
  804452:	e9 37 ff ff ff       	jmp    80438e <__udivdi3+0x46>
  804457:	90                   	nop

00804458 <__umoddi3>:
  804458:	55                   	push   %ebp
  804459:	57                   	push   %edi
  80445a:	56                   	push   %esi
  80445b:	53                   	push   %ebx
  80445c:	83 ec 1c             	sub    $0x1c,%esp
  80445f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  804463:	8b 74 24 34          	mov    0x34(%esp),%esi
  804467:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80446b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80446f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804473:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804477:	89 f3                	mov    %esi,%ebx
  804479:	89 fa                	mov    %edi,%edx
  80447b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80447f:	89 34 24             	mov    %esi,(%esp)
  804482:	85 c0                	test   %eax,%eax
  804484:	75 1a                	jne    8044a0 <__umoddi3+0x48>
  804486:	39 f7                	cmp    %esi,%edi
  804488:	0f 86 a2 00 00 00    	jbe    804530 <__umoddi3+0xd8>
  80448e:	89 c8                	mov    %ecx,%eax
  804490:	89 f2                	mov    %esi,%edx
  804492:	f7 f7                	div    %edi
  804494:	89 d0                	mov    %edx,%eax
  804496:	31 d2                	xor    %edx,%edx
  804498:	83 c4 1c             	add    $0x1c,%esp
  80449b:	5b                   	pop    %ebx
  80449c:	5e                   	pop    %esi
  80449d:	5f                   	pop    %edi
  80449e:	5d                   	pop    %ebp
  80449f:	c3                   	ret    
  8044a0:	39 f0                	cmp    %esi,%eax
  8044a2:	0f 87 ac 00 00 00    	ja     804554 <__umoddi3+0xfc>
  8044a8:	0f bd e8             	bsr    %eax,%ebp
  8044ab:	83 f5 1f             	xor    $0x1f,%ebp
  8044ae:	0f 84 ac 00 00 00    	je     804560 <__umoddi3+0x108>
  8044b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8044b9:	29 ef                	sub    %ebp,%edi
  8044bb:	89 fe                	mov    %edi,%esi
  8044bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8044c1:	89 e9                	mov    %ebp,%ecx
  8044c3:	d3 e0                	shl    %cl,%eax
  8044c5:	89 d7                	mov    %edx,%edi
  8044c7:	89 f1                	mov    %esi,%ecx
  8044c9:	d3 ef                	shr    %cl,%edi
  8044cb:	09 c7                	or     %eax,%edi
  8044cd:	89 e9                	mov    %ebp,%ecx
  8044cf:	d3 e2                	shl    %cl,%edx
  8044d1:	89 14 24             	mov    %edx,(%esp)
  8044d4:	89 d8                	mov    %ebx,%eax
  8044d6:	d3 e0                	shl    %cl,%eax
  8044d8:	89 c2                	mov    %eax,%edx
  8044da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044de:	d3 e0                	shl    %cl,%eax
  8044e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8044e8:	89 f1                	mov    %esi,%ecx
  8044ea:	d3 e8                	shr    %cl,%eax
  8044ec:	09 d0                	or     %edx,%eax
  8044ee:	d3 eb                	shr    %cl,%ebx
  8044f0:	89 da                	mov    %ebx,%edx
  8044f2:	f7 f7                	div    %edi
  8044f4:	89 d3                	mov    %edx,%ebx
  8044f6:	f7 24 24             	mull   (%esp)
  8044f9:	89 c6                	mov    %eax,%esi
  8044fb:	89 d1                	mov    %edx,%ecx
  8044fd:	39 d3                	cmp    %edx,%ebx
  8044ff:	0f 82 87 00 00 00    	jb     80458c <__umoddi3+0x134>
  804505:	0f 84 91 00 00 00    	je     80459c <__umoddi3+0x144>
  80450b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80450f:	29 f2                	sub    %esi,%edx
  804511:	19 cb                	sbb    %ecx,%ebx
  804513:	89 d8                	mov    %ebx,%eax
  804515:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  804519:	d3 e0                	shl    %cl,%eax
  80451b:	89 e9                	mov    %ebp,%ecx
  80451d:	d3 ea                	shr    %cl,%edx
  80451f:	09 d0                	or     %edx,%eax
  804521:	89 e9                	mov    %ebp,%ecx
  804523:	d3 eb                	shr    %cl,%ebx
  804525:	89 da                	mov    %ebx,%edx
  804527:	83 c4 1c             	add    $0x1c,%esp
  80452a:	5b                   	pop    %ebx
  80452b:	5e                   	pop    %esi
  80452c:	5f                   	pop    %edi
  80452d:	5d                   	pop    %ebp
  80452e:	c3                   	ret    
  80452f:	90                   	nop
  804530:	89 fd                	mov    %edi,%ebp
  804532:	85 ff                	test   %edi,%edi
  804534:	75 0b                	jne    804541 <__umoddi3+0xe9>
  804536:	b8 01 00 00 00       	mov    $0x1,%eax
  80453b:	31 d2                	xor    %edx,%edx
  80453d:	f7 f7                	div    %edi
  80453f:	89 c5                	mov    %eax,%ebp
  804541:	89 f0                	mov    %esi,%eax
  804543:	31 d2                	xor    %edx,%edx
  804545:	f7 f5                	div    %ebp
  804547:	89 c8                	mov    %ecx,%eax
  804549:	f7 f5                	div    %ebp
  80454b:	89 d0                	mov    %edx,%eax
  80454d:	e9 44 ff ff ff       	jmp    804496 <__umoddi3+0x3e>
  804552:	66 90                	xchg   %ax,%ax
  804554:	89 c8                	mov    %ecx,%eax
  804556:	89 f2                	mov    %esi,%edx
  804558:	83 c4 1c             	add    $0x1c,%esp
  80455b:	5b                   	pop    %ebx
  80455c:	5e                   	pop    %esi
  80455d:	5f                   	pop    %edi
  80455e:	5d                   	pop    %ebp
  80455f:	c3                   	ret    
  804560:	3b 04 24             	cmp    (%esp),%eax
  804563:	72 06                	jb     80456b <__umoddi3+0x113>
  804565:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804569:	77 0f                	ja     80457a <__umoddi3+0x122>
  80456b:	89 f2                	mov    %esi,%edx
  80456d:	29 f9                	sub    %edi,%ecx
  80456f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  804573:	89 14 24             	mov    %edx,(%esp)
  804576:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80457a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80457e:	8b 14 24             	mov    (%esp),%edx
  804581:	83 c4 1c             	add    $0x1c,%esp
  804584:	5b                   	pop    %ebx
  804585:	5e                   	pop    %esi
  804586:	5f                   	pop    %edi
  804587:	5d                   	pop    %ebp
  804588:	c3                   	ret    
  804589:	8d 76 00             	lea    0x0(%esi),%esi
  80458c:	2b 04 24             	sub    (%esp),%eax
  80458f:	19 fa                	sbb    %edi,%edx
  804591:	89 d1                	mov    %edx,%ecx
  804593:	89 c6                	mov    %eax,%esi
  804595:	e9 71 ff ff ff       	jmp    80450b <__umoddi3+0xb3>
  80459a:	66 90                	xchg   %ax,%ax
  80459c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8045a0:	72 ea                	jb     80458c <__umoddi3+0x134>
  8045a2:	89 d9                	mov    %ebx,%ecx
  8045a4:	e9 62 ff ff ff       	jmp    80450b <__umoddi3+0xb3>
