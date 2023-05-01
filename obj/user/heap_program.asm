
obj/user/heap_program:     file format elf32-i386


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
  800031:	e8 0c 02 00 00       	call   800242 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 5c             	sub    $0x5c,%esp
	int kilo = 1024;
  800041:	c7 45 d8 00 04 00 00 	movl   $0x400,-0x28(%ebp)
	int Mega = 1024*1024;
  800048:	c7 45 d4 00 00 10 00 	movl   $0x100000,-0x2c(%ebp)

	/// testing freeHeap()
	{
		uint32 size = 13*Mega;
  80004f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800052:	89 d0                	mov    %edx,%eax
  800054:	01 c0                	add    %eax,%eax
  800056:	01 d0                	add    %edx,%eax
  800058:	c1 e0 02             	shl    $0x2,%eax
  80005b:	01 d0                	add    %edx,%eax
  80005d:	89 45 d0             	mov    %eax,-0x30(%ebp)
		char *x = malloc(sizeof( char)*size) ;
  800060:	83 ec 0c             	sub    $0xc,%esp
  800063:	ff 75 d0             	pushl  -0x30(%ebp)
  800066:	e8 66 15 00 00       	call   8015d1 <malloc>
  80006b:	83 c4 10             	add    $0x10,%esp
  80006e:	89 45 cc             	mov    %eax,-0x34(%ebp)

		char *y = malloc(sizeof( char)*size) ;
  800071:	83 ec 0c             	sub    $0xc,%esp
  800074:	ff 75 d0             	pushl  -0x30(%ebp)
  800077:	e8 55 15 00 00       	call   8015d1 <malloc>
  80007c:	83 c4 10             	add    $0x10,%esp
  80007f:	89 45 c8             	mov    %eax,-0x38(%ebp)


		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800082:	e8 88 1a 00 00       	call   801b0f <sys_pf_calculate_allocated_pages>
  800087:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		x[1]=-1;
  80008a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80008d:	40                   	inc    %eax
  80008e:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega]=-1;
  800091:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800094:	89 d0                	mov    %edx,%eax
  800096:	c1 e0 02             	shl    $0x2,%eax
  800099:	01 d0                	add    %edx,%eax
  80009b:	89 c2                	mov    %eax,%edx
  80009d:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000a0:	01 d0                	add    %edx,%eax
  8000a2:	c6 00 ff             	movb   $0xff,(%eax)

		//Access VA 0x200000
		int *p1 = (int *)0x200000 ;
  8000a5:	c7 45 c0 00 00 20 00 	movl   $0x200000,-0x40(%ebp)
		*p1 = -1 ;
  8000ac:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8000af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)

		y[1*Mega]=-1;
  8000b5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000b8:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000bb:	01 d0                	add    %edx,%eax
  8000bd:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	c1 e0 03             	shl    $0x3,%eax
  8000c6:	89 c2                	mov    %eax,%edx
  8000c8:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000cb:	01 d0                	add    %edx,%eax
  8000cd:	c6 00 ff             	movb   $0xff,(%eax)

		x[12*Mega]=-1;
  8000d0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8000d3:	89 d0                	mov    %edx,%eax
  8000d5:	01 c0                	add    %eax,%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c1 e0 02             	shl    $0x2,%eax
  8000dc:	89 c2                	mov    %eax,%edx
  8000de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000e1:	01 d0                	add    %edx,%eax
  8000e3:	c6 00 ff             	movb   $0xff,(%eax)


		//int usedDiskPages = sys_pf_calculate_allocated_pages() ;


		free(x);
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	ff 75 cc             	pushl  -0x34(%ebp)
  8000ec:	e8 79 15 00 00       	call   80166a <free>
  8000f1:	83 c4 10             	add    $0x10,%esp
		free(y);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	ff 75 c8             	pushl  -0x38(%ebp)
  8000fa:	e8 6b 15 00 00       	call   80166a <free>
  8000ff:	83 c4 10             	add    $0x10,%esp

		///		cprintf("%d\n",sys_pf_calculate_allocated_pages() - usedDiskPages);
		///assert((sys_pf_calculate_allocated_pages() - usedDiskPages) == 5 ); //4 pages + 1 table, that was not in WS

		int freePages = sys_calculate_free_frames();
  800102:	e8 68 19 00 00       	call   801a6f <sys_calculate_free_frames>
  800107:	89 45 bc             	mov    %eax,-0x44(%ebp)
		x = malloc(sizeof(char)*size) ;
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	ff 75 d0             	pushl  -0x30(%ebp)
  800110:	e8 bc 14 00 00       	call   8015d1 <malloc>
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	89 45 cc             	mov    %eax,-0x34(%ebp)

		//Access VA 0x200000
		*p1 = -1 ;
  80011b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80011e:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


		x[1]=-2;
  800124:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800127:	40                   	inc    %eax
  800128:	c6 00 fe             	movb   $0xfe,(%eax)

		x[5*Mega]=-2;
  80012b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80012e:	89 d0                	mov    %edx,%eax
  800130:	c1 e0 02             	shl    $0x2,%eax
  800133:	01 d0                	add    %edx,%eax
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80013a:	01 d0                	add    %edx,%eax
  80013c:	c6 00 fe             	movb   $0xfe,(%eax)

		x[8*Mega] = -2;
  80013f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800142:	c1 e0 03             	shl    $0x3,%eax
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	c6 00 fe             	movb   $0xfe,(%eax)

//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};
  80014f:	8d 45 9c             	lea    -0x64(%ebp),%eax
  800152:	bb 9c 34 80 00       	mov    $0x80349c,%ebx
  800157:	ba 07 00 00 00       	mov    $0x7,%edx
  80015c:	89 c7                	mov    %eax,%edi
  80015e:	89 de                	mov    %ebx,%esi
  800160:	89 d1                	mov    %edx,%ecx
  800162:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

		int i = 0, j ;
  800164:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (; i < 7; i++)
  80016b:	eb 7e                	jmp    8001eb <_main+0x1b3>
		{
			int found = 0 ;
  80016d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  800174:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80017b:	eb 3d                	jmp    8001ba <_main+0x182>
			{
				if (pageWSEntries[i] == ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address,PAGE_SIZE) )
  80017d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800180:	8b 4c 85 9c          	mov    -0x64(%ebp,%eax,4),%ecx
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	8b 98 9c 05 00 00    	mov    0x59c(%eax),%ebx
  80018f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	01 c0                	add    %eax,%eax
  800196:	01 d0                	add    %edx,%eax
  800198:	c1 e0 03             	shl    $0x3,%eax
  80019b:	01 d8                	add    %ebx,%eax
  80019d:	8b 00                	mov    (%eax),%eax
  80019f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  8001a2:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8001a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001aa:	39 c1                	cmp    %eax,%ecx
  8001ac:	75 09                	jne    8001b7 <_main+0x17f>
				{
					found = 1 ;
  8001ae:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
					break;
  8001b5:	eb 12                	jmp    8001c9 <_main+0x191>

		int i = 0, j ;
		for (; i < 7; i++)
		{
			int found = 0 ;
			for (j=0; j < (myEnv->page_WS_max_size); j++)
  8001b7:	ff 45 e0             	incl   -0x20(%ebp)
  8001ba:	a1 20 40 80 00       	mov    0x804020,%eax
  8001bf:	8b 50 74             	mov    0x74(%eax),%edx
  8001c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c5:	39 c2                	cmp    %eax,%edx
  8001c7:	77 b4                	ja     80017d <_main+0x145>
				{
					found = 1 ;
					break;
				}
			}
			if (!found)
  8001c9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001cd:	75 19                	jne    8001e8 <_main+0x1b0>
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
  8001cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001d2:	8b 44 85 9c          	mov    -0x64(%ebp,%eax,4),%eax
  8001d6:	50                   	push   %eax
  8001d7:	68 a0 33 80 00       	push   $0x8033a0
  8001dc:	6a 4c                	push   $0x4c
  8001de:	68 01 34 80 00       	push   $0x803401
  8001e3:	e8 96 01 00 00       	call   80037e <_panic>
//		x[12*Mega]=-2;

		uint32 pageWSEntries[7] = {0x80000000, 0x80500000, 0x80800000, 0x800000, 0x803000, 0x200000, 0xeebfd000};

		int i = 0, j ;
		for (; i < 7; i++)
  8001e8:	ff 45 e4             	incl   -0x1c(%ebp)
  8001eb:	83 7d e4 06          	cmpl   $0x6,-0x1c(%ebp)
  8001ef:	0f 8e 78 ff ff ff    	jle    80016d <_main+0x135>
			}
			if (!found)
				panic("PAGE Placement algorithm failed after applying freeHeap. Page at VA %x is expected but not found", pageWSEntries[i]);
		}

		if( (freePages - sys_calculate_free_frames() ) != 6 ) panic("Extra/Less memory are wrongly allocated. diff = %d, expected = %d", freePages - sys_calculate_free_frames(), 8);
  8001f5:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  8001f8:	e8 72 18 00 00       	call   801a6f <sys_calculate_free_frames>
  8001fd:	29 c3                	sub    %eax,%ebx
  8001ff:	89 d8                	mov    %ebx,%eax
  800201:	83 f8 06             	cmp    $0x6,%eax
  800204:	74 23                	je     800229 <_main+0x1f1>
  800206:	8b 5d bc             	mov    -0x44(%ebp),%ebx
  800209:	e8 61 18 00 00       	call   801a6f <sys_calculate_free_frames>
  80020e:	29 c3                	sub    %eax,%ebx
  800210:	89 d8                	mov    %ebx,%eax
  800212:	83 ec 0c             	sub    $0xc,%esp
  800215:	6a 08                	push   $0x8
  800217:	50                   	push   %eax
  800218:	68 18 34 80 00       	push   $0x803418
  80021d:	6a 4f                	push   $0x4f
  80021f:	68 01 34 80 00       	push   $0x803401
  800224:	e8 55 01 00 00       	call   80037e <_panic>
	}

	cprintf("Congratulations!! test HEAP_PROGRAM completed successfully.\n");
  800229:	83 ec 0c             	sub    $0xc,%esp
  80022c:	68 5c 34 80 00       	push   $0x80345c
  800231:	e8 fc 03 00 00       	call   800632 <cprintf>
  800236:	83 c4 10             	add    $0x10,%esp


	return;
  800239:	90                   	nop
}
  80023a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80023d:	5b                   	pop    %ebx
  80023e:	5e                   	pop    %esi
  80023f:	5f                   	pop    %edi
  800240:	5d                   	pop    %ebp
  800241:	c3                   	ret    

00800242 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800248:	e8 02 1b 00 00       	call   801d4f <sys_getenvindex>
  80024d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800253:	89 d0                	mov    %edx,%eax
  800255:	c1 e0 03             	shl    $0x3,%eax
  800258:	01 d0                	add    %edx,%eax
  80025a:	01 c0                	add    %eax,%eax
  80025c:	01 d0                	add    %edx,%eax
  80025e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800265:	01 d0                	add    %edx,%eax
  800267:	c1 e0 04             	shl    $0x4,%eax
  80026a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80026f:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80027f:	84 c0                	test   %al,%al
  800281:	74 0f                	je     800292 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800283:	a1 20 40 80 00       	mov    0x804020,%eax
  800288:	05 5c 05 00 00       	add    $0x55c,%eax
  80028d:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800292:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800296:	7e 0a                	jle    8002a2 <libmain+0x60>
		binaryname = argv[0];
  800298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80029b:	8b 00                	mov    (%eax),%eax
  80029d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002a2:	83 ec 08             	sub    $0x8,%esp
  8002a5:	ff 75 0c             	pushl  0xc(%ebp)
  8002a8:	ff 75 08             	pushl  0x8(%ebp)
  8002ab:	e8 88 fd ff ff       	call   800038 <_main>
  8002b0:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002b3:	e8 a4 18 00 00       	call   801b5c <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 d0 34 80 00       	push   $0x8034d0
  8002c0:	e8 6d 03 00 00       	call   800632 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002c8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002cd:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002de:	83 ec 04             	sub    $0x4,%esp
  8002e1:	52                   	push   %edx
  8002e2:	50                   	push   %eax
  8002e3:	68 f8 34 80 00       	push   $0x8034f8
  8002e8:	e8 45 03 00 00       	call   800632 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f5:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002fb:	a1 20 40 80 00       	mov    0x804020,%eax
  800300:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800306:	a1 20 40 80 00       	mov    0x804020,%eax
  80030b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800311:	51                   	push   %ecx
  800312:	52                   	push   %edx
  800313:	50                   	push   %eax
  800314:	68 20 35 80 00       	push   $0x803520
  800319:	e8 14 03 00 00       	call   800632 <cprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800321:	a1 20 40 80 00       	mov    0x804020,%eax
  800326:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80032c:	83 ec 08             	sub    $0x8,%esp
  80032f:	50                   	push   %eax
  800330:	68 78 35 80 00       	push   $0x803578
  800335:	e8 f8 02 00 00       	call   800632 <cprintf>
  80033a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 d0 34 80 00       	push   $0x8034d0
  800345:	e8 e8 02 00 00       	call   800632 <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80034d:	e8 24 18 00 00       	call   801b76 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800352:	e8 19 00 00 00       	call   800370 <exit>
}
  800357:	90                   	nop
  800358:	c9                   	leave  
  800359:	c3                   	ret    

0080035a <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80035a:	55                   	push   %ebp
  80035b:	89 e5                	mov    %esp,%ebp
  80035d:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800360:	83 ec 0c             	sub    $0xc,%esp
  800363:	6a 00                	push   $0x0
  800365:	e8 b1 19 00 00       	call   801d1b <sys_destroy_env>
  80036a:	83 c4 10             	add    $0x10,%esp
}
  80036d:	90                   	nop
  80036e:	c9                   	leave  
  80036f:	c3                   	ret    

00800370 <exit>:

void
exit(void)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800376:	e8 06 1a 00 00       	call   801d81 <sys_exit_env>
}
  80037b:	90                   	nop
  80037c:	c9                   	leave  
  80037d:	c3                   	ret    

0080037e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80037e:	55                   	push   %ebp
  80037f:	89 e5                	mov    %esp,%ebp
  800381:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800384:	8d 45 10             	lea    0x10(%ebp),%eax
  800387:	83 c0 04             	add    $0x4,%eax
  80038a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80038d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800392:	85 c0                	test   %eax,%eax
  800394:	74 16                	je     8003ac <_panic+0x2e>
		cprintf("%s: ", argv0);
  800396:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80039b:	83 ec 08             	sub    $0x8,%esp
  80039e:	50                   	push   %eax
  80039f:	68 8c 35 80 00       	push   $0x80358c
  8003a4:	e8 89 02 00 00       	call   800632 <cprintf>
  8003a9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003ac:	a1 00 40 80 00       	mov    0x804000,%eax
  8003b1:	ff 75 0c             	pushl  0xc(%ebp)
  8003b4:	ff 75 08             	pushl  0x8(%ebp)
  8003b7:	50                   	push   %eax
  8003b8:	68 91 35 80 00       	push   $0x803591
  8003bd:	e8 70 02 00 00       	call   800632 <cprintf>
  8003c2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8003c8:	83 ec 08             	sub    $0x8,%esp
  8003cb:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ce:	50                   	push   %eax
  8003cf:	e8 f3 01 00 00       	call   8005c7 <vcprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	6a 00                	push   $0x0
  8003dc:	68 ad 35 80 00       	push   $0x8035ad
  8003e1:	e8 e1 01 00 00       	call   8005c7 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003e9:	e8 82 ff ff ff       	call   800370 <exit>

	// should not return here
	while (1) ;
  8003ee:	eb fe                	jmp    8003ee <_panic+0x70>

