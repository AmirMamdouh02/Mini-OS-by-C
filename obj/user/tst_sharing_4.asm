
obj/user/tst_sharing_4:     file format elf32-i386


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
  800031:	e8 41 05 00 00       	call   800577 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables (create_shared_memory)
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
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
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
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
  80008d:	68 e0 36 80 00       	push   $0x8036e0
  800092:	6a 12                	push   $0x12
  800094:	68 fc 36 80 00       	push   $0x8036fc
  800099:	e8 15 06 00 00       	call   8006b3 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 5e 18 00 00       	call   801906 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 14 37 80 00       	push   $0x803714
  8000b3:	e8 af 08 00 00       	call   800967 <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 48 37 80 00       	push   $0x803748
  8000c3:	e8 9f 08 00 00       	call   800967 <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 a4 37 80 00       	push   $0x8037a4
  8000d3:	e8 8f 08 00 00       	call   800967 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000db:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000e2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000e9:	e8 7d 1f 00 00       	call   80206b <sys_getenvid>
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000f1:	83 ec 0c             	sub    $0xc,%esp
  8000f4:	68 d8 37 80 00       	push   $0x8037d8
  8000f9:	e8 69 08 00 00       	call   800967 <cprintf>
  8000fe:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  800101:	e8 9e 1c 00 00       	call   801da4 <sys_calculate_free_frames>
  800106:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	6a 01                	push   $0x1
  80010e:	68 00 10 00 00       	push   $0x1000
  800113:	68 07 38 80 00       	push   $0x803807
  800118:	e8 64 19 00 00       	call   801a81 <smalloc>
  80011d:	83 c4 10             	add    $0x10,%esp
  800120:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800123:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80012a:	74 14                	je     800140 <_main+0x108>
  80012c:	83 ec 04             	sub    $0x4,%esp
  80012f:	68 0c 38 80 00       	push   $0x80380c
  800134:	6a 24                	push   $0x24
  800136:	68 fc 36 80 00       	push   $0x8036fc
  80013b:	e8 73 05 00 00       	call   8006b3 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800140:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800143:	e8 5c 1c 00 00       	call   801da4 <sys_calculate_free_frames>
  800148:	29 c3                	sub    %eax,%ebx
  80014a:	89 d8                	mov    %ebx,%eax
  80014c:	83 f8 04             	cmp    $0x4,%eax
  80014f:	74 14                	je     800165 <_main+0x12d>
  800151:	83 ec 04             	sub    $0x4,%esp
  800154:	68 78 38 80 00       	push   $0x803878
  800159:	6a 25                	push   $0x25
  80015b:	68 fc 36 80 00       	push   $0x8036fc
  800160:	e8 4e 05 00 00       	call   8006b3 <_panic>

		sfree(x);
  800165:	83 ec 0c             	sub    $0xc,%esp
  800168:	ff 75 dc             	pushl  -0x24(%ebp)
  80016b:	e8 d4 1a 00 00       	call   801c44 <sfree>
  800170:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800173:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800176:	e8 29 1c 00 00       	call   801da4 <sys_calculate_free_frames>
  80017b:	29 c3                	sub    %eax,%ebx
  80017d:	89 d8                	mov    %ebx,%eax
  80017f:	83 f8 02             	cmp    $0x2,%eax
  800182:	75 14                	jne    800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 f8 38 80 00       	push   $0x8038f8
  80018c:	6a 28                	push   $0x28
  80018e:	68 fc 36 80 00       	push   $0x8036fc
  800193:	e8 1b 05 00 00       	call   8006b3 <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  800198:	e8 07 1c 00 00       	call   801da4 <sys_calculate_free_frames>
  80019d:	89 c2                	mov    %eax,%edx
  80019f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a2:	39 c2                	cmp    %eax,%edx
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 50 39 80 00       	push   $0x803950
  8001ae:	6a 29                	push   $0x29
  8001b0:	68 fc 36 80 00       	push   $0x8036fc
  8001b5:	e8 f9 04 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	68 80 39 80 00       	push   $0x803980
  8001c2:	e8 a0 07 00 00       	call   800967 <cprintf>
  8001c7:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 a4 39 80 00       	push   $0x8039a4
  8001d2:	e8 90 07 00 00       	call   800967 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001da:	e8 c5 1b 00 00       	call   801da4 <sys_calculate_free_frames>
  8001df:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	6a 01                	push   $0x1
  8001e7:	68 00 10 00 00       	push   $0x1000
  8001ec:	68 d4 39 80 00       	push   $0x8039d4
  8001f1:	e8 8b 18 00 00       	call   801a81 <smalloc>
  8001f6:	83 c4 10             	add    $0x10,%esp
  8001f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001fc:	83 ec 04             	sub    $0x4,%esp
  8001ff:	6a 01                	push   $0x1
  800201:	68 00 10 00 00       	push   $0x1000
  800206:	68 07 38 80 00       	push   $0x803807
  80020b:	e8 71 18 00 00       	call   801a81 <smalloc>
  800210:	83 c4 10             	add    $0x10,%esp
  800213:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800216:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80021a:	75 14                	jne    800230 <_main+0x1f8>
  80021c:	83 ec 04             	sub    $0x4,%esp
  80021f:	68 f8 38 80 00       	push   $0x8038f8
  800224:	6a 35                	push   $0x35
  800226:	68 fc 36 80 00       	push   $0x8036fc
  80022b:	e8 83 04 00 00       	call   8006b3 <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800230:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800233:	e8 6c 1b 00 00       	call   801da4 <sys_calculate_free_frames>
  800238:	29 c3                	sub    %eax,%ebx
  80023a:	89 d8                	mov    %ebx,%eax
  80023c:	83 f8 07             	cmp    $0x7,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 d8 39 80 00       	push   $0x8039d8
  800249:	6a 37                	push   $0x37
  80024b:	68 fc 36 80 00       	push   $0x8036fc
  800250:	e8 5e 04 00 00       	call   8006b3 <_panic>

		sfree(z);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	ff 75 d4             	pushl  -0x2c(%ebp)
  80025b:	e8 e4 19 00 00       	call   801c44 <sfree>
  800260:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800263:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800266:	e8 39 1b 00 00       	call   801da4 <sys_calculate_free_frames>
  80026b:	29 c3                	sub    %eax,%ebx
  80026d:	89 d8                	mov    %ebx,%eax
  80026f:	83 f8 04             	cmp    $0x4,%eax
  800272:	74 14                	je     800288 <_main+0x250>
  800274:	83 ec 04             	sub    $0x4,%esp
  800277:	68 2d 3a 80 00       	push   $0x803a2d
  80027c:	6a 3a                	push   $0x3a
  80027e:	68 fc 36 80 00       	push   $0x8036fc
  800283:	e8 2b 04 00 00       	call   8006b3 <_panic>

		sfree(x);
  800288:	83 ec 0c             	sub    $0xc,%esp
  80028b:	ff 75 d0             	pushl  -0x30(%ebp)
  80028e:	e8 b1 19 00 00       	call   801c44 <sfree>
  800293:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800296:	e8 09 1b 00 00       	call   801da4 <sys_calculate_free_frames>
  80029b:	89 c2                	mov    %eax,%edx
  80029d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a0:	39 c2                	cmp    %eax,%edx
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 2d 3a 80 00       	push   $0x803a2d
  8002ac:	6a 3d                	push   $0x3d
  8002ae:	68 fc 36 80 00       	push   $0x8036fc
  8002b3:	e8 fb 03 00 00       	call   8006b3 <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002b8:	83 ec 0c             	sub    $0xc,%esp
  8002bb:	68 4c 3a 80 00       	push   $0x803a4c
  8002c0:	e8 a2 06 00 00       	call   800967 <cprintf>
  8002c5:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	68 70 3a 80 00       	push   $0x803a70
  8002d0:	e8 92 06 00 00       	call   800967 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002d8:	e8 c7 1a 00 00       	call   801da4 <sys_calculate_free_frames>
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	6a 01                	push   $0x1
  8002e5:	68 01 30 00 00       	push   $0x3001
  8002ea:	68 a0 3a 80 00       	push   $0x803aa0
  8002ef:	e8 8d 17 00 00       	call   801a81 <smalloc>
  8002f4:	83 c4 10             	add    $0x10,%esp
  8002f7:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002fa:	83 ec 04             	sub    $0x4,%esp
  8002fd:	6a 01                	push   $0x1
  8002ff:	68 00 10 00 00       	push   $0x1000
  800304:	68 a2 3a 80 00       	push   $0x803aa2
  800309:	e8 73 17 00 00       	call   801a81 <smalloc>
  80030e:	83 c4 10             	add    $0x10,%esp
  800311:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800314:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800317:	e8 88 1a 00 00       	call   801da4 <sys_calculate_free_frames>
  80031c:	29 c3                	sub    %eax,%ebx
  80031e:	89 d8                	mov    %ebx,%eax
  800320:	83 f8 0a             	cmp    $0xa,%eax
  800323:	74 14                	je     800339 <_main+0x301>
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	68 78 38 80 00       	push   $0x803878
  80032d:	6a 48                	push   $0x48
  80032f:	68 fc 36 80 00       	push   $0x8036fc
  800334:	e8 7a 03 00 00       	call   8006b3 <_panic>

		sfree(w);
  800339:	83 ec 0c             	sub    $0xc,%esp
  80033c:	ff 75 c8             	pushl  -0x38(%ebp)
  80033f:	e8 00 19 00 00       	call   801c44 <sfree>
  800344:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800347:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80034a:	e8 55 1a 00 00       	call   801da4 <sys_calculate_free_frames>
  80034f:	29 c3                	sub    %eax,%ebx
  800351:	89 d8                	mov    %ebx,%eax
  800353:	83 f8 04             	cmp    $0x4,%eax
  800356:	74 14                	je     80036c <_main+0x334>
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 2d 3a 80 00       	push   $0x803a2d
  800360:	6a 4b                	push   $0x4b
  800362:	68 fc 36 80 00       	push   $0x8036fc
  800367:	e8 47 03 00 00       	call   8006b3 <_panic>

		uint32 *o;

		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80036c:	83 ec 04             	sub    $0x4,%esp
  80036f:	6a 01                	push   $0x1
  800371:	68 ff 1f 00 00       	push   $0x1fff
  800376:	68 a4 3a 80 00       	push   $0x803aa4
  80037b:	e8 01 17 00 00       	call   801a81 <smalloc>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	89 45 c0             	mov    %eax,-0x40(%ebp)

		cprintf("2\n");
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	68 a6 3a 80 00       	push   $0x803aa6
  80038e:	e8 d4 05 00 00       	call   800967 <cprintf>
  800393:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800396:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800399:	e8 06 1a 00 00       	call   801da4 <sys_calculate_free_frames>
  80039e:	29 c3                	sub    %eax,%ebx
  8003a0:	89 d8                	mov    %ebx,%eax
  8003a2:	83 f8 08             	cmp    $0x8,%eax
  8003a5:	74 14                	je     8003bb <_main+0x383>
  8003a7:	83 ec 04             	sub    $0x4,%esp
  8003aa:	68 78 38 80 00       	push   $0x803878
  8003af:	6a 52                	push   $0x52
  8003b1:	68 fc 36 80 00       	push   $0x8036fc
  8003b6:	e8 f8 02 00 00       	call   8006b3 <_panic>

		sfree(o);
  8003bb:	83 ec 0c             	sub    $0xc,%esp
  8003be:	ff 75 c0             	pushl  -0x40(%ebp)
  8003c1:	e8 7e 18 00 00       	call   801c44 <sfree>
  8003c6:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003c9:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003cc:	e8 d3 19 00 00       	call   801da4 <sys_calculate_free_frames>
  8003d1:	29 c3                	sub    %eax,%ebx
  8003d3:	89 d8                	mov    %ebx,%eax
  8003d5:	83 f8 04             	cmp    $0x4,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 2d 3a 80 00       	push   $0x803a2d
  8003e2:	6a 55                	push   $0x55
  8003e4:	68 fc 36 80 00       	push   $0x8036fc
  8003e9:	e8 c5 02 00 00       	call   8006b3 <_panic>

		sfree(u);
  8003ee:	83 ec 0c             	sub    $0xc,%esp
  8003f1:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003f4:	e8 4b 18 00 00       	call   801c44 <sfree>
  8003f9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003fc:	e8 a3 19 00 00       	call   801da4 <sys_calculate_free_frames>
  800401:	89 c2                	mov    %eax,%edx
  800403:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 2d 3a 80 00       	push   $0x803a2d
  800412:	6a 58                	push   $0x58
  800414:	68 fc 36 80 00       	push   $0x8036fc
  800419:	e8 95 02 00 00       	call   8006b3 <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  80041e:	e8 81 19 00 00       	call   801da4 <sys_calculate_free_frames>
  800423:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800429:	89 c2                	mov    %eax,%edx
  80042b:	01 d2                	add    %edx,%edx
  80042d:	01 d0                	add    %edx,%eax
  80042f:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800432:	83 ec 04             	sub    $0x4,%esp
  800435:	6a 01                	push   $0x1
  800437:	50                   	push   %eax
  800438:	68 a0 3a 80 00       	push   $0x803aa0
  80043d:	e8 3f 16 00 00       	call   801a81 <smalloc>
  800442:	83 c4 10             	add    $0x10,%esp
  800445:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  800448:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80044b:	89 d0                	mov    %edx,%eax
  80044d:	01 c0                	add    %eax,%eax
  80044f:	01 d0                	add    %edx,%eax
  800451:	01 c0                	add    %eax,%eax
  800453:	01 d0                	add    %edx,%eax
  800455:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800458:	83 ec 04             	sub    $0x4,%esp
  80045b:	6a 01                	push   $0x1
  80045d:	50                   	push   %eax
  80045e:	68 a2 3a 80 00       	push   $0x803aa2
  800463:	e8 19 16 00 00       	call   801a81 <smalloc>
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  80046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800471:	01 c0                	add    %eax,%eax
  800473:	89 c2                	mov    %eax,%edx
  800475:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800478:	01 d0                	add    %edx,%eax
  80047a:	83 ec 04             	sub    $0x4,%esp
  80047d:	6a 01                	push   $0x1
  80047f:	50                   	push   %eax
  800480:	68 a4 3a 80 00       	push   $0x803aa4
  800485:	e8 f7 15 00 00       	call   801a81 <smalloc>
  80048a:	83 c4 10             	add    $0x10,%esp
  80048d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800490:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800493:	e8 0c 19 00 00       	call   801da4 <sys_calculate_free_frames>
  800498:	29 c3                	sub    %eax,%ebx
  80049a:	89 d8                	mov    %ebx,%eax
  80049c:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  8004a1:	74 14                	je     8004b7 <_main+0x47f>
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 78 38 80 00       	push   $0x803878
  8004ab:	6a 61                	push   $0x61
  8004ad:	68 fc 36 80 00       	push   $0x8036fc
  8004b2:	e8 fc 01 00 00       	call   8006b3 <_panic>

		sfree(o);
  8004b7:	83 ec 0c             	sub    $0xc,%esp
  8004ba:	ff 75 c0             	pushl  -0x40(%ebp)
  8004bd:	e8 82 17 00 00       	call   801c44 <sfree>
  8004c2:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004c5:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004c8:	e8 d7 18 00 00       	call   801da4 <sys_calculate_free_frames>
  8004cd:	29 c3                	sub    %eax,%ebx
  8004cf:	89 d8                	mov    %ebx,%eax
  8004d1:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004d6:	74 14                	je     8004ec <_main+0x4b4>
  8004d8:	83 ec 04             	sub    $0x4,%esp
  8004db:	68 2d 3a 80 00       	push   $0x803a2d
  8004e0:	6a 64                	push   $0x64
  8004e2:	68 fc 36 80 00       	push   $0x8036fc
  8004e7:	e8 c7 01 00 00       	call   8006b3 <_panic>

		sfree(w);
  8004ec:	83 ec 0c             	sub    $0xc,%esp
  8004ef:	ff 75 c8             	pushl  -0x38(%ebp)
  8004f2:	e8 4d 17 00 00       	call   801c44 <sfree>
  8004f7:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004fa:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004fd:	e8 a2 18 00 00       	call   801da4 <sys_calculate_free_frames>
  800502:	29 c3                	sub    %eax,%ebx
  800504:	89 d8                	mov    %ebx,%eax
  800506:	3d 06 07 00 00       	cmp    $0x706,%eax
  80050b:	74 14                	je     800521 <_main+0x4e9>
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	68 2d 3a 80 00       	push   $0x803a2d
  800515:	6a 67                	push   $0x67
  800517:	68 fc 36 80 00       	push   $0x8036fc
  80051c:	e8 92 01 00 00       	call   8006b3 <_panic>

		sfree(u);
  800521:	83 ec 0c             	sub    $0xc,%esp
  800524:	ff 75 c4             	pushl  -0x3c(%ebp)
  800527:	e8 18 17 00 00       	call   801c44 <sfree>
  80052c:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  80052f:	e8 70 18 00 00       	call   801da4 <sys_calculate_free_frames>
  800534:	89 c2                	mov    %eax,%edx
  800536:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800539:	39 c2                	cmp    %eax,%edx
  80053b:	74 14                	je     800551 <_main+0x519>
  80053d:	83 ec 04             	sub    $0x4,%esp
  800540:	68 2d 3a 80 00       	push   $0x803a2d
  800545:	6a 6a                	push   $0x6a
  800547:	68 fc 36 80 00       	push   $0x8036fc
  80054c:	e8 62 01 00 00       	call   8006b3 <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800551:	83 ec 0c             	sub    $0xc,%esp
  800554:	68 ac 3a 80 00       	push   $0x803aac
  800559:	e8 09 04 00 00       	call   800967 <cprintf>
  80055e:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800561:	83 ec 0c             	sub    $0xc,%esp
  800564:	68 d0 3a 80 00       	push   $0x803ad0
  800569:	e8 f9 03 00 00       	call   800967 <cprintf>
  80056e:	83 c4 10             	add    $0x10,%esp

	return;
  800571:	90                   	nop
}
  800572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800575:	c9                   	leave  
  800576:	c3                   	ret    

00800577 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800577:	55                   	push   %ebp
  800578:	89 e5                	mov    %esp,%ebp
  80057a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80057d:	e8 02 1b 00 00       	call   802084 <sys_getenvindex>
  800582:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800588:	89 d0                	mov    %edx,%eax
  80058a:	c1 e0 03             	shl    $0x3,%eax
  80058d:	01 d0                	add    %edx,%eax
  80058f:	01 c0                	add    %eax,%eax
  800591:	01 d0                	add    %edx,%eax
  800593:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80059a:	01 d0                	add    %edx,%eax
  80059c:	c1 e0 04             	shl    $0x4,%eax
  80059f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005a4:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005a9:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ae:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005b4:	84 c0                	test   %al,%al
  8005b6:	74 0f                	je     8005c7 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8005bd:	05 5c 05 00 00       	add    $0x55c,%eax
  8005c2:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005cb:	7e 0a                	jle    8005d7 <libmain+0x60>
		binaryname = argv[0];
  8005cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005d7:	83 ec 08             	sub    $0x8,%esp
  8005da:	ff 75 0c             	pushl  0xc(%ebp)
  8005dd:	ff 75 08             	pushl  0x8(%ebp)
  8005e0:	e8 53 fa ff ff       	call   800038 <_main>
  8005e5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8005e8:	e8 a4 18 00 00       	call   801e91 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8005ed:	83 ec 0c             	sub    $0xc,%esp
  8005f0:	68 34 3b 80 00       	push   $0x803b34
  8005f5:	e8 6d 03 00 00       	call   800967 <cprintf>
  8005fa:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8005fd:	a1 20 50 80 00       	mov    0x805020,%eax
  800602:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800608:	a1 20 50 80 00       	mov    0x805020,%eax
  80060d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	68 5c 3b 80 00       	push   $0x803b5c
  80061d:	e8 45 03 00 00       	call   800967 <cprintf>
  800622:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800630:	a1 20 50 80 00       	mov    0x805020,%eax
  800635:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80063b:	a1 20 50 80 00       	mov    0x805020,%eax
  800640:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800646:	51                   	push   %ecx
  800647:	52                   	push   %edx
  800648:	50                   	push   %eax
  800649:	68 84 3b 80 00       	push   $0x803b84
  80064e:	e8 14 03 00 00       	call   800967 <cprintf>
  800653:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800656:	a1 20 50 80 00       	mov    0x805020,%eax
  80065b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800661:	83 ec 08             	sub    $0x8,%esp
  800664:	50                   	push   %eax
  800665:	68 dc 3b 80 00       	push   $0x803bdc
  80066a:	e8 f8 02 00 00       	call   800967 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800672:	83 ec 0c             	sub    $0xc,%esp
  800675:	68 34 3b 80 00       	push   $0x803b34
  80067a:	e8 e8 02 00 00       	call   800967 <cprintf>
  80067f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800682:	e8 24 18 00 00       	call   801eab <sys_enable_interrupt>

	// exit gracefully
	exit();
  800687:	e8 19 00 00 00       	call   8006a5 <exit>
}
  80068c:	90                   	nop
  80068d:	c9                   	leave  
  80068e:	c3                   	ret    

0080068f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80068f:	55                   	push   %ebp
  800690:	89 e5                	mov    %esp,%ebp
  800692:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800695:	83 ec 0c             	sub    $0xc,%esp
  800698:	6a 00                	push   $0x0
  80069a:	e8 b1 19 00 00       	call   802050 <sys_destroy_env>
  80069f:	83 c4 10             	add    $0x10,%esp
}
  8006a2:	90                   	nop
  8006a3:	c9                   	leave  
  8006a4:	c3                   	ret    

008006a5 <exit>:

void
exit(void)
{
  8006a5:	55                   	push   %ebp
  8006a6:	89 e5                	mov    %esp,%ebp
  8006a8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006ab:	e8 06 1a 00 00       	call   8020b6 <sys_exit_env>
}
  8006b0:	90                   	nop
  8006b1:	c9                   	leave  
  8006b2:	c3                   	ret    

