
obj/user/ef_tst_sharing_1:     file format elf32-i386


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
  800031:	e8 64 03 00 00       	call   80039a <libmain>
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
  80003c:	83 ec 34             	sub    $0x34,%esp
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
  80008d:	68 00 35 80 00       	push   $0x803500
  800092:	6a 12                	push   $0x12
  800094:	68 1c 35 80 00       	push   $0x80351c
  800099:	e8 38 04 00 00       	call   8004d6 <_panic>
	}

	uint32 *x, *y, *z ;
	cprintf("STEP A: checking the creation of shared variables... \n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 34 35 80 00       	push   $0x803534
  8000a6:	e8 df 06 00 00       	call   80078a <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ae:	e8 14 1b 00 00       	call   801bc7 <sys_calculate_free_frames>
  8000b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000b6:	83 ec 04             	sub    $0x4,%esp
  8000b9:	6a 01                	push   $0x1
  8000bb:	68 00 10 00 00       	push   $0x1000
  8000c0:	68 6b 35 80 00       	push   $0x80356b
  8000c5:	e8 da 17 00 00       	call   8018a4 <smalloc>
  8000ca:	83 c4 10             	add    $0x10,%esp
  8000cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8000d0:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d7:	74 14                	je     8000ed <_main+0xb5>
  8000d9:	83 ec 04             	sub    $0x4,%esp
  8000dc:	68 70 35 80 00       	push   $0x803570
  8000e1:	6a 1a                	push   $0x1a
  8000e3:	68 1c 35 80 00       	push   $0x80351c
  8000e8:	e8 e9 03 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  8000ed:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f0:	e8 d2 1a 00 00       	call   801bc7 <sys_calculate_free_frames>
  8000f5:	29 c3                	sub    %eax,%ebx
  8000f7:	89 d8                	mov    %ebx,%eax
  8000f9:	83 f8 04             	cmp    $0x4,%eax
  8000fc:	74 28                	je     800126 <_main+0xee>
  8000fe:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800101:	e8 c1 1a 00 00       	call   801bc7 <sys_calculate_free_frames>
  800106:	29 c3                	sub    %eax,%ebx
  800108:	e8 ba 1a 00 00       	call   801bc7 <sys_calculate_free_frames>
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	53                   	push   %ebx
  800111:	50                   	push   %eax
  800112:	ff 75 e8             	pushl  -0x18(%ebp)
  800115:	68 dc 35 80 00       	push   $0x8035dc
  80011a:	6a 1b                	push   $0x1b
  80011c:	68 1c 35 80 00       	push   $0x80351c
  800121:	e8 b0 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800126:	e8 9c 1a 00 00       	call   801bc7 <sys_calculate_free_frames>
  80012b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		z = smalloc("y", PAGE_SIZE + 4, 1);
  80012e:	83 ec 04             	sub    $0x4,%esp
  800131:	6a 01                	push   $0x1
  800133:	68 04 10 00 00       	push   $0x1004
  800138:	68 63 36 80 00       	push   $0x803663
  80013d:	e8 62 17 00 00       	call   8018a4 <smalloc>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	89 45 e0             	mov    %eax,-0x20(%ebp)
		if (z != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800148:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 70 35 80 00       	push   $0x803570
  800159:	6a 1f                	push   $0x1f
  80015b:	68 1c 35 80 00       	push   $0x80351c
  800160:	e8 71 03 00 00       	call   8004d6 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage %d %d %d", freeFrames, sys_calculate_free_frames(), freeFrames - sys_calculate_free_frames());
  800165:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800168:	e8 5a 1a 00 00       	call   801bc7 <sys_calculate_free_frames>
  80016d:	29 c3                	sub    %eax,%ebx
  80016f:	89 d8                	mov    %ebx,%eax
  800171:	83 f8 04             	cmp    $0x4,%eax
  800174:	74 28                	je     80019e <_main+0x166>
  800176:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800179:	e8 49 1a 00 00       	call   801bc7 <sys_calculate_free_frames>
  80017e:	29 c3                	sub    %eax,%ebx
  800180:	e8 42 1a 00 00       	call   801bc7 <sys_calculate_free_frames>
  800185:	83 ec 08             	sub    $0x8,%esp
  800188:	53                   	push   %ebx
  800189:	50                   	push   %eax
  80018a:	ff 75 e8             	pushl  -0x18(%ebp)
  80018d:	68 dc 35 80 00       	push   $0x8035dc
  800192:	6a 21                	push   $0x21
  800194:	68 1c 35 80 00       	push   $0x80351c
  800199:	e8 38 03 00 00       	call   8004d6 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80019e:	e8 24 1a 00 00       	call   801bc7 <sys_calculate_free_frames>
  8001a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		y = smalloc("z", 4, 1);
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	6a 01                	push   $0x1
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 65 36 80 00       	push   $0x803665
  8001b2:	e8 ed 16 00 00       	call   8018a4 <smalloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (y != (uint32*)(USER_HEAP_START + 3 * PAGE_SIZE)) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  8001bd:	81 7d dc 00 30 00 80 	cmpl   $0x80003000,-0x24(%ebp)
  8001c4:	74 14                	je     8001da <_main+0x1a2>
  8001c6:	83 ec 04             	sub    $0x4,%esp
  8001c9:	68 70 35 80 00       	push   $0x803570
  8001ce:	6a 25                	push   $0x25
  8001d0:	68 1c 35 80 00       	push   $0x80351c
  8001d5:	e8 fc 02 00 00       	call   8004d6 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+0+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001da:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8001dd:	e8 e5 19 00 00       	call   801bc7 <sys_calculate_free_frames>
  8001e2:	29 c3                	sub    %eax,%ebx
  8001e4:	89 d8                	mov    %ebx,%eax
  8001e6:	83 f8 03             	cmp    $0x3,%eax
  8001e9:	74 14                	je     8001ff <_main+0x1c7>
  8001eb:	83 ec 04             	sub    $0x4,%esp
  8001ee:	68 68 36 80 00       	push   $0x803668
  8001f3:	6a 26                	push   $0x26
  8001f5:	68 1c 35 80 00       	push   $0x80351c
  8001fa:	e8 d7 02 00 00       	call   8004d6 <_panic>
	}
	cprintf("Step A is completed successfully!!\n\n\n");
  8001ff:	83 ec 0c             	sub    $0xc,%esp
  800202:	68 e8 36 80 00       	push   $0x8036e8
  800207:	e8 7e 05 00 00       	call   80078a <cprintf>
  80020c:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking reading & writing... \n");
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	68 10 37 80 00       	push   $0x803710
  800217:	e8 6e 05 00 00       	call   80078a <cprintf>
  80021c:	83 c4 10             	add    $0x10,%esp
	{
		int i=0;
  80021f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<PAGE_SIZE/4;i++)
  800226:	eb 2d                	jmp    800255 <_main+0x21d>
		{
			x[i] = -1;
  800228:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80022b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800232:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800235:	01 d0                	add    %edx,%eax
  800237:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			y[i] = -1;
  80023d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800240:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800247:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80024a:	01 d0                	add    %edx,%eax
  80024c:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)


	cprintf("STEP B: checking reading & writing... \n");
	{
		int i=0;
		for(;i<PAGE_SIZE/4;i++)
  800252:	ff 45 ec             	incl   -0x14(%ebp)
  800255:	81 7d ec ff 03 00 00 	cmpl   $0x3ff,-0x14(%ebp)
  80025c:	7e ca                	jle    800228 <_main+0x1f0>
		{
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
  80025e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for(;i<2*PAGE_SIZE/4;i++)
  800265:	eb 18                	jmp    80027f <_main+0x247>
		{
			z[i] = -1;
  800267:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800271:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800274:	01 d0                	add    %edx,%eax
  800276:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
			x[i] = -1;
			y[i] = -1;
		}

		i=0;
		for(;i<2*PAGE_SIZE/4;i++)
  80027c:	ff 45 ec             	incl   -0x14(%ebp)
  80027f:	81 7d ec ff 07 00 00 	cmpl   $0x7ff,-0x14(%ebp)
  800286:	7e df                	jle    800267 <_main+0x22f>
		{
			z[i] = -1;
		}

		if( x[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  800288:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80028b:	8b 00                	mov    (%eax),%eax
  80028d:	83 f8 ff             	cmp    $0xffffffff,%eax
  800290:	74 14                	je     8002a6 <_main+0x26e>
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	68 38 37 80 00       	push   $0x803738
  80029a:	6a 3a                	push   $0x3a
  80029c:	68 1c 35 80 00       	push   $0x80351c
  8002a1:	e8 30 02 00 00       	call   8004d6 <_panic>
		if( x[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a9:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ae:	8b 00                	mov    (%eax),%eax
  8002b0:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002b3:	74 14                	je     8002c9 <_main+0x291>
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	68 38 37 80 00       	push   $0x803738
  8002bd:	6a 3b                	push   $0x3b
  8002bf:	68 1c 35 80 00       	push   $0x80351c
  8002c4:	e8 0d 02 00 00       	call   8004d6 <_panic>

		if( y[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  8002c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002cc:	8b 00                	mov    (%eax),%eax
  8002ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002d1:	74 14                	je     8002e7 <_main+0x2af>
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	68 38 37 80 00       	push   $0x803738
  8002db:	6a 3d                	push   $0x3d
  8002dd:	68 1c 35 80 00       	push   $0x80351c
  8002e2:	e8 ef 01 00 00       	call   8004d6 <_panic>
		if( y[PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  8002e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ea:	05 fc 0f 00 00       	add    $0xffc,%eax
  8002ef:	8b 00                	mov    (%eax),%eax
  8002f1:	83 f8 ff             	cmp    $0xffffffff,%eax
  8002f4:	74 14                	je     80030a <_main+0x2d2>
  8002f6:	83 ec 04             	sub    $0x4,%esp
  8002f9:	68 38 37 80 00       	push   $0x803738
  8002fe:	6a 3e                	push   $0x3e
  800300:	68 1c 35 80 00       	push   $0x80351c
  800305:	e8 cc 01 00 00       	call   8004d6 <_panic>

		if( z[0] !=  -1)  					panic("Reading/Writing of shared object is failed");
  80030a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80030d:	8b 00                	mov    (%eax),%eax
  80030f:	83 f8 ff             	cmp    $0xffffffff,%eax
  800312:	74 14                	je     800328 <_main+0x2f0>
  800314:	83 ec 04             	sub    $0x4,%esp
  800317:	68 38 37 80 00       	push   $0x803738
  80031c:	6a 40                	push   $0x40
  80031e:	68 1c 35 80 00       	push   $0x80351c
  800323:	e8 ae 01 00 00       	call   8004d6 <_panic>
		if( z[2*PAGE_SIZE/4 - 1] !=  -1)  	panic("Reading/Writing of shared object is failed");
  800328:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80032b:	05 fc 1f 00 00       	add    $0x1ffc,%eax
  800330:	8b 00                	mov    (%eax),%eax
  800332:	83 f8 ff             	cmp    $0xffffffff,%eax
  800335:	74 14                	je     80034b <_main+0x313>
  800337:	83 ec 04             	sub    $0x4,%esp
  80033a:	68 38 37 80 00       	push   $0x803738
  80033f:	6a 41                	push   $0x41
  800341:	68 1c 35 80 00       	push   $0x80351c
  800346:	e8 8b 01 00 00       	call   8004d6 <_panic>
	}

	cprintf("Congratulations!! Test of Shared Variables [Create] [1] completed successfully!!\n\n\n");
  80034b:	83 ec 0c             	sub    $0xc,%esp
  80034e:	68 64 37 80 00       	push   $0x803764
  800353:	e8 32 04 00 00       	call   80078a <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  80035b:	e8 60 1b 00 00       	call   801ec0 <sys_getparentenvid>
  800360:	89 45 d8             	mov    %eax,-0x28(%ebp)
	if(parentenvID > 0)
  800363:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800367:	7e 2b                	jle    800394 <_main+0x35c>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800369:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	68 b8 37 80 00       	push   $0x8037b8
  800378:	ff 75 d8             	pushl  -0x28(%ebp)
  80037b:	e8 f9 15 00 00       	call   801979 <sget>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		(*finishedCount)++ ;
  800386:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800389:	8b 00                	mov    (%eax),%eax
  80038b:	8d 50 01             	lea    0x1(%eax),%edx
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 10                	mov    %edx,(%eax)
	}

	return;
  800393:	90                   	nop
  800394:	90                   	nop
}
  800395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800398:	c9                   	leave  
  800399:	c3                   	ret    

0080039a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039a:	55                   	push   %ebp
  80039b:	89 e5                	mov    %esp,%ebp
  80039d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003a0:	e8 02 1b 00 00       	call   801ea7 <sys_getenvindex>
  8003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003ab:	89 d0                	mov    %edx,%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 d0                	add    %edx,%eax
  8003b2:	01 c0                	add    %eax,%eax
  8003b4:	01 d0                	add    %edx,%eax
  8003b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003bd:	01 d0                	add    %edx,%eax
  8003bf:	c1 e0 04             	shl    $0x4,%eax
  8003c2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003d7:	84 c0                	test   %al,%al
  8003d9:	74 0f                	je     8003ea <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003db:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e0:	05 5c 05 00 00       	add    $0x55c,%eax
  8003e5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003ee:	7e 0a                	jle    8003fa <libmain+0x60>
		binaryname = argv[0];
  8003f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f3:	8b 00                	mov    (%eax),%eax
  8003f5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	ff 75 0c             	pushl  0xc(%ebp)
  800400:	ff 75 08             	pushl  0x8(%ebp)
  800403:	e8 30 fc ff ff       	call   800038 <_main>
  800408:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80040b:	e8 a4 18 00 00       	call   801cb4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800410:	83 ec 0c             	sub    $0xc,%esp
  800413:	68 e0 37 80 00       	push   $0x8037e0
  800418:	e8 6d 03 00 00       	call   80078a <cprintf>
  80041d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800420:	a1 20 40 80 00       	mov    0x804020,%eax
  800425:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80042b:	a1 20 40 80 00       	mov    0x804020,%eax
  800430:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800436:	83 ec 04             	sub    $0x4,%esp
  800439:	52                   	push   %edx
  80043a:	50                   	push   %eax
  80043b:	68 08 38 80 00       	push   $0x803808
  800440:	e8 45 03 00 00       	call   80078a <cprintf>
  800445:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800448:	a1 20 40 80 00       	mov    0x804020,%eax
  80044d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800453:	a1 20 40 80 00       	mov    0x804020,%eax
  800458:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80045e:	a1 20 40 80 00       	mov    0x804020,%eax
  800463:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800469:	51                   	push   %ecx
  80046a:	52                   	push   %edx
  80046b:	50                   	push   %eax
  80046c:	68 30 38 80 00       	push   $0x803830
  800471:	e8 14 03 00 00       	call   80078a <cprintf>
  800476:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800484:	83 ec 08             	sub    $0x8,%esp
  800487:	50                   	push   %eax
  800488:	68 88 38 80 00       	push   $0x803888
  80048d:	e8 f8 02 00 00       	call   80078a <cprintf>
  800492:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	68 e0 37 80 00       	push   $0x8037e0
  80049d:	e8 e8 02 00 00       	call   80078a <cprintf>
  8004a2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004a5:	e8 24 18 00 00       	call   801cce <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004aa:	e8 19 00 00 00       	call   8004c8 <exit>
}
  8004af:	90                   	nop
  8004b0:	c9                   	leave  
  8004b1:	c3                   	ret    

008004b2 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004b2:	55                   	push   %ebp
  8004b3:	89 e5                	mov    %esp,%ebp
  8004b5:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004b8:	83 ec 0c             	sub    $0xc,%esp
  8004bb:	6a 00                	push   $0x0
  8004bd:	e8 b1 19 00 00       	call   801e73 <sys_destroy_env>
  8004c2:	83 c4 10             	add    $0x10,%esp
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <exit>:

void
exit(void)
{
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ce:	e8 06 1a 00 00       	call   801ed9 <sys_exit_env>
}
  8004d3:	90                   	nop
  8004d4:	c9                   	leave  
  8004d5:	c3                   	ret    

008004d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
  8004d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004dc:	8d 45 10             	lea    0x10(%ebp),%eax
  8004df:	83 c0 04             	add    $0x4,%eax
  8004e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004e5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004ea:	85 c0                	test   %eax,%eax
  8004ec:	74 16                	je     800504 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004ee:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	50                   	push   %eax
  8004f7:	68 9c 38 80 00       	push   $0x80389c
  8004fc:	e8 89 02 00 00       	call   80078a <cprintf>
  800501:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800504:	a1 00 40 80 00       	mov    0x804000,%eax
  800509:	ff 75 0c             	pushl  0xc(%ebp)
  80050c:	ff 75 08             	pushl  0x8(%ebp)
  80050f:	50                   	push   %eax
  800510:	68 a1 38 80 00       	push   $0x8038a1
  800515:	e8 70 02 00 00       	call   80078a <cprintf>
  80051a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80051d:	8b 45 10             	mov    0x10(%ebp),%eax
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	ff 75 f4             	pushl  -0xc(%ebp)
  800526:	50                   	push   %eax
  800527:	e8 f3 01 00 00       	call   80071f <vcprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80052f:	83 ec 08             	sub    $0x8,%esp
  800532:	6a 00                	push   $0x0
  800534:	68 bd 38 80 00       	push   $0x8038bd
  800539:	e8 e1 01 00 00       	call   80071f <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800541:	e8 82 ff ff ff       	call   8004c8 <exit>

	// should not return here
	while (1) ;
  800546:	eb fe                	jmp    800546 <_panic+0x70>

00800548 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800548:	55                   	push   %ebp
  800549:	89 e5                	mov    %esp,%ebp
  80054b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80054e:	a1 20 40 80 00       	mov    0x804020,%eax
  800553:	8b 50 74             	mov    0x74(%eax),%edx
  800556:	8b 45 0c             	mov    0xc(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 c0 38 80 00       	push   $0x8038c0
  800565:	6a 26                	push   $0x26
  800567:	68 0c 39 80 00       	push   $0x80390c
  80056c:	e8 65 ff ff ff       	call   8004d6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800571:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800578:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80057f:	e9 c2 00 00 00       	jmp    800646 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800584:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	8b 45 08             	mov    0x8(%ebp),%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8b 00                	mov    (%eax),%eax
  800595:	85 c0                	test   %eax,%eax
  800597:	75 08                	jne    8005a1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800599:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80059c:	e9 a2 00 00 00       	jmp    800643 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005af:	eb 69                	jmp    80061a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bf:	89 d0                	mov    %edx,%eax
  8005c1:	01 c0                	add    %eax,%eax
  8005c3:	01 d0                	add    %edx,%eax
  8005c5:	c1 e0 03             	shl    $0x3,%eax
  8005c8:	01 c8                	add    %ecx,%eax
  8005ca:	8a 40 04             	mov    0x4(%eax),%al
  8005cd:	84 c0                	test   %al,%al
  8005cf:	75 46                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005d1:	a1 20 40 80 00       	mov    0x804020,%eax
  8005d6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005dc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005df:	89 d0                	mov    %edx,%eax
  8005e1:	01 c0                	add    %eax,%eax
  8005e3:	01 d0                	add    %edx,%eax
  8005e5:	c1 e0 03             	shl    $0x3,%eax
  8005e8:	01 c8                	add    %ecx,%eax
  8005ea:	8b 00                	mov    (%eax),%eax
  8005ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005f7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	01 c8                	add    %ecx,%eax
  800608:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80060a:	39 c2                	cmp    %eax,%edx
  80060c:	75 09                	jne    800617 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80060e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800615:	eb 12                	jmp    800629 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800617:	ff 45 e8             	incl   -0x18(%ebp)
  80061a:	a1 20 40 80 00       	mov    0x804020,%eax
  80061f:	8b 50 74             	mov    0x74(%eax),%edx
  800622:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800625:	39 c2                	cmp    %eax,%edx
  800627:	77 88                	ja     8005b1 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800629:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80062d:	75 14                	jne    800643 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	68 18 39 80 00       	push   $0x803918
  800637:	6a 3a                	push   $0x3a
  800639:	68 0c 39 80 00       	push   $0x80390c
  80063e:	e8 93 fe ff ff       	call   8004d6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800643:	ff 45 f0             	incl   -0x10(%ebp)
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800649:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80064c:	0f 8c 32 ff ff ff    	jl     800584 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800652:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800659:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800660:	eb 26                	jmp    800688 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800662:	a1 20 40 80 00       	mov    0x804020,%eax
  800667:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80066d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	01 c0                	add    %eax,%eax
  800674:	01 d0                	add    %edx,%eax
  800676:	c1 e0 03             	shl    $0x3,%eax
  800679:	01 c8                	add    %ecx,%eax
  80067b:	8a 40 04             	mov    0x4(%eax),%al
  80067e:	3c 01                	cmp    $0x1,%al
  800680:	75 03                	jne    800685 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800682:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800685:	ff 45 e0             	incl   -0x20(%ebp)
  800688:	a1 20 40 80 00       	mov    0x804020,%eax
  80068d:	8b 50 74             	mov    0x74(%eax),%edx
  800690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800693:	39 c2                	cmp    %eax,%edx
  800695:	77 cb                	ja     800662 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80069a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80069d:	74 14                	je     8006b3 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80069f:	83 ec 04             	sub    $0x4,%esp
  8006a2:	68 6c 39 80 00       	push   $0x80396c
  8006a7:	6a 44                	push   $0x44
  8006a9:	68 0c 39 80 00       	push   $0x80390c
  8006ae:	e8 23 fe ff ff       	call   8004d6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006b3:	90                   	nop
  8006b4:	c9                   	leave  
  8006b5:	c3                   	ret    

008006b6 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006b6:	55                   	push   %ebp
  8006b7:	89 e5                	mov    %esp,%ebp
  8006b9:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	8d 48 01             	lea    0x1(%eax),%ecx
  8006c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c7:	89 0a                	mov    %ecx,(%edx)
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	88 d1                	mov    %dl,%cl
  8006ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006df:	75 2c                	jne    80070d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006e1:	a0 24 40 80 00       	mov    0x804024,%al
  8006e6:	0f b6 c0             	movzbl %al,%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ec:	8b 12                	mov    (%edx),%edx
  8006ee:	89 d1                	mov    %edx,%ecx
  8006f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006f3:	83 c2 08             	add    $0x8,%edx
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	50                   	push   %eax
  8006fa:	51                   	push   %ecx
  8006fb:	52                   	push   %edx
  8006fc:	e8 05 14 00 00       	call   801b06 <sys_cputs>
  800701:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80070d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800710:	8b 40 04             	mov    0x4(%eax),%eax
  800713:	8d 50 01             	lea    0x1(%eax),%edx
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	89 50 04             	mov    %edx,0x4(%eax)
}
  80071c:	90                   	nop
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800728:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80072f:	00 00 00 
	b.cnt = 0;
  800732:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800739:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80073c:	ff 75 0c             	pushl  0xc(%ebp)
  80073f:	ff 75 08             	pushl  0x8(%ebp)
  800742:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800748:	50                   	push   %eax
  800749:	68 b6 06 80 00       	push   $0x8006b6
  80074e:	e8 11 02 00 00       	call   800964 <vprintfmt>
  800753:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800756:	a0 24 40 80 00       	mov    0x804024,%al
  80075b:	0f b6 c0             	movzbl %al,%eax
  80075e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800764:	83 ec 04             	sub    $0x4,%esp
  800767:	50                   	push   %eax
  800768:	52                   	push   %edx
  800769:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80076f:	83 c0 08             	add    $0x8,%eax
  800772:	50                   	push   %eax
  800773:	e8 8e 13 00 00       	call   801b06 <sys_cputs>
  800778:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80077b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800782:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <cprintf>:

int cprintf(const char *fmt, ...) {
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800790:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800797:	8d 45 0c             	lea    0xc(%ebp),%eax
  80079a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	83 ec 08             	sub    $0x8,%esp
  8007a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8007a6:	50                   	push   %eax
  8007a7:	e8 73 ff ff ff       	call   80071f <vcprintf>
  8007ac:	83 c4 10             	add    $0x10,%esp
  8007af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007b5:	c9                   	leave  
  8007b6:	c3                   	ret    

008007b7 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007bd:	e8 f2 14 00 00       	call   801cb4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007c2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	83 ec 08             	sub    $0x8,%esp
  8007ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8007d1:	50                   	push   %eax
  8007d2:	e8 48 ff ff ff       	call   80071f <vcprintf>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007dd:	e8 ec 14 00 00       	call   801cce <sys_enable_interrupt>
	return cnt;
  8007e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007e5:	c9                   	leave  
  8007e6:	c3                   	ret    

008007e7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 14             	sub    $0x14,%esp
  8007ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8007f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007fa:	8b 45 18             	mov    0x18(%ebp),%eax
  8007fd:	ba 00 00 00 00       	mov    $0x0,%edx
  800802:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800805:	77 55                	ja     80085c <printnum+0x75>
  800807:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80080a:	72 05                	jb     800811 <printnum+0x2a>
  80080c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80080f:	77 4b                	ja     80085c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800811:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800814:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800817:	8b 45 18             	mov    0x18(%ebp),%eax
  80081a:	ba 00 00 00 00       	mov    $0x0,%edx
  80081f:	52                   	push   %edx
  800820:	50                   	push   %eax
  800821:	ff 75 f4             	pushl  -0xc(%ebp)
  800824:	ff 75 f0             	pushl  -0x10(%ebp)
  800827:	e8 64 2a 00 00       	call   803290 <__udivdi3>
  80082c:	83 c4 10             	add    $0x10,%esp
  80082f:	83 ec 04             	sub    $0x4,%esp
  800832:	ff 75 20             	pushl  0x20(%ebp)
  800835:	53                   	push   %ebx
  800836:	ff 75 18             	pushl  0x18(%ebp)
  800839:	52                   	push   %edx
  80083a:	50                   	push   %eax
  80083b:	ff 75 0c             	pushl  0xc(%ebp)
  80083e:	ff 75 08             	pushl  0x8(%ebp)
  800841:	e8 a1 ff ff ff       	call   8007e7 <printnum>
  800846:	83 c4 20             	add    $0x20,%esp
  800849:	eb 1a                	jmp    800865 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	ff 75 0c             	pushl  0xc(%ebp)
  800851:	ff 75 20             	pushl  0x20(%ebp)
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	ff d0                	call   *%eax
  800859:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80085c:	ff 4d 1c             	decl   0x1c(%ebp)
  80085f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800863:	7f e6                	jg     80084b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800865:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800868:	bb 00 00 00 00       	mov    $0x0,%ebx
  80086d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800870:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800873:	53                   	push   %ebx
  800874:	51                   	push   %ecx
  800875:	52                   	push   %edx
  800876:	50                   	push   %eax
  800877:	e8 24 2b 00 00       	call   8033a0 <__umoddi3>
  80087c:	83 c4 10             	add    $0x10,%esp
  80087f:	05 d4 3b 80 00       	add    $0x803bd4,%eax
  800884:	8a 00                	mov    (%eax),%al
  800886:	0f be c0             	movsbl %al,%eax
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	50                   	push   %eax
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
}
  800898:	90                   	nop
  800899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80089c:	c9                   	leave  
  80089d:	c3                   	ret    

0080089e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008a1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008a5:	7e 1c                	jle    8008c3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 00                	mov    (%eax),%eax
  8008ac:	8d 50 08             	lea    0x8(%eax),%edx
  8008af:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b2:	89 10                	mov    %edx,(%eax)
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 00                	mov    (%eax),%eax
  8008b9:	83 e8 08             	sub    $0x8,%eax
  8008bc:	8b 50 04             	mov    0x4(%eax),%edx
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	eb 40                	jmp    800903 <getuint+0x65>
	else if (lflag)
  8008c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008c7:	74 1e                	je     8008e7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	8b 00                	mov    (%eax),%eax
  8008ce:	8d 50 04             	lea    0x4(%eax),%edx
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	89 10                	mov    %edx,(%eax)
  8008d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	83 e8 04             	sub    $0x4,%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	eb 1c                	jmp    800903 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 00                	mov    (%eax),%eax
  8008ec:	8d 50 04             	lea    0x4(%eax),%edx
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 10                	mov    %edx,(%eax)
  8008f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f7:	8b 00                	mov    (%eax),%eax
  8008f9:	83 e8 04             	sub    $0x4,%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800903:	5d                   	pop    %ebp
  800904:	c3                   	ret    

00800905 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800905:	55                   	push   %ebp
  800906:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800908:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80090c:	7e 1c                	jle    80092a <getint+0x25>
		return va_arg(*ap, long long);
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	8b 00                	mov    (%eax),%eax
  800913:	8d 50 08             	lea    0x8(%eax),%edx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	89 10                	mov    %edx,(%eax)
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	83 e8 08             	sub    $0x8,%eax
  800923:	8b 50 04             	mov    0x4(%eax),%edx
  800926:	8b 00                	mov    (%eax),%eax
  800928:	eb 38                	jmp    800962 <getint+0x5d>
	else if (lflag)
  80092a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80092e:	74 1a                	je     80094a <getint+0x45>
		return va_arg(*ap, long);
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 00                	mov    (%eax),%eax
  800935:	8d 50 04             	lea    0x4(%eax),%edx
  800938:	8b 45 08             	mov    0x8(%ebp),%eax
  80093b:	89 10                	mov    %edx,(%eax)
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	83 e8 04             	sub    $0x4,%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	99                   	cltd   
  800948:	eb 18                	jmp    800962 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	8d 50 04             	lea    0x4(%eax),%edx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	89 10                	mov    %edx,(%eax)
  800957:	8b 45 08             	mov    0x8(%ebp),%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	83 e8 04             	sub    $0x4,%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	99                   	cltd   
}
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	56                   	push   %esi
  800968:	53                   	push   %ebx
  800969:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80096c:	eb 17                	jmp    800985 <vprintfmt+0x21>
			if (ch == '\0')
  80096e:	85 db                	test   %ebx,%ebx
  800970:	0f 84 af 03 00 00    	je     800d25 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800976:	83 ec 08             	sub    $0x8,%esp
  800979:	ff 75 0c             	pushl  0xc(%ebp)
  80097c:	53                   	push   %ebx
  80097d:	8b 45 08             	mov    0x8(%ebp),%eax
  800980:	ff d0                	call   *%eax
  800982:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800985:	8b 45 10             	mov    0x10(%ebp),%eax
  800988:	8d 50 01             	lea    0x1(%eax),%edx
  80098b:	89 55 10             	mov    %edx,0x10(%ebp)
  80098e:	8a 00                	mov    (%eax),%al
  800990:	0f b6 d8             	movzbl %al,%ebx
  800993:	83 fb 25             	cmp    $0x25,%ebx
  800996:	75 d6                	jne    80096e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800998:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80099c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009a3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009aa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009b1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8009bb:	8d 50 01             	lea    0x1(%eax),%edx
  8009be:	89 55 10             	mov    %edx,0x10(%ebp)
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f b6 d8             	movzbl %al,%ebx
  8009c6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009c9:	83 f8 55             	cmp    $0x55,%eax
  8009cc:	0f 87 2b 03 00 00    	ja     800cfd <vprintfmt+0x399>
  8009d2:	8b 04 85 f8 3b 80 00 	mov    0x803bf8(,%eax,4),%eax
  8009d9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009db:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009df:	eb d7                	jmp    8009b8 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009e1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009e5:	eb d1                	jmp    8009b8 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009e7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f1:	89 d0                	mov    %edx,%eax
  8009f3:	c1 e0 02             	shl    $0x2,%eax
  8009f6:	01 d0                	add    %edx,%eax
  8009f8:	01 c0                	add    %eax,%eax
  8009fa:	01 d8                	add    %ebx,%eax
  8009fc:	83 e8 30             	sub    $0x30,%eax
  8009ff:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a02:	8b 45 10             	mov    0x10(%ebp),%eax
  800a05:	8a 00                	mov    (%eax),%al
  800a07:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a0a:	83 fb 2f             	cmp    $0x2f,%ebx
  800a0d:	7e 3e                	jle    800a4d <vprintfmt+0xe9>
  800a0f:	83 fb 39             	cmp    $0x39,%ebx
  800a12:	7f 39                	jg     800a4d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a14:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a17:	eb d5                	jmp    8009ee <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	83 c0 04             	add    $0x4,%eax
  800a1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a22:	8b 45 14             	mov    0x14(%ebp),%eax
  800a25:	83 e8 04             	sub    $0x4,%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a2d:	eb 1f                	jmp    800a4e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a2f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a33:	79 83                	jns    8009b8 <vprintfmt+0x54>
				width = 0;
  800a35:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a3c:	e9 77 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a41:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a48:	e9 6b ff ff ff       	jmp    8009b8 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a4d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a4e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a52:	0f 89 60 ff ff ff    	jns    8009b8 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a5e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a65:	e9 4e ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a6a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a6d:	e9 46 ff ff ff       	jmp    8009b8 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a72:	8b 45 14             	mov    0x14(%ebp),%eax
  800a75:	83 c0 04             	add    $0x4,%eax
  800a78:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7e:	83 e8 04             	sub    $0x4,%eax
  800a81:	8b 00                	mov    (%eax),%eax
  800a83:	83 ec 08             	sub    $0x8,%esp
  800a86:	ff 75 0c             	pushl  0xc(%ebp)
  800a89:	50                   	push   %eax
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			break;
  800a92:	e9 89 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aa8:	85 db                	test   %ebx,%ebx
  800aaa:	79 02                	jns    800aae <vprintfmt+0x14a>
				err = -err;
  800aac:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800aae:	83 fb 64             	cmp    $0x64,%ebx
  800ab1:	7f 0b                	jg     800abe <vprintfmt+0x15a>
  800ab3:	8b 34 9d 40 3a 80 00 	mov    0x803a40(,%ebx,4),%esi
  800aba:	85 f6                	test   %esi,%esi
  800abc:	75 19                	jne    800ad7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800abe:	53                   	push   %ebx
  800abf:	68 e5 3b 80 00       	push   $0x803be5
  800ac4:	ff 75 0c             	pushl  0xc(%ebp)
  800ac7:	ff 75 08             	pushl  0x8(%ebp)
  800aca:	e8 5e 02 00 00       	call   800d2d <printfmt>
  800acf:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ad2:	e9 49 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ad7:	56                   	push   %esi
  800ad8:	68 ee 3b 80 00       	push   $0x803bee
  800add:	ff 75 0c             	pushl  0xc(%ebp)
  800ae0:	ff 75 08             	pushl  0x8(%ebp)
  800ae3:	e8 45 02 00 00       	call   800d2d <printfmt>
  800ae8:	83 c4 10             	add    $0x10,%esp
			break;
  800aeb:	e9 30 02 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800af0:	8b 45 14             	mov    0x14(%ebp),%eax
  800af3:	83 c0 04             	add    $0x4,%eax
  800af6:	89 45 14             	mov    %eax,0x14(%ebp)
  800af9:	8b 45 14             	mov    0x14(%ebp),%eax
  800afc:	83 e8 04             	sub    $0x4,%eax
  800aff:	8b 30                	mov    (%eax),%esi
  800b01:	85 f6                	test   %esi,%esi
  800b03:	75 05                	jne    800b0a <vprintfmt+0x1a6>
				p = "(null)";
  800b05:	be f1 3b 80 00       	mov    $0x803bf1,%esi
			if (width > 0 && padc != '-')
  800b0a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0e:	7e 6d                	jle    800b7d <vprintfmt+0x219>
  800b10:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b14:	74 67                	je     800b7d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b16:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b19:	83 ec 08             	sub    $0x8,%esp
  800b1c:	50                   	push   %eax
  800b1d:	56                   	push   %esi
  800b1e:	e8 0c 03 00 00       	call   800e2f <strnlen>
  800b23:	83 c4 10             	add    $0x10,%esp
  800b26:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b29:	eb 16                	jmp    800b41 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b2b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	ff 75 0c             	pushl  0xc(%ebp)
  800b35:	50                   	push   %eax
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b3e:	ff 4d e4             	decl   -0x1c(%ebp)
  800b41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b45:	7f e4                	jg     800b2b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b47:	eb 34                	jmp    800b7d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b49:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b4d:	74 1c                	je     800b6b <vprintfmt+0x207>
  800b4f:	83 fb 1f             	cmp    $0x1f,%ebx
  800b52:	7e 05                	jle    800b59 <vprintfmt+0x1f5>
  800b54:	83 fb 7e             	cmp    $0x7e,%ebx
  800b57:	7e 12                	jle    800b6b <vprintfmt+0x207>
					putch('?', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	ff 75 0c             	pushl  0xc(%ebp)
  800b5f:	6a 3f                	push   $0x3f
  800b61:	8b 45 08             	mov    0x8(%ebp),%eax
  800b64:	ff d0                	call   *%eax
  800b66:	83 c4 10             	add    $0x10,%esp
  800b69:	eb 0f                	jmp    800b7a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	53                   	push   %ebx
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	ff d0                	call   *%eax
  800b77:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b7a:	ff 4d e4             	decl   -0x1c(%ebp)
  800b7d:	89 f0                	mov    %esi,%eax
  800b7f:	8d 70 01             	lea    0x1(%eax),%esi
  800b82:	8a 00                	mov    (%eax),%al
  800b84:	0f be d8             	movsbl %al,%ebx
  800b87:	85 db                	test   %ebx,%ebx
  800b89:	74 24                	je     800baf <vprintfmt+0x24b>
  800b8b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b8f:	78 b8                	js     800b49 <vprintfmt+0x1e5>
  800b91:	ff 4d e0             	decl   -0x20(%ebp)
  800b94:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b98:	79 af                	jns    800b49 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b9a:	eb 13                	jmp    800baf <vprintfmt+0x24b>
				putch(' ', putdat);
  800b9c:	83 ec 08             	sub    $0x8,%esp
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	6a 20                	push   $0x20
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	ff 4d e4             	decl   -0x1c(%ebp)
  800baf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb3:	7f e7                	jg     800b9c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bb5:	e9 66 01 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bba:	83 ec 08             	sub    $0x8,%esp
  800bbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc3:	50                   	push   %eax
  800bc4:	e8 3c fd ff ff       	call   800905 <getint>
  800bc9:	83 c4 10             	add    $0x10,%esp
  800bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bcf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800bd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	85 d2                	test   %edx,%edx
  800bda:	79 23                	jns    800bff <vprintfmt+0x29b>
				putch('-', putdat);
  800bdc:	83 ec 08             	sub    $0x8,%esp
  800bdf:	ff 75 0c             	pushl  0xc(%ebp)
  800be2:	6a 2d                	push   $0x2d
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	ff d0                	call   *%eax
  800be9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bf2:	f7 d8                	neg    %eax
  800bf4:	83 d2 00             	adc    $0x0,%edx
  800bf7:	f7 da                	neg    %edx
  800bf9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c06:	e9 bc 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c0b:	83 ec 08             	sub    $0x8,%esp
  800c0e:	ff 75 e8             	pushl  -0x18(%ebp)
  800c11:	8d 45 14             	lea    0x14(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	e8 84 fc ff ff       	call   80089e <getuint>
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c20:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c23:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c2a:	e9 98 00 00 00       	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c2f:	83 ec 08             	sub    $0x8,%esp
  800c32:	ff 75 0c             	pushl  0xc(%ebp)
  800c35:	6a 58                	push   $0x58
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	ff d0                	call   *%eax
  800c3c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c3f:	83 ec 08             	sub    $0x8,%esp
  800c42:	ff 75 0c             	pushl  0xc(%ebp)
  800c45:	6a 58                	push   $0x58
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	ff d0                	call   *%eax
  800c4c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	ff 75 0c             	pushl  0xc(%ebp)
  800c55:	6a 58                	push   $0x58
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
			break;
  800c5f:	e9 bc 00 00 00       	jmp    800d20 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c64:	83 ec 08             	sub    $0x8,%esp
  800c67:	ff 75 0c             	pushl  0xc(%ebp)
  800c6a:	6a 30                	push   $0x30
  800c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6f:	ff d0                	call   *%eax
  800c71:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	ff 75 0c             	pushl  0xc(%ebp)
  800c7a:	6a 78                	push   $0x78
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	ff d0                	call   *%eax
  800c81:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c84:	8b 45 14             	mov    0x14(%ebp),%eax
  800c87:	83 c0 04             	add    $0x4,%eax
  800c8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c90:	83 e8 04             	sub    $0x4,%eax
  800c93:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c9f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ca6:	eb 1f                	jmp    800cc7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ca8:	83 ec 08             	sub    $0x8,%esp
  800cab:	ff 75 e8             	pushl  -0x18(%ebp)
  800cae:	8d 45 14             	lea    0x14(%ebp),%eax
  800cb1:	50                   	push   %eax
  800cb2:	e8 e7 fb ff ff       	call   80089e <getuint>
  800cb7:	83 c4 10             	add    $0x10,%esp
  800cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cbd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cc0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cc7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ccb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cce:	83 ec 04             	sub    $0x4,%esp
  800cd1:	52                   	push   %edx
  800cd2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cd5:	50                   	push   %eax
  800cd6:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd9:	ff 75 f0             	pushl  -0x10(%ebp)
  800cdc:	ff 75 0c             	pushl  0xc(%ebp)
  800cdf:	ff 75 08             	pushl  0x8(%ebp)
  800ce2:	e8 00 fb ff ff       	call   8007e7 <printnum>
  800ce7:	83 c4 20             	add    $0x20,%esp
			break;
  800cea:	eb 34                	jmp    800d20 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cec:	83 ec 08             	sub    $0x8,%esp
  800cef:	ff 75 0c             	pushl  0xc(%ebp)
  800cf2:	53                   	push   %ebx
  800cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf6:	ff d0                	call   *%eax
  800cf8:	83 c4 10             	add    $0x10,%esp
			break;
  800cfb:	eb 23                	jmp    800d20 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 0c             	pushl  0xc(%ebp)
  800d03:	6a 25                	push   $0x25
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d0d:	ff 4d 10             	decl   0x10(%ebp)
  800d10:	eb 03                	jmp    800d15 <vprintfmt+0x3b1>
  800d12:	ff 4d 10             	decl   0x10(%ebp)
  800d15:	8b 45 10             	mov    0x10(%ebp),%eax
  800d18:	48                   	dec    %eax
  800d19:	8a 00                	mov    (%eax),%al
  800d1b:	3c 25                	cmp    $0x25,%al
  800d1d:	75 f3                	jne    800d12 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d1f:	90                   	nop
		}
	}
  800d20:	e9 47 fc ff ff       	jmp    80096c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d25:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d26:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d33:	8d 45 10             	lea    0x10(%ebp),%eax
  800d36:	83 c0 04             	add    $0x4,%eax
  800d39:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800d42:	50                   	push   %eax
  800d43:	ff 75 0c             	pushl  0xc(%ebp)
  800d46:	ff 75 08             	pushl  0x8(%ebp)
  800d49:	e8 16 fc ff ff       	call   800964 <vprintfmt>
  800d4e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d51:	90                   	nop
  800d52:	c9                   	leave  
  800d53:	c3                   	ret    

00800d54 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d54:	55                   	push   %ebp
  800d55:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5a:	8b 40 08             	mov    0x8(%eax),%eax
  800d5d:	8d 50 01             	lea    0x1(%eax),%edx
  800d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d63:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d69:	8b 10                	mov    (%eax),%edx
  800d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6e:	8b 40 04             	mov    0x4(%eax),%eax
  800d71:	39 c2                	cmp    %eax,%edx
  800d73:	73 12                	jae    800d87 <sprintputch+0x33>
		*b->buf++ = ch;
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	8d 48 01             	lea    0x1(%eax),%ecx
  800d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d80:	89 0a                	mov    %ecx,(%edx)
  800d82:	8b 55 08             	mov    0x8(%ebp),%edx
  800d85:	88 10                	mov    %dl,(%eax)
}
  800d87:	90                   	nop
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9f:	01 d0                	add    %edx,%eax
  800da1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800da4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800daf:	74 06                	je     800db7 <vsnprintf+0x2d>
  800db1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800db5:	7f 07                	jg     800dbe <vsnprintf+0x34>
		return -E_INVAL;
  800db7:	b8 03 00 00 00       	mov    $0x3,%eax
  800dbc:	eb 20                	jmp    800dde <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dbe:	ff 75 14             	pushl  0x14(%ebp)
  800dc1:	ff 75 10             	pushl  0x10(%ebp)
  800dc4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dc7:	50                   	push   %eax
  800dc8:	68 54 0d 80 00       	push   $0x800d54
  800dcd:	e8 92 fb ff ff       	call   800964 <vprintfmt>
  800dd2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800dd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dd8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dde:	c9                   	leave  
  800ddf:	c3                   	ret    

00800de0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800de6:	8d 45 10             	lea    0x10(%ebp),%eax
  800de9:	83 c0 04             	add    $0x4,%eax
  800dec:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	ff 75 f4             	pushl  -0xc(%ebp)
  800df5:	50                   	push   %eax
  800df6:	ff 75 0c             	pushl  0xc(%ebp)
  800df9:	ff 75 08             	pushl  0x8(%ebp)
  800dfc:	e8 89 ff ff ff       	call   800d8a <vsnprintf>
  800e01:	83 c4 10             	add    $0x10,%esp
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 06                	jmp    800e21 <strlen+0x15>
		n++;
  800e1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	8a 00                	mov    (%eax),%al
  800e26:	84 c0                	test   %al,%al
  800e28:	75 f1                	jne    800e1b <strlen+0xf>
		n++;
	return n;
  800e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e2d:	c9                   	leave  
  800e2e:	c3                   	ret    

00800e2f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e3c:	eb 09                	jmp    800e47 <strnlen+0x18>
		n++;
  800e3e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e41:	ff 45 08             	incl   0x8(%ebp)
  800e44:	ff 4d 0c             	decl   0xc(%ebp)
  800e47:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e4b:	74 09                	je     800e56 <strnlen+0x27>
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	84 c0                	test   %al,%al
  800e54:	75 e8                	jne    800e3e <strnlen+0xf>
		n++;
	return n;
  800e56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e59:	c9                   	leave  
  800e5a:	c3                   	ret    

00800e5b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e61:	8b 45 08             	mov    0x8(%ebp),%eax
  800e64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e67:	90                   	nop
  800e68:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6b:	8d 50 01             	lea    0x1(%eax),%edx
  800e6e:	89 55 08             	mov    %edx,0x8(%ebp)
  800e71:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e74:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e77:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e7a:	8a 12                	mov    (%edx),%dl
  800e7c:	88 10                	mov    %dl,(%eax)
  800e7e:	8a 00                	mov    (%eax),%al
  800e80:	84 c0                	test   %al,%al
  800e82:	75 e4                	jne    800e68 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e95:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e9c:	eb 1f                	jmp    800ebd <strncpy+0x34>
		*dst++ = *src;
  800e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea1:	8d 50 01             	lea    0x1(%eax),%edx
  800ea4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ea7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eaa:	8a 12                	mov    (%edx),%dl
  800eac:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	84 c0                	test   %al,%al
  800eb5:	74 03                	je     800eba <strncpy+0x31>
			src++;
  800eb7:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800eba:	ff 45 fc             	incl   -0x4(%ebp)
  800ebd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec3:	72 d9                	jb     800e9e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ec5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ec8:	c9                   	leave  
  800ec9:	c3                   	ret    

00800eca <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eda:	74 30                	je     800f0c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800edc:	eb 16                	jmp    800ef4 <strlcpy+0x2a>
			*dst++ = *src++;
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eea:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eed:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ef0:	8a 12                	mov    (%edx),%dl
  800ef2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ef4:	ff 4d 10             	decl   0x10(%ebp)
  800ef7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800efb:	74 09                	je     800f06 <strlcpy+0x3c>
  800efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f00:	8a 00                	mov    (%eax),%al
  800f02:	84 c0                	test   %al,%al
  800f04:	75 d8                	jne    800ede <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f12:	29 c2                	sub    %eax,%edx
  800f14:	89 d0                	mov    %edx,%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f1b:	eb 06                	jmp    800f23 <strcmp+0xb>
		p++, q++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
  800f20:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	8a 00                	mov    (%eax),%al
  800f28:	84 c0                	test   %al,%al
  800f2a:	74 0e                	je     800f3a <strcmp+0x22>
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	8a 10                	mov    (%eax),%dl
  800f31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	38 c2                	cmp    %al,%dl
  800f38:	74 e3                	je     800f1d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	0f b6 d0             	movzbl %al,%edx
  800f42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 c0             	movzbl %al,%eax
  800f4a:	29 c2                	sub    %eax,%edx
  800f4c:	89 d0                	mov    %edx,%eax
}
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f53:	eb 09                	jmp    800f5e <strncmp+0xe>
		n--, p++, q++;
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	ff 45 08             	incl   0x8(%ebp)
  800f5b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f62:	74 17                	je     800f7b <strncmp+0x2b>
  800f64:	8b 45 08             	mov    0x8(%ebp),%eax
  800f67:	8a 00                	mov    (%eax),%al
  800f69:	84 c0                	test   %al,%al
  800f6b:	74 0e                	je     800f7b <strncmp+0x2b>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 10                	mov    (%eax),%dl
  800f72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f75:	8a 00                	mov    (%eax),%al
  800f77:	38 c2                	cmp    %al,%dl
  800f79:	74 da                	je     800f55 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f7f:	75 07                	jne    800f88 <strncmp+0x38>
		return 0;
  800f81:	b8 00 00 00 00       	mov    $0x0,%eax
  800f86:	eb 14                	jmp    800f9c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f88:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	0f b6 d0             	movzbl %al,%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	8a 00                	mov    (%eax),%al
  800f95:	0f b6 c0             	movzbl %al,%eax
  800f98:	29 c2                	sub    %eax,%edx
  800f9a:	89 d0                	mov    %edx,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 04             	sub    $0x4,%esp
  800fa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800faa:	eb 12                	jmp    800fbe <strchr+0x20>
		if (*s == c)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fb4:	75 05                	jne    800fbb <strchr+0x1d>
			return (char *) s;
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	eb 11                	jmp    800fcc <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fbb:	ff 45 08             	incl   0x8(%ebp)
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	84 c0                	test   %al,%al
  800fc5:	75 e5                	jne    800fac <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fcc:	c9                   	leave  
  800fcd:	c3                   	ret    

00800fce <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
  800fd1:	83 ec 04             	sub    $0x4,%esp
  800fd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fda:	eb 0d                	jmp    800fe9 <strfind+0x1b>
		if (*s == c)
  800fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdf:	8a 00                	mov    (%eax),%al
  800fe1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fe4:	74 0e                	je     800ff4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fe6:	ff 45 08             	incl   0x8(%ebp)
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	84 c0                	test   %al,%al
  800ff0:	75 ea                	jne    800fdc <strfind+0xe>
  800ff2:	eb 01                	jmp    800ff5 <strfind+0x27>
		if (*s == c)
			break;
  800ff4:	90                   	nop
	return (char *) s;
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff8:	c9                   	leave  
  800ff9:	c3                   	ret    

00800ffa <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801000:	8b 45 08             	mov    0x8(%ebp),%eax
  801003:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801006:	8b 45 10             	mov    0x10(%ebp),%eax
  801009:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80100c:	eb 0e                	jmp    80101c <memset+0x22>
		*p++ = c;
  80100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801011:	8d 50 01             	lea    0x1(%eax),%edx
  801014:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801017:	8b 55 0c             	mov    0xc(%ebp),%edx
  80101a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80101c:	ff 4d f8             	decl   -0x8(%ebp)
  80101f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801023:	79 e9                	jns    80100e <memset+0x14>
		*p++ = c;

	return v;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801028:	c9                   	leave  
  801029:	c3                   	ret    

0080102a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801036:	8b 45 08             	mov    0x8(%ebp),%eax
  801039:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80103c:	eb 16                	jmp    801054 <memcpy+0x2a>
		*d++ = *s++;
  80103e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801041:	8d 50 01             	lea    0x1(%eax),%edx
  801044:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801047:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80104a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80104d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801050:	8a 12                	mov    (%edx),%dl
  801052:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801054:	8b 45 10             	mov    0x10(%ebp),%eax
  801057:	8d 50 ff             	lea    -0x1(%eax),%edx
  80105a:	89 55 10             	mov    %edx,0x10(%ebp)
  80105d:	85 c0                	test   %eax,%eax
  80105f:	75 dd                	jne    80103e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80106c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801072:	8b 45 08             	mov    0x8(%ebp),%eax
  801075:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801078:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80107e:	73 50                	jae    8010d0 <memmove+0x6a>
  801080:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801083:	8b 45 10             	mov    0x10(%ebp),%eax
  801086:	01 d0                	add    %edx,%eax
  801088:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80108b:	76 43                	jbe    8010d0 <memmove+0x6a>
		s += n;
  80108d:	8b 45 10             	mov    0x10(%ebp),%eax
  801090:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801093:	8b 45 10             	mov    0x10(%ebp),%eax
  801096:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801099:	eb 10                	jmp    8010ab <memmove+0x45>
			*--d = *--s;
  80109b:	ff 4d f8             	decl   -0x8(%ebp)
  80109e:	ff 4d fc             	decl   -0x4(%ebp)
  8010a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010a4:	8a 10                	mov    (%eax),%dl
  8010a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ae:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b1:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	75 e3                	jne    80109b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010b8:	eb 23                	jmp    8010dd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	8d 50 01             	lea    0x1(%eax),%edx
  8010c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010c6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010cc:	8a 12                	mov    (%edx),%dl
  8010ce:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d3:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010d6:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	75 dd                	jne    8010ba <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010e0:	c9                   	leave  
  8010e1:	c3                   	ret    

008010e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010f4:	eb 2a                	jmp    801120 <memcmp+0x3e>
		if (*s1 != *s2)
  8010f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010f9:	8a 10                	mov    (%eax),%dl
  8010fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fe:	8a 00                	mov    (%eax),%al
  801100:	38 c2                	cmp    %al,%dl
  801102:	74 16                	je     80111a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801104:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801107:	8a 00                	mov    (%eax),%al
  801109:	0f b6 d0             	movzbl %al,%edx
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80110f:	8a 00                	mov    (%eax),%al
  801111:	0f b6 c0             	movzbl %al,%eax
  801114:	29 c2                	sub    %eax,%edx
  801116:	89 d0                	mov    %edx,%eax
  801118:	eb 18                	jmp    801132 <memcmp+0x50>
		s1++, s2++;
  80111a:	ff 45 fc             	incl   -0x4(%ebp)
  80111d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801120:	8b 45 10             	mov    0x10(%ebp),%eax
  801123:	8d 50 ff             	lea    -0x1(%eax),%edx
  801126:	89 55 10             	mov    %edx,0x10(%ebp)
  801129:	85 c0                	test   %eax,%eax
  80112b:	75 c9                	jne    8010f6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80112d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801132:	c9                   	leave  
  801133:	c3                   	ret    

00801134 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80113a:	8b 55 08             	mov    0x8(%ebp),%edx
  80113d:	8b 45 10             	mov    0x10(%ebp),%eax
  801140:	01 d0                	add    %edx,%eax
  801142:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801145:	eb 15                	jmp    80115c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801147:	8b 45 08             	mov    0x8(%ebp),%eax
  80114a:	8a 00                	mov    (%eax),%al
  80114c:	0f b6 d0             	movzbl %al,%edx
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	39 c2                	cmp    %eax,%edx
  801157:	74 0d                	je     801166 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801159:	ff 45 08             	incl   0x8(%ebp)
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801162:	72 e3                	jb     801147 <memfind+0x13>
  801164:	eb 01                	jmp    801167 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801166:	90                   	nop
	return (void *) s;
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801180:	eb 03                	jmp    801185 <strtol+0x19>
		s++;
  801182:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801185:	8b 45 08             	mov    0x8(%ebp),%eax
  801188:	8a 00                	mov    (%eax),%al
  80118a:	3c 20                	cmp    $0x20,%al
  80118c:	74 f4                	je     801182 <strtol+0x16>
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	8a 00                	mov    (%eax),%al
  801193:	3c 09                	cmp    $0x9,%al
  801195:	74 eb                	je     801182 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 2b                	cmp    $0x2b,%al
  80119e:	75 05                	jne    8011a5 <strtol+0x39>
		s++;
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	eb 13                	jmp    8011b8 <strtol+0x4c>
	else if (*s == '-')
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3c 2d                	cmp    $0x2d,%al
  8011ac:	75 0a                	jne    8011b8 <strtol+0x4c>
		s++, neg = 1;
  8011ae:	ff 45 08             	incl   0x8(%ebp)
  8011b1:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011b8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011bc:	74 06                	je     8011c4 <strtol+0x58>
  8011be:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011c2:	75 20                	jne    8011e4 <strtol+0x78>
  8011c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	3c 30                	cmp    $0x30,%al
  8011cb:	75 17                	jne    8011e4 <strtol+0x78>
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	40                   	inc    %eax
  8011d1:	8a 00                	mov    (%eax),%al
  8011d3:	3c 78                	cmp    $0x78,%al
  8011d5:	75 0d                	jne    8011e4 <strtol+0x78>
		s += 2, base = 16;
  8011d7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011db:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011e2:	eb 28                	jmp    80120c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011e4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e8:	75 15                	jne    8011ff <strtol+0x93>
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8a 00                	mov    (%eax),%al
  8011ef:	3c 30                	cmp    $0x30,%al
  8011f1:	75 0c                	jne    8011ff <strtol+0x93>
		s++, base = 8;
  8011f3:	ff 45 08             	incl   0x8(%ebp)
  8011f6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011fd:	eb 0d                	jmp    80120c <strtol+0xa0>
	else if (base == 0)
  8011ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801203:	75 07                	jne    80120c <strtol+0xa0>
		base = 10;
  801205:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 2f                	cmp    $0x2f,%al
  801213:	7e 19                	jle    80122e <strtol+0xc2>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	3c 39                	cmp    $0x39,%al
  80121c:	7f 10                	jg     80122e <strtol+0xc2>
			dig = *s - '0';
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	0f be c0             	movsbl %al,%eax
  801226:	83 e8 30             	sub    $0x30,%eax
  801229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122c:	eb 42                	jmp    801270 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8a 00                	mov    (%eax),%al
  801233:	3c 60                	cmp    $0x60,%al
  801235:	7e 19                	jle    801250 <strtol+0xe4>
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	3c 7a                	cmp    $0x7a,%al
  80123e:	7f 10                	jg     801250 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	0f be c0             	movsbl %al,%eax
  801248:	83 e8 57             	sub    $0x57,%eax
  80124b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80124e:	eb 20                	jmp    801270 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801250:	8b 45 08             	mov    0x8(%ebp),%eax
  801253:	8a 00                	mov    (%eax),%al
  801255:	3c 40                	cmp    $0x40,%al
  801257:	7e 39                	jle    801292 <strtol+0x126>
  801259:	8b 45 08             	mov    0x8(%ebp),%eax
  80125c:	8a 00                	mov    (%eax),%al
  80125e:	3c 5a                	cmp    $0x5a,%al
  801260:	7f 30                	jg     801292 <strtol+0x126>
			dig = *s - 'A' + 10;
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	0f be c0             	movsbl %al,%eax
  80126a:	83 e8 37             	sub    $0x37,%eax
  80126d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801270:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801273:	3b 45 10             	cmp    0x10(%ebp),%eax
  801276:	7d 19                	jge    801291 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801278:	ff 45 08             	incl   0x8(%ebp)
  80127b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801282:	89 c2                	mov    %eax,%edx
  801284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801287:	01 d0                	add    %edx,%eax
  801289:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80128c:	e9 7b ff ff ff       	jmp    80120c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801291:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801292:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801296:	74 08                	je     8012a0 <strtol+0x134>
		*endptr = (char *) s;
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012a4:	74 07                	je     8012ad <strtol+0x141>
  8012a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a9:	f7 d8                	neg    %eax
  8012ab:	eb 03                	jmp    8012b0 <strtol+0x144>
  8012ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012b0:	c9                   	leave  
  8012b1:	c3                   	ret    

008012b2 <ltostr>:

void
ltostr(long value, char *str)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
  8012b5:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012bf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012ca:	79 13                	jns    8012df <ltostr+0x2d>
	{
		neg = 1;
  8012cc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012d9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012dc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012df:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012e7:	99                   	cltd   
  8012e8:	f7 f9                	idiv   %ecx
  8012ea:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f0:	8d 50 01             	lea    0x1(%eax),%edx
  8012f3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801300:	83 c2 30             	add    $0x30,%edx
  801303:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801305:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801308:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80130d:	f7 e9                	imul   %ecx
  80130f:	c1 fa 02             	sar    $0x2,%edx
  801312:	89 c8                	mov    %ecx,%eax
  801314:	c1 f8 1f             	sar    $0x1f,%eax
  801317:	29 c2                	sub    %eax,%edx
  801319:	89 d0                	mov    %edx,%eax
  80131b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80131e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801321:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801326:	f7 e9                	imul   %ecx
  801328:	c1 fa 02             	sar    $0x2,%edx
  80132b:	89 c8                	mov    %ecx,%eax
  80132d:	c1 f8 1f             	sar    $0x1f,%eax
  801330:	29 c2                	sub    %eax,%edx
  801332:	89 d0                	mov    %edx,%eax
  801334:	c1 e0 02             	shl    $0x2,%eax
  801337:	01 d0                	add    %edx,%eax
  801339:	01 c0                	add    %eax,%eax
  80133b:	29 c1                	sub    %eax,%ecx
  80133d:	89 ca                	mov    %ecx,%edx
  80133f:	85 d2                	test   %edx,%edx
  801341:	75 9c                	jne    8012df <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801343:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80134a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134d:	48                   	dec    %eax
  80134e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801351:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801355:	74 3d                	je     801394 <ltostr+0xe2>
		start = 1 ;
  801357:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80135e:	eb 34                	jmp    801394 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801360:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801363:	8b 45 0c             	mov    0xc(%ebp),%eax
  801366:	01 d0                	add    %edx,%eax
  801368:	8a 00                	mov    (%eax),%al
  80136a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80136d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801370:	8b 45 0c             	mov    0xc(%ebp),%eax
  801373:	01 c2                	add    %eax,%edx
  801375:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801378:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137b:	01 c8                	add    %ecx,%eax
  80137d:	8a 00                	mov    (%eax),%al
  80137f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801381:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	01 c2                	add    %eax,%edx
  801389:	8a 45 eb             	mov    -0x15(%ebp),%al
  80138c:	88 02                	mov    %al,(%edx)
		start++ ;
  80138e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801391:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801397:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80139a:	7c c4                	jl     801360 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80139c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80139f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a2:	01 d0                	add    %edx,%eax
  8013a4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013a7:	90                   	nop
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    

008013aa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013b0:	ff 75 08             	pushl  0x8(%ebp)
  8013b3:	e8 54 fa ff ff       	call   800e0c <strlen>
  8013b8:	83 c4 04             	add    $0x4,%esp
  8013bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	e8 46 fa ff ff       	call   800e0c <strlen>
  8013c6:	83 c4 04             	add    $0x4,%esp
  8013c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013da:	eb 17                	jmp    8013f3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013df:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e2:	01 c2                	add    %eax,%edx
  8013e4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ea:	01 c8                	add    %ecx,%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013f0:	ff 45 fc             	incl   -0x4(%ebp)
  8013f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013f9:	7c e1                	jl     8013dc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801402:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801409:	eb 1f                	jmp    80142a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80140e:	8d 50 01             	lea    0x1(%eax),%edx
  801411:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801414:	89 c2                	mov    %eax,%edx
  801416:	8b 45 10             	mov    0x10(%ebp),%eax
  801419:	01 c2                	add    %eax,%edx
  80141b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	01 c8                	add    %ecx,%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801427:	ff 45 f8             	incl   -0x8(%ebp)
  80142a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80142d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801430:	7c d9                	jl     80140b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801432:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c6 00 00             	movb   $0x0,(%eax)
}
  80143d:	90                   	nop
  80143e:	c9                   	leave  
  80143f:	c3                   	ret    

00801440 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801443:	8b 45 14             	mov    0x14(%ebp),%eax
  801446:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	01 d0                	add    %edx,%eax
  80145d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801463:	eb 0c                	jmp    801471 <strsplit+0x31>
			*string++ = 0;
  801465:	8b 45 08             	mov    0x8(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 08             	mov    %edx,0x8(%ebp)
  80146e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	8a 00                	mov    (%eax),%al
  801476:	84 c0                	test   %al,%al
  801478:	74 18                	je     801492 <strsplit+0x52>
  80147a:	8b 45 08             	mov    0x8(%ebp),%eax
  80147d:	8a 00                	mov    (%eax),%al
  80147f:	0f be c0             	movsbl %al,%eax
  801482:	50                   	push   %eax
  801483:	ff 75 0c             	pushl  0xc(%ebp)
  801486:	e8 13 fb ff ff       	call   800f9e <strchr>
  80148b:	83 c4 08             	add    $0x8,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	75 d3                	jne    801465 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	8a 00                	mov    (%eax),%al
  801497:	84 c0                	test   %al,%al
  801499:	74 5a                	je     8014f5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80149b:	8b 45 14             	mov    0x14(%ebp),%eax
  80149e:	8b 00                	mov    (%eax),%eax
  8014a0:	83 f8 0f             	cmp    $0xf,%eax
  8014a3:	75 07                	jne    8014ac <strsplit+0x6c>
		{
			return 0;
  8014a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014aa:	eb 66                	jmp    801512 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	8d 48 01             	lea    0x1(%eax),%ecx
  8014b4:	8b 55 14             	mov    0x14(%ebp),%edx
  8014b7:	89 0a                	mov    %ecx,(%edx)
  8014b9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014c3:	01 c2                	add    %eax,%edx
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ca:	eb 03                	jmp    8014cf <strsplit+0x8f>
			string++;
  8014cc:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d2:	8a 00                	mov    (%eax),%al
  8014d4:	84 c0                	test   %al,%al
  8014d6:	74 8b                	je     801463 <strsplit+0x23>
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	8a 00                	mov    (%eax),%al
  8014dd:	0f be c0             	movsbl %al,%eax
  8014e0:	50                   	push   %eax
  8014e1:	ff 75 0c             	pushl  0xc(%ebp)
  8014e4:	e8 b5 fa ff ff       	call   800f9e <strchr>
  8014e9:	83 c4 08             	add    $0x8,%esp
  8014ec:	85 c0                	test   %eax,%eax
  8014ee:	74 dc                	je     8014cc <strsplit+0x8c>
			string++;
	}
  8014f0:	e9 6e ff ff ff       	jmp    801463 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014f5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801502:	8b 45 10             	mov    0x10(%ebp),%eax
  801505:	01 d0                	add    %edx,%eax
  801507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80150d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    

00801514 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801514:	55                   	push   %ebp
  801515:	89 e5                	mov    %esp,%ebp
  801517:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80151a:	a1 04 40 80 00       	mov    0x804004,%eax
  80151f:	85 c0                	test   %eax,%eax
  801521:	74 1f                	je     801542 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801523:	e8 1d 00 00 00       	call   801545 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	68 50 3d 80 00       	push   $0x803d50
  801530:	e8 55 f2 ff ff       	call   80078a <cprintf>
  801535:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801538:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80153f:	00 00 00 
	}
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80154b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801552:	00 00 00 
  801555:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80155c:	00 00 00 
  80155f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801566:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801569:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801570:	00 00 00 
  801573:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80157a:	00 00 00 
  80157d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801584:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801587:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  80158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801591:	c1 e8 0c             	shr    $0xc,%eax
  801594:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801599:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8015a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015a8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ad:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  8015b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8015b9:	a1 20 41 80 00       	mov    0x804120,%eax
  8015be:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8015c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8015c5:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8015cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8015cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015d2:	01 d0                	add    %edx,%eax
  8015d4:	48                   	dec    %eax
  8015d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015db:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e0:	f7 75 e4             	divl   -0x1c(%ebp)
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	29 d0                	sub    %edx,%eax
  8015e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8015eb:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8015f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8015f5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8015fa:	2d 00 10 00 00       	sub    $0x1000,%eax
  8015ff:	83 ec 04             	sub    $0x4,%esp
  801602:	6a 07                	push   $0x7
  801604:	ff 75 e8             	pushl  -0x18(%ebp)
  801607:	50                   	push   %eax
  801608:	e8 3d 06 00 00       	call   801c4a <sys_allocate_chunk>
  80160d:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801610:	a1 20 41 80 00       	mov    0x804120,%eax
  801615:	83 ec 0c             	sub    $0xc,%esp
  801618:	50                   	push   %eax
  801619:	e8 b2 0c 00 00       	call   8022d0 <initialize_MemBlocksList>
  80161e:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801621:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801626:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801629:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80162d:	0f 84 f3 00 00 00    	je     801726 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801633:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801637:	75 14                	jne    80164d <initialize_dyn_block_system+0x108>
  801639:	83 ec 04             	sub    $0x4,%esp
  80163c:	68 75 3d 80 00       	push   $0x803d75
  801641:	6a 36                	push   $0x36
  801643:	68 93 3d 80 00       	push   $0x803d93
  801648:	e8 89 ee ff ff       	call   8004d6 <_panic>
  80164d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801650:	8b 00                	mov    (%eax),%eax
  801652:	85 c0                	test   %eax,%eax
  801654:	74 10                	je     801666 <initialize_dyn_block_system+0x121>
  801656:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801659:	8b 00                	mov    (%eax),%eax
  80165b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80165e:	8b 52 04             	mov    0x4(%edx),%edx
  801661:	89 50 04             	mov    %edx,0x4(%eax)
  801664:	eb 0b                	jmp    801671 <initialize_dyn_block_system+0x12c>
  801666:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801669:	8b 40 04             	mov    0x4(%eax),%eax
  80166c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801671:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801674:	8b 40 04             	mov    0x4(%eax),%eax
  801677:	85 c0                	test   %eax,%eax
  801679:	74 0f                	je     80168a <initialize_dyn_block_system+0x145>
  80167b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80167e:	8b 40 04             	mov    0x4(%eax),%eax
  801681:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801684:	8b 12                	mov    (%edx),%edx
  801686:	89 10                	mov    %edx,(%eax)
  801688:	eb 0a                	jmp    801694 <initialize_dyn_block_system+0x14f>
  80168a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80168d:	8b 00                	mov    (%eax),%eax
  80168f:	a3 48 41 80 00       	mov    %eax,0x804148
  801694:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801697:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80169d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016a7:	a1 54 41 80 00       	mov    0x804154,%eax
  8016ac:	48                   	dec    %eax
  8016ad:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8016b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016b5:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8016bc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016bf:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8016c6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8016ca:	75 14                	jne    8016e0 <initialize_dyn_block_system+0x19b>
  8016cc:	83 ec 04             	sub    $0x4,%esp
  8016cf:	68 a0 3d 80 00       	push   $0x803da0
  8016d4:	6a 3e                	push   $0x3e
  8016d6:	68 93 3d 80 00       	push   $0x803d93
  8016db:	e8 f6 ed ff ff       	call   8004d6 <_panic>
  8016e0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8016e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016e9:	89 10                	mov    %edx,(%eax)
  8016eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016ee:	8b 00                	mov    (%eax),%eax
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	74 0d                	je     801701 <initialize_dyn_block_system+0x1bc>
  8016f4:	a1 38 41 80 00       	mov    0x804138,%eax
  8016f9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016fc:	89 50 04             	mov    %edx,0x4(%eax)
  8016ff:	eb 08                	jmp    801709 <initialize_dyn_block_system+0x1c4>
  801701:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801704:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801709:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80170c:	a3 38 41 80 00       	mov    %eax,0x804138
  801711:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801714:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80171b:	a1 44 41 80 00       	mov    0x804144,%eax
  801720:	40                   	inc    %eax
  801721:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801726:	90                   	nop
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80172f:	e8 e0 fd ff ff       	call   801514 <InitializeUHeap>
		if (size == 0) return NULL ;
  801734:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801738:	75 07                	jne    801741 <malloc+0x18>
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
  80173f:	eb 7f                	jmp    8017c0 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801741:	e8 d2 08 00 00       	call   802018 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801746:	85 c0                	test   %eax,%eax
  801748:	74 71                	je     8017bb <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80174a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801751:	8b 55 08             	mov    0x8(%ebp),%edx
  801754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801757:	01 d0                	add    %edx,%eax
  801759:	48                   	dec    %eax
  80175a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80175d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801760:	ba 00 00 00 00       	mov    $0x0,%edx
  801765:	f7 75 f4             	divl   -0xc(%ebp)
  801768:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176b:	29 d0                	sub    %edx,%eax
  80176d:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801770:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801777:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80177e:	76 07                	jbe    801787 <malloc+0x5e>
					return NULL ;
  801780:	b8 00 00 00 00       	mov    $0x0,%eax
  801785:	eb 39                	jmp    8017c0 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801787:	83 ec 0c             	sub    $0xc,%esp
  80178a:	ff 75 08             	pushl  0x8(%ebp)
  80178d:	e8 e6 0d 00 00       	call   802578 <alloc_block_FF>
  801792:	83 c4 10             	add    $0x10,%esp
  801795:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801798:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80179c:	74 16                	je     8017b4 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80179e:	83 ec 0c             	sub    $0xc,%esp
  8017a1:	ff 75 ec             	pushl  -0x14(%ebp)
  8017a4:	e8 37 0c 00 00       	call   8023e0 <insert_sorted_allocList>
  8017a9:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8017ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017af:	8b 40 08             	mov    0x8(%eax),%eax
  8017b2:	eb 0c                	jmp    8017c0 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8017b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b9:	eb 05                	jmp    8017c0 <malloc+0x97>
				}
		}
	return 0;
  8017bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8017ce:	83 ec 08             	sub    $0x8,%esp
  8017d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8017d4:	68 40 40 80 00       	push   $0x804040
  8017d9:	e8 cf 0b 00 00       	call   8023ad <find_block>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8017e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8017ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8017ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f0:	8b 40 08             	mov    0x8(%eax),%eax
  8017f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8017f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017fa:	0f 84 a1 00 00 00    	je     8018a1 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801800:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801804:	75 17                	jne    80181d <free+0x5b>
  801806:	83 ec 04             	sub    $0x4,%esp
  801809:	68 75 3d 80 00       	push   $0x803d75
  80180e:	68 80 00 00 00       	push   $0x80
  801813:	68 93 3d 80 00       	push   $0x803d93
  801818:	e8 b9 ec ff ff       	call   8004d6 <_panic>
  80181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801820:	8b 00                	mov    (%eax),%eax
  801822:	85 c0                	test   %eax,%eax
  801824:	74 10                	je     801836 <free+0x74>
  801826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801829:	8b 00                	mov    (%eax),%eax
  80182b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80182e:	8b 52 04             	mov    0x4(%edx),%edx
  801831:	89 50 04             	mov    %edx,0x4(%eax)
  801834:	eb 0b                	jmp    801841 <free+0x7f>
  801836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801839:	8b 40 04             	mov    0x4(%eax),%eax
  80183c:	a3 44 40 80 00       	mov    %eax,0x804044
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801844:	8b 40 04             	mov    0x4(%eax),%eax
  801847:	85 c0                	test   %eax,%eax
  801849:	74 0f                	je     80185a <free+0x98>
  80184b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80184e:	8b 40 04             	mov    0x4(%eax),%eax
  801851:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801854:	8b 12                	mov    (%edx),%edx
  801856:	89 10                	mov    %edx,(%eax)
  801858:	eb 0a                	jmp    801864 <free+0xa2>
  80185a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185d:	8b 00                	mov    (%eax),%eax
  80185f:	a3 40 40 80 00       	mov    %eax,0x804040
  801864:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801867:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801870:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801877:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80187c:	48                   	dec    %eax
  80187d:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801882:	83 ec 0c             	sub    $0xc,%esp
  801885:	ff 75 f0             	pushl  -0x10(%ebp)
  801888:	e8 29 12 00 00       	call   802ab6 <insert_sorted_with_merge_freeList>
  80188d:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801890:	83 ec 08             	sub    $0x8,%esp
  801893:	ff 75 ec             	pushl  -0x14(%ebp)
  801896:	ff 75 e8             	pushl  -0x18(%ebp)
  801899:	e8 74 03 00 00       	call   801c12 <sys_free_user_mem>
  80189e:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8018a1:	90                   	nop
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 38             	sub    $0x38,%esp
  8018aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ad:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018b0:	e8 5f fc ff ff       	call   801514 <InitializeUHeap>
	if (size == 0) return NULL ;
  8018b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8018b9:	75 0a                	jne    8018c5 <smalloc+0x21>
  8018bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c0:	e9 b2 00 00 00       	jmp    801977 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8018c5:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8018cc:	76 0a                	jbe    8018d8 <smalloc+0x34>
		return NULL;
  8018ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d3:	e9 9f 00 00 00       	jmp    801977 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8018d8:	e8 3b 07 00 00       	call   802018 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	0f 84 8d 00 00 00    	je     801972 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8018e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8018ec:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8018f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	48                   	dec    %eax
  8018fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801902:	ba 00 00 00 00       	mov    $0x0,%edx
  801907:	f7 75 f0             	divl   -0x10(%ebp)
  80190a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80190d:	29 d0                	sub    %edx,%eax
  80190f:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801912:	83 ec 0c             	sub    $0xc,%esp
  801915:	ff 75 e8             	pushl  -0x18(%ebp)
  801918:	e8 5b 0c 00 00       	call   802578 <alloc_block_FF>
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801923:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801927:	75 07                	jne    801930 <smalloc+0x8c>
			return NULL;
  801929:	b8 00 00 00 00       	mov    $0x0,%eax
  80192e:	eb 47                	jmp    801977 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801930:	83 ec 0c             	sub    $0xc,%esp
  801933:	ff 75 f4             	pushl  -0xc(%ebp)
  801936:	e8 a5 0a 00 00       	call   8023e0 <insert_sorted_allocList>
  80193b:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80193e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801941:	8b 40 08             	mov    0x8(%eax),%eax
  801944:	89 c2                	mov    %eax,%edx
  801946:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80194a:	52                   	push   %edx
  80194b:	50                   	push   %eax
  80194c:	ff 75 0c             	pushl  0xc(%ebp)
  80194f:	ff 75 08             	pushl  0x8(%ebp)
  801952:	e8 46 04 00 00       	call   801d9d <sys_createSharedObject>
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80195d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801961:	78 08                	js     80196b <smalloc+0xc7>
		return (void *)b->sva;
  801963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801966:	8b 40 08             	mov    0x8(%eax),%eax
  801969:	eb 0c                	jmp    801977 <smalloc+0xd3>
		}else{
		return NULL;
  80196b:	b8 00 00 00 00       	mov    $0x0,%eax
  801970:	eb 05                	jmp    801977 <smalloc+0xd3>
			}

	}return NULL;
  801972:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801977:	c9                   	leave  
  801978:	c3                   	ret    

