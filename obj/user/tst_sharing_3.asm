
obj/user/tst_sharing_3:     file format elf32-i386


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
  800031:	e8 8a 02 00 00       	call   8002c0 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the SPECIAL CASES during the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 48             	sub    $0x48,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 50 80 00       	mov    0x805020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 50 80 00       	mov    0x805020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 20 34 80 00       	push   $0x803420
  800091:	6a 12                	push   $0x12
  800093:	68 3c 34 80 00       	push   $0x80343c
  800098:	e8 5f 03 00 00       	call   8003fc <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 a8 15 00 00       	call   80164f <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000aa:	83 ec 0c             	sub    $0xc,%esp
  8000ad:	68 54 34 80 00       	push   $0x803454
  8000b2:	e8 f9 05 00 00       	call   8006b0 <cprintf>
  8000b7:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ba:	83 ec 0c             	sub    $0xc,%esp
  8000bd:	68 88 34 80 00       	push   $0x803488
  8000c2:	e8 e9 05 00 00       	call   8006b0 <cprintf>
  8000c7:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000ca:	83 ec 0c             	sub    $0xc,%esp
  8000cd:	68 e4 34 80 00       	push   $0x8034e4
  8000d2:	e8 d9 05 00 00       	call   8006b0 <cprintf>
  8000d7:	83 c4 10             	add    $0x10,%esp

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking creation of shared object that is already exists... \n\n");
  8000da:	83 ec 0c             	sub    $0xc,%esp
  8000dd:	68 18 35 80 00       	push   $0x803518
  8000e2:	e8 c9 05 00 00       	call   8006b0 <cprintf>
  8000e7:	83 c4 10             	add    $0x10,%esp
	{
		int ret ;
		//int ret = sys_createSharedObject("x", PAGE_SIZE, 1, (void*)&x);
		x = smalloc("x", PAGE_SIZE, 1);
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	6a 01                	push   $0x1
  8000ef:	68 00 10 00 00       	push   $0x1000
  8000f4:	68 60 35 80 00       	push   $0x803560
  8000f9:	e8 cc 16 00 00       	call   8017ca <smalloc>
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	89 45 e8             	mov    %eax,-0x18(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  800104:	e8 e4 19 00 00       	call   801aed <sys_calculate_free_frames>
  800109:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	6a 01                	push   $0x1
  800111:	68 00 10 00 00       	push   $0x1000
  800116:	68 60 35 80 00       	push   $0x803560
  80011b:	e8 aa 16 00 00       	call   8017ca <smalloc>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (x != NULL) panic("Trying to create an already exists object and corresponding error is not returned!!");
  800126:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 64 35 80 00       	push   $0x803564
  800134:	6a 24                	push   $0x24
  800136:	68 3c 34 80 00       	push   $0x80343c
  80013b:	e8 bc 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exists");
  800140:	e8 a8 19 00 00       	call   801aed <sys_calculate_free_frames>
  800145:	89 c2                	mov    %eax,%edx
  800147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014a:	39 c2                	cmp    %eax,%edx
  80014c:	74 14                	je     800162 <_main+0x12a>
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	68 b8 35 80 00       	push   $0x8035b8
  800156:	6a 25                	push   $0x25
  800158:	68 3c 34 80 00       	push   $0x80343c
  80015d:	e8 9a 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP B: checking the creation of shared object that exceeds the SHARED area limit... \n\n");
  800162:	83 ec 0c             	sub    $0xc,%esp
  800165:	68 14 36 80 00       	push   $0x803614
  80016a:	e8 41 05 00 00       	call   8006b0 <cprintf>
  80016f:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  800172:	e8 76 19 00 00       	call   801aed <sys_calculate_free_frames>
  800177:	89 45 e0             	mov    %eax,-0x20(%ebp)
		uint32 size = USER_HEAP_MAX - USER_HEAP_START ;
  80017a:	c7 45 dc 00 00 00 20 	movl   $0x20000000,-0x24(%ebp)
		y = smalloc("y", size, 1);
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	6a 01                	push   $0x1
  800186:	ff 75 dc             	pushl  -0x24(%ebp)
  800189:	68 6c 36 80 00       	push   $0x80366c
  80018e:	e8 37 16 00 00       	call   8017ca <smalloc>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != NULL) panic("Trying to create a shared object that exceed the SHARED area limit and the corresponding error is not returned!!");
  800199:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80019d:	74 14                	je     8001b3 <_main+0x17b>
  80019f:	83 ec 04             	sub    $0x4,%esp
  8001a2:	68 70 36 80 00       	push   $0x803670
  8001a7:	6a 2d                	push   $0x2d
  8001a9:	68 3c 34 80 00       	push   $0x80343c
  8001ae:	e8 49 02 00 00       	call   8003fc <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong allocation: make sure that you don't allocate any memory if the shared object exceed the SHARED area limit");
  8001b3:	e8 35 19 00 00       	call   801aed <sys_calculate_free_frames>
  8001b8:	89 c2                	mov    %eax,%edx
  8001ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001bd:	39 c2                	cmp    %eax,%edx
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 e4 36 80 00       	push   $0x8036e4
  8001c9:	6a 2e                	push   $0x2e
  8001cb:	68 3c 34 80 00       	push   $0x80343c
  8001d0:	e8 27 02 00 00       	call   8003fc <_panic>
	}

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 58 37 80 00       	push   $0x803758
  8001dd:	e8 ce 04 00 00       	call   8006b0 <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
	{
		uint32 maxShares = sys_getMaxShares();
  8001e5:	e8 5c 1b 00 00       	call   801d46 <sys_getMaxShares>
  8001ea:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  8001ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  8001f4:	eb 45                	jmp    80023b <_main+0x203>
		{
			char shareName[10] ;
			ltostr(i, shareName) ;
  8001f6:	83 ec 08             	sub    $0x8,%esp
  8001f9:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  8001fc:	50                   	push   %eax
  8001fd:	ff 75 ec             	pushl  -0x14(%ebp)
  800200:	e8 d3 0f 00 00       	call   8011d8 <ltostr>
  800205:	83 c4 10             	add    $0x10,%esp
			z = smalloc(shareName, 1, 1);
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	6a 01                	push   $0x1
  80020d:	6a 01                	push   $0x1
  80020f:	8d 45 c2             	lea    -0x3e(%ebp),%eax
  800212:	50                   	push   %eax
  800213:	e8 b2 15 00 00       	call   8017ca <smalloc>
  800218:	83 c4 10             	add    $0x10,%esp
  80021b:	89 45 d0             	mov    %eax,-0x30(%ebp)
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
  80021e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800222:	75 14                	jne    800238 <_main+0x200>
  800224:	83 ec 04             	sub    $0x4,%esp
  800227:	68 cc 37 80 00       	push   $0x8037cc
  80022c:	6a 3a                	push   $0x3a
  80022e:	68 3c 34 80 00       	push   $0x80343c
  800233:	e8 c4 01 00 00       	call   8003fc <_panic>

	cprintf("STEP C: checking the creation of a number of shared objects that exceeds the MAX ALLOWED NUMBER of OBJECTS... \n\n");
	{
		uint32 maxShares = sys_getMaxShares();
		int i ;
		for (i = 0 ; i < maxShares - 1; i++)
  800238:	ff 45 ec             	incl   -0x14(%ebp)
  80023b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800241:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800244:	39 c2                	cmp    %eax,%edx
  800246:	77 ae                	ja     8001f6 <_main+0x1be>
			char shareName[10] ;
			ltostr(i, shareName) ;
			z = smalloc(shareName, 1, 1);
			if (z == NULL) panic("WRONG... supposed no problem in creation here!!");
		}
		z = smalloc("outOfBounds", 1, 1);
  800248:	83 ec 04             	sub    $0x4,%esp
  80024b:	6a 01                	push   $0x1
  80024d:	6a 01                	push   $0x1
  80024f:	68 fc 37 80 00       	push   $0x8037fc
  800254:	e8 71 15 00 00       	call   8017ca <smalloc>
  800259:	83 c4 10             	add    $0x10,%esp
  80025c:	89 45 d0             	mov    %eax,-0x30(%ebp)
		uint32 maxShares_after = sys_getMaxShares();
  80025f:	e8 e2 1a 00 00       	call   801d46 <sys_getMaxShares>
  800264:	89 45 cc             	mov    %eax,-0x34(%ebp)
		//if krealloc is NOT invoked to double the size of max shares
		if ((maxShares_after == maxShares) && (z != NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS and the corresponding error is not returned!!");
  800267:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80026a:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
  80026d:	75 1a                	jne    800289 <_main+0x251>
  80026f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800273:	74 14                	je     800289 <_main+0x251>
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	68 08 38 80 00       	push   $0x803808
  80027d:	6a 3f                	push   $0x3f
  80027f:	68 3c 34 80 00       	push   $0x80343c
  800284:	e8 73 01 00 00       	call   8003fc <_panic>
		//else
		if ((maxShares_after == 2*maxShares) && (z == NULL)) panic("Trying to create a shared object that exceed the number of ALLOWED OBJECTS, krealloc should be invoked to double the size of shares array!!");
  800289:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028c:	01 c0                	add    %eax,%eax
  80028e:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800291:	75 1a                	jne    8002ad <_main+0x275>
  800293:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800297:	75 14                	jne    8002ad <_main+0x275>
  800299:	83 ec 04             	sub    $0x4,%esp
  80029c:	68 84 38 80 00       	push   $0x803884
  8002a1:	6a 41                	push   $0x41
  8002a3:	68 3c 34 80 00       	push   $0x80343c
  8002a8:	e8 4f 01 00 00       	call   8003fc <_panic>
	}
	cprintf("Congratulations!! Test of Shared Variables [Create: Special Cases] completed successfully!!\n\n\n");
  8002ad:	83 ec 0c             	sub    $0xc,%esp
  8002b0:	68 10 39 80 00       	push   $0x803910
  8002b5:	e8 f6 03 00 00       	call   8006b0 <cprintf>
  8002ba:	83 c4 10             	add    $0x10,%esp

	return;
  8002bd:	90                   	nop
}
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002c6:	e8 02 1b 00 00       	call   801dcd <sys_getenvindex>
  8002cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002d1:	89 d0                	mov    %edx,%eax
  8002d3:	c1 e0 03             	shl    $0x3,%eax
  8002d6:	01 d0                	add    %edx,%eax
  8002d8:	01 c0                	add    %eax,%eax
  8002da:	01 d0                	add    %edx,%eax
  8002dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e3:	01 d0                	add    %edx,%eax
  8002e5:	c1 e0 04             	shl    $0x4,%eax
  8002e8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002ed:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f7:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002fd:	84 c0                	test   %al,%al
  8002ff:	74 0f                	je     800310 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800301:	a1 20 50 80 00       	mov    0x805020,%eax
  800306:	05 5c 05 00 00       	add    $0x55c,%eax
  80030b:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800310:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800314:	7e 0a                	jle    800320 <libmain+0x60>
		binaryname = argv[0];
  800316:	8b 45 0c             	mov    0xc(%ebp),%eax
  800319:	8b 00                	mov    (%eax),%eax
  80031b:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800320:	83 ec 08             	sub    $0x8,%esp
  800323:	ff 75 0c             	pushl  0xc(%ebp)
  800326:	ff 75 08             	pushl  0x8(%ebp)
  800329:	e8 0a fd ff ff       	call   800038 <_main>
  80032e:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800331:	e8 a4 18 00 00       	call   801bda <sys_disable_interrupt>
	cprintf("**************************************\n");
  800336:	83 ec 0c             	sub    $0xc,%esp
  800339:	68 88 39 80 00       	push   $0x803988
  80033e:	e8 6d 03 00 00       	call   8006b0 <cprintf>
  800343:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800346:	a1 20 50 80 00       	mov    0x805020,%eax
  80034b:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800351:	a1 20 50 80 00       	mov    0x805020,%eax
  800356:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80035c:	83 ec 04             	sub    $0x4,%esp
  80035f:	52                   	push   %edx
  800360:	50                   	push   %eax
  800361:	68 b0 39 80 00       	push   $0x8039b0
  800366:	e8 45 03 00 00       	call   8006b0 <cprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80036e:	a1 20 50 80 00       	mov    0x805020,%eax
  800373:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800379:	a1 20 50 80 00       	mov    0x805020,%eax
  80037e:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800384:	a1 20 50 80 00       	mov    0x805020,%eax
  800389:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80038f:	51                   	push   %ecx
  800390:	52                   	push   %edx
  800391:	50                   	push   %eax
  800392:	68 d8 39 80 00       	push   $0x8039d8
  800397:	e8 14 03 00 00       	call   8006b0 <cprintf>
  80039c:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80039f:	a1 20 50 80 00       	mov    0x805020,%eax
  8003a4:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003aa:	83 ec 08             	sub    $0x8,%esp
  8003ad:	50                   	push   %eax
  8003ae:	68 30 3a 80 00       	push   $0x803a30
  8003b3:	e8 f8 02 00 00       	call   8006b0 <cprintf>
  8003b8:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	68 88 39 80 00       	push   $0x803988
  8003c3:	e8 e8 02 00 00       	call   8006b0 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003cb:	e8 24 18 00 00       	call   801bf4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003d0:	e8 19 00 00 00       	call   8003ee <exit>
}
  8003d5:	90                   	nop
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003de:	83 ec 0c             	sub    $0xc,%esp
  8003e1:	6a 00                	push   $0x0
  8003e3:	e8 b1 19 00 00       	call   801d99 <sys_destroy_env>
  8003e8:	83 c4 10             	add    $0x10,%esp
}
  8003eb:	90                   	nop
  8003ec:	c9                   	leave  
  8003ed:	c3                   	ret    

008003ee <exit>:

void
exit(void)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003f4:	e8 06 1a 00 00       	call   801dff <sys_exit_env>
}
  8003f9:	90                   	nop
  8003fa:	c9                   	leave  
  8003fb:	c3                   	ret    

008003fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003fc:	55                   	push   %ebp
  8003fd:	89 e5                	mov    %esp,%ebp
  8003ff:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800402:	8d 45 10             	lea    0x10(%ebp),%eax
  800405:	83 c0 04             	add    $0x4,%eax
  800408:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80040b:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800410:	85 c0                	test   %eax,%eax
  800412:	74 16                	je     80042a <_panic+0x2e>
		cprintf("%s: ", argv0);
  800414:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	50                   	push   %eax
  80041d:	68 44 3a 80 00       	push   $0x803a44
  800422:	e8 89 02 00 00       	call   8006b0 <cprintf>
  800427:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042a:	a1 00 50 80 00       	mov    0x805000,%eax
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	50                   	push   %eax
  800436:	68 49 3a 80 00       	push   $0x803a49
  80043b:	e8 70 02 00 00       	call   8006b0 <cprintf>
  800440:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800443:	8b 45 10             	mov    0x10(%ebp),%eax
  800446:	83 ec 08             	sub    $0x8,%esp
  800449:	ff 75 f4             	pushl  -0xc(%ebp)
  80044c:	50                   	push   %eax
  80044d:	e8 f3 01 00 00       	call   800645 <vcprintf>
  800452:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800455:	83 ec 08             	sub    $0x8,%esp
  800458:	6a 00                	push   $0x0
  80045a:	68 65 3a 80 00       	push   $0x803a65
  80045f:	e8 e1 01 00 00       	call   800645 <vcprintf>
  800464:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800467:	e8 82 ff ff ff       	call   8003ee <exit>

	// should not return here
	while (1) ;
  80046c:	eb fe                	jmp    80046c <_panic+0x70>

0080046e <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80046e:	55                   	push   %ebp
  80046f:	89 e5                	mov    %esp,%ebp
  800471:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800474:	a1 20 50 80 00       	mov    0x805020,%eax
  800479:	8b 50 74             	mov    0x74(%eax),%edx
  80047c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80047f:	39 c2                	cmp    %eax,%edx
  800481:	74 14                	je     800497 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800483:	83 ec 04             	sub    $0x4,%esp
  800486:	68 68 3a 80 00       	push   $0x803a68
  80048b:	6a 26                	push   $0x26
  80048d:	68 b4 3a 80 00       	push   $0x803ab4
  800492:	e8 65 ff ff ff       	call   8003fc <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800497:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80049e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004a5:	e9 c2 00 00 00       	jmp    80056c <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004ad:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b7:	01 d0                	add    %edx,%eax
  8004b9:	8b 00                	mov    (%eax),%eax
  8004bb:	85 c0                	test   %eax,%eax
  8004bd:	75 08                	jne    8004c7 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004bf:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004c2:	e9 a2 00 00 00       	jmp    800569 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ce:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004d5:	eb 69                	jmp    800540 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004dc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004e2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004e5:	89 d0                	mov    %edx,%eax
  8004e7:	01 c0                	add    %eax,%eax
  8004e9:	01 d0                	add    %edx,%eax
  8004eb:	c1 e0 03             	shl    $0x3,%eax
  8004ee:	01 c8                	add    %ecx,%eax
  8004f0:	8a 40 04             	mov    0x4(%eax),%al
  8004f3:	84 c0                	test   %al,%al
  8004f5:	75 46                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fc:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800502:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800505:	89 d0                	mov    %edx,%eax
  800507:	01 c0                	add    %eax,%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	c1 e0 03             	shl    $0x3,%eax
  80050e:	01 c8                	add    %ecx,%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800515:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800518:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80051d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80051f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800522:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	01 c8                	add    %ecx,%eax
  80052e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800530:	39 c2                	cmp    %eax,%edx
  800532:	75 09                	jne    80053d <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800534:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80053b:	eb 12                	jmp    80054f <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053d:	ff 45 e8             	incl   -0x18(%ebp)
  800540:	a1 20 50 80 00       	mov    0x805020,%eax
  800545:	8b 50 74             	mov    0x74(%eax),%edx
  800548:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80054b:	39 c2                	cmp    %eax,%edx
  80054d:	77 88                	ja     8004d7 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80054f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800553:	75 14                	jne    800569 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	68 c0 3a 80 00       	push   $0x803ac0
  80055d:	6a 3a                	push   $0x3a
  80055f:	68 b4 3a 80 00       	push   $0x803ab4
  800564:	e8 93 fe ff ff       	call   8003fc <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800569:	ff 45 f0             	incl   -0x10(%ebp)
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80056f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800572:	0f 8c 32 ff ff ff    	jl     8004aa <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800578:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80057f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800586:	eb 26                	jmp    8005ae <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800588:	a1 20 50 80 00       	mov    0x805020,%eax
  80058d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800593:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800596:	89 d0                	mov    %edx,%eax
  800598:	01 c0                	add    %eax,%eax
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 03             	shl    $0x3,%eax
  80059f:	01 c8                	add    %ecx,%eax
  8005a1:	8a 40 04             	mov    0x4(%eax),%al
  8005a4:	3c 01                	cmp    $0x1,%al
  8005a6:	75 03                	jne    8005ab <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a8:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ab:	ff 45 e0             	incl   -0x20(%ebp)
  8005ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8005b3:	8b 50 74             	mov    0x74(%eax),%edx
  8005b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b9:	39 c2                	cmp    %eax,%edx
  8005bb:	77 cb                	ja     800588 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005c0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005c3:	74 14                	je     8005d9 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005c5:	83 ec 04             	sub    $0x4,%esp
  8005c8:	68 14 3b 80 00       	push   $0x803b14
  8005cd:	6a 44                	push   $0x44
  8005cf:	68 b4 3a 80 00       	push   $0x803ab4
  8005d4:	e8 23 fe ff ff       	call   8003fc <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d9:	90                   	nop
  8005da:	c9                   	leave  
  8005db:	c3                   	ret    

