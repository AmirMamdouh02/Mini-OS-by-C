
obj/user/tst_sharing_1:     file format elf32-i386


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
  800031:	e8 27 03 00 00       	call   80035d <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the creation of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 c0 34 80 00       	push   $0x8034c0
  800092:	6a 12                	push   $0x12
  800094:	68 dc 34 80 00       	push   $0x8034dc
  800099:	e8 fb 03 00 00       	call   800499 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 44 16 00 00       	call   8016ec <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x, *y, *z ;
	uint32 expected ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 f4 34 80 00       	push   $0x8034f4
  8000b3:	e8 95 06 00 00       	call   80074d <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000bb:	e8 ca 1a 00 00       	call   801b8a <sys_calculate_free_frames>
  8000c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000c3:	83 ec 04             	sub    $0x4,%esp
  8000c6:	6a 01                	push   $0x1
  8000c8:	68 00 10 00 00       	push   $0x1000
  8000cd:	68 2b 35 80 00       	push   $0x80352b
  8000d2:	e8 90 17 00 00       	call   801867 <smalloc>
  8000d7:	83 c4 10             	add    $0x10,%esp
  8000da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000dd:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000e4:	74 14                	je     8000fa <_main+0xc2>
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	68 30 35 80 00       	push   $0x803530
  8000ee:	6a 1e                	push   $0x1e
  8000f0:	68 dc 34 80 00       	push   $0x8034dc
  8000f5:	e8 9f 03 00 00       	call   800499 <_panic>
		expected = 1+1+2 ;
  8000fa:	c7 45 e0 04 00 00 00 	movl   $0x4,-0x20(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) !=  expected) panic("Wrong allocation (current=%d, expected=%d): make sure that you allocate the required space in the user environment and add its frames to frames_storage", freeFrames - sys_calculate_free_frames(), expected);
  800101:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800104:	e8 81 1a 00 00       	call   801b8a <sys_calculate_free_frames>
  800109:	29 c3                	sub    %eax,%ebx
  80010b:	89 d8                	mov    %ebx,%eax
  80010d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800110:	74 24                	je     800136 <_main+0xfe>
  800112:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800115:	e8 70 1a 00 00       	call   801b8a <sys_calculate_free_frames>
  80011a:	29 c3                	sub    %eax,%ebx
  80011c:	89 d8                	mov    %ebx,%eax
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	ff 75 e0             	pushl  -0x20(%ebp)
  800124:	50                   	push   %eax
  800125:	68 9c 35 80 00       	push   $0x80359c
  80012a:	6a 20                	push   $0x20
  80012c:	68 dc 34 80 00       	push   $0x8034dc
  800131:	e8 63 03 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800136:	e8 4f 1a 00 00       	call   801b8a <sys_calculate_free_frames>
  80013b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("z", PAGE_SIZE + 4, 1);
  80013e:	83 ec 04             	sub    $0x4,%esp
  800141:	6a 01                	push   $0x1
  800143:	68 04 10 00 00       	push   $0x1004
  800148:	68 34 36 80 00       	push   $0x803634
  80014d:	e8 15 17 00 00       	call   801867 <smalloc>
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800158:	81 7d dc 00 10 00 80 	cmpl   $0x80001000,-0x24(%ebp)
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 30 35 80 00       	push   $0x803530
  800169:	6a 24                	push   $0x24
  80016b:	68 dc 34 80 00       	push   $0x8034dc
  800170:	e8 24 03 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800175:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800178:	e8 0d 1a 00 00       	call   801b8a <sys_calculate_free_frames>
  80017d:	29 c3                	sub    %eax,%ebx
  80017f:	89 d8                	mov    %ebx,%eax
  800181:	83 f8 04             	cmp    $0x4,%eax
  800184:	74 14                	je     80019a <_main+0x162>
  800186:	83 ec 04             	sub    $0x4,%esp
  800189:	68 38 36 80 00       	push   $0x803638
  80018e:	6a 25                	push   $0x25
  800190:	68 dc 34 80 00       	push   $0x8034dc
  800195:	e8 ff 02 00 00       	call   800499 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 eb 19 00 00       	call   801b8a <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("y", 4, 1);
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	6a 01                	push   $0x1
  8001a7:	6a 04                	push   $0x4
  8001a9:	68 b6 36 80 00       	push   $0x8036b6
  8001ae:	e8 b4 16 00 00       	call   801867 <smalloc>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001b9:	81 7d d8 00 30 00 80 	cmpl   $0x80003000,-0x28(%ebp)
  8001c0:	74 14                	je     8001d6 <_main+0x19e>
  8001c2:	83 ec 04             	sub    $0x4,%esp
  8001c5:	68 30 35 80 00       	push   $0x803530
  8001ca:	6a 29                	push   $0x29
  8001cc:	68 dc 34 80 00       	push   $0x8034dc
  8001d1:	e8 c3 02 00 00       	call   800499 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001d6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001d9:	e8 ac 19 00 00       	call   801b8a <sys_calculate_free_frames>
  8001de:	29 c3                	sub    %eax,%ebx
  8001e0:	89 d8                	mov    %ebx,%eax
  8001e2:	83 f8 03             	cmp    $0x3,%eax
  8001e5:	74 14                	je     8001fb <_main+0x1c3>
  8001e7:	83 ec 04             	sub    $0x4,%esp
  8001ea:	68 38 36 80 00       	push   $0x803638
  8001ef:	6a 2a                	push   $0x2a
  8001f1:	68 dc 34 80 00       	push   $0x8034dc
  8001f6:	e8 9e 02 00 00       	call   800499 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001fb:	83 ec 0c             	sub    $0xc,%esp
  8001fe:	68 b8 36 80 00       	push   $0x8036b8
  800203:	e8 45 05 00 00       	call   80074d <cprintf>
  800208:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 e0 36 80 00       	push   $0x8036e0
  800213:	e8 35 05 00 00       	call   80074d <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800222:	eb 2d                	jmp    800251 <_main+0x219>
		{
			x[i] = -1;
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80022e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800231:	01 d0                	add    %edx,%eax
  800233:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  800239:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800243:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800246:	01 d0                	add    %edx,%eax
  800248:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  80024e:	ff 45 ec             	incl   -0x14(%ebp)
  800251:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  800258:	7e ca                	jle    800224 <_main+0x1ec>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800261:	eb 18                	jmp    80027b <_main+0x243>
		{
			z[i] = -1;
  800263:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800270:	01 d0                	add    %edx,%eax
  800272:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  800278:	ff 45 ec             	incl   -0x14(%ebp)
  80027b:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800282:	7e df                	jle    800263 <_main+0x22b>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	83 f8 ff             	cmp    $0xffffffff,%eax
  80028c:	74 14                	je     8002a2 <_main+0x26a>
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	68 08 37 80 00       	push   $0x803708
  800296:	6a 3e                	push   $0x3e
  800298:	68 dc 34 80 00       	push   $0x8034dc
  80029d:	e8 f7 01 00 00       	call   800499 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002aa:	8b 00                	mov    (%eax),%eax
  8002ac:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002af:	74 14                	je     8002c5 <_main+0x28d>
  8002b1:	83 ec 04             	sub    $0x4,%esp
  8002b4:	68 08 37 80 00       	push   $0x803708
  8002b9:	6a 3f                	push   $0x3f
  8002bb:	68 dc 34 80 00       	push   $0x8034dc
  8002c0:	e8 d4 01 00 00       	call   800499 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002c8:	8b 00                	mov    (%eax),%eax
  8002ca:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002cd:	74 14                	je     8002e3 <_main+0x2ab>
  8002cf:	83 ec 04             	sub    $0x4,%esp
  8002d2:	68 08 37 80 00       	push   $0x803708
  8002d7:	6a 41                	push   $0x41
  8002d9:	68 dc 34 80 00       	push   $0x8034dc
  8002de:	e8 b6 01 00 00       	call   800499 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e6:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002eb:	8b 00                	mov    (%eax),%eax
  8002ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f0:	74 14                	je     800306 <_main+0x2ce>
  8002f2:	83 ec 04             	sub    $0x4,%esp
  8002f5:	68 08 37 80 00       	push   $0x803708
  8002fa:	6a 42                	push   $0x42
  8002fc:	68 dc 34 80 00       	push   $0x8034dc
  800301:	e8 93 01 00 00       	call   800499 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800306:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800309:	8b 00                	mov    (%eax),%eax
  80030b:	83 f8 ff             	cmp    $0xffffffff,%eax
  80030e:	74 14                	je     800324 <_main+0x2ec>
  800310:	83 ec 04             	sub    $0x4,%esp
  800313:	68 08 37 80 00       	push   $0x803708
  800318:	6a 44                	push   $0x44
  80031a:	68 dc 34 80 00       	push   $0x8034dc
  80031f:	e8 75 01 00 00       	call   800499 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800324:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800327:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  80032c:	8b 00                	mov    (%eax),%eax
  80032e:	83 f8 ff             	cmp    $0xffffffff,%eax
  800331:	74 14                	je     800347 <_main+0x30f>
  800333:	83 ec 04             	sub    $0x4,%esp
  800336:	68 08 37 80 00       	push   $0x803708
  80033b:	6a 45                	push   $0x45
  80033d:	68 dc 34 80 00       	push   $0x8034dc
  800342:	e8 52 01 00 00       	call   800499 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  800347:	83 ec 0c             	sub    $0xc,%esp
  80034a:	68 34 37 80 00       	push   $0x803734
  80034f:	e8 f9 03 00 00       	call   80074d <cprintf>
  800354:	83 c4 10             	add    $0x10,%esp

	return;
  800357:	90                   	nop
}
  800358:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80035b:	c9                   	leave  
  80035c:	c3                   	ret    

0080035d <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800363:	e8 02 1b 00 00       	call   801e6a <sys_getenvindex>
  800368:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80036b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80036e:	89 d0                	mov    %edx,%eax
  800370:	c1 e0 03             	shl    $0x3,%eax
  800373:	01 d0                	add    %edx,%eax
  800375:	01 c0                	add    %eax,%eax
  800377:	01 d0                	add    %edx,%eax
  800379:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800380:	01 d0                	add    %edx,%eax
  800382:	c1 e0 04             	shl    $0x4,%eax
  800385:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80038a:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80038f:	a1 20 40 80 00       	mov    0x804020,%eax
  800394:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80039a:	84 c0                	test   %al,%al
  80039c:	74 0f                	je     8003ad <libmain+0x50>
		binaryname = myEnv->prog_name;
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	05 5c 05 00 00       	add    $0x55c,%eax
  8003a8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003b1:	7e 0a                	jle    8003bd <libmain+0x60>
		binaryname = argv[0];
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b6:	8b 00                	mov    (%eax),%eax
  8003b8:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 0c             	pushl  0xc(%ebp)
  8003c3:	ff 75 08             	pushl  0x8(%ebp)
  8003c6:	e8 6d fc ff ff       	call   800038 <_main>
  8003cb:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003ce:	e8 a4 18 00 00       	call   801c77 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003d3:	83 ec 0c             	sub    $0xc,%esp
  8003d6:	68 a0 37 80 00       	push   $0x8037a0
  8003db:	e8 6d 03 00 00       	call   80074d <cprintf>
  8003e0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e8:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8003ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f3:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8003f9:	83 ec 04             	sub    $0x4,%esp
  8003fc:	52                   	push   %edx
  8003fd:	50                   	push   %eax
  8003fe:	68 c8 37 80 00       	push   $0x8037c8
  800403:	e8 45 03 00 00       	call   80074d <cprintf>
  800408:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800416:	a1 20 40 80 00       	mov    0x804020,%eax
  80041b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80042c:	51                   	push   %ecx
  80042d:	52                   	push   %edx
  80042e:	50                   	push   %eax
  80042f:	68 f0 37 80 00       	push   $0x8037f0
  800434:	e8 14 03 00 00       	call   80074d <cprintf>
  800439:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80043c:	a1 20 40 80 00       	mov    0x804020,%eax
  800441:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800447:	83 ec 08             	sub    $0x8,%esp
  80044a:	50                   	push   %eax
  80044b:	68 48 38 80 00       	push   $0x803848
  800450:	e8 f8 02 00 00       	call   80074d <cprintf>
  800455:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 a0 37 80 00       	push   $0x8037a0
  800460:	e8 e8 02 00 00       	call   80074d <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800468:	e8 24 18 00 00       	call   801c91 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80046d:	e8 19 00 00 00       	call   80048b <exit>
}
  800472:	90                   	nop
  800473:	c9                   	leave  
  800474:	c3                   	ret    

00800475 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80047b:	83 ec 0c             	sub    $0xc,%esp
  80047e:	6a 00                	push   $0x0
  800480:	e8 b1 19 00 00       	call   801e36 <sys_destroy_env>
  800485:	83 c4 10             	add    $0x10,%esp
}
  800488:	90                   	nop
  800489:	c9                   	leave  
  80048a:	c3                   	ret    

0080048b <exit>:

void
exit(void)
{
  80048b:	55                   	push   %ebp
  80048c:	89 e5                	mov    %esp,%ebp
  80048e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800491:	e8 06 1a 00 00       	call   801e9c <sys_exit_env>
}
  800496:	90                   	nop
  800497:	c9                   	leave  
  800498:	c3                   	ret    

00800499 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80049f:	8d 45 10             	lea    0x10(%ebp),%eax
  8004a2:	83 c0 04             	add    $0x4,%eax
  8004a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004ad:	85 c0                	test   %eax,%eax
  8004af:	74 16                	je     8004c7 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004b1:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004b6:	83 ec 08             	sub    $0x8,%esp
  8004b9:	50                   	push   %eax
  8004ba:	68 5c 38 80 00       	push   $0x80385c
  8004bf:	e8 89 02 00 00       	call   80074d <cprintf>
  8004c4:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004c7:	a1 00 40 80 00       	mov    0x804000,%eax
  8004cc:	ff 75 0c             	pushl  0xc(%ebp)
  8004cf:	ff 75 08             	pushl  0x8(%ebp)
  8004d2:	50                   	push   %eax
  8004d3:	68 61 38 80 00       	push   $0x803861
  8004d8:	e8 70 02 00 00       	call   80074d <cprintf>
  8004dd:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8004e9:	50                   	push   %eax
  8004ea:	e8 f3 01 00 00       	call   8006e2 <vcprintf>
  8004ef:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8004f2:	83 ec 08             	sub    $0x8,%esp
  8004f5:	6a 00                	push   $0x0
  8004f7:	68 7d 38 80 00       	push   $0x80387d
  8004fc:	e8 e1 01 00 00       	call   8006e2 <vcprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800504:	e8 82 ff ff ff       	call   80048b <exit>

	// should not return here
	while (1) ;
  800509:	eb fe                	jmp    800509 <_panic+0x70>

0080050b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80050b:	55                   	push   %ebp
  80050c:	89 e5                	mov    %esp,%ebp
  80050e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800511:	a1 20 40 80 00       	mov    0x804020,%eax
  800516:	8b 50 74             	mov    0x74(%eax),%edx
  800519:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 80 38 80 00       	push   $0x803880
  800528:	6a 26                	push   $0x26
  80052a:	68 cc 38 80 00       	push   $0x8038cc
  80052f:	e8 65 ff ff ff       	call   800499 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800534:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80053b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800542:	e9 c2 00 00 00       	jmp    800609 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800551:	8b 45 08             	mov    0x8(%ebp),%eax
  800554:	01 d0                	add    %edx,%eax
  800556:	8b 00                	mov    (%eax),%eax
  800558:	85 c0                	test   %eax,%eax
  80055a:	75 08                	jne    800564 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80055c:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80055f:	e9 a2 00 00 00       	jmp    800606 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800564:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800572:	eb 69                	jmp    8005dd <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800574:	a1 20 40 80 00       	mov    0x804020,%eax
  800579:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80057f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800582:	89 d0                	mov    %edx,%eax
  800584:	01 c0                	add    %eax,%eax
  800586:	01 d0                	add    %edx,%eax
  800588:	c1 e0 03             	shl    $0x3,%eax
  80058b:	01 c8                	add    %ecx,%eax
  80058d:	8a 40 04             	mov    0x4(%eax),%al
  800590:	84 c0                	test   %al,%al
  800592:	75 46                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800594:	a1 20 40 80 00       	mov    0x804020,%eax
  800599:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80059f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005a2:	89 d0                	mov    %edx,%eax
  8005a4:	01 c0                	add    %eax,%eax
  8005a6:	01 d0                	add    %edx,%eax
  8005a8:	c1 e0 03             	shl    $0x3,%eax
  8005ab:	01 c8                	add    %ecx,%eax
  8005ad:	8b 00                	mov    (%eax),%eax
  8005af:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005ba:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005bf:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	01 c8                	add    %ecx,%eax
  8005cb:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	75 09                	jne    8005da <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005d1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005d8:	eb 12                	jmp    8005ec <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005da:	ff 45 e8             	incl   -0x18(%ebp)
  8005dd:	a1 20 40 80 00       	mov    0x804020,%eax
  8005e2:	8b 50 74             	mov    0x74(%eax),%edx
  8005e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8005e8:	39 c2                	cmp    %eax,%edx
  8005ea:	77 88                	ja     800574 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8005ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8005f0:	75 14                	jne    800606 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8005f2:	83 ec 04             	sub    $0x4,%esp
  8005f5:	68 d8 38 80 00       	push   $0x8038d8
  8005fa:	6a 3a                	push   $0x3a
  8005fc:	68 cc 38 80 00       	push   $0x8038cc
  800601:	e8 93 fe ff ff       	call   800499 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800606:	ff 45 f0             	incl   -0x10(%ebp)
  800609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80060f:	0f 8c 32 ff ff ff    	jl     800547 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800615:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800623:	eb 26                	jmp    80064b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800625:	a1 20 40 80 00       	mov    0x804020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	3c 01                	cmp    $0x1,%al
  800643:	75 03                	jne    800648 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800645:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800648:	ff 45 e0             	incl   -0x20(%ebp)
  80064b:	a1 20 40 80 00       	mov    0x804020,%eax
  800650:	8b 50 74             	mov    0x74(%eax),%edx
  800653:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800656:	39 c2                	cmp    %eax,%edx
  800658:	77 cb                	ja     800625 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80065a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80065d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800660:	74 14                	je     800676 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800662:	83 ec 04             	sub    $0x4,%esp
  800665:	68 2c 39 80 00       	push   $0x80392c
  80066a:	6a 44                	push   $0x44
  80066c:	68 cc 38 80 00       	push   $0x8038cc
  800671:	e8 23 fe ff ff       	call   800499 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800676:	90                   	nop
  800677:	c9                   	leave  
  800678:	c3                   	ret    

00800679 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800679:	55                   	push   %ebp
  80067a:	89 e5                	mov    %esp,%ebp
  80067c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80067f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	8d 48 01             	lea    0x1(%eax),%ecx
  800687:	8b 55 0c             	mov    0xc(%ebp),%edx
  80068a:	89 0a                	mov    %ecx,(%edx)
  80068c:	8b 55 08             	mov    0x8(%ebp),%edx
  80068f:	88 d1                	mov    %dl,%cl
  800691:	8b 55 0c             	mov    0xc(%ebp),%edx
  800694:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800698:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069b:	8b 00                	mov    (%eax),%eax
  80069d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a2:	75 2c                	jne    8006d0 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006a4:	a0 24 40 80 00       	mov    0x804024,%al
  8006a9:	0f b6 c0             	movzbl %al,%eax
  8006ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006af:	8b 12                	mov    (%edx),%edx
  8006b1:	89 d1                	mov    %edx,%ecx
  8006b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006b6:	83 c2 08             	add    $0x8,%edx
  8006b9:	83 ec 04             	sub    $0x4,%esp
  8006bc:	50                   	push   %eax
  8006bd:	51                   	push   %ecx
  8006be:	52                   	push   %edx
  8006bf:	e8 05 14 00 00       	call   801ac9 <sys_cputs>
  8006c4:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d3:	8b 40 04             	mov    0x4(%eax),%eax
  8006d6:	8d 50 01             	lea    0x1(%eax),%edx
  8006d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006dc:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006df:	90                   	nop
  8006e0:	c9                   	leave  
  8006e1:	c3                   	ret    

