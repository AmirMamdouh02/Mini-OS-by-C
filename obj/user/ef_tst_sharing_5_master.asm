
obj/user/ef_tst_sharing_5_master:     file format elf32-i386


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
  800031:	e8 3d 04 00 00       	call   800473 <libmain>
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
  80008d:	68 80 36 80 00       	push   $0x803680
  800092:	6a 12                	push   $0x12
  800094:	68 9c 36 80 00       	push   $0x80369c
  800099:	e8 11 05 00 00       	call   8005af <_panic>
	}

	cprintf("************************************************\n");
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	68 bc 36 80 00       	push   $0x8036bc
  8000a6:	e8 b8 07 00 00       	call   800863 <cprintf>
  8000ab:	83 c4 10             	add    $0x10,%esp
	cprintf("MAKE SURE to have a FRESH RUN for this test\n(i.e. don't run any program/test before it)\n");
  8000ae:	83 ec 0c             	sub    $0xc,%esp
  8000b1:	68 f0 36 80 00       	push   $0x8036f0
  8000b6:	e8 a8 07 00 00       	call   800863 <cprintf>
  8000bb:	83 c4 10             	add    $0x10,%esp
	cprintf("************************************************\n\n\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 4c 37 80 00       	push   $0x80374c
  8000c6:	e8 98 07 00 00       	call   800863 <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	int envID = sys_getenvid();
  8000ce:	e8 94 1e 00 00       	call   801f67 <sys_getenvid>
  8000d3:	89 45 ec             	mov    %eax,-0x14(%ebp)

	int32 envIdSlave1, envIdSlave2, envIdSlaveB1, envIdSlaveB2;

	cprintf("STEP A: checking free of shared object using 2 environments... \n");
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 80 37 80 00       	push   $0x803780
  8000de:	e8 80 07 00 00       	call   800863 <cprintf>
  8000e3:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x;
		envIdSlave1 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8000eb:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8000f8:	8b 40 74             	mov    0x74(%eax),%eax
  8000fb:	6a 32                	push   $0x32
  8000fd:	52                   	push   %edx
  8000fe:	50                   	push   %eax
  8000ff:	68 c1 37 80 00       	push   $0x8037c1
  800104:	e8 09 1e 00 00       	call   801f12 <sys_create_env>
  800109:	83 c4 10             	add    $0x10,%esp
  80010c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		envIdSlave2 = sys_create_env("ef_tshr5slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80010f:	a1 20 50 80 00       	mov    0x805020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c2                	mov    %eax,%edx
  80011c:	a1 20 50 80 00       	mov    0x805020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	6a 32                	push   $0x32
  800126:	52                   	push   %edx
  800127:	50                   	push   %eax
  800128:	68 c1 37 80 00       	push   $0x8037c1
  80012d:	e8 e0 1d 00 00       	call   801f12 <sys_create_env>
  800132:	83 c4 10             	add    $0x10,%esp
  800135:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int freeFrames = sys_calculate_free_frames() ;
  800138:	e8 63 1b 00 00       	call   801ca0 <sys_calculate_free_frames>
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		x = smalloc("x", PAGE_SIZE, 1);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 01                	push   $0x1
  800145:	68 00 10 00 00       	push   $0x1000
  80014a:	68 cf 37 80 00       	push   $0x8037cf
  80014f:	e8 29 18 00 00       	call   80197d <smalloc>
  800154:	83 c4 10             	add    $0x10,%esp
  800157:	89 45 dc             	mov    %eax,-0x24(%ebp)
		cprintf("Master env created x (1 page) \n");
  80015a:	83 ec 0c             	sub    $0xc,%esp
  80015d:	68 d4 37 80 00       	push   $0x8037d4
  800162:	e8 fc 06 00 00       	call   800863 <cprintf>
  800167:	83 c4 10             	add    $0x10,%esp
		if (x != (uint32*)USER_HEAP_START) panic("Returned address is not correct. check the setting of it and/or the updating of the shared_mem_free_address");
  80016a:	81 7d dc 00 00 00 80 	cmpl   $0x80000000,-0x24(%ebp)
  800171:	74 14                	je     800187 <_main+0x14f>
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 f4 37 80 00       	push   $0x8037f4
  80017b:	6a 26                	push   $0x26
  80017d:	68 9c 36 80 00       	push   $0x80369c
  800182:	e8 28 04 00 00       	call   8005af <_panic>
		if ((freeFrames - sys_calculate_free_frames()) !=  1+1+2) panic("Wrong allocation: make sure that you allocate the required space in the user environment and add its frames to frames_storage");
  800187:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80018a:	e8 11 1b 00 00       	call   801ca0 <sys_calculate_free_frames>
  80018f:	29 c3                	sub    %eax,%ebx
  800191:	89 d8                	mov    %ebx,%eax
  800193:	83 f8 04             	cmp    $0x4,%eax
  800196:	74 14                	je     8001ac <_main+0x174>
  800198:	83 ec 04             	sub    $0x4,%esp
  80019b:	68 60 38 80 00       	push   $0x803860
  8001a0:	6a 27                	push   $0x27
  8001a2:	68 9c 36 80 00       	push   $0x80369c
  8001a7:	e8 03 04 00 00       	call   8005af <_panic>

		//to check that the slave environments completed successfully
		rsttst();
  8001ac:	e8 ad 1e 00 00       	call   80205e <rsttst>

		sys_run_env(envIdSlave1);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8001b7:	e8 74 1d 00 00       	call   801f30 <sys_run_env>
  8001bc:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlave2);
  8001bf:	83 ec 0c             	sub    $0xc,%esp
  8001c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c5:	e8 66 1d 00 00       	call   801f30 <sys_run_env>
  8001ca:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001cd:	83 ec 0c             	sub    $0xc,%esp
  8001d0:	68 de 38 80 00       	push   $0x8038de
  8001d5:	e8 89 06 00 00       	call   800863 <cprintf>
  8001da:	83 c4 10             	add    $0x10,%esp
		env_sleep(3000);
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	68 b8 0b 00 00       	push   $0xbb8
  8001e5:	e8 7d 31 00 00       	call   803367 <env_sleep>
  8001ea:	83 c4 10             	add    $0x10,%esp

		//to ensure that the slave environments completed successfully
		if (gettst()!=2) panic("test failed");
  8001ed:	e8 e6 1e 00 00       	call   8020d8 <gettst>
  8001f2:	83 f8 02             	cmp    $0x2,%eax
  8001f5:	74 14                	je     80020b <_main+0x1d3>
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	68 f5 38 80 00       	push   $0x8038f5
  8001ff:	6a 33                	push   $0x33
  800201:	68 9c 36 80 00       	push   $0x80369c
  800206:	e8 a4 03 00 00       	call   8005af <_panic>

		sfree(x);
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	ff 75 dc             	pushl  -0x24(%ebp)
  800211:	e8 2a 19 00 00       	call   801b40 <sfree>
  800216:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x (1 page) \n");
  800219:	83 ec 0c             	sub    $0xc,%esp
  80021c:	68 04 39 80 00       	push   $0x803904
  800221:	e8 3d 06 00 00       	call   800863 <cprintf>
  800226:	83 c4 10             	add    $0x10,%esp
		int diff = (sys_calculate_free_frames() - freeFrames);
  800229:	e8 72 1a 00 00       	call   801ca0 <sys_calculate_free_frames>
  80022e:	89 c2                	mov    %eax,%edx
  800230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800233:	29 c2                	sub    %eax,%edx
  800235:	89 d0                	mov    %edx,%eax
  800237:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if ( diff !=  0) panic("Wrong free: revise your freeSharedObject logic\n");
  80023a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80023e:	74 14                	je     800254 <_main+0x21c>
  800240:	83 ec 04             	sub    $0x4,%esp
  800243:	68 24 39 80 00       	push   $0x803924
  800248:	6a 38                	push   $0x38
  80024a:	68 9c 36 80 00       	push   $0x80369c
  80024f:	e8 5b 03 00 00       	call   8005af <_panic>
	}
	cprintf("Step A completed successfully!!\n\n\n");
  800254:	83 ec 0c             	sub    $0xc,%esp
  800257:	68 54 39 80 00       	push   $0x803954
  80025c:	e8 02 06 00 00       	call   800863 <cprintf>
  800261:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking free of 2 shared objects ... \n");
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	68 78 39 80 00       	push   $0x803978
  80026c:	e8 f2 05 00 00       	call   800863 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	{
		uint32 *x, *z ;
		envIdSlaveB1 = sys_create_env("ef_tshr5slaveB1", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800274:	a1 20 50 80 00       	mov    0x805020,%eax
  800279:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80027f:	89 c2                	mov    %eax,%edx
  800281:	a1 20 50 80 00       	mov    0x805020,%eax
  800286:	8b 40 74             	mov    0x74(%eax),%eax
  800289:	6a 32                	push   $0x32
  80028b:	52                   	push   %edx
  80028c:	50                   	push   %eax
  80028d:	68 a8 39 80 00       	push   $0x8039a8
  800292:	e8 7b 1c 00 00       	call   801f12 <sys_create_env>
  800297:	83 c4 10             	add    $0x10,%esp
  80029a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		envIdSlaveB2 = sys_create_env("ef_tshr5slaveB2", (myEnv->page_WS_max_size), (myEnv->SecondListSize),50);
  80029d:	a1 20 50 80 00       	mov    0x805020,%eax
  8002a2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002a8:	89 c2                	mov    %eax,%edx
  8002aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8002af:	8b 40 74             	mov    0x74(%eax),%eax
  8002b2:	6a 32                	push   $0x32
  8002b4:	52                   	push   %edx
  8002b5:	50                   	push   %eax
  8002b6:	68 b8 39 80 00       	push   $0x8039b8
  8002bb:	e8 52 1c 00 00       	call   801f12 <sys_create_env>
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	89 45 d0             	mov    %eax,-0x30(%ebp)

		z = smalloc("z", PAGE_SIZE, 1);
  8002c6:	83 ec 04             	sub    $0x4,%esp
  8002c9:	6a 01                	push   $0x1
  8002cb:	68 00 10 00 00       	push   $0x1000
  8002d0:	68 c8 39 80 00       	push   $0x8039c8
  8002d5:	e8 a3 16 00 00       	call   80197d <smalloc>
  8002da:	83 c4 10             	add    $0x10,%esp
  8002dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
		cprintf("Master env created z (1 page) \n");
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	68 cc 39 80 00       	push   $0x8039cc
  8002e8:	e8 76 05 00 00       	call   800863 <cprintf>
  8002ed:	83 c4 10             	add    $0x10,%esp

		x = smalloc("x", PAGE_SIZE, 1);
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	6a 01                	push   $0x1
  8002f5:	68 00 10 00 00       	push   $0x1000
  8002fa:	68 cf 37 80 00       	push   $0x8037cf
  8002ff:	e8 79 16 00 00       	call   80197d <smalloc>
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	89 45 c8             	mov    %eax,-0x38(%ebp)
		cprintf("Master env created x (1 page) \n");
  80030a:	83 ec 0c             	sub    $0xc,%esp
  80030d:	68 d4 37 80 00       	push   $0x8037d4
  800312:	e8 4c 05 00 00       	call   800863 <cprintf>
  800317:	83 c4 10             	add    $0x10,%esp

		rsttst();
  80031a:	e8 3f 1d 00 00       	call   80205e <rsttst>

		sys_run_env(envIdSlaveB1);
  80031f:	83 ec 0c             	sub    $0xc,%esp
  800322:	ff 75 d4             	pushl  -0x2c(%ebp)
  800325:	e8 06 1c 00 00       	call   801f30 <sys_run_env>
  80032a:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdSlaveB2);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	ff 75 d0             	pushl  -0x30(%ebp)
  800333:	e8 f8 1b 00 00       	call   801f30 <sys_run_env>
  800338:	83 c4 10             	add    $0x10,%esp

		env_sleep(4000); //give slaves time to catch the shared object before removal
  80033b:	83 ec 0c             	sub    $0xc,%esp
  80033e:	68 a0 0f 00 00       	push   $0xfa0
  800343:	e8 1f 30 00 00       	call   803367 <env_sleep>
  800348:	83 c4 10             	add    $0x10,%esp

		int freeFrames = sys_calculate_free_frames() ;
  80034b:	e8 50 19 00 00       	call   801ca0 <sys_calculate_free_frames>
  800350:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		sfree(z);
  800353:	83 ec 0c             	sub    $0xc,%esp
  800356:	ff 75 cc             	pushl  -0x34(%ebp)
  800359:	e8 e2 17 00 00       	call   801b40 <sfree>
  80035e:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed z\n");
  800361:	83 ec 0c             	sub    $0xc,%esp
  800364:	68 ec 39 80 00       	push   $0x8039ec
  800369:	e8 f5 04 00 00       	call   800863 <cprintf>
  80036e:	83 c4 10             	add    $0x10,%esp

		sfree(x);
  800371:	83 ec 0c             	sub    $0xc,%esp
  800374:	ff 75 c8             	pushl  -0x38(%ebp)
  800377:	e8 c4 17 00 00       	call   801b40 <sfree>
  80037c:	83 c4 10             	add    $0x10,%esp
		cprintf("Master env removed x\n");
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	68 02 3a 80 00       	push   $0x803a02
  800387:	e8 d7 04 00 00       	call   800863 <cprintf>
  80038c:	83 c4 10             	add    $0x10,%esp

		int diff = (sys_calculate_free_frames() - freeFrames);
  80038f:	e8 0c 19 00 00       	call   801ca0 <sys_calculate_free_frames>
  800394:	89 c2                	mov    %eax,%edx
  800396:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800399:	29 c2                	sub    %eax,%edx
  80039b:	89 d0                	mov    %edx,%eax
  80039d:	89 45 c0             	mov    %eax,-0x40(%ebp)

		if (diff !=  1) panic("Wrong free: frames removed not equal 1 !, correct frames to be removed are 1:\nfrom the env: 1 table\nframes_storage of z & x: should NOT cleared yet (still in use!)\n");
  8003a0:	83 7d c0 01          	cmpl   $0x1,-0x40(%ebp)
  8003a4:	74 14                	je     8003ba <_main+0x382>
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 18 3a 80 00       	push   $0x803a18
  8003ae:	6a 59                	push   $0x59
  8003b0:	68 9c 36 80 00       	push   $0x80369c
  8003b5:	e8 f5 01 00 00       	call   8005af <_panic>

		//To indicate that it's completed successfully
		inctst();
  8003ba:	e8 ff 1c 00 00       	call   8020be <inctst>

		int* finish_children = smalloc("finish_children", sizeof(int), 1);
  8003bf:	83 ec 04             	sub    $0x4,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	6a 04                	push   $0x4
  8003c6:	68 bd 3a 80 00       	push   $0x803abd
  8003cb:	e8 ad 15 00 00       	call   80197d <smalloc>
  8003d0:	83 c4 10             	add    $0x10,%esp
  8003d3:	89 45 bc             	mov    %eax,-0x44(%ebp)
		*finish_children = 0;
  8003d6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

		if (sys_getparentenvid() > 0) {
  8003df:	e8 b5 1b 00 00       	call   801f99 <sys_getparentenvid>
  8003e4:	85 c0                	test   %eax,%eax
  8003e6:	0f 8e 81 00 00 00    	jle    80046d <_main+0x435>
			while(*finish_children != 1);
  8003ec:	90                   	nop
  8003ed:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8003f0:	8b 00                	mov    (%eax),%eax
  8003f2:	83 f8 01             	cmp    $0x1,%eax
  8003f5:	75 f6                	jne    8003ed <_main+0x3b5>
			cprintf("done\n");
  8003f7:	83 ec 0c             	sub    $0xc,%esp
  8003fa:	68 cd 3a 80 00       	push   $0x803acd
  8003ff:	e8 5f 04 00 00       	call   800863 <cprintf>
  800404:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave1);
  800407:	83 ec 0c             	sub    $0xc,%esp
  80040a:	ff 75 e8             	pushl  -0x18(%ebp)
  80040d:	e8 3a 1b 00 00       	call   801f4c <sys_destroy_env>
  800412:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlave2);
  800415:	83 ec 0c             	sub    $0xc,%esp
  800418:	ff 75 e4             	pushl  -0x1c(%ebp)
  80041b:	e8 2c 1b 00 00       	call   801f4c <sys_destroy_env>
  800420:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB1);
  800423:	83 ec 0c             	sub    $0xc,%esp
  800426:	ff 75 d4             	pushl  -0x2c(%ebp)
  800429:	e8 1e 1b 00 00       	call   801f4c <sys_destroy_env>
  80042e:	83 c4 10             	add    $0x10,%esp
			sys_destroy_env(envIdSlaveB2);
  800431:	83 ec 0c             	sub    $0xc,%esp
  800434:	ff 75 d0             	pushl  -0x30(%ebp)
  800437:	e8 10 1b 00 00       	call   801f4c <sys_destroy_env>
  80043c:	83 c4 10             	add    $0x10,%esp

			int *finishedCount = NULL;
  80043f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
			finishedCount = sget(sys_getparentenvid(), "finishedCount") ;
  800446:	e8 4e 1b 00 00       	call   801f99 <sys_getparentenvid>
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	68 d3 3a 80 00       	push   $0x803ad3
  800453:	50                   	push   %eax
  800454:	e8 f9 15 00 00       	call   801a52 <sget>
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	89 45 b8             	mov    %eax,-0x48(%ebp)
			(*finishedCount)++ ;
  80045f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800462:	8b 00                	mov    (%eax),%eax
  800464:	8d 50 01             	lea    0x1(%eax),%edx
  800467:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80046a:	89 10                	mov    %edx,(%eax)
		}
	}


	return;
  80046c:	90                   	nop
  80046d:	90                   	nop
}
  80046e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800471:	c9                   	leave  
  800472:	c3                   	ret    

00800473 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800473:	55                   	push   %ebp
  800474:	89 e5                	mov    %esp,%ebp
  800476:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800479:	e8 02 1b 00 00       	call   801f80 <sys_getenvindex>
  80047e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800481:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	c1 e0 03             	shl    $0x3,%eax
  800489:	01 d0                	add    %edx,%eax
  80048b:	01 c0                	add    %eax,%eax
  80048d:	01 d0                	add    %edx,%eax
  80048f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800496:	01 d0                	add    %edx,%eax
  800498:	c1 e0 04             	shl    $0x4,%eax
  80049b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8004a0:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8004a5:	a1 20 50 80 00       	mov    0x805020,%eax
  8004aa:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8004b0:	84 c0                	test   %al,%al
  8004b2:	74 0f                	je     8004c3 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8004b4:	a1 20 50 80 00       	mov    0x805020,%eax
  8004b9:	05 5c 05 00 00       	add    $0x55c,%eax
  8004be:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8004c7:	7e 0a                	jle    8004d3 <libmain+0x60>
		binaryname = argv[0];
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	ff 75 0c             	pushl  0xc(%ebp)
  8004d9:	ff 75 08             	pushl  0x8(%ebp)
  8004dc:	e8 57 fb ff ff       	call   800038 <_main>
  8004e1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8004e4:	e8 a4 18 00 00       	call   801d8d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8004e9:	83 ec 0c             	sub    $0xc,%esp
  8004ec:	68 fc 3a 80 00       	push   $0x803afc
  8004f1:	e8 6d 03 00 00       	call   800863 <cprintf>
  8004f6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8004f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8004fe:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800504:	a1 20 50 80 00       	mov    0x805020,%eax
  800509:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80050f:	83 ec 04             	sub    $0x4,%esp
  800512:	52                   	push   %edx
  800513:	50                   	push   %eax
  800514:	68 24 3b 80 00       	push   $0x803b24
  800519:	e8 45 03 00 00       	call   800863 <cprintf>
  80051e:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800521:	a1 20 50 80 00       	mov    0x805020,%eax
  800526:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80052c:	a1 20 50 80 00       	mov    0x805020,%eax
  800531:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800537:	a1 20 50 80 00       	mov    0x805020,%eax
  80053c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800542:	51                   	push   %ecx
  800543:	52                   	push   %edx
  800544:	50                   	push   %eax
  800545:	68 4c 3b 80 00       	push   $0x803b4c
  80054a:	e8 14 03 00 00       	call   800863 <cprintf>
  80054f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800552:	a1 20 50 80 00       	mov    0x805020,%eax
  800557:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80055d:	83 ec 08             	sub    $0x8,%esp
  800560:	50                   	push   %eax
  800561:	68 a4 3b 80 00       	push   $0x803ba4
  800566:	e8 f8 02 00 00       	call   800863 <cprintf>
  80056b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80056e:	83 ec 0c             	sub    $0xc,%esp
  800571:	68 fc 3a 80 00       	push   $0x803afc
  800576:	e8 e8 02 00 00       	call   800863 <cprintf>
  80057b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80057e:	e8 24 18 00 00       	call   801da7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800583:	e8 19 00 00 00       	call   8005a1 <exit>
}
  800588:	90                   	nop
  800589:	c9                   	leave  
  80058a:	c3                   	ret    

0080058b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800591:	83 ec 0c             	sub    $0xc,%esp
  800594:	6a 00                	push   $0x0
  800596:	e8 b1 19 00 00       	call   801f4c <sys_destroy_env>
  80059b:	83 c4 10             	add    $0x10,%esp
}
  80059e:	90                   	nop
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <exit>:

void
exit(void)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8005a7:	e8 06 1a 00 00       	call   801fb2 <sys_exit_env>
}
  8005ac:	90                   	nop
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8005b5:	8d 45 10             	lea    0x10(%ebp),%eax
  8005b8:	83 c0 04             	add    $0x4,%eax
  8005bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8005be:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005c3:	85 c0                	test   %eax,%eax
  8005c5:	74 16                	je     8005dd <_panic+0x2e>
		cprintf("%s: ", argv0);
  8005c7:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	50                   	push   %eax
  8005d0:	68 b8 3b 80 00       	push   $0x803bb8
  8005d5:	e8 89 02 00 00       	call   800863 <cprintf>
  8005da:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8005dd:	a1 00 50 80 00       	mov    0x805000,%eax
  8005e2:	ff 75 0c             	pushl  0xc(%ebp)
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	50                   	push   %eax
  8005e9:	68 bd 3b 80 00       	push   $0x803bbd
  8005ee:	e8 70 02 00 00       	call   800863 <cprintf>
  8005f3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8005f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f9:	83 ec 08             	sub    $0x8,%esp
  8005fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005ff:	50                   	push   %eax
  800600:	e8 f3 01 00 00       	call   8007f8 <vcprintf>
  800605:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800608:	83 ec 08             	sub    $0x8,%esp
  80060b:	6a 00                	push   $0x0
  80060d:	68 d9 3b 80 00       	push   $0x803bd9
  800612:	e8 e1 01 00 00       	call   8007f8 <vcprintf>
  800617:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80061a:	e8 82 ff ff ff       	call   8005a1 <exit>

	// should not return here
	while (1) ;
  80061f:	eb fe                	jmp    80061f <_panic+0x70>