008005dc <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005dc:	55                   	push   %ebp
  8005dd:	89 e5                	mov    %esp,%ebp
  8005df:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	8d 48 01             	lea    0x1(%eax),%ecx
  8005ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ed:	89 0a                	mov    %ecx,(%edx)
  8005ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8005f2:	88 d1                	mov    %dl,%cl
  8005f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005f7:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	3d ff 00 00 00       	cmp    $0xff,%eax
  800605:	75 2c                	jne    800633 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800607:	a0 24 50 80 00       	mov    0x805024,%al
  80060c:	0f b6 c0             	movzbl %al,%eax
  80060f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800612:	8b 12                	mov    (%edx),%edx
  800614:	89 d1                	mov    %edx,%ecx
  800616:	8b 55 0c             	mov    0xc(%ebp),%edx
  800619:	83 c2 08             	add    $0x8,%edx
  80061c:	83 ec 04             	sub    $0x4,%esp
  80061f:	50                   	push   %eax
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	e8 05 14 00 00       	call   801a2c <sys_cputs>
  800627:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80062a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800633:	8b 45 0c             	mov    0xc(%ebp),%eax
  800636:	8b 40 04             	mov    0x4(%eax),%eax
  800639:	8d 50 01             	lea    0x1(%eax),%edx
  80063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063f:	89 50 04             	mov    %edx,0x4(%eax)
}
  800642:	90                   	nop
  800643:	c9                   	leave  
  800644:	c3                   	ret    

00800645 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800645:	55                   	push   %ebp
  800646:	89 e5                	mov    %esp,%ebp
  800648:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80064e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800655:	00 00 00 
	b.cnt = 0;
  800658:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80065f:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800662:	ff 75 0c             	pushl  0xc(%ebp)
  800665:	ff 75 08             	pushl  0x8(%ebp)
  800668:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80066e:	50                   	push   %eax
  80066f:	68 dc 05 80 00       	push   $0x8005dc
  800674:	e8 11 02 00 00       	call   80088a <vprintfmt>
  800679:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80067c:	a0 24 50 80 00       	mov    0x805024,%al
  800681:	0f b6 c0             	movzbl %al,%eax
  800684:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80068a:	83 ec 04             	sub    $0x4,%esp
  80068d:	50                   	push   %eax
  80068e:	52                   	push   %edx
  80068f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800695:	83 c0 08             	add    $0x8,%eax
  800698:	50                   	push   %eax
  800699:	e8 8e 13 00 00       	call   801a2c <sys_cputs>
  80069e:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8006a1:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8006a8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006ae:	c9                   	leave  
  8006af:	c3                   	ret    

008006b0 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006b6:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8006bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c6:	83 ec 08             	sub    $0x8,%esp
  8006c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8006cc:	50                   	push   %eax
  8006cd:	e8 73 ff ff ff       	call   800645 <vcprintf>
  8006d2:	83 c4 10             	add    $0x10,%esp
  8006d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e3:	e8 f2 14 00 00       	call   801bda <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e8:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	83 ec 08             	sub    $0x8,%esp
  8006f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8006f7:	50                   	push   %eax
  8006f8:	e8 48 ff ff ff       	call   800645 <vcprintf>
  8006fd:	83 c4 10             	add    $0x10,%esp
  800700:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800703:	e8 ec 14 00 00       	call   801bf4 <sys_enable_interrupt>
	return cnt;
  800708:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80070b:	c9                   	leave  
  80070c:	c3                   	ret    

0080070d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	53                   	push   %ebx
  800711:	83 ec 14             	sub    $0x14,%esp
  800714:	8b 45 10             	mov    0x10(%ebp),%eax
  800717:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80071a:	8b 45 14             	mov    0x14(%ebp),%eax
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800720:	8b 45 18             	mov    0x18(%ebp),%eax
  800723:	ba 00 00 00 00       	mov    $0x0,%edx
  800728:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80072b:	77 55                	ja     800782 <printnum+0x75>
  80072d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800730:	72 05                	jb     800737 <printnum+0x2a>
  800732:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800735:	77 4b                	ja     800782 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800737:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80073a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80073d:	8b 45 18             	mov    0x18(%ebp),%eax
  800740:	ba 00 00 00 00       	mov    $0x0,%edx
  800745:	52                   	push   %edx
  800746:	50                   	push   %eax
  800747:	ff 75 f4             	pushl  -0xc(%ebp)
  80074a:	ff 75 f0             	pushl  -0x10(%ebp)
  80074d:	e8 62 2a 00 00       	call   8031b4 <__udivdi3>
  800752:	83 c4 10             	add    $0x10,%esp
  800755:	83 ec 04             	sub    $0x4,%esp
  800758:	ff 75 20             	pushl  0x20(%ebp)
  80075b:	53                   	push   %ebx
  80075c:	ff 75 18             	pushl  0x18(%ebp)
  80075f:	52                   	push   %edx
  800760:	50                   	push   %eax
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	ff 75 08             	pushl  0x8(%ebp)
  800767:	e8 a1 ff ff ff       	call   80070d <printnum>
  80076c:	83 c4 20             	add    $0x20,%esp
  80076f:	eb 1a                	jmp    80078b <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	ff 75 20             	pushl  0x20(%ebp)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	ff d0                	call   *%eax
  80077f:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800782:	ff 4d 1c             	decl   0x1c(%ebp)
  800785:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800789:	7f e6                	jg     800771 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80078b:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80078e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800799:	53                   	push   %ebx
  80079a:	51                   	push   %ecx
  80079b:	52                   	push   %edx
  80079c:	50                   	push   %eax
  80079d:	e8 22 2b 00 00       	call   8032c4 <__umoddi3>
  8007a2:	83 c4 10             	add    $0x10,%esp
  8007a5:	05 74 3d 80 00       	add    $0x803d74,%eax
  8007aa:	8a 00                	mov    (%eax),%al
  8007ac:	0f be c0             	movsbl %al,%eax
  8007af:	83 ec 08             	sub    $0x8,%esp
  8007b2:	ff 75 0c             	pushl  0xc(%ebp)
  8007b5:	50                   	push   %eax
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	ff d0                	call   *%eax
  8007bb:	83 c4 10             	add    $0x10,%esp
}
  8007be:	90                   	nop
  8007bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007cb:	7e 1c                	jle    8007e9 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	8b 00                	mov    (%eax),%eax
  8007d2:	8d 50 08             	lea    0x8(%eax),%edx
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	89 10                	mov    %edx,(%eax)
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	83 e8 08             	sub    $0x8,%eax
  8007e2:	8b 50 04             	mov    0x4(%eax),%edx
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	eb 40                	jmp    800829 <getuint+0x65>
	else if (lflag)
  8007e9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007ed:	74 1e                	je     80080d <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	8d 50 04             	lea    0x4(%eax),%edx
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	89 10                	mov    %edx,(%eax)
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	83 e8 04             	sub    $0x4,%eax
  800804:	8b 00                	mov    (%eax),%eax
  800806:	ba 00 00 00 00       	mov    $0x0,%edx
  80080b:	eb 1c                	jmp    800829 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	8b 00                	mov    (%eax),%eax
  800812:	8d 50 04             	lea    0x4(%eax),%edx
  800815:	8b 45 08             	mov    0x8(%ebp),%eax
  800818:	89 10                	mov    %edx,(%eax)
  80081a:	8b 45 08             	mov    0x8(%ebp),%eax
  80081d:	8b 00                	mov    (%eax),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80082e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800832:	7e 1c                	jle    800850 <getint+0x25>
		return va_arg(*ap, long long);
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	8b 00                	mov    (%eax),%eax
  800839:	8d 50 08             	lea    0x8(%eax),%edx
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	89 10                	mov    %edx,(%eax)
  800841:	8b 45 08             	mov    0x8(%ebp),%eax
  800844:	8b 00                	mov    (%eax),%eax
  800846:	83 e8 08             	sub    $0x8,%eax
  800849:	8b 50 04             	mov    0x4(%eax),%edx
  80084c:	8b 00                	mov    (%eax),%eax
  80084e:	eb 38                	jmp    800888 <getint+0x5d>
	else if (lflag)
  800850:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800854:	74 1a                	je     800870 <getint+0x45>
		return va_arg(*ap, long);
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8b 00                	mov    (%eax),%eax
  80085b:	8d 50 04             	lea    0x4(%eax),%edx
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	89 10                	mov    %edx,(%eax)
  800863:	8b 45 08             	mov    0x8(%ebp),%eax
  800866:	8b 00                	mov    (%eax),%eax
  800868:	83 e8 04             	sub    $0x4,%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	99                   	cltd   
  80086e:	eb 18                	jmp    800888 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	8b 00                	mov    (%eax),%eax
  800875:	8d 50 04             	lea    0x4(%eax),%edx
  800878:	8b 45 08             	mov    0x8(%ebp),%eax
  80087b:	89 10                	mov    %edx,(%eax)
  80087d:	8b 45 08             	mov    0x8(%ebp),%eax
  800880:	8b 00                	mov    (%eax),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax
  800887:	99                   	cltd   
}
  800888:	5d                   	pop    %ebp
  800889:	c3                   	ret    

0080088a <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80088a:	55                   	push   %ebp
  80088b:	89 e5                	mov    %esp,%ebp
  80088d:	56                   	push   %esi
  80088e:	53                   	push   %ebx
  80088f:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800892:	eb 17                	jmp    8008ab <vprintfmt+0x21>
			if (ch == '\0')
  800894:	85 db                	test   %ebx,%ebx
  800896:	0f 84 af 03 00 00    	je     800c4b <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	53                   	push   %ebx
  8008a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a6:	ff d0                	call   *%eax
  8008a8:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ae:	8d 50 01             	lea    0x1(%eax),%edx
  8008b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008b4:	8a 00                	mov    (%eax),%al
  8008b6:	0f b6 d8             	movzbl %al,%ebx
  8008b9:	83 fb 25             	cmp    $0x25,%ebx
  8008bc:	75 d6                	jne    800894 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008d7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	8d 50 01             	lea    0x1(%eax),%edx
  8008e4:	89 55 10             	mov    %edx,0x10(%ebp)
  8008e7:	8a 00                	mov    (%eax),%al
  8008e9:	0f b6 d8             	movzbl %al,%ebx
  8008ec:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008ef:	83 f8 55             	cmp    $0x55,%eax
  8008f2:	0f 87 2b 03 00 00    	ja     800c23 <vprintfmt+0x399>
  8008f8:	8b 04 85 98 3d 80 00 	mov    0x803d98(,%eax,4),%eax
  8008ff:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800901:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800905:	eb d7                	jmp    8008de <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800907:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80090b:	eb d1                	jmp    8008de <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80090d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800914:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800917:	89 d0                	mov    %edx,%eax
  800919:	c1 e0 02             	shl    $0x2,%eax
  80091c:	01 d0                	add    %edx,%eax
  80091e:	01 c0                	add    %eax,%eax
  800920:	01 d8                	add    %ebx,%eax
  800922:	83 e8 30             	sub    $0x30,%eax
  800925:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800928:	8b 45 10             	mov    0x10(%ebp),%eax
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800930:	83 fb 2f             	cmp    $0x2f,%ebx
  800933:	7e 3e                	jle    800973 <vprintfmt+0xe9>
  800935:	83 fb 39             	cmp    $0x39,%ebx
  800938:	7f 39                	jg     800973 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80093a:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80093d:	eb d5                	jmp    800914 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80093f:	8b 45 14             	mov    0x14(%ebp),%eax
  800942:	83 c0 04             	add    $0x4,%eax
  800945:	89 45 14             	mov    %eax,0x14(%ebp)
  800948:	8b 45 14             	mov    0x14(%ebp),%eax
  80094b:	83 e8 04             	sub    $0x4,%eax
  80094e:	8b 00                	mov    (%eax),%eax
  800950:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800953:	eb 1f                	jmp    800974 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800955:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800959:	79 83                	jns    8008de <vprintfmt+0x54>
				width = 0;
  80095b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800962:	e9 77 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800967:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80096e:	e9 6b ff ff ff       	jmp    8008de <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800973:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800974:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800978:	0f 89 60 ff ff ff    	jns    8008de <vprintfmt+0x54>
				width = precision, precision = -1;
  80097e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800981:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800984:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80098b:	e9 4e ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800990:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800993:	e9 46 ff ff ff       	jmp    8008de <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800998:	8b 45 14             	mov    0x14(%ebp),%eax
  80099b:	83 c0 04             	add    $0x4,%eax
  80099e:	89 45 14             	mov    %eax,0x14(%ebp)
  8009a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	50                   	push   %eax
  8009b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b3:	ff d0                	call   *%eax
  8009b5:	83 c4 10             	add    $0x10,%esp
			break;
  8009b8:	e9 89 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c0:	83 c0 04             	add    $0x4,%eax
  8009c3:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c9:	83 e8 04             	sub    $0x4,%eax
  8009cc:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009ce:	85 db                	test   %ebx,%ebx
  8009d0:	79 02                	jns    8009d4 <vprintfmt+0x14a>
				err = -err;
  8009d2:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009d4:	83 fb 64             	cmp    $0x64,%ebx
  8009d7:	7f 0b                	jg     8009e4 <vprintfmt+0x15a>
  8009d9:	8b 34 9d e0 3b 80 00 	mov    0x803be0(,%ebx,4),%esi
  8009e0:	85 f6                	test   %esi,%esi
  8009e2:	75 19                	jne    8009fd <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009e4:	53                   	push   %ebx
  8009e5:	68 85 3d 80 00       	push   $0x803d85
  8009ea:	ff 75 0c             	pushl  0xc(%ebp)
  8009ed:	ff 75 08             	pushl  0x8(%ebp)
  8009f0:	e8 5e 02 00 00       	call   800c53 <printfmt>
  8009f5:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f8:	e9 49 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009fd:	56                   	push   %esi
  8009fe:	68 8e 3d 80 00       	push   $0x803d8e
  800a03:	ff 75 0c             	pushl  0xc(%ebp)
  800a06:	ff 75 08             	pushl  0x8(%ebp)
  800a09:	e8 45 02 00 00       	call   800c53 <printfmt>
  800a0e:	83 c4 10             	add    $0x10,%esp
			break;
  800a11:	e9 30 02 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a16:	8b 45 14             	mov    0x14(%ebp),%eax
  800a19:	83 c0 04             	add    $0x4,%eax
  800a1c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 e8 04             	sub    $0x4,%eax
  800a25:	8b 30                	mov    (%eax),%esi
  800a27:	85 f6                	test   %esi,%esi
  800a29:	75 05                	jne    800a30 <vprintfmt+0x1a6>
				p = "(null)";
  800a2b:	be 91 3d 80 00       	mov    $0x803d91,%esi
			if (width > 0 && padc != '-')
  800a30:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a34:	7e 6d                	jle    800aa3 <vprintfmt+0x219>
  800a36:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a3a:	74 67                	je     800aa3 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a3f:	83 ec 08             	sub    $0x8,%esp
  800a42:	50                   	push   %eax
  800a43:	56                   	push   %esi
  800a44:	e8 0c 03 00 00       	call   800d55 <strnlen>
  800a49:	83 c4 10             	add    $0x10,%esp
  800a4c:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a4f:	eb 16                	jmp    800a67 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a51:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 0c             	pushl  0xc(%ebp)
  800a5b:	50                   	push   %eax
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a64:	ff 4d e4             	decl   -0x1c(%ebp)
  800a67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6b:	7f e4                	jg     800a51 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a6d:	eb 34                	jmp    800aa3 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a73:	74 1c                	je     800a91 <vprintfmt+0x207>
  800a75:	83 fb 1f             	cmp    $0x1f,%ebx
  800a78:	7e 05                	jle    800a7f <vprintfmt+0x1f5>
  800a7a:	83 fb 7e             	cmp    $0x7e,%ebx
  800a7d:	7e 12                	jle    800a91 <vprintfmt+0x207>
					putch('?', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 3f                	push   $0x3f
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
  800a8f:	eb 0f                	jmp    800aa0 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a91:	83 ec 08             	sub    $0x8,%esp
  800a94:	ff 75 0c             	pushl  0xc(%ebp)
  800a97:	53                   	push   %ebx
  800a98:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9b:	ff d0                	call   *%eax
  800a9d:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aa0:	ff 4d e4             	decl   -0x1c(%ebp)
  800aa3:	89 f0                	mov    %esi,%eax
  800aa5:	8d 70 01             	lea    0x1(%eax),%esi
  800aa8:	8a 00                	mov    (%eax),%al
  800aaa:	0f be d8             	movsbl %al,%ebx
  800aad:	85 db                	test   %ebx,%ebx
  800aaf:	74 24                	je     800ad5 <vprintfmt+0x24b>
  800ab1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab5:	78 b8                	js     800a6f <vprintfmt+0x1e5>
  800ab7:	ff 4d e0             	decl   -0x20(%ebp)
  800aba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800abe:	79 af                	jns    800a6f <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ac0:	eb 13                	jmp    800ad5 <vprintfmt+0x24b>
				putch(' ', putdat);
  800ac2:	83 ec 08             	sub    $0x8,%esp
  800ac5:	ff 75 0c             	pushl  0xc(%ebp)
  800ac8:	6a 20                	push   $0x20
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	ff d0                	call   *%eax
  800acf:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad2:	ff 4d e4             	decl   -0x1c(%ebp)
  800ad5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad9:	7f e7                	jg     800ac2 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800adb:	e9 66 01 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ae0:	83 ec 08             	sub    $0x8,%esp
  800ae3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ae6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae9:	50                   	push   %eax
  800aea:	e8 3c fd ff ff       	call   80082b <getint>
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800afe:	85 d2                	test   %edx,%edx
  800b00:	79 23                	jns    800b25 <vprintfmt+0x29b>
				putch('-', putdat);
  800b02:	83 ec 08             	sub    $0x8,%esp
  800b05:	ff 75 0c             	pushl  0xc(%ebp)
  800b08:	6a 2d                	push   $0x2d
  800b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0d:	ff d0                	call   *%eax
  800b0f:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b18:	f7 d8                	neg    %eax
  800b1a:	83 d2 00             	adc    $0x0,%edx
  800b1d:	f7 da                	neg    %edx
  800b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b25:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b2c:	e9 bc 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b31:	83 ec 08             	sub    $0x8,%esp
  800b34:	ff 75 e8             	pushl  -0x18(%ebp)
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
  800b3a:	50                   	push   %eax
  800b3b:	e8 84 fc ff ff       	call   8007c4 <getuint>
  800b40:	83 c4 10             	add    $0x10,%esp
  800b43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b46:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b49:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b50:	e9 98 00 00 00       	jmp    800bed <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b55:	83 ec 08             	sub    $0x8,%esp
  800b58:	ff 75 0c             	pushl  0xc(%ebp)
  800b5b:	6a 58                	push   $0x58
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	ff d0                	call   *%eax
  800b62:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b65:	83 ec 08             	sub    $0x8,%esp
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	6a 58                	push   $0x58
  800b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b70:	ff d0                	call   *%eax
  800b72:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b75:	83 ec 08             	sub    $0x8,%esp
  800b78:	ff 75 0c             	pushl  0xc(%ebp)
  800b7b:	6a 58                	push   $0x58
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	ff d0                	call   *%eax
  800b82:	83 c4 10             	add    $0x10,%esp
			break;
  800b85:	e9 bc 00 00 00       	jmp    800c46 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b8a:	83 ec 08             	sub    $0x8,%esp
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	6a 30                	push   $0x30
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	ff d0                	call   *%eax
  800b97:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b9a:	83 ec 08             	sub    $0x8,%esp
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	6a 78                	push   $0x78
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	ff d0                	call   *%eax
  800ba7:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800baa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bad:	83 c0 04             	add    $0x4,%eax
  800bb0:	89 45 14             	mov    %eax,0x14(%ebp)
  800bb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800bb6:	83 e8 04             	sub    $0x4,%eax
  800bb9:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bc5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bcc:	eb 1f                	jmp    800bed <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 e7 fb ff ff       	call   8007c4 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800be6:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bed:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bf4:	83 ec 04             	sub    $0x4,%esp
  800bf7:	52                   	push   %edx
  800bf8:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bfb:	50                   	push   %eax
  800bfc:	ff 75 f4             	pushl  -0xc(%ebp)
  800bff:	ff 75 f0             	pushl  -0x10(%ebp)
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 00 fb ff ff       	call   80070d <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
			break;
  800c10:	eb 34                	jmp    800c46 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	53                   	push   %ebx
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	ff d0                	call   *%eax
  800c1e:	83 c4 10             	add    $0x10,%esp
			break;
  800c21:	eb 23                	jmp    800c46 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c23:	83 ec 08             	sub    $0x8,%esp
  800c26:	ff 75 0c             	pushl  0xc(%ebp)
  800c29:	6a 25                	push   $0x25
  800c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2e:	ff d0                	call   *%eax
  800c30:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c33:	ff 4d 10             	decl   0x10(%ebp)
  800c36:	eb 03                	jmp    800c3b <vprintfmt+0x3b1>
  800c38:	ff 4d 10             	decl   0x10(%ebp)
  800c3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3e:	48                   	dec    %eax
  800c3f:	8a 00                	mov    (%eax),%al
  800c41:	3c 25                	cmp    $0x25,%al
  800c43:	75 f3                	jne    800c38 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c45:	90                   	nop
		}
	}
  800c46:	e9 47 fc ff ff       	jmp    800892 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c4b:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c59:	8d 45 10             	lea    0x10(%ebp),%eax
  800c5c:	83 c0 04             	add    $0x4,%eax
  800c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c62:	8b 45 10             	mov    0x10(%ebp),%eax
  800c65:	ff 75 f4             	pushl  -0xc(%ebp)
  800c68:	50                   	push   %eax
  800c69:	ff 75 0c             	pushl  0xc(%ebp)
  800c6c:	ff 75 08             	pushl  0x8(%ebp)
  800c6f:	e8 16 fc ff ff       	call   80088a <vprintfmt>
  800c74:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c77:	90                   	nop
  800c78:	c9                   	leave  
  800c79:	c3                   	ret    