008006b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006b3:	55                   	push   %ebp
  8006b4:	89 e5                	mov    %esp,%ebp
  8006b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8006bc:	83 c0 04             	add    $0x4,%eax
  8006bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006c2:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006c7:	85 c0                	test   %eax,%eax
  8006c9:	74 16                	je     8006e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006cb:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006d0:	83 ec 08             	sub    $0x8,%esp
  8006d3:	50                   	push   %eax
  8006d4:	68 f0 3b 80 00       	push   $0x803bf0
  8006d9:	e8 89 02 00 00       	call   800967 <cprintf>
  8006de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006e1:	a1 00 50 80 00       	mov    0x805000,%eax
  8006e6:	ff 75 0c             	pushl  0xc(%ebp)
  8006e9:	ff 75 08             	pushl  0x8(%ebp)
  8006ec:	50                   	push   %eax
  8006ed:	68 f5 3b 80 00       	push   $0x803bf5
  8006f2:	e8 70 02 00 00       	call   800967 <cprintf>
  8006f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8006fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8006fd:	83 ec 08             	sub    $0x8,%esp
  800700:	ff 75 f4             	pushl  -0xc(%ebp)
  800703:	50                   	push   %eax
  800704:	e8 f3 01 00 00       	call   8008fc <vcprintf>
  800709:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80070c:	83 ec 08             	sub    $0x8,%esp
  80070f:	6a 00                	push   $0x0
  800711:	68 11 3c 80 00       	push   $0x803c11
  800716:	e8 e1 01 00 00       	call   8008fc <vcprintf>
  80071b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80071e:	e8 82 ff ff ff       	call   8006a5 <exit>

	// should not return here
	while (1) ;
  800723:	eb fe                	jmp    800723 <_panic+0x70>

00800725 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80072b:	a1 20 50 80 00       	mov    0x805020,%eax
  800730:	8b 50 74             	mov    0x74(%eax),%edx
  800733:	8b 45 0c             	mov    0xc(%ebp),%eax
  800736:	39 c2                	cmp    %eax,%edx
  800738:	74 14                	je     80074e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80073a:	83 ec 04             	sub    $0x4,%esp
  80073d:	68 14 3c 80 00       	push   $0x803c14
  800742:	6a 26                	push   $0x26
  800744:	68 60 3c 80 00       	push   $0x803c60
  800749:	e8 65 ff ff ff       	call   8006b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80074e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800755:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80075c:	e9 c2 00 00 00       	jmp    800823 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800764:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	01 d0                	add    %edx,%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	85 c0                	test   %eax,%eax
  800774:	75 08                	jne    80077e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800776:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800779:	e9 a2 00 00 00       	jmp    800820 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80077e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800785:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80078c:	eb 69                	jmp    8007f7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80078e:	a1 20 50 80 00       	mov    0x805020,%eax
  800793:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800799:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80079c:	89 d0                	mov    %edx,%eax
  80079e:	01 c0                	add    %eax,%eax
  8007a0:	01 d0                	add    %edx,%eax
  8007a2:	c1 e0 03             	shl    $0x3,%eax
  8007a5:	01 c8                	add    %ecx,%eax
  8007a7:	8a 40 04             	mov    0x4(%eax),%al
  8007aa:	84 c0                	test   %al,%al
  8007ac:	75 46                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ae:	a1 20 50 80 00       	mov    0x805020,%eax
  8007b3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007bc:	89 d0                	mov    %edx,%eax
  8007be:	01 c0                	add    %eax,%eax
  8007c0:	01 d0                	add    %edx,%eax
  8007c2:	c1 e0 03             	shl    $0x3,%eax
  8007c5:	01 c8                	add    %ecx,%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007d4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e3:	01 c8                	add    %ecx,%eax
  8007e5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007e7:	39 c2                	cmp    %eax,%edx
  8007e9:	75 09                	jne    8007f4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8007eb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8007f2:	eb 12                	jmp    800806 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f4:	ff 45 e8             	incl   -0x18(%ebp)
  8007f7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fc:	8b 50 74             	mov    0x74(%eax),%edx
  8007ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800802:	39 c2                	cmp    %eax,%edx
  800804:	77 88                	ja     80078e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800806:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80080a:	75 14                	jne    800820 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	68 6c 3c 80 00       	push   $0x803c6c
  800814:	6a 3a                	push   $0x3a
  800816:	68 60 3c 80 00       	push   $0x803c60
  80081b:	e8 93 fe ff ff       	call   8006b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800820:	ff 45 f0             	incl   -0x10(%ebp)
  800823:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800826:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800829:	0f 8c 32 ff ff ff    	jl     800761 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80082f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800836:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80083d:	eb 26                	jmp    800865 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80083f:	a1 20 50 80 00       	mov    0x805020,%eax
  800844:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80084a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80084d:	89 d0                	mov    %edx,%eax
  80084f:	01 c0                	add    %eax,%eax
  800851:	01 d0                	add    %edx,%eax
  800853:	c1 e0 03             	shl    $0x3,%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8a 40 04             	mov    0x4(%eax),%al
  80085b:	3c 01                	cmp    $0x1,%al
  80085d:	75 03                	jne    800862 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80085f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800862:	ff 45 e0             	incl   -0x20(%ebp)
  800865:	a1 20 50 80 00       	mov    0x805020,%eax
  80086a:	8b 50 74             	mov    0x74(%eax),%edx
  80086d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800870:	39 c2                	cmp    %eax,%edx
  800872:	77 cb                	ja     80083f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80087a:	74 14                	je     800890 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80087c:	83 ec 04             	sub    $0x4,%esp
  80087f:	68 c0 3c 80 00       	push   $0x803cc0
  800884:	6a 44                	push   $0x44
  800886:	68 60 3c 80 00       	push   $0x803c60
  80088b:	e8 23 fe ff ff       	call   8006b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800890:	90                   	nop
  800891:	c9                   	leave  
  800892:	c3                   	ret    

00800893 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800899:	8b 45 0c             	mov    0xc(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	8d 48 01             	lea    0x1(%eax),%ecx
  8008a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a4:	89 0a                	mov    %ecx,(%edx)
  8008a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008a9:	88 d1                	mov    %dl,%cl
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b5:	8b 00                	mov    (%eax),%eax
  8008b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008bc:	75 2c                	jne    8008ea <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008be:	a0 24 50 80 00       	mov    0x805024,%al
  8008c3:	0f b6 c0             	movzbl %al,%eax
  8008c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c9:	8b 12                	mov    (%edx),%edx
  8008cb:	89 d1                	mov    %edx,%ecx
  8008cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d0:	83 c2 08             	add    $0x8,%edx
  8008d3:	83 ec 04             	sub    $0x4,%esp
  8008d6:	50                   	push   %eax
  8008d7:	51                   	push   %ecx
  8008d8:	52                   	push   %edx
  8008d9:	e8 05 14 00 00       	call   801ce3 <sys_cputs>
  8008de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8008ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ed:	8b 40 04             	mov    0x4(%eax),%eax
  8008f0:	8d 50 01             	lea    0x1(%eax),%edx
  8008f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8008f9:	90                   	nop
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    

008008fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800905:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80090c:	00 00 00 
	b.cnt = 0;
  80090f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800916:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	ff 75 08             	pushl  0x8(%ebp)
  80091f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800925:	50                   	push   %eax
  800926:	68 93 08 80 00       	push   $0x800893
  80092b:	e8 11 02 00 00       	call   800b41 <vprintfmt>
  800930:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800933:	a0 24 50 80 00       	mov    0x805024,%al
  800938:	0f b6 c0             	movzbl %al,%eax
  80093b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800941:	83 ec 04             	sub    $0x4,%esp
  800944:	50                   	push   %eax
  800945:	52                   	push   %edx
  800946:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80094c:	83 c0 08             	add    $0x8,%eax
  80094f:	50                   	push   %eax
  800950:	e8 8e 13 00 00       	call   801ce3 <sys_cputs>
  800955:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800958:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80095f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <cprintf>:

int cprintf(const char *fmt, ...) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80096d:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800974:	8d 45 0c             	lea    0xc(%ebp),%eax
  800977:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80097a:	8b 45 08             	mov    0x8(%ebp),%eax
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 f4             	pushl  -0xc(%ebp)
  800983:	50                   	push   %eax
  800984:	e8 73 ff ff ff       	call   8008fc <vcprintf>
  800989:	83 c4 10             	add    $0x10,%esp
  80098c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80098f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80099a:	e8 f2 14 00 00       	call   801e91 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80099f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a8:	83 ec 08             	sub    $0x8,%esp
  8009ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ae:	50                   	push   %eax
  8009af:	e8 48 ff ff ff       	call   8008fc <vcprintf>
  8009b4:	83 c4 10             	add    $0x10,%esp
  8009b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009ba:	e8 ec 14 00 00       	call   801eab <sys_enable_interrupt>
	return cnt;
  8009bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	53                   	push   %ebx
  8009c8:	83 ec 14             	sub    $0x14,%esp
  8009cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8009d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8009da:	ba 00 00 00 00       	mov    $0x0,%edx
  8009df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e2:	77 55                	ja     800a39 <printnum+0x75>
  8009e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009e7:	72 05                	jb     8009ee <printnum+0x2a>
  8009e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009ec:	77 4b                	ja     800a39 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8009ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8009f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8009f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fc:	52                   	push   %edx
  8009fd:	50                   	push   %eax
  8009fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800a01:	ff 75 f0             	pushl  -0x10(%ebp)
  800a04:	e8 63 2a 00 00       	call   80346c <__udivdi3>
  800a09:	83 c4 10             	add    $0x10,%esp
  800a0c:	83 ec 04             	sub    $0x4,%esp
  800a0f:	ff 75 20             	pushl  0x20(%ebp)
  800a12:	53                   	push   %ebx
  800a13:	ff 75 18             	pushl  0x18(%ebp)
  800a16:	52                   	push   %edx
  800a17:	50                   	push   %eax
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	ff 75 08             	pushl  0x8(%ebp)
  800a1e:	e8 a1 ff ff ff       	call   8009c4 <printnum>
  800a23:	83 c4 20             	add    $0x20,%esp
  800a26:	eb 1a                	jmp    800a42 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a28:	83 ec 08             	sub    $0x8,%esp
  800a2b:	ff 75 0c             	pushl  0xc(%ebp)
  800a2e:	ff 75 20             	pushl  0x20(%ebp)
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	ff d0                	call   *%eax
  800a36:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a39:	ff 4d 1c             	decl   0x1c(%ebp)
  800a3c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a40:	7f e6                	jg     800a28 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a42:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a50:	53                   	push   %ebx
  800a51:	51                   	push   %ecx
  800a52:	52                   	push   %edx
  800a53:	50                   	push   %eax
  800a54:	e8 23 2b 00 00       	call   80357c <__umoddi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	05 34 3f 80 00       	add    $0x803f34,%eax
  800a61:	8a 00                	mov    (%eax),%al
  800a63:	0f be c0             	movsbl %al,%eax
  800a66:	83 ec 08             	sub    $0x8,%esp
  800a69:	ff 75 0c             	pushl  0xc(%ebp)
  800a6c:	50                   	push   %eax
  800a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a70:	ff d0                	call   *%eax
  800a72:	83 c4 10             	add    $0x10,%esp
}
  800a75:	90                   	nop
  800a76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a7e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a82:	7e 1c                	jle    800aa0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	8b 00                	mov    (%eax),%eax
  800a89:	8d 50 08             	lea    0x8(%eax),%edx
  800a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8f:	89 10                	mov    %edx,(%eax)
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	8b 00                	mov    (%eax),%eax
  800a96:	83 e8 08             	sub    $0x8,%eax
  800a99:	8b 50 04             	mov    0x4(%eax),%edx
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	eb 40                	jmp    800ae0 <getuint+0x65>
	else if (lflag)
  800aa0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aa4:	74 1e                	je     800ac4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	8b 00                	mov    (%eax),%eax
  800aab:	8d 50 04             	lea    0x4(%eax),%edx
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	89 10                	mov    %edx,(%eax)
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	83 e8 04             	sub    $0x4,%eax
  800abb:	8b 00                	mov    (%eax),%eax
  800abd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac2:	eb 1c                	jmp    800ae0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac7:	8b 00                	mov    (%eax),%eax
  800ac9:	8d 50 04             	lea    0x4(%eax),%edx
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	89 10                	mov    %edx,(%eax)
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	8b 00                	mov    (%eax),%eax
  800ad6:	83 e8 04             	sub    $0x4,%eax
  800ad9:	8b 00                	mov    (%eax),%eax
  800adb:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ae0:	5d                   	pop    %ebp
  800ae1:	c3                   	ret    

00800ae2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ae2:	55                   	push   %ebp
  800ae3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ae9:	7e 1c                	jle    800b07 <getint+0x25>
		return va_arg(*ap, long long);
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	8b 00                	mov    (%eax),%eax
  800af0:	8d 50 08             	lea    0x8(%eax),%edx
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 10                	mov    %edx,(%eax)
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	8b 00                	mov    (%eax),%eax
  800afd:	83 e8 08             	sub    $0x8,%eax
  800b00:	8b 50 04             	mov    0x4(%eax),%edx
  800b03:	8b 00                	mov    (%eax),%eax
  800b05:	eb 38                	jmp    800b3f <getint+0x5d>
	else if (lflag)
  800b07:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0b:	74 1a                	je     800b27 <getint+0x45>
		return va_arg(*ap, long);
  800b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b10:	8b 00                	mov    (%eax),%eax
  800b12:	8d 50 04             	lea    0x4(%eax),%edx
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 10                	mov    %edx,(%eax)
  800b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1d:	8b 00                	mov    (%eax),%eax
  800b1f:	83 e8 04             	sub    $0x4,%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	99                   	cltd   
  800b25:	eb 18                	jmp    800b3f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 00                	mov    (%eax),%eax
  800b2c:	8d 50 04             	lea    0x4(%eax),%edx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 10                	mov    %edx,(%eax)
  800b34:	8b 45 08             	mov    0x8(%ebp),%eax
  800b37:	8b 00                	mov    (%eax),%eax
  800b39:	83 e8 04             	sub    $0x4,%eax
  800b3c:	8b 00                	mov    (%eax),%eax
  800b3e:	99                   	cltd   
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
  800b46:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b49:	eb 17                	jmp    800b62 <vprintfmt+0x21>
			if (ch == '\0')
  800b4b:	85 db                	test   %ebx,%ebx
  800b4d:	0f 84 af 03 00 00    	je     800f02 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b53:	83 ec 08             	sub    $0x8,%esp
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	53                   	push   %ebx
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b62:	8b 45 10             	mov    0x10(%ebp),%eax
  800b65:	8d 50 01             	lea    0x1(%eax),%edx
  800b68:	89 55 10             	mov    %edx,0x10(%ebp)
  800b6b:	8a 00                	mov    (%eax),%al
  800b6d:	0f b6 d8             	movzbl %al,%ebx
  800b70:	83 fb 25             	cmp    $0x25,%ebx
  800b73:	75 d6                	jne    800b4b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b75:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b79:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b80:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800b87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800b8e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800b95:	8b 45 10             	mov    0x10(%ebp),%eax
  800b98:	8d 50 01             	lea    0x1(%eax),%edx
  800b9b:	89 55 10             	mov    %edx,0x10(%ebp)
  800b9e:	8a 00                	mov    (%eax),%al
  800ba0:	0f b6 d8             	movzbl %al,%ebx
  800ba3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800ba6:	83 f8 55             	cmp    $0x55,%eax
  800ba9:	0f 87 2b 03 00 00    	ja     800eda <vprintfmt+0x399>
  800baf:	8b 04 85 58 3f 80 00 	mov    0x803f58(,%eax,4),%eax
  800bb6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bb8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bbc:	eb d7                	jmp    800b95 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bbe:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bc2:	eb d1                	jmp    800b95 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bc4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bcb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	c1 e0 02             	shl    $0x2,%eax
  800bd3:	01 d0                	add    %edx,%eax
  800bd5:	01 c0                	add    %eax,%eax
  800bd7:	01 d8                	add    %ebx,%eax
  800bd9:	83 e8 30             	sub    $0x30,%eax
  800bdc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800be2:	8a 00                	mov    (%eax),%al
  800be4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800be7:	83 fb 2f             	cmp    $0x2f,%ebx
  800bea:	7e 3e                	jle    800c2a <vprintfmt+0xe9>
  800bec:	83 fb 39             	cmp    $0x39,%ebx
  800bef:	7f 39                	jg     800c2a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800bf4:	eb d5                	jmp    800bcb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800bf6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf9:	83 c0 04             	add    $0x4,%eax
  800bfc:	89 45 14             	mov    %eax,0x14(%ebp)
  800bff:	8b 45 14             	mov    0x14(%ebp),%eax
  800c02:	83 e8 04             	sub    $0x4,%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c0a:	eb 1f                	jmp    800c2b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c10:	79 83                	jns    800b95 <vprintfmt+0x54>
				width = 0;
  800c12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c19:	e9 77 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c1e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c25:	e9 6b ff ff ff       	jmp    800b95 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c2a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2f:	0f 89 60 ff ff ff    	jns    800b95 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c3b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c42:	e9 4e ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c47:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c4a:	e9 46 ff ff ff       	jmp    800b95 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	83 c0 04             	add    $0x4,%eax
  800c55:	89 45 14             	mov    %eax,0x14(%ebp)
  800c58:	8b 45 14             	mov    0x14(%ebp),%eax
  800c5b:	83 e8 04             	sub    $0x4,%eax
  800c5e:	8b 00                	mov    (%eax),%eax
  800c60:	83 ec 08             	sub    $0x8,%esp
  800c63:	ff 75 0c             	pushl  0xc(%ebp)
  800c66:	50                   	push   %eax
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	ff d0                	call   *%eax
  800c6c:	83 c4 10             	add    $0x10,%esp
			break;
  800c6f:	e9 89 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 c0 04             	add    $0x4,%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 e8 04             	sub    $0x4,%eax
  800c83:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800c85:	85 db                	test   %ebx,%ebx
  800c87:	79 02                	jns    800c8b <vprintfmt+0x14a>
				err = -err;
  800c89:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800c8b:	83 fb 64             	cmp    $0x64,%ebx
  800c8e:	7f 0b                	jg     800c9b <vprintfmt+0x15a>
  800c90:	8b 34 9d a0 3d 80 00 	mov    0x803da0(,%ebx,4),%esi
  800c97:	85 f6                	test   %esi,%esi
  800c99:	75 19                	jne    800cb4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800c9b:	53                   	push   %ebx
  800c9c:	68 45 3f 80 00       	push   $0x803f45
  800ca1:	ff 75 0c             	pushl  0xc(%ebp)
  800ca4:	ff 75 08             	pushl  0x8(%ebp)
  800ca7:	e8 5e 02 00 00       	call   800f0a <printfmt>
  800cac:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800caf:	e9 49 02 00 00       	jmp    800efd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cb4:	56                   	push   %esi
  800cb5:	68 4e 3f 80 00       	push   $0x803f4e
  800cba:	ff 75 0c             	pushl  0xc(%ebp)
  800cbd:	ff 75 08             	pushl  0x8(%ebp)
  800cc0:	e8 45 02 00 00       	call   800f0a <printfmt>
  800cc5:	83 c4 10             	add    $0x10,%esp
			break;
  800cc8:	e9 30 02 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	83 c0 04             	add    $0x4,%eax
  800cd3:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	83 e8 04             	sub    $0x4,%eax
  800cdc:	8b 30                	mov    (%eax),%esi
  800cde:	85 f6                	test   %esi,%esi
  800ce0:	75 05                	jne    800ce7 <vprintfmt+0x1a6>
				p = "(null)";
  800ce2:	be 51 3f 80 00       	mov    $0x803f51,%esi
			if (width > 0 && padc != '-')
  800ce7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ceb:	7e 6d                	jle    800d5a <vprintfmt+0x219>
  800ced:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800cf1:	74 67                	je     800d5a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800cf3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cf6:	83 ec 08             	sub    $0x8,%esp
  800cf9:	50                   	push   %eax
  800cfa:	56                   	push   %esi
  800cfb:	e8 0c 03 00 00       	call   80100c <strnlen>
  800d00:	83 c4 10             	add    $0x10,%esp
  800d03:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d06:	eb 16                	jmp    800d1e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d08:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d0c:	83 ec 08             	sub    $0x8,%esp
  800d0f:	ff 75 0c             	pushl  0xc(%ebp)
  800d12:	50                   	push   %eax
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	ff d0                	call   *%eax
  800d18:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d22:	7f e4                	jg     800d08 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d24:	eb 34                	jmp    800d5a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d26:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d2a:	74 1c                	je     800d48 <vprintfmt+0x207>
  800d2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800d2f:	7e 05                	jle    800d36 <vprintfmt+0x1f5>
  800d31:	83 fb 7e             	cmp    $0x7e,%ebx
  800d34:	7e 12                	jle    800d48 <vprintfmt+0x207>
					putch('?', putdat);
  800d36:	83 ec 08             	sub    $0x8,%esp
  800d39:	ff 75 0c             	pushl  0xc(%ebp)
  800d3c:	6a 3f                	push   $0x3f
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	ff d0                	call   *%eax
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	eb 0f                	jmp    800d57 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	53                   	push   %ebx
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d57:	ff 4d e4             	decl   -0x1c(%ebp)
  800d5a:	89 f0                	mov    %esi,%eax
  800d5c:	8d 70 01             	lea    0x1(%eax),%esi
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	0f be d8             	movsbl %al,%ebx
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	74 24                	je     800d8c <vprintfmt+0x24b>
  800d68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d6c:	78 b8                	js     800d26 <vprintfmt+0x1e5>
  800d6e:	ff 4d e0             	decl   -0x20(%ebp)
  800d71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d75:	79 af                	jns    800d26 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d77:	eb 13                	jmp    800d8c <vprintfmt+0x24b>
				putch(' ', putdat);
  800d79:	83 ec 08             	sub    $0x8,%esp
  800d7c:	ff 75 0c             	pushl  0xc(%ebp)
  800d7f:	6a 20                	push   $0x20
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	ff d0                	call   *%eax
  800d86:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d89:	ff 4d e4             	decl   -0x1c(%ebp)
  800d8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d90:	7f e7                	jg     800d79 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800d92:	e9 66 01 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800d97:	83 ec 08             	sub    $0x8,%esp
  800d9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800d9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800da0:	50                   	push   %eax
  800da1:	e8 3c fd ff ff       	call   800ae2 <getint>
  800da6:	83 c4 10             	add    $0x10,%esp
  800da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800db2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800db5:	85 d2                	test   %edx,%edx
  800db7:	79 23                	jns    800ddc <vprintfmt+0x29b>
				putch('-', putdat);
  800db9:	83 ec 08             	sub    $0x8,%esp
  800dbc:	ff 75 0c             	pushl  0xc(%ebp)
  800dbf:	6a 2d                	push   $0x2d
  800dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc4:	ff d0                	call   *%eax
  800dc6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800dc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dcf:	f7 d8                	neg    %eax
  800dd1:	83 d2 00             	adc    $0x0,%edx
  800dd4:	f7 da                	neg    %edx
  800dd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ddc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800de3:	e9 bc 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800de8:	83 ec 08             	sub    $0x8,%esp
  800deb:	ff 75 e8             	pushl  -0x18(%ebp)
  800dee:	8d 45 14             	lea    0x14(%ebp),%eax
  800df1:	50                   	push   %eax
  800df2:	e8 84 fc ff ff       	call   800a7b <getuint>
  800df7:	83 c4 10             	add    $0x10,%esp
  800dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e00:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e07:	e9 98 00 00 00       	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e0c:	83 ec 08             	sub    $0x8,%esp
  800e0f:	ff 75 0c             	pushl  0xc(%ebp)
  800e12:	6a 58                	push   $0x58
  800e14:	8b 45 08             	mov    0x8(%ebp),%eax
  800e17:	ff d0                	call   *%eax
  800e19:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e1c:	83 ec 08             	sub    $0x8,%esp
  800e1f:	ff 75 0c             	pushl  0xc(%ebp)
  800e22:	6a 58                	push   $0x58
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	ff d0                	call   *%eax
  800e29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 58                	push   $0x58
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
			break;
  800e3c:	e9 bc 00 00 00       	jmp    800efd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e41:	83 ec 08             	sub    $0x8,%esp
  800e44:	ff 75 0c             	pushl  0xc(%ebp)
  800e47:	6a 30                	push   $0x30
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e51:	83 ec 08             	sub    $0x8,%esp
  800e54:	ff 75 0c             	pushl  0xc(%ebp)
  800e57:	6a 78                	push   $0x78
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	ff d0                	call   *%eax
  800e5e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e61:	8b 45 14             	mov    0x14(%ebp),%eax
  800e64:	83 c0 04             	add    $0x4,%eax
  800e67:	89 45 14             	mov    %eax,0x14(%ebp)
  800e6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6d:	83 e8 04             	sub    $0x4,%eax
  800e70:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e83:	eb 1f                	jmp    800ea4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800e85:	83 ec 08             	sub    $0x8,%esp
  800e88:	ff 75 e8             	pushl  -0x18(%ebp)
  800e8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800e8e:	50                   	push   %eax
  800e8f:	e8 e7 fb ff ff       	call   800a7b <getuint>
  800e94:	83 c4 10             	add    $0x10,%esp
  800e97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800e9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ea4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eab:	83 ec 04             	sub    $0x4,%esp
  800eae:	52                   	push   %edx
  800eaf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800eb2:	50                   	push   %eax
  800eb3:	ff 75 f4             	pushl  -0xc(%ebp)
  800eb6:	ff 75 f0             	pushl  -0x10(%ebp)
  800eb9:	ff 75 0c             	pushl  0xc(%ebp)
  800ebc:	ff 75 08             	pushl  0x8(%ebp)
  800ebf:	e8 00 fb ff ff       	call   8009c4 <printnum>
  800ec4:	83 c4 20             	add    $0x20,%esp
			break;
  800ec7:	eb 34                	jmp    800efd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ec9:	83 ec 08             	sub    $0x8,%esp
  800ecc:	ff 75 0c             	pushl  0xc(%ebp)
  800ecf:	53                   	push   %ebx
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	ff d0                	call   *%eax
  800ed5:	83 c4 10             	add    $0x10,%esp
			break;
  800ed8:	eb 23                	jmp    800efd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800eda:	83 ec 08             	sub    $0x8,%esp
  800edd:	ff 75 0c             	pushl  0xc(%ebp)
  800ee0:	6a 25                	push   $0x25
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	ff d0                	call   *%eax
  800ee7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800eea:	ff 4d 10             	decl   0x10(%ebp)
  800eed:	eb 03                	jmp    800ef2 <vprintfmt+0x3b1>
  800eef:	ff 4d 10             	decl   0x10(%ebp)
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	48                   	dec    %eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	3c 25                	cmp    $0x25,%al
  800efa:	75 f3                	jne    800eef <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800efc:	90                   	nop
		}
	}
  800efd:	e9 47 fc ff ff       	jmp    800b49 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f06:	5b                   	pop    %ebx
  800f07:	5e                   	pop    %esi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f10:	8d 45 10             	lea    0x10(%ebp),%eax
  800f13:	83 c0 04             	add    $0x4,%eax
  800f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f1f:	50                   	push   %eax
  800f20:	ff 75 0c             	pushl  0xc(%ebp)
  800f23:	ff 75 08             	pushl  0x8(%ebp)
  800f26:	e8 16 fc ff ff       	call   800b41 <vprintfmt>
  800f2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f2e:	90                   	nop
  800f2f:	c9                   	leave  
  800f30:	c3                   	ret    

