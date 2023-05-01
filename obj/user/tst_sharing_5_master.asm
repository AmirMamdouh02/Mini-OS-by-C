
obj/user/tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 d8 03 00 00       	call   80040e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
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
  80008d:	68 20 36 80 00       	push   $0x803620
  800092:	6a 12                	push   $0x12
  800094:	68 3c 36 80 00       	push   $0x80363c
  800099:	e8 ac 04 00 00       	call   80054a <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 f5 16 00 00       	call   80179d <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	cprintf("************************************************\n");
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	68 58 36 80 00       	push   $0x803658
  8000b3:	e8 46 07 00 00       	call   8007fe <cprintf>
  8000b8:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	68 8c 36 80 00       	push   $0x80368c
  8000c3:	e8 36 07 00 00       	call   8007fe <cprintf>
  8000c8:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 e8 36 80 00       	push   $0x8036e8
  8000d3:	e8 26 07 00 00       	call   8007fe <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000db:	e8 22 1e 00 00       	call   801f02 <sys_getenvid>
  8000e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int expected = 0;
  8000e3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000ea:	83 ec 0c             	sub    $0xc,%esp
  8000ed:	68 1c 37 80 00       	push   $0x80371c
  8000f2:	e8 07 07 00 00       	call   8007fe <cprintf>
  8000f7:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		int32 envIdSlave1 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000fa:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ff:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800105:	a1 20 50 80 00       	mov    0x805020,%eax
  80010a:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800110:	89 c1                	mov    %eax,%ecx
  800112:	a1 20 50 80 00       	mov    0x805020,%eax
  800117:	8b 40 74             	mov    0x74(%eax),%eax
  80011a:	52                   	push   %edx
  80011b:	51                   	push   %ecx
  80011c:	50                   	push   %eax
  80011d:	68 5d 37 80 00       	push   $0x80375d
  800122:	e8 86 1d 00 00       	call   801ead <sys_create_env>
  800127:	83 c4 10             	add    $0x10,%esp
  80012a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int32 envIdSlave2 = sys_create_env("tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  80012d:	a1 20 50 80 00       	mov    0x805020,%eax
  800132:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800138:	a1 20 50 80 00       	mov    0x805020,%eax
  80013d:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800143:	89 c1                	mov    %eax,%ecx
  800145:	a1 20 50 80 00       	mov    0x805020,%eax
  80014a:	8b 40 74             	mov    0x74(%eax),%eax
  80014d:	52                   	push   %edx
  80014e:	51                   	push   %ecx
  80014f:	50                   	push   %eax
  800150:	68 5d 37 80 00       	push   $0x80375d
  800155:	e8 53 1d 00 00       	call   801ead <sys_create_env>
  80015a:	83 c4 10             	add    $0x10,%esp
  80015d:	89 45 e0             	mov    %eax,-0x20(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800160:	e8 d6 1a 00 00       	call   801c3b <sys_calculate_free_frames>
  800165:	89 45 dc             	mov    %eax,-0x24(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800168:	83 ec 04             	sub    $0x4,%esp
  80016b:	6a 01                	push   $0x1
  80016d:	68 00 10 00 00       	push   $0x1000
  800172:	68 68 37 80 00       	push   $0x803768
  800177:	e8 9c 17 00 00       	call   801918 <smalloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
		cprintf("Master env created x (1 page) \n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 6c 37 80 00       	push   $0x80376c
  80018a:	e8 6f 06 00 00       	call   8007fe <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  800192:	81 7d d8 00 00 00 80 	cmpl   $0x80000000,-0x28(%ebp)
  800199:	74 14                	je     8001af <_main+0x177>
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	68 8c 37 80 00       	push   $0x80378c
  8001a3:	6a 27                	push   $0x27
  8001a5:	68 3c 36 80 00       	push   $0x80363c
  8001aa:	e8 9b 03 00 00       	call   80054a <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  8001af:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8001b2:	e8 84 1a 00 00       	call   801c3b <sys_calculate_free_frames>
  8001b7:	29 c3                	sub    %eax,%ebx
  8001b9:	89 d8                	mov    %ebx,%eax
  8001bb:	83 f8 04             	cmp    $0x4,%eax
  8001be:	74 14                	je     8001d4 <_main+0x19c>
  8001c0:	83 ec 04             	sub    $0x4,%esp
  8001c3:	68 f8 37 80 00       	push   $0x8037f8
  8001c8:	6a 28                	push   $0x28
  8001ca:	68 3c 36 80 00       	push   $0x80363c
  8001cf:	e8 76 03 00 00       	call   80054a <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001d4:	e8 20 1e 00 00       	call   801ff9 <rsttst>

		sys_run_env(envIdSlave1);
  8001d9:	83 ec 0c             	sub    $0xc,%esp
  8001dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001df:	e8 e7 1c 00 00       	call   801ecb <sys_run_env>
  8001e4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001e7:	83 ec 0c             	sub    $0xc,%esp
  8001ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ed:	e8 d9 1c 00 00       	call   801ecb <sys_run_env>
  8001f2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 76 38 80 00       	push   $0x803876
  8001fd:	e8 fc 05 00 00       	call   8007fe <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 b8 0b 00 00       	push   $0xbb8
  80020d:	e8 f0 30 00 00       	call   803302 <env_sleep>
  800212:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		while (gettst()!=2) ;// panic("test failed");
  800215:	90                   	nop
  800216:	e8 58 1e 00 00       	call   802073 <gettst>
  80021b:	83 f8 02             	cmp    $0x2,%eax
  80021e:	75 f6                	jne    800216 <_main+0x1de>

		freeFrames = sys_calculate_free_frames() ;
  800220:	e8 16 1a 00 00       	call   801c3b <sys_calculate_free_frames>
  800225:	89 45 dc             	mov    %eax,-0x24(%ebp)
		sfree(x);
  800228:	83 ec 0c             	sub    $0xc,%esp
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	e8 a8 18 00 00       	call   801adb <sfree>
  800233:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 90 38 80 00       	push   $0x803890
  80023e:	e8 bb 05 00 00       	call   8007fe <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800246:	e8 f0 19 00 00       	call   801c3b <sys_calculate_free_frames>
  80024b:	89 c2                	mov    %eax,%edx
  80024d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800250:	29 c2                	sub    %eax,%edx
  800252:	89 d0                	mov    %edx,%eax
  800254:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		expected = (1+1) + (1+1);
  800257:	c7 45 e8 04 00 00 00 	movl   $0x4,-0x18(%ebp)
		if ( diff !=  expected) panic("Wrong free (diff=%d, expected=%d): revise your freeSharedObject logic\n", diff, expected);
  80025e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800261:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  800264:	74 1a                	je     800280 <_main+0x248>
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	ff 75 e8             	pushl  -0x18(%ebp)
  80026c:	ff 75 d4             	pushl  -0x2c(%ebp)
  80026f:	68 b0 38 80 00       	push   $0x8038b0
  800274:	6a 3b                	push   $0x3b
  800276:	68 3c 36 80 00       	push   $0x80363c
  80027b:	e8 ca 02 00 00       	call   80054a <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800280:	83 ec 0c             	sub    $0xc,%esp
  800283:	68 f8 38 80 00       	push   $0x8038f8
  800288:	e8 71 05 00 00       	call   8007fe <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 1c 39 80 00       	push   $0x80391c
  800298:	e8 61 05 00 00       	call   8007fe <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		int32 envIdSlaveB1 = sys_create_env("tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a5:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002ab:	a1 20 50 80 00       	mov    0x805020,%eax
  8002b0:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002b6:	89 c1                	mov    %eax,%ecx
  8002b8:	a1 20 50 80 00       	mov    0x805020,%eax
  8002bd:	8b 40 74             	mov    0x74(%eax),%eax
  8002c0:	52                   	push   %edx
  8002c1:	51                   	push   %ecx
  8002c2:	50                   	push   %eax
  8002c3:	68 4c 39 80 00       	push   $0x80394c
  8002c8:	e8 e0 1b 00 00       	call   801ead <sys_create_env>
  8002cd:	83 c4 10             	add    $0x10,%esp
  8002d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		int32 envIdSlaveB2 = sys_create_env("tshr5slaveB2", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002d3:	a1 20 50 80 00       	mov    0x805020,%eax
  8002d8:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002de:	a1 20 50 80 00       	mov    0x805020,%eax
  8002e3:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002e9:	89 c1                	mov    %eax,%ecx
  8002eb:	a1 20 50 80 00       	mov    0x805020,%eax
  8002f0:	8b 40 74             	mov    0x74(%eax),%eax
  8002f3:	52                   	push   %edx
  8002f4:	51                   	push   %ecx
  8002f5:	50                   	push   %eax
  8002f6:	68 59 39 80 00       	push   $0x803959
  8002fb:	e8 ad 1b 00 00       	call   801ead <sys_create_env>
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	89 45 cc             	mov    %eax,-0x34(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	6a 01                	push   $0x1
  80030b:	68 00 10 00 00       	push   $0x1000
  800310:	68 66 39 80 00       	push   $0x803966
  800315:	e8 fe 15 00 00       	call   801918 <smalloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created z (1 page) \n");
  800320:	83 ec 0c             	sub    $0xc,%esp
  800323:	68 68 39 80 00       	push   $0x803968
  800328:	e8 d1 04 00 00       	call   8007fe <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  800330:	83 ec 04             	sub    $0x4,%esp
  800333:	6a 01                	push   $0x1
  800335:	68 00 10 00 00       	push   $0x1000
  80033a:	68 68 37 80 00       	push   $0x803768
  80033f:	e8 d4 15 00 00       	call   801918 <smalloc>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		cprintf("Master env created x (1 page) \n");
  80034a:	83 ec 0c             	sub    $0xc,%esp
  80034d:	68 6c 37 80 00       	push   $0x80376c
  800352:	e8 a7 04 00 00       	call   8007fe <cprintf>
  800357:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80035a:	e8 9a 1c 00 00       	call   801ff9 <rsttst>

		sys_run_env(envIdSlaveB1);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d0             	pushl  -0x30(%ebp)
  800365:	e8 61 1b 00 00       	call   801ecb <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	ff 75 cc             	pushl  -0x34(%ebp)
  800373:	e8 53 1b 00 00       	call   801ecb <sys_run_env>
  800378:	83 c4 10             	add    $0x10,%esp

		//give slaves time to catch the shared object before removal
		{
//			env_sleep(4000);
			while (gettst()!=2) ;
  80037b:	90                   	nop
  80037c:	e8 f2 1c 00 00       	call   802073 <gettst>
  800381:	83 f8 02             	cmp    $0x2,%eax
  800384:	75 f6                	jne    80037c <_main+0x344>
		}

		rsttst();
  800386:	e8 6e 1c 00 00       	call   801ff9 <rsttst>

		int freeFrames = sys_calculate_free_frames() ;
  80038b:	e8 ab 18 00 00       	call   801c3b <sys_calculate_free_frames>
  800390:	89 45 c0             	mov    %eax,-0x40(%ebp)

		sfree(z);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	ff 75 c8             	pushl  -0x38(%ebp)
  800399:	e8 3d 17 00 00       	call   801adb <sfree>
  80039e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  8003a1:	83 ec 0c             	sub    $0xc,%esp
  8003a4:	68 88 39 80 00       	push   $0x803988
  8003a9:	e8 50 04 00 00       	call   8007fe <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  8003b1:	83 ec 0c             	sub    $0xc,%esp
  8003b4:	ff 75 c4             	pushl  -0x3c(%ebp)
  8003b7:	e8 1f 17 00 00       	call   801adb <sfree>
  8003bc:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 9e 39 80 00       	push   $0x80399e
  8003c7:	e8 32 04 00 00       	call   8007fe <cprintf>
  8003cc:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  8003cf:	e8 67 18 00 00       	call   801c3b <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8003d9:	29 c2                	sub    %eax,%edx
  8003db:	89 d0                	mov    %edx,%eax
  8003dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
		expected = 1;
  8003e0:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
		if (diff !=  expected) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003e7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003ea:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8003ed:	74 14                	je     800403 <_main+0x3cb>
  8003ef:	83 ec 04             	sub    $0x4,%esp
  8003f2:	68 b4 39 80 00       	push   $0x8039b4
  8003f7:	6a 62                	push   $0x62
  8003f9:	68 3c 36 80 00       	push   $0x80363c
  8003fe:	e8 47 01 00 00       	call   80054a <_panic>

		//To indicate that it's completed successfully
		inctst();
  800403:	e8 51 1c 00 00       	call   802059 <inctst>


	}


	return;
  800408:	90                   	nop
}
  800409:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800414:	e8 02 1b 00 00       	call   801f1b <sys_getenvindex>
  800419:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80041c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80041f:	89 d0                	mov    %edx,%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	01 d0                	add    %edx,%eax
  800426:	01 c0                	add    %eax,%eax
  800428:	01 d0                	add    %edx,%eax
  80042a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800431:	01 d0                	add    %edx,%eax
  800433:	c1 e0 04             	shl    $0x4,%eax
  800436:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80043b:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800440:	a1 20 50 80 00       	mov    0x805020,%eax
  800445:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80044b:	84 c0                	test   %al,%al
  80044d:	74 0f                	je     80045e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80044f:	a1 20 50 80 00       	mov    0x805020,%eax
  800454:	05 5c 05 00 00       	add    $0x55c,%eax
  800459:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80045e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800462:	7e 0a                	jle    80046e <libmain+0x60>
		binaryname = argv[0];
  800464:	8b 45 0c             	mov    0xc(%ebp),%eax
  800467:	8b 00                	mov    (%eax),%eax
  800469:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80046e:	83 ec 08             	sub    $0x8,%esp
  800471:	ff 75 0c             	pushl  0xc(%ebp)
  800474:	ff 75 08             	pushl  0x8(%ebp)
  800477:	e8 bc fb ff ff       	call   800038 <_main>
  80047c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80047f:	e8 a4 18 00 00       	call   801d28 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800484:	83 ec 0c             	sub    $0xc,%esp
  800487:	68 74 3a 80 00       	push   $0x803a74
  80048c:	e8 6d 03 00 00       	call   8007fe <cprintf>
  800491:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800494:	a1 20 50 80 00       	mov    0x805020,%eax
  800499:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80049f:	a1 20 50 80 00       	mov    0x805020,%eax
  8004a4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	52                   	push   %edx
  8004ae:	50                   	push   %eax
  8004af:	68 9c 3a 80 00       	push   $0x803a9c
  8004b4:	e8 45 03 00 00       	call   8007fe <cprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8004bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8004c1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8004c7:	a1 20 50 80 00       	mov    0x805020,%eax
  8004cc:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8004d7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004dd:	51                   	push   %ecx
  8004de:	52                   	push   %edx
  8004df:	50                   	push   %eax
  8004e0:	68 c4 3a 80 00       	push   $0x803ac4
  8004e5:	e8 14 03 00 00       	call   8007fe <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004ed:	a1 20 50 80 00       	mov    0x805020,%eax
  8004f2:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004f8:	83 ec 08             	sub    $0x8,%esp
  8004fb:	50                   	push   %eax
  8004fc:	68 1c 3b 80 00       	push   $0x803b1c
  800501:	e8 f8 02 00 00       	call   8007fe <cprintf>
  800506:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800509:	83 ec 0c             	sub    $0xc,%esp
  80050c:	68 74 3a 80 00       	push   $0x803a74
  800511:	e8 e8 02 00 00       	call   8007fe <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800519:	e8 24 18 00 00       	call   801d42 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80051e:	e8 19 00 00 00       	call   80053c <exit>
}
  800523:	90                   	nop
  800524:	c9                   	leave  
  800525:	c3                   	ret    

00800526 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800526:	55                   	push   %ebp
  800527:	89 e5                	mov    %esp,%ebp
  800529:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80052c:	83 ec 0c             	sub    $0xc,%esp
  80052f:	6a 00                	push   $0x0
  800531:	e8 b1 19 00 00       	call   801ee7 <sys_destroy_env>
  800536:	83 c4 10             	add    $0x10,%esp
}
  800539:	90                   	nop
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <exit>:

void
exit(void)
{
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800542:	e8 06 1a 00 00       	call   801f4d <sys_exit_env>
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800550:	8d 45 10             	lea    0x10(%ebp),%eax
  800553:	83 c0 04             	add    $0x4,%eax
  800556:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800559:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80055e:	85 c0                	test   %eax,%eax
  800560:	74 16                	je     800578 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800562:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	50                   	push   %eax
  80056b:	68 30 3b 80 00       	push   $0x803b30
  800570:	e8 89 02 00 00       	call   8007fe <cprintf>
  800575:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800578:	a1 00 50 80 00       	mov    0x805000,%eax
  80057d:	ff 75 0c             	pushl  0xc(%ebp)
  800580:	ff 75 08             	pushl  0x8(%ebp)
  800583:	50                   	push   %eax
  800584:	68 35 3b 80 00       	push   $0x803b35
  800589:	e8 70 02 00 00       	call   8007fe <cprintf>
  80058e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800591:	8b 45 10             	mov    0x10(%ebp),%eax
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	ff 75 f4             	pushl  -0xc(%ebp)
  80059a:	50                   	push   %eax
  80059b:	e8 f3 01 00 00       	call   800793 <vcprintf>
  8005a0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	6a 00                	push   $0x0
  8005a8:	68 51 3b 80 00       	push   $0x803b51
  8005ad:	e8 e1 01 00 00       	call   800793 <vcprintf>
  8005b2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8005b5:	e8 82 ff ff ff       	call   80053c <exit>

	// should not return here
	while (1) ;
  8005ba:	eb fe                	jmp    8005ba <_panic+0x70>

008005bc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8005bc:	55                   	push   %ebp
  8005bd:	89 e5                	mov    %esp,%ebp
  8005bf:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8005c2:	a1 20 50 80 00       	mov    0x805020,%eax
  8005c7:	8b 50 74             	mov    0x74(%eax),%edx
  8005ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005cd:	39 c2                	cmp    %eax,%edx
  8005cf:	74 14                	je     8005e5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005d1:	83 ec 04             	sub    $0x4,%esp
  8005d4:	68 54 3b 80 00       	push   $0x803b54
  8005d9:	6a 26                	push   $0x26
  8005db:	68 a0 3b 80 00       	push   $0x803ba0
  8005e0:	e8 65 ff ff ff       	call   80054a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005f3:	e9 c2 00 00 00       	jmp    8006ba <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800602:	8b 45 08             	mov    0x8(%ebp),%eax
  800605:	01 d0                	add    %edx,%eax
  800607:	8b 00                	mov    (%eax),%eax
  800609:	85 c0                	test   %eax,%eax
  80060b:	75 08                	jne    800615 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80060d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800610:	e9 a2 00 00 00       	jmp    8006b7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800615:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80061c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800623:	eb 69                	jmp    80068e <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800625:	a1 20 50 80 00       	mov    0x805020,%eax
  80062a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800630:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800633:	89 d0                	mov    %edx,%eax
  800635:	01 c0                	add    %eax,%eax
  800637:	01 d0                	add    %edx,%eax
  800639:	c1 e0 03             	shl    $0x3,%eax
  80063c:	01 c8                	add    %ecx,%eax
  80063e:	8a 40 04             	mov    0x4(%eax),%al
  800641:	84 c0                	test   %al,%al
  800643:	75 46                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800645:	a1 20 50 80 00       	mov    0x805020,%eax
  80064a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800650:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800653:	89 d0                	mov    %edx,%eax
  800655:	01 c0                	add    %eax,%eax
  800657:	01 d0                	add    %edx,%eax
  800659:	c1 e0 03             	shl    $0x3,%eax
  80065c:	01 c8                	add    %ecx,%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800663:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800666:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80066b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80066d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800670:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	01 c8                	add    %ecx,%eax
  80067c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80067e:	39 c2                	cmp    %eax,%edx
  800680:	75 09                	jne    80068b <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800682:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800689:	eb 12                	jmp    80069d <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80068b:	ff 45 e8             	incl   -0x18(%ebp)
  80068e:	a1 20 50 80 00       	mov    0x805020,%eax
  800693:	8b 50 74             	mov    0x74(%eax),%edx
  800696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800699:	39 c2                	cmp    %eax,%edx
  80069b:	77 88                	ja     800625 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80069d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8006a1:	75 14                	jne    8006b7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8006a3:	83 ec 04             	sub    $0x4,%esp
  8006a6:	68 ac 3b 80 00       	push   $0x803bac
  8006ab:	6a 3a                	push   $0x3a
  8006ad:	68 a0 3b 80 00       	push   $0x803ba0
  8006b2:	e8 93 fe ff ff       	call   80054a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8006b7:	ff 45 f0             	incl   -0x10(%ebp)
  8006ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006c0:	0f 8c 32 ff ff ff    	jl     8005f8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8006c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006d4:	eb 26                	jmp    8006fc <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006d6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006db:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e4:	89 d0                	mov    %edx,%eax
  8006e6:	01 c0                	add    %eax,%eax
  8006e8:	01 d0                	add    %edx,%eax
  8006ea:	c1 e0 03             	shl    $0x3,%eax
  8006ed:	01 c8                	add    %ecx,%eax
  8006ef:	8a 40 04             	mov    0x4(%eax),%al
  8006f2:	3c 01                	cmp    $0x1,%al
  8006f4:	75 03                	jne    8006f9 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006f6:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f9:	ff 45 e0             	incl   -0x20(%ebp)
  8006fc:	a1 20 50 80 00       	mov    0x805020,%eax
  800701:	8b 50 74             	mov    0x74(%eax),%edx
  800704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800707:	39 c2                	cmp    %eax,%edx
  800709:	77 cb                	ja     8006d6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80070b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80070e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800711:	74 14                	je     800727 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800713:	83 ec 04             	sub    $0x4,%esp
  800716:	68 00 3c 80 00       	push   $0x803c00
  80071b:	6a 44                	push   $0x44
  80071d:	68 a0 3b 80 00       	push   $0x803ba0
  800722:	e8 23 fe ff ff       	call   80054a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800727:	90                   	nop
  800728:	c9                   	leave  
  800729:	c3                   	ret    

0080072a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80072a:	55                   	push   %ebp
  80072b:	89 e5                	mov    %esp,%ebp
  80072d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800730:	8b 45 0c             	mov    0xc(%ebp),%eax
  800733:	8b 00                	mov    (%eax),%eax
  800735:	8d 48 01             	lea    0x1(%eax),%ecx
  800738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073b:	89 0a                	mov    %ecx,(%edx)
  80073d:	8b 55 08             	mov    0x8(%ebp),%edx
  800740:	88 d1                	mov    %dl,%cl
  800742:	8b 55 0c             	mov    0xc(%ebp),%edx
  800745:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800749:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800753:	75 2c                	jne    800781 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800755:	a0 24 50 80 00       	mov    0x805024,%al
  80075a:	0f b6 c0             	movzbl %al,%eax
  80075d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800760:	8b 12                	mov    (%edx),%edx
  800762:	89 d1                	mov    %edx,%ecx
  800764:	8b 55 0c             	mov    0xc(%ebp),%edx
  800767:	83 c2 08             	add    $0x8,%edx
  80076a:	83 ec 04             	sub    $0x4,%esp
  80076d:	50                   	push   %eax
  80076e:	51                   	push   %ecx
  80076f:	52                   	push   %edx
  800770:	e8 05 14 00 00       	call   801b7a <sys_cputs>
  800775:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80077b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800781:	8b 45 0c             	mov    0xc(%ebp),%eax
  800784:	8b 40 04             	mov    0x4(%eax),%eax
  800787:	8d 50 01             	lea    0x1(%eax),%edx
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	89 50 04             	mov    %edx,0x4(%eax)
}
  800790:	90                   	nop
  800791:	c9                   	leave  
  800792:	c3                   	ret    

00800793 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800793:	55                   	push   %ebp
  800794:	89 e5                	mov    %esp,%ebp
  800796:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80079c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a3:	00 00 00 
	b.cnt = 0;
  8007a6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007ad:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8007b0:	ff 75 0c             	pushl  0xc(%ebp)
  8007b3:	ff 75 08             	pushl  0x8(%ebp)
  8007b6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007bc:	50                   	push   %eax
  8007bd:	68 2a 07 80 00       	push   $0x80072a
  8007c2:	e8 11 02 00 00       	call   8009d8 <vprintfmt>
  8007c7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8007ca:	a0 24 50 80 00       	mov    0x805024,%al
  8007cf:	0f b6 c0             	movzbl %al,%eax
  8007d2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007d8:	83 ec 04             	sub    $0x4,%esp
  8007db:	50                   	push   %eax
  8007dc:	52                   	push   %edx
  8007dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007e3:	83 c0 08             	add    $0x8,%eax
  8007e6:	50                   	push   %eax
  8007e7:	e8 8e 13 00 00       	call   801b7a <sys_cputs>
  8007ec:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007ef:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8007f6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007fc:	c9                   	leave  
  8007fd:	c3                   	ret    

008007fe <cprintf>:

int cprintf(const char *fmt, ...) {
  8007fe:	55                   	push   %ebp
  8007ff:	89 e5                	mov    %esp,%ebp
  800801:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800804:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  80080b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	ff 75 f4             	pushl  -0xc(%ebp)
  80081a:	50                   	push   %eax
  80081b:	e8 73 ff ff ff       	call   800793 <vcprintf>
  800820:	83 c4 10             	add    $0x10,%esp
  800823:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800826:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800829:	c9                   	leave  
  80082a:	c3                   	ret    

0080082b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800831:	e8 f2 14 00 00       	call   801d28 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800836:	8d 45 0c             	lea    0xc(%ebp),%eax
  800839:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80083c:	8b 45 08             	mov    0x8(%ebp),%eax
  80083f:	83 ec 08             	sub    $0x8,%esp
  800842:	ff 75 f4             	pushl  -0xc(%ebp)
  800845:	50                   	push   %eax
  800846:	e8 48 ff ff ff       	call   800793 <vcprintf>
  80084b:	83 c4 10             	add    $0x10,%esp
  80084e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800851:	e8 ec 14 00 00       	call   801d42 <sys_enable_interrupt>
	return cnt;
  800856:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800859:	c9                   	leave  
  80085a:	c3                   	ret    

0080085b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80085b:	55                   	push   %ebp
  80085c:	89 e5                	mov    %esp,%ebp
  80085e:	53                   	push   %ebx
  80085f:	83 ec 14             	sub    $0x14,%esp
  800862:	8b 45 10             	mov    0x10(%ebp),%eax
  800865:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800868:	8b 45 14             	mov    0x14(%ebp),%eax
  80086b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80086e:	8b 45 18             	mov    0x18(%ebp),%eax
  800871:	ba 00 00 00 00       	mov    $0x0,%edx
  800876:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800879:	77 55                	ja     8008d0 <printnum+0x75>
  80087b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80087e:	72 05                	jb     800885 <printnum+0x2a>
  800880:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800883:	77 4b                	ja     8008d0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800885:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800888:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80088b:	8b 45 18             	mov    0x18(%ebp),%eax
  80088e:	ba 00 00 00 00       	mov    $0x0,%edx
  800893:	52                   	push   %edx
  800894:	50                   	push   %eax
  800895:	ff 75 f4             	pushl  -0xc(%ebp)
  800898:	ff 75 f0             	pushl  -0x10(%ebp)
  80089b:	e8 18 2b 00 00       	call   8033b8 <__udivdi3>
  8008a0:	83 c4 10             	add    $0x10,%esp
  8008a3:	83 ec 04             	sub    $0x4,%esp
  8008a6:	ff 75 20             	pushl  0x20(%ebp)
  8008a9:	53                   	push   %ebx
  8008aa:	ff 75 18             	pushl  0x18(%ebp)
  8008ad:	52                   	push   %edx
  8008ae:	50                   	push   %eax
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	ff 75 08             	pushl  0x8(%ebp)
  8008b5:	e8 a1 ff ff ff       	call   80085b <printnum>
  8008ba:	83 c4 20             	add    $0x20,%esp
  8008bd:	eb 1a                	jmp    8008d9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	ff 75 20             	pushl  0x20(%ebp)
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
  8008cd:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008d0:	ff 4d 1c             	decl   0x1c(%ebp)
  8008d3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008d7:	7f e6                	jg     8008bf <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008d9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008dc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e7:	53                   	push   %ebx
  8008e8:	51                   	push   %ecx
  8008e9:	52                   	push   %edx
  8008ea:	50                   	push   %eax
  8008eb:	e8 d8 2b 00 00       	call   8034c8 <__umoddi3>
  8008f0:	83 c4 10             	add    $0x10,%esp
  8008f3:	05 74 3e 80 00       	add    $0x803e74,%eax
  8008f8:	8a 00                	mov    (%eax),%al
  8008fa:	0f be c0             	movsbl %al,%eax
  8008fd:	83 ec 08             	sub    $0x8,%esp
  800900:	ff 75 0c             	pushl  0xc(%ebp)
  800903:	50                   	push   %eax
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	ff d0                	call   *%eax
  800909:	83 c4 10             	add    $0x10,%esp
}
  80090c:	90                   	nop
  80090d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800915:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800919:	7e 1c                	jle    800937 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	8b 00                	mov    (%eax),%eax
  800920:	8d 50 08             	lea    0x8(%eax),%edx
  800923:	8b 45 08             	mov    0x8(%ebp),%eax
  800926:	89 10                	mov    %edx,(%eax)
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	8b 00                	mov    (%eax),%eax
  80092d:	83 e8 08             	sub    $0x8,%eax
  800930:	8b 50 04             	mov    0x4(%eax),%edx
  800933:	8b 00                	mov    (%eax),%eax
  800935:	eb 40                	jmp    800977 <getuint+0x65>
	else if (lflag)
  800937:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80093b:	74 1e                	je     80095b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80093d:	8b 45 08             	mov    0x8(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	8d 50 04             	lea    0x4(%eax),%edx
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	89 10                	mov    %edx,(%eax)
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 00                	mov    (%eax),%eax
  80094f:	83 e8 04             	sub    $0x4,%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	ba 00 00 00 00       	mov    $0x0,%edx
  800959:	eb 1c                	jmp    800977 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	8b 00                	mov    (%eax),%eax
  800960:	8d 50 04             	lea    0x4(%eax),%edx
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	89 10                	mov    %edx,(%eax)
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8b 00                	mov    (%eax),%eax
  80096d:	83 e8 04             	sub    $0x4,%eax
  800970:	8b 00                	mov    (%eax),%eax
  800972:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800980:	7e 1c                	jle    80099e <getint+0x25>
		return va_arg(*ap, long long);
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 00                	mov    (%eax),%eax
  800987:	8d 50 08             	lea    0x8(%eax),%edx
  80098a:	8b 45 08             	mov    0x8(%ebp),%eax
  80098d:	89 10                	mov    %edx,(%eax)
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 00                	mov    (%eax),%eax
  800994:	83 e8 08             	sub    $0x8,%eax
  800997:	8b 50 04             	mov    0x4(%eax),%edx
  80099a:	8b 00                	mov    (%eax),%eax
  80099c:	eb 38                	jmp    8009d6 <getint+0x5d>
	else if (lflag)
  80099e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a2:	74 1a                	je     8009be <getint+0x45>
		return va_arg(*ap, long);
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	8d 50 04             	lea    0x4(%eax),%edx
  8009ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8009af:	89 10                	mov    %edx,(%eax)
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	8b 00                	mov    (%eax),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 00                	mov    (%eax),%eax
  8009bb:	99                   	cltd   
  8009bc:	eb 18                	jmp    8009d6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	8b 00                	mov    (%eax),%eax
  8009c3:	8d 50 04             	lea    0x4(%eax),%edx
  8009c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c9:	89 10                	mov    %edx,(%eax)
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	8b 00                	mov    (%eax),%eax
  8009d0:	83 e8 04             	sub    $0x4,%eax
  8009d3:	8b 00                	mov    (%eax),%eax
  8009d5:	99                   	cltd   
}
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009e0:	eb 17                	jmp    8009f9 <vprintfmt+0x21>
			if (ch == '\0')
  8009e2:	85 db                	test   %ebx,%ebx
  8009e4:	0f 84 af 03 00 00    	je     800d99 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	53                   	push   %ebx
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	8d 50 01             	lea    0x1(%eax),%edx
  8009ff:	89 55 10             	mov    %edx,0x10(%ebp)
  800a02:	8a 00                	mov    (%eax),%al
  800a04:	0f b6 d8             	movzbl %al,%ebx
  800a07:	83 fb 25             	cmp    $0x25,%ebx
  800a0a:	75 d6                	jne    8009e2 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a0c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a10:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a17:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a1e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2f:	8d 50 01             	lea    0x1(%eax),%edx
  800a32:	89 55 10             	mov    %edx,0x10(%ebp)
  800a35:	8a 00                	mov    (%eax),%al
  800a37:	0f b6 d8             	movzbl %al,%ebx
  800a3a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a3d:	83 f8 55             	cmp    $0x55,%eax
  800a40:	0f 87 2b 03 00 00    	ja     800d71 <vprintfmt+0x399>
  800a46:	8b 04 85 98 3e 80 00 	mov    0x803e98(,%eax,4),%eax
  800a4d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a4f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a53:	eb d7                	jmp    800a2c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a55:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a59:	eb d1                	jmp    800a2c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a5b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a62:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a65:	89 d0                	mov    %edx,%eax
  800a67:	c1 e0 02             	shl    $0x2,%eax
  800a6a:	01 d0                	add    %edx,%eax
  800a6c:	01 c0                	add    %eax,%eax
  800a6e:	01 d8                	add    %ebx,%eax
  800a70:	83 e8 30             	sub    $0x30,%eax
  800a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a76:	8b 45 10             	mov    0x10(%ebp),%eax
  800a79:	8a 00                	mov    (%eax),%al
  800a7b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a7e:	83 fb 2f             	cmp    $0x2f,%ebx
  800a81:	7e 3e                	jle    800ac1 <vprintfmt+0xe9>
  800a83:	83 fb 39             	cmp    $0x39,%ebx
  800a86:	7f 39                	jg     800ac1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a88:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a8b:	eb d5                	jmp    800a62 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 c0 04             	add    $0x4,%eax
  800a93:	89 45 14             	mov    %eax,0x14(%ebp)
  800a96:	8b 45 14             	mov    0x14(%ebp),%eax
  800a99:	83 e8 04             	sub    $0x4,%eax
  800a9c:	8b 00                	mov    (%eax),%eax
  800a9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800aa3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aa7:	79 83                	jns    800a2c <vprintfmt+0x54>
				width = 0;
  800aa9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ab0:	e9 77 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800ab5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800abc:	e9 6b ff ff ff       	jmp    800a2c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800ac1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac6:	0f 89 60 ff ff ff    	jns    800a2c <vprintfmt+0x54>
				width = precision, precision = -1;
  800acc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800acf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ad2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800ad9:	e9 4e ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ade:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ae1:	e9 46 ff ff ff       	jmp    800a2c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800ae6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae9:	83 c0 04             	add    $0x4,%eax
  800aec:	89 45 14             	mov    %eax,0x14(%ebp)
  800aef:	8b 45 14             	mov    0x14(%ebp),%eax
  800af2:	83 e8 04             	sub    $0x4,%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	83 ec 08             	sub    $0x8,%esp
  800afa:	ff 75 0c             	pushl  0xc(%ebp)
  800afd:	50                   	push   %eax
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			break;
  800b06:	e9 89 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 c0 04             	add    $0x4,%eax
  800b11:	89 45 14             	mov    %eax,0x14(%ebp)
  800b14:	8b 45 14             	mov    0x14(%ebp),%eax
  800b17:	83 e8 04             	sub    $0x4,%eax
  800b1a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b1c:	85 db                	test   %ebx,%ebx
  800b1e:	79 02                	jns    800b22 <vprintfmt+0x14a>
				err = -err;
  800b20:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b22:	83 fb 64             	cmp    $0x64,%ebx
  800b25:	7f 0b                	jg     800b32 <vprintfmt+0x15a>
  800b27:	8b 34 9d e0 3c 80 00 	mov    0x803ce0(,%ebx,4),%esi
  800b2e:	85 f6                	test   %esi,%esi
  800b30:	75 19                	jne    800b4b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b32:	53                   	push   %ebx
  800b33:	68 85 3e 80 00       	push   $0x803e85
  800b38:	ff 75 0c             	pushl  0xc(%ebp)
  800b3b:	ff 75 08             	pushl  0x8(%ebp)
  800b3e:	e8 5e 02 00 00       	call   800da1 <printfmt>
  800b43:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b46:	e9 49 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b4b:	56                   	push   %esi
  800b4c:	68 8e 3e 80 00       	push   $0x803e8e
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	ff 75 08             	pushl  0x8(%ebp)
  800b57:	e8 45 02 00 00       	call   800da1 <printfmt>
  800b5c:	83 c4 10             	add    $0x10,%esp
			break;
  800b5f:	e9 30 02 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b64:	8b 45 14             	mov    0x14(%ebp),%eax
  800b67:	83 c0 04             	add    $0x4,%eax
  800b6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b70:	83 e8 04             	sub    $0x4,%eax
  800b73:	8b 30                	mov    (%eax),%esi
  800b75:	85 f6                	test   %esi,%esi
  800b77:	75 05                	jne    800b7e <vprintfmt+0x1a6>
				p = "(null)";
  800b79:	be 91 3e 80 00       	mov    $0x803e91,%esi
			if (width > 0 && padc != '-')
  800b7e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b82:	7e 6d                	jle    800bf1 <vprintfmt+0x219>
  800b84:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b88:	74 67                	je     800bf1 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	50                   	push   %eax
  800b91:	56                   	push   %esi
  800b92:	e8 0c 03 00 00       	call   800ea3 <strnlen>
  800b97:	83 c4 10             	add    $0x10,%esp
  800b9a:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b9d:	eb 16                	jmp    800bb5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b9f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	50                   	push   %eax
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800bb2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bb5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bb9:	7f e4                	jg     800b9f <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bbb:	eb 34                	jmp    800bf1 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800bbd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800bc1:	74 1c                	je     800bdf <vprintfmt+0x207>
  800bc3:	83 fb 1f             	cmp    $0x1f,%ebx
  800bc6:	7e 05                	jle    800bcd <vprintfmt+0x1f5>
  800bc8:	83 fb 7e             	cmp    $0x7e,%ebx
  800bcb:	7e 12                	jle    800bdf <vprintfmt+0x207>
					putch('?', putdat);
  800bcd:	83 ec 08             	sub    $0x8,%esp
  800bd0:	ff 75 0c             	pushl  0xc(%ebp)
  800bd3:	6a 3f                	push   $0x3f
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	ff d0                	call   *%eax
  800bda:	83 c4 10             	add    $0x10,%esp
  800bdd:	eb 0f                	jmp    800bee <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bdf:	83 ec 08             	sub    $0x8,%esp
  800be2:	ff 75 0c             	pushl  0xc(%ebp)
  800be5:	53                   	push   %ebx
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	ff d0                	call   *%eax
  800beb:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bee:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf1:	89 f0                	mov    %esi,%eax
  800bf3:	8d 70 01             	lea    0x1(%eax),%esi
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	0f be d8             	movsbl %al,%ebx
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	74 24                	je     800c23 <vprintfmt+0x24b>
  800bff:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c03:	78 b8                	js     800bbd <vprintfmt+0x1e5>
  800c05:	ff 4d e0             	decl   -0x20(%ebp)
  800c08:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c0c:	79 af                	jns    800bbd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c0e:	eb 13                	jmp    800c23 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 20                	push   $0x20
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c20:	ff 4d e4             	decl   -0x1c(%ebp)
  800c23:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c27:	7f e7                	jg     800c10 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c29:	e9 66 01 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c2e:	83 ec 08             	sub    $0x8,%esp
  800c31:	ff 75 e8             	pushl  -0x18(%ebp)
  800c34:	8d 45 14             	lea    0x14(%ebp),%eax
  800c37:	50                   	push   %eax
  800c38:	e8 3c fd ff ff       	call   800979 <getint>
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c43:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c4c:	85 d2                	test   %edx,%edx
  800c4e:	79 23                	jns    800c73 <vprintfmt+0x29b>
				putch('-', putdat);
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	6a 2d                	push   $0x2d
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	ff d0                	call   *%eax
  800c5d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c66:	f7 d8                	neg    %eax
  800c68:	83 d2 00             	adc    $0x0,%edx
  800c6b:	f7 da                	neg    %edx
  800c6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c7a:	e9 bc 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c7f:	83 ec 08             	sub    $0x8,%esp
  800c82:	ff 75 e8             	pushl  -0x18(%ebp)
  800c85:	8d 45 14             	lea    0x14(%ebp),%eax
  800c88:	50                   	push   %eax
  800c89:	e8 84 fc ff ff       	call   800912 <getuint>
  800c8e:	83 c4 10             	add    $0x10,%esp
  800c91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c97:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c9e:	e9 98 00 00 00       	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ca3:	83 ec 08             	sub    $0x8,%esp
  800ca6:	ff 75 0c             	pushl  0xc(%ebp)
  800ca9:	6a 58                	push   $0x58
  800cab:	8b 45 08             	mov    0x8(%ebp),%eax
  800cae:	ff d0                	call   *%eax
  800cb0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cb3:	83 ec 08             	sub    $0x8,%esp
  800cb6:	ff 75 0c             	pushl  0xc(%ebp)
  800cb9:	6a 58                	push   $0x58
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	ff d0                	call   *%eax
  800cc0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800cc3:	83 ec 08             	sub    $0x8,%esp
  800cc6:	ff 75 0c             	pushl  0xc(%ebp)
  800cc9:	6a 58                	push   $0x58
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	ff d0                	call   *%eax
  800cd0:	83 c4 10             	add    $0x10,%esp
			break;
  800cd3:	e9 bc 00 00 00       	jmp    800d94 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cd8:	83 ec 08             	sub    $0x8,%esp
  800cdb:	ff 75 0c             	pushl  0xc(%ebp)
  800cde:	6a 30                	push   $0x30
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	ff d0                	call   *%eax
  800ce5:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	ff 75 0c             	pushl  0xc(%ebp)
  800cee:	6a 78                	push   $0x78
  800cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf3:	ff d0                	call   *%eax
  800cf5:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfb:	83 c0 04             	add    $0x4,%eax
  800cfe:	89 45 14             	mov    %eax,0x14(%ebp)
  800d01:	8b 45 14             	mov    0x14(%ebp),%eax
  800d04:	83 e8 04             	sub    $0x4,%eax
  800d07:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d0c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d1a:	eb 1f                	jmp    800d3b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d1c:	83 ec 08             	sub    $0x8,%esp
  800d1f:	ff 75 e8             	pushl  -0x18(%ebp)
  800d22:	8d 45 14             	lea    0x14(%ebp),%eax
  800d25:	50                   	push   %eax
  800d26:	e8 e7 fb ff ff       	call   800912 <getuint>
  800d2b:	83 c4 10             	add    $0x10,%esp
  800d2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d31:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d34:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d3b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	52                   	push   %edx
  800d46:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d49:	50                   	push   %eax
  800d4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800d4d:	ff 75 f0             	pushl  -0x10(%ebp)
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	ff 75 08             	pushl  0x8(%ebp)
  800d56:	e8 00 fb ff ff       	call   80085b <printnum>
  800d5b:	83 c4 20             	add    $0x20,%esp
			break;
  800d5e:	eb 34                	jmp    800d94 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d60:	83 ec 08             	sub    $0x8,%esp
  800d63:	ff 75 0c             	pushl  0xc(%ebp)
  800d66:	53                   	push   %ebx
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	ff d0                	call   *%eax
  800d6c:	83 c4 10             	add    $0x10,%esp
			break;
  800d6f:	eb 23                	jmp    800d94 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d71:	83 ec 08             	sub    $0x8,%esp
  800d74:	ff 75 0c             	pushl  0xc(%ebp)
  800d77:	6a 25                	push   $0x25
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	ff d0                	call   *%eax
  800d7e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d81:	ff 4d 10             	decl   0x10(%ebp)
  800d84:	eb 03                	jmp    800d89 <vprintfmt+0x3b1>
  800d86:	ff 4d 10             	decl   0x10(%ebp)
  800d89:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8c:	48                   	dec    %eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	3c 25                	cmp    $0x25,%al
  800d91:	75 f3                	jne    800d86 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d93:	90                   	nop
		}
	}
  800d94:	e9 47 fc ff ff       	jmp    8009e0 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d99:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d9d:	5b                   	pop    %ebx
  800d9e:	5e                   	pop    %esi
  800d9f:	5d                   	pop    %ebp
  800da0:	c3                   	ret    

00800da1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800da1:	55                   	push   %ebp
  800da2:	89 e5                	mov    %esp,%ebp
  800da4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800da7:	8d 45 10             	lea    0x10(%ebp),%eax
  800daa:	83 c0 04             	add    $0x4,%eax
  800dad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	ff 75 f4             	pushl  -0xc(%ebp)
  800db6:	50                   	push   %eax
  800db7:	ff 75 0c             	pushl  0xc(%ebp)
  800dba:	ff 75 08             	pushl  0x8(%ebp)
  800dbd:	e8 16 fc ff ff       	call   8009d8 <vprintfmt>
  800dc2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800dc5:	90                   	nop
  800dc6:	c9                   	leave  
  800dc7:	c3                   	ret    

00800dc8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800dc8:	55                   	push   %ebp
  800dc9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	8b 40 08             	mov    0x8(%eax),%eax
  800dd1:	8d 50 01             	lea    0x1(%eax),%edx
  800dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddd:	8b 10                	mov    (%eax),%edx
  800ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de2:	8b 40 04             	mov    0x4(%eax),%eax
  800de5:	39 c2                	cmp    %eax,%edx
  800de7:	73 12                	jae    800dfb <sprintputch+0x33>
		*b->buf++ = ch;
  800de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dec:	8b 00                	mov    (%eax),%eax
  800dee:	8d 48 01             	lea    0x1(%eax),%ecx
  800df1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800df4:	89 0a                	mov    %ecx,(%edx)
  800df6:	8b 55 08             	mov    0x8(%ebp),%edx
  800df9:	88 10                	mov    %dl,(%eax)
}
  800dfb:	90                   	nop
  800dfc:	5d                   	pop    %ebp
  800dfd:	c3                   	ret    