00800c7a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c7a:	55                   	push   %ebp
  800c7b:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c80:	8b 40 08             	mov    0x8(%eax),%eax
  800c83:	8d 50 01             	lea    0x1(%eax),%edx
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8f:	8b 10                	mov    (%eax),%edx
  800c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c94:	8b 40 04             	mov    0x4(%eax),%eax
  800c97:	39 c2                	cmp    %eax,%edx
  800c99:	73 12                	jae    800cad <sprintputch+0x33>
		*b->buf++ = ch;
  800c9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	8d 48 01             	lea    0x1(%eax),%ecx
  800ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca6:	89 0a                	mov    %ecx,(%edx)
  800ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cab:	88 10                	mov    %dl,(%eax)
}
  800cad:	90                   	nop
  800cae:	5d                   	pop    %ebp
  800caf:	c3                   	ret    

00800cb0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	01 d0                	add    %edx,%eax
  800cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cd5:	74 06                	je     800cdd <vsnprintf+0x2d>
  800cd7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdb:	7f 07                	jg     800ce4 <vsnprintf+0x34>
		return -E_INVAL;
  800cdd:	b8 03 00 00 00       	mov    $0x3,%eax
  800ce2:	eb 20                	jmp    800d04 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ce4:	ff 75 14             	pushl  0x14(%ebp)
  800ce7:	ff 75 10             	pushl  0x10(%ebp)
  800cea:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	68 7a 0c 80 00       	push   $0x800c7a
  800cf3:	e8 92 fb ff ff       	call   80088a <vprintfmt>
  800cf8:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cfe:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d04:	c9                   	leave  
  800d05:	c3                   	ret    

00800d06 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800d0f:	83 c0 04             	add    $0x4,%eax
  800d12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1b:	50                   	push   %eax
  800d1c:	ff 75 0c             	pushl  0xc(%ebp)
  800d1f:	ff 75 08             	pushl  0x8(%ebp)
  800d22:	e8 89 ff ff ff       	call   800cb0 <vsnprintf>
  800d27:	83 c4 10             	add    $0x10,%esp
  800d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d3f:	eb 06                	jmp    800d47 <strlen+0x15>
		n++;
  800d41:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d44:	ff 45 08             	incl   0x8(%ebp)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	84 c0                	test   %al,%al
  800d4e:	75 f1                	jne    800d41 <strlen+0xf>
		n++;
	return n;
  800d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d53:	c9                   	leave  
  800d54:	c3                   	ret    

00800d55 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d62:	eb 09                	jmp    800d6d <strnlen+0x18>
		n++;
  800d64:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	ff 4d 0c             	decl   0xc(%ebp)
  800d6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d71:	74 09                	je     800d7c <strnlen+0x27>
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	75 e8                	jne    800d64 <strnlen+0xf>
		n++;
	return n;
  800d7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d7f:	c9                   	leave  
  800d80:	c3                   	ret    

00800d81 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d87:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d8d:	90                   	nop
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	8d 50 01             	lea    0x1(%eax),%edx
  800d94:	89 55 08             	mov    %edx,0x8(%ebp)
  800d97:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d9d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800da0:	8a 12                	mov    (%edx),%dl
  800da2:	88 10                	mov    %dl,(%eax)
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	84 c0                	test   %al,%al
  800da8:	75 e4                	jne    800d8e <strcpy+0xd>
		/* do nothing */;
	return ret;
  800daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800dbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dc2:	eb 1f                	jmp    800de3 <strncpy+0x34>
		*dst++ = *src;
  800dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc7:	8d 50 01             	lea    0x1(%eax),%edx
  800dca:	89 55 08             	mov    %edx,0x8(%ebp)
  800dcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd0:	8a 12                	mov    (%edx),%dl
  800dd2:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	84 c0                	test   %al,%al
  800ddb:	74 03                	je     800de0 <strncpy+0x31>
			src++;
  800ddd:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800de0:	ff 45 fc             	incl   -0x4(%ebp)
  800de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800de6:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de9:	72 d9                	jb     800dc4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800deb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800dee:	c9                   	leave  
  800def:	c3                   	ret    

00800df0 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800dfc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e00:	74 30                	je     800e32 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e02:	eb 16                	jmp    800e1a <strlcpy+0x2a>
			*dst++ = *src++;
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	8d 50 01             	lea    0x1(%eax),%edx
  800e0a:	89 55 08             	mov    %edx,0x8(%ebp)
  800e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e10:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e13:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e16:	8a 12                	mov    (%edx),%dl
  800e18:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e1a:	ff 4d 10             	decl   0x10(%ebp)
  800e1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e21:	74 09                	je     800e2c <strlcpy+0x3c>
  800e23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e26:	8a 00                	mov    (%eax),%al
  800e28:	84 c0                	test   %al,%al
  800e2a:	75 d8                	jne    800e04 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e32:	8b 55 08             	mov    0x8(%ebp),%edx
  800e35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e38:	29 c2                	sub    %eax,%edx
  800e3a:	89 d0                	mov    %edx,%eax
}
  800e3c:	c9                   	leave  
  800e3d:	c3                   	ret    

00800e3e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e41:	eb 06                	jmp    800e49 <strcmp+0xb>
		p++, q++;
  800e43:	ff 45 08             	incl   0x8(%ebp)
  800e46:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	8a 00                	mov    (%eax),%al
  800e4e:	84 c0                	test   %al,%al
  800e50:	74 0e                	je     800e60 <strcmp+0x22>
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 10                	mov    (%eax),%dl
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	38 c2                	cmp    %al,%dl
  800e5e:	74 e3                	je     800e43 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e60:	8b 45 08             	mov    0x8(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 d0             	movzbl %al,%edx
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	8a 00                	mov    (%eax),%al
  800e6d:	0f b6 c0             	movzbl %al,%eax
  800e70:	29 c2                	sub    %eax,%edx
  800e72:	89 d0                	mov    %edx,%eax
}
  800e74:	5d                   	pop    %ebp
  800e75:	c3                   	ret    

00800e76 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e79:	eb 09                	jmp    800e84 <strncmp+0xe>
		n--, p++, q++;
  800e7b:	ff 4d 10             	decl   0x10(%ebp)
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e88:	74 17                	je     800ea1 <strncmp+0x2b>
  800e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	84 c0                	test   %al,%al
  800e91:	74 0e                	je     800ea1 <strncmp+0x2b>
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	8a 10                	mov    (%eax),%dl
  800e98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9b:	8a 00                	mov    (%eax),%al
  800e9d:	38 c2                	cmp    %al,%dl
  800e9f:	74 da                	je     800e7b <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800ea1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ea5:	75 07                	jne    800eae <strncmp+0x38>
		return 0;
  800ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  800eac:	eb 14                	jmp    800ec2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 d0             	movzbl %al,%edx
  800eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb9:	8a 00                	mov    (%eax),%al
  800ebb:	0f b6 c0             	movzbl %al,%eax
  800ebe:	29 c2                	sub    %eax,%edx
  800ec0:	89 d0                	mov    %edx,%eax
}
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ecd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ed0:	eb 12                	jmp    800ee4 <strchr+0x20>
		if (*s == c)
  800ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed5:	8a 00                	mov    (%eax),%al
  800ed7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eda:	75 05                	jne    800ee1 <strchr+0x1d>
			return (char *) s;
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	eb 11                	jmp    800ef2 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ee1:	ff 45 08             	incl   0x8(%ebp)
  800ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	84 c0                	test   %al,%al
  800eeb:	75 e5                	jne    800ed2 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef2:	c9                   	leave  
  800ef3:	c3                   	ret    

00800ef4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef4:	55                   	push   %ebp
  800ef5:	89 e5                	mov    %esp,%ebp
  800ef7:	83 ec 04             	sub    $0x4,%esp
  800efa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f00:	eb 0d                	jmp    800f0f <strfind+0x1b>
		if (*s == c)
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8a 00                	mov    (%eax),%al
  800f07:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f0a:	74 0e                	je     800f1a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f0c:	ff 45 08             	incl   0x8(%ebp)
  800f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	84 c0                	test   %al,%al
  800f16:	75 ea                	jne    800f02 <strfind+0xe>
  800f18:	eb 01                	jmp    800f1b <strfind+0x27>
		if (*s == c)
			break;
  800f1a:	90                   	nop
	return (char *) s;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f32:	eb 0e                	jmp    800f42 <memset+0x22>
		*p++ = c;
  800f34:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f37:	8d 50 01             	lea    0x1(%eax),%edx
  800f3a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f40:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f42:	ff 4d f8             	decl   -0x8(%ebp)
  800f45:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f49:	79 e9                	jns    800f34 <memset+0x14>
		*p++ = c;

	return v;
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4e:	c9                   	leave  
  800f4f:	c3                   	ret    

00800f50 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f62:	eb 16                	jmp    800f7a <memcpy+0x2a>
		*d++ = *s++;
  800f64:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f67:	8d 50 01             	lea    0x1(%eax),%edx
  800f6a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f70:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f73:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f76:	8a 12                	mov    (%edx),%dl
  800f78:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f80:	89 55 10             	mov    %edx,0x10(%ebp)
  800f83:	85 c0                	test   %eax,%eax
  800f85:	75 dd                	jne    800f64 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fa1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa4:	73 50                	jae    800ff6 <memmove+0x6a>
  800fa6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fac:	01 d0                	add    %edx,%eax
  800fae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fb1:	76 43                	jbe    800ff6 <memmove+0x6a>
		s += n;
  800fb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbc:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fbf:	eb 10                	jmp    800fd1 <memmove+0x45>
			*--d = *--s;
  800fc1:	ff 4d f8             	decl   -0x8(%ebp)
  800fc4:	ff 4d fc             	decl   -0x4(%ebp)
  800fc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fca:	8a 10                	mov    (%eax),%dl
  800fcc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fcf:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fd7:	89 55 10             	mov    %edx,0x10(%ebp)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	75 e3                	jne    800fc1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fde:	eb 23                	jmp    801003 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fe0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fe3:	8d 50 01             	lea    0x1(%eax),%edx
  800fe6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fec:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fef:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ff2:	8a 12                	mov    (%edx),%dl
  800ff4:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ff6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ffc:	89 55 10             	mov    %edx,0x10(%ebp)
  800fff:	85 c0                	test   %eax,%eax
  801001:	75 dd                	jne    800fe0 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801006:	c9                   	leave  
  801007:	c3                   	ret    

00801008 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801014:	8b 45 0c             	mov    0xc(%ebp),%eax
  801017:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80101a:	eb 2a                	jmp    801046 <memcmp+0x3e>
		if (*s1 != *s2)
  80101c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101f:	8a 10                	mov    (%eax),%dl
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	8a 00                	mov    (%eax),%al
  801026:	38 c2                	cmp    %al,%dl
  801028:	74 16                	je     801040 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80102a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 d0             	movzbl %al,%edx
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	0f b6 c0             	movzbl %al,%eax
  80103a:	29 c2                	sub    %eax,%edx
  80103c:	89 d0                	mov    %edx,%eax
  80103e:	eb 18                	jmp    801058 <memcmp+0x50>
		s1++, s2++;
  801040:	ff 45 fc             	incl   -0x4(%ebp)
  801043:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	8d 50 ff             	lea    -0x1(%eax),%edx
  80104c:	89 55 10             	mov    %edx,0x10(%ebp)
  80104f:	85 c0                	test   %eax,%eax
  801051:	75 c9                	jne    80101c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801053:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801058:	c9                   	leave  
  801059:	c3                   	ret    

0080105a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80105a:	55                   	push   %ebp
  80105b:	89 e5                	mov    %esp,%ebp
  80105d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	8b 45 10             	mov    0x10(%ebp),%eax
  801066:	01 d0                	add    %edx,%eax
  801068:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80106b:	eb 15                	jmp    801082 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	0f b6 d0             	movzbl %al,%edx
  801075:	8b 45 0c             	mov    0xc(%ebp),%eax
  801078:	0f b6 c0             	movzbl %al,%eax
  80107b:	39 c2                	cmp    %eax,%edx
  80107d:	74 0d                	je     80108c <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80107f:	ff 45 08             	incl   0x8(%ebp)
  801082:	8b 45 08             	mov    0x8(%ebp),%eax
  801085:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801088:	72 e3                	jb     80106d <memfind+0x13>
  80108a:	eb 01                	jmp    80108d <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80108c:	90                   	nop
	return (void *) s;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a6:	eb 03                	jmp    8010ab <strtol+0x19>
		s++;
  8010a8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	8a 00                	mov    (%eax),%al
  8010b0:	3c 20                	cmp    $0x20,%al
  8010b2:	74 f4                	je     8010a8 <strtol+0x16>
  8010b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b7:	8a 00                	mov    (%eax),%al
  8010b9:	3c 09                	cmp    $0x9,%al
  8010bb:	74 eb                	je     8010a8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c0:	8a 00                	mov    (%eax),%al
  8010c2:	3c 2b                	cmp    $0x2b,%al
  8010c4:	75 05                	jne    8010cb <strtol+0x39>
		s++;
  8010c6:	ff 45 08             	incl   0x8(%ebp)
  8010c9:	eb 13                	jmp    8010de <strtol+0x4c>
	else if (*s == '-')
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 2d                	cmp    $0x2d,%al
  8010d2:	75 0a                	jne    8010de <strtol+0x4c>
		s++, neg = 1;
  8010d4:	ff 45 08             	incl   0x8(%ebp)
  8010d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e2:	74 06                	je     8010ea <strtol+0x58>
  8010e4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e8:	75 20                	jne    80110a <strtol+0x78>
  8010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	3c 30                	cmp    $0x30,%al
  8010f1:	75 17                	jne    80110a <strtol+0x78>
  8010f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f6:	40                   	inc    %eax
  8010f7:	8a 00                	mov    (%eax),%al
  8010f9:	3c 78                	cmp    $0x78,%al
  8010fb:	75 0d                	jne    80110a <strtol+0x78>
		s += 2, base = 16;
  8010fd:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801101:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801108:	eb 28                	jmp    801132 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80110a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80110e:	75 15                	jne    801125 <strtol+0x93>
  801110:	8b 45 08             	mov    0x8(%ebp),%eax
  801113:	8a 00                	mov    (%eax),%al
  801115:	3c 30                	cmp    $0x30,%al
  801117:	75 0c                	jne    801125 <strtol+0x93>
		s++, base = 8;
  801119:	ff 45 08             	incl   0x8(%ebp)
  80111c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801123:	eb 0d                	jmp    801132 <strtol+0xa0>
	else if (base == 0)
  801125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801129:	75 07                	jne    801132 <strtol+0xa0>
		base = 10;
  80112b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801132:	8b 45 08             	mov    0x8(%ebp),%eax
  801135:	8a 00                	mov    (%eax),%al
  801137:	3c 2f                	cmp    $0x2f,%al
  801139:	7e 19                	jle    801154 <strtol+0xc2>
  80113b:	8b 45 08             	mov    0x8(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	3c 39                	cmp    $0x39,%al
  801142:	7f 10                	jg     801154 <strtol+0xc2>
			dig = *s - '0';
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
  801147:	8a 00                	mov    (%eax),%al
  801149:	0f be c0             	movsbl %al,%eax
  80114c:	83 e8 30             	sub    $0x30,%eax
  80114f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801152:	eb 42                	jmp    801196 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	3c 60                	cmp    $0x60,%al
  80115b:	7e 19                	jle    801176 <strtol+0xe4>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	3c 7a                	cmp    $0x7a,%al
  801164:	7f 10                	jg     801176 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 00                	mov    (%eax),%al
  80116b:	0f be c0             	movsbl %al,%eax
  80116e:	83 e8 57             	sub    $0x57,%eax
  801171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801174:	eb 20                	jmp    801196 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801176:	8b 45 08             	mov    0x8(%ebp),%eax
  801179:	8a 00                	mov    (%eax),%al
  80117b:	3c 40                	cmp    $0x40,%al
  80117d:	7e 39                	jle    8011b8 <strtol+0x126>
  80117f:	8b 45 08             	mov    0x8(%ebp),%eax
  801182:	8a 00                	mov    (%eax),%al
  801184:	3c 5a                	cmp    $0x5a,%al
  801186:	7f 30                	jg     8011b8 <strtol+0x126>
			dig = *s - 'A' + 10;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	8a 00                	mov    (%eax),%al
  80118d:	0f be c0             	movsbl %al,%eax
  801190:	83 e8 37             	sub    $0x37,%eax
  801193:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801199:	3b 45 10             	cmp    0x10(%ebp),%eax
  80119c:	7d 19                	jge    8011b7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80119e:	ff 45 08             	incl   0x8(%ebp)
  8011a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011a4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a8:	89 c2                	mov    %eax,%edx
  8011aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ad:	01 d0                	add    %edx,%eax
  8011af:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011b2:	e9 7b ff ff ff       	jmp    801132 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011b7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011bc:	74 08                	je     8011c6 <strtol+0x134>
		*endptr = (char *) s;
  8011be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011c6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011ca:	74 07                	je     8011d3 <strtol+0x141>
  8011cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011cf:	f7 d8                	neg    %eax
  8011d1:	eb 03                	jmp    8011d6 <strtol+0x144>
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    

008011d8 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011e5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011f0:	79 13                	jns    801205 <ltostr+0x2d>
	{
		neg = 1;
  8011f2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fc:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ff:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801202:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801205:	8b 45 08             	mov    0x8(%ebp),%eax
  801208:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80120d:	99                   	cltd   
  80120e:	f7 f9                	idiv   %ecx
  801210:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801213:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801216:	8d 50 01             	lea    0x1(%eax),%edx
  801219:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80121c:	89 c2                	mov    %eax,%edx
  80121e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801221:	01 d0                	add    %edx,%eax
  801223:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801226:	83 c2 30             	add    $0x30,%edx
  801229:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80122b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80122e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801233:	f7 e9                	imul   %ecx
  801235:	c1 fa 02             	sar    $0x2,%edx
  801238:	89 c8                	mov    %ecx,%eax
  80123a:	c1 f8 1f             	sar    $0x1f,%eax
  80123d:	29 c2                	sub    %eax,%edx
  80123f:	89 d0                	mov    %edx,%eax
  801241:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801244:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801247:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80124c:	f7 e9                	imul   %ecx
  80124e:	c1 fa 02             	sar    $0x2,%edx
  801251:	89 c8                	mov    %ecx,%eax
  801253:	c1 f8 1f             	sar    $0x1f,%eax
  801256:	29 c2                	sub    %eax,%edx
  801258:	89 d0                	mov    %edx,%eax
  80125a:	c1 e0 02             	shl    $0x2,%eax
  80125d:	01 d0                	add    %edx,%eax
  80125f:	01 c0                	add    %eax,%eax
  801261:	29 c1                	sub    %eax,%ecx
  801263:	89 ca                	mov    %ecx,%edx
  801265:	85 d2                	test   %edx,%edx
  801267:	75 9c                	jne    801205 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801273:	48                   	dec    %eax
  801274:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801277:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80127b:	74 3d                	je     8012ba <ltostr+0xe2>
		start = 1 ;
  80127d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801284:	eb 34                	jmp    8012ba <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801286:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	01 d0                	add    %edx,%eax
  80128e:	8a 00                	mov    (%eax),%al
  801290:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c2                	add    %eax,%edx
  80129b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80129e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a1:	01 c8                	add    %ecx,%eax
  8012a3:	8a 00                	mov    (%eax),%al
  8012a5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8012a7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012b2:	88 02                	mov    %al,(%edx)
		start++ ;
  8012b4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012b7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c0:	7c c4                	jl     801286 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c8:	01 d0                	add    %edx,%eax
  8012ca:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012cd:	90                   	nop
  8012ce:	c9                   	leave  
  8012cf:	c3                   	ret    

008012d0 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	e8 54 fa ff ff       	call   800d32 <strlen>
  8012de:	83 c4 04             	add    $0x4,%esp
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012e4:	ff 75 0c             	pushl  0xc(%ebp)
  8012e7:	e8 46 fa ff ff       	call   800d32 <strlen>
  8012ec:	83 c4 04             	add    $0x4,%esp
  8012ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801300:	eb 17                	jmp    801319 <strcconcat+0x49>
		final[s] = str1[s] ;
  801302:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801305:	8b 45 10             	mov    0x10(%ebp),%eax
  801308:	01 c2                	add    %eax,%edx
  80130a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80130d:	8b 45 08             	mov    0x8(%ebp),%eax
  801310:	01 c8                	add    %ecx,%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801316:	ff 45 fc             	incl   -0x4(%ebp)
  801319:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80131c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80131f:	7c e1                	jl     801302 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801321:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801328:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80132f:	eb 1f                	jmp    801350 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	8d 50 01             	lea    0x1(%eax),%edx
  801337:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80133a:	89 c2                	mov    %eax,%edx
  80133c:	8b 45 10             	mov    0x10(%ebp),%eax
  80133f:	01 c2                	add    %eax,%edx
  801341:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801344:	8b 45 0c             	mov    0xc(%ebp),%eax
  801347:	01 c8                	add    %ecx,%eax
  801349:	8a 00                	mov    (%eax),%al
  80134b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80134d:	ff 45 f8             	incl   -0x8(%ebp)
  801350:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801353:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801356:	7c d9                	jl     801331 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801358:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80135b:	8b 45 10             	mov    0x10(%ebp),%eax
  80135e:	01 d0                	add    %edx,%eax
  801360:	c6 00 00             	movb   $0x0,(%eax)
}
  801363:	90                   	nop
  801364:	c9                   	leave  
  801365:	c3                   	ret    

00801366 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801369:	8b 45 14             	mov    0x14(%ebp),%eax
  80136c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801372:	8b 45 14             	mov    0x14(%ebp),%eax
  801375:	8b 00                	mov    (%eax),%eax
  801377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137e:	8b 45 10             	mov    0x10(%ebp),%eax
  801381:	01 d0                	add    %edx,%eax
  801383:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801389:	eb 0c                	jmp    801397 <strsplit+0x31>
			*string++ = 0;
  80138b:	8b 45 08             	mov    0x8(%ebp),%eax
  80138e:	8d 50 01             	lea    0x1(%eax),%edx
  801391:	89 55 08             	mov    %edx,0x8(%ebp)
  801394:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801397:	8b 45 08             	mov    0x8(%ebp),%eax
  80139a:	8a 00                	mov    (%eax),%al
  80139c:	84 c0                	test   %al,%al
  80139e:	74 18                	je     8013b8 <strsplit+0x52>
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	8a 00                	mov    (%eax),%al
  8013a5:	0f be c0             	movsbl %al,%eax
  8013a8:	50                   	push   %eax
  8013a9:	ff 75 0c             	pushl  0xc(%ebp)
  8013ac:	e8 13 fb ff ff       	call   800ec4 <strchr>
  8013b1:	83 c4 08             	add    $0x8,%esp
  8013b4:	85 c0                	test   %eax,%eax
  8013b6:	75 d3                	jne    80138b <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	8a 00                	mov    (%eax),%al
  8013bd:	84 c0                	test   %al,%al
  8013bf:	74 5a                	je     80141b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c4:	8b 00                	mov    (%eax),%eax
  8013c6:	83 f8 0f             	cmp    $0xf,%eax
  8013c9:	75 07                	jne    8013d2 <strsplit+0x6c>
		{
			return 0;
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d0:	eb 66                	jmp    801438 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	8d 48 01             	lea    0x1(%eax),%ecx
  8013da:	8b 55 14             	mov    0x14(%ebp),%edx
  8013dd:	89 0a                	mov    %ecx,(%edx)
  8013df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e9:	01 c2                	add    %eax,%edx
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f0:	eb 03                	jmp    8013f5 <strsplit+0x8f>
			string++;
  8013f2:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	84 c0                	test   %al,%al
  8013fc:	74 8b                	je     801389 <strsplit+0x23>
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8a 00                	mov    (%eax),%al
  801403:	0f be c0             	movsbl %al,%eax
  801406:	50                   	push   %eax
  801407:	ff 75 0c             	pushl  0xc(%ebp)
  80140a:	e8 b5 fa ff ff       	call   800ec4 <strchr>
  80140f:	83 c4 08             	add    $0x8,%esp
  801412:	85 c0                	test   %eax,%eax
  801414:	74 dc                	je     8013f2 <strsplit+0x8c>
			string++;
	}
  801416:	e9 6e ff ff ff       	jmp    801389 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80141b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	8b 00                	mov    (%eax),%eax
  801421:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 d0                	add    %edx,%eax
  80142d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801433:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801440:	a1 04 50 80 00       	mov    0x805004,%eax
  801445:	85 c0                	test   %eax,%eax
  801447:	74 1f                	je     801468 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801449:	e8 1d 00 00 00       	call   80146b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80144e:	83 ec 0c             	sub    $0xc,%esp
  801451:	68 f0 3e 80 00       	push   $0x803ef0
  801456:	e8 55 f2 ff ff       	call   8006b0 <cprintf>
  80145b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80145e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801465:	00 00 00 
	}
}
  801468:	90                   	nop
  801469:	c9                   	leave  
  80146a:	c3                   	ret    