00800f31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f31:	55                   	push   %ebp
  800f32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	8b 40 08             	mov    0x8(%eax),%eax
  800f3a:	8d 50 01             	lea    0x1(%eax),%edx
  800f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8b 10                	mov    (%eax),%edx
  800f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4b:	8b 40 04             	mov    0x4(%eax),%eax
  800f4e:	39 c2                	cmp    %eax,%edx
  800f50:	73 12                	jae    800f64 <sprintputch+0x33>
		*b->buf++ = ch;
  800f52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f55:	8b 00                	mov    (%eax),%eax
  800f57:	8d 48 01             	lea    0x1(%eax),%ecx
  800f5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5d:	89 0a                	mov    %ecx,(%edx)
  800f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f62:	88 10                	mov    %dl,(%eax)
}
  800f64:	90                   	nop
  800f65:	5d                   	pop    %ebp
  800f66:	c3                   	ret    

00800f67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	01 d0                	add    %edx,%eax
  800f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800f88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f8c:	74 06                	je     800f94 <vsnprintf+0x2d>
  800f8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f92:	7f 07                	jg     800f9b <vsnprintf+0x34>
		return -E_INVAL;
  800f94:	b8 03 00 00 00       	mov    $0x3,%eax
  800f99:	eb 20                	jmp    800fbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800f9b:	ff 75 14             	pushl  0x14(%ebp)
  800f9e:	ff 75 10             	pushl  0x10(%ebp)
  800fa1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fa4:	50                   	push   %eax
  800fa5:	68 31 0f 80 00       	push   $0x800f31
  800faa:	e8 92 fb ff ff       	call   800b41 <vprintfmt>
  800faf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fb2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fb5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fbb:	c9                   	leave  
  800fbc:	c3                   	ret    

00800fbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800fc6:	83 c0 04             	add    $0x4,%eax
  800fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800fd2:	50                   	push   %eax
  800fd3:	ff 75 0c             	pushl  0xc(%ebp)
  800fd6:	ff 75 08             	pushl  0x8(%ebp)
  800fd9:	e8 89 ff ff ff       	call   800f67 <vsnprintf>
  800fde:	83 c4 10             	add    $0x10,%esp
  800fe1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800fe7:	c9                   	leave  
  800fe8:	c3                   	ret    

00800fe9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800fef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ff6:	eb 06                	jmp    800ffe <strlen+0x15>
		n++;
  800ff8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ffb:	ff 45 08             	incl   0x8(%ebp)
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	84 c0                	test   %al,%al
  801005:	75 f1                	jne    800ff8 <strlen+0xf>
		n++;
	return n;
  801007:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801012:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801019:	eb 09                	jmp    801024 <strnlen+0x18>
		n++;
  80101b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80101e:	ff 45 08             	incl   0x8(%ebp)
  801021:	ff 4d 0c             	decl   0xc(%ebp)
  801024:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801028:	74 09                	je     801033 <strnlen+0x27>
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	84 c0                	test   %al,%al
  801031:	75 e8                	jne    80101b <strnlen+0xf>
		n++;
	return n;
  801033:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801036:	c9                   	leave  
  801037:	c3                   	ret    

00801038 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801038:	55                   	push   %ebp
  801039:	89 e5                	mov    %esp,%ebp
  80103b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801044:	90                   	nop
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	8d 50 01             	lea    0x1(%eax),%edx
  80104b:	89 55 08             	mov    %edx,0x8(%ebp)
  80104e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801051:	8d 4a 01             	lea    0x1(%edx),%ecx
  801054:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801057:	8a 12                	mov    (%edx),%dl
  801059:	88 10                	mov    %dl,(%eax)
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e4                	jne    801045 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801079:	eb 1f                	jmp    80109a <strncpy+0x34>
		*dst++ = *src;
  80107b:	8b 45 08             	mov    0x8(%ebp),%eax
  80107e:	8d 50 01             	lea    0x1(%eax),%edx
  801081:	89 55 08             	mov    %edx,0x8(%ebp)
  801084:	8b 55 0c             	mov    0xc(%ebp),%edx
  801087:	8a 12                	mov    (%edx),%dl
  801089:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80108b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	84 c0                	test   %al,%al
  801092:	74 03                	je     801097 <strncpy+0x31>
			src++;
  801094:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801097:	ff 45 fc             	incl   -0x4(%ebp)
  80109a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109d:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010a0:	72 d9                	jb     80107b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010b7:	74 30                	je     8010e9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010b9:	eb 16                	jmp    8010d1 <strlcpy+0x2a>
			*dst++ = *src++;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8d 50 01             	lea    0x1(%eax),%edx
  8010c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010ca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010cd:	8a 12                	mov    (%edx),%dl
  8010cf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010d1:	ff 4d 10             	decl   0x10(%ebp)
  8010d4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d8:	74 09                	je     8010e3 <strlcpy+0x3c>
  8010da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010dd:	8a 00                	mov    (%eax),%al
  8010df:	84 c0                	test   %al,%al
  8010e1:	75 d8                	jne    8010bb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	29 c2                	sub    %eax,%edx
  8010f1:	89 d0                	mov    %edx,%eax
}
  8010f3:	c9                   	leave  
  8010f4:	c3                   	ret    