008003f0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
  8003f3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003fb:	8b 50 74             	mov    0x74(%eax),%edx
  8003fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800401:	39 c2                	cmp    %eax,%edx
  800403:	74 14                	je     800419 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800405:	83 ec 04             	sub    $0x4,%esp
  800408:	68 b0 35 80 00       	push   $0x8035b0
  80040d:	6a 26                	push   $0x26
  80040f:	68 fc 35 80 00       	push   $0x8035fc
  800414:	e8 65 ff ff ff       	call   80037e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800419:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800420:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800427:	e9 c2 00 00 00       	jmp    8004ee <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80042f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800436:	8b 45 08             	mov    0x8(%ebp),%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	85 c0                	test   %eax,%eax
  80043f:	75 08                	jne    800449 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800441:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800444:	e9 a2 00 00 00       	jmp    8004eb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800449:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800450:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800457:	eb 69                	jmp    8004c2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800464:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800467:	89 d0                	mov    %edx,%eax
  800469:	01 c0                	add    %eax,%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	c1 e0 03             	shl    $0x3,%eax
  800470:	01 c8                	add    %ecx,%eax
  800472:	8a 40 04             	mov    0x4(%eax),%al
  800475:	84 c0                	test   %al,%al
  800477:	75 46                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800484:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800487:	89 d0                	mov    %edx,%eax
  800489:	01 c0                	add    %eax,%eax
  80048b:	01 d0                	add    %edx,%eax
  80048d:	c1 e0 03             	shl    $0x3,%eax
  800490:	01 c8                	add    %ecx,%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800497:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80049a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80049f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ae:	01 c8                	add    %ecx,%eax
  8004b0:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004b2:	39 c2                	cmp    %eax,%edx
  8004b4:	75 09                	jne    8004bf <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004b6:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004bd:	eb 12                	jmp    8004d1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bf:	ff 45 e8             	incl   -0x18(%ebp)
  8004c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c7:	8b 50 74             	mov    0x74(%eax),%edx
  8004ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004cd:	39 c2                	cmp    %eax,%edx
  8004cf:	77 88                	ja     800459 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004d5:	75 14                	jne    8004eb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004d7:	83 ec 04             	sub    $0x4,%esp
  8004da:	68 08 36 80 00       	push   $0x803608
  8004df:	6a 3a                	push   $0x3a
  8004e1:	68 fc 35 80 00       	push   $0x8035fc
  8004e6:	e8 93 fe ff ff       	call   80037e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004eb:	ff 45 f0             	incl   -0x10(%ebp)
  8004ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004f4:	0f 8c 32 ff ff ff    	jl     80042c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800501:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800508:	eb 26                	jmp    800530 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80050a:	a1 20 40 80 00       	mov    0x804020,%eax
  80050f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800515:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 03             	shl    $0x3,%eax
  800521:	01 c8                	add    %ecx,%eax
  800523:	8a 40 04             	mov    0x4(%eax),%al
  800526:	3c 01                	cmp    $0x1,%al
  800528:	75 03                	jne    80052d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80052a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052d:	ff 45 e0             	incl   -0x20(%ebp)
  800530:	a1 20 40 80 00       	mov    0x804020,%eax
  800535:	8b 50 74             	mov    0x74(%eax),%edx
  800538:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80053b:	39 c2                	cmp    %eax,%edx
  80053d:	77 cb                	ja     80050a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80053f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800542:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800545:	74 14                	je     80055b <CheckWSWithoutLastIndex+0x16b>
		panic(
  800547:	83 ec 04             	sub    $0x4,%esp
  80054a:	68 5c 36 80 00       	push   $0x80365c
  80054f:	6a 44                	push   $0x44
  800551:	68 fc 35 80 00       	push   $0x8035fc
  800556:	e8 23 fe ff ff       	call   80037e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800564:	8b 45 0c             	mov    0xc(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	8d 48 01             	lea    0x1(%eax),%ecx
  80056c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80056f:	89 0a                	mov    %ecx,(%edx)
  800571:	8b 55 08             	mov    0x8(%ebp),%edx
  800574:	88 d1                	mov    %dl,%cl
  800576:	8b 55 0c             	mov    0xc(%ebp),%edx
  800579:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80057d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	3d ff 00 00 00       	cmp    $0xff,%eax
  800587:	75 2c                	jne    8005b5 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800589:	a0 24 40 80 00       	mov    0x804024,%al
  80058e:	0f b6 c0             	movzbl %al,%eax
  800591:	8b 55 0c             	mov    0xc(%ebp),%edx
  800594:	8b 12                	mov    (%edx),%edx
  800596:	89 d1                	mov    %edx,%ecx
  800598:	8b 55 0c             	mov    0xc(%ebp),%edx
  80059b:	83 c2 08             	add    $0x8,%edx
  80059e:	83 ec 04             	sub    $0x4,%esp
  8005a1:	50                   	push   %eax
  8005a2:	51                   	push   %ecx
  8005a3:	52                   	push   %edx
  8005a4:	e8 05 14 00 00       	call   8019ae <sys_cputs>
  8005a9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005b8:	8b 40 04             	mov    0x4(%eax),%eax
  8005bb:	8d 50 01             	lea    0x1(%eax),%edx
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005c4:	90                   	nop
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005d7:	00 00 00 
	b.cnt = 0;
  8005da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005e1:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f0:	50                   	push   %eax
  8005f1:	68 5e 05 80 00       	push   $0x80055e
  8005f6:	e8 11 02 00 00       	call   80080c <vprintfmt>
  8005fb:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005fe:	a0 24 40 80 00       	mov    0x804024,%al
  800603:	0f b6 c0             	movzbl %al,%eax
  800606:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	50                   	push   %eax
  800610:	52                   	push   %edx
  800611:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800617:	83 c0 08             	add    $0x8,%eax
  80061a:	50                   	push   %eax
  80061b:	e8 8e 13 00 00       	call   8019ae <sys_cputs>
  800620:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800623:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80062a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <cprintf>:

int cprintf(const char *fmt, ...) {
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800638:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80063f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800642:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800645:	8b 45 08             	mov    0x8(%ebp),%eax
  800648:	83 ec 08             	sub    $0x8,%esp
  80064b:	ff 75 f4             	pushl  -0xc(%ebp)
  80064e:	50                   	push   %eax
  80064f:	e8 73 ff ff ff       	call   8005c7 <vcprintf>
  800654:	83 c4 10             	add    $0x10,%esp
  800657:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80065a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80065d:	c9                   	leave  
  80065e:	c3                   	ret    

0080065f <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800665:	e8 f2 14 00 00       	call   801b5c <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80066a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80066d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	83 ec 08             	sub    $0x8,%esp
  800676:	ff 75 f4             	pushl  -0xc(%ebp)
  800679:	50                   	push   %eax
  80067a:	e8 48 ff ff ff       	call   8005c7 <vcprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
  800682:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800685:	e8 ec 14 00 00       	call   801b76 <sys_enable_interrupt>
	return cnt;
  80068a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	53                   	push   %ebx
  800693:	83 ec 14             	sub    $0x14,%esp
  800696:	8b 45 10             	mov    0x10(%ebp),%eax
  800699:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006a2:	8b 45 18             	mov    0x18(%ebp),%eax
  8006a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006aa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006ad:	77 55                	ja     800704 <printnum+0x75>
  8006af:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006b2:	72 05                	jb     8006b9 <printnum+0x2a>
  8006b4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006b7:	77 4b                	ja     800704 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006bc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006bf:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c7:	52                   	push   %edx
  8006c8:	50                   	push   %eax
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	ff 75 f0             	pushl  -0x10(%ebp)
  8006cf:	e8 64 2a 00 00       	call   803138 <__udivdi3>
  8006d4:	83 c4 10             	add    $0x10,%esp
  8006d7:	83 ec 04             	sub    $0x4,%esp
  8006da:	ff 75 20             	pushl  0x20(%ebp)
  8006dd:	53                   	push   %ebx
  8006de:	ff 75 18             	pushl  0x18(%ebp)
  8006e1:	52                   	push   %edx
  8006e2:	50                   	push   %eax
  8006e3:	ff 75 0c             	pushl  0xc(%ebp)
  8006e6:	ff 75 08             	pushl  0x8(%ebp)
  8006e9:	e8 a1 ff ff ff       	call   80068f <printnum>
  8006ee:	83 c4 20             	add    $0x20,%esp
  8006f1:	eb 1a                	jmp    80070d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006f3:	83 ec 08             	sub    $0x8,%esp
  8006f6:	ff 75 0c             	pushl  0xc(%ebp)
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ff:	ff d0                	call   *%eax
  800701:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800704:	ff 4d 1c             	decl   0x1c(%ebp)
  800707:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80070b:	7f e6                	jg     8006f3 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80070d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800710:	bb 00 00 00 00       	mov    $0x0,%ebx
  800715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800718:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80071b:	53                   	push   %ebx
  80071c:	51                   	push   %ecx
  80071d:	52                   	push   %edx
  80071e:	50                   	push   %eax
  80071f:	e8 24 2b 00 00       	call   803248 <__umoddi3>
  800724:	83 c4 10             	add    $0x10,%esp
  800727:	05 d4 38 80 00       	add    $0x8038d4,%eax
  80072c:	8a 00                	mov    (%eax),%al
  80072e:	0f be c0             	movsbl %al,%eax
  800731:	83 ec 08             	sub    $0x8,%esp
  800734:	ff 75 0c             	pushl  0xc(%ebp)
  800737:	50                   	push   %eax
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	ff d0                	call   *%eax
  80073d:	83 c4 10             	add    $0x10,%esp
}
  800740:	90                   	nop
  800741:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800744:	c9                   	leave  
  800745:	c3                   	ret    

00800746 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800746:	55                   	push   %ebp
  800747:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800749:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074d:	7e 1c                	jle    80076b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	8d 50 08             	lea    0x8(%eax),%edx
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	89 10                	mov    %edx,(%eax)
  80075c:	8b 45 08             	mov    0x8(%ebp),%eax
  80075f:	8b 00                	mov    (%eax),%eax
  800761:	83 e8 08             	sub    $0x8,%eax
  800764:	8b 50 04             	mov    0x4(%eax),%edx
  800767:	8b 00                	mov    (%eax),%eax
  800769:	eb 40                	jmp    8007ab <getuint+0x65>
	else if (lflag)
  80076b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076f:	74 1e                	je     80078f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800771:	8b 45 08             	mov    0x8(%ebp),%eax
  800774:	8b 00                	mov    (%eax),%eax
  800776:	8d 50 04             	lea    0x4(%eax),%edx
  800779:	8b 45 08             	mov    0x8(%ebp),%eax
  80077c:	89 10                	mov    %edx,(%eax)
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	8b 00                	mov    (%eax),%eax
  800783:	83 e8 04             	sub    $0x4,%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	eb 1c                	jmp    8007ab <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b4:	7e 1c                	jle    8007d2 <getint+0x25>
		return va_arg(*ap, long long);
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	8d 50 08             	lea    0x8(%eax),%edx
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	89 10                	mov    %edx,(%eax)
  8007c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	83 e8 08             	sub    $0x8,%eax
  8007cb:	8b 50 04             	mov    0x4(%eax),%edx
  8007ce:	8b 00                	mov    (%eax),%eax
  8007d0:	eb 38                	jmp    80080a <getint+0x5d>
	else if (lflag)
  8007d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007d6:	74 1a                	je     8007f2 <getint+0x45>
		return va_arg(*ap, long);
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	8d 50 04             	lea    0x4(%eax),%edx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	89 10                	mov    %edx,(%eax)
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	8b 00                	mov    (%eax),%eax
  8007ea:	83 e8 04             	sub    $0x4,%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	99                   	cltd   
  8007f0:	eb 18                	jmp    80080a <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	8d 50 04             	lea    0x4(%eax),%edx
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	89 10                	mov    %edx,(%eax)
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	83 e8 04             	sub    $0x4,%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	99                   	cltd   
}
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	56                   	push   %esi
  800810:	53                   	push   %ebx
  800811:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800814:	eb 17                	jmp    80082d <vprintfmt+0x21>
			if (ch == '\0')
  800816:	85 db                	test   %ebx,%ebx
  800818:	0f 84 af 03 00 00    	je     800bcd <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	53                   	push   %ebx
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80082d:	8b 45 10             	mov    0x10(%ebp),%eax
  800830:	8d 50 01             	lea    0x1(%eax),%edx
  800833:	89 55 10             	mov    %edx,0x10(%ebp)
  800836:	8a 00                	mov    (%eax),%al
  800838:	0f b6 d8             	movzbl %al,%ebx
  80083b:	83 fb 25             	cmp    $0x25,%ebx
  80083e:	75 d6                	jne    800816 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800840:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800844:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80084b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800852:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800859:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800860:	8b 45 10             	mov    0x10(%ebp),%eax
  800863:	8d 50 01             	lea    0x1(%eax),%edx
  800866:	89 55 10             	mov    %edx,0x10(%ebp)
  800869:	8a 00                	mov    (%eax),%al
  80086b:	0f b6 d8             	movzbl %al,%ebx
  80086e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800871:	83 f8 55             	cmp    $0x55,%eax
  800874:	0f 87 2b 03 00 00    	ja     800ba5 <vprintfmt+0x399>
  80087a:	8b 04 85 f8 38 80 00 	mov    0x8038f8(,%eax,4),%eax
  800881:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800883:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800887:	eb d7                	jmp    800860 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800889:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80088d:	eb d1                	jmp    800860 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80088f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800896:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800899:	89 d0                	mov    %edx,%eax
  80089b:	c1 e0 02             	shl    $0x2,%eax
  80089e:	01 d0                	add    %edx,%eax
  8008a0:	01 c0                	add    %eax,%eax
  8008a2:	01 d8                	add    %ebx,%eax
  8008a4:	83 e8 30             	sub    $0x30,%eax
  8008a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ad:	8a 00                	mov    (%eax),%al
  8008af:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008b2:	83 fb 2f             	cmp    $0x2f,%ebx
  8008b5:	7e 3e                	jle    8008f5 <vprintfmt+0xe9>
  8008b7:	83 fb 39             	cmp    $0x39,%ebx
  8008ba:	7f 39                	jg     8008f5 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008bc:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008bf:	eb d5                	jmp    800896 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c4:	83 c0 04             	add    $0x4,%eax
  8008c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cd:	83 e8 04             	sub    $0x4,%eax
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008d5:	eb 1f                	jmp    8008f6 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	79 83                	jns    800860 <vprintfmt+0x54>
				width = 0;
  8008dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008e4:	e9 77 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008e9:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008f0:	e9 6b ff ff ff       	jmp    800860 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008f5:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	0f 89 60 ff ff ff    	jns    800860 <vprintfmt+0x54>
				width = precision, precision = -1;
  800900:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800903:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800906:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80090d:	e9 4e ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800912:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800915:	e9 46 ff ff ff       	jmp    800860 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80091a:	8b 45 14             	mov    0x14(%ebp),%eax
  80091d:	83 c0 04             	add    $0x4,%eax
  800920:	89 45 14             	mov    %eax,0x14(%ebp)
  800923:	8b 45 14             	mov    0x14(%ebp),%eax
  800926:	83 e8 04             	sub    $0x4,%eax
  800929:	8b 00                	mov    (%eax),%eax
  80092b:	83 ec 08             	sub    $0x8,%esp
  80092e:	ff 75 0c             	pushl  0xc(%ebp)
  800931:	50                   	push   %eax
  800932:	8b 45 08             	mov    0x8(%ebp),%eax
  800935:	ff d0                	call   *%eax
  800937:	83 c4 10             	add    $0x10,%esp
			break;
  80093a:	e9 89 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800950:	85 db                	test   %ebx,%ebx
  800952:	79 02                	jns    800956 <vprintfmt+0x14a>
				err = -err;
  800954:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800956:	83 fb 64             	cmp    $0x64,%ebx
  800959:	7f 0b                	jg     800966 <vprintfmt+0x15a>
  80095b:	8b 34 9d 40 37 80 00 	mov    0x803740(,%ebx,4),%esi
  800962:	85 f6                	test   %esi,%esi
  800964:	75 19                	jne    80097f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800966:	53                   	push   %ebx
  800967:	68 e5 38 80 00       	push   $0x8038e5
  80096c:	ff 75 0c             	pushl  0xc(%ebp)
  80096f:	ff 75 08             	pushl  0x8(%ebp)
  800972:	e8 5e 02 00 00       	call   800bd5 <printfmt>
  800977:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80097a:	e9 49 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80097f:	56                   	push   %esi
  800980:	68 ee 38 80 00       	push   $0x8038ee
  800985:	ff 75 0c             	pushl  0xc(%ebp)
  800988:	ff 75 08             	pushl  0x8(%ebp)
  80098b:	e8 45 02 00 00       	call   800bd5 <printfmt>
  800990:	83 c4 10             	add    $0x10,%esp
			break;
  800993:	e9 30 02 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 30                	mov    (%eax),%esi
  8009a9:	85 f6                	test   %esi,%esi
  8009ab:	75 05                	jne    8009b2 <vprintfmt+0x1a6>
				p = "(null)";
  8009ad:	be f1 38 80 00       	mov    $0x8038f1,%esi
			if (width > 0 && padc != '-')
  8009b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009b6:	7e 6d                	jle    800a25 <vprintfmt+0x219>
  8009b8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009bc:	74 67                	je     800a25 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009c1:	83 ec 08             	sub    $0x8,%esp
  8009c4:	50                   	push   %eax
  8009c5:	56                   	push   %esi
  8009c6:	e8 0c 03 00 00       	call   800cd7 <strnlen>
  8009cb:	83 c4 10             	add    $0x10,%esp
  8009ce:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009d1:	eb 16                	jmp    8009e9 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009d3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	50                   	push   %eax
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	ff d0                	call   *%eax
  8009e3:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009e6:	ff 4d e4             	decl   -0x1c(%ebp)
  8009e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ed:	7f e4                	jg     8009d3 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ef:	eb 34                	jmp    800a25 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009f1:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009f5:	74 1c                	je     800a13 <vprintfmt+0x207>
  8009f7:	83 fb 1f             	cmp    $0x1f,%ebx
  8009fa:	7e 05                	jle    800a01 <vprintfmt+0x1f5>
  8009fc:	83 fb 7e             	cmp    $0x7e,%ebx
  8009ff:	7e 12                	jle    800a13 <vprintfmt+0x207>
					putch('?', putdat);
  800a01:	83 ec 08             	sub    $0x8,%esp
  800a04:	ff 75 0c             	pushl  0xc(%ebp)
  800a07:	6a 3f                	push   $0x3f
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	ff d0                	call   *%eax
  800a0e:	83 c4 10             	add    $0x10,%esp
  800a11:	eb 0f                	jmp    800a22 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	53                   	push   %ebx
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	ff d0                	call   *%eax
  800a1f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a22:	ff 4d e4             	decl   -0x1c(%ebp)
  800a25:	89 f0                	mov    %esi,%eax
  800a27:	8d 70 01             	lea    0x1(%eax),%esi
  800a2a:	8a 00                	mov    (%eax),%al
  800a2c:	0f be d8             	movsbl %al,%ebx
  800a2f:	85 db                	test   %ebx,%ebx
  800a31:	74 24                	je     800a57 <vprintfmt+0x24b>
  800a33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a37:	78 b8                	js     8009f1 <vprintfmt+0x1e5>
  800a39:	ff 4d e0             	decl   -0x20(%ebp)
  800a3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a40:	79 af                	jns    8009f1 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a42:	eb 13                	jmp    800a57 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 20                	push   $0x20
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	ff 4d e4             	decl   -0x1c(%ebp)
  800a57:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a5b:	7f e7                	jg     800a44 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a5d:	e9 66 01 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 3c fd ff ff       	call   8007ad <getint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a80:	85 d2                	test   %edx,%edx
  800a82:	79 23                	jns    800aa7 <vprintfmt+0x29b>
				putch('-', putdat);
  800a84:	83 ec 08             	sub    $0x8,%esp
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	6a 2d                	push   $0x2d
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	ff d0                	call   *%eax
  800a91:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9a:	f7 d8                	neg    %eax
  800a9c:	83 d2 00             	adc    $0x0,%edx
  800a9f:	f7 da                	neg    %edx
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800aa7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800aae:	e9 bc 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 e8             	pushl  -0x18(%ebp)
  800ab9:	8d 45 14             	lea    0x14(%ebp),%eax
  800abc:	50                   	push   %eax
  800abd:	e8 84 fc ff ff       	call   800746 <getuint>
  800ac2:	83 c4 10             	add    $0x10,%esp
  800ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800acb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ad2:	e9 98 00 00 00       	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	6a 58                	push   $0x58
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	ff d0                	call   *%eax
  800b04:	83 c4 10             	add    $0x10,%esp
			break;
  800b07:	e9 bc 00 00 00       	jmp    800bc8 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	6a 30                	push   $0x30
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	ff d0                	call   *%eax
  800b19:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 78                	push   $0x78
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b2c:	8b 45 14             	mov    0x14(%ebp),%eax
  800b2f:	83 c0 04             	add    $0x4,%eax
  800b32:	89 45 14             	mov    %eax,0x14(%ebp)
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	83 e8 04             	sub    $0x4,%eax
  800b3b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b47:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b4e:	eb 1f                	jmp    800b6f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b50:	83 ec 08             	sub    $0x8,%esp
  800b53:	ff 75 e8             	pushl  -0x18(%ebp)
  800b56:	8d 45 14             	lea    0x14(%ebp),%eax
  800b59:	50                   	push   %eax
  800b5a:	e8 e7 fb ff ff       	call   800746 <getuint>
  800b5f:	83 c4 10             	add    $0x10,%esp
  800b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b65:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b68:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b6f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b76:	83 ec 04             	sub    $0x4,%esp
  800b79:	52                   	push   %edx
  800b7a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b7d:	50                   	push   %eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	ff 75 f0             	pushl  -0x10(%ebp)
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	ff 75 08             	pushl  0x8(%ebp)
  800b8a:	e8 00 fb ff ff       	call   80068f <printnum>
  800b8f:	83 c4 20             	add    $0x20,%esp
			break;
  800b92:	eb 34                	jmp    800bc8 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b94:	83 ec 08             	sub    $0x8,%esp
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	53                   	push   %ebx
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	ff d0                	call   *%eax
  800ba0:	83 c4 10             	add    $0x10,%esp
			break;
  800ba3:	eb 23                	jmp    800bc8 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ba5:	83 ec 08             	sub    $0x8,%esp
  800ba8:	ff 75 0c             	pushl  0xc(%ebp)
  800bab:	6a 25                	push   $0x25
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bb5:	ff 4d 10             	decl   0x10(%ebp)
  800bb8:	eb 03                	jmp    800bbd <vprintfmt+0x3b1>
  800bba:	ff 4d 10             	decl   0x10(%ebp)
  800bbd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc0:	48                   	dec    %eax
  800bc1:	8a 00                	mov    (%eax),%al
  800bc3:	3c 25                	cmp    $0x25,%al
  800bc5:	75 f3                	jne    800bba <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bc7:	90                   	nop
		}
	}
  800bc8:	e9 47 fc ff ff       	jmp    800814 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bcd:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bdb:	8d 45 10             	lea    0x10(%ebp),%eax
  800bde:	83 c0 04             	add    $0x4,%eax
  800be1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800be4:	8b 45 10             	mov    0x10(%ebp),%eax
  800be7:	ff 75 f4             	pushl  -0xc(%ebp)
  800bea:	50                   	push   %eax
  800beb:	ff 75 0c             	pushl  0xc(%ebp)
  800bee:	ff 75 08             	pushl  0x8(%ebp)
  800bf1:	e8 16 fc ff ff       	call   80080c <vprintfmt>
  800bf6:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bf9:	90                   	nop
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 08             	mov    0x8(%eax),%eax
  800c05:	8d 50 01             	lea    0x1(%eax),%edx
  800c08:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	8b 10                	mov    (%eax),%edx
  800c13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c16:	8b 40 04             	mov    0x4(%eax),%eax
  800c19:	39 c2                	cmp    %eax,%edx
  800c1b:	73 12                	jae    800c2f <sprintputch+0x33>
		*b->buf++ = ch;
  800c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c20:	8b 00                	mov    (%eax),%eax
  800c22:	8d 48 01             	lea    0x1(%eax),%ecx
  800c25:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c28:	89 0a                	mov    %ecx,(%edx)
  800c2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2d:	88 10                	mov    %dl,(%eax)
}
  800c2f:	90                   	nop
  800c30:	5d                   	pop    %ebp
  800c31:	c3                   	ret    