00800dfe <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	01 d0                	add    %edx,%eax
  800e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e1f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e23:	74 06                	je     800e2b <vsnprintf+0x2d>
  800e25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e29:	7f 07                	jg     800e32 <vsnprintf+0x34>
		return -E_INVAL;
  800e2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800e30:	eb 20                	jmp    800e52 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e32:	ff 75 14             	pushl  0x14(%ebp)
  800e35:	ff 75 10             	pushl  0x10(%ebp)
  800e38:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e3b:	50                   	push   %eax
  800e3c:	68 c8 0d 80 00       	push   $0x800dc8
  800e41:	e8 92 fb ff ff       	call   8009d8 <vprintfmt>
  800e46:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e4c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e5a:	8d 45 10             	lea    0x10(%ebp),%eax
  800e5d:	83 c0 04             	add    $0x4,%eax
  800e60:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	ff 75 f4             	pushl  -0xc(%ebp)
  800e69:	50                   	push   %eax
  800e6a:	ff 75 0c             	pushl  0xc(%ebp)
  800e6d:	ff 75 08             	pushl  0x8(%ebp)
  800e70:	e8 89 ff ff ff       	call   800dfe <vsnprintf>
  800e75:	83 c4 10             	add    $0x10,%esp
  800e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e7e:	c9                   	leave  
  800e7f:	c3                   	ret    