008010f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8010f8:	eb 06                	jmp    801100 <strcmp+0xb>
		p++, q++;
  8010fa:	ff 45 08             	incl   0x8(%ebp)
  8010fd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	84 c0                	test   %al,%al
  801107:	74 0e                	je     801117 <strcmp+0x22>
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	8a 10                	mov    (%eax),%dl
  80110e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	38 c2                	cmp    %al,%dl
  801115:	74 e3                	je     8010fa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	0f b6 d0             	movzbl %al,%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	0f b6 c0             	movzbl %al,%eax
  801127:	29 c2                	sub    %eax,%edx
  801129:	89 d0                	mov    %edx,%eax
}
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801130:	eb 09                	jmp    80113b <strncmp+0xe>
		n--, p++, q++;
  801132:	ff 4d 10             	decl   0x10(%ebp)
  801135:	ff 45 08             	incl   0x8(%ebp)
  801138:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80113b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80113f:	74 17                	je     801158 <strncmp+0x2b>
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 0e                	je     801158 <strncmp+0x2b>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 10                	mov    (%eax),%dl
  80114f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801152:	8a 00                	mov    (%eax),%al
  801154:	38 c2                	cmp    %al,%dl
  801156:	74 da                	je     801132 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801158:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115c:	75 07                	jne    801165 <strncmp+0x38>
		return 0;
  80115e:	b8 00 00 00 00       	mov    $0x0,%eax
  801163:	eb 14                	jmp    801179 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801165:	8b 45 08             	mov    0x8(%ebp),%eax
  801168:	8a 00                	mov    (%eax),%al
  80116a:	0f b6 d0             	movzbl %al,%edx
  80116d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801170:	8a 00                	mov    (%eax),%al
  801172:	0f b6 c0             	movzbl %al,%eax
  801175:	29 c2                	sub    %eax,%edx
  801177:	89 d0                	mov    %edx,%eax
}
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	8b 45 0c             	mov    0xc(%ebp),%eax
  801184:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801187:	eb 12                	jmp    80119b <strchr+0x20>
		if (*s == c)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801191:	75 05                	jne    801198 <strchr+0x1d>
			return (char *) s;
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	eb 11                	jmp    8011a9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801198:	ff 45 08             	incl   0x8(%ebp)
  80119b:	8b 45 08             	mov    0x8(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	84 c0                	test   %al,%al
  8011a2:	75 e5                	jne    801189 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 04             	sub    $0x4,%esp
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b7:	eb 0d                	jmp    8011c6 <strfind+0x1b>
		if (*s == c)
  8011b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011c1:	74 0e                	je     8011d1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011c3:	ff 45 08             	incl   0x8(%ebp)
  8011c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c9:	8a 00                	mov    (%eax),%al
  8011cb:	84 c0                	test   %al,%al
  8011cd:	75 ea                	jne    8011b9 <strfind+0xe>
  8011cf:	eb 01                	jmp    8011d2 <strfind+0x27>
		if (*s == c)
			break;
  8011d1:	90                   	nop
	return (char *) s;
  8011d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    

008011d7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011d7:	55                   	push   %ebp
  8011d8:	89 e5                	mov    %esp,%ebp
  8011da:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8011e9:	eb 0e                	jmp    8011f9 <memset+0x22>
		*p++ = c;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011f7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8011f9:	ff 4d f8             	decl   -0x8(%ebp)
  8011fc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801200:	79 e9                	jns    8011eb <memset+0x14>
		*p++ = c;

	return v;
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801205:	c9                   	leave  
  801206:	c3                   	ret    

00801207 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801219:	eb 16                	jmp    801231 <memcpy+0x2a>
		*d++ = *s++;
  80121b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80121e:	8d 50 01             	lea    0x1(%eax),%edx
  801221:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801224:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801227:	8d 4a 01             	lea    0x1(%edx),%ecx
  80122a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80122d:	8a 12                	mov    (%edx),%dl
  80122f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801231:	8b 45 10             	mov    0x10(%ebp),%eax
  801234:	8d 50 ff             	lea    -0x1(%eax),%edx
  801237:	89 55 10             	mov    %edx,0x10(%ebp)
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 dd                	jne    80121b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801241:	c9                   	leave  
  801242:	c3                   	ret    

00801243 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801258:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80125b:	73 50                	jae    8012ad <memmove+0x6a>
  80125d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801260:	8b 45 10             	mov    0x10(%ebp),%eax
  801263:	01 d0                	add    %edx,%eax
  801265:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801268:	76 43                	jbe    8012ad <memmove+0x6a>
		s += n;
  80126a:	8b 45 10             	mov    0x10(%ebp),%eax
  80126d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801270:	8b 45 10             	mov    0x10(%ebp),%eax
  801273:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801276:	eb 10                	jmp    801288 <memmove+0x45>
			*--d = *--s;
  801278:	ff 4d f8             	decl   -0x8(%ebp)
  80127b:	ff 4d fc             	decl   -0x4(%ebp)
  80127e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801281:	8a 10                	mov    (%eax),%dl
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801288:	8b 45 10             	mov    0x10(%ebp),%eax
  80128b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80128e:	89 55 10             	mov    %edx,0x10(%ebp)
  801291:	85 c0                	test   %eax,%eax
  801293:	75 e3                	jne    801278 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801295:	eb 23                	jmp    8012ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801297:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80129a:	8d 50 01             	lea    0x1(%eax),%edx
  80129d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012a9:	8a 12                	mov    (%edx),%dl
  8012ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8012b6:	85 c0                	test   %eax,%eax
  8012b8:	75 dd                	jne    801297 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012d1:	eb 2a                	jmp    8012fd <memcmp+0x3e>
		if (*s1 != *s2)
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8a 10                	mov    (%eax),%dl
  8012d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	38 c2                	cmp    %al,%dl
  8012df:	74 16                	je     8012f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012e4:	8a 00                	mov    (%eax),%al
  8012e6:	0f b6 d0             	movzbl %al,%edx
  8012e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ec:	8a 00                	mov    (%eax),%al
  8012ee:	0f b6 c0             	movzbl %al,%eax
  8012f1:	29 c2                	sub    %eax,%edx
  8012f3:	89 d0                	mov    %edx,%eax
  8012f5:	eb 18                	jmp    80130f <memcmp+0x50>
		s1++, s2++;
  8012f7:	ff 45 fc             	incl   -0x4(%ebp)
  8012fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	8d 50 ff             	lea    -0x1(%eax),%edx
  801303:	89 55 10             	mov    %edx,0x10(%ebp)
  801306:	85 c0                	test   %eax,%eax
  801308:	75 c9                	jne    8012d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80130a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80130f:	c9                   	leave  
  801310:	c3                   	ret    

00801311 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801317:	8b 55 08             	mov    0x8(%ebp),%edx
  80131a:	8b 45 10             	mov    0x10(%ebp),%eax
  80131d:	01 d0                	add    %edx,%eax
  80131f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801322:	eb 15                	jmp    801339 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	8a 00                	mov    (%eax),%al
  801329:	0f b6 d0             	movzbl %al,%edx
  80132c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132f:	0f b6 c0             	movzbl %al,%eax
  801332:	39 c2                	cmp    %eax,%edx
  801334:	74 0d                	je     801343 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80133f:	72 e3                	jb     801324 <memfind+0x13>
  801341:	eb 01                	jmp    801344 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801343:	90                   	nop
	return (void *) s;
  801344:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801347:	c9                   	leave  
  801348:	c3                   	ret    

00801349 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80134f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801356:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80135d:	eb 03                	jmp    801362 <strtol+0x19>
		s++;
  80135f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801362:	8b 45 08             	mov    0x8(%ebp),%eax
  801365:	8a 00                	mov    (%eax),%al
  801367:	3c 20                	cmp    $0x20,%al
  801369:	74 f4                	je     80135f <strtol+0x16>
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	8a 00                	mov    (%eax),%al
  801370:	3c 09                	cmp    $0x9,%al
  801372:	74 eb                	je     80135f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	3c 2b                	cmp    $0x2b,%al
  80137b:	75 05                	jne    801382 <strtol+0x39>
		s++;
  80137d:	ff 45 08             	incl   0x8(%ebp)
  801380:	eb 13                	jmp    801395 <strtol+0x4c>
	else if (*s == '-')
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 00                	mov    (%eax),%al
  801387:	3c 2d                	cmp    $0x2d,%al
  801389:	75 0a                	jne    801395 <strtol+0x4c>
		s++, neg = 1;
  80138b:	ff 45 08             	incl   0x8(%ebp)
  80138e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801395:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801399:	74 06                	je     8013a1 <strtol+0x58>
  80139b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80139f:	75 20                	jne    8013c1 <strtol+0x78>
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	8a 00                	mov    (%eax),%al
  8013a6:	3c 30                	cmp    $0x30,%al
  8013a8:	75 17                	jne    8013c1 <strtol+0x78>
  8013aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ad:	40                   	inc    %eax
  8013ae:	8a 00                	mov    (%eax),%al
  8013b0:	3c 78                	cmp    $0x78,%al
  8013b2:	75 0d                	jne    8013c1 <strtol+0x78>
		s += 2, base = 16;
  8013b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013bf:	eb 28                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c5:	75 15                	jne    8013dc <strtol+0x93>
  8013c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 30                	cmp    $0x30,%al
  8013ce:	75 0c                	jne    8013dc <strtol+0x93>
		s++, base = 8;
  8013d0:	ff 45 08             	incl   0x8(%ebp)
  8013d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013da:	eb 0d                	jmp    8013e9 <strtol+0xa0>
	else if (base == 0)
  8013dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e0:	75 07                	jne    8013e9 <strtol+0xa0>
		base = 10;
  8013e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ec:	8a 00                	mov    (%eax),%al
  8013ee:	3c 2f                	cmp    $0x2f,%al
  8013f0:	7e 19                	jle    80140b <strtol+0xc2>
  8013f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f5:	8a 00                	mov    (%eax),%al
  8013f7:	3c 39                	cmp    $0x39,%al
  8013f9:	7f 10                	jg     80140b <strtol+0xc2>
			dig = *s - '0';
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	0f be c0             	movsbl %al,%eax
  801403:	83 e8 30             	sub    $0x30,%eax
  801406:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801409:	eb 42                	jmp    80144d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	8a 00                	mov    (%eax),%al
  801410:	3c 60                	cmp    $0x60,%al
  801412:	7e 19                	jle    80142d <strtol+0xe4>
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	3c 7a                	cmp    $0x7a,%al
  80141b:	7f 10                	jg     80142d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80141d:	8b 45 08             	mov    0x8(%ebp),%eax
  801420:	8a 00                	mov    (%eax),%al
  801422:	0f be c0             	movsbl %al,%eax
  801425:	83 e8 57             	sub    $0x57,%eax
  801428:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80142b:	eb 20                	jmp    80144d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
  801430:	8a 00                	mov    (%eax),%al
  801432:	3c 40                	cmp    $0x40,%al
  801434:	7e 39                	jle    80146f <strtol+0x126>
  801436:	8b 45 08             	mov    0x8(%ebp),%eax
  801439:	8a 00                	mov    (%eax),%al
  80143b:	3c 5a                	cmp    $0x5a,%al
  80143d:	7f 30                	jg     80146f <strtol+0x126>
			dig = *s - 'A' + 10;
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	0f be c0             	movsbl %al,%eax
  801447:	83 e8 37             	sub    $0x37,%eax
  80144a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801450:	3b 45 10             	cmp    0x10(%ebp),%eax
  801453:	7d 19                	jge    80146e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801455:	ff 45 08             	incl   0x8(%ebp)
  801458:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80145f:	89 c2                	mov    %eax,%edx
  801461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801464:	01 d0                	add    %edx,%eax
  801466:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801469:	e9 7b ff ff ff       	jmp    8013e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80146e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80146f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801473:	74 08                	je     80147d <strtol+0x134>
		*endptr = (char *) s;
  801475:	8b 45 0c             	mov    0xc(%ebp),%eax
  801478:	8b 55 08             	mov    0x8(%ebp),%edx
  80147b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80147d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801481:	74 07                	je     80148a <strtol+0x141>
  801483:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801486:	f7 d8                	neg    %eax
  801488:	eb 03                	jmp    80148d <strtol+0x144>
  80148a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <ltostr>:

void
ltostr(long value, char *str)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801495:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80149c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a7:	79 13                	jns    8014bc <ltostr+0x2d>
	{
		neg = 1;
  8014a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014c4:	99                   	cltd   
  8014c5:	f7 f9                	idiv   %ecx
  8014c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014cd:	8d 50 01             	lea    0x1(%eax),%edx
  8014d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014d3:	89 c2                	mov    %eax,%edx
  8014d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d8:	01 d0                	add    %edx,%eax
  8014da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014dd:	83 c2 30             	add    $0x30,%edx
  8014e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8014ea:	f7 e9                	imul   %ecx
  8014ec:	c1 fa 02             	sar    $0x2,%edx
  8014ef:	89 c8                	mov    %ecx,%eax
  8014f1:	c1 f8 1f             	sar    $0x1f,%eax
  8014f4:	29 c2                	sub    %eax,%edx
  8014f6:	89 d0                	mov    %edx,%eax
  8014f8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8014fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801503:	f7 e9                	imul   %ecx
  801505:	c1 fa 02             	sar    $0x2,%edx
  801508:	89 c8                	mov    %ecx,%eax
  80150a:	c1 f8 1f             	sar    $0x1f,%eax
  80150d:	29 c2                	sub    %eax,%edx
  80150f:	89 d0                	mov    %edx,%eax
  801511:	c1 e0 02             	shl    $0x2,%eax
  801514:	01 d0                	add    %edx,%eax
  801516:	01 c0                	add    %eax,%eax
  801518:	29 c1                	sub    %eax,%ecx
  80151a:	89 ca                	mov    %ecx,%edx
  80151c:	85 d2                	test   %edx,%edx
  80151e:	75 9c                	jne    8014bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801520:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801527:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80152a:	48                   	dec    %eax
  80152b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80152e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801532:	74 3d                	je     801571 <ltostr+0xe2>
		start = 1 ;
  801534:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80153b:	eb 34                	jmp    801571 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80153d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8a 00                	mov    (%eax),%al
  801547:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80154a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801550:	01 c2                	add    %eax,%edx
  801552:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801555:	8b 45 0c             	mov    0xc(%ebp),%eax
  801558:	01 c8                	add    %ecx,%eax
  80155a:	8a 00                	mov    (%eax),%al
  80155c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80155e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	01 c2                	add    %eax,%edx
  801566:	8a 45 eb             	mov    -0x15(%ebp),%al
  801569:	88 02                	mov    %al,(%edx)
		start++ ;
  80156b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80156e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801577:	7c c4                	jl     80153d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801579:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80157c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801584:	90                   	nop
  801585:	c9                   	leave  
  801586:	c3                   	ret    

00801587 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80158d:	ff 75 08             	pushl  0x8(%ebp)
  801590:	e8 54 fa ff ff       	call   800fe9 <strlen>
  801595:	83 c4 04             	add    $0x4,%esp
  801598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80159b:	ff 75 0c             	pushl  0xc(%ebp)
  80159e:	e8 46 fa ff ff       	call   800fe9 <strlen>
  8015a3:	83 c4 04             	add    $0x4,%esp
  8015a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015b7:	eb 17                	jmp    8015d0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8015b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	01 c2                	add    %eax,%edx
  8015c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c7:	01 c8                	add    %ecx,%eax
  8015c9:	8a 00                	mov    (%eax),%al
  8015cb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015cd:	ff 45 fc             	incl   -0x4(%ebp)
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015d6:	7c e1                	jl     8015b9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8015e6:	eb 1f                	jmp    801607 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8015e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015eb:	8d 50 01             	lea    0x1(%eax),%edx
  8015ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015f1:	89 c2                	mov    %eax,%edx
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	01 c2                	add    %eax,%edx
  8015f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8015fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015fe:	01 c8                	add    %ecx,%eax
  801600:	8a 00                	mov    (%eax),%al
  801602:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801604:	ff 45 f8             	incl   -0x8(%ebp)
  801607:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80160d:	7c d9                	jl     8015e8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80160f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801612:	8b 45 10             	mov    0x10(%ebp),%eax
  801615:	01 d0                	add    %edx,%eax
  801617:	c6 00 00             	movb   $0x0,(%eax)
}
  80161a:	90                   	nop
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801620:	8b 45 14             	mov    0x14(%ebp),%eax
  801623:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801629:	8b 45 14             	mov    0x14(%ebp),%eax
  80162c:	8b 00                	mov    (%eax),%eax
  80162e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801635:	8b 45 10             	mov    0x10(%ebp),%eax
  801638:	01 d0                	add    %edx,%eax
  80163a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801640:	eb 0c                	jmp    80164e <strsplit+0x31>
			*string++ = 0;
  801642:	8b 45 08             	mov    0x8(%ebp),%eax
  801645:	8d 50 01             	lea    0x1(%eax),%edx
  801648:	89 55 08             	mov    %edx,0x8(%ebp)
  80164b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80164e:	8b 45 08             	mov    0x8(%ebp),%eax
  801651:	8a 00                	mov    (%eax),%al
  801653:	84 c0                	test   %al,%al
  801655:	74 18                	je     80166f <strsplit+0x52>
  801657:	8b 45 08             	mov    0x8(%ebp),%eax
  80165a:	8a 00                	mov    (%eax),%al
  80165c:	0f be c0             	movsbl %al,%eax
  80165f:	50                   	push   %eax
  801660:	ff 75 0c             	pushl  0xc(%ebp)
  801663:	e8 13 fb ff ff       	call   80117b <strchr>
  801668:	83 c4 08             	add    $0x8,%esp
  80166b:	85 c0                	test   %eax,%eax
  80166d:	75 d3                	jne    801642 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80166f:	8b 45 08             	mov    0x8(%ebp),%eax
  801672:	8a 00                	mov    (%eax),%al
  801674:	84 c0                	test   %al,%al
  801676:	74 5a                	je     8016d2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801678:	8b 45 14             	mov    0x14(%ebp),%eax
  80167b:	8b 00                	mov    (%eax),%eax
  80167d:	83 f8 0f             	cmp    $0xf,%eax
  801680:	75 07                	jne    801689 <strsplit+0x6c>
		{
			return 0;
  801682:	b8 00 00 00 00       	mov    $0x0,%eax
  801687:	eb 66                	jmp    8016ef <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801689:	8b 45 14             	mov    0x14(%ebp),%eax
  80168c:	8b 00                	mov    (%eax),%eax
  80168e:	8d 48 01             	lea    0x1(%eax),%ecx
  801691:	8b 55 14             	mov    0x14(%ebp),%edx
  801694:	89 0a                	mov    %ecx,(%edx)
  801696:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	01 c2                	add    %eax,%edx
  8016a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016a7:	eb 03                	jmp    8016ac <strsplit+0x8f>
			string++;
  8016a9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	8a 00                	mov    (%eax),%al
  8016b1:	84 c0                	test   %al,%al
  8016b3:	74 8b                	je     801640 <strsplit+0x23>
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	0f be c0             	movsbl %al,%eax
  8016bd:	50                   	push   %eax
  8016be:	ff 75 0c             	pushl  0xc(%ebp)
  8016c1:	e8 b5 fa ff ff       	call   80117b <strchr>
  8016c6:	83 c4 08             	add    $0x8,%esp
  8016c9:	85 c0                	test   %eax,%eax
  8016cb:	74 dc                	je     8016a9 <strsplit+0x8c>
			string++;
	}
  8016cd:	e9 6e ff ff ff       	jmp    801640 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016d2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8b 00                	mov    (%eax),%eax
  8016d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016df:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e2:	01 d0                	add    %edx,%eax
  8016e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8016ea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8016f7:	a1 04 50 80 00       	mov    0x805004,%eax
  8016fc:	85 c0                	test   %eax,%eax
  8016fe:	74 1f                	je     80171f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801700:	e8 1d 00 00 00       	call   801722 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	68 b0 40 80 00       	push   $0x8040b0
  80170d:	e8 55 f2 ff ff       	call   800967 <cprintf>
  801712:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801715:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80171c:	00 00 00 
	}
}
  80171f:	90                   	nop
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801728:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80172f:	00 00 00 
  801732:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801739:	00 00 00 
  80173c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801743:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801746:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80174d:	00 00 00 
  801750:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801757:	00 00 00 
  80175a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801761:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801764:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  80176b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176e:	c1 e8 0c             	shr    $0xc,%eax
  801771:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801776:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80177d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801780:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801785:	2d 00 10 00 00       	sub    $0x1000,%eax
  80178a:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  80178f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801796:	a1 20 51 80 00       	mov    0x805120,%eax
  80179b:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80179f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8017a2:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8017a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017af:	01 d0                	add    %edx,%eax
  8017b1:	48                   	dec    %eax
  8017b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017bd:	f7 75 e4             	divl   -0x1c(%ebp)
  8017c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017c3:	29 d0                	sub    %edx,%eax
  8017c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8017c8:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8017cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017d7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017dc:	83 ec 04             	sub    $0x4,%esp
  8017df:	6a 07                	push   $0x7
  8017e1:	ff 75 e8             	pushl  -0x18(%ebp)
  8017e4:	50                   	push   %eax
  8017e5:	e8 3d 06 00 00       	call   801e27 <sys_allocate_chunk>
  8017ea:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8017ed:	a1 20 51 80 00       	mov    0x805120,%eax
  8017f2:	83 ec 0c             	sub    $0xc,%esp
  8017f5:	50                   	push   %eax
  8017f6:	e8 b2 0c 00 00       	call   8024ad <initialize_MemBlocksList>
  8017fb:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8017fe:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801803:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801806:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80180a:	0f 84 f3 00 00 00    	je     801903 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801810:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801814:	75 14                	jne    80182a <initialize_dyn_block_system+0x108>
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	68 d5 40 80 00       	push   $0x8040d5
  80181e:	6a 36                	push   $0x36
  801820:	68 f3 40 80 00       	push   $0x8040f3
  801825:	e8 89 ee ff ff       	call   8006b3 <_panic>
  80182a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80182d:	8b 00                	mov    (%eax),%eax
  80182f:	85 c0                	test   %eax,%eax
  801831:	74 10                	je     801843 <initialize_dyn_block_system+0x121>
  801833:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801836:	8b 00                	mov    (%eax),%eax
  801838:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80183b:	8b 52 04             	mov    0x4(%edx),%edx
  80183e:	89 50 04             	mov    %edx,0x4(%eax)
  801841:	eb 0b                	jmp    80184e <initialize_dyn_block_system+0x12c>
  801843:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801846:	8b 40 04             	mov    0x4(%eax),%eax
  801849:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80184e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801851:	8b 40 04             	mov    0x4(%eax),%eax
  801854:	85 c0                	test   %eax,%eax
  801856:	74 0f                	je     801867 <initialize_dyn_block_system+0x145>
  801858:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80185b:	8b 40 04             	mov    0x4(%eax),%eax
  80185e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801861:	8b 12                	mov    (%edx),%edx
  801863:	89 10                	mov    %edx,(%eax)
  801865:	eb 0a                	jmp    801871 <initialize_dyn_block_system+0x14f>
  801867:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80186a:	8b 00                	mov    (%eax),%eax
  80186c:	a3 48 51 80 00       	mov    %eax,0x805148
  801871:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801874:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80187a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80187d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801884:	a1 54 51 80 00       	mov    0x805154,%eax
  801889:	48                   	dec    %eax
  80188a:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80188f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801892:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801899:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80189c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8018a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018a7:	75 14                	jne    8018bd <initialize_dyn_block_system+0x19b>
  8018a9:	83 ec 04             	sub    $0x4,%esp
  8018ac:	68 00 41 80 00       	push   $0x804100
  8018b1:	6a 3e                	push   $0x3e
  8018b3:	68 f3 40 80 00       	push   $0x8040f3
  8018b8:	e8 f6 ed ff ff       	call   8006b3 <_panic>
  8018bd:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8018c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018c6:	89 10                	mov    %edx,(%eax)
  8018c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018cb:	8b 00                	mov    (%eax),%eax
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	74 0d                	je     8018de <initialize_dyn_block_system+0x1bc>
  8018d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8018d6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018d9:	89 50 04             	mov    %edx,0x4(%eax)
  8018dc:	eb 08                	jmp    8018e6 <initialize_dyn_block_system+0x1c4>
  8018de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8018e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e9:	a3 38 51 80 00       	mov    %eax,0x805138
  8018ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018f8:	a1 44 51 80 00       	mov    0x805144,%eax
  8018fd:	40                   	inc    %eax
  8018fe:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801903:	90                   	nop
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80190c:	e8 e0 fd ff ff       	call   8016f1 <InitializeUHeap>
		if (size == 0) return NULL ;
  801911:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801915:	75 07                	jne    80191e <malloc+0x18>
  801917:	b8 00 00 00 00       	mov    $0x0,%eax
  80191c:	eb 7f                	jmp    80199d <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80191e:	e8 d2 08 00 00       	call   8021f5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801923:	85 c0                	test   %eax,%eax
  801925:	74 71                	je     801998 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801927:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80192e:	8b 55 08             	mov    0x8(%ebp),%edx
  801931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801934:	01 d0                	add    %edx,%eax
  801936:	48                   	dec    %eax
  801937:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80193a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193d:	ba 00 00 00 00       	mov    $0x0,%edx
  801942:	f7 75 f4             	divl   -0xc(%ebp)
  801945:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801948:	29 d0                	sub    %edx,%eax
  80194a:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80194d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801954:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80195b:	76 07                	jbe    801964 <malloc+0x5e>
					return NULL ;
  80195d:	b8 00 00 00 00       	mov    $0x0,%eax
  801962:	eb 39                	jmp    80199d <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801964:	83 ec 0c             	sub    $0xc,%esp
  801967:	ff 75 08             	pushl  0x8(%ebp)
  80196a:	e8 e6 0d 00 00       	call   802755 <alloc_block_FF>
  80196f:	83 c4 10             	add    $0x10,%esp
  801972:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801975:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801979:	74 16                	je     801991 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80197b:	83 ec 0c             	sub    $0xc,%esp
  80197e:	ff 75 ec             	pushl  -0x14(%ebp)
  801981:	e8 37 0c 00 00       	call   8025bd <insert_sorted_allocList>
  801986:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801989:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80198c:	8b 40 08             	mov    0x8(%eax),%eax
  80198f:	eb 0c                	jmp    80199d <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801991:	b8 00 00 00 00       	mov    $0x0,%eax
  801996:	eb 05                	jmp    80199d <malloc+0x97>
				}
		}
	return 0;
  801998:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80199d:	c9                   	leave  
  80199e:	c3                   	ret    

0080199f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80199f:	55                   	push   %ebp
  8019a0:	89 e5                	mov    %esp,%ebp
  8019a2:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8019a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8019ab:	83 ec 08             	sub    $0x8,%esp
  8019ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b1:	68 40 50 80 00       	push   $0x805040
  8019b6:	e8 cf 0b 00 00       	call   80258a <find_block>
  8019bb:	83 c4 10             	add    $0x10,%esp
  8019be:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8019c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8019ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019cd:	8b 40 08             	mov    0x8(%eax),%eax
  8019d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8019d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019d7:	0f 84 a1 00 00 00    	je     801a7e <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8019dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019e1:	75 17                	jne    8019fa <free+0x5b>
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	68 d5 40 80 00       	push   $0x8040d5
  8019eb:	68 80 00 00 00       	push   $0x80
  8019f0:	68 f3 40 80 00       	push   $0x8040f3
  8019f5:	e8 b9 ec ff ff       	call   8006b3 <_panic>
  8019fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fd:	8b 00                	mov    (%eax),%eax
  8019ff:	85 c0                	test   %eax,%eax
  801a01:	74 10                	je     801a13 <free+0x74>
  801a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a06:	8b 00                	mov    (%eax),%eax
  801a08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0b:	8b 52 04             	mov    0x4(%edx),%edx
  801a0e:	89 50 04             	mov    %edx,0x4(%eax)
  801a11:	eb 0b                	jmp    801a1e <free+0x7f>
  801a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a16:	8b 40 04             	mov    0x4(%eax),%eax
  801a19:	a3 44 50 80 00       	mov    %eax,0x805044
  801a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a21:	8b 40 04             	mov    0x4(%eax),%eax
  801a24:	85 c0                	test   %eax,%eax
  801a26:	74 0f                	je     801a37 <free+0x98>
  801a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2b:	8b 40 04             	mov    0x4(%eax),%eax
  801a2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a31:	8b 12                	mov    (%edx),%edx
  801a33:	89 10                	mov    %edx,(%eax)
  801a35:	eb 0a                	jmp    801a41 <free+0xa2>
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	8b 00                	mov    (%eax),%eax
  801a3c:	a3 40 50 80 00       	mov    %eax,0x805040
  801a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a54:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a59:	48                   	dec    %eax
  801a5a:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801a5f:	83 ec 0c             	sub    $0xc,%esp
  801a62:	ff 75 f0             	pushl  -0x10(%ebp)
  801a65:	e8 29 12 00 00       	call   802c93 <insert_sorted_with_merge_freeList>
  801a6a:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801a6d:	83 ec 08             	sub    $0x8,%esp
  801a70:	ff 75 ec             	pushl  -0x14(%ebp)
  801a73:	ff 75 e8             	pushl  -0x18(%ebp)
  801a76:	e8 74 03 00 00       	call   801def <sys_free_user_mem>
  801a7b:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a7e:	90                   	nop
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 38             	sub    $0x38,%esp
  801a87:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a8d:	e8 5f fc ff ff       	call   8016f1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801a92:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801a96:	75 0a                	jne    801aa2 <smalloc+0x21>
  801a98:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9d:	e9 b2 00 00 00       	jmp    801b54 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801aa2:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801aa9:	76 0a                	jbe    801ab5 <smalloc+0x34>
		return NULL;
  801aab:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab0:	e9 9f 00 00 00       	jmp    801b54 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801ab5:	e8 3b 07 00 00       	call   8021f5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801aba:	85 c0                	test   %eax,%eax
  801abc:	0f 84 8d 00 00 00    	je     801b4f <smalloc+0xce>
	struct MemBlock *b = NULL;
  801ac2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801ac9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ad6:	01 d0                	add    %edx,%eax
  801ad8:	48                   	dec    %eax
  801ad9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801adf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae4:	f7 75 f0             	divl   -0x10(%ebp)
  801ae7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aea:	29 d0                	sub    %edx,%eax
  801aec:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801aef:	83 ec 0c             	sub    $0xc,%esp
  801af2:	ff 75 e8             	pushl  -0x18(%ebp)
  801af5:	e8 5b 0c 00 00       	call   802755 <alloc_block_FF>
  801afa:	83 c4 10             	add    $0x10,%esp
  801afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801b00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b04:	75 07                	jne    801b0d <smalloc+0x8c>
			return NULL;
  801b06:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0b:	eb 47                	jmp    801b54 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801b0d:	83 ec 0c             	sub    $0xc,%esp
  801b10:	ff 75 f4             	pushl  -0xc(%ebp)
  801b13:	e8 a5 0a 00 00       	call   8025bd <insert_sorted_allocList>
  801b18:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1e:	8b 40 08             	mov    0x8(%eax),%eax
  801b21:	89 c2                	mov    %eax,%edx
  801b23:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b27:	52                   	push   %edx
  801b28:	50                   	push   %eax
  801b29:	ff 75 0c             	pushl  0xc(%ebp)
  801b2c:	ff 75 08             	pushl  0x8(%ebp)
  801b2f:	e8 46 04 00 00       	call   801f7a <sys_createSharedObject>
  801b34:	83 c4 10             	add    $0x10,%esp
  801b37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801b3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b3e:	78 08                	js     801b48 <smalloc+0xc7>
		return (void *)b->sva;
  801b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b43:	8b 40 08             	mov    0x8(%eax),%eax
  801b46:	eb 0c                	jmp    801b54 <smalloc+0xd3>
		}else{
		return NULL;
  801b48:	b8 00 00 00 00       	mov    $0x0,%eax
  801b4d:	eb 05                	jmp    801b54 <smalloc+0xd3>
			}

	}return NULL;
  801b4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b5c:	e8 90 fb ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b61:	e8 8f 06 00 00       	call   8021f5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b66:	85 c0                	test   %eax,%eax
  801b68:	0f 84 ad 00 00 00    	je     801c1b <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b6e:	83 ec 08             	sub    $0x8,%esp
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	ff 75 08             	pushl  0x8(%ebp)
  801b77:	e8 28 04 00 00       	call   801fa4 <sys_getSizeOfSharedObject>
  801b7c:	83 c4 10             	add    $0x10,%esp
  801b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801b82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b86:	79 0a                	jns    801b92 <sget+0x3c>
    {
    	return NULL;
  801b88:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8d:	e9 8e 00 00 00       	jmp    801c20 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801b92:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801b99:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801ba0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ba6:	01 d0                	add    %edx,%eax
  801ba8:	48                   	dec    %eax
  801ba9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801baf:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb4:	f7 75 ec             	divl   -0x14(%ebp)
  801bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bba:	29 d0                	sub    %edx,%eax
  801bbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801bbf:	83 ec 0c             	sub    $0xc,%esp
  801bc2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bc5:	e8 8b 0b 00 00       	call   802755 <alloc_block_FF>
  801bca:	83 c4 10             	add    $0x10,%esp
  801bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801bd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bd4:	75 07                	jne    801bdd <sget+0x87>
				return NULL;
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdb:	eb 43                	jmp    801c20 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	ff 75 f0             	pushl  -0x10(%ebp)
  801be3:	e8 d5 09 00 00       	call   8025bd <insert_sorted_allocList>
  801be8:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801beb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bee:	8b 40 08             	mov    0x8(%eax),%eax
  801bf1:	83 ec 04             	sub    $0x4,%esp
  801bf4:	50                   	push   %eax
  801bf5:	ff 75 0c             	pushl  0xc(%ebp)
  801bf8:	ff 75 08             	pushl  0x8(%ebp)
  801bfb:	e8 c1 03 00 00       	call   801fc1 <sys_getSharedObject>
  801c00:	83 c4 10             	add    $0x10,%esp
  801c03:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801c06:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c0a:	78 08                	js     801c14 <sget+0xbe>
			return (void *)b->sva;
  801c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0f:	8b 40 08             	mov    0x8(%eax),%eax
  801c12:	eb 0c                	jmp    801c20 <sget+0xca>
			}else{
			return NULL;
  801c14:	b8 00 00 00 00       	mov    $0x0,%eax
  801c19:	eb 05                	jmp    801c20 <sget+0xca>
			}
    }}return NULL;
  801c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c28:	e8 c4 fa ff ff       	call   8016f1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c2d:	83 ec 04             	sub    $0x4,%esp
  801c30:	68 24 41 80 00       	push   $0x804124
  801c35:	68 03 01 00 00       	push   $0x103
  801c3a:	68 f3 40 80 00       	push   $0x8040f3
  801c3f:	e8 6f ea ff ff       	call   8006b3 <_panic>