00800621 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800621:	55                   	push   %ebp
  800622:	89 e5                	mov    %esp,%ebp
  800624:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800627:	a1 20 50 80 00       	mov    0x805020,%eax
  80062c:	8b 50 74             	mov    0x74(%eax),%edx
  80062f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800632:	39 c2                	cmp    %eax,%edx
  800634:	74 14                	je     80064a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800636:	83 ec 04             	sub    $0x4,%esp
  800639:	68 dc 3b 80 00       	push   $0x803bdc
  80063e:	6a 26                	push   $0x26
  800640:	68 28 3c 80 00       	push   $0x803c28
  800645:	e8 65 ff ff ff       	call   8005af <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80064a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800658:	e9 c2 00 00 00       	jmp    80071f <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80065d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800660:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	01 d0                	add    %edx,%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	85 c0                	test   %eax,%eax
  800670:	75 08                	jne    80067a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800672:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800675:	e9 a2 00 00 00       	jmp    80071c <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80067a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800681:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800688:	eb 69                	jmp    8006f3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80068a:	a1 20 50 80 00       	mov    0x805020,%eax
  80068f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800695:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800698:	89 d0                	mov    %edx,%eax
  80069a:	01 c0                	add    %eax,%eax
  80069c:	01 d0                	add    %edx,%eax
  80069e:	c1 e0 03             	shl    $0x3,%eax
  8006a1:	01 c8                	add    %ecx,%eax
  8006a3:	8a 40 04             	mov    0x4(%eax),%al
  8006a6:	84 c0                	test   %al,%al
  8006a8:	75 46                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8006af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006b5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006b8:	89 d0                	mov    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d0                	add    %edx,%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8006d0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8006d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006d5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	01 c8                	add    %ecx,%eax
  8006e1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8006e3:	39 c2                	cmp    %eax,%edx
  8006e5:	75 09                	jne    8006f0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8006e7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8006ee:	eb 12                	jmp    800702 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006f0:	ff 45 e8             	incl   -0x18(%ebp)
  8006f3:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f8:	8b 50 74             	mov    0x74(%eax),%edx
  8006fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006fe:	39 c2                	cmp    %eax,%edx
  800700:	77 88                	ja     80068a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800702:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800706:	75 14                	jne    80071c <CheckWSWithoutLastIndex+0xfb>
			panic(
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	68 34 3c 80 00       	push   $0x803c34
  800710:	6a 3a                	push   $0x3a
  800712:	68 28 3c 80 00       	push   $0x803c28
  800717:	e8 93 fe ff ff       	call   8005af <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80071c:	ff 45 f0             	incl   -0x10(%ebp)
  80071f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800722:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800725:	0f 8c 32 ff ff ff    	jl     80065d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80072b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800732:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800739:	eb 26                	jmp    800761 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80073b:	a1 20 50 80 00       	mov    0x805020,%eax
  800740:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800746:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800749:	89 d0                	mov    %edx,%eax
  80074b:	01 c0                	add    %eax,%eax
  80074d:	01 d0                	add    %edx,%eax
  80074f:	c1 e0 03             	shl    $0x3,%eax
  800752:	01 c8                	add    %ecx,%eax
  800754:	8a 40 04             	mov    0x4(%eax),%al
  800757:	3c 01                	cmp    $0x1,%al
  800759:	75 03                	jne    80075e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80075b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80075e:	ff 45 e0             	incl   -0x20(%ebp)
  800761:	a1 20 50 80 00       	mov    0x805020,%eax
  800766:	8b 50 74             	mov    0x74(%eax),%edx
  800769:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80076c:	39 c2                	cmp    %eax,%edx
  80076e:	77 cb                	ja     80073b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800773:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800776:	74 14                	je     80078c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800778:	83 ec 04             	sub    $0x4,%esp
  80077b:	68 88 3c 80 00       	push   $0x803c88
  800780:	6a 44                	push   $0x44
  800782:	68 28 3c 80 00       	push   $0x803c28
  800787:	e8 23 fe ff ff       	call   8005af <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80078c:	90                   	nop
  80078d:	c9                   	leave  
  80078e:	c3                   	ret    

0080078f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80078f:	55                   	push   %ebp
  800790:	89 e5                	mov    %esp,%ebp
  800792:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800795:	8b 45 0c             	mov    0xc(%ebp),%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	8d 48 01             	lea    0x1(%eax),%ecx
  80079d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007a0:	89 0a                	mov    %ecx,(%edx)
  8007a2:	8b 55 08             	mov    0x8(%ebp),%edx
  8007a5:	88 d1                	mov    %dl,%cl
  8007a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007aa:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8007ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007b8:	75 2c                	jne    8007e6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8007ba:	a0 24 50 80 00       	mov    0x805024,%al
  8007bf:	0f b6 c0             	movzbl %al,%eax
  8007c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c5:	8b 12                	mov    (%edx),%edx
  8007c7:	89 d1                	mov    %edx,%ecx
  8007c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007cc:	83 c2 08             	add    $0x8,%edx
  8007cf:	83 ec 04             	sub    $0x4,%esp
  8007d2:	50                   	push   %eax
  8007d3:	51                   	push   %ecx
  8007d4:	52                   	push   %edx
  8007d5:	e8 05 14 00 00       	call   801bdf <sys_cputs>
  8007da:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8007dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e9:	8b 40 04             	mov    0x4(%eax),%eax
  8007ec:	8d 50 01             	lea    0x1(%eax),%edx
  8007ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007f2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8007f5:	90                   	nop
  8007f6:	c9                   	leave  
  8007f7:	c3                   	ret    

008007f8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800801:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800808:	00 00 00 
	b.cnt = 0;
  80080b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800812:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800815:	ff 75 0c             	pushl  0xc(%ebp)
  800818:	ff 75 08             	pushl  0x8(%ebp)
  80081b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800821:	50                   	push   %eax
  800822:	68 8f 07 80 00       	push   $0x80078f
  800827:	e8 11 02 00 00       	call   800a3d <vprintfmt>
  80082c:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80082f:	a0 24 50 80 00       	mov    0x805024,%al
  800834:	0f b6 c0             	movzbl %al,%eax
  800837:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80083d:	83 ec 04             	sub    $0x4,%esp
  800840:	50                   	push   %eax
  800841:	52                   	push   %edx
  800842:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800848:	83 c0 08             	add    $0x8,%eax
  80084b:	50                   	push   %eax
  80084c:	e8 8e 13 00 00       	call   801bdf <sys_cputs>
  800851:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800854:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80085b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800861:	c9                   	leave  
  800862:	c3                   	ret    

00800863 <cprintf>:

int cprintf(const char *fmt, ...) {
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800869:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800870:	8d 45 0c             	lea    0xc(%ebp),%eax
  800873:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	ff 75 f4             	pushl  -0xc(%ebp)
  80087f:	50                   	push   %eax
  800880:	e8 73 ff ff ff       	call   8007f8 <vcprintf>
  800885:	83 c4 10             	add    $0x10,%esp
  800888:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80088b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80088e:	c9                   	leave  
  80088f:	c3                   	ret    

00800890 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800896:	e8 f2 14 00 00       	call   801d8d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80089b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80089e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008aa:	50                   	push   %eax
  8008ab:	e8 48 ff ff ff       	call   8007f8 <vcprintf>
  8008b0:	83 c4 10             	add    $0x10,%esp
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8008b6:	e8 ec 14 00 00       	call   801da7 <sys_enable_interrupt>
	return cnt;
  8008bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8008be:	c9                   	leave  
  8008bf:	c3                   	ret    

008008c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8008c0:	55                   	push   %ebp
  8008c1:	89 e5                	mov    %esp,%ebp
  8008c3:	53                   	push   %ebx
  8008c4:	83 ec 14             	sub    $0x14,%esp
  8008c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008d3:	8b 45 18             	mov    0x18(%ebp),%eax
  8008d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8008db:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008de:	77 55                	ja     800935 <printnum+0x75>
  8008e0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8008e3:	72 05                	jb     8008ea <printnum+0x2a>
  8008e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8008e8:	77 4b                	ja     800935 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008ea:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8008ed:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008f0:	8b 45 18             	mov    0x18(%ebp),%eax
  8008f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f8:	52                   	push   %edx
  8008f9:	50                   	push   %eax
  8008fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8008fd:	ff 75 f0             	pushl  -0x10(%ebp)
  800900:	e8 17 2b 00 00       	call   80341c <__udivdi3>
  800905:	83 c4 10             	add    $0x10,%esp
  800908:	83 ec 04             	sub    $0x4,%esp
  80090b:	ff 75 20             	pushl  0x20(%ebp)
  80090e:	53                   	push   %ebx
  80090f:	ff 75 18             	pushl  0x18(%ebp)
  800912:	52                   	push   %edx
  800913:	50                   	push   %eax
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 a1 ff ff ff       	call   8008c0 <printnum>
  80091f:	83 c4 20             	add    $0x20,%esp
  800922:	eb 1a                	jmp    80093e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800924:	83 ec 08             	sub    $0x8,%esp
  800927:	ff 75 0c             	pushl  0xc(%ebp)
  80092a:	ff 75 20             	pushl  0x20(%ebp)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	ff d0                	call   *%eax
  800932:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800935:	ff 4d 1c             	decl   0x1c(%ebp)
  800938:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80093c:	7f e6                	jg     800924 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80093e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800941:	bb 00 00 00 00       	mov    $0x0,%ebx
  800946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800949:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80094c:	53                   	push   %ebx
  80094d:	51                   	push   %ecx
  80094e:	52                   	push   %edx
  80094f:	50                   	push   %eax
  800950:	e8 d7 2b 00 00       	call   80352c <__umoddi3>
  800955:	83 c4 10             	add    $0x10,%esp
  800958:	05 f4 3e 80 00       	add    $0x803ef4,%eax
  80095d:	8a 00                	mov    (%eax),%al
  80095f:	0f be c0             	movsbl %al,%eax
  800962:	83 ec 08             	sub    $0x8,%esp
  800965:	ff 75 0c             	pushl  0xc(%ebp)
  800968:	50                   	push   %eax
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
}
  800971:	90                   	nop
  800972:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800975:	c9                   	leave  
  800976:	c3                   	ret    

00800977 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80097a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80097e:	7e 1c                	jle    80099c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	8b 00                	mov    (%eax),%eax
  800985:	8d 50 08             	lea    0x8(%eax),%edx
  800988:	8b 45 08             	mov    0x8(%ebp),%eax
  80098b:	89 10                	mov    %edx,(%eax)
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	8b 00                	mov    (%eax),%eax
  800992:	83 e8 08             	sub    $0x8,%eax
  800995:	8b 50 04             	mov    0x4(%eax),%edx
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	eb 40                	jmp    8009dc <getuint+0x65>
	else if (lflag)
  80099c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a0:	74 1e                	je     8009c0 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8009a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a5:	8b 00                	mov    (%eax),%eax
  8009a7:	8d 50 04             	lea    0x4(%eax),%edx
  8009aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ad:	89 10                	mov    %edx,(%eax)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 00                	mov    (%eax),%eax
  8009b4:	83 e8 04             	sub    $0x4,%eax
  8009b7:	8b 00                	mov    (%eax),%eax
  8009b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8009be:	eb 1c                	jmp    8009dc <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8d 50 04             	lea    0x4(%eax),%edx
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 10                	mov    %edx,(%eax)
  8009cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	83 e8 04             	sub    $0x4,%eax
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8009e1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8009e5:	7e 1c                	jle    800a03 <getint+0x25>
		return va_arg(*ap, long long);
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 00                	mov    (%eax),%eax
  8009ec:	8d 50 08             	lea    0x8(%eax),%edx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	89 10                	mov    %edx,(%eax)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	8b 00                	mov    (%eax),%eax
  8009f9:	83 e8 08             	sub    $0x8,%eax
  8009fc:	8b 50 04             	mov    0x4(%eax),%edx
  8009ff:	8b 00                	mov    (%eax),%eax
  800a01:	eb 38                	jmp    800a3b <getint+0x5d>
	else if (lflag)
  800a03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a07:	74 1a                	je     800a23 <getint+0x45>
		return va_arg(*ap, long);
  800a09:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0c:	8b 00                	mov    (%eax),%eax
  800a0e:	8d 50 04             	lea    0x4(%eax),%edx
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	89 10                	mov    %edx,(%eax)
  800a16:	8b 45 08             	mov    0x8(%ebp),%eax
  800a19:	8b 00                	mov    (%eax),%eax
  800a1b:	83 e8 04             	sub    $0x4,%eax
  800a1e:	8b 00                	mov    (%eax),%eax
  800a20:	99                   	cltd   
  800a21:	eb 18                	jmp    800a3b <getint+0x5d>
	else
		return va_arg(*ap, int);
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	8b 00                	mov    (%eax),%eax
  800a28:	8d 50 04             	lea    0x4(%eax),%edx
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	89 10                	mov    %edx,(%eax)
  800a30:	8b 45 08             	mov    0x8(%ebp),%eax
  800a33:	8b 00                	mov    (%eax),%eax
  800a35:	83 e8 04             	sub    $0x4,%eax
  800a38:	8b 00                	mov    (%eax),%eax
  800a3a:	99                   	cltd   
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	56                   	push   %esi
  800a41:	53                   	push   %ebx
  800a42:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a45:	eb 17                	jmp    800a5e <vprintfmt+0x21>
			if (ch == '\0')
  800a47:	85 db                	test   %ebx,%ebx
  800a49:	0f 84 af 03 00 00    	je     800dfe <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800a4f:	83 ec 08             	sub    $0x8,%esp
  800a52:	ff 75 0c             	pushl  0xc(%ebp)
  800a55:	53                   	push   %ebx
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	ff d0                	call   *%eax
  800a5b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800a5e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a61:	8d 50 01             	lea    0x1(%eax),%edx
  800a64:	89 55 10             	mov    %edx,0x10(%ebp)
  800a67:	8a 00                	mov    (%eax),%al
  800a69:	0f b6 d8             	movzbl %al,%ebx
  800a6c:	83 fb 25             	cmp    $0x25,%ebx
  800a6f:	75 d6                	jne    800a47 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800a71:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800a75:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800a7c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800a83:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800a8a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a91:	8b 45 10             	mov    0x10(%ebp),%eax
  800a94:	8d 50 01             	lea    0x1(%eax),%edx
  800a97:	89 55 10             	mov    %edx,0x10(%ebp)
  800a9a:	8a 00                	mov    (%eax),%al
  800a9c:	0f b6 d8             	movzbl %al,%ebx
  800a9f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800aa2:	83 f8 55             	cmp    $0x55,%eax
  800aa5:	0f 87 2b 03 00 00    	ja     800dd6 <vprintfmt+0x399>
  800aab:	8b 04 85 18 3f 80 00 	mov    0x803f18(,%eax,4),%eax
  800ab2:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ab4:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ab8:	eb d7                	jmp    800a91 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800aba:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800abe:	eb d1                	jmp    800a91 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ac0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800ac7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800aca:	89 d0                	mov    %edx,%eax
  800acc:	c1 e0 02             	shl    $0x2,%eax
  800acf:	01 d0                	add    %edx,%eax
  800ad1:	01 c0                	add    %eax,%eax
  800ad3:	01 d8                	add    %ebx,%eax
  800ad5:	83 e8 30             	sub    $0x30,%eax
  800ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800adb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ade:	8a 00                	mov    (%eax),%al
  800ae0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ae3:	83 fb 2f             	cmp    $0x2f,%ebx
  800ae6:	7e 3e                	jle    800b26 <vprintfmt+0xe9>
  800ae8:	83 fb 39             	cmp    $0x39,%ebx
  800aeb:	7f 39                	jg     800b26 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800aed:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800af0:	eb d5                	jmp    800ac7 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800af2:	8b 45 14             	mov    0x14(%ebp),%eax
  800af5:	83 c0 04             	add    $0x4,%eax
  800af8:	89 45 14             	mov    %eax,0x14(%ebp)
  800afb:	8b 45 14             	mov    0x14(%ebp),%eax
  800afe:	83 e8 04             	sub    $0x4,%eax
  800b01:	8b 00                	mov    (%eax),%eax
  800b03:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800b06:	eb 1f                	jmp    800b27 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800b08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b0c:	79 83                	jns    800a91 <vprintfmt+0x54>
				width = 0;
  800b0e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800b15:	e9 77 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800b1a:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800b21:	e9 6b ff ff ff       	jmp    800a91 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800b26:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800b27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b2b:	0f 89 60 ff ff ff    	jns    800a91 <vprintfmt+0x54>
				width = precision, precision = -1;
  800b31:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b37:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800b3e:	e9 4e ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800b43:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800b46:	e9 46 ff ff ff       	jmp    800a91 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	50                   	push   %eax
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	ff d0                	call   *%eax
  800b68:	83 c4 10             	add    $0x10,%esp
			break;
  800b6b:	e9 89 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800b70:	8b 45 14             	mov    0x14(%ebp),%eax
  800b73:	83 c0 04             	add    $0x4,%eax
  800b76:	89 45 14             	mov    %eax,0x14(%ebp)
  800b79:	8b 45 14             	mov    0x14(%ebp),%eax
  800b7c:	83 e8 04             	sub    $0x4,%eax
  800b7f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800b81:	85 db                	test   %ebx,%ebx
  800b83:	79 02                	jns    800b87 <vprintfmt+0x14a>
				err = -err;
  800b85:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800b87:	83 fb 64             	cmp    $0x64,%ebx
  800b8a:	7f 0b                	jg     800b97 <vprintfmt+0x15a>
  800b8c:	8b 34 9d 60 3d 80 00 	mov    0x803d60(,%ebx,4),%esi
  800b93:	85 f6                	test   %esi,%esi
  800b95:	75 19                	jne    800bb0 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b97:	53                   	push   %ebx
  800b98:	68 05 3f 80 00       	push   $0x803f05
  800b9d:	ff 75 0c             	pushl  0xc(%ebp)
  800ba0:	ff 75 08             	pushl  0x8(%ebp)
  800ba3:	e8 5e 02 00 00       	call   800e06 <printfmt>
  800ba8:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800bab:	e9 49 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800bb0:	56                   	push   %esi
  800bb1:	68 0e 3f 80 00       	push   $0x803f0e
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	ff 75 08             	pushl  0x8(%ebp)
  800bbc:	e8 45 02 00 00       	call   800e06 <printfmt>
  800bc1:	83 c4 10             	add    $0x10,%esp
			break;
  800bc4:	e9 30 02 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bcc:	83 c0 04             	add    $0x4,%eax
  800bcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800bd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd5:	83 e8 04             	sub    $0x4,%eax
  800bd8:	8b 30                	mov    (%eax),%esi
  800bda:	85 f6                	test   %esi,%esi
  800bdc:	75 05                	jne    800be3 <vprintfmt+0x1a6>
				p = "(null)";
  800bde:	be 11 3f 80 00       	mov    $0x803f11,%esi
			if (width > 0 && padc != '-')
  800be3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800be7:	7e 6d                	jle    800c56 <vprintfmt+0x219>
  800be9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800bed:	74 67                	je     800c56 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bf2:	83 ec 08             	sub    $0x8,%esp
  800bf5:	50                   	push   %eax
  800bf6:	56                   	push   %esi
  800bf7:	e8 0c 03 00 00       	call   800f08 <strnlen>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800c02:	eb 16                	jmp    800c1a <vprintfmt+0x1dd>
					putch(padc, putdat);
  800c04:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800c08:	83 ec 08             	sub    $0x8,%esp
  800c0b:	ff 75 0c             	pushl  0xc(%ebp)
  800c0e:	50                   	push   %eax
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	ff d0                	call   *%eax
  800c14:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800c17:	ff 4d e4             	decl   -0x1c(%ebp)
  800c1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c1e:	7f e4                	jg     800c04 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c20:	eb 34                	jmp    800c56 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800c22:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c26:	74 1c                	je     800c44 <vprintfmt+0x207>
  800c28:	83 fb 1f             	cmp    $0x1f,%ebx
  800c2b:	7e 05                	jle    800c32 <vprintfmt+0x1f5>
  800c2d:	83 fb 7e             	cmp    $0x7e,%ebx
  800c30:	7e 12                	jle    800c44 <vprintfmt+0x207>
					putch('?', putdat);
  800c32:	83 ec 08             	sub    $0x8,%esp
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	6a 3f                	push   $0x3f
  800c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3d:	ff d0                	call   *%eax
  800c3f:	83 c4 10             	add    $0x10,%esp
  800c42:	eb 0f                	jmp    800c53 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800c44:	83 ec 08             	sub    $0x8,%esp
  800c47:	ff 75 0c             	pushl  0xc(%ebp)
  800c4a:	53                   	push   %ebx
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
  800c50:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800c53:	ff 4d e4             	decl   -0x1c(%ebp)
  800c56:	89 f0                	mov    %esi,%eax
  800c58:	8d 70 01             	lea    0x1(%eax),%esi
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f be d8             	movsbl %al,%ebx
  800c60:	85 db                	test   %ebx,%ebx
  800c62:	74 24                	je     800c88 <vprintfmt+0x24b>
  800c64:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c68:	78 b8                	js     800c22 <vprintfmt+0x1e5>
  800c6a:	ff 4d e0             	decl   -0x20(%ebp)
  800c6d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800c71:	79 af                	jns    800c22 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c73:	eb 13                	jmp    800c88 <vprintfmt+0x24b>
				putch(' ', putdat);
  800c75:	83 ec 08             	sub    $0x8,%esp
  800c78:	ff 75 0c             	pushl  0xc(%ebp)
  800c7b:	6a 20                	push   $0x20
  800c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c80:	ff d0                	call   *%eax
  800c82:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800c85:	ff 4d e4             	decl   -0x1c(%ebp)
  800c88:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c8c:	7f e7                	jg     800c75 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800c8e:	e9 66 01 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c93:	83 ec 08             	sub    $0x8,%esp
  800c96:	ff 75 e8             	pushl  -0x18(%ebp)
  800c99:	8d 45 14             	lea    0x14(%ebp),%eax
  800c9c:	50                   	push   %eax
  800c9d:	e8 3c fd ff ff       	call   8009de <getint>
  800ca2:	83 c4 10             	add    $0x10,%esp
  800ca5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ca8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800cab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cb1:	85 d2                	test   %edx,%edx
  800cb3:	79 23                	jns    800cd8 <vprintfmt+0x29b>
				putch('-', putdat);
  800cb5:	83 ec 08             	sub    $0x8,%esp
  800cb8:	ff 75 0c             	pushl  0xc(%ebp)
  800cbb:	6a 2d                	push   $0x2d
  800cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc0:	ff d0                	call   *%eax
  800cc2:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800cc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ccb:	f7 d8                	neg    %eax
  800ccd:	83 d2 00             	adc    $0x0,%edx
  800cd0:	f7 da                	neg    %edx
  800cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800cd8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800cdf:	e9 bc 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ce4:	83 ec 08             	sub    $0x8,%esp
  800ce7:	ff 75 e8             	pushl  -0x18(%ebp)
  800cea:	8d 45 14             	lea    0x14(%ebp),%eax
  800ced:	50                   	push   %eax
  800cee:	e8 84 fc ff ff       	call   800977 <getuint>
  800cf3:	83 c4 10             	add    $0x10,%esp
  800cf6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800cfc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800d03:	e9 98 00 00 00       	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	ff 75 0c             	pushl  0xc(%ebp)
  800d0e:	6a 58                	push   $0x58
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	ff d0                	call   *%eax
  800d15:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d18:	83 ec 08             	sub    $0x8,%esp
  800d1b:	ff 75 0c             	pushl  0xc(%ebp)
  800d1e:	6a 58                	push   $0x58
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800d28:	83 ec 08             	sub    $0x8,%esp
  800d2b:	ff 75 0c             	pushl  0xc(%ebp)
  800d2e:	6a 58                	push   $0x58
  800d30:	8b 45 08             	mov    0x8(%ebp),%eax
  800d33:	ff d0                	call   *%eax
  800d35:	83 c4 10             	add    $0x10,%esp
			break;
  800d38:	e9 bc 00 00 00       	jmp    800df9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	6a 30                	push   $0x30
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	ff d0                	call   *%eax
  800d4a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800d4d:	83 ec 08             	sub    $0x8,%esp
  800d50:	ff 75 0c             	pushl  0xc(%ebp)
  800d53:	6a 78                	push   $0x78
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	ff d0                	call   *%eax
  800d5a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800d5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d60:	83 c0 04             	add    $0x4,%eax
  800d63:	89 45 14             	mov    %eax,0x14(%ebp)
  800d66:	8b 45 14             	mov    0x14(%ebp),%eax
  800d69:	83 e8 04             	sub    $0x4,%eax
  800d6c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800d6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800d78:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800d7f:	eb 1f                	jmp    800da0 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800d81:	83 ec 08             	sub    $0x8,%esp
  800d84:	ff 75 e8             	pushl  -0x18(%ebp)
  800d87:	8d 45 14             	lea    0x14(%ebp),%eax
  800d8a:	50                   	push   %eax
  800d8b:	e8 e7 fb ff ff       	call   800977 <getuint>
  800d90:	83 c4 10             	add    $0x10,%esp
  800d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800da0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800da4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800da7:	83 ec 04             	sub    $0x4,%esp
  800daa:	52                   	push   %edx
  800dab:	ff 75 e4             	pushl  -0x1c(%ebp)
  800dae:	50                   	push   %eax
  800daf:	ff 75 f4             	pushl  -0xc(%ebp)
  800db2:	ff 75 f0             	pushl  -0x10(%ebp)
  800db5:	ff 75 0c             	pushl  0xc(%ebp)
  800db8:	ff 75 08             	pushl  0x8(%ebp)
  800dbb:	e8 00 fb ff ff       	call   8008c0 <printnum>
  800dc0:	83 c4 20             	add    $0x20,%esp
			break;
  800dc3:	eb 34                	jmp    800df9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 0c             	pushl  0xc(%ebp)
  800dcb:	53                   	push   %ebx
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	ff d0                	call   *%eax
  800dd1:	83 c4 10             	add    $0x10,%esp
			break;
  800dd4:	eb 23                	jmp    800df9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800dd6:	83 ec 08             	sub    $0x8,%esp
  800dd9:	ff 75 0c             	pushl  0xc(%ebp)
  800ddc:	6a 25                	push   $0x25
  800dde:	8b 45 08             	mov    0x8(%ebp),%eax
  800de1:	ff d0                	call   *%eax
  800de3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800de6:	ff 4d 10             	decl   0x10(%ebp)
  800de9:	eb 03                	jmp    800dee <vprintfmt+0x3b1>
  800deb:	ff 4d 10             	decl   0x10(%ebp)
  800dee:	8b 45 10             	mov    0x10(%ebp),%eax
  800df1:	48                   	dec    %eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3c 25                	cmp    $0x25,%al
  800df6:	75 f3                	jne    800deb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800df8:	90                   	nop
		}
	}
  800df9:	e9 47 fc ff ff       	jmp    800a45 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800dfe:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800dff:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800e02:	5b                   	pop    %ebx
  800e03:	5e                   	pop    %esi
  800e04:	5d                   	pop    %ebp
  800e05:	c3                   	ret    