008006e2 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006e2:	55                   	push   %ebp
  8006e3:	89 e5                	mov    %esp,%ebp
  8006e5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006eb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006f2:	00 00 00 
	b.cnt = 0;
  8006f5:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006fc:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8006ff:	ff 75 0c             	pushl  0xc(%ebp)
  800702:	ff 75 08             	pushl  0x8(%ebp)
  800705:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80070b:	50                   	push   %eax
  80070c:	68 79 06 80 00       	push   $0x800679
  800711:	e8 11 02 00 00       	call   800927 <vprintfmt>
  800716:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800719:	a0 24 40 80 00       	mov    0x804024,%al
  80071e:	0f b6 c0             	movzbl %al,%eax
  800721:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800727:	83 ec 04             	sub    $0x4,%esp
  80072a:	50                   	push   %eax
  80072b:	52                   	push   %edx
  80072c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800732:	83 c0 08             	add    $0x8,%eax
  800735:	50                   	push   %eax
  800736:	e8 8e 13 00 00       	call   801ac9 <sys_cputs>
  80073b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80073e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800745:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80074b:	c9                   	leave  
  80074c:	c3                   	ret    

0080074d <cprintf>:

int cprintf(const char *fmt, ...) {
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800753:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80075a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80075d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800760:	8b 45 08             	mov    0x8(%ebp),%eax
  800763:	83 ec 08             	sub    $0x8,%esp
  800766:	ff 75 f4             	pushl  -0xc(%ebp)
  800769:	50                   	push   %eax
  80076a:	e8 73 ff ff ff       	call   8006e2 <vcprintf>
  80076f:	83 c4 10             	add    $0x10,%esp
  800772:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800775:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800778:	c9                   	leave  
  800779:	c3                   	ret    

0080077a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800780:	e8 f2 14 00 00       	call   801c77 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800785:	8d 45 0c             	lea    0xc(%ebp),%eax
  800788:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 f4             	pushl  -0xc(%ebp)
  800794:	50                   	push   %eax
  800795:	e8 48 ff ff ff       	call   8006e2 <vcprintf>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007a0:	e8 ec 14 00 00       	call   801c91 <sys_enable_interrupt>
	return cnt;
  8007a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007a8:	c9                   	leave  
  8007a9:	c3                   	ret    

008007aa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007aa:	55                   	push   %ebp
  8007ab:	89 e5                	mov    %esp,%ebp
  8007ad:	53                   	push   %ebx
  8007ae:	83 ec 14             	sub    $0x14,%esp
  8007b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007bd:	8b 45 18             	mov    0x18(%ebp),%eax
  8007c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c5:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007c8:	77 55                	ja     80081f <printnum+0x75>
  8007ca:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007cd:	72 05                	jb     8007d4 <printnum+0x2a>
  8007cf:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007d2:	77 4b                	ja     80081f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007d4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007d7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007da:	8b 45 18             	mov    0x18(%ebp),%eax
  8007dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e2:	52                   	push   %edx
  8007e3:	50                   	push   %eax
  8007e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e7:	ff 75 f0             	pushl  -0x10(%ebp)
  8007ea:	e8 65 2a 00 00       	call   803254 <__udivdi3>
  8007ef:	83 c4 10             	add    $0x10,%esp
  8007f2:	83 ec 04             	sub    $0x4,%esp
  8007f5:	ff 75 20             	pushl  0x20(%ebp)
  8007f8:	53                   	push   %ebx
  8007f9:	ff 75 18             	pushl  0x18(%ebp)
  8007fc:	52                   	push   %edx
  8007fd:	50                   	push   %eax
  8007fe:	ff 75 0c             	pushl  0xc(%ebp)
  800801:	ff 75 08             	pushl  0x8(%ebp)
  800804:	e8 a1 ff ff ff       	call   8007aa <printnum>
  800809:	83 c4 20             	add    $0x20,%esp
  80080c:	eb 1a                	jmp    800828 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80080e:	83 ec 08             	sub    $0x8,%esp
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	ff 75 20             	pushl  0x20(%ebp)
  800817:	8b 45 08             	mov    0x8(%ebp),%eax
  80081a:	ff d0                	call   *%eax
  80081c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80081f:	ff 4d 1c             	decl   0x1c(%ebp)
  800822:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800826:	7f e6                	jg     80080e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800828:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80082b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800833:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800836:	53                   	push   %ebx
  800837:	51                   	push   %ecx
  800838:	52                   	push   %edx
  800839:	50                   	push   %eax
  80083a:	e8 25 2b 00 00       	call   803364 <__umoddi3>
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	05 94 3b 80 00       	add    $0x803b94,%eax
  800847:	8a 00                	mov    (%eax),%al
  800849:	0f be c0             	movsbl %al,%eax
  80084c:	83 ec 08             	sub    $0x8,%esp
  80084f:	ff 75 0c             	pushl  0xc(%ebp)
  800852:	50                   	push   %eax
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	ff d0                	call   *%eax
  800858:	83 c4 10             	add    $0x10,%esp
}
  80085b:	90                   	nop
  80085c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80085f:	c9                   	leave  
  800860:	c3                   	ret    

00800861 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800864:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800868:	7e 1c                	jle    800886 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	8d 50 08             	lea    0x8(%eax),%edx
  800872:	8b 45 08             	mov    0x8(%ebp),%eax
  800875:	89 10                	mov    %edx,(%eax)
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 00                	mov    (%eax),%eax
  80087c:	83 e8 08             	sub    $0x8,%eax
  80087f:	8b 50 04             	mov    0x4(%eax),%edx
  800882:	8b 00                	mov    (%eax),%eax
  800884:	eb 40                	jmp    8008c6 <getuint+0x65>
	else if (lflag)
  800886:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80088a:	74 1e                	je     8008aa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	8b 00                	mov    (%eax),%eax
  800891:	8d 50 04             	lea    0x4(%eax),%edx
  800894:	8b 45 08             	mov    0x8(%ebp),%eax
  800897:	89 10                	mov    %edx,(%eax)
  800899:	8b 45 08             	mov    0x8(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 00                	mov    (%eax),%eax
  8008a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008a8:	eb 1c                	jmp    8008c6 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ad:	8b 00                	mov    (%eax),%eax
  8008af:	8d 50 04             	lea    0x4(%eax),%edx
  8008b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b5:	89 10                	mov    %edx,(%eax)
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 00                	mov    (%eax),%eax
  8008bc:	83 e8 04             	sub    $0x4,%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008cb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008cf:	7e 1c                	jle    8008ed <getint+0x25>
		return va_arg(*ap, long long);
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	8d 50 08             	lea    0x8(%eax),%edx
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	89 10                	mov    %edx,(%eax)
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 00                	mov    (%eax),%eax
  8008e3:	83 e8 08             	sub    $0x8,%eax
  8008e6:	8b 50 04             	mov    0x4(%eax),%edx
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	eb 38                	jmp    800925 <getint+0x5d>
	else if (lflag)
  8008ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008f1:	74 1a                	je     80090d <getint+0x45>
		return va_arg(*ap, long);
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	8b 00                	mov    (%eax),%eax
  8008f8:	8d 50 04             	lea    0x4(%eax),%edx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	89 10                	mov    %edx,(%eax)
  800900:	8b 45 08             	mov    0x8(%ebp),%eax
  800903:	8b 00                	mov    (%eax),%eax
  800905:	83 e8 04             	sub    $0x4,%eax
  800908:	8b 00                	mov    (%eax),%eax
  80090a:	99                   	cltd   
  80090b:	eb 18                	jmp    800925 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	99                   	cltd   
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	56                   	push   %esi
  80092b:	53                   	push   %ebx
  80092c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80092f:	eb 17                	jmp    800948 <vprintfmt+0x21>
			if (ch == '\0')
  800931:	85 db                	test   %ebx,%ebx
  800933:	0f 84 af 03 00 00    	je     800ce8 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	53                   	push   %ebx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	ff d0                	call   *%eax
  800945:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800948:	8b 45 10             	mov    0x10(%ebp),%eax
  80094b:	8d 50 01             	lea    0x1(%eax),%edx
  80094e:	89 55 10             	mov    %edx,0x10(%ebp)
  800951:	8a 00                	mov    (%eax),%al
  800953:	0f b6 d8             	movzbl %al,%ebx
  800956:	83 fb 25             	cmp    $0x25,%ebx
  800959:	75 d6                	jne    800931 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80095b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80095f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800966:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80096d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800974:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097b:	8b 45 10             	mov    0x10(%ebp),%eax
  80097e:	8d 50 01             	lea    0x1(%eax),%edx
  800981:	89 55 10             	mov    %edx,0x10(%ebp)
  800984:	8a 00                	mov    (%eax),%al
  800986:	0f b6 d8             	movzbl %al,%ebx
  800989:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80098c:	83 f8 55             	cmp    $0x55,%eax
  80098f:	0f 87 2b 03 00 00    	ja     800cc0 <vprintfmt+0x399>
  800995:	8b 04 85 b8 3b 80 00 	mov    0x803bb8(,%eax,4),%eax
  80099c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80099e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009a2:	eb d7                	jmp    80097b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009a4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009a8:	eb d1                	jmp    80097b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009aa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009b4:	89 d0                	mov    %edx,%eax
  8009b6:	c1 e0 02             	shl    $0x2,%eax
  8009b9:	01 d0                	add    %edx,%eax
  8009bb:	01 c0                	add    %eax,%eax
  8009bd:	01 d8                	add    %ebx,%eax
  8009bf:	83 e8 30             	sub    $0x30,%eax
  8009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c8:	8a 00                	mov    (%eax),%al
  8009ca:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009cd:	83 fb 2f             	cmp    $0x2f,%ebx
  8009d0:	7e 3e                	jle    800a10 <vprintfmt+0xe9>
  8009d2:	83 fb 39             	cmp    $0x39,%ebx
  8009d5:	7f 39                	jg     800a10 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009d7:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009da:	eb d5                	jmp    8009b1 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8009df:	83 c0 04             	add    $0x4,%eax
  8009e2:	89 45 14             	mov    %eax,0x14(%ebp)
  8009e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e8:	83 e8 04             	sub    $0x4,%eax
  8009eb:	8b 00                	mov    (%eax),%eax
  8009ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8009f0:	eb 1f                	jmp    800a11 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8009f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f6:	79 83                	jns    80097b <vprintfmt+0x54>
				width = 0;
  8009f8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8009ff:	e9 77 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a04:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a0b:	e9 6b ff ff ff       	jmp    80097b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a10:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a11:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a15:	0f 89 60 ff ff ff    	jns    80097b <vprintfmt+0x54>
				width = precision, precision = -1;
  800a1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a21:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a28:	e9 4e ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a2d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a30:	e9 46 ff ff ff       	jmp    80097b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a35:	8b 45 14             	mov    0x14(%ebp),%eax
  800a38:	83 c0 04             	add    $0x4,%eax
  800a3b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 e8 04             	sub    $0x4,%eax
  800a44:	8b 00                	mov    (%eax),%eax
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	ff 75 0c             	pushl  0xc(%ebp)
  800a4c:	50                   	push   %eax
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
			break;
  800a55:	e9 89 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a5a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5d:	83 c0 04             	add    $0x4,%eax
  800a60:	89 45 14             	mov    %eax,0x14(%ebp)
  800a63:	8b 45 14             	mov    0x14(%ebp),%eax
  800a66:	83 e8 04             	sub    $0x4,%eax
  800a69:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a6b:	85 db                	test   %ebx,%ebx
  800a6d:	79 02                	jns    800a71 <vprintfmt+0x14a>
				err = -err;
  800a6f:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a71:	83 fb 64             	cmp    $0x64,%ebx
  800a74:	7f 0b                	jg     800a81 <vprintfmt+0x15a>
  800a76:	8b 34 9d 00 3a 80 00 	mov    0x803a00(,%ebx,4),%esi
  800a7d:	85 f6                	test   %esi,%esi
  800a7f:	75 19                	jne    800a9a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a81:	53                   	push   %ebx
  800a82:	68 a5 3b 80 00       	push   $0x803ba5
  800a87:	ff 75 0c             	pushl  0xc(%ebp)
  800a8a:	ff 75 08             	pushl  0x8(%ebp)
  800a8d:	e8 5e 02 00 00       	call   800cf0 <printfmt>
  800a92:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800a95:	e9 49 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a9a:	56                   	push   %esi
  800a9b:	68 ae 3b 80 00       	push   $0x803bae
  800aa0:	ff 75 0c             	pushl  0xc(%ebp)
  800aa3:	ff 75 08             	pushl  0x8(%ebp)
  800aa6:	e8 45 02 00 00       	call   800cf0 <printfmt>
  800aab:	83 c4 10             	add    $0x10,%esp
			break;
  800aae:	e9 30 02 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab6:	83 c0 04             	add    $0x4,%eax
  800ab9:	89 45 14             	mov    %eax,0x14(%ebp)
  800abc:	8b 45 14             	mov    0x14(%ebp),%eax
  800abf:	83 e8 04             	sub    $0x4,%eax
  800ac2:	8b 30                	mov    (%eax),%esi
  800ac4:	85 f6                	test   %esi,%esi
  800ac6:	75 05                	jne    800acd <vprintfmt+0x1a6>
				p = "(null)";
  800ac8:	be b1 3b 80 00       	mov    $0x803bb1,%esi
			if (width > 0 && padc != '-')
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7e 6d                	jle    800b40 <vprintfmt+0x219>
  800ad3:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800ad7:	74 67                	je     800b40 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800adc:	83 ec 08             	sub    $0x8,%esp
  800adf:	50                   	push   %eax
  800ae0:	56                   	push   %esi
  800ae1:	e8 0c 03 00 00       	call   800df2 <strnlen>
  800ae6:	83 c4 10             	add    $0x10,%esp
  800ae9:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800aec:	eb 16                	jmp    800b04 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800aee:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800af2:	83 ec 08             	sub    $0x8,%esp
  800af5:	ff 75 0c             	pushl  0xc(%ebp)
  800af8:	50                   	push   %eax
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	ff d0                	call   *%eax
  800afe:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b01:	ff 4d e4             	decl   -0x1c(%ebp)
  800b04:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b08:	7f e4                	jg     800aee <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b0a:	eb 34                	jmp    800b40 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b0c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b10:	74 1c                	je     800b2e <vprintfmt+0x207>
  800b12:	83 fb 1f             	cmp    $0x1f,%ebx
  800b15:	7e 05                	jle    800b1c <vprintfmt+0x1f5>
  800b17:	83 fb 7e             	cmp    $0x7e,%ebx
  800b1a:	7e 12                	jle    800b2e <vprintfmt+0x207>
					putch('?', putdat);
  800b1c:	83 ec 08             	sub    $0x8,%esp
  800b1f:	ff 75 0c             	pushl  0xc(%ebp)
  800b22:	6a 3f                	push   $0x3f
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	ff d0                	call   *%eax
  800b29:	83 c4 10             	add    $0x10,%esp
  800b2c:	eb 0f                	jmp    800b3d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	53                   	push   %ebx
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	ff d0                	call   *%eax
  800b3a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b3d:	ff 4d e4             	decl   -0x1c(%ebp)
  800b40:	89 f0                	mov    %esi,%eax
  800b42:	8d 70 01             	lea    0x1(%eax),%esi
  800b45:	8a 00                	mov    (%eax),%al
  800b47:	0f be d8             	movsbl %al,%ebx
  800b4a:	85 db                	test   %ebx,%ebx
  800b4c:	74 24                	je     800b72 <vprintfmt+0x24b>
  800b4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b52:	78 b8                	js     800b0c <vprintfmt+0x1e5>
  800b54:	ff 4d e0             	decl   -0x20(%ebp)
  800b57:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b5b:	79 af                	jns    800b0c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5d:	eb 13                	jmp    800b72 <vprintfmt+0x24b>
				putch(' ', putdat);
  800b5f:	83 ec 08             	sub    $0x8,%esp
  800b62:	ff 75 0c             	pushl  0xc(%ebp)
  800b65:	6a 20                	push   $0x20
  800b67:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6a:	ff d0                	call   *%eax
  800b6c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b6f:	ff 4d e4             	decl   -0x1c(%ebp)
  800b72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b76:	7f e7                	jg     800b5f <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b78:	e9 66 01 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 e8             	pushl  -0x18(%ebp)
  800b83:	8d 45 14             	lea    0x14(%ebp),%eax
  800b86:	50                   	push   %eax
  800b87:	e8 3c fd ff ff       	call   8008c8 <getint>
  800b8c:	83 c4 10             	add    $0x10,%esp
  800b8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b92:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800b95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9b:	85 d2                	test   %edx,%edx
  800b9d:	79 23                	jns    800bc2 <vprintfmt+0x29b>
				putch('-', putdat);
  800b9f:	83 ec 08             	sub    $0x8,%esp
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	6a 2d                	push   $0x2d
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	ff d0                	call   *%eax
  800bac:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb5:	f7 d8                	neg    %eax
  800bb7:	83 d2 00             	adc    $0x0,%edx
  800bba:	f7 da                	neg    %edx
  800bbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bc2:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bc9:	e9 bc 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bce:	83 ec 08             	sub    $0x8,%esp
  800bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd4:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd7:	50                   	push   %eax
  800bd8:	e8 84 fc ff ff       	call   800861 <getuint>
  800bdd:	83 c4 10             	add    $0x10,%esp
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800be6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800bed:	e9 98 00 00 00       	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
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
			putch('X', putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	6a 58                	push   $0x58
  800c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1d:	ff d0                	call   *%eax
  800c1f:	83 c4 10             	add    $0x10,%esp
			break;
  800c22:	e9 bc 00 00 00       	jmp    800ce3 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	ff 75 0c             	pushl  0xc(%ebp)
  800c2d:	6a 30                	push   $0x30
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	ff d0                	call   *%eax
  800c34:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c37:	83 ec 08             	sub    $0x8,%esp
  800c3a:	ff 75 0c             	pushl  0xc(%ebp)
  800c3d:	6a 78                	push   $0x78
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	ff d0                	call   *%eax
  800c44:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c47:	8b 45 14             	mov    0x14(%ebp),%eax
  800c4a:	83 c0 04             	add    $0x4,%eax
  800c4d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c50:	8b 45 14             	mov    0x14(%ebp),%eax
  800c53:	83 e8 04             	sub    $0x4,%eax
  800c56:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c62:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c69:	eb 1f                	jmp    800c8a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c6b:	83 ec 08             	sub    $0x8,%esp
  800c6e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c71:	8d 45 14             	lea    0x14(%ebp),%eax
  800c74:	50                   	push   %eax
  800c75:	e8 e7 fb ff ff       	call   800861 <getuint>
  800c7a:	83 c4 10             	add    $0x10,%esp
  800c7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c80:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c83:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c91:	83 ec 04             	sub    $0x4,%esp
  800c94:	52                   	push   %edx
  800c95:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c98:	50                   	push   %eax
  800c99:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9c:	ff 75 f0             	pushl  -0x10(%ebp)
  800c9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ca2:	ff 75 08             	pushl  0x8(%ebp)
  800ca5:	e8 00 fb ff ff       	call   8007aa <printnum>
  800caa:	83 c4 20             	add    $0x20,%esp
			break;
  800cad:	eb 34                	jmp    800ce3 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800caf:	83 ec 08             	sub    $0x8,%esp
  800cb2:	ff 75 0c             	pushl  0xc(%ebp)
  800cb5:	53                   	push   %ebx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	ff d0                	call   *%eax
  800cbb:	83 c4 10             	add    $0x10,%esp
			break;
  800cbe:	eb 23                	jmp    800ce3 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cc0:	83 ec 08             	sub    $0x8,%esp
  800cc3:	ff 75 0c             	pushl  0xc(%ebp)
  800cc6:	6a 25                	push   $0x25
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	ff d0                	call   *%eax
  800ccd:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd0:	ff 4d 10             	decl   0x10(%ebp)
  800cd3:	eb 03                	jmp    800cd8 <vprintfmt+0x3b1>
  800cd5:	ff 4d 10             	decl   0x10(%ebp)
  800cd8:	8b 45 10             	mov    0x10(%ebp),%eax
  800cdb:	48                   	dec    %eax
  800cdc:	8a 00                	mov    (%eax),%al
  800cde:	3c 25                	cmp    $0x25,%al
  800ce0:	75 f3                	jne    800cd5 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ce2:	90                   	nop
		}
	}
  800ce3:	e9 47 fc ff ff       	jmp    80092f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ce8:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ce9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800cf6:	8d 45 10             	lea    0x10(%ebp),%eax
  800cf9:	83 c0 04             	add    $0x4,%eax
  800cfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800cff:	8b 45 10             	mov    0x10(%ebp),%eax
  800d02:	ff 75 f4             	pushl  -0xc(%ebp)
  800d05:	50                   	push   %eax
  800d06:	ff 75 0c             	pushl  0xc(%ebp)
  800d09:	ff 75 08             	pushl  0x8(%ebp)
  800d0c:	e8 16 fc ff ff       	call   800927 <vprintfmt>
  800d11:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d14:	90                   	nop
  800d15:	c9                   	leave  
  800d16:	c3                   	ret    