00801979 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801979:	55                   	push   %ebp
  80197a:	89 e5                	mov    %esp,%ebp
  80197c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80197f:	e8 90 fb ff ff       	call   801514 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801984:	e8 8f 06 00 00       	call   802018 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801989:	85 c0                	test   %eax,%eax
  80198b:	0f 84 ad 00 00 00    	je     801a3e <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801991:	83 ec 08             	sub    $0x8,%esp
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	ff 75 08             	pushl  0x8(%ebp)
  80199a:	e8 28 04 00 00       	call   801dc7 <sys_getSizeOfSharedObject>
  80199f:	83 c4 10             	add    $0x10,%esp
  8019a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8019a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8019a9:	79 0a                	jns    8019b5 <sget+0x3c>
    {
    	return NULL;
  8019ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b0:	e9 8e 00 00 00       	jmp    801a43 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8019b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8019bc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8019c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019c9:	01 d0                	add    %edx,%eax
  8019cb:	48                   	dec    %eax
  8019cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8019cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d7:	f7 75 ec             	divl   -0x14(%ebp)
  8019da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8019dd:	29 d0                	sub    %edx,%eax
  8019df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8019e2:	83 ec 0c             	sub    $0xc,%esp
  8019e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019e8:	e8 8b 0b 00 00       	call   802578 <alloc_block_FF>
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8019f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019f7:	75 07                	jne    801a00 <sget+0x87>
				return NULL;
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fe:	eb 43                	jmp    801a43 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801a00:	83 ec 0c             	sub    $0xc,%esp
  801a03:	ff 75 f0             	pushl  -0x10(%ebp)
  801a06:	e8 d5 09 00 00       	call   8023e0 <insert_sorted_allocList>
  801a0b:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a11:	8b 40 08             	mov    0x8(%eax),%eax
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	50                   	push   %eax
  801a18:	ff 75 0c             	pushl  0xc(%ebp)
  801a1b:	ff 75 08             	pushl  0x8(%ebp)
  801a1e:	e8 c1 03 00 00       	call   801de4 <sys_getSharedObject>
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801a29:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801a2d:	78 08                	js     801a37 <sget+0xbe>
			return (void *)b->sva;
  801a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a32:	8b 40 08             	mov    0x8(%eax),%eax
  801a35:	eb 0c                	jmp    801a43 <sget+0xca>
			}else{
			return NULL;
  801a37:	b8 00 00 00 00       	mov    $0x0,%eax
  801a3c:	eb 05                	jmp    801a43 <sget+0xca>
			}
    }}return NULL;
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
  801a48:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a4b:	e8 c4 fa ff ff       	call   801514 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801a50:	83 ec 04             	sub    $0x4,%esp
  801a53:	68 c4 3d 80 00       	push   $0x803dc4
  801a58:	68 03 01 00 00       	push   $0x103
  801a5d:	68 93 3d 80 00       	push   $0x803d93
  801a62:	e8 6f ea ff ff       	call   8004d6 <_panic>