00800e06 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800e06:	55                   	push   %ebp
  800e07:	89 e5                	mov    %esp,%ebp
  800e09:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800e0c:	8d 45 10             	lea    0x10(%ebp),%eax
  800e0f:	83 c0 04             	add    $0x4,%eax
  800e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800e15:	8b 45 10             	mov    0x10(%ebp),%eax
  800e18:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1b:	50                   	push   %eax
  800e1c:	ff 75 0c             	pushl  0xc(%ebp)
  800e1f:	ff 75 08             	pushl  0x8(%ebp)
  800e22:	e8 16 fc ff ff       	call   800a3d <vprintfmt>
  800e27:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800e2a:	90                   	nop
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800e30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e33:	8b 40 08             	mov    0x8(%eax),%eax
  800e36:	8d 50 01             	lea    0x1(%eax),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e42:	8b 10                	mov    (%eax),%edx
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8b 40 04             	mov    0x4(%eax),%eax
  800e4a:	39 c2                	cmp    %eax,%edx
  800e4c:	73 12                	jae    800e60 <sprintputch+0x33>
		*b->buf++ = ch;
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	8b 00                	mov    (%eax),%eax
  800e53:	8d 48 01             	lea    0x1(%eax),%ecx
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	89 0a                	mov    %ecx,(%edx)
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	88 10                	mov    %dl,(%eax)
}
  800e60:	90                   	nop
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800e88:	74 06                	je     800e90 <vsnprintf+0x2d>
  800e8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8e:	7f 07                	jg     800e97 <vsnprintf+0x34>
		return -E_INVAL;
  800e90:	b8 03 00 00 00       	mov    $0x3,%eax
  800e95:	eb 20                	jmp    800eb7 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e97:	ff 75 14             	pushl  0x14(%ebp)
  800e9a:	ff 75 10             	pushl  0x10(%ebp)
  800e9d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ea0:	50                   	push   %eax
  800ea1:	68 2d 0e 80 00       	push   $0x800e2d
  800ea6:	e8 92 fb ff ff       	call   800a3d <vprintfmt>
  800eab:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800eb1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ebf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ec2:	83 c0 04             	add    $0x4,%eax
  800ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	ff 75 f4             	pushl  -0xc(%ebp)
  800ece:	50                   	push   %eax
  800ecf:	ff 75 0c             	pushl  0xc(%ebp)
  800ed2:	ff 75 08             	pushl  0x8(%ebp)
  800ed5:	e8 89 ff ff ff       	call   800e63 <vsnprintf>
  800eda:	83 c4 10             	add    $0x10,%esp
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ee3:	c9                   	leave  
  800ee4:	c3                   	ret    

00800ee5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800eeb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ef2:	eb 06                	jmp    800efa <strlen+0x15>
		n++;
  800ef4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ef7:	ff 45 08             	incl   0x8(%ebp)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	84 c0                	test   %al,%al
  800f01:	75 f1                	jne    800ef4 <strlen+0xf>
		n++;
	return n;
  800f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f06:	c9                   	leave  
  800f07:	c3                   	ret    

00800f08 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800f08:	55                   	push   %ebp
  800f09:	89 e5                	mov    %esp,%ebp
  800f0b:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f0e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f15:	eb 09                	jmp    800f20 <strnlen+0x18>
		n++;
  800f17:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800f1a:	ff 45 08             	incl   0x8(%ebp)
  800f1d:	ff 4d 0c             	decl   0xc(%ebp)
  800f20:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f24:	74 09                	je     800f2f <strnlen+0x27>
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	84 c0                	test   %al,%al
  800f2d:	75 e8                	jne    800f17 <strnlen+0xf>
		n++;
	return n;
  800f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f32:	c9                   	leave  
  800f33:	c3                   	ret    

00800f34 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800f34:	55                   	push   %ebp
  800f35:	89 e5                	mov    %esp,%ebp
  800f37:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800f40:	90                   	nop
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8d 50 01             	lea    0x1(%eax),%edx
  800f47:	89 55 08             	mov    %edx,0x8(%ebp)
  800f4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f4d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f50:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f53:	8a 12                	mov    (%edx),%dl
  800f55:	88 10                	mov    %dl,(%eax)
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	84 c0                	test   %al,%al
  800f5b:	75 e4                	jne    800f41 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800f5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800f60:	c9                   	leave  
  800f61:	c3                   	ret    

00800f62 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800f6e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800f75:	eb 1f                	jmp    800f96 <strncpy+0x34>
		*dst++ = *src;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8d 50 01             	lea    0x1(%eax),%edx
  800f7d:	89 55 08             	mov    %edx,0x8(%ebp)
  800f80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f83:	8a 12                	mov    (%edx),%dl
  800f85:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800f87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8a:	8a 00                	mov    (%eax),%al
  800f8c:	84 c0                	test   %al,%al
  800f8e:	74 03                	je     800f93 <strncpy+0x31>
			src++;
  800f90:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f93:	ff 45 fc             	incl   -0x4(%ebp)
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f9c:	72 d9                	jb     800f77 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800fa1:	c9                   	leave  
  800fa2:	c3                   	ret    

00800fa3 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800fa3:	55                   	push   %ebp
  800fa4:	89 e5                	mov    %esp,%ebp
  800fa6:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800faf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb3:	74 30                	je     800fe5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800fb5:	eb 16                	jmp    800fcd <strlcpy+0x2a>
			*dst++ = *src++;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fba:	8d 50 01             	lea    0x1(%eax),%edx
  800fbd:	89 55 08             	mov    %edx,0x8(%ebp)
  800fc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fc6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800fc9:	8a 12                	mov    (%edx),%dl
  800fcb:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800fcd:	ff 4d 10             	decl   0x10(%ebp)
  800fd0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fd4:	74 09                	je     800fdf <strlcpy+0x3c>
  800fd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	84 c0                	test   %al,%al
  800fdd:	75 d8                	jne    800fb7 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800fdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800feb:	29 c2                	sub    %eax,%edx
  800fed:	89 d0                	mov    %edx,%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ff4:	eb 06                	jmp    800ffc <strcmp+0xb>
		p++, q++;
  800ff6:	ff 45 08             	incl   0x8(%ebp)
  800ff9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	84 c0                	test   %al,%al
  801003:	74 0e                	je     801013 <strcmp+0x22>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 10                	mov    (%eax),%dl
  80100a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	38 c2                	cmp    %al,%dl
  801011:	74 e3                	je     800ff6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	0f b6 d0             	movzbl %al,%edx
  80101b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101e:	8a 00                	mov    (%eax),%al
  801020:	0f b6 c0             	movzbl %al,%eax
  801023:	29 c2                	sub    %eax,%edx
  801025:	89 d0                	mov    %edx,%eax
}
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80102c:	eb 09                	jmp    801037 <strncmp+0xe>
		n--, p++, q++;
  80102e:	ff 4d 10             	decl   0x10(%ebp)
  801031:	ff 45 08             	incl   0x8(%ebp)
  801034:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801037:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80103b:	74 17                	je     801054 <strncmp+0x2b>
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	8a 00                	mov    (%eax),%al
  801042:	84 c0                	test   %al,%al
  801044:	74 0e                	je     801054 <strncmp+0x2b>
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	8a 10                	mov    (%eax),%dl
  80104b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	38 c2                	cmp    %al,%dl
  801052:	74 da                	je     80102e <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strncmp+0x38>
		return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
  80105f:	eb 14                	jmp    801075 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	8a 00                	mov    (%eax),%al
  801066:	0f b6 d0             	movzbl %al,%edx
  801069:	8b 45 0c             	mov    0xc(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	0f b6 c0             	movzbl %al,%eax
  801071:	29 c2                	sub    %eax,%edx
  801073:	89 d0                	mov    %edx,%eax
}
  801075:	5d                   	pop    %ebp
  801076:	c3                   	ret    

00801077 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 04             	sub    $0x4,%esp
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801083:	eb 12                	jmp    801097 <strchr+0x20>
		if (*s == c)
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
  801088:	8a 00                	mov    (%eax),%al
  80108a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80108d:	75 05                	jne    801094 <strchr+0x1d>
			return (char *) s;
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	eb 11                	jmp    8010a5 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801094:	ff 45 08             	incl   0x8(%ebp)
  801097:	8b 45 08             	mov    0x8(%ebp),%eax
  80109a:	8a 00                	mov    (%eax),%al
  80109c:	84 c0                	test   %al,%al
  80109e:	75 e5                	jne    801085 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a5:	c9                   	leave  
  8010a6:	c3                   	ret    

008010a7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 04             	sub    $0x4,%esp
  8010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8010b3:	eb 0d                	jmp    8010c2 <strfind+0x1b>
		if (*s == c)
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8010bd:	74 0e                	je     8010cd <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8010bf:	ff 45 08             	incl   0x8(%ebp)
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	84 c0                	test   %al,%al
  8010c9:	75 ea                	jne    8010b5 <strfind+0xe>
  8010cb:	eb 01                	jmp    8010ce <strfind+0x27>
		if (*s == c)
			break;
  8010cd:	90                   	nop
	return (char *) s;
  8010ce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010d1:	c9                   	leave  
  8010d2:	c3                   	ret    

008010d3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8010d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8010df:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8010e5:	eb 0e                	jmp    8010f5 <memset+0x22>
		*p++ = c;
  8010e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ea:	8d 50 01             	lea    0x1(%eax),%edx
  8010ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8010f5:	ff 4d f8             	decl   -0x8(%ebp)
  8010f8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8010fc:	79 e9                	jns    8010e7 <memset+0x14>
		*p++ = c;

	return v;
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801101:	c9                   	leave  
  801102:	c3                   	ret    

00801103 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801103:	55                   	push   %ebp
  801104:	89 e5                	mov    %esp,%ebp
  801106:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80110f:	8b 45 08             	mov    0x8(%ebp),%eax
  801112:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801115:	eb 16                	jmp    80112d <memcpy+0x2a>
		*d++ = *s++;
  801117:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80111a:	8d 50 01             	lea    0x1(%eax),%edx
  80111d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801120:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801123:	8d 4a 01             	lea    0x1(%edx),%ecx
  801126:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801129:	8a 12                	mov    (%edx),%dl
  80112b:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80112d:	8b 45 10             	mov    0x10(%ebp),%eax
  801130:	8d 50 ff             	lea    -0x1(%eax),%edx
  801133:	89 55 10             	mov    %edx,0x10(%ebp)
  801136:	85 c0                	test   %eax,%eax
  801138:	75 dd                	jne    801117 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80113a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80113d:	c9                   	leave  
  80113e:	c3                   	ret    

0080113f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801151:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801157:	73 50                	jae    8011a9 <memmove+0x6a>
  801159:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80115c:	8b 45 10             	mov    0x10(%ebp),%eax
  80115f:	01 d0                	add    %edx,%eax
  801161:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801164:	76 43                	jbe    8011a9 <memmove+0x6a>
		s += n;
  801166:	8b 45 10             	mov    0x10(%ebp),%eax
  801169:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80116c:	8b 45 10             	mov    0x10(%ebp),%eax
  80116f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801172:	eb 10                	jmp    801184 <memmove+0x45>
			*--d = *--s;
  801174:	ff 4d f8             	decl   -0x8(%ebp)
  801177:	ff 4d fc             	decl   -0x4(%ebp)
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117d:	8a 10                	mov    (%eax),%dl
  80117f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801182:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801184:	8b 45 10             	mov    0x10(%ebp),%eax
  801187:	8d 50 ff             	lea    -0x1(%eax),%edx
  80118a:	89 55 10             	mov    %edx,0x10(%ebp)
  80118d:	85 c0                	test   %eax,%eax
  80118f:	75 e3                	jne    801174 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801191:	eb 23                	jmp    8011b6 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801193:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801196:	8d 50 01             	lea    0x1(%eax),%edx
  801199:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80119c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80119f:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011a2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8011a5:	8a 12                	mov    (%edx),%dl
  8011a7:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8011a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011af:	89 55 10             	mov    %edx,0x10(%ebp)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	75 dd                	jne    801193 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8011b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8011cd:	eb 2a                	jmp    8011f9 <memcmp+0x3e>
		if (*s1 != *s2)
  8011cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d2:	8a 10                	mov    (%eax),%dl
  8011d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d7:	8a 00                	mov    (%eax),%al
  8011d9:	38 c2                	cmp    %al,%dl
  8011db:	74 16                	je     8011f3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8011dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011e0:	8a 00                	mov    (%eax),%al
  8011e2:	0f b6 d0             	movzbl %al,%edx
  8011e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e8:	8a 00                	mov    (%eax),%al
  8011ea:	0f b6 c0             	movzbl %al,%eax
  8011ed:	29 c2                	sub    %eax,%edx
  8011ef:	89 d0                	mov    %edx,%eax
  8011f1:	eb 18                	jmp    80120b <memcmp+0x50>
		s1++, s2++;
  8011f3:	ff 45 fc             	incl   -0x4(%ebp)
  8011f6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	8d 50 ff             	lea    -0x1(%eax),%edx
  8011ff:	89 55 10             	mov    %edx,0x10(%ebp)
  801202:	85 c0                	test   %eax,%eax
  801204:	75 c9                	jne    8011cf <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801206:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80120b:	c9                   	leave  
  80120c:	c3                   	ret    