00800c32 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	01 d0                	add    %edx,%eax
  800c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c4c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c57:	74 06                	je     800c5f <vsnprintf+0x2d>
  800c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5d:	7f 07                	jg     800c66 <vsnprintf+0x34>
		return -E_INVAL;
  800c5f:	b8 03 00 00 00       	mov    $0x3,%eax
  800c64:	eb 20                	jmp    800c86 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c66:	ff 75 14             	pushl  0x14(%ebp)
  800c69:	ff 75 10             	pushl  0x10(%ebp)
  800c6c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c6f:	50                   	push   %eax
  800c70:	68 fc 0b 80 00       	push   $0x800bfc
  800c75:	e8 92 fb ff ff       	call   80080c <vprintfmt>
  800c7a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c80:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c86:	c9                   	leave  
  800c87:	c3                   	ret    

00800c88 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c8e:	8d 45 10             	lea    0x10(%ebp),%eax
  800c91:	83 c0 04             	add    $0x4,%eax
  800c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c97:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	e8 89 ff ff ff       	call   800c32 <vsnprintf>
  800ca9:	83 c4 10             	add    $0x10,%esp
  800cac:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cc1:	eb 06                	jmp    800cc9 <strlen+0x15>
		n++;
  800cc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccc:	8a 00                	mov    (%eax),%al
  800cce:	84 c0                	test   %al,%al
  800cd0:	75 f1                	jne    800cc3 <strlen+0xf>
		n++;
	return n;
  800cd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd5:	c9                   	leave  
  800cd6:	c3                   	ret    

00800cd7 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce4:	eb 09                	jmp    800cef <strnlen+0x18>
		n++;
  800ce6:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ce9:	ff 45 08             	incl   0x8(%ebp)
  800cec:	ff 4d 0c             	decl   0xc(%ebp)
  800cef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf3:	74 09                	je     800cfe <strnlen+0x27>
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 e8                	jne    800ce6 <strnlen+0xf>
		n++;
	return n;
  800cfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d01:	c9                   	leave  
  800d02:	c3                   	ret    

00800d03 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d0f:	90                   	nop
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8d 50 01             	lea    0x1(%eax),%edx
  800d16:	89 55 08             	mov    %edx,0x8(%ebp)
  800d19:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d1c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d22:	8a 12                	mov    (%edx),%dl
  800d24:	88 10                	mov    %dl,(%eax)
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	84 c0                	test   %al,%al
  800d2a:	75 e4                	jne    800d10 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d37:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d3d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d44:	eb 1f                	jmp    800d65 <strncpy+0x34>
		*dst++ = *src;
  800d46:	8b 45 08             	mov    0x8(%ebp),%eax
  800d49:	8d 50 01             	lea    0x1(%eax),%edx
  800d4c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d52:	8a 12                	mov    (%edx),%dl
  800d54:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d59:	8a 00                	mov    (%eax),%al
  800d5b:	84 c0                	test   %al,%al
  800d5d:	74 03                	je     800d62 <strncpy+0x31>
			src++;
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d62:	ff 45 fc             	incl   -0x4(%ebp)
  800d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d68:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d6b:	72 d9                	jb     800d46 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d70:	c9                   	leave  
  800d71:	c3                   	ret    

00800d72 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d72:	55                   	push   %ebp
  800d73:	89 e5                	mov    %esp,%ebp
  800d75:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d7e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d82:	74 30                	je     800db4 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d84:	eb 16                	jmp    800d9c <strlcpy+0x2a>
			*dst++ = *src++;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d9c:	ff 4d 10             	decl   0x10(%ebp)
  800d9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da3:	74 09                	je     800dae <strlcpy+0x3c>
  800da5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 d8                	jne    800d86 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	29 c2                	sub    %eax,%edx
  800dbc:	89 d0                	mov    %edx,%eax
}
  800dbe:	c9                   	leave  
  800dbf:	c3                   	ret    

00800dc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dc3:	eb 06                	jmp    800dcb <strcmp+0xb>
		p++, q++;
  800dc5:	ff 45 08             	incl   0x8(%ebp)
  800dc8:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	84 c0                	test   %al,%al
  800dd2:	74 0e                	je     800de2 <strcmp+0x22>
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 10                	mov    (%eax),%dl
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	8a 00                	mov    (%eax),%al
  800dde:	38 c2                	cmp    %al,%dl
  800de0:	74 e3                	je     800dc5 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	8a 00                	mov    (%eax),%al
  800de7:	0f b6 d0             	movzbl %al,%edx
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	0f b6 c0             	movzbl %al,%eax
  800df2:	29 c2                	sub    %eax,%edx
  800df4:	89 d0                	mov    %edx,%eax
}
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800dfb:	eb 09                	jmp    800e06 <strncmp+0xe>
		n--, p++, q++;
  800dfd:	ff 4d 10             	decl   0x10(%ebp)
  800e00:	ff 45 08             	incl   0x8(%ebp)
  800e03:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e06:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0a:	74 17                	je     800e23 <strncmp+0x2b>
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0f:	8a 00                	mov    (%eax),%al
  800e11:	84 c0                	test   %al,%al
  800e13:	74 0e                	je     800e23 <strncmp+0x2b>
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	8a 10                	mov    (%eax),%dl
  800e1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1d:	8a 00                	mov    (%eax),%al
  800e1f:	38 c2                	cmp    %al,%dl
  800e21:	74 da                	je     800dfd <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e27:	75 07                	jne    800e30 <strncmp+0x38>
		return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2e:	eb 14                	jmp    800e44 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	8a 00                	mov    (%eax),%al
  800e35:	0f b6 d0             	movzbl %al,%edx
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	8a 00                	mov    (%eax),%al
  800e3d:	0f b6 c0             	movzbl %al,%eax
  800e40:	29 c2                	sub    %eax,%edx
  800e42:	89 d0                	mov    %edx,%eax
}
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e52:	eb 12                	jmp    800e66 <strchr+0x20>
		if (*s == c)
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e5c:	75 05                	jne    800e63 <strchr+0x1d>
			return (char *) s;
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	eb 11                	jmp    800e74 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e63:	ff 45 08             	incl   0x8(%ebp)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	84 c0                	test   %al,%al
  800e6d:	75 e5                	jne    800e54 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e74:	c9                   	leave  
  800e75:	c3                   	ret    

00800e76 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	83 ec 04             	sub    $0x4,%esp
  800e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e82:	eb 0d                	jmp    800e91 <strfind+0x1b>
		if (*s == c)
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	8a 00                	mov    (%eax),%al
  800e89:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e8c:	74 0e                	je     800e9c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e8e:	ff 45 08             	incl   0x8(%ebp)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	84 c0                	test   %al,%al
  800e98:	75 ea                	jne    800e84 <strfind+0xe>
  800e9a:	eb 01                	jmp    800e9d <strfind+0x27>
		if (*s == c)
			break;
  800e9c:	90                   	nop
	return (char *) s;
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea0:	c9                   	leave  
  800ea1:	c3                   	ret    

00800ea2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ea2:	55                   	push   %ebp
  800ea3:	89 e5                	mov    %esp,%ebp
  800ea5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800eae:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800eb4:	eb 0e                	jmp    800ec4 <memset+0x22>
		*p++ = c;
  800eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb9:	8d 50 01             	lea    0x1(%eax),%edx
  800ebc:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec2:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ec4:	ff 4d f8             	decl   -0x8(%ebp)
  800ec7:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ecb:	79 e9                	jns    800eb6 <memset+0x14>
		*p++ = c;

	return v;
  800ecd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed0:	c9                   	leave  
  800ed1:	c3                   	ret    

00800ed2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ed2:	55                   	push   %ebp
  800ed3:	89 e5                	mov    %esp,%ebp
  800ed5:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ed8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ee4:	eb 16                	jmp    800efc <memcpy+0x2a>
		*d++ = *s++;
  800ee6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ef2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ef5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ef8:	8a 12                	mov    (%edx),%dl
  800efa:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800efc:	8b 45 10             	mov    0x10(%ebp),%eax
  800eff:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f02:	89 55 10             	mov    %edx,0x10(%ebp)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	75 dd                	jne    800ee6 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0c:	c9                   	leave  
  800f0d:	c3                   	ret    

00800f0e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f0e:	55                   	push   %ebp
  800f0f:	89 e5                	mov    %esp,%ebp
  800f11:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f17:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f20:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f26:	73 50                	jae    800f78 <memmove+0x6a>
  800f28:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f2b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2e:	01 d0                	add    %edx,%eax
  800f30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f33:	76 43                	jbe    800f78 <memmove+0x6a>
		s += n;
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f41:	eb 10                	jmp    800f53 <memmove+0x45>
			*--d = *--s;
  800f43:	ff 4d f8             	decl   -0x8(%ebp)
  800f46:	ff 4d fc             	decl   -0x4(%ebp)
  800f49:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f4c:	8a 10                	mov    (%eax),%dl
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f53:	8b 45 10             	mov    0x10(%ebp),%eax
  800f56:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f59:	89 55 10             	mov    %edx,0x10(%ebp)
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	75 e3                	jne    800f43 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f60:	eb 23                	jmp    800f85 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f65:	8d 50 01             	lea    0x1(%eax),%edx
  800f68:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f6e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f71:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f74:	8a 12                	mov    (%edx),%dl
  800f76:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f78:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f7e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f81:	85 c0                	test   %eax,%eax
  800f83:	75 dd                	jne    800f62 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    

00800f8a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f99:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f9c:	eb 2a                	jmp    800fc8 <memcmp+0x3e>
		if (*s1 != *s2)
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	8a 10                	mov    (%eax),%dl
  800fa3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	38 c2                	cmp    %al,%dl
  800faa:	74 16                	je     800fc2 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	0f b6 d0             	movzbl %al,%edx
  800fb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb7:	8a 00                	mov    (%eax),%al
  800fb9:	0f b6 c0             	movzbl %al,%eax
  800fbc:	29 c2                	sub    %eax,%edx
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	eb 18                	jmp    800fda <memcmp+0x50>
		s1++, s2++;
  800fc2:	ff 45 fc             	incl   -0x4(%ebp)
  800fc5:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fc8:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fce:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	75 c9                	jne    800f9e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fda:	c9                   	leave  
  800fdb:	c3                   	ret    

00800fdc <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fdc:	55                   	push   %ebp
  800fdd:	89 e5                	mov    %esp,%ebp
  800fdf:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe8:	01 d0                	add    %edx,%eax
  800fea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fed:	eb 15                	jmp    801004 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff2:	8a 00                	mov    (%eax),%al
  800ff4:	0f b6 d0             	movzbl %al,%edx
  800ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ffa:	0f b6 c0             	movzbl %al,%eax
  800ffd:	39 c2                	cmp    %eax,%edx
  800fff:	74 0d                	je     80100e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801001:	ff 45 08             	incl   0x8(%ebp)
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80100a:	72 e3                	jb     800fef <memfind+0x13>
  80100c:	eb 01                	jmp    80100f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80100e:	90                   	nop
	return (void *) s;
  80100f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80101a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801021:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801028:	eb 03                	jmp    80102d <strtol+0x19>
		s++;
  80102a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 20                	cmp    $0x20,%al
  801034:	74 f4                	je     80102a <strtol+0x16>
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	8a 00                	mov    (%eax),%al
  80103b:	3c 09                	cmp    $0x9,%al
  80103d:	74 eb                	je     80102a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 2b                	cmp    $0x2b,%al
  801046:	75 05                	jne    80104d <strtol+0x39>
		s++;
  801048:	ff 45 08             	incl   0x8(%ebp)
  80104b:	eb 13                	jmp    801060 <strtol+0x4c>
	else if (*s == '-')
  80104d:	8b 45 08             	mov    0x8(%ebp),%eax
  801050:	8a 00                	mov    (%eax),%al
  801052:	3c 2d                	cmp    $0x2d,%al
  801054:	75 0a                	jne    801060 <strtol+0x4c>
		s++, neg = 1;
  801056:	ff 45 08             	incl   0x8(%ebp)
  801059:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801060:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801064:	74 06                	je     80106c <strtol+0x58>
  801066:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80106a:	75 20                	jne    80108c <strtol+0x78>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 30                	cmp    $0x30,%al
  801073:	75 17                	jne    80108c <strtol+0x78>
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	40                   	inc    %eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 78                	cmp    $0x78,%al
  80107d:	75 0d                	jne    80108c <strtol+0x78>
		s += 2, base = 16;
  80107f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801083:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80108a:	eb 28                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80108c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801090:	75 15                	jne    8010a7 <strtol+0x93>
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
  801095:	8a 00                	mov    (%eax),%al
  801097:	3c 30                	cmp    $0x30,%al
  801099:	75 0c                	jne    8010a7 <strtol+0x93>
		s++, base = 8;
  80109b:	ff 45 08             	incl   0x8(%ebp)
  80109e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010a5:	eb 0d                	jmp    8010b4 <strtol+0xa0>
	else if (base == 0)
  8010a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ab:	75 07                	jne    8010b4 <strtol+0xa0>
		base = 10;
  8010ad:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 2f                	cmp    $0x2f,%al
  8010bb:	7e 19                	jle    8010d6 <strtol+0xc2>
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 39                	cmp    $0x39,%al
  8010c4:	7f 10                	jg     8010d6 <strtol+0xc2>
			dig = *s - '0';
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	0f be c0             	movsbl %al,%eax
  8010ce:	83 e8 30             	sub    $0x30,%eax
  8010d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010d4:	eb 42                	jmp    801118 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	8a 00                	mov    (%eax),%al
  8010db:	3c 60                	cmp    $0x60,%al
  8010dd:	7e 19                	jle    8010f8 <strtol+0xe4>
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	8a 00                	mov    (%eax),%al
  8010e4:	3c 7a                	cmp    $0x7a,%al
  8010e6:	7f 10                	jg     8010f8 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	0f be c0             	movsbl %al,%eax
  8010f0:	83 e8 57             	sub    $0x57,%eax
  8010f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f6:	eb 20                	jmp    801118 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	8a 00                	mov    (%eax),%al
  8010fd:	3c 40                	cmp    $0x40,%al
  8010ff:	7e 39                	jle    80113a <strtol+0x126>
  801101:	8b 45 08             	mov    0x8(%ebp),%eax
  801104:	8a 00                	mov    (%eax),%al
  801106:	3c 5a                	cmp    $0x5a,%al
  801108:	7f 30                	jg     80113a <strtol+0x126>
			dig = *s - 'A' + 10;
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f be c0             	movsbl %al,%eax
  801112:	83 e8 37             	sub    $0x37,%eax
  801115:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80111e:	7d 19                	jge    801139 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801120:	ff 45 08             	incl   0x8(%ebp)
  801123:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801126:	0f af 45 10          	imul   0x10(%ebp),%eax
  80112a:	89 c2                	mov    %eax,%edx
  80112c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801134:	e9 7b ff ff ff       	jmp    8010b4 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801139:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80113a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80113e:	74 08                	je     801148 <strtol+0x134>
		*endptr = (char *) s;
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	8b 55 08             	mov    0x8(%ebp),%edx
  801146:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801148:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114c:	74 07                	je     801155 <strtol+0x141>
  80114e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801151:	f7 d8                	neg    %eax
  801153:	eb 03                	jmp    801158 <strtol+0x144>
  801155:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <ltostr>:

void
ltostr(long value, char *str)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801160:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801167:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80116e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801172:	79 13                	jns    801187 <ltostr+0x2d>
	{
		neg = 1;
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80117b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801181:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801184:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80118f:	99                   	cltd   
  801190:	f7 f9                	idiv   %ecx
  801192:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801195:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801198:	8d 50 01             	lea    0x1(%eax),%edx
  80119b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119e:	89 c2                	mov    %eax,%edx
  8011a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a3:	01 d0                	add    %edx,%eax
  8011a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011a8:	83 c2 30             	add    $0x30,%edx
  8011ab:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b0:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011b5:	f7 e9                	imul   %ecx
  8011b7:	c1 fa 02             	sar    $0x2,%edx
  8011ba:	89 c8                	mov    %ecx,%eax
  8011bc:	c1 f8 1f             	sar    $0x1f,%eax
  8011bf:	29 c2                	sub    %eax,%edx
  8011c1:	89 d0                	mov    %edx,%eax
  8011c3:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ce:	f7 e9                	imul   %ecx
  8011d0:	c1 fa 02             	sar    $0x2,%edx
  8011d3:	89 c8                	mov    %ecx,%eax
  8011d5:	c1 f8 1f             	sar    $0x1f,%eax
  8011d8:	29 c2                	sub    %eax,%edx
  8011da:	89 d0                	mov    %edx,%eax
  8011dc:	c1 e0 02             	shl    $0x2,%eax
  8011df:	01 d0                	add    %edx,%eax
  8011e1:	01 c0                	add    %eax,%eax
  8011e3:	29 c1                	sub    %eax,%ecx
  8011e5:	89 ca                	mov    %ecx,%edx
  8011e7:	85 d2                	test   %edx,%edx
  8011e9:	75 9c                	jne    801187 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011f5:	48                   	dec    %eax
  8011f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011f9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011fd:	74 3d                	je     80123c <ltostr+0xe2>
		start = 1 ;
  8011ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801206:	eb 34                	jmp    80123c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	01 d0                	add    %edx,%eax
  801210:	8a 00                	mov    (%eax),%al
  801212:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	01 c8                	add    %ecx,%eax
  801225:	8a 00                	mov    (%eax),%al
  801227:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801229:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	01 c2                	add    %eax,%edx
  801231:	8a 45 eb             	mov    -0x15(%ebp),%al
  801234:	88 02                	mov    %al,(%edx)
		start++ ;
  801236:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801239:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80123c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80123f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801242:	7c c4                	jl     801208 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801244:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80124f:	90                   	nop
  801250:	c9                   	leave  
  801251:	c3                   	ret    

00801252 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801252:	55                   	push   %ebp
  801253:	89 e5                	mov    %esp,%ebp
  801255:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801258:	ff 75 08             	pushl  0x8(%ebp)
  80125b:	e8 54 fa ff ff       	call   800cb4 <strlen>
  801260:	83 c4 04             	add    $0x4,%esp
  801263:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 46 fa ff ff       	call   800cb4 <strlen>
  80126e:	83 c4 04             	add    $0x4,%esp
  801271:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801274:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801282:	eb 17                	jmp    80129b <strcconcat+0x49>
		final[s] = str1[s] ;
  801284:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 c2                	add    %eax,%edx
  80128c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80128f:	8b 45 08             	mov    0x8(%ebp),%eax
  801292:	01 c8                	add    %ecx,%eax
  801294:	8a 00                	mov    (%eax),%al
  801296:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801298:	ff 45 fc             	incl   -0x4(%ebp)
  80129b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012a1:	7c e1                	jl     801284 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012b1:	eb 1f                	jmp    8012d2 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012bc:	89 c2                	mov    %eax,%edx
  8012be:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c1:	01 c2                	add    %eax,%edx
  8012c3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c9:	01 c8                	add    %ecx,%eax
  8012cb:	8a 00                	mov    (%eax),%al
  8012cd:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012cf:	ff 45 f8             	incl   -0x8(%ebp)
  8012d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012d8:	7c d9                	jl     8012b3 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 d0                	add    %edx,%eax
  8012e2:	c6 00 00             	movb   $0x0,(%eax)
}
  8012e5:	90                   	nop
  8012e6:	c9                   	leave  
  8012e7:	c3                   	ret    

