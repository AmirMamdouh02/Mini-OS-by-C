
obj/user/ef_tst_sharing_4:     file format elf32-i386


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
  800031:	e8 5d 05 00 00       	call   800593 <libmain>
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
  80008d:	68 00 37 80 00       	push   $0x803700
  800092:	6a 12                	push   $0x12
  800094:	68 1c 37 80 00       	push   $0x80371c
  800099:	e8 31 06 00 00       	call   8006cf <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 34 37 80 00       	push   $0x803734
  8000a6:	e8 d8 08 00 00       	call   800983 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 68 37 80 00       	push   $0x803768
  8000b6:	e8 c8 08 00 00       	call   800983 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 c4 37 80 00       	push   $0x8037c4
  8000c6:	e8 b8 08 00 00       	call   800983 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int Mega = 1024*1024;
  8000ce:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000d5:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	int envID = sys_getenvid();
  8000dc:	e8 a6 1f 00 00       	call   802087 <sys_getenvid>
  8000e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("STEP A: checking free of a shared object ... \n");
  8000e4:	83 ec 0c             	sub    $0xc,%esp
  8000e7:	68 f8 37 80 00       	push   $0x8037f8
  8000ec:	e8 92 08 00 00       	call   800983 <cprintf>
  8000f1:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int freeFrames = sys_calculate_free_frames() ;
  8000f4:	e8 c7 1c 00 00       	call   801dc0 <sys_calculate_free_frames>
  8000f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8000fc:	83 ec 04             	sub    $0x4,%esp
  8000ff:	6a 01                	push   $0x1
  800101:	68 00 10 00 00       	push   $0x1000
  800106:	68 27 38 80 00       	push   $0x803827
  80010b:	e8 8d 19 00 00       	call   801a9d <smalloc>
  800110:	83 c4 10             	add    $0x10,%esp
  800113:	89 45 dc             	mov    %eax,-0x24(%ebp)
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800116:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 2c 38 80 00       	push   $0x80382c
  800127:	6a 21                	push   $0x21
  800129:	68 1c 37 80 00       	push   $0x80371c
  80012e:	e8 9c 05 00 00       	call   8006cf <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800133:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800136:	e8 85 1c 00 00       	call   801dc0 <sys_calculate_free_frames>
  80013b:	29 c3                	sub    %eax,%ebx
  80013d:	89 d8                	mov    %ebx,%eax
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 14                	je     800158 <_main+0x120>
  800144:	83 ec 04             	sub    $0x4,%esp
  800147:	68 98 38 80 00       	push   $0x803898
  80014c:	6a 22                	push   $0x22
  80014e:	68 1c 37 80 00       	push   $0x80371c
  800153:	e8 77 05 00 00       	call   8006cf <_panic>

		sfree(x);
  800158:	83 ec 0c             	sub    $0xc,%esp
  80015b:	ff 75 dc             	pushl  -0x24(%ebp)
  80015e:	e8 fd 1a 00 00       	call   801c60 <sfree>
  800163:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) ==  0+0+2) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800166:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800169:	e8 52 1c 00 00       	call   801dc0 <sys_calculate_free_frames>
  80016e:	29 c3                	sub    %eax,%ebx
  800170:	89 d8                	mov    %ebx,%eax
  800172:	83 f8 02             	cmp    $0x2,%eax
  800175:	75 14                	jne    80018b <_main+0x153>
  800177:	83 ec 04             	sub    $0x4,%esp
  80017a:	68 18 39 80 00       	push   $0x803918
  80017f:	6a 25                	push   $0x25
  800181:	68 1c 37 80 00       	push   $0x80371c
  800186:	e8 44 05 00 00       	call   8006cf <_panic>
		else if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: revise your freeSharedObject logic");
  80018b:	e8 30 1c 00 00       	call   801dc0 <sys_calculate_free_frames>
  800190:	89 c2                	mov    %eax,%edx
  800192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	74 14                	je     8001ad <_main+0x175>
  800199:	83 ec 04             	sub    $0x4,%esp
  80019c:	68 70 39 80 00       	push   $0x803970
  8001a1:	6a 26                	push   $0x26
  8001a3:	68 1c 37 80 00       	push   $0x80371c
  8001a8:	e8 22 05 00 00       	call   8006cf <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  8001ad:	83 ec 0c             	sub    $0xc,%esp
  8001b0:	68 a0 39 80 00       	push   $0x8039a0
  8001b5:	e8 c9 07 00 00       	call   800983 <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp


	cprintf("STEP B: checking free of 2 shared objects ... \n");
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	68 c4 39 80 00       	push   $0x8039c4
  8001c5:	e8 b9 07 00 00       	call   800983 <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int freeFrames = sys_calculate_free_frames() ;
  8001cd:	e8 ee 1b 00 00       	call   801dc0 <sys_calculate_free_frames>
  8001d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		z = smalloc("z", PAGE_SIZE, 1);
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	6a 01                	push   $0x1
  8001da:	68 00 10 00 00       	push   $0x1000
  8001df:	68 f4 39 80 00       	push   $0x8039f4
  8001e4:	e8 b4 18 00 00       	call   801a9d <smalloc>
  8001e9:	83 c4 10             	add    $0x10,%esp
  8001ec:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	68 00 10 00 00       	push   $0x1000
  8001f9:	68 27 38 80 00       	push   $0x803827
  8001fe:	e8 9a 18 00 00       	call   801a9d <smalloc>
  800203:	83 c4 10             	add    $0x10,%esp
  800206:	89 45 d0             	mov    %eax,-0x30(%ebp)

		if(x == NULL) panic("Wrong free: make sure that you free the shared object by calling free_share_object()");
  800209:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80020d:	75 14                	jne    800223 <_main+0x1eb>
  80020f:	83 ec 04             	sub    $0x4,%esp
  800212:	68 18 39 80 00       	push   $0x803918
  800217:	6a 32                	push   $0x32
  800219:	68 1c 37 80 00       	push   $0x80371c
  80021e:	e8 ac 04 00 00       	call   8006cf <_panic>

		if ((freeFrames - sys_calculate_free_frames()) !=  2+1+4) panic("Wrong previous free: make sure that you correctly free shared object before (Step A)");
  800223:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800226:	e8 95 1b 00 00       	call   801dc0 <sys_calculate_free_frames>
  80022b:	29 c3                	sub    %eax,%ebx
  80022d:	89 d8                	mov    %ebx,%eax
  80022f:	83 f8 07             	cmp    $0x7,%eax
  800232:	74 14                	je     800248 <_main+0x210>
  800234:	83 ec 04             	sub    $0x4,%esp
  800237:	68 f8 39 80 00       	push   $0x8039f8
  80023c:	6a 34                	push   $0x34
  80023e:	68 1c 37 80 00       	push   $0x80371c
  800243:	e8 87 04 00 00       	call   8006cf <_panic>

		sfree(z);
  800248:	83 ec 0c             	sub    $0xc,%esp
  80024b:	ff 75 d4             	pushl  -0x2c(%ebp)
  80024e:	e8 0d 1a 00 00       	call   801c60 <sfree>
  800253:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  800256:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800259:	e8 62 1b 00 00       	call   801dc0 <sys_calculate_free_frames>
  80025e:	29 c3                	sub    %eax,%ebx
  800260:	89 d8                	mov    %ebx,%eax
  800262:	83 f8 04             	cmp    $0x4,%eax
  800265:	74 14                	je     80027b <_main+0x243>
  800267:	83 ec 04             	sub    $0x4,%esp
  80026a:	68 4d 3a 80 00       	push   $0x803a4d
  80026f:	6a 37                	push   $0x37
  800271:	68 1c 37 80 00       	push   $0x80371c
  800276:	e8 54 04 00 00       	call   8006cf <_panic>

		sfree(x);
  80027b:	83 ec 0c             	sub    $0xc,%esp
  80027e:	ff 75 d0             	pushl  -0x30(%ebp)
  800281:	e8 da 19 00 00       	call   801c60 <sfree>
  800286:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800289:	e8 32 1b 00 00       	call   801dc0 <sys_calculate_free_frames>
  80028e:	89 c2                	mov    %eax,%edx
  800290:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800293:	39 c2                	cmp    %eax,%edx
  800295:	74 14                	je     8002ab <_main+0x273>
  800297:	83 ec 04             	sub    $0x4,%esp
  80029a:	68 4d 3a 80 00       	push   $0x803a4d
  80029f:	6a 3a                	push   $0x3a
  8002a1:	68 1c 37 80 00       	push   $0x80371c
  8002a6:	e8 24 04 00 00       	call   8006cf <_panic>

	}
	cprintf("Step B completed successfully!!\n\n\n");
  8002ab:	83 ec 0c             	sub    $0xc,%esp
  8002ae:	68 6c 3a 80 00       	push   $0x803a6c
  8002b3:	e8 cb 06 00 00       	call   800983 <cprintf>
  8002b8:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking range of loop during free... \n");
  8002bb:	83 ec 0c             	sub    $0xc,%esp
  8002be:	68 90 3a 80 00       	push   $0x803a90
  8002c3:	e8 bb 06 00 00       	call   800983 <cprintf>
  8002c8:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *w, *u;
		int freeFrames = sys_calculate_free_frames() ;
  8002cb:	e8 f0 1a 00 00       	call   801dc0 <sys_calculate_free_frames>
  8002d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * PAGE_SIZE+1, 1);
  8002d3:	83 ec 04             	sub    $0x4,%esp
  8002d6:	6a 01                	push   $0x1
  8002d8:	68 01 30 00 00       	push   $0x3001
  8002dd:	68 c0 3a 80 00       	push   $0x803ac0
  8002e2:	e8 b6 17 00 00       	call   801a9d <smalloc>
  8002e7:	83 c4 10             	add    $0x10,%esp
  8002ea:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", PAGE_SIZE, 1);
  8002ed:	83 ec 04             	sub    $0x4,%esp
  8002f0:	6a 01                	push   $0x1
  8002f2:	68 00 10 00 00       	push   $0x1000
  8002f7:	68 c2 3a 80 00       	push   $0x803ac2
  8002fc:	e8 9c 17 00 00       	call   801a9d <smalloc>
  800301:	83 c4 10             	add    $0x10,%esp
  800304:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 5+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800307:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80030a:	e8 b1 1a 00 00       	call   801dc0 <sys_calculate_free_frames>
  80030f:	29 c3                	sub    %eax,%ebx
  800311:	89 d8                	mov    %ebx,%eax
  800313:	83 f8 0a             	cmp    $0xa,%eax
  800316:	74 14                	je     80032c <_main+0x2f4>
  800318:	83 ec 04             	sub    $0x4,%esp
  80031b:	68 98 38 80 00       	push   $0x803898
  800320:	6a 46                	push   $0x46
  800322:	68 1c 37 80 00       	push   $0x80371c
  800327:	e8 a3 03 00 00       	call   8006cf <_panic>

		sfree(w);
  80032c:	83 ec 0c             	sub    $0xc,%esp
  80032f:	ff 75 c8             	pushl  -0x38(%ebp)
  800332:	e8 29 19 00 00       	call   801c60 <sfree>
  800337:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  80033a:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80033d:	e8 7e 1a 00 00       	call   801dc0 <sys_calculate_free_frames>
  800342:	29 c3                	sub    %eax,%ebx
  800344:	89 d8                	mov    %ebx,%eax
  800346:	83 f8 04             	cmp    $0x4,%eax
  800349:	74 14                	je     80035f <_main+0x327>
  80034b:	83 ec 04             	sub    $0x4,%esp
  80034e:	68 4d 3a 80 00       	push   $0x803a4d
  800353:	6a 49                	push   $0x49
  800355:	68 1c 37 80 00       	push   $0x80371c
  80035a:	e8 70 03 00 00       	call   8006cf <_panic>

		uint32 *o;
		o = smalloc("o", 2 * PAGE_SIZE-1,1);
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	6a 01                	push   $0x1
  800364:	68 ff 1f 00 00       	push   $0x1fff
  800369:	68 c4 3a 80 00       	push   $0x803ac4
  80036e:	e8 2a 17 00 00       	call   801a9d <smalloc>
  800373:	83 c4 10             	add    $0x10,%esp
  800376:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3+1+4) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800379:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  80037c:	e8 3f 1a 00 00       	call   801dc0 <sys_calculate_free_frames>
  800381:	29 c3                	sub    %eax,%ebx
  800383:	89 d8                	mov    %ebx,%eax
  800385:	83 f8 08             	cmp    $0x8,%eax
  800388:	74 14                	je     80039e <_main+0x366>
  80038a:	83 ec 04             	sub    $0x4,%esp
  80038d:	68 98 38 80 00       	push   $0x803898
  800392:	6a 4e                	push   $0x4e
  800394:	68 1c 37 80 00       	push   $0x80371c
  800399:	e8 31 03 00 00       	call   8006cf <_panic>

		sfree(o);
  80039e:	83 ec 0c             	sub    $0xc,%esp
  8003a1:	ff 75 c0             	pushl  -0x40(%ebp)
  8003a4:	e8 b7 18 00 00       	call   801c60 <sfree>
  8003a9:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong free: check your logic");
  8003ac:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8003af:	e8 0c 1a 00 00       	call   801dc0 <sys_calculate_free_frames>
  8003b4:	29 c3                	sub    %eax,%ebx
  8003b6:	89 d8                	mov    %ebx,%eax
  8003b8:	83 f8 04             	cmp    $0x4,%eax
  8003bb:	74 14                	je     8003d1 <_main+0x399>
  8003bd:	83 ec 04             	sub    $0x4,%esp
  8003c0:	68 4d 3a 80 00       	push   $0x803a4d
  8003c5:	6a 51                	push   $0x51
  8003c7:	68 1c 37 80 00       	push   $0x80371c
  8003cc:	e8 fe 02 00 00       	call   8006cf <_panic>

		sfree(u);
  8003d1:	83 ec 0c             	sub    $0xc,%esp
  8003d4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003d7:	e8 84 18 00 00       	call   801c60 <sfree>
  8003dc:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  8003df:	e8 dc 19 00 00       	call   801dc0 <sys_calculate_free_frames>
  8003e4:	89 c2                	mov    %eax,%edx
  8003e6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8003e9:	39 c2                	cmp    %eax,%edx
  8003eb:	74 14                	je     800401 <_main+0x3c9>
  8003ed:	83 ec 04             	sub    $0x4,%esp
  8003f0:	68 4d 3a 80 00       	push   $0x803a4d
  8003f5:	6a 54                	push   $0x54
  8003f7:	68 1c 37 80 00       	push   $0x80371c
  8003fc:	e8 ce 02 00 00       	call   8006cf <_panic>


		//Checking boundaries of page tables
		freeFrames = sys_calculate_free_frames() ;
  800401:	e8 ba 19 00 00       	call   801dc0 <sys_calculate_free_frames>
  800406:	89 45 cc             	mov    %eax,-0x34(%ebp)
		w = smalloc("w", 3 * Mega - 1*kilo, 1);
  800409:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80040c:	89 c2                	mov    %eax,%edx
  80040e:	01 d2                	add    %edx,%edx
  800410:	01 d0                	add    %edx,%eax
  800412:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800415:	83 ec 04             	sub    $0x4,%esp
  800418:	6a 01                	push   $0x1
  80041a:	50                   	push   %eax
  80041b:	68 c0 3a 80 00       	push   $0x803ac0
  800420:	e8 78 16 00 00       	call   801a9d <smalloc>
  800425:	83 c4 10             	add    $0x10,%esp
  800428:	89 45 c8             	mov    %eax,-0x38(%ebp)
		u = smalloc("u", 7 * Mega - 1*kilo, 1);
  80042b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80042e:	89 d0                	mov    %edx,%eax
  800430:	01 c0                	add    %eax,%eax
  800432:	01 d0                	add    %edx,%eax
  800434:	01 c0                	add    %eax,%eax
  800436:	01 d0                	add    %edx,%eax
  800438:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80043b:	83 ec 04             	sub    $0x4,%esp
  80043e:	6a 01                	push   $0x1
  800440:	50                   	push   %eax
  800441:	68 c2 3a 80 00       	push   $0x803ac2
  800446:	e8 52 16 00 00       	call   801a9d <smalloc>
  80044b:	83 c4 10             	add    $0x10,%esp
  80044e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		o = smalloc("o", 2 * Mega + 1*kilo, 1);
  800451:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800454:	01 c0                	add    %eax,%eax
  800456:	89 c2                	mov    %eax,%edx
  800458:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	83 ec 04             	sub    $0x4,%esp
  800460:	6a 01                	push   $0x1
  800462:	50                   	push   %eax
  800463:	68 c4 3a 80 00       	push   $0x803ac4
  800468:	e8 30 16 00 00       	call   801a9d <smalloc>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if ((freeFrames - sys_calculate_free_frames()) != 3073+4+7) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800473:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800476:	e8 45 19 00 00       	call   801dc0 <sys_calculate_free_frames>
  80047b:	29 c3                	sub    %eax,%ebx
  80047d:	89 d8                	mov    %ebx,%eax
  80047f:	3d 0c 0c 00 00       	cmp    $0xc0c,%eax
  800484:	74 14                	je     80049a <_main+0x462>
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 98 38 80 00       	push   $0x803898
  80048e:	6a 5d                	push   $0x5d
  800490:	68 1c 37 80 00       	push   $0x80371c
  800495:	e8 35 02 00 00       	call   8006cf <_panic>

		sfree(o);
  80049a:	83 ec 0c             	sub    $0xc,%esp
  80049d:	ff 75 c0             	pushl  -0x40(%ebp)
  8004a0:	e8 bb 17 00 00       	call   801c60 <sfree>
  8004a5:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  2560+3+5) panic("Wrong free: check your logic");
  8004a8:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004ab:	e8 10 19 00 00       	call   801dc0 <sys_calculate_free_frames>
  8004b0:	29 c3                	sub    %eax,%ebx
  8004b2:	89 d8                	mov    %ebx,%eax
  8004b4:	3d 08 0a 00 00       	cmp    $0xa08,%eax
  8004b9:	74 14                	je     8004cf <_main+0x497>
  8004bb:	83 ec 04             	sub    $0x4,%esp
  8004be:	68 4d 3a 80 00       	push   $0x803a4d
  8004c3:	6a 60                	push   $0x60
  8004c5:	68 1c 37 80 00       	push   $0x80371c
  8004ca:	e8 00 02 00 00       	call   8006cf <_panic>

		sfree(w);
  8004cf:	83 ec 0c             	sub    $0xc,%esp
  8004d2:	ff 75 c8             	pushl  -0x38(%ebp)
  8004d5:	e8 86 17 00 00       	call   801c60 <sfree>
  8004da:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  1792+3+3) panic("Wrong free: check your logic");
  8004dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8004e0:	e8 db 18 00 00       	call   801dc0 <sys_calculate_free_frames>
  8004e5:	29 c3                	sub    %eax,%ebx
  8004e7:	89 d8                	mov    %ebx,%eax
  8004e9:	3d 06 07 00 00       	cmp    $0x706,%eax
  8004ee:	74 14                	je     800504 <_main+0x4cc>
  8004f0:	83 ec 04             	sub    $0x4,%esp
  8004f3:	68 4d 3a 80 00       	push   $0x803a4d
  8004f8:	6a 63                	push   $0x63
  8004fa:	68 1c 37 80 00       	push   $0x80371c
  8004ff:	e8 cb 01 00 00       	call   8006cf <_panic>

		sfree(u);
  800504:	83 ec 0c             	sub    $0xc,%esp
  800507:	ff 75 c4             	pushl  -0x3c(%ebp)
  80050a:	e8 51 17 00 00       	call   801c60 <sfree>
  80050f:	83 c4 10             	add    $0x10,%esp
		if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Wrong free: check your logic");
  800512:	e8 a9 18 00 00       	call   801dc0 <sys_calculate_free_frames>
  800517:	89 c2                	mov    %eax,%edx
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	39 c2                	cmp    %eax,%edx
  80051e:	74 14                	je     800534 <_main+0x4fc>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	68 4d 3a 80 00       	push   $0x803a4d
  800528:	6a 66                	push   $0x66
  80052a:	68 1c 37 80 00       	push   $0x80371c
  80052f:	e8 9b 01 00 00       	call   8006cf <_panic>
	}
	cprintf("Step C completed successfully!!\n\n\n");
  800534:	83 ec 0c             	sub    $0xc,%esp
  800537:	68 c8 3a 80 00       	push   $0x803ac8
  80053c:	e8 42 04 00 00       	call   800983 <cprintf>
  800541:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of freeSharedObjects [4] completed successfully!!\n\n\n");
  800544:	83 ec 0c             	sub    $0xc,%esp
  800547:	68 ec 3a 80 00       	push   $0x803aec
  80054c:	e8 32 04 00 00       	call   800983 <cprintf>
  800551:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800554:	e8 60 1b 00 00       	call   8020b9 <sys_getparentenvid>
  800559:	89 45 bc             	mov    %eax,-0x44(%ebp)
	if(parentenvID > 0)
  80055c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  800560:	7e 2b                	jle    80058d <_main+0x555>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  800562:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	68 38 3b 80 00       	push   $0x803b38
  800571:	ff 75 bc             	pushl  -0x44(%ebp)
  800574:	e8 f9 15 00 00       	call   801b72 <sget>
  800579:	83 c4 10             	add    $0x10,%esp
  80057c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		(*finishedCount)++ ;
  80057f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 50 01             	lea    0x1(%eax),%edx
  800587:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80058a:	89 10                	mov    %edx,(%eax)
	}
	return;
  80058c:	90                   	nop
  80058d:	90                   	nop
}
  80058e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800599:	e8 02 1b 00 00       	call   8020a0 <sys_getenvindex>
  80059e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005a4:	89 d0                	mov    %edx,%eax
  8005a6:	c1 e0 03             	shl    $0x3,%eax
  8005a9:	01 d0                	add    %edx,%eax
  8005ab:	01 c0                	add    %eax,%eax
  8005ad:	01 d0                	add    %edx,%eax
  8005af:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005b6:	01 d0                	add    %edx,%eax
  8005b8:	c1 e0 04             	shl    $0x4,%eax
  8005bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005c5:	a1 20 50 80 00       	mov    0x805020,%eax
  8005ca:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005d0:	84 c0                	test   %al,%al
  8005d2:	74 0f                	je     8005e3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005d4:	a1 20 50 80 00       	mov    0x805020,%eax
  8005d9:	05 5c 05 00 00       	add    $0x55c,%eax
  8005de:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005e7:	7e 0a                	jle    8005f3 <libmain+0x60>
		binaryname = argv[0];
  8005e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8005f3:	83 ec 08             	sub    $0x8,%esp
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	e8 37 fa ff ff       	call   800038 <_main>
  800601:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800604:	e8 a4 18 00 00       	call   801ead <sys_disable_interrupt>
	cprintf("**************************************\n");
  800609:	83 ec 0c             	sub    $0xc,%esp
  80060c:	68 60 3b 80 00       	push   $0x803b60
  800611:	e8 6d 03 00 00       	call   800983 <cprintf>
  800616:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800619:	a1 20 50 80 00       	mov    0x805020,%eax
  80061e:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800624:	a1 20 50 80 00       	mov    0x805020,%eax
  800629:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80062f:	83 ec 04             	sub    $0x4,%esp
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	68 88 3b 80 00       	push   $0x803b88
  800639:	e8 45 03 00 00       	call   800983 <cprintf>
  80063e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800641:	a1 20 50 80 00       	mov    0x805020,%eax
  800646:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80064c:	a1 20 50 80 00       	mov    0x805020,%eax
  800651:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800657:	a1 20 50 80 00       	mov    0x805020,%eax
  80065c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800662:	51                   	push   %ecx
  800663:	52                   	push   %edx
  800664:	50                   	push   %eax
  800665:	68 b0 3b 80 00       	push   $0x803bb0
  80066a:	e8 14 03 00 00       	call   800983 <cprintf>
  80066f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800672:	a1 20 50 80 00       	mov    0x805020,%eax
  800677:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80067d:	83 ec 08             	sub    $0x8,%esp
  800680:	50                   	push   %eax
  800681:	68 08 3c 80 00       	push   $0x803c08
  800686:	e8 f8 02 00 00       	call   800983 <cprintf>
  80068b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80068e:	83 ec 0c             	sub    $0xc,%esp
  800691:	68 60 3b 80 00       	push   $0x803b60
  800696:	e8 e8 02 00 00       	call   800983 <cprintf>
  80069b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80069e:	e8 24 18 00 00       	call   801ec7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006a3:	e8 19 00 00 00       	call   8006c1 <exit>
}
  8006a8:	90                   	nop
  8006a9:	c9                   	leave  
  8006aa:	c3                   	ret    