00800e80 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
  800e83:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e8d:	eb 06                	jmp    800e95 <strlen+0x15>
		n++;
  800e8f:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e92:	ff 45 08             	incl   0x8(%ebp)
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 f1                	jne    800e8f <strlen+0xf>
		n++;
	return n;
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eb0:	eb 09                	jmp    800ebb <strnlen+0x18>
		n++;
  800eb2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800eb5:	ff 45 08             	incl   0x8(%ebp)
  800eb8:	ff 4d 0c             	decl   0xc(%ebp)
  800ebb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ebf:	74 09                	je     800eca <strnlen+0x27>
  800ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec4:	8a 00                	mov    (%eax),%al
  800ec6:	84 c0                	test   %al,%al
  800ec8:	75 e8                	jne    800eb2 <strnlen+0xf>
		n++;
	return n;
  800eca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800edb:	90                   	nop
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8d 50 01             	lea    0x1(%eax),%edx
  800ee2:	89 55 08             	mov    %edx,0x8(%ebp)
  800ee5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eeb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800eee:	8a 12                	mov    (%edx),%dl
  800ef0:	88 10                	mov    %dl,(%eax)
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	84 c0                	test   %al,%al
  800ef6:	75 e4                	jne    800edc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800efb:	c9                   	leave  
  800efc:	c3                   	ret    

00800efd <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800efd:	55                   	push   %ebp
  800efe:	89 e5                	mov    %esp,%ebp
  800f00:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f03:	8b 45 08             	mov    0x8(%ebp),%eax
  800f06:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f09:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f10:	eb 1f                	jmp    800f31 <strncpy+0x34>
		*dst++ = *src;
  800f12:	8b 45 08             	mov    0x8(%ebp),%eax
  800f15:	8d 50 01             	lea    0x1(%eax),%edx
  800f18:	89 55 08             	mov    %edx,0x8(%ebp)
  800f1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1e:	8a 12                	mov    (%edx),%dl
  800f20:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f25:	8a 00                	mov    (%eax),%al
  800f27:	84 c0                	test   %al,%al
  800f29:	74 03                	je     800f2e <strncpy+0x31>
			src++;
  800f2b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f2e:	ff 45 fc             	incl   -0x4(%ebp)
  800f31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f34:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f37:	72 d9                	jb     800f12 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f39:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f44:	8b 45 08             	mov    0x8(%ebp),%eax
  800f47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f4e:	74 30                	je     800f80 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f50:	eb 16                	jmp    800f68 <strlcpy+0x2a>
			*dst++ = *src++;
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8d 50 01             	lea    0x1(%eax),%edx
  800f58:	89 55 08             	mov    %edx,0x8(%ebp)
  800f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f61:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f64:	8a 12                	mov    (%edx),%dl
  800f66:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f68:	ff 4d 10             	decl   0x10(%ebp)
  800f6b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6f:	74 09                	je     800f7a <strlcpy+0x3c>
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8a 00                	mov    (%eax),%al
  800f76:	84 c0                	test   %al,%al
  800f78:	75 d8                	jne    800f52 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f80:	8b 55 08             	mov    0x8(%ebp),%edx
  800f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f86:	29 c2                	sub    %eax,%edx
  800f88:	89 d0                	mov    %edx,%eax
}
  800f8a:	c9                   	leave  
  800f8b:	c3                   	ret    

00800f8c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f8f:	eb 06                	jmp    800f97 <strcmp+0xb>
		p++, q++;
  800f91:	ff 45 08             	incl   0x8(%ebp)
  800f94:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	84 c0                	test   %al,%al
  800f9e:	74 0e                	je     800fae <strcmp+0x22>
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 10                	mov    (%eax),%dl
  800fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa8:	8a 00                	mov    (%eax),%al
  800faa:	38 c2                	cmp    %al,%dl
  800fac:	74 e3                	je     800f91 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800fae:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	0f b6 d0             	movzbl %al,%edx
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	0f b6 c0             	movzbl %al,%eax
  800fbe:	29 c2                	sub    %eax,%edx
  800fc0:	89 d0                	mov    %edx,%eax
}
  800fc2:	5d                   	pop    %ebp
  800fc3:	c3                   	ret    

00800fc4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800fc4:	55                   	push   %ebp
  800fc5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800fc7:	eb 09                	jmp    800fd2 <strncmp+0xe>
		n--, p++, q++;
  800fc9:	ff 4d 10             	decl   0x10(%ebp)
  800fcc:	ff 45 08             	incl   0x8(%ebp)
  800fcf:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fd2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd6:	74 17                	je     800fef <strncmp+0x2b>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	84 c0                	test   %al,%al
  800fdf:	74 0e                	je     800fef <strncmp+0x2b>
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 10                	mov    (%eax),%dl
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8a 00                	mov    (%eax),%al
  800feb:	38 c2                	cmp    %al,%dl
  800fed:	74 da                	je     800fc9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ff3:	75 07                	jne    800ffc <strncmp+0x38>
		return 0;
  800ff5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ffa:	eb 14                	jmp    801010 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	0f b6 d0             	movzbl %al,%edx
  801004:	8b 45 0c             	mov    0xc(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	0f b6 c0             	movzbl %al,%eax
  80100c:	29 c2                	sub    %eax,%edx
  80100e:	89 d0                	mov    %edx,%eax
}
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
  801015:	83 ec 04             	sub    $0x4,%esp
  801018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80101e:	eb 12                	jmp    801032 <strchr+0x20>
		if (*s == c)
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801028:	75 05                	jne    80102f <strchr+0x1d>
			return (char *) s;
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	eb 11                	jmp    801040 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80102f:	ff 45 08             	incl   0x8(%ebp)
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	84 c0                	test   %al,%al
  801039:	75 e5                	jne    801020 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80103b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 04             	sub    $0x4,%esp
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80104e:	eb 0d                	jmp    80105d <strfind+0x1b>
		if (*s == c)
  801050:	8b 45 08             	mov    0x8(%ebp),%eax
  801053:	8a 00                	mov    (%eax),%al
  801055:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801058:	74 0e                	je     801068 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	84 c0                	test   %al,%al
  801064:	75 ea                	jne    801050 <strfind+0xe>
  801066:	eb 01                	jmp    801069 <strfind+0x27>
		if (*s == c)
			break;
  801068:	90                   	nop
	return (char *) s;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80106c:	c9                   	leave  
  80106d:	c3                   	ret    

0080106e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80106e:	55                   	push   %ebp
  80106f:	89 e5                	mov    %esp,%ebp
  801071:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80107a:	8b 45 10             	mov    0x10(%ebp),%eax
  80107d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801080:	eb 0e                	jmp    801090 <memset+0x22>
		*p++ = c;
  801082:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801085:	8d 50 01             	lea    0x1(%eax),%edx
  801088:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80108b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108e:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801090:	ff 4d f8             	decl   -0x8(%ebp)
  801093:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801097:	79 e9                	jns    801082 <memset+0x14>
		*p++ = c;

	return v;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80109c:	c9                   	leave  
  80109d:	c3                   	ret    

0080109e <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8010b0:	eb 16                	jmp    8010c8 <memcpy+0x2a>
		*d++ = *s++;
  8010b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b5:	8d 50 01             	lea    0x1(%eax),%edx
  8010b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010be:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010c1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010c4:	8a 12                	mov    (%edx),%dl
  8010c6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8010c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ce:	89 55 10             	mov    %edx,0x10(%ebp)
  8010d1:	85 c0                	test   %eax,%eax
  8010d3:	75 dd                	jne    8010b2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010d5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d8:	c9                   	leave  
  8010d9:	c3                   	ret    

008010da <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ef:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010f2:	73 50                	jae    801144 <memmove+0x6a>
  8010f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8010fa:	01 d0                	add    %edx,%eax
  8010fc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010ff:	76 43                	jbe    801144 <memmove+0x6a>
		s += n;
  801101:	8b 45 10             	mov    0x10(%ebp),%eax
  801104:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801107:	8b 45 10             	mov    0x10(%ebp),%eax
  80110a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80110d:	eb 10                	jmp    80111f <memmove+0x45>
			*--d = *--s;
  80110f:	ff 4d f8             	decl   -0x8(%ebp)
  801112:	ff 4d fc             	decl   -0x4(%ebp)
  801115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801118:	8a 10                	mov    (%eax),%dl
  80111a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80111f:	8b 45 10             	mov    0x10(%ebp),%eax
  801122:	8d 50 ff             	lea    -0x1(%eax),%edx
  801125:	89 55 10             	mov    %edx,0x10(%ebp)
  801128:	85 c0                	test   %eax,%eax
  80112a:	75 e3                	jne    80110f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80112c:	eb 23                	jmp    801151 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801131:	8d 50 01             	lea    0x1(%eax),%edx
  801134:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801137:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80113a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801140:	8a 12                	mov    (%edx),%dl
  801142:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801144:	8b 45 10             	mov    0x10(%ebp),%eax
  801147:	8d 50 ff             	lea    -0x1(%eax),%edx
  80114a:	89 55 10             	mov    %edx,0x10(%ebp)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	75 dd                	jne    80112e <memmove+0x54>
			*d++ = *s++;

	return dst;
  801151:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80115c:	8b 45 08             	mov    0x8(%ebp),%eax
  80115f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801162:	8b 45 0c             	mov    0xc(%ebp),%eax
  801165:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801168:	eb 2a                	jmp    801194 <memcmp+0x3e>
		if (*s1 != *s2)
  80116a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80116d:	8a 10                	mov    (%eax),%dl
  80116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	38 c2                	cmp    %al,%dl
  801176:	74 16                	je     80118e <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	0f b6 d0             	movzbl %al,%edx
  801180:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f b6 c0             	movzbl %al,%eax
  801188:	29 c2                	sub    %eax,%edx
  80118a:	89 d0                	mov    %edx,%eax
  80118c:	eb 18                	jmp    8011a6 <memcmp+0x50>
		s1++, s2++;
  80118e:	ff 45 fc             	incl   -0x4(%ebp)
  801191:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801194:	8b 45 10             	mov    0x10(%ebp),%eax
  801197:	8d 50 ff             	lea    -0x1(%eax),%edx
  80119a:	89 55 10             	mov    %edx,0x10(%ebp)
  80119d:	85 c0                	test   %eax,%eax
  80119f:	75 c9                	jne    80116a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8011a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 d0                	add    %edx,%eax
  8011b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  8011b9:	eb 15                	jmp    8011d0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  8011bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	0f b6 d0             	movzbl %al,%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	0f b6 c0             	movzbl %al,%eax
  8011c9:	39 c2                	cmp    %eax,%edx
  8011cb:	74 0d                	je     8011da <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011cd:	ff 45 08             	incl   0x8(%ebp)
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011d6:	72 e3                	jb     8011bb <memfind+0x13>
  8011d8:	eb 01                	jmp    8011db <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011da:	90                   	nop
	return (void *) s;
  8011db:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011de:	c9                   	leave  
  8011df:	c3                   	ret    

008011e0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011ed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f4:	eb 03                	jmp    8011f9 <strtol+0x19>
		s++;
  8011f6:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	3c 20                	cmp    $0x20,%al
  801200:	74 f4                	je     8011f6 <strtol+0x16>
  801202:	8b 45 08             	mov    0x8(%ebp),%eax
  801205:	8a 00                	mov    (%eax),%al
  801207:	3c 09                	cmp    $0x9,%al
  801209:	74 eb                	je     8011f6 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 2b                	cmp    $0x2b,%al
  801212:	75 05                	jne    801219 <strtol+0x39>
		s++;
  801214:	ff 45 08             	incl   0x8(%ebp)
  801217:	eb 13                	jmp    80122c <strtol+0x4c>
	else if (*s == '-')
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	8a 00                	mov    (%eax),%al
  80121e:	3c 2d                	cmp    $0x2d,%al
  801220:	75 0a                	jne    80122c <strtol+0x4c>
		s++, neg = 1;
  801222:	ff 45 08             	incl   0x8(%ebp)
  801225:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80122c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801230:	74 06                	je     801238 <strtol+0x58>
  801232:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801236:	75 20                	jne    801258 <strtol+0x78>
  801238:	8b 45 08             	mov    0x8(%ebp),%eax
  80123b:	8a 00                	mov    (%eax),%al
  80123d:	3c 30                	cmp    $0x30,%al
  80123f:	75 17                	jne    801258 <strtol+0x78>
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	40                   	inc    %eax
  801245:	8a 00                	mov    (%eax),%al
  801247:	3c 78                	cmp    $0x78,%al
  801249:	75 0d                	jne    801258 <strtol+0x78>
		s += 2, base = 16;
  80124b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80124f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801256:	eb 28                	jmp    801280 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801258:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80125c:	75 15                	jne    801273 <strtol+0x93>
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 30                	cmp    $0x30,%al
  801265:	75 0c                	jne    801273 <strtol+0x93>
		s++, base = 8;
  801267:	ff 45 08             	incl   0x8(%ebp)
  80126a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801271:	eb 0d                	jmp    801280 <strtol+0xa0>
	else if (base == 0)
  801273:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801277:	75 07                	jne    801280 <strtol+0xa0>
		base = 10;
  801279:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801280:	8b 45 08             	mov    0x8(%ebp),%eax
  801283:	8a 00                	mov    (%eax),%al
  801285:	3c 2f                	cmp    $0x2f,%al
  801287:	7e 19                	jle    8012a2 <strtol+0xc2>
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	3c 39                	cmp    $0x39,%al
  801290:	7f 10                	jg     8012a2 <strtol+0xc2>
			dig = *s - '0';
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	83 e8 30             	sub    $0x30,%eax
  80129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012a0:	eb 42                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8a 00                	mov    (%eax),%al
  8012a7:	3c 60                	cmp    $0x60,%al
  8012a9:	7e 19                	jle    8012c4 <strtol+0xe4>
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	8a 00                	mov    (%eax),%al
  8012b0:	3c 7a                	cmp    $0x7a,%al
  8012b2:	7f 10                	jg     8012c4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	0f be c0             	movsbl %al,%eax
  8012bc:	83 e8 57             	sub    $0x57,%eax
  8012bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8012c2:	eb 20                	jmp    8012e4 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8a 00                	mov    (%eax),%al
  8012c9:	3c 40                	cmp    $0x40,%al
  8012cb:	7e 39                	jle    801306 <strtol+0x126>
  8012cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d0:	8a 00                	mov    (%eax),%al
  8012d2:	3c 5a                	cmp    $0x5a,%al
  8012d4:	7f 30                	jg     801306 <strtol+0x126>
			dig = *s - 'A' + 10;
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	8a 00                	mov    (%eax),%al
  8012db:	0f be c0             	movsbl %al,%eax
  8012de:	83 e8 37             	sub    $0x37,%eax
  8012e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012e7:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012ea:	7d 19                	jge    801305 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012ec:	ff 45 08             	incl   0x8(%ebp)
  8012ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f2:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fb:	01 d0                	add    %edx,%eax
  8012fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801300:	e9 7b ff ff ff       	jmp    801280 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801305:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801306:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80130a:	74 08                	je     801314 <strtol+0x134>
		*endptr = (char *) s;
  80130c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130f:	8b 55 08             	mov    0x8(%ebp),%edx
  801312:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801314:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801318:	74 07                	je     801321 <strtol+0x141>
  80131a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131d:	f7 d8                	neg    %eax
  80131f:	eb 03                	jmp    801324 <strtol+0x144>
  801321:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801324:	c9                   	leave  
  801325:	c3                   	ret    

00801326 <ltostr>:

void
ltostr(long value, char *str)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80132c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801333:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80133a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80133e:	79 13                	jns    801353 <ltostr+0x2d>
	{
		neg = 1;
  801340:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80134a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80134d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801350:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80135b:	99                   	cltd   
  80135c:	f7 f9                	idiv   %ecx
  80135e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801361:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	83 c2 30             	add    $0x30,%edx
  801377:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801381:	f7 e9                	imul   %ecx
  801383:	c1 fa 02             	sar    $0x2,%edx
  801386:	89 c8                	mov    %ecx,%eax
  801388:	c1 f8 1f             	sar    $0x1f,%eax
  80138b:	29 c2                	sub    %eax,%edx
  80138d:	89 d0                	mov    %edx,%eax
  80138f:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801392:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801395:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80139a:	f7 e9                	imul   %ecx
  80139c:	c1 fa 02             	sar    $0x2,%edx
  80139f:	89 c8                	mov    %ecx,%eax
  8013a1:	c1 f8 1f             	sar    $0x1f,%eax
  8013a4:	29 c2                	sub    %eax,%edx
  8013a6:	89 d0                	mov    %edx,%eax
  8013a8:	c1 e0 02             	shl    $0x2,%eax
  8013ab:	01 d0                	add    %edx,%eax
  8013ad:	01 c0                	add    %eax,%eax
  8013af:	29 c1                	sub    %eax,%ecx
  8013b1:	89 ca                	mov    %ecx,%edx
  8013b3:	85 d2                	test   %edx,%edx
  8013b5:	75 9c                	jne    801353 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8013b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8013be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c1:	48                   	dec    %eax
  8013c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8013c5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8013c9:	74 3d                	je     801408 <ltostr+0xe2>
		start = 1 ;
  8013cb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013d2:	eb 34                	jmp    801408 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013da:	01 d0                	add    %edx,%eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e7:	01 c2                	add    %eax,%edx
  8013e9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ef:	01 c8                	add    %ecx,%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fb:	01 c2                	add    %eax,%edx
  8013fd:	8a 45 eb             	mov    -0x15(%ebp),%al
  801400:	88 02                	mov    %al,(%edx)
		start++ ;
  801402:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801405:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80140e:	7c c4                	jl     8013d4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801410:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801413:	8b 45 0c             	mov    0xc(%ebp),%eax
  801416:	01 d0                	add    %edx,%eax
  801418:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80141b:	90                   	nop
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801424:	ff 75 08             	pushl  0x8(%ebp)
  801427:	e8 54 fa ff ff       	call   800e80 <strlen>
  80142c:	83 c4 04             	add    $0x4,%esp
  80142f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801432:	ff 75 0c             	pushl  0xc(%ebp)
  801435:	e8 46 fa ff ff       	call   800e80 <strlen>
  80143a:	83 c4 04             	add    $0x4,%esp
  80143d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801447:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80144e:	eb 17                	jmp    801467 <strcconcat+0x49>
		final[s] = str1[s] ;
  801450:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801453:	8b 45 10             	mov    0x10(%ebp),%eax
  801456:	01 c2                	add    %eax,%edx
  801458:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	01 c8                	add    %ecx,%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801464:	ff 45 fc             	incl   -0x4(%ebp)
  801467:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80146a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80146d:	7c e1                	jl     801450 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80146f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801476:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80147d:	eb 1f                	jmp    80149e <strcconcat+0x80>
		final[s++] = str2[i] ;
  80147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801482:	8d 50 01             	lea    0x1(%eax),%edx
  801485:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801488:	89 c2                	mov    %eax,%edx
  80148a:	8b 45 10             	mov    0x10(%ebp),%eax
  80148d:	01 c2                	add    %eax,%edx
  80148f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	01 c8                	add    %ecx,%eax
  801497:	8a 00                	mov    (%eax),%al
  801499:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80149b:	ff 45 f8             	incl   -0x8(%ebp)
  80149e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8014a4:	7c d9                	jl     80147f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8014a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ac:	01 d0                	add    %edx,%eax
  8014ae:	c6 00 00             	movb   $0x0,(%eax)
}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8014b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8014c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c3:	8b 00                	mov    (%eax),%eax
  8014c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014d7:	eb 0c                	jmp    8014e5 <strsplit+0x31>
			*string++ = 0;
  8014d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dc:	8d 50 01             	lea    0x1(%eax),%edx
  8014df:	89 55 08             	mov    %edx,0x8(%ebp)
  8014e2:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	84 c0                	test   %al,%al
  8014ec:	74 18                	je     801506 <strsplit+0x52>
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 00                	mov    (%eax),%al
  8014f3:	0f be c0             	movsbl %al,%eax
  8014f6:	50                   	push   %eax
  8014f7:	ff 75 0c             	pushl  0xc(%ebp)
  8014fa:	e8 13 fb ff ff       	call   801012 <strchr>
  8014ff:	83 c4 08             	add    $0x8,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	75 d3                	jne    8014d9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	8a 00                	mov    (%eax),%al
  80150b:	84 c0                	test   %al,%al
  80150d:	74 5a                	je     801569 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80150f:	8b 45 14             	mov    0x14(%ebp),%eax
  801512:	8b 00                	mov    (%eax),%eax
  801514:	83 f8 0f             	cmp    $0xf,%eax
  801517:	75 07                	jne    801520 <strsplit+0x6c>
		{
			return 0;
  801519:	b8 00 00 00 00       	mov    $0x0,%eax
  80151e:	eb 66                	jmp    801586 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801520:	8b 45 14             	mov    0x14(%ebp),%eax
  801523:	8b 00                	mov    (%eax),%eax
  801525:	8d 48 01             	lea    0x1(%eax),%ecx
  801528:	8b 55 14             	mov    0x14(%ebp),%edx
  80152b:	89 0a                	mov    %ecx,(%edx)
  80152d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801534:	8b 45 10             	mov    0x10(%ebp),%eax
  801537:	01 c2                	add    %eax,%edx
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80153e:	eb 03                	jmp    801543 <strsplit+0x8f>
			string++;
  801540:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801543:	8b 45 08             	mov    0x8(%ebp),%eax
  801546:	8a 00                	mov    (%eax),%al
  801548:	84 c0                	test   %al,%al
  80154a:	74 8b                	je     8014d7 <strsplit+0x23>
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	8a 00                	mov    (%eax),%al
  801551:	0f be c0             	movsbl %al,%eax
  801554:	50                   	push   %eax
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	e8 b5 fa ff ff       	call   801012 <strchr>
  80155d:	83 c4 08             	add    $0x8,%esp
  801560:	85 c0                	test   %eax,%eax
  801562:	74 dc                	je     801540 <strsplit+0x8c>
			string++;
	}
  801564:	e9 6e ff ff ff       	jmp    8014d7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801569:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80156a:	8b 45 14             	mov    0x14(%ebp),%eax
  80156d:	8b 00                	mov    (%eax),%eax
  80156f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	01 d0                	add    %edx,%eax
  80157b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801581:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80158e:	a1 04 50 80 00       	mov    0x805004,%eax
  801593:	85 c0                	test   %eax,%eax
  801595:	74 1f                	je     8015b6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801597:	e8 1d 00 00 00       	call   8015b9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	68 f0 3f 80 00       	push   $0x803ff0
  8015a4:	e8 55 f2 ff ff       	call   8007fe <cprintf>
  8015a9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8015ac:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  8015b3:	00 00 00 
	}
}
  8015b6:	90                   	nop
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8015bf:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8015c6:	00 00 00 
  8015c9:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8015d0:	00 00 00 
  8015d3:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8015da:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8015dd:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8015e4:	00 00 00 
  8015e7:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8015ee:	00 00 00 
  8015f1:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8015f8:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8015fb:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801605:	c1 e8 0c             	shr    $0xc,%eax
  801608:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80160d:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80161c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801621:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801626:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80162d:	a1 20 51 80 00       	mov    0x805120,%eax
  801632:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801636:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801639:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801640:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801646:	01 d0                	add    %edx,%eax
  801648:	48                   	dec    %eax
  801649:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80164c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80164f:	ba 00 00 00 00       	mov    $0x0,%edx
  801654:	f7 75 e4             	divl   -0x1c(%ebp)
  801657:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80165a:	29 d0                	sub    %edx,%eax
  80165c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  80165f:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801666:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801669:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80166e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	6a 07                	push   $0x7
  801678:	ff 75 e8             	pushl  -0x18(%ebp)
  80167b:	50                   	push   %eax
  80167c:	e8 3d 06 00 00       	call   801cbe <sys_allocate_chunk>
  801681:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801684:	a1 20 51 80 00       	mov    0x805120,%eax
  801689:	83 ec 0c             	sub    $0xc,%esp
  80168c:	50                   	push   %eax
  80168d:	e8 b2 0c 00 00       	call   802344 <initialize_MemBlocksList>
  801692:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801695:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80169a:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  80169d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8016a1:	0f 84 f3 00 00 00    	je     80179a <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8016a7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8016ab:	75 14                	jne    8016c1 <initialize_dyn_block_system+0x108>
  8016ad:	83 ec 04             	sub    $0x4,%esp
  8016b0:	68 15 40 80 00       	push   $0x804015
  8016b5:	6a 36                	push   $0x36
  8016b7:	68 33 40 80 00       	push   $0x804033
  8016bc:	e8 89 ee ff ff       	call   80054a <_panic>
  8016c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016c4:	8b 00                	mov    (%eax),%eax
  8016c6:	85 c0                	test   %eax,%eax
  8016c8:	74 10                	je     8016da <initialize_dyn_block_system+0x121>
  8016ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016cd:	8b 00                	mov    (%eax),%eax
  8016cf:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016d2:	8b 52 04             	mov    0x4(%edx),%edx
  8016d5:	89 50 04             	mov    %edx,0x4(%eax)
  8016d8:	eb 0b                	jmp    8016e5 <initialize_dyn_block_system+0x12c>
  8016da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016dd:	8b 40 04             	mov    0x4(%eax),%eax
  8016e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8016e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016e8:	8b 40 04             	mov    0x4(%eax),%eax
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	74 0f                	je     8016fe <initialize_dyn_block_system+0x145>
  8016ef:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016f2:	8b 40 04             	mov    0x4(%eax),%eax
  8016f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016f8:	8b 12                	mov    (%edx),%edx
  8016fa:	89 10                	mov    %edx,(%eax)
  8016fc:	eb 0a                	jmp    801708 <initialize_dyn_block_system+0x14f>
  8016fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801701:	8b 00                	mov    (%eax),%eax
  801703:	a3 48 51 80 00       	mov    %eax,0x805148
  801708:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80170b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801711:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801714:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80171b:	a1 54 51 80 00       	mov    0x805154,%eax
  801720:	48                   	dec    %eax
  801721:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801726:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801729:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801730:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801733:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80173a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80173e:	75 14                	jne    801754 <initialize_dyn_block_system+0x19b>
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	68 40 40 80 00       	push   $0x804040
  801748:	6a 3e                	push   $0x3e
  80174a:	68 33 40 80 00       	push   $0x804033
  80174f:	e8 f6 ed ff ff       	call   80054a <_panic>
  801754:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80175a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80175d:	89 10                	mov    %edx,(%eax)
  80175f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801762:	8b 00                	mov    (%eax),%eax
  801764:	85 c0                	test   %eax,%eax
  801766:	74 0d                	je     801775 <initialize_dyn_block_system+0x1bc>
  801768:	a1 38 51 80 00       	mov    0x805138,%eax
  80176d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801770:	89 50 04             	mov    %edx,0x4(%eax)
  801773:	eb 08                	jmp    80177d <initialize_dyn_block_system+0x1c4>
  801775:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801778:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80177d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801780:	a3 38 51 80 00       	mov    %eax,0x805138
  801785:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801788:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80178f:	a1 44 51 80 00       	mov    0x805144,%eax
  801794:	40                   	inc    %eax
  801795:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  80179a:	90                   	nop
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8017a3:	e8 e0 fd ff ff       	call   801588 <InitializeUHeap>
		if (size == 0) return NULL ;
  8017a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017ac:	75 07                	jne    8017b5 <malloc+0x18>
  8017ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b3:	eb 7f                	jmp    801834 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017b5:	e8 d2 08 00 00       	call   80208c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	74 71                	je     80182f <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8017be:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8017c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017cb:	01 d0                	add    %edx,%eax
  8017cd:	48                   	dec    %eax
  8017ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8017d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d9:	f7 75 f4             	divl   -0xc(%ebp)
  8017dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017df:	29 d0                	sub    %edx,%eax
  8017e1:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  8017e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  8017eb:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8017f2:	76 07                	jbe    8017fb <malloc+0x5e>
					return NULL ;
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	eb 39                	jmp    801834 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  8017fb:	83 ec 0c             	sub    $0xc,%esp
  8017fe:	ff 75 08             	pushl  0x8(%ebp)
  801801:	e8 e6 0d 00 00       	call   8025ec <alloc_block_FF>
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80180c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801810:	74 16                	je     801828 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801812:	83 ec 0c             	sub    $0xc,%esp
  801815:	ff 75 ec             	pushl  -0x14(%ebp)
  801818:	e8 37 0c 00 00       	call   802454 <insert_sorted_allocList>
  80181d:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801823:	8b 40 08             	mov    0x8(%eax),%eax
  801826:	eb 0c                	jmp    801834 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801828:	b8 00 00 00 00       	mov    $0x0,%eax
  80182d:	eb 05                	jmp    801834 <malloc+0x97>
				}
		}
	return 0;
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  80183c:	8b 45 08             	mov    0x8(%ebp),%eax
  80183f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801842:	83 ec 08             	sub    $0x8,%esp
  801845:	ff 75 f4             	pushl  -0xc(%ebp)
  801848:	68 40 50 80 00       	push   $0x805040
  80184d:	e8 cf 0b 00 00       	call   802421 <find_block>
  801852:	83 c4 10             	add    $0x10,%esp
  801855:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185b:	8b 40 0c             	mov    0xc(%eax),%eax
  80185e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801861:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801864:	8b 40 08             	mov    0x8(%eax),%eax
  801867:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  80186a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80186e:	0f 84 a1 00 00 00    	je     801915 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801874:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801878:	75 17                	jne    801891 <free+0x5b>
  80187a:	83 ec 04             	sub    $0x4,%esp
  80187d:	68 15 40 80 00       	push   $0x804015
  801882:	68 80 00 00 00       	push   $0x80
  801887:	68 33 40 80 00       	push   $0x804033
  80188c:	e8 b9 ec ff ff       	call   80054a <_panic>
  801891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801894:	8b 00                	mov    (%eax),%eax
  801896:	85 c0                	test   %eax,%eax
  801898:	74 10                	je     8018aa <free+0x74>
  80189a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189d:	8b 00                	mov    (%eax),%eax
  80189f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018a2:	8b 52 04             	mov    0x4(%edx),%edx
  8018a5:	89 50 04             	mov    %edx,0x4(%eax)
  8018a8:	eb 0b                	jmp    8018b5 <free+0x7f>
  8018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ad:	8b 40 04             	mov    0x4(%eax),%eax
  8018b0:	a3 44 50 80 00       	mov    %eax,0x805044
  8018b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b8:	8b 40 04             	mov    0x4(%eax),%eax
  8018bb:	85 c0                	test   %eax,%eax
  8018bd:	74 0f                	je     8018ce <free+0x98>
  8018bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c2:	8b 40 04             	mov    0x4(%eax),%eax
  8018c5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c8:	8b 12                	mov    (%edx),%edx
  8018ca:	89 10                	mov    %edx,(%eax)
  8018cc:	eb 0a                	jmp    8018d8 <free+0xa2>
  8018ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d1:	8b 00                	mov    (%eax),%eax
  8018d3:	a3 40 50 80 00       	mov    %eax,0x805040
  8018d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018eb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8018f0:	48                   	dec    %eax
  8018f1:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  8018f6:	83 ec 0c             	sub    $0xc,%esp
  8018f9:	ff 75 f0             	pushl  -0x10(%ebp)
  8018fc:	e8 29 12 00 00       	call   802b2a <insert_sorted_with_merge_freeList>
  801901:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801904:	83 ec 08             	sub    $0x8,%esp
  801907:	ff 75 ec             	pushl  -0x14(%ebp)
  80190a:	ff 75 e8             	pushl  -0x18(%ebp)
  80190d:	e8 74 03 00 00       	call   801c86 <sys_free_user_mem>
  801912:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801915:	90                   	nop
  801916:	c9                   	leave  
  801917:	c3                   	ret    

00801918 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 38             	sub    $0x38,%esp
  80191e:	8b 45 10             	mov    0x10(%ebp),%eax
  801921:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801924:	e8 5f fc ff ff       	call   801588 <InitializeUHeap>
	if (size == 0) return NULL ;
  801929:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80192d:	75 0a                	jne    801939 <smalloc+0x21>
  80192f:	b8 00 00 00 00       	mov    $0x0,%eax
  801934:	e9 b2 00 00 00       	jmp    8019eb <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801939:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801940:	76 0a                	jbe    80194c <smalloc+0x34>
		return NULL;
  801942:	b8 00 00 00 00       	mov    $0x0,%eax
  801947:	e9 9f 00 00 00       	jmp    8019eb <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80194c:	e8 3b 07 00 00       	call   80208c <sys_isUHeapPlacementStrategyFIRSTFIT>
  801951:	85 c0                	test   %eax,%eax
  801953:	0f 84 8d 00 00 00    	je     8019e6 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801959:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801960:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196d:	01 d0                	add    %edx,%eax
  80196f:	48                   	dec    %eax
  801970:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801973:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801976:	ba 00 00 00 00       	mov    $0x0,%edx
  80197b:	f7 75 f0             	divl   -0x10(%ebp)
  80197e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801981:	29 d0                	sub    %edx,%eax
  801983:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801986:	83 ec 0c             	sub    $0xc,%esp
  801989:	ff 75 e8             	pushl  -0x18(%ebp)
  80198c:	e8 5b 0c 00 00       	call   8025ec <alloc_block_FF>
  801991:	83 c4 10             	add    $0x10,%esp
  801994:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801997:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80199b:	75 07                	jne    8019a4 <smalloc+0x8c>
			return NULL;
  80199d:	b8 00 00 00 00       	mov    $0x0,%eax
  8019a2:	eb 47                	jmp    8019eb <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8019a4:	83 ec 0c             	sub    $0xc,%esp
  8019a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019aa:	e8 a5 0a 00 00       	call   802454 <insert_sorted_allocList>
  8019af:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8019b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019b5:	8b 40 08             	mov    0x8(%eax),%eax
  8019b8:	89 c2                	mov    %eax,%edx
  8019ba:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8019be:	52                   	push   %edx
  8019bf:	50                   	push   %eax
  8019c0:	ff 75 0c             	pushl  0xc(%ebp)
  8019c3:	ff 75 08             	pushl  0x8(%ebp)
  8019c6:	e8 46 04 00 00       	call   801e11 <sys_createSharedObject>
  8019cb:	83 c4 10             	add    $0x10,%esp
  8019ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8019d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019d5:	78 08                	js     8019df <smalloc+0xc7>
		return (void *)b->sva;
  8019d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019da:	8b 40 08             	mov    0x8(%eax),%eax
  8019dd:	eb 0c                	jmp    8019eb <smalloc+0xd3>
		}else{
		return NULL;
  8019df:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e4:	eb 05                	jmp    8019eb <smalloc+0xd3>
			}

	}return NULL;
  8019e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8019f3:	e8 90 fb ff ff       	call   801588 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8019f8:	e8 8f 06 00 00       	call   80208c <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	0f 84 ad 00 00 00    	je     801ab2 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801a05:	83 ec 08             	sub    $0x8,%esp
  801a08:	ff 75 0c             	pushl  0xc(%ebp)
  801a0b:	ff 75 08             	pushl  0x8(%ebp)
  801a0e:	e8 28 04 00 00       	call   801e3b <sys_getSizeOfSharedObject>
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801a19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a1d:	79 0a                	jns    801a29 <sget+0x3c>
    {
    	return NULL;
  801a1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a24:	e9 8e 00 00 00       	jmp    801ab7 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801a29:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801a30:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a3d:	01 d0                	add    %edx,%eax
  801a3f:	48                   	dec    %eax
  801a40:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801a43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a46:	ba 00 00 00 00       	mov    $0x0,%edx
  801a4b:	f7 75 ec             	divl   -0x14(%ebp)
  801a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a51:	29 d0                	sub    %edx,%eax
  801a53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801a56:	83 ec 0c             	sub    $0xc,%esp
  801a59:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a5c:	e8 8b 0b 00 00       	call   8025ec <alloc_block_FF>
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a6b:	75 07                	jne    801a74 <sget+0x87>
				return NULL;
  801a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a72:	eb 43                	jmp    801ab7 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801a74:	83 ec 0c             	sub    $0xc,%esp
  801a77:	ff 75 f0             	pushl  -0x10(%ebp)
  801a7a:	e8 d5 09 00 00       	call   802454 <insert_sorted_allocList>
  801a7f:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a85:	8b 40 08             	mov    0x8(%eax),%eax
  801a88:	83 ec 04             	sub    $0x4,%esp
  801a8b:	50                   	push   %eax
  801a8c:	ff 75 0c             	pushl  0xc(%ebp)
  801a8f:	ff 75 08             	pushl  0x8(%ebp)
  801a92:	e8 c1 03 00 00       	call   801e58 <sys_getSharedObject>
  801a97:	83 c4 10             	add    $0x10,%esp
  801a9a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801a9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801aa1:	78 08                	js     801aab <sget+0xbe>
			return (void *)b->sva;
  801aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa6:	8b 40 08             	mov    0x8(%eax),%eax
  801aa9:	eb 0c                	jmp    801ab7 <sget+0xca>
			}else{
			return NULL;
  801aab:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab0:	eb 05                	jmp    801ab7 <sget+0xca>
			}
    }}return NULL;
  801ab2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801abf:	e8 c4 fa ff ff       	call   801588 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ac4:	83 ec 04             	sub    $0x4,%esp
  801ac7:	68 64 40 80 00       	push   $0x804064
  801acc:	68 03 01 00 00       	push   $0x103
  801ad1:	68 33 40 80 00       	push   $0x804033
  801ad6:	e8 6f ea ff ff       	call   80054a <_panic>

00801adb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ae1:	83 ec 04             	sub    $0x4,%esp
  801ae4:	68 8c 40 80 00       	push   $0x80408c
  801ae9:	68 17 01 00 00       	push   $0x117
  801aee:	68 33 40 80 00       	push   $0x804033
  801af3:	e8 52 ea ff ff       	call   80054a <_panic>