008012e8 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f7:	8b 00                	mov    (%eax),%eax
  8012f9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801300:	8b 45 10             	mov    0x10(%ebp),%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80130b:	eb 0c                	jmp    801319 <strsplit+0x31>
			*string++ = 0;
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	8d 50 01             	lea    0x1(%eax),%edx
  801313:	89 55 08             	mov    %edx,0x8(%ebp)
  801316:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	84 c0                	test   %al,%al
  801320:	74 18                	je     80133a <strsplit+0x52>
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	8a 00                	mov    (%eax),%al
  801327:	0f be c0             	movsbl %al,%eax
  80132a:	50                   	push   %eax
  80132b:	ff 75 0c             	pushl  0xc(%ebp)
  80132e:	e8 13 fb ff ff       	call   800e46 <strchr>
  801333:	83 c4 08             	add    $0x8,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	75 d3                	jne    80130d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80133a:	8b 45 08             	mov    0x8(%ebp),%eax
  80133d:	8a 00                	mov    (%eax),%al
  80133f:	84 c0                	test   %al,%al
  801341:	74 5a                	je     80139d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801343:	8b 45 14             	mov    0x14(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	83 f8 0f             	cmp    $0xf,%eax
  80134b:	75 07                	jne    801354 <strsplit+0x6c>
		{
			return 0;
  80134d:	b8 00 00 00 00       	mov    $0x0,%eax
  801352:	eb 66                	jmp    8013ba <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801354:	8b 45 14             	mov    0x14(%ebp),%eax
  801357:	8b 00                	mov    (%eax),%eax
  801359:	8d 48 01             	lea    0x1(%eax),%ecx
  80135c:	8b 55 14             	mov    0x14(%ebp),%edx
  80135f:	89 0a                	mov    %ecx,(%edx)
  801361:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	01 c2                	add    %eax,%edx
  80136d:	8b 45 08             	mov    0x8(%ebp),%eax
  801370:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801372:	eb 03                	jmp    801377 <strsplit+0x8f>
			string++;
  801374:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801377:	8b 45 08             	mov    0x8(%ebp),%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	84 c0                	test   %al,%al
  80137e:	74 8b                	je     80130b <strsplit+0x23>
  801380:	8b 45 08             	mov    0x8(%ebp),%eax
  801383:	8a 00                	mov    (%eax),%al
  801385:	0f be c0             	movsbl %al,%eax
  801388:	50                   	push   %eax
  801389:	ff 75 0c             	pushl  0xc(%ebp)
  80138c:	e8 b5 fa ff ff       	call   800e46 <strchr>
  801391:	83 c4 08             	add    $0x8,%esp
  801394:	85 c0                	test   %eax,%eax
  801396:	74 dc                	je     801374 <strsplit+0x8c>
			string++;
	}
  801398:	e9 6e ff ff ff       	jmp    80130b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80139d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80139e:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a1:	8b 00                	mov    (%eax),%eax
  8013a3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8013ad:	01 d0                	add    %edx,%eax
  8013af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013b5:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013c2:	a1 04 40 80 00       	mov    0x804004,%eax
  8013c7:	85 c0                	test   %eax,%eax
  8013c9:	74 1f                	je     8013ea <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013cb:	e8 1d 00 00 00       	call   8013ed <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013d0:	83 ec 0c             	sub    $0xc,%esp
  8013d3:	68 50 3a 80 00       	push   $0x803a50
  8013d8:	e8 55 f2 ff ff       	call   800632 <cprintf>
  8013dd:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013e0:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013e7:	00 00 00 
	}
}
  8013ea:	90                   	nop
  8013eb:	c9                   	leave  
  8013ec:	c3                   	ret    

008013ed <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8013f3:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013fa:	00 00 00 
  8013fd:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801404:	00 00 00 
  801407:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80140e:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801411:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801418:	00 00 00 
  80141b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801422:	00 00 00 
  801425:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80142c:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80142f:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801439:	c1 e8 0c             	shr    $0xc,%eax
  80143c:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801441:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801450:	2d 00 10 00 00       	sub    $0x1000,%eax
  801455:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  80145a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801461:	a1 20 41 80 00       	mov    0x804120,%eax
  801466:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80146a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80146d:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801474:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801477:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80147a:	01 d0                	add    %edx,%eax
  80147c:	48                   	dec    %eax
  80147d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801480:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801483:	ba 00 00 00 00       	mov    $0x0,%edx
  801488:	f7 75 e4             	divl   -0x1c(%ebp)
  80148b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148e:	29 d0                	sub    %edx,%eax
  801490:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801493:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  80149a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80149d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	6a 07                	push   $0x7
  8014ac:	ff 75 e8             	pushl  -0x18(%ebp)
  8014af:	50                   	push   %eax
  8014b0:	e8 3d 06 00 00       	call   801af2 <sys_allocate_chunk>
  8014b5:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014b8:	a1 20 41 80 00       	mov    0x804120,%eax
  8014bd:	83 ec 0c             	sub    $0xc,%esp
  8014c0:	50                   	push   %eax
  8014c1:	e8 b2 0c 00 00       	call   802178 <initialize_MemBlocksList>
  8014c6:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8014c9:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8014d1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014d5:	0f 84 f3 00 00 00    	je     8015ce <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8014db:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014df:	75 14                	jne    8014f5 <initialize_dyn_block_system+0x108>
  8014e1:	83 ec 04             	sub    $0x4,%esp
  8014e4:	68 75 3a 80 00       	push   $0x803a75
  8014e9:	6a 36                	push   $0x36
  8014eb:	68 93 3a 80 00       	push   $0x803a93
  8014f0:	e8 89 ee ff ff       	call   80037e <_panic>
  8014f5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014f8:	8b 00                	mov    (%eax),%eax
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	74 10                	je     80150e <initialize_dyn_block_system+0x121>
  8014fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801501:	8b 00                	mov    (%eax),%eax
  801503:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801506:	8b 52 04             	mov    0x4(%edx),%edx
  801509:	89 50 04             	mov    %edx,0x4(%eax)
  80150c:	eb 0b                	jmp    801519 <initialize_dyn_block_system+0x12c>
  80150e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801511:	8b 40 04             	mov    0x4(%eax),%eax
  801514:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801519:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80151c:	8b 40 04             	mov    0x4(%eax),%eax
  80151f:	85 c0                	test   %eax,%eax
  801521:	74 0f                	je     801532 <initialize_dyn_block_system+0x145>
  801523:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801526:	8b 40 04             	mov    0x4(%eax),%eax
  801529:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80152c:	8b 12                	mov    (%edx),%edx
  80152e:	89 10                	mov    %edx,(%eax)
  801530:	eb 0a                	jmp    80153c <initialize_dyn_block_system+0x14f>
  801532:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801535:	8b 00                	mov    (%eax),%eax
  801537:	a3 48 41 80 00       	mov    %eax,0x804148
  80153c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80153f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801545:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801548:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80154f:	a1 54 41 80 00       	mov    0x804154,%eax
  801554:	48                   	dec    %eax
  801555:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80155a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80155d:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801564:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801567:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80156e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801572:	75 14                	jne    801588 <initialize_dyn_block_system+0x19b>
  801574:	83 ec 04             	sub    $0x4,%esp
  801577:	68 a0 3a 80 00       	push   $0x803aa0
  80157c:	6a 3e                	push   $0x3e
  80157e:	68 93 3a 80 00       	push   $0x803a93
  801583:	e8 f6 ed ff ff       	call   80037e <_panic>
  801588:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80158e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801591:	89 10                	mov    %edx,(%eax)
  801593:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801596:	8b 00                	mov    (%eax),%eax
  801598:	85 c0                	test   %eax,%eax
  80159a:	74 0d                	je     8015a9 <initialize_dyn_block_system+0x1bc>
  80159c:	a1 38 41 80 00       	mov    0x804138,%eax
  8015a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015a4:	89 50 04             	mov    %edx,0x4(%eax)
  8015a7:	eb 08                	jmp    8015b1 <initialize_dyn_block_system+0x1c4>
  8015a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015ac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8015b1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015b4:	a3 38 41 80 00       	mov    %eax,0x804138
  8015b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015bc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015c3:	a1 44 41 80 00       	mov    0x804144,%eax
  8015c8:	40                   	inc    %eax
  8015c9:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8015ce:	90                   	nop
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8015d7:	e8 e0 fd ff ff       	call   8013bc <InitializeUHeap>
		if (size == 0) return NULL ;
  8015dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015e0:	75 07                	jne    8015e9 <malloc+0x18>
  8015e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e7:	eb 7f                	jmp    801668 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8015e9:	e8 d2 08 00 00       	call   801ec0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ee:	85 c0                	test   %eax,%eax
  8015f0:	74 71                	je     801663 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8015f2:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8015fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ff:	01 d0                	add    %edx,%eax
  801601:	48                   	dec    %eax
  801602:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801608:	ba 00 00 00 00       	mov    $0x0,%edx
  80160d:	f7 75 f4             	divl   -0xc(%ebp)
  801610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801613:	29 d0                	sub    %edx,%eax
  801615:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801618:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80161f:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801626:	76 07                	jbe    80162f <malloc+0x5e>
					return NULL ;
  801628:	b8 00 00 00 00       	mov    $0x0,%eax
  80162d:	eb 39                	jmp    801668 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80162f:	83 ec 0c             	sub    $0xc,%esp
  801632:	ff 75 08             	pushl  0x8(%ebp)
  801635:	e8 e6 0d 00 00       	call   802420 <alloc_block_FF>
  80163a:	83 c4 10             	add    $0x10,%esp
  80163d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801640:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801644:	74 16                	je     80165c <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801646:	83 ec 0c             	sub    $0xc,%esp
  801649:	ff 75 ec             	pushl  -0x14(%ebp)
  80164c:	e8 37 0c 00 00       	call   802288 <insert_sorted_allocList>
  801651:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801654:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801657:	8b 40 08             	mov    0x8(%eax),%eax
  80165a:	eb 0c                	jmp    801668 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  80165c:	b8 00 00 00 00       	mov    $0x0,%eax
  801661:	eb 05                	jmp    801668 <malloc+0x97>
				}
		}
	return 0;
  801663:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801668:	c9                   	leave  
  801669:	c3                   	ret    

0080166a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	ff 75 f4             	pushl  -0xc(%ebp)
  80167c:	68 40 40 80 00       	push   $0x804040
  801681:	e8 cf 0b 00 00       	call   802255 <find_block>
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  80168c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168f:	8b 40 0c             	mov    0xc(%eax),%eax
  801692:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801698:	8b 40 08             	mov    0x8(%eax),%eax
  80169b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  80169e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016a2:	0f 84 a1 00 00 00    	je     801749 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8016a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ac:	75 17                	jne    8016c5 <free+0x5b>
  8016ae:	83 ec 04             	sub    $0x4,%esp
  8016b1:	68 75 3a 80 00       	push   $0x803a75
  8016b6:	68 80 00 00 00       	push   $0x80
  8016bb:	68 93 3a 80 00       	push   $0x803a93
  8016c0:	e8 b9 ec ff ff       	call   80037e <_panic>
  8016c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c8:	8b 00                	mov    (%eax),%eax
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	74 10                	je     8016de <free+0x74>
  8016ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d1:	8b 00                	mov    (%eax),%eax
  8016d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d6:	8b 52 04             	mov    0x4(%edx),%edx
  8016d9:	89 50 04             	mov    %edx,0x4(%eax)
  8016dc:	eb 0b                	jmp    8016e9 <free+0x7f>
  8016de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e1:	8b 40 04             	mov    0x4(%eax),%eax
  8016e4:	a3 44 40 80 00       	mov    %eax,0x804044
  8016e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ec:	8b 40 04             	mov    0x4(%eax),%eax
  8016ef:	85 c0                	test   %eax,%eax
  8016f1:	74 0f                	je     801702 <free+0x98>
  8016f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f6:	8b 40 04             	mov    0x4(%eax),%eax
  8016f9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016fc:	8b 12                	mov    (%edx),%edx
  8016fe:	89 10                	mov    %edx,(%eax)
  801700:	eb 0a                	jmp    80170c <free+0xa2>
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801705:	8b 00                	mov    (%eax),%eax
  801707:	a3 40 40 80 00       	mov    %eax,0x804040
  80170c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801715:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801718:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80171f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801724:	48                   	dec    %eax
  801725:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80172a:	83 ec 0c             	sub    $0xc,%esp
  80172d:	ff 75 f0             	pushl  -0x10(%ebp)
  801730:	e8 29 12 00 00       	call   80295e <insert_sorted_with_merge_freeList>
  801735:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801738:	83 ec 08             	sub    $0x8,%esp
  80173b:	ff 75 ec             	pushl  -0x14(%ebp)
  80173e:	ff 75 e8             	pushl  -0x18(%ebp)
  801741:	e8 74 03 00 00       	call   801aba <sys_free_user_mem>
  801746:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801749:	90                   	nop
  80174a:	c9                   	leave  
  80174b:	c3                   	ret    

0080174c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 38             	sub    $0x38,%esp
  801752:	8b 45 10             	mov    0x10(%ebp),%eax
  801755:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801758:	e8 5f fc ff ff       	call   8013bc <InitializeUHeap>
	if (size == 0) return NULL ;
  80175d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801761:	75 0a                	jne    80176d <smalloc+0x21>
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	e9 b2 00 00 00       	jmp    80181f <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  80176d:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801774:	76 0a                	jbe    801780 <smalloc+0x34>
		return NULL;
  801776:	b8 00 00 00 00       	mov    $0x0,%eax
  80177b:	e9 9f 00 00 00       	jmp    80181f <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801780:	e8 3b 07 00 00       	call   801ec0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801785:	85 c0                	test   %eax,%eax
  801787:	0f 84 8d 00 00 00    	je     80181a <smalloc+0xce>
	struct MemBlock *b = NULL;
  80178d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801794:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80179b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a1:	01 d0                	add    %edx,%eax
  8017a3:	48                   	dec    %eax
  8017a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8017af:	f7 75 f0             	divl   -0x10(%ebp)
  8017b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b5:	29 d0                	sub    %edx,%eax
  8017b7:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8017ba:	83 ec 0c             	sub    $0xc,%esp
  8017bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8017c0:	e8 5b 0c 00 00       	call   802420 <alloc_block_FF>
  8017c5:	83 c4 10             	add    $0x10,%esp
  8017c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8017cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017cf:	75 07                	jne    8017d8 <smalloc+0x8c>
			return NULL;
  8017d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d6:	eb 47                	jmp    80181f <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8017d8:	83 ec 0c             	sub    $0xc,%esp
  8017db:	ff 75 f4             	pushl  -0xc(%ebp)
  8017de:	e8 a5 0a 00 00       	call   802288 <insert_sorted_allocList>
  8017e3:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8017e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e9:	8b 40 08             	mov    0x8(%eax),%eax
  8017ec:	89 c2                	mov    %eax,%edx
  8017ee:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017f2:	52                   	push   %edx
  8017f3:	50                   	push   %eax
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	ff 75 08             	pushl  0x8(%ebp)
  8017fa:	e8 46 04 00 00       	call   801c45 <sys_createSharedObject>
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801805:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801809:	78 08                	js     801813 <smalloc+0xc7>
		return (void *)b->sva;
  80180b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80180e:	8b 40 08             	mov    0x8(%eax),%eax
  801811:	eb 0c                	jmp    80181f <smalloc+0xd3>
		}else{
		return NULL;
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	eb 05                	jmp    80181f <smalloc+0xd3>
			}

	}return NULL;
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801827:	e8 90 fb ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80182c:	e8 8f 06 00 00       	call   801ec0 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801831:	85 c0                	test   %eax,%eax
  801833:	0f 84 ad 00 00 00    	je     8018e6 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801839:	83 ec 08             	sub    $0x8,%esp
  80183c:	ff 75 0c             	pushl  0xc(%ebp)
  80183f:	ff 75 08             	pushl  0x8(%ebp)
  801842:	e8 28 04 00 00       	call   801c6f <sys_getSizeOfSharedObject>
  801847:	83 c4 10             	add    $0x10,%esp
  80184a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80184d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801851:	79 0a                	jns    80185d <sget+0x3c>
    {
    	return NULL;
  801853:	b8 00 00 00 00       	mov    $0x0,%eax
  801858:	e9 8e 00 00 00       	jmp    8018eb <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  80185d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801864:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80186b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801871:	01 d0                	add    %edx,%eax
  801873:	48                   	dec    %eax
  801874:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801877:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80187a:	ba 00 00 00 00       	mov    $0x0,%edx
  80187f:	f7 75 ec             	divl   -0x14(%ebp)
  801882:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801885:	29 d0                	sub    %edx,%eax
  801887:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  80188a:	83 ec 0c             	sub    $0xc,%esp
  80188d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801890:	e8 8b 0b 00 00       	call   802420 <alloc_block_FF>
  801895:	83 c4 10             	add    $0x10,%esp
  801898:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  80189b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80189f:	75 07                	jne    8018a8 <sget+0x87>
				return NULL;
  8018a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a6:	eb 43                	jmp    8018eb <sget+0xca>
			}
			insert_sorted_allocList(b);
  8018a8:	83 ec 0c             	sub    $0xc,%esp
  8018ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8018ae:	e8 d5 09 00 00       	call   802288 <insert_sorted_allocList>
  8018b3:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8018b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b9:	8b 40 08             	mov    0x8(%eax),%eax
  8018bc:	83 ec 04             	sub    $0x4,%esp
  8018bf:	50                   	push   %eax
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	ff 75 08             	pushl  0x8(%ebp)
  8018c6:	e8 c1 03 00 00       	call   801c8c <sys_getSharedObject>
  8018cb:	83 c4 10             	add    $0x10,%esp
  8018ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8018d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018d5:	78 08                	js     8018df <sget+0xbe>
			return (void *)b->sva;
  8018d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018da:	8b 40 08             	mov    0x8(%eax),%eax
  8018dd:	eb 0c                	jmp    8018eb <sget+0xca>
			}else{
			return NULL;
  8018df:	b8 00 00 00 00       	mov    $0x0,%eax
  8018e4:	eb 05                	jmp    8018eb <sget+0xca>
			}
    }}return NULL;
  8018e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018f3:	e8 c4 fa ff ff       	call   8013bc <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018f8:	83 ec 04             	sub    $0x4,%esp
  8018fb:	68 c4 3a 80 00       	push   $0x803ac4
  801900:	68 03 01 00 00       	push   $0x103
  801905:	68 93 3a 80 00       	push   $0x803a93
  80190a:	e8 6f ea ff ff       	call   80037e <_panic>

0080190f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	68 ec 3a 80 00       	push   $0x803aec
  80191d:	68 17 01 00 00       	push   $0x117
  801922:	68 93 3a 80 00       	push   $0x803a93
  801927:	e8 52 ea ff ff       	call   80037e <_panic>

0080192c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801932:	83 ec 04             	sub    $0x4,%esp
  801935:	68 10 3b 80 00       	push   $0x803b10
  80193a:	68 22 01 00 00       	push   $0x122
  80193f:	68 93 3a 80 00       	push   $0x803a93
  801944:	e8 35 ea ff ff       	call   80037e <_panic>