00801a67 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801a6d:	83 ec 04             	sub    $0x4,%esp
  801a70:	68 ec 3d 80 00       	push   $0x803dec
  801a75:	68 17 01 00 00       	push   $0x117
  801a7a:	68 93 3d 80 00       	push   $0x803d93
  801a7f:	e8 52 ea ff ff       	call   8004d6 <_panic>

00801a84 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801a8a:	83 ec 04             	sub    $0x4,%esp
  801a8d:	68 10 3e 80 00       	push   $0x803e10
  801a92:	68 22 01 00 00       	push   $0x122
  801a97:	68 93 3d 80 00       	push   $0x803d93
  801a9c:	e8 35 ea ff ff       	call   8004d6 <_panic>

00801aa1 <shrink>:

}
void shrink(uint32 newSize)
{
  801aa1:	55                   	push   %ebp
  801aa2:	89 e5                	mov    %esp,%ebp
  801aa4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	68 10 3e 80 00       	push   $0x803e10
  801aaf:	68 27 01 00 00       	push   $0x127
  801ab4:	68 93 3d 80 00       	push   $0x803d93
  801ab9:	e8 18 ea ff ff       	call   8004d6 <_panic>

00801abe <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
  801ac1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	68 10 3e 80 00       	push   $0x803e10
  801acc:	68 2c 01 00 00       	push   $0x12c
  801ad1:	68 93 3d 80 00       	push   $0x803d93
  801ad6:	e8 fb e9 ff ff       	call   8004d6 <_panic>

00801adb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	57                   	push   %edi
  801adf:	56                   	push   %esi
  801ae0:	53                   	push   %ebx
  801ae1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801af0:	8b 7d 18             	mov    0x18(%ebp),%edi
  801af3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801af6:	cd 30                	int    $0x30
  801af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801afe:	83 c4 10             	add    $0x10,%esp
  801b01:	5b                   	pop    %ebx
  801b02:	5e                   	pop    %esi
  801b03:	5f                   	pop    %edi
  801b04:	5d                   	pop    %ebp
  801b05:	c3                   	ret    

00801b06 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	83 ec 04             	sub    $0x4,%esp
  801b0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b12:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	52                   	push   %edx
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	50                   	push   %eax
  801b22:	6a 00                	push   $0x0
  801b24:	e8 b2 ff ff ff       	call   801adb <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	90                   	nop
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <sys_cgetc>:

int
sys_cgetc(void)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 01                	push   $0x1
  801b3e:	e8 98 ff ff ff       	call   801adb <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	52                   	push   %edx
  801b58:	50                   	push   %eax
  801b59:	6a 05                	push   $0x5
  801b5b:	e8 7b ff ff ff       	call   801adb <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	56                   	push   %esi
  801b69:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b6a:	8b 75 18             	mov    0x18(%ebp),%esi
  801b6d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b70:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	56                   	push   %esi
  801b7a:	53                   	push   %ebx
  801b7b:	51                   	push   %ecx
  801b7c:	52                   	push   %edx
  801b7d:	50                   	push   %eax
  801b7e:	6a 06                	push   $0x6
  801b80:	e8 56 ff ff ff       	call   801adb <syscall>
  801b85:	83 c4 18             	add    $0x18,%esp
}
  801b88:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b8b:	5b                   	pop    %ebx
  801b8c:	5e                   	pop    %esi
  801b8d:	5d                   	pop    %ebp
  801b8e:	c3                   	ret    