00801af8 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801af8:	55                   	push   %ebp
  801af9:	89 e5                	mov    %esp,%ebp
  801afb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801afe:	83 ec 04             	sub    $0x4,%esp
  801b01:	68 b0 40 80 00       	push   $0x8040b0
  801b06:	68 22 01 00 00       	push   $0x122
  801b0b:	68 33 40 80 00       	push   $0x804033
  801b10:	e8 35 ea ff ff       	call   80054a <_panic>

00801b15 <shrink>:

}
void shrink(uint32 newSize)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b1b:	83 ec 04             	sub    $0x4,%esp
  801b1e:	68 b0 40 80 00       	push   $0x8040b0
  801b23:	68 27 01 00 00       	push   $0x127
  801b28:	68 33 40 80 00       	push   $0x804033
  801b2d:	e8 18 ea ff ff       	call   80054a <_panic>

00801b32 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b38:	83 ec 04             	sub    $0x4,%esp
  801b3b:	68 b0 40 80 00       	push   $0x8040b0
  801b40:	68 2c 01 00 00       	push   $0x12c
  801b45:	68 33 40 80 00       	push   $0x804033
  801b4a:	e8 fb e9 ff ff       	call   80054a <_panic>

00801b4f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	57                   	push   %edi
  801b53:	56                   	push   %esi
  801b54:	53                   	push   %ebx
  801b55:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b58:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b64:	8b 7d 18             	mov    0x18(%ebp),%edi
  801b67:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801b6a:	cd 30                	int    $0x30
  801b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801b72:	83 c4 10             	add    $0x10,%esp
  801b75:	5b                   	pop    %ebx
  801b76:	5e                   	pop    %esi
  801b77:	5f                   	pop    %edi
  801b78:	5d                   	pop    %ebp
  801b79:	c3                   	ret    

00801b7a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	8b 45 10             	mov    0x10(%ebp),%eax
  801b83:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b86:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	52                   	push   %edx
  801b92:	ff 75 0c             	pushl  0xc(%ebp)
  801b95:	50                   	push   %eax
  801b96:	6a 00                	push   $0x0
  801b98:	e8 b2 ff ff ff       	call   801b4f <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	90                   	nop
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_cgetc>:

int
sys_cgetc(void)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 01                	push   $0x1
  801bb2:	e8 98 ff ff ff       	call   801b4f <syscall>
  801bb7:	83 c4 18             	add    $0x18,%esp
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	52                   	push   %edx
  801bcc:	50                   	push   %eax
  801bcd:	6a 05                	push   $0x5
  801bcf:	e8 7b ff ff ff       	call   801b4f <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
  801bdc:	56                   	push   %esi
  801bdd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801bde:	8b 75 18             	mov    0x18(%ebp),%esi
  801be1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801be4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bea:	8b 45 08             	mov    0x8(%ebp),%eax
  801bed:	56                   	push   %esi
  801bee:	53                   	push   %ebx
  801bef:	51                   	push   %ecx
  801bf0:	52                   	push   %edx
  801bf1:	50                   	push   %eax
  801bf2:	6a 06                	push   $0x6
  801bf4:	e8 56 ff ff ff       	call   801b4f <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bff:	5b                   	pop    %ebx
  801c00:	5e                   	pop    %esi
  801c01:	5d                   	pop    %ebp
  801c02:	c3                   	ret    

00801c03 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	52                   	push   %edx
  801c13:	50                   	push   %eax
  801c14:	6a 07                	push   $0x7
  801c16:	e8 34 ff ff ff       	call   801b4f <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	ff 75 08             	pushl  0x8(%ebp)
  801c2f:	6a 08                	push   $0x8
  801c31:	e8 19 ff ff ff       	call   801b4f <syscall>
  801c36:	83 c4 18             	add    $0x18,%esp
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 09                	push   $0x9
  801c4a:	e8 00 ff ff ff       	call   801b4f <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 0a                	push   $0xa
  801c63:	e8 e7 fe ff ff       	call   801b4f <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 0b                	push   $0xb
  801c7c:	e8 ce fe ff ff       	call   801b4f <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	ff 75 0c             	pushl  0xc(%ebp)
  801c92:	ff 75 08             	pushl  0x8(%ebp)
  801c95:	6a 0f                	push   $0xf
  801c97:	e8 b3 fe ff ff       	call   801b4f <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
	return;
  801c9f:	90                   	nop
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	ff 75 0c             	pushl  0xc(%ebp)
  801cae:	ff 75 08             	pushl  0x8(%ebp)
  801cb1:	6a 10                	push   $0x10
  801cb3:	e8 97 fe ff ff       	call   801b4f <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cbb:	90                   	nop
}
  801cbc:	c9                   	leave  
  801cbd:	c3                   	ret    

00801cbe <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	ff 75 10             	pushl  0x10(%ebp)
  801cc8:	ff 75 0c             	pushl  0xc(%ebp)
  801ccb:	ff 75 08             	pushl  0x8(%ebp)
  801cce:	6a 11                	push   $0x11
  801cd0:	e8 7a fe ff ff       	call   801b4f <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd8:	90                   	nop
}
  801cd9:	c9                   	leave  
  801cda:	c3                   	ret    

00801cdb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 0c                	push   $0xc
  801cea:	e8 60 fe ff ff       	call   801b4f <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
}
  801cf2:	c9                   	leave  
  801cf3:	c3                   	ret    

00801cf4 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801cf4:	55                   	push   %ebp
  801cf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	ff 75 08             	pushl  0x8(%ebp)
  801d02:	6a 0d                	push   $0xd
  801d04:	e8 46 fe ff ff       	call   801b4f <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 0e                	push   $0xe
  801d1d:	e8 2d fe ff ff       	call   801b4f <syscall>
  801d22:	83 c4 18             	add    $0x18,%esp
}
  801d25:	90                   	nop
  801d26:	c9                   	leave  
  801d27:	c3                   	ret    

00801d28 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d28:	55                   	push   %ebp
  801d29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 13                	push   $0x13
  801d37:	e8 13 fe ff ff       	call   801b4f <syscall>
  801d3c:	83 c4 18             	add    $0x18,%esp
}
  801d3f:	90                   	nop
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 14                	push   $0x14
  801d51:	e8 f9 fd ff ff       	call   801b4f <syscall>
  801d56:	83 c4 18             	add    $0x18,%esp
}
  801d59:	90                   	nop
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_cputc>:


void
sys_cputc(const char c)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	83 ec 04             	sub    $0x4,%esp
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801d68:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	50                   	push   %eax
  801d75:	6a 15                	push   $0x15
  801d77:	e8 d3 fd ff ff       	call   801b4f <syscall>
  801d7c:	83 c4 18             	add    $0x18,%esp
}
  801d7f:	90                   	nop
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 16                	push   $0x16
  801d91:	e8 b9 fd ff ff       	call   801b4f <syscall>
  801d96:	83 c4 18             	add    $0x18,%esp
}
  801d99:	90                   	nop
  801d9a:	c9                   	leave  
  801d9b:	c3                   	ret    

00801d9c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	ff 75 0c             	pushl  0xc(%ebp)
  801dab:	50                   	push   %eax
  801dac:	6a 17                	push   $0x17
  801dae:	e8 9c fd ff ff       	call   801b4f <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	52                   	push   %edx
  801dc8:	50                   	push   %eax
  801dc9:	6a 1a                	push   $0x1a
  801dcb:	e8 7f fd ff ff       	call   801b4f <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801dd8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	52                   	push   %edx
  801de5:	50                   	push   %eax
  801de6:	6a 18                	push   $0x18
  801de8:	e8 62 fd ff ff       	call   801b4f <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
}
  801df0:	90                   	nop
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801df6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	52                   	push   %edx
  801e03:	50                   	push   %eax
  801e04:	6a 19                	push   $0x19
  801e06:	e8 44 fd ff ff       	call   801b4f <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
}
  801e0e:	90                   	nop
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 04             	sub    $0x4,%esp
  801e17:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e1d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e20:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	6a 00                	push   $0x0
  801e29:	51                   	push   %ecx
  801e2a:	52                   	push   %edx
  801e2b:	ff 75 0c             	pushl  0xc(%ebp)
  801e2e:	50                   	push   %eax
  801e2f:	6a 1b                	push   $0x1b
  801e31:	e8 19 fd ff ff       	call   801b4f <syscall>
  801e36:	83 c4 18             	add    $0x18,%esp
}
  801e39:	c9                   	leave  
  801e3a:	c3                   	ret    

00801e3b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801e3b:	55                   	push   %ebp
  801e3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801e3e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e41:	8b 45 08             	mov    0x8(%ebp),%eax
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	52                   	push   %edx
  801e4b:	50                   	push   %eax
  801e4c:	6a 1c                	push   $0x1c
  801e4e:	e8 fc fc ff ff       	call   801b4f <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801e5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	51                   	push   %ecx
  801e69:	52                   	push   %edx
  801e6a:	50                   	push   %eax
  801e6b:	6a 1d                	push   $0x1d
  801e6d:	e8 dd fc ff ff       	call   801b4f <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	52                   	push   %edx
  801e87:	50                   	push   %eax
  801e88:	6a 1e                	push   $0x1e
  801e8a:	e8 c0 fc ff ff       	call   801b4f <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 1f                	push   $0x1f
  801ea3:	e8 a7 fc ff ff       	call   801b4f <syscall>
  801ea8:	83 c4 18             	add    $0x18,%esp
}
  801eab:	c9                   	leave  
  801eac:	c3                   	ret    

00801ead <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ead:	55                   	push   %ebp
  801eae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	6a 00                	push   $0x0
  801eb5:	ff 75 14             	pushl  0x14(%ebp)
  801eb8:	ff 75 10             	pushl  0x10(%ebp)
  801ebb:	ff 75 0c             	pushl  0xc(%ebp)
  801ebe:	50                   	push   %eax
  801ebf:	6a 20                	push   $0x20
  801ec1:	e8 89 fc ff ff       	call   801b4f <syscall>
  801ec6:	83 c4 18             	add    $0x18,%esp
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ece:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	6a 00                	push   $0x0
  801ed9:	50                   	push   %eax
  801eda:	6a 21                	push   $0x21
  801edc:	e8 6e fc ff ff       	call   801b4f <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
}
  801ee4:	90                   	nop
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801eea:	8b 45 08             	mov    0x8(%ebp),%eax
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	6a 00                	push   $0x0
  801ef5:	50                   	push   %eax
  801ef6:	6a 22                	push   $0x22
  801ef8:	e8 52 fc ff ff       	call   801b4f <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 02                	push   $0x2
  801f11:	e8 39 fc ff ff       	call   801b4f <syscall>
  801f16:	83 c4 18             	add    $0x18,%esp
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 03                	push   $0x3
  801f2a:	e8 20 fc ff ff       	call   801b4f <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f37:	6a 00                	push   $0x0
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	6a 00                	push   $0x0
  801f41:	6a 04                	push   $0x4
  801f43:	e8 07 fc ff ff       	call   801b4f <syscall>
  801f48:	83 c4 18             	add    $0x18,%esp
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <sys_exit_env>:


void sys_exit_env(void)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801f50:	6a 00                	push   $0x0
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 23                	push   $0x23
  801f5c:	e8 ee fb ff ff       	call   801b4f <syscall>
  801f61:	83 c4 18             	add    $0x18,%esp
}
  801f64:	90                   	nop
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801f6d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f70:	8d 50 04             	lea    0x4(%eax),%edx
  801f73:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	52                   	push   %edx
  801f7d:	50                   	push   %eax
  801f7e:	6a 24                	push   $0x24
  801f80:	e8 ca fb ff ff       	call   801b4f <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
	return result;
  801f88:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f8e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f91:	89 01                	mov    %eax,(%ecx)
  801f93:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	c9                   	leave  
  801f9a:	c2 04 00             	ret    $0x4

00801f9d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	ff 75 10             	pushl  0x10(%ebp)
  801fa7:	ff 75 0c             	pushl  0xc(%ebp)
  801faa:	ff 75 08             	pushl  0x8(%ebp)
  801fad:	6a 12                	push   $0x12
  801faf:	e8 9b fb ff ff       	call   801b4f <syscall>
  801fb4:	83 c4 18             	add    $0x18,%esp
	return ;
  801fb7:	90                   	nop
}
  801fb8:	c9                   	leave  
  801fb9:	c3                   	ret    

00801fba <sys_rcr2>:
uint32 sys_rcr2()
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 25                	push   $0x25
  801fc9:	e8 81 fb ff ff       	call   801b4f <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
  801fd6:	83 ec 04             	sub    $0x4,%esp
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801fdf:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	50                   	push   %eax
  801fec:	6a 26                	push   $0x26
  801fee:	e8 5c fb ff ff       	call   801b4f <syscall>
  801ff3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff6:	90                   	nop
}
  801ff7:	c9                   	leave  
  801ff8:	c3                   	ret    

00801ff9 <rsttst>:
void rsttst()
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ffc:	6a 00                	push   $0x0
  801ffe:	6a 00                	push   $0x0
  802000:	6a 00                	push   $0x0
  802002:	6a 00                	push   $0x0
  802004:	6a 00                	push   $0x0
  802006:	6a 28                	push   $0x28
  802008:	e8 42 fb ff ff       	call   801b4f <syscall>
  80200d:	83 c4 18             	add    $0x18,%esp
	return ;
  802010:	90                   	nop
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 04             	sub    $0x4,%esp
  802019:	8b 45 14             	mov    0x14(%ebp),%eax
  80201c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80201f:	8b 55 18             	mov    0x18(%ebp),%edx
  802022:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802026:	52                   	push   %edx
  802027:	50                   	push   %eax
  802028:	ff 75 10             	pushl  0x10(%ebp)
  80202b:	ff 75 0c             	pushl  0xc(%ebp)
  80202e:	ff 75 08             	pushl  0x8(%ebp)
  802031:	6a 27                	push   $0x27
  802033:	e8 17 fb ff ff       	call   801b4f <syscall>
  802038:	83 c4 18             	add    $0x18,%esp
	return ;
  80203b:	90                   	nop
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <chktst>:
void chktst(uint32 n)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802041:	6a 00                	push   $0x0
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	ff 75 08             	pushl  0x8(%ebp)
  80204c:	6a 29                	push   $0x29
  80204e:	e8 fc fa ff ff       	call   801b4f <syscall>
  802053:	83 c4 18             	add    $0x18,%esp
	return ;
  802056:	90                   	nop
}
  802057:	c9                   	leave  
  802058:	c3                   	ret    

00802059 <inctst>:

void inctst()
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80205c:	6a 00                	push   $0x0
  80205e:	6a 00                	push   $0x0
  802060:	6a 00                	push   $0x0
  802062:	6a 00                	push   $0x0
  802064:	6a 00                	push   $0x0
  802066:	6a 2a                	push   $0x2a
  802068:	e8 e2 fa ff ff       	call   801b4f <syscall>
  80206d:	83 c4 18             	add    $0x18,%esp
	return ;
  802070:	90                   	nop
}
  802071:	c9                   	leave  
  802072:	c3                   	ret    

00802073 <gettst>:
uint32 gettst()
{
  802073:	55                   	push   %ebp
  802074:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 00                	push   $0x0
  80207c:	6a 00                	push   $0x0
  80207e:	6a 00                	push   $0x0
  802080:	6a 2b                	push   $0x2b
  802082:	e8 c8 fa ff ff       	call   801b4f <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
  80208f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802092:	6a 00                	push   $0x0
  802094:	6a 00                	push   $0x0
  802096:	6a 00                	push   $0x0
  802098:	6a 00                	push   $0x0
  80209a:	6a 00                	push   $0x0
  80209c:	6a 2c                	push   $0x2c
  80209e:	e8 ac fa ff ff       	call   801b4f <syscall>
  8020a3:	83 c4 18             	add    $0x18,%esp
  8020a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8020a9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8020ad:	75 07                	jne    8020b6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  8020af:	b8 01 00 00 00       	mov    $0x1,%eax
  8020b4:	eb 05                	jmp    8020bb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  8020b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
  8020c0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 00                	push   $0x0
  8020cd:	6a 2c                	push   $0x2c
  8020cf:	e8 7b fa ff ff       	call   801b4f <syscall>
  8020d4:	83 c4 18             	add    $0x18,%esp
  8020d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8020da:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8020de:	75 07                	jne    8020e7 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8020e0:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e5:	eb 05                	jmp    8020ec <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 2c                	push   $0x2c
  802100:	e8 4a fa ff ff       	call   801b4f <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
  802108:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80210b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80210f:	75 07                	jne    802118 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802111:	b8 01 00 00 00       	mov    $0x1,%eax
  802116:	eb 05                	jmp    80211d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802118:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802125:	6a 00                	push   $0x0
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 2c                	push   $0x2c
  802131:	e8 19 fa ff ff       	call   801b4f <syscall>
  802136:	83 c4 18             	add    $0x18,%esp
  802139:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80213c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802140:	75 07                	jne    802149 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	eb 05                	jmp    80214e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  802149:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	ff 75 08             	pushl  0x8(%ebp)
  80215e:	6a 2d                	push   $0x2d
  802160:	e8 ea f9 ff ff       	call   801b4f <syscall>
  802165:	83 c4 18             	add    $0x18,%esp
	return ;
  802168:	90                   	nop
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80216f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802172:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802175:	8b 55 0c             	mov    0xc(%ebp),%edx
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	6a 00                	push   $0x0
  80217d:	53                   	push   %ebx
  80217e:	51                   	push   %ecx
  80217f:	52                   	push   %edx
  802180:	50                   	push   %eax
  802181:	6a 2e                	push   $0x2e
  802183:	e8 c7 f9 ff ff       	call   801b4f <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
}
  80218b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802193:	8b 55 0c             	mov    0xc(%ebp),%edx
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	52                   	push   %edx
  8021a0:	50                   	push   %eax
  8021a1:	6a 2f                	push   $0x2f
  8021a3:	e8 a7 f9 ff ff       	call   801b4f <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  8021b3:	83 ec 0c             	sub    $0xc,%esp
  8021b6:	68 c0 40 80 00       	push   $0x8040c0
  8021bb:	e8 3e e6 ff ff       	call   8007fe <cprintf>
  8021c0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8021c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8021ca:	83 ec 0c             	sub    $0xc,%esp
  8021cd:	68 ec 40 80 00       	push   $0x8040ec
  8021d2:	e8 27 e6 ff ff       	call   8007fe <cprintf>
  8021d7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8021da:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8021de:	a1 38 51 80 00       	mov    0x805138,%eax
  8021e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021e6:	eb 56                	jmp    80223e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8021e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8021ec:	74 1c                	je     80220a <print_mem_block_lists+0x5d>
  8021ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f1:	8b 50 08             	mov    0x8(%eax),%edx
  8021f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021f7:	8b 48 08             	mov    0x8(%eax),%ecx
  8021fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802200:	01 c8                	add    %ecx,%eax
  802202:	39 c2                	cmp    %eax,%edx
  802204:	73 04                	jae    80220a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802206:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	8b 50 08             	mov    0x8(%eax),%edx
  802210:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802213:	8b 40 0c             	mov    0xc(%eax),%eax
  802216:	01 c2                	add    %eax,%edx
  802218:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221b:	8b 40 08             	mov    0x8(%eax),%eax
  80221e:	83 ec 04             	sub    $0x4,%esp
  802221:	52                   	push   %edx
  802222:	50                   	push   %eax
  802223:	68 01 41 80 00       	push   $0x804101
  802228:	e8 d1 e5 ff ff       	call   8007fe <cprintf>
  80222d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802230:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802233:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802236:	a1 40 51 80 00       	mov    0x805140,%eax
  80223b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80223e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802242:	74 07                	je     80224b <print_mem_block_lists+0x9e>
  802244:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802247:	8b 00                	mov    (%eax),%eax
  802249:	eb 05                	jmp    802250 <print_mem_block_lists+0xa3>
  80224b:	b8 00 00 00 00       	mov    $0x0,%eax
  802250:	a3 40 51 80 00       	mov    %eax,0x805140
  802255:	a1 40 51 80 00       	mov    0x805140,%eax
  80225a:	85 c0                	test   %eax,%eax
  80225c:	75 8a                	jne    8021e8 <print_mem_block_lists+0x3b>
  80225e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802262:	75 84                	jne    8021e8 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802264:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802268:	75 10                	jne    80227a <print_mem_block_lists+0xcd>
  80226a:	83 ec 0c             	sub    $0xc,%esp
  80226d:	68 10 41 80 00       	push   $0x804110
  802272:	e8 87 e5 ff ff       	call   8007fe <cprintf>
  802277:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80227a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802281:	83 ec 0c             	sub    $0xc,%esp
  802284:	68 34 41 80 00       	push   $0x804134
  802289:	e8 70 e5 ff ff       	call   8007fe <cprintf>
  80228e:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802291:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802295:	a1 40 50 80 00       	mov    0x805040,%eax
  80229a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80229d:	eb 56                	jmp    8022f5 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80229f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022a3:	74 1c                	je     8022c1 <print_mem_block_lists+0x114>
  8022a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a8:	8b 50 08             	mov    0x8(%eax),%edx
  8022ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022ae:	8b 48 08             	mov    0x8(%eax),%ecx
  8022b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8022b7:	01 c8                	add    %ecx,%eax
  8022b9:	39 c2                	cmp    %eax,%edx
  8022bb:	73 04                	jae    8022c1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8022bd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	8b 50 08             	mov    0x8(%eax),%edx
  8022c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8022cd:	01 c2                	add    %eax,%edx
  8022cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d2:	8b 40 08             	mov    0x8(%eax),%eax
  8022d5:	83 ec 04             	sub    $0x4,%esp
  8022d8:	52                   	push   %edx
  8022d9:	50                   	push   %eax
  8022da:	68 01 41 80 00       	push   $0x804101
  8022df:	e8 1a e5 ff ff       	call   8007fe <cprintf>
  8022e4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022ed:	a1 48 50 80 00       	mov    0x805048,%eax
  8022f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f9:	74 07                	je     802302 <print_mem_block_lists+0x155>
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	eb 05                	jmp    802307 <print_mem_block_lists+0x15a>
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
  802307:	a3 48 50 80 00       	mov    %eax,0x805048
  80230c:	a1 48 50 80 00       	mov    0x805048,%eax
  802311:	85 c0                	test   %eax,%eax
  802313:	75 8a                	jne    80229f <print_mem_block_lists+0xf2>
  802315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802319:	75 84                	jne    80229f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80231b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80231f:	75 10                	jne    802331 <print_mem_block_lists+0x184>
  802321:	83 ec 0c             	sub    $0xc,%esp
  802324:	68 4c 41 80 00       	push   $0x80414c
  802329:	e8 d0 e4 ff ff       	call   8007fe <cprintf>
  80232e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802331:	83 ec 0c             	sub    $0xc,%esp
  802334:	68 c0 40 80 00       	push   $0x8040c0
  802339:	e8 c0 e4 ff ff       	call   8007fe <cprintf>
  80233e:	83 c4 10             	add    $0x10,%esp

}
  802341:	90                   	nop
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80234a:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802351:	00 00 00 
  802354:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80235b:	00 00 00 
  80235e:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802365:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802368:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80236f:	e9 9e 00 00 00       	jmp    802412 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802374:	a1 50 50 80 00       	mov    0x805050,%eax
  802379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237c:	c1 e2 04             	shl    $0x4,%edx
  80237f:	01 d0                	add    %edx,%eax
  802381:	85 c0                	test   %eax,%eax
  802383:	75 14                	jne    802399 <initialize_MemBlocksList+0x55>
  802385:	83 ec 04             	sub    $0x4,%esp
  802388:	68 74 41 80 00       	push   $0x804174
  80238d:	6a 3d                	push   $0x3d
  80238f:	68 97 41 80 00       	push   $0x804197
  802394:	e8 b1 e1 ff ff       	call   80054a <_panic>
  802399:	a1 50 50 80 00       	mov    0x805050,%eax
  80239e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023a1:	c1 e2 04             	shl    $0x4,%edx
  8023a4:	01 d0                	add    %edx,%eax
  8023a6:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8023ac:	89 10                	mov    %edx,(%eax)
  8023ae:	8b 00                	mov    (%eax),%eax
  8023b0:	85 c0                	test   %eax,%eax
  8023b2:	74 18                	je     8023cc <initialize_MemBlocksList+0x88>
  8023b4:	a1 48 51 80 00       	mov    0x805148,%eax
  8023b9:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8023bf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8023c2:	c1 e1 04             	shl    $0x4,%ecx
  8023c5:	01 ca                	add    %ecx,%edx
  8023c7:	89 50 04             	mov    %edx,0x4(%eax)
  8023ca:	eb 12                	jmp    8023de <initialize_MemBlocksList+0x9a>
  8023cc:	a1 50 50 80 00       	mov    0x805050,%eax
  8023d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d4:	c1 e2 04             	shl    $0x4,%edx
  8023d7:	01 d0                	add    %edx,%eax
  8023d9:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8023de:	a1 50 50 80 00       	mov    0x805050,%eax
  8023e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e6:	c1 e2 04             	shl    $0x4,%edx
  8023e9:	01 d0                	add    %edx,%eax
  8023eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8023f0:	a1 50 50 80 00       	mov    0x805050,%eax
  8023f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f8:	c1 e2 04             	shl    $0x4,%edx
  8023fb:	01 d0                	add    %edx,%eax
  8023fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802404:	a1 54 51 80 00       	mov    0x805154,%eax
  802409:	40                   	inc    %eax
  80240a:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80240f:	ff 45 f4             	incl   -0xc(%ebp)
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	3b 45 08             	cmp    0x8(%ebp),%eax
  802418:	0f 82 56 ff ff ff    	jb     802374 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80241e:	90                   	nop
  80241f:	c9                   	leave  
  802420:	c3                   	ret    