0080120d <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801213:	8b 55 08             	mov    0x8(%ebp),%edx
  801216:	8b 45 10             	mov    0x10(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80121e:	eb 15                	jmp    801235 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	8a 00                	mov    (%eax),%al
  801225:	0f b6 d0             	movzbl %al,%edx
  801228:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122b:	0f b6 c0             	movzbl %al,%eax
  80122e:	39 c2                	cmp    %eax,%edx
  801230:	74 0d                	je     80123f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801232:	ff 45 08             	incl   0x8(%ebp)
  801235:	8b 45 08             	mov    0x8(%ebp),%eax
  801238:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80123b:	72 e3                	jb     801220 <memfind+0x13>
  80123d:	eb 01                	jmp    801240 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80123f:	90                   	nop
	return (void *) s;
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801243:	c9                   	leave  
  801244:	c3                   	ret    

00801245 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80124b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801259:	eb 03                	jmp    80125e <strtol+0x19>
		s++;
  80125b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80125e:	8b 45 08             	mov    0x8(%ebp),%eax
  801261:	8a 00                	mov    (%eax),%al
  801263:	3c 20                	cmp    $0x20,%al
  801265:	74 f4                	je     80125b <strtol+0x16>
  801267:	8b 45 08             	mov    0x8(%ebp),%eax
  80126a:	8a 00                	mov    (%eax),%al
  80126c:	3c 09                	cmp    $0x9,%al
  80126e:	74 eb                	je     80125b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	3c 2b                	cmp    $0x2b,%al
  801277:	75 05                	jne    80127e <strtol+0x39>
		s++;
  801279:	ff 45 08             	incl   0x8(%ebp)
  80127c:	eb 13                	jmp    801291 <strtol+0x4c>
	else if (*s == '-')
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	8a 00                	mov    (%eax),%al
  801283:	3c 2d                	cmp    $0x2d,%al
  801285:	75 0a                	jne    801291 <strtol+0x4c>
		s++, neg = 1;
  801287:	ff 45 08             	incl   0x8(%ebp)
  80128a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801291:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801295:	74 06                	je     80129d <strtol+0x58>
  801297:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80129b:	75 20                	jne    8012bd <strtol+0x78>
  80129d:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a0:	8a 00                	mov    (%eax),%al
  8012a2:	3c 30                	cmp    $0x30,%al
  8012a4:	75 17                	jne    8012bd <strtol+0x78>
  8012a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a9:	40                   	inc    %eax
  8012aa:	8a 00                	mov    (%eax),%al
  8012ac:	3c 78                	cmp    $0x78,%al
  8012ae:	75 0d                	jne    8012bd <strtol+0x78>
		s += 2, base = 16;
  8012b0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8012b4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8012bb:	eb 28                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8012bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012c1:	75 15                	jne    8012d8 <strtol+0x93>
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	8a 00                	mov    (%eax),%al
  8012c8:	3c 30                	cmp    $0x30,%al
  8012ca:	75 0c                	jne    8012d8 <strtol+0x93>
		s++, base = 8;
  8012cc:	ff 45 08             	incl   0x8(%ebp)
  8012cf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8012d6:	eb 0d                	jmp    8012e5 <strtol+0xa0>
	else if (base == 0)
  8012d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012dc:	75 07                	jne    8012e5 <strtol+0xa0>
		base = 10;
  8012de:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	8a 00                	mov    (%eax),%al
  8012ea:	3c 2f                	cmp    $0x2f,%al
  8012ec:	7e 19                	jle    801307 <strtol+0xc2>
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	8a 00                	mov    (%eax),%al
  8012f3:	3c 39                	cmp    $0x39,%al
  8012f5:	7f 10                	jg     801307 <strtol+0xc2>
			dig = *s - '0';
  8012f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fa:	8a 00                	mov    (%eax),%al
  8012fc:	0f be c0             	movsbl %al,%eax
  8012ff:	83 e8 30             	sub    $0x30,%eax
  801302:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801305:	eb 42                	jmp    801349 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801307:	8b 45 08             	mov    0x8(%ebp),%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	3c 60                	cmp    $0x60,%al
  80130e:	7e 19                	jle    801329 <strtol+0xe4>
  801310:	8b 45 08             	mov    0x8(%ebp),%eax
  801313:	8a 00                	mov    (%eax),%al
  801315:	3c 7a                	cmp    $0x7a,%al
  801317:	7f 10                	jg     801329 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801319:	8b 45 08             	mov    0x8(%ebp),%eax
  80131c:	8a 00                	mov    (%eax),%al
  80131e:	0f be c0             	movsbl %al,%eax
  801321:	83 e8 57             	sub    $0x57,%eax
  801324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801327:	eb 20                	jmp    801349 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801329:	8b 45 08             	mov    0x8(%ebp),%eax
  80132c:	8a 00                	mov    (%eax),%al
  80132e:	3c 40                	cmp    $0x40,%al
  801330:	7e 39                	jle    80136b <strtol+0x126>
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	8a 00                	mov    (%eax),%al
  801337:	3c 5a                	cmp    $0x5a,%al
  801339:	7f 30                	jg     80136b <strtol+0x126>
			dig = *s - 'A' + 10;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	8a 00                	mov    (%eax),%al
  801340:	0f be c0             	movsbl %al,%eax
  801343:	83 e8 37             	sub    $0x37,%eax
  801346:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80134f:	7d 19                	jge    80136a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801351:	ff 45 08             	incl   0x8(%ebp)
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	0f af 45 10          	imul   0x10(%ebp),%eax
  80135b:	89 c2                	mov    %eax,%edx
  80135d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801360:	01 d0                	add    %edx,%eax
  801362:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801365:	e9 7b ff ff ff       	jmp    8012e5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80136a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80136b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80136f:	74 08                	je     801379 <strtol+0x134>
		*endptr = (char *) s;
  801371:	8b 45 0c             	mov    0xc(%ebp),%eax
  801374:	8b 55 08             	mov    0x8(%ebp),%edx
  801377:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801379:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80137d:	74 07                	je     801386 <strtol+0x141>
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	f7 d8                	neg    %eax
  801384:	eb 03                	jmp    801389 <strtol+0x144>
  801386:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801389:	c9                   	leave  
  80138a:	c3                   	ret    

0080138b <ltostr>:

void
ltostr(long value, char *str)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801391:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801398:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80139f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013a3:	79 13                	jns    8013b8 <ltostr+0x2d>
	{
		neg = 1;
  8013a5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8013b2:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8013b5:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8013b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8013c0:	99                   	cltd   
  8013c1:	f7 f9                	idiv   %ecx
  8013c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8013c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c9:	8d 50 01             	lea    0x1(%eax),%edx
  8013cc:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8013cf:	89 c2                	mov    %eax,%edx
  8013d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013d4:	01 d0                	add    %edx,%eax
  8013d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8013d9:	83 c2 30             	add    $0x30,%edx
  8013dc:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8013de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013e1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013e6:	f7 e9                	imul   %ecx
  8013e8:	c1 fa 02             	sar    $0x2,%edx
  8013eb:	89 c8                	mov    %ecx,%eax
  8013ed:	c1 f8 1f             	sar    $0x1f,%eax
  8013f0:	29 c2                	sub    %eax,%edx
  8013f2:	89 d0                	mov    %edx,%eax
  8013f4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8013f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013fa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8013ff:	f7 e9                	imul   %ecx
  801401:	c1 fa 02             	sar    $0x2,%edx
  801404:	89 c8                	mov    %ecx,%eax
  801406:	c1 f8 1f             	sar    $0x1f,%eax
  801409:	29 c2                	sub    %eax,%edx
  80140b:	89 d0                	mov    %edx,%eax
  80140d:	c1 e0 02             	shl    $0x2,%eax
  801410:	01 d0                	add    %edx,%eax
  801412:	01 c0                	add    %eax,%eax
  801414:	29 c1                	sub    %eax,%ecx
  801416:	89 ca                	mov    %ecx,%edx
  801418:	85 d2                	test   %edx,%edx
  80141a:	75 9c                	jne    8013b8 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80141c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801423:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801426:	48                   	dec    %eax
  801427:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80142a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80142e:	74 3d                	je     80146d <ltostr+0xe2>
		start = 1 ;
  801430:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801437:	eb 34                	jmp    80146d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801439:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	01 d0                	add    %edx,%eax
  801441:	8a 00                	mov    (%eax),%al
  801443:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801446:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801449:	8b 45 0c             	mov    0xc(%ebp),%eax
  80144c:	01 c2                	add    %eax,%edx
  80144e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801451:	8b 45 0c             	mov    0xc(%ebp),%eax
  801454:	01 c8                	add    %ecx,%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80145a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801460:	01 c2                	add    %eax,%edx
  801462:	8a 45 eb             	mov    -0x15(%ebp),%al
  801465:	88 02                	mov    %al,(%edx)
		start++ ;
  801467:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80146a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80146d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801470:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801473:	7c c4                	jl     801439 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801475:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801478:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147b:	01 d0                	add    %edx,%eax
  80147d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801480:	90                   	nop
  801481:	c9                   	leave  
  801482:	c3                   	ret    

00801483 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801489:	ff 75 08             	pushl  0x8(%ebp)
  80148c:	e8 54 fa ff ff       	call   800ee5 <strlen>
  801491:	83 c4 04             	add    $0x4,%esp
  801494:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801497:	ff 75 0c             	pushl  0xc(%ebp)
  80149a:	e8 46 fa ff ff       	call   800ee5 <strlen>
  80149f:	83 c4 04             	add    $0x4,%esp
  8014a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8014a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8014ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014b3:	eb 17                	jmp    8014cc <strcconcat+0x49>
		final[s] = str1[s] ;
  8014b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8014bb:	01 c2                	add    %eax,%edx
  8014bd:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8014c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c3:	01 c8                	add    %ecx,%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8014c9:	ff 45 fc             	incl   -0x4(%ebp)
  8014cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014cf:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8014d2:	7c e1                	jl     8014b5 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8014d4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8014db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8014e2:	eb 1f                	jmp    801503 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8014e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014e7:	8d 50 01             	lea    0x1(%eax),%edx
  8014ea:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8014ed:	89 c2                	mov    %eax,%edx
  8014ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f2:	01 c2                	add    %eax,%edx
  8014f4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8014f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fa:	01 c8                	add    %ecx,%eax
  8014fc:	8a 00                	mov    (%eax),%al
  8014fe:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801500:	ff 45 f8             	incl   -0x8(%ebp)
  801503:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801506:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801509:	7c d9                	jl     8014e4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80150b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80150e:	8b 45 10             	mov    0x10(%ebp),%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	c6 00 00             	movb   $0x0,(%eax)
}
  801516:	90                   	nop
  801517:	c9                   	leave  
  801518:	c3                   	ret    

00801519 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801519:	55                   	push   %ebp
  80151a:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80151c:	8b 45 14             	mov    0x14(%ebp),%eax
  80151f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801525:	8b 45 14             	mov    0x14(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801531:	8b 45 10             	mov    0x10(%ebp),%eax
  801534:	01 d0                	add    %edx,%eax
  801536:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80153c:	eb 0c                	jmp    80154a <strsplit+0x31>
			*string++ = 0;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	8d 50 01             	lea    0x1(%eax),%edx
  801544:	89 55 08             	mov    %edx,0x8(%ebp)
  801547:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	84 c0                	test   %al,%al
  801551:	74 18                	je     80156b <strsplit+0x52>
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	8a 00                	mov    (%eax),%al
  801558:	0f be c0             	movsbl %al,%eax
  80155b:	50                   	push   %eax
  80155c:	ff 75 0c             	pushl  0xc(%ebp)
  80155f:	e8 13 fb ff ff       	call   801077 <strchr>
  801564:	83 c4 08             	add    $0x8,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	75 d3                	jne    80153e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8a 00                	mov    (%eax),%al
  801570:	84 c0                	test   %al,%al
  801572:	74 5a                	je     8015ce <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801574:	8b 45 14             	mov    0x14(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	83 f8 0f             	cmp    $0xf,%eax
  80157c:	75 07                	jne    801585 <strsplit+0x6c>
		{
			return 0;
  80157e:	b8 00 00 00 00       	mov    $0x0,%eax
  801583:	eb 66                	jmp    8015eb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801585:	8b 45 14             	mov    0x14(%ebp),%eax
  801588:	8b 00                	mov    (%eax),%eax
  80158a:	8d 48 01             	lea    0x1(%eax),%ecx
  80158d:	8b 55 14             	mov    0x14(%ebp),%edx
  801590:	89 0a                	mov    %ecx,(%edx)
  801592:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801599:	8b 45 10             	mov    0x10(%ebp),%eax
  80159c:	01 c2                	add    %eax,%edx
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a3:	eb 03                	jmp    8015a8 <strsplit+0x8f>
			string++;
  8015a5:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	8a 00                	mov    (%eax),%al
  8015ad:	84 c0                	test   %al,%al
  8015af:	74 8b                	je     80153c <strsplit+0x23>
  8015b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b4:	8a 00                	mov    (%eax),%al
  8015b6:	0f be c0             	movsbl %al,%eax
  8015b9:	50                   	push   %eax
  8015ba:	ff 75 0c             	pushl  0xc(%ebp)
  8015bd:	e8 b5 fa ff ff       	call   801077 <strchr>
  8015c2:	83 c4 08             	add    $0x8,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	74 dc                	je     8015a5 <strsplit+0x8c>
			string++;
	}
  8015c9:	e9 6e ff ff ff       	jmp    80153c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8015ce:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8015cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8015db:	8b 45 10             	mov    0x10(%ebp),%eax
  8015de:	01 d0                	add    %edx,%eax
  8015e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8015e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8015f3:	a1 04 50 80 00       	mov    0x805004,%eax
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	74 1f                	je     80161b <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8015fc:	e8 1d 00 00 00       	call   80161e <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	68 70 40 80 00       	push   $0x804070
  801609:	e8 55 f2 ff ff       	call   800863 <cprintf>
  80160e:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801611:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801618:	00 00 00 
	}
}
  80161b:	90                   	nop
  80161c:	c9                   	leave  
  80161d:	c3                   	ret    

0080161e <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801624:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80162b:	00 00 00 
  80162e:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801635:	00 00 00 
  801638:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80163f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801642:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801649:	00 00 00 
  80164c:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801653:	00 00 00 
  801656:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80165d:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801660:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166a:	c1 e8 0c             	shr    $0xc,%eax
  80166d:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801672:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801681:	2d 00 10 00 00       	sub    $0x1000,%eax
  801686:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  80168b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801692:	a1 20 51 80 00       	mov    0x805120,%eax
  801697:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80169b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80169e:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8016a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8016a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ab:	01 d0                	add    %edx,%eax
  8016ad:	48                   	dec    %eax
  8016ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8016b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b9:	f7 75 e4             	divl   -0x1c(%ebp)
  8016bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016bf:	29 d0                	sub    %edx,%eax
  8016c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8016c4:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8016cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8016ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8016d3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8016d8:	83 ec 04             	sub    $0x4,%esp
  8016db:	6a 07                	push   $0x7
  8016dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8016e0:	50                   	push   %eax
  8016e1:	e8 3d 06 00 00       	call   801d23 <sys_allocate_chunk>
  8016e6:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8016e9:	a1 20 51 80 00       	mov    0x805120,%eax
  8016ee:	83 ec 0c             	sub    $0xc,%esp
  8016f1:	50                   	push   %eax
  8016f2:	e8 b2 0c 00 00       	call   8023a9 <initialize_MemBlocksList>
  8016f7:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8016fa:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8016ff:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801702:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801706:	0f 84 f3 00 00 00    	je     8017ff <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80170c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801710:	75 14                	jne    801726 <initialize_dyn_block_system+0x108>
  801712:	83 ec 04             	sub    $0x4,%esp
  801715:	68 95 40 80 00       	push   $0x804095
  80171a:	6a 36                	push   $0x36
  80171c:	68 b3 40 80 00       	push   $0x8040b3
  801721:	e8 89 ee ff ff       	call   8005af <_panic>
  801726:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801729:	8b 00                	mov    (%eax),%eax
  80172b:	85 c0                	test   %eax,%eax
  80172d:	74 10                	je     80173f <initialize_dyn_block_system+0x121>
  80172f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801732:	8b 00                	mov    (%eax),%eax
  801734:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801737:	8b 52 04             	mov    0x4(%edx),%edx
  80173a:	89 50 04             	mov    %edx,0x4(%eax)
  80173d:	eb 0b                	jmp    80174a <initialize_dyn_block_system+0x12c>
  80173f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801742:	8b 40 04             	mov    0x4(%eax),%eax
  801745:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80174a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80174d:	8b 40 04             	mov    0x4(%eax),%eax
  801750:	85 c0                	test   %eax,%eax
  801752:	74 0f                	je     801763 <initialize_dyn_block_system+0x145>
  801754:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801757:	8b 40 04             	mov    0x4(%eax),%eax
  80175a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80175d:	8b 12                	mov    (%edx),%edx
  80175f:	89 10                	mov    %edx,(%eax)
  801761:	eb 0a                	jmp    80176d <initialize_dyn_block_system+0x14f>
  801763:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801766:	8b 00                	mov    (%eax),%eax
  801768:	a3 48 51 80 00       	mov    %eax,0x805148
  80176d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801770:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801776:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801779:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801780:	a1 54 51 80 00       	mov    0x805154,%eax
  801785:	48                   	dec    %eax
  801786:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80178b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80178e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801795:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801798:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80179f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8017a3:	75 14                	jne    8017b9 <initialize_dyn_block_system+0x19b>
  8017a5:	83 ec 04             	sub    $0x4,%esp
  8017a8:	68 c0 40 80 00       	push   $0x8040c0
  8017ad:	6a 3e                	push   $0x3e
  8017af:	68 b3 40 80 00       	push   $0x8040b3
  8017b4:	e8 f6 ed ff ff       	call   8005af <_panic>
  8017b9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8017bf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017c2:	89 10                	mov    %edx,(%eax)
  8017c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017c7:	8b 00                	mov    (%eax),%eax
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	74 0d                	je     8017da <initialize_dyn_block_system+0x1bc>
  8017cd:	a1 38 51 80 00       	mov    0x805138,%eax
  8017d2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8017d5:	89 50 04             	mov    %edx,0x4(%eax)
  8017d8:	eb 08                	jmp    8017e2 <initialize_dyn_block_system+0x1c4>
  8017da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017dd:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8017e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017e5:	a3 38 51 80 00       	mov    %eax,0x805138
  8017ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8017ed:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8017f4:	a1 44 51 80 00       	mov    0x805144,%eax
  8017f9:	40                   	inc    %eax
  8017fa:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  8017ff:	90                   	nop
  801800:	c9                   	leave  
  801801:	c3                   	ret    

00801802 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801808:	e8 e0 fd ff ff       	call   8015ed <InitializeUHeap>
		if (size == 0) return NULL ;
  80180d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801811:	75 07                	jne    80181a <malloc+0x18>
  801813:	b8 00 00 00 00       	mov    $0x0,%eax
  801818:	eb 7f                	jmp    801899 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80181a:	e8 d2 08 00 00       	call   8020f1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80181f:	85 c0                	test   %eax,%eax
  801821:	74 71                	je     801894 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801823:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80182a:	8b 55 08             	mov    0x8(%ebp),%edx
  80182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801830:	01 d0                	add    %edx,%eax
  801832:	48                   	dec    %eax
  801833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801839:	ba 00 00 00 00       	mov    $0x0,%edx
  80183e:	f7 75 f4             	divl   -0xc(%ebp)
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801844:	29 d0                	sub    %edx,%eax
  801846:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801849:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801850:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801857:	76 07                	jbe    801860 <malloc+0x5e>
					return NULL ;
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
  80185e:	eb 39                	jmp    801899 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801860:	83 ec 0c             	sub    $0xc,%esp
  801863:	ff 75 08             	pushl  0x8(%ebp)
  801866:	e8 e6 0d 00 00       	call   802651 <alloc_block_FF>
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801871:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801875:	74 16                	je     80188d <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801877:	83 ec 0c             	sub    $0xc,%esp
  80187a:	ff 75 ec             	pushl  -0x14(%ebp)
  80187d:	e8 37 0c 00 00       	call   8024b9 <insert_sorted_allocList>
  801882:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801888:	8b 40 08             	mov    0x8(%eax),%eax
  80188b:	eb 0c                	jmp    801899 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  80188d:	b8 00 00 00 00       	mov    $0x0,%eax
  801892:	eb 05                	jmp    801899 <malloc+0x97>
				}
		}
	return 0;
  801894:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801899:	c9                   	leave  
  80189a:	c3                   	ret    

0080189b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80189b:	55                   	push   %ebp
  80189c:	89 e5                	mov    %esp,%ebp
  80189e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8018a7:	83 ec 08             	sub    $0x8,%esp
  8018aa:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ad:	68 40 50 80 00       	push   $0x805040
  8018b2:	e8 cf 0b 00 00       	call   802486 <find_block>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8018bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8018c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c9:	8b 40 08             	mov    0x8(%eax),%eax
  8018cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8018cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018d3:	0f 84 a1 00 00 00    	je     80197a <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8018d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018dd:	75 17                	jne    8018f6 <free+0x5b>
  8018df:	83 ec 04             	sub    $0x4,%esp
  8018e2:	68 95 40 80 00       	push   $0x804095
  8018e7:	68 80 00 00 00       	push   $0x80
  8018ec:	68 b3 40 80 00       	push   $0x8040b3
  8018f1:	e8 b9 ec ff ff       	call   8005af <_panic>
  8018f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f9:	8b 00                	mov    (%eax),%eax
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	74 10                	je     80190f <free+0x74>
  8018ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801902:	8b 00                	mov    (%eax),%eax
  801904:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801907:	8b 52 04             	mov    0x4(%edx),%edx
  80190a:	89 50 04             	mov    %edx,0x4(%eax)
  80190d:	eb 0b                	jmp    80191a <free+0x7f>
  80190f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801912:	8b 40 04             	mov    0x4(%eax),%eax
  801915:	a3 44 50 80 00       	mov    %eax,0x805044
  80191a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191d:	8b 40 04             	mov    0x4(%eax),%eax
  801920:	85 c0                	test   %eax,%eax
  801922:	74 0f                	je     801933 <free+0x98>
  801924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801927:	8b 40 04             	mov    0x4(%eax),%eax
  80192a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80192d:	8b 12                	mov    (%edx),%edx
  80192f:	89 10                	mov    %edx,(%eax)
  801931:	eb 0a                	jmp    80193d <free+0xa2>
  801933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801936:	8b 00                	mov    (%eax),%eax
  801938:	a3 40 50 80 00       	mov    %eax,0x805040
  80193d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801949:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801950:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801955:	48                   	dec    %eax
  801956:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  80195b:	83 ec 0c             	sub    $0xc,%esp
  80195e:	ff 75 f0             	pushl  -0x10(%ebp)
  801961:	e8 29 12 00 00       	call   802b8f <insert_sorted_with_merge_freeList>
  801966:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801969:	83 ec 08             	sub    $0x8,%esp
  80196c:	ff 75 ec             	pushl  -0x14(%ebp)
  80196f:	ff 75 e8             	pushl  -0x18(%ebp)
  801972:	e8 74 03 00 00       	call   801ceb <sys_free_user_mem>
  801977:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80197a:	90                   	nop
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	83 ec 38             	sub    $0x38,%esp
  801983:	8b 45 10             	mov    0x10(%ebp),%eax
  801986:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801989:	e8 5f fc ff ff       	call   8015ed <InitializeUHeap>
	if (size == 0) return NULL ;
  80198e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801992:	75 0a                	jne    80199e <smalloc+0x21>
  801994:	b8 00 00 00 00       	mov    $0x0,%eax
  801999:	e9 b2 00 00 00       	jmp    801a50 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  80199e:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8019a5:	76 0a                	jbe    8019b1 <smalloc+0x34>
		return NULL;
  8019a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ac:	e9 9f 00 00 00       	jmp    801a50 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8019b1:	e8 3b 07 00 00       	call   8020f1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	0f 84 8d 00 00 00    	je     801a4b <smalloc+0xce>
	struct MemBlock *b = NULL;
  8019be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8019c5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8019cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d2:	01 d0                	add    %edx,%eax
  8019d4:	48                   	dec    %eax
  8019d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8019d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019db:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e0:	f7 75 f0             	divl   -0x10(%ebp)
  8019e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019e6:	29 d0                	sub    %edx,%eax
  8019e8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8019eb:	83 ec 0c             	sub    $0xc,%esp
  8019ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8019f1:	e8 5b 0c 00 00       	call   802651 <alloc_block_FF>
  8019f6:	83 c4 10             	add    $0x10,%esp
  8019f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8019fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a00:	75 07                	jne    801a09 <smalloc+0x8c>
			return NULL;
  801a02:	b8 00 00 00 00       	mov    $0x0,%eax
  801a07:	eb 47                	jmp    801a50 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801a09:	83 ec 0c             	sub    $0xc,%esp
  801a0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801a0f:	e8 a5 0a 00 00       	call   8024b9 <insert_sorted_allocList>
  801a14:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1a:	8b 40 08             	mov    0x8(%eax),%eax
  801a1d:	89 c2                	mov    %eax,%edx
  801a1f:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801a23:	52                   	push   %edx
  801a24:	50                   	push   %eax
  801a25:	ff 75 0c             	pushl  0xc(%ebp)
  801a28:	ff 75 08             	pushl  0x8(%ebp)
  801a2b:	e8 46 04 00 00       	call   801e76 <sys_createSharedObject>
  801a30:	83 c4 10             	add    $0x10,%esp
  801a33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801a36:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a3a:	78 08                	js     801a44 <smalloc+0xc7>
		return (void *)b->sva;
  801a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a3f:	8b 40 08             	mov    0x8(%eax),%eax
  801a42:	eb 0c                	jmp    801a50 <smalloc+0xd3>
		}else{
		return NULL;
  801a44:	b8 00 00 00 00       	mov    $0x0,%eax
  801a49:	eb 05                	jmp    801a50 <smalloc+0xd3>
			}

	}return NULL;
  801a4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801a58:	e8 90 fb ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801a5d:	e8 8f 06 00 00       	call   8020f1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a62:	85 c0                	test   %eax,%eax
  801a64:	0f 84 ad 00 00 00    	je     801b17 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801a6a:	83 ec 08             	sub    $0x8,%esp
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	e8 28 04 00 00       	call   801ea0 <sys_getSizeOfSharedObject>
  801a78:	83 c4 10             	add    $0x10,%esp
  801a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a82:	79 0a                	jns    801a8e <sget+0x3c>
    {
    	return NULL;
  801a84:	b8 00 00 00 00       	mov    $0x0,%eax
  801a89:	e9 8e 00 00 00       	jmp    801b1c <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801a8e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801a95:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801aa2:	01 d0                	add    %edx,%eax
  801aa4:	48                   	dec    %eax
  801aa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801aab:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab0:	f7 75 ec             	divl   -0x14(%ebp)
  801ab3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ab6:	29 d0                	sub    %edx,%eax
  801ab8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801abb:	83 ec 0c             	sub    $0xc,%esp
  801abe:	ff 75 e4             	pushl  -0x1c(%ebp)
  801ac1:	e8 8b 0b 00 00       	call   802651 <alloc_block_FF>
  801ac6:	83 c4 10             	add    $0x10,%esp
  801ac9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801acc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ad0:	75 07                	jne    801ad9 <sget+0x87>
				return NULL;
  801ad2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad7:	eb 43                	jmp    801b1c <sget+0xca>
			}
			insert_sorted_allocList(b);
  801ad9:	83 ec 0c             	sub    $0xc,%esp
  801adc:	ff 75 f0             	pushl  -0x10(%ebp)
  801adf:	e8 d5 09 00 00       	call   8024b9 <insert_sorted_allocList>
  801ae4:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aea:	8b 40 08             	mov    0x8(%eax),%eax
  801aed:	83 ec 04             	sub    $0x4,%esp
  801af0:	50                   	push   %eax
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	ff 75 08             	pushl  0x8(%ebp)
  801af7:	e8 c1 03 00 00       	call   801ebd <sys_getSharedObject>
  801afc:	83 c4 10             	add    $0x10,%esp
  801aff:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801b02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b06:	78 08                	js     801b10 <sget+0xbe>
			return (void *)b->sva;
  801b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0b:	8b 40 08             	mov    0x8(%eax),%eax
  801b0e:	eb 0c                	jmp    801b1c <sget+0xca>
			}else{
			return NULL;
  801b10:	b8 00 00 00 00       	mov    $0x0,%eax
  801b15:	eb 05                	jmp    801b1c <sget+0xca>
			}
    }}return NULL;
  801b17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b24:	e8 c4 fa ff ff       	call   8015ed <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801b29:	83 ec 04             	sub    $0x4,%esp
  801b2c:	68 e4 40 80 00       	push   $0x8040e4
  801b31:	68 03 01 00 00       	push   $0x103
  801b36:	68 b3 40 80 00       	push   $0x8040b3
  801b3b:	e8 6f ea ff ff       	call   8005af <_panic>