00801b8f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	52                   	push   %edx
  801b9f:	50                   	push   %eax
  801ba0:	6a 07                	push   $0x7
  801ba2:	e8 34 ff ff ff       	call   801adb <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	ff 75 0c             	pushl  0xc(%ebp)
  801bb8:	ff 75 08             	pushl  0x8(%ebp)
  801bbb:	6a 08                	push   $0x8
  801bbd:	e8 19 ff ff ff       	call   801adb <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	c9                   	leave  
  801bc6:	c3                   	ret    

00801bc7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bc7:	55                   	push   %ebp
  801bc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 09                	push   $0x9
  801bd6:	e8 00 ff ff ff       	call   801adb <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 0a                	push   $0xa
  801bef:	e8 e7 fe ff ff       	call   801adb <syscall>
  801bf4:	83 c4 18             	add    $0x18,%esp
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 0b                	push   $0xb
  801c08:	e8 ce fe ff ff       	call   801adb <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	c9                   	leave  
  801c11:	c3                   	ret    

00801c12 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c12:	55                   	push   %ebp
  801c13:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	ff 75 0c             	pushl  0xc(%ebp)
  801c1e:	ff 75 08             	pushl  0x8(%ebp)
  801c21:	6a 0f                	push   $0xf
  801c23:	e8 b3 fe ff ff       	call   801adb <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
	return;
  801c2b:	90                   	nop
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	ff 75 0c             	pushl  0xc(%ebp)
  801c3a:	ff 75 08             	pushl  0x8(%ebp)
  801c3d:	6a 10                	push   $0x10
  801c3f:	e8 97 fe ff ff       	call   801adb <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
	return ;
  801c47:	90                   	nop
}
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	ff 75 10             	pushl  0x10(%ebp)
  801c54:	ff 75 0c             	pushl  0xc(%ebp)
  801c57:	ff 75 08             	pushl  0x8(%ebp)
  801c5a:	6a 11                	push   $0x11
  801c5c:	e8 7a fe ff ff       	call   801adb <syscall>
  801c61:	83 c4 18             	add    $0x18,%esp
	return ;
  801c64:	90                   	nop
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 0c                	push   $0xc
  801c76:	e8 60 fe ff ff       	call   801adb <syscall>
  801c7b:	83 c4 18             	add    $0x18,%esp
}
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	ff 75 08             	pushl  0x8(%ebp)
  801c8e:	6a 0d                	push   $0xd
  801c90:	e8 46 fe ff ff       	call   801adb <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 0e                	push   $0xe
  801ca9:	e8 2d fe ff ff       	call   801adb <syscall>
  801cae:	83 c4 18             	add    $0x18,%esp
}
  801cb1:	90                   	nop
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 13                	push   $0x13
  801cc3:	e8 13 fe ff ff       	call   801adb <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	90                   	nop
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 14                	push   $0x14
  801cdd:	e8 f9 fd ff ff       	call   801adb <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	90                   	nop
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 04             	sub    $0x4,%esp
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cf4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	50                   	push   %eax
  801d01:	6a 15                	push   $0x15
  801d03:	e8 d3 fd ff ff       	call   801adb <syscall>
  801d08:	83 c4 18             	add    $0x18,%esp
}
  801d0b:	90                   	nop
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 16                	push   $0x16
  801d1d:	e8 b9 fd ff ff       	call   801adb <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	90                   	nop
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	ff 75 0c             	pushl  0xc(%ebp)
  801d37:	50                   	push   %eax
  801d38:	6a 17                	push   $0x17
  801d3a:	e8 9c fd ff ff       	call   801adb <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
}
  801d42:	c9                   	leave  
  801d43:	c3                   	ret    