008006ab <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006ab:	55                   	push   %ebp
  8006ac:	89 e5                	mov    %esp,%ebp
  8006ae:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006b1:	83 ec 0c             	sub    $0xc,%esp
  8006b4:	6a 00                	push   $0x0
  8006b6:	e8 b1 19 00 00       	call   80206c <sys_destroy_env>
  8006bb:	83 c4 10             	add    $0x10,%esp
}
  8006be:	90                   	nop
  8006bf:	c9                   	leave  
  8006c0:	c3                   	ret    

008006c1 <exit>:

void
exit(void)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006c7:	e8 06 1a 00 00       	call   8020d2 <sys_exit_env>
}
  8006cc:	90                   	nop
  8006cd:	c9                   	leave  
  8006ce:	c3                   	ret    

008006cf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006cf:	55                   	push   %ebp
  8006d0:	89 e5                	mov    %esp,%ebp
  8006d2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006d5:	8d 45 10             	lea    0x10(%ebp),%eax
  8006d8:	83 c0 04             	add    $0x4,%eax
  8006db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006de:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	74 16                	je     8006fd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006e7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006ec:	83 ec 08             	sub    $0x8,%esp
  8006ef:	50                   	push   %eax
  8006f0:	68 1c 3c 80 00       	push   $0x803c1c
  8006f5:	e8 89 02 00 00       	call   800983 <cprintf>
  8006fa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006fd:	a1 00 50 80 00       	mov    0x805000,%eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	50                   	push   %eax
  800709:	68 21 3c 80 00       	push   $0x803c21
  80070e:	e8 70 02 00 00       	call   800983 <cprintf>
  800713:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800716:	8b 45 10             	mov    0x10(%ebp),%eax
  800719:	83 ec 08             	sub    $0x8,%esp
  80071c:	ff 75 f4             	pushl  -0xc(%ebp)
  80071f:	50                   	push   %eax
  800720:	e8 f3 01 00 00       	call   800918 <vcprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800728:	83 ec 08             	sub    $0x8,%esp
  80072b:	6a 00                	push   $0x0
  80072d:	68 3d 3c 80 00       	push   $0x803c3d
  800732:	e8 e1 01 00 00       	call   800918 <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80073a:	e8 82 ff ff ff       	call   8006c1 <exit>

	// should not return here
	while (1) ;
  80073f:	eb fe                	jmp    80073f <_panic+0x70>

00800741 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800747:	a1 20 50 80 00       	mov    0x805020,%eax
  80074c:	8b 50 74             	mov    0x74(%eax),%edx
  80074f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800752:	39 c2                	cmp    %eax,%edx
  800754:	74 14                	je     80076a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800756:	83 ec 04             	sub    $0x4,%esp
  800759:	68 40 3c 80 00       	push   $0x803c40
  80075e:	6a 26                	push   $0x26
  800760:	68 8c 3c 80 00       	push   $0x803c8c
  800765:	e8 65 ff ff ff       	call   8006cf <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80076a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800771:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800778:	e9 c2 00 00 00       	jmp    80083f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80077d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800780:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800787:	8b 45 08             	mov    0x8(%ebp),%eax
  80078a:	01 d0                	add    %edx,%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	85 c0                	test   %eax,%eax
  800790:	75 08                	jne    80079a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800792:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800795:	e9 a2 00 00 00       	jmp    80083c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80079a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007a1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007a8:	eb 69                	jmp    800813 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8007af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007b8:	89 d0                	mov    %edx,%eax
  8007ba:	01 c0                	add    %eax,%eax
  8007bc:	01 d0                	add    %edx,%eax
  8007be:	c1 e0 03             	shl    $0x3,%eax
  8007c1:	01 c8                	add    %ecx,%eax
  8007c3:	8a 40 04             	mov    0x4(%eax),%al
  8007c6:	84 c0                	test   %al,%al
  8007c8:	75 46                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007ca:	a1 20 50 80 00       	mov    0x805020,%eax
  8007cf:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	01 c0                	add    %eax,%eax
  8007dc:	01 d0                	add    %edx,%eax
  8007de:	c1 e0 03             	shl    $0x3,%eax
  8007e1:	01 c8                	add    %ecx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8007f0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8007f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8007fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ff:	01 c8                	add    %ecx,%eax
  800801:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800803:	39 c2                	cmp    %eax,%edx
  800805:	75 09                	jne    800810 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800807:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80080e:	eb 12                	jmp    800822 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800810:	ff 45 e8             	incl   -0x18(%ebp)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	77 88                	ja     8007aa <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800822:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800826:	75 14                	jne    80083c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 98 3c 80 00       	push   $0x803c98
  800830:	6a 3a                	push   $0x3a
  800832:	68 8c 3c 80 00       	push   $0x803c8c
  800837:	e8 93 fe ff ff       	call   8006cf <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80083c:	ff 45 f0             	incl   -0x10(%ebp)
  80083f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800842:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800845:	0f 8c 32 ff ff ff    	jl     80077d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80084b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800852:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800859:	eb 26                	jmp    800881 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80085b:	a1 20 50 80 00       	mov    0x805020,%eax
  800860:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800866:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800869:	89 d0                	mov    %edx,%eax
  80086b:	01 c0                	add    %eax,%eax
  80086d:	01 d0                	add    %edx,%eax
  80086f:	c1 e0 03             	shl    $0x3,%eax
  800872:	01 c8                	add    %ecx,%eax
  800874:	8a 40 04             	mov    0x4(%eax),%al
  800877:	3c 01                	cmp    $0x1,%al
  800879:	75 03                	jne    80087e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80087b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80087e:	ff 45 e0             	incl   -0x20(%ebp)
  800881:	a1 20 50 80 00       	mov    0x805020,%eax
  800886:	8b 50 74             	mov    0x74(%eax),%edx
  800889:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80088c:	39 c2                	cmp    %eax,%edx
  80088e:	77 cb                	ja     80085b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800893:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800896:	74 14                	je     8008ac <CheckWSWithoutLastIndex+0x16b>
		panic(
  800898:	83 ec 04             	sub    $0x4,%esp
  80089b:	68 ec 3c 80 00       	push   $0x803cec
  8008a0:	6a 44                	push   $0x44
  8008a2:	68 8c 3c 80 00       	push   $0x803c8c
  8008a7:	e8 23 fe ff ff       	call   8006cf <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008ac:	90                   	nop
  8008ad:	c9                   	leave  
  8008ae:	c3                   	ret    

008008af <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	8d 48 01             	lea    0x1(%eax),%ecx
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c0:	89 0a                	mov    %ecx,(%edx)
  8008c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c5:	88 d1                	mov    %dl,%cl
  8008c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ca:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008d8:	75 2c                	jne    800906 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008da:	a0 24 50 80 00       	mov    0x805024,%al
  8008df:	0f b6 c0             	movzbl %al,%eax
  8008e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008e5:	8b 12                	mov    (%edx),%edx
  8008e7:	89 d1                	mov    %edx,%ecx
  8008e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ec:	83 c2 08             	add    $0x8,%edx
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	50                   	push   %eax
  8008f3:	51                   	push   %ecx
  8008f4:	52                   	push   %edx
  8008f5:	e8 05 14 00 00       	call   801cff <sys_cputs>
  8008fa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800906:	8b 45 0c             	mov    0xc(%ebp),%eax
  800909:	8b 40 04             	mov    0x4(%eax),%eax
  80090c:	8d 50 01             	lea    0x1(%eax),%edx
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	89 50 04             	mov    %edx,0x4(%eax)
}
  800915:	90                   	nop
  800916:	c9                   	leave  
  800917:	c3                   	ret    

00800918 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800918:	55                   	push   %ebp
  800919:	89 e5                	mov    %esp,%ebp
  80091b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800921:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800928:	00 00 00 
	b.cnt = 0;
  80092b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800932:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800941:	50                   	push   %eax
  800942:	68 af 08 80 00       	push   $0x8008af
  800947:	e8 11 02 00 00       	call   800b5d <vprintfmt>
  80094c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80094f:	a0 24 50 80 00       	mov    0x805024,%al
  800954:	0f b6 c0             	movzbl %al,%eax
  800957:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80095d:	83 ec 04             	sub    $0x4,%esp
  800960:	50                   	push   %eax
  800961:	52                   	push   %edx
  800962:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800968:	83 c0 08             	add    $0x8,%eax
  80096b:	50                   	push   %eax
  80096c:	e8 8e 13 00 00       	call   801cff <sys_cputs>
  800971:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800974:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80097b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800981:	c9                   	leave  
  800982:	c3                   	ret    

00800983 <cprintf>:

int cprintf(const char *fmt, ...) {
  800983:	55                   	push   %ebp
  800984:	89 e5                	mov    %esp,%ebp
  800986:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800989:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800990:	8d 45 0c             	lea    0xc(%ebp),%eax
  800993:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800996:	8b 45 08             	mov    0x8(%ebp),%eax
  800999:	83 ec 08             	sub    $0x8,%esp
  80099c:	ff 75 f4             	pushl  -0xc(%ebp)
  80099f:	50                   	push   %eax
  8009a0:	e8 73 ff ff ff       	call   800918 <vcprintf>
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009ae:	c9                   	leave  
  8009af:	c3                   	ret    

008009b0 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009b6:	e8 f2 14 00 00       	call   801ead <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009bb:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ca:	50                   	push   %eax
  8009cb:	e8 48 ff ff ff       	call   800918 <vcprintf>
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009d6:	e8 ec 14 00 00       	call   801ec7 <sys_enable_interrupt>
	return cnt;
  8009db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009de:	c9                   	leave  
  8009df:	c3                   	ret    

008009e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	53                   	push   %ebx
  8009e4:	83 ec 14             	sub    $0x14,%esp
  8009e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8009f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8009fe:	77 55                	ja     800a55 <printnum+0x75>
  800a00:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a03:	72 05                	jb     800a0a <printnum+0x2a>
  800a05:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a08:	77 4b                	ja     800a55 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a0a:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a0d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a10:	8b 45 18             	mov    0x18(%ebp),%eax
  800a13:	ba 00 00 00 00       	mov    $0x0,%edx
  800a18:	52                   	push   %edx
  800a19:	50                   	push   %eax
  800a1a:	ff 75 f4             	pushl  -0xc(%ebp)
  800a1d:	ff 75 f0             	pushl  -0x10(%ebp)
  800a20:	e8 63 2a 00 00       	call   803488 <__udivdi3>
  800a25:	83 c4 10             	add    $0x10,%esp
  800a28:	83 ec 04             	sub    $0x4,%esp
  800a2b:	ff 75 20             	pushl  0x20(%ebp)
  800a2e:	53                   	push   %ebx
  800a2f:	ff 75 18             	pushl  0x18(%ebp)
  800a32:	52                   	push   %edx
  800a33:	50                   	push   %eax
  800a34:	ff 75 0c             	pushl  0xc(%ebp)
  800a37:	ff 75 08             	pushl  0x8(%ebp)
  800a3a:	e8 a1 ff ff ff       	call   8009e0 <printnum>
  800a3f:	83 c4 20             	add    $0x20,%esp
  800a42:	eb 1a                	jmp    800a5e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	ff 75 20             	pushl  0x20(%ebp)
  800a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a50:	ff d0                	call   *%eax
  800a52:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a55:	ff 4d 1c             	decl   0x1c(%ebp)
  800a58:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a5c:	7f e6                	jg     800a44 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a5e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	53                   	push   %ebx
  800a6d:	51                   	push   %ecx
  800a6e:	52                   	push   %edx
  800a6f:	50                   	push   %eax
  800a70:	e8 23 2b 00 00       	call   803598 <__umoddi3>
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	05 54 3f 80 00       	add    $0x803f54,%eax
  800a7d:	8a 00                	mov    (%eax),%al
  800a7f:	0f be c0             	movsbl %al,%eax
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	50                   	push   %eax
  800a89:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8c:	ff d0                	call   *%eax
  800a8e:	83 c4 10             	add    $0x10,%esp
}
  800a91:	90                   	nop
  800a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a95:	c9                   	leave  
  800a96:	c3                   	ret    

00800a97 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800a97:	55                   	push   %ebp
  800a98:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800a9a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a9e:	7e 1c                	jle    800abc <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	8b 00                	mov    (%eax),%eax
  800aa5:	8d 50 08             	lea    0x8(%eax),%edx
  800aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aab:	89 10                	mov    %edx,(%eax)
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	8b 00                	mov    (%eax),%eax
  800ab2:	83 e8 08             	sub    $0x8,%eax
  800ab5:	8b 50 04             	mov    0x4(%eax),%edx
  800ab8:	8b 00                	mov    (%eax),%eax
  800aba:	eb 40                	jmp    800afc <getuint+0x65>
	else if (lflag)
  800abc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ac0:	74 1e                	je     800ae0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	8b 00                	mov    (%eax),%eax
  800ac7:	8d 50 04             	lea    0x4(%eax),%edx
  800aca:	8b 45 08             	mov    0x8(%ebp),%eax
  800acd:	89 10                	mov    %edx,(%eax)
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 00                	mov    (%eax),%eax
  800ad4:	83 e8 04             	sub    $0x4,%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	ba 00 00 00 00       	mov    $0x0,%edx
  800ade:	eb 1c                	jmp    800afc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	8b 00                	mov    (%eax),%eax
  800ae5:	8d 50 04             	lea    0x4(%eax),%edx
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	89 10                	mov    %edx,(%eax)
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	8b 00                	mov    (%eax),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800afc:	5d                   	pop    %ebp
  800afd:	c3                   	ret    

00800afe <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b01:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b05:	7e 1c                	jle    800b23 <getint+0x25>
		return va_arg(*ap, long long);
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	8b 00                	mov    (%eax),%eax
  800b0c:	8d 50 08             	lea    0x8(%eax),%edx
  800b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b12:	89 10                	mov    %edx,(%eax)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	83 e8 08             	sub    $0x8,%eax
  800b1c:	8b 50 04             	mov    0x4(%eax),%edx
  800b1f:	8b 00                	mov    (%eax),%eax
  800b21:	eb 38                	jmp    800b5b <getint+0x5d>
	else if (lflag)
  800b23:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b27:	74 1a                	je     800b43 <getint+0x45>
		return va_arg(*ap, long);
  800b29:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2c:	8b 00                	mov    (%eax),%eax
  800b2e:	8d 50 04             	lea    0x4(%eax),%edx
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 10                	mov    %edx,(%eax)
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	8b 00                	mov    (%eax),%eax
  800b3b:	83 e8 04             	sub    $0x4,%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	99                   	cltd   
  800b41:	eb 18                	jmp    800b5b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	8b 00                	mov    (%eax),%eax
  800b48:	8d 50 04             	lea    0x4(%eax),%edx
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	89 10                	mov    %edx,(%eax)
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	8b 00                	mov    (%eax),%eax
  800b55:	83 e8 04             	sub    $0x4,%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	99                   	cltd   
}
  800b5b:	5d                   	pop    %ebp
  800b5c:	c3                   	ret    