0080146b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80146b:	55                   	push   %ebp
  80146c:	89 e5                	mov    %esp,%ebp
  80146e:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801471:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801478:	00 00 00 
  80147b:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801482:	00 00 00 
  801485:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80148c:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80148f:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801496:	00 00 00 
  801499:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8014a0:	00 00 00 
  8014a3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8014aa:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8014ad:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8014b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b7:	c1 e8 0c             	shr    $0xc,%eax
  8014ba:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8014bf:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8014c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ce:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014d3:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  8014d8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8014df:	a1 20 51 80 00       	mov    0x805120,%eax
  8014e4:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8014e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8014eb:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8014f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f8:	01 d0                	add    %edx,%eax
  8014fa:	48                   	dec    %eax
  8014fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801501:	ba 00 00 00 00       	mov    $0x0,%edx
  801506:	f7 75 e4             	divl   -0x1c(%ebp)
  801509:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80150c:	29 d0                	sub    %edx,%eax
  80150e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801511:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801518:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80151b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801520:	2d 00 10 00 00       	sub    $0x1000,%eax
  801525:	83 ec 04             	sub    $0x4,%esp
  801528:	6a 07                	push   $0x7
  80152a:	ff 75 e8             	pushl  -0x18(%ebp)
  80152d:	50                   	push   %eax
  80152e:	e8 3d 06 00 00       	call   801b70 <sys_allocate_chunk>
  801533:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801536:	a1 20 51 80 00       	mov    0x805120,%eax
  80153b:	83 ec 0c             	sub    $0xc,%esp
  80153e:	50                   	push   %eax
  80153f:	e8 b2 0c 00 00       	call   8021f6 <initialize_MemBlocksList>
  801544:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801547:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80154c:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  80154f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801553:	0f 84 f3 00 00 00    	je     80164c <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801559:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80155d:	75 14                	jne    801573 <initialize_dyn_block_system+0x108>
  80155f:	83 ec 04             	sub    $0x4,%esp
  801562:	68 15 3f 80 00       	push   $0x803f15
  801567:	6a 36                	push   $0x36
  801569:	68 33 3f 80 00       	push   $0x803f33
  80156e:	e8 89 ee ff ff       	call   8003fc <_panic>
  801573:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801576:	8b 00                	mov    (%eax),%eax
  801578:	85 c0                	test   %eax,%eax
  80157a:	74 10                	je     80158c <initialize_dyn_block_system+0x121>
  80157c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80157f:	8b 00                	mov    (%eax),%eax
  801581:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801584:	8b 52 04             	mov    0x4(%edx),%edx
  801587:	89 50 04             	mov    %edx,0x4(%eax)
  80158a:	eb 0b                	jmp    801597 <initialize_dyn_block_system+0x12c>
  80158c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80158f:	8b 40 04             	mov    0x4(%eax),%eax
  801592:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801597:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80159a:	8b 40 04             	mov    0x4(%eax),%eax
  80159d:	85 c0                	test   %eax,%eax
  80159f:	74 0f                	je     8015b0 <initialize_dyn_block_system+0x145>
  8015a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015a4:	8b 40 04             	mov    0x4(%eax),%eax
  8015a7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015aa:	8b 12                	mov    (%edx),%edx
  8015ac:	89 10                	mov    %edx,(%eax)
  8015ae:	eb 0a                	jmp    8015ba <initialize_dyn_block_system+0x14f>
  8015b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015b3:	8b 00                	mov    (%eax),%eax
  8015b5:	a3 48 51 80 00       	mov    %eax,0x805148
  8015ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015cd:	a1 54 51 80 00       	mov    0x805154,%eax
  8015d2:	48                   	dec    %eax
  8015d3:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8015d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015db:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8015e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015e5:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8015ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8015f0:	75 14                	jne    801606 <initialize_dyn_block_system+0x19b>
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 40 3f 80 00       	push   $0x803f40
  8015fa:	6a 3e                	push   $0x3e
  8015fc:	68 33 3f 80 00       	push   $0x803f33
  801601:	e8 f6 ed ff ff       	call   8003fc <_panic>
  801606:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80160c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80160f:	89 10                	mov    %edx,(%eax)
  801611:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801614:	8b 00                	mov    (%eax),%eax
  801616:	85 c0                	test   %eax,%eax
  801618:	74 0d                	je     801627 <initialize_dyn_block_system+0x1bc>
  80161a:	a1 38 51 80 00       	mov    0x805138,%eax
  80161f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801622:	89 50 04             	mov    %edx,0x4(%eax)
  801625:	eb 08                	jmp    80162f <initialize_dyn_block_system+0x1c4>
  801627:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80162a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80162f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801632:	a3 38 51 80 00       	mov    %eax,0x805138
  801637:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80163a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801641:	a1 44 51 80 00       	mov    0x805144,%eax
  801646:	40                   	inc    %eax
  801647:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  80164c:	90                   	nop
  80164d:	c9                   	leave  
  80164e:	c3                   	ret    

0080164f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80164f:	55                   	push   %ebp
  801650:	89 e5                	mov    %esp,%ebp
  801652:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801655:	e8 e0 fd ff ff       	call   80143a <InitializeUHeap>
		if (size == 0) return NULL ;
  80165a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80165e:	75 07                	jne    801667 <malloc+0x18>
  801660:	b8 00 00 00 00       	mov    $0x0,%eax
  801665:	eb 7f                	jmp    8016e6 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801667:	e8 d2 08 00 00       	call   801f3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80166c:	85 c0                	test   %eax,%eax
  80166e:	74 71                	je     8016e1 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801670:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801677:	8b 55 08             	mov    0x8(%ebp),%edx
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	01 d0                	add    %edx,%eax
  80167f:	48                   	dec    %eax
  801680:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801686:	ba 00 00 00 00       	mov    $0x0,%edx
  80168b:	f7 75 f4             	divl   -0xc(%ebp)
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	29 d0                	sub    %edx,%eax
  801693:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801696:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80169d:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8016a4:	76 07                	jbe    8016ad <malloc+0x5e>
					return NULL ;
  8016a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ab:	eb 39                	jmp    8016e6 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  8016ad:	83 ec 0c             	sub    $0xc,%esp
  8016b0:	ff 75 08             	pushl  0x8(%ebp)
  8016b3:	e8 e6 0d 00 00       	call   80249e <alloc_block_FF>
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8016be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016c2:	74 16                	je     8016da <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8016c4:	83 ec 0c             	sub    $0xc,%esp
  8016c7:	ff 75 ec             	pushl  -0x14(%ebp)
  8016ca:	e8 37 0c 00 00       	call   802306 <insert_sorted_allocList>
  8016cf:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8016d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d5:	8b 40 08             	mov    0x8(%eax),%eax
  8016d8:	eb 0c                	jmp    8016e6 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8016da:	b8 00 00 00 00       	mov    $0x0,%eax
  8016df:	eb 05                	jmp    8016e6 <malloc+0x97>
				}
		}
	return 0;
  8016e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
  8016eb:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8016f4:	83 ec 08             	sub    $0x8,%esp
  8016f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8016fa:	68 40 50 80 00       	push   $0x805040
  8016ff:	e8 cf 0b 00 00       	call   8022d3 <find_block>
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  80170a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170d:	8b 40 0c             	mov    0xc(%eax),%eax
  801710:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801716:	8b 40 08             	mov    0x8(%eax),%eax
  801719:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  80171c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801720:	0f 84 a1 00 00 00    	je     8017c7 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801726:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80172a:	75 17                	jne    801743 <free+0x5b>
  80172c:	83 ec 04             	sub    $0x4,%esp
  80172f:	68 15 3f 80 00       	push   $0x803f15
  801734:	68 80 00 00 00       	push   $0x80
  801739:	68 33 3f 80 00       	push   $0x803f33
  80173e:	e8 b9 ec ff ff       	call   8003fc <_panic>
  801743:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801746:	8b 00                	mov    (%eax),%eax
  801748:	85 c0                	test   %eax,%eax
  80174a:	74 10                	je     80175c <free+0x74>
  80174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174f:	8b 00                	mov    (%eax),%eax
  801751:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801754:	8b 52 04             	mov    0x4(%edx),%edx
  801757:	89 50 04             	mov    %edx,0x4(%eax)
  80175a:	eb 0b                	jmp    801767 <free+0x7f>
  80175c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175f:	8b 40 04             	mov    0x4(%eax),%eax
  801762:	a3 44 50 80 00       	mov    %eax,0x805044
  801767:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176a:	8b 40 04             	mov    0x4(%eax),%eax
  80176d:	85 c0                	test   %eax,%eax
  80176f:	74 0f                	je     801780 <free+0x98>
  801771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801774:	8b 40 04             	mov    0x4(%eax),%eax
  801777:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80177a:	8b 12                	mov    (%edx),%edx
  80177c:	89 10                	mov    %edx,(%eax)
  80177e:	eb 0a                	jmp    80178a <free+0xa2>
  801780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801783:	8b 00                	mov    (%eax),%eax
  801785:	a3 40 50 80 00       	mov    %eax,0x805040
  80178a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801796:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80179d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8017a2:	48                   	dec    %eax
  8017a3:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  8017a8:	83 ec 0c             	sub    $0xc,%esp
  8017ab:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ae:	e8 29 12 00 00       	call   8029dc <insert_sorted_with_merge_freeList>
  8017b3:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  8017b6:	83 ec 08             	sub    $0x8,%esp
  8017b9:	ff 75 ec             	pushl  -0x14(%ebp)
  8017bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8017bf:	e8 74 03 00 00       	call   801b38 <sys_free_user_mem>
  8017c4:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8017c7:	90                   	nop
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 38             	sub    $0x38,%esp
  8017d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017d3:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017d6:	e8 5f fc ff ff       	call   80143a <InitializeUHeap>
	if (size == 0) return NULL ;
  8017db:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017df:	75 0a                	jne    8017eb <smalloc+0x21>
  8017e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e6:	e9 b2 00 00 00       	jmp    80189d <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8017eb:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8017f2:	76 0a                	jbe    8017fe <smalloc+0x34>
		return NULL;
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	e9 9f 00 00 00       	jmp    80189d <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017fe:	e8 3b 07 00 00       	call   801f3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801803:	85 c0                	test   %eax,%eax
  801805:	0f 84 8d 00 00 00    	je     801898 <smalloc+0xce>
	struct MemBlock *b = NULL;
  80180b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801812:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801819:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181f:	01 d0                	add    %edx,%eax
  801821:	48                   	dec    %eax
  801822:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801828:	ba 00 00 00 00       	mov    $0x0,%edx
  80182d:	f7 75 f0             	divl   -0x10(%ebp)
  801830:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801833:	29 d0                	sub    %edx,%eax
  801835:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801838:	83 ec 0c             	sub    $0xc,%esp
  80183b:	ff 75 e8             	pushl  -0x18(%ebp)
  80183e:	e8 5b 0c 00 00       	call   80249e <alloc_block_FF>
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801849:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80184d:	75 07                	jne    801856 <smalloc+0x8c>
			return NULL;
  80184f:	b8 00 00 00 00       	mov    $0x0,%eax
  801854:	eb 47                	jmp    80189d <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801856:	83 ec 0c             	sub    $0xc,%esp
  801859:	ff 75 f4             	pushl  -0xc(%ebp)
  80185c:	e8 a5 0a 00 00       	call   802306 <insert_sorted_allocList>
  801861:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801867:	8b 40 08             	mov    0x8(%eax),%eax
  80186a:	89 c2                	mov    %eax,%edx
  80186c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801870:	52                   	push   %edx
  801871:	50                   	push   %eax
  801872:	ff 75 0c             	pushl  0xc(%ebp)
  801875:	ff 75 08             	pushl  0x8(%ebp)
  801878:	e8 46 04 00 00       	call   801cc3 <sys_createSharedObject>
  80187d:	83 c4 10             	add    $0x10,%esp
  801880:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801883:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801887:	78 08                	js     801891 <smalloc+0xc7>
		return (void *)b->sva;
  801889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188c:	8b 40 08             	mov    0x8(%eax),%eax
  80188f:	eb 0c                	jmp    80189d <smalloc+0xd3>
		}else{
		return NULL;
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	eb 05                	jmp    80189d <smalloc+0xd3>
			}

	}return NULL;
  801898:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018a5:	e8 90 fb ff ff       	call   80143a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8018aa:	e8 8f 06 00 00       	call   801f3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018af:	85 c0                	test   %eax,%eax
  8018b1:	0f 84 ad 00 00 00    	je     801964 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018b7:	83 ec 08             	sub    $0x8,%esp
  8018ba:	ff 75 0c             	pushl  0xc(%ebp)
  8018bd:	ff 75 08             	pushl  0x8(%ebp)
  8018c0:	e8 28 04 00 00       	call   801ced <sys_getSizeOfSharedObject>
  8018c5:	83 c4 10             	add    $0x10,%esp
  8018c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8018cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018cf:	79 0a                	jns    8018db <sget+0x3c>
    {
    	return NULL;
  8018d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d6:	e9 8e 00 00 00       	jmp    801969 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8018db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8018e2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018ef:	01 d0                	add    %edx,%eax
  8018f1:	48                   	dec    %eax
  8018f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fd:	f7 75 ec             	divl   -0x14(%ebp)
  801900:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801903:	29 d0                	sub    %edx,%eax
  801905:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801908:	83 ec 0c             	sub    $0xc,%esp
  80190b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80190e:	e8 8b 0b 00 00       	call   80249e <alloc_block_FF>
  801913:	83 c4 10             	add    $0x10,%esp
  801916:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801919:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80191d:	75 07                	jne    801926 <sget+0x87>
				return NULL;
  80191f:	b8 00 00 00 00       	mov    $0x0,%eax
  801924:	eb 43                	jmp    801969 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801926:	83 ec 0c             	sub    $0xc,%esp
  801929:	ff 75 f0             	pushl  -0x10(%ebp)
  80192c:	e8 d5 09 00 00       	call   802306 <insert_sorted_allocList>
  801931:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801937:	8b 40 08             	mov    0x8(%eax),%eax
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	50                   	push   %eax
  80193e:	ff 75 0c             	pushl  0xc(%ebp)
  801941:	ff 75 08             	pushl  0x8(%ebp)
  801944:	e8 c1 03 00 00       	call   801d0a <sys_getSharedObject>
  801949:	83 c4 10             	add    $0x10,%esp
  80194c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  80194f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801953:	78 08                	js     80195d <sget+0xbe>
			return (void *)b->sva;
  801955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801958:	8b 40 08             	mov    0x8(%eax),%eax
  80195b:	eb 0c                	jmp    801969 <sget+0xca>
			}else{
			return NULL;
  80195d:	b8 00 00 00 00       	mov    $0x0,%eax
  801962:	eb 05                	jmp    801969 <sget+0xca>
			}
    }}return NULL;
  801964:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
  80196e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801971:	e8 c4 fa ff ff       	call   80143a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801976:	83 ec 04             	sub    $0x4,%esp
  801979:	68 64 3f 80 00       	push   $0x803f64
  80197e:	68 03 01 00 00       	push   $0x103
  801983:	68 33 3f 80 00       	push   $0x803f33
  801988:	e8 6f ea ff ff       	call   8003fc <_panic>