00801d44 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d44:	55                   	push   %ebp
  801d45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	52                   	push   %edx
  801d54:	50                   	push   %eax
  801d55:	6a 1a                	push   $0x1a
  801d57:	e8 7f fd ff ff       	call   801adb <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d67:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	52                   	push   %edx
  801d71:	50                   	push   %eax
  801d72:	6a 18                	push   $0x18
  801d74:	e8 62 fd ff ff       	call   801adb <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
}
  801d7c:	90                   	nop
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d85:	8b 45 08             	mov    0x8(%ebp),%eax
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	52                   	push   %edx
  801d8f:	50                   	push   %eax
  801d90:	6a 19                	push   $0x19
  801d92:	e8 44 fd ff ff       	call   801adb <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
}
  801d9a:	90                   	nop
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 04             	sub    $0x4,%esp
  801da3:	8b 45 10             	mov    0x10(%ebp),%eax
  801da6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801da9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801dac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	6a 00                	push   $0x0
  801db5:	51                   	push   %ecx
  801db6:	52                   	push   %edx
  801db7:	ff 75 0c             	pushl  0xc(%ebp)
  801dba:	50                   	push   %eax
  801dbb:	6a 1b                	push   $0x1b
  801dbd:	e8 19 fd ff ff       	call   801adb <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	52                   	push   %edx
  801dd7:	50                   	push   %eax
  801dd8:	6a 1c                	push   $0x1c
  801dda:	e8 fc fc ff ff       	call   801adb <syscall>
  801ddf:	83 c4 18             	add    $0x18,%esp
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801de7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ded:	8b 45 08             	mov    0x8(%ebp),%eax
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	51                   	push   %ecx
  801df5:	52                   	push   %edx
  801df6:	50                   	push   %eax
  801df7:	6a 1d                	push   $0x1d
  801df9:	e8 dd fc ff ff       	call   801adb <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e09:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	52                   	push   %edx
  801e13:	50                   	push   %eax
  801e14:	6a 1e                	push   $0x1e
  801e16:	e8 c0 fc ff ff       	call   801adb <syscall>
  801e1b:	83 c4 18             	add    $0x18,%esp
}
  801e1e:	c9                   	leave  
  801e1f:	c3                   	ret    

00801e20 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 1f                	push   $0x1f
  801e2f:	e8 a7 fc ff ff       	call   801adb <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 14             	pushl  0x14(%ebp)
  801e44:	ff 75 10             	pushl  0x10(%ebp)
  801e47:	ff 75 0c             	pushl  0xc(%ebp)
  801e4a:	50                   	push   %eax
  801e4b:	6a 20                	push   $0x20
  801e4d:	e8 89 fc ff ff       	call   801adb <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	50                   	push   %eax
  801e66:	6a 21                	push   $0x21
  801e68:	e8 6e fc ff ff       	call   801adb <syscall>
  801e6d:	83 c4 18             	add    $0x18,%esp
}
  801e70:	90                   	nop
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	50                   	push   %eax
  801e82:	6a 22                	push   $0x22
  801e84:	e8 52 fc ff ff       	call   801adb <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
}
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 02                	push   $0x2
  801e9d:	e8 39 fc ff ff       	call   801adb <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
}
  801ea5:	c9                   	leave  
  801ea6:	c3                   	ret    

00801ea7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ea7:	55                   	push   %ebp
  801ea8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 03                	push   $0x3
  801eb6:	e8 20 fc ff ff       	call   801adb <syscall>
  801ebb:	83 c4 18             	add    $0x18,%esp
}
  801ebe:	c9                   	leave  
  801ebf:	c3                   	ret    

00801ec0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 04                	push   $0x4
  801ecf:	e8 07 fc ff ff       	call   801adb <syscall>
  801ed4:	83 c4 18             	add    $0x18,%esp
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_exit_env>:


void sys_exit_env(void)
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 23                	push   $0x23
  801ee8:	e8 ee fb ff ff       	call   801adb <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
}
  801ef0:	90                   	nop
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ef9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801efc:	8d 50 04             	lea    0x4(%eax),%edx
  801eff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 00                	push   $0x0
  801f08:	52                   	push   %edx
  801f09:	50                   	push   %eax
  801f0a:	6a 24                	push   $0x24
  801f0c:	e8 ca fb ff ff       	call   801adb <syscall>
  801f11:	83 c4 18             	add    $0x18,%esp
	return result;
  801f14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f1d:	89 01                	mov    %eax,(%ecx)
  801f1f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f22:	8b 45 08             	mov    0x8(%ebp),%eax
  801f25:	c9                   	leave  
  801f26:	c2 04 00             	ret    $0x4

00801f29 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f29:	55                   	push   %ebp
  801f2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	ff 75 10             	pushl  0x10(%ebp)
  801f33:	ff 75 0c             	pushl  0xc(%ebp)
  801f36:	ff 75 08             	pushl  0x8(%ebp)
  801f39:	6a 12                	push   $0x12
  801f3b:	e8 9b fb ff ff       	call   801adb <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
	return ;
  801f43:	90                   	nop
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 00                	push   $0x0
  801f53:	6a 25                	push   $0x25
  801f55:	e8 81 fb ff ff       	call   801adb <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 04             	sub    $0x4,%esp
  801f65:	8b 45 08             	mov    0x8(%ebp),%eax
  801f68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f6b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	50                   	push   %eax
  801f78:	6a 26                	push   $0x26
  801f7a:	e8 5c fb ff ff       	call   801adb <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801f82:	90                   	nop
}
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <rsttst>:
void rsttst()
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 28                	push   $0x28
  801f94:	e8 42 fb ff ff       	call   801adb <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
	return ;
  801f9c:	90                   	nop
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fab:	8b 55 18             	mov    0x18(%ebp),%edx
  801fae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fb2:	52                   	push   %edx
  801fb3:	50                   	push   %eax
  801fb4:	ff 75 10             	pushl  0x10(%ebp)
  801fb7:	ff 75 0c             	pushl  0xc(%ebp)
  801fba:	ff 75 08             	pushl  0x8(%ebp)
  801fbd:	6a 27                	push   $0x27
  801fbf:	e8 17 fb ff ff       	call   801adb <syscall>
  801fc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc7:	90                   	nop
}
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <chktst>:
void chktst(uint32 n)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	ff 75 08             	pushl  0x8(%ebp)
  801fd8:	6a 29                	push   $0x29
  801fda:	e8 fc fa ff ff       	call   801adb <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fe2:	90                   	nop
}
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <inctst>:

void inctst()
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fe8:	6a 00                	push   $0x0
  801fea:	6a 00                	push   $0x0
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 2a                	push   $0x2a
  801ff4:	e8 e2 fa ff ff       	call   801adb <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ffc:	90                   	nop
}
  801ffd:	c9                   	leave  
  801ffe:	c3                   	ret    

00801fff <gettst>:
uint32 gettst()
{
  801fff:	55                   	push   %ebp
  802000:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 00                	push   $0x0
  80200c:	6a 2b                	push   $0x2b
  80200e:	e8 c8 fa ff ff       	call   801adb <syscall>
  802013:	83 c4 18             	add    $0x18,%esp
}
  802016:	c9                   	leave  
  802017:	c3                   	ret    

00802018 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802018:	55                   	push   %ebp
  802019:	89 e5                	mov    %esp,%ebp
  80201b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 2c                	push   $0x2c
  80202a:	e8 ac fa ff ff       	call   801adb <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
  802032:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802035:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802039:	75 07                	jne    802042 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80203b:	b8 01 00 00 00       	mov    $0x1,%eax
  802040:	eb 05                	jmp    802047 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802042:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    

00802049 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	6a 00                	push   $0x0
  802055:	6a 00                	push   $0x0
  802057:	6a 00                	push   $0x0
  802059:	6a 2c                	push   $0x2c
  80205b:	e8 7b fa ff ff       	call   801adb <syscall>
  802060:	83 c4 18             	add    $0x18,%esp
  802063:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802066:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80206a:	75 07                	jne    802073 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80206c:	b8 01 00 00 00       	mov    $0x1,%eax
  802071:	eb 05                	jmp    802078 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802073:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802080:	6a 00                	push   $0x0
  802082:	6a 00                	push   $0x0
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 2c                	push   $0x2c
  80208c:	e8 4a fa ff ff       	call   801adb <syscall>
  802091:	83 c4 18             	add    $0x18,%esp
  802094:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802097:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80209b:	75 07                	jne    8020a4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80209d:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a2:	eb 05                	jmp    8020a9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8020a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020b1:	6a 00                	push   $0x0
  8020b3:	6a 00                	push   $0x0
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 2c                	push   $0x2c
  8020bd:	e8 19 fa ff ff       	call   801adb <syscall>
  8020c2:	83 c4 18             	add    $0x18,%esp
  8020c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020c8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020cc:	75 07                	jne    8020d5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8020d3:	eb 05                	jmp    8020da <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020da:	c9                   	leave  
  8020db:	c3                   	ret    

008020dc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 00                	push   $0x0
  8020e7:	ff 75 08             	pushl  0x8(%ebp)
  8020ea:	6a 2d                	push   $0x2d
  8020ec:	e8 ea f9 ff ff       	call   801adb <syscall>
  8020f1:	83 c4 18             	add    $0x18,%esp
	return ;
  8020f4:	90                   	nop
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020fb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020fe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802101:	8b 55 0c             	mov    0xc(%ebp),%edx
  802104:	8b 45 08             	mov    0x8(%ebp),%eax
  802107:	6a 00                	push   $0x0
  802109:	53                   	push   %ebx
  80210a:	51                   	push   %ecx
  80210b:	52                   	push   %edx
  80210c:	50                   	push   %eax
  80210d:	6a 2e                	push   $0x2e
  80210f:	e8 c7 f9 ff ff       	call   801adb <syscall>
  802114:	83 c4 18             	add    $0x18,%esp
}
  802117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80211f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	52                   	push   %edx
  80212c:	50                   	push   %eax
  80212d:	6a 2f                	push   $0x2f
  80212f:	e8 a7 f9 ff ff       	call   801adb <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80213f:	83 ec 0c             	sub    $0xc,%esp
  802142:	68 20 3e 80 00       	push   $0x803e20
  802147:	e8 3e e6 ff ff       	call   80078a <cprintf>
  80214c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80214f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802156:	83 ec 0c             	sub    $0xc,%esp
  802159:	68 4c 3e 80 00       	push   $0x803e4c
  80215e:	e8 27 e6 ff ff       	call   80078a <cprintf>
  802163:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802166:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80216a:	a1 38 41 80 00       	mov    0x804138,%eax
  80216f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802172:	eb 56                	jmp    8021ca <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802174:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802178:	74 1c                	je     802196 <print_mem_block_lists+0x5d>
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	8b 50 08             	mov    0x8(%eax),%edx
  802180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802183:	8b 48 08             	mov    0x8(%eax),%ecx
  802186:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802189:	8b 40 0c             	mov    0xc(%eax),%eax
  80218c:	01 c8                	add    %ecx,%eax
  80218e:	39 c2                	cmp    %eax,%edx
  802190:	73 04                	jae    802196 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802192:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802199:	8b 50 08             	mov    0x8(%eax),%edx
  80219c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219f:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a2:	01 c2                	add    %eax,%edx
  8021a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a7:	8b 40 08             	mov    0x8(%eax),%eax
  8021aa:	83 ec 04             	sub    $0x4,%esp
  8021ad:	52                   	push   %edx
  8021ae:	50                   	push   %eax
  8021af:	68 61 3e 80 00       	push   $0x803e61
  8021b4:	e8 d1 e5 ff ff       	call   80078a <cprintf>
  8021b9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8021bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021c2:	a1 40 41 80 00       	mov    0x804140,%eax
  8021c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ce:	74 07                	je     8021d7 <print_mem_block_lists+0x9e>
  8021d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d3:	8b 00                	mov    (%eax),%eax
  8021d5:	eb 05                	jmp    8021dc <print_mem_block_lists+0xa3>
  8021d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8021dc:	a3 40 41 80 00       	mov    %eax,0x804140
  8021e1:	a1 40 41 80 00       	mov    0x804140,%eax
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	75 8a                	jne    802174 <print_mem_block_lists+0x3b>
  8021ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021ee:	75 84                	jne    802174 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8021f0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021f4:	75 10                	jne    802206 <print_mem_block_lists+0xcd>
  8021f6:	83 ec 0c             	sub    $0xc,%esp
  8021f9:	68 70 3e 80 00       	push   $0x803e70
  8021fe:	e8 87 e5 ff ff       	call   80078a <cprintf>
  802203:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802206:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80220d:	83 ec 0c             	sub    $0xc,%esp
  802210:	68 94 3e 80 00       	push   $0x803e94
  802215:	e8 70 e5 ff ff       	call   80078a <cprintf>
  80221a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80221d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802221:	a1 40 40 80 00       	mov    0x804040,%eax
  802226:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802229:	eb 56                	jmp    802281 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80222b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80222f:	74 1c                	je     80224d <print_mem_block_lists+0x114>
  802231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802234:	8b 50 08             	mov    0x8(%eax),%edx
  802237:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223a:	8b 48 08             	mov    0x8(%eax),%ecx
  80223d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802240:	8b 40 0c             	mov    0xc(%eax),%eax
  802243:	01 c8                	add    %ecx,%eax
  802245:	39 c2                	cmp    %eax,%edx
  802247:	73 04                	jae    80224d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802249:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80224d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802250:	8b 50 08             	mov    0x8(%eax),%edx
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 40 0c             	mov    0xc(%eax),%eax
  802259:	01 c2                	add    %eax,%edx
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 40 08             	mov    0x8(%eax),%eax
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	52                   	push   %edx
  802265:	50                   	push   %eax
  802266:	68 61 3e 80 00       	push   $0x803e61
  80226b:	e8 1a e5 ff ff       	call   80078a <cprintf>
  802270:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802279:	a1 48 40 80 00       	mov    0x804048,%eax
  80227e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802285:	74 07                	je     80228e <print_mem_block_lists+0x155>
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	8b 00                	mov    (%eax),%eax
  80228c:	eb 05                	jmp    802293 <print_mem_block_lists+0x15a>
  80228e:	b8 00 00 00 00       	mov    $0x0,%eax
  802293:	a3 48 40 80 00       	mov    %eax,0x804048
  802298:	a1 48 40 80 00       	mov    0x804048,%eax
  80229d:	85 c0                	test   %eax,%eax
  80229f:	75 8a                	jne    80222b <print_mem_block_lists+0xf2>
  8022a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a5:	75 84                	jne    80222b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8022a7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022ab:	75 10                	jne    8022bd <print_mem_block_lists+0x184>
  8022ad:	83 ec 0c             	sub    $0xc,%esp
  8022b0:	68 ac 3e 80 00       	push   $0x803eac
  8022b5:	e8 d0 e4 ff ff       	call   80078a <cprintf>
  8022ba:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8022bd:	83 ec 0c             	sub    $0xc,%esp
  8022c0:	68 20 3e 80 00       	push   $0x803e20
  8022c5:	e8 c0 e4 ff ff       	call   80078a <cprintf>
  8022ca:	83 c4 10             	add    $0x10,%esp

}
  8022cd:	90                   	nop
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8022d6:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8022dd:	00 00 00 
  8022e0:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8022e7:	00 00 00 
  8022ea:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8022f1:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8022f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8022fb:	e9 9e 00 00 00       	jmp    80239e <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802300:	a1 50 40 80 00       	mov    0x804050,%eax
  802305:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802308:	c1 e2 04             	shl    $0x4,%edx
  80230b:	01 d0                	add    %edx,%eax
  80230d:	85 c0                	test   %eax,%eax
  80230f:	75 14                	jne    802325 <initialize_MemBlocksList+0x55>
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	68 d4 3e 80 00       	push   $0x803ed4
  802319:	6a 3d                	push   $0x3d
  80231b:	68 f7 3e 80 00       	push   $0x803ef7
  802320:	e8 b1 e1 ff ff       	call   8004d6 <_panic>
  802325:	a1 50 40 80 00       	mov    0x804050,%eax
  80232a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232d:	c1 e2 04             	shl    $0x4,%edx
  802330:	01 d0                	add    %edx,%eax
  802332:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802338:	89 10                	mov    %edx,(%eax)
  80233a:	8b 00                	mov    (%eax),%eax
  80233c:	85 c0                	test   %eax,%eax
  80233e:	74 18                	je     802358 <initialize_MemBlocksList+0x88>
  802340:	a1 48 41 80 00       	mov    0x804148,%eax
  802345:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80234b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80234e:	c1 e1 04             	shl    $0x4,%ecx
  802351:	01 ca                	add    %ecx,%edx
  802353:	89 50 04             	mov    %edx,0x4(%eax)
  802356:	eb 12                	jmp    80236a <initialize_MemBlocksList+0x9a>
  802358:	a1 50 40 80 00       	mov    0x804050,%eax
  80235d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802360:	c1 e2 04             	shl    $0x4,%edx
  802363:	01 d0                	add    %edx,%eax
  802365:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80236a:	a1 50 40 80 00       	mov    0x804050,%eax
  80236f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802372:	c1 e2 04             	shl    $0x4,%edx
  802375:	01 d0                	add    %edx,%eax
  802377:	a3 48 41 80 00       	mov    %eax,0x804148
  80237c:	a1 50 40 80 00       	mov    0x804050,%eax
  802381:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802384:	c1 e2 04             	shl    $0x4,%edx
  802387:	01 d0                	add    %edx,%eax
  802389:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802390:	a1 54 41 80 00       	mov    0x804154,%eax
  802395:	40                   	inc    %eax
  802396:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80239b:	ff 45 f4             	incl   -0xc(%ebp)
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a4:	0f 82 56 ff ff ff    	jb     802300 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8023aa:	90                   	nop
  8023ab:	c9                   	leave  
  8023ac:	c3                   	ret    