00800b5d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b5d:	55                   	push   %ebp
  800b5e:	89 e5                	mov    %esp,%ebp
  800b60:	56                   	push   %esi
  800b61:	53                   	push   %ebx
  800b62:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b65:	eb 17                	jmp    800b7e <vprintfmt+0x21>
			if (ch == '\0')
  800b67:	85 db                	test   %ebx,%ebx
  800b69:	0f 84 af 03 00 00    	je     800f1e <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	53                   	push   %ebx
  800b76:	8b 45 08             	mov    0x8(%ebp),%eax
  800b79:	ff d0                	call   *%eax
  800b7b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	8d 50 01             	lea    0x1(%eax),%edx
  800b84:	89 55 10             	mov    %edx,0x10(%ebp)
  800b87:	8a 00                	mov    (%eax),%al
  800b89:	0f b6 d8             	movzbl %al,%ebx
  800b8c:	83 fb 25             	cmp    $0x25,%ebx
  800b8f:	75 d6                	jne    800b67 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800b91:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800b95:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800b9c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800ba3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800baa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb4:	8d 50 01             	lea    0x1(%eax),%edx
  800bb7:	89 55 10             	mov    %edx,0x10(%ebp)
  800bba:	8a 00                	mov    (%eax),%al
  800bbc:	0f b6 d8             	movzbl %al,%ebx
  800bbf:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bc2:	83 f8 55             	cmp    $0x55,%eax
  800bc5:	0f 87 2b 03 00 00    	ja     800ef6 <vprintfmt+0x399>
  800bcb:	8b 04 85 78 3f 80 00 	mov    0x803f78(,%eax,4),%eax
  800bd2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800bd4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bd8:	eb d7                	jmp    800bb1 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bda:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bde:	eb d1                	jmp    800bb1 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800be0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800be7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bea:	89 d0                	mov    %edx,%eax
  800bec:	c1 e0 02             	shl    $0x2,%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	01 c0                	add    %eax,%eax
  800bf3:	01 d8                	add    %ebx,%eax
  800bf5:	83 e8 30             	sub    $0x30,%eax
  800bf8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800bfb:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfe:	8a 00                	mov    (%eax),%al
  800c00:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c03:	83 fb 2f             	cmp    $0x2f,%ebx
  800c06:	7e 3e                	jle    800c46 <vprintfmt+0xe9>
  800c08:	83 fb 39             	cmp    $0x39,%ebx
  800c0b:	7f 39                	jg     800c46 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c0d:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c10:	eb d5                	jmp    800be7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c12:	8b 45 14             	mov    0x14(%ebp),%eax
  800c15:	83 c0 04             	add    $0x4,%eax
  800c18:	89 45 14             	mov    %eax,0x14(%ebp)
  800c1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1e:	83 e8 04             	sub    $0x4,%eax
  800c21:	8b 00                	mov    (%eax),%eax
  800c23:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c26:	eb 1f                	jmp    800c47 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c2c:	79 83                	jns    800bb1 <vprintfmt+0x54>
				width = 0;
  800c2e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c35:	e9 77 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c3a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c41:	e9 6b ff ff ff       	jmp    800bb1 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c46:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c47:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c4b:	0f 89 60 ff ff ff    	jns    800bb1 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c57:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c5e:	e9 4e ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c63:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c66:	e9 46 ff ff ff       	jmp    800bb1 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6e:	83 c0 04             	add    $0x4,%eax
  800c71:	89 45 14             	mov    %eax,0x14(%ebp)
  800c74:	8b 45 14             	mov    0x14(%ebp),%eax
  800c77:	83 e8 04             	sub    $0x4,%eax
  800c7a:	8b 00                	mov    (%eax),%eax
  800c7c:	83 ec 08             	sub    $0x8,%esp
  800c7f:	ff 75 0c             	pushl  0xc(%ebp)
  800c82:	50                   	push   %eax
  800c83:	8b 45 08             	mov    0x8(%ebp),%eax
  800c86:	ff d0                	call   *%eax
  800c88:	83 c4 10             	add    $0x10,%esp
			break;
  800c8b:	e9 89 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800c90:	8b 45 14             	mov    0x14(%ebp),%eax
  800c93:	83 c0 04             	add    $0x4,%eax
  800c96:	89 45 14             	mov    %eax,0x14(%ebp)
  800c99:	8b 45 14             	mov    0x14(%ebp),%eax
  800c9c:	83 e8 04             	sub    $0x4,%eax
  800c9f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800ca1:	85 db                	test   %ebx,%ebx
  800ca3:	79 02                	jns    800ca7 <vprintfmt+0x14a>
				err = -err;
  800ca5:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ca7:	83 fb 64             	cmp    $0x64,%ebx
  800caa:	7f 0b                	jg     800cb7 <vprintfmt+0x15a>
  800cac:	8b 34 9d c0 3d 80 00 	mov    0x803dc0(,%ebx,4),%esi
  800cb3:	85 f6                	test   %esi,%esi
  800cb5:	75 19                	jne    800cd0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cb7:	53                   	push   %ebx
  800cb8:	68 65 3f 80 00       	push   $0x803f65
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 5e 02 00 00       	call   800f26 <printfmt>
  800cc8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ccb:	e9 49 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800cd0:	56                   	push   %esi
  800cd1:	68 6e 3f 80 00       	push   $0x803f6e
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	ff 75 08             	pushl  0x8(%ebp)
  800cdc:	e8 45 02 00 00       	call   800f26 <printfmt>
  800ce1:	83 c4 10             	add    $0x10,%esp
			break;
  800ce4:	e9 30 02 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ce9:	8b 45 14             	mov    0x14(%ebp),%eax
  800cec:	83 c0 04             	add    $0x4,%eax
  800cef:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf5:	83 e8 04             	sub    $0x4,%eax
  800cf8:	8b 30                	mov    (%eax),%esi
  800cfa:	85 f6                	test   %esi,%esi
  800cfc:	75 05                	jne    800d03 <vprintfmt+0x1a6>
				p = "(null)";
  800cfe:	be 71 3f 80 00       	mov    $0x803f71,%esi
			if (width > 0 && padc != '-')
  800d03:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d07:	7e 6d                	jle    800d76 <vprintfmt+0x219>
  800d09:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d0d:	74 67                	je     800d76 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d12:	83 ec 08             	sub    $0x8,%esp
  800d15:	50                   	push   %eax
  800d16:	56                   	push   %esi
  800d17:	e8 0c 03 00 00       	call   801028 <strnlen>
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d22:	eb 16                	jmp    800d3a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d24:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	50                   	push   %eax
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	ff d0                	call   *%eax
  800d34:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d37:	ff 4d e4             	decl   -0x1c(%ebp)
  800d3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3e:	7f e4                	jg     800d24 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d40:	eb 34                	jmp    800d76 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d42:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d46:	74 1c                	je     800d64 <vprintfmt+0x207>
  800d48:	83 fb 1f             	cmp    $0x1f,%ebx
  800d4b:	7e 05                	jle    800d52 <vprintfmt+0x1f5>
  800d4d:	83 fb 7e             	cmp    $0x7e,%ebx
  800d50:	7e 12                	jle    800d64 <vprintfmt+0x207>
					putch('?', putdat);
  800d52:	83 ec 08             	sub    $0x8,%esp
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	6a 3f                	push   $0x3f
  800d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5d:	ff d0                	call   *%eax
  800d5f:	83 c4 10             	add    $0x10,%esp
  800d62:	eb 0f                	jmp    800d73 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	53                   	push   %ebx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	ff d0                	call   *%eax
  800d70:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d73:	ff 4d e4             	decl   -0x1c(%ebp)
  800d76:	89 f0                	mov    %esi,%eax
  800d78:	8d 70 01             	lea    0x1(%eax),%esi
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	0f be d8             	movsbl %al,%ebx
  800d80:	85 db                	test   %ebx,%ebx
  800d82:	74 24                	je     800da8 <vprintfmt+0x24b>
  800d84:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d88:	78 b8                	js     800d42 <vprintfmt+0x1e5>
  800d8a:	ff 4d e0             	decl   -0x20(%ebp)
  800d8d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d91:	79 af                	jns    800d42 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800d93:	eb 13                	jmp    800da8 <vprintfmt+0x24b>
				putch(' ', putdat);
  800d95:	83 ec 08             	sub    $0x8,%esp
  800d98:	ff 75 0c             	pushl  0xc(%ebp)
  800d9b:	6a 20                	push   $0x20
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	ff d0                	call   *%eax
  800da2:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	ff 4d e4             	decl   -0x1c(%ebp)
  800da8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dac:	7f e7                	jg     800d95 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dae:	e9 66 01 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 e8             	pushl  -0x18(%ebp)
  800db9:	8d 45 14             	lea    0x14(%ebp),%eax
  800dbc:	50                   	push   %eax
  800dbd:	e8 3c fd ff ff       	call   800afe <getint>
  800dc2:	83 c4 10             	add    $0x10,%esp
  800dc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dc8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dd1:	85 d2                	test   %edx,%edx
  800dd3:	79 23                	jns    800df8 <vprintfmt+0x29b>
				putch('-', putdat);
  800dd5:	83 ec 08             	sub    $0x8,%esp
  800dd8:	ff 75 0c             	pushl  0xc(%ebp)
  800ddb:	6a 2d                	push   $0x2d
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	ff d0                	call   *%eax
  800de2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800deb:	f7 d8                	neg    %eax
  800ded:	83 d2 00             	adc    $0x0,%edx
  800df0:	f7 da                	neg    %edx
  800df2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800df5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800df8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800dff:	e9 bc 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e04:	83 ec 08             	sub    $0x8,%esp
  800e07:	ff 75 e8             	pushl  -0x18(%ebp)
  800e0a:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0d:	50                   	push   %eax
  800e0e:	e8 84 fc ff ff       	call   800a97 <getuint>
  800e13:	83 c4 10             	add    $0x10,%esp
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e19:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e1c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e23:	e9 98 00 00 00       	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e28:	83 ec 08             	sub    $0x8,%esp
  800e2b:	ff 75 0c             	pushl  0xc(%ebp)
  800e2e:	6a 58                	push   $0x58
  800e30:	8b 45 08             	mov    0x8(%ebp),%eax
  800e33:	ff d0                	call   *%eax
  800e35:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 0c             	pushl  0xc(%ebp)
  800e3e:	6a 58                	push   $0x58
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	ff d0                	call   *%eax
  800e45:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e48:	83 ec 08             	sub    $0x8,%esp
  800e4b:	ff 75 0c             	pushl  0xc(%ebp)
  800e4e:	6a 58                	push   $0x58
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	ff d0                	call   *%eax
  800e55:	83 c4 10             	add    $0x10,%esp
			break;
  800e58:	e9 bc 00 00 00       	jmp    800f19 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e5d:	83 ec 08             	sub    $0x8,%esp
  800e60:	ff 75 0c             	pushl  0xc(%ebp)
  800e63:	6a 30                	push   $0x30
  800e65:	8b 45 08             	mov    0x8(%ebp),%eax
  800e68:	ff d0                	call   *%eax
  800e6a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e6d:	83 ec 08             	sub    $0x8,%esp
  800e70:	ff 75 0c             	pushl  0xc(%ebp)
  800e73:	6a 78                	push   $0x78
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	ff d0                	call   *%eax
  800e7a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800e80:	83 c0 04             	add    $0x4,%eax
  800e83:	89 45 14             	mov    %eax,0x14(%ebp)
  800e86:	8b 45 14             	mov    0x14(%ebp),%eax
  800e89:	83 e8 04             	sub    $0x4,%eax
  800e8c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800e8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800e98:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800e9f:	eb 1f                	jmp    800ec0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 e8             	pushl  -0x18(%ebp)
  800ea7:	8d 45 14             	lea    0x14(%ebp),%eax
  800eaa:	50                   	push   %eax
  800eab:	e8 e7 fb ff ff       	call   800a97 <getuint>
  800eb0:	83 c4 10             	add    $0x10,%esp
  800eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eb9:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ec0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ec4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ec7:	83 ec 04             	sub    $0x4,%esp
  800eca:	52                   	push   %edx
  800ecb:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ed2:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed5:	ff 75 0c             	pushl  0xc(%ebp)
  800ed8:	ff 75 08             	pushl  0x8(%ebp)
  800edb:	e8 00 fb ff ff       	call   8009e0 <printnum>
  800ee0:	83 c4 20             	add    $0x20,%esp
			break;
  800ee3:	eb 34                	jmp    800f19 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ee5:	83 ec 08             	sub    $0x8,%esp
  800ee8:	ff 75 0c             	pushl  0xc(%ebp)
  800eeb:	53                   	push   %ebx
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
  800eef:	ff d0                	call   *%eax
  800ef1:	83 c4 10             	add    $0x10,%esp
			break;
  800ef4:	eb 23                	jmp    800f19 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	6a 25                	push   $0x25
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f06:	ff 4d 10             	decl   0x10(%ebp)
  800f09:	eb 03                	jmp    800f0e <vprintfmt+0x3b1>
  800f0b:	ff 4d 10             	decl   0x10(%ebp)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	48                   	dec    %eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	3c 25                	cmp    $0x25,%al
  800f16:	75 f3                	jne    800f0b <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f18:	90                   	nop
		}
	}
  800f19:	e9 47 fc ff ff       	jmp    800b65 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f1e:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f22:	5b                   	pop    %ebx
  800f23:	5e                   	pop    %esi
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f2c:	8d 45 10             	lea    0x10(%ebp),%eax
  800f2f:	83 c0 04             	add    $0x4,%eax
  800f32:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3b:	50                   	push   %eax
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	ff 75 08             	pushl  0x8(%ebp)
  800f42:	e8 16 fc ff ff       	call   800b5d <vprintfmt>
  800f47:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f4a:	90                   	nop
  800f4b:	c9                   	leave  
  800f4c:	c3                   	ret    

00800f4d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f53:	8b 40 08             	mov    0x8(%eax),%eax
  800f56:	8d 50 01             	lea    0x1(%eax),%edx
  800f59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f62:	8b 10                	mov    (%eax),%edx
  800f64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f67:	8b 40 04             	mov    0x4(%eax),%eax
  800f6a:	39 c2                	cmp    %eax,%edx
  800f6c:	73 12                	jae    800f80 <sprintputch+0x33>
		*b->buf++ = ch;
  800f6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f71:	8b 00                	mov    (%eax),%eax
  800f73:	8d 48 01             	lea    0x1(%eax),%ecx
  800f76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f79:	89 0a                	mov    %ecx,(%edx)
  800f7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7e:	88 10                	mov    %dl,(%eax)
}
  800f80:	90                   	nop
  800f81:	5d                   	pop    %ebp
  800f82:	c3                   	ret    

00800f83 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f83:	55                   	push   %ebp
  800f84:	89 e5                	mov    %esp,%ebp
  800f86:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f92:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f95:	8b 45 08             	mov    0x8(%ebp),%eax
  800f98:	01 d0                	add    %edx,%eax
  800f9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fa4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fa8:	74 06                	je     800fb0 <vsnprintf+0x2d>
  800faa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fae:	7f 07                	jg     800fb7 <vsnprintf+0x34>
		return -E_INVAL;
  800fb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800fb5:	eb 20                	jmp    800fd7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fb7:	ff 75 14             	pushl  0x14(%ebp)
  800fba:	ff 75 10             	pushl  0x10(%ebp)
  800fbd:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fc0:	50                   	push   %eax
  800fc1:	68 4d 0f 80 00       	push   $0x800f4d
  800fc6:	e8 92 fb ff ff       	call   800b5d <vprintfmt>
  800fcb:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fd1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fd7:	c9                   	leave  
  800fd8:	c3                   	ret    

00800fd9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800fdf:	8d 45 10             	lea    0x10(%ebp),%eax
  800fe2:	83 c0 04             	add    $0x4,%eax
  800fe5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800fe8:	8b 45 10             	mov    0x10(%ebp),%eax
  800feb:	ff 75 f4             	pushl  -0xc(%ebp)
  800fee:	50                   	push   %eax
  800fef:	ff 75 0c             	pushl  0xc(%ebp)
  800ff2:	ff 75 08             	pushl  0x8(%ebp)
  800ff5:	e8 89 ff ff ff       	call   800f83 <vsnprintf>
  800ffa:	83 c4 10             	add    $0x10,%esp
  800ffd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801000:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801003:	c9                   	leave  
  801004:	c3                   	ret    

00801005 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801005:	55                   	push   %ebp
  801006:	89 e5                	mov    %esp,%ebp
  801008:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80100b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801012:	eb 06                	jmp    80101a <strlen+0x15>
		n++;
  801014:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801017:	ff 45 08             	incl   0x8(%ebp)
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	8a 00                	mov    (%eax),%al
  80101f:	84 c0                	test   %al,%al
  801021:	75 f1                	jne    801014 <strlen+0xf>
		n++;
	return n;
  801023:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80102e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801035:	eb 09                	jmp    801040 <strnlen+0x18>
		n++;
  801037:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80103a:	ff 45 08             	incl   0x8(%ebp)
  80103d:	ff 4d 0c             	decl   0xc(%ebp)
  801040:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801044:	74 09                	je     80104f <strnlen+0x27>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 00                	mov    (%eax),%al
  80104b:	84 c0                	test   %al,%al
  80104d:	75 e8                	jne    801037 <strnlen+0xf>
		n++;
	return n;
  80104f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801060:	90                   	nop
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8d 50 01             	lea    0x1(%eax),%edx
  801067:	89 55 08             	mov    %edx,0x8(%ebp)
  80106a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80106d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801070:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801073:	8a 12                	mov    (%edx),%dl
  801075:	88 10                	mov    %dl,(%eax)
  801077:	8a 00                	mov    (%eax),%al
  801079:	84 c0                	test   %al,%al
  80107b:	75 e4                	jne    801061 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80107d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80108e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801095:	eb 1f                	jmp    8010b6 <strncpy+0x34>
		*dst++ = *src;
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 08             	mov    %edx,0x8(%ebp)
  8010a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a3:	8a 12                	mov    (%edx),%dl
  8010a5:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8a 00                	mov    (%eax),%al
  8010ac:	84 c0                	test   %al,%al
  8010ae:	74 03                	je     8010b3 <strncpy+0x31>
			src++;
  8010b0:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010b3:	ff 45 fc             	incl   -0x4(%ebp)
  8010b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010bc:	72 d9                	jb     801097 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010be:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d3:	74 30                	je     801105 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010d5:	eb 16                	jmp    8010ed <strlcpy+0x2a>
			*dst++ = *src++;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8d 50 01             	lea    0x1(%eax),%edx
  8010dd:	89 55 08             	mov    %edx,0x8(%ebp)
  8010e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010e6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010e9:	8a 12                	mov    (%edx),%dl
  8010eb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ed:	ff 4d 10             	decl   0x10(%ebp)
  8010f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010f4:	74 09                	je     8010ff <strlcpy+0x3c>
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	75 d8                	jne    8010d7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8010ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801102:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110b:	29 c2                	sub    %eax,%edx
  80110d:	89 d0                	mov    %edx,%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801114:	eb 06                	jmp    80111c <strcmp+0xb>
		p++, q++;
  801116:	ff 45 08             	incl   0x8(%ebp)
  801119:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	84 c0                	test   %al,%al
  801123:	74 0e                	je     801133 <strcmp+0x22>
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	8a 10                	mov    (%eax),%dl
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	38 c2                	cmp    %al,%dl
  801131:	74 e3                	je     801116 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	0f b6 d0             	movzbl %al,%edx
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	8a 00                	mov    (%eax),%al
  801140:	0f b6 c0             	movzbl %al,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
}
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80114c:	eb 09                	jmp    801157 <strncmp+0xe>
		n--, p++, q++;
  80114e:	ff 4d 10             	decl   0x10(%ebp)
  801151:	ff 45 08             	incl   0x8(%ebp)
  801154:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801157:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80115b:	74 17                	je     801174 <strncmp+0x2b>
  80115d:	8b 45 08             	mov    0x8(%ebp),%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	84 c0                	test   %al,%al
  801164:	74 0e                	je     801174 <strncmp+0x2b>
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	8a 10                	mov    (%eax),%dl
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	38 c2                	cmp    %al,%dl
  801172:	74 da                	je     80114e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801174:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801178:	75 07                	jne    801181 <strncmp+0x38>
		return 0;
  80117a:	b8 00 00 00 00       	mov    $0x0,%eax
  80117f:	eb 14                	jmp    801195 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801181:	8b 45 08             	mov    0x8(%ebp),%eax
  801184:	8a 00                	mov    (%eax),%al
  801186:	0f b6 d0             	movzbl %al,%edx
  801189:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118c:	8a 00                	mov    (%eax),%al
  80118e:	0f b6 c0             	movzbl %al,%eax
  801191:	29 c2                	sub    %eax,%edx
  801193:	89 d0                	mov    %edx,%eax
}
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011a3:	eb 12                	jmp    8011b7 <strchr+0x20>
		if (*s == c)
  8011a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ad:	75 05                	jne    8011b4 <strchr+0x1d>
			return (char *) s;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b2:	eb 11                	jmp    8011c5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011b4:	ff 45 08             	incl   0x8(%ebp)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	84 c0                	test   %al,%al
  8011be:	75 e5                	jne    8011a5 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011c5:	c9                   	leave  
  8011c6:	c3                   	ret    

008011c7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	83 ec 04             	sub    $0x4,%esp
  8011cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d3:	eb 0d                	jmp    8011e2 <strfind+0x1b>
		if (*s == c)
  8011d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d8:	8a 00                	mov    (%eax),%al
  8011da:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011dd:	74 0e                	je     8011ed <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011df:	ff 45 08             	incl   0x8(%ebp)
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	84 c0                	test   %al,%al
  8011e9:	75 ea                	jne    8011d5 <strfind+0xe>
  8011eb:	eb 01                	jmp    8011ee <strfind+0x27>
		if (*s == c)
			break;
  8011ed:	90                   	nop
	return (char *) s;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011f1:	c9                   	leave  
  8011f2:	c3                   	ret    

008011f3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8011f3:	55                   	push   %ebp
  8011f4:	89 e5                	mov    %esp,%ebp
  8011f6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8011ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801202:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801205:	eb 0e                	jmp    801215 <memset+0x22>
		*p++ = c;
  801207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80120a:	8d 50 01             	lea    0x1(%eax),%edx
  80120d:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801210:	8b 55 0c             	mov    0xc(%ebp),%edx
  801213:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801215:	ff 4d f8             	decl   -0x8(%ebp)
  801218:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80121c:	79 e9                	jns    801207 <memset+0x14>
		*p++ = c;

	return v;
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801229:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80122f:	8b 45 08             	mov    0x8(%ebp),%eax
  801232:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801235:	eb 16                	jmp    80124d <memcpy+0x2a>
		*d++ = *s++;
  801237:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80123a:	8d 50 01             	lea    0x1(%eax),%edx
  80123d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801240:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801243:	8d 4a 01             	lea    0x1(%edx),%ecx
  801246:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801249:	8a 12                	mov    (%edx),%dl
  80124b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80124d:	8b 45 10             	mov    0x10(%ebp),%eax
  801250:	8d 50 ff             	lea    -0x1(%eax),%edx
  801253:	89 55 10             	mov    %edx,0x10(%ebp)
  801256:	85 c0                	test   %eax,%eax
  801258:	75 dd                	jne    801237 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801265:	8b 45 0c             	mov    0xc(%ebp),%eax
  801268:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801271:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801274:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801277:	73 50                	jae    8012c9 <memmove+0x6a>
  801279:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80127c:	8b 45 10             	mov    0x10(%ebp),%eax
  80127f:	01 d0                	add    %edx,%eax
  801281:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801284:	76 43                	jbe    8012c9 <memmove+0x6a>
		s += n;
  801286:	8b 45 10             	mov    0x10(%ebp),%eax
  801289:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80128c:	8b 45 10             	mov    0x10(%ebp),%eax
  80128f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801292:	eb 10                	jmp    8012a4 <memmove+0x45>
			*--d = *--s;
  801294:	ff 4d f8             	decl   -0x8(%ebp)
  801297:	ff 4d fc             	decl   -0x4(%ebp)
  80129a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129d:	8a 10                	mov    (%eax),%dl
  80129f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012a2:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	75 e3                	jne    801294 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012b1:	eb 23                	jmp    8012d6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b6:	8d 50 01             	lea    0x1(%eax),%edx
  8012b9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012c2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012c5:	8a 12                	mov    (%edx),%dl
  8012c7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012cf:	89 55 10             	mov    %edx,0x10(%ebp)
  8012d2:	85 c0                	test   %eax,%eax
  8012d4:	75 dd                	jne    8012b3 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ea:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ed:	eb 2a                	jmp    801319 <memcmp+0x3e>
		if (*s1 != *s2)
  8012ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f2:	8a 10                	mov    (%eax),%dl
  8012f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f7:	8a 00                	mov    (%eax),%al
  8012f9:	38 c2                	cmp    %al,%dl
  8012fb:	74 16                	je     801313 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8012fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801300:	8a 00                	mov    (%eax),%al
  801302:	0f b6 d0             	movzbl %al,%edx
  801305:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	0f b6 c0             	movzbl %al,%eax
  80130d:	29 c2                	sub    %eax,%edx
  80130f:	89 d0                	mov    %edx,%eax
  801311:	eb 18                	jmp    80132b <memcmp+0x50>
		s1++, s2++;
  801313:	ff 45 fc             	incl   -0x4(%ebp)
  801316:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 c9                	jne    8012ef <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80132b:	c9                   	leave  
  80132c:	c3                   	ret    

0080132d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801333:	8b 55 08             	mov    0x8(%ebp),%edx
  801336:	8b 45 10             	mov    0x10(%ebp),%eax
  801339:	01 d0                	add    %edx,%eax
  80133b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80133e:	eb 15                	jmp    801355 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	8a 00                	mov    (%eax),%al
  801345:	0f b6 d0             	movzbl %al,%edx
  801348:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134b:	0f b6 c0             	movzbl %al,%eax
  80134e:	39 c2                	cmp    %eax,%edx
  801350:	74 0d                	je     80135f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801352:	ff 45 08             	incl   0x8(%ebp)
  801355:	8b 45 08             	mov    0x8(%ebp),%eax
  801358:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80135b:	72 e3                	jb     801340 <memfind+0x13>
  80135d:	eb 01                	jmp    801360 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80135f:	90                   	nop
	return (void *) s;
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801363:	c9                   	leave  
  801364:	c3                   	ret    