0080198d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
  801990:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801993:	83 ec 04             	sub    $0x4,%esp
  801996:	68 8c 3f 80 00       	push   $0x803f8c
  80199b:	68 17 01 00 00       	push   $0x117
  8019a0:	68 33 3f 80 00       	push   $0x803f33
  8019a5:	e8 52 ea ff ff       	call   8003fc <_panic>

008019aa <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019b0:	83 ec 04             	sub    $0x4,%esp
  8019b3:	68 b0 3f 80 00       	push   $0x803fb0
  8019b8:	68 22 01 00 00       	push   $0x122
  8019bd:	68 33 3f 80 00       	push   $0x803f33
  8019c2:	e8 35 ea ff ff       	call   8003fc <_panic>

008019c7 <shrink>:

}
void shrink(uint32 newSize)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	68 b0 3f 80 00       	push   $0x803fb0
  8019d5:	68 27 01 00 00       	push   $0x127
  8019da:	68 33 3f 80 00       	push   $0x803f33
  8019df:	e8 18 ea ff ff       	call   8003fc <_panic>

008019e4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	68 b0 3f 80 00       	push   $0x803fb0
  8019f2:	68 2c 01 00 00       	push   $0x12c
  8019f7:	68 33 3f 80 00       	push   $0x803f33
  8019fc:	e8 fb e9 ff ff       	call   8003fc <_panic>

00801a01 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	57                   	push   %edi
  801a05:	56                   	push   %esi
  801a06:	53                   	push   %ebx
  801a07:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a10:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a13:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a16:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a19:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a1c:	cd 30                	int    $0x30
  801a1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a24:	83 c4 10             	add    $0x10,%esp
  801a27:	5b                   	pop    %ebx
  801a28:	5e                   	pop    %esi
  801a29:	5f                   	pop    %edi
  801a2a:	5d                   	pop    %ebp
  801a2b:	c3                   	ret    

00801a2c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 04             	sub    $0x4,%esp
  801a32:	8b 45 10             	mov    0x10(%ebp),%eax
  801a35:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a38:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	52                   	push   %edx
  801a44:	ff 75 0c             	pushl  0xc(%ebp)
  801a47:	50                   	push   %eax
  801a48:	6a 00                	push   $0x0
  801a4a:	e8 b2 ff ff ff       	call   801a01 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	90                   	nop
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_cgetc>:

int
sys_cgetc(void)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 01                	push   $0x1
  801a64:	e8 98 ff ff ff       	call   801a01 <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a71:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a74:	8b 45 08             	mov    0x8(%ebp),%eax
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	52                   	push   %edx
  801a7e:	50                   	push   %eax
  801a7f:	6a 05                	push   $0x5
  801a81:	e8 7b ff ff ff       	call   801a01 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	c9                   	leave  
  801a8a:	c3                   	ret    

00801a8b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a8b:	55                   	push   %ebp
  801a8c:	89 e5                	mov    %esp,%ebp
  801a8e:	56                   	push   %esi
  801a8f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a90:	8b 75 18             	mov    0x18(%ebp),%esi
  801a93:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	56                   	push   %esi
  801aa0:	53                   	push   %ebx
  801aa1:	51                   	push   %ecx
  801aa2:	52                   	push   %edx
  801aa3:	50                   	push   %eax
  801aa4:	6a 06                	push   $0x6
  801aa6:	e8 56 ff ff ff       	call   801a01 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
}
  801aae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab1:	5b                   	pop    %ebx
  801ab2:	5e                   	pop    %esi
  801ab3:	5d                   	pop    %ebp
  801ab4:	c3                   	ret    

00801ab5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ab8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	52                   	push   %edx
  801ac5:	50                   	push   %eax
  801ac6:	6a 07                	push   $0x7
  801ac8:	e8 34 ff ff ff       	call   801a01 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	ff 75 0c             	pushl  0xc(%ebp)
  801ade:	ff 75 08             	pushl  0x8(%ebp)
  801ae1:	6a 08                	push   $0x8
  801ae3:	e8 19 ff ff ff       	call   801a01 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 09                	push   $0x9
  801afc:	e8 00 ff ff ff       	call   801a01 <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 0a                	push   $0xa
  801b15:	e8 e7 fe ff ff       	call   801a01 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 0b                	push   $0xb
  801b2e:	e8 ce fe ff ff       	call   801a01 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	ff 75 08             	pushl  0x8(%ebp)
  801b47:	6a 0f                	push   $0xf
  801b49:	e8 b3 fe ff ff       	call   801a01 <syscall>
  801b4e:	83 c4 18             	add    $0x18,%esp
	return;
  801b51:	90                   	nop
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	ff 75 08             	pushl  0x8(%ebp)
  801b63:	6a 10                	push   $0x10
  801b65:	e8 97 fe ff ff       	call   801a01 <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b6d:	90                   	nop
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	ff 75 10             	pushl  0x10(%ebp)
  801b7a:	ff 75 0c             	pushl  0xc(%ebp)
  801b7d:	ff 75 08             	pushl  0x8(%ebp)
  801b80:	6a 11                	push   $0x11
  801b82:	e8 7a fe ff ff       	call   801a01 <syscall>
  801b87:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8a:	90                   	nop
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 0c                	push   $0xc
  801b9c:	e8 60 fe ff ff       	call   801a01 <syscall>
  801ba1:	83 c4 18             	add    $0x18,%esp
}
  801ba4:	c9                   	leave  
  801ba5:	c3                   	ret    

00801ba6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ba6:	55                   	push   %ebp
  801ba7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	ff 75 08             	pushl  0x8(%ebp)
  801bb4:	6a 0d                	push   $0xd
  801bb6:	e8 46 fe ff ff       	call   801a01 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 0e                	push   $0xe
  801bcf:	e8 2d fe ff ff       	call   801a01 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	90                   	nop
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 13                	push   $0x13
  801be9:	e8 13 fe ff ff       	call   801a01 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	90                   	nop
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 14                	push   $0x14
  801c03:	e8 f9 fd ff ff       	call   801a01 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	90                   	nop
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_cputc>:


void
sys_cputc(const char c)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
  801c11:	83 ec 04             	sub    $0x4,%esp
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	50                   	push   %eax
  801c27:	6a 15                	push   $0x15
  801c29:	e8 d3 fd ff ff       	call   801a01 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	90                   	nop
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 16                	push   $0x16
  801c43:	e8 b9 fd ff ff       	call   801a01 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
}
  801c4b:	90                   	nop
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	50                   	push   %eax
  801c5e:	6a 17                	push   $0x17
  801c60:	e8 9c fd ff ff       	call   801a01 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	52                   	push   %edx
  801c7a:	50                   	push   %eax
  801c7b:	6a 1a                	push   $0x1a
  801c7d:	e8 7f fd ff ff       	call   801a01 <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	52                   	push   %edx
  801c97:	50                   	push   %eax
  801c98:	6a 18                	push   $0x18
  801c9a:	e8 62 fd ff ff       	call   801a01 <syscall>
  801c9f:	83 c4 18             	add    $0x18,%esp
}
  801ca2:	90                   	nop
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	6a 19                	push   $0x19
  801cb8:	e8 44 fd ff ff       	call   801a01 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	90                   	nop
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ccc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ccf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cd2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd9:	6a 00                	push   $0x0
  801cdb:	51                   	push   %ecx
  801cdc:	52                   	push   %edx
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	50                   	push   %eax
  801ce1:	6a 1b                	push   $0x1b
  801ce3:	e8 19 fd ff ff       	call   801a01 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801cf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	52                   	push   %edx
  801cfd:	50                   	push   %eax
  801cfe:	6a 1c                	push   $0x1c
  801d00:	e8 fc fc ff ff       	call   801a01 <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	51                   	push   %ecx
  801d1b:	52                   	push   %edx
  801d1c:	50                   	push   %eax
  801d1d:	6a 1d                	push   $0x1d
  801d1f:	e8 dd fc ff ff       	call   801a01 <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	52                   	push   %edx
  801d39:	50                   	push   %eax
  801d3a:	6a 1e                	push   $0x1e
  801d3c:	e8 c0 fc ff ff       	call   801a01 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 1f                	push   $0x1f
  801d55:	e8 a7 fc ff ff       	call   801a01 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	6a 00                	push   $0x0
  801d67:	ff 75 14             	pushl  0x14(%ebp)
  801d6a:	ff 75 10             	pushl  0x10(%ebp)
  801d6d:	ff 75 0c             	pushl  0xc(%ebp)
  801d70:	50                   	push   %eax
  801d71:	6a 20                	push   $0x20
  801d73:	e8 89 fc ff ff       	call   801a01 <syscall>
  801d78:	83 c4 18             	add    $0x18,%esp
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	50                   	push   %eax
  801d8c:	6a 21                	push   $0x21
  801d8e:	e8 6e fc ff ff       	call   801a01 <syscall>
  801d93:	83 c4 18             	add    $0x18,%esp
}
  801d96:	90                   	nop
  801d97:	c9                   	leave  
  801d98:	c3                   	ret    

00801d99 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	50                   	push   %eax
  801da8:	6a 22                	push   $0x22
  801daa:	e8 52 fc ff ff       	call   801a01 <syscall>
  801daf:	83 c4 18             	add    $0x18,%esp
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 02                	push   $0x2
  801dc3:	e8 39 fc ff ff       	call   801a01 <syscall>
  801dc8:	83 c4 18             	add    $0x18,%esp
}
  801dcb:	c9                   	leave  
  801dcc:	c3                   	ret    

00801dcd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dcd:	55                   	push   %ebp
  801dce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 03                	push   $0x3
  801ddc:	e8 20 fc ff ff       	call   801a01 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 04                	push   $0x4
  801df5:	e8 07 fc ff ff       	call   801a01 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_exit_env>:


void sys_exit_env(void)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 23                	push   $0x23
  801e0e:	e8 ee fb ff ff       	call   801a01 <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
}
  801e16:	90                   	nop
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e1f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e22:	8d 50 04             	lea    0x4(%eax),%edx
  801e25:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	52                   	push   %edx
  801e2f:	50                   	push   %eax
  801e30:	6a 24                	push   $0x24
  801e32:	e8 ca fb ff ff       	call   801a01 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
	return result;
  801e3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e43:	89 01                	mov    %eax,(%ecx)
  801e45:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e48:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4b:	c9                   	leave  
  801e4c:	c2 04 00             	ret    $0x4

00801e4f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	ff 75 10             	pushl  0x10(%ebp)
  801e59:	ff 75 0c             	pushl  0xc(%ebp)
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	6a 12                	push   $0x12
  801e61:	e8 9b fb ff ff       	call   801a01 <syscall>
  801e66:	83 c4 18             	add    $0x18,%esp
	return ;
  801e69:	90                   	nop
}
  801e6a:	c9                   	leave  
  801e6b:	c3                   	ret    

00801e6c <sys_rcr2>:
uint32 sys_rcr2()
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 25                	push   $0x25
  801e7b:	e8 81 fb ff ff       	call   801a01 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 04             	sub    $0x4,%esp
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e91:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	50                   	push   %eax
  801e9e:	6a 26                	push   $0x26
  801ea0:	e8 5c fb ff ff       	call   801a01 <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea8:	90                   	nop
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <rsttst>:
void rsttst()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 28                	push   $0x28
  801eba:	e8 42 fb ff ff       	call   801a01 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec2:	90                   	nop
}
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	8b 45 14             	mov    0x14(%ebp),%eax
  801ece:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ed1:	8b 55 18             	mov    0x18(%ebp),%edx
  801ed4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ed8:	52                   	push   %edx
  801ed9:	50                   	push   %eax
  801eda:	ff 75 10             	pushl  0x10(%ebp)
  801edd:	ff 75 0c             	pushl  0xc(%ebp)
  801ee0:	ff 75 08             	pushl  0x8(%ebp)
  801ee3:	6a 27                	push   $0x27
  801ee5:	e8 17 fb ff ff       	call   801a01 <syscall>
  801eea:	83 c4 18             	add    $0x18,%esp
	return ;
  801eed:	90                   	nop
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <chktst>:
void chktst(uint32 n)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	6a 00                	push   $0x0
  801efb:	ff 75 08             	pushl  0x8(%ebp)
  801efe:	6a 29                	push   $0x29
  801f00:	e8 fc fa ff ff       	call   801a01 <syscall>
  801f05:	83 c4 18             	add    $0x18,%esp
	return ;
  801f08:	90                   	nop
}
  801f09:	c9                   	leave  
  801f0a:	c3                   	ret    

00801f0b <inctst>:

void inctst()
{
  801f0b:	55                   	push   %ebp
  801f0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 2a                	push   $0x2a
  801f1a:	e8 e2 fa ff ff       	call   801a01 <syscall>
  801f1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f22:	90                   	nop
}
  801f23:	c9                   	leave  
  801f24:	c3                   	ret    

00801f25 <gettst>:
uint32 gettst()
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 00                	push   $0x0
  801f32:	6a 2b                	push   $0x2b
  801f34:	e8 c8 fa ff ff       	call   801a01 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 2c                	push   $0x2c
  801f50:	e8 ac fa ff ff       	call   801a01 <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
  801f58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f5b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f5f:	75 07                	jne    801f68 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f61:	b8 01 00 00 00       	mov    $0x1,%eax
  801f66:	eb 05                	jmp    801f6d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6d:	c9                   	leave  
  801f6e:	c3                   	ret    