00801949 <shrink>:

}
void shrink(uint32 newSize)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80194f:	83 ec 04             	sub    $0x4,%esp
  801952:	68 10 3b 80 00       	push   $0x803b10
  801957:	68 27 01 00 00       	push   $0x127
  80195c:	68 93 3a 80 00       	push   $0x803a93
  801961:	e8 18 ea ff ff       	call   80037e <_panic>

00801966 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80196c:	83 ec 04             	sub    $0x4,%esp
  80196f:	68 10 3b 80 00       	push   $0x803b10
  801974:	68 2c 01 00 00       	push   $0x12c
  801979:	68 93 3a 80 00       	push   $0x803a93
  80197e:	e8 fb e9 ff ff       	call   80037e <_panic>

00801983 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801983:	55                   	push   %ebp
  801984:	89 e5                	mov    %esp,%ebp
  801986:	57                   	push   %edi
  801987:	56                   	push   %esi
  801988:	53                   	push   %ebx
  801989:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80198c:	8b 45 08             	mov    0x8(%ebp),%eax
  80198f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801992:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801995:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801998:	8b 7d 18             	mov    0x18(%ebp),%edi
  80199b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80199e:	cd 30                	int    $0x30
  8019a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	5b                   	pop    %ebx
  8019aa:	5e                   	pop    %esi
  8019ab:	5f                   	pop    %edi
  8019ac:	5d                   	pop    %ebp
  8019ad:	c3                   	ret    

008019ae <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 04             	sub    $0x4,%esp
  8019b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019ba:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	52                   	push   %edx
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	50                   	push   %eax
  8019ca:	6a 00                	push   $0x0
  8019cc:	e8 b2 ff ff ff       	call   801983 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	90                   	nop
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 01                	push   $0x1
  8019e6:	e8 98 ff ff ff       	call   801983 <syscall>
  8019eb:	83 c4 18             	add    $0x18,%esp
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	52                   	push   %edx
  801a00:	50                   	push   %eax
  801a01:	6a 05                	push   $0x5
  801a03:	e8 7b ff ff ff       	call   801983 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a12:	8b 75 18             	mov    0x18(%ebp),%esi
  801a15:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a18:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a21:	56                   	push   %esi
  801a22:	53                   	push   %ebx
  801a23:	51                   	push   %ecx
  801a24:	52                   	push   %edx
  801a25:	50                   	push   %eax
  801a26:	6a 06                	push   $0x6
  801a28:	e8 56 ff ff ff       	call   801983 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a33:	5b                   	pop    %ebx
  801a34:	5e                   	pop    %esi
  801a35:	5d                   	pop    %ebp
  801a36:	c3                   	ret    

00801a37 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a37:	55                   	push   %ebp
  801a38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	52                   	push   %edx
  801a47:	50                   	push   %eax
  801a48:	6a 07                	push   $0x7
  801a4a:	e8 34 ff ff ff       	call   801983 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	ff 75 0c             	pushl  0xc(%ebp)
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	6a 08                	push   $0x8
  801a65:	e8 19 ff ff ff       	call   801983 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 09                	push   $0x9
  801a7e:	e8 00 ff ff ff       	call   801983 <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 0a                	push   $0xa
  801a97:	e8 e7 fe ff ff       	call   801983 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	c9                   	leave  
  801aa0:	c3                   	ret    

00801aa1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 0b                	push   $0xb
  801ab0:	e8 ce fe ff ff       	call   801983 <syscall>
  801ab5:	83 c4 18             	add    $0x18,%esp
}
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	ff 75 0c             	pushl  0xc(%ebp)
  801ac6:	ff 75 08             	pushl  0x8(%ebp)
  801ac9:	6a 0f                	push   $0xf
  801acb:	e8 b3 fe ff ff       	call   801983 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
	return;
  801ad3:	90                   	nop
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	ff 75 0c             	pushl  0xc(%ebp)
  801ae2:	ff 75 08             	pushl  0x8(%ebp)
  801ae5:	6a 10                	push   $0x10
  801ae7:	e8 97 fe ff ff       	call   801983 <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
	return ;
  801aef:	90                   	nop
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	ff 75 10             	pushl  0x10(%ebp)
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	ff 75 08             	pushl  0x8(%ebp)
  801b02:	6a 11                	push   $0x11
  801b04:	e8 7a fe ff ff       	call   801983 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0c:	90                   	nop
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 0c                	push   $0xc
  801b1e:	e8 60 fe ff ff       	call   801983 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	ff 75 08             	pushl  0x8(%ebp)
  801b36:	6a 0d                	push   $0xd
  801b38:	e8 46 fe ff ff       	call   801983 <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 0e                	push   $0xe
  801b51:	e8 2d fe ff ff       	call   801983 <syscall>
  801b56:	83 c4 18             	add    $0x18,%esp
}
  801b59:	90                   	nop
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 13                	push   $0x13
  801b6b:	e8 13 fe ff ff       	call   801983 <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	90                   	nop
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 14                	push   $0x14
  801b85:	e8 f9 fd ff ff       	call   801983 <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
}
  801b8d:	90                   	nop
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b9c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	50                   	push   %eax
  801ba9:	6a 15                	push   $0x15
  801bab:	e8 d3 fd ff ff       	call   801983 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	90                   	nop
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 16                	push   $0x16
  801bc5:	e8 b9 fd ff ff       	call   801983 <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	90                   	nop
  801bce:	c9                   	leave  
  801bcf:	c3                   	ret    

00801bd0 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	ff 75 0c             	pushl  0xc(%ebp)
  801bdf:	50                   	push   %eax
  801be0:	6a 17                	push   $0x17
  801be2:	e8 9c fd ff ff       	call   801983 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bef:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	52                   	push   %edx
  801bfc:	50                   	push   %eax
  801bfd:	6a 1a                	push   $0x1a
  801bff:	e8 7f fd ff ff       	call   801983 <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	52                   	push   %edx
  801c19:	50                   	push   %eax
  801c1a:	6a 18                	push   $0x18
  801c1c:	e8 62 fd ff ff       	call   801983 <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	90                   	nop
  801c25:	c9                   	leave  
  801c26:	c3                   	ret    

00801c27 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	52                   	push   %edx
  801c37:	50                   	push   %eax
  801c38:	6a 19                	push   $0x19
  801c3a:	e8 44 fd ff ff       	call   801983 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
}
  801c42:	90                   	nop
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 04             	sub    $0x4,%esp
  801c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c51:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c54:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	6a 00                	push   $0x0
  801c5d:	51                   	push   %ecx
  801c5e:	52                   	push   %edx
  801c5f:	ff 75 0c             	pushl  0xc(%ebp)
  801c62:	50                   	push   %eax
  801c63:	6a 1b                	push   $0x1b
  801c65:	e8 19 fd ff ff       	call   801983 <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c72:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	52                   	push   %edx
  801c7f:	50                   	push   %eax
  801c80:	6a 1c                	push   $0x1c
  801c82:	e8 fc fc ff ff       	call   801983 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c8f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	51                   	push   %ecx
  801c9d:	52                   	push   %edx
  801c9e:	50                   	push   %eax
  801c9f:	6a 1d                	push   $0x1d
  801ca1:	e8 dd fc ff ff       	call   801983 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	52                   	push   %edx
  801cbb:	50                   	push   %eax
  801cbc:	6a 1e                	push   $0x1e
  801cbe:	e8 c0 fc ff ff       	call   801983 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 1f                	push   $0x1f
  801cd7:	e8 a7 fc ff ff       	call   801983 <syscall>
  801cdc:	83 c4 18             	add    $0x18,%esp
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce7:	6a 00                	push   $0x0
  801ce9:	ff 75 14             	pushl  0x14(%ebp)
  801cec:	ff 75 10             	pushl  0x10(%ebp)
  801cef:	ff 75 0c             	pushl  0xc(%ebp)
  801cf2:	50                   	push   %eax
  801cf3:	6a 20                	push   $0x20
  801cf5:	e8 89 fc ff ff       	call   801983 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	50                   	push   %eax
  801d0e:	6a 21                	push   $0x21
  801d10:	e8 6e fc ff ff       	call   801983 <syscall>
  801d15:	83 c4 18             	add    $0x18,%esp
}
  801d18:	90                   	nop
  801d19:	c9                   	leave  
  801d1a:	c3                   	ret    

00801d1b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d1b:	55                   	push   %ebp
  801d1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	50                   	push   %eax
  801d2a:	6a 22                	push   $0x22
  801d2c:	e8 52 fc ff ff       	call   801983 <syscall>
  801d31:	83 c4 18             	add    $0x18,%esp
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 02                	push   $0x2
  801d45:	e8 39 fc ff ff       	call   801983 <syscall>
  801d4a:	83 c4 18             	add    $0x18,%esp
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 03                	push   $0x3
  801d5e:	e8 20 fc ff ff       	call   801983 <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 04                	push   $0x4
  801d77:	e8 07 fc ff ff       	call   801983 <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	c9                   	leave  
  801d80:	c3                   	ret    

00801d81 <sys_exit_env>:


void sys_exit_env(void)
{
  801d81:	55                   	push   %ebp
  801d82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 23                	push   $0x23
  801d90:	e8 ee fb ff ff       	call   801983 <syscall>
  801d95:	83 c4 18             	add    $0x18,%esp
}
  801d98:	90                   	nop
  801d99:	c9                   	leave  
  801d9a:	c3                   	ret    

00801d9b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d9b:	55                   	push   %ebp
  801d9c:	89 e5                	mov    %esp,%ebp
  801d9e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801da1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801da4:	8d 50 04             	lea    0x4(%eax),%edx
  801da7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	52                   	push   %edx
  801db1:	50                   	push   %eax
  801db2:	6a 24                	push   $0x24
  801db4:	e8 ca fb ff ff       	call   801983 <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
	return result;
  801dbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dc5:	89 01                	mov    %eax,(%ecx)
  801dc7:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801dca:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcd:	c9                   	leave  
  801dce:	c2 04 00             	ret    $0x4

00801dd1 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	ff 75 10             	pushl  0x10(%ebp)
  801ddb:	ff 75 0c             	pushl  0xc(%ebp)
  801dde:	ff 75 08             	pushl  0x8(%ebp)
  801de1:	6a 12                	push   $0x12
  801de3:	e8 9b fb ff ff       	call   801983 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
	return ;
  801deb:	90                   	nop
}
  801dec:	c9                   	leave  
  801ded:	c3                   	ret    

00801dee <sys_rcr2>:
uint32 sys_rcr2()
{
  801dee:	55                   	push   %ebp
  801def:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 25                	push   $0x25
  801dfd:	e8 81 fb ff ff       	call   801983 <syscall>
  801e02:	83 c4 18             	add    $0x18,%esp
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 04             	sub    $0x4,%esp
  801e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e10:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e13:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	50                   	push   %eax
  801e20:	6a 26                	push   $0x26
  801e22:	e8 5c fb ff ff       	call   801983 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
	return ;
  801e2a:	90                   	nop
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <rsttst>:
void rsttst()
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 28                	push   $0x28
  801e3c:	e8 42 fb ff ff       	call   801983 <syscall>
  801e41:	83 c4 18             	add    $0x18,%esp
	return ;
  801e44:	90                   	nop
}
  801e45:	c9                   	leave  
  801e46:	c3                   	ret    

00801e47 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
  801e4a:	83 ec 04             	sub    $0x4,%esp
  801e4d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e50:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e53:	8b 55 18             	mov    0x18(%ebp),%edx
  801e56:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e5a:	52                   	push   %edx
  801e5b:	50                   	push   %eax
  801e5c:	ff 75 10             	pushl  0x10(%ebp)
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	ff 75 08             	pushl  0x8(%ebp)
  801e65:	6a 27                	push   $0x27
  801e67:	e8 17 fb ff ff       	call   801983 <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6f:	90                   	nop
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <chktst>:
void chktst(uint32 n)
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	6a 29                	push   $0x29
  801e82:	e8 fc fa ff ff       	call   801983 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8a:	90                   	nop
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <inctst>:

void inctst()
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 2a                	push   $0x2a
  801e9c:	e8 e2 fa ff ff       	call   801983 <syscall>
  801ea1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea4:	90                   	nop
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <gettst>:
uint32 gettst()
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 2b                	push   $0x2b
  801eb6:	e8 c8 fa ff ff       	call   801983 <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 2c                	push   $0x2c
  801ed2:	e8 ac fa ff ff       	call   801983 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
  801eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801edd:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ee1:	75 07                	jne    801eea <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ee3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee8:	eb 05                	jmp    801eef <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801eea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eef:	c9                   	leave  
  801ef0:	c3                   	ret    

00801ef1 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	6a 00                	push   $0x0
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 2c                	push   $0x2c
  801f03:	e8 7b fa ff ff       	call   801983 <syscall>
  801f08:	83 c4 18             	add    $0x18,%esp
  801f0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f0e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f12:	75 07                	jne    801f1b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f14:	b8 01 00 00 00       	mov    $0x1,%eax
  801f19:	eb 05                	jmp    801f20 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 2c                	push   $0x2c
  801f34:	e8 4a fa ff ff       	call   801983 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
  801f3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f3f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f43:	75 07                	jne    801f4c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f45:	b8 01 00 00 00       	mov    $0x1,%eax
  801f4a:	eb 05                	jmp    801f51 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 2c                	push   $0x2c
  801f65:	e8 19 fa ff ff       	call   801983 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
  801f6d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f70:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f74:	75 07                	jne    801f7d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f76:	b8 01 00 00 00       	mov    $0x1,%eax
  801f7b:	eb 05                	jmp    801f82 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f82:	c9                   	leave  
  801f83:	c3                   	ret    

00801f84 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 00                	push   $0x0
  801f8f:	ff 75 08             	pushl  0x8(%ebp)
  801f92:	6a 2d                	push   $0x2d
  801f94:	e8 ea f9 ff ff       	call   801983 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9c:	90                   	nop
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fa3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fa6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fa9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fac:	8b 45 08             	mov    0x8(%ebp),%eax
  801faf:	6a 00                	push   $0x0
  801fb1:	53                   	push   %ebx
  801fb2:	51                   	push   %ecx
  801fb3:	52                   	push   %edx
  801fb4:	50                   	push   %eax
  801fb5:	6a 2e                	push   $0x2e
  801fb7:	e8 c7 f9 ff ff       	call   801983 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fc2:	c9                   	leave  
  801fc3:	c3                   	ret    

00801fc4 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	52                   	push   %edx
  801fd4:	50                   	push   %eax
  801fd5:	6a 2f                	push   $0x2f
  801fd7:	e8 a7 f9 ff ff       	call   801983 <syscall>
  801fdc:	83 c4 18             	add    $0x18,%esp
}
  801fdf:	c9                   	leave  
  801fe0:	c3                   	ret    

00801fe1 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fe7:	83 ec 0c             	sub    $0xc,%esp
  801fea:	68 20 3b 80 00       	push   $0x803b20
  801fef:	e8 3e e6 ff ff       	call   800632 <cprintf>
  801ff4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ff7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ffe:	83 ec 0c             	sub    $0xc,%esp
  802001:	68 4c 3b 80 00       	push   $0x803b4c
  802006:	e8 27 e6 ff ff       	call   800632 <cprintf>
  80200b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80200e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802012:	a1 38 41 80 00       	mov    0x804138,%eax
  802017:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201a:	eb 56                	jmp    802072 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80201c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802020:	74 1c                	je     80203e <print_mem_block_lists+0x5d>
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 50 08             	mov    0x8(%eax),%edx
  802028:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80202b:	8b 48 08             	mov    0x8(%eax),%ecx
  80202e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802031:	8b 40 0c             	mov    0xc(%eax),%eax
  802034:	01 c8                	add    %ecx,%eax
  802036:	39 c2                	cmp    %eax,%edx
  802038:	73 04                	jae    80203e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80203a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80203e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802041:	8b 50 08             	mov    0x8(%eax),%edx
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 40 0c             	mov    0xc(%eax),%eax
  80204a:	01 c2                	add    %eax,%edx
  80204c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204f:	8b 40 08             	mov    0x8(%eax),%eax
  802052:	83 ec 04             	sub    $0x4,%esp
  802055:	52                   	push   %edx
  802056:	50                   	push   %eax
  802057:	68 61 3b 80 00       	push   $0x803b61
  80205c:	e8 d1 e5 ff ff       	call   800632 <cprintf>
  802061:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80206a:	a1 40 41 80 00       	mov    0x804140,%eax
  80206f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802072:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802076:	74 07                	je     80207f <print_mem_block_lists+0x9e>
  802078:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207b:	8b 00                	mov    (%eax),%eax
  80207d:	eb 05                	jmp    802084 <print_mem_block_lists+0xa3>
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	a3 40 41 80 00       	mov    %eax,0x804140
  802089:	a1 40 41 80 00       	mov    0x804140,%eax
  80208e:	85 c0                	test   %eax,%eax
  802090:	75 8a                	jne    80201c <print_mem_block_lists+0x3b>
  802092:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802096:	75 84                	jne    80201c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802098:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80209c:	75 10                	jne    8020ae <print_mem_block_lists+0xcd>
  80209e:	83 ec 0c             	sub    $0xc,%esp
  8020a1:	68 70 3b 80 00       	push   $0x803b70
  8020a6:	e8 87 e5 ff ff       	call   800632 <cprintf>
  8020ab:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020b5:	83 ec 0c             	sub    $0xc,%esp
  8020b8:	68 94 3b 80 00       	push   $0x803b94
  8020bd:	e8 70 e5 ff ff       	call   800632 <cprintf>
  8020c2:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020c5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020c9:	a1 40 40 80 00       	mov    0x804040,%eax
  8020ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d1:	eb 56                	jmp    802129 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020d7:	74 1c                	je     8020f5 <print_mem_block_lists+0x114>
  8020d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dc:	8b 50 08             	mov    0x8(%eax),%edx
  8020df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e2:	8b 48 08             	mov    0x8(%eax),%ecx
  8020e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8020eb:	01 c8                	add    %ecx,%eax
  8020ed:	39 c2                	cmp    %eax,%edx
  8020ef:	73 04                	jae    8020f5 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020f1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	8b 50 08             	mov    0x8(%eax),%edx
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802101:	01 c2                	add    %eax,%edx
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	8b 40 08             	mov    0x8(%eax),%eax
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	52                   	push   %edx
  80210d:	50                   	push   %eax
  80210e:	68 61 3b 80 00       	push   $0x803b61
  802113:	e8 1a e5 ff ff       	call   800632 <cprintf>
  802118:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802121:	a1 48 40 80 00       	mov    0x804048,%eax
  802126:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80212d:	74 07                	je     802136 <print_mem_block_lists+0x155>
  80212f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802132:	8b 00                	mov    (%eax),%eax
  802134:	eb 05                	jmp    80213b <print_mem_block_lists+0x15a>
  802136:	b8 00 00 00 00       	mov    $0x0,%eax
  80213b:	a3 48 40 80 00       	mov    %eax,0x804048
  802140:	a1 48 40 80 00       	mov    0x804048,%eax
  802145:	85 c0                	test   %eax,%eax
  802147:	75 8a                	jne    8020d3 <print_mem_block_lists+0xf2>
  802149:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214d:	75 84                	jne    8020d3 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80214f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802153:	75 10                	jne    802165 <print_mem_block_lists+0x184>
  802155:	83 ec 0c             	sub    $0xc,%esp
  802158:	68 ac 3b 80 00       	push   $0x803bac
  80215d:	e8 d0 e4 ff ff       	call   800632 <cprintf>
  802162:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802165:	83 ec 0c             	sub    $0xc,%esp
  802168:	68 20 3b 80 00       	push   $0x803b20
  80216d:	e8 c0 e4 ff ff       	call   800632 <cprintf>
  802172:	83 c4 10             	add    $0x10,%esp

}
  802175:	90                   	nop
  802176:	c9                   	leave  
  802177:	c3                   	ret    