00801365 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80136b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801372:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801379:	eb 03                	jmp    80137e <strtol+0x19>
		s++;
  80137b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80137e:	8b 45 08             	mov    0x8(%ebp),%eax
  801381:	8a 00                	mov    (%eax),%al
  801383:	3c 20                	cmp    $0x20,%al
  801385:	74 f4                	je     80137b <strtol+0x16>
  801387:	8b 45 08             	mov    0x8(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	3c 09                	cmp    $0x9,%al
  80138e:	74 eb                	je     80137b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 2b                	cmp    $0x2b,%al
  801397:	75 05                	jne    80139e <strtol+0x39>
		s++;
  801399:	ff 45 08             	incl   0x8(%ebp)
  80139c:	eb 13                	jmp    8013b1 <strtol+0x4c>
	else if (*s == '-')
  80139e:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a1:	8a 00                	mov    (%eax),%al
  8013a3:	3c 2d                	cmp    $0x2d,%al
  8013a5:	75 0a                	jne    8013b1 <strtol+0x4c>
		s++, neg = 1;
  8013a7:	ff 45 08             	incl   0x8(%ebp)
  8013aa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b5:	74 06                	je     8013bd <strtol+0x58>
  8013b7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013bb:	75 20                	jne    8013dd <strtol+0x78>
  8013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c0:	8a 00                	mov    (%eax),%al
  8013c2:	3c 30                	cmp    $0x30,%al
  8013c4:	75 17                	jne    8013dd <strtol+0x78>
  8013c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c9:	40                   	inc    %eax
  8013ca:	8a 00                	mov    (%eax),%al
  8013cc:	3c 78                	cmp    $0x78,%al
  8013ce:	75 0d                	jne    8013dd <strtol+0x78>
		s += 2, base = 16;
  8013d0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013d4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013db:	eb 28                	jmp    801405 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013dd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e1:	75 15                	jne    8013f8 <strtol+0x93>
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	3c 30                	cmp    $0x30,%al
  8013ea:	75 0c                	jne    8013f8 <strtol+0x93>
		s++, base = 8;
  8013ec:	ff 45 08             	incl   0x8(%ebp)
  8013ef:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8013f6:	eb 0d                	jmp    801405 <strtol+0xa0>
	else if (base == 0)
  8013f8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013fc:	75 07                	jne    801405 <strtol+0xa0>
		base = 10;
  8013fe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801405:	8b 45 08             	mov    0x8(%ebp),%eax
  801408:	8a 00                	mov    (%eax),%al
  80140a:	3c 2f                	cmp    $0x2f,%al
  80140c:	7e 19                	jle    801427 <strtol+0xc2>
  80140e:	8b 45 08             	mov    0x8(%ebp),%eax
  801411:	8a 00                	mov    (%eax),%al
  801413:	3c 39                	cmp    $0x39,%al
  801415:	7f 10                	jg     801427 <strtol+0xc2>
			dig = *s - '0';
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	0f be c0             	movsbl %al,%eax
  80141f:	83 e8 30             	sub    $0x30,%eax
  801422:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801425:	eb 42                	jmp    801469 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801427:	8b 45 08             	mov    0x8(%ebp),%eax
  80142a:	8a 00                	mov    (%eax),%al
  80142c:	3c 60                	cmp    $0x60,%al
  80142e:	7e 19                	jle    801449 <strtol+0xe4>
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8a 00                	mov    (%eax),%al
  801435:	3c 7a                	cmp    $0x7a,%al
  801437:	7f 10                	jg     801449 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	0f be c0             	movsbl %al,%eax
  801441:	83 e8 57             	sub    $0x57,%eax
  801444:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801447:	eb 20                	jmp    801469 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
  80144c:	8a 00                	mov    (%eax),%al
  80144e:	3c 40                	cmp    $0x40,%al
  801450:	7e 39                	jle    80148b <strtol+0x126>
  801452:	8b 45 08             	mov    0x8(%ebp),%eax
  801455:	8a 00                	mov    (%eax),%al
  801457:	3c 5a                	cmp    $0x5a,%al
  801459:	7f 30                	jg     80148b <strtol+0x126>
			dig = *s - 'A' + 10;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	0f be c0             	movsbl %al,%eax
  801463:	83 e8 37             	sub    $0x37,%eax
  801466:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80146f:	7d 19                	jge    80148a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801471:	ff 45 08             	incl   0x8(%ebp)
  801474:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801477:	0f af 45 10          	imul   0x10(%ebp),%eax
  80147b:	89 c2                	mov    %eax,%edx
  80147d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801485:	e9 7b ff ff ff       	jmp    801405 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80148a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80148b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80148f:	74 08                	je     801499 <strtol+0x134>
		*endptr = (char *) s;
  801491:	8b 45 0c             	mov    0xc(%ebp),%eax
  801494:	8b 55 08             	mov    0x8(%ebp),%edx
  801497:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801499:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80149d:	74 07                	je     8014a6 <strtol+0x141>
  80149f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a2:	f7 d8                	neg    %eax
  8014a4:	eb 03                	jmp    8014a9 <strtol+0x144>
  8014a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    

008014ab <ltostr>:

void
ltostr(long value, char *str)
{
  8014ab:	55                   	push   %ebp
  8014ac:	89 e5                	mov    %esp,%ebp
  8014ae:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014b8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c3:	79 13                	jns    8014d8 <ltostr+0x2d>
	{
		neg = 1;
  8014c5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cf:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014d2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014d5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014db:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014e0:	99                   	cltd   
  8014e1:	f7 f9                	idiv   %ecx
  8014e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014e9:	8d 50 01             	lea    0x1(%eax),%edx
  8014ec:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8014ef:	89 c2                	mov    %eax,%edx
  8014f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f4:	01 d0                	add    %edx,%eax
  8014f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8014f9:	83 c2 30             	add    $0x30,%edx
  8014fc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8014fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801501:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801506:	f7 e9                	imul   %ecx
  801508:	c1 fa 02             	sar    $0x2,%edx
  80150b:	89 c8                	mov    %ecx,%eax
  80150d:	c1 f8 1f             	sar    $0x1f,%eax
  801510:	29 c2                	sub    %eax,%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801517:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80151a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80151f:	f7 e9                	imul   %ecx
  801521:	c1 fa 02             	sar    $0x2,%edx
  801524:	89 c8                	mov    %ecx,%eax
  801526:	c1 f8 1f             	sar    $0x1f,%eax
  801529:	29 c2                	sub    %eax,%edx
  80152b:	89 d0                	mov    %edx,%eax
  80152d:	c1 e0 02             	shl    $0x2,%eax
  801530:	01 d0                	add    %edx,%eax
  801532:	01 c0                	add    %eax,%eax
  801534:	29 c1                	sub    %eax,%ecx
  801536:	89 ca                	mov    %ecx,%edx
  801538:	85 d2                	test   %edx,%edx
  80153a:	75 9c                	jne    8014d8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80153c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801543:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801546:	48                   	dec    %eax
  801547:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80154a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80154e:	74 3d                	je     80158d <ltostr+0xe2>
		start = 1 ;
  801550:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801557:	eb 34                	jmp    80158d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80155c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80155f:	01 d0                	add    %edx,%eax
  801561:	8a 00                	mov    (%eax),%al
  801563:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156c:	01 c2                	add    %eax,%edx
  80156e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	01 c8                	add    %ecx,%eax
  801576:	8a 00                	mov    (%eax),%al
  801578:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80157a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801580:	01 c2                	add    %eax,%edx
  801582:	8a 45 eb             	mov    -0x15(%ebp),%al
  801585:	88 02                	mov    %al,(%edx)
		start++ ;
  801587:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80158a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80158d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801590:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801593:	7c c4                	jl     801559 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801595:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	01 d0                	add    %edx,%eax
  80159d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015a0:	90                   	nop
  8015a1:	c9                   	leave  
  8015a2:	c3                   	ret    

008015a3 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015a3:	55                   	push   %ebp
  8015a4:	89 e5                	mov    %esp,%ebp
  8015a6:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015a9:	ff 75 08             	pushl  0x8(%ebp)
  8015ac:	e8 54 fa ff ff       	call   801005 <strlen>
  8015b1:	83 c4 04             	add    $0x4,%esp
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015b7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ba:	e8 46 fa ff ff       	call   801005 <strlen>
  8015bf:	83 c4 04             	add    $0x4,%esp
  8015c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015d3:	eb 17                	jmp    8015ec <strcconcat+0x49>
		final[s] = str1[s] ;
  8015d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015db:	01 c2                	add    %eax,%edx
  8015dd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	01 c8                	add    %ecx,%eax
  8015e5:	8a 00                	mov    (%eax),%al
  8015e7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015e9:	ff 45 fc             	incl   -0x4(%ebp)
  8015ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8015f2:	7c e1                	jl     8015d5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8015f4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8015fb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801602:	eb 1f                	jmp    801623 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801604:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801607:	8d 50 01             	lea    0x1(%eax),%edx
  80160a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80160d:	89 c2                	mov    %eax,%edx
  80160f:	8b 45 10             	mov    0x10(%ebp),%eax
  801612:	01 c2                	add    %eax,%edx
  801614:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	01 c8                	add    %ecx,%eax
  80161c:	8a 00                	mov    (%eax),%al
  80161e:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801620:	ff 45 f8             	incl   -0x8(%ebp)
  801623:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801626:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801629:	7c d9                	jl     801604 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80162b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80162e:	8b 45 10             	mov    0x10(%ebp),%eax
  801631:	01 d0                	add    %edx,%eax
  801633:	c6 00 00             	movb   $0x0,(%eax)
}
  801636:	90                   	nop
  801637:	c9                   	leave  
  801638:	c3                   	ret    

00801639 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80163c:	8b 45 14             	mov    0x14(%ebp),%eax
  80163f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801645:	8b 45 14             	mov    0x14(%ebp),%eax
  801648:	8b 00                	mov    (%eax),%eax
  80164a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801651:	8b 45 10             	mov    0x10(%ebp),%eax
  801654:	01 d0                	add    %edx,%eax
  801656:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80165c:	eb 0c                	jmp    80166a <strsplit+0x31>
			*string++ = 0;
  80165e:	8b 45 08             	mov    0x8(%ebp),%eax
  801661:	8d 50 01             	lea    0x1(%eax),%edx
  801664:	89 55 08             	mov    %edx,0x8(%ebp)
  801667:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8a 00                	mov    (%eax),%al
  80166f:	84 c0                	test   %al,%al
  801671:	74 18                	je     80168b <strsplit+0x52>
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	8a 00                	mov    (%eax),%al
  801678:	0f be c0             	movsbl %al,%eax
  80167b:	50                   	push   %eax
  80167c:	ff 75 0c             	pushl  0xc(%ebp)
  80167f:	e8 13 fb ff ff       	call   801197 <strchr>
  801684:	83 c4 08             	add    $0x8,%esp
  801687:	85 c0                	test   %eax,%eax
  801689:	75 d3                	jne    80165e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80168b:	8b 45 08             	mov    0x8(%ebp),%eax
  80168e:	8a 00                	mov    (%eax),%al
  801690:	84 c0                	test   %al,%al
  801692:	74 5a                	je     8016ee <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	83 f8 0f             	cmp    $0xf,%eax
  80169c:	75 07                	jne    8016a5 <strsplit+0x6c>
		{
			return 0;
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	eb 66                	jmp    80170b <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a8:	8b 00                	mov    (%eax),%eax
  8016aa:	8d 48 01             	lea    0x1(%eax),%ecx
  8016ad:	8b 55 14             	mov    0x14(%ebp),%edx
  8016b0:	89 0a                	mov    %ecx,(%edx)
  8016b2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016bc:	01 c2                	add    %eax,%edx
  8016be:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c3:	eb 03                	jmp    8016c8 <strsplit+0x8f>
			string++;
  8016c5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	84 c0                	test   %al,%al
  8016cf:	74 8b                	je     80165c <strsplit+0x23>
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f be c0             	movsbl %al,%eax
  8016d9:	50                   	push   %eax
  8016da:	ff 75 0c             	pushl  0xc(%ebp)
  8016dd:	e8 b5 fa ff ff       	call   801197 <strchr>
  8016e2:	83 c4 08             	add    $0x8,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	74 dc                	je     8016c5 <strsplit+0x8c>
			string++;
	}
  8016e9:	e9 6e ff ff ff       	jmp    80165c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8016ee:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8016ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f2:	8b 00                	mov    (%eax),%eax
  8016f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fe:	01 d0                	add    %edx,%eax
  801700:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801706:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80170b:	c9                   	leave  
  80170c:	c3                   	ret    

0080170d <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801713:	a1 04 50 80 00       	mov    0x805004,%eax
  801718:	85 c0                	test   %eax,%eax
  80171a:	74 1f                	je     80173b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80171c:	e8 1d 00 00 00       	call   80173e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801721:	83 ec 0c             	sub    $0xc,%esp
  801724:	68 d0 40 80 00       	push   $0x8040d0
  801729:	e8 55 f2 ff ff       	call   800983 <cprintf>
  80172e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801731:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801738:	00 00 00 
	}
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801744:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80174b:	00 00 00 
  80174e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801755:	00 00 00 
  801758:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80175f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801762:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801769:	00 00 00 
  80176c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801773:	00 00 00 
  801776:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80177d:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801780:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178a:	c1 e8 0c             	shr    $0xc,%eax
  80178d:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801792:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80179c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017a1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017a6:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  8017ab:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8017b2:	a1 20 51 80 00       	mov    0x805120,%eax
  8017b7:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8017bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8017be:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8017c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017cb:	01 d0                	add    %edx,%eax
  8017cd:	48                   	dec    %eax
  8017ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d9:	f7 75 e4             	divl   -0x1c(%ebp)
  8017dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017df:	29 d0                	sub    %edx,%eax
  8017e1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8017e4:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8017eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8017ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017f3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017f8:	83 ec 04             	sub    $0x4,%esp
  8017fb:	6a 07                	push   $0x7
  8017fd:	ff 75 e8             	pushl  -0x18(%ebp)
  801800:	50                   	push   %eax
  801801:	e8 3d 06 00 00       	call   801e43 <sys_allocate_chunk>
  801806:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801809:	a1 20 51 80 00       	mov    0x805120,%eax
  80180e:	83 ec 0c             	sub    $0xc,%esp
  801811:	50                   	push   %eax
  801812:	e8 b2 0c 00 00       	call   8024c9 <initialize_MemBlocksList>
  801817:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  80181a:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80181f:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801822:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801826:	0f 84 f3 00 00 00    	je     80191f <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80182c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801830:	75 14                	jne    801846 <initialize_dyn_block_system+0x108>
  801832:	83 ec 04             	sub    $0x4,%esp
  801835:	68 f5 40 80 00       	push   $0x8040f5
  80183a:	6a 36                	push   $0x36
  80183c:	68 13 41 80 00       	push   $0x804113
  801841:	e8 89 ee ff ff       	call   8006cf <_panic>
  801846:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801849:	8b 00                	mov    (%eax),%eax
  80184b:	85 c0                	test   %eax,%eax
  80184d:	74 10                	je     80185f <initialize_dyn_block_system+0x121>
  80184f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801852:	8b 00                	mov    (%eax),%eax
  801854:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801857:	8b 52 04             	mov    0x4(%edx),%edx
  80185a:	89 50 04             	mov    %edx,0x4(%eax)
  80185d:	eb 0b                	jmp    80186a <initialize_dyn_block_system+0x12c>
  80185f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801862:	8b 40 04             	mov    0x4(%eax),%eax
  801865:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80186a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80186d:	8b 40 04             	mov    0x4(%eax),%eax
  801870:	85 c0                	test   %eax,%eax
  801872:	74 0f                	je     801883 <initialize_dyn_block_system+0x145>
  801874:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801877:	8b 40 04             	mov    0x4(%eax),%eax
  80187a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80187d:	8b 12                	mov    (%edx),%edx
  80187f:	89 10                	mov    %edx,(%eax)
  801881:	eb 0a                	jmp    80188d <initialize_dyn_block_system+0x14f>
  801883:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	a3 48 51 80 00       	mov    %eax,0x805148
  80188d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801896:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801899:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018a0:	a1 54 51 80 00       	mov    0x805154,%eax
  8018a5:	48                   	dec    %eax
  8018a6:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8018ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018ae:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8018b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018b8:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8018bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018c3:	75 14                	jne    8018d9 <initialize_dyn_block_system+0x19b>
  8018c5:	83 ec 04             	sub    $0x4,%esp
  8018c8:	68 20 41 80 00       	push   $0x804120
  8018cd:	6a 3e                	push   $0x3e
  8018cf:	68 13 41 80 00       	push   $0x804113
  8018d4:	e8 f6 ed ff ff       	call   8006cf <_panic>
  8018d9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8018df:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e2:	89 10                	mov    %edx,(%eax)
  8018e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e7:	8b 00                	mov    (%eax),%eax
  8018e9:	85 c0                	test   %eax,%eax
  8018eb:	74 0d                	je     8018fa <initialize_dyn_block_system+0x1bc>
  8018ed:	a1 38 51 80 00       	mov    0x805138,%eax
  8018f2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018f5:	89 50 04             	mov    %edx,0x4(%eax)
  8018f8:	eb 08                	jmp    801902 <initialize_dyn_block_system+0x1c4>
  8018fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018fd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801902:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801905:	a3 38 51 80 00       	mov    %eax,0x805138
  80190a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80190d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801914:	a1 44 51 80 00       	mov    0x805144,%eax
  801919:	40                   	inc    %eax
  80191a:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  80191f:	90                   	nop
  801920:	c9                   	leave  
  801921:	c3                   	ret    

00801922 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801922:	55                   	push   %ebp
  801923:	89 e5                	mov    %esp,%ebp
  801925:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801928:	e8 e0 fd ff ff       	call   80170d <InitializeUHeap>
		if (size == 0) return NULL ;
  80192d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801931:	75 07                	jne    80193a <malloc+0x18>
  801933:	b8 00 00 00 00       	mov    $0x0,%eax
  801938:	eb 7f                	jmp    8019b9 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80193a:	e8 d2 08 00 00       	call   802211 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80193f:	85 c0                	test   %eax,%eax
  801941:	74 71                	je     8019b4 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801943:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80194a:	8b 55 08             	mov    0x8(%ebp),%edx
  80194d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801950:	01 d0                	add    %edx,%eax
  801952:	48                   	dec    %eax
  801953:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801956:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801959:	ba 00 00 00 00       	mov    $0x0,%edx
  80195e:	f7 75 f4             	divl   -0xc(%ebp)
  801961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801964:	29 d0                	sub    %edx,%eax
  801966:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801969:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801970:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801977:	76 07                	jbe    801980 <malloc+0x5e>
					return NULL ;
  801979:	b8 00 00 00 00       	mov    $0x0,%eax
  80197e:	eb 39                	jmp    8019b9 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801980:	83 ec 0c             	sub    $0xc,%esp
  801983:	ff 75 08             	pushl  0x8(%ebp)
  801986:	e8 e6 0d 00 00       	call   802771 <alloc_block_FF>
  80198b:	83 c4 10             	add    $0x10,%esp
  80198e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801991:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801995:	74 16                	je     8019ad <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801997:	83 ec 0c             	sub    $0xc,%esp
  80199a:	ff 75 ec             	pushl  -0x14(%ebp)
  80199d:	e8 37 0c 00 00       	call   8025d9 <insert_sorted_allocList>
  8019a2:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8019a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019a8:	8b 40 08             	mov    0x8(%eax),%eax
  8019ab:	eb 0c                	jmp    8019b9 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8019ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8019b2:	eb 05                	jmp    8019b9 <malloc+0x97>
				}
		}
	return 0;
  8019b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8019c7:	83 ec 08             	sub    $0x8,%esp
  8019ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8019cd:	68 40 50 80 00       	push   $0x805040
  8019d2:	e8 cf 0b 00 00       	call   8025a6 <find_block>
  8019d7:	83 c4 10             	add    $0x10,%esp
  8019da:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8019dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8019e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019e9:	8b 40 08             	mov    0x8(%eax),%eax
  8019ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8019ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019f3:	0f 84 a1 00 00 00    	je     801a9a <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8019f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8019fd:	75 17                	jne    801a16 <free+0x5b>
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	68 f5 40 80 00       	push   $0x8040f5
  801a07:	68 80 00 00 00       	push   $0x80
  801a0c:	68 13 41 80 00       	push   $0x804113
  801a11:	e8 b9 ec ff ff       	call   8006cf <_panic>
  801a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a19:	8b 00                	mov    (%eax),%eax
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	74 10                	je     801a2f <free+0x74>
  801a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a22:	8b 00                	mov    (%eax),%eax
  801a24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a27:	8b 52 04             	mov    0x4(%edx),%edx
  801a2a:	89 50 04             	mov    %edx,0x4(%eax)
  801a2d:	eb 0b                	jmp    801a3a <free+0x7f>
  801a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a32:	8b 40 04             	mov    0x4(%eax),%eax
  801a35:	a3 44 50 80 00       	mov    %eax,0x805044
  801a3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3d:	8b 40 04             	mov    0x4(%eax),%eax
  801a40:	85 c0                	test   %eax,%eax
  801a42:	74 0f                	je     801a53 <free+0x98>
  801a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a47:	8b 40 04             	mov    0x4(%eax),%eax
  801a4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a4d:	8b 12                	mov    (%edx),%edx
  801a4f:	89 10                	mov    %edx,(%eax)
  801a51:	eb 0a                	jmp    801a5d <free+0xa2>
  801a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a56:	8b 00                	mov    (%eax),%eax
  801a58:	a3 40 50 80 00       	mov    %eax,0x805040
  801a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a60:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a70:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a75:	48                   	dec    %eax
  801a76:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801a7b:	83 ec 0c             	sub    $0xc,%esp
  801a7e:	ff 75 f0             	pushl  -0x10(%ebp)
  801a81:	e8 29 12 00 00       	call   802caf <insert_sorted_with_merge_freeList>
  801a86:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801a89:	83 ec 08             	sub    $0x8,%esp
  801a8c:	ff 75 ec             	pushl  -0x14(%ebp)
  801a8f:	ff 75 e8             	pushl  -0x18(%ebp)
  801a92:	e8 74 03 00 00       	call   801e0b <sys_free_user_mem>
  801a97:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801a9a:	90                   	nop
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 38             	sub    $0x38,%esp
  801aa3:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa6:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801aa9:	e8 5f fc ff ff       	call   80170d <InitializeUHeap>
	if (size == 0) return NULL ;
  801aae:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ab2:	75 0a                	jne    801abe <smalloc+0x21>
  801ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab9:	e9 b2 00 00 00       	jmp    801b70 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801abe:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801ac5:	76 0a                	jbe    801ad1 <smalloc+0x34>
		return NULL;
  801ac7:	b8 00 00 00 00       	mov    $0x0,%eax
  801acc:	e9 9f 00 00 00       	jmp    801b70 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801ad1:	e8 3b 07 00 00       	call   802211 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ad6:	85 c0                	test   %eax,%eax
  801ad8:	0f 84 8d 00 00 00    	je     801b6b <smalloc+0xce>
	struct MemBlock *b = NULL;
  801ade:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801ae5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801aec:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801af2:	01 d0                	add    %edx,%eax
  801af4:	48                   	dec    %eax
  801af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801afb:	ba 00 00 00 00       	mov    $0x0,%edx
  801b00:	f7 75 f0             	divl   -0x10(%ebp)
  801b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b06:	29 d0                	sub    %edx,%eax
  801b08:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801b0b:	83 ec 0c             	sub    $0xc,%esp
  801b0e:	ff 75 e8             	pushl  -0x18(%ebp)
  801b11:	e8 5b 0c 00 00       	call   802771 <alloc_block_FF>
  801b16:	83 c4 10             	add    $0x10,%esp
  801b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801b1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b20:	75 07                	jne    801b29 <smalloc+0x8c>
			return NULL;
  801b22:	b8 00 00 00 00       	mov    $0x0,%eax
  801b27:	eb 47                	jmp    801b70 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801b29:	83 ec 0c             	sub    $0xc,%esp
  801b2c:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2f:	e8 a5 0a 00 00       	call   8025d9 <insert_sorted_allocList>
  801b34:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3a:	8b 40 08             	mov    0x8(%eax),%eax
  801b3d:	89 c2                	mov    %eax,%edx
  801b3f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b43:	52                   	push   %edx
  801b44:	50                   	push   %eax
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	ff 75 08             	pushl  0x8(%ebp)
  801b4b:	e8 46 04 00 00       	call   801f96 <sys_createSharedObject>
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801b56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b5a:	78 08                	js     801b64 <smalloc+0xc7>
		return (void *)b->sva;
  801b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5f:	8b 40 08             	mov    0x8(%eax),%eax
  801b62:	eb 0c                	jmp    801b70 <smalloc+0xd3>
		}else{
		return NULL;
  801b64:	b8 00 00 00 00       	mov    $0x0,%eax
  801b69:	eb 05                	jmp    801b70 <smalloc+0xd3>
			}

	}return NULL;
  801b6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b78:	e8 90 fb ff ff       	call   80170d <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b7d:	e8 8f 06 00 00       	call   802211 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b82:	85 c0                	test   %eax,%eax
  801b84:	0f 84 ad 00 00 00    	je     801c37 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b8a:	83 ec 08             	sub    $0x8,%esp
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	ff 75 08             	pushl  0x8(%ebp)
  801b93:	e8 28 04 00 00       	call   801fc0 <sys_getSizeOfSharedObject>
  801b98:	83 c4 10             	add    $0x10,%esp
  801b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801b9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ba2:	79 0a                	jns    801bae <sget+0x3c>
    {
    	return NULL;
  801ba4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ba9:	e9 8e 00 00 00       	jmp    801c3c <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801bae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801bb5:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801bbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc2:	01 d0                	add    %edx,%eax
  801bc4:	48                   	dec    %eax
  801bc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd0:	f7 75 ec             	divl   -0x14(%ebp)
  801bd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bd6:	29 d0                	sub    %edx,%eax
  801bd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801bdb:	83 ec 0c             	sub    $0xc,%esp
  801bde:	ff 75 e4             	pushl  -0x1c(%ebp)
  801be1:	e8 8b 0b 00 00       	call   802771 <alloc_block_FF>
  801be6:	83 c4 10             	add    $0x10,%esp
  801be9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801bec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801bf0:	75 07                	jne    801bf9 <sget+0x87>
				return NULL;
  801bf2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf7:	eb 43                	jmp    801c3c <sget+0xca>
			}
			insert_sorted_allocList(b);
  801bf9:	83 ec 0c             	sub    $0xc,%esp
  801bfc:	ff 75 f0             	pushl  -0x10(%ebp)
  801bff:	e8 d5 09 00 00       	call   8025d9 <insert_sorted_allocList>
  801c04:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c0a:	8b 40 08             	mov    0x8(%eax),%eax
  801c0d:	83 ec 04             	sub    $0x4,%esp
  801c10:	50                   	push   %eax
  801c11:	ff 75 0c             	pushl  0xc(%ebp)
  801c14:	ff 75 08             	pushl  0x8(%ebp)
  801c17:	e8 c1 03 00 00       	call   801fdd <sys_getSharedObject>
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801c22:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c26:	78 08                	js     801c30 <sget+0xbe>
			return (void *)b->sva;
  801c28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c2b:	8b 40 08             	mov    0x8(%eax),%eax
  801c2e:	eb 0c                	jmp    801c3c <sget+0xca>
			}else{
			return NULL;
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
  801c35:	eb 05                	jmp    801c3c <sget+0xca>
			}
    }}return NULL;
  801c37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c44:	e8 c4 fa ff ff       	call   80170d <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c49:	83 ec 04             	sub    $0x4,%esp
  801c4c:	68 44 41 80 00       	push   $0x804144
  801c51:	68 03 01 00 00       	push   $0x103
  801c56:	68 13 41 80 00       	push   $0x804113
  801c5b:	e8 6f ea ff ff       	call   8006cf <_panic>