008023ad <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8023ad:	55                   	push   %ebp
  8023ae:	89 e5                	mov    %esp,%ebp
  8023b0:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8023b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b6:	8b 00                	mov    (%eax),%eax
  8023b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8023bb:	eb 18                	jmp    8023d5 <find_block+0x28>

		if(tmp->sva == va){
  8023bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023c0:	8b 40 08             	mov    0x8(%eax),%eax
  8023c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8023c6:	75 05                	jne    8023cd <find_block+0x20>
			return tmp ;
  8023c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023cb:	eb 11                	jmp    8023de <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8023cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8023d0:	8b 00                	mov    (%eax),%eax
  8023d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8023d5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8023d9:	75 e2                	jne    8023bd <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8023db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8023e6:	a1 40 40 80 00       	mov    0x804040,%eax
  8023eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8023ee:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8023f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023fa:	75 65                	jne    802461 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8023fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802400:	75 14                	jne    802416 <insert_sorted_allocList+0x36>
  802402:	83 ec 04             	sub    $0x4,%esp
  802405:	68 d4 3e 80 00       	push   $0x803ed4
  80240a:	6a 62                	push   $0x62
  80240c:	68 f7 3e 80 00       	push   $0x803ef7
  802411:	e8 c0 e0 ff ff       	call   8004d6 <_panic>
  802416:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	89 10                	mov    %edx,(%eax)
  802421:	8b 45 08             	mov    0x8(%ebp),%eax
  802424:	8b 00                	mov    (%eax),%eax
  802426:	85 c0                	test   %eax,%eax
  802428:	74 0d                	je     802437 <insert_sorted_allocList+0x57>
  80242a:	a1 40 40 80 00       	mov    0x804040,%eax
  80242f:	8b 55 08             	mov    0x8(%ebp),%edx
  802432:	89 50 04             	mov    %edx,0x4(%eax)
  802435:	eb 08                	jmp    80243f <insert_sorted_allocList+0x5f>
  802437:	8b 45 08             	mov    0x8(%ebp),%eax
  80243a:	a3 44 40 80 00       	mov    %eax,0x804044
  80243f:	8b 45 08             	mov    0x8(%ebp),%eax
  802442:	a3 40 40 80 00       	mov    %eax,0x804040
  802447:	8b 45 08             	mov    0x8(%ebp),%eax
  80244a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802451:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802456:	40                   	inc    %eax
  802457:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80245c:	e9 14 01 00 00       	jmp    802575 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802461:	8b 45 08             	mov    0x8(%ebp),%eax
  802464:	8b 50 08             	mov    0x8(%eax),%edx
  802467:	a1 44 40 80 00       	mov    0x804044,%eax
  80246c:	8b 40 08             	mov    0x8(%eax),%eax
  80246f:	39 c2                	cmp    %eax,%edx
  802471:	76 65                	jbe    8024d8 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802473:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802477:	75 14                	jne    80248d <insert_sorted_allocList+0xad>
  802479:	83 ec 04             	sub    $0x4,%esp
  80247c:	68 10 3f 80 00       	push   $0x803f10
  802481:	6a 64                	push   $0x64
  802483:	68 f7 3e 80 00       	push   $0x803ef7
  802488:	e8 49 e0 ff ff       	call   8004d6 <_panic>
  80248d:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	89 50 04             	mov    %edx,0x4(%eax)
  802499:	8b 45 08             	mov    0x8(%ebp),%eax
  80249c:	8b 40 04             	mov    0x4(%eax),%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	74 0c                	je     8024af <insert_sorted_allocList+0xcf>
  8024a3:	a1 44 40 80 00       	mov    0x804044,%eax
  8024a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ab:	89 10                	mov    %edx,(%eax)
  8024ad:	eb 08                	jmp    8024b7 <insert_sorted_allocList+0xd7>
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	a3 40 40 80 00       	mov    %eax,0x804040
  8024b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ba:	a3 44 40 80 00       	mov    %eax,0x804044
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8024cd:	40                   	inc    %eax
  8024ce:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8024d3:	e9 9d 00 00 00       	jmp    802575 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8024d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8024df:	e9 85 00 00 00       	jmp    802569 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8024e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e7:	8b 50 08             	mov    0x8(%eax),%edx
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 40 08             	mov    0x8(%eax),%eax
  8024f0:	39 c2                	cmp    %eax,%edx
  8024f2:	73 6a                	jae    80255e <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8024f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f8:	74 06                	je     802500 <insert_sorted_allocList+0x120>
  8024fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024fe:	75 14                	jne    802514 <insert_sorted_allocList+0x134>
  802500:	83 ec 04             	sub    $0x4,%esp
  802503:	68 34 3f 80 00       	push   $0x803f34
  802508:	6a 6b                	push   $0x6b
  80250a:	68 f7 3e 80 00       	push   $0x803ef7
  80250f:	e8 c2 df ff ff       	call   8004d6 <_panic>
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 50 04             	mov    0x4(%eax),%edx
  80251a:	8b 45 08             	mov    0x8(%ebp),%eax
  80251d:	89 50 04             	mov    %edx,0x4(%eax)
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802526:	89 10                	mov    %edx,(%eax)
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 40 04             	mov    0x4(%eax),%eax
  80252e:	85 c0                	test   %eax,%eax
  802530:	74 0d                	je     80253f <insert_sorted_allocList+0x15f>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 40 04             	mov    0x4(%eax),%eax
  802538:	8b 55 08             	mov    0x8(%ebp),%edx
  80253b:	89 10                	mov    %edx,(%eax)
  80253d:	eb 08                	jmp    802547 <insert_sorted_allocList+0x167>
  80253f:	8b 45 08             	mov    0x8(%ebp),%eax
  802542:	a3 40 40 80 00       	mov    %eax,0x804040
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 55 08             	mov    0x8(%ebp),%edx
  80254d:	89 50 04             	mov    %edx,0x4(%eax)
  802550:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802555:	40                   	inc    %eax
  802556:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  80255b:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80255c:	eb 17                	jmp    802575 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802566:	ff 45 f0             	incl   -0x10(%ebp)
  802569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80256c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80256f:	0f 8c 6f ff ff ff    	jl     8024e4 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802575:	90                   	nop
  802576:	c9                   	leave  
  802577:	c3                   	ret    

00802578 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802578:	55                   	push   %ebp
  802579:	89 e5                	mov    %esp,%ebp
  80257b:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80257e:	a1 38 41 80 00       	mov    0x804138,%eax
  802583:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802586:	e9 7c 01 00 00       	jmp    802707 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 40 0c             	mov    0xc(%eax),%eax
  802591:	3b 45 08             	cmp    0x8(%ebp),%eax
  802594:	0f 86 cf 00 00 00    	jbe    802669 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80259a:	a1 48 41 80 00       	mov    0x804148,%eax
  80259f:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8025a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8025a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8025ae:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 50 08             	mov    0x8(%eax),%edx
  8025b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ba:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8025bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025c3:	2b 45 08             	sub    0x8(%ebp),%eax
  8025c6:	89 c2                	mov    %eax,%edx
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8025ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d1:	8b 50 08             	mov    0x8(%eax),%edx
  8025d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d7:	01 c2                	add    %eax,%edx
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8025df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025e3:	75 17                	jne    8025fc <alloc_block_FF+0x84>
  8025e5:	83 ec 04             	sub    $0x4,%esp
  8025e8:	68 69 3f 80 00       	push   $0x803f69
  8025ed:	68 83 00 00 00       	push   $0x83
  8025f2:	68 f7 3e 80 00       	push   $0x803ef7
  8025f7:	e8 da de ff ff       	call   8004d6 <_panic>
  8025fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	85 c0                	test   %eax,%eax
  802603:	74 10                	je     802615 <alloc_block_FF+0x9d>
  802605:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802608:	8b 00                	mov    (%eax),%eax
  80260a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80260d:	8b 52 04             	mov    0x4(%edx),%edx
  802610:	89 50 04             	mov    %edx,0x4(%eax)
  802613:	eb 0b                	jmp    802620 <alloc_block_FF+0xa8>
  802615:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802618:	8b 40 04             	mov    0x4(%eax),%eax
  80261b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802620:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802623:	8b 40 04             	mov    0x4(%eax),%eax
  802626:	85 c0                	test   %eax,%eax
  802628:	74 0f                	je     802639 <alloc_block_FF+0xc1>
  80262a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262d:	8b 40 04             	mov    0x4(%eax),%eax
  802630:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802633:	8b 12                	mov    (%edx),%edx
  802635:	89 10                	mov    %edx,(%eax)
  802637:	eb 0a                	jmp    802643 <alloc_block_FF+0xcb>
  802639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80263c:	8b 00                	mov    (%eax),%eax
  80263e:	a3 48 41 80 00       	mov    %eax,0x804148
  802643:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802646:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802656:	a1 54 41 80 00       	mov    0x804154,%eax
  80265b:	48                   	dec    %eax
  80265c:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802664:	e9 ad 00 00 00       	jmp    802716 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	8b 40 0c             	mov    0xc(%eax),%eax
  80266f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802672:	0f 85 87 00 00 00    	jne    8026ff <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	75 17                	jne    802695 <alloc_block_FF+0x11d>
  80267e:	83 ec 04             	sub    $0x4,%esp
  802681:	68 69 3f 80 00       	push   $0x803f69
  802686:	68 87 00 00 00       	push   $0x87
  80268b:	68 f7 3e 80 00       	push   $0x803ef7
  802690:	e8 41 de ff ff       	call   8004d6 <_panic>
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	74 10                	je     8026ae <alloc_block_FF+0x136>
  80269e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a1:	8b 00                	mov    (%eax),%eax
  8026a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026a6:	8b 52 04             	mov    0x4(%edx),%edx
  8026a9:	89 50 04             	mov    %edx,0x4(%eax)
  8026ac:	eb 0b                	jmp    8026b9 <alloc_block_FF+0x141>
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 40 04             	mov    0x4(%eax),%eax
  8026b4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	74 0f                	je     8026d2 <alloc_block_FF+0x15a>
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 04             	mov    0x4(%eax),%eax
  8026c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026cc:	8b 12                	mov    (%edx),%edx
  8026ce:	89 10                	mov    %edx,(%eax)
  8026d0:	eb 0a                	jmp    8026dc <alloc_block_FF+0x164>
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 00                	mov    (%eax),%eax
  8026d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ef:	a1 44 41 80 00       	mov    0x804144,%eax
  8026f4:	48                   	dec    %eax
  8026f5:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	eb 17                	jmp    802716 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8026ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802702:	8b 00                	mov    (%eax),%eax
  802704:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802707:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270b:	0f 85 7a fe ff ff    	jne    80258b <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802711:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802716:	c9                   	leave  
  802717:	c3                   	ret    

00802718 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802718:	55                   	push   %ebp
  802719:	89 e5                	mov    %esp,%ebp
  80271b:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  80271e:	a1 38 41 80 00       	mov    0x804138,%eax
  802723:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802726:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  80272d:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802734:	a1 38 41 80 00       	mov    0x804138,%eax
  802739:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273c:	e9 d0 00 00 00       	jmp    802811 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802744:	8b 40 0c             	mov    0xc(%eax),%eax
  802747:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274a:	0f 82 b8 00 00 00    	jb     802808 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	8b 40 0c             	mov    0xc(%eax),%eax
  802756:	2b 45 08             	sub    0x8(%ebp),%eax
  802759:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80275c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80275f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802762:	0f 83 a1 00 00 00    	jae    802809 <alloc_block_BF+0xf1>
				differsize = differance ;
  802768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80276b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802774:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802778:	0f 85 8b 00 00 00    	jne    802809 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80277e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802782:	75 17                	jne    80279b <alloc_block_BF+0x83>
  802784:	83 ec 04             	sub    $0x4,%esp
  802787:	68 69 3f 80 00       	push   $0x803f69
  80278c:	68 a0 00 00 00       	push   $0xa0
  802791:	68 f7 3e 80 00       	push   $0x803ef7
  802796:	e8 3b dd ff ff       	call   8004d6 <_panic>
  80279b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279e:	8b 00                	mov    (%eax),%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	74 10                	je     8027b4 <alloc_block_BF+0x9c>
  8027a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ac:	8b 52 04             	mov    0x4(%edx),%edx
  8027af:	89 50 04             	mov    %edx,0x4(%eax)
  8027b2:	eb 0b                	jmp    8027bf <alloc_block_BF+0xa7>
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c2:	8b 40 04             	mov    0x4(%eax),%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	74 0f                	je     8027d8 <alloc_block_BF+0xc0>
  8027c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cc:	8b 40 04             	mov    0x4(%eax),%eax
  8027cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027d2:	8b 12                	mov    (%edx),%edx
  8027d4:	89 10                	mov    %edx,(%eax)
  8027d6:	eb 0a                	jmp    8027e2 <alloc_block_BF+0xca>
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f5:	a1 44 41 80 00       	mov    0x804144,%eax
  8027fa:	48                   	dec    %eax
  8027fb:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	e9 0c 01 00 00       	jmp    802914 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802808:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802809:	a1 40 41 80 00       	mov    0x804140,%eax
  80280e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802815:	74 07                	je     80281e <alloc_block_BF+0x106>
  802817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281a:	8b 00                	mov    (%eax),%eax
  80281c:	eb 05                	jmp    802823 <alloc_block_BF+0x10b>
  80281e:	b8 00 00 00 00       	mov    $0x0,%eax
  802823:	a3 40 41 80 00       	mov    %eax,0x804140
  802828:	a1 40 41 80 00       	mov    0x804140,%eax
  80282d:	85 c0                	test   %eax,%eax
  80282f:	0f 85 0c ff ff ff    	jne    802741 <alloc_block_BF+0x29>
  802835:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802839:	0f 85 02 ff ff ff    	jne    802741 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80283f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802843:	0f 84 c6 00 00 00    	je     80290f <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802849:	a1 48 41 80 00       	mov    0x804148,%eax
  80284e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802851:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802854:	8b 55 08             	mov    0x8(%ebp),%edx
  802857:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80285a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285d:	8b 50 08             	mov    0x8(%eax),%edx
  802860:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802863:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802866:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802869:	8b 40 0c             	mov    0xc(%eax),%eax
  80286c:	2b 45 08             	sub    0x8(%ebp),%eax
  80286f:	89 c2                	mov    %eax,%edx
  802871:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802874:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802877:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287a:	8b 50 08             	mov    0x8(%eax),%edx
  80287d:	8b 45 08             	mov    0x8(%ebp),%eax
  802880:	01 c2                	add    %eax,%edx
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802888:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80288c:	75 17                	jne    8028a5 <alloc_block_BF+0x18d>
  80288e:	83 ec 04             	sub    $0x4,%esp
  802891:	68 69 3f 80 00       	push   $0x803f69
  802896:	68 af 00 00 00       	push   $0xaf
  80289b:	68 f7 3e 80 00       	push   $0x803ef7
  8028a0:	e8 31 dc ff ff       	call   8004d6 <_panic>
  8028a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028a8:	8b 00                	mov    (%eax),%eax
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	74 10                	je     8028be <alloc_block_BF+0x1a6>
  8028ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028b6:	8b 52 04             	mov    0x4(%edx),%edx
  8028b9:	89 50 04             	mov    %edx,0x4(%eax)
  8028bc:	eb 0b                	jmp    8028c9 <alloc_block_BF+0x1b1>
  8028be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c1:	8b 40 04             	mov    0x4(%eax),%eax
  8028c4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028cc:	8b 40 04             	mov    0x4(%eax),%eax
  8028cf:	85 c0                	test   %eax,%eax
  8028d1:	74 0f                	je     8028e2 <alloc_block_BF+0x1ca>
  8028d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d6:	8b 40 04             	mov    0x4(%eax),%eax
  8028d9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8028dc:	8b 12                	mov    (%edx),%edx
  8028de:	89 10                	mov    %edx,(%eax)
  8028e0:	eb 0a                	jmp    8028ec <alloc_block_BF+0x1d4>
  8028e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ff:	a1 54 41 80 00       	mov    0x804154,%eax
  802904:	48                   	dec    %eax
  802905:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  80290a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80290d:	eb 05                	jmp    802914 <alloc_block_BF+0x1fc>
	}

	return NULL;
  80290f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802914:	c9                   	leave  
  802915:	c3                   	ret    