00801b40 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801b46:	83 ec 04             	sub    $0x4,%esp
  801b49:	68 0c 41 80 00       	push   $0x80410c
  801b4e:	68 17 01 00 00       	push   $0x117
  801b53:	68 b3 40 80 00       	push   $0x8040b3
  801b58:	e8 52 ea ff ff       	call   8005af <_panic>

00801b5d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b63:	83 ec 04             	sub    $0x4,%esp
  801b66:	68 30 41 80 00       	push   $0x804130
  801b6b:	68 22 01 00 00       	push   $0x122
  801b70:	68 b3 40 80 00       	push   $0x8040b3
  801b75:	e8 35 ea ff ff       	call   8005af <_panic>

00801b7a <shrink>:

}
void shrink(uint32 newSize)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	68 30 41 80 00       	push   $0x804130
  801b88:	68 27 01 00 00       	push   $0x127
  801b8d:	68 b3 40 80 00       	push   $0x8040b3
  801b92:	e8 18 ea ff ff       	call   8005af <_panic>

00801b97 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801b97:	55                   	push   %ebp
  801b98:	89 e5                	mov    %esp,%ebp
  801b9a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801b9d:	83 ec 04             	sub    $0x4,%esp
  801ba0:	68 30 41 80 00       	push   $0x804130
  801ba5:	68 2c 01 00 00       	push   $0x12c
  801baa:	68 b3 40 80 00       	push   $0x8040b3
  801baf:	e8 fb e9 ff ff       	call   8005af <_panic>

00801bb4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
  801bb7:	57                   	push   %edi
  801bb8:	56                   	push   %esi
  801bb9:	53                   	push   %ebx
  801bba:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bc6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801bc9:	8b 7d 18             	mov    0x18(%ebp),%edi
  801bcc:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801bcf:	cd 30                	int    $0x30
  801bd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801bd7:	83 c4 10             	add    $0x10,%esp
  801bda:	5b                   	pop    %ebx
  801bdb:	5e                   	pop    %esi
  801bdc:	5f                   	pop    %edi
  801bdd:	5d                   	pop    %ebp
  801bde:	c3                   	ret    

00801bdf <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 04             	sub    $0x4,%esp
  801be5:	8b 45 10             	mov    0x10(%ebp),%eax
  801be8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801beb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	52                   	push   %edx
  801bf7:	ff 75 0c             	pushl  0xc(%ebp)
  801bfa:	50                   	push   %eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	e8 b2 ff ff ff       	call   801bb4 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	90                   	nop
  801c06:	c9                   	leave  
  801c07:	c3                   	ret    

00801c08 <sys_cgetc>:

int
sys_cgetc(void)
{
  801c08:	55                   	push   %ebp
  801c09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 01                	push   $0x1
  801c17:	e8 98 ff ff ff       	call   801bb4 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	c9                   	leave  
  801c20:	c3                   	ret    

00801c21 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801c24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	52                   	push   %edx
  801c31:	50                   	push   %eax
  801c32:	6a 05                	push   $0x5
  801c34:	e8 7b ff ff ff       	call   801bb4 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	56                   	push   %esi
  801c42:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801c43:	8b 75 18             	mov    0x18(%ebp),%esi
  801c46:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801c49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	56                   	push   %esi
  801c53:	53                   	push   %ebx
  801c54:	51                   	push   %ecx
  801c55:	52                   	push   %edx
  801c56:	50                   	push   %eax
  801c57:	6a 06                	push   $0x6
  801c59:	e8 56 ff ff ff       	call   801bb4 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c64:	5b                   	pop    %ebx
  801c65:	5e                   	pop    %esi
  801c66:	5d                   	pop    %ebp
  801c67:	c3                   	ret    

00801c68 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801c6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	52                   	push   %edx
  801c78:	50                   	push   %eax
  801c79:	6a 07                	push   $0x7
  801c7b:	e8 34 ff ff ff       	call   801bb4 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	ff 75 0c             	pushl  0xc(%ebp)
  801c91:	ff 75 08             	pushl  0x8(%ebp)
  801c94:	6a 08                	push   $0x8
  801c96:	e8 19 ff ff ff       	call   801bb4 <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 09                	push   $0x9
  801caf:	e8 00 ff ff ff       	call   801bb4 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 0a                	push   $0xa
  801cc8:	e8 e7 fe ff ff       	call   801bb4 <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 0b                	push   $0xb
  801ce1:	e8 ce fe ff ff       	call   801bb4 <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	ff 75 0c             	pushl  0xc(%ebp)
  801cf7:	ff 75 08             	pushl  0x8(%ebp)
  801cfa:	6a 0f                	push   $0xf
  801cfc:	e8 b3 fe ff ff       	call   801bb4 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
	return;
  801d04:	90                   	nop
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	ff 75 0c             	pushl  0xc(%ebp)
  801d13:	ff 75 08             	pushl  0x8(%ebp)
  801d16:	6a 10                	push   $0x10
  801d18:	e8 97 fe ff ff       	call   801bb4 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	ff 75 10             	pushl  0x10(%ebp)
  801d2d:	ff 75 0c             	pushl  0xc(%ebp)
  801d30:	ff 75 08             	pushl  0x8(%ebp)
  801d33:	6a 11                	push   $0x11
  801d35:	e8 7a fe ff ff       	call   801bb4 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3d:	90                   	nop
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 0c                	push   $0xc
  801d4f:	e8 60 fe ff ff       	call   801bb4 <syscall>
  801d54:	83 c4 18             	add    $0x18,%esp
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	ff 75 08             	pushl  0x8(%ebp)
  801d67:	6a 0d                	push   $0xd
  801d69:	e8 46 fe ff ff       	call   801bb4 <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 0e                	push   $0xe
  801d82:	e8 2d fe ff ff       	call   801bb4 <syscall>
  801d87:	83 c4 18             	add    $0x18,%esp
}
  801d8a:	90                   	nop
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 13                	push   $0x13
  801d9c:	e8 13 fe ff ff       	call   801bb4 <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
}
  801da4:	90                   	nop
  801da5:	c9                   	leave  
  801da6:	c3                   	ret    

00801da7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801da7:	55                   	push   %ebp
  801da8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 14                	push   $0x14
  801db6:	e8 f9 fd ff ff       	call   801bb4 <syscall>
  801dbb:	83 c4 18             	add    $0x18,%esp
}
  801dbe:	90                   	nop
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_cputc>:


void
sys_cputc(const char c)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 04             	sub    $0x4,%esp
  801dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dca:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801dcd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	50                   	push   %eax
  801dda:	6a 15                	push   $0x15
  801ddc:	e8 d3 fd ff ff       	call   801bb4 <syscall>
  801de1:	83 c4 18             	add    $0x18,%esp
}
  801de4:	90                   	nop
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 16                	push   $0x16
  801df6:	e8 b9 fd ff ff       	call   801bb4 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
}
  801dfe:	90                   	nop
  801dff:	c9                   	leave  
  801e00:	c3                   	ret    

00801e01 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801e01:	55                   	push   %ebp
  801e02:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	ff 75 0c             	pushl  0xc(%ebp)
  801e10:	50                   	push   %eax
  801e11:	6a 17                	push   $0x17
  801e13:	e8 9c fd ff ff       	call   801bb4 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	6a 00                	push   $0x0
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	52                   	push   %edx
  801e2d:	50                   	push   %eax
  801e2e:	6a 1a                	push   $0x1a
  801e30:	e8 7f fd ff ff       	call   801bb4 <syscall>
  801e35:	83 c4 18             	add    $0x18,%esp
}
  801e38:	c9                   	leave  
  801e39:	c3                   	ret    

00801e3a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e3a:	55                   	push   %ebp
  801e3b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	52                   	push   %edx
  801e4a:	50                   	push   %eax
  801e4b:	6a 18                	push   $0x18
  801e4d:	e8 62 fd ff ff       	call   801bb4 <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	90                   	nop
  801e56:	c9                   	leave  
  801e57:	c3                   	ret    

00801e58 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801e58:	55                   	push   %ebp
  801e59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	52                   	push   %edx
  801e68:	50                   	push   %eax
  801e69:	6a 19                	push   $0x19
  801e6b:	e8 44 fd ff ff       	call   801bb4 <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
}
  801e73:	90                   	nop
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 04             	sub    $0x4,%esp
  801e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801e82:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801e85:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	6a 00                	push   $0x0
  801e8e:	51                   	push   %ecx
  801e8f:	52                   	push   %edx
  801e90:	ff 75 0c             	pushl  0xc(%ebp)
  801e93:	50                   	push   %eax
  801e94:	6a 1b                	push   $0x1b
  801e96:	e8 19 fd ff ff       	call   801bb4 <syscall>
  801e9b:	83 c4 18             	add    $0x18,%esp
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ea3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	52                   	push   %edx
  801eb0:	50                   	push   %eax
  801eb1:	6a 1c                	push   $0x1c
  801eb3:	e8 fc fc ff ff       	call   801bb4 <syscall>
  801eb8:	83 c4 18             	add    $0x18,%esp
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ec0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	51                   	push   %ecx
  801ece:	52                   	push   %edx
  801ecf:	50                   	push   %eax
  801ed0:	6a 1d                	push   $0x1d
  801ed2:	e8 dd fc ff ff       	call   801bb4 <syscall>
  801ed7:	83 c4 18             	add    $0x18,%esp
}
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801edf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	6a 1e                	push   $0x1e
  801eef:	e8 c0 fc ff ff       	call   801bb4 <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	c9                   	leave  
  801ef8:	c3                   	ret    

00801ef9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	6a 00                	push   $0x0
  801f02:	6a 00                	push   $0x0
  801f04:	6a 00                	push   $0x0
  801f06:	6a 1f                	push   $0x1f
  801f08:	e8 a7 fc ff ff       	call   801bb4 <syscall>
  801f0d:	83 c4 18             	add    $0x18,%esp
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801f15:	8b 45 08             	mov    0x8(%ebp),%eax
  801f18:	6a 00                	push   $0x0
  801f1a:	ff 75 14             	pushl  0x14(%ebp)
  801f1d:	ff 75 10             	pushl  0x10(%ebp)
  801f20:	ff 75 0c             	pushl  0xc(%ebp)
  801f23:	50                   	push   %eax
  801f24:	6a 20                	push   $0x20
  801f26:	e8 89 fc ff ff       	call   801bb4 <syscall>
  801f2b:	83 c4 18             	add    $0x18,%esp
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801f33:	8b 45 08             	mov    0x8(%ebp),%eax
  801f36:	6a 00                	push   $0x0
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	50                   	push   %eax
  801f3f:	6a 21                	push   $0x21
  801f41:	e8 6e fc ff ff       	call   801bb4 <syscall>
  801f46:	83 c4 18             	add    $0x18,%esp
}
  801f49:	90                   	nop
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	6a 00                	push   $0x0
  801f54:	6a 00                	push   $0x0
  801f56:	6a 00                	push   $0x0
  801f58:	6a 00                	push   $0x0
  801f5a:	50                   	push   %eax
  801f5b:	6a 22                	push   $0x22
  801f5d:	e8 52 fc ff ff       	call   801bb4 <syscall>
  801f62:	83 c4 18             	add    $0x18,%esp
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	6a 00                	push   $0x0
  801f74:	6a 02                	push   $0x2
  801f76:	e8 39 fc ff ff       	call   801bb4 <syscall>
  801f7b:	83 c4 18             	add    $0x18,%esp
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 03                	push   $0x3
  801f8f:	e8 20 fc ff ff       	call   801bb4 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 04                	push   $0x4
  801fa8:	e8 07 fc ff ff       	call   801bb4 <syscall>
  801fad:	83 c4 18             	add    $0x18,%esp
}
  801fb0:	c9                   	leave  
  801fb1:	c3                   	ret    

00801fb2 <sys_exit_env>:


void sys_exit_env(void)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801fb5:	6a 00                	push   $0x0
  801fb7:	6a 00                	push   $0x0
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 23                	push   $0x23
  801fc1:	e8 ee fb ff ff       	call   801bb4 <syscall>
  801fc6:	83 c4 18             	add    $0x18,%esp
}
  801fc9:	90                   	nop
  801fca:	c9                   	leave  
  801fcb:	c3                   	ret    

00801fcc <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801fd2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fd5:	8d 50 04             	lea    0x4(%eax),%edx
  801fd8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	52                   	push   %edx
  801fe2:	50                   	push   %eax
  801fe3:	6a 24                	push   $0x24
  801fe5:	e8 ca fb ff ff       	call   801bb4 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
	return result;
  801fed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ff3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ff6:	89 01                	mov    %eax,(%ecx)
  801ff8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffe:	c9                   	leave  
  801fff:	c2 04 00             	ret    $0x4

00802002 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	ff 75 10             	pushl  0x10(%ebp)
  80200c:	ff 75 0c             	pushl  0xc(%ebp)
  80200f:	ff 75 08             	pushl  0x8(%ebp)
  802012:	6a 12                	push   $0x12
  802014:	e8 9b fb ff ff       	call   801bb4 <syscall>
  802019:	83 c4 18             	add    $0x18,%esp
	return ;
  80201c:	90                   	nop
}
  80201d:	c9                   	leave  
  80201e:	c3                   	ret    

0080201f <sys_rcr2>:
uint32 sys_rcr2()
{
  80201f:	55                   	push   %ebp
  802020:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 00                	push   $0x0
  80202c:	6a 25                	push   $0x25
  80202e:	e8 81 fb ff ff       	call   801bb4 <syscall>
  802033:	83 c4 18             	add    $0x18,%esp
}
  802036:	c9                   	leave  
  802037:	c3                   	ret    

00802038 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802038:	55                   	push   %ebp
  802039:	89 e5                	mov    %esp,%ebp
  80203b:	83 ec 04             	sub    $0x4,%esp
  80203e:	8b 45 08             	mov    0x8(%ebp),%eax
  802041:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802044:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802048:	6a 00                	push   $0x0
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	50                   	push   %eax
  802051:	6a 26                	push   $0x26
  802053:	e8 5c fb ff ff       	call   801bb4 <syscall>
  802058:	83 c4 18             	add    $0x18,%esp
	return ;
  80205b:	90                   	nop
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <rsttst>:
void rsttst()
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802061:	6a 00                	push   $0x0
  802063:	6a 00                	push   $0x0
  802065:	6a 00                	push   $0x0
  802067:	6a 00                	push   $0x0
  802069:	6a 00                	push   $0x0
  80206b:	6a 28                	push   $0x28
  80206d:	e8 42 fb ff ff       	call   801bb4 <syscall>
  802072:	83 c4 18             	add    $0x18,%esp
	return ;
  802075:	90                   	nop
}
  802076:	c9                   	leave  
  802077:	c3                   	ret    

00802078 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802078:	55                   	push   %ebp
  802079:	89 e5                	mov    %esp,%ebp
  80207b:	83 ec 04             	sub    $0x4,%esp
  80207e:	8b 45 14             	mov    0x14(%ebp),%eax
  802081:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802084:	8b 55 18             	mov    0x18(%ebp),%edx
  802087:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80208b:	52                   	push   %edx
  80208c:	50                   	push   %eax
  80208d:	ff 75 10             	pushl  0x10(%ebp)
  802090:	ff 75 0c             	pushl  0xc(%ebp)
  802093:	ff 75 08             	pushl  0x8(%ebp)
  802096:	6a 27                	push   $0x27
  802098:	e8 17 fb ff ff       	call   801bb4 <syscall>
  80209d:	83 c4 18             	add    $0x18,%esp
	return ;
  8020a0:	90                   	nop
}
  8020a1:	c9                   	leave  
  8020a2:	c3                   	ret    

008020a3 <chktst>:
void chktst(uint32 n)
{
  8020a3:	55                   	push   %ebp
  8020a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8020a6:	6a 00                	push   $0x0
  8020a8:	6a 00                	push   $0x0
  8020aa:	6a 00                	push   $0x0
  8020ac:	6a 00                	push   $0x0
  8020ae:	ff 75 08             	pushl  0x8(%ebp)
  8020b1:	6a 29                	push   $0x29
  8020b3:	e8 fc fa ff ff       	call   801bb4 <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8020bb:	90                   	nop
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <inctst>:

void inctst()
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 2a                	push   $0x2a
  8020cd:	e8 e2 fa ff ff       	call   801bb4 <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8020d5:	90                   	nop
}
  8020d6:	c9                   	leave  
  8020d7:	c3                   	ret    

008020d8 <gettst>:
uint32 gettst()
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 00                	push   $0x0
  8020e5:	6a 2b                	push   $0x2b
  8020e7:	e8 c8 fa ff ff       	call   801bb4 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 00                	push   $0x0
  8020ff:	6a 00                	push   $0x0
  802101:	6a 2c                	push   $0x2c
  802103:	e8 ac fa ff ff       	call   801bb4 <syscall>
  802108:	83 c4 18             	add    $0x18,%esp
  80210b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80210e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802112:	75 07                	jne    80211b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802114:	b8 01 00 00 00       	mov    $0x1,%eax
  802119:	eb 05                	jmp    802120 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80211b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802120:	c9                   	leave  
  802121:	c3                   	ret    

00802122 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802122:	55                   	push   %ebp
  802123:	89 e5                	mov    %esp,%ebp
  802125:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 2c                	push   $0x2c
  802134:	e8 7b fa ff ff       	call   801bb4 <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
  80213c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80213f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802143:	75 07                	jne    80214c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802145:	b8 01 00 00 00       	mov    $0x1,%eax
  80214a:	eb 05                	jmp    802151 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 00                	push   $0x0
  802161:	6a 00                	push   $0x0
  802163:	6a 2c                	push   $0x2c
  802165:	e8 4a fa ff ff       	call   801bb4 <syscall>
  80216a:	83 c4 18             	add    $0x18,%esp
  80216d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802170:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802174:	75 07                	jne    80217d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802176:	b8 01 00 00 00       	mov    $0x1,%eax
  80217b:	eb 05                	jmp    802182 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80217d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 00                	push   $0x0
  802194:	6a 2c                	push   $0x2c
  802196:	e8 19 fa ff ff       	call   801bb4 <syscall>
  80219b:	83 c4 18             	add    $0x18,%esp
  80219e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8021a1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8021a5:	75 07                	jne    8021ae <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8021a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ac:	eb 05                	jmp    8021b3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8021ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b3:	c9                   	leave  
  8021b4:	c3                   	ret    

008021b5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8021b5:	55                   	push   %ebp
  8021b6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 00                	push   $0x0
  8021bc:	6a 00                	push   $0x0
  8021be:	6a 00                	push   $0x0
  8021c0:	ff 75 08             	pushl  0x8(%ebp)
  8021c3:	6a 2d                	push   $0x2d
  8021c5:	e8 ea f9 ff ff       	call   801bb4 <syscall>
  8021ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8021cd:	90                   	nop
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8021d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	6a 00                	push   $0x0
  8021e2:	53                   	push   %ebx
  8021e3:	51                   	push   %ecx
  8021e4:	52                   	push   %edx
  8021e5:	50                   	push   %eax
  8021e6:	6a 2e                	push   $0x2e
  8021e8:	e8 c7 f9 ff ff       	call   801bb4 <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8021f3:	c9                   	leave  
  8021f4:	c3                   	ret    