00801c60 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c66:	83 ec 04             	sub    $0x4,%esp
  801c69:	68 6c 41 80 00       	push   $0x80416c
  801c6e:	68 17 01 00 00       	push   $0x117
  801c73:	68 13 41 80 00       	push   $0x804113
  801c78:	e8 52 ea ff ff       	call   8006cf <_panic>

00801c7d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c83:	83 ec 04             	sub    $0x4,%esp
  801c86:	68 90 41 80 00       	push   $0x804190
  801c8b:	68 22 01 00 00       	push   $0x122
  801c90:	68 13 41 80 00       	push   $0x804113
  801c95:	e8 35 ea ff ff       	call   8006cf <_panic>

00801c9a <shrink>:

}
void shrink(uint32 newSize)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
  801c9d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ca0:	83 ec 04             	sub    $0x4,%esp
  801ca3:	68 90 41 80 00       	push   $0x804190
  801ca8:	68 27 01 00 00       	push   $0x127
  801cad:	68 13 41 80 00       	push   $0x804113
  801cb2:	e8 18 ea ff ff       	call   8006cf <_panic>

00801cb7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cbd:	83 ec 04             	sub    $0x4,%esp
  801cc0:	68 90 41 80 00       	push   $0x804190
  801cc5:	68 2c 01 00 00       	push   $0x12c
  801cca:	68 13 41 80 00       	push   $0x804113
  801ccf:	e8 fb e9 ff ff       	call   8006cf <_panic>

00801cd4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	57                   	push   %edi
  801cd8:	56                   	push   %esi
  801cd9:	53                   	push   %ebx
  801cda:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ce6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ce9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cec:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801cef:	cd 30                	int    $0x30
  801cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801cf7:	83 c4 10             	add    $0x10,%esp
  801cfa:	5b                   	pop    %ebx
  801cfb:	5e                   	pop    %esi
  801cfc:	5f                   	pop    %edi
  801cfd:	5d                   	pop    %ebp
  801cfe:	c3                   	ret    

00801cff <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
  801d02:	83 ec 04             	sub    $0x4,%esp
  801d05:	8b 45 10             	mov    0x10(%ebp),%eax
  801d08:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d0b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	52                   	push   %edx
  801d17:	ff 75 0c             	pushl  0xc(%ebp)
  801d1a:	50                   	push   %eax
  801d1b:	6a 00                	push   $0x0
  801d1d:	e8 b2 ff ff ff       	call   801cd4 <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	90                   	nop
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 01                	push   $0x1
  801d37:	e8 98 ff ff ff       	call   801cd4 <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	52                   	push   %edx
  801d51:	50                   	push   %eax
  801d52:	6a 05                	push   $0x5
  801d54:	e8 7b ff ff ff       	call   801cd4 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	56                   	push   %esi
  801d62:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d63:	8b 75 18             	mov    0x18(%ebp),%esi
  801d66:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d69:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d72:	56                   	push   %esi
  801d73:	53                   	push   %ebx
  801d74:	51                   	push   %ecx
  801d75:	52                   	push   %edx
  801d76:	50                   	push   %eax
  801d77:	6a 06                	push   $0x6
  801d79:	e8 56 ff ff ff       	call   801cd4 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
}
  801d81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d84:	5b                   	pop    %ebx
  801d85:	5e                   	pop    %esi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    

00801d88 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	52                   	push   %edx
  801d98:	50                   	push   %eax
  801d99:	6a 07                	push   $0x7
  801d9b:	e8 34 ff ff ff       	call   801cd4 <syscall>
  801da0:	83 c4 18             	add    $0x18,%esp
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	ff 75 0c             	pushl  0xc(%ebp)
  801db1:	ff 75 08             	pushl  0x8(%ebp)
  801db4:	6a 08                	push   $0x8
  801db6:	e8 19 ff ff ff       	call   801cd4 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 09                	push   $0x9
  801dcf:	e8 00 ff ff ff       	call   801cd4 <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
}
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 0a                	push   $0xa
  801de8:	e8 e7 fe ff ff       	call   801cd4 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 0b                	push   $0xb
  801e01:	e8 ce fe ff ff       	call   801cd4 <syscall>
  801e06:	83 c4 18             	add    $0x18,%esp
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	ff 75 0c             	pushl  0xc(%ebp)
  801e17:	ff 75 08             	pushl  0x8(%ebp)
  801e1a:	6a 0f                	push   $0xf
  801e1c:	e8 b3 fe ff ff       	call   801cd4 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
	return;
  801e24:	90                   	nop
}
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	ff 75 0c             	pushl  0xc(%ebp)
  801e33:	ff 75 08             	pushl  0x8(%ebp)
  801e36:	6a 10                	push   $0x10
  801e38:	e8 97 fe ff ff       	call   801cd4 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e40:	90                   	nop
}
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	ff 75 10             	pushl  0x10(%ebp)
  801e4d:	ff 75 0c             	pushl  0xc(%ebp)
  801e50:	ff 75 08             	pushl  0x8(%ebp)
  801e53:	6a 11                	push   $0x11
  801e55:	e8 7a fe ff ff       	call   801cd4 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5d:	90                   	nop
}
  801e5e:	c9                   	leave  
  801e5f:	c3                   	ret    

00801e60 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e60:	55                   	push   %ebp
  801e61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 0c                	push   $0xc
  801e6f:	e8 60 fe ff ff       	call   801cd4 <syscall>
  801e74:	83 c4 18             	add    $0x18,%esp
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	ff 75 08             	pushl  0x8(%ebp)
  801e87:	6a 0d                	push   $0xd
  801e89:	e8 46 fe ff ff       	call   801cd4 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 0e                	push   $0xe
  801ea2:	e8 2d fe ff ff       	call   801cd4 <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	90                   	nop
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 13                	push   $0x13
  801ebc:	e8 13 fe ff ff       	call   801cd4 <syscall>
  801ec1:	83 c4 18             	add    $0x18,%esp
}
  801ec4:	90                   	nop
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 14                	push   $0x14
  801ed6:	e8 f9 fd ff ff       	call   801cd4 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
}
  801ede:	90                   	nop
  801edf:	c9                   	leave  
  801ee0:	c3                   	ret    

00801ee1 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ee1:	55                   	push   %ebp
  801ee2:	89 e5                	mov    %esp,%ebp
  801ee4:	83 ec 04             	sub    $0x4,%esp
  801ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eea:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801eed:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	6a 00                	push   $0x0
  801ef7:	6a 00                	push   $0x0
  801ef9:	50                   	push   %eax
  801efa:	6a 15                	push   $0x15
  801efc:	e8 d3 fd ff ff       	call   801cd4 <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
}
  801f04:	90                   	nop
  801f05:	c9                   	leave  
  801f06:	c3                   	ret    

00801f07 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f07:	55                   	push   %ebp
  801f08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 16                	push   $0x16
  801f16:	e8 b9 fd ff ff       	call   801cd4 <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
}
  801f1e:	90                   	nop
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	6a 00                	push   $0x0
  801f2d:	ff 75 0c             	pushl  0xc(%ebp)
  801f30:	50                   	push   %eax
  801f31:	6a 17                	push   $0x17
  801f33:	e8 9c fd ff ff       	call   801cd4 <syscall>
  801f38:	83 c4 18             	add    $0x18,%esp
}
  801f3b:	c9                   	leave  
  801f3c:	c3                   	ret    

00801f3d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f3d:	55                   	push   %ebp
  801f3e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	52                   	push   %edx
  801f4d:	50                   	push   %eax
  801f4e:	6a 1a                	push   $0x1a
  801f50:	e8 7f fd ff ff       	call   801cd4 <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	6a 00                	push   $0x0
  801f65:	6a 00                	push   $0x0
  801f67:	6a 00                	push   $0x0
  801f69:	52                   	push   %edx
  801f6a:	50                   	push   %eax
  801f6b:	6a 18                	push   $0x18
  801f6d:	e8 62 fd ff ff       	call   801cd4 <syscall>
  801f72:	83 c4 18             	add    $0x18,%esp
}
  801f75:	90                   	nop
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f81:	6a 00                	push   $0x0
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	52                   	push   %edx
  801f88:	50                   	push   %eax
  801f89:	6a 19                	push   $0x19
  801f8b:	e8 44 fd ff ff       	call   801cd4 <syscall>
  801f90:	83 c4 18             	add    $0x18,%esp
}
  801f93:	90                   	nop
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
  801f99:	83 ec 04             	sub    $0x4,%esp
  801f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fa2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fa5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	6a 00                	push   $0x0
  801fae:	51                   	push   %ecx
  801faf:	52                   	push   %edx
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	50                   	push   %eax
  801fb4:	6a 1b                	push   $0x1b
  801fb6:	e8 19 fd ff ff       	call   801cd4 <syscall>
  801fbb:	83 c4 18             	add    $0x18,%esp
}
  801fbe:	c9                   	leave  
  801fbf:	c3                   	ret    

00801fc0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	6a 00                	push   $0x0
  801fcb:	6a 00                	push   $0x0
  801fcd:	6a 00                	push   $0x0
  801fcf:	52                   	push   %edx
  801fd0:	50                   	push   %eax
  801fd1:	6a 1c                	push   $0x1c
  801fd3:	e8 fc fc ff ff       	call   801cd4 <syscall>
  801fd8:	83 c4 18             	add    $0x18,%esp
}
  801fdb:	c9                   	leave  
  801fdc:	c3                   	ret    

00801fdd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801fe0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	51                   	push   %ecx
  801fee:	52                   	push   %edx
  801fef:	50                   	push   %eax
  801ff0:	6a 1d                	push   $0x1d
  801ff2:	e8 dd fc ff ff       	call   801cd4 <syscall>
  801ff7:	83 c4 18             	add    $0x18,%esp
}
  801ffa:	c9                   	leave  
  801ffb:	c3                   	ret    

00801ffc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ffc:	55                   	push   %ebp
  801ffd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801fff:	8b 55 0c             	mov    0xc(%ebp),%edx
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	52                   	push   %edx
  80200c:	50                   	push   %eax
  80200d:	6a 1e                	push   $0x1e
  80200f:	e8 c0 fc ff ff       	call   801cd4 <syscall>
  802014:	83 c4 18             	add    $0x18,%esp
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80201c:	6a 00                	push   $0x0
  80201e:	6a 00                	push   $0x0
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 1f                	push   $0x1f
  802028:	e8 a7 fc ff ff       	call   801cd4 <syscall>
  80202d:	83 c4 18             	add    $0x18,%esp
}
  802030:	c9                   	leave  
  802031:	c3                   	ret    

00802032 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	6a 00                	push   $0x0
  80203a:	ff 75 14             	pushl  0x14(%ebp)
  80203d:	ff 75 10             	pushl  0x10(%ebp)
  802040:	ff 75 0c             	pushl  0xc(%ebp)
  802043:	50                   	push   %eax
  802044:	6a 20                	push   $0x20
  802046:	e8 89 fc ff ff       	call   801cd4 <syscall>
  80204b:	83 c4 18             	add    $0x18,%esp
}
  80204e:	c9                   	leave  
  80204f:	c3                   	ret    

00802050 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 00                	push   $0x0
  80205e:	50                   	push   %eax
  80205f:	6a 21                	push   $0x21
  802061:	e8 6e fc ff ff       	call   801cd4 <syscall>
  802066:	83 c4 18             	add    $0x18,%esp
}
  802069:	90                   	nop
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	50                   	push   %eax
  80207b:	6a 22                	push   $0x22
  80207d:	e8 52 fc ff ff       	call   801cd4 <syscall>
  802082:	83 c4 18             	add    $0x18,%esp
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80208a:	6a 00                	push   $0x0
  80208c:	6a 00                	push   $0x0
  80208e:	6a 00                	push   $0x0
  802090:	6a 00                	push   $0x0
  802092:	6a 00                	push   $0x0
  802094:	6a 02                	push   $0x2
  802096:	e8 39 fc ff ff       	call   801cd4 <syscall>
  80209b:	83 c4 18             	add    $0x18,%esp
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	6a 03                	push   $0x3
  8020af:	e8 20 fc ff ff       	call   801cd4 <syscall>
  8020b4:	83 c4 18             	add    $0x18,%esp
}
  8020b7:	c9                   	leave  
  8020b8:	c3                   	ret    

008020b9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020bc:	6a 00                	push   $0x0
  8020be:	6a 00                	push   $0x0
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 04                	push   $0x4
  8020c8:	e8 07 fc ff ff       	call   801cd4 <syscall>
  8020cd:	83 c4 18             	add    $0x18,%esp
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <sys_exit_env>:


void sys_exit_env(void)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020d5:	6a 00                	push   $0x0
  8020d7:	6a 00                	push   $0x0
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 23                	push   $0x23
  8020e1:	e8 ee fb ff ff       	call   801cd4 <syscall>
  8020e6:	83 c4 18             	add    $0x18,%esp
}
  8020e9:	90                   	nop
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8020f2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020f5:	8d 50 04             	lea    0x4(%eax),%edx
  8020f8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	52                   	push   %edx
  802102:	50                   	push   %eax
  802103:	6a 24                	push   $0x24
  802105:	e8 ca fb ff ff       	call   801cd4 <syscall>
  80210a:	83 c4 18             	add    $0x18,%esp
	return result;
  80210d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802110:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802113:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802116:	89 01                	mov    %eax,(%ecx)
  802118:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	c9                   	leave  
  80211f:	c2 04 00             	ret    $0x4

00802122 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	ff 75 10             	pushl  0x10(%ebp)
  80212c:	ff 75 0c             	pushl  0xc(%ebp)
  80212f:	ff 75 08             	pushl  0x8(%ebp)
  802132:	6a 12                	push   $0x12
  802134:	e8 9b fb ff ff       	call   801cd4 <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
	return ;
  80213c:	90                   	nop
}
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_rcr2>:
uint32 sys_rcr2()
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 00                	push   $0x0
  802148:	6a 00                	push   $0x0
  80214a:	6a 00                	push   $0x0
  80214c:	6a 25                	push   $0x25
  80214e:	e8 81 fb ff ff       	call   801cd4 <syscall>
  802153:	83 c4 18             	add    $0x18,%esp
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	83 ec 04             	sub    $0x4,%esp
  80215e:	8b 45 08             	mov    0x8(%ebp),%eax
  802161:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802164:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	50                   	push   %eax
  802171:	6a 26                	push   $0x26
  802173:	e8 5c fb ff ff       	call   801cd4 <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
	return ;
  80217b:	90                   	nop
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <rsttst>:
void rsttst()
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802181:	6a 00                	push   $0x0
  802183:	6a 00                	push   $0x0
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 28                	push   $0x28
  80218d:	e8 42 fb ff ff       	call   801cd4 <syscall>
  802192:	83 c4 18             	add    $0x18,%esp
	return ;
  802195:	90                   	nop
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	83 ec 04             	sub    $0x4,%esp
  80219e:	8b 45 14             	mov    0x14(%ebp),%eax
  8021a1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021a4:	8b 55 18             	mov    0x18(%ebp),%edx
  8021a7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021ab:	52                   	push   %edx
  8021ac:	50                   	push   %eax
  8021ad:	ff 75 10             	pushl  0x10(%ebp)
  8021b0:	ff 75 0c             	pushl  0xc(%ebp)
  8021b3:	ff 75 08             	pushl  0x8(%ebp)
  8021b6:	6a 27                	push   $0x27
  8021b8:	e8 17 fb ff ff       	call   801cd4 <syscall>
  8021bd:	83 c4 18             	add    $0x18,%esp
	return ;
  8021c0:	90                   	nop
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <chktst>:
void chktst(uint32 n)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021c6:	6a 00                	push   $0x0
  8021c8:	6a 00                	push   $0x0
  8021ca:	6a 00                	push   $0x0
  8021cc:	6a 00                	push   $0x0
  8021ce:	ff 75 08             	pushl  0x8(%ebp)
  8021d1:	6a 29                	push   $0x29
  8021d3:	e8 fc fa ff ff       	call   801cd4 <syscall>
  8021d8:	83 c4 18             	add    $0x18,%esp
	return ;
  8021db:	90                   	nop
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <inctst>:

void inctst()
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	6a 00                	push   $0x0
  8021e7:	6a 00                	push   $0x0
  8021e9:	6a 00                	push   $0x0
  8021eb:	6a 2a                	push   $0x2a
  8021ed:	e8 e2 fa ff ff       	call   801cd4 <syscall>
  8021f2:	83 c4 18             	add    $0x18,%esp
	return ;
  8021f5:	90                   	nop
}
  8021f6:	c9                   	leave  
  8021f7:	c3                   	ret    

008021f8 <gettst>:
uint32 gettst()
{
  8021f8:	55                   	push   %ebp
  8021f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 00                	push   $0x0
  8021ff:	6a 00                	push   $0x0
  802201:	6a 00                	push   $0x0
  802203:	6a 00                	push   $0x0
  802205:	6a 2b                	push   $0x2b
  802207:	e8 c8 fa ff ff       	call   801cd4 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
}
  80220f:	c9                   	leave  
  802210:	c3                   	ret    

00802211 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	6a 00                	push   $0x0
  80221f:	6a 00                	push   $0x0
  802221:	6a 2c                	push   $0x2c
  802223:	e8 ac fa ff ff       	call   801cd4 <syscall>
  802228:	83 c4 18             	add    $0x18,%esp
  80222b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80222e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802232:	75 07                	jne    80223b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802234:	b8 01 00 00 00       	mov    $0x1,%eax
  802239:	eb 05                	jmp    802240 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80223b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802248:	6a 00                	push   $0x0
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 2c                	push   $0x2c
  802254:	e8 7b fa ff ff       	call   801cd4 <syscall>
  802259:	83 c4 18             	add    $0x18,%esp
  80225c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80225f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802263:	75 07                	jne    80226c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802265:	b8 01 00 00 00       	mov    $0x1,%eax
  80226a:	eb 05                	jmp    802271 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80226c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802271:	c9                   	leave  
  802272:	c3                   	ret    

00802273 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 2c                	push   $0x2c
  802285:	e8 4a fa ff ff       	call   801cd4 <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
  80228d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802290:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802294:	75 07                	jne    80229d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802296:	b8 01 00 00 00       	mov    $0x1,%eax
  80229b:	eb 05                	jmp    8022a2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80229d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    

008022a4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022aa:	6a 00                	push   $0x0
  8022ac:	6a 00                	push   $0x0
  8022ae:	6a 00                	push   $0x0
  8022b0:	6a 00                	push   $0x0
  8022b2:	6a 00                	push   $0x0
  8022b4:	6a 2c                	push   $0x2c
  8022b6:	e8 19 fa ff ff       	call   801cd4 <syscall>
  8022bb:	83 c4 18             	add    $0x18,%esp
  8022be:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022c1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022c5:	75 07                	jne    8022ce <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8022cc:	eb 05                	jmp    8022d3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022d3:	c9                   	leave  
  8022d4:	c3                   	ret    

008022d5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022d5:	55                   	push   %ebp
  8022d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	ff 75 08             	pushl  0x8(%ebp)
  8022e3:	6a 2d                	push   $0x2d
  8022e5:	e8 ea f9 ff ff       	call   801cd4 <syscall>
  8022ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ed:	90                   	nop
}
  8022ee:	c9                   	leave  
  8022ef:	c3                   	ret    