00801c44 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c44:	55                   	push   %ebp
  801c45:	89 e5                	mov    %esp,%ebp
  801c47:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c4a:	83 ec 04             	sub    $0x4,%esp
  801c4d:	68 4c 41 80 00       	push   $0x80414c
  801c52:	68 17 01 00 00       	push   $0x117
  801c57:	68 f3 40 80 00       	push   $0x8040f3
  801c5c:	e8 52 ea ff ff       	call   8006b3 <_panic>

00801c61 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c67:	83 ec 04             	sub    $0x4,%esp
  801c6a:	68 70 41 80 00       	push   $0x804170
  801c6f:	68 22 01 00 00       	push   $0x122
  801c74:	68 f3 40 80 00       	push   $0x8040f3
  801c79:	e8 35 ea ff ff       	call   8006b3 <_panic>

00801c7e <shrink>:

}
void shrink(uint32 newSize)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	68 70 41 80 00       	push   $0x804170
  801c8c:	68 27 01 00 00       	push   $0x127
  801c91:	68 f3 40 80 00       	push   $0x8040f3
  801c96:	e8 18 ea ff ff       	call   8006b3 <_panic>

00801c9b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca1:	83 ec 04             	sub    $0x4,%esp
  801ca4:	68 70 41 80 00       	push   $0x804170
  801ca9:	68 2c 01 00 00       	push   $0x12c
  801cae:	68 f3 40 80 00       	push   $0x8040f3
  801cb3:	e8 fb e9 ff ff       	call   8006b3 <_panic>

00801cb8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	57                   	push   %edi
  801cbc:	56                   	push   %esi
  801cbd:	53                   	push   %ebx
  801cbe:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cca:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ccd:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cd0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cd3:	cd 30                	int    $0x30
  801cd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cdb:	83 c4 10             	add    $0x10,%esp
  801cde:	5b                   	pop    %ebx
  801cdf:	5e                   	pop    %esi
  801ce0:	5f                   	pop    %edi
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    

00801ce3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 04             	sub    $0x4,%esp
  801ce9:	8b 45 10             	mov    0x10(%ebp),%eax
  801cec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801cef:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	52                   	push   %edx
  801cfb:	ff 75 0c             	pushl  0xc(%ebp)
  801cfe:	50                   	push   %eax
  801cff:	6a 00                	push   $0x0
  801d01:	e8 b2 ff ff ff       	call   801cb8 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	90                   	nop
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_cgetc>:

int
sys_cgetc(void)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 01                	push   $0x1
  801d1b:	e8 98 ff ff ff       	call   801cb8 <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
}
  801d23:	c9                   	leave  
  801d24:	c3                   	ret    

00801d25 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d25:	55                   	push   %ebp
  801d26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d28:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	52                   	push   %edx
  801d35:	50                   	push   %eax
  801d36:	6a 05                	push   $0x5
  801d38:	e8 7b ff ff ff       	call   801cb8 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d47:	8b 75 18             	mov    0x18(%ebp),%esi
  801d4a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d53:	8b 45 08             	mov    0x8(%ebp),%eax
  801d56:	56                   	push   %esi
  801d57:	53                   	push   %ebx
  801d58:	51                   	push   %ecx
  801d59:	52                   	push   %edx
  801d5a:	50                   	push   %eax
  801d5b:	6a 06                	push   $0x6
  801d5d:	e8 56 ff ff ff       	call   801cb8 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
}
  801d65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d68:	5b                   	pop    %ebx
  801d69:	5e                   	pop    %esi
  801d6a:	5d                   	pop    %ebp
  801d6b:	c3                   	ret    

00801d6c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	52                   	push   %edx
  801d7c:	50                   	push   %eax
  801d7d:	6a 07                	push   $0x7
  801d7f:	e8 34 ff ff ff       	call   801cb8 <syscall>
  801d84:	83 c4 18             	add    $0x18,%esp
}
  801d87:	c9                   	leave  
  801d88:	c3                   	ret    

00801d89 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	6a 08                	push   $0x8
  801d9a:	e8 19 ff ff ff       	call   801cb8 <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
}
  801da2:	c9                   	leave  
  801da3:	c3                   	ret    

00801da4 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801da4:	55                   	push   %ebp
  801da5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 09                	push   $0x9
  801db3:	e8 00 ff ff ff       	call   801cb8 <syscall>
  801db8:	83 c4 18             	add    $0x18,%esp
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 0a                	push   $0xa
  801dcc:	e8 e7 fe ff ff       	call   801cb8 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 0b                	push   $0xb
  801de5:	e8 ce fe ff ff       	call   801cb8 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	ff 75 0c             	pushl  0xc(%ebp)
  801dfb:	ff 75 08             	pushl  0x8(%ebp)
  801dfe:	6a 0f                	push   $0xf
  801e00:	e8 b3 fe ff ff       	call   801cb8 <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
	return;
  801e08:	90                   	nop
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	ff 75 0c             	pushl  0xc(%ebp)
  801e17:	ff 75 08             	pushl  0x8(%ebp)
  801e1a:	6a 10                	push   $0x10
  801e1c:	e8 97 fe ff ff       	call   801cb8 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
	return ;
  801e24:	90                   	nop
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	ff 75 10             	pushl  0x10(%ebp)
  801e31:	ff 75 0c             	pushl  0xc(%ebp)
  801e34:	ff 75 08             	pushl  0x8(%ebp)
  801e37:	6a 11                	push   $0x11
  801e39:	e8 7a fe ff ff       	call   801cb8 <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e41:	90                   	nop
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 0c                	push   $0xc
  801e53:	e8 60 fe ff ff       	call   801cb8 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
}
  801e5b:	c9                   	leave  
  801e5c:	c3                   	ret    

00801e5d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	ff 75 08             	pushl  0x8(%ebp)
  801e6b:	6a 0d                	push   $0xd
  801e6d:	e8 46 fe ff ff       	call   801cb8 <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 0e                	push   $0xe
  801e86:	e8 2d fe ff ff       	call   801cb8 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	90                   	nop
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 13                	push   $0x13
  801ea0:	e8 13 fe ff ff       	call   801cb8 <syscall>
  801ea5:	83 c4 18             	add    $0x18,%esp
}
  801ea8:	90                   	nop
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 14                	push   $0x14
  801eba:	e8 f9 fd ff ff       	call   801cb8 <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
}
  801ec2:	90                   	nop
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
  801ec8:	83 ec 04             	sub    $0x4,%esp
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ed1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	50                   	push   %eax
  801ede:	6a 15                	push   $0x15
  801ee0:	e8 d3 fd ff ff       	call   801cb8 <syscall>
  801ee5:	83 c4 18             	add    $0x18,%esp
}
  801ee8:	90                   	nop
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801eee:	6a 00                	push   $0x0
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 16                	push   $0x16
  801efa:	e8 b9 fd ff ff       	call   801cb8 <syscall>
  801eff:	83 c4 18             	add    $0x18,%esp
}
  801f02:	90                   	nop
  801f03:	c9                   	leave  
  801f04:	c3                   	ret    

00801f05 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f05:	55                   	push   %ebp
  801f06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	ff 75 0c             	pushl  0xc(%ebp)
  801f14:	50                   	push   %eax
  801f15:	6a 17                	push   $0x17
  801f17:	e8 9c fd ff ff       	call   801cb8 <syscall>
  801f1c:	83 c4 18             	add    $0x18,%esp
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	52                   	push   %edx
  801f31:	50                   	push   %eax
  801f32:	6a 1a                	push   $0x1a
  801f34:	e8 7f fd ff ff       	call   801cb8 <syscall>
  801f39:	83 c4 18             	add    $0x18,%esp
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f44:	8b 45 08             	mov    0x8(%ebp),%eax
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	52                   	push   %edx
  801f4e:	50                   	push   %eax
  801f4f:	6a 18                	push   $0x18
  801f51:	e8 62 fd ff ff       	call   801cb8 <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
}
  801f59:	90                   	nop
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	6a 00                	push   $0x0
  801f6b:	52                   	push   %edx
  801f6c:	50                   	push   %eax
  801f6d:	6a 19                	push   $0x19
  801f6f:	e8 44 fd ff ff       	call   801cb8 <syscall>
  801f74:	83 c4 18             	add    $0x18,%esp
}
  801f77:	90                   	nop
  801f78:	c9                   	leave  
  801f79:	c3                   	ret    

00801f7a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f7a:	55                   	push   %ebp
  801f7b:	89 e5                	mov    %esp,%ebp
  801f7d:	83 ec 04             	sub    $0x4,%esp
  801f80:	8b 45 10             	mov    0x10(%ebp),%eax
  801f83:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801f86:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801f89:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f90:	6a 00                	push   $0x0
  801f92:	51                   	push   %ecx
  801f93:	52                   	push   %edx
  801f94:	ff 75 0c             	pushl  0xc(%ebp)
  801f97:	50                   	push   %eax
  801f98:	6a 1b                	push   $0x1b
  801f9a:	e8 19 fd ff ff       	call   801cb8 <syscall>
  801f9f:	83 c4 18             	add    $0x18,%esp
}
  801fa2:	c9                   	leave  
  801fa3:	c3                   	ret    

00801fa4 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fa7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	6a 00                	push   $0x0
  801faf:	6a 00                	push   $0x0
  801fb1:	6a 00                	push   $0x0
  801fb3:	52                   	push   %edx
  801fb4:	50                   	push   %eax
  801fb5:	6a 1c                	push   $0x1c
  801fb7:	e8 fc fc ff ff       	call   801cb8 <syscall>
  801fbc:	83 c4 18             	add    $0x18,%esp
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fc4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fca:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcd:	6a 00                	push   $0x0
  801fcf:	6a 00                	push   $0x0
  801fd1:	51                   	push   %ecx
  801fd2:	52                   	push   %edx
  801fd3:	50                   	push   %eax
  801fd4:	6a 1d                	push   $0x1d
  801fd6:	e8 dd fc ff ff       	call   801cb8 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 00                	push   $0x0
  801fef:	52                   	push   %edx
  801ff0:	50                   	push   %eax
  801ff1:	6a 1e                	push   $0x1e
  801ff3:	e8 c0 fc ff ff       	call   801cb8 <syscall>
  801ff8:	83 c4 18             	add    $0x18,%esp
}
  801ffb:	c9                   	leave  
  801ffc:	c3                   	ret    

00801ffd <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 00                	push   $0x0
  802008:	6a 00                	push   $0x0
  80200a:	6a 1f                	push   $0x1f
  80200c:	e8 a7 fc ff ff       	call   801cb8 <syscall>
  802011:	83 c4 18             	add    $0x18,%esp
}
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	6a 00                	push   $0x0
  80201e:	ff 75 14             	pushl  0x14(%ebp)
  802021:	ff 75 10             	pushl  0x10(%ebp)
  802024:	ff 75 0c             	pushl  0xc(%ebp)
  802027:	50                   	push   %eax
  802028:	6a 20                	push   $0x20
  80202a:	e8 89 fc ff ff       	call   801cb8 <syscall>
  80202f:	83 c4 18             	add    $0x18,%esp
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	6a 00                	push   $0x0
  80203c:	6a 00                	push   $0x0
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	50                   	push   %eax
  802043:	6a 21                	push   $0x21
  802045:	e8 6e fc ff ff       	call   801cb8 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	90                   	nop
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	50                   	push   %eax
  80205f:	6a 22                	push   $0x22
  802061:	e8 52 fc ff ff       	call   801cb8 <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80206e:	6a 00                	push   $0x0
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 02                	push   $0x2
  80207a:	e8 39 fc ff ff       	call   801cb8 <syscall>
  80207f:	83 c4 18             	add    $0x18,%esp
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	6a 00                	push   $0x0
  802091:	6a 03                	push   $0x3
  802093:	e8 20 fc ff ff       	call   801cb8 <syscall>
  802098:	83 c4 18             	add    $0x18,%esp
}
  80209b:	c9                   	leave  
  80209c:	c3                   	ret    

0080209d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80209d:	55                   	push   %ebp
  80209e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 04                	push   $0x4
  8020ac:	e8 07 fc ff ff       	call   801cb8 <syscall>
  8020b1:	83 c4 18             	add    $0x18,%esp
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <sys_exit_env>:


void sys_exit_env(void)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 00                	push   $0x0
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 23                	push   $0x23
  8020c5:	e8 ee fb ff ff       	call   801cb8 <syscall>
  8020ca:	83 c4 18             	add    $0x18,%esp
}
  8020cd:	90                   	nop
  8020ce:	c9                   	leave  
  8020cf:	c3                   	ret    

008020d0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020d6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020d9:	8d 50 04             	lea    0x4(%eax),%edx
  8020dc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	52                   	push   %edx
  8020e6:	50                   	push   %eax
  8020e7:	6a 24                	push   $0x24
  8020e9:	e8 ca fb ff ff       	call   801cb8 <syscall>
  8020ee:	83 c4 18             	add    $0x18,%esp
	return result;
  8020f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8020f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8020fa:	89 01                	mov    %eax,(%ecx)
  8020fc:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	c9                   	leave  
  802103:	c2 04 00             	ret    $0x4

00802106 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802109:	6a 00                	push   $0x0
  80210b:	6a 00                	push   $0x0
  80210d:	ff 75 10             	pushl  0x10(%ebp)
  802110:	ff 75 0c             	pushl  0xc(%ebp)
  802113:	ff 75 08             	pushl  0x8(%ebp)
  802116:	6a 12                	push   $0x12
  802118:	e8 9b fb ff ff       	call   801cb8 <syscall>
  80211d:	83 c4 18             	add    $0x18,%esp
	return ;
  802120:	90                   	nop
}
  802121:	c9                   	leave  
  802122:	c3                   	ret    

00802123 <sys_rcr2>:
uint32 sys_rcr2()
{
  802123:	55                   	push   %ebp
  802124:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 25                	push   $0x25
  802132:	e8 81 fb ff ff       	call   801cb8 <syscall>
  802137:	83 c4 18             	add    $0x18,%esp
}
  80213a:	c9                   	leave  
  80213b:	c3                   	ret    

0080213c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80213c:	55                   	push   %ebp
  80213d:	89 e5                	mov    %esp,%ebp
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802148:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	50                   	push   %eax
  802155:	6a 26                	push   $0x26
  802157:	e8 5c fb ff ff       	call   801cb8 <syscall>
  80215c:	83 c4 18             	add    $0x18,%esp
	return ;
  80215f:	90                   	nop
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <rsttst>:
void rsttst()
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 28                	push   $0x28
  802171:	e8 42 fb ff ff       	call   801cb8 <syscall>
  802176:	83 c4 18             	add    $0x18,%esp
	return ;
  802179:	90                   	nop
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	8b 45 14             	mov    0x14(%ebp),%eax
  802185:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802188:	8b 55 18             	mov    0x18(%ebp),%edx
  80218b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80218f:	52                   	push   %edx
  802190:	50                   	push   %eax
  802191:	ff 75 10             	pushl  0x10(%ebp)
  802194:	ff 75 0c             	pushl  0xc(%ebp)
  802197:	ff 75 08             	pushl  0x8(%ebp)
  80219a:	6a 27                	push   $0x27
  80219c:	e8 17 fb ff ff       	call   801cb8 <syscall>
  8021a1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a4:	90                   	nop
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <chktst>:
void chktst(uint32 n)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021aa:	6a 00                	push   $0x0
  8021ac:	6a 00                	push   $0x0
  8021ae:	6a 00                	push   $0x0
  8021b0:	6a 00                	push   $0x0
  8021b2:	ff 75 08             	pushl  0x8(%ebp)
  8021b5:	6a 29                	push   $0x29
  8021b7:	e8 fc fa ff ff       	call   801cb8 <syscall>
  8021bc:	83 c4 18             	add    $0x18,%esp
	return ;
  8021bf:	90                   	nop
}
  8021c0:	c9                   	leave  
  8021c1:	c3                   	ret    

008021c2 <inctst>:

void inctst()
{
  8021c2:	55                   	push   %ebp
  8021c3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021c5:	6a 00                	push   $0x0
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 2a                	push   $0x2a
  8021d1:	e8 e2 fa ff ff       	call   801cb8 <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d9:	90                   	nop
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <gettst>:
uint32 gettst()
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 2b                	push   $0x2b
  8021eb:	e8 c8 fa ff ff       	call   801cb8 <syscall>
  8021f0:	83 c4 18             	add    $0x18,%esp
}
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
  8021f8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 2c                	push   $0x2c
  802207:	e8 ac fa ff ff       	call   801cb8 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
  80220f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802212:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802216:	75 07                	jne    80221f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802218:	b8 01 00 00 00       	mov    $0x1,%eax
  80221d:	eb 05                	jmp    802224 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80221f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802224:	c9                   	leave  
  802225:	c3                   	ret    

00802226 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802226:	55                   	push   %ebp
  802227:	89 e5                	mov    %esp,%ebp
  802229:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80222c:	6a 00                	push   $0x0
  80222e:	6a 00                	push   $0x0
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 2c                	push   $0x2c
  802238:	e8 7b fa ff ff       	call   801cb8 <syscall>
  80223d:	83 c4 18             	add    $0x18,%esp
  802240:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802243:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802247:	75 07                	jne    802250 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802249:	b8 01 00 00 00       	mov    $0x1,%eax
  80224e:	eb 05                	jmp    802255 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802250:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802255:	c9                   	leave  
  802256:	c3                   	ret    

00802257 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802257:	55                   	push   %ebp
  802258:	89 e5                	mov    %esp,%ebp
  80225a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80225d:	6a 00                	push   $0x0
  80225f:	6a 00                	push   $0x0
  802261:	6a 00                	push   $0x0
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 2c                	push   $0x2c
  802269:	e8 4a fa ff ff       	call   801cb8 <syscall>
  80226e:	83 c4 18             	add    $0x18,%esp
  802271:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802274:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802278:	75 07                	jne    802281 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80227a:	b8 01 00 00 00       	mov    $0x1,%eax
  80227f:	eb 05                	jmp    802286 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802281:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802286:	c9                   	leave  
  802287:	c3                   	ret    

00802288 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80228e:	6a 00                	push   $0x0
  802290:	6a 00                	push   $0x0
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 2c                	push   $0x2c
  80229a:	e8 19 fa ff ff       	call   801cb8 <syscall>
  80229f:	83 c4 18             	add    $0x18,%esp
  8022a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022a5:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022a9:	75 07                	jne    8022b2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022ab:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b0:	eb 05                	jmp    8022b7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	ff 75 08             	pushl  0x8(%ebp)
  8022c7:	6a 2d                	push   $0x2d
  8022c9:	e8 ea f9 ff ff       	call   801cb8 <syscall>
  8022ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8022d1:	90                   	nop
}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022d8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e4:	6a 00                	push   $0x0
  8022e6:	53                   	push   %ebx
  8022e7:	51                   	push   %ecx
  8022e8:	52                   	push   %edx
  8022e9:	50                   	push   %eax
  8022ea:	6a 2e                	push   $0x2e
  8022ec:	e8 c7 f9 ff ff       	call   801cb8 <syscall>
  8022f1:	83 c4 18             	add    $0x18,%esp
}
  8022f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8022f7:	c9                   	leave  
  8022f8:	c3                   	ret    