008021f5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8021f5:	55                   	push   %ebp
  8021f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8021f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	52                   	push   %edx
  802205:	50                   	push   %eax
  802206:	6a 2f                	push   $0x2f
  802208:	e8 a7 f9 ff ff       	call   801bb4 <syscall>
  80220d:	83 c4 18             	add    $0x18,%esp
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802218:	83 ec 0c             	sub    $0xc,%esp
  80221b:	68 40 41 80 00       	push   $0x804140
  802220:	e8 3e e6 ff ff       	call   800863 <cprintf>
  802225:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802228:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80222f:	83 ec 0c             	sub    $0xc,%esp
  802232:	68 6c 41 80 00       	push   $0x80416c
  802237:	e8 27 e6 ff ff       	call   800863 <cprintf>
  80223c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80223f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802243:	a1 38 51 80 00       	mov    0x805138,%eax
  802248:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80224b:	eb 56                	jmp    8022a3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80224d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802251:	74 1c                	je     80226f <print_mem_block_lists+0x5d>
  802253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802256:	8b 50 08             	mov    0x8(%eax),%edx
  802259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225c:	8b 48 08             	mov    0x8(%eax),%ecx
  80225f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802262:	8b 40 0c             	mov    0xc(%eax),%eax
  802265:	01 c8                	add    %ecx,%eax
  802267:	39 c2                	cmp    %eax,%edx
  802269:	73 04                	jae    80226f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80226b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 50 08             	mov    0x8(%eax),%edx
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	8b 40 0c             	mov    0xc(%eax),%eax
  80227b:	01 c2                	add    %eax,%edx
  80227d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802280:	8b 40 08             	mov    0x8(%eax),%eax
  802283:	83 ec 04             	sub    $0x4,%esp
  802286:	52                   	push   %edx
  802287:	50                   	push   %eax
  802288:	68 81 41 80 00       	push   $0x804181
  80228d:	e8 d1 e5 ff ff       	call   800863 <cprintf>
  802292:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80229b:	a1 40 51 80 00       	mov    0x805140,%eax
  8022a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a7:	74 07                	je     8022b0 <print_mem_block_lists+0x9e>
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	8b 00                	mov    (%eax),%eax
  8022ae:	eb 05                	jmp    8022b5 <print_mem_block_lists+0xa3>
  8022b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8022ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	75 8a                	jne    80224d <print_mem_block_lists+0x3b>
  8022c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c7:	75 84                	jne    80224d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8022c9:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8022cd:	75 10                	jne    8022df <print_mem_block_lists+0xcd>
  8022cf:	83 ec 0c             	sub    $0xc,%esp
  8022d2:	68 90 41 80 00       	push   $0x804190
  8022d7:	e8 87 e5 ff ff       	call   800863 <cprintf>
  8022dc:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8022df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8022e6:	83 ec 0c             	sub    $0xc,%esp
  8022e9:	68 b4 41 80 00       	push   $0x8041b4
  8022ee:	e8 70 e5 ff ff       	call   800863 <cprintf>
  8022f3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8022f6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8022fa:	a1 40 50 80 00       	mov    0x805040,%eax
  8022ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802302:	eb 56                	jmp    80235a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802304:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802308:	74 1c                	je     802326 <print_mem_block_lists+0x114>
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 50 08             	mov    0x8(%eax),%edx
  802310:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802313:	8b 48 08             	mov    0x8(%eax),%ecx
  802316:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802319:	8b 40 0c             	mov    0xc(%eax),%eax
  80231c:	01 c8                	add    %ecx,%eax
  80231e:	39 c2                	cmp    %eax,%edx
  802320:	73 04                	jae    802326 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802322:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	8b 50 08             	mov    0x8(%eax),%edx
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 40 0c             	mov    0xc(%eax),%eax
  802332:	01 c2                	add    %eax,%edx
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 40 08             	mov    0x8(%eax),%eax
  80233a:	83 ec 04             	sub    $0x4,%esp
  80233d:	52                   	push   %edx
  80233e:	50                   	push   %eax
  80233f:	68 81 41 80 00       	push   $0x804181
  802344:	e8 1a e5 ff ff       	call   800863 <cprintf>
  802349:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802352:	a1 48 50 80 00       	mov    0x805048,%eax
  802357:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80235a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235e:	74 07                	je     802367 <print_mem_block_lists+0x155>
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	8b 00                	mov    (%eax),%eax
  802365:	eb 05                	jmp    80236c <print_mem_block_lists+0x15a>
  802367:	b8 00 00 00 00       	mov    $0x0,%eax
  80236c:	a3 48 50 80 00       	mov    %eax,0x805048
  802371:	a1 48 50 80 00       	mov    0x805048,%eax
  802376:	85 c0                	test   %eax,%eax
  802378:	75 8a                	jne    802304 <print_mem_block_lists+0xf2>
  80237a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237e:	75 84                	jne    802304 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802380:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802384:	75 10                	jne    802396 <print_mem_block_lists+0x184>
  802386:	83 ec 0c             	sub    $0xc,%esp
  802389:	68 cc 41 80 00       	push   $0x8041cc
  80238e:	e8 d0 e4 ff ff       	call   800863 <cprintf>
  802393:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802396:	83 ec 0c             	sub    $0xc,%esp
  802399:	68 40 41 80 00       	push   $0x804140
  80239e:	e8 c0 e4 ff ff       	call   800863 <cprintf>
  8023a3:	83 c4 10             	add    $0x10,%esp

}
  8023a6:	90                   	nop
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8023af:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8023b6:	00 00 00 
  8023b9:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8023c0:	00 00 00 
  8023c3:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8023ca:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8023cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8023d4:	e9 9e 00 00 00       	jmp    802477 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8023d9:	a1 50 50 80 00       	mov    0x805050,%eax
  8023de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e1:	c1 e2 04             	shl    $0x4,%edx
  8023e4:	01 d0                	add    %edx,%eax
  8023e6:	85 c0                	test   %eax,%eax
  8023e8:	75 14                	jne    8023fe <initialize_MemBlocksList+0x55>
  8023ea:	83 ec 04             	sub    $0x4,%esp
  8023ed:	68 f4 41 80 00       	push   $0x8041f4
  8023f2:	6a 3d                	push   $0x3d
  8023f4:	68 17 42 80 00       	push   $0x804217
  8023f9:	e8 b1 e1 ff ff       	call   8005af <_panic>
  8023fe:	a1 50 50 80 00       	mov    0x805050,%eax
  802403:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802406:	c1 e2 04             	shl    $0x4,%edx
  802409:	01 d0                	add    %edx,%eax
  80240b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802411:	89 10                	mov    %edx,(%eax)
  802413:	8b 00                	mov    (%eax),%eax
  802415:	85 c0                	test   %eax,%eax
  802417:	74 18                	je     802431 <initialize_MemBlocksList+0x88>
  802419:	a1 48 51 80 00       	mov    0x805148,%eax
  80241e:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802424:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802427:	c1 e1 04             	shl    $0x4,%ecx
  80242a:	01 ca                	add    %ecx,%edx
  80242c:	89 50 04             	mov    %edx,0x4(%eax)
  80242f:	eb 12                	jmp    802443 <initialize_MemBlocksList+0x9a>
  802431:	a1 50 50 80 00       	mov    0x805050,%eax
  802436:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802439:	c1 e2 04             	shl    $0x4,%edx
  80243c:	01 d0                	add    %edx,%eax
  80243e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802443:	a1 50 50 80 00       	mov    0x805050,%eax
  802448:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244b:	c1 e2 04             	shl    $0x4,%edx
  80244e:	01 d0                	add    %edx,%eax
  802450:	a3 48 51 80 00       	mov    %eax,0x805148
  802455:	a1 50 50 80 00       	mov    0x805050,%eax
  80245a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245d:	c1 e2 04             	shl    $0x4,%edx
  802460:	01 d0                	add    %edx,%eax
  802462:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802469:	a1 54 51 80 00       	mov    0x805154,%eax
  80246e:	40                   	inc    %eax
  80246f:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802474:	ff 45 f4             	incl   -0xc(%ebp)
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80247d:	0f 82 56 ff ff ff    	jb     8023d9 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802483:	90                   	nop
  802484:	c9                   	leave  
  802485:	c3                   	ret    