00800d17 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8b 40 08             	mov    0x8(%eax),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d26:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8b 10                	mov    (%eax),%edx
  800d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d31:	8b 40 04             	mov    0x4(%eax),%eax
  800d34:	39 c2                	cmp    %eax,%edx
  800d36:	73 12                	jae    800d4a <sprintputch+0x33>
		*b->buf++ = ch;
  800d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3b:	8b 00                	mov    (%eax),%eax
  800d3d:	8d 48 01             	lea    0x1(%eax),%ecx
  800d40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d43:	89 0a                	mov    %ecx,(%edx)
  800d45:	8b 55 08             	mov    0x8(%ebp),%edx
  800d48:	88 10                	mov    %dl,(%eax)
}
  800d4a:	90                   	nop
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d53:	8b 45 08             	mov    0x8(%ebp),%eax
  800d56:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	01 d0                	add    %edx,%eax
  800d64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d72:	74 06                	je     800d7a <vsnprintf+0x2d>
  800d74:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d78:	7f 07                	jg     800d81 <vsnprintf+0x34>
		return -E_INVAL;
  800d7a:	b8 03 00 00 00       	mov    $0x3,%eax
  800d7f:	eb 20                	jmp    800da1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d81:	ff 75 14             	pushl  0x14(%ebp)
  800d84:	ff 75 10             	pushl  0x10(%ebp)
  800d87:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	68 17 0d 80 00       	push   $0x800d17
  800d90:	e8 92 fb ff ff       	call   800927 <vprintfmt>
  800d95:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800d98:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d9b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da9:	8d 45 10             	lea    0x10(%ebp),%eax
  800dac:	83 c0 04             	add    $0x4,%eax
  800daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	ff 75 f4             	pushl  -0xc(%ebp)
  800db8:	50                   	push   %eax
  800db9:	ff 75 0c             	pushl  0xc(%ebp)
  800dbc:	ff 75 08             	pushl  0x8(%ebp)
  800dbf:	e8 89 ff ff ff       	call   800d4d <vsnprintf>
  800dc4:	83 c4 10             	add    $0x10,%esp
  800dc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800dcd:	c9                   	leave  
  800dce:	c3                   	ret    

00800dcf <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800dcf:	55                   	push   %ebp
  800dd0:	89 e5                	mov    %esp,%ebp
  800dd2:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800dd5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ddc:	eb 06                	jmp    800de4 <strlen+0x15>
		n++;
  800dde:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 f1                	jne    800dde <strlen+0xf>
		n++;
	return n;
  800ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800df8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dff:	eb 09                	jmp    800e0a <strnlen+0x18>
		n++;
  800e01:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e04:	ff 45 08             	incl   0x8(%ebp)
  800e07:	ff 4d 0c             	decl   0xc(%ebp)
  800e0a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e0e:	74 09                	je     800e19 <strnlen+0x27>
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 e8                	jne    800e01 <strnlen+0xf>
		n++;
	return n;
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e2a:	90                   	nop
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8d 50 01             	lea    0x1(%eax),%edx
  800e31:	89 55 08             	mov    %edx,0x8(%ebp)
  800e34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e37:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e3a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e3d:	8a 12                	mov    (%edx),%dl
  800e3f:	88 10                	mov    %dl,(%eax)
  800e41:	8a 00                	mov    (%eax),%al
  800e43:	84 c0                	test   %al,%al
  800e45:	75 e4                	jne    800e2b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e4a:	c9                   	leave  
  800e4b:	c3                   	ret    

00800e4c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e4c:	55                   	push   %ebp
  800e4d:	89 e5                	mov    %esp,%ebp
  800e4f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e5f:	eb 1f                	jmp    800e80 <strncpy+0x34>
		*dst++ = *src;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	8d 50 01             	lea    0x1(%eax),%edx
  800e67:	89 55 08             	mov    %edx,0x8(%ebp)
  800e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e74:	8a 00                	mov    (%eax),%al
  800e76:	84 c0                	test   %al,%al
  800e78:	74 03                	je     800e7d <strncpy+0x31>
			src++;
  800e7a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e7d:	ff 45 fc             	incl   -0x4(%ebp)
  800e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e83:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e86:	72 d9                	jb     800e61 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800e88:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800e8b:	c9                   	leave  
  800e8c:	c3                   	ret    

00800e8d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	74 30                	je     800ecf <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800e9f:	eb 16                	jmp    800eb7 <strlcpy+0x2a>
			*dst++ = *src++;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 08             	mov    %edx,0x8(%ebp)
  800eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800eb7:	ff 4d 10             	decl   0x10(%ebp)
  800eba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ebe:	74 09                	je     800ec9 <strlcpy+0x3c>
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	84 c0                	test   %al,%al
  800ec7:	75 d8                	jne    800ea1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ecf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed5:	29 c2                	sub    %eax,%edx
  800ed7:	89 d0                	mov    %edx,%eax
}
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ede:	eb 06                	jmp    800ee6 <strcmp+0xb>
		p++, q++;
  800ee0:	ff 45 08             	incl   0x8(%ebp)
  800ee3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8a 00                	mov    (%eax),%al
  800eeb:	84 c0                	test   %al,%al
  800eed:	74 0e                	je     800efd <strcmp+0x22>
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 10                	mov    (%eax),%dl
  800ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef7:	8a 00                	mov    (%eax),%al
  800ef9:	38 c2                	cmp    %al,%dl
  800efb:	74 e3                	je     800ee0 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	0f b6 d0             	movzbl %al,%edx
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	8a 00                	mov    (%eax),%al
  800f0a:	0f b6 c0             	movzbl %al,%eax
  800f0d:	29 c2                	sub    %eax,%edx
  800f0f:	89 d0                	mov    %edx,%eax
}
  800f11:	5d                   	pop    %ebp
  800f12:	c3                   	ret    

00800f13 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f16:	eb 09                	jmp    800f21 <strncmp+0xe>
		n--, p++, q++;
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	ff 45 08             	incl   0x8(%ebp)
  800f1e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f21:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f25:	74 17                	je     800f3e <strncmp+0x2b>
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	84 c0                	test   %al,%al
  800f2e:	74 0e                	je     800f3e <strncmp+0x2b>
  800f30:	8b 45 08             	mov    0x8(%ebp),%eax
  800f33:	8a 10                	mov    (%eax),%dl
  800f35:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	38 c2                	cmp    %al,%dl
  800f3c:	74 da                	je     800f18 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f42:	75 07                	jne    800f4b <strncmp+0x38>
		return 0;
  800f44:	b8 00 00 00 00       	mov    $0x0,%eax
  800f49:	eb 14                	jmp    800f5f <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 d0             	movzbl %al,%edx
  800f53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	0f b6 c0             	movzbl %al,%eax
  800f5b:	29 c2                	sub    %eax,%edx
  800f5d:	89 d0                	mov    %edx,%eax
}
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	83 ec 04             	sub    $0x4,%esp
  800f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f6d:	eb 12                	jmp    800f81 <strchr+0x20>
		if (*s == c)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f77:	75 05                	jne    800f7e <strchr+0x1d>
			return (char *) s;
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	eb 11                	jmp    800f8f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f7e:	ff 45 08             	incl   0x8(%ebp)
  800f81:	8b 45 08             	mov    0x8(%ebp),%eax
  800f84:	8a 00                	mov    (%eax),%al
  800f86:	84 c0                	test   %al,%al
  800f88:	75 e5                	jne    800f6f <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800f8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f8f:	c9                   	leave  
  800f90:	c3                   	ret    

00800f91 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f91:	55                   	push   %ebp
  800f92:	89 e5                	mov    %esp,%ebp
  800f94:	83 ec 04             	sub    $0x4,%esp
  800f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f9d:	eb 0d                	jmp    800fac <strfind+0x1b>
		if (*s == c)
  800f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa2:	8a 00                	mov    (%eax),%al
  800fa4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fa7:	74 0e                	je     800fb7 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	75 ea                	jne    800f9f <strfind+0xe>
  800fb5:	eb 01                	jmp    800fb8 <strfind+0x27>
		if (*s == c)
			break;
  800fb7:	90                   	nop
	return (char *) s;
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fcf:	eb 0e                	jmp    800fdf <memset+0x22>
		*p++ = c;
  800fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fd4:	8d 50 01             	lea    0x1(%eax),%edx
  800fd7:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800fda:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fdd:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800fdf:	ff 4d f8             	decl   -0x8(%ebp)
  800fe2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800fe6:	79 e9                	jns    800fd1 <memset+0x14>
		*p++ = c;

	return v;
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800feb:	c9                   	leave  
  800fec:	c3                   	ret    

00800fed <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800fed:	55                   	push   %ebp
  800fee:	89 e5                	mov    %esp,%ebp
  800ff0:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800fff:	eb 16                	jmp    801017 <memcpy+0x2a>
		*d++ = *s++;
  801001:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801004:	8d 50 01             	lea    0x1(%eax),%edx
  801007:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80100a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80100d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801010:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801013:	8a 12                	mov    (%edx),%dl
  801015:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801017:	8b 45 10             	mov    0x10(%ebp),%eax
  80101a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80101d:	89 55 10             	mov    %edx,0x10(%ebp)
  801020:	85 c0                	test   %eax,%eax
  801022:	75 dd                	jne    801001 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801027:	c9                   	leave  
  801028:	c3                   	ret    

00801029 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80102f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80103b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80103e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801041:	73 50                	jae    801093 <memmove+0x6a>
  801043:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801046:	8b 45 10             	mov    0x10(%ebp),%eax
  801049:	01 d0                	add    %edx,%eax
  80104b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80104e:	76 43                	jbe    801093 <memmove+0x6a>
		s += n;
  801050:	8b 45 10             	mov    0x10(%ebp),%eax
  801053:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801056:	8b 45 10             	mov    0x10(%ebp),%eax
  801059:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80105c:	eb 10                	jmp    80106e <memmove+0x45>
			*--d = *--s;
  80105e:	ff 4d f8             	decl   -0x8(%ebp)
  801061:	ff 4d fc             	decl   -0x4(%ebp)
  801064:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801067:	8a 10                	mov    (%eax),%dl
  801069:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80106c:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80106e:	8b 45 10             	mov    0x10(%ebp),%eax
  801071:	8d 50 ff             	lea    -0x1(%eax),%edx
  801074:	89 55 10             	mov    %edx,0x10(%ebp)
  801077:	85 c0                	test   %eax,%eax
  801079:	75 e3                	jne    80105e <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80107b:	eb 23                	jmp    8010a0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80107d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801080:	8d 50 01             	lea    0x1(%eax),%edx
  801083:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801086:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801089:	8d 4a 01             	lea    0x1(%edx),%ecx
  80108c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80108f:	8a 12                	mov    (%edx),%dl
  801091:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	8d 50 ff             	lea    -0x1(%eax),%edx
  801099:	89 55 10             	mov    %edx,0x10(%ebp)
  80109c:	85 c0                	test   %eax,%eax
  80109e:	75 dd                	jne    80107d <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010b7:	eb 2a                	jmp    8010e3 <memcmp+0x3e>
		if (*s1 != *s2)
  8010b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010bc:	8a 10                	mov    (%eax),%dl
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010c1:	8a 00                	mov    (%eax),%al
  8010c3:	38 c2                	cmp    %al,%dl
  8010c5:	74 16                	je     8010dd <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ca:	8a 00                	mov    (%eax),%al
  8010cc:	0f b6 d0             	movzbl %al,%edx
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	0f b6 c0             	movzbl %al,%eax
  8010d7:	29 c2                	sub    %eax,%edx
  8010d9:	89 d0                	mov    %edx,%eax
  8010db:	eb 18                	jmp    8010f5 <memcmp+0x50>
		s1++, s2++;
  8010dd:	ff 45 fc             	incl   -0x4(%ebp)
  8010e0:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	75 c9                	jne    8010b9 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8010f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	8b 45 10             	mov    0x10(%ebp),%eax
  801103:	01 d0                	add    %edx,%eax
  801105:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801108:	eb 15                	jmp    80111f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	0f b6 d0             	movzbl %al,%edx
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	0f b6 c0             	movzbl %al,%eax
  801118:	39 c2                	cmp    %eax,%edx
  80111a:	74 0d                	je     801129 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80111c:	ff 45 08             	incl   0x8(%ebp)
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801125:	72 e3                	jb     80110a <memfind+0x13>
  801127:	eb 01                	jmp    80112a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801129:	90                   	nop
	return (void *) s;
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801135:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80113c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801143:	eb 03                	jmp    801148 <strtol+0x19>
		s++;
  801145:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	8a 00                	mov    (%eax),%al
  80114d:	3c 20                	cmp    $0x20,%al
  80114f:	74 f4                	je     801145 <strtol+0x16>
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
  801154:	8a 00                	mov    (%eax),%al
  801156:	3c 09                	cmp    $0x9,%al
  801158:	74 eb                	je     801145 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80115a:	8b 45 08             	mov    0x8(%ebp),%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	3c 2b                	cmp    $0x2b,%al
  801161:	75 05                	jne    801168 <strtol+0x39>
		s++;
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	eb 13                	jmp    80117b <strtol+0x4c>
	else if (*s == '-')
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	8a 00                	mov    (%eax),%al
  80116d:	3c 2d                	cmp    $0x2d,%al
  80116f:	75 0a                	jne    80117b <strtol+0x4c>
		s++, neg = 1;
  801171:	ff 45 08             	incl   0x8(%ebp)
  801174:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80117b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80117f:	74 06                	je     801187 <strtol+0x58>
  801181:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801185:	75 20                	jne    8011a7 <strtol+0x78>
  801187:	8b 45 08             	mov    0x8(%ebp),%eax
  80118a:	8a 00                	mov    (%eax),%al
  80118c:	3c 30                	cmp    $0x30,%al
  80118e:	75 17                	jne    8011a7 <strtol+0x78>
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	40                   	inc    %eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	3c 78                	cmp    $0x78,%al
  801198:	75 0d                	jne    8011a7 <strtol+0x78>
		s += 2, base = 16;
  80119a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80119e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011a5:	eb 28                	jmp    8011cf <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ab:	75 15                	jne    8011c2 <strtol+0x93>
  8011ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b0:	8a 00                	mov    (%eax),%al
  8011b2:	3c 30                	cmp    $0x30,%al
  8011b4:	75 0c                	jne    8011c2 <strtol+0x93>
		s++, base = 8;
  8011b6:	ff 45 08             	incl   0x8(%ebp)
  8011b9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011c0:	eb 0d                	jmp    8011cf <strtol+0xa0>
	else if (base == 0)
  8011c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c6:	75 07                	jne    8011cf <strtol+0xa0>
		base = 10;
  8011c8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d2:	8a 00                	mov    (%eax),%al
  8011d4:	3c 2f                	cmp    $0x2f,%al
  8011d6:	7e 19                	jle    8011f1 <strtol+0xc2>
  8011d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	3c 39                	cmp    $0x39,%al
  8011df:	7f 10                	jg     8011f1 <strtol+0xc2>
			dig = *s - '0';
  8011e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	0f be c0             	movsbl %al,%eax
  8011e9:	83 e8 30             	sub    $0x30,%eax
  8011ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8011ef:	eb 42                	jmp    801233 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 00                	mov    (%eax),%al
  8011f6:	3c 60                	cmp    $0x60,%al
  8011f8:	7e 19                	jle    801213 <strtol+0xe4>
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	8a 00                	mov    (%eax),%al
  8011ff:	3c 7a                	cmp    $0x7a,%al
  801201:	7f 10                	jg     801213 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801203:	8b 45 08             	mov    0x8(%ebp),%eax
  801206:	8a 00                	mov    (%eax),%al
  801208:	0f be c0             	movsbl %al,%eax
  80120b:	83 e8 57             	sub    $0x57,%eax
  80120e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801211:	eb 20                	jmp    801233 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	8a 00                	mov    (%eax),%al
  801218:	3c 40                	cmp    $0x40,%al
  80121a:	7e 39                	jle    801255 <strtol+0x126>
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	8a 00                	mov    (%eax),%al
  801221:	3c 5a                	cmp    $0x5a,%al
  801223:	7f 30                	jg     801255 <strtol+0x126>
			dig = *s - 'A' + 10;
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	8a 00                	mov    (%eax),%al
  80122a:	0f be c0             	movsbl %al,%eax
  80122d:	83 e8 37             	sub    $0x37,%eax
  801230:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801233:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801236:	3b 45 10             	cmp    0x10(%ebp),%eax
  801239:	7d 19                	jge    801254 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801241:	0f af 45 10          	imul   0x10(%ebp),%eax
  801245:	89 c2                	mov    %eax,%edx
  801247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80124f:	e9 7b ff ff ff       	jmp    8011cf <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801254:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801255:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801259:	74 08                	je     801263 <strtol+0x134>
		*endptr = (char *) s;
  80125b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125e:	8b 55 08             	mov    0x8(%ebp),%edx
  801261:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801263:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801267:	74 07                	je     801270 <strtol+0x141>
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	f7 d8                	neg    %eax
  80126e:	eb 03                	jmp    801273 <strtol+0x144>
  801270:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801273:	c9                   	leave  
  801274:	c3                   	ret    

00801275 <ltostr>:

void
ltostr(long value, char *str)
{
  801275:	55                   	push   %ebp
  801276:	89 e5                	mov    %esp,%ebp
  801278:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80127b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801282:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801289:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80128d:	79 13                	jns    8012a2 <ltostr+0x2d>
	{
		neg = 1;
  80128f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80129c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80129f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012aa:	99                   	cltd   
  8012ab:	f7 f9                	idiv   %ecx
  8012ad:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b3:	8d 50 01             	lea    0x1(%eax),%edx
  8012b6:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012b9:	89 c2                	mov    %eax,%edx
  8012bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012be:	01 d0                	add    %edx,%eax
  8012c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012c3:	83 c2 30             	add    $0x30,%edx
  8012c6:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012cb:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012d0:	f7 e9                	imul   %ecx
  8012d2:	c1 fa 02             	sar    $0x2,%edx
  8012d5:	89 c8                	mov    %ecx,%eax
  8012d7:	c1 f8 1f             	sar    $0x1f,%eax
  8012da:	29 c2                	sub    %eax,%edx
  8012dc:	89 d0                	mov    %edx,%eax
  8012de:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012e9:	f7 e9                	imul   %ecx
  8012eb:	c1 fa 02             	sar    $0x2,%edx
  8012ee:	89 c8                	mov    %ecx,%eax
  8012f0:	c1 f8 1f             	sar    $0x1f,%eax
  8012f3:	29 c2                	sub    %eax,%edx
  8012f5:	89 d0                	mov    %edx,%eax
  8012f7:	c1 e0 02             	shl    $0x2,%eax
  8012fa:	01 d0                	add    %edx,%eax
  8012fc:	01 c0                	add    %eax,%eax
  8012fe:	29 c1                	sub    %eax,%ecx
  801300:	89 ca                	mov    %ecx,%edx
  801302:	85 d2                	test   %edx,%edx
  801304:	75 9c                	jne    8012a2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801306:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80130d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801310:	48                   	dec    %eax
  801311:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 3d                	je     801357 <ltostr+0xe2>
		start = 1 ;
  80131a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801321:	eb 34                	jmp    801357 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801326:	8b 45 0c             	mov    0xc(%ebp),%eax
  801329:	01 d0                	add    %edx,%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801330:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801333:	8b 45 0c             	mov    0xc(%ebp),%eax
  801336:	01 c2                	add    %eax,%edx
  801338:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	01 c8                	add    %ecx,%eax
  801340:	8a 00                	mov    (%eax),%al
  801342:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801344:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	01 c2                	add    %eax,%edx
  80134c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80134f:	88 02                	mov    %al,(%edx)
		start++ ;
  801351:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801354:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80135d:	7c c4                	jl     801323 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80135f:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801362:	8b 45 0c             	mov    0xc(%ebp),%eax
  801365:	01 d0                	add    %edx,%eax
  801367:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80136a:	90                   	nop
  80136b:	c9                   	leave  
  80136c:	c3                   	ret    

0080136d <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801373:	ff 75 08             	pushl  0x8(%ebp)
  801376:	e8 54 fa ff ff       	call   800dcf <strlen>
  80137b:	83 c4 04             	add    $0x4,%esp
  80137e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801381:	ff 75 0c             	pushl  0xc(%ebp)
  801384:	e8 46 fa ff ff       	call   800dcf <strlen>
  801389:	83 c4 04             	add    $0x4,%esp
  80138c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80138f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801396:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80139d:	eb 17                	jmp    8013b6 <strcconcat+0x49>
		final[s] = str1[s] ;
  80139f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a5:	01 c2                	add    %eax,%edx
  8013a7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	01 c8                	add    %ecx,%eax
  8013af:	8a 00                	mov    (%eax),%al
  8013b1:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013b3:	ff 45 fc             	incl   -0x4(%ebp)
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013bc:	7c e1                	jl     80139f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013be:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013c5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013cc:	eb 1f                	jmp    8013ed <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d1:	8d 50 01             	lea    0x1(%eax),%edx
  8013d4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013d7:	89 c2                	mov    %eax,%edx
  8013d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013dc:	01 c2                	add    %eax,%edx
  8013de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e4:	01 c8                	add    %ecx,%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8013ea:	ff 45 f8             	incl   -0x8(%ebp)
  8013ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013f3:	7c d9                	jl     8013ce <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8013f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f8:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fb:	01 d0                	add    %edx,%eax
  8013fd:	c6 00 00             	movb   $0x0,(%eax)
}
  801400:	90                   	nop
  801401:	c9                   	leave  
  801402:	c3                   	ret    

00801403 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801406:	8b 45 14             	mov    0x14(%ebp),%eax
  801409:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80140f:	8b 45 14             	mov    0x14(%ebp),%eax
  801412:	8b 00                	mov    (%eax),%eax
  801414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80141b:	8b 45 10             	mov    0x10(%ebp),%eax
  80141e:	01 d0                	add    %edx,%eax
  801420:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801426:	eb 0c                	jmp    801434 <strsplit+0x31>
			*string++ = 0;
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	8d 50 01             	lea    0x1(%eax),%edx
  80142e:	89 55 08             	mov    %edx,0x8(%ebp)
  801431:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801434:	8b 45 08             	mov    0x8(%ebp),%eax
  801437:	8a 00                	mov    (%eax),%al
  801439:	84 c0                	test   %al,%al
  80143b:	74 18                	je     801455 <strsplit+0x52>
  80143d:	8b 45 08             	mov    0x8(%ebp),%eax
  801440:	8a 00                	mov    (%eax),%al
  801442:	0f be c0             	movsbl %al,%eax
  801445:	50                   	push   %eax
  801446:	ff 75 0c             	pushl  0xc(%ebp)
  801449:	e8 13 fb ff ff       	call   800f61 <strchr>
  80144e:	83 c4 08             	add    $0x8,%esp
  801451:	85 c0                	test   %eax,%eax
  801453:	75 d3                	jne    801428 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	84 c0                	test   %al,%al
  80145c:	74 5a                	je     8014b8 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	8b 00                	mov    (%eax),%eax
  801463:	83 f8 0f             	cmp    $0xf,%eax
  801466:	75 07                	jne    80146f <strsplit+0x6c>
		{
			return 0;
  801468:	b8 00 00 00 00       	mov    $0x0,%eax
  80146d:	eb 66                	jmp    8014d5 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	8d 48 01             	lea    0x1(%eax),%ecx
  801477:	8b 55 14             	mov    0x14(%ebp),%edx
  80147a:	89 0a                	mov    %ecx,(%edx)
  80147c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801483:	8b 45 10             	mov    0x10(%ebp),%eax
  801486:	01 c2                	add    %eax,%edx
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80148d:	eb 03                	jmp    801492 <strsplit+0x8f>
			string++;
  80148f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 8b                	je     801426 <strsplit+0x23>
  80149b:	8b 45 08             	mov    0x8(%ebp),%eax
  80149e:	8a 00                	mov    (%eax),%al
  8014a0:	0f be c0             	movsbl %al,%eax
  8014a3:	50                   	push   %eax
  8014a4:	ff 75 0c             	pushl  0xc(%ebp)
  8014a7:	e8 b5 fa ff ff       	call   800f61 <strchr>
  8014ac:	83 c4 08             	add    $0x8,%esp
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 dc                	je     80148f <strsplit+0x8c>
			string++;
	}
  8014b3:	e9 6e ff ff ff       	jmp    801426 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014b8:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8014bc:	8b 00                	mov    (%eax),%eax
  8014be:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c8:	01 d0                	add    %edx,%eax
  8014ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014d0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014d5:	c9                   	leave  
  8014d6:	c3                   	ret    

008014d7 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8014dd:	a1 04 40 80 00       	mov    0x804004,%eax
  8014e2:	85 c0                	test   %eax,%eax
  8014e4:	74 1f                	je     801505 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8014e6:	e8 1d 00 00 00       	call   801508 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8014eb:	83 ec 0c             	sub    $0xc,%esp
  8014ee:	68 10 3d 80 00       	push   $0x803d10
  8014f3:	e8 55 f2 ff ff       	call   80074d <cprintf>
  8014f8:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8014fb:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801502:	00 00 00 
	}
}
  801505:	90                   	nop
  801506:	c9                   	leave  
  801507:	c3                   	ret    

00801508 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801508:	55                   	push   %ebp
  801509:	89 e5                	mov    %esp,%ebp
  80150b:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80150e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801515:	00 00 00 
  801518:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80151f:	00 00 00 
  801522:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801529:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80152c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801533:	00 00 00 
  801536:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80153d:	00 00 00 
  801540:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801547:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80154a:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801554:	c1 e8 0c             	shr    $0xc,%eax
  801557:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80155c:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801566:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80156b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801570:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801575:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80157c:	a1 20 41 80 00       	mov    0x804120,%eax
  801581:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801585:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801588:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80158f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801595:	01 d0                	add    %edx,%eax
  801597:	48                   	dec    %eax
  801598:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80159b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80159e:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a3:	f7 75 e4             	divl   -0x1c(%ebp)
  8015a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015a9:	29 d0                	sub    %edx,%eax
  8015ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8015ae:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8015b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015bd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	6a 07                	push   $0x7
  8015c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8015ca:	50                   	push   %eax
  8015cb:	e8 3d 06 00 00       	call   801c0d <sys_allocate_chunk>
  8015d0:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8015d3:	a1 20 41 80 00       	mov    0x804120,%eax
  8015d8:	83 ec 0c             	sub    $0xc,%esp
  8015db:	50                   	push   %eax
  8015dc:	e8 b2 0c 00 00       	call   802293 <initialize_MemBlocksList>
  8015e1:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8015e4:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8015e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8015ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8015f0:	0f 84 f3 00 00 00    	je     8016e9 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8015f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8015fa:	75 14                	jne    801610 <initialize_dyn_block_system+0x108>
  8015fc:	83 ec 04             	sub    $0x4,%esp
  8015ff:	68 35 3d 80 00       	push   $0x803d35
  801604:	6a 36                	push   $0x36
  801606:	68 53 3d 80 00       	push   $0x803d53
  80160b:	e8 89 ee ff ff       	call   800499 <_panic>
  801610:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801613:	8b 00                	mov    (%eax),%eax
  801615:	85 c0                	test   %eax,%eax
  801617:	74 10                	je     801629 <initialize_dyn_block_system+0x121>
  801619:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80161c:	8b 00                	mov    (%eax),%eax
  80161e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801621:	8b 52 04             	mov    0x4(%edx),%edx
  801624:	89 50 04             	mov    %edx,0x4(%eax)
  801627:	eb 0b                	jmp    801634 <initialize_dyn_block_system+0x12c>
  801629:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80162c:	8b 40 04             	mov    0x4(%eax),%eax
  80162f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801634:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801637:	8b 40 04             	mov    0x4(%eax),%eax
  80163a:	85 c0                	test   %eax,%eax
  80163c:	74 0f                	je     80164d <initialize_dyn_block_system+0x145>
  80163e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801641:	8b 40 04             	mov    0x4(%eax),%eax
  801644:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801647:	8b 12                	mov    (%edx),%edx
  801649:	89 10                	mov    %edx,(%eax)
  80164b:	eb 0a                	jmp    801657 <initialize_dyn_block_system+0x14f>
  80164d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801650:	8b 00                	mov    (%eax),%eax
  801652:	a3 48 41 80 00       	mov    %eax,0x804148
  801657:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80165a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801660:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801663:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80166a:	a1 54 41 80 00       	mov    0x804154,%eax
  80166f:	48                   	dec    %eax
  801670:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801675:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801678:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80167f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801682:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801689:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80168d:	75 14                	jne    8016a3 <initialize_dyn_block_system+0x19b>
  80168f:	83 ec 04             	sub    $0x4,%esp
  801692:	68 60 3d 80 00       	push   $0x803d60
  801697:	6a 3e                	push   $0x3e
  801699:	68 53 3d 80 00       	push   $0x803d53
  80169e:	e8 f6 ed ff ff       	call   800499 <_panic>
  8016a3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8016a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016ac:	89 10                	mov    %edx,(%eax)
  8016ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016b1:	8b 00                	mov    (%eax),%eax
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	74 0d                	je     8016c4 <initialize_dyn_block_system+0x1bc>
  8016b7:	a1 38 41 80 00       	mov    0x804138,%eax
  8016bc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016bf:	89 50 04             	mov    %edx,0x4(%eax)
  8016c2:	eb 08                	jmp    8016cc <initialize_dyn_block_system+0x1c4>
  8016c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016c7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8016cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016cf:	a3 38 41 80 00       	mov    %eax,0x804138
  8016d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016de:	a1 44 41 80 00       	mov    0x804144,%eax
  8016e3:	40                   	inc    %eax
  8016e4:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8016e9:	90                   	nop
  8016ea:	c9                   	leave  
  8016eb:	c3                   	ret    

008016ec <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8016ec:	55                   	push   %ebp
  8016ed:	89 e5                	mov    %esp,%ebp
  8016ef:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8016f2:	e8 e0 fd ff ff       	call   8014d7 <InitializeUHeap>
		if (size == 0) return NULL ;
  8016f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8016fb:	75 07                	jne    801704 <malloc+0x18>
  8016fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801702:	eb 7f                	jmp    801783 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801704:	e8 d2 08 00 00       	call   801fdb <sys_isUHeapPlacementStrategyFIRSTFIT>
  801709:	85 c0                	test   %eax,%eax
  80170b:	74 71                	je     80177e <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80170d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801714:	8b 55 08             	mov    0x8(%ebp),%edx
  801717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80171a:	01 d0                	add    %edx,%eax
  80171c:	48                   	dec    %eax
  80171d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801723:	ba 00 00 00 00       	mov    $0x0,%edx
  801728:	f7 75 f4             	divl   -0xc(%ebp)
  80172b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172e:	29 d0                	sub    %edx,%eax
  801730:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801733:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80173a:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801741:	76 07                	jbe    80174a <malloc+0x5e>
					return NULL ;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
  801748:	eb 39                	jmp    801783 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80174a:	83 ec 0c             	sub    $0xc,%esp
  80174d:	ff 75 08             	pushl  0x8(%ebp)
  801750:	e8 e6 0d 00 00       	call   80253b <alloc_block_FF>
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80175b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80175f:	74 16                	je     801777 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801761:	83 ec 0c             	sub    $0xc,%esp
  801764:	ff 75 ec             	pushl  -0x14(%ebp)
  801767:	e8 37 0c 00 00       	call   8023a3 <insert_sorted_allocList>
  80176c:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80176f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801772:	8b 40 08             	mov    0x8(%eax),%eax
  801775:	eb 0c                	jmp    801783 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801777:	b8 00 00 00 00       	mov    $0x0,%eax
  80177c:	eb 05                	jmp    801783 <malloc+0x97>
				}
		}
	return 0;
  80177e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801791:	83 ec 08             	sub    $0x8,%esp
  801794:	ff 75 f4             	pushl  -0xc(%ebp)
  801797:	68 40 40 80 00       	push   $0x804040
  80179c:	e8 cf 0b 00 00       	call   802370 <find_block>
  8017a1:	83 c4 10             	add    $0x10,%esp
  8017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	8b 40 08             	mov    0x8(%eax),%eax
  8017b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8017b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017bd:	0f 84 a1 00 00 00    	je     801864 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8017c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017c7:	75 17                	jne    8017e0 <free+0x5b>
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 35 3d 80 00       	push   $0x803d35
  8017d1:	68 80 00 00 00       	push   $0x80
  8017d6:	68 53 3d 80 00       	push   $0x803d53
  8017db:	e8 b9 ec ff ff       	call   800499 <_panic>
  8017e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e3:	8b 00                	mov    (%eax),%eax
  8017e5:	85 c0                	test   %eax,%eax
  8017e7:	74 10                	je     8017f9 <free+0x74>
  8017e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ec:	8b 00                	mov    (%eax),%eax
  8017ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017f1:	8b 52 04             	mov    0x4(%edx),%edx
  8017f4:	89 50 04             	mov    %edx,0x4(%eax)
  8017f7:	eb 0b                	jmp    801804 <free+0x7f>
  8017f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fc:	8b 40 04             	mov    0x4(%eax),%eax
  8017ff:	a3 44 40 80 00       	mov    %eax,0x804044
  801804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801807:	8b 40 04             	mov    0x4(%eax),%eax
  80180a:	85 c0                	test   %eax,%eax
  80180c:	74 0f                	je     80181d <free+0x98>
  80180e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801811:	8b 40 04             	mov    0x4(%eax),%eax
  801814:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801817:	8b 12                	mov    (%edx),%edx
  801819:	89 10                	mov    %edx,(%eax)
  80181b:	eb 0a                	jmp    801827 <free+0xa2>
  80181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801820:	8b 00                	mov    (%eax),%eax
  801822:	a3 40 40 80 00       	mov    %eax,0x804040
  801827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801833:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80183a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80183f:	48                   	dec    %eax
  801840:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801845:	83 ec 0c             	sub    $0xc,%esp
  801848:	ff 75 f0             	pushl  -0x10(%ebp)
  80184b:	e8 29 12 00 00       	call   802a79 <insert_sorted_with_merge_freeList>
  801850:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801853:	83 ec 08             	sub    $0x8,%esp
  801856:	ff 75 ec             	pushl  -0x14(%ebp)
  801859:	ff 75 e8             	pushl  -0x18(%ebp)
  80185c:	e8 74 03 00 00       	call   801bd5 <sys_free_user_mem>
  801861:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801864:	90                   	nop
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 38             	sub    $0x38,%esp
  80186d:	8b 45 10             	mov    0x10(%ebp),%eax
  801870:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801873:	e8 5f fc ff ff       	call   8014d7 <InitializeUHeap>
	if (size == 0) return NULL ;
  801878:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80187c:	75 0a                	jne    801888 <smalloc+0x21>
  80187e:	b8 00 00 00 00       	mov    $0x0,%eax
  801883:	e9 b2 00 00 00       	jmp    80193a <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801888:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80188f:	76 0a                	jbe    80189b <smalloc+0x34>
		return NULL;
  801891:	b8 00 00 00 00       	mov    $0x0,%eax
  801896:	e9 9f 00 00 00       	jmp    80193a <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80189b:	e8 3b 07 00 00       	call   801fdb <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	0f 84 8d 00 00 00    	je     801935 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8018a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8018af:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018bc:	01 d0                	add    %edx,%eax
  8018be:	48                   	dec    %eax
  8018bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ca:	f7 75 f0             	divl   -0x10(%ebp)
  8018cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018d0:	29 d0                	sub    %edx,%eax
  8018d2:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8018d5:	83 ec 0c             	sub    $0xc,%esp
  8018d8:	ff 75 e8             	pushl  -0x18(%ebp)
  8018db:	e8 5b 0c 00 00       	call   80253b <alloc_block_FF>
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8018e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018ea:	75 07                	jne    8018f3 <smalloc+0x8c>
			return NULL;
  8018ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f1:	eb 47                	jmp    80193a <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8018f3:	83 ec 0c             	sub    $0xc,%esp
  8018f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f9:	e8 a5 0a 00 00       	call   8023a3 <insert_sorted_allocList>
  8018fe:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801904:	8b 40 08             	mov    0x8(%eax),%eax
  801907:	89 c2                	mov    %eax,%edx
  801909:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80190d:	52                   	push   %edx
  80190e:	50                   	push   %eax
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	e8 46 04 00 00       	call   801d60 <sys_createSharedObject>
  80191a:	83 c4 10             	add    $0x10,%esp
  80191d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801920:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801924:	78 08                	js     80192e <smalloc+0xc7>
		return (void *)b->sva;
  801926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801929:	8b 40 08             	mov    0x8(%eax),%eax
  80192c:	eb 0c                	jmp    80193a <smalloc+0xd3>
		}else{
		return NULL;
  80192e:	b8 00 00 00 00       	mov    $0x0,%eax
  801933:	eb 05                	jmp    80193a <smalloc+0xd3>
			}

	}return NULL;
  801935:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80193a:	c9                   	leave  
  80193b:	c3                   	ret    

0080193c <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80193c:	55                   	push   %ebp
  80193d:	89 e5                	mov    %esp,%ebp
  80193f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801942:	e8 90 fb ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801947:	e8 8f 06 00 00       	call   801fdb <sys_isUHeapPlacementStrategyFIRSTFIT>
  80194c:	85 c0                	test   %eax,%eax
  80194e:	0f 84 ad 00 00 00    	je     801a01 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801954:	83 ec 08             	sub    $0x8,%esp
  801957:	ff 75 0c             	pushl  0xc(%ebp)
  80195a:	ff 75 08             	pushl  0x8(%ebp)
  80195d:	e8 28 04 00 00       	call   801d8a <sys_getSizeOfSharedObject>
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801968:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80196c:	79 0a                	jns    801978 <sget+0x3c>
    {
    	return NULL;
  80196e:	b8 00 00 00 00       	mov    $0x0,%eax
  801973:	e9 8e 00 00 00       	jmp    801a06 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801978:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80197f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198c:	01 d0                	add    %edx,%eax
  80198e:	48                   	dec    %eax
  80198f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801992:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801995:	ba 00 00 00 00       	mov    $0x0,%edx
  80199a:	f7 75 ec             	divl   -0x14(%ebp)
  80199d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019a0:	29 d0                	sub    %edx,%eax
  8019a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8019a5:	83 ec 0c             	sub    $0xc,%esp
  8019a8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019ab:	e8 8b 0b 00 00       	call   80253b <alloc_block_FF>
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8019b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019ba:	75 07                	jne    8019c3 <sget+0x87>
				return NULL;
  8019bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c1:	eb 43                	jmp    801a06 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8019c3:	83 ec 0c             	sub    $0xc,%esp
  8019c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8019c9:	e8 d5 09 00 00       	call   8023a3 <insert_sorted_allocList>
  8019ce:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8019d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d4:	8b 40 08             	mov    0x8(%eax),%eax
  8019d7:	83 ec 04             	sub    $0x4,%esp
  8019da:	50                   	push   %eax
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	e8 c1 03 00 00       	call   801da7 <sys_getSharedObject>
  8019e6:	83 c4 10             	add    $0x10,%esp
  8019e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8019ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8019f0:	78 08                	js     8019fa <sget+0xbe>
			return (void *)b->sva;
  8019f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f5:	8b 40 08             	mov    0x8(%eax),%eax
  8019f8:	eb 0c                	jmp    801a06 <sget+0xca>
			}else{
			return NULL;
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ff:	eb 05                	jmp    801a06 <sget+0xca>
			}
    }}return NULL;
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
  801a0b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a0e:	e8 c4 fa ff ff       	call   8014d7 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a13:	83 ec 04             	sub    $0x4,%esp
  801a16:	68 84 3d 80 00       	push   $0x803d84
  801a1b:	68 03 01 00 00       	push   $0x103
  801a20:	68 53 3d 80 00       	push   $0x803d53
  801a25:	e8 6f ea ff ff       	call   800499 <_panic>

00801a2a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a30:	83 ec 04             	sub    $0x4,%esp
  801a33:	68 ac 3d 80 00       	push   $0x803dac
  801a38:	68 17 01 00 00       	push   $0x117
  801a3d:	68 53 3d 80 00       	push   $0x803d53
  801a42:	e8 52 ea ff ff       	call   800499 <_panic>

00801a47 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a4d:	83 ec 04             	sub    $0x4,%esp
  801a50:	68 d0 3d 80 00       	push   $0x803dd0
  801a55:	68 22 01 00 00       	push   $0x122
  801a5a:	68 53 3d 80 00       	push   $0x803d53
  801a5f:	e8 35 ea ff ff       	call   800499 <_panic>