008022f0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8022f4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8022f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8022fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	6a 00                	push   $0x0
  802302:	53                   	push   %ebx
  802303:	51                   	push   %ecx
  802304:	52                   	push   %edx
  802305:	50                   	push   %eax
  802306:	6a 2e                	push   $0x2e
  802308:	e8 c7 f9 ff ff       	call   801cd4 <syscall>
  80230d:	83 c4 18             	add    $0x18,%esp
}
  802310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802313:	c9                   	leave  
  802314:	c3                   	ret    

00802315 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802315:	55                   	push   %ebp
  802316:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802318:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	6a 00                	push   $0x0
  802320:	6a 00                	push   $0x0
  802322:	6a 00                	push   $0x0
  802324:	52                   	push   %edx
  802325:	50                   	push   %eax
  802326:	6a 2f                	push   $0x2f
  802328:	e8 a7 f9 ff ff       	call   801cd4 <syscall>
  80232d:	83 c4 18             	add    $0x18,%esp
}
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802338:	83 ec 0c             	sub    $0xc,%esp
  80233b:	68 a0 41 80 00       	push   $0x8041a0
  802340:	e8 3e e6 ff ff       	call   800983 <cprintf>
  802345:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802348:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80234f:	83 ec 0c             	sub    $0xc,%esp
  802352:	68 cc 41 80 00       	push   $0x8041cc
  802357:	e8 27 e6 ff ff       	call   800983 <cprintf>
  80235c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80235f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802363:	a1 38 51 80 00       	mov    0x805138,%eax
  802368:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236b:	eb 56                	jmp    8023c3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80236d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802371:	74 1c                	je     80238f <print_mem_block_lists+0x5d>
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 50 08             	mov    0x8(%eax),%edx
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	8b 48 08             	mov    0x8(%eax),%ecx
  80237f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802382:	8b 40 0c             	mov    0xc(%eax),%eax
  802385:	01 c8                	add    %ecx,%eax
  802387:	39 c2                	cmp    %eax,%edx
  802389:	73 04                	jae    80238f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80238b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	8b 50 08             	mov    0x8(%eax),%edx
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 40 0c             	mov    0xc(%eax),%eax
  80239b:	01 c2                	add    %eax,%edx
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 40 08             	mov    0x8(%eax),%eax
  8023a3:	83 ec 04             	sub    $0x4,%esp
  8023a6:	52                   	push   %edx
  8023a7:	50                   	push   %eax
  8023a8:	68 e1 41 80 00       	push   $0x8041e1
  8023ad:	e8 d1 e5 ff ff       	call   800983 <cprintf>
  8023b2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023bb:	a1 40 51 80 00       	mov    0x805140,%eax
  8023c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c7:	74 07                	je     8023d0 <print_mem_block_lists+0x9e>
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	eb 05                	jmp    8023d5 <print_mem_block_lists+0xa3>
  8023d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d5:	a3 40 51 80 00       	mov    %eax,0x805140
  8023da:	a1 40 51 80 00       	mov    0x805140,%eax
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	75 8a                	jne    80236d <print_mem_block_lists+0x3b>
  8023e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e7:	75 84                	jne    80236d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023e9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023ed:	75 10                	jne    8023ff <print_mem_block_lists+0xcd>
  8023ef:	83 ec 0c             	sub    $0xc,%esp
  8023f2:	68 f0 41 80 00       	push   $0x8041f0
  8023f7:	e8 87 e5 ff ff       	call   800983 <cprintf>
  8023fc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8023ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802406:	83 ec 0c             	sub    $0xc,%esp
  802409:	68 14 42 80 00       	push   $0x804214
  80240e:	e8 70 e5 ff ff       	call   800983 <cprintf>
  802413:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802416:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80241a:	a1 40 50 80 00       	mov    0x805040,%eax
  80241f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802422:	eb 56                	jmp    80247a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802424:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802428:	74 1c                	je     802446 <print_mem_block_lists+0x114>
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	8b 50 08             	mov    0x8(%eax),%edx
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	8b 48 08             	mov    0x8(%eax),%ecx
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	8b 40 0c             	mov    0xc(%eax),%eax
  80243c:	01 c8                	add    %ecx,%eax
  80243e:	39 c2                	cmp    %eax,%edx
  802440:	73 04                	jae    802446 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802442:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 50 08             	mov    0x8(%eax),%edx
  80244c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244f:	8b 40 0c             	mov    0xc(%eax),%eax
  802452:	01 c2                	add    %eax,%edx
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 08             	mov    0x8(%eax),%eax
  80245a:	83 ec 04             	sub    $0x4,%esp
  80245d:	52                   	push   %edx
  80245e:	50                   	push   %eax
  80245f:	68 e1 41 80 00       	push   $0x8041e1
  802464:	e8 1a e5 ff ff       	call   800983 <cprintf>
  802469:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802472:	a1 48 50 80 00       	mov    0x805048,%eax
  802477:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80247a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80247e:	74 07                	je     802487 <print_mem_block_lists+0x155>
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	8b 00                	mov    (%eax),%eax
  802485:	eb 05                	jmp    80248c <print_mem_block_lists+0x15a>
  802487:	b8 00 00 00 00       	mov    $0x0,%eax
  80248c:	a3 48 50 80 00       	mov    %eax,0x805048
  802491:	a1 48 50 80 00       	mov    0x805048,%eax
  802496:	85 c0                	test   %eax,%eax
  802498:	75 8a                	jne    802424 <print_mem_block_lists+0xf2>
  80249a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249e:	75 84                	jne    802424 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024a0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024a4:	75 10                	jne    8024b6 <print_mem_block_lists+0x184>
  8024a6:	83 ec 0c             	sub    $0xc,%esp
  8024a9:	68 2c 42 80 00       	push   $0x80422c
  8024ae:	e8 d0 e4 ff ff       	call   800983 <cprintf>
  8024b3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024b6:	83 ec 0c             	sub    $0xc,%esp
  8024b9:	68 a0 41 80 00       	push   $0x8041a0
  8024be:	e8 c0 e4 ff ff       	call   800983 <cprintf>
  8024c3:	83 c4 10             	add    $0x10,%esp

}
  8024c6:	90                   	nop
  8024c7:	c9                   	leave  
  8024c8:	c3                   	ret    

008024c9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024c9:	55                   	push   %ebp
  8024ca:	89 e5                	mov    %esp,%ebp
  8024cc:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8024cf:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024d6:	00 00 00 
  8024d9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024e0:	00 00 00 
  8024e3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024ea:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8024ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8024f4:	e9 9e 00 00 00       	jmp    802597 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8024f9:	a1 50 50 80 00       	mov    0x805050,%eax
  8024fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802501:	c1 e2 04             	shl    $0x4,%edx
  802504:	01 d0                	add    %edx,%eax
  802506:	85 c0                	test   %eax,%eax
  802508:	75 14                	jne    80251e <initialize_MemBlocksList+0x55>
  80250a:	83 ec 04             	sub    $0x4,%esp
  80250d:	68 54 42 80 00       	push   $0x804254
  802512:	6a 3d                	push   $0x3d
  802514:	68 77 42 80 00       	push   $0x804277
  802519:	e8 b1 e1 ff ff       	call   8006cf <_panic>
  80251e:	a1 50 50 80 00       	mov    0x805050,%eax
  802523:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802526:	c1 e2 04             	shl    $0x4,%edx
  802529:	01 d0                	add    %edx,%eax
  80252b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802531:	89 10                	mov    %edx,(%eax)
  802533:	8b 00                	mov    (%eax),%eax
  802535:	85 c0                	test   %eax,%eax
  802537:	74 18                	je     802551 <initialize_MemBlocksList+0x88>
  802539:	a1 48 51 80 00       	mov    0x805148,%eax
  80253e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802544:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802547:	c1 e1 04             	shl    $0x4,%ecx
  80254a:	01 ca                	add    %ecx,%edx
  80254c:	89 50 04             	mov    %edx,0x4(%eax)
  80254f:	eb 12                	jmp    802563 <initialize_MemBlocksList+0x9a>
  802551:	a1 50 50 80 00       	mov    0x805050,%eax
  802556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802559:	c1 e2 04             	shl    $0x4,%edx
  80255c:	01 d0                	add    %edx,%eax
  80255e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802563:	a1 50 50 80 00       	mov    0x805050,%eax
  802568:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256b:	c1 e2 04             	shl    $0x4,%edx
  80256e:	01 d0                	add    %edx,%eax
  802570:	a3 48 51 80 00       	mov    %eax,0x805148
  802575:	a1 50 50 80 00       	mov    0x805050,%eax
  80257a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257d:	c1 e2 04             	shl    $0x4,%edx
  802580:	01 d0                	add    %edx,%eax
  802582:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802589:	a1 54 51 80 00       	mov    0x805154,%eax
  80258e:	40                   	inc    %eax
  80258f:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802594:	ff 45 f4             	incl   -0xc(%ebp)
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259d:	0f 82 56 ff ff ff    	jb     8024f9 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8025a3:	90                   	nop
  8025a4:	c9                   	leave  
  8025a5:	c3                   	ret    