00802421 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	8b 00                	mov    (%eax),%eax
  80242c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80242f:	eb 18                	jmp    802449 <find_block+0x28>

		if(tmp->sva == va){
  802431:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802434:	8b 40 08             	mov    0x8(%eax),%eax
  802437:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80243a:	75 05                	jne    802441 <find_block+0x20>
			return tmp ;
  80243c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80243f:	eb 11                	jmp    802452 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802441:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802444:	8b 00                	mov    (%eax),%eax
  802446:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802449:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80244d:	75 e2                	jne    802431 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80244f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802452:	c9                   	leave  
  802453:	c3                   	ret    

00802454 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802454:	55                   	push   %ebp
  802455:	89 e5                	mov    %esp,%ebp
  802457:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80245a:	a1 40 50 80 00       	mov    0x805040,%eax
  80245f:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802462:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802467:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  80246a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80246e:	75 65                	jne    8024d5 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802470:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802474:	75 14                	jne    80248a <insert_sorted_allocList+0x36>
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	68 74 41 80 00       	push   $0x804174
  80247e:	6a 62                	push   $0x62
  802480:	68 97 41 80 00       	push   $0x804197
  802485:	e8 c0 e0 ff ff       	call   80054a <_panic>
  80248a:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802490:	8b 45 08             	mov    0x8(%ebp),%eax
  802493:	89 10                	mov    %edx,(%eax)
  802495:	8b 45 08             	mov    0x8(%ebp),%eax
  802498:	8b 00                	mov    (%eax),%eax
  80249a:	85 c0                	test   %eax,%eax
  80249c:	74 0d                	je     8024ab <insert_sorted_allocList+0x57>
  80249e:	a1 40 50 80 00       	mov    0x805040,%eax
  8024a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a6:	89 50 04             	mov    %edx,0x4(%eax)
  8024a9:	eb 08                	jmp    8024b3 <insert_sorted_allocList+0x5f>
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	a3 44 50 80 00       	mov    %eax,0x805044
  8024b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b6:	a3 40 50 80 00       	mov    %eax,0x805040
  8024bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c5:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024ca:	40                   	inc    %eax
  8024cb:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8024d0:	e9 14 01 00 00       	jmp    8025e9 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8024d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024d8:	8b 50 08             	mov    0x8(%eax),%edx
  8024db:	a1 44 50 80 00       	mov    0x805044,%eax
  8024e0:	8b 40 08             	mov    0x8(%eax),%eax
  8024e3:	39 c2                	cmp    %eax,%edx
  8024e5:	76 65                	jbe    80254c <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8024e7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024eb:	75 14                	jne    802501 <insert_sorted_allocList+0xad>
  8024ed:	83 ec 04             	sub    $0x4,%esp
  8024f0:	68 b0 41 80 00       	push   $0x8041b0
  8024f5:	6a 64                	push   $0x64
  8024f7:	68 97 41 80 00       	push   $0x804197
  8024fc:	e8 49 e0 ff ff       	call   80054a <_panic>
  802501:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802507:	8b 45 08             	mov    0x8(%ebp),%eax
  80250a:	89 50 04             	mov    %edx,0x4(%eax)
  80250d:	8b 45 08             	mov    0x8(%ebp),%eax
  802510:	8b 40 04             	mov    0x4(%eax),%eax
  802513:	85 c0                	test   %eax,%eax
  802515:	74 0c                	je     802523 <insert_sorted_allocList+0xcf>
  802517:	a1 44 50 80 00       	mov    0x805044,%eax
  80251c:	8b 55 08             	mov    0x8(%ebp),%edx
  80251f:	89 10                	mov    %edx,(%eax)
  802521:	eb 08                	jmp    80252b <insert_sorted_allocList+0xd7>
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	a3 40 50 80 00       	mov    %eax,0x805040
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	a3 44 50 80 00       	mov    %eax,0x805044
  802533:	8b 45 08             	mov    0x8(%ebp),%eax
  802536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80253c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802541:	40                   	inc    %eax
  802542:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802547:	e9 9d 00 00 00       	jmp    8025e9 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80254c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802553:	e9 85 00 00 00       	jmp    8025dd <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802558:	8b 45 08             	mov    0x8(%ebp),%eax
  80255b:	8b 50 08             	mov    0x8(%eax),%edx
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 40 08             	mov    0x8(%eax),%eax
  802564:	39 c2                	cmp    %eax,%edx
  802566:	73 6a                	jae    8025d2 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802568:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256c:	74 06                	je     802574 <insert_sorted_allocList+0x120>
  80256e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802572:	75 14                	jne    802588 <insert_sorted_allocList+0x134>
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	68 d4 41 80 00       	push   $0x8041d4
  80257c:	6a 6b                	push   $0x6b
  80257e:	68 97 41 80 00       	push   $0x804197
  802583:	e8 c2 df ff ff       	call   80054a <_panic>
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 50 04             	mov    0x4(%eax),%edx
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	89 50 04             	mov    %edx,0x4(%eax)
  802594:	8b 45 08             	mov    0x8(%ebp),%eax
  802597:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259a:	89 10                	mov    %edx,(%eax)
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 40 04             	mov    0x4(%eax),%eax
  8025a2:	85 c0                	test   %eax,%eax
  8025a4:	74 0d                	je     8025b3 <insert_sorted_allocList+0x15f>
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8025af:	89 10                	mov    %edx,(%eax)
  8025b1:	eb 08                	jmp    8025bb <insert_sorted_allocList+0x167>
  8025b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b6:	a3 40 50 80 00       	mov    %eax,0x805040
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c1:	89 50 04             	mov    %edx,0x4(%eax)
  8025c4:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025c9:	40                   	inc    %eax
  8025ca:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  8025cf:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8025d0:	eb 17                	jmp    8025e9 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8025da:	ff 45 f0             	incl   -0x10(%ebp)
  8025dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025e3:	0f 8c 6f ff ff ff    	jl     802558 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8025e9:	90                   	nop
  8025ea:	c9                   	leave  
  8025eb:	c3                   	ret    

008025ec <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8025ec:	55                   	push   %ebp
  8025ed:	89 e5                	mov    %esp,%ebp
  8025ef:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  8025f2:	a1 38 51 80 00       	mov    0x805138,%eax
  8025f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8025fa:	e9 7c 01 00 00       	jmp    80277b <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 40 0c             	mov    0xc(%eax),%eax
  802605:	3b 45 08             	cmp    0x8(%ebp),%eax
  802608:	0f 86 cf 00 00 00    	jbe    8026dd <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80260e:	a1 48 51 80 00       	mov    0x805148,%eax
  802613:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802619:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80261c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80261f:	8b 55 08             	mov    0x8(%ebp),%edx
  802622:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 50 08             	mov    0x8(%eax),%edx
  80262b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80262e:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802631:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802634:	8b 40 0c             	mov    0xc(%eax),%eax
  802637:	2b 45 08             	sub    0x8(%ebp),%eax
  80263a:	89 c2                	mov    %eax,%edx
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802642:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802645:	8b 50 08             	mov    0x8(%eax),%edx
  802648:	8b 45 08             	mov    0x8(%ebp),%eax
  80264b:	01 c2                	add    %eax,%edx
  80264d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802650:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802653:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802657:	75 17                	jne    802670 <alloc_block_FF+0x84>
  802659:	83 ec 04             	sub    $0x4,%esp
  80265c:	68 09 42 80 00       	push   $0x804209
  802661:	68 83 00 00 00       	push   $0x83
  802666:	68 97 41 80 00       	push   $0x804197
  80266b:	e8 da de ff ff       	call   80054a <_panic>
  802670:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	85 c0                	test   %eax,%eax
  802677:	74 10                	je     802689 <alloc_block_FF+0x9d>
  802679:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80267c:	8b 00                	mov    (%eax),%eax
  80267e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802681:	8b 52 04             	mov    0x4(%edx),%edx
  802684:	89 50 04             	mov    %edx,0x4(%eax)
  802687:	eb 0b                	jmp    802694 <alloc_block_FF+0xa8>
  802689:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80268c:	8b 40 04             	mov    0x4(%eax),%eax
  80268f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802694:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802697:	8b 40 04             	mov    0x4(%eax),%eax
  80269a:	85 c0                	test   %eax,%eax
  80269c:	74 0f                	je     8026ad <alloc_block_FF+0xc1>
  80269e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026a1:	8b 40 04             	mov    0x4(%eax),%eax
  8026a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026a7:	8b 12                	mov    (%edx),%edx
  8026a9:	89 10                	mov    %edx,(%eax)
  8026ab:	eb 0a                	jmp    8026b7 <alloc_block_FF+0xcb>
  8026ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b0:	8b 00                	mov    (%eax),%eax
  8026b2:	a3 48 51 80 00       	mov    %eax,0x805148
  8026b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ca:	a1 54 51 80 00       	mov    0x805154,%eax
  8026cf:	48                   	dec    %eax
  8026d0:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  8026d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d8:	e9 ad 00 00 00       	jmp    80278a <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e6:	0f 85 87 00 00 00    	jne    802773 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  8026ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f0:	75 17                	jne    802709 <alloc_block_FF+0x11d>
  8026f2:	83 ec 04             	sub    $0x4,%esp
  8026f5:	68 09 42 80 00       	push   $0x804209
  8026fa:	68 87 00 00 00       	push   $0x87
  8026ff:	68 97 41 80 00       	push   $0x804197
  802704:	e8 41 de ff ff       	call   80054a <_panic>
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 00                	mov    (%eax),%eax
  80270e:	85 c0                	test   %eax,%eax
  802710:	74 10                	je     802722 <alloc_block_FF+0x136>
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 00                	mov    (%eax),%eax
  802717:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80271a:	8b 52 04             	mov    0x4(%edx),%edx
  80271d:	89 50 04             	mov    %edx,0x4(%eax)
  802720:	eb 0b                	jmp    80272d <alloc_block_FF+0x141>
  802722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802725:	8b 40 04             	mov    0x4(%eax),%eax
  802728:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802730:	8b 40 04             	mov    0x4(%eax),%eax
  802733:	85 c0                	test   %eax,%eax
  802735:	74 0f                	je     802746 <alloc_block_FF+0x15a>
  802737:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273a:	8b 40 04             	mov    0x4(%eax),%eax
  80273d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802740:	8b 12                	mov    (%edx),%edx
  802742:	89 10                	mov    %edx,(%eax)
  802744:	eb 0a                	jmp    802750 <alloc_block_FF+0x164>
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	a3 38 51 80 00       	mov    %eax,0x805138
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802763:	a1 44 51 80 00       	mov    0x805144,%eax
  802768:	48                   	dec    %eax
  802769:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	eb 17                	jmp    80278a <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802776:	8b 00                	mov    (%eax),%eax
  802778:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  80277b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277f:	0f 85 7a fe ff ff    	jne    8025ff <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802785:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80278a:	c9                   	leave  
  80278b:	c3                   	ret    

0080278c <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80278c:	55                   	push   %ebp
  80278d:	89 e5                	mov    %esp,%ebp
  80278f:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802792:	a1 38 51 80 00       	mov    0x805138,%eax
  802797:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  80279a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8027a1:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8027a8:	a1 38 51 80 00       	mov    0x805138,%eax
  8027ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b0:	e9 d0 00 00 00       	jmp    802885 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027be:	0f 82 b8 00 00 00    	jb     80287c <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ca:	2b 45 08             	sub    0x8(%ebp),%eax
  8027cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8027d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027d6:	0f 83 a1 00 00 00    	jae    80287d <alloc_block_BF+0xf1>
				differsize = differance ;
  8027dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027df:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  8027e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  8027e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ec:	0f 85 8b 00 00 00    	jne    80287d <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  8027f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f6:	75 17                	jne    80280f <alloc_block_BF+0x83>
  8027f8:	83 ec 04             	sub    $0x4,%esp
  8027fb:	68 09 42 80 00       	push   $0x804209
  802800:	68 a0 00 00 00       	push   $0xa0
  802805:	68 97 41 80 00       	push   $0x804197
  80280a:	e8 3b dd ff ff       	call   80054a <_panic>
  80280f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802812:	8b 00                	mov    (%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	74 10                	je     802828 <alloc_block_BF+0x9c>
  802818:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802820:	8b 52 04             	mov    0x4(%edx),%edx
  802823:	89 50 04             	mov    %edx,0x4(%eax)
  802826:	eb 0b                	jmp    802833 <alloc_block_BF+0xa7>
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 40 04             	mov    0x4(%eax),%eax
  80282e:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	85 c0                	test   %eax,%eax
  80283b:	74 0f                	je     80284c <alloc_block_BF+0xc0>
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	8b 40 04             	mov    0x4(%eax),%eax
  802843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802846:	8b 12                	mov    (%edx),%edx
  802848:	89 10                	mov    %edx,(%eax)
  80284a:	eb 0a                	jmp    802856 <alloc_block_BF+0xca>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 00                	mov    (%eax),%eax
  802851:	a3 38 51 80 00       	mov    %eax,0x805138
  802856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802859:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802869:	a1 44 51 80 00       	mov    0x805144,%eax
  80286e:	48                   	dec    %eax
  80286f:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	e9 0c 01 00 00       	jmp    802988 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  80287c:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80287d:	a1 40 51 80 00       	mov    0x805140,%eax
  802882:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802889:	74 07                	je     802892 <alloc_block_BF+0x106>
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 00                	mov    (%eax),%eax
  802890:	eb 05                	jmp    802897 <alloc_block_BF+0x10b>
  802892:	b8 00 00 00 00       	mov    $0x0,%eax
  802897:	a3 40 51 80 00       	mov    %eax,0x805140
  80289c:	a1 40 51 80 00       	mov    0x805140,%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	0f 85 0c ff ff ff    	jne    8027b5 <alloc_block_BF+0x29>
  8028a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ad:	0f 85 02 ff ff ff    	jne    8027b5 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8028b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8028b7:	0f 84 c6 00 00 00    	je     802983 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8028bd:	a1 48 51 80 00       	mov    0x805148,%eax
  8028c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8028c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8028ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d1:	8b 50 08             	mov    0x8(%eax),%edx
  8028d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8028d7:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e0:	2b 45 08             	sub    0x8(%ebp),%eax
  8028e3:	89 c2                	mov    %eax,%edx
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 50 08             	mov    0x8(%eax),%edx
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	01 c2                	add    %eax,%edx
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  8028fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802900:	75 17                	jne    802919 <alloc_block_BF+0x18d>
  802902:	83 ec 04             	sub    $0x4,%esp
  802905:	68 09 42 80 00       	push   $0x804209
  80290a:	68 af 00 00 00       	push   $0xaf
  80290f:	68 97 41 80 00       	push   $0x804197
  802914:	e8 31 dc ff ff       	call   80054a <_panic>
  802919:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80291c:	8b 00                	mov    (%eax),%eax
  80291e:	85 c0                	test   %eax,%eax
  802920:	74 10                	je     802932 <alloc_block_BF+0x1a6>
  802922:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802925:	8b 00                	mov    (%eax),%eax
  802927:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80292a:	8b 52 04             	mov    0x4(%edx),%edx
  80292d:	89 50 04             	mov    %edx,0x4(%eax)
  802930:	eb 0b                	jmp    80293d <alloc_block_BF+0x1b1>
  802932:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802935:	8b 40 04             	mov    0x4(%eax),%eax
  802938:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80293d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802940:	8b 40 04             	mov    0x4(%eax),%eax
  802943:	85 c0                	test   %eax,%eax
  802945:	74 0f                	je     802956 <alloc_block_BF+0x1ca>
  802947:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80294a:	8b 40 04             	mov    0x4(%eax),%eax
  80294d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802950:	8b 12                	mov    (%edx),%edx
  802952:	89 10                	mov    %edx,(%eax)
  802954:	eb 0a                	jmp    802960 <alloc_block_BF+0x1d4>
  802956:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802959:	8b 00                	mov    (%eax),%eax
  80295b:	a3 48 51 80 00       	mov    %eax,0x805148
  802960:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802963:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802969:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80296c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802973:	a1 54 51 80 00       	mov    0x805154,%eax
  802978:	48                   	dec    %eax
  802979:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  80297e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802981:	eb 05                	jmp    802988 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802983:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802988:	c9                   	leave  
  802989:	c3                   	ret    

0080298a <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  80298a:	55                   	push   %ebp
  80298b:	89 e5                	mov    %esp,%ebp
  80298d:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802990:	a1 38 51 80 00       	mov    0x805138,%eax
  802995:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802998:	e9 7c 01 00 00       	jmp    802b19 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8029a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029a6:	0f 86 cf 00 00 00    	jbe    802a7b <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8029ac:	a1 48 51 80 00       	mov    0x805148,%eax
  8029b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8029b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8029ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c0:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8029c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c6:	8b 50 08             	mov    0x8(%eax),%edx
  8029c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029cc:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8029cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d5:	2b 45 08             	sub    0x8(%ebp),%eax
  8029d8:	89 c2                	mov    %eax,%edx
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  8029e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e3:	8b 50 08             	mov    0x8(%eax),%edx
  8029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e9:	01 c2                	add    %eax,%edx
  8029eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ee:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8029f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029f5:	75 17                	jne    802a0e <alloc_block_NF+0x84>
  8029f7:	83 ec 04             	sub    $0x4,%esp
  8029fa:	68 09 42 80 00       	push   $0x804209
  8029ff:	68 c4 00 00 00       	push   $0xc4
  802a04:	68 97 41 80 00       	push   $0x804197
  802a09:	e8 3c db ff ff       	call   80054a <_panic>
  802a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	74 10                	je     802a27 <alloc_block_NF+0x9d>
  802a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a1f:	8b 52 04             	mov    0x4(%edx),%edx
  802a22:	89 50 04             	mov    %edx,0x4(%eax)
  802a25:	eb 0b                	jmp    802a32 <alloc_block_NF+0xa8>
  802a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2a:	8b 40 04             	mov    0x4(%eax),%eax
  802a2d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a35:	8b 40 04             	mov    0x4(%eax),%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	74 0f                	je     802a4b <alloc_block_NF+0xc1>
  802a3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a3f:	8b 40 04             	mov    0x4(%eax),%eax
  802a42:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a45:	8b 12                	mov    (%edx),%edx
  802a47:	89 10                	mov    %edx,(%eax)
  802a49:	eb 0a                	jmp    802a55 <alloc_block_NF+0xcb>
  802a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a4e:	8b 00                	mov    (%eax),%eax
  802a50:	a3 48 51 80 00       	mov    %eax,0x805148
  802a55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a68:	a1 54 51 80 00       	mov    0x805154,%eax
  802a6d:	48                   	dec    %eax
  802a6e:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a76:	e9 ad 00 00 00       	jmp    802b28 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802a81:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a84:	0f 85 87 00 00 00    	jne    802b11 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802a8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a8e:	75 17                	jne    802aa7 <alloc_block_NF+0x11d>
  802a90:	83 ec 04             	sub    $0x4,%esp
  802a93:	68 09 42 80 00       	push   $0x804209
  802a98:	68 c8 00 00 00       	push   $0xc8
  802a9d:	68 97 41 80 00       	push   $0x804197
  802aa2:	e8 a3 da ff ff       	call   80054a <_panic>
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	74 10                	je     802ac0 <alloc_block_NF+0x136>
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ab8:	8b 52 04             	mov    0x4(%edx),%edx
  802abb:	89 50 04             	mov    %edx,0x4(%eax)
  802abe:	eb 0b                	jmp    802acb <alloc_block_NF+0x141>
  802ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac3:	8b 40 04             	mov    0x4(%eax),%eax
  802ac6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ace:	8b 40 04             	mov    0x4(%eax),%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	74 0f                	je     802ae4 <alloc_block_NF+0x15a>
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 40 04             	mov    0x4(%eax),%eax
  802adb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ade:	8b 12                	mov    (%edx),%edx
  802ae0:	89 10                	mov    %edx,(%eax)
  802ae2:	eb 0a                	jmp    802aee <alloc_block_NF+0x164>
  802ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae7:	8b 00                	mov    (%eax),%eax
  802ae9:	a3 38 51 80 00       	mov    %eax,0x805138
  802aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802afa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b01:	a1 44 51 80 00       	mov    0x805144,%eax
  802b06:	48                   	dec    %eax
  802b07:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	eb 17                	jmp    802b28 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b14:	8b 00                	mov    (%eax),%eax
  802b16:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802b19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b1d:	0f 85 7a fe ff ff    	jne    80299d <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802b23:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802b28:	c9                   	leave  
  802b29:	c3                   	ret    

00802b2a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b2a:	55                   	push   %ebp
  802b2b:	89 e5                	mov    %esp,%ebp
  802b2d:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802b30:	a1 38 51 80 00       	mov    0x805138,%eax
  802b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802b38:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802b40:	a1 44 51 80 00       	mov    0x805144,%eax
  802b45:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802b48:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b4c:	75 68                	jne    802bb6 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802b4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b52:	75 17                	jne    802b6b <insert_sorted_with_merge_freeList+0x41>
  802b54:	83 ec 04             	sub    $0x4,%esp
  802b57:	68 74 41 80 00       	push   $0x804174
  802b5c:	68 da 00 00 00       	push   $0xda
  802b61:	68 97 41 80 00       	push   $0x804197
  802b66:	e8 df d9 ff ff       	call   80054a <_panic>
  802b6b:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	89 10                	mov    %edx,(%eax)
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	85 c0                	test   %eax,%eax
  802b7d:	74 0d                	je     802b8c <insert_sorted_with_merge_freeList+0x62>
  802b7f:	a1 38 51 80 00       	mov    0x805138,%eax
  802b84:	8b 55 08             	mov    0x8(%ebp),%edx
  802b87:	89 50 04             	mov    %edx,0x4(%eax)
  802b8a:	eb 08                	jmp    802b94 <insert_sorted_with_merge_freeList+0x6a>
  802b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	a3 38 51 80 00       	mov    %eax,0x805138
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba6:	a1 44 51 80 00       	mov    0x805144,%eax
  802bab:	40                   	inc    %eax
  802bac:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802bb1:	e9 49 07 00 00       	jmp    8032ff <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc2:	01 c2                	add    %eax,%edx
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	8b 40 08             	mov    0x8(%eax),%eax
  802bca:	39 c2                	cmp    %eax,%edx
  802bcc:	73 77                	jae    802c45 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	75 6e                	jne    802c45 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802bd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bdb:	74 68                	je     802c45 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802bdd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be1:	75 17                	jne    802bfa <insert_sorted_with_merge_freeList+0xd0>
  802be3:	83 ec 04             	sub    $0x4,%esp
  802be6:	68 b0 41 80 00       	push   $0x8041b0
  802beb:	68 e0 00 00 00       	push   $0xe0
  802bf0:	68 97 41 80 00       	push   $0x804197
  802bf5:	e8 50 d9 ff ff       	call   80054a <_panic>
  802bfa:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	89 50 04             	mov    %edx,0x4(%eax)
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 40 04             	mov    0x4(%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0c                	je     802c1c <insert_sorted_with_merge_freeList+0xf2>
  802c10:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c15:	8b 55 08             	mov    0x8(%ebp),%edx
  802c18:	89 10                	mov    %edx,(%eax)
  802c1a:	eb 08                	jmp    802c24 <insert_sorted_with_merge_freeList+0xfa>
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	a3 38 51 80 00       	mov    %eax,0x805138
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c35:	a1 44 51 80 00       	mov    0x805144,%eax
  802c3a:	40                   	inc    %eax
  802c3b:	a3 44 51 80 00       	mov    %eax,0x805144
  802c40:	e9 ba 06 00 00       	jmp    8032ff <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802c45:	8b 45 08             	mov    0x8(%ebp),%eax
  802c48:	8b 50 0c             	mov    0xc(%eax),%edx
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8b 40 08             	mov    0x8(%eax),%eax
  802c51:	01 c2                	add    %eax,%edx
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	8b 40 08             	mov    0x8(%eax),%eax
  802c59:	39 c2                	cmp    %eax,%edx
  802c5b:	73 78                	jae    802cd5 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 04             	mov    0x4(%eax),%eax
  802c63:	85 c0                	test   %eax,%eax
  802c65:	75 6e                	jne    802cd5 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802c67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c6b:	74 68                	je     802cd5 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802c6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c71:	75 17                	jne    802c8a <insert_sorted_with_merge_freeList+0x160>
  802c73:	83 ec 04             	sub    $0x4,%esp
  802c76:	68 74 41 80 00       	push   $0x804174
  802c7b:	68 e6 00 00 00       	push   $0xe6
  802c80:	68 97 41 80 00       	push   $0x804197
  802c85:	e8 c0 d8 ff ff       	call   80054a <_panic>
  802c8a:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	89 10                	mov    %edx,(%eax)
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	8b 00                	mov    (%eax),%eax
  802c9a:	85 c0                	test   %eax,%eax
  802c9c:	74 0d                	je     802cab <insert_sorted_with_merge_freeList+0x181>
  802c9e:	a1 38 51 80 00       	mov    0x805138,%eax
  802ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca6:	89 50 04             	mov    %edx,0x4(%eax)
  802ca9:	eb 08                	jmp    802cb3 <insert_sorted_with_merge_freeList+0x189>
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	a3 38 51 80 00       	mov    %eax,0x805138
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc5:	a1 44 51 80 00       	mov    0x805144,%eax
  802cca:	40                   	inc    %eax
  802ccb:	a3 44 51 80 00       	mov    %eax,0x805144
  802cd0:	e9 2a 06 00 00       	jmp    8032ff <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802cd5:	a1 38 51 80 00       	mov    0x805138,%eax
  802cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cdd:	e9 ed 05 00 00       	jmp    8032cf <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	8b 00                	mov    (%eax),%eax
  802ce7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802cea:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802cee:	0f 84 a7 00 00 00    	je     802d9b <insert_sorted_with_merge_freeList+0x271>
  802cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf7:	8b 50 0c             	mov    0xc(%eax),%edx
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	8b 40 08             	mov    0x8(%eax),%eax
  802d00:	01 c2                	add    %eax,%edx
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	8b 40 08             	mov    0x8(%eax),%eax
  802d08:	39 c2                	cmp    %eax,%edx
  802d0a:	0f 83 8b 00 00 00    	jae    802d9b <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	8b 50 0c             	mov    0xc(%eax),%edx
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 40 08             	mov    0x8(%eax),%eax
  802d1c:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d21:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802d24:	39 c2                	cmp    %eax,%edx
  802d26:	73 73                	jae    802d9b <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802d28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d2c:	74 06                	je     802d34 <insert_sorted_with_merge_freeList+0x20a>
  802d2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d32:	75 17                	jne    802d4b <insert_sorted_with_merge_freeList+0x221>
  802d34:	83 ec 04             	sub    $0x4,%esp
  802d37:	68 28 42 80 00       	push   $0x804228
  802d3c:	68 f0 00 00 00       	push   $0xf0
  802d41:	68 97 41 80 00       	push   $0x804197
  802d46:	e8 ff d7 ff ff       	call   80054a <_panic>
  802d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4e:	8b 10                	mov    (%eax),%edx
  802d50:	8b 45 08             	mov    0x8(%ebp),%eax
  802d53:	89 10                	mov    %edx,(%eax)
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 00                	mov    (%eax),%eax
  802d5a:	85 c0                	test   %eax,%eax
  802d5c:	74 0b                	je     802d69 <insert_sorted_with_merge_freeList+0x23f>
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 00                	mov    (%eax),%eax
  802d63:	8b 55 08             	mov    0x8(%ebp),%edx
  802d66:	89 50 04             	mov    %edx,0x4(%eax)
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6f:	89 10                	mov    %edx,(%eax)
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d77:	89 50 04             	mov    %edx,0x4(%eax)
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	75 08                	jne    802d8b <insert_sorted_with_merge_freeList+0x261>
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d8b:	a1 44 51 80 00       	mov    0x805144,%eax
  802d90:	40                   	inc    %eax
  802d91:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  802d96:	e9 64 05 00 00       	jmp    8032ff <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802d9b:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802da0:	8b 50 0c             	mov    0xc(%eax),%edx
  802da3:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802da8:	8b 40 08             	mov    0x8(%eax),%eax
  802dab:	01 c2                	add    %eax,%edx
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	8b 40 08             	mov    0x8(%eax),%eax
  802db3:	39 c2                	cmp    %eax,%edx
  802db5:	0f 85 b1 00 00 00    	jne    802e6c <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802dbb:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dc0:	85 c0                	test   %eax,%eax
  802dc2:	0f 84 a4 00 00 00    	je     802e6c <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802dc8:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dcd:	8b 00                	mov    (%eax),%eax
  802dcf:	85 c0                	test   %eax,%eax
  802dd1:	0f 85 95 00 00 00    	jne    802e6c <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802dd7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ddc:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802de2:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802de5:	8b 55 08             	mov    0x8(%ebp),%edx
  802de8:	8b 52 0c             	mov    0xc(%edx),%edx
  802deb:	01 ca                	add    %ecx,%edx
  802ded:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e08:	75 17                	jne    802e21 <insert_sorted_with_merge_freeList+0x2f7>
  802e0a:	83 ec 04             	sub    $0x4,%esp
  802e0d:	68 74 41 80 00       	push   $0x804174
  802e12:	68 ff 00 00 00       	push   $0xff
  802e17:	68 97 41 80 00       	push   $0x804197
  802e1c:	e8 29 d7 ff ff       	call   80054a <_panic>
  802e21:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	89 10                	mov    %edx,(%eax)
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	85 c0                	test   %eax,%eax
  802e33:	74 0d                	je     802e42 <insert_sorted_with_merge_freeList+0x318>
  802e35:	a1 48 51 80 00       	mov    0x805148,%eax
  802e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3d:	89 50 04             	mov    %edx,0x4(%eax)
  802e40:	eb 08                	jmp    802e4a <insert_sorted_with_merge_freeList+0x320>
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	a3 48 51 80 00       	mov    %eax,0x805148
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5c:	a1 54 51 80 00       	mov    0x805154,%eax
  802e61:	40                   	inc    %eax
  802e62:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  802e67:	e9 93 04 00 00       	jmp    8032ff <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6f:	8b 50 08             	mov    0x8(%eax),%edx
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	8b 40 0c             	mov    0xc(%eax),%eax
  802e78:	01 c2                	add    %eax,%edx
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	8b 40 08             	mov    0x8(%eax),%eax
  802e80:	39 c2                	cmp    %eax,%edx
  802e82:	0f 85 ae 00 00 00    	jne    802f36 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	8b 40 08             	mov    0x8(%eax),%eax
  802e94:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802e9e:	39 c2                	cmp    %eax,%edx
  802ea0:	0f 84 90 00 00 00    	je     802f36 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea9:	8b 50 0c             	mov    0xc(%eax),%edx
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb2:	01 c2                	add    %eax,%edx
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802ece:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed2:	75 17                	jne    802eeb <insert_sorted_with_merge_freeList+0x3c1>
  802ed4:	83 ec 04             	sub    $0x4,%esp
  802ed7:	68 74 41 80 00       	push   $0x804174
  802edc:	68 0b 01 00 00       	push   $0x10b
  802ee1:	68 97 41 80 00       	push   $0x804197
  802ee6:	e8 5f d6 ff ff       	call   80054a <_panic>
  802eeb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	89 10                	mov    %edx,(%eax)
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	8b 00                	mov    (%eax),%eax
  802efb:	85 c0                	test   %eax,%eax
  802efd:	74 0d                	je     802f0c <insert_sorted_with_merge_freeList+0x3e2>
  802eff:	a1 48 51 80 00       	mov    0x805148,%eax
  802f04:	8b 55 08             	mov    0x8(%ebp),%edx
  802f07:	89 50 04             	mov    %edx,0x4(%eax)
  802f0a:	eb 08                	jmp    802f14 <insert_sorted_with_merge_freeList+0x3ea>
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	a3 48 51 80 00       	mov    %eax,0x805148
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f26:	a1 54 51 80 00       	mov    0x805154,%eax
  802f2b:	40                   	inc    %eax
  802f2c:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  802f31:	e9 c9 03 00 00       	jmp    8032ff <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	8b 40 08             	mov    0x8(%eax),%eax
  802f42:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802f4a:	39 c2                	cmp    %eax,%edx
  802f4c:	0f 85 bb 00 00 00    	jne    80300d <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f56:	0f 84 b1 00 00 00    	je     80300d <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5f:	8b 40 04             	mov    0x4(%eax),%eax
  802f62:	85 c0                	test   %eax,%eax
  802f64:	0f 85 a3 00 00 00    	jne    80300d <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802f6a:	a1 38 51 80 00       	mov    0x805138,%eax
  802f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f72:	8b 52 08             	mov    0x8(%edx),%edx
  802f75:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802f78:	a1 38 51 80 00       	mov    0x805138,%eax
  802f7d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f83:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f86:	8b 55 08             	mov    0x8(%ebp),%edx
  802f89:	8b 52 0c             	mov    0xc(%edx),%edx
  802f8c:	01 ca                	add    %ecx,%edx
  802f8e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802fa5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa9:	75 17                	jne    802fc2 <insert_sorted_with_merge_freeList+0x498>
  802fab:	83 ec 04             	sub    $0x4,%esp
  802fae:	68 74 41 80 00       	push   $0x804174
  802fb3:	68 17 01 00 00       	push   $0x117
  802fb8:	68 97 41 80 00       	push   $0x804197
  802fbd:	e8 88 d5 ff ff       	call   80054a <_panic>
  802fc2:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	89 10                	mov    %edx,(%eax)
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	8b 00                	mov    (%eax),%eax
  802fd2:	85 c0                	test   %eax,%eax
  802fd4:	74 0d                	je     802fe3 <insert_sorted_with_merge_freeList+0x4b9>
  802fd6:	a1 48 51 80 00       	mov    0x805148,%eax
  802fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fde:	89 50 04             	mov    %edx,0x4(%eax)
  802fe1:	eb 08                	jmp    802feb <insert_sorted_with_merge_freeList+0x4c1>
  802fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	a3 48 51 80 00       	mov    %eax,0x805148
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffd:	a1 54 51 80 00       	mov    0x805154,%eax
  803002:	40                   	inc    %eax
  803003:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803008:	e9 f2 02 00 00       	jmp    8032ff <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	8b 50 08             	mov    0x8(%eax),%edx
  803013:	8b 45 08             	mov    0x8(%ebp),%eax
  803016:	8b 40 0c             	mov    0xc(%eax),%eax
  803019:	01 c2                	add    %eax,%edx
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 40 08             	mov    0x8(%eax),%eax
  803021:	39 c2                	cmp    %eax,%edx
  803023:	0f 85 be 00 00 00    	jne    8030e7 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302c:	8b 40 04             	mov    0x4(%eax),%eax
  80302f:	8b 50 08             	mov    0x8(%eax),%edx
  803032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803035:	8b 40 04             	mov    0x4(%eax),%eax
  803038:	8b 40 0c             	mov    0xc(%eax),%eax
  80303b:	01 c2                	add    %eax,%edx
  80303d:	8b 45 08             	mov    0x8(%ebp),%eax
  803040:	8b 40 08             	mov    0x8(%eax),%eax
  803043:	39 c2                	cmp    %eax,%edx
  803045:	0f 84 9c 00 00 00    	je     8030e7 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	8b 50 08             	mov    0x8(%eax),%edx
  803051:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803054:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	8b 50 0c             	mov    0xc(%eax),%edx
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	8b 40 0c             	mov    0xc(%eax),%eax
  803063:	01 c2                	add    %eax,%edx
  803065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803068:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80306b:	8b 45 08             	mov    0x8(%ebp),%eax
  80306e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80307f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803083:	75 17                	jne    80309c <insert_sorted_with_merge_freeList+0x572>
  803085:	83 ec 04             	sub    $0x4,%esp
  803088:	68 74 41 80 00       	push   $0x804174
  80308d:	68 26 01 00 00       	push   $0x126
  803092:	68 97 41 80 00       	push   $0x804197
  803097:	e8 ae d4 ff ff       	call   80054a <_panic>
  80309c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	89 10                	mov    %edx,(%eax)
  8030a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	85 c0                	test   %eax,%eax
  8030ae:	74 0d                	je     8030bd <insert_sorted_with_merge_freeList+0x593>
  8030b0:	a1 48 51 80 00       	mov    0x805148,%eax
  8030b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8030b8:	89 50 04             	mov    %edx,0x4(%eax)
  8030bb:	eb 08                	jmp    8030c5 <insert_sorted_with_merge_freeList+0x59b>
  8030bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	a3 48 51 80 00       	mov    %eax,0x805148
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030d7:	a1 54 51 80 00       	mov    0x805154,%eax
  8030dc:	40                   	inc    %eax
  8030dd:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  8030e2:	e9 18 02 00 00       	jmp    8032ff <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 50 0c             	mov    0xc(%eax),%edx
  8030ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f0:	8b 40 08             	mov    0x8(%eax),%eax
  8030f3:	01 c2                	add    %eax,%edx
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	8b 40 08             	mov    0x8(%eax),%eax
  8030fb:	39 c2                	cmp    %eax,%edx
  8030fd:	0f 85 c4 01 00 00    	jne    8032c7 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803103:	8b 45 08             	mov    0x8(%ebp),%eax
  803106:	8b 50 0c             	mov    0xc(%eax),%edx
  803109:	8b 45 08             	mov    0x8(%ebp),%eax
  80310c:	8b 40 08             	mov    0x8(%eax),%eax
  80310f:	01 c2                	add    %eax,%edx
  803111:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803114:	8b 00                	mov    (%eax),%eax
  803116:	8b 40 08             	mov    0x8(%eax),%eax
  803119:	39 c2                	cmp    %eax,%edx
  80311b:	0f 85 a6 01 00 00    	jne    8032c7 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803121:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803125:	0f 84 9c 01 00 00    	je     8032c7 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	8b 50 0c             	mov    0xc(%eax),%edx
  803131:	8b 45 08             	mov    0x8(%ebp),%eax
  803134:	8b 40 0c             	mov    0xc(%eax),%eax
  803137:	01 c2                	add    %eax,%edx
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	8b 00                	mov    (%eax),%eax
  80313e:	8b 40 0c             	mov    0xc(%eax),%eax
  803141:	01 c2                	add    %eax,%edx
  803143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803146:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80315d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803161:	75 17                	jne    80317a <insert_sorted_with_merge_freeList+0x650>
  803163:	83 ec 04             	sub    $0x4,%esp
  803166:	68 74 41 80 00       	push   $0x804174
  80316b:	68 32 01 00 00       	push   $0x132
  803170:	68 97 41 80 00       	push   $0x804197
  803175:	e8 d0 d3 ff ff       	call   80054a <_panic>
  80317a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803180:	8b 45 08             	mov    0x8(%ebp),%eax
  803183:	89 10                	mov    %edx,(%eax)
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	8b 00                	mov    (%eax),%eax
  80318a:	85 c0                	test   %eax,%eax
  80318c:	74 0d                	je     80319b <insert_sorted_with_merge_freeList+0x671>
  80318e:	a1 48 51 80 00       	mov    0x805148,%eax
  803193:	8b 55 08             	mov    0x8(%ebp),%edx
  803196:	89 50 04             	mov    %edx,0x4(%eax)
  803199:	eb 08                	jmp    8031a3 <insert_sorted_with_merge_freeList+0x679>
  80319b:	8b 45 08             	mov    0x8(%ebp),%eax
  80319e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8031ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8031ba:	40                   	inc    %eax
  8031bb:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  8031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c3:	8b 00                	mov    (%eax),%eax
  8031c5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  8031cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cf:	8b 00                	mov    (%eax),%eax
  8031d1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  8031d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031db:	8b 00                	mov    (%eax),%eax
  8031dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  8031e0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8031e4:	75 17                	jne    8031fd <insert_sorted_with_merge_freeList+0x6d3>
  8031e6:	83 ec 04             	sub    $0x4,%esp
  8031e9:	68 09 42 80 00       	push   $0x804209
  8031ee:	68 36 01 00 00       	push   $0x136
  8031f3:	68 97 41 80 00       	push   $0x804197
  8031f8:	e8 4d d3 ff ff       	call   80054a <_panic>
  8031fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803200:	8b 00                	mov    (%eax),%eax
  803202:	85 c0                	test   %eax,%eax
  803204:	74 10                	je     803216 <insert_sorted_with_merge_freeList+0x6ec>
  803206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803209:	8b 00                	mov    (%eax),%eax
  80320b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80320e:	8b 52 04             	mov    0x4(%edx),%edx
  803211:	89 50 04             	mov    %edx,0x4(%eax)
  803214:	eb 0b                	jmp    803221 <insert_sorted_with_merge_freeList+0x6f7>
  803216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803219:	8b 40 04             	mov    0x4(%eax),%eax
  80321c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803221:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803224:	8b 40 04             	mov    0x4(%eax),%eax
  803227:	85 c0                	test   %eax,%eax
  803229:	74 0f                	je     80323a <insert_sorted_with_merge_freeList+0x710>
  80322b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80322e:	8b 40 04             	mov    0x4(%eax),%eax
  803231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803234:	8b 12                	mov    (%edx),%edx
  803236:	89 10                	mov    %edx,(%eax)
  803238:	eb 0a                	jmp    803244 <insert_sorted_with_merge_freeList+0x71a>
  80323a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80323d:	8b 00                	mov    (%eax),%eax
  80323f:	a3 38 51 80 00       	mov    %eax,0x805138
  803244:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803247:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80324d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803250:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803257:	a1 44 51 80 00       	mov    0x805144,%eax
  80325c:	48                   	dec    %eax
  80325d:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803262:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803266:	75 17                	jne    80327f <insert_sorted_with_merge_freeList+0x755>
  803268:	83 ec 04             	sub    $0x4,%esp
  80326b:	68 74 41 80 00       	push   $0x804174
  803270:	68 37 01 00 00       	push   $0x137
  803275:	68 97 41 80 00       	push   $0x804197
  80327a:	e8 cb d2 ff ff       	call   80054a <_panic>
  80327f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803288:	89 10                	mov    %edx,(%eax)
  80328a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	85 c0                	test   %eax,%eax
  803291:	74 0d                	je     8032a0 <insert_sorted_with_merge_freeList+0x776>
  803293:	a1 48 51 80 00       	mov    0x805148,%eax
  803298:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80329b:	89 50 04             	mov    %edx,0x4(%eax)
  80329e:	eb 08                	jmp    8032a8 <insert_sorted_with_merge_freeList+0x77e>
  8032a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8032b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8032bf:	40                   	inc    %eax
  8032c0:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  8032c5:	eb 38                	jmp    8032ff <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8032c7:	a1 40 51 80 00       	mov    0x805140,%eax
  8032cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8032cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032d3:	74 07                	je     8032dc <insert_sorted_with_merge_freeList+0x7b2>
  8032d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d8:	8b 00                	mov    (%eax),%eax
  8032da:	eb 05                	jmp    8032e1 <insert_sorted_with_merge_freeList+0x7b7>
  8032dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8032e1:	a3 40 51 80 00       	mov    %eax,0x805140
  8032e6:	a1 40 51 80 00       	mov    0x805140,%eax
  8032eb:	85 c0                	test   %eax,%eax
  8032ed:	0f 85 ef f9 ff ff    	jne    802ce2 <insert_sorted_with_merge_freeList+0x1b8>
  8032f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f7:	0f 85 e5 f9 ff ff    	jne    802ce2 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8032fd:	eb 00                	jmp    8032ff <insert_sorted_with_merge_freeList+0x7d5>
  8032ff:	90                   	nop
  803300:	c9                   	leave  
  803301:	c3                   	ret    

00803302 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803302:	55                   	push   %ebp
  803303:	89 e5                	mov    %esp,%ebp
  803305:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803308:	8b 55 08             	mov    0x8(%ebp),%edx
  80330b:	89 d0                	mov    %edx,%eax
  80330d:	c1 e0 02             	shl    $0x2,%eax
  803310:	01 d0                	add    %edx,%eax
  803312:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803319:	01 d0                	add    %edx,%eax
  80331b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803322:	01 d0                	add    %edx,%eax
  803324:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80332b:	01 d0                	add    %edx,%eax
  80332d:	c1 e0 04             	shl    $0x4,%eax
  803330:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803333:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80333a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80333d:	83 ec 0c             	sub    $0xc,%esp
  803340:	50                   	push   %eax
  803341:	e8 21 ec ff ff       	call   801f67 <sys_get_virtual_time>
  803346:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803349:	eb 41                	jmp    80338c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80334b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80334e:	83 ec 0c             	sub    $0xc,%esp
  803351:	50                   	push   %eax
  803352:	e8 10 ec ff ff       	call   801f67 <sys_get_virtual_time>
  803357:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80335a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80335d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803360:	29 c2                	sub    %eax,%edx
  803362:	89 d0                	mov    %edx,%eax
  803364:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803367:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80336a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80336d:	89 d1                	mov    %edx,%ecx
  80336f:	29 c1                	sub    %eax,%ecx
  803371:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803374:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803377:	39 c2                	cmp    %eax,%edx
  803379:	0f 97 c0             	seta   %al
  80337c:	0f b6 c0             	movzbl %al,%eax
  80337f:	29 c1                	sub    %eax,%ecx
  803381:	89 c8                	mov    %ecx,%eax
  803383:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803386:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803389:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80338c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803392:	72 b7                	jb     80334b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803394:	90                   	nop
  803395:	c9                   	leave  
  803396:	c3                   	ret    

00803397 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803397:	55                   	push   %ebp
  803398:	89 e5                	mov    %esp,%ebp
  80339a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80339d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8033a4:	eb 03                	jmp    8033a9 <busy_wait+0x12>
  8033a6:	ff 45 fc             	incl   -0x4(%ebp)
  8033a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8033ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8033af:	72 f5                	jb     8033a6 <busy_wait+0xf>
	return i;
  8033b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8033b4:	c9                   	leave  
  8033b5:	c3                   	ret    
  8033b6:	66 90                	xchg   %ax,%ax

008033b8 <__udivdi3>:
  8033b8:	55                   	push   %ebp
  8033b9:	57                   	push   %edi
  8033ba:	56                   	push   %esi
  8033bb:	53                   	push   %ebx
  8033bc:	83 ec 1c             	sub    $0x1c,%esp
  8033bf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8033c3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8033c7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8033cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033cf:	89 ca                	mov    %ecx,%edx
  8033d1:	89 f8                	mov    %edi,%eax
  8033d3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8033d7:	85 f6                	test   %esi,%esi
  8033d9:	75 2d                	jne    803408 <__udivdi3+0x50>
  8033db:	39 cf                	cmp    %ecx,%edi
  8033dd:	77 65                	ja     803444 <__udivdi3+0x8c>
  8033df:	89 fd                	mov    %edi,%ebp
  8033e1:	85 ff                	test   %edi,%edi
  8033e3:	75 0b                	jne    8033f0 <__udivdi3+0x38>
  8033e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8033ea:	31 d2                	xor    %edx,%edx
  8033ec:	f7 f7                	div    %edi
  8033ee:	89 c5                	mov    %eax,%ebp
  8033f0:	31 d2                	xor    %edx,%edx
  8033f2:	89 c8                	mov    %ecx,%eax
  8033f4:	f7 f5                	div    %ebp
  8033f6:	89 c1                	mov    %eax,%ecx
  8033f8:	89 d8                	mov    %ebx,%eax
  8033fa:	f7 f5                	div    %ebp
  8033fc:	89 cf                	mov    %ecx,%edi
  8033fe:	89 fa                	mov    %edi,%edx
  803400:	83 c4 1c             	add    $0x1c,%esp
  803403:	5b                   	pop    %ebx
  803404:	5e                   	pop    %esi
  803405:	5f                   	pop    %edi
  803406:	5d                   	pop    %ebp
  803407:	c3                   	ret    
  803408:	39 ce                	cmp    %ecx,%esi
  80340a:	77 28                	ja     803434 <__udivdi3+0x7c>
  80340c:	0f bd fe             	bsr    %esi,%edi
  80340f:	83 f7 1f             	xor    $0x1f,%edi
  803412:	75 40                	jne    803454 <__udivdi3+0x9c>
  803414:	39 ce                	cmp    %ecx,%esi
  803416:	72 0a                	jb     803422 <__udivdi3+0x6a>
  803418:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80341c:	0f 87 9e 00 00 00    	ja     8034c0 <__udivdi3+0x108>
  803422:	b8 01 00 00 00       	mov    $0x1,%eax
  803427:	89 fa                	mov    %edi,%edx
  803429:	83 c4 1c             	add    $0x1c,%esp
  80342c:	5b                   	pop    %ebx
  80342d:	5e                   	pop    %esi
  80342e:	5f                   	pop    %edi
  80342f:	5d                   	pop    %ebp
  803430:	c3                   	ret    
  803431:	8d 76 00             	lea    0x0(%esi),%esi
  803434:	31 ff                	xor    %edi,%edi
  803436:	31 c0                	xor    %eax,%eax
  803438:	89 fa                	mov    %edi,%edx
  80343a:	83 c4 1c             	add    $0x1c,%esp
  80343d:	5b                   	pop    %ebx
  80343e:	5e                   	pop    %esi
  80343f:	5f                   	pop    %edi
  803440:	5d                   	pop    %ebp
  803441:	c3                   	ret    
  803442:	66 90                	xchg   %ax,%ax
  803444:	89 d8                	mov    %ebx,%eax
  803446:	f7 f7                	div    %edi
  803448:	31 ff                	xor    %edi,%edi
  80344a:	89 fa                	mov    %edi,%edx
  80344c:	83 c4 1c             	add    $0x1c,%esp
  80344f:	5b                   	pop    %ebx
  803450:	5e                   	pop    %esi
  803451:	5f                   	pop    %edi
  803452:	5d                   	pop    %ebp
  803453:	c3                   	ret    
  803454:	bd 20 00 00 00       	mov    $0x20,%ebp
  803459:	89 eb                	mov    %ebp,%ebx
  80345b:	29 fb                	sub    %edi,%ebx
  80345d:	89 f9                	mov    %edi,%ecx
  80345f:	d3 e6                	shl    %cl,%esi
  803461:	89 c5                	mov    %eax,%ebp
  803463:	88 d9                	mov    %bl,%cl
  803465:	d3 ed                	shr    %cl,%ebp
  803467:	89 e9                	mov    %ebp,%ecx
  803469:	09 f1                	or     %esi,%ecx
  80346b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80346f:	89 f9                	mov    %edi,%ecx
  803471:	d3 e0                	shl    %cl,%eax
  803473:	89 c5                	mov    %eax,%ebp
  803475:	89 d6                	mov    %edx,%esi
  803477:	88 d9                	mov    %bl,%cl
  803479:	d3 ee                	shr    %cl,%esi
  80347b:	89 f9                	mov    %edi,%ecx
  80347d:	d3 e2                	shl    %cl,%edx
  80347f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803483:	88 d9                	mov    %bl,%cl
  803485:	d3 e8                	shr    %cl,%eax
  803487:	09 c2                	or     %eax,%edx
  803489:	89 d0                	mov    %edx,%eax
  80348b:	89 f2                	mov    %esi,%edx
  80348d:	f7 74 24 0c          	divl   0xc(%esp)
  803491:	89 d6                	mov    %edx,%esi
  803493:	89 c3                	mov    %eax,%ebx
  803495:	f7 e5                	mul    %ebp
  803497:	39 d6                	cmp    %edx,%esi
  803499:	72 19                	jb     8034b4 <__udivdi3+0xfc>
  80349b:	74 0b                	je     8034a8 <__udivdi3+0xf0>
  80349d:	89 d8                	mov    %ebx,%eax
  80349f:	31 ff                	xor    %edi,%edi
  8034a1:	e9 58 ff ff ff       	jmp    8033fe <__udivdi3+0x46>
  8034a6:	66 90                	xchg   %ax,%ax
  8034a8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8034ac:	89 f9                	mov    %edi,%ecx
  8034ae:	d3 e2                	shl    %cl,%edx
  8034b0:	39 c2                	cmp    %eax,%edx
  8034b2:	73 e9                	jae    80349d <__udivdi3+0xe5>
  8034b4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8034b7:	31 ff                	xor    %edi,%edi
  8034b9:	e9 40 ff ff ff       	jmp    8033fe <__udivdi3+0x46>
  8034be:	66 90                	xchg   %ax,%ax
  8034c0:	31 c0                	xor    %eax,%eax
  8034c2:	e9 37 ff ff ff       	jmp    8033fe <__udivdi3+0x46>
  8034c7:	90                   	nop

008034c8 <__umoddi3>:
  8034c8:	55                   	push   %ebp
  8034c9:	57                   	push   %edi
  8034ca:	56                   	push   %esi
  8034cb:	53                   	push   %ebx
  8034cc:	83 ec 1c             	sub    $0x1c,%esp
  8034cf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8034d3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8034d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8034df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8034e3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8034e7:	89 f3                	mov    %esi,%ebx
  8034e9:	89 fa                	mov    %edi,%edx
  8034eb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8034ef:	89 34 24             	mov    %esi,(%esp)
  8034f2:	85 c0                	test   %eax,%eax
  8034f4:	75 1a                	jne    803510 <__umoddi3+0x48>
  8034f6:	39 f7                	cmp    %esi,%edi
  8034f8:	0f 86 a2 00 00 00    	jbe    8035a0 <__umoddi3+0xd8>
  8034fe:	89 c8                	mov    %ecx,%eax
  803500:	89 f2                	mov    %esi,%edx
  803502:	f7 f7                	div    %edi
  803504:	89 d0                	mov    %edx,%eax
  803506:	31 d2                	xor    %edx,%edx
  803508:	83 c4 1c             	add    $0x1c,%esp
  80350b:	5b                   	pop    %ebx
  80350c:	5e                   	pop    %esi
  80350d:	5f                   	pop    %edi
  80350e:	5d                   	pop    %ebp
  80350f:	c3                   	ret    
  803510:	39 f0                	cmp    %esi,%eax
  803512:	0f 87 ac 00 00 00    	ja     8035c4 <__umoddi3+0xfc>
  803518:	0f bd e8             	bsr    %eax,%ebp
  80351b:	83 f5 1f             	xor    $0x1f,%ebp
  80351e:	0f 84 ac 00 00 00    	je     8035d0 <__umoddi3+0x108>
  803524:	bf 20 00 00 00       	mov    $0x20,%edi
  803529:	29 ef                	sub    %ebp,%edi
  80352b:	89 fe                	mov    %edi,%esi
  80352d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803531:	89 e9                	mov    %ebp,%ecx
  803533:	d3 e0                	shl    %cl,%eax
  803535:	89 d7                	mov    %edx,%edi
  803537:	89 f1                	mov    %esi,%ecx
  803539:	d3 ef                	shr    %cl,%edi
  80353b:	09 c7                	or     %eax,%edi
  80353d:	89 e9                	mov    %ebp,%ecx
  80353f:	d3 e2                	shl    %cl,%edx
  803541:	89 14 24             	mov    %edx,(%esp)
  803544:	89 d8                	mov    %ebx,%eax
  803546:	d3 e0                	shl    %cl,%eax
  803548:	89 c2                	mov    %eax,%edx
  80354a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80354e:	d3 e0                	shl    %cl,%eax
  803550:	89 44 24 04          	mov    %eax,0x4(%esp)
  803554:	8b 44 24 08          	mov    0x8(%esp),%eax
  803558:	89 f1                	mov    %esi,%ecx
  80355a:	d3 e8                	shr    %cl,%eax
  80355c:	09 d0                	or     %edx,%eax
  80355e:	d3 eb                	shr    %cl,%ebx
  803560:	89 da                	mov    %ebx,%edx
  803562:	f7 f7                	div    %edi
  803564:	89 d3                	mov    %edx,%ebx
  803566:	f7 24 24             	mull   (%esp)
  803569:	89 c6                	mov    %eax,%esi
  80356b:	89 d1                	mov    %edx,%ecx
  80356d:	39 d3                	cmp    %edx,%ebx
  80356f:	0f 82 87 00 00 00    	jb     8035fc <__umoddi3+0x134>
  803575:	0f 84 91 00 00 00    	je     80360c <__umoddi3+0x144>
  80357b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80357f:	29 f2                	sub    %esi,%edx
  803581:	19 cb                	sbb    %ecx,%ebx
  803583:	89 d8                	mov    %ebx,%eax
  803585:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803589:	d3 e0                	shl    %cl,%eax
  80358b:	89 e9                	mov    %ebp,%ecx
  80358d:	d3 ea                	shr    %cl,%edx
  80358f:	09 d0                	or     %edx,%eax
  803591:	89 e9                	mov    %ebp,%ecx
  803593:	d3 eb                	shr    %cl,%ebx
  803595:	89 da                	mov    %ebx,%edx
  803597:	83 c4 1c             	add    $0x1c,%esp
  80359a:	5b                   	pop    %ebx
  80359b:	5e                   	pop    %esi
  80359c:	5f                   	pop    %edi
  80359d:	5d                   	pop    %ebp
  80359e:	c3                   	ret    
  80359f:	90                   	nop
  8035a0:	89 fd                	mov    %edi,%ebp
  8035a2:	85 ff                	test   %edi,%edi
  8035a4:	75 0b                	jne    8035b1 <__umoddi3+0xe9>
  8035a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035ab:	31 d2                	xor    %edx,%edx
  8035ad:	f7 f7                	div    %edi
  8035af:	89 c5                	mov    %eax,%ebp
  8035b1:	89 f0                	mov    %esi,%eax
  8035b3:	31 d2                	xor    %edx,%edx
  8035b5:	f7 f5                	div    %ebp
  8035b7:	89 c8                	mov    %ecx,%eax
  8035b9:	f7 f5                	div    %ebp
  8035bb:	89 d0                	mov    %edx,%eax
  8035bd:	e9 44 ff ff ff       	jmp    803506 <__umoddi3+0x3e>
  8035c2:	66 90                	xchg   %ax,%ax
  8035c4:	89 c8                	mov    %ecx,%eax
  8035c6:	89 f2                	mov    %esi,%edx
  8035c8:	83 c4 1c             	add    $0x1c,%esp
  8035cb:	5b                   	pop    %ebx
  8035cc:	5e                   	pop    %esi
  8035cd:	5f                   	pop    %edi
  8035ce:	5d                   	pop    %ebp
  8035cf:	c3                   	ret    
  8035d0:	3b 04 24             	cmp    (%esp),%eax
  8035d3:	72 06                	jb     8035db <__umoddi3+0x113>
  8035d5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8035d9:	77 0f                	ja     8035ea <__umoddi3+0x122>
  8035db:	89 f2                	mov    %esi,%edx
  8035dd:	29 f9                	sub    %edi,%ecx
  8035df:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8035e3:	89 14 24             	mov    %edx,(%esp)
  8035e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ea:	8b 44 24 04          	mov    0x4(%esp),%eax
  8035ee:	8b 14 24             	mov    (%esp),%edx
  8035f1:	83 c4 1c             	add    $0x1c,%esp
  8035f4:	5b                   	pop    %ebx
  8035f5:	5e                   	pop    %esi
  8035f6:	5f                   	pop    %edi
  8035f7:	5d                   	pop    %ebp
  8035f8:	c3                   	ret    
  8035f9:	8d 76 00             	lea    0x0(%esi),%esi
  8035fc:	2b 04 24             	sub    (%esp),%eax
  8035ff:	19 fa                	sbb    %edi,%edx
  803601:	89 d1                	mov    %edx,%ecx
  803603:	89 c6                	mov    %eax,%esi
  803605:	e9 71 ff ff ff       	jmp    80357b <__umoddi3+0xb3>
  80360a:	66 90                	xchg   %ax,%ax
  80360c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803610:	72 ea                	jb     8035fc <__umoddi3+0x134>
  803612:	89 d9                	mov    %ebx,%ecx
  803614:	e9 62 ff ff ff       	jmp    80357b <__umoddi3+0xb3>