00801a64 <shrink>:

}
void shrink(uint32 newSize)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
  801a67:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a6a:	83 ec 04             	sub    $0x4,%esp
  801a6d:	68 d0 3d 80 00       	push   $0x803dd0
  801a72:	68 27 01 00 00       	push   $0x127
  801a77:	68 53 3d 80 00       	push   $0x803d53
  801a7c:	e8 18 ea ff ff       	call   800499 <_panic>

00801a81 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a87:	83 ec 04             	sub    $0x4,%esp
  801a8a:	68 d0 3d 80 00       	push   $0x803dd0
  801a8f:	68 2c 01 00 00       	push   $0x12c
  801a94:	68 53 3d 80 00       	push   $0x803d53
  801a99:	e8 fb e9 ff ff       	call   800499 <_panic>

00801a9e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	57                   	push   %edi
  801aa2:	56                   	push   %esi
  801aa3:	53                   	push   %ebx
  801aa4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aad:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ab0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ab3:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ab6:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801ab9:	cd 30                	int    $0x30
  801abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ac1:	83 c4 10             	add    $0x10,%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5e                   	pop    %esi
  801ac6:	5f                   	pop    %edi
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    

00801ac9 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 04             	sub    $0x4,%esp
  801acf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801ad5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	52                   	push   %edx
  801ae1:	ff 75 0c             	pushl  0xc(%ebp)
  801ae4:	50                   	push   %eax
  801ae5:	6a 00                	push   $0x0
  801ae7:	e8 b2 ff ff ff       	call   801a9e <syscall>
  801aec:	83 c4 18             	add    $0x18,%esp
}
  801aef:	90                   	nop
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_cgetc>:

int
sys_cgetc(void)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 01                	push   $0x1
  801b01:	e8 98 ff ff ff       	call   801a9e <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	6a 05                	push   $0x5
  801b1e:	e8 7b ff ff ff       	call   801a9e <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
  801b2b:	56                   	push   %esi
  801b2c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b2d:	8b 75 18             	mov    0x18(%ebp),%esi
  801b30:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b33:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b36:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	56                   	push   %esi
  801b3d:	53                   	push   %ebx
  801b3e:	51                   	push   %ecx
  801b3f:	52                   	push   %edx
  801b40:	50                   	push   %eax
  801b41:	6a 06                	push   $0x6
  801b43:	e8 56 ff ff ff       	call   801a9e <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b4e:	5b                   	pop    %ebx
  801b4f:	5e                   	pop    %esi
  801b50:	5d                   	pop    %ebp
  801b51:	c3                   	ret    

00801b52 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b55:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	52                   	push   %edx
  801b62:	50                   	push   %eax
  801b63:	6a 07                	push   $0x7
  801b65:	e8 34 ff ff ff       	call   801a9e <syscall>
  801b6a:	83 c4 18             	add    $0x18,%esp
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	ff 75 08             	pushl  0x8(%ebp)
  801b7e:	6a 08                	push   $0x8
  801b80:	e8 19 ff ff ff       	call   801a9e <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 09                	push   $0x9
  801b99:	e8 00 ff ff ff       	call   801a9e <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 0a                	push   $0xa
  801bb2:	e8 e7 fe ff ff       	call   801a9e <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 0b                	push   $0xb
  801bcb:	e8 ce fe ff ff       	call   801a9e <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	ff 75 0c             	pushl  0xc(%ebp)
  801be1:	ff 75 08             	pushl  0x8(%ebp)
  801be4:	6a 0f                	push   $0xf
  801be6:	e8 b3 fe ff ff       	call   801a9e <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
	return;
  801bee:	90                   	nop
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	ff 75 0c             	pushl  0xc(%ebp)
  801bfd:	ff 75 08             	pushl  0x8(%ebp)
  801c00:	6a 10                	push   $0x10
  801c02:	e8 97 fe ff ff       	call   801a9e <syscall>
  801c07:	83 c4 18             	add    $0x18,%esp
	return ;
  801c0a:	90                   	nop
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	ff 75 10             	pushl  0x10(%ebp)
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	6a 11                	push   $0x11
  801c1f:	e8 7a fe ff ff       	call   801a9e <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
	return ;
  801c27:	90                   	nop
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 0c                	push   $0xc
  801c39:	e8 60 fe ff ff       	call   801a9e <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	ff 75 08             	pushl  0x8(%ebp)
  801c51:	6a 0d                	push   $0xd
  801c53:	e8 46 fe ff ff       	call   801a9e <syscall>
  801c58:	83 c4 18             	add    $0x18,%esp
}
  801c5b:	c9                   	leave  
  801c5c:	c3                   	ret    

00801c5d <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 0e                	push   $0xe
  801c6c:	e8 2d fe ff ff       	call   801a9e <syscall>
  801c71:	83 c4 18             	add    $0x18,%esp
}
  801c74:	90                   	nop
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 13                	push   $0x13
  801c86:	e8 13 fe ff ff       	call   801a9e <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	90                   	nop
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 14                	push   $0x14
  801ca0:	e8 f9 fd ff ff       	call   801a9e <syscall>
  801ca5:	83 c4 18             	add    $0x18,%esp
}
  801ca8:	90                   	nop
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_cputc>:


void
sys_cputc(const char c)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 04             	sub    $0x4,%esp
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cb7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	50                   	push   %eax
  801cc4:	6a 15                	push   $0x15
  801cc6:	e8 d3 fd ff ff       	call   801a9e <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
}
  801cce:	90                   	nop
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 16                	push   $0x16
  801ce0:	e8 b9 fd ff ff       	call   801a9e <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	90                   	nop
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	ff 75 0c             	pushl  0xc(%ebp)
  801cfa:	50                   	push   %eax
  801cfb:	6a 17                	push   $0x17
  801cfd:	e8 9c fd ff ff       	call   801a9e <syscall>
  801d02:	83 c4 18             	add    $0x18,%esp
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d0a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	52                   	push   %edx
  801d17:	50                   	push   %eax
  801d18:	6a 1a                	push   $0x1a
  801d1a:	e8 7f fd ff ff       	call   801a9e <syscall>
  801d1f:	83 c4 18             	add    $0x18,%esp
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	52                   	push   %edx
  801d34:	50                   	push   %eax
  801d35:	6a 18                	push   $0x18
  801d37:	e8 62 fd ff ff       	call   801a9e <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	90                   	nop
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	52                   	push   %edx
  801d52:	50                   	push   %eax
  801d53:	6a 19                	push   $0x19
  801d55:	e8 44 fd ff ff       	call   801a9e <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
}
  801d5d:	90                   	nop
  801d5e:	c9                   	leave  
  801d5f:	c3                   	ret    

00801d60 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 04             	sub    $0x4,%esp
  801d66:	8b 45 10             	mov    0x10(%ebp),%eax
  801d69:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801d6c:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801d6f:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d73:	8b 45 08             	mov    0x8(%ebp),%eax
  801d76:	6a 00                	push   $0x0
  801d78:	51                   	push   %ecx
  801d79:	52                   	push   %edx
  801d7a:	ff 75 0c             	pushl  0xc(%ebp)
  801d7d:	50                   	push   %eax
  801d7e:	6a 1b                	push   $0x1b
  801d80:	e8 19 fd ff ff       	call   801a9e <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801d8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d90:	8b 45 08             	mov    0x8(%ebp),%eax
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	52                   	push   %edx
  801d9a:	50                   	push   %eax
  801d9b:	6a 1c                	push   $0x1c
  801d9d:	e8 fc fc ff ff       	call   801a9e <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
}
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801daa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dad:	8b 55 0c             	mov    0xc(%ebp),%edx
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	51                   	push   %ecx
  801db8:	52                   	push   %edx
  801db9:	50                   	push   %eax
  801dba:	6a 1d                	push   $0x1d
  801dbc:	e8 dd fc ff ff       	call   801a9e <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801dc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	52                   	push   %edx
  801dd6:	50                   	push   %eax
  801dd7:	6a 1e                	push   $0x1e
  801dd9:	e8 c0 fc ff ff       	call   801a9e <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 1f                	push   $0x1f
  801df2:	e8 a7 fc ff ff       	call   801a9e <syscall>
  801df7:	83 c4 18             	add    $0x18,%esp
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    

00801dfc <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801dff:	8b 45 08             	mov    0x8(%ebp),%eax
  801e02:	6a 00                	push   $0x0
  801e04:	ff 75 14             	pushl  0x14(%ebp)
  801e07:	ff 75 10             	pushl  0x10(%ebp)
  801e0a:	ff 75 0c             	pushl  0xc(%ebp)
  801e0d:	50                   	push   %eax
  801e0e:	6a 20                	push   $0x20
  801e10:	e8 89 fc ff ff       	call   801a9e <syscall>
  801e15:	83 c4 18             	add    $0x18,%esp
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	50                   	push   %eax
  801e29:	6a 21                	push   $0x21
  801e2b:	e8 6e fc ff ff       	call   801a9e <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
}
  801e33:	90                   	nop
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e39:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	50                   	push   %eax
  801e45:	6a 22                	push   $0x22
  801e47:	e8 52 fc ff ff       	call   801a9e <syscall>
  801e4c:	83 c4 18             	add    $0x18,%esp
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 02                	push   $0x2
  801e60:	e8 39 fc ff ff       	call   801a9e <syscall>
  801e65:	83 c4 18             	add    $0x18,%esp
}
  801e68:	c9                   	leave  
  801e69:	c3                   	ret    

00801e6a <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801e6a:	55                   	push   %ebp
  801e6b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 03                	push   $0x3
  801e79:	e8 20 fc ff ff       	call   801a9e <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
}
  801e81:	c9                   	leave  
  801e82:	c3                   	ret    

00801e83 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801e86:	6a 00                	push   $0x0
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 04                	push   $0x4
  801e92:	e8 07 fc ff ff       	call   801a9e <syscall>
  801e97:	83 c4 18             	add    $0x18,%esp
}
  801e9a:	c9                   	leave  
  801e9b:	c3                   	ret    

00801e9c <sys_exit_env>:


void sys_exit_env(void)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 23                	push   $0x23
  801eab:	e8 ee fb ff ff       	call   801a9e <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
}
  801eb3:	90                   	nop
  801eb4:	c9                   	leave  
  801eb5:	c3                   	ret    

00801eb6 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801eb6:	55                   	push   %ebp
  801eb7:	89 e5                	mov    %esp,%ebp
  801eb9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ebc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ebf:	8d 50 04             	lea    0x4(%eax),%edx
  801ec2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	52                   	push   %edx
  801ecc:	50                   	push   %eax
  801ecd:	6a 24                	push   $0x24
  801ecf:	e8 ca fb ff ff       	call   801a9e <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
	return result;
  801ed7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801eda:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801edd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ee0:	89 01                	mov    %eax,(%ecx)
  801ee2:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee8:	c9                   	leave  
  801ee9:	c2 04 00             	ret    $0x4

00801eec <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801eec:	55                   	push   %ebp
  801eed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	ff 75 10             	pushl  0x10(%ebp)
  801ef6:	ff 75 0c             	pushl  0xc(%ebp)
  801ef9:	ff 75 08             	pushl  0x8(%ebp)
  801efc:	6a 12                	push   $0x12
  801efe:	e8 9b fb ff ff       	call   801a9e <syscall>
  801f03:	83 c4 18             	add    $0x18,%esp
	return ;
  801f06:	90                   	nop
}
  801f07:	c9                   	leave  
  801f08:	c3                   	ret    

00801f09 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f09:	55                   	push   %ebp
  801f0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 25                	push   $0x25
  801f18:	e8 81 fb ff ff       	call   801a9e <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 04             	sub    $0x4,%esp
  801f28:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f2e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f32:	6a 00                	push   $0x0
  801f34:	6a 00                	push   $0x0
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	50                   	push   %eax
  801f3b:	6a 26                	push   $0x26
  801f3d:	e8 5c fb ff ff       	call   801a9e <syscall>
  801f42:	83 c4 18             	add    $0x18,%esp
	return ;
  801f45:	90                   	nop
}
  801f46:	c9                   	leave  
  801f47:	c3                   	ret    

00801f48 <rsttst>:
void rsttst()
{
  801f48:	55                   	push   %ebp
  801f49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 00                	push   $0x0
  801f55:	6a 28                	push   $0x28
  801f57:	e8 42 fb ff ff       	call   801a9e <syscall>
  801f5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801f5f:	90                   	nop
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 04             	sub    $0x4,%esp
  801f68:	8b 45 14             	mov    0x14(%ebp),%eax
  801f6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801f6e:	8b 55 18             	mov    0x18(%ebp),%edx
  801f71:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f75:	52                   	push   %edx
  801f76:	50                   	push   %eax
  801f77:	ff 75 10             	pushl  0x10(%ebp)
  801f7a:	ff 75 0c             	pushl  0xc(%ebp)
  801f7d:	ff 75 08             	pushl  0x8(%ebp)
  801f80:	6a 27                	push   $0x27
  801f82:	e8 17 fb ff ff       	call   801a9e <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
	return ;
  801f8a:	90                   	nop
}
  801f8b:	c9                   	leave  
  801f8c:	c3                   	ret    

00801f8d <chktst>:
void chktst(uint32 n)
{
  801f8d:	55                   	push   %ebp
  801f8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 00                	push   $0x0
  801f98:	ff 75 08             	pushl  0x8(%ebp)
  801f9b:	6a 29                	push   $0x29
  801f9d:	e8 fc fa ff ff       	call   801a9e <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
	return ;
  801fa5:	90                   	nop
}
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <inctst>:

void inctst()
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	6a 00                	push   $0x0
  801fb5:	6a 2a                	push   $0x2a
  801fb7:	e8 e2 fa ff ff       	call   801a9e <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801fbf:	90                   	nop
}
  801fc0:	c9                   	leave  
  801fc1:	c3                   	ret    

00801fc2 <gettst>:
uint32 gettst()
{
  801fc2:	55                   	push   %ebp
  801fc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 2b                	push   $0x2b
  801fd1:	e8 c8 fa ff ff       	call   801a9e <syscall>
  801fd6:	83 c4 18             	add    $0x18,%esp
}
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 2c                	push   $0x2c
  801fed:	e8 ac fa ff ff       	call   801a9e <syscall>
  801ff2:	83 c4 18             	add    $0x18,%esp
  801ff5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ff8:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ffc:	75 07                	jne    802005 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ffe:	b8 01 00 00 00       	mov    $0x1,%eax
  802003:	eb 05                	jmp    80200a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802005:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80200a:	c9                   	leave  
  80200b:	c3                   	ret    

0080200c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80200c:	55                   	push   %ebp
  80200d:	89 e5                	mov    %esp,%ebp
  80200f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 2c                	push   $0x2c
  80201e:	e8 7b fa ff ff       	call   801a9e <syscall>
  802023:	83 c4 18             	add    $0x18,%esp
  802026:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802029:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80202d:	75 07                	jne    802036 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80202f:	b8 01 00 00 00       	mov    $0x1,%eax
  802034:	eb 05                	jmp    80203b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	6a 00                	push   $0x0
  80204b:	6a 00                	push   $0x0
  80204d:	6a 2c                	push   $0x2c
  80204f:	e8 4a fa ff ff       	call   801a9e <syscall>
  802054:	83 c4 18             	add    $0x18,%esp
  802057:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80205a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80205e:	75 07                	jne    802067 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802060:	b8 01 00 00 00       	mov    $0x1,%eax
  802065:	eb 05                	jmp    80206c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802067:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 2c                	push   $0x2c
  802080:	e8 19 fa ff ff       	call   801a9e <syscall>
  802085:	83 c4 18             	add    $0x18,%esp
  802088:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80208b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80208f:	75 07                	jne    802098 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802091:	b8 01 00 00 00       	mov    $0x1,%eax
  802096:	eb 05                	jmp    80209d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802098:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	ff 75 08             	pushl  0x8(%ebp)
  8020ad:	6a 2d                	push   $0x2d
  8020af:	e8 ea f9 ff ff       	call   801a9e <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8020b7:	90                   	nop
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    

008020ba <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020be:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	6a 00                	push   $0x0
  8020cc:	53                   	push   %ebx
  8020cd:	51                   	push   %ecx
  8020ce:	52                   	push   %edx
  8020cf:	50                   	push   %eax
  8020d0:	6a 2e                	push   $0x2e
  8020d2:	e8 c7 f9 ff ff       	call   801a9e <syscall>
  8020d7:	83 c4 18             	add    $0x18,%esp
}
  8020da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020dd:	c9                   	leave  
  8020de:	c3                   	ret    

008020df <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8020df:	55                   	push   %ebp
  8020e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	52                   	push   %edx
  8020ef:	50                   	push   %eax
  8020f0:	6a 2f                	push   $0x2f
  8020f2:	e8 a7 f9 ff ff       	call   801a9e <syscall>
  8020f7:	83 c4 18             	add    $0x18,%esp
}
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
  8020ff:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802102:	83 ec 0c             	sub    $0xc,%esp
  802105:	68 e0 3d 80 00       	push   $0x803de0
  80210a:	e8 3e e6 ff ff       	call   80074d <cprintf>
  80210f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802112:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802119:	83 ec 0c             	sub    $0xc,%esp
  80211c:	68 0c 3e 80 00       	push   $0x803e0c
  802121:	e8 27 e6 ff ff       	call   80074d <cprintf>
  802126:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802129:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80212d:	a1 38 41 80 00       	mov    0x804138,%eax
  802132:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802135:	eb 56                	jmp    80218d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802137:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80213b:	74 1c                	je     802159 <print_mem_block_lists+0x5d>
  80213d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802140:	8b 50 08             	mov    0x8(%eax),%edx
  802143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802146:	8b 48 08             	mov    0x8(%eax),%ecx
  802149:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80214c:	8b 40 0c             	mov    0xc(%eax),%eax
  80214f:	01 c8                	add    %ecx,%eax
  802151:	39 c2                	cmp    %eax,%edx
  802153:	73 04                	jae    802159 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802155:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	8b 50 08             	mov    0x8(%eax),%edx
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	8b 40 0c             	mov    0xc(%eax),%eax
  802165:	01 c2                	add    %eax,%edx
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	8b 40 08             	mov    0x8(%eax),%eax
  80216d:	83 ec 04             	sub    $0x4,%esp
  802170:	52                   	push   %edx
  802171:	50                   	push   %eax
  802172:	68 21 3e 80 00       	push   $0x803e21
  802177:	e8 d1 e5 ff ff       	call   80074d <cprintf>
  80217c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80217f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802182:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802185:	a1 40 41 80 00       	mov    0x804140,%eax
  80218a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80218d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802191:	74 07                	je     80219a <print_mem_block_lists+0x9e>
  802193:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802196:	8b 00                	mov    (%eax),%eax
  802198:	eb 05                	jmp    80219f <print_mem_block_lists+0xa3>
  80219a:	b8 00 00 00 00       	mov    $0x0,%eax
  80219f:	a3 40 41 80 00       	mov    %eax,0x804140
  8021a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	75 8a                	jne    802137 <print_mem_block_lists+0x3b>
  8021ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021b1:	75 84                	jne    802137 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021b3:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021b7:	75 10                	jne    8021c9 <print_mem_block_lists+0xcd>
  8021b9:	83 ec 0c             	sub    $0xc,%esp
  8021bc:	68 30 3e 80 00       	push   $0x803e30
  8021c1:	e8 87 e5 ff ff       	call   80074d <cprintf>
  8021c6:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8021c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8021d0:	83 ec 0c             	sub    $0xc,%esp
  8021d3:	68 54 3e 80 00       	push   $0x803e54
  8021d8:	e8 70 e5 ff ff       	call   80074d <cprintf>
  8021dd:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8021e0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8021e4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ec:	eb 56                	jmp    802244 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021f2:	74 1c                	je     802210 <print_mem_block_lists+0x114>
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 50 08             	mov    0x8(%eax),%edx
  8021fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fd:	8b 48 08             	mov    0x8(%eax),%ecx
  802200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802203:	8b 40 0c             	mov    0xc(%eax),%eax
  802206:	01 c8                	add    %ecx,%eax
  802208:	39 c2                	cmp    %eax,%edx
  80220a:	73 04                	jae    802210 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80220c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 50 08             	mov    0x8(%eax),%edx
  802216:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802219:	8b 40 0c             	mov    0xc(%eax),%eax
  80221c:	01 c2                	add    %eax,%edx
  80221e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802221:	8b 40 08             	mov    0x8(%eax),%eax
  802224:	83 ec 04             	sub    $0x4,%esp
  802227:	52                   	push   %edx
  802228:	50                   	push   %eax
  802229:	68 21 3e 80 00       	push   $0x803e21
  80222e:	e8 1a e5 ff ff       	call   80074d <cprintf>
  802233:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802239:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80223c:	a1 48 40 80 00       	mov    0x804048,%eax
  802241:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802244:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802248:	74 07                	je     802251 <print_mem_block_lists+0x155>
  80224a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224d:	8b 00                	mov    (%eax),%eax
  80224f:	eb 05                	jmp    802256 <print_mem_block_lists+0x15a>
  802251:	b8 00 00 00 00       	mov    $0x0,%eax
  802256:	a3 48 40 80 00       	mov    %eax,0x804048
  80225b:	a1 48 40 80 00       	mov    0x804048,%eax
  802260:	85 c0                	test   %eax,%eax
  802262:	75 8a                	jne    8021ee <print_mem_block_lists+0xf2>
  802264:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802268:	75 84                	jne    8021ee <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80226a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80226e:	75 10                	jne    802280 <print_mem_block_lists+0x184>
  802270:	83 ec 0c             	sub    $0xc,%esp
  802273:	68 6c 3e 80 00       	push   $0x803e6c
  802278:	e8 d0 e4 ff ff       	call   80074d <cprintf>
  80227d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802280:	83 ec 0c             	sub    $0xc,%esp
  802283:	68 e0 3d 80 00       	push   $0x803de0
  802288:	e8 c0 e4 ff ff       	call   80074d <cprintf>
  80228d:	83 c4 10             	add    $0x10,%esp

}
  802290:	90                   	nop
  802291:	c9                   	leave  
  802292:	c3                   	ret    