008025a6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025a6:	55                   	push   %ebp
  8025a7:	89 e5                	mov    %esp,%ebp
  8025a9:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8025ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8025af:	8b 00                	mov    (%eax),%eax
  8025b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8025b4:	eb 18                	jmp    8025ce <find_block+0x28>

		if(tmp->sva == va){
  8025b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025b9:	8b 40 08             	mov    0x8(%eax),%eax
  8025bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025bf:	75 05                	jne    8025c6 <find_block+0x20>
			return tmp ;
  8025c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c4:	eb 11                	jmp    8025d7 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8025c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8025ce:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025d2:	75 e2                	jne    8025b6 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8025d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8025d7:	c9                   	leave  
  8025d8:	c3                   	ret    

008025d9 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025d9:	55                   	push   %ebp
  8025da:	89 e5                	mov    %esp,%ebp
  8025dc:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8025df:	a1 40 50 80 00       	mov    0x805040,%eax
  8025e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8025e7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8025ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025f3:	75 65                	jne    80265a <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8025f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025f9:	75 14                	jne    80260f <insert_sorted_allocList+0x36>
  8025fb:	83 ec 04             	sub    $0x4,%esp
  8025fe:	68 54 42 80 00       	push   $0x804254
  802603:	6a 62                	push   $0x62
  802605:	68 77 42 80 00       	push   $0x804277
  80260a:	e8 c0 e0 ff ff       	call   8006cf <_panic>
  80260f:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802615:	8b 45 08             	mov    0x8(%ebp),%eax
  802618:	89 10                	mov    %edx,(%eax)
  80261a:	8b 45 08             	mov    0x8(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	85 c0                	test   %eax,%eax
  802621:	74 0d                	je     802630 <insert_sorted_allocList+0x57>
  802623:	a1 40 50 80 00       	mov    0x805040,%eax
  802628:	8b 55 08             	mov    0x8(%ebp),%edx
  80262b:	89 50 04             	mov    %edx,0x4(%eax)
  80262e:	eb 08                	jmp    802638 <insert_sorted_allocList+0x5f>
  802630:	8b 45 08             	mov    0x8(%ebp),%eax
  802633:	a3 44 50 80 00       	mov    %eax,0x805044
  802638:	8b 45 08             	mov    0x8(%ebp),%eax
  80263b:	a3 40 50 80 00       	mov    %eax,0x805040
  802640:	8b 45 08             	mov    0x8(%ebp),%eax
  802643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80264a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80264f:	40                   	inc    %eax
  802650:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802655:	e9 14 01 00 00       	jmp    80276e <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80265a:	8b 45 08             	mov    0x8(%ebp),%eax
  80265d:	8b 50 08             	mov    0x8(%eax),%edx
  802660:	a1 44 50 80 00       	mov    0x805044,%eax
  802665:	8b 40 08             	mov    0x8(%eax),%eax
  802668:	39 c2                	cmp    %eax,%edx
  80266a:	76 65                	jbe    8026d1 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80266c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802670:	75 14                	jne    802686 <insert_sorted_allocList+0xad>
  802672:	83 ec 04             	sub    $0x4,%esp
  802675:	68 90 42 80 00       	push   $0x804290
  80267a:	6a 64                	push   $0x64
  80267c:	68 77 42 80 00       	push   $0x804277
  802681:	e8 49 e0 ff ff       	call   8006cf <_panic>
  802686:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	89 50 04             	mov    %edx,0x4(%eax)
  802692:	8b 45 08             	mov    0x8(%ebp),%eax
  802695:	8b 40 04             	mov    0x4(%eax),%eax
  802698:	85 c0                	test   %eax,%eax
  80269a:	74 0c                	je     8026a8 <insert_sorted_allocList+0xcf>
  80269c:	a1 44 50 80 00       	mov    0x805044,%eax
  8026a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a4:	89 10                	mov    %edx,(%eax)
  8026a6:	eb 08                	jmp    8026b0 <insert_sorted_allocList+0xd7>
  8026a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ab:	a3 40 50 80 00       	mov    %eax,0x805040
  8026b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b3:	a3 44 50 80 00       	mov    %eax,0x805044
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026c6:	40                   	inc    %eax
  8026c7:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8026cc:	e9 9d 00 00 00       	jmp    80276e <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8026d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8026d8:	e9 85 00 00 00       	jmp    802762 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8026dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e0:	8b 50 08             	mov    0x8(%eax),%edx
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 40 08             	mov    0x8(%eax),%eax
  8026e9:	39 c2                	cmp    %eax,%edx
  8026eb:	73 6a                	jae    802757 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8026ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f1:	74 06                	je     8026f9 <insert_sorted_allocList+0x120>
  8026f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026f7:	75 14                	jne    80270d <insert_sorted_allocList+0x134>
  8026f9:	83 ec 04             	sub    $0x4,%esp
  8026fc:	68 b4 42 80 00       	push   $0x8042b4
  802701:	6a 6b                	push   $0x6b
  802703:	68 77 42 80 00       	push   $0x804277
  802708:	e8 c2 df ff ff       	call   8006cf <_panic>
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 50 04             	mov    0x4(%eax),%edx
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	89 50 04             	mov    %edx,0x4(%eax)
  802719:	8b 45 08             	mov    0x8(%ebp),%eax
  80271c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271f:	89 10                	mov    %edx,(%eax)
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 40 04             	mov    0x4(%eax),%eax
  802727:	85 c0                	test   %eax,%eax
  802729:	74 0d                	je     802738 <insert_sorted_allocList+0x15f>
  80272b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272e:	8b 40 04             	mov    0x4(%eax),%eax
  802731:	8b 55 08             	mov    0x8(%ebp),%edx
  802734:	89 10                	mov    %edx,(%eax)
  802736:	eb 08                	jmp    802740 <insert_sorted_allocList+0x167>
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	a3 40 50 80 00       	mov    %eax,0x805040
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 55 08             	mov    0x8(%ebp),%edx
  802746:	89 50 04             	mov    %edx,0x4(%eax)
  802749:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80274e:	40                   	inc    %eax
  80274f:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802754:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802755:	eb 17                	jmp    80276e <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	8b 00                	mov    (%eax),%eax
  80275c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80275f:	ff 45 f0             	incl   -0x10(%ebp)
  802762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802765:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802768:	0f 8c 6f ff ff ff    	jl     8026dd <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80276e:	90                   	nop
  80276f:	c9                   	leave  
  802770:	c3                   	ret    

00802771 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
  802774:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802777:	a1 38 51 80 00       	mov    0x805138,%eax
  80277c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80277f:	e9 7c 01 00 00       	jmp    802900 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802784:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802787:	8b 40 0c             	mov    0xc(%eax),%eax
  80278a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278d:	0f 86 cf 00 00 00    	jbe    802862 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802793:	a1 48 51 80 00       	mov    0x805148,%eax
  802798:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80279b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279e:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8027a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8027a7:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8027aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ad:	8b 50 08             	mov    0x8(%eax),%edx
  8027b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b3:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8027bf:	89 c2                	mov    %eax,%edx
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	8b 50 08             	mov    0x8(%eax),%edx
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	01 c2                	add    %eax,%edx
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8027d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027dc:	75 17                	jne    8027f5 <alloc_block_FF+0x84>
  8027de:	83 ec 04             	sub    $0x4,%esp
  8027e1:	68 e9 42 80 00       	push   $0x8042e9
  8027e6:	68 83 00 00 00       	push   $0x83
  8027eb:	68 77 42 80 00       	push   $0x804277
  8027f0:	e8 da de ff ff       	call   8006cf <_panic>
  8027f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	85 c0                	test   %eax,%eax
  8027fc:	74 10                	je     80280e <alloc_block_FF+0x9d>
  8027fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802801:	8b 00                	mov    (%eax),%eax
  802803:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802806:	8b 52 04             	mov    0x4(%edx),%edx
  802809:	89 50 04             	mov    %edx,0x4(%eax)
  80280c:	eb 0b                	jmp    802819 <alloc_block_FF+0xa8>
  80280e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802811:	8b 40 04             	mov    0x4(%eax),%eax
  802814:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281c:	8b 40 04             	mov    0x4(%eax),%eax
  80281f:	85 c0                	test   %eax,%eax
  802821:	74 0f                	je     802832 <alloc_block_FF+0xc1>
  802823:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802826:	8b 40 04             	mov    0x4(%eax),%eax
  802829:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80282c:	8b 12                	mov    (%edx),%edx
  80282e:	89 10                	mov    %edx,(%eax)
  802830:	eb 0a                	jmp    80283c <alloc_block_FF+0xcb>
  802832:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802835:	8b 00                	mov    (%eax),%eax
  802837:	a3 48 51 80 00       	mov    %eax,0x805148
  80283c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802848:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80284f:	a1 54 51 80 00       	mov    0x805154,%eax
  802854:	48                   	dec    %eax
  802855:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  80285a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285d:	e9 ad 00 00 00       	jmp    80290f <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	8b 40 0c             	mov    0xc(%eax),%eax
  802868:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286b:	0f 85 87 00 00 00    	jne    8028f8 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802871:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802875:	75 17                	jne    80288e <alloc_block_FF+0x11d>
  802877:	83 ec 04             	sub    $0x4,%esp
  80287a:	68 e9 42 80 00       	push   $0x8042e9
  80287f:	68 87 00 00 00       	push   $0x87
  802884:	68 77 42 80 00       	push   $0x804277
  802889:	e8 41 de ff ff       	call   8006cf <_panic>
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	8b 00                	mov    (%eax),%eax
  802893:	85 c0                	test   %eax,%eax
  802895:	74 10                	je     8028a7 <alloc_block_FF+0x136>
  802897:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289a:	8b 00                	mov    (%eax),%eax
  80289c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80289f:	8b 52 04             	mov    0x4(%edx),%edx
  8028a2:	89 50 04             	mov    %edx,0x4(%eax)
  8028a5:	eb 0b                	jmp    8028b2 <alloc_block_FF+0x141>
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 40 04             	mov    0x4(%eax),%eax
  8028b8:	85 c0                	test   %eax,%eax
  8028ba:	74 0f                	je     8028cb <alloc_block_FF+0x15a>
  8028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bf:	8b 40 04             	mov    0x4(%eax),%eax
  8028c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c5:	8b 12                	mov    (%edx),%edx
  8028c7:	89 10                	mov    %edx,(%eax)
  8028c9:	eb 0a                	jmp    8028d5 <alloc_block_FF+0x164>
  8028cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ce:	8b 00                	mov    (%eax),%eax
  8028d0:	a3 38 51 80 00       	mov    %eax,0x805138
  8028d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e8:	a1 44 51 80 00       	mov    0x805144,%eax
  8028ed:	48                   	dec    %eax
  8028ee:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  8028f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f6:	eb 17                	jmp    80290f <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8028f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802900:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802904:	0f 85 7a fe ff ff    	jne    802784 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  80290a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80290f:	c9                   	leave  
  802910:	c3                   	ret    

00802911 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802911:	55                   	push   %ebp
  802912:	89 e5                	mov    %esp,%ebp
  802914:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802917:	a1 38 51 80 00       	mov    0x805138,%eax
  80291c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  80291f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802926:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80292d:	a1 38 51 80 00       	mov    0x805138,%eax
  802932:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802935:	e9 d0 00 00 00       	jmp    802a0a <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80293a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293d:	8b 40 0c             	mov    0xc(%eax),%eax
  802940:	3b 45 08             	cmp    0x8(%ebp),%eax
  802943:	0f 82 b8 00 00 00    	jb     802a01 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802949:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294c:	8b 40 0c             	mov    0xc(%eax),%eax
  80294f:	2b 45 08             	sub    0x8(%ebp),%eax
  802952:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802955:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802958:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80295b:	0f 83 a1 00 00 00    	jae    802a02 <alloc_block_BF+0xf1>
				differsize = differance ;
  802961:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802964:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802967:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80296d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802971:	0f 85 8b 00 00 00    	jne    802a02 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802977:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80297b:	75 17                	jne    802994 <alloc_block_BF+0x83>
  80297d:	83 ec 04             	sub    $0x4,%esp
  802980:	68 e9 42 80 00       	push   $0x8042e9
  802985:	68 a0 00 00 00       	push   $0xa0
  80298a:	68 77 42 80 00       	push   $0x804277
  80298f:	e8 3b dd ff ff       	call   8006cf <_panic>
  802994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	85 c0                	test   %eax,%eax
  80299b:	74 10                	je     8029ad <alloc_block_BF+0x9c>
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 00                	mov    (%eax),%eax
  8029a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029a5:	8b 52 04             	mov    0x4(%edx),%edx
  8029a8:	89 50 04             	mov    %edx,0x4(%eax)
  8029ab:	eb 0b                	jmp    8029b8 <alloc_block_BF+0xa7>
  8029ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b0:	8b 40 04             	mov    0x4(%eax),%eax
  8029b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	8b 40 04             	mov    0x4(%eax),%eax
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	74 0f                	je     8029d1 <alloc_block_BF+0xc0>
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	8b 40 04             	mov    0x4(%eax),%eax
  8029c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029cb:	8b 12                	mov    (%edx),%edx
  8029cd:	89 10                	mov    %edx,(%eax)
  8029cf:	eb 0a                	jmp    8029db <alloc_block_BF+0xca>
  8029d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d4:	8b 00                	mov    (%eax),%eax
  8029d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8029f3:	48                   	dec    %eax
  8029f4:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	e9 0c 01 00 00       	jmp    802b0d <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802a01:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802a02:	a1 40 51 80 00       	mov    0x805140,%eax
  802a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a0e:	74 07                	je     802a17 <alloc_block_BF+0x106>
  802a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a13:	8b 00                	mov    (%eax),%eax
  802a15:	eb 05                	jmp    802a1c <alloc_block_BF+0x10b>
  802a17:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1c:	a3 40 51 80 00       	mov    %eax,0x805140
  802a21:	a1 40 51 80 00       	mov    0x805140,%eax
  802a26:	85 c0                	test   %eax,%eax
  802a28:	0f 85 0c ff ff ff    	jne    80293a <alloc_block_BF+0x29>
  802a2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a32:	0f 85 02 ff ff ff    	jne    80293a <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802a38:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a3c:	0f 84 c6 00 00 00    	je     802b08 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802a42:	a1 48 51 80 00       	mov    0x805148,%eax
  802a47:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802a4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a50:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802a53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a56:	8b 50 08             	mov    0x8(%eax),%edx
  802a59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5c:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a62:	8b 40 0c             	mov    0xc(%eax),%eax
  802a65:	2b 45 08             	sub    0x8(%ebp),%eax
  802a68:	89 c2                	mov    %eax,%edx
  802a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6d:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	8b 50 08             	mov    0x8(%eax),%edx
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	01 c2                	add    %eax,%edx
  802a7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7e:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802a81:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a85:	75 17                	jne    802a9e <alloc_block_BF+0x18d>
  802a87:	83 ec 04             	sub    $0x4,%esp
  802a8a:	68 e9 42 80 00       	push   $0x8042e9
  802a8f:	68 af 00 00 00       	push   $0xaf
  802a94:	68 77 42 80 00       	push   $0x804277
  802a99:	e8 31 dc ff ff       	call   8006cf <_panic>
  802a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa1:	8b 00                	mov    (%eax),%eax
  802aa3:	85 c0                	test   %eax,%eax
  802aa5:	74 10                	je     802ab7 <alloc_block_BF+0x1a6>
  802aa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802aaf:	8b 52 04             	mov    0x4(%edx),%edx
  802ab2:	89 50 04             	mov    %edx,0x4(%eax)
  802ab5:	eb 0b                	jmp    802ac2 <alloc_block_BF+0x1b1>
  802ab7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aba:	8b 40 04             	mov    0x4(%eax),%eax
  802abd:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ac2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac5:	8b 40 04             	mov    0x4(%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 0f                	je     802adb <alloc_block_BF+0x1ca>
  802acc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acf:	8b 40 04             	mov    0x4(%eax),%eax
  802ad2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ad5:	8b 12                	mov    (%edx),%edx
  802ad7:	89 10                	mov    %edx,(%eax)
  802ad9:	eb 0a                	jmp    802ae5 <alloc_block_BF+0x1d4>
  802adb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	a3 48 51 80 00       	mov    %eax,0x805148
  802ae5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af8:	a1 54 51 80 00       	mov    0x805154,%eax
  802afd:	48                   	dec    %eax
  802afe:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802b03:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b06:	eb 05                	jmp    802b0d <alloc_block_BF+0x1fc>
	}

	return NULL;
  802b08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b0d:	c9                   	leave  
  802b0e:	c3                   	ret    

00802b0f <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802b0f:	55                   	push   %ebp
  802b10:	89 e5                	mov    %esp,%ebp
  802b12:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802b15:	a1 38 51 80 00       	mov    0x805138,%eax
  802b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802b1d:	e9 7c 01 00 00       	jmp    802c9e <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	8b 40 0c             	mov    0xc(%eax),%eax
  802b28:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b2b:	0f 86 cf 00 00 00    	jbe    802c00 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802b31:	a1 48 51 80 00       	mov    0x805148,%eax
  802b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b42:	8b 55 08             	mov    0x8(%ebp),%edx
  802b45:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4b:	8b 50 08             	mov    0x8(%eax),%edx
  802b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b51:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5a:	2b 45 08             	sub    0x8(%ebp),%eax
  802b5d:	89 c2                	mov    %eax,%edx
  802b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b62:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b68:	8b 50 08             	mov    0x8(%eax),%edx
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	01 c2                	add    %eax,%edx
  802b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b73:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802b76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b7a:	75 17                	jne    802b93 <alloc_block_NF+0x84>
  802b7c:	83 ec 04             	sub    $0x4,%esp
  802b7f:	68 e9 42 80 00       	push   $0x8042e9
  802b84:	68 c4 00 00 00       	push   $0xc4
  802b89:	68 77 42 80 00       	push   $0x804277
  802b8e:	e8 3c db ff ff       	call   8006cf <_panic>
  802b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b96:	8b 00                	mov    (%eax),%eax
  802b98:	85 c0                	test   %eax,%eax
  802b9a:	74 10                	je     802bac <alloc_block_NF+0x9d>
  802b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9f:	8b 00                	mov    (%eax),%eax
  802ba1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802ba4:	8b 52 04             	mov    0x4(%edx),%edx
  802ba7:	89 50 04             	mov    %edx,0x4(%eax)
  802baa:	eb 0b                	jmp    802bb7 <alloc_block_NF+0xa8>
  802bac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baf:	8b 40 04             	mov    0x4(%eax),%eax
  802bb2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bba:	8b 40 04             	mov    0x4(%eax),%eax
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	74 0f                	je     802bd0 <alloc_block_NF+0xc1>
  802bc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc4:	8b 40 04             	mov    0x4(%eax),%eax
  802bc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bca:	8b 12                	mov    (%edx),%edx
  802bcc:	89 10                	mov    %edx,(%eax)
  802bce:	eb 0a                	jmp    802bda <alloc_block_NF+0xcb>
  802bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd3:	8b 00                	mov    (%eax),%eax
  802bd5:	a3 48 51 80 00       	mov    %eax,0x805148
  802bda:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802be3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bed:	a1 54 51 80 00       	mov    0x805154,%eax
  802bf2:	48                   	dec    %eax
  802bf3:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802bf8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfb:	e9 ad 00 00 00       	jmp    802cad <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c03:	8b 40 0c             	mov    0xc(%eax),%eax
  802c06:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c09:	0f 85 87 00 00 00    	jne    802c96 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802c0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c13:	75 17                	jne    802c2c <alloc_block_NF+0x11d>
  802c15:	83 ec 04             	sub    $0x4,%esp
  802c18:	68 e9 42 80 00       	push   $0x8042e9
  802c1d:	68 c8 00 00 00       	push   $0xc8
  802c22:	68 77 42 80 00       	push   $0x804277
  802c27:	e8 a3 da ff ff       	call   8006cf <_panic>
  802c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2f:	8b 00                	mov    (%eax),%eax
  802c31:	85 c0                	test   %eax,%eax
  802c33:	74 10                	je     802c45 <alloc_block_NF+0x136>
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c3d:	8b 52 04             	mov    0x4(%edx),%edx
  802c40:	89 50 04             	mov    %edx,0x4(%eax)
  802c43:	eb 0b                	jmp    802c50 <alloc_block_NF+0x141>
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 40 04             	mov    0x4(%eax),%eax
  802c4b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	85 c0                	test   %eax,%eax
  802c58:	74 0f                	je     802c69 <alloc_block_NF+0x15a>
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 40 04             	mov    0x4(%eax),%eax
  802c60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c63:	8b 12                	mov    (%edx),%edx
  802c65:	89 10                	mov    %edx,(%eax)
  802c67:	eb 0a                	jmp    802c73 <alloc_block_NF+0x164>
  802c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	a3 38 51 80 00       	mov    %eax,0x805138
  802c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c86:	a1 44 51 80 00       	mov    0x805144,%eax
  802c8b:	48                   	dec    %eax
  802c8c:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	eb 17                	jmp    802cad <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c99:	8b 00                	mov    (%eax),%eax
  802c9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca2:	0f 85 7a fe ff ff    	jne    802b22 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802ca8:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802cad:	c9                   	leave  
  802cae:	c3                   	ret    

00802caf <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802caf:	55                   	push   %ebp
  802cb0:	89 e5                	mov    %esp,%ebp
  802cb2:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802cb5:	a1 38 51 80 00       	mov    0x805138,%eax
  802cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802cbd:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802cc5:	a1 44 51 80 00       	mov    0x805144,%eax
  802cca:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802ccd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cd1:	75 68                	jne    802d3b <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802cd3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd7:	75 17                	jne    802cf0 <insert_sorted_with_merge_freeList+0x41>
  802cd9:	83 ec 04             	sub    $0x4,%esp
  802cdc:	68 54 42 80 00       	push   $0x804254
  802ce1:	68 da 00 00 00       	push   $0xda
  802ce6:	68 77 42 80 00       	push   $0x804277
  802ceb:	e8 df d9 ff ff       	call   8006cf <_panic>
  802cf0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf9:	89 10                	mov    %edx,(%eax)
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 0d                	je     802d11 <insert_sorted_with_merge_freeList+0x62>
  802d04:	a1 38 51 80 00       	mov    0x805138,%eax
  802d09:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0c:	89 50 04             	mov    %edx,0x4(%eax)
  802d0f:	eb 08                	jmp    802d19 <insert_sorted_with_merge_freeList+0x6a>
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	a3 38 51 80 00       	mov    %eax,0x805138
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d30:	40                   	inc    %eax
  802d31:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802d36:	e9 49 07 00 00       	jmp    803484 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d3e:	8b 50 08             	mov    0x8(%eax),%edx
  802d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d44:	8b 40 0c             	mov    0xc(%eax),%eax
  802d47:	01 c2                	add    %eax,%edx
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 40 08             	mov    0x8(%eax),%eax
  802d4f:	39 c2                	cmp    %eax,%edx
  802d51:	73 77                	jae    802dca <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	75 6e                	jne    802dca <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802d5c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d60:	74 68                	je     802dca <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802d62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d66:	75 17                	jne    802d7f <insert_sorted_with_merge_freeList+0xd0>
  802d68:	83 ec 04             	sub    $0x4,%esp
  802d6b:	68 90 42 80 00       	push   $0x804290
  802d70:	68 e0 00 00 00       	push   $0xe0
  802d75:	68 77 42 80 00       	push   $0x804277
  802d7a:	e8 50 d9 ff ff       	call   8006cf <_panic>
  802d7f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	89 50 04             	mov    %edx,0x4(%eax)
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 0c                	je     802da1 <insert_sorted_with_merge_freeList+0xf2>
  802d95:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9d:	89 10                	mov    %edx,(%eax)
  802d9f:	eb 08                	jmp    802da9 <insert_sorted_with_merge_freeList+0xfa>
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	a3 38 51 80 00       	mov    %eax,0x805138
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dba:	a1 44 51 80 00       	mov    0x805144,%eax
  802dbf:	40                   	inc    %eax
  802dc0:	a3 44 51 80 00       	mov    %eax,0x805144
  802dc5:	e9 ba 06 00 00       	jmp    803484 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802dca:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcd:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	8b 40 08             	mov    0x8(%eax),%eax
  802dd6:	01 c2                	add    %eax,%edx
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	8b 40 08             	mov    0x8(%eax),%eax
  802dde:	39 c2                	cmp    %eax,%edx
  802de0:	73 78                	jae    802e5a <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 40 04             	mov    0x4(%eax),%eax
  802de8:	85 c0                	test   %eax,%eax
  802dea:	75 6e                	jne    802e5a <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802dec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802df0:	74 68                	je     802e5a <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802df2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df6:	75 17                	jne    802e0f <insert_sorted_with_merge_freeList+0x160>
  802df8:	83 ec 04             	sub    $0x4,%esp
  802dfb:	68 54 42 80 00       	push   $0x804254
  802e00:	68 e6 00 00 00       	push   $0xe6
  802e05:	68 77 42 80 00       	push   $0x804277
  802e0a:	e8 c0 d8 ff ff       	call   8006cf <_panic>
  802e0f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	89 10                	mov    %edx,(%eax)
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 0d                	je     802e30 <insert_sorted_with_merge_freeList+0x181>
  802e23:	a1 38 51 80 00       	mov    0x805138,%eax
  802e28:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	eb 08                	jmp    802e38 <insert_sorted_with_merge_freeList+0x189>
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	a3 38 51 80 00       	mov    %eax,0x805138
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4a:	a1 44 51 80 00       	mov    0x805144,%eax
  802e4f:	40                   	inc    %eax
  802e50:	a3 44 51 80 00       	mov    %eax,0x805144
  802e55:	e9 2a 06 00 00       	jmp    803484 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802e5a:	a1 38 51 80 00       	mov    0x805138,%eax
  802e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e62:	e9 ed 05 00 00       	jmp    803454 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	8b 00                	mov    (%eax),%eax
  802e6c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802e6f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e73:	0f 84 a7 00 00 00    	je     802f20 <insert_sorted_with_merge_freeList+0x271>
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 40 08             	mov    0x8(%eax),%eax
  802e85:	01 c2                	add    %eax,%edx
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 40 08             	mov    0x8(%eax),%eax
  802e8d:	39 c2                	cmp    %eax,%edx
  802e8f:	0f 83 8b 00 00 00    	jae    802f20 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	8b 50 0c             	mov    0xc(%eax),%edx
  802e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9e:	8b 40 08             	mov    0x8(%eax),%eax
  802ea1:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802ea3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea6:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802ea9:	39 c2                	cmp    %eax,%edx
  802eab:	73 73                	jae    802f20 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802ead:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb1:	74 06                	je     802eb9 <insert_sorted_with_merge_freeList+0x20a>
  802eb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb7:	75 17                	jne    802ed0 <insert_sorted_with_merge_freeList+0x221>
  802eb9:	83 ec 04             	sub    $0x4,%esp
  802ebc:	68 08 43 80 00       	push   $0x804308
  802ec1:	68 f0 00 00 00       	push   $0xf0
  802ec6:	68 77 42 80 00       	push   $0x804277
  802ecb:	e8 ff d7 ff ff       	call   8006cf <_panic>
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	8b 10                	mov    (%eax),%edx
  802ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed8:	89 10                	mov    %edx,(%eax)
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 00                	mov    (%eax),%eax
  802edf:	85 c0                	test   %eax,%eax
  802ee1:	74 0b                	je     802eee <insert_sorted_with_merge_freeList+0x23f>
  802ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee6:	8b 00                	mov    (%eax),%eax
  802ee8:	8b 55 08             	mov    0x8(%ebp),%edx
  802eeb:	89 50 04             	mov    %edx,0x4(%eax)
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef4:	89 10                	mov    %edx,(%eax)
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802efc:	89 50 04             	mov    %edx,0x4(%eax)
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	8b 00                	mov    (%eax),%eax
  802f04:	85 c0                	test   %eax,%eax
  802f06:	75 08                	jne    802f10 <insert_sorted_with_merge_freeList+0x261>
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f10:	a1 44 51 80 00       	mov    0x805144,%eax
  802f15:	40                   	inc    %eax
  802f16:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  802f1b:	e9 64 05 00 00       	jmp    803484 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802f20:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f25:	8b 50 0c             	mov    0xc(%eax),%edx
  802f28:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f2d:	8b 40 08             	mov    0x8(%eax),%eax
  802f30:	01 c2                	add    %eax,%edx
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	8b 40 08             	mov    0x8(%eax),%eax
  802f38:	39 c2                	cmp    %eax,%edx
  802f3a:	0f 85 b1 00 00 00    	jne    802ff1 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802f40:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f45:	85 c0                	test   %eax,%eax
  802f47:	0f 84 a4 00 00 00    	je     802ff1 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802f4d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f52:	8b 00                	mov    (%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	0f 85 95 00 00 00    	jne    802ff1 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802f5c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f61:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f67:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6d:	8b 52 0c             	mov    0xc(%edx),%edx
  802f70:	01 ca                	add    %ecx,%edx
  802f72:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8d:	75 17                	jne    802fa6 <insert_sorted_with_merge_freeList+0x2f7>
  802f8f:	83 ec 04             	sub    $0x4,%esp
  802f92:	68 54 42 80 00       	push   $0x804254
  802f97:	68 ff 00 00 00       	push   $0xff
  802f9c:	68 77 42 80 00       	push   $0x804277
  802fa1:	e8 29 d7 ff ff       	call   8006cf <_panic>
  802fa6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	89 10                	mov    %edx,(%eax)
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	8b 00                	mov    (%eax),%eax
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	74 0d                	je     802fc7 <insert_sorted_with_merge_freeList+0x318>
  802fba:	a1 48 51 80 00       	mov    0x805148,%eax
  802fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc2:	89 50 04             	mov    %edx,0x4(%eax)
  802fc5:	eb 08                	jmp    802fcf <insert_sorted_with_merge_freeList+0x320>
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	a3 48 51 80 00       	mov    %eax,0x805148
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe1:	a1 54 51 80 00       	mov    0x805154,%eax
  802fe6:	40                   	inc    %eax
  802fe7:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  802fec:	e9 93 04 00 00       	jmp    803484 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	8b 50 08             	mov    0x8(%eax),%edx
  802ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffa:	8b 40 0c             	mov    0xc(%eax),%eax
  802ffd:	01 c2                	add    %eax,%edx
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	8b 40 08             	mov    0x8(%eax),%eax
  803005:	39 c2                	cmp    %eax,%edx
  803007:	0f 85 ae 00 00 00    	jne    8030bb <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	8b 50 0c             	mov    0xc(%eax),%edx
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	8b 40 08             	mov    0x8(%eax),%eax
  803019:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803023:	39 c2                	cmp    %eax,%edx
  803025:	0f 84 90 00 00 00    	je     8030bb <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 50 0c             	mov    0xc(%eax),%edx
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	8b 40 0c             	mov    0xc(%eax),%eax
  803037:	01 c2                	add    %eax,%edx
  803039:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80303f:	8b 45 08             	mov    0x8(%ebp),%eax
  803042:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803049:	8b 45 08             	mov    0x8(%ebp),%eax
  80304c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803053:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803057:	75 17                	jne    803070 <insert_sorted_with_merge_freeList+0x3c1>
  803059:	83 ec 04             	sub    $0x4,%esp
  80305c:	68 54 42 80 00       	push   $0x804254
  803061:	68 0b 01 00 00       	push   $0x10b
  803066:	68 77 42 80 00       	push   $0x804277
  80306b:	e8 5f d6 ff ff       	call   8006cf <_panic>
  803070:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	89 10                	mov    %edx,(%eax)
  80307b:	8b 45 08             	mov    0x8(%ebp),%eax
  80307e:	8b 00                	mov    (%eax),%eax
  803080:	85 c0                	test   %eax,%eax
  803082:	74 0d                	je     803091 <insert_sorted_with_merge_freeList+0x3e2>
  803084:	a1 48 51 80 00       	mov    0x805148,%eax
  803089:	8b 55 08             	mov    0x8(%ebp),%edx
  80308c:	89 50 04             	mov    %edx,0x4(%eax)
  80308f:	eb 08                	jmp    803099 <insert_sorted_with_merge_freeList+0x3ea>
  803091:	8b 45 08             	mov    0x8(%ebp),%eax
  803094:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803099:	8b 45 08             	mov    0x8(%ebp),%eax
  80309c:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b0:	40                   	inc    %eax
  8030b1:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8030b6:	e9 c9 03 00 00       	jmp    803484 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8030bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030be:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c4:	8b 40 08             	mov    0x8(%eax),%eax
  8030c7:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8030c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cc:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8030cf:	39 c2                	cmp    %eax,%edx
  8030d1:	0f 85 bb 00 00 00    	jne    803192 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8030d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030db:	0f 84 b1 00 00 00    	je     803192 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	8b 40 04             	mov    0x4(%eax),%eax
  8030e7:	85 c0                	test   %eax,%eax
  8030e9:	0f 85 a3 00 00 00    	jne    803192 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8030ef:	a1 38 51 80 00       	mov    0x805138,%eax
  8030f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030f7:	8b 52 08             	mov    0x8(%edx),%edx
  8030fa:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8030fd:	a1 38 51 80 00       	mov    0x805138,%eax
  803102:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803108:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80310b:	8b 55 08             	mov    0x8(%ebp),%edx
  80310e:	8b 52 0c             	mov    0xc(%edx),%edx
  803111:	01 ca                	add    %ecx,%edx
  803113:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803116:	8b 45 08             	mov    0x8(%ebp),%eax
  803119:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803120:	8b 45 08             	mov    0x8(%ebp),%eax
  803123:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80312a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80312e:	75 17                	jne    803147 <insert_sorted_with_merge_freeList+0x498>
  803130:	83 ec 04             	sub    $0x4,%esp
  803133:	68 54 42 80 00       	push   $0x804254
  803138:	68 17 01 00 00       	push   $0x117
  80313d:	68 77 42 80 00       	push   $0x804277
  803142:	e8 88 d5 ff ff       	call   8006cf <_panic>
  803147:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80314d:	8b 45 08             	mov    0x8(%ebp),%eax
  803150:	89 10                	mov    %edx,(%eax)
  803152:	8b 45 08             	mov    0x8(%ebp),%eax
  803155:	8b 00                	mov    (%eax),%eax
  803157:	85 c0                	test   %eax,%eax
  803159:	74 0d                	je     803168 <insert_sorted_with_merge_freeList+0x4b9>
  80315b:	a1 48 51 80 00       	mov    0x805148,%eax
  803160:	8b 55 08             	mov    0x8(%ebp),%edx
  803163:	89 50 04             	mov    %edx,0x4(%eax)
  803166:	eb 08                	jmp    803170 <insert_sorted_with_merge_freeList+0x4c1>
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803170:	8b 45 08             	mov    0x8(%ebp),%eax
  803173:	a3 48 51 80 00       	mov    %eax,0x805148
  803178:	8b 45 08             	mov    0x8(%ebp),%eax
  80317b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803182:	a1 54 51 80 00       	mov    0x805154,%eax
  803187:	40                   	inc    %eax
  803188:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80318d:	e9 f2 02 00 00       	jmp    803484 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803192:	8b 45 08             	mov    0x8(%ebp),%eax
  803195:	8b 50 08             	mov    0x8(%eax),%edx
  803198:	8b 45 08             	mov    0x8(%ebp),%eax
  80319b:	8b 40 0c             	mov    0xc(%eax),%eax
  80319e:	01 c2                	add    %eax,%edx
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	8b 40 08             	mov    0x8(%eax),%eax
  8031a6:	39 c2                	cmp    %eax,%edx
  8031a8:	0f 85 be 00 00 00    	jne    80326c <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	8b 40 04             	mov    0x4(%eax),%eax
  8031b4:	8b 50 08             	mov    0x8(%eax),%edx
  8031b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ba:	8b 40 04             	mov    0x4(%eax),%eax
  8031bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8031c0:	01 c2                	add    %eax,%edx
  8031c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c5:	8b 40 08             	mov    0x8(%eax),%eax
  8031c8:	39 c2                	cmp    %eax,%edx
  8031ca:	0f 84 9c 00 00 00    	je     80326c <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8031d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d3:	8b 50 08             	mov    0x8(%eax),%edx
  8031d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d9:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8031dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031df:	8b 50 0c             	mov    0xc(%eax),%edx
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8031e8:	01 c2                	add    %eax,%edx
  8031ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ed:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8031f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803204:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803208:	75 17                	jne    803221 <insert_sorted_with_merge_freeList+0x572>
  80320a:	83 ec 04             	sub    $0x4,%esp
  80320d:	68 54 42 80 00       	push   $0x804254
  803212:	68 26 01 00 00       	push   $0x126
  803217:	68 77 42 80 00       	push   $0x804277
  80321c:	e8 ae d4 ff ff       	call   8006cf <_panic>
  803221:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	89 10                	mov    %edx,(%eax)
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	74 0d                	je     803242 <insert_sorted_with_merge_freeList+0x593>
  803235:	a1 48 51 80 00       	mov    0x805148,%eax
  80323a:	8b 55 08             	mov    0x8(%ebp),%edx
  80323d:	89 50 04             	mov    %edx,0x4(%eax)
  803240:	eb 08                	jmp    80324a <insert_sorted_with_merge_freeList+0x59b>
  803242:	8b 45 08             	mov    0x8(%ebp),%eax
  803245:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80324a:	8b 45 08             	mov    0x8(%ebp),%eax
  80324d:	a3 48 51 80 00       	mov    %eax,0x805148
  803252:	8b 45 08             	mov    0x8(%ebp),%eax
  803255:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80325c:	a1 54 51 80 00       	mov    0x805154,%eax
  803261:	40                   	inc    %eax
  803262:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803267:	e9 18 02 00 00       	jmp    803484 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 50 0c             	mov    0xc(%eax),%edx
  803272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803275:	8b 40 08             	mov    0x8(%eax),%eax
  803278:	01 c2                	add    %eax,%edx
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	8b 40 08             	mov    0x8(%eax),%eax
  803280:	39 c2                	cmp    %eax,%edx
  803282:	0f 85 c4 01 00 00    	jne    80344c <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803288:	8b 45 08             	mov    0x8(%ebp),%eax
  80328b:	8b 50 0c             	mov    0xc(%eax),%edx
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	8b 40 08             	mov    0x8(%eax),%eax
  803294:	01 c2                	add    %eax,%edx
  803296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803299:	8b 00                	mov    (%eax),%eax
  80329b:	8b 40 08             	mov    0x8(%eax),%eax
  80329e:	39 c2                	cmp    %eax,%edx
  8032a0:	0f 85 a6 01 00 00    	jne    80344c <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8032a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032aa:	0f 84 9c 01 00 00    	je     80344c <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  8032b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b3:	8b 50 0c             	mov    0xc(%eax),%edx
  8032b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8032bc:	01 c2                	add    %eax,%edx
  8032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c1:	8b 00                	mov    (%eax),%eax
  8032c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8032c6:	01 c2                	add    %eax,%edx
  8032c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032cb:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8032ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8032e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032e6:	75 17                	jne    8032ff <insert_sorted_with_merge_freeList+0x650>
  8032e8:	83 ec 04             	sub    $0x4,%esp
  8032eb:	68 54 42 80 00       	push   $0x804254
  8032f0:	68 32 01 00 00       	push   $0x132
  8032f5:	68 77 42 80 00       	push   $0x804277
  8032fa:	e8 d0 d3 ff ff       	call   8006cf <_panic>
  8032ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	89 10                	mov    %edx,(%eax)
  80330a:	8b 45 08             	mov    0x8(%ebp),%eax
  80330d:	8b 00                	mov    (%eax),%eax
  80330f:	85 c0                	test   %eax,%eax
  803311:	74 0d                	je     803320 <insert_sorted_with_merge_freeList+0x671>
  803313:	a1 48 51 80 00       	mov    0x805148,%eax
  803318:	8b 55 08             	mov    0x8(%ebp),%edx
  80331b:	89 50 04             	mov    %edx,0x4(%eax)
  80331e:	eb 08                	jmp    803328 <insert_sorted_with_merge_freeList+0x679>
  803320:	8b 45 08             	mov    0x8(%ebp),%eax
  803323:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	a3 48 51 80 00       	mov    %eax,0x805148
  803330:	8b 45 08             	mov    0x8(%ebp),%eax
  803333:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80333a:	a1 54 51 80 00       	mov    0x805154,%eax
  80333f:	40                   	inc    %eax
  803340:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803348:	8b 00                	mov    (%eax),%eax
  80334a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803354:	8b 00                	mov    (%eax),%eax
  803356:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80335d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803360:	8b 00                	mov    (%eax),%eax
  803362:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803365:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803369:	75 17                	jne    803382 <insert_sorted_with_merge_freeList+0x6d3>
  80336b:	83 ec 04             	sub    $0x4,%esp
  80336e:	68 e9 42 80 00       	push   $0x8042e9
  803373:	68 36 01 00 00       	push   $0x136
  803378:	68 77 42 80 00       	push   $0x804277
  80337d:	e8 4d d3 ff ff       	call   8006cf <_panic>
  803382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803385:	8b 00                	mov    (%eax),%eax
  803387:	85 c0                	test   %eax,%eax
  803389:	74 10                	je     80339b <insert_sorted_with_merge_freeList+0x6ec>
  80338b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80338e:	8b 00                	mov    (%eax),%eax
  803390:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803393:	8b 52 04             	mov    0x4(%edx),%edx
  803396:	89 50 04             	mov    %edx,0x4(%eax)
  803399:	eb 0b                	jmp    8033a6 <insert_sorted_with_merge_freeList+0x6f7>
  80339b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80339e:	8b 40 04             	mov    0x4(%eax),%eax
  8033a1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a9:	8b 40 04             	mov    0x4(%eax),%eax
  8033ac:	85 c0                	test   %eax,%eax
  8033ae:	74 0f                	je     8033bf <insert_sorted_with_merge_freeList+0x710>
  8033b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b3:	8b 40 04             	mov    0x4(%eax),%eax
  8033b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033b9:	8b 12                	mov    (%edx),%edx
  8033bb:	89 10                	mov    %edx,(%eax)
  8033bd:	eb 0a                	jmp    8033c9 <insert_sorted_with_merge_freeList+0x71a>
  8033bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c2:	8b 00                	mov    (%eax),%eax
  8033c4:	a3 38 51 80 00       	mov    %eax,0x805138
  8033c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033dc:	a1 44 51 80 00       	mov    0x805144,%eax
  8033e1:	48                   	dec    %eax
  8033e2:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8033e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033eb:	75 17                	jne    803404 <insert_sorted_with_merge_freeList+0x755>
  8033ed:	83 ec 04             	sub    $0x4,%esp
  8033f0:	68 54 42 80 00       	push   $0x804254
  8033f5:	68 37 01 00 00       	push   $0x137
  8033fa:	68 77 42 80 00       	push   $0x804277
  8033ff:	e8 cb d2 ff ff       	call   8006cf <_panic>
  803404:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80340a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80340d:	89 10                	mov    %edx,(%eax)
  80340f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803412:	8b 00                	mov    (%eax),%eax
  803414:	85 c0                	test   %eax,%eax
  803416:	74 0d                	je     803425 <insert_sorted_with_merge_freeList+0x776>
  803418:	a1 48 51 80 00       	mov    0x805148,%eax
  80341d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803420:	89 50 04             	mov    %edx,0x4(%eax)
  803423:	eb 08                	jmp    80342d <insert_sorted_with_merge_freeList+0x77e>
  803425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803428:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80342d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803430:	a3 48 51 80 00       	mov    %eax,0x805148
  803435:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803438:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80343f:	a1 54 51 80 00       	mov    0x805154,%eax
  803444:	40                   	inc    %eax
  803445:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  80344a:	eb 38                	jmp    803484 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80344c:	a1 40 51 80 00       	mov    0x805140,%eax
  803451:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803454:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803458:	74 07                	je     803461 <insert_sorted_with_merge_freeList+0x7b2>
  80345a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80345d:	8b 00                	mov    (%eax),%eax
  80345f:	eb 05                	jmp    803466 <insert_sorted_with_merge_freeList+0x7b7>
  803461:	b8 00 00 00 00       	mov    $0x0,%eax
  803466:	a3 40 51 80 00       	mov    %eax,0x805140
  80346b:	a1 40 51 80 00       	mov    0x805140,%eax
  803470:	85 c0                	test   %eax,%eax
  803472:	0f 85 ef f9 ff ff    	jne    802e67 <insert_sorted_with_merge_freeList+0x1b8>
  803478:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80347c:	0f 85 e5 f9 ff ff    	jne    802e67 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803482:	eb 00                	jmp    803484 <insert_sorted_with_merge_freeList+0x7d5>
  803484:	90                   	nop
  803485:	c9                   	leave  
  803486:	c3                   	ret    
  803487:	90                   	nop

00803488 <__udivdi3>:
  803488:	55                   	push   %ebp
  803489:	57                   	push   %edi
  80348a:	56                   	push   %esi
  80348b:	53                   	push   %ebx
  80348c:	83 ec 1c             	sub    $0x1c,%esp
  80348f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803493:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803497:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80349b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80349f:	89 ca                	mov    %ecx,%edx
  8034a1:	89 f8                	mov    %edi,%eax
  8034a3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034a7:	85 f6                	test   %esi,%esi
  8034a9:	75 2d                	jne    8034d8 <__udivdi3+0x50>
  8034ab:	39 cf                	cmp    %ecx,%edi
  8034ad:	77 65                	ja     803514 <__udivdi3+0x8c>
  8034af:	89 fd                	mov    %edi,%ebp
  8034b1:	85 ff                	test   %edi,%edi
  8034b3:	75 0b                	jne    8034c0 <__udivdi3+0x38>
  8034b5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ba:	31 d2                	xor    %edx,%edx
  8034bc:	f7 f7                	div    %edi
  8034be:	89 c5                	mov    %eax,%ebp
  8034c0:	31 d2                	xor    %edx,%edx
  8034c2:	89 c8                	mov    %ecx,%eax
  8034c4:	f7 f5                	div    %ebp
  8034c6:	89 c1                	mov    %eax,%ecx
  8034c8:	89 d8                	mov    %ebx,%eax
  8034ca:	f7 f5                	div    %ebp
  8034cc:	89 cf                	mov    %ecx,%edi
  8034ce:	89 fa                	mov    %edi,%edx
  8034d0:	83 c4 1c             	add    $0x1c,%esp
  8034d3:	5b                   	pop    %ebx
  8034d4:	5e                   	pop    %esi
  8034d5:	5f                   	pop    %edi
  8034d6:	5d                   	pop    %ebp
  8034d7:	c3                   	ret    
  8034d8:	39 ce                	cmp    %ecx,%esi
  8034da:	77 28                	ja     803504 <__udivdi3+0x7c>
  8034dc:	0f bd fe             	bsr    %esi,%edi
  8034df:	83 f7 1f             	xor    $0x1f,%edi
  8034e2:	75 40                	jne    803524 <__udivdi3+0x9c>
  8034e4:	39 ce                	cmp    %ecx,%esi
  8034e6:	72 0a                	jb     8034f2 <__udivdi3+0x6a>
  8034e8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8034ec:	0f 87 9e 00 00 00    	ja     803590 <__udivdi3+0x108>
  8034f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8034f7:	89 fa                	mov    %edi,%edx
  8034f9:	83 c4 1c             	add    $0x1c,%esp
  8034fc:	5b                   	pop    %ebx
  8034fd:	5e                   	pop    %esi
  8034fe:	5f                   	pop    %edi
  8034ff:	5d                   	pop    %ebp
  803500:	c3                   	ret    
  803501:	8d 76 00             	lea    0x0(%esi),%esi
  803504:	31 ff                	xor    %edi,%edi
  803506:	31 c0                	xor    %eax,%eax
  803508:	89 fa                	mov    %edi,%edx
  80350a:	83 c4 1c             	add    $0x1c,%esp
  80350d:	5b                   	pop    %ebx
  80350e:	5e                   	pop    %esi
  80350f:	5f                   	pop    %edi
  803510:	5d                   	pop    %ebp
  803511:	c3                   	ret    
  803512:	66 90                	xchg   %ax,%ax
  803514:	89 d8                	mov    %ebx,%eax
  803516:	f7 f7                	div    %edi
  803518:	31 ff                	xor    %edi,%edi
  80351a:	89 fa                	mov    %edi,%edx
  80351c:	83 c4 1c             	add    $0x1c,%esp
  80351f:	5b                   	pop    %ebx
  803520:	5e                   	pop    %esi
  803521:	5f                   	pop    %edi
  803522:	5d                   	pop    %ebp
  803523:	c3                   	ret    
  803524:	bd 20 00 00 00       	mov    $0x20,%ebp
  803529:	89 eb                	mov    %ebp,%ebx
  80352b:	29 fb                	sub    %edi,%ebx
  80352d:	89 f9                	mov    %edi,%ecx
  80352f:	d3 e6                	shl    %cl,%esi
  803531:	89 c5                	mov    %eax,%ebp
  803533:	88 d9                	mov    %bl,%cl
  803535:	d3 ed                	shr    %cl,%ebp
  803537:	89 e9                	mov    %ebp,%ecx
  803539:	09 f1                	or     %esi,%ecx
  80353b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80353f:	89 f9                	mov    %edi,%ecx
  803541:	d3 e0                	shl    %cl,%eax
  803543:	89 c5                	mov    %eax,%ebp
  803545:	89 d6                	mov    %edx,%esi
  803547:	88 d9                	mov    %bl,%cl
  803549:	d3 ee                	shr    %cl,%esi
  80354b:	89 f9                	mov    %edi,%ecx
  80354d:	d3 e2                	shl    %cl,%edx
  80354f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803553:	88 d9                	mov    %bl,%cl
  803555:	d3 e8                	shr    %cl,%eax
  803557:	09 c2                	or     %eax,%edx
  803559:	89 d0                	mov    %edx,%eax
  80355b:	89 f2                	mov    %esi,%edx
  80355d:	f7 74 24 0c          	divl   0xc(%esp)
  803561:	89 d6                	mov    %edx,%esi
  803563:	89 c3                	mov    %eax,%ebx
  803565:	f7 e5                	mul    %ebp
  803567:	39 d6                	cmp    %edx,%esi
  803569:	72 19                	jb     803584 <__udivdi3+0xfc>
  80356b:	74 0b                	je     803578 <__udivdi3+0xf0>
  80356d:	89 d8                	mov    %ebx,%eax
  80356f:	31 ff                	xor    %edi,%edi
  803571:	e9 58 ff ff ff       	jmp    8034ce <__udivdi3+0x46>
  803576:	66 90                	xchg   %ax,%ax
  803578:	8b 54 24 08          	mov    0x8(%esp),%edx
  80357c:	89 f9                	mov    %edi,%ecx
  80357e:	d3 e2                	shl    %cl,%edx
  803580:	39 c2                	cmp    %eax,%edx
  803582:	73 e9                	jae    80356d <__udivdi3+0xe5>
  803584:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803587:	31 ff                	xor    %edi,%edi
  803589:	e9 40 ff ff ff       	jmp    8034ce <__udivdi3+0x46>
  80358e:	66 90                	xchg   %ax,%ax
  803590:	31 c0                	xor    %eax,%eax
  803592:	e9 37 ff ff ff       	jmp    8034ce <__udivdi3+0x46>
  803597:	90                   	nop

00803598 <__umoddi3>:
  803598:	55                   	push   %ebp
  803599:	57                   	push   %edi
  80359a:	56                   	push   %esi
  80359b:	53                   	push   %ebx
  80359c:	83 ec 1c             	sub    $0x1c,%esp
  80359f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035a3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035ab:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035b3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035b7:	89 f3                	mov    %esi,%ebx
  8035b9:	89 fa                	mov    %edi,%edx
  8035bb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035bf:	89 34 24             	mov    %esi,(%esp)
  8035c2:	85 c0                	test   %eax,%eax
  8035c4:	75 1a                	jne    8035e0 <__umoddi3+0x48>
  8035c6:	39 f7                	cmp    %esi,%edi
  8035c8:	0f 86 a2 00 00 00    	jbe    803670 <__umoddi3+0xd8>
  8035ce:	89 c8                	mov    %ecx,%eax
  8035d0:	89 f2                	mov    %esi,%edx
  8035d2:	f7 f7                	div    %edi
  8035d4:	89 d0                	mov    %edx,%eax
  8035d6:	31 d2                	xor    %edx,%edx
  8035d8:	83 c4 1c             	add    $0x1c,%esp
  8035db:	5b                   	pop    %ebx
  8035dc:	5e                   	pop    %esi
  8035dd:	5f                   	pop    %edi
  8035de:	5d                   	pop    %ebp
  8035df:	c3                   	ret    
  8035e0:	39 f0                	cmp    %esi,%eax
  8035e2:	0f 87 ac 00 00 00    	ja     803694 <__umoddi3+0xfc>
  8035e8:	0f bd e8             	bsr    %eax,%ebp
  8035eb:	83 f5 1f             	xor    $0x1f,%ebp
  8035ee:	0f 84 ac 00 00 00    	je     8036a0 <__umoddi3+0x108>
  8035f4:	bf 20 00 00 00       	mov    $0x20,%edi
  8035f9:	29 ef                	sub    %ebp,%edi
  8035fb:	89 fe                	mov    %edi,%esi
  8035fd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803601:	89 e9                	mov    %ebp,%ecx
  803603:	d3 e0                	shl    %cl,%eax
  803605:	89 d7                	mov    %edx,%edi
  803607:	89 f1                	mov    %esi,%ecx
  803609:	d3 ef                	shr    %cl,%edi
  80360b:	09 c7                	or     %eax,%edi
  80360d:	89 e9                	mov    %ebp,%ecx
  80360f:	d3 e2                	shl    %cl,%edx
  803611:	89 14 24             	mov    %edx,(%esp)
  803614:	89 d8                	mov    %ebx,%eax
  803616:	d3 e0                	shl    %cl,%eax
  803618:	89 c2                	mov    %eax,%edx
  80361a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80361e:	d3 e0                	shl    %cl,%eax
  803620:	89 44 24 04          	mov    %eax,0x4(%esp)
  803624:	8b 44 24 08          	mov    0x8(%esp),%eax
  803628:	89 f1                	mov    %esi,%ecx
  80362a:	d3 e8                	shr    %cl,%eax
  80362c:	09 d0                	or     %edx,%eax
  80362e:	d3 eb                	shr    %cl,%ebx
  803630:	89 da                	mov    %ebx,%edx
  803632:	f7 f7                	div    %edi
  803634:	89 d3                	mov    %edx,%ebx
  803636:	f7 24 24             	mull   (%esp)
  803639:	89 c6                	mov    %eax,%esi
  80363b:	89 d1                	mov    %edx,%ecx
  80363d:	39 d3                	cmp    %edx,%ebx
  80363f:	0f 82 87 00 00 00    	jb     8036cc <__umoddi3+0x134>
  803645:	0f 84 91 00 00 00    	je     8036dc <__umoddi3+0x144>
  80364b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80364f:	29 f2                	sub    %esi,%edx
  803651:	19 cb                	sbb    %ecx,%ebx
  803653:	89 d8                	mov    %ebx,%eax
  803655:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803659:	d3 e0                	shl    %cl,%eax
  80365b:	89 e9                	mov    %ebp,%ecx
  80365d:	d3 ea                	shr    %cl,%edx
  80365f:	09 d0                	or     %edx,%eax
  803661:	89 e9                	mov    %ebp,%ecx
  803663:	d3 eb                	shr    %cl,%ebx
  803665:	89 da                	mov    %ebx,%edx
  803667:	83 c4 1c             	add    $0x1c,%esp
  80366a:	5b                   	pop    %ebx
  80366b:	5e                   	pop    %esi
  80366c:	5f                   	pop    %edi
  80366d:	5d                   	pop    %ebp
  80366e:	c3                   	ret    
  80366f:	90                   	nop
  803670:	89 fd                	mov    %edi,%ebp
  803672:	85 ff                	test   %edi,%edi
  803674:	75 0b                	jne    803681 <__umoddi3+0xe9>
  803676:	b8 01 00 00 00       	mov    $0x1,%eax
  80367b:	31 d2                	xor    %edx,%edx
  80367d:	f7 f7                	div    %edi
  80367f:	89 c5                	mov    %eax,%ebp
  803681:	89 f0                	mov    %esi,%eax
  803683:	31 d2                	xor    %edx,%edx
  803685:	f7 f5                	div    %ebp
  803687:	89 c8                	mov    %ecx,%eax
  803689:	f7 f5                	div    %ebp
  80368b:	89 d0                	mov    %edx,%eax
  80368d:	e9 44 ff ff ff       	jmp    8035d6 <__umoddi3+0x3e>
  803692:	66 90                	xchg   %ax,%ax
  803694:	89 c8                	mov    %ecx,%eax
  803696:	89 f2                	mov    %esi,%edx
  803698:	83 c4 1c             	add    $0x1c,%esp
  80369b:	5b                   	pop    %ebx
  80369c:	5e                   	pop    %esi
  80369d:	5f                   	pop    %edi
  80369e:	5d                   	pop    %ebp
  80369f:	c3                   	ret    
  8036a0:	3b 04 24             	cmp    (%esp),%eax
  8036a3:	72 06                	jb     8036ab <__umoddi3+0x113>
  8036a5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036a9:	77 0f                	ja     8036ba <__umoddi3+0x122>
  8036ab:	89 f2                	mov    %esi,%edx
  8036ad:	29 f9                	sub    %edi,%ecx
  8036af:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036b3:	89 14 24             	mov    %edx,(%esp)
  8036b6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ba:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036be:	8b 14 24             	mov    (%esp),%edx
  8036c1:	83 c4 1c             	add    $0x1c,%esp
  8036c4:	5b                   	pop    %ebx
  8036c5:	5e                   	pop    %esi
  8036c6:	5f                   	pop    %edi
  8036c7:	5d                   	pop    %ebp
  8036c8:	c3                   	ret    
  8036c9:	8d 76 00             	lea    0x0(%esi),%esi
  8036cc:	2b 04 24             	sub    (%esp),%eax
  8036cf:	19 fa                	sbb    %edi,%edx
  8036d1:	89 d1                	mov    %edx,%ecx
  8036d3:	89 c6                	mov    %eax,%esi
  8036d5:	e9 71 ff ff ff       	jmp    80364b <__umoddi3+0xb3>
  8036da:	66 90                	xchg   %ax,%ax
  8036dc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036e0:	72 ea                	jb     8036cc <__umoddi3+0x134>
  8036e2:	89 d9                	mov    %ebx,%ecx
  8036e4:	e9 62 ff ff ff       	jmp    80364b <__umoddi3+0xb3>