00802486 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802486:	55                   	push   %ebp
  802487:	89 e5                	mov    %esp,%ebp
  802489:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80248c:	8b 45 08             	mov    0x8(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802494:	eb 18                	jmp    8024ae <find_block+0x28>

		if(tmp->sva == va){
  802496:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802499:	8b 40 08             	mov    0x8(%eax),%eax
  80249c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80249f:	75 05                	jne    8024a6 <find_block+0x20>
			return tmp ;
  8024a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024a4:	eb 11                	jmp    8024b7 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8024a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8024a9:	8b 00                	mov    (%eax),%eax
  8024ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8024ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8024b2:	75 e2                	jne    802496 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8024b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8024bf:	a1 40 50 80 00       	mov    0x805040,%eax
  8024c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8024c7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8024cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8024cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024d3:	75 65                	jne    80253a <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8024d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8024d9:	75 14                	jne    8024ef <insert_sorted_allocList+0x36>
  8024db:	83 ec 04             	sub    $0x4,%esp
  8024de:	68 f4 41 80 00       	push   $0x8041f4
  8024e3:	6a 62                	push   $0x62
  8024e5:	68 17 42 80 00       	push   $0x804217
  8024ea:	e8 c0 e0 ff ff       	call   8005af <_panic>
  8024ef:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8024f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f8:	89 10                	mov    %edx,(%eax)
  8024fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fd:	8b 00                	mov    (%eax),%eax
  8024ff:	85 c0                	test   %eax,%eax
  802501:	74 0d                	je     802510 <insert_sorted_allocList+0x57>
  802503:	a1 40 50 80 00       	mov    0x805040,%eax
  802508:	8b 55 08             	mov    0x8(%ebp),%edx
  80250b:	89 50 04             	mov    %edx,0x4(%eax)
  80250e:	eb 08                	jmp    802518 <insert_sorted_allocList+0x5f>
  802510:	8b 45 08             	mov    0x8(%ebp),%eax
  802513:	a3 44 50 80 00       	mov    %eax,0x805044
  802518:	8b 45 08             	mov    0x8(%ebp),%eax
  80251b:	a3 40 50 80 00       	mov    %eax,0x805040
  802520:	8b 45 08             	mov    0x8(%ebp),%eax
  802523:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80252f:	40                   	inc    %eax
  802530:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802535:	e9 14 01 00 00       	jmp    80264e <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	8b 50 08             	mov    0x8(%eax),%edx
  802540:	a1 44 50 80 00       	mov    0x805044,%eax
  802545:	8b 40 08             	mov    0x8(%eax),%eax
  802548:	39 c2                	cmp    %eax,%edx
  80254a:	76 65                	jbe    8025b1 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80254c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802550:	75 14                	jne    802566 <insert_sorted_allocList+0xad>
  802552:	83 ec 04             	sub    $0x4,%esp
  802555:	68 30 42 80 00       	push   $0x804230
  80255a:	6a 64                	push   $0x64
  80255c:	68 17 42 80 00       	push   $0x804217
  802561:	e8 49 e0 ff ff       	call   8005af <_panic>
  802566:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80256c:	8b 45 08             	mov    0x8(%ebp),%eax
  80256f:	89 50 04             	mov    %edx,0x4(%eax)
  802572:	8b 45 08             	mov    0x8(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 0c                	je     802588 <insert_sorted_allocList+0xcf>
  80257c:	a1 44 50 80 00       	mov    0x805044,%eax
  802581:	8b 55 08             	mov    0x8(%ebp),%edx
  802584:	89 10                	mov    %edx,(%eax)
  802586:	eb 08                	jmp    802590 <insert_sorted_allocList+0xd7>
  802588:	8b 45 08             	mov    0x8(%ebp),%eax
  80258b:	a3 40 50 80 00       	mov    %eax,0x805040
  802590:	8b 45 08             	mov    0x8(%ebp),%eax
  802593:	a3 44 50 80 00       	mov    %eax,0x805044
  802598:	8b 45 08             	mov    0x8(%ebp),%eax
  80259b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a1:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025a6:	40                   	inc    %eax
  8025a7:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8025ac:	e9 9d 00 00 00       	jmp    80264e <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8025b1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8025b8:	e9 85 00 00 00       	jmp    802642 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8025bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c0:	8b 50 08             	mov    0x8(%eax),%edx
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 40 08             	mov    0x8(%eax),%eax
  8025c9:	39 c2                	cmp    %eax,%edx
  8025cb:	73 6a                	jae    802637 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8025cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d1:	74 06                	je     8025d9 <insert_sorted_allocList+0x120>
  8025d3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8025d7:	75 14                	jne    8025ed <insert_sorted_allocList+0x134>
  8025d9:	83 ec 04             	sub    $0x4,%esp
  8025dc:	68 54 42 80 00       	push   $0x804254
  8025e1:	6a 6b                	push   $0x6b
  8025e3:	68 17 42 80 00       	push   $0x804217
  8025e8:	e8 c2 df ff ff       	call   8005af <_panic>
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 50 04             	mov    0x4(%eax),%edx
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	89 50 04             	mov    %edx,0x4(%eax)
  8025f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ff:	89 10                	mov    %edx,(%eax)
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	8b 40 04             	mov    0x4(%eax),%eax
  802607:	85 c0                	test   %eax,%eax
  802609:	74 0d                	je     802618 <insert_sorted_allocList+0x15f>
  80260b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260e:	8b 40 04             	mov    0x4(%eax),%eax
  802611:	8b 55 08             	mov    0x8(%ebp),%edx
  802614:	89 10                	mov    %edx,(%eax)
  802616:	eb 08                	jmp    802620 <insert_sorted_allocList+0x167>
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	a3 40 50 80 00       	mov    %eax,0x805040
  802620:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802623:	8b 55 08             	mov    0x8(%ebp),%edx
  802626:	89 50 04             	mov    %edx,0x4(%eax)
  802629:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80262e:	40                   	inc    %eax
  80262f:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802634:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802635:	eb 17                	jmp    80264e <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80263f:	ff 45 f0             	incl   -0x10(%ebp)
  802642:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802645:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802648:	0f 8c 6f ff ff ff    	jl     8025bd <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80264e:	90                   	nop
  80264f:	c9                   	leave  
  802650:	c3                   	ret    

00802651 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802651:	55                   	push   %ebp
  802652:	89 e5                	mov    %esp,%ebp
  802654:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802657:	a1 38 51 80 00       	mov    0x805138,%eax
  80265c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80265f:	e9 7c 01 00 00       	jmp    8027e0 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 40 0c             	mov    0xc(%eax),%eax
  80266a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80266d:	0f 86 cf 00 00 00    	jbe    802742 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802673:	a1 48 51 80 00       	mov    0x805148,%eax
  802678:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80267b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267e:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802684:	8b 55 08             	mov    0x8(%ebp),%edx
  802687:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	8b 50 08             	mov    0x8(%eax),%edx
  802690:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802693:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	8b 40 0c             	mov    0xc(%eax),%eax
  80269c:	2b 45 08             	sub    0x8(%ebp),%eax
  80269f:	89 c2                	mov    %eax,%edx
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 50 08             	mov    0x8(%eax),%edx
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	01 c2                	add    %eax,%edx
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8026b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026bc:	75 17                	jne    8026d5 <alloc_block_FF+0x84>
  8026be:	83 ec 04             	sub    $0x4,%esp
  8026c1:	68 89 42 80 00       	push   $0x804289
  8026c6:	68 83 00 00 00       	push   $0x83
  8026cb:	68 17 42 80 00       	push   $0x804217
  8026d0:	e8 da de ff ff       	call   8005af <_panic>
  8026d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d8:	8b 00                	mov    (%eax),%eax
  8026da:	85 c0                	test   %eax,%eax
  8026dc:	74 10                	je     8026ee <alloc_block_FF+0x9d>
  8026de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026e6:	8b 52 04             	mov    0x4(%edx),%edx
  8026e9:	89 50 04             	mov    %edx,0x4(%eax)
  8026ec:	eb 0b                	jmp    8026f9 <alloc_block_FF+0xa8>
  8026ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f1:	8b 40 04             	mov    0x4(%eax),%eax
  8026f4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8026f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026fc:	8b 40 04             	mov    0x4(%eax),%eax
  8026ff:	85 c0                	test   %eax,%eax
  802701:	74 0f                	je     802712 <alloc_block_FF+0xc1>
  802703:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802706:	8b 40 04             	mov    0x4(%eax),%eax
  802709:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80270c:	8b 12                	mov    (%edx),%edx
  80270e:	89 10                	mov    %edx,(%eax)
  802710:	eb 0a                	jmp    80271c <alloc_block_FF+0xcb>
  802712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802715:	8b 00                	mov    (%eax),%eax
  802717:	a3 48 51 80 00       	mov    %eax,0x805148
  80271c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80271f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802725:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802728:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80272f:	a1 54 51 80 00       	mov    0x805154,%eax
  802734:	48                   	dec    %eax
  802735:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  80273a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273d:	e9 ad 00 00 00       	jmp    8027ef <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 0c             	mov    0xc(%eax),%eax
  802748:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274b:	0f 85 87 00 00 00    	jne    8027d8 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802751:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802755:	75 17                	jne    80276e <alloc_block_FF+0x11d>
  802757:	83 ec 04             	sub    $0x4,%esp
  80275a:	68 89 42 80 00       	push   $0x804289
  80275f:	68 87 00 00 00       	push   $0x87
  802764:	68 17 42 80 00       	push   $0x804217
  802769:	e8 41 de ff ff       	call   8005af <_panic>
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 00                	mov    (%eax),%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	74 10                	je     802787 <alloc_block_FF+0x136>
  802777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277a:	8b 00                	mov    (%eax),%eax
  80277c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80277f:	8b 52 04             	mov    0x4(%edx),%edx
  802782:	89 50 04             	mov    %edx,0x4(%eax)
  802785:	eb 0b                	jmp    802792 <alloc_block_FF+0x141>
  802787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278a:	8b 40 04             	mov    0x4(%eax),%eax
  80278d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	8b 40 04             	mov    0x4(%eax),%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	74 0f                	je     8027ab <alloc_block_FF+0x15a>
  80279c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279f:	8b 40 04             	mov    0x4(%eax),%eax
  8027a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027a5:	8b 12                	mov    (%edx),%edx
  8027a7:	89 10                	mov    %edx,(%eax)
  8027a9:	eb 0a                	jmp    8027b5 <alloc_block_FF+0x164>
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	a3 38 51 80 00       	mov    %eax,0x805138
  8027b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c8:	a1 44 51 80 00       	mov    0x805144,%eax
  8027cd:	48                   	dec    %eax
  8027ce:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	eb 17                	jmp    8027ef <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8027e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027e4:	0f 85 7a fe ff ff    	jne    802664 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8027ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
  8027f4:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8027f7:	a1 38 51 80 00       	mov    0x805138,%eax
  8027fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8027ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802806:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80280d:	a1 38 51 80 00       	mov    0x805138,%eax
  802812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802815:	e9 d0 00 00 00       	jmp    8028ea <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 0c             	mov    0xc(%eax),%eax
  802820:	3b 45 08             	cmp    0x8(%ebp),%eax
  802823:	0f 82 b8 00 00 00    	jb     8028e1 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	8b 40 0c             	mov    0xc(%eax),%eax
  80282f:	2b 45 08             	sub    0x8(%ebp),%eax
  802832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802835:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802838:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80283b:	0f 83 a1 00 00 00    	jae    8028e2 <alloc_block_BF+0xf1>
				differsize = differance ;
  802841:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802844:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80284d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802851:	0f 85 8b 00 00 00    	jne    8028e2 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802857:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80285b:	75 17                	jne    802874 <alloc_block_BF+0x83>
  80285d:	83 ec 04             	sub    $0x4,%esp
  802860:	68 89 42 80 00       	push   $0x804289
  802865:	68 a0 00 00 00       	push   $0xa0
  80286a:	68 17 42 80 00       	push   $0x804217
  80286f:	e8 3b dd ff ff       	call   8005af <_panic>
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 00                	mov    (%eax),%eax
  802879:	85 c0                	test   %eax,%eax
  80287b:	74 10                	je     80288d <alloc_block_BF+0x9c>
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 00                	mov    (%eax),%eax
  802882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802885:	8b 52 04             	mov    0x4(%edx),%edx
  802888:	89 50 04             	mov    %edx,0x4(%eax)
  80288b:	eb 0b                	jmp    802898 <alloc_block_BF+0xa7>
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	8b 40 04             	mov    0x4(%eax),%eax
  802893:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	8b 40 04             	mov    0x4(%eax),%eax
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	74 0f                	je     8028b1 <alloc_block_BF+0xc0>
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 40 04             	mov    0x4(%eax),%eax
  8028a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ab:	8b 12                	mov    (%edx),%edx
  8028ad:	89 10                	mov    %edx,(%eax)
  8028af:	eb 0a                	jmp    8028bb <alloc_block_BF+0xca>
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 00                	mov    (%eax),%eax
  8028b6:	a3 38 51 80 00       	mov    %eax,0x805138
  8028bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ce:	a1 44 51 80 00       	mov    0x805144,%eax
  8028d3:	48                   	dec    %eax
  8028d4:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	e9 0c 01 00 00       	jmp    8029ed <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8028e1:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8028e2:	a1 40 51 80 00       	mov    0x805140,%eax
  8028e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ee:	74 07                	je     8028f7 <alloc_block_BF+0x106>
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	eb 05                	jmp    8028fc <alloc_block_BF+0x10b>
  8028f7:	b8 00 00 00 00       	mov    $0x0,%eax
  8028fc:	a3 40 51 80 00       	mov    %eax,0x805140
  802901:	a1 40 51 80 00       	mov    0x805140,%eax
  802906:	85 c0                	test   %eax,%eax
  802908:	0f 85 0c ff ff ff    	jne    80281a <alloc_block_BF+0x29>
  80290e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802912:	0f 85 02 ff ff ff    	jne    80281a <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802918:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80291c:	0f 84 c6 00 00 00    	je     8029e8 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802922:	a1 48 51 80 00       	mov    0x805148,%eax
  802927:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80292a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80292d:	8b 55 08             	mov    0x8(%ebp),%edx
  802930:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802936:	8b 50 08             	mov    0x8(%eax),%edx
  802939:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80293c:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80293f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802942:	8b 40 0c             	mov    0xc(%eax),%eax
  802945:	2b 45 08             	sub    0x8(%ebp),%eax
  802948:	89 c2                	mov    %eax,%edx
  80294a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294d:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802950:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802953:	8b 50 08             	mov    0x8(%eax),%edx
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	01 c2                	add    %eax,%edx
  80295b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295e:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802961:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802965:	75 17                	jne    80297e <alloc_block_BF+0x18d>
  802967:	83 ec 04             	sub    $0x4,%esp
  80296a:	68 89 42 80 00       	push   $0x804289
  80296f:	68 af 00 00 00       	push   $0xaf
  802974:	68 17 42 80 00       	push   $0x804217
  802979:	e8 31 dc ff ff       	call   8005af <_panic>
  80297e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802981:	8b 00                	mov    (%eax),%eax
  802983:	85 c0                	test   %eax,%eax
  802985:	74 10                	je     802997 <alloc_block_BF+0x1a6>
  802987:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80298a:	8b 00                	mov    (%eax),%eax
  80298c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80298f:	8b 52 04             	mov    0x4(%edx),%edx
  802992:	89 50 04             	mov    %edx,0x4(%eax)
  802995:	eb 0b                	jmp    8029a2 <alloc_block_BF+0x1b1>
  802997:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80299a:	8b 40 04             	mov    0x4(%eax),%eax
  80299d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8029a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029a5:	8b 40 04             	mov    0x4(%eax),%eax
  8029a8:	85 c0                	test   %eax,%eax
  8029aa:	74 0f                	je     8029bb <alloc_block_BF+0x1ca>
  8029ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8029b5:	8b 12                	mov    (%edx),%edx
  8029b7:	89 10                	mov    %edx,(%eax)
  8029b9:	eb 0a                	jmp    8029c5 <alloc_block_BF+0x1d4>
  8029bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029be:	8b 00                	mov    (%eax),%eax
  8029c0:	a3 48 51 80 00       	mov    %eax,0x805148
  8029c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8029dd:	48                   	dec    %eax
  8029de:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  8029e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8029e6:	eb 05                	jmp    8029ed <alloc_block_BF+0x1fc>
	}

	return NULL;
  8029e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ed:	c9                   	leave  
  8029ee:	c3                   	ret    

008029ef <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8029ef:	55                   	push   %ebp
  8029f0:	89 e5                	mov    %esp,%ebp
  8029f2:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8029f5:	a1 38 51 80 00       	mov    0x805138,%eax
  8029fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8029fd:	e9 7c 01 00 00       	jmp    802b7e <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	8b 40 0c             	mov    0xc(%eax),%eax
  802a08:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a0b:	0f 86 cf 00 00 00    	jbe    802ae0 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802a11:	a1 48 51 80 00       	mov    0x805148,%eax
  802a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802a1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a22:	8b 55 08             	mov    0x8(%ebp),%edx
  802a25:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 50 08             	mov    0x8(%eax),%edx
  802a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a31:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a37:	8b 40 0c             	mov    0xc(%eax),%eax
  802a3a:	2b 45 08             	sub    0x8(%ebp),%eax
  802a3d:	89 c2                	mov    %eax,%edx
  802a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a42:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a48:	8b 50 08             	mov    0x8(%eax),%edx
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	01 c2                	add    %eax,%edx
  802a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a53:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802a56:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a5a:	75 17                	jne    802a73 <alloc_block_NF+0x84>
  802a5c:	83 ec 04             	sub    $0x4,%esp
  802a5f:	68 89 42 80 00       	push   $0x804289
  802a64:	68 c4 00 00 00       	push   $0xc4
  802a69:	68 17 42 80 00       	push   $0x804217
  802a6e:	e8 3c db ff ff       	call   8005af <_panic>
  802a73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a76:	8b 00                	mov    (%eax),%eax
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	74 10                	je     802a8c <alloc_block_NF+0x9d>
  802a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a84:	8b 52 04             	mov    0x4(%edx),%edx
  802a87:	89 50 04             	mov    %edx,0x4(%eax)
  802a8a:	eb 0b                	jmp    802a97 <alloc_block_NF+0xa8>
  802a8c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a8f:	8b 40 04             	mov    0x4(%eax),%eax
  802a92:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9a:	8b 40 04             	mov    0x4(%eax),%eax
  802a9d:	85 c0                	test   %eax,%eax
  802a9f:	74 0f                	je     802ab0 <alloc_block_NF+0xc1>
  802aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa4:	8b 40 04             	mov    0x4(%eax),%eax
  802aa7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802aaa:	8b 12                	mov    (%edx),%edx
  802aac:	89 10                	mov    %edx,(%eax)
  802aae:	eb 0a                	jmp    802aba <alloc_block_NF+0xcb>
  802ab0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	a3 48 51 80 00       	mov    %eax,0x805148
  802aba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802acd:	a1 54 51 80 00       	mov    0x805154,%eax
  802ad2:	48                   	dec    %eax
  802ad3:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adb:	e9 ad 00 00 00       	jmp    802b8d <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae6:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ae9:	0f 85 87 00 00 00    	jne    802b76 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802aef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af3:	75 17                	jne    802b0c <alloc_block_NF+0x11d>
  802af5:	83 ec 04             	sub    $0x4,%esp
  802af8:	68 89 42 80 00       	push   $0x804289
  802afd:	68 c8 00 00 00       	push   $0xc8
  802b02:	68 17 42 80 00       	push   $0x804217
  802b07:	e8 a3 da ff ff       	call   8005af <_panic>
  802b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0f:	8b 00                	mov    (%eax),%eax
  802b11:	85 c0                	test   %eax,%eax
  802b13:	74 10                	je     802b25 <alloc_block_NF+0x136>
  802b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b18:	8b 00                	mov    (%eax),%eax
  802b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b1d:	8b 52 04             	mov    0x4(%edx),%edx
  802b20:	89 50 04             	mov    %edx,0x4(%eax)
  802b23:	eb 0b                	jmp    802b30 <alloc_block_NF+0x141>
  802b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b28:	8b 40 04             	mov    0x4(%eax),%eax
  802b2b:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b33:	8b 40 04             	mov    0x4(%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 0f                	je     802b49 <alloc_block_NF+0x15a>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 40 04             	mov    0x4(%eax),%eax
  802b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b43:	8b 12                	mov    (%edx),%edx
  802b45:	89 10                	mov    %edx,(%eax)
  802b47:	eb 0a                	jmp    802b53 <alloc_block_NF+0x164>
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	a3 38 51 80 00       	mov    %eax,0x805138
  802b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b56:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b66:	a1 44 51 80 00       	mov    0x805144,%eax
  802b6b:	48                   	dec    %eax
  802b6c:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	eb 17                	jmp    802b8d <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 00                	mov    (%eax),%eax
  802b7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b82:	0f 85 7a fe ff ff    	jne    802a02 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802b88:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802b8d:	c9                   	leave  
  802b8e:	c3                   	ret    

00802b8f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802b8f:	55                   	push   %ebp
  802b90:	89 e5                	mov    %esp,%ebp
  802b92:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802b95:	a1 38 51 80 00       	mov    0x805138,%eax
  802b9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802b9d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ba2:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802ba5:	a1 44 51 80 00       	mov    0x805144,%eax
  802baa:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802bad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bb1:	75 68                	jne    802c1b <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802bb3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bb7:	75 17                	jne    802bd0 <insert_sorted_with_merge_freeList+0x41>
  802bb9:	83 ec 04             	sub    $0x4,%esp
  802bbc:	68 f4 41 80 00       	push   $0x8041f4
  802bc1:	68 da 00 00 00       	push   $0xda
  802bc6:	68 17 42 80 00       	push   $0x804217
  802bcb:	e8 df d9 ff ff       	call   8005af <_panic>
  802bd0:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	89 10                	mov    %edx,(%eax)
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	8b 00                	mov    (%eax),%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	74 0d                	je     802bf1 <insert_sorted_with_merge_freeList+0x62>
  802be4:	a1 38 51 80 00       	mov    0x805138,%eax
  802be9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bec:	89 50 04             	mov    %edx,0x4(%eax)
  802bef:	eb 08                	jmp    802bf9 <insert_sorted_with_merge_freeList+0x6a>
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	a3 38 51 80 00       	mov    %eax,0x805138
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c0b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c10:	40                   	inc    %eax
  802c11:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802c16:	e9 49 07 00 00       	jmp    803364 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c1e:	8b 50 08             	mov    0x8(%eax),%edx
  802c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c24:	8b 40 0c             	mov    0xc(%eax),%eax
  802c27:	01 c2                	add    %eax,%edx
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	8b 40 08             	mov    0x8(%eax),%eax
  802c2f:	39 c2                	cmp    %eax,%edx
  802c31:	73 77                	jae    802caa <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c36:	8b 00                	mov    (%eax),%eax
  802c38:	85 c0                	test   %eax,%eax
  802c3a:	75 6e                	jne    802caa <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802c3c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c40:	74 68                	je     802caa <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802c42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c46:	75 17                	jne    802c5f <insert_sorted_with_merge_freeList+0xd0>
  802c48:	83 ec 04             	sub    $0x4,%esp
  802c4b:	68 30 42 80 00       	push   $0x804230
  802c50:	68 e0 00 00 00       	push   $0xe0
  802c55:	68 17 42 80 00       	push   $0x804217
  802c5a:	e8 50 d9 ff ff       	call   8005af <_panic>
  802c5f:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	89 50 04             	mov    %edx,0x4(%eax)
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 40 04             	mov    0x4(%eax),%eax
  802c71:	85 c0                	test   %eax,%eax
  802c73:	74 0c                	je     802c81 <insert_sorted_with_merge_freeList+0xf2>
  802c75:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802c7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7d:	89 10                	mov    %edx,(%eax)
  802c7f:	eb 08                	jmp    802c89 <insert_sorted_with_merge_freeList+0xfa>
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	a3 38 51 80 00       	mov    %eax,0x805138
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c91:	8b 45 08             	mov    0x8(%ebp),%eax
  802c94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c9a:	a1 44 51 80 00       	mov    0x805144,%eax
  802c9f:	40                   	inc    %eax
  802ca0:	a3 44 51 80 00       	mov    %eax,0x805144
  802ca5:	e9 ba 06 00 00       	jmp    803364 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802caa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cad:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb3:	8b 40 08             	mov    0x8(%eax),%eax
  802cb6:	01 c2                	add    %eax,%edx
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 08             	mov    0x8(%eax),%eax
  802cbe:	39 c2                	cmp    %eax,%edx
  802cc0:	73 78                	jae    802d3a <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	8b 40 04             	mov    0x4(%eax),%eax
  802cc8:	85 c0                	test   %eax,%eax
  802cca:	75 6e                	jne    802d3a <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802ccc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cd0:	74 68                	je     802d3a <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802cd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd6:	75 17                	jne    802cef <insert_sorted_with_merge_freeList+0x160>
  802cd8:	83 ec 04             	sub    $0x4,%esp
  802cdb:	68 f4 41 80 00       	push   $0x8041f4
  802ce0:	68 e6 00 00 00       	push   $0xe6
  802ce5:	68 17 42 80 00       	push   $0x804217
  802cea:	e8 c0 d8 ff ff       	call   8005af <_panic>
  802cef:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	89 10                	mov    %edx,(%eax)
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 0d                	je     802d10 <insert_sorted_with_merge_freeList+0x181>
  802d03:	a1 38 51 80 00       	mov    0x805138,%eax
  802d08:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0b:	89 50 04             	mov    %edx,0x4(%eax)
  802d0e:	eb 08                	jmp    802d18 <insert_sorted_with_merge_freeList+0x189>
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2a:	a1 44 51 80 00       	mov    0x805144,%eax
  802d2f:	40                   	inc    %eax
  802d30:	a3 44 51 80 00       	mov    %eax,0x805144
  802d35:	e9 2a 06 00 00       	jmp    803364 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802d3a:	a1 38 51 80 00       	mov    0x805138,%eax
  802d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d42:	e9 ed 05 00 00       	jmp    803334 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 00                	mov    (%eax),%eax
  802d4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802d4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802d53:	0f 84 a7 00 00 00    	je     802e00 <insert_sorted_with_merge_freeList+0x271>
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 40 08             	mov    0x8(%eax),%eax
  802d65:	01 c2                	add    %eax,%edx
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	8b 40 08             	mov    0x8(%eax),%eax
  802d6d:	39 c2                	cmp    %eax,%edx
  802d6f:	0f 83 8b 00 00 00    	jae    802e00 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 50 0c             	mov    0xc(%eax),%edx
  802d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7e:	8b 40 08             	mov    0x8(%eax),%eax
  802d81:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802d83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d86:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802d89:	39 c2                	cmp    %eax,%edx
  802d8b:	73 73                	jae    802e00 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d91:	74 06                	je     802d99 <insert_sorted_with_merge_freeList+0x20a>
  802d93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d97:	75 17                	jne    802db0 <insert_sorted_with_merge_freeList+0x221>
  802d99:	83 ec 04             	sub    $0x4,%esp
  802d9c:	68 a8 42 80 00       	push   $0x8042a8
  802da1:	68 f0 00 00 00       	push   $0xf0
  802da6:	68 17 42 80 00       	push   $0x804217
  802dab:	e8 ff d7 ff ff       	call   8005af <_panic>
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 10                	mov    (%eax),%edx
  802db5:	8b 45 08             	mov    0x8(%ebp),%eax
  802db8:	89 10                	mov    %edx,(%eax)
  802dba:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbd:	8b 00                	mov    (%eax),%eax
  802dbf:	85 c0                	test   %eax,%eax
  802dc1:	74 0b                	je     802dce <insert_sorted_with_merge_freeList+0x23f>
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 00                	mov    (%eax),%eax
  802dc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcb:	89 50 04             	mov    %edx,0x4(%eax)
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd4:	89 10                	mov    %edx,(%eax)
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ddc:	89 50 04             	mov    %edx,0x4(%eax)
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 00                	mov    (%eax),%eax
  802de4:	85 c0                	test   %eax,%eax
  802de6:	75 08                	jne    802df0 <insert_sorted_with_merge_freeList+0x261>
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802df0:	a1 44 51 80 00       	mov    0x805144,%eax
  802df5:	40                   	inc    %eax
  802df6:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  802dfb:	e9 64 05 00 00       	jmp    803364 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802e00:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e05:	8b 50 0c             	mov    0xc(%eax),%edx
  802e08:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e0d:	8b 40 08             	mov    0x8(%eax),%eax
  802e10:	01 c2                	add    %eax,%edx
  802e12:	8b 45 08             	mov    0x8(%ebp),%eax
  802e15:	8b 40 08             	mov    0x8(%eax),%eax
  802e18:	39 c2                	cmp    %eax,%edx
  802e1a:	0f 85 b1 00 00 00    	jne    802ed1 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802e20:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	0f 84 a4 00 00 00    	je     802ed1 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802e2d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e32:	8b 00                	mov    (%eax),%eax
  802e34:	85 c0                	test   %eax,%eax
  802e36:	0f 85 95 00 00 00    	jne    802ed1 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802e3c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e41:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e47:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802e4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e4d:	8b 52 0c             	mov    0xc(%edx),%edx
  802e50:	01 ca                	add    %ecx,%edx
  802e52:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802e55:	8b 45 08             	mov    0x8(%ebp),%eax
  802e58:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6d:	75 17                	jne    802e86 <insert_sorted_with_merge_freeList+0x2f7>
  802e6f:	83 ec 04             	sub    $0x4,%esp
  802e72:	68 f4 41 80 00       	push   $0x8041f4
  802e77:	68 ff 00 00 00       	push   $0xff
  802e7c:	68 17 42 80 00       	push   $0x804217
  802e81:	e8 29 d7 ff ff       	call   8005af <_panic>
  802e86:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8f:	89 10                	mov    %edx,(%eax)
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	8b 00                	mov    (%eax),%eax
  802e96:	85 c0                	test   %eax,%eax
  802e98:	74 0d                	je     802ea7 <insert_sorted_with_merge_freeList+0x318>
  802e9a:	a1 48 51 80 00       	mov    0x805148,%eax
  802e9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea2:	89 50 04             	mov    %edx,0x4(%eax)
  802ea5:	eb 08                	jmp    802eaf <insert_sorted_with_merge_freeList+0x320>
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	a3 48 51 80 00       	mov    %eax,0x805148
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec1:	a1 54 51 80 00       	mov    0x805154,%eax
  802ec6:	40                   	inc    %eax
  802ec7:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  802ecc:	e9 93 04 00 00       	jmp    803364 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	8b 50 08             	mov    0x8(%eax),%edx
  802ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eda:	8b 40 0c             	mov    0xc(%eax),%eax
  802edd:	01 c2                	add    %eax,%edx
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	8b 40 08             	mov    0x8(%eax),%eax
  802ee5:	39 c2                	cmp    %eax,%edx
  802ee7:	0f 85 ae 00 00 00    	jne    802f9b <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	8b 40 08             	mov    0x8(%eax),%eax
  802ef9:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	8b 00                	mov    (%eax),%eax
  802f00:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802f03:	39 c2                	cmp    %eax,%edx
  802f05:	0f 84 90 00 00 00    	je     802f9b <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	8b 40 0c             	mov    0xc(%eax),%eax
  802f17:	01 c2                	add    %eax,%edx
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f33:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f37:	75 17                	jne    802f50 <insert_sorted_with_merge_freeList+0x3c1>
  802f39:	83 ec 04             	sub    $0x4,%esp
  802f3c:	68 f4 41 80 00       	push   $0x8041f4
  802f41:	68 0b 01 00 00       	push   $0x10b
  802f46:	68 17 42 80 00       	push   $0x804217
  802f4b:	e8 5f d6 ff ff       	call   8005af <_panic>
  802f50:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	89 10                	mov    %edx,(%eax)
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	8b 00                	mov    (%eax),%eax
  802f60:	85 c0                	test   %eax,%eax
  802f62:	74 0d                	je     802f71 <insert_sorted_with_merge_freeList+0x3e2>
  802f64:	a1 48 51 80 00       	mov    0x805148,%eax
  802f69:	8b 55 08             	mov    0x8(%ebp),%edx
  802f6c:	89 50 04             	mov    %edx,0x4(%eax)
  802f6f:	eb 08                	jmp    802f79 <insert_sorted_with_merge_freeList+0x3ea>
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f79:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7c:	a3 48 51 80 00       	mov    %eax,0x805148
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8b:	a1 54 51 80 00       	mov    0x805154,%eax
  802f90:	40                   	inc    %eax
  802f91:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  802f96:	e9 c9 03 00 00       	jmp    803364 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	8b 50 0c             	mov    0xc(%eax),%edx
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	8b 40 08             	mov    0x8(%eax),%eax
  802fa7:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802faf:	39 c2                	cmp    %eax,%edx
  802fb1:	0f 85 bb 00 00 00    	jne    803072 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802fb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fbb:	0f 84 b1 00 00 00    	je     803072 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc4:	8b 40 04             	mov    0x4(%eax),%eax
  802fc7:	85 c0                	test   %eax,%eax
  802fc9:	0f 85 a3 00 00 00    	jne    803072 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802fcf:	a1 38 51 80 00       	mov    0x805138,%eax
  802fd4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd7:	8b 52 08             	mov    0x8(%edx),%edx
  802fda:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802fdd:	a1 38 51 80 00       	mov    0x805138,%eax
  802fe2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802fe8:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802feb:	8b 55 08             	mov    0x8(%ebp),%edx
  802fee:	8b 52 0c             	mov    0xc(%edx),%edx
  802ff1:	01 ca                	add    %ecx,%edx
  802ff3:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80300a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300e:	75 17                	jne    803027 <insert_sorted_with_merge_freeList+0x498>
  803010:	83 ec 04             	sub    $0x4,%esp
  803013:	68 f4 41 80 00       	push   $0x8041f4
  803018:	68 17 01 00 00       	push   $0x117
  80301d:	68 17 42 80 00       	push   $0x804217
  803022:	e8 88 d5 ff ff       	call   8005af <_panic>
  803027:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	89 10                	mov    %edx,(%eax)
  803032:	8b 45 08             	mov    0x8(%ebp),%eax
  803035:	8b 00                	mov    (%eax),%eax
  803037:	85 c0                	test   %eax,%eax
  803039:	74 0d                	je     803048 <insert_sorted_with_merge_freeList+0x4b9>
  80303b:	a1 48 51 80 00       	mov    0x805148,%eax
  803040:	8b 55 08             	mov    0x8(%ebp),%edx
  803043:	89 50 04             	mov    %edx,0x4(%eax)
  803046:	eb 08                	jmp    803050 <insert_sorted_with_merge_freeList+0x4c1>
  803048:	8b 45 08             	mov    0x8(%ebp),%eax
  80304b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803050:	8b 45 08             	mov    0x8(%ebp),%eax
  803053:	a3 48 51 80 00       	mov    %eax,0x805148
  803058:	8b 45 08             	mov    0x8(%ebp),%eax
  80305b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803062:	a1 54 51 80 00       	mov    0x805154,%eax
  803067:	40                   	inc    %eax
  803068:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80306d:	e9 f2 02 00 00       	jmp    803364 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	8b 50 08             	mov    0x8(%eax),%edx
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	8b 40 0c             	mov    0xc(%eax),%eax
  80307e:	01 c2                	add    %eax,%edx
  803080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803083:	8b 40 08             	mov    0x8(%eax),%eax
  803086:	39 c2                	cmp    %eax,%edx
  803088:	0f 85 be 00 00 00    	jne    80314c <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  80308e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803091:	8b 40 04             	mov    0x4(%eax),%eax
  803094:	8b 50 08             	mov    0x8(%eax),%edx
  803097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80309a:	8b 40 04             	mov    0x4(%eax),%eax
  80309d:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a0:	01 c2                	add    %eax,%edx
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 40 08             	mov    0x8(%eax),%eax
  8030a8:	39 c2                	cmp    %eax,%edx
  8030aa:	0f 84 9c 00 00 00    	je     80314c <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8030b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b3:	8b 50 08             	mov    0x8(%eax),%edx
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8030bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bf:	8b 50 0c             	mov    0xc(%eax),%edx
  8030c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c8:	01 c2                	add    %eax,%edx
  8030ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030cd:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8030d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8030da:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8030e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030e8:	75 17                	jne    803101 <insert_sorted_with_merge_freeList+0x572>
  8030ea:	83 ec 04             	sub    $0x4,%esp
  8030ed:	68 f4 41 80 00       	push   $0x8041f4
  8030f2:	68 26 01 00 00       	push   $0x126
  8030f7:	68 17 42 80 00       	push   $0x804217
  8030fc:	e8 ae d4 ff ff       	call   8005af <_panic>
  803101:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803107:	8b 45 08             	mov    0x8(%ebp),%eax
  80310a:	89 10                	mov    %edx,(%eax)
  80310c:	8b 45 08             	mov    0x8(%ebp),%eax
  80310f:	8b 00                	mov    (%eax),%eax
  803111:	85 c0                	test   %eax,%eax
  803113:	74 0d                	je     803122 <insert_sorted_with_merge_freeList+0x593>
  803115:	a1 48 51 80 00       	mov    0x805148,%eax
  80311a:	8b 55 08             	mov    0x8(%ebp),%edx
  80311d:	89 50 04             	mov    %edx,0x4(%eax)
  803120:	eb 08                	jmp    80312a <insert_sorted_with_merge_freeList+0x59b>
  803122:	8b 45 08             	mov    0x8(%ebp),%eax
  803125:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80312a:	8b 45 08             	mov    0x8(%ebp),%eax
  80312d:	a3 48 51 80 00       	mov    %eax,0x805148
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80313c:	a1 54 51 80 00       	mov    0x805154,%eax
  803141:	40                   	inc    %eax
  803142:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803147:	e9 18 02 00 00       	jmp    803364 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	8b 50 0c             	mov    0xc(%eax),%edx
  803152:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803155:	8b 40 08             	mov    0x8(%eax),%eax
  803158:	01 c2                	add    %eax,%edx
  80315a:	8b 45 08             	mov    0x8(%ebp),%eax
  80315d:	8b 40 08             	mov    0x8(%eax),%eax
  803160:	39 c2                	cmp    %eax,%edx
  803162:	0f 85 c4 01 00 00    	jne    80332c <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803168:	8b 45 08             	mov    0x8(%ebp),%eax
  80316b:	8b 50 0c             	mov    0xc(%eax),%edx
  80316e:	8b 45 08             	mov    0x8(%ebp),%eax
  803171:	8b 40 08             	mov    0x8(%eax),%eax
  803174:	01 c2                	add    %eax,%edx
  803176:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803179:	8b 00                	mov    (%eax),%eax
  80317b:	8b 40 08             	mov    0x8(%eax),%eax
  80317e:	39 c2                	cmp    %eax,%edx
  803180:	0f 85 a6 01 00 00    	jne    80332c <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803186:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80318a:	0f 84 9c 01 00 00    	je     80332c <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803193:	8b 50 0c             	mov    0xc(%eax),%edx
  803196:	8b 45 08             	mov    0x8(%ebp),%eax
  803199:	8b 40 0c             	mov    0xc(%eax),%eax
  80319c:	01 c2                	add    %eax,%edx
  80319e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a1:	8b 00                	mov    (%eax),%eax
  8031a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8031a6:	01 c2                	add    %eax,%edx
  8031a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ab:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8031ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8031c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031c6:	75 17                	jne    8031df <insert_sorted_with_merge_freeList+0x650>
  8031c8:	83 ec 04             	sub    $0x4,%esp
  8031cb:	68 f4 41 80 00       	push   $0x8041f4
  8031d0:	68 32 01 00 00       	push   $0x132
  8031d5:	68 17 42 80 00       	push   $0x804217
  8031da:	e8 d0 d3 ff ff       	call   8005af <_panic>
  8031df:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8031e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e8:	89 10                	mov    %edx,(%eax)
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	8b 00                	mov    (%eax),%eax
  8031ef:	85 c0                	test   %eax,%eax
  8031f1:	74 0d                	je     803200 <insert_sorted_with_merge_freeList+0x671>
  8031f3:	a1 48 51 80 00       	mov    0x805148,%eax
  8031f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8031fb:	89 50 04             	mov    %edx,0x4(%eax)
  8031fe:	eb 08                	jmp    803208 <insert_sorted_with_merge_freeList+0x679>
  803200:	8b 45 08             	mov    0x8(%ebp),%eax
  803203:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803208:	8b 45 08             	mov    0x8(%ebp),%eax
  80320b:	a3 48 51 80 00       	mov    %eax,0x805148
  803210:	8b 45 08             	mov    0x8(%ebp),%eax
  803213:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321a:	a1 54 51 80 00       	mov    0x805154,%eax
  80321f:	40                   	inc    %eax
  803220:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	8b 00                	mov    (%eax),%eax
  80322a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803234:	8b 00                	mov    (%eax),%eax
  803236:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80323d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803240:	8b 00                	mov    (%eax),%eax
  803242:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803245:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803249:	75 17                	jne    803262 <insert_sorted_with_merge_freeList+0x6d3>
  80324b:	83 ec 04             	sub    $0x4,%esp
  80324e:	68 89 42 80 00       	push   $0x804289
  803253:	68 36 01 00 00       	push   $0x136
  803258:	68 17 42 80 00       	push   $0x804217
  80325d:	e8 4d d3 ff ff       	call   8005af <_panic>
  803262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803265:	8b 00                	mov    (%eax),%eax
  803267:	85 c0                	test   %eax,%eax
  803269:	74 10                	je     80327b <insert_sorted_with_merge_freeList+0x6ec>
  80326b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80326e:	8b 00                	mov    (%eax),%eax
  803270:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803273:	8b 52 04             	mov    0x4(%edx),%edx
  803276:	89 50 04             	mov    %edx,0x4(%eax)
  803279:	eb 0b                	jmp    803286 <insert_sorted_with_merge_freeList+0x6f7>
  80327b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80327e:	8b 40 04             	mov    0x4(%eax),%eax
  803281:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803286:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803289:	8b 40 04             	mov    0x4(%eax),%eax
  80328c:	85 c0                	test   %eax,%eax
  80328e:	74 0f                	je     80329f <insert_sorted_with_merge_freeList+0x710>
  803290:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803293:	8b 40 04             	mov    0x4(%eax),%eax
  803296:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803299:	8b 12                	mov    (%edx),%edx
  80329b:	89 10                	mov    %edx,(%eax)
  80329d:	eb 0a                	jmp    8032a9 <insert_sorted_with_merge_freeList+0x71a>
  80329f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032a2:	8b 00                	mov    (%eax),%eax
  8032a4:	a3 38 51 80 00       	mov    %eax,0x805138
  8032a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8032b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032bc:	a1 44 51 80 00       	mov    0x805144,%eax
  8032c1:	48                   	dec    %eax
  8032c2:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8032c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8032cb:	75 17                	jne    8032e4 <insert_sorted_with_merge_freeList+0x755>
  8032cd:	83 ec 04             	sub    $0x4,%esp
  8032d0:	68 f4 41 80 00       	push   $0x8041f4
  8032d5:	68 37 01 00 00       	push   $0x137
  8032da:	68 17 42 80 00       	push   $0x804217
  8032df:	e8 cb d2 ff ff       	call   8005af <_panic>
  8032e4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032ed:	89 10                	mov    %edx,(%eax)
  8032ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8032f2:	8b 00                	mov    (%eax),%eax
  8032f4:	85 c0                	test   %eax,%eax
  8032f6:	74 0d                	je     803305 <insert_sorted_with_merge_freeList+0x776>
  8032f8:	a1 48 51 80 00       	mov    0x805148,%eax
  8032fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803300:	89 50 04             	mov    %edx,0x4(%eax)
  803303:	eb 08                	jmp    80330d <insert_sorted_with_merge_freeList+0x77e>
  803305:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803308:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80330d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803310:	a3 48 51 80 00       	mov    %eax,0x805148
  803315:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803318:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80331f:	a1 54 51 80 00       	mov    0x805154,%eax
  803324:	40                   	inc    %eax
  803325:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  80332a:	eb 38                	jmp    803364 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80332c:	a1 40 51 80 00       	mov    0x805140,%eax
  803331:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803338:	74 07                	je     803341 <insert_sorted_with_merge_freeList+0x7b2>
  80333a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333d:	8b 00                	mov    (%eax),%eax
  80333f:	eb 05                	jmp    803346 <insert_sorted_with_merge_freeList+0x7b7>
  803341:	b8 00 00 00 00       	mov    $0x0,%eax
  803346:	a3 40 51 80 00       	mov    %eax,0x805140
  80334b:	a1 40 51 80 00       	mov    0x805140,%eax
  803350:	85 c0                	test   %eax,%eax
  803352:	0f 85 ef f9 ff ff    	jne    802d47 <insert_sorted_with_merge_freeList+0x1b8>
  803358:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80335c:	0f 85 e5 f9 ff ff    	jne    802d47 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803362:	eb 00                	jmp    803364 <insert_sorted_with_merge_freeList+0x7d5>
  803364:	90                   	nop
  803365:	c9                   	leave  
  803366:	c3                   	ret    

00803367 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803367:	55                   	push   %ebp
  803368:	89 e5                	mov    %esp,%ebp
  80336a:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80336d:	8b 55 08             	mov    0x8(%ebp),%edx
  803370:	89 d0                	mov    %edx,%eax
  803372:	c1 e0 02             	shl    $0x2,%eax
  803375:	01 d0                	add    %edx,%eax
  803377:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80337e:	01 d0                	add    %edx,%eax
  803380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803387:	01 d0                	add    %edx,%eax
  803389:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803390:	01 d0                	add    %edx,%eax
  803392:	c1 e0 04             	shl    $0x4,%eax
  803395:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803398:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80339f:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8033a2:	83 ec 0c             	sub    $0xc,%esp
  8033a5:	50                   	push   %eax
  8033a6:	e8 21 ec ff ff       	call   801fcc <sys_get_virtual_time>
  8033ab:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8033ae:	eb 41                	jmp    8033f1 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8033b0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8033b3:	83 ec 0c             	sub    $0xc,%esp
  8033b6:	50                   	push   %eax
  8033b7:	e8 10 ec ff ff       	call   801fcc <sys_get_virtual_time>
  8033bc:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8033bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8033c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8033c5:	29 c2                	sub    %eax,%edx
  8033c7:	89 d0                	mov    %edx,%eax
  8033c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8033cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8033d2:	89 d1                	mov    %edx,%ecx
  8033d4:	29 c1                	sub    %eax,%ecx
  8033d6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8033d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8033dc:	39 c2                	cmp    %eax,%edx
  8033de:	0f 97 c0             	seta   %al
  8033e1:	0f b6 c0             	movzbl %al,%eax
  8033e4:	29 c1                	sub    %eax,%ecx
  8033e6:	89 c8                	mov    %ecx,%eax
  8033e8:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8033eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8033ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8033f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8033f7:	72 b7                	jb     8033b0 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8033f9:	90                   	nop
  8033fa:	c9                   	leave  
  8033fb:	c3                   	ret    

008033fc <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8033fc:	55                   	push   %ebp
  8033fd:	89 e5                	mov    %esp,%ebp
  8033ff:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803409:	eb 03                	jmp    80340e <busy_wait+0x12>
  80340b:	ff 45 fc             	incl   -0x4(%ebp)
  80340e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803411:	3b 45 08             	cmp    0x8(%ebp),%eax
  803414:	72 f5                	jb     80340b <busy_wait+0xf>
	return i;
  803416:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803419:	c9                   	leave  
  80341a:	c3                   	ret    
  80341b:	90                   	nop

0080341c <__udivdi3>:
  80341c:	55                   	push   %ebp
  80341d:	57                   	push   %edi
  80341e:	56                   	push   %esi
  80341f:	53                   	push   %ebx
  803420:	83 ec 1c             	sub    $0x1c,%esp
  803423:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803427:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80342b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80342f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803433:	89 ca                	mov    %ecx,%edx
  803435:	89 f8                	mov    %edi,%eax
  803437:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80343b:	85 f6                	test   %esi,%esi
  80343d:	75 2d                	jne    80346c <__udivdi3+0x50>
  80343f:	39 cf                	cmp    %ecx,%edi
  803441:	77 65                	ja     8034a8 <__udivdi3+0x8c>
  803443:	89 fd                	mov    %edi,%ebp
  803445:	85 ff                	test   %edi,%edi
  803447:	75 0b                	jne    803454 <__udivdi3+0x38>
  803449:	b8 01 00 00 00       	mov    $0x1,%eax
  80344e:	31 d2                	xor    %edx,%edx
  803450:	f7 f7                	div    %edi
  803452:	89 c5                	mov    %eax,%ebp
  803454:	31 d2                	xor    %edx,%edx
  803456:	89 c8                	mov    %ecx,%eax
  803458:	f7 f5                	div    %ebp
  80345a:	89 c1                	mov    %eax,%ecx
  80345c:	89 d8                	mov    %ebx,%eax
  80345e:	f7 f5                	div    %ebp
  803460:	89 cf                	mov    %ecx,%edi
  803462:	89 fa                	mov    %edi,%edx
  803464:	83 c4 1c             	add    $0x1c,%esp
  803467:	5b                   	pop    %ebx
  803468:	5e                   	pop    %esi
  803469:	5f                   	pop    %edi
  80346a:	5d                   	pop    %ebp
  80346b:	c3                   	ret    
  80346c:	39 ce                	cmp    %ecx,%esi
  80346e:	77 28                	ja     803498 <__udivdi3+0x7c>
  803470:	0f bd fe             	bsr    %esi,%edi
  803473:	83 f7 1f             	xor    $0x1f,%edi
  803476:	75 40                	jne    8034b8 <__udivdi3+0x9c>
  803478:	39 ce                	cmp    %ecx,%esi
  80347a:	72 0a                	jb     803486 <__udivdi3+0x6a>
  80347c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803480:	0f 87 9e 00 00 00    	ja     803524 <__udivdi3+0x108>
  803486:	b8 01 00 00 00       	mov    $0x1,%eax
  80348b:	89 fa                	mov    %edi,%edx
  80348d:	83 c4 1c             	add    $0x1c,%esp
  803490:	5b                   	pop    %ebx
  803491:	5e                   	pop    %esi
  803492:	5f                   	pop    %edi
  803493:	5d                   	pop    %ebp
  803494:	c3                   	ret    
  803495:	8d 76 00             	lea    0x0(%esi),%esi
  803498:	31 ff                	xor    %edi,%edi
  80349a:	31 c0                	xor    %eax,%eax
  80349c:	89 fa                	mov    %edi,%edx
  80349e:	83 c4 1c             	add    $0x1c,%esp
  8034a1:	5b                   	pop    %ebx
  8034a2:	5e                   	pop    %esi
  8034a3:	5f                   	pop    %edi
  8034a4:	5d                   	pop    %ebp
  8034a5:	c3                   	ret    
  8034a6:	66 90                	xchg   %ax,%ax
  8034a8:	89 d8                	mov    %ebx,%eax
  8034aa:	f7 f7                	div    %edi
  8034ac:	31 ff                	xor    %edi,%edi
  8034ae:	89 fa                	mov    %edi,%edx
  8034b0:	83 c4 1c             	add    $0x1c,%esp
  8034b3:	5b                   	pop    %ebx
  8034b4:	5e                   	pop    %esi
  8034b5:	5f                   	pop    %edi
  8034b6:	5d                   	pop    %ebp
  8034b7:	c3                   	ret    
  8034b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8034bd:	89 eb                	mov    %ebp,%ebx
  8034bf:	29 fb                	sub    %edi,%ebx
  8034c1:	89 f9                	mov    %edi,%ecx
  8034c3:	d3 e6                	shl    %cl,%esi
  8034c5:	89 c5                	mov    %eax,%ebp
  8034c7:	88 d9                	mov    %bl,%cl
  8034c9:	d3 ed                	shr    %cl,%ebp
  8034cb:	89 e9                	mov    %ebp,%ecx
  8034cd:	09 f1                	or     %esi,%ecx
  8034cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8034d3:	89 f9                	mov    %edi,%ecx
  8034d5:	d3 e0                	shl    %cl,%eax
  8034d7:	89 c5                	mov    %eax,%ebp
  8034d9:	89 d6                	mov    %edx,%esi
  8034db:	88 d9                	mov    %bl,%cl
  8034dd:	d3 ee                	shr    %cl,%esi
  8034df:	89 f9                	mov    %edi,%ecx
  8034e1:	d3 e2                	shl    %cl,%edx
  8034e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8034e7:	88 d9                	mov    %bl,%cl
  8034e9:	d3 e8                	shr    %cl,%eax
  8034eb:	09 c2                	or     %eax,%edx
  8034ed:	89 d0                	mov    %edx,%eax
  8034ef:	89 f2                	mov    %esi,%edx
  8034f1:	f7 74 24 0c          	divl   0xc(%esp)
  8034f5:	89 d6                	mov    %edx,%esi
  8034f7:	89 c3                	mov    %eax,%ebx
  8034f9:	f7 e5                	mul    %ebp
  8034fb:	39 d6                	cmp    %edx,%esi
  8034fd:	72 19                	jb     803518 <__udivdi3+0xfc>
  8034ff:	74 0b                	je     80350c <__udivdi3+0xf0>
  803501:	89 d8                	mov    %ebx,%eax
  803503:	31 ff                	xor    %edi,%edi
  803505:	e9 58 ff ff ff       	jmp    803462 <__udivdi3+0x46>
  80350a:	66 90                	xchg   %ax,%ax
  80350c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803510:	89 f9                	mov    %edi,%ecx
  803512:	d3 e2                	shl    %cl,%edx
  803514:	39 c2                	cmp    %eax,%edx
  803516:	73 e9                	jae    803501 <__udivdi3+0xe5>
  803518:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80351b:	31 ff                	xor    %edi,%edi
  80351d:	e9 40 ff ff ff       	jmp    803462 <__udivdi3+0x46>
  803522:	66 90                	xchg   %ax,%ax
  803524:	31 c0                	xor    %eax,%eax
  803526:	e9 37 ff ff ff       	jmp    803462 <__udivdi3+0x46>
  80352b:	90                   	nop

0080352c <__umoddi3>:
  80352c:	55                   	push   %ebp
  80352d:	57                   	push   %edi
  80352e:	56                   	push   %esi
  80352f:	53                   	push   %ebx
  803530:	83 ec 1c             	sub    $0x1c,%esp
  803533:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803537:	8b 74 24 34          	mov    0x34(%esp),%esi
  80353b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80353f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803543:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803547:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80354b:	89 f3                	mov    %esi,%ebx
  80354d:	89 fa                	mov    %edi,%edx
  80354f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803553:	89 34 24             	mov    %esi,(%esp)
  803556:	85 c0                	test   %eax,%eax
  803558:	75 1a                	jne    803574 <__umoddi3+0x48>
  80355a:	39 f7                	cmp    %esi,%edi
  80355c:	0f 86 a2 00 00 00    	jbe    803604 <__umoddi3+0xd8>
  803562:	89 c8                	mov    %ecx,%eax
  803564:	89 f2                	mov    %esi,%edx
  803566:	f7 f7                	div    %edi
  803568:	89 d0                	mov    %edx,%eax
  80356a:	31 d2                	xor    %edx,%edx
  80356c:	83 c4 1c             	add    $0x1c,%esp
  80356f:	5b                   	pop    %ebx
  803570:	5e                   	pop    %esi
  803571:	5f                   	pop    %edi
  803572:	5d                   	pop    %ebp
  803573:	c3                   	ret    
  803574:	39 f0                	cmp    %esi,%eax
  803576:	0f 87 ac 00 00 00    	ja     803628 <__umoddi3+0xfc>
  80357c:	0f bd e8             	bsr    %eax,%ebp
  80357f:	83 f5 1f             	xor    $0x1f,%ebp
  803582:	0f 84 ac 00 00 00    	je     803634 <__umoddi3+0x108>
  803588:	bf 20 00 00 00       	mov    $0x20,%edi
  80358d:	29 ef                	sub    %ebp,%edi
  80358f:	89 fe                	mov    %edi,%esi
  803591:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803595:	89 e9                	mov    %ebp,%ecx
  803597:	d3 e0                	shl    %cl,%eax
  803599:	89 d7                	mov    %edx,%edi
  80359b:	89 f1                	mov    %esi,%ecx
  80359d:	d3 ef                	shr    %cl,%edi
  80359f:	09 c7                	or     %eax,%edi
  8035a1:	89 e9                	mov    %ebp,%ecx
  8035a3:	d3 e2                	shl    %cl,%edx
  8035a5:	89 14 24             	mov    %edx,(%esp)
  8035a8:	89 d8                	mov    %ebx,%eax
  8035aa:	d3 e0                	shl    %cl,%eax
  8035ac:	89 c2                	mov    %eax,%edx
  8035ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035b2:	d3 e0                	shl    %cl,%eax
  8035b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8035bc:	89 f1                	mov    %esi,%ecx
  8035be:	d3 e8                	shr    %cl,%eax
  8035c0:	09 d0                	or     %edx,%eax
  8035c2:	d3 eb                	shr    %cl,%ebx
  8035c4:	89 da                	mov    %ebx,%edx
  8035c6:	f7 f7                	div    %edi
  8035c8:	89 d3                	mov    %edx,%ebx
  8035ca:	f7 24 24             	mull   (%esp)
  8035cd:	89 c6                	mov    %eax,%esi
  8035cf:	89 d1                	mov    %edx,%ecx
  8035d1:	39 d3                	cmp    %edx,%ebx
  8035d3:	0f 82 87 00 00 00    	jb     803660 <__umoddi3+0x134>
  8035d9:	0f 84 91 00 00 00    	je     803670 <__umoddi3+0x144>
  8035df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8035e3:	29 f2                	sub    %esi,%edx
  8035e5:	19 cb                	sbb    %ecx,%ebx
  8035e7:	89 d8                	mov    %ebx,%eax
  8035e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8035ed:	d3 e0                	shl    %cl,%eax
  8035ef:	89 e9                	mov    %ebp,%ecx
  8035f1:	d3 ea                	shr    %cl,%edx
  8035f3:	09 d0                	or     %edx,%eax
  8035f5:	89 e9                	mov    %ebp,%ecx
  8035f7:	d3 eb                	shr    %cl,%ebx
  8035f9:	89 da                	mov    %ebx,%edx
  8035fb:	83 c4 1c             	add    $0x1c,%esp
  8035fe:	5b                   	pop    %ebx
  8035ff:	5e                   	pop    %esi
  803600:	5f                   	pop    %edi
  803601:	5d                   	pop    %ebp
  803602:	c3                   	ret    
  803603:	90                   	nop
  803604:	89 fd                	mov    %edi,%ebp
  803606:	85 ff                	test   %edi,%edi
  803608:	75 0b                	jne    803615 <__umoddi3+0xe9>
  80360a:	b8 01 00 00 00       	mov    $0x1,%eax
  80360f:	31 d2                	xor    %edx,%edx
  803611:	f7 f7                	div    %edi
  803613:	89 c5                	mov    %eax,%ebp
  803615:	89 f0                	mov    %esi,%eax
  803617:	31 d2                	xor    %edx,%edx
  803619:	f7 f5                	div    %ebp
  80361b:	89 c8                	mov    %ecx,%eax
  80361d:	f7 f5                	div    %ebp
  80361f:	89 d0                	mov    %edx,%eax
  803621:	e9 44 ff ff ff       	jmp    80356a <__umoddi3+0x3e>
  803626:	66 90                	xchg   %ax,%ax
  803628:	89 c8                	mov    %ecx,%eax
  80362a:	89 f2                	mov    %esi,%edx
  80362c:	83 c4 1c             	add    $0x1c,%esp
  80362f:	5b                   	pop    %ebx
  803630:	5e                   	pop    %esi
  803631:	5f                   	pop    %edi
  803632:	5d                   	pop    %ebp
  803633:	c3                   	ret    
  803634:	3b 04 24             	cmp    (%esp),%eax
  803637:	72 06                	jb     80363f <__umoddi3+0x113>
  803639:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80363d:	77 0f                	ja     80364e <__umoddi3+0x122>
  80363f:	89 f2                	mov    %esi,%edx
  803641:	29 f9                	sub    %edi,%ecx
  803643:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803647:	89 14 24             	mov    %edx,(%esp)
  80364a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80364e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803652:	8b 14 24             	mov    (%esp),%edx
  803655:	83 c4 1c             	add    $0x1c,%esp
  803658:	5b                   	pop    %ebx
  803659:	5e                   	pop    %esi
  80365a:	5f                   	pop    %edi
  80365b:	5d                   	pop    %ebp
  80365c:	c3                   	ret    
  80365d:	8d 76 00             	lea    0x0(%esi),%esi
  803660:	2b 04 24             	sub    (%esp),%eax
  803663:	19 fa                	sbb    %edi,%edx
  803665:	89 d1                	mov    %edx,%ecx
  803667:	89 c6                	mov    %eax,%esi
  803669:	e9 71 ff ff ff       	jmp    8035df <__umoddi3+0xb3>
  80366e:	66 90                	xchg   %ax,%ax
  803670:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803674:	72 ea                	jb     803660 <__umoddi3+0x134>
  803676:	89 d9                	mov    %ebx,%ecx
  803678:	e9 62 ff ff ff       	jmp    8035df <__umoddi3+0xb3>