00802178 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80217e:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802185:	00 00 00 
  802188:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80218f:	00 00 00 
  802192:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802199:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80219c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021a3:	e9 9e 00 00 00       	jmp    802246 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8021a8:	a1 50 40 80 00       	mov    0x804050,%eax
  8021ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b0:	c1 e2 04             	shl    $0x4,%edx
  8021b3:	01 d0                	add    %edx,%eax
  8021b5:	85 c0                	test   %eax,%eax
  8021b7:	75 14                	jne    8021cd <initialize_MemBlocksList+0x55>
  8021b9:	83 ec 04             	sub    $0x4,%esp
  8021bc:	68 d4 3b 80 00       	push   $0x803bd4
  8021c1:	6a 3d                	push   $0x3d
  8021c3:	68 f7 3b 80 00       	push   $0x803bf7
  8021c8:	e8 b1 e1 ff ff       	call   80037e <_panic>
  8021cd:	a1 50 40 80 00       	mov    0x804050,%eax
  8021d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d5:	c1 e2 04             	shl    $0x4,%edx
  8021d8:	01 d0                	add    %edx,%eax
  8021da:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021e0:	89 10                	mov    %edx,(%eax)
  8021e2:	8b 00                	mov    (%eax),%eax
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	74 18                	je     802200 <initialize_MemBlocksList+0x88>
  8021e8:	a1 48 41 80 00       	mov    0x804148,%eax
  8021ed:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021f3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021f6:	c1 e1 04             	shl    $0x4,%ecx
  8021f9:	01 ca                	add    %ecx,%edx
  8021fb:	89 50 04             	mov    %edx,0x4(%eax)
  8021fe:	eb 12                	jmp    802212 <initialize_MemBlocksList+0x9a>
  802200:	a1 50 40 80 00       	mov    0x804050,%eax
  802205:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802208:	c1 e2 04             	shl    $0x4,%edx
  80220b:	01 d0                	add    %edx,%eax
  80220d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802212:	a1 50 40 80 00       	mov    0x804050,%eax
  802217:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221a:	c1 e2 04             	shl    $0x4,%edx
  80221d:	01 d0                	add    %edx,%eax
  80221f:	a3 48 41 80 00       	mov    %eax,0x804148
  802224:	a1 50 40 80 00       	mov    0x804050,%eax
  802229:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222c:	c1 e2 04             	shl    $0x4,%edx
  80222f:	01 d0                	add    %edx,%eax
  802231:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802238:	a1 54 41 80 00       	mov    0x804154,%eax
  80223d:	40                   	inc    %eax
  80223e:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802243:	ff 45 f4             	incl   -0xc(%ebp)
  802246:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802249:	3b 45 08             	cmp    0x8(%ebp),%eax
  80224c:	0f 82 56 ff ff ff    	jb     8021a8 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802252:	90                   	nop
  802253:	c9                   	leave  
  802254:	c3                   	ret    

00802255 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	8b 00                	mov    (%eax),%eax
  802260:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802263:	eb 18                	jmp    80227d <find_block+0x28>

		if(tmp->sva == va){
  802265:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802268:	8b 40 08             	mov    0x8(%eax),%eax
  80226b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80226e:	75 05                	jne    802275 <find_block+0x20>
			return tmp ;
  802270:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802273:	eb 11                	jmp    802286 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802275:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802278:	8b 00                	mov    (%eax),%eax
  80227a:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80227d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802281:	75 e2                	jne    802265 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802283:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80228e:	a1 40 40 80 00       	mov    0x804040,%eax
  802293:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802296:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80229b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  80229e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022a2:	75 65                	jne    802309 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8022a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a8:	75 14                	jne    8022be <insert_sorted_allocList+0x36>
  8022aa:	83 ec 04             	sub    $0x4,%esp
  8022ad:	68 d4 3b 80 00       	push   $0x803bd4
  8022b2:	6a 62                	push   $0x62
  8022b4:	68 f7 3b 80 00       	push   $0x803bf7
  8022b9:	e8 c0 e0 ff ff       	call   80037e <_panic>
  8022be:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	89 10                	mov    %edx,(%eax)
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	8b 00                	mov    (%eax),%eax
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	74 0d                	je     8022df <insert_sorted_allocList+0x57>
  8022d2:	a1 40 40 80 00       	mov    0x804040,%eax
  8022d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022da:	89 50 04             	mov    %edx,0x4(%eax)
  8022dd:	eb 08                	jmp    8022e7 <insert_sorted_allocList+0x5f>
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	a3 44 40 80 00       	mov    %eax,0x804044
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	a3 40 40 80 00       	mov    %eax,0x804040
  8022ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022f9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022fe:	40                   	inc    %eax
  8022ff:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802304:	e9 14 01 00 00       	jmp    80241d <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	8b 50 08             	mov    0x8(%eax),%edx
  80230f:	a1 44 40 80 00       	mov    0x804044,%eax
  802314:	8b 40 08             	mov    0x8(%eax),%eax
  802317:	39 c2                	cmp    %eax,%edx
  802319:	76 65                	jbe    802380 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80231b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80231f:	75 14                	jne    802335 <insert_sorted_allocList+0xad>
  802321:	83 ec 04             	sub    $0x4,%esp
  802324:	68 10 3c 80 00       	push   $0x803c10
  802329:	6a 64                	push   $0x64
  80232b:	68 f7 3b 80 00       	push   $0x803bf7
  802330:	e8 49 e0 ff ff       	call   80037e <_panic>
  802335:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	89 50 04             	mov    %edx,0x4(%eax)
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	8b 40 04             	mov    0x4(%eax),%eax
  802347:	85 c0                	test   %eax,%eax
  802349:	74 0c                	je     802357 <insert_sorted_allocList+0xcf>
  80234b:	a1 44 40 80 00       	mov    0x804044,%eax
  802350:	8b 55 08             	mov    0x8(%ebp),%edx
  802353:	89 10                	mov    %edx,(%eax)
  802355:	eb 08                	jmp    80235f <insert_sorted_allocList+0xd7>
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	a3 40 40 80 00       	mov    %eax,0x804040
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	a3 44 40 80 00       	mov    %eax,0x804044
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802370:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802375:	40                   	inc    %eax
  802376:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80237b:	e9 9d 00 00 00       	jmp    80241d <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802380:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802387:	e9 85 00 00 00       	jmp    802411 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80238c:	8b 45 08             	mov    0x8(%ebp),%eax
  80238f:	8b 50 08             	mov    0x8(%eax),%edx
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	8b 40 08             	mov    0x8(%eax),%eax
  802398:	39 c2                	cmp    %eax,%edx
  80239a:	73 6a                	jae    802406 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  80239c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023a0:	74 06                	je     8023a8 <insert_sorted_allocList+0x120>
  8023a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023a6:	75 14                	jne    8023bc <insert_sorted_allocList+0x134>
  8023a8:	83 ec 04             	sub    $0x4,%esp
  8023ab:	68 34 3c 80 00       	push   $0x803c34
  8023b0:	6a 6b                	push   $0x6b
  8023b2:	68 f7 3b 80 00       	push   $0x803bf7
  8023b7:	e8 c2 df ff ff       	call   80037e <_panic>
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 50 04             	mov    0x4(%eax),%edx
  8023c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c5:	89 50 04             	mov    %edx,0x4(%eax)
  8023c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ce:	89 10                	mov    %edx,(%eax)
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 40 04             	mov    0x4(%eax),%eax
  8023d6:	85 c0                	test   %eax,%eax
  8023d8:	74 0d                	je     8023e7 <insert_sorted_allocList+0x15f>
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 40 04             	mov    0x4(%eax),%eax
  8023e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e3:	89 10                	mov    %edx,(%eax)
  8023e5:	eb 08                	jmp    8023ef <insert_sorted_allocList+0x167>
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	a3 40 40 80 00       	mov    %eax,0x804040
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f5:	89 50 04             	mov    %edx,0x4(%eax)
  8023f8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023fd:	40                   	inc    %eax
  8023fe:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802403:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802404:	eb 17                	jmp    80241d <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80240e:	ff 45 f0             	incl   -0x10(%ebp)
  802411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802414:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802417:	0f 8c 6f ff ff ff    	jl     80238c <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80241d:	90                   	nop
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802426:	a1 38 41 80 00       	mov    0x804138,%eax
  80242b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80242e:	e9 7c 01 00 00       	jmp    8025af <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 40 0c             	mov    0xc(%eax),%eax
  802439:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243c:	0f 86 cf 00 00 00    	jbe    802511 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802442:	a1 48 41 80 00       	mov    0x804148,%eax
  802447:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80244a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244d:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802450:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802453:	8b 55 08             	mov    0x8(%ebp),%edx
  802456:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 50 08             	mov    0x8(%eax),%edx
  80245f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802462:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 40 0c             	mov    0xc(%eax),%eax
  80246b:	2b 45 08             	sub    0x8(%ebp),%eax
  80246e:	89 c2                	mov    %eax,%edx
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 50 08             	mov    0x8(%eax),%edx
  80247c:	8b 45 08             	mov    0x8(%ebp),%eax
  80247f:	01 c2                	add    %eax,%edx
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802487:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80248b:	75 17                	jne    8024a4 <alloc_block_FF+0x84>
  80248d:	83 ec 04             	sub    $0x4,%esp
  802490:	68 69 3c 80 00       	push   $0x803c69
  802495:	68 83 00 00 00       	push   $0x83
  80249a:	68 f7 3b 80 00       	push   $0x803bf7
  80249f:	e8 da de ff ff       	call   80037e <_panic>
  8024a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a7:	8b 00                	mov    (%eax),%eax
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	74 10                	je     8024bd <alloc_block_FF+0x9d>
  8024ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024b5:	8b 52 04             	mov    0x4(%edx),%edx
  8024b8:	89 50 04             	mov    %edx,0x4(%eax)
  8024bb:	eb 0b                	jmp    8024c8 <alloc_block_FF+0xa8>
  8024bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c0:	8b 40 04             	mov    0x4(%eax),%eax
  8024c3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cb:	8b 40 04             	mov    0x4(%eax),%eax
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	74 0f                	je     8024e1 <alloc_block_FF+0xc1>
  8024d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d5:	8b 40 04             	mov    0x4(%eax),%eax
  8024d8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024db:	8b 12                	mov    (%edx),%edx
  8024dd:	89 10                	mov    %edx,(%eax)
  8024df:	eb 0a                	jmp    8024eb <alloc_block_FF+0xcb>
  8024e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e4:	8b 00                	mov    (%eax),%eax
  8024e6:	a3 48 41 80 00       	mov    %eax,0x804148
  8024eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024fe:	a1 54 41 80 00       	mov    0x804154,%eax
  802503:	48                   	dec    %eax
  802504:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802509:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250c:	e9 ad 00 00 00       	jmp    8025be <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 40 0c             	mov    0xc(%eax),%eax
  802517:	3b 45 08             	cmp    0x8(%ebp),%eax
  80251a:	0f 85 87 00 00 00    	jne    8025a7 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802524:	75 17                	jne    80253d <alloc_block_FF+0x11d>
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	68 69 3c 80 00       	push   $0x803c69
  80252e:	68 87 00 00 00       	push   $0x87
  802533:	68 f7 3b 80 00       	push   $0x803bf7
  802538:	e8 41 de ff ff       	call   80037e <_panic>
  80253d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802540:	8b 00                	mov    (%eax),%eax
  802542:	85 c0                	test   %eax,%eax
  802544:	74 10                	je     802556 <alloc_block_FF+0x136>
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 00                	mov    (%eax),%eax
  80254b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254e:	8b 52 04             	mov    0x4(%edx),%edx
  802551:	89 50 04             	mov    %edx,0x4(%eax)
  802554:	eb 0b                	jmp    802561 <alloc_block_FF+0x141>
  802556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802559:	8b 40 04             	mov    0x4(%eax),%eax
  80255c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	85 c0                	test   %eax,%eax
  802569:	74 0f                	je     80257a <alloc_block_FF+0x15a>
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802574:	8b 12                	mov    (%edx),%edx
  802576:	89 10                	mov    %edx,(%eax)
  802578:	eb 0a                	jmp    802584 <alloc_block_FF+0x164>
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	a3 38 41 80 00       	mov    %eax,0x804138
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802597:	a1 44 41 80 00       	mov    0x804144,%eax
  80259c:	48                   	dec    %eax
  80259d:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	eb 17                	jmp    8025be <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	8b 00                	mov    (%eax),%eax
  8025ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8025af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b3:	0f 85 7a fe ff ff    	jne    802433 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8025b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025be:	c9                   	leave  
  8025bf:	c3                   	ret    

008025c0 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8025c6:	a1 38 41 80 00       	mov    0x804138,%eax
  8025cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8025ce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8025d5:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025dc:	a1 38 41 80 00       	mov    0x804138,%eax
  8025e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025e4:	e9 d0 00 00 00       	jmp    8026b9 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ef:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025f2:	0f 82 b8 00 00 00    	jb     8026b0 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fe:	2b 45 08             	sub    0x8(%ebp),%eax
  802601:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802607:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80260a:	0f 83 a1 00 00 00    	jae    8026b1 <alloc_block_BF+0xf1>
				differsize = differance ;
  802610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802613:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802619:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80261c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802620:	0f 85 8b 00 00 00    	jne    8026b1 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802626:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80262a:	75 17                	jne    802643 <alloc_block_BF+0x83>
  80262c:	83 ec 04             	sub    $0x4,%esp
  80262f:	68 69 3c 80 00       	push   $0x803c69
  802634:	68 a0 00 00 00       	push   $0xa0
  802639:	68 f7 3b 80 00       	push   $0x803bf7
  80263e:	e8 3b dd ff ff       	call   80037e <_panic>
  802643:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802646:	8b 00                	mov    (%eax),%eax
  802648:	85 c0                	test   %eax,%eax
  80264a:	74 10                	je     80265c <alloc_block_BF+0x9c>
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 00                	mov    (%eax),%eax
  802651:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802654:	8b 52 04             	mov    0x4(%edx),%edx
  802657:	89 50 04             	mov    %edx,0x4(%eax)
  80265a:	eb 0b                	jmp    802667 <alloc_block_BF+0xa7>
  80265c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265f:	8b 40 04             	mov    0x4(%eax),%eax
  802662:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 40 04             	mov    0x4(%eax),%eax
  80266d:	85 c0                	test   %eax,%eax
  80266f:	74 0f                	je     802680 <alloc_block_BF+0xc0>
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 04             	mov    0x4(%eax),%eax
  802677:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267a:	8b 12                	mov    (%edx),%edx
  80267c:	89 10                	mov    %edx,(%eax)
  80267e:	eb 0a                	jmp    80268a <alloc_block_BF+0xca>
  802680:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802683:	8b 00                	mov    (%eax),%eax
  802685:	a3 38 41 80 00       	mov    %eax,0x804138
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802693:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802696:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269d:	a1 44 41 80 00       	mov    0x804144,%eax
  8026a2:	48                   	dec    %eax
  8026a3:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	e9 0c 01 00 00       	jmp    8027bc <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8026b0:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8026b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8026b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026bd:	74 07                	je     8026c6 <alloc_block_BF+0x106>
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	eb 05                	jmp    8026cb <alloc_block_BF+0x10b>
  8026c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cb:	a3 40 41 80 00       	mov    %eax,0x804140
  8026d0:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d5:	85 c0                	test   %eax,%eax
  8026d7:	0f 85 0c ff ff ff    	jne    8025e9 <alloc_block_BF+0x29>
  8026dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e1:	0f 85 02 ff ff ff    	jne    8025e9 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8026e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026eb:	0f 84 c6 00 00 00    	je     8027b7 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8026f1:	a1 48 41 80 00       	mov    0x804148,%eax
  8026f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8026f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ff:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802705:	8b 50 08             	mov    0x8(%eax),%edx
  802708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270b:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80270e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802711:	8b 40 0c             	mov    0xc(%eax),%eax
  802714:	2b 45 08             	sub    0x8(%ebp),%eax
  802717:	89 c2                	mov    %eax,%edx
  802719:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80271c:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80271f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802722:	8b 50 08             	mov    0x8(%eax),%edx
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	01 c2                	add    %eax,%edx
  80272a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272d:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802730:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802734:	75 17                	jne    80274d <alloc_block_BF+0x18d>
  802736:	83 ec 04             	sub    $0x4,%esp
  802739:	68 69 3c 80 00       	push   $0x803c69
  80273e:	68 af 00 00 00       	push   $0xaf
  802743:	68 f7 3b 80 00       	push   $0x803bf7
  802748:	e8 31 dc ff ff       	call   80037e <_panic>
  80274d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	85 c0                	test   %eax,%eax
  802754:	74 10                	je     802766 <alloc_block_BF+0x1a6>
  802756:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802759:	8b 00                	mov    (%eax),%eax
  80275b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80275e:	8b 52 04             	mov    0x4(%edx),%edx
  802761:	89 50 04             	mov    %edx,0x4(%eax)
  802764:	eb 0b                	jmp    802771 <alloc_block_BF+0x1b1>
  802766:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802769:	8b 40 04             	mov    0x4(%eax),%eax
  80276c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802771:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	85 c0                	test   %eax,%eax
  802779:	74 0f                	je     80278a <alloc_block_BF+0x1ca>
  80277b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277e:	8b 40 04             	mov    0x4(%eax),%eax
  802781:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802784:	8b 12                	mov    (%edx),%edx
  802786:	89 10                	mov    %edx,(%eax)
  802788:	eb 0a                	jmp    802794 <alloc_block_BF+0x1d4>
  80278a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	a3 48 41 80 00       	mov    %eax,0x804148
  802794:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802797:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80279d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a7:	a1 54 41 80 00       	mov    0x804154,%eax
  8027ac:	48                   	dec    %eax
  8027ad:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8027b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b5:	eb 05                	jmp    8027bc <alloc_block_BF+0x1fc>
	}

	return NULL;
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bc:	c9                   	leave  
  8027bd:	c3                   	ret    