008022f9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8022f9:	55                   	push   %ebp
  8022fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8022fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	52                   	push   %edx
  802309:	50                   	push   %eax
  80230a:	6a 2f                	push   $0x2f
  80230c:	e8 a7 f9 ff ff       	call   801cb8 <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
  802319:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80231c:	83 ec 0c             	sub    $0xc,%esp
  80231f:	68 80 41 80 00       	push   $0x804180
  802324:	e8 3e e6 ff ff       	call   800967 <cprintf>
  802329:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80232c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802333:	83 ec 0c             	sub    $0xc,%esp
  802336:	68 ac 41 80 00       	push   $0x8041ac
  80233b:	e8 27 e6 ff ff       	call   800967 <cprintf>
  802340:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802343:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802347:	a1 38 51 80 00       	mov    0x805138,%eax
  80234c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234f:	eb 56                	jmp    8023a7 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802351:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802355:	74 1c                	je     802373 <print_mem_block_lists+0x5d>
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 50 08             	mov    0x8(%eax),%edx
  80235d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802360:	8b 48 08             	mov    0x8(%eax),%ecx
  802363:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802366:	8b 40 0c             	mov    0xc(%eax),%eax
  802369:	01 c8                	add    %ecx,%eax
  80236b:	39 c2                	cmp    %eax,%edx
  80236d:	73 04                	jae    802373 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80236f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 50 08             	mov    0x8(%eax),%edx
  802379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237c:	8b 40 0c             	mov    0xc(%eax),%eax
  80237f:	01 c2                	add    %eax,%edx
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 40 08             	mov    0x8(%eax),%eax
  802387:	83 ec 04             	sub    $0x4,%esp
  80238a:	52                   	push   %edx
  80238b:	50                   	push   %eax
  80238c:	68 c1 41 80 00       	push   $0x8041c1
  802391:	e8 d1 e5 ff ff       	call   800967 <cprintf>
  802396:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80239f:	a1 40 51 80 00       	mov    0x805140,%eax
  8023a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023ab:	74 07                	je     8023b4 <print_mem_block_lists+0x9e>
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	8b 00                	mov    (%eax),%eax
  8023b2:	eb 05                	jmp    8023b9 <print_mem_block_lists+0xa3>
  8023b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8023b9:	a3 40 51 80 00       	mov    %eax,0x805140
  8023be:	a1 40 51 80 00       	mov    0x805140,%eax
  8023c3:	85 c0                	test   %eax,%eax
  8023c5:	75 8a                	jne    802351 <print_mem_block_lists+0x3b>
  8023c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023cb:	75 84                	jne    802351 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023cd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023d1:	75 10                	jne    8023e3 <print_mem_block_lists+0xcd>
  8023d3:	83 ec 0c             	sub    $0xc,%esp
  8023d6:	68 d0 41 80 00       	push   $0x8041d0
  8023db:	e8 87 e5 ff ff       	call   800967 <cprintf>
  8023e0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8023ea:	83 ec 0c             	sub    $0xc,%esp
  8023ed:	68 f4 41 80 00       	push   $0x8041f4
  8023f2:	e8 70 e5 ff ff       	call   800967 <cprintf>
  8023f7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8023fa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8023fe:	a1 40 50 80 00       	mov    0x805040,%eax
  802403:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802406:	eb 56                	jmp    80245e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802408:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240c:	74 1c                	je     80242a <print_mem_block_lists+0x114>
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 50 08             	mov    0x8(%eax),%edx
  802414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802417:	8b 48 08             	mov    0x8(%eax),%ecx
  80241a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241d:	8b 40 0c             	mov    0xc(%eax),%eax
  802420:	01 c8                	add    %ecx,%eax
  802422:	39 c2                	cmp    %eax,%edx
  802424:	73 04                	jae    80242a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802426:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 50 08             	mov    0x8(%eax),%edx
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 0c             	mov    0xc(%eax),%eax
  802436:	01 c2                	add    %eax,%edx
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	8b 40 08             	mov    0x8(%eax),%eax
  80243e:	83 ec 04             	sub    $0x4,%esp
  802441:	52                   	push   %edx
  802442:	50                   	push   %eax
  802443:	68 c1 41 80 00       	push   $0x8041c1
  802448:	e8 1a e5 ff ff       	call   800967 <cprintf>
  80244d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802456:	a1 48 50 80 00       	mov    0x805048,%eax
  80245b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80245e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802462:	74 07                	je     80246b <print_mem_block_lists+0x155>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	eb 05                	jmp    802470 <print_mem_block_lists+0x15a>
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
  802470:	a3 48 50 80 00       	mov    %eax,0x805048
  802475:	a1 48 50 80 00       	mov    0x805048,%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	75 8a                	jne    802408 <print_mem_block_lists+0xf2>
  80247e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802482:	75 84                	jne    802408 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802484:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802488:	75 10                	jne    80249a <print_mem_block_lists+0x184>
  80248a:	83 ec 0c             	sub    $0xc,%esp
  80248d:	68 0c 42 80 00       	push   $0x80420c
  802492:	e8 d0 e4 ff ff       	call   800967 <cprintf>
  802497:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80249a:	83 ec 0c             	sub    $0xc,%esp
  80249d:	68 80 41 80 00       	push   $0x804180
  8024a2:	e8 c0 e4 ff ff       	call   800967 <cprintf>
  8024a7:	83 c4 10             	add    $0x10,%esp

}
  8024aa:	90                   	nop
  8024ab:	c9                   	leave  
  8024ac:	c3                   	ret    

008024ad <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024ad:	55                   	push   %ebp
  8024ae:	89 e5                	mov    %esp,%ebp
  8024b0:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8024b3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024ba:	00 00 00 
  8024bd:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024c4:	00 00 00 
  8024c7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024ce:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8024d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024d8:	e9 9e 00 00 00       	jmp    80257b <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8024dd:	a1 50 50 80 00       	mov    0x805050,%eax
  8024e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e5:	c1 e2 04             	shl    $0x4,%edx
  8024e8:	01 d0                	add    %edx,%eax
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	75 14                	jne    802502 <initialize_MemBlocksList+0x55>
  8024ee:	83 ec 04             	sub    $0x4,%esp
  8024f1:	68 34 42 80 00       	push   $0x804234
  8024f6:	6a 3d                	push   $0x3d
  8024f8:	68 57 42 80 00       	push   $0x804257
  8024fd:	e8 b1 e1 ff ff       	call   8006b3 <_panic>
  802502:	a1 50 50 80 00       	mov    0x805050,%eax
  802507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250a:	c1 e2 04             	shl    $0x4,%edx
  80250d:	01 d0                	add    %edx,%eax
  80250f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802515:	89 10                	mov    %edx,(%eax)
  802517:	8b 00                	mov    (%eax),%eax
  802519:	85 c0                	test   %eax,%eax
  80251b:	74 18                	je     802535 <initialize_MemBlocksList+0x88>
  80251d:	a1 48 51 80 00       	mov    0x805148,%eax
  802522:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802528:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80252b:	c1 e1 04             	shl    $0x4,%ecx
  80252e:	01 ca                	add    %ecx,%edx
  802530:	89 50 04             	mov    %edx,0x4(%eax)
  802533:	eb 12                	jmp    802547 <initialize_MemBlocksList+0x9a>
  802535:	a1 50 50 80 00       	mov    0x805050,%eax
  80253a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253d:	c1 e2 04             	shl    $0x4,%edx
  802540:	01 d0                	add    %edx,%eax
  802542:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802547:	a1 50 50 80 00       	mov    0x805050,%eax
  80254c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254f:	c1 e2 04             	shl    $0x4,%edx
  802552:	01 d0                	add    %edx,%eax
  802554:	a3 48 51 80 00       	mov    %eax,0x805148
  802559:	a1 50 50 80 00       	mov    0x805050,%eax
  80255e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802561:	c1 e2 04             	shl    $0x4,%edx
  802564:	01 d0                	add    %edx,%eax
  802566:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256d:	a1 54 51 80 00       	mov    0x805154,%eax
  802572:	40                   	inc    %eax
  802573:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802578:	ff 45 f4             	incl   -0xc(%ebp)
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802581:	0f 82 56 ff ff ff    	jb     8024dd <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802587:	90                   	nop
  802588:	c9                   	leave  
  802589:	c3                   	ret    