00802916 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802916:	55                   	push   %ebp
  802917:	89 e5                	mov    %esp,%ebp
  802919:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80291c:	a1 38 41 80 00       	mov    0x804138,%eax
  802921:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802924:	e9 7c 01 00 00       	jmp    802aa5 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802929:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292c:	8b 40 0c             	mov    0xc(%eax),%eax
  80292f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802932:	0f 86 cf 00 00 00    	jbe    802a07 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802938:	a1 48 41 80 00       	mov    0x804148,%eax
  80293d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802946:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802949:	8b 55 08             	mov    0x8(%ebp),%edx
  80294c:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802952:	8b 50 08             	mov    0x8(%eax),%edx
  802955:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802958:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 40 0c             	mov    0xc(%eax),%eax
  802961:	2b 45 08             	sub    0x8(%ebp),%eax
  802964:	89 c2                	mov    %eax,%edx
  802966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802969:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80296c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296f:	8b 50 08             	mov    0x8(%eax),%edx
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	01 c2                	add    %eax,%edx
  802977:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297a:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80297d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802981:	75 17                	jne    80299a <alloc_block_NF+0x84>
  802983:	83 ec 04             	sub    $0x4,%esp
  802986:	68 69 3f 80 00       	push   $0x803f69
  80298b:	68 c4 00 00 00       	push   $0xc4
  802990:	68 f7 3e 80 00       	push   $0x803ef7
  802995:	e8 3c db ff ff       	call   8004d6 <_panic>
  80299a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	74 10                	je     8029b3 <alloc_block_NF+0x9d>
  8029a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a6:	8b 00                	mov    (%eax),%eax
  8029a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029ab:	8b 52 04             	mov    0x4(%edx),%edx
  8029ae:	89 50 04             	mov    %edx,0x4(%eax)
  8029b1:	eb 0b                	jmp    8029be <alloc_block_NF+0xa8>
  8029b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b6:	8b 40 04             	mov    0x4(%eax),%eax
  8029b9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c1:	8b 40 04             	mov    0x4(%eax),%eax
  8029c4:	85 c0                	test   %eax,%eax
  8029c6:	74 0f                	je     8029d7 <alloc_block_NF+0xc1>
  8029c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cb:	8b 40 04             	mov    0x4(%eax),%eax
  8029ce:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8029d1:	8b 12                	mov    (%edx),%edx
  8029d3:	89 10                	mov    %edx,(%eax)
  8029d5:	eb 0a                	jmp    8029e1 <alloc_block_NF+0xcb>
  8029d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029da:	8b 00                	mov    (%eax),%eax
  8029dc:	a3 48 41 80 00       	mov    %eax,0x804148
  8029e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f4:	a1 54 41 80 00       	mov    0x804154,%eax
  8029f9:	48                   	dec    %eax
  8029fa:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8029ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a02:	e9 ad 00 00 00       	jmp    802ab4 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a10:	0f 85 87 00 00 00    	jne    802a9d <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802a16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a1a:	75 17                	jne    802a33 <alloc_block_NF+0x11d>
  802a1c:	83 ec 04             	sub    $0x4,%esp
  802a1f:	68 69 3f 80 00       	push   $0x803f69
  802a24:	68 c8 00 00 00       	push   $0xc8
  802a29:	68 f7 3e 80 00       	push   $0x803ef7
  802a2e:	e8 a3 da ff ff       	call   8004d6 <_panic>
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	8b 00                	mov    (%eax),%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	74 10                	je     802a4c <alloc_block_NF+0x136>
  802a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3f:	8b 00                	mov    (%eax),%eax
  802a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a44:	8b 52 04             	mov    0x4(%edx),%edx
  802a47:	89 50 04             	mov    %edx,0x4(%eax)
  802a4a:	eb 0b                	jmp    802a57 <alloc_block_NF+0x141>
  802a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4f:	8b 40 04             	mov    0x4(%eax),%eax
  802a52:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5a:	8b 40 04             	mov    0x4(%eax),%eax
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	74 0f                	je     802a70 <alloc_block_NF+0x15a>
  802a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a64:	8b 40 04             	mov    0x4(%eax),%eax
  802a67:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a6a:	8b 12                	mov    (%edx),%edx
  802a6c:	89 10                	mov    %edx,(%eax)
  802a6e:	eb 0a                	jmp    802a7a <alloc_block_NF+0x164>
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	8b 00                	mov    (%eax),%eax
  802a75:	a3 38 41 80 00       	mov    %eax,0x804138
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8d:	a1 44 41 80 00       	mov    0x804144,%eax
  802a92:	48                   	dec    %eax
  802a93:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802a98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9b:	eb 17                	jmp    802ab4 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 00                	mov    (%eax),%eax
  802aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802aa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802aa9:	0f 85 7a fe ff ff    	jne    802929 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802aaf:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802ab4:	c9                   	leave  
  802ab5:	c3                   	ret    