00802293 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802299:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8022a0:	00 00 00 
  8022a3:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8022aa:	00 00 00 
  8022ad:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8022b4:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8022b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022be:	e9 9e 00 00 00       	jmp    802361 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8022c3:	a1 50 40 80 00       	mov    0x804050,%eax
  8022c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022cb:	c1 e2 04             	shl    $0x4,%edx
  8022ce:	01 d0                	add    %edx,%eax
  8022d0:	85 c0                	test   %eax,%eax
  8022d2:	75 14                	jne    8022e8 <initialize_MemBlocksList+0x55>
  8022d4:	83 ec 04             	sub    $0x4,%esp
  8022d7:	68 94 3e 80 00       	push   $0x803e94
  8022dc:	6a 3d                	push   $0x3d
  8022de:	68 b7 3e 80 00       	push   $0x803eb7
  8022e3:	e8 b1 e1 ff ff       	call   800499 <_panic>
  8022e8:	a1 50 40 80 00       	mov    0x804050,%eax
  8022ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022f0:	c1 e2 04             	shl    $0x4,%edx
  8022f3:	01 d0                	add    %edx,%eax
  8022f5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8022fb:	89 10                	mov    %edx,(%eax)
  8022fd:	8b 00                	mov    (%eax),%eax
  8022ff:	85 c0                	test   %eax,%eax
  802301:	74 18                	je     80231b <initialize_MemBlocksList+0x88>
  802303:	a1 48 41 80 00       	mov    0x804148,%eax
  802308:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80230e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802311:	c1 e1 04             	shl    $0x4,%ecx
  802314:	01 ca                	add    %ecx,%edx
  802316:	89 50 04             	mov    %edx,0x4(%eax)
  802319:	eb 12                	jmp    80232d <initialize_MemBlocksList+0x9a>
  80231b:	a1 50 40 80 00       	mov    0x804050,%eax
  802320:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802323:	c1 e2 04             	shl    $0x4,%edx
  802326:	01 d0                	add    %edx,%eax
  802328:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80232d:	a1 50 40 80 00       	mov    0x804050,%eax
  802332:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802335:	c1 e2 04             	shl    $0x4,%edx
  802338:	01 d0                	add    %edx,%eax
  80233a:	a3 48 41 80 00       	mov    %eax,0x804148
  80233f:	a1 50 40 80 00       	mov    0x804050,%eax
  802344:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802347:	c1 e2 04             	shl    $0x4,%edx
  80234a:	01 d0                	add    %edx,%eax
  80234c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802353:	a1 54 41 80 00       	mov    0x804154,%eax
  802358:	40                   	inc    %eax
  802359:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80235e:	ff 45 f4             	incl   -0xc(%ebp)
  802361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802364:	3b 45 08             	cmp    0x8(%ebp),%eax
  802367:	0f 82 56 ff ff ff    	jb     8022c3 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80236d:	90                   	nop
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	8b 00                	mov    (%eax),%eax
  80237b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80237e:	eb 18                	jmp    802398 <find_block+0x28>

		if(tmp->sva == va){
  802380:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802383:	8b 40 08             	mov    0x8(%eax),%eax
  802386:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802389:	75 05                	jne    802390 <find_block+0x20>
			return tmp ;
  80238b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80238e:	eb 11                	jmp    8023a1 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802390:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802393:	8b 00                	mov    (%eax),%eax
  802395:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802398:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80239c:	75 e2                	jne    802380 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80239e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8023a9:	a1 40 40 80 00       	mov    0x804040,%eax
  8023ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8023b1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8023b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023bd:	75 65                	jne    802424 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8023bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c3:	75 14                	jne    8023d9 <insert_sorted_allocList+0x36>
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	68 94 3e 80 00       	push   $0x803e94
  8023cd:	6a 62                	push   $0x62
  8023cf:	68 b7 3e 80 00       	push   $0x803eb7
  8023d4:	e8 c0 e0 ff ff       	call   800499 <_panic>
  8023d9:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8023df:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e2:	89 10                	mov    %edx,(%eax)
  8023e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e7:	8b 00                	mov    (%eax),%eax
  8023e9:	85 c0                	test   %eax,%eax
  8023eb:	74 0d                	je     8023fa <insert_sorted_allocList+0x57>
  8023ed:	a1 40 40 80 00       	mov    0x804040,%eax
  8023f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f5:	89 50 04             	mov    %edx,0x4(%eax)
  8023f8:	eb 08                	jmp    802402 <insert_sorted_allocList+0x5f>
  8023fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fd:	a3 44 40 80 00       	mov    %eax,0x804044
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	a3 40 40 80 00       	mov    %eax,0x804040
  80240a:	8b 45 08             	mov    0x8(%ebp),%eax
  80240d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802414:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802419:	40                   	inc    %eax
  80241a:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80241f:	e9 14 01 00 00       	jmp    802538 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	8b 50 08             	mov    0x8(%eax),%edx
  80242a:	a1 44 40 80 00       	mov    0x804044,%eax
  80242f:	8b 40 08             	mov    0x8(%eax),%eax
  802432:	39 c2                	cmp    %eax,%edx
  802434:	76 65                	jbe    80249b <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802436:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80243a:	75 14                	jne    802450 <insert_sorted_allocList+0xad>
  80243c:	83 ec 04             	sub    $0x4,%esp
  80243f:	68 d0 3e 80 00       	push   $0x803ed0
  802444:	6a 64                	push   $0x64
  802446:	68 b7 3e 80 00       	push   $0x803eb7
  80244b:	e8 49 e0 ff ff       	call   800499 <_panic>
  802450:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802456:	8b 45 08             	mov    0x8(%ebp),%eax
  802459:	89 50 04             	mov    %edx,0x4(%eax)
  80245c:	8b 45 08             	mov    0x8(%ebp),%eax
  80245f:	8b 40 04             	mov    0x4(%eax),%eax
  802462:	85 c0                	test   %eax,%eax
  802464:	74 0c                	je     802472 <insert_sorted_allocList+0xcf>
  802466:	a1 44 40 80 00       	mov    0x804044,%eax
  80246b:	8b 55 08             	mov    0x8(%ebp),%edx
  80246e:	89 10                	mov    %edx,(%eax)
  802470:	eb 08                	jmp    80247a <insert_sorted_allocList+0xd7>
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	a3 40 40 80 00       	mov    %eax,0x804040
  80247a:	8b 45 08             	mov    0x8(%ebp),%eax
  80247d:	a3 44 40 80 00       	mov    %eax,0x804044
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802490:	40                   	inc    %eax
  802491:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802496:	e9 9d 00 00 00       	jmp    802538 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80249b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8024a2:	e9 85 00 00 00       	jmp    80252c <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8024a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024aa:	8b 50 08             	mov    0x8(%eax),%edx
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 40 08             	mov    0x8(%eax),%eax
  8024b3:	39 c2                	cmp    %eax,%edx
  8024b5:	73 6a                	jae    802521 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8024b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bb:	74 06                	je     8024c3 <insert_sorted_allocList+0x120>
  8024bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024c1:	75 14                	jne    8024d7 <insert_sorted_allocList+0x134>
  8024c3:	83 ec 04             	sub    $0x4,%esp
  8024c6:	68 f4 3e 80 00       	push   $0x803ef4
  8024cb:	6a 6b                	push   $0x6b
  8024cd:	68 b7 3e 80 00       	push   $0x803eb7
  8024d2:	e8 c2 df ff ff       	call   800499 <_panic>
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 50 04             	mov    0x4(%eax),%edx
  8024dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e0:	89 50 04             	mov    %edx,0x4(%eax)
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e9:	89 10                	mov    %edx,(%eax)
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 40 04             	mov    0x4(%eax),%eax
  8024f1:	85 c0                	test   %eax,%eax
  8024f3:	74 0d                	je     802502 <insert_sorted_allocList+0x15f>
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	8b 40 04             	mov    0x4(%eax),%eax
  8024fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024fe:	89 10                	mov    %edx,(%eax)
  802500:	eb 08                	jmp    80250a <insert_sorted_allocList+0x167>
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	a3 40 40 80 00       	mov    %eax,0x804040
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 55 08             	mov    0x8(%ebp),%edx
  802510:	89 50 04             	mov    %edx,0x4(%eax)
  802513:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802518:	40                   	inc    %eax
  802519:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  80251e:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80251f:	eb 17                	jmp    802538 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 00                	mov    (%eax),%eax
  802526:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802529:	ff 45 f0             	incl   -0x10(%ebp)
  80252c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802532:	0f 8c 6f ff ff ff    	jl     8024a7 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802538:	90                   	nop
  802539:	c9                   	leave  
  80253a:	c3                   	ret    

0080253b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80253b:	55                   	push   %ebp
  80253c:	89 e5                	mov    %esp,%ebp
  80253e:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802541:	a1 38 41 80 00       	mov    0x804138,%eax
  802546:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802549:	e9 7c 01 00 00       	jmp    8026ca <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 40 0c             	mov    0xc(%eax),%eax
  802554:	3b 45 08             	cmp    0x8(%ebp),%eax
  802557:	0f 86 cf 00 00 00    	jbe    80262c <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80255d:	a1 48 41 80 00       	mov    0x804148,%eax
  802562:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802568:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80256b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256e:	8b 55 08             	mov    0x8(%ebp),%edx
  802571:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 50 08             	mov    0x8(%eax),%edx
  80257a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80257d:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 0c             	mov    0xc(%eax),%eax
  802586:	2b 45 08             	sub    0x8(%ebp),%eax
  802589:	89 c2                	mov    %eax,%edx
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 50 08             	mov    0x8(%eax),%edx
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	01 c2                	add    %eax,%edx
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8025a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025a6:	75 17                	jne    8025bf <alloc_block_FF+0x84>
  8025a8:	83 ec 04             	sub    $0x4,%esp
  8025ab:	68 29 3f 80 00       	push   $0x803f29
  8025b0:	68 83 00 00 00       	push   $0x83
  8025b5:	68 b7 3e 80 00       	push   $0x803eb7
  8025ba:	e8 da de ff ff       	call   800499 <_panic>
  8025bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	85 c0                	test   %eax,%eax
  8025c6:	74 10                	je     8025d8 <alloc_block_FF+0x9d>
  8025c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025d0:	8b 52 04             	mov    0x4(%edx),%edx
  8025d3:	89 50 04             	mov    %edx,0x4(%eax)
  8025d6:	eb 0b                	jmp    8025e3 <alloc_block_FF+0xa8>
  8025d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025db:	8b 40 04             	mov    0x4(%eax),%eax
  8025de:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025e6:	8b 40 04             	mov    0x4(%eax),%eax
  8025e9:	85 c0                	test   %eax,%eax
  8025eb:	74 0f                	je     8025fc <alloc_block_FF+0xc1>
  8025ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f0:	8b 40 04             	mov    0x4(%eax),%eax
  8025f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025f6:	8b 12                	mov    (%edx),%edx
  8025f8:	89 10                	mov    %edx,(%eax)
  8025fa:	eb 0a                	jmp    802606 <alloc_block_FF+0xcb>
  8025fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	a3 48 41 80 00       	mov    %eax,0x804148
  802606:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802609:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80260f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802612:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802619:	a1 54 41 80 00       	mov    0x804154,%eax
  80261e:	48                   	dec    %eax
  80261f:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802624:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802627:	e9 ad 00 00 00       	jmp    8026d9 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80262c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262f:	8b 40 0c             	mov    0xc(%eax),%eax
  802632:	3b 45 08             	cmp    0x8(%ebp),%eax
  802635:	0f 85 87 00 00 00    	jne    8026c2 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80263b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263f:	75 17                	jne    802658 <alloc_block_FF+0x11d>
  802641:	83 ec 04             	sub    $0x4,%esp
  802644:	68 29 3f 80 00       	push   $0x803f29
  802649:	68 87 00 00 00       	push   $0x87
  80264e:	68 b7 3e 80 00       	push   $0x803eb7
  802653:	e8 41 de ff ff       	call   800499 <_panic>
  802658:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265b:	8b 00                	mov    (%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 10                	je     802671 <alloc_block_FF+0x136>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802669:	8b 52 04             	mov    0x4(%edx),%edx
  80266c:	89 50 04             	mov    %edx,0x4(%eax)
  80266f:	eb 0b                	jmp    80267c <alloc_block_FF+0x141>
  802671:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802674:	8b 40 04             	mov    0x4(%eax),%eax
  802677:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267f:	8b 40 04             	mov    0x4(%eax),%eax
  802682:	85 c0                	test   %eax,%eax
  802684:	74 0f                	je     802695 <alloc_block_FF+0x15a>
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 40 04             	mov    0x4(%eax),%eax
  80268c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268f:	8b 12                	mov    (%edx),%edx
  802691:	89 10                	mov    %edx,(%eax)
  802693:	eb 0a                	jmp    80269f <alloc_block_FF+0x164>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	a3 38 41 80 00       	mov    %eax,0x804138
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b2:	a1 44 41 80 00       	mov    0x804144,%eax
  8026b7:	48                   	dec    %eax
  8026b8:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	eb 17                	jmp    8026d9 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 00                	mov    (%eax),%eax
  8026c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8026ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ce:	0f 85 7a fe ff ff    	jne    80254e <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8026d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    

008026db <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8026e1:	a1 38 41 80 00       	mov    0x804138,%eax
  8026e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8026e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8026f0:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8026f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8026fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026ff:	e9 d0 00 00 00       	jmp    8027d4 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 0c             	mov    0xc(%eax),%eax
  80270a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80270d:	0f 82 b8 00 00 00    	jb     8027cb <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802713:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802716:	8b 40 0c             	mov    0xc(%eax),%eax
  802719:	2b 45 08             	sub    0x8(%ebp),%eax
  80271c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80271f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802722:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802725:	0f 83 a1 00 00 00    	jae    8027cc <alloc_block_BF+0xf1>
				differsize = differance ;
  80272b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80272e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802737:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80273b:	0f 85 8b 00 00 00    	jne    8027cc <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802745:	75 17                	jne    80275e <alloc_block_BF+0x83>
  802747:	83 ec 04             	sub    $0x4,%esp
  80274a:	68 29 3f 80 00       	push   $0x803f29
  80274f:	68 a0 00 00 00       	push   $0xa0
  802754:	68 b7 3e 80 00       	push   $0x803eb7
  802759:	e8 3b dd ff ff       	call   800499 <_panic>
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	8b 00                	mov    (%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 10                	je     802777 <alloc_block_BF+0x9c>
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 00                	mov    (%eax),%eax
  80276c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276f:	8b 52 04             	mov    0x4(%edx),%edx
  802772:	89 50 04             	mov    %edx,0x4(%eax)
  802775:	eb 0b                	jmp    802782 <alloc_block_BF+0xa7>
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 40 04             	mov    0x4(%eax),%eax
  80277d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802785:	8b 40 04             	mov    0x4(%eax),%eax
  802788:	85 c0                	test   %eax,%eax
  80278a:	74 0f                	je     80279b <alloc_block_BF+0xc0>
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 40 04             	mov    0x4(%eax),%eax
  802792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802795:	8b 12                	mov    (%edx),%edx
  802797:	89 10                	mov    %edx,(%eax)
  802799:	eb 0a                	jmp    8027a5 <alloc_block_BF+0xca>
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 00                	mov    (%eax),%eax
  8027a0:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b8:	a1 44 41 80 00       	mov    0x804144,%eax
  8027bd:	48                   	dec    %eax
  8027be:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8027c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c6:	e9 0c 01 00 00       	jmp    8028d7 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8027cb:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8027cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8027d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d8:	74 07                	je     8027e1 <alloc_block_BF+0x106>
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 00                	mov    (%eax),%eax
  8027df:	eb 05                	jmp    8027e6 <alloc_block_BF+0x10b>
  8027e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027e6:	a3 40 41 80 00       	mov    %eax,0x804140
  8027eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8027f0:	85 c0                	test   %eax,%eax
  8027f2:	0f 85 0c ff ff ff    	jne    802704 <alloc_block_BF+0x29>
  8027f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fc:	0f 85 02 ff ff ff    	jne    802704 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802802:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802806:	0f 84 c6 00 00 00    	je     8028d2 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80280c:	a1 48 41 80 00       	mov    0x804148,%eax
  802811:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802814:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802817:	8b 55 08             	mov    0x8(%ebp),%edx
  80281a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802820:	8b 50 08             	mov    0x8(%eax),%edx
  802823:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802826:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282c:	8b 40 0c             	mov    0xc(%eax),%eax
  80282f:	2b 45 08             	sub    0x8(%ebp),%eax
  802832:	89 c2                	mov    %eax,%edx
  802834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802837:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80283a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283d:	8b 50 08             	mov    0x8(%eax),%edx
  802840:	8b 45 08             	mov    0x8(%ebp),%eax
  802843:	01 c2                	add    %eax,%edx
  802845:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802848:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80284b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80284f:	75 17                	jne    802868 <alloc_block_BF+0x18d>
  802851:	83 ec 04             	sub    $0x4,%esp
  802854:	68 29 3f 80 00       	push   $0x803f29
  802859:	68 af 00 00 00       	push   $0xaf
  80285e:	68 b7 3e 80 00       	push   $0x803eb7
  802863:	e8 31 dc ff ff       	call   800499 <_panic>
  802868:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80286b:	8b 00                	mov    (%eax),%eax
  80286d:	85 c0                	test   %eax,%eax
  80286f:	74 10                	je     802881 <alloc_block_BF+0x1a6>
  802871:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802874:	8b 00                	mov    (%eax),%eax
  802876:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802879:	8b 52 04             	mov    0x4(%edx),%edx
  80287c:	89 50 04             	mov    %edx,0x4(%eax)
  80287f:	eb 0b                	jmp    80288c <alloc_block_BF+0x1b1>
  802881:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802884:	8b 40 04             	mov    0x4(%eax),%eax
  802887:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80288c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80288f:	8b 40 04             	mov    0x4(%eax),%eax
  802892:	85 c0                	test   %eax,%eax
  802894:	74 0f                	je     8028a5 <alloc_block_BF+0x1ca>
  802896:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80289f:	8b 12                	mov    (%edx),%edx
  8028a1:	89 10                	mov    %edx,(%eax)
  8028a3:	eb 0a                	jmp    8028af <alloc_block_BF+0x1d4>
  8028a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	a3 48 41 80 00       	mov    %eax,0x804148
  8028af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028bb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028c2:	a1 54 41 80 00       	mov    0x804154,%eax
  8028c7:	48                   	dec    %eax
  8028c8:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8028cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d0:	eb 05                	jmp    8028d7 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8028d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028d7:	c9                   	leave  
  8028d8:	c3                   	ret    

008028d9 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8028d9:	55                   	push   %ebp
  8028da:	89 e5                	mov    %esp,%ebp
  8028dc:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8028df:	a1 38 41 80 00       	mov    0x804138,%eax
  8028e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8028e7:	e9 7c 01 00 00       	jmp    802a68 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8028ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028f5:	0f 86 cf 00 00 00    	jbe    8029ca <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8028fb:	a1 48 41 80 00       	mov    0x804148,%eax
  802900:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802906:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802909:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290c:	8b 55 08             	mov    0x8(%ebp),%edx
  80290f:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802915:	8b 50 08             	mov    0x8(%eax),%edx
  802918:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291b:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 0c             	mov    0xc(%eax),%eax
  802924:	2b 45 08             	sub    0x8(%ebp),%eax
  802927:	89 c2                	mov    %eax,%edx
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	8b 50 08             	mov    0x8(%eax),%edx
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	01 c2                	add    %eax,%edx
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802940:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802944:	75 17                	jne    80295d <alloc_block_NF+0x84>
  802946:	83 ec 04             	sub    $0x4,%esp
  802949:	68 29 3f 80 00       	push   $0x803f29
  80294e:	68 c4 00 00 00       	push   $0xc4
  802953:	68 b7 3e 80 00       	push   $0x803eb7
  802958:	e8 3c db ff ff       	call   800499 <_panic>
  80295d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 10                	je     802976 <alloc_block_NF+0x9d>
  802966:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802969:	8b 00                	mov    (%eax),%eax
  80296b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80296e:	8b 52 04             	mov    0x4(%edx),%edx
  802971:	89 50 04             	mov    %edx,0x4(%eax)
  802974:	eb 0b                	jmp    802981 <alloc_block_NF+0xa8>
  802976:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802979:	8b 40 04             	mov    0x4(%eax),%eax
  80297c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802981:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802984:	8b 40 04             	mov    0x4(%eax),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	74 0f                	je     80299a <alloc_block_NF+0xc1>
  80298b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298e:	8b 40 04             	mov    0x4(%eax),%eax
  802991:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802994:	8b 12                	mov    (%edx),%edx
  802996:	89 10                	mov    %edx,(%eax)
  802998:	eb 0a                	jmp    8029a4 <alloc_block_NF+0xcb>
  80299a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	a3 48 41 80 00       	mov    %eax,0x804148
  8029a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b7:	a1 54 41 80 00       	mov    0x804154,%eax
  8029bc:	48                   	dec    %eax
  8029bd:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8029c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c5:	e9 ad 00 00 00       	jmp    802a77 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029d3:	0f 85 87 00 00 00    	jne    802a60 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8029d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029dd:	75 17                	jne    8029f6 <alloc_block_NF+0x11d>
  8029df:	83 ec 04             	sub    $0x4,%esp
  8029e2:	68 29 3f 80 00       	push   $0x803f29
  8029e7:	68 c8 00 00 00       	push   $0xc8
  8029ec:	68 b7 3e 80 00       	push   $0x803eb7
  8029f1:	e8 a3 da ff ff       	call   800499 <_panic>
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	74 10                	je     802a0f <alloc_block_NF+0x136>
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	8b 00                	mov    (%eax),%eax
  802a04:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a07:	8b 52 04             	mov    0x4(%edx),%edx
  802a0a:	89 50 04             	mov    %edx,0x4(%eax)
  802a0d:	eb 0b                	jmp    802a1a <alloc_block_NF+0x141>
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	8b 40 04             	mov    0x4(%eax),%eax
  802a15:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 40 04             	mov    0x4(%eax),%eax
  802a20:	85 c0                	test   %eax,%eax
  802a22:	74 0f                	je     802a33 <alloc_block_NF+0x15a>
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 40 04             	mov    0x4(%eax),%eax
  802a2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a2d:	8b 12                	mov    (%edx),%edx
  802a2f:	89 10                	mov    %edx,(%eax)
  802a31:	eb 0a                	jmp    802a3d <alloc_block_NF+0x164>
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	a3 38 41 80 00       	mov    %eax,0x804138
  802a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a50:	a1 44 41 80 00       	mov    0x804144,%eax
  802a55:	48                   	dec    %eax
  802a56:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5e:	eb 17                	jmp    802a77 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802a68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a6c:	0f 85 7a fe ff ff    	jne    8028ec <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802a72:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802a77:	c9                   	leave  
  802a78:	c3                   	ret    

00802a79 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a79:	55                   	push   %ebp
  802a7a:	89 e5                	mov    %esp,%ebp
  802a7c:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802a7f:	a1 38 41 80 00       	mov    0x804138,%eax
  802a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802a87:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802a8f:	a1 44 41 80 00       	mov    0x804144,%eax
  802a94:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802a97:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a9b:	75 68                	jne    802b05 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802a9d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa1:	75 17                	jne    802aba <insert_sorted_with_merge_freeList+0x41>
  802aa3:	83 ec 04             	sub    $0x4,%esp
  802aa6:	68 94 3e 80 00       	push   $0x803e94
  802aab:	68 da 00 00 00       	push   $0xda
  802ab0:	68 b7 3e 80 00       	push   $0x803eb7
  802ab5:	e8 df d9 ff ff       	call   800499 <_panic>
  802aba:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	89 10                	mov    %edx,(%eax)
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	8b 00                	mov    (%eax),%eax
  802aca:	85 c0                	test   %eax,%eax
  802acc:	74 0d                	je     802adb <insert_sorted_with_merge_freeList+0x62>
  802ace:	a1 38 41 80 00       	mov    0x804138,%eax
  802ad3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad6:	89 50 04             	mov    %edx,0x4(%eax)
  802ad9:	eb 08                	jmp    802ae3 <insert_sorted_with_merge_freeList+0x6a>
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	a3 38 41 80 00       	mov    %eax,0x804138
  802aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802aee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af5:	a1 44 41 80 00       	mov    0x804144,%eax
  802afa:	40                   	inc    %eax
  802afb:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802b00:	e9 49 07 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b08:	8b 50 08             	mov    0x8(%eax),%edx
  802b0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b0e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b11:	01 c2                	add    %eax,%edx
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	8b 40 08             	mov    0x8(%eax),%eax
  802b19:	39 c2                	cmp    %eax,%edx
  802b1b:	73 77                	jae    802b94 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	8b 00                	mov    (%eax),%eax
  802b22:	85 c0                	test   %eax,%eax
  802b24:	75 6e                	jne    802b94 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802b26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b2a:	74 68                	je     802b94 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802b2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b30:	75 17                	jne    802b49 <insert_sorted_with_merge_freeList+0xd0>
  802b32:	83 ec 04             	sub    $0x4,%esp
  802b35:	68 d0 3e 80 00       	push   $0x803ed0
  802b3a:	68 e0 00 00 00       	push   $0xe0
  802b3f:	68 b7 3e 80 00       	push   $0x803eb7
  802b44:	e8 50 d9 ff ff       	call   800499 <_panic>
  802b49:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	89 50 04             	mov    %edx,0x4(%eax)
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	8b 40 04             	mov    0x4(%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	74 0c                	je     802b6b <insert_sorted_with_merge_freeList+0xf2>
  802b5f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b64:	8b 55 08             	mov    0x8(%ebp),%edx
  802b67:	89 10                	mov    %edx,(%eax)
  802b69:	eb 08                	jmp    802b73 <insert_sorted_with_merge_freeList+0xfa>
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	a3 38 41 80 00       	mov    %eax,0x804138
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b84:	a1 44 41 80 00       	mov    0x804144,%eax
  802b89:	40                   	inc    %eax
  802b8a:	a3 44 41 80 00       	mov    %eax,0x804144
  802b8f:	e9 ba 06 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 50 0c             	mov    0xc(%eax),%edx
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ba0:	01 c2                	add    %eax,%edx
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 40 08             	mov    0x8(%eax),%eax
  802ba8:	39 c2                	cmp    %eax,%edx
  802baa:	73 78                	jae    802c24 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baf:	8b 40 04             	mov    0x4(%eax),%eax
  802bb2:	85 c0                	test   %eax,%eax
  802bb4:	75 6e                	jne    802c24 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802bb6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bba:	74 68                	je     802c24 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802bbc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc0:	75 17                	jne    802bd9 <insert_sorted_with_merge_freeList+0x160>
  802bc2:	83 ec 04             	sub    $0x4,%esp
  802bc5:	68 94 3e 80 00       	push   $0x803e94
  802bca:	68 e6 00 00 00       	push   $0xe6
  802bcf:	68 b7 3e 80 00       	push   $0x803eb7
  802bd4:	e8 c0 d8 ff ff       	call   800499 <_panic>
  802bd9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	89 10                	mov    %edx,(%eax)
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	8b 00                	mov    (%eax),%eax
  802be9:	85 c0                	test   %eax,%eax
  802beb:	74 0d                	je     802bfa <insert_sorted_with_merge_freeList+0x181>
  802bed:	a1 38 41 80 00       	mov    0x804138,%eax
  802bf2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf5:	89 50 04             	mov    %edx,0x4(%eax)
  802bf8:	eb 08                	jmp    802c02 <insert_sorted_with_merge_freeList+0x189>
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	a3 38 41 80 00       	mov    %eax,0x804138
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c14:	a1 44 41 80 00       	mov    0x804144,%eax
  802c19:	40                   	inc    %eax
  802c1a:	a3 44 41 80 00       	mov    %eax,0x804144
  802c1f:	e9 2a 06 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802c24:	a1 38 41 80 00       	mov    0x804138,%eax
  802c29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c2c:	e9 ed 05 00 00       	jmp    80321e <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 00                	mov    (%eax),%eax
  802c36:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802c39:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c3d:	0f 84 a7 00 00 00    	je     802cea <insert_sorted_with_merge_freeList+0x271>
  802c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c46:	8b 50 0c             	mov    0xc(%eax),%edx
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 40 08             	mov    0x8(%eax),%eax
  802c4f:	01 c2                	add    %eax,%edx
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	8b 40 08             	mov    0x8(%eax),%eax
  802c57:	39 c2                	cmp    %eax,%edx
  802c59:	0f 83 8b 00 00 00    	jae    802cea <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 50 0c             	mov    0xc(%eax),%edx
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	8b 40 08             	mov    0x8(%eax),%eax
  802c6b:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802c6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c70:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802c73:	39 c2                	cmp    %eax,%edx
  802c75:	73 73                	jae    802cea <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802c77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7b:	74 06                	je     802c83 <insert_sorted_with_merge_freeList+0x20a>
  802c7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c81:	75 17                	jne    802c9a <insert_sorted_with_merge_freeList+0x221>
  802c83:	83 ec 04             	sub    $0x4,%esp
  802c86:	68 48 3f 80 00       	push   $0x803f48
  802c8b:	68 f0 00 00 00       	push   $0xf0
  802c90:	68 b7 3e 80 00       	push   $0x803eb7
  802c95:	e8 ff d7 ff ff       	call   800499 <_panic>
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	8b 10                	mov    (%eax),%edx
  802c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca2:	89 10                	mov    %edx,(%eax)
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	8b 00                	mov    (%eax),%eax
  802ca9:	85 c0                	test   %eax,%eax
  802cab:	74 0b                	je     802cb8 <insert_sorted_with_merge_freeList+0x23f>
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	8b 00                	mov    (%eax),%eax
  802cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb5:	89 50 04             	mov    %edx,0x4(%eax)
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbe:	89 10                	mov    %edx,(%eax)
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc6:	89 50 04             	mov    %edx,0x4(%eax)
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	8b 00                	mov    (%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	75 08                	jne    802cda <insert_sorted_with_merge_freeList+0x261>
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cda:	a1 44 41 80 00       	mov    0x804144,%eax
  802cdf:	40                   	inc    %eax
  802ce0:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802ce5:	e9 64 05 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802cea:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cef:	8b 50 0c             	mov    0xc(%eax),%edx
  802cf2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802cf7:	8b 40 08             	mov    0x8(%eax),%eax
  802cfa:	01 c2                	add    %eax,%edx
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	8b 40 08             	mov    0x8(%eax),%eax
  802d02:	39 c2                	cmp    %eax,%edx
  802d04:	0f 85 b1 00 00 00    	jne    802dbb <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802d0a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d0f:	85 c0                	test   %eax,%eax
  802d11:	0f 84 a4 00 00 00    	je     802dbb <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802d17:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d1c:	8b 00                	mov    (%eax),%eax
  802d1e:	85 c0                	test   %eax,%eax
  802d20:	0f 85 95 00 00 00    	jne    802dbb <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802d26:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d2b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d31:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d34:	8b 55 08             	mov    0x8(%ebp),%edx
  802d37:	8b 52 0c             	mov    0xc(%edx),%edx
  802d3a:	01 ca                	add    %ecx,%edx
  802d3c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d53:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d57:	75 17                	jne    802d70 <insert_sorted_with_merge_freeList+0x2f7>
  802d59:	83 ec 04             	sub    $0x4,%esp
  802d5c:	68 94 3e 80 00       	push   $0x803e94
  802d61:	68 ff 00 00 00       	push   $0xff
  802d66:	68 b7 3e 80 00       	push   $0x803eb7
  802d6b:	e8 29 d7 ff ff       	call   800499 <_panic>
  802d70:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d76:	8b 45 08             	mov    0x8(%ebp),%eax
  802d79:	89 10                	mov    %edx,(%eax)
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	74 0d                	je     802d91 <insert_sorted_with_merge_freeList+0x318>
  802d84:	a1 48 41 80 00       	mov    0x804148,%eax
  802d89:	8b 55 08             	mov    0x8(%ebp),%edx
  802d8c:	89 50 04             	mov    %edx,0x4(%eax)
  802d8f:	eb 08                	jmp    802d99 <insert_sorted_with_merge_freeList+0x320>
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	a3 48 41 80 00       	mov    %eax,0x804148
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dab:	a1 54 41 80 00       	mov    0x804154,%eax
  802db0:	40                   	inc    %eax
  802db1:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802db6:	e9 93 04 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802dbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbe:	8b 50 08             	mov    0x8(%eax),%edx
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc7:	01 c2                	add    %eax,%edx
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	8b 40 08             	mov    0x8(%eax),%eax
  802dcf:	39 c2                	cmp    %eax,%edx
  802dd1:	0f 85 ae 00 00 00    	jne    802e85 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	8b 50 0c             	mov    0xc(%eax),%edx
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	8b 40 08             	mov    0x8(%eax),%eax
  802de3:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	8b 00                	mov    (%eax),%eax
  802dea:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802ded:	39 c2                	cmp    %eax,%edx
  802def:	0f 84 90 00 00 00    	je     802e85 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfe:	8b 40 0c             	mov    0xc(%eax),%eax
  802e01:	01 c2                	add    %eax,%edx
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e21:	75 17                	jne    802e3a <insert_sorted_with_merge_freeList+0x3c1>
  802e23:	83 ec 04             	sub    $0x4,%esp
  802e26:	68 94 3e 80 00       	push   $0x803e94
  802e2b:	68 0b 01 00 00       	push   $0x10b
  802e30:	68 b7 3e 80 00       	push   $0x803eb7
  802e35:	e8 5f d6 ff ff       	call   800499 <_panic>
  802e3a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	89 10                	mov    %edx,(%eax)
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	8b 00                	mov    (%eax),%eax
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	74 0d                	je     802e5b <insert_sorted_with_merge_freeList+0x3e2>
  802e4e:	a1 48 41 80 00       	mov    0x804148,%eax
  802e53:	8b 55 08             	mov    0x8(%ebp),%edx
  802e56:	89 50 04             	mov    %edx,0x4(%eax)
  802e59:	eb 08                	jmp    802e63 <insert_sorted_with_merge_freeList+0x3ea>
  802e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	a3 48 41 80 00       	mov    %eax,0x804148
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e75:	a1 54 41 80 00       	mov    0x804154,%eax
  802e7a:	40                   	inc    %eax
  802e7b:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802e80:	e9 c9 03 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802e85:	8b 45 08             	mov    0x8(%ebp),%eax
  802e88:	8b 50 0c             	mov    0xc(%eax),%edx
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	8b 40 08             	mov    0x8(%eax),%eax
  802e91:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e96:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802e99:	39 c2                	cmp    %eax,%edx
  802e9b:	0f 85 bb 00 00 00    	jne    802f5c <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea5:	0f 84 b1 00 00 00    	je     802f5c <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	8b 40 04             	mov    0x4(%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	0f 85 a3 00 00 00    	jne    802f5c <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802eb9:	a1 38 41 80 00       	mov    0x804138,%eax
  802ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec1:	8b 52 08             	mov    0x8(%edx),%edx
  802ec4:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802ec7:	a1 38 41 80 00       	mov    0x804138,%eax
  802ecc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ed2:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed8:	8b 52 0c             	mov    0xc(%edx),%edx
  802edb:	01 ca                	add    %ecx,%edx
  802edd:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802ef4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef8:	75 17                	jne    802f11 <insert_sorted_with_merge_freeList+0x498>
  802efa:	83 ec 04             	sub    $0x4,%esp
  802efd:	68 94 3e 80 00       	push   $0x803e94
  802f02:	68 17 01 00 00       	push   $0x117
  802f07:	68 b7 3e 80 00       	push   $0x803eb7
  802f0c:	e8 88 d5 ff ff       	call   800499 <_panic>
  802f11:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	89 10                	mov    %edx,(%eax)
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	8b 00                	mov    (%eax),%eax
  802f21:	85 c0                	test   %eax,%eax
  802f23:	74 0d                	je     802f32 <insert_sorted_with_merge_freeList+0x4b9>
  802f25:	a1 48 41 80 00       	mov    0x804148,%eax
  802f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2d:	89 50 04             	mov    %edx,0x4(%eax)
  802f30:	eb 08                	jmp    802f3a <insert_sorted_with_merge_freeList+0x4c1>
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	a3 48 41 80 00       	mov    %eax,0x804148
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4c:	a1 54 41 80 00       	mov    0x804154,%eax
  802f51:	40                   	inc    %eax
  802f52:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802f57:	e9 f2 02 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	8b 50 08             	mov    0x8(%eax),%edx
  802f62:	8b 45 08             	mov    0x8(%ebp),%eax
  802f65:	8b 40 0c             	mov    0xc(%eax),%eax
  802f68:	01 c2                	add    %eax,%edx
  802f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6d:	8b 40 08             	mov    0x8(%eax),%eax
  802f70:	39 c2                	cmp    %eax,%edx
  802f72:	0f 85 be 00 00 00    	jne    803036 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7b:	8b 40 04             	mov    0x4(%eax),%eax
  802f7e:	8b 50 08             	mov    0x8(%eax),%edx
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	8b 40 04             	mov    0x4(%eax),%eax
  802f87:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8a:	01 c2                	add    %eax,%edx
  802f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8f:	8b 40 08             	mov    0x8(%eax),%eax
  802f92:	39 c2                	cmp    %eax,%edx
  802f94:	0f 84 9c 00 00 00    	je     803036 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	8b 50 08             	mov    0x8(%eax),%edx
  802fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa3:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa9:	8b 50 0c             	mov    0xc(%eax),%edx
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb2:	01 c2                	add    %eax,%edx
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802fce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd2:	75 17                	jne    802feb <insert_sorted_with_merge_freeList+0x572>
  802fd4:	83 ec 04             	sub    $0x4,%esp
  802fd7:	68 94 3e 80 00       	push   $0x803e94
  802fdc:	68 26 01 00 00       	push   $0x126
  802fe1:	68 b7 3e 80 00       	push   $0x803eb7
  802fe6:	e8 ae d4 ff ff       	call   800499 <_panic>
  802feb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	89 10                	mov    %edx,(%eax)
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	74 0d                	je     80300c <insert_sorted_with_merge_freeList+0x593>
  802fff:	a1 48 41 80 00       	mov    0x804148,%eax
  803004:	8b 55 08             	mov    0x8(%ebp),%edx
  803007:	89 50 04             	mov    %edx,0x4(%eax)
  80300a:	eb 08                	jmp    803014 <insert_sorted_with_merge_freeList+0x59b>
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803014:	8b 45 08             	mov    0x8(%ebp),%eax
  803017:	a3 48 41 80 00       	mov    %eax,0x804148
  80301c:	8b 45 08             	mov    0x8(%ebp),%eax
  80301f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803026:	a1 54 41 80 00       	mov    0x804154,%eax
  80302b:	40                   	inc    %eax
  80302c:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  803031:	e9 18 02 00 00       	jmp    80324e <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803039:	8b 50 0c             	mov    0xc(%eax),%edx
  80303c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303f:	8b 40 08             	mov    0x8(%eax),%eax
  803042:	01 c2                	add    %eax,%edx
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	8b 40 08             	mov    0x8(%eax),%eax
  80304a:	39 c2                	cmp    %eax,%edx
  80304c:	0f 85 c4 01 00 00    	jne    803216 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803052:	8b 45 08             	mov    0x8(%ebp),%eax
  803055:	8b 50 0c             	mov    0xc(%eax),%edx
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	8b 40 08             	mov    0x8(%eax),%eax
  80305e:	01 c2                	add    %eax,%edx
  803060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803063:	8b 00                	mov    (%eax),%eax
  803065:	8b 40 08             	mov    0x8(%eax),%eax
  803068:	39 c2                	cmp    %eax,%edx
  80306a:	0f 85 a6 01 00 00    	jne    803216 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803070:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803074:	0f 84 9c 01 00 00    	je     803216 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  80307a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307d:	8b 50 0c             	mov    0xc(%eax),%edx
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	8b 40 0c             	mov    0xc(%eax),%eax
  803086:	01 c2                	add    %eax,%edx
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	8b 00                	mov    (%eax),%eax
  80308d:	8b 40 0c             	mov    0xc(%eax),%eax
  803090:	01 c2                	add    %eax,%edx
  803092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803095:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8030ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030b0:	75 17                	jne    8030c9 <insert_sorted_with_merge_freeList+0x650>
  8030b2:	83 ec 04             	sub    $0x4,%esp
  8030b5:	68 94 3e 80 00       	push   $0x803e94
  8030ba:	68 32 01 00 00       	push   $0x132
  8030bf:	68 b7 3e 80 00       	push   $0x803eb7
  8030c4:	e8 d0 d3 ff ff       	call   800499 <_panic>
  8030c9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	89 10                	mov    %edx,(%eax)
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	8b 00                	mov    (%eax),%eax
  8030d9:	85 c0                	test   %eax,%eax
  8030db:	74 0d                	je     8030ea <insert_sorted_with_merge_freeList+0x671>
  8030dd:	a1 48 41 80 00       	mov    0x804148,%eax
  8030e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e5:	89 50 04             	mov    %edx,0x4(%eax)
  8030e8:	eb 08                	jmp    8030f2 <insert_sorted_with_merge_freeList+0x679>
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ed:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	a3 48 41 80 00       	mov    %eax,0x804148
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803104:	a1 54 41 80 00       	mov    0x804154,%eax
  803109:	40                   	inc    %eax
  80310a:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	8b 00                	mov    (%eax),%eax
  803114:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80311b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80312f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803133:	75 17                	jne    80314c <insert_sorted_with_merge_freeList+0x6d3>
  803135:	83 ec 04             	sub    $0x4,%esp
  803138:	68 29 3f 80 00       	push   $0x803f29
  80313d:	68 36 01 00 00       	push   $0x136
  803142:	68 b7 3e 80 00       	push   $0x803eb7
  803147:	e8 4d d3 ff ff       	call   800499 <_panic>
  80314c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314f:	8b 00                	mov    (%eax),%eax
  803151:	85 c0                	test   %eax,%eax
  803153:	74 10                	je     803165 <insert_sorted_with_merge_freeList+0x6ec>
  803155:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803158:	8b 00                	mov    (%eax),%eax
  80315a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80315d:	8b 52 04             	mov    0x4(%edx),%edx
  803160:	89 50 04             	mov    %edx,0x4(%eax)
  803163:	eb 0b                	jmp    803170 <insert_sorted_with_merge_freeList+0x6f7>
  803165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803168:	8b 40 04             	mov    0x4(%eax),%eax
  80316b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803170:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803173:	8b 40 04             	mov    0x4(%eax),%eax
  803176:	85 c0                	test   %eax,%eax
  803178:	74 0f                	je     803189 <insert_sorted_with_merge_freeList+0x710>
  80317a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80317d:	8b 40 04             	mov    0x4(%eax),%eax
  803180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803183:	8b 12                	mov    (%edx),%edx
  803185:	89 10                	mov    %edx,(%eax)
  803187:	eb 0a                	jmp    803193 <insert_sorted_with_merge_freeList+0x71a>
  803189:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	a3 38 41 80 00       	mov    %eax,0x804138
  803193:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803196:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80319c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80319f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031a6:	a1 44 41 80 00       	mov    0x804144,%eax
  8031ab:	48                   	dec    %eax
  8031ac:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8031b1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031b5:	75 17                	jne    8031ce <insert_sorted_with_merge_freeList+0x755>
  8031b7:	83 ec 04             	sub    $0x4,%esp
  8031ba:	68 94 3e 80 00       	push   $0x803e94
  8031bf:	68 37 01 00 00       	push   $0x137
  8031c4:	68 b7 3e 80 00       	push   $0x803eb7
  8031c9:	e8 cb d2 ff ff       	call   800499 <_panic>
  8031ce:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8031d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d7:	89 10                	mov    %edx,(%eax)
  8031d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031dc:	8b 00                	mov    (%eax),%eax
  8031de:	85 c0                	test   %eax,%eax
  8031e0:	74 0d                	je     8031ef <insert_sorted_with_merge_freeList+0x776>
  8031e2:	a1 48 41 80 00       	mov    0x804148,%eax
  8031e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031ea:	89 50 04             	mov    %edx,0x4(%eax)
  8031ed:	eb 08                	jmp    8031f7 <insert_sorted_with_merge_freeList+0x77e>
  8031ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031f2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8031f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031fa:	a3 48 41 80 00       	mov    %eax,0x804148
  8031ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803202:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803209:	a1 54 41 80 00       	mov    0x804154,%eax
  80320e:	40                   	inc    %eax
  80320f:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  803214:	eb 38                	jmp    80324e <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803216:	a1 40 41 80 00       	mov    0x804140,%eax
  80321b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80321e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803222:	74 07                	je     80322b <insert_sorted_with_merge_freeList+0x7b2>
  803224:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803227:	8b 00                	mov    (%eax),%eax
  803229:	eb 05                	jmp    803230 <insert_sorted_with_merge_freeList+0x7b7>
  80322b:	b8 00 00 00 00       	mov    $0x0,%eax
  803230:	a3 40 41 80 00       	mov    %eax,0x804140
  803235:	a1 40 41 80 00       	mov    0x804140,%eax
  80323a:	85 c0                	test   %eax,%eax
  80323c:	0f 85 ef f9 ff ff    	jne    802c31 <insert_sorted_with_merge_freeList+0x1b8>
  803242:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803246:	0f 85 e5 f9 ff ff    	jne    802c31 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80324c:	eb 00                	jmp    80324e <insert_sorted_with_merge_freeList+0x7d5>
  80324e:	90                   	nop
  80324f:	c9                   	leave  
  803250:	c3                   	ret    
  803251:	66 90                	xchg   %ax,%ax
  803253:	90                   	nop

00803254 <__udivdi3>:
  803254:	55                   	push   %ebp
  803255:	57                   	push   %edi
  803256:	56                   	push   %esi
  803257:	53                   	push   %ebx
  803258:	83 ec 1c             	sub    $0x1c,%esp
  80325b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80325f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803263:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803267:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80326b:	89 ca                	mov    %ecx,%edx
  80326d:	89 f8                	mov    %edi,%eax
  80326f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803273:	85 f6                	test   %esi,%esi
  803275:	75 2d                	jne    8032a4 <__udivdi3+0x50>
  803277:	39 cf                	cmp    %ecx,%edi
  803279:	77 65                	ja     8032e0 <__udivdi3+0x8c>
  80327b:	89 fd                	mov    %edi,%ebp
  80327d:	85 ff                	test   %edi,%edi
  80327f:	75 0b                	jne    80328c <__udivdi3+0x38>
  803281:	b8 01 00 00 00       	mov    $0x1,%eax
  803286:	31 d2                	xor    %edx,%edx
  803288:	f7 f7                	div    %edi
  80328a:	89 c5                	mov    %eax,%ebp
  80328c:	31 d2                	xor    %edx,%edx
  80328e:	89 c8                	mov    %ecx,%eax
  803290:	f7 f5                	div    %ebp
  803292:	89 c1                	mov    %eax,%ecx
  803294:	89 d8                	mov    %ebx,%eax
  803296:	f7 f5                	div    %ebp
  803298:	89 cf                	mov    %ecx,%edi
  80329a:	89 fa                	mov    %edi,%edx
  80329c:	83 c4 1c             	add    $0x1c,%esp
  80329f:	5b                   	pop    %ebx
  8032a0:	5e                   	pop    %esi
  8032a1:	5f                   	pop    %edi
  8032a2:	5d                   	pop    %ebp
  8032a3:	c3                   	ret    
  8032a4:	39 ce                	cmp    %ecx,%esi
  8032a6:	77 28                	ja     8032d0 <__udivdi3+0x7c>
  8032a8:	0f bd fe             	bsr    %esi,%edi
  8032ab:	83 f7 1f             	xor    $0x1f,%edi
  8032ae:	75 40                	jne    8032f0 <__udivdi3+0x9c>
  8032b0:	39 ce                	cmp    %ecx,%esi
  8032b2:	72 0a                	jb     8032be <__udivdi3+0x6a>
  8032b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032b8:	0f 87 9e 00 00 00    	ja     80335c <__udivdi3+0x108>
  8032be:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c3:	89 fa                	mov    %edi,%edx
  8032c5:	83 c4 1c             	add    $0x1c,%esp
  8032c8:	5b                   	pop    %ebx
  8032c9:	5e                   	pop    %esi
  8032ca:	5f                   	pop    %edi
  8032cb:	5d                   	pop    %ebp
  8032cc:	c3                   	ret    
  8032cd:	8d 76 00             	lea    0x0(%esi),%esi
  8032d0:	31 ff                	xor    %edi,%edi
  8032d2:	31 c0                	xor    %eax,%eax
  8032d4:	89 fa                	mov    %edi,%edx
  8032d6:	83 c4 1c             	add    $0x1c,%esp
  8032d9:	5b                   	pop    %ebx
  8032da:	5e                   	pop    %esi
  8032db:	5f                   	pop    %edi
  8032dc:	5d                   	pop    %ebp
  8032dd:	c3                   	ret    
  8032de:	66 90                	xchg   %ax,%ax
  8032e0:	89 d8                	mov    %ebx,%eax
  8032e2:	f7 f7                	div    %edi
  8032e4:	31 ff                	xor    %edi,%edi
  8032e6:	89 fa                	mov    %edi,%edx
  8032e8:	83 c4 1c             	add    $0x1c,%esp
  8032eb:	5b                   	pop    %ebx
  8032ec:	5e                   	pop    %esi
  8032ed:	5f                   	pop    %edi
  8032ee:	5d                   	pop    %ebp
  8032ef:	c3                   	ret    
  8032f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8032f5:	89 eb                	mov    %ebp,%ebx
  8032f7:	29 fb                	sub    %edi,%ebx
  8032f9:	89 f9                	mov    %edi,%ecx
  8032fb:	d3 e6                	shl    %cl,%esi
  8032fd:	89 c5                	mov    %eax,%ebp
  8032ff:	88 d9                	mov    %bl,%cl
  803301:	d3 ed                	shr    %cl,%ebp
  803303:	89 e9                	mov    %ebp,%ecx
  803305:	09 f1                	or     %esi,%ecx
  803307:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80330b:	89 f9                	mov    %edi,%ecx
  80330d:	d3 e0                	shl    %cl,%eax
  80330f:	89 c5                	mov    %eax,%ebp
  803311:	89 d6                	mov    %edx,%esi
  803313:	88 d9                	mov    %bl,%cl
  803315:	d3 ee                	shr    %cl,%esi
  803317:	89 f9                	mov    %edi,%ecx
  803319:	d3 e2                	shl    %cl,%edx
  80331b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80331f:	88 d9                	mov    %bl,%cl
  803321:	d3 e8                	shr    %cl,%eax
  803323:	09 c2                	or     %eax,%edx
  803325:	89 d0                	mov    %edx,%eax
  803327:	89 f2                	mov    %esi,%edx
  803329:	f7 74 24 0c          	divl   0xc(%esp)
  80332d:	89 d6                	mov    %edx,%esi
  80332f:	89 c3                	mov    %eax,%ebx
  803331:	f7 e5                	mul    %ebp
  803333:	39 d6                	cmp    %edx,%esi
  803335:	72 19                	jb     803350 <__udivdi3+0xfc>
  803337:	74 0b                	je     803344 <__udivdi3+0xf0>
  803339:	89 d8                	mov    %ebx,%eax
  80333b:	31 ff                	xor    %edi,%edi
  80333d:	e9 58 ff ff ff       	jmp    80329a <__udivdi3+0x46>
  803342:	66 90                	xchg   %ax,%ax
  803344:	8b 54 24 08          	mov    0x8(%esp),%edx
  803348:	89 f9                	mov    %edi,%ecx
  80334a:	d3 e2                	shl    %cl,%edx
  80334c:	39 c2                	cmp    %eax,%edx
  80334e:	73 e9                	jae    803339 <__udivdi3+0xe5>
  803350:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803353:	31 ff                	xor    %edi,%edi
  803355:	e9 40 ff ff ff       	jmp    80329a <__udivdi3+0x46>
  80335a:	66 90                	xchg   %ax,%ax
  80335c:	31 c0                	xor    %eax,%eax
  80335e:	e9 37 ff ff ff       	jmp    80329a <__udivdi3+0x46>
  803363:	90                   	nop

00803364 <__umoddi3>:
  803364:	55                   	push   %ebp
  803365:	57                   	push   %edi
  803366:	56                   	push   %esi
  803367:	53                   	push   %ebx
  803368:	83 ec 1c             	sub    $0x1c,%esp
  80336b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80336f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803373:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803377:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80337b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80337f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803383:	89 f3                	mov    %esi,%ebx
  803385:	89 fa                	mov    %edi,%edx
  803387:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80338b:	89 34 24             	mov    %esi,(%esp)
  80338e:	85 c0                	test   %eax,%eax
  803390:	75 1a                	jne    8033ac <__umoddi3+0x48>
  803392:	39 f7                	cmp    %esi,%edi
  803394:	0f 86 a2 00 00 00    	jbe    80343c <__umoddi3+0xd8>
  80339a:	89 c8                	mov    %ecx,%eax
  80339c:	89 f2                	mov    %esi,%edx
  80339e:	f7 f7                	div    %edi
  8033a0:	89 d0                	mov    %edx,%eax
  8033a2:	31 d2                	xor    %edx,%edx
  8033a4:	83 c4 1c             	add    $0x1c,%esp
  8033a7:	5b                   	pop    %ebx
  8033a8:	5e                   	pop    %esi
  8033a9:	5f                   	pop    %edi
  8033aa:	5d                   	pop    %ebp
  8033ab:	c3                   	ret    
  8033ac:	39 f0                	cmp    %esi,%eax
  8033ae:	0f 87 ac 00 00 00    	ja     803460 <__umoddi3+0xfc>
  8033b4:	0f bd e8             	bsr    %eax,%ebp
  8033b7:	83 f5 1f             	xor    $0x1f,%ebp
  8033ba:	0f 84 ac 00 00 00    	je     80346c <__umoddi3+0x108>
  8033c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8033c5:	29 ef                	sub    %ebp,%edi
  8033c7:	89 fe                	mov    %edi,%esi
  8033c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8033cd:	89 e9                	mov    %ebp,%ecx
  8033cf:	d3 e0                	shl    %cl,%eax
  8033d1:	89 d7                	mov    %edx,%edi
  8033d3:	89 f1                	mov    %esi,%ecx
  8033d5:	d3 ef                	shr    %cl,%edi
  8033d7:	09 c7                	or     %eax,%edi
  8033d9:	89 e9                	mov    %ebp,%ecx
  8033db:	d3 e2                	shl    %cl,%edx
  8033dd:	89 14 24             	mov    %edx,(%esp)
  8033e0:	89 d8                	mov    %ebx,%eax
  8033e2:	d3 e0                	shl    %cl,%eax
  8033e4:	89 c2                	mov    %eax,%edx
  8033e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033ea:	d3 e0                	shl    %cl,%eax
  8033ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8033f4:	89 f1                	mov    %esi,%ecx
  8033f6:	d3 e8                	shr    %cl,%eax
  8033f8:	09 d0                	or     %edx,%eax
  8033fa:	d3 eb                	shr    %cl,%ebx
  8033fc:	89 da                	mov    %ebx,%edx
  8033fe:	f7 f7                	div    %edi
  803400:	89 d3                	mov    %edx,%ebx
  803402:	f7 24 24             	mull   (%esp)
  803405:	89 c6                	mov    %eax,%esi
  803407:	89 d1                	mov    %edx,%ecx
  803409:	39 d3                	cmp    %edx,%ebx
  80340b:	0f 82 87 00 00 00    	jb     803498 <__umoddi3+0x134>
  803411:	0f 84 91 00 00 00    	je     8034a8 <__umoddi3+0x144>
  803417:	8b 54 24 04          	mov    0x4(%esp),%edx
  80341b:	29 f2                	sub    %esi,%edx
  80341d:	19 cb                	sbb    %ecx,%ebx
  80341f:	89 d8                	mov    %ebx,%eax
  803421:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803425:	d3 e0                	shl    %cl,%eax
  803427:	89 e9                	mov    %ebp,%ecx
  803429:	d3 ea                	shr    %cl,%edx
  80342b:	09 d0                	or     %edx,%eax
  80342d:	89 e9                	mov    %ebp,%ecx
  80342f:	d3 eb                	shr    %cl,%ebx
  803431:	89 da                	mov    %ebx,%edx
  803433:	83 c4 1c             	add    $0x1c,%esp
  803436:	5b                   	pop    %ebx
  803437:	5e                   	pop    %esi
  803438:	5f                   	pop    %edi
  803439:	5d                   	pop    %ebp
  80343a:	c3                   	ret    
  80343b:	90                   	nop
  80343c:	89 fd                	mov    %edi,%ebp
  80343e:	85 ff                	test   %edi,%edi
  803440:	75 0b                	jne    80344d <__umoddi3+0xe9>
  803442:	b8 01 00 00 00       	mov    $0x1,%eax
  803447:	31 d2                	xor    %edx,%edx
  803449:	f7 f7                	div    %edi
  80344b:	89 c5                	mov    %eax,%ebp
  80344d:	89 f0                	mov    %esi,%eax
  80344f:	31 d2                	xor    %edx,%edx
  803451:	f7 f5                	div    %ebp
  803453:	89 c8                	mov    %ecx,%eax
  803455:	f7 f5                	div    %ebp
  803457:	89 d0                	mov    %edx,%eax
  803459:	e9 44 ff ff ff       	jmp    8033a2 <__umoddi3+0x3e>
  80345e:	66 90                	xchg   %ax,%ax
  803460:	89 c8                	mov    %ecx,%eax
  803462:	89 f2                	mov    %esi,%edx
  803464:	83 c4 1c             	add    $0x1c,%esp
  803467:	5b                   	pop    %ebx
  803468:	5e                   	pop    %esi
  803469:	5f                   	pop    %edi
  80346a:	5d                   	pop    %ebp
  80346b:	c3                   	ret    
  80346c:	3b 04 24             	cmp    (%esp),%eax
  80346f:	72 06                	jb     803477 <__umoddi3+0x113>
  803471:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803475:	77 0f                	ja     803486 <__umoddi3+0x122>
  803477:	89 f2                	mov    %esi,%edx
  803479:	29 f9                	sub    %edi,%ecx
  80347b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80347f:	89 14 24             	mov    %edx,(%esp)
  803482:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803486:	8b 44 24 04          	mov    0x4(%esp),%eax
  80348a:	8b 14 24             	mov    (%esp),%edx
  80348d:	83 c4 1c             	add    $0x1c,%esp
  803490:	5b                   	pop    %ebx
  803491:	5e                   	pop    %esi
  803492:	5f                   	pop    %edi
  803493:	5d                   	pop    %ebp
  803494:	c3                   	ret    
  803495:	8d 76 00             	lea    0x0(%esi),%esi
  803498:	2b 04 24             	sub    (%esp),%eax
  80349b:	19 fa                	sbb    %edi,%edx
  80349d:	89 d1                	mov    %edx,%ecx
  80349f:	89 c6                	mov    %eax,%esi
  8034a1:	e9 71 ff ff ff       	jmp    803417 <__umoddi3+0xb3>
  8034a6:	66 90                	xchg   %ax,%ax
  8034a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034ac:	72 ea                	jb     803498 <__umoddi3+0x134>
  8034ae:	89 d9                	mov    %ebx,%ecx
  8034b0:	e9 62 ff ff ff       	jmp    803417 <__umoddi3+0xb3>