00801f6f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 00                	push   $0x0
  801f7f:	6a 2c                	push   $0x2c
  801f81:	e8 7b fa ff ff       	call   801a01 <syscall>
  801f86:	83 c4 18             	add    $0x18,%esp
  801f89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f8c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f90:	75 07                	jne    801f99 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f92:	b8 01 00 00 00       	mov    $0x1,%eax
  801f97:	eb 05                	jmp    801f9e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	6a 00                	push   $0x0
  801fb0:	6a 2c                	push   $0x2c
  801fb2:	e8 4a fa ff ff       	call   801a01 <syscall>
  801fb7:	83 c4 18             	add    $0x18,%esp
  801fba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fbd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fc1:	75 07                	jne    801fca <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc8:	eb 05                	jmp    801fcf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 00                	push   $0x0
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 2c                	push   $0x2c
  801fe3:	e8 19 fa ff ff       	call   801a01 <syscall>
  801fe8:	83 c4 18             	add    $0x18,%esp
  801feb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fee:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ff2:	75 07                	jne    801ffb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ff4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff9:	eb 05                	jmp    802000 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ffb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	6a 00                	push   $0x0
  80200d:	ff 75 08             	pushl  0x8(%ebp)
  802010:	6a 2d                	push   $0x2d
  802012:	e8 ea f9 ff ff       	call   801a01 <syscall>
  802017:	83 c4 18             	add    $0x18,%esp
	return ;
  80201a:	90                   	nop
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802021:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802024:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802027:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	6a 00                	push   $0x0
  80202f:	53                   	push   %ebx
  802030:	51                   	push   %ecx
  802031:	52                   	push   %edx
  802032:	50                   	push   %eax
  802033:	6a 2e                	push   $0x2e
  802035:	e8 c7 f9 ff ff       	call   801a01 <syscall>
  80203a:	83 c4 18             	add    $0x18,%esp
}
  80203d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802045:	8b 55 0c             	mov    0xc(%ebp),%edx
  802048:	8b 45 08             	mov    0x8(%ebp),%eax
  80204b:	6a 00                	push   $0x0
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	52                   	push   %edx
  802052:	50                   	push   %eax
  802053:	6a 2f                	push   $0x2f
  802055:	e8 a7 f9 ff ff       	call   801a01 <syscall>
  80205a:	83 c4 18             	add    $0x18,%esp
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	68 c0 3f 80 00       	push   $0x803fc0
  80206d:	e8 3e e6 ff ff       	call   8006b0 <cprintf>
  802072:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802075:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80207c:	83 ec 0c             	sub    $0xc,%esp
  80207f:	68 ec 3f 80 00       	push   $0x803fec
  802084:	e8 27 e6 ff ff       	call   8006b0 <cprintf>
  802089:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80208c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802090:	a1 38 51 80 00       	mov    0x805138,%eax
  802095:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802098:	eb 56                	jmp    8020f0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80209a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80209e:	74 1c                	je     8020bc <print_mem_block_lists+0x5d>
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 50 08             	mov    0x8(%eax),%edx
  8020a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a9:	8b 48 08             	mov    0x8(%eax),%ecx
  8020ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020af:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b2:	01 c8                	add    %ecx,%eax
  8020b4:	39 c2                	cmp    %eax,%edx
  8020b6:	73 04                	jae    8020bc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020b8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bf:	8b 50 08             	mov    0x8(%eax),%edx
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c8:	01 c2                	add    %eax,%edx
  8020ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020cd:	8b 40 08             	mov    0x8(%eax),%eax
  8020d0:	83 ec 04             	sub    $0x4,%esp
  8020d3:	52                   	push   %edx
  8020d4:	50                   	push   %eax
  8020d5:	68 01 40 80 00       	push   $0x804001
  8020da:	e8 d1 e5 ff ff       	call   8006b0 <cprintf>
  8020df:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020e8:	a1 40 51 80 00       	mov    0x805140,%eax
  8020ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f4:	74 07                	je     8020fd <print_mem_block_lists+0x9e>
  8020f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f9:	8b 00                	mov    (%eax),%eax
  8020fb:	eb 05                	jmp    802102 <print_mem_block_lists+0xa3>
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	a3 40 51 80 00       	mov    %eax,0x805140
  802107:	a1 40 51 80 00       	mov    0x805140,%eax
  80210c:	85 c0                	test   %eax,%eax
  80210e:	75 8a                	jne    80209a <print_mem_block_lists+0x3b>
  802110:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802114:	75 84                	jne    80209a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802116:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80211a:	75 10                	jne    80212c <print_mem_block_lists+0xcd>
  80211c:	83 ec 0c             	sub    $0xc,%esp
  80211f:	68 10 40 80 00       	push   $0x804010
  802124:	e8 87 e5 ff ff       	call   8006b0 <cprintf>
  802129:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80212c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802133:	83 ec 0c             	sub    $0xc,%esp
  802136:	68 34 40 80 00       	push   $0x804034
  80213b:	e8 70 e5 ff ff       	call   8006b0 <cprintf>
  802140:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802143:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802147:	a1 40 50 80 00       	mov    0x805040,%eax
  80214c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80214f:	eb 56                	jmp    8021a7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802151:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802155:	74 1c                	je     802173 <print_mem_block_lists+0x114>
  802157:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215a:	8b 50 08             	mov    0x8(%eax),%edx
  80215d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802160:	8b 48 08             	mov    0x8(%eax),%ecx
  802163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802166:	8b 40 0c             	mov    0xc(%eax),%eax
  802169:	01 c8                	add    %ecx,%eax
  80216b:	39 c2                	cmp    %eax,%edx
  80216d:	73 04                	jae    802173 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80216f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802173:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802176:	8b 50 08             	mov    0x8(%eax),%edx
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 40 0c             	mov    0xc(%eax),%eax
  80217f:	01 c2                	add    %eax,%edx
  802181:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	83 ec 04             	sub    $0x4,%esp
  80218a:	52                   	push   %edx
  80218b:	50                   	push   %eax
  80218c:	68 01 40 80 00       	push   $0x804001
  802191:	e8 1a e5 ff ff       	call   8006b0 <cprintf>
  802196:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80219f:	a1 48 50 80 00       	mov    0x805048,%eax
  8021a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ab:	74 07                	je     8021b4 <print_mem_block_lists+0x155>
  8021ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b0:	8b 00                	mov    (%eax),%eax
  8021b2:	eb 05                	jmp    8021b9 <print_mem_block_lists+0x15a>
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b9:	a3 48 50 80 00       	mov    %eax,0x805048
  8021be:	a1 48 50 80 00       	mov    0x805048,%eax
  8021c3:	85 c0                	test   %eax,%eax
  8021c5:	75 8a                	jne    802151 <print_mem_block_lists+0xf2>
  8021c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021cb:	75 84                	jne    802151 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021cd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021d1:	75 10                	jne    8021e3 <print_mem_block_lists+0x184>
  8021d3:	83 ec 0c             	sub    $0xc,%esp
  8021d6:	68 4c 40 80 00       	push   $0x80404c
  8021db:	e8 d0 e4 ff ff       	call   8006b0 <cprintf>
  8021e0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021e3:	83 ec 0c             	sub    $0xc,%esp
  8021e6:	68 c0 3f 80 00       	push   $0x803fc0
  8021eb:	e8 c0 e4 ff ff       	call   8006b0 <cprintf>
  8021f0:	83 c4 10             	add    $0x10,%esp

}
  8021f3:	90                   	nop
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8021fc:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802203:	00 00 00 
  802206:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80220d:	00 00 00 
  802210:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802217:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80221a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802221:	e9 9e 00 00 00       	jmp    8022c4 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802226:	a1 50 50 80 00       	mov    0x805050,%eax
  80222b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222e:	c1 e2 04             	shl    $0x4,%edx
  802231:	01 d0                	add    %edx,%eax
  802233:	85 c0                	test   %eax,%eax
  802235:	75 14                	jne    80224b <initialize_MemBlocksList+0x55>
  802237:	83 ec 04             	sub    $0x4,%esp
  80223a:	68 74 40 80 00       	push   $0x804074
  80223f:	6a 3d                	push   $0x3d
  802241:	68 97 40 80 00       	push   $0x804097
  802246:	e8 b1 e1 ff ff       	call   8003fc <_panic>
  80224b:	a1 50 50 80 00       	mov    0x805050,%eax
  802250:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802253:	c1 e2 04             	shl    $0x4,%edx
  802256:	01 d0                	add    %edx,%eax
  802258:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80225e:	89 10                	mov    %edx,(%eax)
  802260:	8b 00                	mov    (%eax),%eax
  802262:	85 c0                	test   %eax,%eax
  802264:	74 18                	je     80227e <initialize_MemBlocksList+0x88>
  802266:	a1 48 51 80 00       	mov    0x805148,%eax
  80226b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802271:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802274:	c1 e1 04             	shl    $0x4,%ecx
  802277:	01 ca                	add    %ecx,%edx
  802279:	89 50 04             	mov    %edx,0x4(%eax)
  80227c:	eb 12                	jmp    802290 <initialize_MemBlocksList+0x9a>
  80227e:	a1 50 50 80 00       	mov    0x805050,%eax
  802283:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802286:	c1 e2 04             	shl    $0x4,%edx
  802289:	01 d0                	add    %edx,%eax
  80228b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802290:	a1 50 50 80 00       	mov    0x805050,%eax
  802295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802298:	c1 e2 04             	shl    $0x4,%edx
  80229b:	01 d0                	add    %edx,%eax
  80229d:	a3 48 51 80 00       	mov    %eax,0x805148
  8022a2:	a1 50 50 80 00       	mov    0x805050,%eax
  8022a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022aa:	c1 e2 04             	shl    $0x4,%edx
  8022ad:	01 d0                	add    %edx,%eax
  8022af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b6:	a1 54 51 80 00       	mov    0x805154,%eax
  8022bb:	40                   	inc    %eax
  8022bc:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8022c1:	ff 45 f4             	incl   -0xc(%ebp)
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022ca:	0f 82 56 ff ff ff    	jb     802226 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8022d0:	90                   	nop
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8022e1:	eb 18                	jmp    8022fb <find_block+0x28>

		if(tmp->sva == va){
  8022e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e6:	8b 40 08             	mov    0x8(%eax),%eax
  8022e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022ec:	75 05                	jne    8022f3 <find_block+0x20>
			return tmp ;
  8022ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f1:	eb 11                	jmp    802304 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8022f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022f6:	8b 00                	mov    (%eax),%eax
  8022f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8022fb:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022ff:	75 e2                	jne    8022e3 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802301:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80230c:	a1 40 50 80 00       	mov    0x805040,%eax
  802311:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802314:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802319:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  80231c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802320:	75 65                	jne    802387 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802322:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802326:	75 14                	jne    80233c <insert_sorted_allocList+0x36>
  802328:	83 ec 04             	sub    $0x4,%esp
  80232b:	68 74 40 80 00       	push   $0x804074
  802330:	6a 62                	push   $0x62
  802332:	68 97 40 80 00       	push   $0x804097
  802337:	e8 c0 e0 ff ff       	call   8003fc <_panic>
  80233c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802342:	8b 45 08             	mov    0x8(%ebp),%eax
  802345:	89 10                	mov    %edx,(%eax)
  802347:	8b 45 08             	mov    0x8(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	85 c0                	test   %eax,%eax
  80234e:	74 0d                	je     80235d <insert_sorted_allocList+0x57>
  802350:	a1 40 50 80 00       	mov    0x805040,%eax
  802355:	8b 55 08             	mov    0x8(%ebp),%edx
  802358:	89 50 04             	mov    %edx,0x4(%eax)
  80235b:	eb 08                	jmp    802365 <insert_sorted_allocList+0x5f>
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	a3 44 50 80 00       	mov    %eax,0x805044
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	a3 40 50 80 00       	mov    %eax,0x805040
  80236d:	8b 45 08             	mov    0x8(%ebp),%eax
  802370:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802377:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80237c:	40                   	inc    %eax
  80237d:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802382:	e9 14 01 00 00       	jmp    80249b <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802387:	8b 45 08             	mov    0x8(%ebp),%eax
  80238a:	8b 50 08             	mov    0x8(%eax),%edx
  80238d:	a1 44 50 80 00       	mov    0x805044,%eax
  802392:	8b 40 08             	mov    0x8(%eax),%eax
  802395:	39 c2                	cmp    %eax,%edx
  802397:	76 65                	jbe    8023fe <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80239d:	75 14                	jne    8023b3 <insert_sorted_allocList+0xad>
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	68 b0 40 80 00       	push   $0x8040b0
  8023a7:	6a 64                	push   $0x64
  8023a9:	68 97 40 80 00       	push   $0x804097
  8023ae:	e8 49 e0 ff ff       	call   8003fc <_panic>
  8023b3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8023b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bc:	89 50 04             	mov    %edx,0x4(%eax)
  8023bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c2:	8b 40 04             	mov    0x4(%eax),%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	74 0c                	je     8023d5 <insert_sorted_allocList+0xcf>
  8023c9:	a1 44 50 80 00       	mov    0x805044,%eax
  8023ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d1:	89 10                	mov    %edx,(%eax)
  8023d3:	eb 08                	jmp    8023dd <insert_sorted_allocList+0xd7>
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	a3 40 50 80 00       	mov    %eax,0x805040
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	a3 44 50 80 00       	mov    %eax,0x805044
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ee:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8023f3:	40                   	inc    %eax
  8023f4:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8023f9:	e9 9d 00 00 00       	jmp    80249b <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8023fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802405:	e9 85 00 00 00       	jmp    80248f <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	8b 50 08             	mov    0x8(%eax),%edx
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 40 08             	mov    0x8(%eax),%eax
  802416:	39 c2                	cmp    %eax,%edx
  802418:	73 6a                	jae    802484 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  80241a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241e:	74 06                	je     802426 <insert_sorted_allocList+0x120>
  802420:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802424:	75 14                	jne    80243a <insert_sorted_allocList+0x134>
  802426:	83 ec 04             	sub    $0x4,%esp
  802429:	68 d4 40 80 00       	push   $0x8040d4
  80242e:	6a 6b                	push   $0x6b
  802430:	68 97 40 80 00       	push   $0x804097
  802435:	e8 c2 df ff ff       	call   8003fc <_panic>
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	8b 50 04             	mov    0x4(%eax),%edx
  802440:	8b 45 08             	mov    0x8(%ebp),%eax
  802443:	89 50 04             	mov    %edx,0x4(%eax)
  802446:	8b 45 08             	mov    0x8(%ebp),%eax
  802449:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244c:	89 10                	mov    %edx,(%eax)
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	8b 40 04             	mov    0x4(%eax),%eax
  802454:	85 c0                	test   %eax,%eax
  802456:	74 0d                	je     802465 <insert_sorted_allocList+0x15f>
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 40 04             	mov    0x4(%eax),%eax
  80245e:	8b 55 08             	mov    0x8(%ebp),%edx
  802461:	89 10                	mov    %edx,(%eax)
  802463:	eb 08                	jmp    80246d <insert_sorted_allocList+0x167>
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	a3 40 50 80 00       	mov    %eax,0x805040
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 55 08             	mov    0x8(%ebp),%edx
  802473:	89 50 04             	mov    %edx,0x4(%eax)
  802476:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80247b:	40                   	inc    %eax
  80247c:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802481:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802482:	eb 17                	jmp    80249b <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 00                	mov    (%eax),%eax
  802489:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80248c:	ff 45 f0             	incl   -0x10(%ebp)
  80248f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802492:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802495:	0f 8c 6f ff ff ff    	jl     80240a <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80249b:	90                   	nop
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  8024a4:	a1 38 51 80 00       	mov    0x805138,%eax
  8024a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8024ac:	e9 7c 01 00 00       	jmp    80262d <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ba:	0f 86 cf 00 00 00    	jbe    80258f <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8024c0:	a1 48 51 80 00       	mov    0x805148,%eax
  8024c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8024c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8024ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024d4:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 50 08             	mov    0x8(%eax),%edx
  8024dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e0:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e9:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ec:	89 c2                	mov    %eax,%edx
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 50 08             	mov    0x8(%eax),%edx
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	01 c2                	add    %eax,%edx
  8024ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802502:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802505:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802509:	75 17                	jne    802522 <alloc_block_FF+0x84>
  80250b:	83 ec 04             	sub    $0x4,%esp
  80250e:	68 09 41 80 00       	push   $0x804109
  802513:	68 83 00 00 00       	push   $0x83
  802518:	68 97 40 80 00       	push   $0x804097
  80251d:	e8 da de ff ff       	call   8003fc <_panic>
  802522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802525:	8b 00                	mov    (%eax),%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	74 10                	je     80253b <alloc_block_FF+0x9d>
  80252b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252e:	8b 00                	mov    (%eax),%eax
  802530:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802533:	8b 52 04             	mov    0x4(%edx),%edx
  802536:	89 50 04             	mov    %edx,0x4(%eax)
  802539:	eb 0b                	jmp    802546 <alloc_block_FF+0xa8>
  80253b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253e:	8b 40 04             	mov    0x4(%eax),%eax
  802541:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802549:	8b 40 04             	mov    0x4(%eax),%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	74 0f                	je     80255f <alloc_block_FF+0xc1>
  802550:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802553:	8b 40 04             	mov    0x4(%eax),%eax
  802556:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802559:	8b 12                	mov    (%edx),%edx
  80255b:	89 10                	mov    %edx,(%eax)
  80255d:	eb 0a                	jmp    802569 <alloc_block_FF+0xcb>
  80255f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802562:	8b 00                	mov    (%eax),%eax
  802564:	a3 48 51 80 00       	mov    %eax,0x805148
  802569:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802572:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802575:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257c:	a1 54 51 80 00       	mov    0x805154,%eax
  802581:	48                   	dec    %eax
  802582:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802587:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258a:	e9 ad 00 00 00       	jmp    80263c <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 0c             	mov    0xc(%eax),%eax
  802595:	3b 45 08             	cmp    0x8(%ebp),%eax
  802598:	0f 85 87 00 00 00    	jne    802625 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80259e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a2:	75 17                	jne    8025bb <alloc_block_FF+0x11d>
  8025a4:	83 ec 04             	sub    $0x4,%esp
  8025a7:	68 09 41 80 00       	push   $0x804109
  8025ac:	68 87 00 00 00       	push   $0x87
  8025b1:	68 97 40 80 00       	push   $0x804097
  8025b6:	e8 41 de ff ff       	call   8003fc <_panic>
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 00                	mov    (%eax),%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	74 10                	je     8025d4 <alloc_block_FF+0x136>
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 00                	mov    (%eax),%eax
  8025c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cc:	8b 52 04             	mov    0x4(%edx),%edx
  8025cf:	89 50 04             	mov    %edx,0x4(%eax)
  8025d2:	eb 0b                	jmp    8025df <alloc_block_FF+0x141>
  8025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d7:	8b 40 04             	mov    0x4(%eax),%eax
  8025da:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	8b 40 04             	mov    0x4(%eax),%eax
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	74 0f                	je     8025f8 <alloc_block_FF+0x15a>
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 40 04             	mov    0x4(%eax),%eax
  8025ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f2:	8b 12                	mov    (%edx),%edx
  8025f4:	89 10                	mov    %edx,(%eax)
  8025f6:	eb 0a                	jmp    802602 <alloc_block_FF+0x164>
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 00                	mov    (%eax),%eax
  8025fd:	a3 38 51 80 00       	mov    %eax,0x805138
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802615:	a1 44 51 80 00       	mov    0x805144,%eax
  80261a:	48                   	dec    %eax
  80261b:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	eb 17                	jmp    80263c <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  80262d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802631:	0f 85 7a fe ff ff    	jne    8024b1 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263c:	c9                   	leave  
  80263d:	c3                   	ret    

0080263e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80263e:	55                   	push   %ebp
  80263f:	89 e5                	mov    %esp,%ebp
  802641:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802644:	a1 38 51 80 00       	mov    0x805138,%eax
  802649:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  80264c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802653:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80265a:	a1 38 51 80 00       	mov    0x805138,%eax
  80265f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802662:	e9 d0 00 00 00       	jmp    802737 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 40 0c             	mov    0xc(%eax),%eax
  80266d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802670:	0f 82 b8 00 00 00    	jb     80272e <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 40 0c             	mov    0xc(%eax),%eax
  80267c:	2b 45 08             	sub    0x8(%ebp),%eax
  80267f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802685:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802688:	0f 83 a1 00 00 00    	jae    80272f <alloc_block_BF+0xf1>
				differsize = differance ;
  80268e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802691:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80269a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80269e:	0f 85 8b 00 00 00    	jne    80272f <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  8026a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a8:	75 17                	jne    8026c1 <alloc_block_BF+0x83>
  8026aa:	83 ec 04             	sub    $0x4,%esp
  8026ad:	68 09 41 80 00       	push   $0x804109
  8026b2:	68 a0 00 00 00       	push   $0xa0
  8026b7:	68 97 40 80 00       	push   $0x804097
  8026bc:	e8 3b dd ff ff       	call   8003fc <_panic>
  8026c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	74 10                	je     8026da <alloc_block_BF+0x9c>
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 00                	mov    (%eax),%eax
  8026cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026d2:	8b 52 04             	mov    0x4(%edx),%edx
  8026d5:	89 50 04             	mov    %edx,0x4(%eax)
  8026d8:	eb 0b                	jmp    8026e5 <alloc_block_BF+0xa7>
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 40 04             	mov    0x4(%eax),%eax
  8026e0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	8b 40 04             	mov    0x4(%eax),%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	74 0f                	je     8026fe <alloc_block_BF+0xc0>
  8026ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f2:	8b 40 04             	mov    0x4(%eax),%eax
  8026f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f8:	8b 12                	mov    (%edx),%edx
  8026fa:	89 10                	mov    %edx,(%eax)
  8026fc:	eb 0a                	jmp    802708 <alloc_block_BF+0xca>
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	a3 38 51 80 00       	mov    %eax,0x805138
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802711:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802714:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80271b:	a1 44 51 80 00       	mov    0x805144,%eax
  802720:	48                   	dec    %eax
  802721:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	e9 0c 01 00 00       	jmp    80283a <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  80272e:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80272f:	a1 40 51 80 00       	mov    0x805140,%eax
  802734:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80273b:	74 07                	je     802744 <alloc_block_BF+0x106>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 00                	mov    (%eax),%eax
  802742:	eb 05                	jmp    802749 <alloc_block_BF+0x10b>
  802744:	b8 00 00 00 00       	mov    $0x0,%eax
  802749:	a3 40 51 80 00       	mov    %eax,0x805140
  80274e:	a1 40 51 80 00       	mov    0x805140,%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	0f 85 0c ff ff ff    	jne    802667 <alloc_block_BF+0x29>
  80275b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275f:	0f 85 02 ff ff ff    	jne    802667 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802765:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802769:	0f 84 c6 00 00 00    	je     802835 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80276f:	a1 48 51 80 00       	mov    0x805148,%eax
  802774:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802777:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277a:	8b 55 08             	mov    0x8(%ebp),%edx
  80277d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802783:	8b 50 08             	mov    0x8(%eax),%edx
  802786:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802789:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80278c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278f:	8b 40 0c             	mov    0xc(%eax),%eax
  802792:	2b 45 08             	sub    0x8(%ebp),%eax
  802795:	89 c2                	mov    %eax,%edx
  802797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279a:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80279d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a0:	8b 50 08             	mov    0x8(%eax),%edx
  8027a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a6:	01 c2                	add    %eax,%edx
  8027a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ab:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  8027ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027b2:	75 17                	jne    8027cb <alloc_block_BF+0x18d>
  8027b4:	83 ec 04             	sub    $0x4,%esp
  8027b7:	68 09 41 80 00       	push   $0x804109
  8027bc:	68 af 00 00 00       	push   $0xaf
  8027c1:	68 97 40 80 00       	push   $0x804097
  8027c6:	e8 31 dc ff ff       	call   8003fc <_panic>
  8027cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ce:	8b 00                	mov    (%eax),%eax
  8027d0:	85 c0                	test   %eax,%eax
  8027d2:	74 10                	je     8027e4 <alloc_block_BF+0x1a6>
  8027d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027dc:	8b 52 04             	mov    0x4(%edx),%edx
  8027df:	89 50 04             	mov    %edx,0x4(%eax)
  8027e2:	eb 0b                	jmp    8027ef <alloc_block_BF+0x1b1>
  8027e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027e7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ea:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f2:	8b 40 04             	mov    0x4(%eax),%eax
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 0f                	je     802808 <alloc_block_BF+0x1ca>
  8027f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027fc:	8b 40 04             	mov    0x4(%eax),%eax
  8027ff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802802:	8b 12                	mov    (%edx),%edx
  802804:	89 10                	mov    %edx,(%eax)
  802806:	eb 0a                	jmp    802812 <alloc_block_BF+0x1d4>
  802808:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280b:	8b 00                	mov    (%eax),%eax
  80280d:	a3 48 51 80 00       	mov    %eax,0x805148
  802812:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802815:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80281e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802825:	a1 54 51 80 00       	mov    0x805154,%eax
  80282a:	48                   	dec    %eax
  80282b:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802830:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802833:	eb 05                	jmp    80283a <alloc_block_BF+0x1fc>
	}

	return NULL;
  802835:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802842:	a1 38 51 80 00       	mov    0x805138,%eax
  802847:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  80284a:	e9 7c 01 00 00       	jmp    8029cb <alloc_block_NF+0x18f>
	        if (updated->size > size){
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 40 0c             	mov    0xc(%eax),%eax
  802855:	3b 45 08             	cmp    0x8(%ebp),%eax
  802858:	0f 86 cf 00 00 00    	jbe    80292d <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80285e:	a1 48 51 80 00       	mov    0x805148,%eax
  802863:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802869:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  80286c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286f:	8b 55 08             	mov    0x8(%ebp),%edx
  802872:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	8b 50 08             	mov    0x8(%eax),%edx
  80287b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287e:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802884:	8b 40 0c             	mov    0xc(%eax),%eax
  802887:	2b 45 08             	sub    0x8(%ebp),%eax
  80288a:	89 c2                	mov    %eax,%edx
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 50 08             	mov    0x8(%eax),%edx
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	01 c2                	add    %eax,%edx
  80289d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a0:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8028a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028a7:	75 17                	jne    8028c0 <alloc_block_NF+0x84>
  8028a9:	83 ec 04             	sub    $0x4,%esp
  8028ac:	68 09 41 80 00       	push   $0x804109
  8028b1:	68 c4 00 00 00       	push   $0xc4
  8028b6:	68 97 40 80 00       	push   $0x804097
  8028bb:	e8 3c db ff ff       	call   8003fc <_panic>
  8028c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	85 c0                	test   %eax,%eax
  8028c7:	74 10                	je     8028d9 <alloc_block_NF+0x9d>
  8028c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cc:	8b 00                	mov    (%eax),%eax
  8028ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d1:	8b 52 04             	mov    0x4(%edx),%edx
  8028d4:	89 50 04             	mov    %edx,0x4(%eax)
  8028d7:	eb 0b                	jmp    8028e4 <alloc_block_NF+0xa8>
  8028d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dc:	8b 40 04             	mov    0x4(%eax),%eax
  8028df:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	74 0f                	je     8028fd <alloc_block_NF+0xc1>
  8028ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f1:	8b 40 04             	mov    0x4(%eax),%eax
  8028f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f7:	8b 12                	mov    (%edx),%edx
  8028f9:	89 10                	mov    %edx,(%eax)
  8028fb:	eb 0a                	jmp    802907 <alloc_block_NF+0xcb>
  8028fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	a3 48 51 80 00       	mov    %eax,0x805148
  802907:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802910:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802913:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291a:	a1 54 51 80 00       	mov    0x805154,%eax
  80291f:	48                   	dec    %eax
  802920:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802925:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802928:	e9 ad 00 00 00       	jmp    8029da <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 40 0c             	mov    0xc(%eax),%eax
  802933:	3b 45 08             	cmp    0x8(%ebp),%eax
  802936:	0f 85 87 00 00 00    	jne    8029c3 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  80293c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802940:	75 17                	jne    802959 <alloc_block_NF+0x11d>
  802942:	83 ec 04             	sub    $0x4,%esp
  802945:	68 09 41 80 00       	push   $0x804109
  80294a:	68 c8 00 00 00       	push   $0xc8
  80294f:	68 97 40 80 00       	push   $0x804097
  802954:	e8 a3 da ff ff       	call   8003fc <_panic>
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	74 10                	je     802972 <alloc_block_NF+0x136>
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296a:	8b 52 04             	mov    0x4(%edx),%edx
  80296d:	89 50 04             	mov    %edx,0x4(%eax)
  802970:	eb 0b                	jmp    80297d <alloc_block_NF+0x141>
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80297d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802980:	8b 40 04             	mov    0x4(%eax),%eax
  802983:	85 c0                	test   %eax,%eax
  802985:	74 0f                	je     802996 <alloc_block_NF+0x15a>
  802987:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298a:	8b 40 04             	mov    0x4(%eax),%eax
  80298d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802990:	8b 12                	mov    (%edx),%edx
  802992:	89 10                	mov    %edx,(%eax)
  802994:	eb 0a                	jmp    8029a0 <alloc_block_NF+0x164>
  802996:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802999:	8b 00                	mov    (%eax),%eax
  80299b:	a3 38 51 80 00       	mov    %eax,0x805138
  8029a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b3:	a1 44 51 80 00       	mov    0x805144,%eax
  8029b8:	48                   	dec    %eax
  8029b9:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  8029be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c1:	eb 17                	jmp    8029da <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 00                	mov    (%eax),%eax
  8029c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8029cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029cf:	0f 85 7a fe ff ff    	jne    80284f <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8029d5:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8029da:	c9                   	leave  
  8029db:	c3                   	ret    

008029dc <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029dc:	55                   	push   %ebp
  8029dd:	89 e5                	mov    %esp,%ebp
  8029df:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8029e2:	a1 38 51 80 00       	mov    0x805138,%eax
  8029e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8029ea:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8029ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8029f2:	a1 44 51 80 00       	mov    0x805144,%eax
  8029f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8029fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029fe:	75 68                	jne    802a68 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802a00:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a04:	75 17                	jne    802a1d <insert_sorted_with_merge_freeList+0x41>
  802a06:	83 ec 04             	sub    $0x4,%esp
  802a09:	68 74 40 80 00       	push   $0x804074
  802a0e:	68 da 00 00 00       	push   $0xda
  802a13:	68 97 40 80 00       	push   $0x804097
  802a18:	e8 df d9 ff ff       	call   8003fc <_panic>
  802a1d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802a23:	8b 45 08             	mov    0x8(%ebp),%eax
  802a26:	89 10                	mov    %edx,(%eax)
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	85 c0                	test   %eax,%eax
  802a2f:	74 0d                	je     802a3e <insert_sorted_with_merge_freeList+0x62>
  802a31:	a1 38 51 80 00       	mov    0x805138,%eax
  802a36:	8b 55 08             	mov    0x8(%ebp),%edx
  802a39:	89 50 04             	mov    %edx,0x4(%eax)
  802a3c:	eb 08                	jmp    802a46 <insert_sorted_with_merge_freeList+0x6a>
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	a3 38 51 80 00       	mov    %eax,0x805138
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a58:	a1 44 51 80 00       	mov    0x805144,%eax
  802a5d:	40                   	inc    %eax
  802a5e:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802a63:	e9 49 07 00 00       	jmp    8031b1 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6b:	8b 50 08             	mov    0x8(%eax),%edx
  802a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a71:	8b 40 0c             	mov    0xc(%eax),%eax
  802a74:	01 c2                	add    %eax,%edx
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	8b 40 08             	mov    0x8(%eax),%eax
  802a7c:	39 c2                	cmp    %eax,%edx
  802a7e:	73 77                	jae    802af7 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	75 6e                	jne    802af7 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802a89:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a8d:	74 68                	je     802af7 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802a8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a93:	75 17                	jne    802aac <insert_sorted_with_merge_freeList+0xd0>
  802a95:	83 ec 04             	sub    $0x4,%esp
  802a98:	68 b0 40 80 00       	push   $0x8040b0
  802a9d:	68 e0 00 00 00       	push   $0xe0
  802aa2:	68 97 40 80 00       	push   $0x804097
  802aa7:	e8 50 d9 ff ff       	call   8003fc <_panic>
  802aac:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	89 50 04             	mov    %edx,0x4(%eax)
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	8b 40 04             	mov    0x4(%eax),%eax
  802abe:	85 c0                	test   %eax,%eax
  802ac0:	74 0c                	je     802ace <insert_sorted_with_merge_freeList+0xf2>
  802ac2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ac7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aca:	89 10                	mov    %edx,(%eax)
  802acc:	eb 08                	jmp    802ad6 <insert_sorted_with_merge_freeList+0xfa>
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	a3 38 51 80 00       	mov    %eax,0x805138
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ae7:	a1 44 51 80 00       	mov    0x805144,%eax
  802aec:	40                   	inc    %eax
  802aed:	a3 44 51 80 00       	mov    %eax,0x805144
  802af2:	e9 ba 06 00 00       	jmp    8031b1 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	8b 50 0c             	mov    0xc(%eax),%edx
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	8b 40 08             	mov    0x8(%eax),%eax
  802b03:	01 c2                	add    %eax,%edx
  802b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b08:	8b 40 08             	mov    0x8(%eax),%eax
  802b0b:	39 c2                	cmp    %eax,%edx
  802b0d:	73 78                	jae    802b87 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	75 6e                	jne    802b87 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802b19:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b1d:	74 68                	je     802b87 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802b1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b23:	75 17                	jne    802b3c <insert_sorted_with_merge_freeList+0x160>
  802b25:	83 ec 04             	sub    $0x4,%esp
  802b28:	68 74 40 80 00       	push   $0x804074
  802b2d:	68 e6 00 00 00       	push   $0xe6
  802b32:	68 97 40 80 00       	push   $0x804097
  802b37:	e8 c0 d8 ff ff       	call   8003fc <_panic>
  802b3c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	89 10                	mov    %edx,(%eax)
  802b47:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4a:	8b 00                	mov    (%eax),%eax
  802b4c:	85 c0                	test   %eax,%eax
  802b4e:	74 0d                	je     802b5d <insert_sorted_with_merge_freeList+0x181>
  802b50:	a1 38 51 80 00       	mov    0x805138,%eax
  802b55:	8b 55 08             	mov    0x8(%ebp),%edx
  802b58:	89 50 04             	mov    %edx,0x4(%eax)
  802b5b:	eb 08                	jmp    802b65 <insert_sorted_with_merge_freeList+0x189>
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b65:	8b 45 08             	mov    0x8(%ebp),%eax
  802b68:	a3 38 51 80 00       	mov    %eax,0x805138
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b77:	a1 44 51 80 00       	mov    0x805144,%eax
  802b7c:	40                   	inc    %eax
  802b7d:	a3 44 51 80 00       	mov    %eax,0x805144
  802b82:	e9 2a 06 00 00       	jmp    8031b1 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802b87:	a1 38 51 80 00       	mov    0x805138,%eax
  802b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b8f:	e9 ed 05 00 00       	jmp    803181 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b97:	8b 00                	mov    (%eax),%eax
  802b99:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802b9c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ba0:	0f 84 a7 00 00 00    	je     802c4d <insert_sorted_with_merge_freeList+0x271>
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 50 0c             	mov    0xc(%eax),%edx
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 08             	mov    0x8(%eax),%eax
  802bb2:	01 c2                	add    %eax,%edx
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	8b 40 08             	mov    0x8(%eax),%eax
  802bba:	39 c2                	cmp    %eax,%edx
  802bbc:	0f 83 8b 00 00 00    	jae    802c4d <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc5:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	8b 40 08             	mov    0x8(%eax),%eax
  802bce:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802bd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd3:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802bd6:	39 c2                	cmp    %eax,%edx
  802bd8:	73 73                	jae    802c4d <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802bda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bde:	74 06                	je     802be6 <insert_sorted_with_merge_freeList+0x20a>
  802be0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be4:	75 17                	jne    802bfd <insert_sorted_with_merge_freeList+0x221>
  802be6:	83 ec 04             	sub    $0x4,%esp
  802be9:	68 28 41 80 00       	push   $0x804128
  802bee:	68 f0 00 00 00       	push   $0xf0
  802bf3:	68 97 40 80 00       	push   $0x804097
  802bf8:	e8 ff d7 ff ff       	call   8003fc <_panic>
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 10                	mov    (%eax),%edx
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	89 10                	mov    %edx,(%eax)
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0b                	je     802c1b <insert_sorted_with_merge_freeList+0x23f>
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	8b 55 08             	mov    0x8(%ebp),%edx
  802c18:	89 50 04             	mov    %edx,0x4(%eax)
  802c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c21:	89 10                	mov    %edx,(%eax)
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c29:	89 50 04             	mov    %edx,0x4(%eax)
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	85 c0                	test   %eax,%eax
  802c33:	75 08                	jne    802c3d <insert_sorted_with_merge_freeList+0x261>
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c3d:	a1 44 51 80 00       	mov    0x805144,%eax
  802c42:	40                   	inc    %eax
  802c43:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  802c48:	e9 64 05 00 00       	jmp    8031b1 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802c4d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c52:	8b 50 0c             	mov    0xc(%eax),%edx
  802c55:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c5a:	8b 40 08             	mov    0x8(%eax),%eax
  802c5d:	01 c2                	add    %eax,%edx
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 40 08             	mov    0x8(%eax),%eax
  802c65:	39 c2                	cmp    %eax,%edx
  802c67:	0f 85 b1 00 00 00    	jne    802d1e <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802c6d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c72:	85 c0                	test   %eax,%eax
  802c74:	0f 84 a4 00 00 00    	je     802d1e <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802c7a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c7f:	8b 00                	mov    (%eax),%eax
  802c81:	85 c0                	test   %eax,%eax
  802c83:	0f 85 95 00 00 00    	jne    802d1e <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802c89:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c8e:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802c94:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c97:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9a:	8b 52 0c             	mov    0xc(%edx),%edx
  802c9d:	01 ca                	add    %ecx,%edx
  802c9f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802cb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cba:	75 17                	jne    802cd3 <insert_sorted_with_merge_freeList+0x2f7>
  802cbc:	83 ec 04             	sub    $0x4,%esp
  802cbf:	68 74 40 80 00       	push   $0x804074
  802cc4:	68 ff 00 00 00       	push   $0xff
  802cc9:	68 97 40 80 00       	push   $0x804097
  802cce:	e8 29 d7 ff ff       	call   8003fc <_panic>
  802cd3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	89 10                	mov    %edx,(%eax)
  802cde:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce1:	8b 00                	mov    (%eax),%eax
  802ce3:	85 c0                	test   %eax,%eax
  802ce5:	74 0d                	je     802cf4 <insert_sorted_with_merge_freeList+0x318>
  802ce7:	a1 48 51 80 00       	mov    0x805148,%eax
  802cec:	8b 55 08             	mov    0x8(%ebp),%edx
  802cef:	89 50 04             	mov    %edx,0x4(%eax)
  802cf2:	eb 08                	jmp    802cfc <insert_sorted_with_merge_freeList+0x320>
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	a3 48 51 80 00       	mov    %eax,0x805148
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0e:	a1 54 51 80 00       	mov    0x805154,%eax
  802d13:	40                   	inc    %eax
  802d14:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  802d19:	e9 93 04 00 00       	jmp    8031b1 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d21:	8b 50 08             	mov    0x8(%eax),%edx
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2a:	01 c2                	add    %eax,%edx
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	8b 40 08             	mov    0x8(%eax),%eax
  802d32:	39 c2                	cmp    %eax,%edx
  802d34:	0f 85 ae 00 00 00    	jne    802de8 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 50 0c             	mov    0xc(%eax),%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	8b 40 08             	mov    0x8(%eax),%eax
  802d46:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 00                	mov    (%eax),%eax
  802d4d:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802d50:	39 c2                	cmp    %eax,%edx
  802d52:	0f 84 90 00 00 00    	je     802de8 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	8b 40 0c             	mov    0xc(%eax),%eax
  802d64:	01 c2                	add    %eax,%edx
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d84:	75 17                	jne    802d9d <insert_sorted_with_merge_freeList+0x3c1>
  802d86:	83 ec 04             	sub    $0x4,%esp
  802d89:	68 74 40 80 00       	push   $0x804074
  802d8e:	68 0b 01 00 00       	push   $0x10b
  802d93:	68 97 40 80 00       	push   $0x804097
  802d98:	e8 5f d6 ff ff       	call   8003fc <_panic>
  802d9d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	89 10                	mov    %edx,(%eax)
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	8b 00                	mov    (%eax),%eax
  802dad:	85 c0                	test   %eax,%eax
  802daf:	74 0d                	je     802dbe <insert_sorted_with_merge_freeList+0x3e2>
  802db1:	a1 48 51 80 00       	mov    0x805148,%eax
  802db6:	8b 55 08             	mov    0x8(%ebp),%edx
  802db9:	89 50 04             	mov    %edx,0x4(%eax)
  802dbc:	eb 08                	jmp    802dc6 <insert_sorted_with_merge_freeList+0x3ea>
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	a3 48 51 80 00       	mov    %eax,0x805148
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd8:	a1 54 51 80 00       	mov    0x805154,%eax
  802ddd:	40                   	inc    %eax
  802dde:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  802de3:	e9 c9 03 00 00       	jmp    8031b1 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	8b 40 08             	mov    0x8(%eax),%eax
  802df4:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802dfc:	39 c2                	cmp    %eax,%edx
  802dfe:	0f 85 bb 00 00 00    	jne    802ebf <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802e04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e08:	0f 84 b1 00 00 00    	je     802ebf <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	85 c0                	test   %eax,%eax
  802e16:	0f 85 a3 00 00 00    	jne    802ebf <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802e1c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e21:	8b 55 08             	mov    0x8(%ebp),%edx
  802e24:	8b 52 08             	mov    0x8(%edx),%edx
  802e27:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802e2a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e2f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e35:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802e38:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3b:	8b 52 0c             	mov    0xc(%edx),%edx
  802e3e:	01 ca                	add    %ecx,%edx
  802e40:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e43:	8b 45 08             	mov    0x8(%ebp),%eax
  802e46:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5b:	75 17                	jne    802e74 <insert_sorted_with_merge_freeList+0x498>
  802e5d:	83 ec 04             	sub    $0x4,%esp
  802e60:	68 74 40 80 00       	push   $0x804074
  802e65:	68 17 01 00 00       	push   $0x117
  802e6a:	68 97 40 80 00       	push   $0x804097
  802e6f:	e8 88 d5 ff ff       	call   8003fc <_panic>
  802e74:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	89 10                	mov    %edx,(%eax)
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	8b 00                	mov    (%eax),%eax
  802e84:	85 c0                	test   %eax,%eax
  802e86:	74 0d                	je     802e95 <insert_sorted_with_merge_freeList+0x4b9>
  802e88:	a1 48 51 80 00       	mov    0x805148,%eax
  802e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802e90:	89 50 04             	mov    %edx,0x4(%eax)
  802e93:	eb 08                	jmp    802e9d <insert_sorted_with_merge_freeList+0x4c1>
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	a3 48 51 80 00       	mov    %eax,0x805148
  802ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eaf:	a1 54 51 80 00       	mov    0x805154,%eax
  802eb4:	40                   	inc    %eax
  802eb5:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  802eba:	e9 f2 02 00 00       	jmp    8031b1 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	8b 50 08             	mov    0x8(%eax),%edx
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ecb:	01 c2                	add    %eax,%edx
  802ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed0:	8b 40 08             	mov    0x8(%eax),%eax
  802ed3:	39 c2                	cmp    %eax,%edx
  802ed5:	0f 85 be 00 00 00    	jne    802f99 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ede:	8b 40 04             	mov    0x4(%eax),%eax
  802ee1:	8b 50 08             	mov    0x8(%eax),%edx
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	8b 40 04             	mov    0x4(%eax),%eax
  802eea:	8b 40 0c             	mov    0xc(%eax),%eax
  802eed:	01 c2                	add    %eax,%edx
  802eef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef2:	8b 40 08             	mov    0x8(%eax),%eax
  802ef5:	39 c2                	cmp    %eax,%edx
  802ef7:	0f 84 9c 00 00 00    	je     802f99 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802efd:	8b 45 08             	mov    0x8(%ebp),%eax
  802f00:	8b 50 08             	mov    0x8(%eax),%edx
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	8b 40 0c             	mov    0xc(%eax),%eax
  802f15:	01 c2                	add    %eax,%edx
  802f17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f35:	75 17                	jne    802f4e <insert_sorted_with_merge_freeList+0x572>
  802f37:	83 ec 04             	sub    $0x4,%esp
  802f3a:	68 74 40 80 00       	push   $0x804074
  802f3f:	68 26 01 00 00       	push   $0x126
  802f44:	68 97 40 80 00       	push   $0x804097
  802f49:	e8 ae d4 ff ff       	call   8003fc <_panic>
  802f4e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f54:	8b 45 08             	mov    0x8(%ebp),%eax
  802f57:	89 10                	mov    %edx,(%eax)
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 0d                	je     802f6f <insert_sorted_with_merge_freeList+0x593>
  802f62:	a1 48 51 80 00       	mov    0x805148,%eax
  802f67:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6a:	89 50 04             	mov    %edx,0x4(%eax)
  802f6d:	eb 08                	jmp    802f77 <insert_sorted_with_merge_freeList+0x59b>
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	a3 48 51 80 00       	mov    %eax,0x805148
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f89:	a1 54 51 80 00       	mov    0x805154,%eax
  802f8e:	40                   	inc    %eax
  802f8f:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  802f94:	e9 18 02 00 00       	jmp    8031b1 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 40 08             	mov    0x8(%eax),%eax
  802fa5:	01 c2                	add    %eax,%edx
  802fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802faa:	8b 40 08             	mov    0x8(%eax),%eax
  802fad:	39 c2                	cmp    %eax,%edx
  802faf:	0f 85 c4 01 00 00    	jne    803179 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb8:	8b 50 0c             	mov    0xc(%eax),%edx
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	8b 40 08             	mov    0x8(%eax),%eax
  802fc1:	01 c2                	add    %eax,%edx
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	8b 40 08             	mov    0x8(%eax),%eax
  802fcb:	39 c2                	cmp    %eax,%edx
  802fcd:	0f 85 a6 01 00 00    	jne    803179 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802fd3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fd7:	0f 84 9c 01 00 00    	je     803179 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe9:	01 c2                	add    %eax,%edx
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 00                	mov    (%eax),%eax
  802ff0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff3:	01 c2                	add    %eax,%edx
  802ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff8:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80300f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803013:	75 17                	jne    80302c <insert_sorted_with_merge_freeList+0x650>
  803015:	83 ec 04             	sub    $0x4,%esp
  803018:	68 74 40 80 00       	push   $0x804074
  80301d:	68 32 01 00 00       	push   $0x132
  803022:	68 97 40 80 00       	push   $0x804097
  803027:	e8 d0 d3 ff ff       	call   8003fc <_panic>
  80302c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	89 10                	mov    %edx,(%eax)
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	8b 00                	mov    (%eax),%eax
  80303c:	85 c0                	test   %eax,%eax
  80303e:	74 0d                	je     80304d <insert_sorted_with_merge_freeList+0x671>
  803040:	a1 48 51 80 00       	mov    0x805148,%eax
  803045:	8b 55 08             	mov    0x8(%ebp),%edx
  803048:	89 50 04             	mov    %edx,0x4(%eax)
  80304b:	eb 08                	jmp    803055 <insert_sorted_with_merge_freeList+0x679>
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	a3 48 51 80 00       	mov    %eax,0x805148
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803067:	a1 54 51 80 00       	mov    0x805154,%eax
  80306c:	40                   	inc    %eax
  80306d:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803072:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803075:	8b 00                	mov    (%eax),%eax
  803077:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80307e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803081:	8b 00                	mov    (%eax),%eax
  803083:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80308a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308d:	8b 00                	mov    (%eax),%eax
  80308f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803092:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803096:	75 17                	jne    8030af <insert_sorted_with_merge_freeList+0x6d3>
  803098:	83 ec 04             	sub    $0x4,%esp
  80309b:	68 09 41 80 00       	push   $0x804109
  8030a0:	68 36 01 00 00       	push   $0x136
  8030a5:	68 97 40 80 00       	push   $0x804097
  8030aa:	e8 4d d3 ff ff       	call   8003fc <_panic>
  8030af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b2:	8b 00                	mov    (%eax),%eax
  8030b4:	85 c0                	test   %eax,%eax
  8030b6:	74 10                	je     8030c8 <insert_sorted_with_merge_freeList+0x6ec>
  8030b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030bb:	8b 00                	mov    (%eax),%eax
  8030bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030c0:	8b 52 04             	mov    0x4(%edx),%edx
  8030c3:	89 50 04             	mov    %edx,0x4(%eax)
  8030c6:	eb 0b                	jmp    8030d3 <insert_sorted_with_merge_freeList+0x6f7>
  8030c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cb:	8b 40 04             	mov    0x4(%eax),%eax
  8030ce:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d6:	8b 40 04             	mov    0x4(%eax),%eax
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	74 0f                	je     8030ec <insert_sorted_with_merge_freeList+0x710>
  8030dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e0:	8b 40 04             	mov    0x4(%eax),%eax
  8030e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030e6:	8b 12                	mov    (%edx),%edx
  8030e8:	89 10                	mov    %edx,(%eax)
  8030ea:	eb 0a                	jmp    8030f6 <insert_sorted_with_merge_freeList+0x71a>
  8030ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ef:	8b 00                	mov    (%eax),%eax
  8030f1:	a3 38 51 80 00       	mov    %eax,0x805138
  8030f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803102:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803109:	a1 44 51 80 00       	mov    0x805144,%eax
  80310e:	48                   	dec    %eax
  80310f:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803114:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803118:	75 17                	jne    803131 <insert_sorted_with_merge_freeList+0x755>
  80311a:	83 ec 04             	sub    $0x4,%esp
  80311d:	68 74 40 80 00       	push   $0x804074
  803122:	68 37 01 00 00       	push   $0x137
  803127:	68 97 40 80 00       	push   $0x804097
  80312c:	e8 cb d2 ff ff       	call   8003fc <_panic>
  803131:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803137:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313a:	89 10                	mov    %edx,(%eax)
  80313c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80313f:	8b 00                	mov    (%eax),%eax
  803141:	85 c0                	test   %eax,%eax
  803143:	74 0d                	je     803152 <insert_sorted_with_merge_freeList+0x776>
  803145:	a1 48 51 80 00       	mov    0x805148,%eax
  80314a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80314d:	89 50 04             	mov    %edx,0x4(%eax)
  803150:	eb 08                	jmp    80315a <insert_sorted_with_merge_freeList+0x77e>
  803152:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803155:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80315a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315d:	a3 48 51 80 00       	mov    %eax,0x805148
  803162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803165:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80316c:	a1 54 51 80 00       	mov    0x805154,%eax
  803171:	40                   	inc    %eax
  803172:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803177:	eb 38                	jmp    8031b1 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803179:	a1 40 51 80 00       	mov    0x805140,%eax
  80317e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803181:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803185:	74 07                	je     80318e <insert_sorted_with_merge_freeList+0x7b2>
  803187:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80318a:	8b 00                	mov    (%eax),%eax
  80318c:	eb 05                	jmp    803193 <insert_sorted_with_merge_freeList+0x7b7>
  80318e:	b8 00 00 00 00       	mov    $0x0,%eax
  803193:	a3 40 51 80 00       	mov    %eax,0x805140
  803198:	a1 40 51 80 00       	mov    0x805140,%eax
  80319d:	85 c0                	test   %eax,%eax
  80319f:	0f 85 ef f9 ff ff    	jne    802b94 <insert_sorted_with_merge_freeList+0x1b8>
  8031a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a9:	0f 85 e5 f9 ff ff    	jne    802b94 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8031af:	eb 00                	jmp    8031b1 <insert_sorted_with_merge_freeList+0x7d5>
  8031b1:	90                   	nop
  8031b2:	c9                   	leave  
  8031b3:	c3                   	ret    

008031b4 <__udivdi3>:
  8031b4:	55                   	push   %ebp
  8031b5:	57                   	push   %edi
  8031b6:	56                   	push   %esi
  8031b7:	53                   	push   %ebx
  8031b8:	83 ec 1c             	sub    $0x1c,%esp
  8031bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031cb:	89 ca                	mov    %ecx,%edx
  8031cd:	89 f8                	mov    %edi,%eax
  8031cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031d3:	85 f6                	test   %esi,%esi
  8031d5:	75 2d                	jne    803204 <__udivdi3+0x50>
  8031d7:	39 cf                	cmp    %ecx,%edi
  8031d9:	77 65                	ja     803240 <__udivdi3+0x8c>
  8031db:	89 fd                	mov    %edi,%ebp
  8031dd:	85 ff                	test   %edi,%edi
  8031df:	75 0b                	jne    8031ec <__udivdi3+0x38>
  8031e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8031e6:	31 d2                	xor    %edx,%edx
  8031e8:	f7 f7                	div    %edi
  8031ea:	89 c5                	mov    %eax,%ebp
  8031ec:	31 d2                	xor    %edx,%edx
  8031ee:	89 c8                	mov    %ecx,%eax
  8031f0:	f7 f5                	div    %ebp
  8031f2:	89 c1                	mov    %eax,%ecx
  8031f4:	89 d8                	mov    %ebx,%eax
  8031f6:	f7 f5                	div    %ebp
  8031f8:	89 cf                	mov    %ecx,%edi
  8031fa:	89 fa                	mov    %edi,%edx
  8031fc:	83 c4 1c             	add    $0x1c,%esp
  8031ff:	5b                   	pop    %ebx
  803200:	5e                   	pop    %esi
  803201:	5f                   	pop    %edi
  803202:	5d                   	pop    %ebp
  803203:	c3                   	ret    
  803204:	39 ce                	cmp    %ecx,%esi
  803206:	77 28                	ja     803230 <__udivdi3+0x7c>
  803208:	0f bd fe             	bsr    %esi,%edi
  80320b:	83 f7 1f             	xor    $0x1f,%edi
  80320e:	75 40                	jne    803250 <__udivdi3+0x9c>
  803210:	39 ce                	cmp    %ecx,%esi
  803212:	72 0a                	jb     80321e <__udivdi3+0x6a>
  803214:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803218:	0f 87 9e 00 00 00    	ja     8032bc <__udivdi3+0x108>
  80321e:	b8 01 00 00 00       	mov    $0x1,%eax
  803223:	89 fa                	mov    %edi,%edx
  803225:	83 c4 1c             	add    $0x1c,%esp
  803228:	5b                   	pop    %ebx
  803229:	5e                   	pop    %esi
  80322a:	5f                   	pop    %edi
  80322b:	5d                   	pop    %ebp
  80322c:	c3                   	ret    
  80322d:	8d 76 00             	lea    0x0(%esi),%esi
  803230:	31 ff                	xor    %edi,%edi
  803232:	31 c0                	xor    %eax,%eax
  803234:	89 fa                	mov    %edi,%edx
  803236:	83 c4 1c             	add    $0x1c,%esp
  803239:	5b                   	pop    %ebx
  80323a:	5e                   	pop    %esi
  80323b:	5f                   	pop    %edi
  80323c:	5d                   	pop    %ebp
  80323d:	c3                   	ret    
  80323e:	66 90                	xchg   %ax,%ax
  803240:	89 d8                	mov    %ebx,%eax
  803242:	f7 f7                	div    %edi
  803244:	31 ff                	xor    %edi,%edi
  803246:	89 fa                	mov    %edi,%edx
  803248:	83 c4 1c             	add    $0x1c,%esp
  80324b:	5b                   	pop    %ebx
  80324c:	5e                   	pop    %esi
  80324d:	5f                   	pop    %edi
  80324e:	5d                   	pop    %ebp
  80324f:	c3                   	ret    
  803250:	bd 20 00 00 00       	mov    $0x20,%ebp
  803255:	89 eb                	mov    %ebp,%ebx
  803257:	29 fb                	sub    %edi,%ebx
  803259:	89 f9                	mov    %edi,%ecx
  80325b:	d3 e6                	shl    %cl,%esi
  80325d:	89 c5                	mov    %eax,%ebp
  80325f:	88 d9                	mov    %bl,%cl
  803261:	d3 ed                	shr    %cl,%ebp
  803263:	89 e9                	mov    %ebp,%ecx
  803265:	09 f1                	or     %esi,%ecx
  803267:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80326b:	89 f9                	mov    %edi,%ecx
  80326d:	d3 e0                	shl    %cl,%eax
  80326f:	89 c5                	mov    %eax,%ebp
  803271:	89 d6                	mov    %edx,%esi
  803273:	88 d9                	mov    %bl,%cl
  803275:	d3 ee                	shr    %cl,%esi
  803277:	89 f9                	mov    %edi,%ecx
  803279:	d3 e2                	shl    %cl,%edx
  80327b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80327f:	88 d9                	mov    %bl,%cl
  803281:	d3 e8                	shr    %cl,%eax
  803283:	09 c2                	or     %eax,%edx
  803285:	89 d0                	mov    %edx,%eax
  803287:	89 f2                	mov    %esi,%edx
  803289:	f7 74 24 0c          	divl   0xc(%esp)
  80328d:	89 d6                	mov    %edx,%esi
  80328f:	89 c3                	mov    %eax,%ebx
  803291:	f7 e5                	mul    %ebp
  803293:	39 d6                	cmp    %edx,%esi
  803295:	72 19                	jb     8032b0 <__udivdi3+0xfc>
  803297:	74 0b                	je     8032a4 <__udivdi3+0xf0>
  803299:	89 d8                	mov    %ebx,%eax
  80329b:	31 ff                	xor    %edi,%edi
  80329d:	e9 58 ff ff ff       	jmp    8031fa <__udivdi3+0x46>
  8032a2:	66 90                	xchg   %ax,%ax
  8032a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032a8:	89 f9                	mov    %edi,%ecx
  8032aa:	d3 e2                	shl    %cl,%edx
  8032ac:	39 c2                	cmp    %eax,%edx
  8032ae:	73 e9                	jae    803299 <__udivdi3+0xe5>
  8032b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032b3:	31 ff                	xor    %edi,%edi
  8032b5:	e9 40 ff ff ff       	jmp    8031fa <__udivdi3+0x46>
  8032ba:	66 90                	xchg   %ax,%ax
  8032bc:	31 c0                	xor    %eax,%eax
  8032be:	e9 37 ff ff ff       	jmp    8031fa <__udivdi3+0x46>
  8032c3:	90                   	nop

008032c4 <__umoddi3>:
  8032c4:	55                   	push   %ebp
  8032c5:	57                   	push   %edi
  8032c6:	56                   	push   %esi
  8032c7:	53                   	push   %ebx
  8032c8:	83 ec 1c             	sub    $0x1c,%esp
  8032cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032e3:	89 f3                	mov    %esi,%ebx
  8032e5:	89 fa                	mov    %edi,%edx
  8032e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032eb:	89 34 24             	mov    %esi,(%esp)
  8032ee:	85 c0                	test   %eax,%eax
  8032f0:	75 1a                	jne    80330c <__umoddi3+0x48>
  8032f2:	39 f7                	cmp    %esi,%edi
  8032f4:	0f 86 a2 00 00 00    	jbe    80339c <__umoddi3+0xd8>
  8032fa:	89 c8                	mov    %ecx,%eax
  8032fc:	89 f2                	mov    %esi,%edx
  8032fe:	f7 f7                	div    %edi
  803300:	89 d0                	mov    %edx,%eax
  803302:	31 d2                	xor    %edx,%edx
  803304:	83 c4 1c             	add    $0x1c,%esp
  803307:	5b                   	pop    %ebx
  803308:	5e                   	pop    %esi
  803309:	5f                   	pop    %edi
  80330a:	5d                   	pop    %ebp
  80330b:	c3                   	ret    
  80330c:	39 f0                	cmp    %esi,%eax
  80330e:	0f 87 ac 00 00 00    	ja     8033c0 <__umoddi3+0xfc>
  803314:	0f bd e8             	bsr    %eax,%ebp
  803317:	83 f5 1f             	xor    $0x1f,%ebp
  80331a:	0f 84 ac 00 00 00    	je     8033cc <__umoddi3+0x108>
  803320:	bf 20 00 00 00       	mov    $0x20,%edi
  803325:	29 ef                	sub    %ebp,%edi
  803327:	89 fe                	mov    %edi,%esi
  803329:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80332d:	89 e9                	mov    %ebp,%ecx
  80332f:	d3 e0                	shl    %cl,%eax
  803331:	89 d7                	mov    %edx,%edi
  803333:	89 f1                	mov    %esi,%ecx
  803335:	d3 ef                	shr    %cl,%edi
  803337:	09 c7                	or     %eax,%edi
  803339:	89 e9                	mov    %ebp,%ecx
  80333b:	d3 e2                	shl    %cl,%edx
  80333d:	89 14 24             	mov    %edx,(%esp)
  803340:	89 d8                	mov    %ebx,%eax
  803342:	d3 e0                	shl    %cl,%eax
  803344:	89 c2                	mov    %eax,%edx
  803346:	8b 44 24 08          	mov    0x8(%esp),%eax
  80334a:	d3 e0                	shl    %cl,%eax
  80334c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803350:	8b 44 24 08          	mov    0x8(%esp),%eax
  803354:	89 f1                	mov    %esi,%ecx
  803356:	d3 e8                	shr    %cl,%eax
  803358:	09 d0                	or     %edx,%eax
  80335a:	d3 eb                	shr    %cl,%ebx
  80335c:	89 da                	mov    %ebx,%edx
  80335e:	f7 f7                	div    %edi
  803360:	89 d3                	mov    %edx,%ebx
  803362:	f7 24 24             	mull   (%esp)
  803365:	89 c6                	mov    %eax,%esi
  803367:	89 d1                	mov    %edx,%ecx
  803369:	39 d3                	cmp    %edx,%ebx
  80336b:	0f 82 87 00 00 00    	jb     8033f8 <__umoddi3+0x134>
  803371:	0f 84 91 00 00 00    	je     803408 <__umoddi3+0x144>
  803377:	8b 54 24 04          	mov    0x4(%esp),%edx
  80337b:	29 f2                	sub    %esi,%edx
  80337d:	19 cb                	sbb    %ecx,%ebx
  80337f:	89 d8                	mov    %ebx,%eax
  803381:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803385:	d3 e0                	shl    %cl,%eax
  803387:	89 e9                	mov    %ebp,%ecx
  803389:	d3 ea                	shr    %cl,%edx
  80338b:	09 d0                	or     %edx,%eax
  80338d:	89 e9                	mov    %ebp,%ecx
  80338f:	d3 eb                	shr    %cl,%ebx
  803391:	89 da                	mov    %ebx,%edx
  803393:	83 c4 1c             	add    $0x1c,%esp
  803396:	5b                   	pop    %ebx
  803397:	5e                   	pop    %esi
  803398:	5f                   	pop    %edi
  803399:	5d                   	pop    %ebp
  80339a:	c3                   	ret    
  80339b:	90                   	nop
  80339c:	89 fd                	mov    %edi,%ebp
  80339e:	85 ff                	test   %edi,%edi
  8033a0:	75 0b                	jne    8033ad <__umoddi3+0xe9>
  8033a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8033a7:	31 d2                	xor    %edx,%edx
  8033a9:	f7 f7                	div    %edi
  8033ab:	89 c5                	mov    %eax,%ebp
  8033ad:	89 f0                	mov    %esi,%eax
  8033af:	31 d2                	xor    %edx,%edx
  8033b1:	f7 f5                	div    %ebp
  8033b3:	89 c8                	mov    %ecx,%eax
  8033b5:	f7 f5                	div    %ebp
  8033b7:	89 d0                	mov    %edx,%eax
  8033b9:	e9 44 ff ff ff       	jmp    803302 <__umoddi3+0x3e>
  8033be:	66 90                	xchg   %ax,%ax
  8033c0:	89 c8                	mov    %ecx,%eax
  8033c2:	89 f2                	mov    %esi,%edx
  8033c4:	83 c4 1c             	add    $0x1c,%esp
  8033c7:	5b                   	pop    %ebx
  8033c8:	5e                   	pop    %esi
  8033c9:	5f                   	pop    %edi
  8033ca:	5d                   	pop    %ebp
  8033cb:	c3                   	ret    
  8033cc:	3b 04 24             	cmp    (%esp),%eax
  8033cf:	72 06                	jb     8033d7 <__umoddi3+0x113>
  8033d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033d5:	77 0f                	ja     8033e6 <__umoddi3+0x122>
  8033d7:	89 f2                	mov    %esi,%edx
  8033d9:	29 f9                	sub    %edi,%ecx
  8033db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033df:	89 14 24             	mov    %edx,(%esp)
  8033e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033ea:	8b 14 24             	mov    (%esp),%edx
  8033ed:	83 c4 1c             	add    $0x1c,%esp
  8033f0:	5b                   	pop    %ebx
  8033f1:	5e                   	pop    %esi
  8033f2:	5f                   	pop    %edi
  8033f3:	5d                   	pop    %ebp
  8033f4:	c3                   	ret    
  8033f5:	8d 76 00             	lea    0x0(%esi),%esi
  8033f8:	2b 04 24             	sub    (%esp),%eax
  8033fb:	19 fa                	sbb    %edi,%edx
  8033fd:	89 d1                	mov    %edx,%ecx
  8033ff:	89 c6                	mov    %eax,%esi
  803401:	e9 71 ff ff ff       	jmp    803377 <__umoddi3+0xb3>
  803406:	66 90                	xchg   %ax,%ax
  803408:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80340c:	72 ea                	jb     8033f8 <__umoddi3+0x134>
  80340e:	89 d9                	mov    %ebx,%ecx
  803410:	e9 62 ff ff ff       	jmp    803377 <__umoddi3+0xb3>