00802ab6 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802ab6:	55                   	push   %ebp
  802ab7:	89 e5                	mov    %esp,%ebp
  802ab9:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802abc:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802ac4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802acc:	a1 44 41 80 00       	mov    0x804144,%eax
  802ad1:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802ad4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ad8:	75 68                	jne    802b42 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802ada:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ade:	75 17                	jne    802af7 <insert_sorted_with_merge_freeList+0x41>
  802ae0:	83 ec 04             	sub    $0x4,%esp
  802ae3:	68 d4 3e 80 00       	push   $0x803ed4
  802ae8:	68 da 00 00 00       	push   $0xda
  802aed:	68 f7 3e 80 00       	push   $0x803ef7
  802af2:	e8 df d9 ff ff       	call   8004d6 <_panic>
  802af7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	89 10                	mov    %edx,(%eax)
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	74 0d                	je     802b18 <insert_sorted_with_merge_freeList+0x62>
  802b0b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b10:	8b 55 08             	mov    0x8(%ebp),%edx
  802b13:	89 50 04             	mov    %edx,0x4(%eax)
  802b16:	eb 08                	jmp    802b20 <insert_sorted_with_merge_freeList+0x6a>
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	a3 38 41 80 00       	mov    %eax,0x804138
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b32:	a1 44 41 80 00       	mov    0x804144,%eax
  802b37:	40                   	inc    %eax
  802b38:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802b3d:	e9 49 07 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b45:	8b 50 08             	mov    0x8(%eax),%edx
  802b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4e:	01 c2                	add    %eax,%edx
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	8b 40 08             	mov    0x8(%eax),%eax
  802b56:	39 c2                	cmp    %eax,%edx
  802b58:	73 77                	jae    802bd1 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b5d:	8b 00                	mov    (%eax),%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	75 6e                	jne    802bd1 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802b63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b67:	74 68                	je     802bd1 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802b69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b6d:	75 17                	jne    802b86 <insert_sorted_with_merge_freeList+0xd0>
  802b6f:	83 ec 04             	sub    $0x4,%esp
  802b72:	68 10 3f 80 00       	push   $0x803f10
  802b77:	68 e0 00 00 00       	push   $0xe0
  802b7c:	68 f7 3e 80 00       	push   $0x803ef7
  802b81:	e8 50 d9 ff ff       	call   8004d6 <_panic>
  802b86:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	89 50 04             	mov    %edx,0x4(%eax)
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	8b 40 04             	mov    0x4(%eax),%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	74 0c                	je     802ba8 <insert_sorted_with_merge_freeList+0xf2>
  802b9c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba4:	89 10                	mov    %edx,(%eax)
  802ba6:	eb 08                	jmp    802bb0 <insert_sorted_with_merge_freeList+0xfa>
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	a3 38 41 80 00       	mov    %eax,0x804138
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc1:	a1 44 41 80 00       	mov    0x804144,%eax
  802bc6:	40                   	inc    %eax
  802bc7:	a3 44 41 80 00       	mov    %eax,0x804144
  802bcc:	e9 ba 06 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bda:	8b 40 08             	mov    0x8(%eax),%eax
  802bdd:	01 c2                	add    %eax,%edx
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 40 08             	mov    0x8(%eax),%eax
  802be5:	39 c2                	cmp    %eax,%edx
  802be7:	73 78                	jae    802c61 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	8b 40 04             	mov    0x4(%eax),%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	75 6e                	jne    802c61 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802bf3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bf7:	74 68                	je     802c61 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802bf9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bfd:	75 17                	jne    802c16 <insert_sorted_with_merge_freeList+0x160>
  802bff:	83 ec 04             	sub    $0x4,%esp
  802c02:	68 d4 3e 80 00       	push   $0x803ed4
  802c07:	68 e6 00 00 00       	push   $0xe6
  802c0c:	68 f7 3e 80 00       	push   $0x803ef7
  802c11:	e8 c0 d8 ff ff       	call   8004d6 <_panic>
  802c16:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	89 10                	mov    %edx,(%eax)
  802c21:	8b 45 08             	mov    0x8(%ebp),%eax
  802c24:	8b 00                	mov    (%eax),%eax
  802c26:	85 c0                	test   %eax,%eax
  802c28:	74 0d                	je     802c37 <insert_sorted_with_merge_freeList+0x181>
  802c2a:	a1 38 41 80 00       	mov    0x804138,%eax
  802c2f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c32:	89 50 04             	mov    %edx,0x4(%eax)
  802c35:	eb 08                	jmp    802c3f <insert_sorted_with_merge_freeList+0x189>
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	a3 38 41 80 00       	mov    %eax,0x804138
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c51:	a1 44 41 80 00       	mov    0x804144,%eax
  802c56:	40                   	inc    %eax
  802c57:	a3 44 41 80 00       	mov    %eax,0x804144
  802c5c:	e9 2a 06 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802c61:	a1 38 41 80 00       	mov    0x804138,%eax
  802c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c69:	e9 ed 05 00 00       	jmp    80325b <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802c76:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802c7a:	0f 84 a7 00 00 00    	je     802d27 <insert_sorted_with_merge_freeList+0x271>
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 50 0c             	mov    0xc(%eax),%edx
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 40 08             	mov    0x8(%eax),%eax
  802c8c:	01 c2                	add    %eax,%edx
  802c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c91:	8b 40 08             	mov    0x8(%eax),%eax
  802c94:	39 c2                	cmp    %eax,%edx
  802c96:	0f 83 8b 00 00 00    	jae    802d27 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	8b 40 08             	mov    0x8(%eax),%eax
  802ca8:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802caa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cad:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802cb0:	39 c2                	cmp    %eax,%edx
  802cb2:	73 73                	jae    802d27 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802cb4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb8:	74 06                	je     802cc0 <insert_sorted_with_merge_freeList+0x20a>
  802cba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cbe:	75 17                	jne    802cd7 <insert_sorted_with_merge_freeList+0x221>
  802cc0:	83 ec 04             	sub    $0x4,%esp
  802cc3:	68 88 3f 80 00       	push   $0x803f88
  802cc8:	68 f0 00 00 00       	push   $0xf0
  802ccd:	68 f7 3e 80 00       	push   $0x803ef7
  802cd2:	e8 ff d7 ff ff       	call   8004d6 <_panic>
  802cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cda:	8b 10                	mov    (%eax),%edx
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	89 10                	mov    %edx,(%eax)
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	74 0b                	je     802cf5 <insert_sorted_with_merge_freeList+0x23f>
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 00                	mov    (%eax),%eax
  802cef:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf2:	89 50 04             	mov    %edx,0x4(%eax)
  802cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfb:	89 10                	mov    %edx,(%eax)
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d03:	89 50 04             	mov    %edx,0x4(%eax)
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	8b 00                	mov    (%eax),%eax
  802d0b:	85 c0                	test   %eax,%eax
  802d0d:	75 08                	jne    802d17 <insert_sorted_with_merge_freeList+0x261>
  802d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d12:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d17:	a1 44 41 80 00       	mov    0x804144,%eax
  802d1c:	40                   	inc    %eax
  802d1d:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802d22:	e9 64 05 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802d27:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d2c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d2f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d34:	8b 40 08             	mov    0x8(%eax),%eax
  802d37:	01 c2                	add    %eax,%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	8b 40 08             	mov    0x8(%eax),%eax
  802d3f:	39 c2                	cmp    %eax,%edx
  802d41:	0f 85 b1 00 00 00    	jne    802df8 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802d47:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d4c:	85 c0                	test   %eax,%eax
  802d4e:	0f 84 a4 00 00 00    	je     802df8 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802d54:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	0f 85 95 00 00 00    	jne    802df8 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802d63:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802d68:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802d6e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d71:	8b 55 08             	mov    0x8(%ebp),%edx
  802d74:	8b 52 0c             	mov    0xc(%edx),%edx
  802d77:	01 ca                	add    %ecx,%edx
  802d79:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d94:	75 17                	jne    802dad <insert_sorted_with_merge_freeList+0x2f7>
  802d96:	83 ec 04             	sub    $0x4,%esp
  802d99:	68 d4 3e 80 00       	push   $0x803ed4
  802d9e:	68 ff 00 00 00       	push   $0xff
  802da3:	68 f7 3e 80 00       	push   $0x803ef7
  802da8:	e8 29 d7 ff ff       	call   8004d6 <_panic>
  802dad:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	89 10                	mov    %edx,(%eax)
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 00                	mov    (%eax),%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	74 0d                	je     802dce <insert_sorted_with_merge_freeList+0x318>
  802dc1:	a1 48 41 80 00       	mov    0x804148,%eax
  802dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc9:	89 50 04             	mov    %edx,0x4(%eax)
  802dcc:	eb 08                	jmp    802dd6 <insert_sorted_with_merge_freeList+0x320>
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	a3 48 41 80 00       	mov    %eax,0x804148
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de8:	a1 54 41 80 00       	mov    0x804154,%eax
  802ded:	40                   	inc    %eax
  802dee:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802df3:	e9 93 04 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 50 08             	mov    0x8(%eax),%edx
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 40 0c             	mov    0xc(%eax),%eax
  802e04:	01 c2                	add    %eax,%edx
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	39 c2                	cmp    %eax,%edx
  802e0e:	0f 85 ae 00 00 00    	jne    802ec2 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 40 08             	mov    0x8(%eax),%eax
  802e20:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802e2a:	39 c2                	cmp    %eax,%edx
  802e2c:	0f 84 90 00 00 00    	je     802ec2 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	8b 50 0c             	mov    0xc(%eax),%edx
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3e:	01 c2                	add    %eax,%edx
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e50:	8b 45 08             	mov    0x8(%ebp),%eax
  802e53:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e5a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5e:	75 17                	jne    802e77 <insert_sorted_with_merge_freeList+0x3c1>
  802e60:	83 ec 04             	sub    $0x4,%esp
  802e63:	68 d4 3e 80 00       	push   $0x803ed4
  802e68:	68 0b 01 00 00       	push   $0x10b
  802e6d:	68 f7 3e 80 00       	push   $0x803ef7
  802e72:	e8 5f d6 ff ff       	call   8004d6 <_panic>
  802e77:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	89 10                	mov    %edx,(%eax)
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	85 c0                	test   %eax,%eax
  802e89:	74 0d                	je     802e98 <insert_sorted_with_merge_freeList+0x3e2>
  802e8b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e90:	8b 55 08             	mov    0x8(%ebp),%edx
  802e93:	89 50 04             	mov    %edx,0x4(%eax)
  802e96:	eb 08                	jmp    802ea0 <insert_sorted_with_merge_freeList+0x3ea>
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea3:	a3 48 41 80 00       	mov    %eax,0x804148
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb2:	a1 54 41 80 00       	mov    0x804154,%eax
  802eb7:	40                   	inc    %eax
  802eb8:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802ebd:	e9 c9 03 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	8b 40 08             	mov    0x8(%eax),%eax
  802ece:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ed6:	39 c2                	cmp    %eax,%edx
  802ed8:	0f 85 bb 00 00 00    	jne    802f99 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802ede:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee2:	0f 84 b1 00 00 00    	je     802f99 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eeb:	8b 40 04             	mov    0x4(%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	0f 85 a3 00 00 00    	jne    802f99 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ef6:	a1 38 41 80 00       	mov    0x804138,%eax
  802efb:	8b 55 08             	mov    0x8(%ebp),%edx
  802efe:	8b 52 08             	mov    0x8(%edx),%edx
  802f01:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802f04:	a1 38 41 80 00       	mov    0x804138,%eax
  802f09:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802f0f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f12:	8b 55 08             	mov    0x8(%ebp),%edx
  802f15:	8b 52 0c             	mov    0xc(%edx),%edx
  802f18:	01 ca                	add    %ecx,%edx
  802f1a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f35:	75 17                	jne    802f4e <insert_sorted_with_merge_freeList+0x498>
  802f37:	83 ec 04             	sub    $0x4,%esp
  802f3a:	68 d4 3e 80 00       	push   $0x803ed4
  802f3f:	68 17 01 00 00       	push   $0x117
  802f44:	68 f7 3e 80 00       	push   $0x803ef7
  802f49:	e8 88 d5 ff ff       	call   8004d6 <_panic>
  802f4e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f54:	8b 45 08             	mov    0x8(%ebp),%eax
  802f57:	89 10                	mov    %edx,(%eax)
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	85 c0                	test   %eax,%eax
  802f60:	74 0d                	je     802f6f <insert_sorted_with_merge_freeList+0x4b9>
  802f62:	a1 48 41 80 00       	mov    0x804148,%eax
  802f67:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6a:	89 50 04             	mov    %edx,0x4(%eax)
  802f6d:	eb 08                	jmp    802f77 <insert_sorted_with_merge_freeList+0x4c1>
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	a3 48 41 80 00       	mov    %eax,0x804148
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f89:	a1 54 41 80 00       	mov    0x804154,%eax
  802f8e:	40                   	inc    %eax
  802f8f:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802f94:	e9 f2 02 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	8b 50 08             	mov    0x8(%eax),%edx
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa5:	01 c2                	add    %eax,%edx
  802fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802faa:	8b 40 08             	mov    0x8(%eax),%eax
  802fad:	39 c2                	cmp    %eax,%edx
  802faf:	0f 85 be 00 00 00    	jne    803073 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb8:	8b 40 04             	mov    0x4(%eax),%eax
  802fbb:	8b 50 08             	mov    0x8(%eax),%edx
  802fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc1:	8b 40 04             	mov    0x4(%eax),%eax
  802fc4:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc7:	01 c2                	add    %eax,%edx
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	8b 40 08             	mov    0x8(%eax),%eax
  802fcf:	39 c2                	cmp    %eax,%edx
  802fd1:	0f 84 9c 00 00 00    	je     803073 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	8b 50 08             	mov    0x8(%eax),%edx
  802fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe0:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 50 0c             	mov    0xc(%eax),%edx
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	8b 40 0c             	mov    0xc(%eax),%eax
  802fef:	01 c2                	add    %eax,%edx
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803001:	8b 45 08             	mov    0x8(%ebp),%eax
  803004:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80300b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300f:	75 17                	jne    803028 <insert_sorted_with_merge_freeList+0x572>
  803011:	83 ec 04             	sub    $0x4,%esp
  803014:	68 d4 3e 80 00       	push   $0x803ed4
  803019:	68 26 01 00 00       	push   $0x126
  80301e:	68 f7 3e 80 00       	push   $0x803ef7
  803023:	e8 ae d4 ff ff       	call   8004d6 <_panic>
  803028:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80302e:	8b 45 08             	mov    0x8(%ebp),%eax
  803031:	89 10                	mov    %edx,(%eax)
  803033:	8b 45 08             	mov    0x8(%ebp),%eax
  803036:	8b 00                	mov    (%eax),%eax
  803038:	85 c0                	test   %eax,%eax
  80303a:	74 0d                	je     803049 <insert_sorted_with_merge_freeList+0x593>
  80303c:	a1 48 41 80 00       	mov    0x804148,%eax
  803041:	8b 55 08             	mov    0x8(%ebp),%edx
  803044:	89 50 04             	mov    %edx,0x4(%eax)
  803047:	eb 08                	jmp    803051 <insert_sorted_with_merge_freeList+0x59b>
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	a3 48 41 80 00       	mov    %eax,0x804148
  803059:	8b 45 08             	mov    0x8(%ebp),%eax
  80305c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803063:	a1 54 41 80 00       	mov    0x804154,%eax
  803068:	40                   	inc    %eax
  803069:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  80306e:	e9 18 02 00 00       	jmp    80328b <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803076:	8b 50 0c             	mov    0xc(%eax),%edx
  803079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307c:	8b 40 08             	mov    0x8(%eax),%eax
  80307f:	01 c2                	add    %eax,%edx
  803081:	8b 45 08             	mov    0x8(%ebp),%eax
  803084:	8b 40 08             	mov    0x8(%eax),%eax
  803087:	39 c2                	cmp    %eax,%edx
  803089:	0f 85 c4 01 00 00    	jne    803253 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  80308f:	8b 45 08             	mov    0x8(%ebp),%eax
  803092:	8b 50 0c             	mov    0xc(%eax),%edx
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	8b 40 08             	mov    0x8(%eax),%eax
  80309b:	01 c2                	add    %eax,%edx
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	8b 00                	mov    (%eax),%eax
  8030a2:	8b 40 08             	mov    0x8(%eax),%eax
  8030a5:	39 c2                	cmp    %eax,%edx
  8030a7:	0f 85 a6 01 00 00    	jne    803253 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8030ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b1:	0f 84 9c 01 00 00    	je     803253 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  8030b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c3:	01 c2                	add    %eax,%edx
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 00                	mov    (%eax),%eax
  8030ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8030cd:	01 c2                	add    %eax,%edx
  8030cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d2:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8030d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8030e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ed:	75 17                	jne    803106 <insert_sorted_with_merge_freeList+0x650>
  8030ef:	83 ec 04             	sub    $0x4,%esp
  8030f2:	68 d4 3e 80 00       	push   $0x803ed4
  8030f7:	68 32 01 00 00       	push   $0x132
  8030fc:	68 f7 3e 80 00       	push   $0x803ef7
  803101:	e8 d0 d3 ff ff       	call   8004d6 <_panic>
  803106:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	89 10                	mov    %edx,(%eax)
  803111:	8b 45 08             	mov    0x8(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	85 c0                	test   %eax,%eax
  803118:	74 0d                	je     803127 <insert_sorted_with_merge_freeList+0x671>
  80311a:	a1 48 41 80 00       	mov    0x804148,%eax
  80311f:	8b 55 08             	mov    0x8(%ebp),%edx
  803122:	89 50 04             	mov    %edx,0x4(%eax)
  803125:	eb 08                	jmp    80312f <insert_sorted_with_merge_freeList+0x679>
  803127:	8b 45 08             	mov    0x8(%ebp),%eax
  80312a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	a3 48 41 80 00       	mov    %eax,0x804148
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803141:	a1 54 41 80 00       	mov    0x804154,%eax
  803146:	40                   	inc    %eax
  803147:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 00                	mov    (%eax),%eax
  803151:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80315b:	8b 00                	mov    (%eax),%eax
  80315d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80316c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803170:	75 17                	jne    803189 <insert_sorted_with_merge_freeList+0x6d3>
  803172:	83 ec 04             	sub    $0x4,%esp
  803175:	68 69 3f 80 00       	push   $0x803f69
  80317a:	68 36 01 00 00       	push   $0x136
  80317f:	68 f7 3e 80 00       	push   $0x803ef7
  803184:	e8 4d d3 ff ff       	call   8004d6 <_panic>
  803189:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80318c:	8b 00                	mov    (%eax),%eax
  80318e:	85 c0                	test   %eax,%eax
  803190:	74 10                	je     8031a2 <insert_sorted_with_merge_freeList+0x6ec>
  803192:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803195:	8b 00                	mov    (%eax),%eax
  803197:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80319a:	8b 52 04             	mov    0x4(%edx),%edx
  80319d:	89 50 04             	mov    %edx,0x4(%eax)
  8031a0:	eb 0b                	jmp    8031ad <insert_sorted_with_merge_freeList+0x6f7>
  8031a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a5:	8b 40 04             	mov    0x4(%eax),%eax
  8031a8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8031ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031b0:	8b 40 04             	mov    0x4(%eax),%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	74 0f                	je     8031c6 <insert_sorted_with_merge_freeList+0x710>
  8031b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031c0:	8b 12                	mov    (%edx),%edx
  8031c2:	89 10                	mov    %edx,(%eax)
  8031c4:	eb 0a                	jmp    8031d0 <insert_sorted_with_merge_freeList+0x71a>
  8031c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031c9:	8b 00                	mov    (%eax),%eax
  8031cb:	a3 38 41 80 00       	mov    %eax,0x804138
  8031d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8031d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031e3:	a1 44 41 80 00       	mov    0x804144,%eax
  8031e8:	48                   	dec    %eax
  8031e9:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8031ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031f2:	75 17                	jne    80320b <insert_sorted_with_merge_freeList+0x755>
  8031f4:	83 ec 04             	sub    $0x4,%esp
  8031f7:	68 d4 3e 80 00       	push   $0x803ed4
  8031fc:	68 37 01 00 00       	push   $0x137
  803201:	68 f7 3e 80 00       	push   $0x803ef7
  803206:	e8 cb d2 ff ff       	call   8004d6 <_panic>
  80320b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803211:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803214:	89 10                	mov    %edx,(%eax)
  803216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803219:	8b 00                	mov    (%eax),%eax
  80321b:	85 c0                	test   %eax,%eax
  80321d:	74 0d                	je     80322c <insert_sorted_with_merge_freeList+0x776>
  80321f:	a1 48 41 80 00       	mov    0x804148,%eax
  803224:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803227:	89 50 04             	mov    %edx,0x4(%eax)
  80322a:	eb 08                	jmp    803234 <insert_sorted_with_merge_freeList+0x77e>
  80322c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803237:	a3 48 41 80 00       	mov    %eax,0x804148
  80323c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803246:	a1 54 41 80 00       	mov    0x804154,%eax
  80324b:	40                   	inc    %eax
  80324c:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  803251:	eb 38                	jmp    80328b <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803253:	a1 40 41 80 00       	mov    0x804140,%eax
  803258:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80325b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80325f:	74 07                	je     803268 <insert_sorted_with_merge_freeList+0x7b2>
  803261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803264:	8b 00                	mov    (%eax),%eax
  803266:	eb 05                	jmp    80326d <insert_sorted_with_merge_freeList+0x7b7>
  803268:	b8 00 00 00 00       	mov    $0x0,%eax
  80326d:	a3 40 41 80 00       	mov    %eax,0x804140
  803272:	a1 40 41 80 00       	mov    0x804140,%eax
  803277:	85 c0                	test   %eax,%eax
  803279:	0f 85 ef f9 ff ff    	jne    802c6e <insert_sorted_with_merge_freeList+0x1b8>
  80327f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803283:	0f 85 e5 f9 ff ff    	jne    802c6e <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803289:	eb 00                	jmp    80328b <insert_sorted_with_merge_freeList+0x7d5>
  80328b:	90                   	nop
  80328c:	c9                   	leave  
  80328d:	c3                   	ret    
  80328e:	66 90                	xchg   %ax,%ax

00803290 <__udivdi3>:
  803290:	55                   	push   %ebp
  803291:	57                   	push   %edi
  803292:	56                   	push   %esi
  803293:	53                   	push   %ebx
  803294:	83 ec 1c             	sub    $0x1c,%esp
  803297:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80329b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80329f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8032a7:	89 ca                	mov    %ecx,%edx
  8032a9:	89 f8                	mov    %edi,%eax
  8032ab:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8032af:	85 f6                	test   %esi,%esi
  8032b1:	75 2d                	jne    8032e0 <__udivdi3+0x50>
  8032b3:	39 cf                	cmp    %ecx,%edi
  8032b5:	77 65                	ja     80331c <__udivdi3+0x8c>
  8032b7:	89 fd                	mov    %edi,%ebp
  8032b9:	85 ff                	test   %edi,%edi
  8032bb:	75 0b                	jne    8032c8 <__udivdi3+0x38>
  8032bd:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c2:	31 d2                	xor    %edx,%edx
  8032c4:	f7 f7                	div    %edi
  8032c6:	89 c5                	mov    %eax,%ebp
  8032c8:	31 d2                	xor    %edx,%edx
  8032ca:	89 c8                	mov    %ecx,%eax
  8032cc:	f7 f5                	div    %ebp
  8032ce:	89 c1                	mov    %eax,%ecx
  8032d0:	89 d8                	mov    %ebx,%eax
  8032d2:	f7 f5                	div    %ebp
  8032d4:	89 cf                	mov    %ecx,%edi
  8032d6:	89 fa                	mov    %edi,%edx
  8032d8:	83 c4 1c             	add    $0x1c,%esp
  8032db:	5b                   	pop    %ebx
  8032dc:	5e                   	pop    %esi
  8032dd:	5f                   	pop    %edi
  8032de:	5d                   	pop    %ebp
  8032df:	c3                   	ret    
  8032e0:	39 ce                	cmp    %ecx,%esi
  8032e2:	77 28                	ja     80330c <__udivdi3+0x7c>
  8032e4:	0f bd fe             	bsr    %esi,%edi
  8032e7:	83 f7 1f             	xor    $0x1f,%edi
  8032ea:	75 40                	jne    80332c <__udivdi3+0x9c>
  8032ec:	39 ce                	cmp    %ecx,%esi
  8032ee:	72 0a                	jb     8032fa <__udivdi3+0x6a>
  8032f0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8032f4:	0f 87 9e 00 00 00    	ja     803398 <__udivdi3+0x108>
  8032fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ff:	89 fa                	mov    %edi,%edx
  803301:	83 c4 1c             	add    $0x1c,%esp
  803304:	5b                   	pop    %ebx
  803305:	5e                   	pop    %esi
  803306:	5f                   	pop    %edi
  803307:	5d                   	pop    %ebp
  803308:	c3                   	ret    
  803309:	8d 76 00             	lea    0x0(%esi),%esi
  80330c:	31 ff                	xor    %edi,%edi
  80330e:	31 c0                	xor    %eax,%eax
  803310:	89 fa                	mov    %edi,%edx
  803312:	83 c4 1c             	add    $0x1c,%esp
  803315:	5b                   	pop    %ebx
  803316:	5e                   	pop    %esi
  803317:	5f                   	pop    %edi
  803318:	5d                   	pop    %ebp
  803319:	c3                   	ret    
  80331a:	66 90                	xchg   %ax,%ax
  80331c:	89 d8                	mov    %ebx,%eax
  80331e:	f7 f7                	div    %edi
  803320:	31 ff                	xor    %edi,%edi
  803322:	89 fa                	mov    %edi,%edx
  803324:	83 c4 1c             	add    $0x1c,%esp
  803327:	5b                   	pop    %ebx
  803328:	5e                   	pop    %esi
  803329:	5f                   	pop    %edi
  80332a:	5d                   	pop    %ebp
  80332b:	c3                   	ret    
  80332c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803331:	89 eb                	mov    %ebp,%ebx
  803333:	29 fb                	sub    %edi,%ebx
  803335:	89 f9                	mov    %edi,%ecx
  803337:	d3 e6                	shl    %cl,%esi
  803339:	89 c5                	mov    %eax,%ebp
  80333b:	88 d9                	mov    %bl,%cl
  80333d:	d3 ed                	shr    %cl,%ebp
  80333f:	89 e9                	mov    %ebp,%ecx
  803341:	09 f1                	or     %esi,%ecx
  803343:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803347:	89 f9                	mov    %edi,%ecx
  803349:	d3 e0                	shl    %cl,%eax
  80334b:	89 c5                	mov    %eax,%ebp
  80334d:	89 d6                	mov    %edx,%esi
  80334f:	88 d9                	mov    %bl,%cl
  803351:	d3 ee                	shr    %cl,%esi
  803353:	89 f9                	mov    %edi,%ecx
  803355:	d3 e2                	shl    %cl,%edx
  803357:	8b 44 24 08          	mov    0x8(%esp),%eax
  80335b:	88 d9                	mov    %bl,%cl
  80335d:	d3 e8                	shr    %cl,%eax
  80335f:	09 c2                	or     %eax,%edx
  803361:	89 d0                	mov    %edx,%eax
  803363:	89 f2                	mov    %esi,%edx
  803365:	f7 74 24 0c          	divl   0xc(%esp)
  803369:	89 d6                	mov    %edx,%esi
  80336b:	89 c3                	mov    %eax,%ebx
  80336d:	f7 e5                	mul    %ebp
  80336f:	39 d6                	cmp    %edx,%esi
  803371:	72 19                	jb     80338c <__udivdi3+0xfc>
  803373:	74 0b                	je     803380 <__udivdi3+0xf0>
  803375:	89 d8                	mov    %ebx,%eax
  803377:	31 ff                	xor    %edi,%edi
  803379:	e9 58 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  80337e:	66 90                	xchg   %ax,%ax
  803380:	8b 54 24 08          	mov    0x8(%esp),%edx
  803384:	89 f9                	mov    %edi,%ecx
  803386:	d3 e2                	shl    %cl,%edx
  803388:	39 c2                	cmp    %eax,%edx
  80338a:	73 e9                	jae    803375 <__udivdi3+0xe5>
  80338c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80338f:	31 ff                	xor    %edi,%edi
  803391:	e9 40 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  803396:	66 90                	xchg   %ax,%ax
  803398:	31 c0                	xor    %eax,%eax
  80339a:	e9 37 ff ff ff       	jmp    8032d6 <__udivdi3+0x46>
  80339f:	90                   	nop

008033a0 <__umoddi3>:
  8033a0:	55                   	push   %ebp
  8033a1:	57                   	push   %edi
  8033a2:	56                   	push   %esi
  8033a3:	53                   	push   %ebx
  8033a4:	83 ec 1c             	sub    $0x1c,%esp
  8033a7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8033ab:	8b 74 24 34          	mov    0x34(%esp),%esi
  8033af:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033b3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8033b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8033bb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033bf:	89 f3                	mov    %esi,%ebx
  8033c1:	89 fa                	mov    %edi,%edx
  8033c3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033c7:	89 34 24             	mov    %esi,(%esp)
  8033ca:	85 c0                	test   %eax,%eax
  8033cc:	75 1a                	jne    8033e8 <__umoddi3+0x48>
  8033ce:	39 f7                	cmp    %esi,%edi
  8033d0:	0f 86 a2 00 00 00    	jbe    803478 <__umoddi3+0xd8>
  8033d6:	89 c8                	mov    %ecx,%eax
  8033d8:	89 f2                	mov    %esi,%edx
  8033da:	f7 f7                	div    %edi
  8033dc:	89 d0                	mov    %edx,%eax
  8033de:	31 d2                	xor    %edx,%edx
  8033e0:	83 c4 1c             	add    $0x1c,%esp
  8033e3:	5b                   	pop    %ebx
  8033e4:	5e                   	pop    %esi
  8033e5:	5f                   	pop    %edi
  8033e6:	5d                   	pop    %ebp
  8033e7:	c3                   	ret    
  8033e8:	39 f0                	cmp    %esi,%eax
  8033ea:	0f 87 ac 00 00 00    	ja     80349c <__umoddi3+0xfc>
  8033f0:	0f bd e8             	bsr    %eax,%ebp
  8033f3:	83 f5 1f             	xor    $0x1f,%ebp
  8033f6:	0f 84 ac 00 00 00    	je     8034a8 <__umoddi3+0x108>
  8033fc:	bf 20 00 00 00       	mov    $0x20,%edi
  803401:	29 ef                	sub    %ebp,%edi
  803403:	89 fe                	mov    %edi,%esi
  803405:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803409:	89 e9                	mov    %ebp,%ecx
  80340b:	d3 e0                	shl    %cl,%eax
  80340d:	89 d7                	mov    %edx,%edi
  80340f:	89 f1                	mov    %esi,%ecx
  803411:	d3 ef                	shr    %cl,%edi
  803413:	09 c7                	or     %eax,%edi
  803415:	89 e9                	mov    %ebp,%ecx
  803417:	d3 e2                	shl    %cl,%edx
  803419:	89 14 24             	mov    %edx,(%esp)
  80341c:	89 d8                	mov    %ebx,%eax
  80341e:	d3 e0                	shl    %cl,%eax
  803420:	89 c2                	mov    %eax,%edx
  803422:	8b 44 24 08          	mov    0x8(%esp),%eax
  803426:	d3 e0                	shl    %cl,%eax
  803428:	89 44 24 04          	mov    %eax,0x4(%esp)
  80342c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803430:	89 f1                	mov    %esi,%ecx
  803432:	d3 e8                	shr    %cl,%eax
  803434:	09 d0                	or     %edx,%eax
  803436:	d3 eb                	shr    %cl,%ebx
  803438:	89 da                	mov    %ebx,%edx
  80343a:	f7 f7                	div    %edi
  80343c:	89 d3                	mov    %edx,%ebx
  80343e:	f7 24 24             	mull   (%esp)
  803441:	89 c6                	mov    %eax,%esi
  803443:	89 d1                	mov    %edx,%ecx
  803445:	39 d3                	cmp    %edx,%ebx
  803447:	0f 82 87 00 00 00    	jb     8034d4 <__umoddi3+0x134>
  80344d:	0f 84 91 00 00 00    	je     8034e4 <__umoddi3+0x144>
  803453:	8b 54 24 04          	mov    0x4(%esp),%edx
  803457:	29 f2                	sub    %esi,%edx
  803459:	19 cb                	sbb    %ecx,%ebx
  80345b:	89 d8                	mov    %ebx,%eax
  80345d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803461:	d3 e0                	shl    %cl,%eax
  803463:	89 e9                	mov    %ebp,%ecx
  803465:	d3 ea                	shr    %cl,%edx
  803467:	09 d0                	or     %edx,%eax
  803469:	89 e9                	mov    %ebp,%ecx
  80346b:	d3 eb                	shr    %cl,%ebx
  80346d:	89 da                	mov    %ebx,%edx
  80346f:	83 c4 1c             	add    $0x1c,%esp
  803472:	5b                   	pop    %ebx
  803473:	5e                   	pop    %esi
  803474:	5f                   	pop    %edi
  803475:	5d                   	pop    %ebp
  803476:	c3                   	ret    
  803477:	90                   	nop
  803478:	89 fd                	mov    %edi,%ebp
  80347a:	85 ff                	test   %edi,%edi
  80347c:	75 0b                	jne    803489 <__umoddi3+0xe9>
  80347e:	b8 01 00 00 00       	mov    $0x1,%eax
  803483:	31 d2                	xor    %edx,%edx
  803485:	f7 f7                	div    %edi
  803487:	89 c5                	mov    %eax,%ebp
  803489:	89 f0                	mov    %esi,%eax
  80348b:	31 d2                	xor    %edx,%edx
  80348d:	f7 f5                	div    %ebp
  80348f:	89 c8                	mov    %ecx,%eax
  803491:	f7 f5                	div    %ebp
  803493:	89 d0                	mov    %edx,%eax
  803495:	e9 44 ff ff ff       	jmp    8033de <__umoddi3+0x3e>
  80349a:	66 90                	xchg   %ax,%ax
  80349c:	89 c8                	mov    %ecx,%eax
  80349e:	89 f2                	mov    %esi,%edx
  8034a0:	83 c4 1c             	add    $0x1c,%esp
  8034a3:	5b                   	pop    %ebx
  8034a4:	5e                   	pop    %esi
  8034a5:	5f                   	pop    %edi
  8034a6:	5d                   	pop    %ebp
  8034a7:	c3                   	ret    
  8034a8:	3b 04 24             	cmp    (%esp),%eax
  8034ab:	72 06                	jb     8034b3 <__umoddi3+0x113>
  8034ad:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8034b1:	77 0f                	ja     8034c2 <__umoddi3+0x122>
  8034b3:	89 f2                	mov    %esi,%edx
  8034b5:	29 f9                	sub    %edi,%ecx
  8034b7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8034bb:	89 14 24             	mov    %edx,(%esp)
  8034be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034c2:	8b 44 24 04          	mov    0x4(%esp),%eax
  8034c6:	8b 14 24             	mov    (%esp),%edx
  8034c9:	83 c4 1c             	add    $0x1c,%esp
  8034cc:	5b                   	pop    %ebx
  8034cd:	5e                   	pop    %esi
  8034ce:	5f                   	pop    %edi
  8034cf:	5d                   	pop    %ebp
  8034d0:	c3                   	ret    
  8034d1:	8d 76 00             	lea    0x0(%esi),%esi
  8034d4:	2b 04 24             	sub    (%esp),%eax
  8034d7:	19 fa                	sbb    %edi,%edx
  8034d9:	89 d1                	mov    %edx,%ecx
  8034db:	89 c6                	mov    %eax,%esi
  8034dd:	e9 71 ff ff ff       	jmp    803453 <__umoddi3+0xb3>
  8034e2:	66 90                	xchg   %ax,%ax
  8034e4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8034e8:	72 ea                	jb     8034d4 <__umoddi3+0x134>
  8034ea:	89 d9                	mov    %ebx,%ecx
  8034ec:	e9 62 ff ff ff       	jmp    803453 <__umoddi3+0xb3>