0080258a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
  80258d:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	8b 00                	mov    (%eax),%eax
  802595:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802598:	eb 18                	jmp    8025b2 <find_block+0x28>

		if(tmp->sva == va){
  80259a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80259d:	8b 40 08             	mov    0x8(%eax),%eax
  8025a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025a3:	75 05                	jne    8025aa <find_block+0x20>
			return tmp ;
  8025a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025a8:	eb 11                	jmp    8025bb <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8025aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025ad:	8b 00                	mov    (%eax),%eax
  8025af:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8025b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025b6:	75 e2                	jne    80259a <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8025b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8025bb:	c9                   	leave  
  8025bc:	c3                   	ret    

008025bd <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025bd:	55                   	push   %ebp
  8025be:	89 e5                	mov    %esp,%ebp
  8025c0:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8025c3:	a1 40 50 80 00       	mov    0x805040,%eax
  8025c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8025cb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8025d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025d7:	75 65                	jne    80263e <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8025d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025dd:	75 14                	jne    8025f3 <insert_sorted_allocList+0x36>
  8025df:	83 ec 04             	sub    $0x4,%esp
  8025e2:	68 34 42 80 00       	push   $0x804234
  8025e7:	6a 62                	push   $0x62
  8025e9:	68 57 42 80 00       	push   $0x804257
  8025ee:	e8 c0 e0 ff ff       	call   8006b3 <_panic>
  8025f3:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	89 10                	mov    %edx,(%eax)
  8025fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	85 c0                	test   %eax,%eax
  802605:	74 0d                	je     802614 <insert_sorted_allocList+0x57>
  802607:	a1 40 50 80 00       	mov    0x805040,%eax
  80260c:	8b 55 08             	mov    0x8(%ebp),%edx
  80260f:	89 50 04             	mov    %edx,0x4(%eax)
  802612:	eb 08                	jmp    80261c <insert_sorted_allocList+0x5f>
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	a3 44 50 80 00       	mov    %eax,0x805044
  80261c:	8b 45 08             	mov    0x8(%ebp),%eax
  80261f:	a3 40 50 80 00       	mov    %eax,0x805040
  802624:	8b 45 08             	mov    0x8(%ebp),%eax
  802627:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80262e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802633:	40                   	inc    %eax
  802634:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802639:	e9 14 01 00 00       	jmp    802752 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80263e:	8b 45 08             	mov    0x8(%ebp),%eax
  802641:	8b 50 08             	mov    0x8(%eax),%edx
  802644:	a1 44 50 80 00       	mov    0x805044,%eax
  802649:	8b 40 08             	mov    0x8(%eax),%eax
  80264c:	39 c2                	cmp    %eax,%edx
  80264e:	76 65                	jbe    8026b5 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802650:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802654:	75 14                	jne    80266a <insert_sorted_allocList+0xad>
  802656:	83 ec 04             	sub    $0x4,%esp
  802659:	68 70 42 80 00       	push   $0x804270
  80265e:	6a 64                	push   $0x64
  802660:	68 57 42 80 00       	push   $0x804257
  802665:	e8 49 e0 ff ff       	call   8006b3 <_panic>
  80266a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802670:	8b 45 08             	mov    0x8(%ebp),%eax
  802673:	89 50 04             	mov    %edx,0x4(%eax)
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	8b 40 04             	mov    0x4(%eax),%eax
  80267c:	85 c0                	test   %eax,%eax
  80267e:	74 0c                	je     80268c <insert_sorted_allocList+0xcf>
  802680:	a1 44 50 80 00       	mov    0x805044,%eax
  802685:	8b 55 08             	mov    0x8(%ebp),%edx
  802688:	89 10                	mov    %edx,(%eax)
  80268a:	eb 08                	jmp    802694 <insert_sorted_allocList+0xd7>
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	a3 40 50 80 00       	mov    %eax,0x805040
  802694:	8b 45 08             	mov    0x8(%ebp),%eax
  802697:	a3 44 50 80 00       	mov    %eax,0x805044
  80269c:	8b 45 08             	mov    0x8(%ebp),%eax
  80269f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026aa:	40                   	inc    %eax
  8026ab:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8026b0:	e9 9d 00 00 00       	jmp    802752 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8026b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8026bc:	e9 85 00 00 00       	jmp    802746 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	8b 50 08             	mov    0x8(%eax),%edx
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	8b 40 08             	mov    0x8(%eax),%eax
  8026cd:	39 c2                	cmp    %eax,%edx
  8026cf:	73 6a                	jae    80273b <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8026d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d5:	74 06                	je     8026dd <insert_sorted_allocList+0x120>
  8026d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026db:	75 14                	jne    8026f1 <insert_sorted_allocList+0x134>
  8026dd:	83 ec 04             	sub    $0x4,%esp
  8026e0:	68 94 42 80 00       	push   $0x804294
  8026e5:	6a 6b                	push   $0x6b
  8026e7:	68 57 42 80 00       	push   $0x804257
  8026ec:	e8 c2 df ff ff       	call   8006b3 <_panic>
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 50 04             	mov    0x4(%eax),%edx
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	89 50 04             	mov    %edx,0x4(%eax)
  8026fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802700:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802703:	89 10                	mov    %edx,(%eax)
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	8b 40 04             	mov    0x4(%eax),%eax
  80270b:	85 c0                	test   %eax,%eax
  80270d:	74 0d                	je     80271c <insert_sorted_allocList+0x15f>
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 04             	mov    0x4(%eax),%eax
  802715:	8b 55 08             	mov    0x8(%ebp),%edx
  802718:	89 10                	mov    %edx,(%eax)
  80271a:	eb 08                	jmp    802724 <insert_sorted_allocList+0x167>
  80271c:	8b 45 08             	mov    0x8(%ebp),%eax
  80271f:	a3 40 50 80 00       	mov    %eax,0x805040
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 55 08             	mov    0x8(%ebp),%edx
  80272a:	89 50 04             	mov    %edx,0x4(%eax)
  80272d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802732:	40                   	inc    %eax
  802733:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802738:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802739:	eb 17                	jmp    802752 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802743:	ff 45 f0             	incl   -0x10(%ebp)
  802746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802749:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80274c:	0f 8c 6f ff ff ff    	jl     8026c1 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802752:	90                   	nop
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80275b:	a1 38 51 80 00       	mov    0x805138,%eax
  802760:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802763:	e9 7c 01 00 00       	jmp    8028e4 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802771:	0f 86 cf 00 00 00    	jbe    802846 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802777:	a1 48 51 80 00       	mov    0x805148,%eax
  80277c:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80277f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802782:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	8b 55 08             	mov    0x8(%ebp),%edx
  80278b:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 50 08             	mov    0x8(%eax),%edx
  802794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802797:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a3:	89 c2                	mov    %eax,%edx
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 50 08             	mov    0x8(%eax),%edx
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	01 c2                	add    %eax,%edx
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8027bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027c0:	75 17                	jne    8027d9 <alloc_block_FF+0x84>
  8027c2:	83 ec 04             	sub    $0x4,%esp
  8027c5:	68 c9 42 80 00       	push   $0x8042c9
  8027ca:	68 83 00 00 00       	push   $0x83
  8027cf:	68 57 42 80 00       	push   $0x804257
  8027d4:	e8 da de ff ff       	call   8006b3 <_panic>
  8027d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	85 c0                	test   %eax,%eax
  8027e0:	74 10                	je     8027f2 <alloc_block_FF+0x9d>
  8027e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ea:	8b 52 04             	mov    0x4(%edx),%edx
  8027ed:	89 50 04             	mov    %edx,0x4(%eax)
  8027f0:	eb 0b                	jmp    8027fd <alloc_block_FF+0xa8>
  8027f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f5:	8b 40 04             	mov    0x4(%eax),%eax
  8027f8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802800:	8b 40 04             	mov    0x4(%eax),%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	74 0f                	je     802816 <alloc_block_FF+0xc1>
  802807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280a:	8b 40 04             	mov    0x4(%eax),%eax
  80280d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802810:	8b 12                	mov    (%edx),%edx
  802812:	89 10                	mov    %edx,(%eax)
  802814:	eb 0a                	jmp    802820 <alloc_block_FF+0xcb>
  802816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802819:	8b 00                	mov    (%eax),%eax
  80281b:	a3 48 51 80 00       	mov    %eax,0x805148
  802820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802823:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802829:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802833:	a1 54 51 80 00       	mov    0x805154,%eax
  802838:	48                   	dec    %eax
  802839:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  80283e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802841:	e9 ad 00 00 00       	jmp    8028f3 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 0c             	mov    0xc(%eax),%eax
  80284c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284f:	0f 85 87 00 00 00    	jne    8028dc <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802859:	75 17                	jne    802872 <alloc_block_FF+0x11d>
  80285b:	83 ec 04             	sub    $0x4,%esp
  80285e:	68 c9 42 80 00       	push   $0x8042c9
  802863:	68 87 00 00 00       	push   $0x87
  802868:	68 57 42 80 00       	push   $0x804257
  80286d:	e8 41 de ff ff       	call   8006b3 <_panic>
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	74 10                	je     80288b <alloc_block_FF+0x136>
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 00                	mov    (%eax),%eax
  802880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802883:	8b 52 04             	mov    0x4(%edx),%edx
  802886:	89 50 04             	mov    %edx,0x4(%eax)
  802889:	eb 0b                	jmp    802896 <alloc_block_FF+0x141>
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 40 04             	mov    0x4(%eax),%eax
  802891:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	74 0f                	je     8028af <alloc_block_FF+0x15a>
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 04             	mov    0x4(%eax),%eax
  8028a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a9:	8b 12                	mov    (%edx),%edx
  8028ab:	89 10                	mov    %edx,(%eax)
  8028ad:	eb 0a                	jmp    8028b9 <alloc_block_FF+0x164>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	a3 38 51 80 00       	mov    %eax,0x805138
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cc:	a1 44 51 80 00       	mov    0x805144,%eax
  8028d1:	48                   	dec    %eax
  8028d2:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	eb 17                	jmp    8028f3 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8028e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e8:	0f 85 7a fe ff ff    	jne    802768 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8028ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8028fb:	a1 38 51 80 00       	mov    0x805138,%eax
  802900:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802903:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  80290a:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802911:	a1 38 51 80 00       	mov    0x805138,%eax
  802916:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802919:	e9 d0 00 00 00       	jmp    8029ee <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 0c             	mov    0xc(%eax),%eax
  802924:	3b 45 08             	cmp    0x8(%ebp),%eax
  802927:	0f 82 b8 00 00 00    	jb     8029e5 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 40 0c             	mov    0xc(%eax),%eax
  802933:	2b 45 08             	sub    0x8(%ebp),%eax
  802936:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802939:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80293c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80293f:	0f 83 a1 00 00 00    	jae    8029e6 <alloc_block_BF+0xf1>
				differsize = differance ;
  802945:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802948:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80294b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802951:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802955:	0f 85 8b 00 00 00    	jne    8029e6 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80295b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80295f:	75 17                	jne    802978 <alloc_block_BF+0x83>
  802961:	83 ec 04             	sub    $0x4,%esp
  802964:	68 c9 42 80 00       	push   $0x8042c9
  802969:	68 a0 00 00 00       	push   $0xa0
  80296e:	68 57 42 80 00       	push   $0x804257
  802973:	e8 3b dd ff ff       	call   8006b3 <_panic>
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	8b 00                	mov    (%eax),%eax
  80297d:	85 c0                	test   %eax,%eax
  80297f:	74 10                	je     802991 <alloc_block_BF+0x9c>
  802981:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802984:	8b 00                	mov    (%eax),%eax
  802986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802989:	8b 52 04             	mov    0x4(%edx),%edx
  80298c:	89 50 04             	mov    %edx,0x4(%eax)
  80298f:	eb 0b                	jmp    80299c <alloc_block_BF+0xa7>
  802991:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802994:	8b 40 04             	mov    0x4(%eax),%eax
  802997:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80299c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299f:	8b 40 04             	mov    0x4(%eax),%eax
  8029a2:	85 c0                	test   %eax,%eax
  8029a4:	74 0f                	je     8029b5 <alloc_block_BF+0xc0>
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 40 04             	mov    0x4(%eax),%eax
  8029ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029af:	8b 12                	mov    (%edx),%edx
  8029b1:	89 10                	mov    %edx,(%eax)
  8029b3:	eb 0a                	jmp    8029bf <alloc_block_BF+0xca>
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	8b 00                	mov    (%eax),%eax
  8029ba:	a3 38 51 80 00       	mov    %eax,0x805138
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d2:	a1 44 51 80 00       	mov    0x805144,%eax
  8029d7:	48                   	dec    %eax
  8029d8:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  8029dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e0:	e9 0c 01 00 00       	jmp    802af1 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8029e5:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8029e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8029eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029f2:	74 07                	je     8029fb <alloc_block_BF+0x106>
  8029f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f7:	8b 00                	mov    (%eax),%eax
  8029f9:	eb 05                	jmp    802a00 <alloc_block_BF+0x10b>
  8029fb:	b8 00 00 00 00       	mov    $0x0,%eax
  802a00:	a3 40 51 80 00       	mov    %eax,0x805140
  802a05:	a1 40 51 80 00       	mov    0x805140,%eax
  802a0a:	85 c0                	test   %eax,%eax
  802a0c:	0f 85 0c ff ff ff    	jne    80291e <alloc_block_BF+0x29>
  802a12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a16:	0f 85 02 ff ff ff    	jne    80291e <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802a1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a20:	0f 84 c6 00 00 00    	je     802aec <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802a26:	a1 48 51 80 00       	mov    0x805148,%eax
  802a2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802a2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a31:	8b 55 08             	mov    0x8(%ebp),%edx
  802a34:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3a:	8b 50 08             	mov    0x8(%eax),%edx
  802a3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a40:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a46:	8b 40 0c             	mov    0xc(%eax),%eax
  802a49:	2b 45 08             	sub    0x8(%ebp),%eax
  802a4c:	89 c2                	mov    %eax,%edx
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a51:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802a54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a57:	8b 50 08             	mov    0x8(%eax),%edx
  802a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5d:	01 c2                	add    %eax,%edx
  802a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a62:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802a65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a69:	75 17                	jne    802a82 <alloc_block_BF+0x18d>
  802a6b:	83 ec 04             	sub    $0x4,%esp
  802a6e:	68 c9 42 80 00       	push   $0x8042c9
  802a73:	68 af 00 00 00       	push   $0xaf
  802a78:	68 57 42 80 00       	push   $0x804257
  802a7d:	e8 31 dc ff ff       	call   8006b3 <_panic>
  802a82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a85:	8b 00                	mov    (%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	74 10                	je     802a9b <alloc_block_BF+0x1a6>
  802a8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8e:	8b 00                	mov    (%eax),%eax
  802a90:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802a93:	8b 52 04             	mov    0x4(%edx),%edx
  802a96:	89 50 04             	mov    %edx,0x4(%eax)
  802a99:	eb 0b                	jmp    802aa6 <alloc_block_BF+0x1b1>
  802a9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9e:	8b 40 04             	mov    0x4(%eax),%eax
  802aa1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802aa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa9:	8b 40 04             	mov    0x4(%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 0f                	je     802abf <alloc_block_BF+0x1ca>
  802ab0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab3:	8b 40 04             	mov    0x4(%eax),%eax
  802ab6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ab9:	8b 12                	mov    (%edx),%edx
  802abb:	89 10                	mov    %edx,(%eax)
  802abd:	eb 0a                	jmp    802ac9 <alloc_block_BF+0x1d4>
  802abf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac2:	8b 00                	mov    (%eax),%eax
  802ac4:	a3 48 51 80 00       	mov    %eax,0x805148
  802ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ad2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802adc:	a1 54 51 80 00       	mov    0x805154,%eax
  802ae1:	48                   	dec    %eax
  802ae2:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802ae7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aea:	eb 05                	jmp    802af1 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802aec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802af1:	c9                   	leave  
  802af2:	c3                   	ret    

00802af3 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802af3:	55                   	push   %ebp
  802af4:	89 e5                	mov    %esp,%ebp
  802af6:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802af9:	a1 38 51 80 00       	mov    0x805138,%eax
  802afe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802b01:	e9 7c 01 00 00       	jmp    802c82 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b09:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b0f:	0f 86 cf 00 00 00    	jbe    802be4 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802b15:	a1 48 51 80 00       	mov    0x805148,%eax
  802b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802b1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b20:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802b23:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b26:	8b 55 08             	mov    0x8(%ebp),%edx
  802b29:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2f:	8b 50 08             	mov    0x8(%eax),%edx
  802b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b35:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3e:	2b 45 08             	sub    0x8(%ebp),%eax
  802b41:	89 c2                	mov    %eax,%edx
  802b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b46:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 50 08             	mov    0x8(%eax),%edx
  802b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b52:	01 c2                	add    %eax,%edx
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802b5a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b5e:	75 17                	jne    802b77 <alloc_block_NF+0x84>
  802b60:	83 ec 04             	sub    $0x4,%esp
  802b63:	68 c9 42 80 00       	push   $0x8042c9
  802b68:	68 c4 00 00 00       	push   $0xc4
  802b6d:	68 57 42 80 00       	push   $0x804257
  802b72:	e8 3c db ff ff       	call   8006b3 <_panic>
  802b77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7a:	8b 00                	mov    (%eax),%eax
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	74 10                	je     802b90 <alloc_block_NF+0x9d>
  802b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b83:	8b 00                	mov    (%eax),%eax
  802b85:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802b88:	8b 52 04             	mov    0x4(%edx),%edx
  802b8b:	89 50 04             	mov    %edx,0x4(%eax)
  802b8e:	eb 0b                	jmp    802b9b <alloc_block_NF+0xa8>
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	8b 40 04             	mov    0x4(%eax),%eax
  802b96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ba1:	85 c0                	test   %eax,%eax
  802ba3:	74 0f                	je     802bb4 <alloc_block_NF+0xc1>
  802ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba8:	8b 40 04             	mov    0x4(%eax),%eax
  802bab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bae:	8b 12                	mov    (%edx),%edx
  802bb0:	89 10                	mov    %edx,(%eax)
  802bb2:	eb 0a                	jmp    802bbe <alloc_block_NF+0xcb>
  802bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb7:	8b 00                	mov    (%eax),%eax
  802bb9:	a3 48 51 80 00       	mov    %eax,0x805148
  802bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd1:	a1 54 51 80 00       	mov    0x805154,%eax
  802bd6:	48                   	dec    %eax
  802bd7:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802bdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdf:	e9 ad 00 00 00       	jmp    802c91 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bea:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bed:	0f 85 87 00 00 00    	jne    802c7a <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802bf3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bf7:	75 17                	jne    802c10 <alloc_block_NF+0x11d>
  802bf9:	83 ec 04             	sub    $0x4,%esp
  802bfc:	68 c9 42 80 00       	push   $0x8042c9
  802c01:	68 c8 00 00 00       	push   $0xc8
  802c06:	68 57 42 80 00       	push   $0x804257
  802c0b:	e8 a3 da ff ff       	call   8006b3 <_panic>
  802c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	85 c0                	test   %eax,%eax
  802c17:	74 10                	je     802c29 <alloc_block_NF+0x136>
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 00                	mov    (%eax),%eax
  802c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c21:	8b 52 04             	mov    0x4(%edx),%edx
  802c24:	89 50 04             	mov    %edx,0x4(%eax)
  802c27:	eb 0b                	jmp    802c34 <alloc_block_NF+0x141>
  802c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2c:	8b 40 04             	mov    0x4(%eax),%eax
  802c2f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c37:	8b 40 04             	mov    0x4(%eax),%eax
  802c3a:	85 c0                	test   %eax,%eax
  802c3c:	74 0f                	je     802c4d <alloc_block_NF+0x15a>
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 40 04             	mov    0x4(%eax),%eax
  802c44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c47:	8b 12                	mov    (%edx),%edx
  802c49:	89 10                	mov    %edx,(%eax)
  802c4b:	eb 0a                	jmp    802c57 <alloc_block_NF+0x164>
  802c4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c50:	8b 00                	mov    (%eax),%eax
  802c52:	a3 38 51 80 00       	mov    %eax,0x805138
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c6f:	48                   	dec    %eax
  802c70:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	eb 17                	jmp    802c91 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802c82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c86:	0f 85 7a fe ff ff    	jne    802b06 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802c8c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802c91:	c9                   	leave  
  802c92:	c3                   	ret    

00802c93 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802c93:	55                   	push   %ebp
  802c94:	89 e5                	mov    %esp,%ebp
  802c96:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802c99:	a1 38 51 80 00       	mov    0x805138,%eax
  802c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802ca1:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802ca9:	a1 44 51 80 00       	mov    0x805144,%eax
  802cae:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802cb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cb5:	75 68                	jne    802d1f <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802cb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cbb:	75 17                	jne    802cd4 <insert_sorted_with_merge_freeList+0x41>
  802cbd:	83 ec 04             	sub    $0x4,%esp
  802cc0:	68 34 42 80 00       	push   $0x804234
  802cc5:	68 da 00 00 00       	push   $0xda
  802cca:	68 57 42 80 00       	push   $0x804257
  802ccf:	e8 df d9 ff ff       	call   8006b3 <_panic>
  802cd4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	89 10                	mov    %edx,(%eax)
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8b 00                	mov    (%eax),%eax
  802ce4:	85 c0                	test   %eax,%eax
  802ce6:	74 0d                	je     802cf5 <insert_sorted_with_merge_freeList+0x62>
  802ce8:	a1 38 51 80 00       	mov    0x805138,%eax
  802ced:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf0:	89 50 04             	mov    %edx,0x4(%eax)
  802cf3:	eb 08                	jmp    802cfd <insert_sorted_with_merge_freeList+0x6a>
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	a3 38 51 80 00       	mov    %eax,0x805138
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0f:	a1 44 51 80 00       	mov    0x805144,%eax
  802d14:	40                   	inc    %eax
  802d15:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802d1a:	e9 49 07 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d22:	8b 50 08             	mov    0x8(%eax),%edx
  802d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d28:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2b:	01 c2                	add    %eax,%edx
  802d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d30:	8b 40 08             	mov    0x8(%eax),%eax
  802d33:	39 c2                	cmp    %eax,%edx
  802d35:	73 77                	jae    802dae <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802d37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3a:	8b 00                	mov    (%eax),%eax
  802d3c:	85 c0                	test   %eax,%eax
  802d3e:	75 6e                	jne    802dae <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802d40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d44:	74 68                	je     802dae <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802d46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d4a:	75 17                	jne    802d63 <insert_sorted_with_merge_freeList+0xd0>
  802d4c:	83 ec 04             	sub    $0x4,%esp
  802d4f:	68 70 42 80 00       	push   $0x804270
  802d54:	68 e0 00 00 00       	push   $0xe0
  802d59:	68 57 42 80 00       	push   $0x804257
  802d5e:	e8 50 d9 ff ff       	call   8006b3 <_panic>
  802d63:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	89 50 04             	mov    %edx,0x4(%eax)
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	8b 40 04             	mov    0x4(%eax),%eax
  802d75:	85 c0                	test   %eax,%eax
  802d77:	74 0c                	je     802d85 <insert_sorted_with_merge_freeList+0xf2>
  802d79:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d81:	89 10                	mov    %edx,(%eax)
  802d83:	eb 08                	jmp    802d8d <insert_sorted_with_merge_freeList+0xfa>
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	a3 38 51 80 00       	mov    %eax,0x805138
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d9e:	a1 44 51 80 00       	mov    0x805144,%eax
  802da3:	40                   	inc    %eax
  802da4:	a3 44 51 80 00       	mov    %eax,0x805144
  802da9:	e9 ba 06 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	8b 50 0c             	mov    0xc(%eax),%edx
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	8b 40 08             	mov    0x8(%eax),%eax
  802dba:	01 c2                	add    %eax,%edx
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 40 08             	mov    0x8(%eax),%eax
  802dc2:	39 c2                	cmp    %eax,%edx
  802dc4:	73 78                	jae    802e3e <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc9:	8b 40 04             	mov    0x4(%eax),%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	75 6e                	jne    802e3e <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802dd0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dd4:	74 68                	je     802e3e <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802dd6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dda:	75 17                	jne    802df3 <insert_sorted_with_merge_freeList+0x160>
  802ddc:	83 ec 04             	sub    $0x4,%esp
  802ddf:	68 34 42 80 00       	push   $0x804234
  802de4:	68 e6 00 00 00       	push   $0xe6
  802de9:	68 57 42 80 00       	push   $0x804257
  802dee:	e8 c0 d8 ff ff       	call   8006b3 <_panic>
  802df3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	89 10                	mov    %edx,(%eax)
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 00                	mov    (%eax),%eax
  802e03:	85 c0                	test   %eax,%eax
  802e05:	74 0d                	je     802e14 <insert_sorted_with_merge_freeList+0x181>
  802e07:	a1 38 51 80 00       	mov    0x805138,%eax
  802e0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0f:	89 50 04             	mov    %edx,0x4(%eax)
  802e12:	eb 08                	jmp    802e1c <insert_sorted_with_merge_freeList+0x189>
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	a3 38 51 80 00       	mov    %eax,0x805138
  802e24:	8b 45 08             	mov    0x8(%ebp),%eax
  802e27:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2e:	a1 44 51 80 00       	mov    0x805144,%eax
  802e33:	40                   	inc    %eax
  802e34:	a3 44 51 80 00       	mov    %eax,0x805144
  802e39:	e9 2a 06 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802e3e:	a1 38 51 80 00       	mov    0x805138,%eax
  802e43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e46:	e9 ed 05 00 00       	jmp    803438 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802e4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4e:	8b 00                	mov    (%eax),%eax
  802e50:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802e53:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e57:	0f 84 a7 00 00 00    	je     802f04 <insert_sorted_with_merge_freeList+0x271>
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 50 0c             	mov    0xc(%eax),%edx
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 40 08             	mov    0x8(%eax),%eax
  802e69:	01 c2                	add    %eax,%edx
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	8b 40 08             	mov    0x8(%eax),%eax
  802e71:	39 c2                	cmp    %eax,%edx
  802e73:	0f 83 8b 00 00 00    	jae    802f04 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	8b 40 08             	mov    0x8(%eax),%eax
  802e85:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802e87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8a:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802e8d:	39 c2                	cmp    %eax,%edx
  802e8f:	73 73                	jae    802f04 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802e91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e95:	74 06                	je     802e9d <insert_sorted_with_merge_freeList+0x20a>
  802e97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9b:	75 17                	jne    802eb4 <insert_sorted_with_merge_freeList+0x221>
  802e9d:	83 ec 04             	sub    $0x4,%esp
  802ea0:	68 e8 42 80 00       	push   $0x8042e8
  802ea5:	68 f0 00 00 00       	push   $0xf0
  802eaa:	68 57 42 80 00       	push   $0x804257
  802eaf:	e8 ff d7 ff ff       	call   8006b3 <_panic>
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	8b 10                	mov    (%eax),%edx
  802eb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebc:	89 10                	mov    %edx,(%eax)
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	8b 00                	mov    (%eax),%eax
  802ec3:	85 c0                	test   %eax,%eax
  802ec5:	74 0b                	je     802ed2 <insert_sorted_with_merge_freeList+0x23f>
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecf:	89 50 04             	mov    %edx,0x4(%eax)
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed8:	89 10                	mov    %edx,(%eax)
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ee0:	89 50 04             	mov    %edx,0x4(%eax)
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	85 c0                	test   %eax,%eax
  802eea:	75 08                	jne    802ef4 <insert_sorted_with_merge_freeList+0x261>
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ef4:	a1 44 51 80 00       	mov    0x805144,%eax
  802ef9:	40                   	inc    %eax
  802efa:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  802eff:	e9 64 05 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802f04:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f09:	8b 50 0c             	mov    0xc(%eax),%edx
  802f0c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f11:	8b 40 08             	mov    0x8(%eax),%eax
  802f14:	01 c2                	add    %eax,%edx
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	8b 40 08             	mov    0x8(%eax),%eax
  802f1c:	39 c2                	cmp    %eax,%edx
  802f1e:	0f 85 b1 00 00 00    	jne    802fd5 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802f24:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	0f 84 a4 00 00 00    	je     802fd5 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802f31:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	0f 85 95 00 00 00    	jne    802fd5 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802f40:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f45:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f4b:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f51:	8b 52 0c             	mov    0xc(%edx),%edx
  802f54:	01 ca                	add    %ecx,%edx
  802f56:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802f63:	8b 45 08             	mov    0x8(%ebp),%eax
  802f66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f71:	75 17                	jne    802f8a <insert_sorted_with_merge_freeList+0x2f7>
  802f73:	83 ec 04             	sub    $0x4,%esp
  802f76:	68 34 42 80 00       	push   $0x804234
  802f7b:	68 ff 00 00 00       	push   $0xff
  802f80:	68 57 42 80 00       	push   $0x804257
  802f85:	e8 29 d7 ff ff       	call   8006b3 <_panic>
  802f8a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	89 10                	mov    %edx,(%eax)
  802f95:	8b 45 08             	mov    0x8(%ebp),%eax
  802f98:	8b 00                	mov    (%eax),%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	74 0d                	je     802fab <insert_sorted_with_merge_freeList+0x318>
  802f9e:	a1 48 51 80 00       	mov    0x805148,%eax
  802fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa6:	89 50 04             	mov    %edx,0x4(%eax)
  802fa9:	eb 08                	jmp    802fb3 <insert_sorted_with_merge_freeList+0x320>
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	a3 48 51 80 00       	mov    %eax,0x805148
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc5:	a1 54 51 80 00       	mov    0x805154,%eax
  802fca:	40                   	inc    %eax
  802fcb:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  802fd0:	e9 93 04 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	8b 50 08             	mov    0x8(%eax),%edx
  802fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fde:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe1:	01 c2                	add    %eax,%edx
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	8b 40 08             	mov    0x8(%eax),%eax
  802fe9:	39 c2                	cmp    %eax,%edx
  802feb:	0f 85 ae 00 00 00    	jne    80309f <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	8b 40 08             	mov    0x8(%eax),%eax
  802ffd:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803002:	8b 00                	mov    (%eax),%eax
  803004:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803007:	39 c2                	cmp    %eax,%edx
  803009:	0f 84 90 00 00 00    	je     80309f <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  80300f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803012:	8b 50 0c             	mov    0xc(%eax),%edx
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	8b 40 0c             	mov    0xc(%eax),%eax
  80301b:	01 c2                	add    %eax,%edx
  80301d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803020:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803037:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80303b:	75 17                	jne    803054 <insert_sorted_with_merge_freeList+0x3c1>
  80303d:	83 ec 04             	sub    $0x4,%esp
  803040:	68 34 42 80 00       	push   $0x804234
  803045:	68 0b 01 00 00       	push   $0x10b
  80304a:	68 57 42 80 00       	push   $0x804257
  80304f:	e8 5f d6 ff ff       	call   8006b3 <_panic>
  803054:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80305a:	8b 45 08             	mov    0x8(%ebp),%eax
  80305d:	89 10                	mov    %edx,(%eax)
  80305f:	8b 45 08             	mov    0x8(%ebp),%eax
  803062:	8b 00                	mov    (%eax),%eax
  803064:	85 c0                	test   %eax,%eax
  803066:	74 0d                	je     803075 <insert_sorted_with_merge_freeList+0x3e2>
  803068:	a1 48 51 80 00       	mov    0x805148,%eax
  80306d:	8b 55 08             	mov    0x8(%ebp),%edx
  803070:	89 50 04             	mov    %edx,0x4(%eax)
  803073:	eb 08                	jmp    80307d <insert_sorted_with_merge_freeList+0x3ea>
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	a3 48 51 80 00       	mov    %eax,0x805148
  803085:	8b 45 08             	mov    0x8(%ebp),%eax
  803088:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80308f:	a1 54 51 80 00       	mov    0x805154,%eax
  803094:	40                   	inc    %eax
  803095:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80309a:	e9 c9 03 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  80309f:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a2:	8b 50 0c             	mov    0xc(%eax),%edx
  8030a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a8:	8b 40 08             	mov    0x8(%eax),%eax
  8030ab:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8030ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b0:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8030b3:	39 c2                	cmp    %eax,%edx
  8030b5:	0f 85 bb 00 00 00    	jne    803176 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8030bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030bf:	0f 84 b1 00 00 00    	je     803176 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8030c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c8:	8b 40 04             	mov    0x4(%eax),%eax
  8030cb:	85 c0                	test   %eax,%eax
  8030cd:	0f 85 a3 00 00 00    	jne    803176 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8030d3:	a1 38 51 80 00       	mov    0x805138,%eax
  8030d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030db:	8b 52 08             	mov    0x8(%edx),%edx
  8030de:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8030e1:	a1 38 51 80 00       	mov    0x805138,%eax
  8030e6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030ec:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8030ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8030f5:	01 ca                	add    %ecx,%edx
  8030f7:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8030fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803104:	8b 45 08             	mov    0x8(%ebp),%eax
  803107:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80310e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803112:	75 17                	jne    80312b <insert_sorted_with_merge_freeList+0x498>
  803114:	83 ec 04             	sub    $0x4,%esp
  803117:	68 34 42 80 00       	push   $0x804234
  80311c:	68 17 01 00 00       	push   $0x117
  803121:	68 57 42 80 00       	push   $0x804257
  803126:	e8 88 d5 ff ff       	call   8006b3 <_panic>
  80312b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	89 10                	mov    %edx,(%eax)
  803136:	8b 45 08             	mov    0x8(%ebp),%eax
  803139:	8b 00                	mov    (%eax),%eax
  80313b:	85 c0                	test   %eax,%eax
  80313d:	74 0d                	je     80314c <insert_sorted_with_merge_freeList+0x4b9>
  80313f:	a1 48 51 80 00       	mov    0x805148,%eax
  803144:	8b 55 08             	mov    0x8(%ebp),%edx
  803147:	89 50 04             	mov    %edx,0x4(%eax)
  80314a:	eb 08                	jmp    803154 <insert_sorted_with_merge_freeList+0x4c1>
  80314c:	8b 45 08             	mov    0x8(%ebp),%eax
  80314f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803154:	8b 45 08             	mov    0x8(%ebp),%eax
  803157:	a3 48 51 80 00       	mov    %eax,0x805148
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803166:	a1 54 51 80 00       	mov    0x805154,%eax
  80316b:	40                   	inc    %eax
  80316c:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803171:	e9 f2 02 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803176:	8b 45 08             	mov    0x8(%ebp),%eax
  803179:	8b 50 08             	mov    0x8(%eax),%edx
  80317c:	8b 45 08             	mov    0x8(%ebp),%eax
  80317f:	8b 40 0c             	mov    0xc(%eax),%eax
  803182:	01 c2                	add    %eax,%edx
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	8b 40 08             	mov    0x8(%eax),%eax
  80318a:	39 c2                	cmp    %eax,%edx
  80318c:	0f 85 be 00 00 00    	jne    803250 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803192:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803195:	8b 40 04             	mov    0x4(%eax),%eax
  803198:	8b 50 08             	mov    0x8(%eax),%edx
  80319b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80319e:	8b 40 04             	mov    0x4(%eax),%eax
  8031a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a4:	01 c2                	add    %eax,%edx
  8031a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a9:	8b 40 08             	mov    0x8(%eax),%eax
  8031ac:	39 c2                	cmp    %eax,%edx
  8031ae:	0f 84 9c 00 00 00    	je     803250 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8031b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b7:	8b 50 08             	mov    0x8(%eax),%edx
  8031ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031bd:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c3:	8b 50 0c             	mov    0xc(%eax),%edx
  8031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031cc:	01 c2                	add    %eax,%edx
  8031ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d1:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8031de:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8031e8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ec:	75 17                	jne    803205 <insert_sorted_with_merge_freeList+0x572>
  8031ee:	83 ec 04             	sub    $0x4,%esp
  8031f1:	68 34 42 80 00       	push   $0x804234
  8031f6:	68 26 01 00 00       	push   $0x126
  8031fb:	68 57 42 80 00       	push   $0x804257
  803200:	e8 ae d4 ff ff       	call   8006b3 <_panic>
  803205:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80320b:	8b 45 08             	mov    0x8(%ebp),%eax
  80320e:	89 10                	mov    %edx,(%eax)
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	8b 00                	mov    (%eax),%eax
  803215:	85 c0                	test   %eax,%eax
  803217:	74 0d                	je     803226 <insert_sorted_with_merge_freeList+0x593>
  803219:	a1 48 51 80 00       	mov    0x805148,%eax
  80321e:	8b 55 08             	mov    0x8(%ebp),%edx
  803221:	89 50 04             	mov    %edx,0x4(%eax)
  803224:	eb 08                	jmp    80322e <insert_sorted_with_merge_freeList+0x59b>
  803226:	8b 45 08             	mov    0x8(%ebp),%eax
  803229:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80322e:	8b 45 08             	mov    0x8(%ebp),%eax
  803231:	a3 48 51 80 00       	mov    %eax,0x805148
  803236:	8b 45 08             	mov    0x8(%ebp),%eax
  803239:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803240:	a1 54 51 80 00       	mov    0x805154,%eax
  803245:	40                   	inc    %eax
  803246:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  80324b:	e9 18 02 00 00       	jmp    803468 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803250:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803253:	8b 50 0c             	mov    0xc(%eax),%edx
  803256:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803259:	8b 40 08             	mov    0x8(%eax),%eax
  80325c:	01 c2                	add    %eax,%edx
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	8b 40 08             	mov    0x8(%eax),%eax
  803264:	39 c2                	cmp    %eax,%edx
  803266:	0f 85 c4 01 00 00    	jne    803430 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  80326c:	8b 45 08             	mov    0x8(%ebp),%eax
  80326f:	8b 50 0c             	mov    0xc(%eax),%edx
  803272:	8b 45 08             	mov    0x8(%ebp),%eax
  803275:	8b 40 08             	mov    0x8(%eax),%eax
  803278:	01 c2                	add    %eax,%edx
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	8b 00                	mov    (%eax),%eax
  80327f:	8b 40 08             	mov    0x8(%eax),%eax
  803282:	39 c2                	cmp    %eax,%edx
  803284:	0f 85 a6 01 00 00    	jne    803430 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  80328a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80328e:	0f 84 9c 01 00 00    	je     803430 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803297:	8b 50 0c             	mov    0xc(%eax),%edx
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	8b 40 0c             	mov    0xc(%eax),%eax
  8032a0:	01 c2                	add    %eax,%edx
  8032a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a5:	8b 00                	mov    (%eax),%eax
  8032a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8032aa:	01 c2                	add    %eax,%edx
  8032ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032af:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8032b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8032c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032ca:	75 17                	jne    8032e3 <insert_sorted_with_merge_freeList+0x650>
  8032cc:	83 ec 04             	sub    $0x4,%esp
  8032cf:	68 34 42 80 00       	push   $0x804234
  8032d4:	68 32 01 00 00       	push   $0x132
  8032d9:	68 57 42 80 00       	push   $0x804257
  8032de:	e8 d0 d3 ff ff       	call   8006b3 <_panic>
  8032e3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ec:	89 10                	mov    %edx,(%eax)
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	8b 00                	mov    (%eax),%eax
  8032f3:	85 c0                	test   %eax,%eax
  8032f5:	74 0d                	je     803304 <insert_sorted_with_merge_freeList+0x671>
  8032f7:	a1 48 51 80 00       	mov    0x805148,%eax
  8032fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032ff:	89 50 04             	mov    %edx,0x4(%eax)
  803302:	eb 08                	jmp    80330c <insert_sorted_with_merge_freeList+0x679>
  803304:	8b 45 08             	mov    0x8(%ebp),%eax
  803307:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80330c:	8b 45 08             	mov    0x8(%ebp),%eax
  80330f:	a3 48 51 80 00       	mov    %eax,0x805148
  803314:	8b 45 08             	mov    0x8(%ebp),%eax
  803317:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331e:	a1 54 51 80 00       	mov    0x805154,%eax
  803323:	40                   	inc    %eax
  803324:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332c:	8b 00                	mov    (%eax),%eax
  80332e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803335:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803338:	8b 00                	mov    (%eax),%eax
  80333a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803344:	8b 00                	mov    (%eax),%eax
  803346:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803349:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80334d:	75 17                	jne    803366 <insert_sorted_with_merge_freeList+0x6d3>
  80334f:	83 ec 04             	sub    $0x4,%esp
  803352:	68 c9 42 80 00       	push   $0x8042c9
  803357:	68 36 01 00 00       	push   $0x136
  80335c:	68 57 42 80 00       	push   $0x804257
  803361:	e8 4d d3 ff ff       	call   8006b3 <_panic>
  803366:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803369:	8b 00                	mov    (%eax),%eax
  80336b:	85 c0                	test   %eax,%eax
  80336d:	74 10                	je     80337f <insert_sorted_with_merge_freeList+0x6ec>
  80336f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803372:	8b 00                	mov    (%eax),%eax
  803374:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803377:	8b 52 04             	mov    0x4(%edx),%edx
  80337a:	89 50 04             	mov    %edx,0x4(%eax)
  80337d:	eb 0b                	jmp    80338a <insert_sorted_with_merge_freeList+0x6f7>
  80337f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803382:	8b 40 04             	mov    0x4(%eax),%eax
  803385:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80338a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338d:	8b 40 04             	mov    0x4(%eax),%eax
  803390:	85 c0                	test   %eax,%eax
  803392:	74 0f                	je     8033a3 <insert_sorted_with_merge_freeList+0x710>
  803394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803397:	8b 40 04             	mov    0x4(%eax),%eax
  80339a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80339d:	8b 12                	mov    (%edx),%edx
  80339f:	89 10                	mov    %edx,(%eax)
  8033a1:	eb 0a                	jmp    8033ad <insert_sorted_with_merge_freeList+0x71a>
  8033a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a6:	8b 00                	mov    (%eax),%eax
  8033a8:	a3 38 51 80 00       	mov    %eax,0x805138
  8033ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033c0:	a1 44 51 80 00       	mov    0x805144,%eax
  8033c5:	48                   	dec    %eax
  8033c6:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8033cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033cf:	75 17                	jne    8033e8 <insert_sorted_with_merge_freeList+0x755>
  8033d1:	83 ec 04             	sub    $0x4,%esp
  8033d4:	68 34 42 80 00       	push   $0x804234
  8033d9:	68 37 01 00 00       	push   $0x137
  8033de:	68 57 42 80 00       	push   $0x804257
  8033e3:	e8 cb d2 ff ff       	call   8006b3 <_panic>
  8033e8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f1:	89 10                	mov    %edx,(%eax)
  8033f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f6:	8b 00                	mov    (%eax),%eax
  8033f8:	85 c0                	test   %eax,%eax
  8033fa:	74 0d                	je     803409 <insert_sorted_with_merge_freeList+0x776>
  8033fc:	a1 48 51 80 00       	mov    0x805148,%eax
  803401:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803404:	89 50 04             	mov    %edx,0x4(%eax)
  803407:	eb 08                	jmp    803411 <insert_sorted_with_merge_freeList+0x77e>
  803409:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803411:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803414:	a3 48 51 80 00       	mov    %eax,0x805148
  803419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803423:	a1 54 51 80 00       	mov    0x805154,%eax
  803428:	40                   	inc    %eax
  803429:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  80342e:	eb 38                	jmp    803468 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803430:	a1 40 51 80 00       	mov    0x805140,%eax
  803435:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803438:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80343c:	74 07                	je     803445 <insert_sorted_with_merge_freeList+0x7b2>
  80343e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803441:	8b 00                	mov    (%eax),%eax
  803443:	eb 05                	jmp    80344a <insert_sorted_with_merge_freeList+0x7b7>
  803445:	b8 00 00 00 00       	mov    $0x0,%eax
  80344a:	a3 40 51 80 00       	mov    %eax,0x805140
  80344f:	a1 40 51 80 00       	mov    0x805140,%eax
  803454:	85 c0                	test   %eax,%eax
  803456:	0f 85 ef f9 ff ff    	jne    802e4b <insert_sorted_with_merge_freeList+0x1b8>
  80345c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803460:	0f 85 e5 f9 ff ff    	jne    802e4b <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803466:	eb 00                	jmp    803468 <insert_sorted_with_merge_freeList+0x7d5>
  803468:	90                   	nop
  803469:	c9                   	leave  
  80346a:	c3                   	ret    
  80346b:	90                   	nop

0080346c <__udivdi3>:
  80346c:	55                   	push   %ebp
  80346d:	57                   	push   %edi
  80346e:	56                   	push   %esi
  80346f:	53                   	push   %ebx
  803470:	83 ec 1c             	sub    $0x1c,%esp
  803473:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803477:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80347b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80347f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803483:	89 ca                	mov    %ecx,%edx
  803485:	89 f8                	mov    %edi,%eax
  803487:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80348b:	85 f6                	test   %esi,%esi
  80348d:	75 2d                	jne    8034bc <__udivdi3+0x50>
  80348f:	39 cf                	cmp    %ecx,%edi
  803491:	77 65                	ja     8034f8 <__udivdi3+0x8c>
  803493:	89 fd                	mov    %edi,%ebp
  803495:	85 ff                	test   %edi,%edi
  803497:	75 0b                	jne    8034a4 <__udivdi3+0x38>
  803499:	b8 01 00 00 00       	mov    $0x1,%eax
  80349e:	31 d2                	xor    %edx,%edx
  8034a0:	f7 f7                	div    %edi
  8034a2:	89 c5                	mov    %eax,%ebp
  8034a4:	31 d2                	xor    %edx,%edx
  8034a6:	89 c8                	mov    %ecx,%eax
  8034a8:	f7 f5                	div    %ebp
  8034aa:	89 c1                	mov    %eax,%ecx
  8034ac:	89 d8                	mov    %ebx,%eax
  8034ae:	f7 f5                	div    %ebp
  8034b0:	89 cf                	mov    %ecx,%edi
  8034b2:	89 fa                	mov    %edi,%edx
  8034b4:	83 c4 1c             	add    $0x1c,%esp
  8034b7:	5b                   	pop    %ebx
  8034b8:	5e                   	pop    %esi
  8034b9:	5f                   	pop    %edi
  8034ba:	5d                   	pop    %ebp
  8034bb:	c3                   	ret    
  8034bc:	39 ce                	cmp    %ecx,%esi
  8034be:	77 28                	ja     8034e8 <__udivdi3+0x7c>
  8034c0:	0f bd fe             	bsr    %esi,%edi
  8034c3:	83 f7 1f             	xor    $0x1f,%edi
  8034c6:	75 40                	jne    803508 <__udivdi3+0x9c>
  8034c8:	39 ce                	cmp    %ecx,%esi
  8034ca:	72 0a                	jb     8034d6 <__udivdi3+0x6a>
  8034cc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034d0:	0f 87 9e 00 00 00    	ja     803574 <__udivdi3+0x108>
  8034d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8034db:	89 fa                	mov    %edi,%edx
  8034dd:	83 c4 1c             	add    $0x1c,%esp
  8034e0:	5b                   	pop    %ebx
  8034e1:	5e                   	pop    %esi
  8034e2:	5f                   	pop    %edi
  8034e3:	5d                   	pop    %ebp
  8034e4:	c3                   	ret    
  8034e5:	8d 76 00             	lea    0x0(%esi),%esi
  8034e8:	31 ff                	xor    %edi,%edi
  8034ea:	31 c0                	xor    %eax,%eax
  8034ec:	89 fa                	mov    %edi,%edx
  8034ee:	83 c4 1c             	add    $0x1c,%esp
  8034f1:	5b                   	pop    %ebx
  8034f2:	5e                   	pop    %esi
  8034f3:	5f                   	pop    %edi
  8034f4:	5d                   	pop    %ebp
  8034f5:	c3                   	ret    
  8034f6:	66 90                	xchg   %ax,%ax
  8034f8:	89 d8                	mov    %ebx,%eax
  8034fa:	f7 f7                	div    %edi
  8034fc:	31 ff                	xor    %edi,%edi
  8034fe:	89 fa                	mov    %edi,%edx
  803500:	83 c4 1c             	add    $0x1c,%esp
  803503:	5b                   	pop    %ebx
  803504:	5e                   	pop    %esi
  803505:	5f                   	pop    %edi
  803506:	5d                   	pop    %ebp
  803507:	c3                   	ret    
  803508:	bd 20 00 00 00       	mov    $0x20,%ebp
  80350d:	89 eb                	mov    %ebp,%ebx
  80350f:	29 fb                	sub    %edi,%ebx
  803511:	89 f9                	mov    %edi,%ecx
  803513:	d3 e6                	shl    %cl,%esi
  803515:	89 c5                	mov    %eax,%ebp
  803517:	88 d9                	mov    %bl,%cl
  803519:	d3 ed                	shr    %cl,%ebp
  80351b:	89 e9                	mov    %ebp,%ecx
  80351d:	09 f1                	or     %esi,%ecx
  80351f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803523:	89 f9                	mov    %edi,%ecx
  803525:	d3 e0                	shl    %cl,%eax
  803527:	89 c5                	mov    %eax,%ebp
  803529:	89 d6                	mov    %edx,%esi
  80352b:	88 d9                	mov    %bl,%cl
  80352d:	d3 ee                	shr    %cl,%esi
  80352f:	89 f9                	mov    %edi,%ecx
  803531:	d3 e2                	shl    %cl,%edx
  803533:	8b 44 24 08          	mov    0x8(%esp),%eax
  803537:	88 d9                	mov    %bl,%cl
  803539:	d3 e8                	shr    %cl,%eax
  80353b:	09 c2                	or     %eax,%edx
  80353d:	89 d0                	mov    %edx,%eax
  80353f:	89 f2                	mov    %esi,%edx
  803541:	f7 74 24 0c          	divl   0xc(%esp)
  803545:	89 d6                	mov    %edx,%esi
  803547:	89 c3                	mov    %eax,%ebx
  803549:	f7 e5                	mul    %ebp
  80354b:	39 d6                	cmp    %edx,%esi
  80354d:	72 19                	jb     803568 <__udivdi3+0xfc>
  80354f:	74 0b                	je     80355c <__udivdi3+0xf0>
  803551:	89 d8                	mov    %ebx,%eax
  803553:	31 ff                	xor    %edi,%edi
  803555:	e9 58 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  80355a:	66 90                	xchg   %ax,%ax
  80355c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803560:	89 f9                	mov    %edi,%ecx
  803562:	d3 e2                	shl    %cl,%edx
  803564:	39 c2                	cmp    %eax,%edx
  803566:	73 e9                	jae    803551 <__udivdi3+0xe5>
  803568:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80356b:	31 ff                	xor    %edi,%edi
  80356d:	e9 40 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  803572:	66 90                	xchg   %ax,%ax
  803574:	31 c0                	xor    %eax,%eax
  803576:	e9 37 ff ff ff       	jmp    8034b2 <__udivdi3+0x46>
  80357b:	90                   	nop

0080357c <__umoddi3>:
  80357c:	55                   	push   %ebp
  80357d:	57                   	push   %edi
  80357e:	56                   	push   %esi
  80357f:	53                   	push   %ebx
  803580:	83 ec 1c             	sub    $0x1c,%esp
  803583:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803587:	8b 74 24 34          	mov    0x34(%esp),%esi
  80358b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80358f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803593:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803597:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80359b:	89 f3                	mov    %esi,%ebx
  80359d:	89 fa                	mov    %edi,%edx
  80359f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035a3:	89 34 24             	mov    %esi,(%esp)
  8035a6:	85 c0                	test   %eax,%eax
  8035a8:	75 1a                	jne    8035c4 <__umoddi3+0x48>
  8035aa:	39 f7                	cmp    %esi,%edi
  8035ac:	0f 86 a2 00 00 00    	jbe    803654 <__umoddi3+0xd8>
  8035b2:	89 c8                	mov    %ecx,%eax
  8035b4:	89 f2                	mov    %esi,%edx
  8035b6:	f7 f7                	div    %edi
  8035b8:	89 d0                	mov    %edx,%eax
  8035ba:	31 d2                	xor    %edx,%edx
  8035bc:	83 c4 1c             	add    $0x1c,%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5e                   	pop    %esi
  8035c1:	5f                   	pop    %edi
  8035c2:	5d                   	pop    %ebp
  8035c3:	c3                   	ret    
  8035c4:	39 f0                	cmp    %esi,%eax
  8035c6:	0f 87 ac 00 00 00    	ja     803678 <__umoddi3+0xfc>
  8035cc:	0f bd e8             	bsr    %eax,%ebp
  8035cf:	83 f5 1f             	xor    $0x1f,%ebp
  8035d2:	0f 84 ac 00 00 00    	je     803684 <__umoddi3+0x108>
  8035d8:	bf 20 00 00 00       	mov    $0x20,%edi
  8035dd:	29 ef                	sub    %ebp,%edi
  8035df:	89 fe                	mov    %edi,%esi
  8035e1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8035e5:	89 e9                	mov    %ebp,%ecx
  8035e7:	d3 e0                	shl    %cl,%eax
  8035e9:	89 d7                	mov    %edx,%edi
  8035eb:	89 f1                	mov    %esi,%ecx
  8035ed:	d3 ef                	shr    %cl,%edi
  8035ef:	09 c7                	or     %eax,%edi
  8035f1:	89 e9                	mov    %ebp,%ecx
  8035f3:	d3 e2                	shl    %cl,%edx
  8035f5:	89 14 24             	mov    %edx,(%esp)
  8035f8:	89 d8                	mov    %ebx,%eax
  8035fa:	d3 e0                	shl    %cl,%eax
  8035fc:	89 c2                	mov    %eax,%edx
  8035fe:	8b 44 24 08          	mov    0x8(%esp),%eax
  803602:	d3 e0                	shl    %cl,%eax
  803604:	89 44 24 04          	mov    %eax,0x4(%esp)
  803608:	8b 44 24 08          	mov    0x8(%esp),%eax
  80360c:	89 f1                	mov    %esi,%ecx
  80360e:	d3 e8                	shr    %cl,%eax
  803610:	09 d0                	or     %edx,%eax
  803612:	d3 eb                	shr    %cl,%ebx
  803614:	89 da                	mov    %ebx,%edx
  803616:	f7 f7                	div    %edi
  803618:	89 d3                	mov    %edx,%ebx
  80361a:	f7 24 24             	mull   (%esp)
  80361d:	89 c6                	mov    %eax,%esi
  80361f:	89 d1                	mov    %edx,%ecx
  803621:	39 d3                	cmp    %edx,%ebx
  803623:	0f 82 87 00 00 00    	jb     8036b0 <__umoddi3+0x134>
  803629:	0f 84 91 00 00 00    	je     8036c0 <__umoddi3+0x144>
  80362f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803633:	29 f2                	sub    %esi,%edx
  803635:	19 cb                	sbb    %ecx,%ebx
  803637:	89 d8                	mov    %ebx,%eax
  803639:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80363d:	d3 e0                	shl    %cl,%eax
  80363f:	89 e9                	mov    %ebp,%ecx
  803641:	d3 ea                	shr    %cl,%edx
  803643:	09 d0                	or     %edx,%eax
  803645:	89 e9                	mov    %ebp,%ecx
  803647:	d3 eb                	shr    %cl,%ebx
  803649:	89 da                	mov    %ebx,%edx
  80364b:	83 c4 1c             	add    $0x1c,%esp
  80364e:	5b                   	pop    %ebx
  80364f:	5e                   	pop    %esi
  803650:	5f                   	pop    %edi
  803651:	5d                   	pop    %ebp
  803652:	c3                   	ret    
  803653:	90                   	nop
  803654:	89 fd                	mov    %edi,%ebp
  803656:	85 ff                	test   %edi,%edi
  803658:	75 0b                	jne    803665 <__umoddi3+0xe9>
  80365a:	b8 01 00 00 00       	mov    $0x1,%eax
  80365f:	31 d2                	xor    %edx,%edx
  803661:	f7 f7                	div    %edi
  803663:	89 c5                	mov    %eax,%ebp
  803665:	89 f0                	mov    %esi,%eax
  803667:	31 d2                	xor    %edx,%edx
  803669:	f7 f5                	div    %ebp
  80366b:	89 c8                	mov    %ecx,%eax
  80366d:	f7 f5                	div    %ebp
  80366f:	89 d0                	mov    %edx,%eax
  803671:	e9 44 ff ff ff       	jmp    8035ba <__umoddi3+0x3e>
  803676:	66 90                	xchg   %ax,%ax
  803678:	89 c8                	mov    %ecx,%eax
  80367a:	89 f2                	mov    %esi,%edx
  80367c:	83 c4 1c             	add    $0x1c,%esp
  80367f:	5b                   	pop    %ebx
  803680:	5e                   	pop    %esi
  803681:	5f                   	pop    %edi
  803682:	5d                   	pop    %ebp
  803683:	c3                   	ret    
  803684:	3b 04 24             	cmp    (%esp),%eax
  803687:	72 06                	jb     80368f <__umoddi3+0x113>
  803689:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80368d:	77 0f                	ja     80369e <__umoddi3+0x122>
  80368f:	89 f2                	mov    %esi,%edx
  803691:	29 f9                	sub    %edi,%ecx
  803693:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803697:	89 14 24             	mov    %edx,(%esp)
  80369a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80369e:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036a2:	8b 14 24             	mov    (%esp),%edx
  8036a5:	83 c4 1c             	add    $0x1c,%esp
  8036a8:	5b                   	pop    %ebx
  8036a9:	5e                   	pop    %esi
  8036aa:	5f                   	pop    %edi
  8036ab:	5d                   	pop    %ebp
  8036ac:	c3                   	ret    
  8036ad:	8d 76 00             	lea    0x0(%esi),%esi
  8036b0:	2b 04 24             	sub    (%esp),%eax
  8036b3:	19 fa                	sbb    %edi,%edx
  8036b5:	89 d1                	mov    %edx,%ecx
  8036b7:	89 c6                	mov    %eax,%esi
  8036b9:	e9 71 ff ff ff       	jmp    80362f <__umoddi3+0xb3>
  8036be:	66 90                	xchg   %ax,%ax
  8036c0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036c4:	72 ea                	jb     8036b0 <__umoddi3+0x134>
  8036c6:	89 d9                	mov    %ebx,%ecx
  8036c8:	e9 62 ff ff ff       	jmp    80362f <__umoddi3+0xb3>