008027be <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
  8027c1:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8027c4:	a1 38 41 80 00       	mov    0x804138,%eax
  8027c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8027cc:	e9 7c 01 00 00       	jmp    80294d <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027da:	0f 86 cf 00 00 00    	jbe    8028af <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8027e0:	a1 48 41 80 00       	mov    0x804148,%eax
  8027e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8027ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f4:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	8b 50 08             	mov    0x8(%eax),%edx
  8027fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802800:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 0c             	mov    0xc(%eax),%eax
  802809:	2b 45 08             	sub    0x8(%ebp),%eax
  80280c:	89 c2                	mov    %eax,%edx
  80280e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802811:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802814:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802817:	8b 50 08             	mov    0x8(%eax),%edx
  80281a:	8b 45 08             	mov    0x8(%ebp),%eax
  80281d:	01 c2                	add    %eax,%edx
  80281f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802822:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802825:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802829:	75 17                	jne    802842 <alloc_block_NF+0x84>
  80282b:	83 ec 04             	sub    $0x4,%esp
  80282e:	68 69 3c 80 00       	push   $0x803c69
  802833:	68 c4 00 00 00       	push   $0xc4
  802838:	68 f7 3b 80 00       	push   $0x803bf7
  80283d:	e8 3c db ff ff       	call   80037e <_panic>
  802842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	85 c0                	test   %eax,%eax
  802849:	74 10                	je     80285b <alloc_block_NF+0x9d>
  80284b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284e:	8b 00                	mov    (%eax),%eax
  802850:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802853:	8b 52 04             	mov    0x4(%edx),%edx
  802856:	89 50 04             	mov    %edx,0x4(%eax)
  802859:	eb 0b                	jmp    802866 <alloc_block_NF+0xa8>
  80285b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285e:	8b 40 04             	mov    0x4(%eax),%eax
  802861:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802866:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802869:	8b 40 04             	mov    0x4(%eax),%eax
  80286c:	85 c0                	test   %eax,%eax
  80286e:	74 0f                	je     80287f <alloc_block_NF+0xc1>
  802870:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802873:	8b 40 04             	mov    0x4(%eax),%eax
  802876:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802879:	8b 12                	mov    (%edx),%edx
  80287b:	89 10                	mov    %edx,(%eax)
  80287d:	eb 0a                	jmp    802889 <alloc_block_NF+0xcb>
  80287f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802882:	8b 00                	mov    (%eax),%eax
  802884:	a3 48 41 80 00       	mov    %eax,0x804148
  802889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802892:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802895:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289c:	a1 54 41 80 00       	mov    0x804154,%eax
  8028a1:	48                   	dec    %eax
  8028a2:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8028a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028aa:	e9 ad 00 00 00       	jmp    80295c <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b8:	0f 85 87 00 00 00    	jne    802945 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8028be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c2:	75 17                	jne    8028db <alloc_block_NF+0x11d>
  8028c4:	83 ec 04             	sub    $0x4,%esp
  8028c7:	68 69 3c 80 00       	push   $0x803c69
  8028cc:	68 c8 00 00 00       	push   $0xc8
  8028d1:	68 f7 3b 80 00       	push   $0x803bf7
  8028d6:	e8 a3 da ff ff       	call   80037e <_panic>
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	74 10                	je     8028f4 <alloc_block_NF+0x136>
  8028e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e7:	8b 00                	mov    (%eax),%eax
  8028e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ec:	8b 52 04             	mov    0x4(%edx),%edx
  8028ef:	89 50 04             	mov    %edx,0x4(%eax)
  8028f2:	eb 0b                	jmp    8028ff <alloc_block_NF+0x141>
  8028f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f7:	8b 40 04             	mov    0x4(%eax),%eax
  8028fa:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802902:	8b 40 04             	mov    0x4(%eax),%eax
  802905:	85 c0                	test   %eax,%eax
  802907:	74 0f                	je     802918 <alloc_block_NF+0x15a>
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	8b 40 04             	mov    0x4(%eax),%eax
  80290f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802912:	8b 12                	mov    (%edx),%edx
  802914:	89 10                	mov    %edx,(%eax)
  802916:	eb 0a                	jmp    802922 <alloc_block_NF+0x164>
  802918:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291b:	8b 00                	mov    (%eax),%eax
  80291d:	a3 38 41 80 00       	mov    %eax,0x804138
  802922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802925:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802935:	a1 44 41 80 00       	mov    0x804144,%eax
  80293a:	48                   	dec    %eax
  80293b:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	eb 17                	jmp    80295c <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	8b 00                	mov    (%eax),%eax
  80294a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  80294d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802951:	0f 85 7a fe ff ff    	jne    8027d1 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802957:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80295c:	c9                   	leave  
  80295d:	c3                   	ret    

0080295e <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80295e:	55                   	push   %ebp
  80295f:	89 e5                	mov    %esp,%ebp
  802961:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802964:	a1 38 41 80 00       	mov    0x804138,%eax
  802969:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  80296c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802971:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802974:	a1 44 41 80 00       	mov    0x804144,%eax
  802979:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  80297c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802980:	75 68                	jne    8029ea <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802982:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802986:	75 17                	jne    80299f <insert_sorted_with_merge_freeList+0x41>
  802988:	83 ec 04             	sub    $0x4,%esp
  80298b:	68 d4 3b 80 00       	push   $0x803bd4
  802990:	68 da 00 00 00       	push   $0xda
  802995:	68 f7 3b 80 00       	push   $0x803bf7
  80299a:	e8 df d9 ff ff       	call   80037e <_panic>
  80299f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	89 10                	mov    %edx,(%eax)
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	74 0d                	je     8029c0 <insert_sorted_with_merge_freeList+0x62>
  8029b3:	a1 38 41 80 00       	mov    0x804138,%eax
  8029b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bb:	89 50 04             	mov    %edx,0x4(%eax)
  8029be:	eb 08                	jmp    8029c8 <insert_sorted_with_merge_freeList+0x6a>
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	a3 38 41 80 00       	mov    %eax,0x804138
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029da:	a1 44 41 80 00       	mov    0x804144,%eax
  8029df:	40                   	inc    %eax
  8029e0:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8029e5:	e9 49 07 00 00       	jmp    803133 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8029ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ed:	8b 50 08             	mov    0x8(%eax),%edx
  8029f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f6:	01 c2                	add    %eax,%edx
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	8b 40 08             	mov    0x8(%eax),%eax
  8029fe:	39 c2                	cmp    %eax,%edx
  802a00:	73 77                	jae    802a79 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	85 c0                	test   %eax,%eax
  802a09:	75 6e                	jne    802a79 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802a0b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a0f:	74 68                	je     802a79 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802a11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a15:	75 17                	jne    802a2e <insert_sorted_with_merge_freeList+0xd0>
  802a17:	83 ec 04             	sub    $0x4,%esp
  802a1a:	68 10 3c 80 00       	push   $0x803c10
  802a1f:	68 e0 00 00 00       	push   $0xe0
  802a24:	68 f7 3b 80 00       	push   $0x803bf7
  802a29:	e8 50 d9 ff ff       	call   80037e <_panic>
  802a2e:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a34:	8b 45 08             	mov    0x8(%ebp),%eax
  802a37:	89 50 04             	mov    %edx,0x4(%eax)
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	8b 40 04             	mov    0x4(%eax),%eax
  802a40:	85 c0                	test   %eax,%eax
  802a42:	74 0c                	je     802a50 <insert_sorted_with_merge_freeList+0xf2>
  802a44:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a49:	8b 55 08             	mov    0x8(%ebp),%edx
  802a4c:	89 10                	mov    %edx,(%eax)
  802a4e:	eb 08                	jmp    802a58 <insert_sorted_with_merge_freeList+0xfa>
  802a50:	8b 45 08             	mov    0x8(%ebp),%eax
  802a53:	a3 38 41 80 00       	mov    %eax,0x804138
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a60:	8b 45 08             	mov    0x8(%ebp),%eax
  802a63:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a69:	a1 44 41 80 00       	mov    0x804144,%eax
  802a6e:	40                   	inc    %eax
  802a6f:	a3 44 41 80 00       	mov    %eax,0x804144
  802a74:	e9 ba 06 00 00       	jmp    803133 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802a79:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7c:	8b 50 0c             	mov    0xc(%eax),%edx
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	8b 40 08             	mov    0x8(%eax),%eax
  802a85:	01 c2                	add    %eax,%edx
  802a87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8a:	8b 40 08             	mov    0x8(%eax),%eax
  802a8d:	39 c2                	cmp    %eax,%edx
  802a8f:	73 78                	jae    802b09 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 40 04             	mov    0x4(%eax),%eax
  802a97:	85 c0                	test   %eax,%eax
  802a99:	75 6e                	jne    802b09 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802a9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a9f:	74 68                	je     802b09 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa5:	75 17                	jne    802abe <insert_sorted_with_merge_freeList+0x160>
  802aa7:	83 ec 04             	sub    $0x4,%esp
  802aaa:	68 d4 3b 80 00       	push   $0x803bd4
  802aaf:	68 e6 00 00 00       	push   $0xe6
  802ab4:	68 f7 3b 80 00       	push   $0x803bf7
  802ab9:	e8 c0 d8 ff ff       	call   80037e <_panic>
  802abe:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	89 10                	mov    %edx,(%eax)
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	8b 00                	mov    (%eax),%eax
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	74 0d                	je     802adf <insert_sorted_with_merge_freeList+0x181>
  802ad2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ada:	89 50 04             	mov    %edx,0x4(%eax)
  802add:	eb 08                	jmp    802ae7 <insert_sorted_with_merge_freeList+0x189>
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	a3 38 41 80 00       	mov    %eax,0x804138
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af9:	a1 44 41 80 00       	mov    0x804144,%eax
  802afe:	40                   	inc    %eax
  802aff:	a3 44 41 80 00       	mov    %eax,0x804144
  802b04:	e9 2a 06 00 00       	jmp    803133 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802b09:	a1 38 41 80 00       	mov    0x804138,%eax
  802b0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b11:	e9 ed 05 00 00       	jmp    803103 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 00                	mov    (%eax),%eax
  802b1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802b1e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b22:	0f 84 a7 00 00 00    	je     802bcf <insert_sorted_with_merge_freeList+0x271>
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 50 0c             	mov    0xc(%eax),%edx
  802b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b31:	8b 40 08             	mov    0x8(%eax),%eax
  802b34:	01 c2                	add    %eax,%edx
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	8b 40 08             	mov    0x8(%eax),%eax
  802b3c:	39 c2                	cmp    %eax,%edx
  802b3e:	0f 83 8b 00 00 00    	jae    802bcf <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	8b 50 0c             	mov    0xc(%eax),%edx
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	8b 40 08             	mov    0x8(%eax),%eax
  802b50:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802b52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b55:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802b58:	39 c2                	cmp    %eax,%edx
  802b5a:	73 73                	jae    802bcf <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802b5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b60:	74 06                	je     802b68 <insert_sorted_with_merge_freeList+0x20a>
  802b62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b66:	75 17                	jne    802b7f <insert_sorted_with_merge_freeList+0x221>
  802b68:	83 ec 04             	sub    $0x4,%esp
  802b6b:	68 88 3c 80 00       	push   $0x803c88
  802b70:	68 f0 00 00 00       	push   $0xf0
  802b75:	68 f7 3b 80 00       	push   $0x803bf7
  802b7a:	e8 ff d7 ff ff       	call   80037e <_panic>
  802b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b82:	8b 10                	mov    (%eax),%edx
  802b84:	8b 45 08             	mov    0x8(%ebp),%eax
  802b87:	89 10                	mov    %edx,(%eax)
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	8b 00                	mov    (%eax),%eax
  802b8e:	85 c0                	test   %eax,%eax
  802b90:	74 0b                	je     802b9d <insert_sorted_with_merge_freeList+0x23f>
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	8b 00                	mov    (%eax),%eax
  802b97:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9a:	89 50 04             	mov    %edx,0x4(%eax)
  802b9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba3:	89 10                	mov    %edx,(%eax)
  802ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bab:	89 50 04             	mov    %edx,0x4(%eax)
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	8b 00                	mov    (%eax),%eax
  802bb3:	85 c0                	test   %eax,%eax
  802bb5:	75 08                	jne    802bbf <insert_sorted_with_merge_freeList+0x261>
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bbf:	a1 44 41 80 00       	mov    0x804144,%eax
  802bc4:	40                   	inc    %eax
  802bc5:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802bca:	e9 64 05 00 00       	jmp    803133 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802bcf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bd4:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bdc:	8b 40 08             	mov    0x8(%eax),%eax
  802bdf:	01 c2                	add    %eax,%edx
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 40 08             	mov    0x8(%eax),%eax
  802be7:	39 c2                	cmp    %eax,%edx
  802be9:	0f 85 b1 00 00 00    	jne    802ca0 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802bef:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	0f 84 a4 00 00 00    	je     802ca0 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802bfc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c01:	8b 00                	mov    (%eax),%eax
  802c03:	85 c0                	test   %eax,%eax
  802c05:	0f 85 95 00 00 00    	jne    802ca0 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802c0b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c10:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c16:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c19:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1c:	8b 52 0c             	mov    0xc(%edx),%edx
  802c1f:	01 ca                	add    %ecx,%edx
  802c21:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3c:	75 17                	jne    802c55 <insert_sorted_with_merge_freeList+0x2f7>
  802c3e:	83 ec 04             	sub    $0x4,%esp
  802c41:	68 d4 3b 80 00       	push   $0x803bd4
  802c46:	68 ff 00 00 00       	push   $0xff
  802c4b:	68 f7 3b 80 00       	push   $0x803bf7
  802c50:	e8 29 d7 ff ff       	call   80037e <_panic>
  802c55:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5e:	89 10                	mov    %edx,(%eax)
  802c60:	8b 45 08             	mov    0x8(%ebp),%eax
  802c63:	8b 00                	mov    (%eax),%eax
  802c65:	85 c0                	test   %eax,%eax
  802c67:	74 0d                	je     802c76 <insert_sorted_with_merge_freeList+0x318>
  802c69:	a1 48 41 80 00       	mov    0x804148,%eax
  802c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c71:	89 50 04             	mov    %edx,0x4(%eax)
  802c74:	eb 08                	jmp    802c7e <insert_sorted_with_merge_freeList+0x320>
  802c76:	8b 45 08             	mov    0x8(%ebp),%eax
  802c79:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	a3 48 41 80 00       	mov    %eax,0x804148
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c90:	a1 54 41 80 00       	mov    0x804154,%eax
  802c95:	40                   	inc    %eax
  802c96:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802c9b:	e9 93 04 00 00       	jmp    803133 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 50 08             	mov    0x8(%eax),%edx
  802ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cac:	01 c2                	add    %eax,%edx
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	8b 40 08             	mov    0x8(%eax),%eax
  802cb4:	39 c2                	cmp    %eax,%edx
  802cb6:	0f 85 ae 00 00 00    	jne    802d6a <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	8b 40 08             	mov    0x8(%eax),%eax
  802cc8:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 00                	mov    (%eax),%eax
  802ccf:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802cd2:	39 c2                	cmp    %eax,%edx
  802cd4:	0f 84 90 00 00 00    	je     802d6a <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce6:	01 c2                	add    %eax,%edx
  802ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ceb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cee:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d06:	75 17                	jne    802d1f <insert_sorted_with_merge_freeList+0x3c1>
  802d08:	83 ec 04             	sub    $0x4,%esp
  802d0b:	68 d4 3b 80 00       	push   $0x803bd4
  802d10:	68 0b 01 00 00       	push   $0x10b
  802d15:	68 f7 3b 80 00       	push   $0x803bf7
  802d1a:	e8 5f d6 ff ff       	call   80037e <_panic>
  802d1f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d25:	8b 45 08             	mov    0x8(%ebp),%eax
  802d28:	89 10                	mov    %edx,(%eax)
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	8b 00                	mov    (%eax),%eax
  802d2f:	85 c0                	test   %eax,%eax
  802d31:	74 0d                	je     802d40 <insert_sorted_with_merge_freeList+0x3e2>
  802d33:	a1 48 41 80 00       	mov    0x804148,%eax
  802d38:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3b:	89 50 04             	mov    %edx,0x4(%eax)
  802d3e:	eb 08                	jmp    802d48 <insert_sorted_with_merge_freeList+0x3ea>
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d5f:	40                   	inc    %eax
  802d60:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d65:	e9 c9 03 00 00       	jmp    803133 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	8b 40 08             	mov    0x8(%eax),%eax
  802d76:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d7e:	39 c2                	cmp    %eax,%edx
  802d80:	0f 85 bb 00 00 00    	jne    802e41 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802d86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8a:	0f 84 b1 00 00 00    	je     802e41 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 40 04             	mov    0x4(%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	0f 85 a3 00 00 00    	jne    802e41 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802d9e:	a1 38 41 80 00       	mov    0x804138,%eax
  802da3:	8b 55 08             	mov    0x8(%ebp),%edx
  802da6:	8b 52 08             	mov    0x8(%edx),%edx
  802da9:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802dac:	a1 38 41 80 00       	mov    0x804138,%eax
  802db1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802db7:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802dba:	8b 55 08             	mov    0x8(%ebp),%edx
  802dbd:	8b 52 0c             	mov    0xc(%edx),%edx
  802dc0:	01 ca                	add    %ecx,%edx
  802dc2:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802dd9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ddd:	75 17                	jne    802df6 <insert_sorted_with_merge_freeList+0x498>
  802ddf:	83 ec 04             	sub    $0x4,%esp
  802de2:	68 d4 3b 80 00       	push   $0x803bd4
  802de7:	68 17 01 00 00       	push   $0x117
  802dec:	68 f7 3b 80 00       	push   $0x803bf7
  802df1:	e8 88 d5 ff ff       	call   80037e <_panic>
  802df6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	89 10                	mov    %edx,(%eax)
  802e01:	8b 45 08             	mov    0x8(%ebp),%eax
  802e04:	8b 00                	mov    (%eax),%eax
  802e06:	85 c0                	test   %eax,%eax
  802e08:	74 0d                	je     802e17 <insert_sorted_with_merge_freeList+0x4b9>
  802e0a:	a1 48 41 80 00       	mov    0x804148,%eax
  802e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e12:	89 50 04             	mov    %edx,0x4(%eax)
  802e15:	eb 08                	jmp    802e1f <insert_sorted_with_merge_freeList+0x4c1>
  802e17:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	a3 48 41 80 00       	mov    %eax,0x804148
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e31:	a1 54 41 80 00       	mov    0x804154,%eax
  802e36:	40                   	inc    %eax
  802e37:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802e3c:	e9 f2 02 00 00       	jmp    803133 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	8b 50 08             	mov    0x8(%eax),%edx
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4d:	01 c2                	add    %eax,%edx
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	8b 40 08             	mov    0x8(%eax),%eax
  802e55:	39 c2                	cmp    %eax,%edx
  802e57:	0f 85 be 00 00 00    	jne    802f1b <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 40 04             	mov    0x4(%eax),%eax
  802e63:	8b 50 08             	mov    0x8(%eax),%edx
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 40 04             	mov    0x4(%eax),%eax
  802e6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6f:	01 c2                	add    %eax,%edx
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 40 08             	mov    0x8(%eax),%eax
  802e77:	39 c2                	cmp    %eax,%edx
  802e79:	0f 84 9c 00 00 00    	je     802f1b <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	8b 50 08             	mov    0x8(%eax),%edx
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	8b 40 0c             	mov    0xc(%eax),%eax
  802e97:	01 c2                	add    %eax,%edx
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802eb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb7:	75 17                	jne    802ed0 <insert_sorted_with_merge_freeList+0x572>
  802eb9:	83 ec 04             	sub    $0x4,%esp
  802ebc:	68 d4 3b 80 00       	push   $0x803bd4
  802ec1:	68 26 01 00 00       	push   $0x126
  802ec6:	68 f7 3b 80 00       	push   $0x803bf7
  802ecb:	e8 ae d4 ff ff       	call   80037e <_panic>
  802ed0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	89 10                	mov    %edx,(%eax)
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	8b 00                	mov    (%eax),%eax
  802ee0:	85 c0                	test   %eax,%eax
  802ee2:	74 0d                	je     802ef1 <insert_sorted_with_merge_freeList+0x593>
  802ee4:	a1 48 41 80 00       	mov    0x804148,%eax
  802ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  802eec:	89 50 04             	mov    %edx,0x4(%eax)
  802eef:	eb 08                	jmp    802ef9 <insert_sorted_with_merge_freeList+0x59b>
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	a3 48 41 80 00       	mov    %eax,0x804148
  802f01:	8b 45 08             	mov    0x8(%ebp),%eax
  802f04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0b:	a1 54 41 80 00       	mov    0x804154,%eax
  802f10:	40                   	inc    %eax
  802f11:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802f16:	e9 18 02 00 00       	jmp    803133 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f24:	8b 40 08             	mov    0x8(%eax),%eax
  802f27:	01 c2                	add    %eax,%edx
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	8b 40 08             	mov    0x8(%eax),%eax
  802f2f:	39 c2                	cmp    %eax,%edx
  802f31:	0f 85 c4 01 00 00    	jne    8030fb <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f40:	8b 40 08             	mov    0x8(%eax),%eax
  802f43:	01 c2                	add    %eax,%edx
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 00                	mov    (%eax),%eax
  802f4a:	8b 40 08             	mov    0x8(%eax),%eax
  802f4d:	39 c2                	cmp    %eax,%edx
  802f4f:	0f 85 a6 01 00 00    	jne    8030fb <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802f55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f59:	0f 84 9c 01 00 00    	je     8030fb <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 50 0c             	mov    0xc(%eax),%edx
  802f65:	8b 45 08             	mov    0x8(%ebp),%eax
  802f68:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6b:	01 c2                	add    %eax,%edx
  802f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f70:	8b 00                	mov    (%eax),%eax
  802f72:	8b 40 0c             	mov    0xc(%eax),%eax
  802f75:	01 c2                	add    %eax,%edx
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f80:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802f91:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f95:	75 17                	jne    802fae <insert_sorted_with_merge_freeList+0x650>
  802f97:	83 ec 04             	sub    $0x4,%esp
  802f9a:	68 d4 3b 80 00       	push   $0x803bd4
  802f9f:	68 32 01 00 00       	push   $0x132
  802fa4:	68 f7 3b 80 00       	push   $0x803bf7
  802fa9:	e8 d0 d3 ff ff       	call   80037e <_panic>
  802fae:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb7:	89 10                	mov    %edx,(%eax)
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	8b 00                	mov    (%eax),%eax
  802fbe:	85 c0                	test   %eax,%eax
  802fc0:	74 0d                	je     802fcf <insert_sorted_with_merge_freeList+0x671>
  802fc2:	a1 48 41 80 00       	mov    0x804148,%eax
  802fc7:	8b 55 08             	mov    0x8(%ebp),%edx
  802fca:	89 50 04             	mov    %edx,0x4(%eax)
  802fcd:	eb 08                	jmp    802fd7 <insert_sorted_with_merge_freeList+0x679>
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	a3 48 41 80 00       	mov    %eax,0x804148
  802fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe9:	a1 54 41 80 00       	mov    0x804154,%eax
  802fee:	40                   	inc    %eax
  802fef:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	8b 00                	mov    (%eax),%eax
  802ff9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80300c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300f:	8b 00                	mov    (%eax),%eax
  803011:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803014:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803018:	75 17                	jne    803031 <insert_sorted_with_merge_freeList+0x6d3>
  80301a:	83 ec 04             	sub    $0x4,%esp
  80301d:	68 69 3c 80 00       	push   $0x803c69
  803022:	68 36 01 00 00       	push   $0x136
  803027:	68 f7 3b 80 00       	push   $0x803bf7
  80302c:	e8 4d d3 ff ff       	call   80037e <_panic>
  803031:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803034:	8b 00                	mov    (%eax),%eax
  803036:	85 c0                	test   %eax,%eax
  803038:	74 10                	je     80304a <insert_sorted_with_merge_freeList+0x6ec>
  80303a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303d:	8b 00                	mov    (%eax),%eax
  80303f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803042:	8b 52 04             	mov    0x4(%edx),%edx
  803045:	89 50 04             	mov    %edx,0x4(%eax)
  803048:	eb 0b                	jmp    803055 <insert_sorted_with_merge_freeList+0x6f7>
  80304a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304d:	8b 40 04             	mov    0x4(%eax),%eax
  803050:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803058:	8b 40 04             	mov    0x4(%eax),%eax
  80305b:	85 c0                	test   %eax,%eax
  80305d:	74 0f                	je     80306e <insert_sorted_with_merge_freeList+0x710>
  80305f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803062:	8b 40 04             	mov    0x4(%eax),%eax
  803065:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803068:	8b 12                	mov    (%edx),%edx
  80306a:	89 10                	mov    %edx,(%eax)
  80306c:	eb 0a                	jmp    803078 <insert_sorted_with_merge_freeList+0x71a>
  80306e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803071:	8b 00                	mov    (%eax),%eax
  803073:	a3 38 41 80 00       	mov    %eax,0x804138
  803078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803081:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803084:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308b:	a1 44 41 80 00       	mov    0x804144,%eax
  803090:	48                   	dec    %eax
  803091:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803096:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80309a:	75 17                	jne    8030b3 <insert_sorted_with_merge_freeList+0x755>
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	68 d4 3b 80 00       	push   $0x803bd4
  8030a4:	68 37 01 00 00       	push   $0x137
  8030a9:	68 f7 3b 80 00       	push   $0x803bf7
  8030ae:	e8 cb d2 ff ff       	call   80037e <_panic>
  8030b3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030bc:	89 10                	mov    %edx,(%eax)
  8030be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	74 0d                	je     8030d4 <insert_sorted_with_merge_freeList+0x776>
  8030c7:	a1 48 41 80 00       	mov    0x804148,%eax
  8030cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030cf:	89 50 04             	mov    %edx,0x4(%eax)
  8030d2:	eb 08                	jmp    8030dc <insert_sorted_with_merge_freeList+0x77e>
  8030d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030df:	a3 48 41 80 00       	mov    %eax,0x804148
  8030e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ee:	a1 54 41 80 00       	mov    0x804154,%eax
  8030f3:	40                   	inc    %eax
  8030f4:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  8030f9:	eb 38                	jmp    803133 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8030fb:	a1 40 41 80 00       	mov    0x804140,%eax
  803100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803103:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803107:	74 07                	je     803110 <insert_sorted_with_merge_freeList+0x7b2>
  803109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310c:	8b 00                	mov    (%eax),%eax
  80310e:	eb 05                	jmp    803115 <insert_sorted_with_merge_freeList+0x7b7>
  803110:	b8 00 00 00 00       	mov    $0x0,%eax
  803115:	a3 40 41 80 00       	mov    %eax,0x804140
  80311a:	a1 40 41 80 00       	mov    0x804140,%eax
  80311f:	85 c0                	test   %eax,%eax
  803121:	0f 85 ef f9 ff ff    	jne    802b16 <insert_sorted_with_merge_freeList+0x1b8>
  803127:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312b:	0f 85 e5 f9 ff ff    	jne    802b16 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803131:	eb 00                	jmp    803133 <insert_sorted_with_merge_freeList+0x7d5>
  803133:	90                   	nop
  803134:	c9                   	leave  
  803135:	c3                   	ret    
  803136:	66 90                	xchg   %ax,%ax

00803138 <__udivdi3>:
  803138:	55                   	push   %ebp
  803139:	57                   	push   %edi
  80313a:	56                   	push   %esi
  80313b:	53                   	push   %ebx
  80313c:	83 ec 1c             	sub    $0x1c,%esp
  80313f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803143:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803147:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80314b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80314f:	89 ca                	mov    %ecx,%edx
  803151:	89 f8                	mov    %edi,%eax
  803153:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803157:	85 f6                	test   %esi,%esi
  803159:	75 2d                	jne    803188 <__udivdi3+0x50>
  80315b:	39 cf                	cmp    %ecx,%edi
  80315d:	77 65                	ja     8031c4 <__udivdi3+0x8c>
  80315f:	89 fd                	mov    %edi,%ebp
  803161:	85 ff                	test   %edi,%edi
  803163:	75 0b                	jne    803170 <__udivdi3+0x38>
  803165:	b8 01 00 00 00       	mov    $0x1,%eax
  80316a:	31 d2                	xor    %edx,%edx
  80316c:	f7 f7                	div    %edi
  80316e:	89 c5                	mov    %eax,%ebp
  803170:	31 d2                	xor    %edx,%edx
  803172:	89 c8                	mov    %ecx,%eax
  803174:	f7 f5                	div    %ebp
  803176:	89 c1                	mov    %eax,%ecx
  803178:	89 d8                	mov    %ebx,%eax
  80317a:	f7 f5                	div    %ebp
  80317c:	89 cf                	mov    %ecx,%edi
  80317e:	89 fa                	mov    %edi,%edx
  803180:	83 c4 1c             	add    $0x1c,%esp
  803183:	5b                   	pop    %ebx
  803184:	5e                   	pop    %esi
  803185:	5f                   	pop    %edi
  803186:	5d                   	pop    %ebp
  803187:	c3                   	ret    
  803188:	39 ce                	cmp    %ecx,%esi
  80318a:	77 28                	ja     8031b4 <__udivdi3+0x7c>
  80318c:	0f bd fe             	bsr    %esi,%edi
  80318f:	83 f7 1f             	xor    $0x1f,%edi
  803192:	75 40                	jne    8031d4 <__udivdi3+0x9c>
  803194:	39 ce                	cmp    %ecx,%esi
  803196:	72 0a                	jb     8031a2 <__udivdi3+0x6a>
  803198:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80319c:	0f 87 9e 00 00 00    	ja     803240 <__udivdi3+0x108>
  8031a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8031a7:	89 fa                	mov    %edi,%edx
  8031a9:	83 c4 1c             	add    $0x1c,%esp
  8031ac:	5b                   	pop    %ebx
  8031ad:	5e                   	pop    %esi
  8031ae:	5f                   	pop    %edi
  8031af:	5d                   	pop    %ebp
  8031b0:	c3                   	ret    
  8031b1:	8d 76 00             	lea    0x0(%esi),%esi
  8031b4:	31 ff                	xor    %edi,%edi
  8031b6:	31 c0                	xor    %eax,%eax
  8031b8:	89 fa                	mov    %edi,%edx
  8031ba:	83 c4 1c             	add    $0x1c,%esp
  8031bd:	5b                   	pop    %ebx
  8031be:	5e                   	pop    %esi
  8031bf:	5f                   	pop    %edi
  8031c0:	5d                   	pop    %ebp
  8031c1:	c3                   	ret    
  8031c2:	66 90                	xchg   %ax,%ax
  8031c4:	89 d8                	mov    %ebx,%eax
  8031c6:	f7 f7                	div    %edi
  8031c8:	31 ff                	xor    %edi,%edi
  8031ca:	89 fa                	mov    %edi,%edx
  8031cc:	83 c4 1c             	add    $0x1c,%esp
  8031cf:	5b                   	pop    %ebx
  8031d0:	5e                   	pop    %esi
  8031d1:	5f                   	pop    %edi
  8031d2:	5d                   	pop    %ebp
  8031d3:	c3                   	ret    
  8031d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031d9:	89 eb                	mov    %ebp,%ebx
  8031db:	29 fb                	sub    %edi,%ebx
  8031dd:	89 f9                	mov    %edi,%ecx
  8031df:	d3 e6                	shl    %cl,%esi
  8031e1:	89 c5                	mov    %eax,%ebp
  8031e3:	88 d9                	mov    %bl,%cl
  8031e5:	d3 ed                	shr    %cl,%ebp
  8031e7:	89 e9                	mov    %ebp,%ecx
  8031e9:	09 f1                	or     %esi,%ecx
  8031eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031ef:	89 f9                	mov    %edi,%ecx
  8031f1:	d3 e0                	shl    %cl,%eax
  8031f3:	89 c5                	mov    %eax,%ebp
  8031f5:	89 d6                	mov    %edx,%esi
  8031f7:	88 d9                	mov    %bl,%cl
  8031f9:	d3 ee                	shr    %cl,%esi
  8031fb:	89 f9                	mov    %edi,%ecx
  8031fd:	d3 e2                	shl    %cl,%edx
  8031ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803203:	88 d9                	mov    %bl,%cl
  803205:	d3 e8                	shr    %cl,%eax
  803207:	09 c2                	or     %eax,%edx
  803209:	89 d0                	mov    %edx,%eax
  80320b:	89 f2                	mov    %esi,%edx
  80320d:	f7 74 24 0c          	divl   0xc(%esp)
  803211:	89 d6                	mov    %edx,%esi
  803213:	89 c3                	mov    %eax,%ebx
  803215:	f7 e5                	mul    %ebp
  803217:	39 d6                	cmp    %edx,%esi
  803219:	72 19                	jb     803234 <__udivdi3+0xfc>
  80321b:	74 0b                	je     803228 <__udivdi3+0xf0>
  80321d:	89 d8                	mov    %ebx,%eax
  80321f:	31 ff                	xor    %edi,%edi
  803221:	e9 58 ff ff ff       	jmp    80317e <__udivdi3+0x46>
  803226:	66 90                	xchg   %ax,%ax
  803228:	8b 54 24 08          	mov    0x8(%esp),%edx
  80322c:	89 f9                	mov    %edi,%ecx
  80322e:	d3 e2                	shl    %cl,%edx
  803230:	39 c2                	cmp    %eax,%edx
  803232:	73 e9                	jae    80321d <__udivdi3+0xe5>
  803234:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803237:	31 ff                	xor    %edi,%edi
  803239:	e9 40 ff ff ff       	jmp    80317e <__udivdi3+0x46>
  80323e:	66 90                	xchg   %ax,%ax
  803240:	31 c0                	xor    %eax,%eax
  803242:	e9 37 ff ff ff       	jmp    80317e <__udivdi3+0x46>
  803247:	90                   	nop

00803248 <__umoddi3>:
  803248:	55                   	push   %ebp
  803249:	57                   	push   %edi
  80324a:	56                   	push   %esi
  80324b:	53                   	push   %ebx
  80324c:	83 ec 1c             	sub    $0x1c,%esp
  80324f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803253:	8b 74 24 34          	mov    0x34(%esp),%esi
  803257:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80325b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80325f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803263:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803267:	89 f3                	mov    %esi,%ebx
  803269:	89 fa                	mov    %edi,%edx
  80326b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80326f:	89 34 24             	mov    %esi,(%esp)
  803272:	85 c0                	test   %eax,%eax
  803274:	75 1a                	jne    803290 <__umoddi3+0x48>
  803276:	39 f7                	cmp    %esi,%edi
  803278:	0f 86 a2 00 00 00    	jbe    803320 <__umoddi3+0xd8>
  80327e:	89 c8                	mov    %ecx,%eax
  803280:	89 f2                	mov    %esi,%edx
  803282:	f7 f7                	div    %edi
  803284:	89 d0                	mov    %edx,%eax
  803286:	31 d2                	xor    %edx,%edx
  803288:	83 c4 1c             	add    $0x1c,%esp
  80328b:	5b                   	pop    %ebx
  80328c:	5e                   	pop    %esi
  80328d:	5f                   	pop    %edi
  80328e:	5d                   	pop    %ebp
  80328f:	c3                   	ret    
  803290:	39 f0                	cmp    %esi,%eax
  803292:	0f 87 ac 00 00 00    	ja     803344 <__umoddi3+0xfc>
  803298:	0f bd e8             	bsr    %eax,%ebp
  80329b:	83 f5 1f             	xor    $0x1f,%ebp
  80329e:	0f 84 ac 00 00 00    	je     803350 <__umoddi3+0x108>
  8032a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8032a9:	29 ef                	sub    %ebp,%edi
  8032ab:	89 fe                	mov    %edi,%esi
  8032ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032b1:	89 e9                	mov    %ebp,%ecx
  8032b3:	d3 e0                	shl    %cl,%eax
  8032b5:	89 d7                	mov    %edx,%edi
  8032b7:	89 f1                	mov    %esi,%ecx
  8032b9:	d3 ef                	shr    %cl,%edi
  8032bb:	09 c7                	or     %eax,%edi
  8032bd:	89 e9                	mov    %ebp,%ecx
  8032bf:	d3 e2                	shl    %cl,%edx
  8032c1:	89 14 24             	mov    %edx,(%esp)
  8032c4:	89 d8                	mov    %ebx,%eax
  8032c6:	d3 e0                	shl    %cl,%eax
  8032c8:	89 c2                	mov    %eax,%edx
  8032ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ce:	d3 e0                	shl    %cl,%eax
  8032d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032d8:	89 f1                	mov    %esi,%ecx
  8032da:	d3 e8                	shr    %cl,%eax
  8032dc:	09 d0                	or     %edx,%eax
  8032de:	d3 eb                	shr    %cl,%ebx
  8032e0:	89 da                	mov    %ebx,%edx
  8032e2:	f7 f7                	div    %edi
  8032e4:	89 d3                	mov    %edx,%ebx
  8032e6:	f7 24 24             	mull   (%esp)
  8032e9:	89 c6                	mov    %eax,%esi
  8032eb:	89 d1                	mov    %edx,%ecx
  8032ed:	39 d3                	cmp    %edx,%ebx
  8032ef:	0f 82 87 00 00 00    	jb     80337c <__umoddi3+0x134>
  8032f5:	0f 84 91 00 00 00    	je     80338c <__umoddi3+0x144>
  8032fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032ff:	29 f2                	sub    %esi,%edx
  803301:	19 cb                	sbb    %ecx,%ebx
  803303:	89 d8                	mov    %ebx,%eax
  803305:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803309:	d3 e0                	shl    %cl,%eax
  80330b:	89 e9                	mov    %ebp,%ecx
  80330d:	d3 ea                	shr    %cl,%edx
  80330f:	09 d0                	or     %edx,%eax
  803311:	89 e9                	mov    %ebp,%ecx
  803313:	d3 eb                	shr    %cl,%ebx
  803315:	89 da                	mov    %ebx,%edx
  803317:	83 c4 1c             	add    $0x1c,%esp
  80331a:	5b                   	pop    %ebx
  80331b:	5e                   	pop    %esi
  80331c:	5f                   	pop    %edi
  80331d:	5d                   	pop    %ebp
  80331e:	c3                   	ret    
  80331f:	90                   	nop
  803320:	89 fd                	mov    %edi,%ebp
  803322:	85 ff                	test   %edi,%edi
  803324:	75 0b                	jne    803331 <__umoddi3+0xe9>
  803326:	b8 01 00 00 00       	mov    $0x1,%eax
  80332b:	31 d2                	xor    %edx,%edx
  80332d:	f7 f7                	div    %edi
  80332f:	89 c5                	mov    %eax,%ebp
  803331:	89 f0                	mov    %esi,%eax
  803333:	31 d2                	xor    %edx,%edx
  803335:	f7 f5                	div    %ebp
  803337:	89 c8                	mov    %ecx,%eax
  803339:	f7 f5                	div    %ebp
  80333b:	89 d0                	mov    %edx,%eax
  80333d:	e9 44 ff ff ff       	jmp    803286 <__umoddi3+0x3e>
  803342:	66 90                	xchg   %ax,%ax
  803344:	89 c8                	mov    %ecx,%eax
  803346:	89 f2                	mov    %esi,%edx
  803348:	83 c4 1c             	add    $0x1c,%esp
  80334b:	5b                   	pop    %ebx
  80334c:	5e                   	pop    %esi
  80334d:	5f                   	pop    %edi
  80334e:	5d                   	pop    %ebp
  80334f:	c3                   	ret    
  803350:	3b 04 24             	cmp    (%esp),%eax
  803353:	72 06                	jb     80335b <__umoddi3+0x113>
  803355:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803359:	77 0f                	ja     80336a <__umoddi3+0x122>
  80335b:	89 f2                	mov    %esi,%edx
  80335d:	29 f9                	sub    %edi,%ecx
  80335f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803363:	89 14 24             	mov    %edx,(%esp)
  803366:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80336a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80336e:	8b 14 24             	mov    (%esp),%edx
  803371:	83 c4 1c             	add    $0x1c,%esp
  803374:	5b                   	pop    %ebx
  803375:	5e                   	pop    %esi
  803376:	5f                   	pop    %edi
  803377:	5d                   	pop    %ebp
  803378:	c3                   	ret    
  803379:	8d 76 00             	lea    0x0(%esi),%esi
  80337c:	2b 04 24             	sub    (%esp),%eax
  80337f:	19 fa                	sbb    %edi,%edx
  803381:	89 d1                	mov    %edx,%ecx
  803383:	89 c6                	mov    %eax,%esi
  803385:	e9 71 ff ff ff       	jmp    8032fb <__umoddi3+0xb3>
  80338a:	66 90                	xchg   %ax,%ax
  80338c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803390:	72 ea                	jb     80337c <__umoddi3+0x134>
  803392:	89 d9                	mov    %ebx,%ecx
  803394:	e9 62 ff ff ff       	jmp    8032fb <__umoddi3+0xb3>
