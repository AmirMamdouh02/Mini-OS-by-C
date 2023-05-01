
obj/user/tst_buffer_3:     file format elf32-i386


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
  800031:	e8 82 02 00 00       	call   8002b8 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 44             	sub    $0x44,%esp
//		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x804000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
//		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review size of the WS..!!");
	}
	int kilo = 1024;
  80003f:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	int Mega = 1024*1024;
  800046:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)

	{
		int freeFrames = sys_calculate_free_frames() ;
  80004d:	e8 93 1a 00 00       	call   801ae5 <sys_calculate_free_frames>
  800052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int origFreeFrames = freeFrames ;
  800055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800058:	89 45 e0             	mov    %eax,-0x20(%ebp)

		uint32 size = 10*Mega;
  80005b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80005e:	89 d0                	mov    %edx,%eax
  800060:	c1 e0 02             	shl    $0x2,%eax
  800063:	01 d0                	add    %edx,%eax
  800065:	01 c0                	add    %eax,%eax
  800067:	89 45 dc             	mov    %eax,-0x24(%ebp)
		unsigned char *x = malloc(sizeof(unsigned char)*size) ;
  80006a:	83 ec 0c             	sub    $0xc,%esp
  80006d:	ff 75 dc             	pushl  -0x24(%ebp)
  800070:	e8 d2 15 00 00       	call   801647 <malloc>
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	89 45 d8             	mov    %eax,-0x28(%ebp)
		freeFrames = sys_calculate_free_frames() ;
  80007b:	e8 65 1a 00 00       	call   801ae5 <sys_calculate_free_frames>
  800080:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int modFrames = sys_calculate_modified_frames();
  800083:	e8 76 1a 00 00       	call   801afe <sys_calculate_modified_frames>
  800088:	89 45 d4             	mov    %eax,-0x2c(%ebp)

		cprintf("all frames AFTER malloc = %d\n", freeFrames + modFrames);
  80008b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80008e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800091:	01 d0                	add    %edx,%eax
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	50                   	push   %eax
  800097:	68 20 34 80 00       	push   $0x803420
  80009c:	e8 07 06 00 00       	call   8006a8 <cprintf>
  8000a1:	83 c4 10             	add    $0x10,%esp
		x[1]=-1;
  8000a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000a7:	40                   	inc    %eax
  8000a8:	c6 00 ff             	movb   $0xff,(%eax)

		x[1*Mega] = -1;
  8000ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000b1:	01 d0                	add    %edx,%eax
  8000b3:	c6 00 ff             	movb   $0xff,(%eax)

		int i = x[2*Mega];
  8000b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000b9:	01 c0                	add    %eax,%eax
  8000bb:	89 c2                	mov    %eax,%edx
  8000bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000c0:	01 d0                	add    %edx,%eax
  8000c2:	8a 00                	mov    (%eax),%al
  8000c4:	0f b6 c0             	movzbl %al,%eax
  8000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)

		int j = x[3*Mega];
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	89 c2                	mov    %eax,%edx
  8000cf:	01 d2                	add    %edx,%edx
  8000d1:	01 d0                	add    %edx,%eax
  8000d3:	89 c2                	mov    %eax,%edx
  8000d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000d8:	01 d0                	add    %edx,%eax
  8000da:	8a 00                	mov    (%eax),%al
  8000dc:	0f b6 c0             	movzbl %al,%eax
  8000df:	89 45 d0             	mov    %eax,-0x30(%ebp)

		x[4*Mega] = -1;
  8000e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000e5:	c1 e0 02             	shl    $0x2,%eax
  8000e8:	89 c2                	mov    %eax,%edx
  8000ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8000ed:	01 d0                	add    %edx,%eax
  8000ef:	c6 00 ff             	movb   $0xff,(%eax)

		x[5*Mega] = -1;
  8000f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8000f5:	89 d0                	mov    %edx,%eax
  8000f7:	c1 e0 02             	shl    $0x2,%eax
  8000fa:	01 d0                	add    %edx,%eax
  8000fc:	89 c2                	mov    %eax,%edx
  8000fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800101:	01 d0                	add    %edx,%eax
  800103:	c6 00 ff             	movb   $0xff,(%eax)

		x[6*Mega] = -1;
  800106:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800109:	89 d0                	mov    %edx,%eax
  80010b:	01 c0                	add    %eax,%eax
  80010d:	01 d0                	add    %edx,%eax
  80010f:	01 c0                	add    %eax,%eax
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800116:	01 d0                	add    %edx,%eax
  800118:	c6 00 ff             	movb   $0xff,(%eax)

		x[7*Mega] = -1;
  80011b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80011e:	89 d0                	mov    %edx,%eax
  800120:	01 c0                	add    %eax,%eax
  800122:	01 d0                	add    %edx,%eax
  800124:	01 c0                	add    %eax,%eax
  800126:	01 d0                	add    %edx,%eax
  800128:	89 c2                	mov    %eax,%edx
  80012a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80012d:	01 d0                	add    %edx,%eax
  80012f:	c6 00 ff             	movb   $0xff,(%eax)

		x[8*Mega] = -1;
  800132:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800135:	c1 e0 03             	shl    $0x3,%eax
  800138:	89 c2                	mov    %eax,%edx
  80013a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80013d:	01 d0                	add    %edx,%eax
  80013f:	c6 00 ff             	movb   $0xff,(%eax)

		x[9*Mega] = -1;
  800142:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800145:	89 d0                	mov    %edx,%eax
  800147:	c1 e0 03             	shl    $0x3,%eax
  80014a:	01 d0                	add    %edx,%eax
  80014c:	89 c2                	mov    %eax,%edx
  80014e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	c6 00 ff             	movb   $0xff,(%eax)

		free(x);
  800156:	83 ec 0c             	sub    $0xc,%esp
  800159:	ff 75 d8             	pushl  -0x28(%ebp)
  80015c:	e8 7f 15 00 00       	call   8016e0 <free>
  800161:	83 c4 10             	add    $0x10,%esp

		int numOFEmptyLocInWS = 0;
  800164:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  80016b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800172:	eb 79                	jmp    8001ed <_main+0x1b5>
		{
			if (myEnv->__uptr_pws[i].empty)
  800174:	a1 20 40 80 00       	mov    0x804020,%eax
  800179:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80017f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800182:	89 d0                	mov    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	c1 e0 03             	shl    $0x3,%eax
  80018b:	01 c8                	add    %ecx,%eax
  80018d:	8a 40 04             	mov    0x4(%eax),%al
  800190:	84 c0                	test   %al,%al
  800192:	74 05                	je     800199 <_main+0x161>
			{
				numOFEmptyLocInWS++;
  800194:	ff 45 f0             	incl   -0x10(%ebp)
  800197:	eb 51                	jmp    8001ea <_main+0x1b2>
			}
			else
			{
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  800199:	a1 20 40 80 00       	mov    0x804020,%eax
  80019e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a7:	89 d0                	mov    %edx,%eax
  8001a9:	01 c0                	add    %eax,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	c1 e0 03             	shl    $0x3,%eax
  8001b0:	01 c8                	add    %ecx,%eax
  8001b2:	8b 00                	mov    (%eax),%eax
  8001b4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8001b7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001bf:	89 45 c8             	mov    %eax,-0x38(%ebp)
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
  8001c2:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8001c5:	85 c0                	test   %eax,%eax
  8001c7:	79 21                	jns    8001ea <_main+0x1b2>
  8001c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cc:	05 00 00 00 80       	add    $0x80000000,%eax
  8001d1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  8001d4:	76 14                	jbe    8001ea <_main+0x1b2>
					panic("freeMem didn't remove its page(s) from the WS");
  8001d6:	83 ec 04             	sub    $0x4,%esp
  8001d9:	68 40 34 80 00       	push   $0x803440
  8001de:	6a 4e                	push   $0x4e
  8001e0:	68 6e 34 80 00       	push   $0x80346e
  8001e5:	e8 0a 02 00 00       	call   8003f4 <_panic>
		x[9*Mega] = -1;

		free(x);

		int numOFEmptyLocInWS = 0;
		for (i = 0 ; i < (myEnv->page_WS_max_size); i++)
  8001ea:	ff 45 f4             	incl   -0xc(%ebp)
  8001ed:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f2:	8b 50 74             	mov    0x74(%eax),%edx
  8001f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001f8:	39 c2                	cmp    %eax,%edx
  8001fa:	0f 87 74 ff ff ff    	ja     800174 <_main+0x13c>
				uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
				if (va >= USER_HEAP_START && va < (USER_HEAP_START + size))
					panic("freeMem didn't remove its page(s) from the WS");
			}
		}
		int free_frames = sys_calculate_free_frames();
  800200:	e8 e0 18 00 00       	call   801ae5 <sys_calculate_free_frames>
  800205:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		int mod_frames = sys_calculate_modified_frames();
  800208:	e8 f1 18 00 00       	call   801afe <sys_calculate_modified_frames>
  80020d:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if ((sys_calculate_modified_frames() + sys_calculate_free_frames() - numOFEmptyLocInWS) - (modFrames + freeFrames) != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
  800210:	e8 e9 18 00 00       	call   801afe <sys_calculate_modified_frames>
  800215:	89 c3                	mov    %eax,%ebx
  800217:	e8 c9 18 00 00       	call   801ae5 <sys_calculate_free_frames>
  80021c:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80021f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800222:	89 d1                	mov    %edx,%ecx
  800224:	29 c1                	sub    %eax,%ecx
  800226:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800229:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022c:	01 d0                	add    %edx,%eax
  80022e:	39 c1                	cmp    %eax,%ecx
  800230:	74 14                	je     800246 <_main+0x20e>
  800232:	83 ec 04             	sub    $0x4,%esp
  800235:	68 84 34 80 00       	push   $0x803484
  80023a:	6a 53                	push   $0x53
  80023c:	68 6e 34 80 00       	push   $0x80346e
  800241:	e8 ae 01 00 00       	call   8003f4 <_panic>
		//if (sys_calculate_modified_frames() != 0 ) panic("FreeMem didn't remove all modified frames in the given range from the modified list");
		//if (sys_calculate_notmod_frames() != 7) panic("FreeMem didn't remove all un-modified frames in the given range from the free frame list");

		//if (sys_calculate_free_frames() - freeFrames != 3) panic("FreeMem didn't UN-BUFFER the removed BUFFERED frames in the given range.. (check updating of isBuffered");

		cprintf("Congratulations!! test of removing BUFFERED pages in freeHeap is completed successfully.\n");
  800246:	83 ec 0c             	sub    $0xc,%esp
  800249:	68 d8 34 80 00       	push   $0x8034d8
  80024e:	e8 55 04 00 00       	call   8006a8 <cprintf>
  800253:	83 c4 10             	add    $0x10,%esp

		//Try to access any of the removed buffered pages in the Heap [It's ILLEGAL ACCESS now]
		{
			cprintf("\nNow, trying to access the removed BUFFERED pages, you should make the kernel PANIC with ILLEGAL MEMORY ACCESS in page_fault_handler() since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK.\n\n\n");
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	68 34 35 80 00       	push   $0x803534
  80025e:	e8 45 04 00 00       	call   8006a8 <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp

			x[1]=-1;
  800266:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800269:	40                   	inc    %eax
  80026a:	c6 00 ff             	movb   $0xff,(%eax)

			x[1*Mega] = -1;
  80026d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800270:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800273:	01 d0                	add    %edx,%eax
  800275:	c6 00 ff             	movb   $0xff,(%eax)

			int i = x[2*Mega];
  800278:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80027b:	01 c0                	add    %eax,%eax
  80027d:	89 c2                	mov    %eax,%edx
  80027f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800282:	01 d0                	add    %edx,%eax
  800284:	8a 00                	mov    (%eax),%al
  800286:	0f b6 c0             	movzbl %al,%eax
  800289:	89 45 bc             	mov    %eax,-0x44(%ebp)

			int j = x[3*Mega];
  80028c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80028f:	89 c2                	mov    %eax,%edx
  800291:	01 d2                	add    %edx,%edx
  800293:	01 d0                	add    %edx,%eax
  800295:	89 c2                	mov    %eax,%edx
  800297:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80029a:	01 d0                	add    %edx,%eax
  80029c:	8a 00                	mov    (%eax),%al
  80029e:	0f b6 c0             	movzbl %al,%eax
  8002a1:	89 45 b8             	mov    %eax,-0x48(%ebp)
		}
		panic("ERROR: FOS SHOULD NOT panic here, it should panic earlier in page_fault_handler(), since we have illegal access to page that is NOT EXIST in PF and NOT BELONGS to STACK. REMEMBER: creating new page in page file shouldn't be allowed except ONLY for stack pages\n");
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 18 36 80 00       	push   $0x803618
  8002ac:	6a 68                	push   $0x68
  8002ae:	68 6e 34 80 00       	push   $0x80346e
  8002b3:	e8 3c 01 00 00       	call   8003f4 <_panic>

008002b8 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002be:	e8 02 1b 00 00       	call   801dc5 <sys_getenvindex>
  8002c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002c9:	89 d0                	mov    %edx,%eax
  8002cb:	c1 e0 03             	shl    $0x3,%eax
  8002ce:	01 d0                	add    %edx,%eax
  8002d0:	01 c0                	add    %eax,%eax
  8002d2:	01 d0                	add    %edx,%eax
  8002d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002db:	01 d0                	add    %edx,%eax
  8002dd:	c1 e0 04             	shl    $0x4,%eax
  8002e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002e5:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ef:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002f5:	84 c0                	test   %al,%al
  8002f7:	74 0f                	je     800308 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fe:	05 5c 05 00 00       	add    $0x55c,%eax
  800303:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800308:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80030c:	7e 0a                	jle    800318 <libmain+0x60>
		binaryname = argv[0];
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800311:	8b 00                	mov    (%eax),%eax
  800313:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 0c             	pushl  0xc(%ebp)
  80031e:	ff 75 08             	pushl  0x8(%ebp)
  800321:	e8 12 fd ff ff       	call   800038 <_main>
  800326:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800329:	e8 a4 18 00 00       	call   801bd2 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80032e:	83 ec 0c             	sub    $0xc,%esp
  800331:	68 38 37 80 00       	push   $0x803738
  800336:	e8 6d 03 00 00       	call   8006a8 <cprintf>
  80033b:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80033e:	a1 20 40 80 00       	mov    0x804020,%eax
  800343:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800354:	83 ec 04             	sub    $0x4,%esp
  800357:	52                   	push   %edx
  800358:	50                   	push   %eax
  800359:	68 60 37 80 00       	push   $0x803760
  80035e:	e8 45 03 00 00       	call   8006a8 <cprintf>
  800363:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800366:	a1 20 40 80 00       	mov    0x804020,%eax
  80036b:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800371:	a1 20 40 80 00       	mov    0x804020,%eax
  800376:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80037c:	a1 20 40 80 00       	mov    0x804020,%eax
  800381:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800387:	51                   	push   %ecx
  800388:	52                   	push   %edx
  800389:	50                   	push   %eax
  80038a:	68 88 37 80 00       	push   $0x803788
  80038f:	e8 14 03 00 00       	call   8006a8 <cprintf>
  800394:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800397:	a1 20 40 80 00       	mov    0x804020,%eax
  80039c:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	50                   	push   %eax
  8003a6:	68 e0 37 80 00       	push   $0x8037e0
  8003ab:	e8 f8 02 00 00       	call   8006a8 <cprintf>
  8003b0:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	68 38 37 80 00       	push   $0x803738
  8003bb:	e8 e8 02 00 00       	call   8006a8 <cprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003c3:	e8 24 18 00 00       	call   801bec <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003c8:	e8 19 00 00 00       	call   8003e6 <exit>
}
  8003cd:	90                   	nop
  8003ce:	c9                   	leave  
  8003cf:	c3                   	ret    

008003d0 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003d6:	83 ec 0c             	sub    $0xc,%esp
  8003d9:	6a 00                	push   $0x0
  8003db:	e8 b1 19 00 00       	call   801d91 <sys_destroy_env>
  8003e0:	83 c4 10             	add    $0x10,%esp
}
  8003e3:	90                   	nop
  8003e4:	c9                   	leave  
  8003e5:	c3                   	ret    

008003e6 <exit>:

void
exit(void)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003ec:	e8 06 1a 00 00       	call   801df7 <sys_exit_env>
}
  8003f1:	90                   	nop
  8003f2:	c9                   	leave  
  8003f3:	c3                   	ret    

008003f4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8003fd:	83 c0 04             	add    $0x4,%eax
  800400:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800403:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800408:	85 c0                	test   %eax,%eax
  80040a:	74 16                	je     800422 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80040c:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800411:	83 ec 08             	sub    $0x8,%esp
  800414:	50                   	push   %eax
  800415:	68 f4 37 80 00       	push   $0x8037f4
  80041a:	e8 89 02 00 00       	call   8006a8 <cprintf>
  80041f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800422:	a1 00 40 80 00       	mov    0x804000,%eax
  800427:	ff 75 0c             	pushl  0xc(%ebp)
  80042a:	ff 75 08             	pushl  0x8(%ebp)
  80042d:	50                   	push   %eax
  80042e:	68 f9 37 80 00       	push   $0x8037f9
  800433:	e8 70 02 00 00       	call   8006a8 <cprintf>
  800438:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80043b:	8b 45 10             	mov    0x10(%ebp),%eax
  80043e:	83 ec 08             	sub    $0x8,%esp
  800441:	ff 75 f4             	pushl  -0xc(%ebp)
  800444:	50                   	push   %eax
  800445:	e8 f3 01 00 00       	call   80063d <vcprintf>
  80044a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	6a 00                	push   $0x0
  800452:	68 15 38 80 00       	push   $0x803815
  800457:	e8 e1 01 00 00       	call   80063d <vcprintf>
  80045c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80045f:	e8 82 ff ff ff       	call   8003e6 <exit>

	// should not return here
	while (1) ;
  800464:	eb fe                	jmp    800464 <_panic+0x70>

00800466 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800466:	55                   	push   %ebp
  800467:	89 e5                	mov    %esp,%ebp
  800469:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80046c:	a1 20 40 80 00       	mov    0x804020,%eax
  800471:	8b 50 74             	mov    0x74(%eax),%edx
  800474:	8b 45 0c             	mov    0xc(%ebp),%eax
  800477:	39 c2                	cmp    %eax,%edx
  800479:	74 14                	je     80048f <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	68 18 38 80 00       	push   $0x803818
  800483:	6a 26                	push   $0x26
  800485:	68 64 38 80 00       	push   $0x803864
  80048a:	e8 65 ff ff ff       	call   8003f4 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80048f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800496:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80049d:	e9 c2 00 00 00       	jmp    800564 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8004a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8004af:	01 d0                	add    %edx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	85 c0                	test   %eax,%eax
  8004b5:	75 08                	jne    8004bf <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004b7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004ba:	e9 a2 00 00 00       	jmp    800561 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004cd:	eb 69                	jmp    800538 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004cf:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004da:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004dd:	89 d0                	mov    %edx,%eax
  8004df:	01 c0                	add    %eax,%eax
  8004e1:	01 d0                	add    %edx,%eax
  8004e3:	c1 e0 03             	shl    $0x3,%eax
  8004e6:	01 c8                	add    %ecx,%eax
  8004e8:	8a 40 04             	mov    0x4(%eax),%al
  8004eb:	84 c0                	test   %al,%al
  8004ed:	75 46                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8004f4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004fa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004fd:	89 d0                	mov    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	c1 e0 03             	shl    $0x3,%eax
  800506:	01 c8                	add    %ecx,%eax
  800508:	8b 00                	mov    (%eax),%eax
  80050a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80050d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800510:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800515:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80051a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	01 c8                	add    %ecx,%eax
  800526:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800528:	39 c2                	cmp    %eax,%edx
  80052a:	75 09                	jne    800535 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80052c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800533:	eb 12                	jmp    800547 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800535:	ff 45 e8             	incl   -0x18(%ebp)
  800538:	a1 20 40 80 00       	mov    0x804020,%eax
  80053d:	8b 50 74             	mov    0x74(%eax),%edx
  800540:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800543:	39 c2                	cmp    %eax,%edx
  800545:	77 88                	ja     8004cf <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800547:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80054b:	75 14                	jne    800561 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80054d:	83 ec 04             	sub    $0x4,%esp
  800550:	68 70 38 80 00       	push   $0x803870
  800555:	6a 3a                	push   $0x3a
  800557:	68 64 38 80 00       	push   $0x803864
  80055c:	e8 93 fe ff ff       	call   8003f4 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800561:	ff 45 f0             	incl   -0x10(%ebp)
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80056a:	0f 8c 32 ff ff ff    	jl     8004a2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800570:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800577:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80057e:	eb 26                	jmp    8005a6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800580:	a1 20 40 80 00       	mov    0x804020,%eax
  800585:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80058b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80058e:	89 d0                	mov    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	01 d0                	add    %edx,%eax
  800594:	c1 e0 03             	shl    $0x3,%eax
  800597:	01 c8                	add    %ecx,%eax
  800599:	8a 40 04             	mov    0x4(%eax),%al
  80059c:	3c 01                	cmp    $0x1,%al
  80059e:	75 03                	jne    8005a3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8005a0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005a3:	ff 45 e0             	incl   -0x20(%ebp)
  8005a6:	a1 20 40 80 00       	mov    0x804020,%eax
  8005ab:	8b 50 74             	mov    0x74(%eax),%edx
  8005ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b1:	39 c2                	cmp    %eax,%edx
  8005b3:	77 cb                	ja     800580 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005b8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005bb:	74 14                	je     8005d1 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	68 c4 38 80 00       	push   $0x8038c4
  8005c5:	6a 44                	push   $0x44
  8005c7:	68 64 38 80 00       	push   $0x803864
  8005cc:	e8 23 fe ff ff       	call   8003f4 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005d1:	90                   	nop
  8005d2:	c9                   	leave  
  8005d3:	c3                   	ret    

008005d4 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005d4:	55                   	push   %ebp
  8005d5:	89 e5                	mov    %esp,%ebp
  8005d7:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005dd:	8b 00                	mov    (%eax),%eax
  8005df:	8d 48 01             	lea    0x1(%eax),%ecx
  8005e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e5:	89 0a                	mov    %ecx,(%edx)
  8005e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ea:	88 d1                	mov    %dl,%cl
  8005ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ef:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005fd:	75 2c                	jne    80062b <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005ff:	a0 24 40 80 00       	mov    0x804024,%al
  800604:	0f b6 c0             	movzbl %al,%eax
  800607:	8b 55 0c             	mov    0xc(%ebp),%edx
  80060a:	8b 12                	mov    (%edx),%edx
  80060c:	89 d1                	mov    %edx,%ecx
  80060e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800611:	83 c2 08             	add    $0x8,%edx
  800614:	83 ec 04             	sub    $0x4,%esp
  800617:	50                   	push   %eax
  800618:	51                   	push   %ecx
  800619:	52                   	push   %edx
  80061a:	e8 05 14 00 00       	call   801a24 <sys_cputs>
  80061f:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800622:	8b 45 0c             	mov    0xc(%ebp),%eax
  800625:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	8b 40 04             	mov    0x4(%eax),%eax
  800631:	8d 50 01             	lea    0x1(%eax),%edx
  800634:	8b 45 0c             	mov    0xc(%ebp),%eax
  800637:	89 50 04             	mov    %edx,0x4(%eax)
}
  80063a:	90                   	nop
  80063b:	c9                   	leave  
  80063c:	c3                   	ret    

0080063d <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800646:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80064d:	00 00 00 
	b.cnt = 0;
  800650:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800657:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80065a:	ff 75 0c             	pushl  0xc(%ebp)
  80065d:	ff 75 08             	pushl  0x8(%ebp)
  800660:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800666:	50                   	push   %eax
  800667:	68 d4 05 80 00       	push   $0x8005d4
  80066c:	e8 11 02 00 00       	call   800882 <vprintfmt>
  800671:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800674:	a0 24 40 80 00       	mov    0x804024,%al
  800679:	0f b6 c0             	movzbl %al,%eax
  80067c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800682:	83 ec 04             	sub    $0x4,%esp
  800685:	50                   	push   %eax
  800686:	52                   	push   %edx
  800687:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80068d:	83 c0 08             	add    $0x8,%eax
  800690:	50                   	push   %eax
  800691:	e8 8e 13 00 00       	call   801a24 <sys_cputs>
  800696:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800699:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8006a0:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8006a6:	c9                   	leave  
  8006a7:	c3                   	ret    

008006a8 <cprintf>:

int cprintf(const char *fmt, ...) {
  8006a8:	55                   	push   %ebp
  8006a9:	89 e5                	mov    %esp,%ebp
  8006ab:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006ae:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8006b5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006be:	83 ec 08             	sub    $0x8,%esp
  8006c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006c4:	50                   	push   %eax
  8006c5:	e8 73 ff ff ff       	call   80063d <vcprintf>
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006d3:	c9                   	leave  
  8006d4:	c3                   	ret    

008006d5 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006d5:	55                   	push   %ebp
  8006d6:	89 e5                	mov    %esp,%ebp
  8006d8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006db:	e8 f2 14 00 00       	call   801bd2 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006e0:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	83 ec 08             	sub    $0x8,%esp
  8006ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8006ef:	50                   	push   %eax
  8006f0:	e8 48 ff ff ff       	call   80063d <vcprintf>
  8006f5:	83 c4 10             	add    $0x10,%esp
  8006f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006fb:	e8 ec 14 00 00       	call   801bec <sys_enable_interrupt>
	return cnt;
  800700:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800703:	c9                   	leave  
  800704:	c3                   	ret    

00800705 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	53                   	push   %ebx
  800709:	83 ec 14             	sub    $0x14,%esp
  80070c:	8b 45 10             	mov    0x10(%ebp),%eax
  80070f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800718:	8b 45 18             	mov    0x18(%ebp),%eax
  80071b:	ba 00 00 00 00       	mov    $0x0,%edx
  800720:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800723:	77 55                	ja     80077a <printnum+0x75>
  800725:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800728:	72 05                	jb     80072f <printnum+0x2a>
  80072a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80072d:	77 4b                	ja     80077a <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80072f:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800732:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800735:	8b 45 18             	mov    0x18(%ebp),%eax
  800738:	ba 00 00 00 00       	mov    $0x0,%edx
  80073d:	52                   	push   %edx
  80073e:	50                   	push   %eax
  80073f:	ff 75 f4             	pushl  -0xc(%ebp)
  800742:	ff 75 f0             	pushl  -0x10(%ebp)
  800745:	e8 62 2a 00 00       	call   8031ac <__udivdi3>
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	83 ec 04             	sub    $0x4,%esp
  800750:	ff 75 20             	pushl  0x20(%ebp)
  800753:	53                   	push   %ebx
  800754:	ff 75 18             	pushl  0x18(%ebp)
  800757:	52                   	push   %edx
  800758:	50                   	push   %eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	e8 a1 ff ff ff       	call   800705 <printnum>
  800764:	83 c4 20             	add    $0x20,%esp
  800767:	eb 1a                	jmp    800783 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800769:	83 ec 08             	sub    $0x8,%esp
  80076c:	ff 75 0c             	pushl  0xc(%ebp)
  80076f:	ff 75 20             	pushl  0x20(%ebp)
  800772:	8b 45 08             	mov    0x8(%ebp),%eax
  800775:	ff d0                	call   *%eax
  800777:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80077a:	ff 4d 1c             	decl   0x1c(%ebp)
  80077d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800781:	7f e6                	jg     800769 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800783:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800786:	bb 00 00 00 00       	mov    $0x0,%ebx
  80078b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80078e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800791:	53                   	push   %ebx
  800792:	51                   	push   %ecx
  800793:	52                   	push   %edx
  800794:	50                   	push   %eax
  800795:	e8 22 2b 00 00       	call   8032bc <__umoddi3>
  80079a:	83 c4 10             	add    $0x10,%esp
  80079d:	05 34 3b 80 00       	add    $0x803b34,%eax
  8007a2:	8a 00                	mov    (%eax),%al
  8007a4:	0f be c0             	movsbl %al,%eax
  8007a7:	83 ec 08             	sub    $0x8,%esp
  8007aa:	ff 75 0c             	pushl  0xc(%ebp)
  8007ad:	50                   	push   %eax
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	ff d0                	call   *%eax
  8007b3:	83 c4 10             	add    $0x10,%esp
}
  8007b6:	90                   	nop
  8007b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007ba:	c9                   	leave  
  8007bb:	c3                   	ret    

008007bc <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007bc:	55                   	push   %ebp
  8007bd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007bf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c3:	7e 1c                	jle    8007e1 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c8:	8b 00                	mov    (%eax),%eax
  8007ca:	8d 50 08             	lea    0x8(%eax),%edx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	89 10                	mov    %edx,(%eax)
  8007d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	83 e8 08             	sub    $0x8,%eax
  8007da:	8b 50 04             	mov    0x4(%eax),%edx
  8007dd:	8b 00                	mov    (%eax),%eax
  8007df:	eb 40                	jmp    800821 <getuint+0x65>
	else if (lflag)
  8007e1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e5:	74 1e                	je     800805 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ea:	8b 00                	mov    (%eax),%eax
  8007ec:	8d 50 04             	lea    0x4(%eax),%edx
  8007ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f2:	89 10                	mov    %edx,(%eax)
  8007f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f7:	8b 00                	mov    (%eax),%eax
  8007f9:	83 e8 04             	sub    $0x4,%eax
  8007fc:	8b 00                	mov    (%eax),%eax
  8007fe:	ba 00 00 00 00       	mov    $0x0,%edx
  800803:	eb 1c                	jmp    800821 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800805:	8b 45 08             	mov    0x8(%ebp),%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	89 10                	mov    %edx,(%eax)
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	8b 00                	mov    (%eax),%eax
  800817:	83 e8 04             	sub    $0x4,%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800821:	5d                   	pop    %ebp
  800822:	c3                   	ret    

00800823 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800826:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80082a:	7e 1c                	jle    800848 <getint+0x25>
		return va_arg(*ap, long long);
  80082c:	8b 45 08             	mov    0x8(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	8d 50 08             	lea    0x8(%eax),%edx
  800834:	8b 45 08             	mov    0x8(%ebp),%eax
  800837:	89 10                	mov    %edx,(%eax)
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	8b 00                	mov    (%eax),%eax
  80083e:	83 e8 08             	sub    $0x8,%eax
  800841:	8b 50 04             	mov    0x4(%eax),%edx
  800844:	8b 00                	mov    (%eax),%eax
  800846:	eb 38                	jmp    800880 <getint+0x5d>
	else if (lflag)
  800848:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80084c:	74 1a                	je     800868 <getint+0x45>
		return va_arg(*ap, long);
  80084e:	8b 45 08             	mov    0x8(%ebp),%eax
  800851:	8b 00                	mov    (%eax),%eax
  800853:	8d 50 04             	lea    0x4(%eax),%edx
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	89 10                	mov    %edx,(%eax)
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 00                	mov    (%eax),%eax
  800860:	83 e8 04             	sub    $0x4,%eax
  800863:	8b 00                	mov    (%eax),%eax
  800865:	99                   	cltd   
  800866:	eb 18                	jmp    800880 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800868:	8b 45 08             	mov    0x8(%ebp),%eax
  80086b:	8b 00                	mov    (%eax),%eax
  80086d:	8d 50 04             	lea    0x4(%eax),%edx
  800870:	8b 45 08             	mov    0x8(%ebp),%eax
  800873:	89 10                	mov    %edx,(%eax)
  800875:	8b 45 08             	mov    0x8(%ebp),%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	83 e8 04             	sub    $0x4,%eax
  80087d:	8b 00                	mov    (%eax),%eax
  80087f:	99                   	cltd   
}
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80088a:	eb 17                	jmp    8008a3 <vprintfmt+0x21>
			if (ch == '\0')
  80088c:	85 db                	test   %ebx,%ebx
  80088e:	0f 84 af 03 00 00    	je     800c43 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	ff d0                	call   *%eax
  8008a0:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a6:	8d 50 01             	lea    0x1(%eax),%edx
  8008a9:	89 55 10             	mov    %edx,0x10(%ebp)
  8008ac:	8a 00                	mov    (%eax),%al
  8008ae:	0f b6 d8             	movzbl %al,%ebx
  8008b1:	83 fb 25             	cmp    $0x25,%ebx
  8008b4:	75 d6                	jne    80088c <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008b6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008ba:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008c1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008c8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d9:	8d 50 01             	lea    0x1(%eax),%edx
  8008dc:	89 55 10             	mov    %edx,0x10(%ebp)
  8008df:	8a 00                	mov    (%eax),%al
  8008e1:	0f b6 d8             	movzbl %al,%ebx
  8008e4:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008e7:	83 f8 55             	cmp    $0x55,%eax
  8008ea:	0f 87 2b 03 00 00    	ja     800c1b <vprintfmt+0x399>
  8008f0:	8b 04 85 58 3b 80 00 	mov    0x803b58(,%eax,4),%eax
  8008f7:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008f9:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008fd:	eb d7                	jmp    8008d6 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008ff:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800903:	eb d1                	jmp    8008d6 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800905:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80090c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80090f:	89 d0                	mov    %edx,%eax
  800911:	c1 e0 02             	shl    $0x2,%eax
  800914:	01 d0                	add    %edx,%eax
  800916:	01 c0                	add    %eax,%eax
  800918:	01 d8                	add    %ebx,%eax
  80091a:	83 e8 30             	sub    $0x30,%eax
  80091d:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800920:	8b 45 10             	mov    0x10(%ebp),%eax
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800928:	83 fb 2f             	cmp    $0x2f,%ebx
  80092b:	7e 3e                	jle    80096b <vprintfmt+0xe9>
  80092d:	83 fb 39             	cmp    $0x39,%ebx
  800930:	7f 39                	jg     80096b <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800932:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800935:	eb d5                	jmp    80090c <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800937:	8b 45 14             	mov    0x14(%ebp),%eax
  80093a:	83 c0 04             	add    $0x4,%eax
  80093d:	89 45 14             	mov    %eax,0x14(%ebp)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 e8 04             	sub    $0x4,%eax
  800946:	8b 00                	mov    (%eax),%eax
  800948:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80094b:	eb 1f                	jmp    80096c <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80094d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800951:	79 83                	jns    8008d6 <vprintfmt+0x54>
				width = 0;
  800953:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80095a:	e9 77 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80095f:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800966:	e9 6b ff ff ff       	jmp    8008d6 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80096b:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80096c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800970:	0f 89 60 ff ff ff    	jns    8008d6 <vprintfmt+0x54>
				width = precision, precision = -1;
  800976:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80097c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800983:	e9 4e ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800988:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80098b:	e9 46 ff ff ff       	jmp    8008d6 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800990:	8b 45 14             	mov    0x14(%ebp),%eax
  800993:	83 c0 04             	add    $0x4,%eax
  800996:	89 45 14             	mov    %eax,0x14(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	83 e8 04             	sub    $0x4,%eax
  80099f:	8b 00                	mov    (%eax),%eax
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	50                   	push   %eax
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	ff d0                	call   *%eax
  8009ad:	83 c4 10             	add    $0x10,%esp
			break;
  8009b0:	e9 89 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b8:	83 c0 04             	add    $0x4,%eax
  8009bb:	89 45 14             	mov    %eax,0x14(%ebp)
  8009be:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c1:	83 e8 04             	sub    $0x4,%eax
  8009c4:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	79 02                	jns    8009cc <vprintfmt+0x14a>
				err = -err;
  8009ca:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009cc:	83 fb 64             	cmp    $0x64,%ebx
  8009cf:	7f 0b                	jg     8009dc <vprintfmt+0x15a>
  8009d1:	8b 34 9d a0 39 80 00 	mov    0x8039a0(,%ebx,4),%esi
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	75 19                	jne    8009f5 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009dc:	53                   	push   %ebx
  8009dd:	68 45 3b 80 00       	push   $0x803b45
  8009e2:	ff 75 0c             	pushl  0xc(%ebp)
  8009e5:	ff 75 08             	pushl  0x8(%ebp)
  8009e8:	e8 5e 02 00 00       	call   800c4b <printfmt>
  8009ed:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009f0:	e9 49 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009f5:	56                   	push   %esi
  8009f6:	68 4e 3b 80 00       	push   $0x803b4e
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	ff 75 08             	pushl  0x8(%ebp)
  800a01:	e8 45 02 00 00       	call   800c4b <printfmt>
  800a06:	83 c4 10             	add    $0x10,%esp
			break;
  800a09:	e9 30 02 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a11:	83 c0 04             	add    $0x4,%eax
  800a14:	89 45 14             	mov    %eax,0x14(%ebp)
  800a17:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1a:	83 e8 04             	sub    $0x4,%eax
  800a1d:	8b 30                	mov    (%eax),%esi
  800a1f:	85 f6                	test   %esi,%esi
  800a21:	75 05                	jne    800a28 <vprintfmt+0x1a6>
				p = "(null)";
  800a23:	be 51 3b 80 00       	mov    $0x803b51,%esi
			if (width > 0 && padc != '-')
  800a28:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2c:	7e 6d                	jle    800a9b <vprintfmt+0x219>
  800a2e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a32:	74 67                	je     800a9b <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a34:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	50                   	push   %eax
  800a3b:	56                   	push   %esi
  800a3c:	e8 0c 03 00 00       	call   800d4d <strnlen>
  800a41:	83 c4 10             	add    $0x10,%esp
  800a44:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a47:	eb 16                	jmp    800a5f <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a49:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a4d:	83 ec 08             	sub    $0x8,%esp
  800a50:	ff 75 0c             	pushl  0xc(%ebp)
  800a53:	50                   	push   %eax
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	ff d0                	call   *%eax
  800a59:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a5c:	ff 4d e4             	decl   -0x1c(%ebp)
  800a5f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a63:	7f e4                	jg     800a49 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a65:	eb 34                	jmp    800a9b <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a67:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a6b:	74 1c                	je     800a89 <vprintfmt+0x207>
  800a6d:	83 fb 1f             	cmp    $0x1f,%ebx
  800a70:	7e 05                	jle    800a77 <vprintfmt+0x1f5>
  800a72:	83 fb 7e             	cmp    $0x7e,%ebx
  800a75:	7e 12                	jle    800a89 <vprintfmt+0x207>
					putch('?', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 3f                	push   $0x3f
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	eb 0f                	jmp    800a98 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a89:	83 ec 08             	sub    $0x8,%esp
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	53                   	push   %ebx
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	ff d0                	call   *%eax
  800a95:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a98:	ff 4d e4             	decl   -0x1c(%ebp)
  800a9b:	89 f0                	mov    %esi,%eax
  800a9d:	8d 70 01             	lea    0x1(%eax),%esi
  800aa0:	8a 00                	mov    (%eax),%al
  800aa2:	0f be d8             	movsbl %al,%ebx
  800aa5:	85 db                	test   %ebx,%ebx
  800aa7:	74 24                	je     800acd <vprintfmt+0x24b>
  800aa9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aad:	78 b8                	js     800a67 <vprintfmt+0x1e5>
  800aaf:	ff 4d e0             	decl   -0x20(%ebp)
  800ab2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ab6:	79 af                	jns    800a67 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ab8:	eb 13                	jmp    800acd <vprintfmt+0x24b>
				putch(' ', putdat);
  800aba:	83 ec 08             	sub    $0x8,%esp
  800abd:	ff 75 0c             	pushl  0xc(%ebp)
  800ac0:	6a 20                	push   $0x20
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	ff d0                	call   *%eax
  800ac7:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aca:	ff 4d e4             	decl   -0x1c(%ebp)
  800acd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ad1:	7f e7                	jg     800aba <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ad3:	e9 66 01 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800ad8:	83 ec 08             	sub    $0x8,%esp
  800adb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ade:	8d 45 14             	lea    0x14(%ebp),%eax
  800ae1:	50                   	push   %eax
  800ae2:	e8 3c fd ff ff       	call   800823 <getint>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800af0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800af6:	85 d2                	test   %edx,%edx
  800af8:	79 23                	jns    800b1d <vprintfmt+0x29b>
				putch('-', putdat);
  800afa:	83 ec 08             	sub    $0x8,%esp
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	6a 2d                	push   $0x2d
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	ff d0                	call   *%eax
  800b07:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800b0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b10:	f7 d8                	neg    %eax
  800b12:	83 d2 00             	adc    $0x0,%edx
  800b15:	f7 da                	neg    %edx
  800b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b1d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b24:	e9 bc 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b29:	83 ec 08             	sub    $0x8,%esp
  800b2c:	ff 75 e8             	pushl  -0x18(%ebp)
  800b2f:	8d 45 14             	lea    0x14(%ebp),%eax
  800b32:	50                   	push   %eax
  800b33:	e8 84 fc ff ff       	call   8007bc <getuint>
  800b38:	83 c4 10             	add    $0x10,%esp
  800b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b41:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b48:	e9 98 00 00 00       	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 58                	push   $0x58
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b5d:	83 ec 08             	sub    $0x8,%esp
  800b60:	ff 75 0c             	pushl  0xc(%ebp)
  800b63:	6a 58                	push   $0x58
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	ff d0                	call   *%eax
  800b6a:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b6d:	83 ec 08             	sub    $0x8,%esp
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	6a 58                	push   $0x58
  800b75:	8b 45 08             	mov    0x8(%ebp),%eax
  800b78:	ff d0                	call   *%eax
  800b7a:	83 c4 10             	add    $0x10,%esp
			break;
  800b7d:	e9 bc 00 00 00       	jmp    800c3e <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b82:	83 ec 08             	sub    $0x8,%esp
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	6a 30                	push   $0x30
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	ff d0                	call   *%eax
  800b8f:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 0c             	pushl  0xc(%ebp)
  800b98:	6a 78                	push   $0x78
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	ff d0                	call   *%eax
  800b9f:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ba2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba5:	83 c0 04             	add    $0x4,%eax
  800ba8:	89 45 14             	mov    %eax,0x14(%ebp)
  800bab:	8b 45 14             	mov    0x14(%ebp),%eax
  800bae:	83 e8 04             	sub    $0x4,%eax
  800bb1:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800bb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bbd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bc4:	eb 1f                	jmp    800be5 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 e8             	pushl  -0x18(%ebp)
  800bcc:	8d 45 14             	lea    0x14(%ebp),%eax
  800bcf:	50                   	push   %eax
  800bd0:	e8 e7 fb ff ff       	call   8007bc <getuint>
  800bd5:	83 c4 10             	add    $0x10,%esp
  800bd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bde:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800be5:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800be9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	52                   	push   %edx
  800bf0:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf3:	50                   	push   %eax
  800bf4:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf7:	ff 75 f0             	pushl  -0x10(%ebp)
  800bfa:	ff 75 0c             	pushl  0xc(%ebp)
  800bfd:	ff 75 08             	pushl  0x8(%ebp)
  800c00:	e8 00 fb ff ff       	call   800705 <printnum>
  800c05:	83 c4 20             	add    $0x20,%esp
			break;
  800c08:	eb 34                	jmp    800c3e <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c0a:	83 ec 08             	sub    $0x8,%esp
  800c0d:	ff 75 0c             	pushl  0xc(%ebp)
  800c10:	53                   	push   %ebx
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	ff d0                	call   *%eax
  800c16:	83 c4 10             	add    $0x10,%esp
			break;
  800c19:	eb 23                	jmp    800c3e <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	ff 75 0c             	pushl  0xc(%ebp)
  800c21:	6a 25                	push   $0x25
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	ff d0                	call   *%eax
  800c28:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c2b:	ff 4d 10             	decl   0x10(%ebp)
  800c2e:	eb 03                	jmp    800c33 <vprintfmt+0x3b1>
  800c30:	ff 4d 10             	decl   0x10(%ebp)
  800c33:	8b 45 10             	mov    0x10(%ebp),%eax
  800c36:	48                   	dec    %eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	3c 25                	cmp    $0x25,%al
  800c3b:	75 f3                	jne    800c30 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c3d:	90                   	nop
		}
	}
  800c3e:	e9 47 fc ff ff       	jmp    80088a <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c43:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c47:	5b                   	pop    %ebx
  800c48:	5e                   	pop    %esi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c51:	8d 45 10             	lea    0x10(%ebp),%eax
  800c54:	83 c0 04             	add    $0x4,%eax
  800c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c5d:	ff 75 f4             	pushl  -0xc(%ebp)
  800c60:	50                   	push   %eax
  800c61:	ff 75 0c             	pushl  0xc(%ebp)
  800c64:	ff 75 08             	pushl  0x8(%ebp)
  800c67:	e8 16 fc ff ff       	call   800882 <vprintfmt>
  800c6c:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c6f:	90                   	nop
  800c70:	c9                   	leave  
  800c71:	c3                   	ret    

00800c72 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c78:	8b 40 08             	mov    0x8(%eax),%eax
  800c7b:	8d 50 01             	lea    0x1(%eax),%edx
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c87:	8b 10                	mov    (%eax),%edx
  800c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8c:	8b 40 04             	mov    0x4(%eax),%eax
  800c8f:	39 c2                	cmp    %eax,%edx
  800c91:	73 12                	jae    800ca5 <sprintputch+0x33>
		*b->buf++ = ch;
  800c93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c96:	8b 00                	mov    (%eax),%eax
  800c98:	8d 48 01             	lea    0x1(%eax),%ecx
  800c9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c9e:	89 0a                	mov    %ecx,(%edx)
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	88 10                	mov    %dl,(%eax)
}
  800ca5:	90                   	nop
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cba:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbd:	01 d0                	add    %edx,%eax
  800cbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cc9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ccd:	74 06                	je     800cd5 <vsnprintf+0x2d>
  800ccf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cd3:	7f 07                	jg     800cdc <vsnprintf+0x34>
		return -E_INVAL;
  800cd5:	b8 03 00 00 00       	mov    $0x3,%eax
  800cda:	eb 20                	jmp    800cfc <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdc:	ff 75 14             	pushl  0x14(%ebp)
  800cdf:	ff 75 10             	pushl  0x10(%ebp)
  800ce2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ce5:	50                   	push   %eax
  800ce6:	68 72 0c 80 00       	push   $0x800c72
  800ceb:	e8 92 fb ff ff       	call   800882 <vprintfmt>
  800cf0:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800cf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cf6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cfc:	c9                   	leave  
  800cfd:	c3                   	ret    

00800cfe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cfe:	55                   	push   %ebp
  800cff:	89 e5                	mov    %esp,%ebp
  800d01:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800d04:	8d 45 10             	lea    0x10(%ebp),%eax
  800d07:	83 c0 04             	add    $0x4,%eax
  800d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d10:	ff 75 f4             	pushl  -0xc(%ebp)
  800d13:	50                   	push   %eax
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 89 ff ff ff       	call   800ca8 <vsnprintf>
  800d1f:	83 c4 10             	add    $0x10,%esp
  800d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d28:	c9                   	leave  
  800d29:	c3                   	ret    

00800d2a <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d2a:	55                   	push   %ebp
  800d2b:	89 e5                	mov    %esp,%ebp
  800d2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d37:	eb 06                	jmp    800d3f <strlen+0x15>
		n++;
  800d39:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d3c:	ff 45 08             	incl   0x8(%ebp)
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 00                	mov    (%eax),%al
  800d44:	84 c0                	test   %al,%al
  800d46:	75 f1                	jne    800d39 <strlen+0xf>
		n++;
	return n;
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4b:	c9                   	leave  
  800d4c:	c3                   	ret    

00800d4d <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d53:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d5a:	eb 09                	jmp    800d65 <strnlen+0x18>
		n++;
  800d5c:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d5f:	ff 45 08             	incl   0x8(%ebp)
  800d62:	ff 4d 0c             	decl   0xc(%ebp)
  800d65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d69:	74 09                	je     800d74 <strnlen+0x27>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 00                	mov    (%eax),%al
  800d70:	84 c0                	test   %al,%al
  800d72:	75 e8                	jne    800d5c <strnlen+0xf>
		n++;
	return n;
  800d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d85:	90                   	nop
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8d 50 01             	lea    0x1(%eax),%edx
  800d8c:	89 55 08             	mov    %edx,0x8(%ebp)
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d95:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d98:	8a 12                	mov    (%edx),%dl
  800d9a:	88 10                	mov    %dl,(%eax)
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	84 c0                	test   %al,%al
  800da0:	75 e4                	jne    800d86 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800da2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800da5:	c9                   	leave  
  800da6:	c3                   	ret    

00800da7 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
  800db0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800db3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800dba:	eb 1f                	jmp    800ddb <strncpy+0x34>
		*dst++ = *src;
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8d 50 01             	lea    0x1(%eax),%edx
  800dc2:	89 55 08             	mov    %edx,0x8(%ebp)
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc8:	8a 12                	mov    (%edx),%dl
  800dca:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	8a 00                	mov    (%eax),%al
  800dd1:	84 c0                	test   %al,%al
  800dd3:	74 03                	je     800dd8 <strncpy+0x31>
			src++;
  800dd5:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd8:	ff 45 fc             	incl   -0x4(%ebp)
  800ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dde:	3b 45 10             	cmp    0x10(%ebp),%eax
  800de1:	72 d9                	jb     800dbc <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800de3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800de6:	c9                   	leave  
  800de7:	c3                   	ret    

00800de8 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800df4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df8:	74 30                	je     800e2a <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800dfa:	eb 16                	jmp    800e12 <strlcpy+0x2a>
			*dst++ = *src++;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8d 50 01             	lea    0x1(%eax),%edx
  800e02:	89 55 08             	mov    %edx,0x8(%ebp)
  800e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e0e:	8a 12                	mov    (%edx),%dl
  800e10:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e12:	ff 4d 10             	decl   0x10(%ebp)
  800e15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e19:	74 09                	je     800e24 <strlcpy+0x3c>
  800e1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	84 c0                	test   %al,%al
  800e22:	75 d8                	jne    800dfc <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e30:	29 c2                	sub    %eax,%edx
  800e32:	89 d0                	mov    %edx,%eax
}
  800e34:	c9                   	leave  
  800e35:	c3                   	ret    

00800e36 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e39:	eb 06                	jmp    800e41 <strcmp+0xb>
		p++, q++;
  800e3b:	ff 45 08             	incl   0x8(%ebp)
  800e3e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	84 c0                	test   %al,%al
  800e48:	74 0e                	je     800e58 <strcmp+0x22>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	38 c2                	cmp    %al,%dl
  800e56:	74 e3                	je     800e3b <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	0f b6 d0             	movzbl %al,%edx
  800e60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e63:	8a 00                	mov    (%eax),%al
  800e65:	0f b6 c0             	movzbl %al,%eax
  800e68:	29 c2                	sub    %eax,%edx
  800e6a:	89 d0                	mov    %edx,%eax
}
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    

00800e6e <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e6e:	55                   	push   %ebp
  800e6f:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e71:	eb 09                	jmp    800e7c <strncmp+0xe>
		n--, p++, q++;
  800e73:	ff 4d 10             	decl   0x10(%ebp)
  800e76:	ff 45 08             	incl   0x8(%ebp)
  800e79:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e80:	74 17                	je     800e99 <strncmp+0x2b>
  800e82:	8b 45 08             	mov    0x8(%ebp),%eax
  800e85:	8a 00                	mov    (%eax),%al
  800e87:	84 c0                	test   %al,%al
  800e89:	74 0e                	je     800e99 <strncmp+0x2b>
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8a 10                	mov    (%eax),%dl
  800e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e93:	8a 00                	mov    (%eax),%al
  800e95:	38 c2                	cmp    %al,%dl
  800e97:	74 da                	je     800e73 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e9d:	75 07                	jne    800ea6 <strncmp+0x38>
		return 0;
  800e9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea4:	eb 14                	jmp    800eba <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea9:	8a 00                	mov    (%eax),%al
  800eab:	0f b6 d0             	movzbl %al,%edx
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	8a 00                	mov    (%eax),%al
  800eb3:	0f b6 c0             	movzbl %al,%eax
  800eb6:	29 c2                	sub    %eax,%edx
  800eb8:	89 d0                	mov    %edx,%eax
}
  800eba:	5d                   	pop    %ebp
  800ebb:	c3                   	ret    

00800ebc <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ebc:	55                   	push   %ebp
  800ebd:	89 e5                	mov    %esp,%ebp
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ec8:	eb 12                	jmp    800edc <strchr+0x20>
		if (*s == c)
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	8a 00                	mov    (%eax),%al
  800ecf:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ed2:	75 05                	jne    800ed9 <strchr+0x1d>
			return (char *) s;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	eb 11                	jmp    800eea <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ed9:	ff 45 08             	incl   0x8(%ebp)
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	84 c0                	test   %al,%al
  800ee3:	75 e5                	jne    800eca <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eea:	c9                   	leave  
  800eeb:	c3                   	ret    

00800eec <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 04             	sub    $0x4,%esp
  800ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef5:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ef8:	eb 0d                	jmp    800f07 <strfind+0x1b>
		if (*s == c)
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 00                	mov    (%eax),%al
  800eff:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f02:	74 0e                	je     800f12 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f04:	ff 45 08             	incl   0x8(%ebp)
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	84 c0                	test   %al,%al
  800f0e:	75 ea                	jne    800efa <strfind+0xe>
  800f10:	eb 01                	jmp    800f13 <strfind+0x27>
		if (*s == c)
			break;
  800f12:	90                   	nop
	return (char *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f2a:	eb 0e                	jmp    800f3a <memset+0x22>
		*p++ = c;
  800f2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f2f:	8d 50 01             	lea    0x1(%eax),%edx
  800f32:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f35:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f38:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f3a:	ff 4d f8             	decl   -0x8(%ebp)
  800f3d:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f41:	79 e9                	jns    800f2c <memset+0x14>
		*p++ = c;

	return v;
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f46:	c9                   	leave  
  800f47:	c3                   	ret    

00800f48 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f51:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f5a:	eb 16                	jmp    800f72 <memcpy+0x2a>
		*d++ = *s++;
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8d 50 01             	lea    0x1(%eax),%edx
  800f62:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f65:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f68:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f6b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f6e:	8a 12                	mov    (%edx),%dl
  800f70:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 dd                	jne    800f5c <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f90:	8b 45 08             	mov    0x8(%ebp),%eax
  800f93:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f96:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f99:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9c:	73 50                	jae    800fee <memmove+0x6a>
  800f9e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa4:	01 d0                	add    %edx,%eax
  800fa6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800fa9:	76 43                	jbe    800fee <memmove+0x6a>
		s += n;
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fb1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb4:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fb7:	eb 10                	jmp    800fc9 <memmove+0x45>
			*--d = *--s;
  800fb9:	ff 4d f8             	decl   -0x8(%ebp)
  800fbc:	ff 4d fc             	decl   -0x4(%ebp)
  800fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc2:	8a 10                	mov    (%eax),%dl
  800fc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc7:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fcc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fcf:	89 55 10             	mov    %edx,0x10(%ebp)
  800fd2:	85 c0                	test   %eax,%eax
  800fd4:	75 e3                	jne    800fb9 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fd6:	eb 23                	jmp    800ffb <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fdb:	8d 50 01             	lea    0x1(%eax),%edx
  800fde:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fe4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fe7:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fea:	8a 12                	mov    (%edx),%dl
  800fec:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fee:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ff4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	75 dd                	jne    800fd8 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80100c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100f:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801012:	eb 2a                	jmp    80103e <memcmp+0x3e>
		if (*s1 != *s2)
  801014:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801017:	8a 10                	mov    (%eax),%dl
  801019:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	38 c2                	cmp    %al,%dl
  801020:	74 16                	je     801038 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801022:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	0f b6 d0             	movzbl %al,%edx
  80102a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102d:	8a 00                	mov    (%eax),%al
  80102f:	0f b6 c0             	movzbl %al,%eax
  801032:	29 c2                	sub    %eax,%edx
  801034:	89 d0                	mov    %edx,%eax
  801036:	eb 18                	jmp    801050 <memcmp+0x50>
		s1++, s2++;
  801038:	ff 45 fc             	incl   -0x4(%ebp)
  80103b:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80103e:	8b 45 10             	mov    0x10(%ebp),%eax
  801041:	8d 50 ff             	lea    -0x1(%eax),%edx
  801044:	89 55 10             	mov    %edx,0x10(%ebp)
  801047:	85 c0                	test   %eax,%eax
  801049:	75 c9                	jne    801014 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801050:	c9                   	leave  
  801051:	c3                   	ret    

00801052 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
  801055:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	8b 45 10             	mov    0x10(%ebp),%eax
  80105e:	01 d0                	add    %edx,%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801063:	eb 15                	jmp    80107a <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	0f b6 d0             	movzbl %al,%edx
  80106d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801070:	0f b6 c0             	movzbl %al,%eax
  801073:	39 c2                	cmp    %eax,%edx
  801075:	74 0d                	je     801084 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801077:	ff 45 08             	incl   0x8(%ebp)
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801080:	72 e3                	jb     801065 <memfind+0x13>
  801082:	eb 01                	jmp    801085 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801084:	90                   	nop
	return (void *) s;
  801085:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801088:	c9                   	leave  
  801089:	c3                   	ret    

0080108a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80108a:	55                   	push   %ebp
  80108b:	89 e5                	mov    %esp,%ebp
  80108d:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801090:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801097:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80109e:	eb 03                	jmp    8010a3 <strtol+0x19>
		s++;
  8010a0:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a6:	8a 00                	mov    (%eax),%al
  8010a8:	3c 20                	cmp    $0x20,%al
  8010aa:	74 f4                	je     8010a0 <strtol+0x16>
  8010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8010af:	8a 00                	mov    (%eax),%al
  8010b1:	3c 09                	cmp    $0x9,%al
  8010b3:	74 eb                	je     8010a0 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b8:	8a 00                	mov    (%eax),%al
  8010ba:	3c 2b                	cmp    $0x2b,%al
  8010bc:	75 05                	jne    8010c3 <strtol+0x39>
		s++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
  8010c1:	eb 13                	jmp    8010d6 <strtol+0x4c>
	else if (*s == '-')
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	3c 2d                	cmp    $0x2d,%al
  8010ca:	75 0a                	jne    8010d6 <strtol+0x4c>
		s++, neg = 1;
  8010cc:	ff 45 08             	incl   0x8(%ebp)
  8010cf:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010d6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010da:	74 06                	je     8010e2 <strtol+0x58>
  8010dc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010e0:	75 20                	jne    801102 <strtol+0x78>
  8010e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e5:	8a 00                	mov    (%eax),%al
  8010e7:	3c 30                	cmp    $0x30,%al
  8010e9:	75 17                	jne    801102 <strtol+0x78>
  8010eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ee:	40                   	inc    %eax
  8010ef:	8a 00                	mov    (%eax),%al
  8010f1:	3c 78                	cmp    $0x78,%al
  8010f3:	75 0d                	jne    801102 <strtol+0x78>
		s += 2, base = 16;
  8010f5:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010f9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801100:	eb 28                	jmp    80112a <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	75 15                	jne    80111d <strtol+0x93>
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	3c 30                	cmp    $0x30,%al
  80110f:	75 0c                	jne    80111d <strtol+0x93>
		s++, base = 8;
  801111:	ff 45 08             	incl   0x8(%ebp)
  801114:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80111b:	eb 0d                	jmp    80112a <strtol+0xa0>
	else if (base == 0)
  80111d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801121:	75 07                	jne    80112a <strtol+0xa0>
		base = 10;
  801123:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80112a:	8b 45 08             	mov    0x8(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	3c 2f                	cmp    $0x2f,%al
  801131:	7e 19                	jle    80114c <strtol+0xc2>
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	8a 00                	mov    (%eax),%al
  801138:	3c 39                	cmp    $0x39,%al
  80113a:	7f 10                	jg     80114c <strtol+0xc2>
			dig = *s - '0';
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	0f be c0             	movsbl %al,%eax
  801144:	83 e8 30             	sub    $0x30,%eax
  801147:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80114a:	eb 42                	jmp    80118e <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80114c:	8b 45 08             	mov    0x8(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	3c 60                	cmp    $0x60,%al
  801153:	7e 19                	jle    80116e <strtol+0xe4>
  801155:	8b 45 08             	mov    0x8(%ebp),%eax
  801158:	8a 00                	mov    (%eax),%al
  80115a:	3c 7a                	cmp    $0x7a,%al
  80115c:	7f 10                	jg     80116e <strtol+0xe4>
			dig = *s - 'a' + 10;
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	0f be c0             	movsbl %al,%eax
  801166:	83 e8 57             	sub    $0x57,%eax
  801169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80116c:	eb 20                	jmp    80118e <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	3c 40                	cmp    $0x40,%al
  801175:	7e 39                	jle    8011b0 <strtol+0x126>
  801177:	8b 45 08             	mov    0x8(%ebp),%eax
  80117a:	8a 00                	mov    (%eax),%al
  80117c:	3c 5a                	cmp    $0x5a,%al
  80117e:	7f 30                	jg     8011b0 <strtol+0x126>
			dig = *s - 'A' + 10;
  801180:	8b 45 08             	mov    0x8(%ebp),%eax
  801183:	8a 00                	mov    (%eax),%al
  801185:	0f be c0             	movsbl %al,%eax
  801188:	83 e8 37             	sub    $0x37,%eax
  80118b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80118e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801191:	3b 45 10             	cmp    0x10(%ebp),%eax
  801194:	7d 19                	jge    8011af <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801196:	ff 45 08             	incl   0x8(%ebp)
  801199:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119c:	0f af 45 10          	imul   0x10(%ebp),%eax
  8011a0:	89 c2                	mov    %eax,%edx
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8011aa:	e9 7b ff ff ff       	jmp    80112a <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011af:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011b4:	74 08                	je     8011be <strtol+0x134>
		*endptr = (char *) s;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011be:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011c2:	74 07                	je     8011cb <strtol+0x141>
  8011c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c7:	f7 d8                	neg    %eax
  8011c9:	eb 03                	jmp    8011ce <strtol+0x144>
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011ce:	c9                   	leave  
  8011cf:	c3                   	ret    

008011d0 <ltostr>:

void
ltostr(long value, char *str)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011d6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011dd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011e4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011e8:	79 13                	jns    8011fd <ltostr+0x2d>
	{
		neg = 1;
  8011ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f4:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011f7:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011fa:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801200:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801205:	99                   	cltd   
  801206:	f7 f9                	idiv   %ecx
  801208:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80120b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120e:	8d 50 01             	lea    0x1(%eax),%edx
  801211:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801214:	89 c2                	mov    %eax,%edx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 d0                	add    %edx,%eax
  80121b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80121e:	83 c2 30             	add    $0x30,%edx
  801221:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801226:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80122b:	f7 e9                	imul   %ecx
  80122d:	c1 fa 02             	sar    $0x2,%edx
  801230:	89 c8                	mov    %ecx,%eax
  801232:	c1 f8 1f             	sar    $0x1f,%eax
  801235:	29 c2                	sub    %eax,%edx
  801237:	89 d0                	mov    %edx,%eax
  801239:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80123c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80123f:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801244:	f7 e9                	imul   %ecx
  801246:	c1 fa 02             	sar    $0x2,%edx
  801249:	89 c8                	mov    %ecx,%eax
  80124b:	c1 f8 1f             	sar    $0x1f,%eax
  80124e:	29 c2                	sub    %eax,%edx
  801250:	89 d0                	mov    %edx,%eax
  801252:	c1 e0 02             	shl    $0x2,%eax
  801255:	01 d0                	add    %edx,%eax
  801257:	01 c0                	add    %eax,%eax
  801259:	29 c1                	sub    %eax,%ecx
  80125b:	89 ca                	mov    %ecx,%edx
  80125d:	85 d2                	test   %edx,%edx
  80125f:	75 9c                	jne    8011fd <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801268:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126b:	48                   	dec    %eax
  80126c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80126f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801273:	74 3d                	je     8012b2 <ltostr+0xe2>
		start = 1 ;
  801275:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80127c:	eb 34                	jmp    8012b2 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80127e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	01 d0                	add    %edx,%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80128b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80128e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801291:	01 c2                	add    %eax,%edx
  801293:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801296:	8b 45 0c             	mov    0xc(%ebp),%eax
  801299:	01 c8                	add    %ecx,%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80129f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a5:	01 c2                	add    %eax,%edx
  8012a7:	8a 45 eb             	mov    -0x15(%ebp),%al
  8012aa:	88 02                	mov    %al,(%edx)
		start++ ;
  8012ac:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012af:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012b8:	7c c4                	jl     80127e <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c0:	01 d0                	add    %edx,%eax
  8012c2:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012c5:	90                   	nop
  8012c6:	c9                   	leave  
  8012c7:	c3                   	ret    

008012c8 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012ce:	ff 75 08             	pushl  0x8(%ebp)
  8012d1:	e8 54 fa ff ff       	call   800d2a <strlen>
  8012d6:	83 c4 04             	add    $0x4,%esp
  8012d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 46 fa ff ff       	call   800d2a <strlen>
  8012e4:	83 c4 04             	add    $0x4,%esp
  8012e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f8:	eb 17                	jmp    801311 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 c2                	add    %eax,%edx
  801302:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	01 c8                	add    %ecx,%eax
  80130a:	8a 00                	mov    (%eax),%al
  80130c:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80130e:	ff 45 fc             	incl   -0x4(%ebp)
  801311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801314:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801317:	7c e1                	jl     8012fa <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801319:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801327:	eb 1f                	jmp    801348 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801329:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80132c:	8d 50 01             	lea    0x1(%eax),%edx
  80132f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801332:	89 c2                	mov    %eax,%edx
  801334:	8b 45 10             	mov    0x10(%ebp),%eax
  801337:	01 c2                	add    %eax,%edx
  801339:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80133c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133f:	01 c8                	add    %ecx,%eax
  801341:	8a 00                	mov    (%eax),%al
  801343:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801345:	ff 45 f8             	incl   -0x8(%ebp)
  801348:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80134b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80134e:	7c d9                	jl     801329 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801350:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	01 d0                	add    %edx,%eax
  801358:	c6 00 00             	movb   $0x0,(%eax)
}
  80135b:	90                   	nop
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    

0080135e <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80135e:	55                   	push   %ebp
  80135f:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801361:	8b 45 14             	mov    0x14(%ebp),%eax
  801364:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80136a:	8b 45 14             	mov    0x14(%ebp),%eax
  80136d:	8b 00                	mov    (%eax),%eax
  80136f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801376:	8b 45 10             	mov    0x10(%ebp),%eax
  801379:	01 d0                	add    %edx,%eax
  80137b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801381:	eb 0c                	jmp    80138f <strsplit+0x31>
			*string++ = 0;
  801383:	8b 45 08             	mov    0x8(%ebp),%eax
  801386:	8d 50 01             	lea    0x1(%eax),%edx
  801389:	89 55 08             	mov    %edx,0x8(%ebp)
  80138c:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	84 c0                	test   %al,%al
  801396:	74 18                	je     8013b0 <strsplit+0x52>
  801398:	8b 45 08             	mov    0x8(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f be c0             	movsbl %al,%eax
  8013a0:	50                   	push   %eax
  8013a1:	ff 75 0c             	pushl  0xc(%ebp)
  8013a4:	e8 13 fb ff ff       	call   800ebc <strchr>
  8013a9:	83 c4 08             	add    $0x8,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	75 d3                	jne    801383 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	84 c0                	test   %al,%al
  8013b7:	74 5a                	je     801413 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8013bc:	8b 00                	mov    (%eax),%eax
  8013be:	83 f8 0f             	cmp    $0xf,%eax
  8013c1:	75 07                	jne    8013ca <strsplit+0x6c>
		{
			return 0;
  8013c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c8:	eb 66                	jmp    801430 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8013cd:	8b 00                	mov    (%eax),%eax
  8013cf:	8d 48 01             	lea    0x1(%eax),%ecx
  8013d2:	8b 55 14             	mov    0x14(%ebp),%edx
  8013d5:	89 0a                	mov    %ecx,(%edx)
  8013d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013de:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e1:	01 c2                	add    %eax,%edx
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e8:	eb 03                	jmp    8013ed <strsplit+0x8f>
			string++;
  8013ea:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	84 c0                	test   %al,%al
  8013f4:	74 8b                	je     801381 <strsplit+0x23>
  8013f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f9:	8a 00                	mov    (%eax),%al
  8013fb:	0f be c0             	movsbl %al,%eax
  8013fe:	50                   	push   %eax
  8013ff:	ff 75 0c             	pushl  0xc(%ebp)
  801402:	e8 b5 fa ff ff       	call   800ebc <strchr>
  801407:	83 c4 08             	add    $0x8,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	74 dc                	je     8013ea <strsplit+0x8c>
			string++;
	}
  80140e:	e9 6e ff ff ff       	jmp    801381 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801413:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	8b 00                	mov    (%eax),%eax
  801419:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	01 d0                	add    %edx,%eax
  801425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80142b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801438:	a1 04 40 80 00       	mov    0x804004,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 1f                	je     801460 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801441:	e8 1d 00 00 00       	call   801463 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801446:	83 ec 0c             	sub    $0xc,%esp
  801449:	68 b0 3c 80 00       	push   $0x803cb0
  80144e:	e8 55 f2 ff ff       	call   8006a8 <cprintf>
  801453:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801456:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80145d:	00 00 00 
	}
}
  801460:	90                   	nop
  801461:	c9                   	leave  
  801462:	c3                   	ret    

00801463 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801463:	55                   	push   %ebp
  801464:	89 e5                	mov    %esp,%ebp
  801466:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801469:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801470:	00 00 00 
  801473:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80147a:	00 00 00 
  80147d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801484:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801487:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80148e:	00 00 00 
  801491:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801498:	00 00 00 
  80149b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8014a2:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8014a5:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8014ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014af:	c1 e8 0c             	shr    $0xc,%eax
  8014b2:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8014b7:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8014be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014cb:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  8014d0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8014d7:	a1 20 41 80 00       	mov    0x804120,%eax
  8014dc:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8014e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8014e3:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8014ea:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8014ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f0:	01 d0                	add    %edx,%eax
  8014f2:	48                   	dec    %eax
  8014f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fe:	f7 75 e4             	divl   -0x1c(%ebp)
  801501:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801504:	29 d0                	sub    %edx,%eax
  801506:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801509:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801510:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801513:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801518:	2d 00 10 00 00       	sub    $0x1000,%eax
  80151d:	83 ec 04             	sub    $0x4,%esp
  801520:	6a 07                	push   $0x7
  801522:	ff 75 e8             	pushl  -0x18(%ebp)
  801525:	50                   	push   %eax
  801526:	e8 3d 06 00 00       	call   801b68 <sys_allocate_chunk>
  80152b:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80152e:	a1 20 41 80 00       	mov    0x804120,%eax
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	50                   	push   %eax
  801537:	e8 b2 0c 00 00       	call   8021ee <initialize_MemBlocksList>
  80153c:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  80153f:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801544:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801547:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80154b:	0f 84 f3 00 00 00    	je     801644 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801551:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801555:	75 14                	jne    80156b <initialize_dyn_block_system+0x108>
  801557:	83 ec 04             	sub    $0x4,%esp
  80155a:	68 d5 3c 80 00       	push   $0x803cd5
  80155f:	6a 36                	push   $0x36
  801561:	68 f3 3c 80 00       	push   $0x803cf3
  801566:	e8 89 ee ff ff       	call   8003f4 <_panic>
  80156b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80156e:	8b 00                	mov    (%eax),%eax
  801570:	85 c0                	test   %eax,%eax
  801572:	74 10                	je     801584 <initialize_dyn_block_system+0x121>
  801574:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801577:	8b 00                	mov    (%eax),%eax
  801579:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80157c:	8b 52 04             	mov    0x4(%edx),%edx
  80157f:	89 50 04             	mov    %edx,0x4(%eax)
  801582:	eb 0b                	jmp    80158f <initialize_dyn_block_system+0x12c>
  801584:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801587:	8b 40 04             	mov    0x4(%eax),%eax
  80158a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80158f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801592:	8b 40 04             	mov    0x4(%eax),%eax
  801595:	85 c0                	test   %eax,%eax
  801597:	74 0f                	je     8015a8 <initialize_dyn_block_system+0x145>
  801599:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80159c:	8b 40 04             	mov    0x4(%eax),%eax
  80159f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015a2:	8b 12                	mov    (%edx),%edx
  8015a4:	89 10                	mov    %edx,(%eax)
  8015a6:	eb 0a                	jmp    8015b2 <initialize_dyn_block_system+0x14f>
  8015a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015ab:	8b 00                	mov    (%eax),%eax
  8015ad:	a3 48 41 80 00       	mov    %eax,0x804148
  8015b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015c5:	a1 54 41 80 00       	mov    0x804154,%eax
  8015ca:	48                   	dec    %eax
  8015cb:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8015d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015d3:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8015da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015dd:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8015e4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8015e8:	75 14                	jne    8015fe <initialize_dyn_block_system+0x19b>
  8015ea:	83 ec 04             	sub    $0x4,%esp
  8015ed:	68 00 3d 80 00       	push   $0x803d00
  8015f2:	6a 3e                	push   $0x3e
  8015f4:	68 f3 3c 80 00       	push   $0x803cf3
  8015f9:	e8 f6 ed ff ff       	call   8003f4 <_panic>
  8015fe:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801604:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801607:	89 10                	mov    %edx,(%eax)
  801609:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80160c:	8b 00                	mov    (%eax),%eax
  80160e:	85 c0                	test   %eax,%eax
  801610:	74 0d                	je     80161f <initialize_dyn_block_system+0x1bc>
  801612:	a1 38 41 80 00       	mov    0x804138,%eax
  801617:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80161a:	89 50 04             	mov    %edx,0x4(%eax)
  80161d:	eb 08                	jmp    801627 <initialize_dyn_block_system+0x1c4>
  80161f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801622:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801627:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80162a:	a3 38 41 80 00       	mov    %eax,0x804138
  80162f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801639:	a1 44 41 80 00       	mov    0x804144,%eax
  80163e:	40                   	inc    %eax
  80163f:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801644:	90                   	nop
  801645:	c9                   	leave  
  801646:	c3                   	ret    

00801647 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80164d:	e8 e0 fd ff ff       	call   801432 <InitializeUHeap>
		if (size == 0) return NULL ;
  801652:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801656:	75 07                	jne    80165f <malloc+0x18>
  801658:	b8 00 00 00 00       	mov    $0x0,%eax
  80165d:	eb 7f                	jmp    8016de <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80165f:	e8 d2 08 00 00       	call   801f36 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801664:	85 c0                	test   %eax,%eax
  801666:	74 71                	je     8016d9 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801668:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80166f:	8b 55 08             	mov    0x8(%ebp),%edx
  801672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801675:	01 d0                	add    %edx,%eax
  801677:	48                   	dec    %eax
  801678:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167e:	ba 00 00 00 00       	mov    $0x0,%edx
  801683:	f7 75 f4             	divl   -0xc(%ebp)
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	29 d0                	sub    %edx,%eax
  80168b:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80168e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801695:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80169c:	76 07                	jbe    8016a5 <malloc+0x5e>
					return NULL ;
  80169e:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a3:	eb 39                	jmp    8016de <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  8016a5:	83 ec 0c             	sub    $0xc,%esp
  8016a8:	ff 75 08             	pushl  0x8(%ebp)
  8016ab:	e8 e6 0d 00 00       	call   802496 <alloc_block_FF>
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8016b6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016ba:	74 16                	je     8016d2 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8016bc:	83 ec 0c             	sub    $0xc,%esp
  8016bf:	ff 75 ec             	pushl  -0x14(%ebp)
  8016c2:	e8 37 0c 00 00       	call   8022fe <insert_sorted_allocList>
  8016c7:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8016ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cd:	8b 40 08             	mov    0x8(%eax),%eax
  8016d0:	eb 0c                	jmp    8016de <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d7:	eb 05                	jmp    8016de <malloc+0x97>
				}
		}
	return 0;
  8016d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016de:	c9                   	leave  
  8016df:	c3                   	ret    

008016e0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8016e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8016ec:	83 ec 08             	sub    $0x8,%esp
  8016ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f2:	68 40 40 80 00       	push   $0x804040
  8016f7:	e8 cf 0b 00 00       	call   8022cb <find_block>
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801705:	8b 40 0c             	mov    0xc(%eax),%eax
  801708:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  80170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170e:	8b 40 08             	mov    0x8(%eax),%eax
  801711:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801714:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801718:	0f 84 a1 00 00 00    	je     8017bf <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  80171e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801722:	75 17                	jne    80173b <free+0x5b>
  801724:	83 ec 04             	sub    $0x4,%esp
  801727:	68 d5 3c 80 00       	push   $0x803cd5
  80172c:	68 80 00 00 00       	push   $0x80
  801731:	68 f3 3c 80 00       	push   $0x803cf3
  801736:	e8 b9 ec ff ff       	call   8003f4 <_panic>
  80173b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173e:	8b 00                	mov    (%eax),%eax
  801740:	85 c0                	test   %eax,%eax
  801742:	74 10                	je     801754 <free+0x74>
  801744:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801747:	8b 00                	mov    (%eax),%eax
  801749:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174c:	8b 52 04             	mov    0x4(%edx),%edx
  80174f:	89 50 04             	mov    %edx,0x4(%eax)
  801752:	eb 0b                	jmp    80175f <free+0x7f>
  801754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801757:	8b 40 04             	mov    0x4(%eax),%eax
  80175a:	a3 44 40 80 00       	mov    %eax,0x804044
  80175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801762:	8b 40 04             	mov    0x4(%eax),%eax
  801765:	85 c0                	test   %eax,%eax
  801767:	74 0f                	je     801778 <free+0x98>
  801769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80176c:	8b 40 04             	mov    0x4(%eax),%eax
  80176f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801772:	8b 12                	mov    (%edx),%edx
  801774:	89 10                	mov    %edx,(%eax)
  801776:	eb 0a                	jmp    801782 <free+0xa2>
  801778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177b:	8b 00                	mov    (%eax),%eax
  80177d:	a3 40 40 80 00       	mov    %eax,0x804040
  801782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801785:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80178b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801795:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80179a:	48                   	dec    %eax
  80179b:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  8017a0:	83 ec 0c             	sub    $0xc,%esp
  8017a3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017a6:	e8 29 12 00 00       	call   8029d4 <insert_sorted_with_merge_freeList>
  8017ab:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  8017ae:	83 ec 08             	sub    $0x8,%esp
  8017b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8017b4:	ff 75 e8             	pushl  -0x18(%ebp)
  8017b7:	e8 74 03 00 00       	call   801b30 <sys_free_user_mem>
  8017bc:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8017bf:	90                   	nop
  8017c0:	c9                   	leave  
  8017c1:	c3                   	ret    

008017c2 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 38             	sub    $0x38,%esp
  8017c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017cb:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ce:	e8 5f fc ff ff       	call   801432 <InitializeUHeap>
	if (size == 0) return NULL ;
  8017d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017d7:	75 0a                	jne    8017e3 <smalloc+0x21>
  8017d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017de:	e9 b2 00 00 00       	jmp    801895 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8017e3:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8017ea:	76 0a                	jbe    8017f6 <smalloc+0x34>
		return NULL;
  8017ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f1:	e9 9f 00 00 00       	jmp    801895 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017f6:	e8 3b 07 00 00       	call   801f36 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	0f 84 8d 00 00 00    	je     801890 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801803:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80180a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801811:	8b 55 0c             	mov    0xc(%ebp),%edx
  801814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801817:	01 d0                	add    %edx,%eax
  801819:	48                   	dec    %eax
  80181a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80181d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801820:	ba 00 00 00 00       	mov    $0x0,%edx
  801825:	f7 75 f0             	divl   -0x10(%ebp)
  801828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80182b:	29 d0                	sub    %edx,%eax
  80182d:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801830:	83 ec 0c             	sub    $0xc,%esp
  801833:	ff 75 e8             	pushl  -0x18(%ebp)
  801836:	e8 5b 0c 00 00       	call   802496 <alloc_block_FF>
  80183b:	83 c4 10             	add    $0x10,%esp
  80183e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801841:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801845:	75 07                	jne    80184e <smalloc+0x8c>
			return NULL;
  801847:	b8 00 00 00 00       	mov    $0x0,%eax
  80184c:	eb 47                	jmp    801895 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  80184e:	83 ec 0c             	sub    $0xc,%esp
  801851:	ff 75 f4             	pushl  -0xc(%ebp)
  801854:	e8 a5 0a 00 00       	call   8022fe <insert_sorted_allocList>
  801859:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80185c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185f:	8b 40 08             	mov    0x8(%eax),%eax
  801862:	89 c2                	mov    %eax,%edx
  801864:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801868:	52                   	push   %edx
  801869:	50                   	push   %eax
  80186a:	ff 75 0c             	pushl  0xc(%ebp)
  80186d:	ff 75 08             	pushl  0x8(%ebp)
  801870:	e8 46 04 00 00       	call   801cbb <sys_createSharedObject>
  801875:	83 c4 10             	add    $0x10,%esp
  801878:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80187b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80187f:	78 08                	js     801889 <smalloc+0xc7>
		return (void *)b->sva;
  801881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801884:	8b 40 08             	mov    0x8(%eax),%eax
  801887:	eb 0c                	jmp    801895 <smalloc+0xd3>
		}else{
		return NULL;
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	eb 05                	jmp    801895 <smalloc+0xd3>
			}

	}return NULL;
  801890:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80189d:	e8 90 fb ff ff       	call   801432 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8018a2:	e8 8f 06 00 00       	call   801f36 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	0f 84 ad 00 00 00    	je     80195c <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8018af:	83 ec 08             	sub    $0x8,%esp
  8018b2:	ff 75 0c             	pushl  0xc(%ebp)
  8018b5:	ff 75 08             	pushl  0x8(%ebp)
  8018b8:	e8 28 04 00 00       	call   801ce5 <sys_getSizeOfSharedObject>
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8018c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8018c7:	79 0a                	jns    8018d3 <sget+0x3c>
    {
    	return NULL;
  8018c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8018ce:	e9 8e 00 00 00       	jmp    801961 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8018d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8018da:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8018e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8018e7:	01 d0                	add    %edx,%eax
  8018e9:	48                   	dec    %eax
  8018ea:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8018ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f5:	f7 75 ec             	divl   -0x14(%ebp)
  8018f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018fb:	29 d0                	sub    %edx,%eax
  8018fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801900:	83 ec 0c             	sub    $0xc,%esp
  801903:	ff 75 e4             	pushl  -0x1c(%ebp)
  801906:	e8 8b 0b 00 00       	call   802496 <alloc_block_FF>
  80190b:	83 c4 10             	add    $0x10,%esp
  80190e:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801911:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801915:	75 07                	jne    80191e <sget+0x87>
				return NULL;
  801917:	b8 00 00 00 00       	mov    $0x0,%eax
  80191c:	eb 43                	jmp    801961 <sget+0xca>
			}
			insert_sorted_allocList(b);
  80191e:	83 ec 0c             	sub    $0xc,%esp
  801921:	ff 75 f0             	pushl  -0x10(%ebp)
  801924:	e8 d5 09 00 00       	call   8022fe <insert_sorted_allocList>
  801929:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  80192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192f:	8b 40 08             	mov    0x8(%eax),%eax
  801932:	83 ec 04             	sub    $0x4,%esp
  801935:	50                   	push   %eax
  801936:	ff 75 0c             	pushl  0xc(%ebp)
  801939:	ff 75 08             	pushl  0x8(%ebp)
  80193c:	e8 c1 03 00 00       	call   801d02 <sys_getSharedObject>
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801947:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80194b:	78 08                	js     801955 <sget+0xbe>
			return (void *)b->sva;
  80194d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801950:	8b 40 08             	mov    0x8(%eax),%eax
  801953:	eb 0c                	jmp    801961 <sget+0xca>
			}else{
			return NULL;
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	eb 05                	jmp    801961 <sget+0xca>
			}
    }}return NULL;
  80195c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801969:	e8 c4 fa ff ff       	call   801432 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	68 24 3d 80 00       	push   $0x803d24
  801976:	68 03 01 00 00       	push   $0x103
  80197b:	68 f3 3c 80 00       	push   $0x803cf3
  801980:	e8 6f ea ff ff       	call   8003f4 <_panic>

00801985 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80198b:	83 ec 04             	sub    $0x4,%esp
  80198e:	68 4c 3d 80 00       	push   $0x803d4c
  801993:	68 17 01 00 00       	push   $0x117
  801998:	68 f3 3c 80 00       	push   $0x803cf3
  80199d:	e8 52 ea ff ff       	call   8003f4 <_panic>

008019a2 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019a8:	83 ec 04             	sub    $0x4,%esp
  8019ab:	68 70 3d 80 00       	push   $0x803d70
  8019b0:	68 22 01 00 00       	push   $0x122
  8019b5:	68 f3 3c 80 00       	push   $0x803cf3
  8019ba:	e8 35 ea ff ff       	call   8003f4 <_panic>

008019bf <shrink>:

}
void shrink(uint32 newSize)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019c5:	83 ec 04             	sub    $0x4,%esp
  8019c8:	68 70 3d 80 00       	push   $0x803d70
  8019cd:	68 27 01 00 00       	push   $0x127
  8019d2:	68 f3 3c 80 00       	push   $0x803cf3
  8019d7:	e8 18 ea ff ff       	call   8003f4 <_panic>

008019dc <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
  8019df:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	68 70 3d 80 00       	push   $0x803d70
  8019ea:	68 2c 01 00 00       	push   $0x12c
  8019ef:	68 f3 3c 80 00       	push   $0x803cf3
  8019f4:	e8 fb e9 ff ff       	call   8003f4 <_panic>

008019f9 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	57                   	push   %edi
  8019fd:	56                   	push   %esi
  8019fe:	53                   	push   %ebx
  8019ff:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a02:	8b 45 08             	mov    0x8(%ebp),%eax
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a0b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a0e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801a11:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801a14:	cd 30                	int    $0x30
  801a16:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	5b                   	pop    %ebx
  801a20:	5e                   	pop    %esi
  801a21:	5f                   	pop    %edi
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    

00801a24 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 04             	sub    $0x4,%esp
  801a2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801a30:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	52                   	push   %edx
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	50                   	push   %eax
  801a40:	6a 00                	push   $0x0
  801a42:	e8 b2 ff ff ff       	call   8019f9 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	90                   	nop
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_cgetc>:

int
sys_cgetc(void)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 01                	push   $0x1
  801a5c:	e8 98 ff ff ff       	call   8019f9 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	52                   	push   %edx
  801a76:	50                   	push   %eax
  801a77:	6a 05                	push   $0x5
  801a79:	e8 7b ff ff ff       	call   8019f9 <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	56                   	push   %esi
  801a87:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a88:	8b 75 18             	mov    0x18(%ebp),%esi
  801a8b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	56                   	push   %esi
  801a98:	53                   	push   %ebx
  801a99:	51                   	push   %ecx
  801a9a:	52                   	push   %edx
  801a9b:	50                   	push   %eax
  801a9c:	6a 06                	push   $0x6
  801a9e:	e8 56 ff ff ff       	call   8019f9 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aa9:	5b                   	pop    %ebx
  801aaa:	5e                   	pop    %esi
  801aab:	5d                   	pop    %ebp
  801aac:	c3                   	ret    

00801aad <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	52                   	push   %edx
  801abd:	50                   	push   %eax
  801abe:	6a 07                	push   $0x7
  801ac0:	e8 34 ff ff ff       	call   8019f9 <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	ff 75 0c             	pushl  0xc(%ebp)
  801ad6:	ff 75 08             	pushl  0x8(%ebp)
  801ad9:	6a 08                	push   $0x8
  801adb:	e8 19 ff ff ff       	call   8019f9 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 09                	push   $0x9
  801af4:	e8 00 ff ff ff       	call   8019f9 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 0a                	push   $0xa
  801b0d:	e8 e7 fe ff ff       	call   8019f9 <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
}
  801b15:	c9                   	leave  
  801b16:	c3                   	ret    

00801b17 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801b17:	55                   	push   %ebp
  801b18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 0b                	push   $0xb
  801b26:	e8 ce fe ff ff       	call   8019f9 <syscall>
  801b2b:	83 c4 18             	add    $0x18,%esp
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	ff 75 0c             	pushl  0xc(%ebp)
  801b3c:	ff 75 08             	pushl  0x8(%ebp)
  801b3f:	6a 0f                	push   $0xf
  801b41:	e8 b3 fe ff ff       	call   8019f9 <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
	return;
  801b49:	90                   	nop
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	ff 75 08             	pushl  0x8(%ebp)
  801b5b:	6a 10                	push   $0x10
  801b5d:	e8 97 fe ff ff       	call   8019f9 <syscall>
  801b62:	83 c4 18             	add    $0x18,%esp
	return ;
  801b65:	90                   	nop
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	ff 75 10             	pushl  0x10(%ebp)
  801b72:	ff 75 0c             	pushl  0xc(%ebp)
  801b75:	ff 75 08             	pushl  0x8(%ebp)
  801b78:	6a 11                	push   $0x11
  801b7a:	e8 7a fe ff ff       	call   8019f9 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b82:	90                   	nop
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 0c                	push   $0xc
  801b94:	e8 60 fe ff ff       	call   8019f9 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	ff 75 08             	pushl  0x8(%ebp)
  801bac:	6a 0d                	push   $0xd
  801bae:	e8 46 fe ff ff       	call   8019f9 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 0e                	push   $0xe
  801bc7:	e8 2d fe ff ff       	call   8019f9 <syscall>
  801bcc:	83 c4 18             	add    $0x18,%esp
}
  801bcf:	90                   	nop
  801bd0:	c9                   	leave  
  801bd1:	c3                   	ret    

00801bd2 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801bd2:	55                   	push   %ebp
  801bd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 13                	push   $0x13
  801be1:	e8 13 fe ff ff       	call   8019f9 <syscall>
  801be6:	83 c4 18             	add    $0x18,%esp
}
  801be9:	90                   	nop
  801bea:	c9                   	leave  
  801beb:	c3                   	ret    

00801bec <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801bec:	55                   	push   %ebp
  801bed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 14                	push   $0x14
  801bfb:	e8 f9 fd ff ff       	call   8019f9 <syscall>
  801c00:	83 c4 18             	add    $0x18,%esp
}
  801c03:	90                   	nop
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_cputc>:


void
sys_cputc(const char c)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
  801c09:	83 ec 04             	sub    $0x4,%esp
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801c12:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	50                   	push   %eax
  801c1f:	6a 15                	push   $0x15
  801c21:	e8 d3 fd ff ff       	call   8019f9 <syscall>
  801c26:	83 c4 18             	add    $0x18,%esp
}
  801c29:	90                   	nop
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 16                	push   $0x16
  801c3b:	e8 b9 fd ff ff       	call   8019f9 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	ff 75 0c             	pushl  0xc(%ebp)
  801c55:	50                   	push   %eax
  801c56:	6a 17                	push   $0x17
  801c58:	e8 9c fd ff ff       	call   8019f9 <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	52                   	push   %edx
  801c72:	50                   	push   %eax
  801c73:	6a 1a                	push   $0x1a
  801c75:	e8 7f fd ff ff       	call   8019f9 <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	52                   	push   %edx
  801c8f:	50                   	push   %eax
  801c90:	6a 18                	push   $0x18
  801c92:	e8 62 fd ff ff       	call   8019f9 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
}
  801c9a:	90                   	nop
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ca0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	52                   	push   %edx
  801cad:	50                   	push   %eax
  801cae:	6a 19                	push   $0x19
  801cb0:	e8 44 fd ff ff       	call   8019f9 <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	90                   	nop
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	83 ec 04             	sub    $0x4,%esp
  801cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc4:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801cc7:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801cca:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	6a 00                	push   $0x0
  801cd3:	51                   	push   %ecx
  801cd4:	52                   	push   %edx
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	50                   	push   %eax
  801cd9:	6a 1b                	push   $0x1b
  801cdb:	e8 19 fd ff ff       	call   8019f9 <syscall>
  801ce0:	83 c4 18             	add    $0x18,%esp
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ce8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	52                   	push   %edx
  801cf5:	50                   	push   %eax
  801cf6:	6a 1c                	push   $0x1c
  801cf8:	e8 fc fc ff ff       	call   8019f9 <syscall>
  801cfd:	83 c4 18             	add    $0x18,%esp
}
  801d00:	c9                   	leave  
  801d01:	c3                   	ret    

00801d02 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801d02:	55                   	push   %ebp
  801d03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801d05:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d08:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	51                   	push   %ecx
  801d13:	52                   	push   %edx
  801d14:	50                   	push   %eax
  801d15:	6a 1d                	push   $0x1d
  801d17:	e8 dd fc ff ff       	call   8019f9 <syscall>
  801d1c:	83 c4 18             	add    $0x18,%esp
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801d24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	52                   	push   %edx
  801d31:	50                   	push   %eax
  801d32:	6a 1e                	push   $0x1e
  801d34:	e8 c0 fc ff ff       	call   8019f9 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 1f                	push   $0x1f
  801d4d:	e8 a7 fc ff ff       	call   8019f9 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	6a 00                	push   $0x0
  801d5f:	ff 75 14             	pushl  0x14(%ebp)
  801d62:	ff 75 10             	pushl  0x10(%ebp)
  801d65:	ff 75 0c             	pushl  0xc(%ebp)
  801d68:	50                   	push   %eax
  801d69:	6a 20                	push   $0x20
  801d6b:	e8 89 fc ff ff       	call   8019f9 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
}
  801d73:	c9                   	leave  
  801d74:	c3                   	ret    

00801d75 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	50                   	push   %eax
  801d84:	6a 21                	push   $0x21
  801d86:	e8 6e fc ff ff       	call   8019f9 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	90                   	nop
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	50                   	push   %eax
  801da0:	6a 22                	push   $0x22
  801da2:	e8 52 fc ff ff       	call   8019f9 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_getenvid>:

int32 sys_getenvid(void)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 02                	push   $0x2
  801dbb:	e8 39 fc ff ff       	call   8019f9 <syscall>
  801dc0:	83 c4 18             	add    $0x18,%esp
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 03                	push   $0x3
  801dd4:	e8 20 fc ff ff       	call   8019f9 <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 04                	push   $0x4
  801ded:	e8 07 fc ff ff       	call   8019f9 <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_exit_env>:


void sys_exit_env(void)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 23                	push   $0x23
  801e06:	e8 ee fb ff ff       	call   8019f9 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
}
  801e0e:	90                   	nop
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801e17:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e1a:	8d 50 04             	lea    0x4(%eax),%edx
  801e1d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	52                   	push   %edx
  801e27:	50                   	push   %eax
  801e28:	6a 24                	push   $0x24
  801e2a:	e8 ca fb ff ff       	call   8019f9 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
	return result;
  801e32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801e35:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801e38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801e3b:	89 01                	mov    %eax,(%ecx)
  801e3d:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801e40:	8b 45 08             	mov    0x8(%ebp),%eax
  801e43:	c9                   	leave  
  801e44:	c2 04 00             	ret    $0x4

00801e47 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801e47:	55                   	push   %ebp
  801e48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	ff 75 10             	pushl  0x10(%ebp)
  801e51:	ff 75 0c             	pushl  0xc(%ebp)
  801e54:	ff 75 08             	pushl  0x8(%ebp)
  801e57:	6a 12                	push   $0x12
  801e59:	e8 9b fb ff ff       	call   8019f9 <syscall>
  801e5e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e61:	90                   	nop
}
  801e62:	c9                   	leave  
  801e63:	c3                   	ret    

00801e64 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e64:	55                   	push   %ebp
  801e65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 25                	push   $0x25
  801e73:	e8 81 fb ff ff       	call   8019f9 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 04             	sub    $0x4,%esp
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e89:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	50                   	push   %eax
  801e96:	6a 26                	push   $0x26
  801e98:	e8 5c fb ff ff       	call   8019f9 <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea0:	90                   	nop
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <rsttst>:
void rsttst()
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 28                	push   $0x28
  801eb2:	e8 42 fb ff ff       	call   8019f9 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
	return ;
  801eba:	90                   	nop
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 04             	sub    $0x4,%esp
  801ec3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ec6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ec9:	8b 55 18             	mov    0x18(%ebp),%edx
  801ecc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ed0:	52                   	push   %edx
  801ed1:	50                   	push   %eax
  801ed2:	ff 75 10             	pushl  0x10(%ebp)
  801ed5:	ff 75 0c             	pushl  0xc(%ebp)
  801ed8:	ff 75 08             	pushl  0x8(%ebp)
  801edb:	6a 27                	push   $0x27
  801edd:	e8 17 fb ff ff       	call   8019f9 <syscall>
  801ee2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ee5:	90                   	nop
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <chktst>:
void chktst(uint32 n)
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 00                	push   $0x0
  801ef1:	6a 00                	push   $0x0
  801ef3:	ff 75 08             	pushl  0x8(%ebp)
  801ef6:	6a 29                	push   $0x29
  801ef8:	e8 fc fa ff ff       	call   8019f9 <syscall>
  801efd:	83 c4 18             	add    $0x18,%esp
	return ;
  801f00:	90                   	nop
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <inctst>:

void inctst()
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801f06:	6a 00                	push   $0x0
  801f08:	6a 00                	push   $0x0
  801f0a:	6a 00                	push   $0x0
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 2a                	push   $0x2a
  801f12:	e8 e2 fa ff ff       	call   8019f9 <syscall>
  801f17:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1a:	90                   	nop
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <gettst>:
uint32 gettst()
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 2b                	push   $0x2b
  801f2c:	e8 c8 fa ff ff       	call   8019f9 <syscall>
  801f31:	83 c4 18             	add    $0x18,%esp
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 2c                	push   $0x2c
  801f48:	e8 ac fa ff ff       	call   8019f9 <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
  801f50:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801f53:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f57:	75 07                	jne    801f60 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f59:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5e:	eb 05                	jmp    801f65 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f65:	c9                   	leave  
  801f66:	c3                   	ret    

00801f67 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 2c                	push   $0x2c
  801f79:	e8 7b fa ff ff       	call   8019f9 <syscall>
  801f7e:	83 c4 18             	add    $0x18,%esp
  801f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f84:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f88:	75 07                	jne    801f91 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8f:	eb 05                	jmp    801f96 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 00                	push   $0x0
  801fa2:	6a 00                	push   $0x0
  801fa4:	6a 00                	push   $0x0
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 2c                	push   $0x2c
  801faa:	e8 4a fa ff ff       	call   8019f9 <syscall>
  801faf:	83 c4 18             	add    $0x18,%esp
  801fb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801fb5:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801fb9:	75 07                	jne    801fc2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801fbb:	b8 01 00 00 00       	mov    $0x1,%eax
  801fc0:	eb 05                	jmp    801fc7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801fc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fc7:	c9                   	leave  
  801fc8:	c3                   	ret    

00801fc9 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801fc9:	55                   	push   %ebp
  801fca:	89 e5                	mov    %esp,%ebp
  801fcc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801fcf:	6a 00                	push   $0x0
  801fd1:	6a 00                	push   $0x0
  801fd3:	6a 00                	push   $0x0
  801fd5:	6a 00                	push   $0x0
  801fd7:	6a 00                	push   $0x0
  801fd9:	6a 2c                	push   $0x2c
  801fdb:	e8 19 fa ff ff       	call   8019f9 <syscall>
  801fe0:	83 c4 18             	add    $0x18,%esp
  801fe3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801fe6:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801fea:	75 07                	jne    801ff3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801fec:	b8 01 00 00 00       	mov    $0x1,%eax
  801ff1:	eb 05                	jmp    801ff8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ff3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	ff 75 08             	pushl  0x8(%ebp)
  802008:	6a 2d                	push   $0x2d
  80200a:	e8 ea f9 ff ff       	call   8019f9 <syscall>
  80200f:	83 c4 18             	add    $0x18,%esp
	return ;
  802012:	90                   	nop
}
  802013:	c9                   	leave  
  802014:	c3                   	ret    

00802015 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802019:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80201c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80201f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802022:	8b 45 08             	mov    0x8(%ebp),%eax
  802025:	6a 00                	push   $0x0
  802027:	53                   	push   %ebx
  802028:	51                   	push   %ecx
  802029:	52                   	push   %edx
  80202a:	50                   	push   %eax
  80202b:	6a 2e                	push   $0x2e
  80202d:	e8 c7 f9 ff ff       	call   8019f9 <syscall>
  802032:	83 c4 18             	add    $0x18,%esp
}
  802035:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802038:	c9                   	leave  
  802039:	c3                   	ret    

0080203a <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80203d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	6a 00                	push   $0x0
  802045:	6a 00                	push   $0x0
  802047:	6a 00                	push   $0x0
  802049:	52                   	push   %edx
  80204a:	50                   	push   %eax
  80204b:	6a 2f                	push   $0x2f
  80204d:	e8 a7 f9 ff ff       	call   8019f9 <syscall>
  802052:	83 c4 18             	add    $0x18,%esp
}
  802055:	c9                   	leave  
  802056:	c3                   	ret    

00802057 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802057:	55                   	push   %ebp
  802058:	89 e5                	mov    %esp,%ebp
  80205a:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80205d:	83 ec 0c             	sub    $0xc,%esp
  802060:	68 80 3d 80 00       	push   $0x803d80
  802065:	e8 3e e6 ff ff       	call   8006a8 <cprintf>
  80206a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80206d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802074:	83 ec 0c             	sub    $0xc,%esp
  802077:	68 ac 3d 80 00       	push   $0x803dac
  80207c:	e8 27 e6 ff ff       	call   8006a8 <cprintf>
  802081:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802084:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802088:	a1 38 41 80 00       	mov    0x804138,%eax
  80208d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802090:	eb 56                	jmp    8020e8 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802092:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802096:	74 1c                	je     8020b4 <print_mem_block_lists+0x5d>
  802098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209b:	8b 50 08             	mov    0x8(%eax),%edx
  80209e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a1:	8b 48 08             	mov    0x8(%eax),%ecx
  8020a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8020aa:	01 c8                	add    %ecx,%eax
  8020ac:	39 c2                	cmp    %eax,%edx
  8020ae:	73 04                	jae    8020b4 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8020b0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b7:	8b 50 08             	mov    0x8(%eax),%edx
  8020ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c0:	01 c2                	add    %eax,%edx
  8020c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c5:	8b 40 08             	mov    0x8(%eax),%eax
  8020c8:	83 ec 04             	sub    $0x4,%esp
  8020cb:	52                   	push   %edx
  8020cc:	50                   	push   %eax
  8020cd:	68 c1 3d 80 00       	push   $0x803dc1
  8020d2:	e8 d1 e5 ff ff       	call   8006a8 <cprintf>
  8020d7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8020e0:	a1 40 41 80 00       	mov    0x804140,%eax
  8020e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ec:	74 07                	je     8020f5 <print_mem_block_lists+0x9e>
  8020ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f1:	8b 00                	mov    (%eax),%eax
  8020f3:	eb 05                	jmp    8020fa <print_mem_block_lists+0xa3>
  8020f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020fa:	a3 40 41 80 00       	mov    %eax,0x804140
  8020ff:	a1 40 41 80 00       	mov    0x804140,%eax
  802104:	85 c0                	test   %eax,%eax
  802106:	75 8a                	jne    802092 <print_mem_block_lists+0x3b>
  802108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80210c:	75 84                	jne    802092 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80210e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802112:	75 10                	jne    802124 <print_mem_block_lists+0xcd>
  802114:	83 ec 0c             	sub    $0xc,%esp
  802117:	68 d0 3d 80 00       	push   $0x803dd0
  80211c:	e8 87 e5 ff ff       	call   8006a8 <cprintf>
  802121:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802124:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80212b:	83 ec 0c             	sub    $0xc,%esp
  80212e:	68 f4 3d 80 00       	push   $0x803df4
  802133:	e8 70 e5 ff ff       	call   8006a8 <cprintf>
  802138:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80213b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80213f:	a1 40 40 80 00       	mov    0x804040,%eax
  802144:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802147:	eb 56                	jmp    80219f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80214d:	74 1c                	je     80216b <print_mem_block_lists+0x114>
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	8b 50 08             	mov    0x8(%eax),%edx
  802155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802158:	8b 48 08             	mov    0x8(%eax),%ecx
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	8b 40 0c             	mov    0xc(%eax),%eax
  802161:	01 c8                	add    %ecx,%eax
  802163:	39 c2                	cmp    %eax,%edx
  802165:	73 04                	jae    80216b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802167:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80216b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216e:	8b 50 08             	mov    0x8(%eax),%edx
  802171:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802174:	8b 40 0c             	mov    0xc(%eax),%eax
  802177:	01 c2                	add    %eax,%edx
  802179:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217c:	8b 40 08             	mov    0x8(%eax),%eax
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	52                   	push   %edx
  802183:	50                   	push   %eax
  802184:	68 c1 3d 80 00       	push   $0x803dc1
  802189:	e8 1a e5 ff ff       	call   8006a8 <cprintf>
  80218e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802194:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802197:	a1 48 40 80 00       	mov    0x804048,%eax
  80219c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80219f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021a3:	74 07                	je     8021ac <print_mem_block_lists+0x155>
  8021a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a8:	8b 00                	mov    (%eax),%eax
  8021aa:	eb 05                	jmp    8021b1 <print_mem_block_lists+0x15a>
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b1:	a3 48 40 80 00       	mov    %eax,0x804048
  8021b6:	a1 48 40 80 00       	mov    0x804048,%eax
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	75 8a                	jne    802149 <print_mem_block_lists+0xf2>
  8021bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c3:	75 84                	jne    802149 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8021c5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8021c9:	75 10                	jne    8021db <print_mem_block_lists+0x184>
  8021cb:	83 ec 0c             	sub    $0xc,%esp
  8021ce:	68 0c 3e 80 00       	push   $0x803e0c
  8021d3:	e8 d0 e4 ff ff       	call   8006a8 <cprintf>
  8021d8:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8021db:	83 ec 0c             	sub    $0xc,%esp
  8021de:	68 80 3d 80 00       	push   $0x803d80
  8021e3:	e8 c0 e4 ff ff       	call   8006a8 <cprintf>
  8021e8:	83 c4 10             	add    $0x10,%esp

}
  8021eb:	90                   	nop
  8021ec:	c9                   	leave  
  8021ed:	c3                   	ret    

008021ee <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
  8021f1:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8021f4:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021fb:	00 00 00 
  8021fe:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802205:	00 00 00 
  802208:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80220f:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802212:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802219:	e9 9e 00 00 00       	jmp    8022bc <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  80221e:	a1 50 40 80 00       	mov    0x804050,%eax
  802223:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802226:	c1 e2 04             	shl    $0x4,%edx
  802229:	01 d0                	add    %edx,%eax
  80222b:	85 c0                	test   %eax,%eax
  80222d:	75 14                	jne    802243 <initialize_MemBlocksList+0x55>
  80222f:	83 ec 04             	sub    $0x4,%esp
  802232:	68 34 3e 80 00       	push   $0x803e34
  802237:	6a 3d                	push   $0x3d
  802239:	68 57 3e 80 00       	push   $0x803e57
  80223e:	e8 b1 e1 ff ff       	call   8003f4 <_panic>
  802243:	a1 50 40 80 00       	mov    0x804050,%eax
  802248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224b:	c1 e2 04             	shl    $0x4,%edx
  80224e:	01 d0                	add    %edx,%eax
  802250:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802256:	89 10                	mov    %edx,(%eax)
  802258:	8b 00                	mov    (%eax),%eax
  80225a:	85 c0                	test   %eax,%eax
  80225c:	74 18                	je     802276 <initialize_MemBlocksList+0x88>
  80225e:	a1 48 41 80 00       	mov    0x804148,%eax
  802263:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802269:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80226c:	c1 e1 04             	shl    $0x4,%ecx
  80226f:	01 ca                	add    %ecx,%edx
  802271:	89 50 04             	mov    %edx,0x4(%eax)
  802274:	eb 12                	jmp    802288 <initialize_MemBlocksList+0x9a>
  802276:	a1 50 40 80 00       	mov    0x804050,%eax
  80227b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227e:	c1 e2 04             	shl    $0x4,%edx
  802281:	01 d0                	add    %edx,%eax
  802283:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802288:	a1 50 40 80 00       	mov    0x804050,%eax
  80228d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802290:	c1 e2 04             	shl    $0x4,%edx
  802293:	01 d0                	add    %edx,%eax
  802295:	a3 48 41 80 00       	mov    %eax,0x804148
  80229a:	a1 50 40 80 00       	mov    0x804050,%eax
  80229f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a2:	c1 e2 04             	shl    $0x4,%edx
  8022a5:	01 d0                	add    %edx,%eax
  8022a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022ae:	a1 54 41 80 00       	mov    0x804154,%eax
  8022b3:	40                   	inc    %eax
  8022b4:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8022b9:	ff 45 f4             	incl   -0xc(%ebp)
  8022bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022c2:	0f 82 56 ff ff ff    	jb     80221e <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8022c8:	90                   	nop
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
  8022ce:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	8b 00                	mov    (%eax),%eax
  8022d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8022d9:	eb 18                	jmp    8022f3 <find_block+0x28>

		if(tmp->sva == va){
  8022db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022de:	8b 40 08             	mov    0x8(%eax),%eax
  8022e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8022e4:	75 05                	jne    8022eb <find_block+0x20>
			return tmp ;
  8022e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022e9:	eb 11                	jmp    8022fc <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8022eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8022ee:	8b 00                	mov    (%eax),%eax
  8022f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8022f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022f7:	75 e2                	jne    8022db <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8022f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802304:	a1 40 40 80 00       	mov    0x804040,%eax
  802309:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  80230c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802311:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802314:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802318:	75 65                	jne    80237f <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  80231a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80231e:	75 14                	jne    802334 <insert_sorted_allocList+0x36>
  802320:	83 ec 04             	sub    $0x4,%esp
  802323:	68 34 3e 80 00       	push   $0x803e34
  802328:	6a 62                	push   $0x62
  80232a:	68 57 3e 80 00       	push   $0x803e57
  80232f:	e8 c0 e0 ff ff       	call   8003f4 <_panic>
  802334:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	89 10                	mov    %edx,(%eax)
  80233f:	8b 45 08             	mov    0x8(%ebp),%eax
  802342:	8b 00                	mov    (%eax),%eax
  802344:	85 c0                	test   %eax,%eax
  802346:	74 0d                	je     802355 <insert_sorted_allocList+0x57>
  802348:	a1 40 40 80 00       	mov    0x804040,%eax
  80234d:	8b 55 08             	mov    0x8(%ebp),%edx
  802350:	89 50 04             	mov    %edx,0x4(%eax)
  802353:	eb 08                	jmp    80235d <insert_sorted_allocList+0x5f>
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	a3 44 40 80 00       	mov    %eax,0x804044
  80235d:	8b 45 08             	mov    0x8(%ebp),%eax
  802360:	a3 40 40 80 00       	mov    %eax,0x804040
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802374:	40                   	inc    %eax
  802375:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80237a:	e9 14 01 00 00       	jmp    802493 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	8b 50 08             	mov    0x8(%eax),%edx
  802385:	a1 44 40 80 00       	mov    0x804044,%eax
  80238a:	8b 40 08             	mov    0x8(%eax),%eax
  80238d:	39 c2                	cmp    %eax,%edx
  80238f:	76 65                	jbe    8023f6 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802391:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802395:	75 14                	jne    8023ab <insert_sorted_allocList+0xad>
  802397:	83 ec 04             	sub    $0x4,%esp
  80239a:	68 70 3e 80 00       	push   $0x803e70
  80239f:	6a 64                	push   $0x64
  8023a1:	68 57 3e 80 00       	push   $0x803e57
  8023a6:	e8 49 e0 ff ff       	call   8003f4 <_panic>
  8023ab:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	89 50 04             	mov    %edx,0x4(%eax)
  8023b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ba:	8b 40 04             	mov    0x4(%eax),%eax
  8023bd:	85 c0                	test   %eax,%eax
  8023bf:	74 0c                	je     8023cd <insert_sorted_allocList+0xcf>
  8023c1:	a1 44 40 80 00       	mov    0x804044,%eax
  8023c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c9:	89 10                	mov    %edx,(%eax)
  8023cb:	eb 08                	jmp    8023d5 <insert_sorted_allocList+0xd7>
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	a3 40 40 80 00       	mov    %eax,0x804040
  8023d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d8:	a3 44 40 80 00       	mov    %eax,0x804044
  8023dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023eb:	40                   	inc    %eax
  8023ec:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8023f1:	e9 9d 00 00 00       	jmp    802493 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8023f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8023fd:	e9 85 00 00 00       	jmp    802487 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	8b 50 08             	mov    0x8(%eax),%edx
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 40 08             	mov    0x8(%eax),%eax
  80240e:	39 c2                	cmp    %eax,%edx
  802410:	73 6a                	jae    80247c <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802412:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802416:	74 06                	je     80241e <insert_sorted_allocList+0x120>
  802418:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80241c:	75 14                	jne    802432 <insert_sorted_allocList+0x134>
  80241e:	83 ec 04             	sub    $0x4,%esp
  802421:	68 94 3e 80 00       	push   $0x803e94
  802426:	6a 6b                	push   $0x6b
  802428:	68 57 3e 80 00       	push   $0x803e57
  80242d:	e8 c2 df ff ff       	call   8003f4 <_panic>
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	8b 50 04             	mov    0x4(%eax),%edx
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	89 50 04             	mov    %edx,0x4(%eax)
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802444:	89 10                	mov    %edx,(%eax)
  802446:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802449:	8b 40 04             	mov    0x4(%eax),%eax
  80244c:	85 c0                	test   %eax,%eax
  80244e:	74 0d                	je     80245d <insert_sorted_allocList+0x15f>
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 40 04             	mov    0x4(%eax),%eax
  802456:	8b 55 08             	mov    0x8(%ebp),%edx
  802459:	89 10                	mov    %edx,(%eax)
  80245b:	eb 08                	jmp    802465 <insert_sorted_allocList+0x167>
  80245d:	8b 45 08             	mov    0x8(%ebp),%eax
  802460:	a3 40 40 80 00       	mov    %eax,0x804040
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 55 08             	mov    0x8(%ebp),%edx
  80246b:	89 50 04             	mov    %edx,0x4(%eax)
  80246e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802473:	40                   	inc    %eax
  802474:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802479:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80247a:	eb 17                	jmp    802493 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802484:	ff 45 f0             	incl   -0x10(%ebp)
  802487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80248d:	0f 8c 6f ff ff ff    	jl     802402 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802493:	90                   	nop
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80249c:	a1 38 41 80 00       	mov    0x804138,%eax
  8024a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8024a4:	e9 7c 01 00 00       	jmp    802625 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8024af:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b2:	0f 86 cf 00 00 00    	jbe    802587 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8024b8:	a1 48 41 80 00       	mov    0x804148,%eax
  8024bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8024c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8024cc:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 50 08             	mov    0x8(%eax),%edx
  8024d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d8:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8024db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024de:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e1:	2b 45 08             	sub    0x8(%ebp),%eax
  8024e4:	89 c2                	mov    %eax,%edx
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8024ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ef:	8b 50 08             	mov    0x8(%eax),%edx
  8024f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f5:	01 c2                	add    %eax,%edx
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8024fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802501:	75 17                	jne    80251a <alloc_block_FF+0x84>
  802503:	83 ec 04             	sub    $0x4,%esp
  802506:	68 c9 3e 80 00       	push   $0x803ec9
  80250b:	68 83 00 00 00       	push   $0x83
  802510:	68 57 3e 80 00       	push   $0x803e57
  802515:	e8 da de ff ff       	call   8003f4 <_panic>
  80251a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251d:	8b 00                	mov    (%eax),%eax
  80251f:	85 c0                	test   %eax,%eax
  802521:	74 10                	je     802533 <alloc_block_FF+0x9d>
  802523:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80252b:	8b 52 04             	mov    0x4(%edx),%edx
  80252e:	89 50 04             	mov    %edx,0x4(%eax)
  802531:	eb 0b                	jmp    80253e <alloc_block_FF+0xa8>
  802533:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802536:	8b 40 04             	mov    0x4(%eax),%eax
  802539:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80253e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802541:	8b 40 04             	mov    0x4(%eax),%eax
  802544:	85 c0                	test   %eax,%eax
  802546:	74 0f                	je     802557 <alloc_block_FF+0xc1>
  802548:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802551:	8b 12                	mov    (%edx),%edx
  802553:	89 10                	mov    %edx,(%eax)
  802555:	eb 0a                	jmp    802561 <alloc_block_FF+0xcb>
  802557:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	a3 48 41 80 00       	mov    %eax,0x804148
  802561:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80256d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802574:	a1 54 41 80 00       	mov    0x804154,%eax
  802579:	48                   	dec    %eax
  80257a:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  80257f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802582:	e9 ad 00 00 00       	jmp    802634 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 0c             	mov    0xc(%eax),%eax
  80258d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802590:	0f 85 87 00 00 00    	jne    80261d <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259a:	75 17                	jne    8025b3 <alloc_block_FF+0x11d>
  80259c:	83 ec 04             	sub    $0x4,%esp
  80259f:	68 c9 3e 80 00       	push   $0x803ec9
  8025a4:	68 87 00 00 00       	push   $0x87
  8025a9:	68 57 3e 80 00       	push   $0x803e57
  8025ae:	e8 41 de ff ff       	call   8003f4 <_panic>
  8025b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b6:	8b 00                	mov    (%eax),%eax
  8025b8:	85 c0                	test   %eax,%eax
  8025ba:	74 10                	je     8025cc <alloc_block_FF+0x136>
  8025bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bf:	8b 00                	mov    (%eax),%eax
  8025c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c4:	8b 52 04             	mov    0x4(%edx),%edx
  8025c7:	89 50 04             	mov    %edx,0x4(%eax)
  8025ca:	eb 0b                	jmp    8025d7 <alloc_block_FF+0x141>
  8025cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cf:	8b 40 04             	mov    0x4(%eax),%eax
  8025d2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025da:	8b 40 04             	mov    0x4(%eax),%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 0f                	je     8025f0 <alloc_block_FF+0x15a>
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 40 04             	mov    0x4(%eax),%eax
  8025e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ea:	8b 12                	mov    (%edx),%edx
  8025ec:	89 10                	mov    %edx,(%eax)
  8025ee:	eb 0a                	jmp    8025fa <alloc_block_FF+0x164>
  8025f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f3:	8b 00                	mov    (%eax),%eax
  8025f5:	a3 38 41 80 00       	mov    %eax,0x804138
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80260d:	a1 44 41 80 00       	mov    0x804144,%eax
  802612:	48                   	dec    %eax
  802613:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  802618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261b:	eb 17                	jmp    802634 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	8b 00                	mov    (%eax),%eax
  802622:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802629:	0f 85 7a fe ff ff    	jne    8024a9 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  80262f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  80263c:	a1 38 41 80 00       	mov    0x804138,%eax
  802641:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802644:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  80264b:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802652:	a1 38 41 80 00       	mov    0x804138,%eax
  802657:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80265a:	e9 d0 00 00 00       	jmp    80272f <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	8b 40 0c             	mov    0xc(%eax),%eax
  802665:	3b 45 08             	cmp    0x8(%ebp),%eax
  802668:	0f 82 b8 00 00 00    	jb     802726 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	8b 40 0c             	mov    0xc(%eax),%eax
  802674:	2b 45 08             	sub    0x8(%ebp),%eax
  802677:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80267a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80267d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802680:	0f 83 a1 00 00 00    	jae    802727 <alloc_block_BF+0xf1>
				differsize = differance ;
  802686:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802689:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80268c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268f:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802692:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802696:	0f 85 8b 00 00 00    	jne    802727 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80269c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a0:	75 17                	jne    8026b9 <alloc_block_BF+0x83>
  8026a2:	83 ec 04             	sub    $0x4,%esp
  8026a5:	68 c9 3e 80 00       	push   $0x803ec9
  8026aa:	68 a0 00 00 00       	push   $0xa0
  8026af:	68 57 3e 80 00       	push   $0x803e57
  8026b4:	e8 3b dd ff ff       	call   8003f4 <_panic>
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	8b 00                	mov    (%eax),%eax
  8026be:	85 c0                	test   %eax,%eax
  8026c0:	74 10                	je     8026d2 <alloc_block_BF+0x9c>
  8026c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c5:	8b 00                	mov    (%eax),%eax
  8026c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026ca:	8b 52 04             	mov    0x4(%edx),%edx
  8026cd:	89 50 04             	mov    %edx,0x4(%eax)
  8026d0:	eb 0b                	jmp    8026dd <alloc_block_BF+0xa7>
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 40 04             	mov    0x4(%eax),%eax
  8026d8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 40 04             	mov    0x4(%eax),%eax
  8026e3:	85 c0                	test   %eax,%eax
  8026e5:	74 0f                	je     8026f6 <alloc_block_BF+0xc0>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 40 04             	mov    0x4(%eax),%eax
  8026ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8026f0:	8b 12                	mov    (%edx),%edx
  8026f2:	89 10                	mov    %edx,(%eax)
  8026f4:	eb 0a                	jmp    802700 <alloc_block_BF+0xca>
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 00                	mov    (%eax),%eax
  8026fb:	a3 38 41 80 00       	mov    %eax,0x804138
  802700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802703:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802713:	a1 44 41 80 00       	mov    0x804144,%eax
  802718:	48                   	dec    %eax
  802719:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	e9 0c 01 00 00       	jmp    802832 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802726:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802727:	a1 40 41 80 00       	mov    0x804140,%eax
  80272c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80272f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802733:	74 07                	je     80273c <alloc_block_BF+0x106>
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	8b 00                	mov    (%eax),%eax
  80273a:	eb 05                	jmp    802741 <alloc_block_BF+0x10b>
  80273c:	b8 00 00 00 00       	mov    $0x0,%eax
  802741:	a3 40 41 80 00       	mov    %eax,0x804140
  802746:	a1 40 41 80 00       	mov    0x804140,%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	0f 85 0c ff ff ff    	jne    80265f <alloc_block_BF+0x29>
  802753:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802757:	0f 85 02 ff ff ff    	jne    80265f <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80275d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802761:	0f 84 c6 00 00 00    	je     80282d <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802767:	a1 48 41 80 00       	mov    0x804148,%eax
  80276c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80276f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802772:	8b 55 08             	mov    0x8(%ebp),%edx
  802775:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802778:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277b:	8b 50 08             	mov    0x8(%eax),%edx
  80277e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802781:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 40 0c             	mov    0xc(%eax),%eax
  80278a:	2b 45 08             	sub    0x8(%ebp),%eax
  80278d:	89 c2                	mov    %eax,%edx
  80278f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802792:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802795:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802798:	8b 50 08             	mov    0x8(%eax),%edx
  80279b:	8b 45 08             	mov    0x8(%ebp),%eax
  80279e:	01 c2                	add    %eax,%edx
  8027a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a3:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  8027a6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8027aa:	75 17                	jne    8027c3 <alloc_block_BF+0x18d>
  8027ac:	83 ec 04             	sub    $0x4,%esp
  8027af:	68 c9 3e 80 00       	push   $0x803ec9
  8027b4:	68 af 00 00 00       	push   $0xaf
  8027b9:	68 57 3e 80 00       	push   $0x803e57
  8027be:	e8 31 dc ff ff       	call   8003f4 <_panic>
  8027c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	74 10                	je     8027dc <alloc_block_BF+0x1a6>
  8027cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027cf:	8b 00                	mov    (%eax),%eax
  8027d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027d4:	8b 52 04             	mov    0x4(%edx),%edx
  8027d7:	89 50 04             	mov    %edx,0x4(%eax)
  8027da:	eb 0b                	jmp    8027e7 <alloc_block_BF+0x1b1>
  8027dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ea:	8b 40 04             	mov    0x4(%eax),%eax
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	74 0f                	je     802800 <alloc_block_BF+0x1ca>
  8027f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027f4:	8b 40 04             	mov    0x4(%eax),%eax
  8027f7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027fa:	8b 12                	mov    (%edx),%edx
  8027fc:	89 10                	mov    %edx,(%eax)
  8027fe:	eb 0a                	jmp    80280a <alloc_block_BF+0x1d4>
  802800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802803:	8b 00                	mov    (%eax),%eax
  802805:	a3 48 41 80 00       	mov    %eax,0x804148
  80280a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80280d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802813:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802816:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80281d:	a1 54 41 80 00       	mov    0x804154,%eax
  802822:	48                   	dec    %eax
  802823:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  802828:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80282b:	eb 05                	jmp    802832 <alloc_block_BF+0x1fc>
	}

	return NULL;
  80282d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802832:	c9                   	leave  
  802833:	c3                   	ret    

00802834 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802834:	55                   	push   %ebp
  802835:	89 e5                	mov    %esp,%ebp
  802837:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80283a:	a1 38 41 80 00       	mov    0x804138,%eax
  80283f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802842:	e9 7c 01 00 00       	jmp    8029c3 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 40 0c             	mov    0xc(%eax),%eax
  80284d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802850:	0f 86 cf 00 00 00    	jbe    802925 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802856:	a1 48 41 80 00       	mov    0x804148,%eax
  80285b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  80285e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802861:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802864:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802867:	8b 55 08             	mov    0x8(%ebp),%edx
  80286a:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80286d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802870:	8b 50 08             	mov    0x8(%eax),%edx
  802873:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802876:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802879:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287c:	8b 40 0c             	mov    0xc(%eax),%eax
  80287f:	2b 45 08             	sub    0x8(%ebp),%eax
  802882:	89 c2                	mov    %eax,%edx
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80288a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288d:	8b 50 08             	mov    0x8(%eax),%edx
  802890:	8b 45 08             	mov    0x8(%ebp),%eax
  802893:	01 c2                	add    %eax,%edx
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80289b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80289f:	75 17                	jne    8028b8 <alloc_block_NF+0x84>
  8028a1:	83 ec 04             	sub    $0x4,%esp
  8028a4:	68 c9 3e 80 00       	push   $0x803ec9
  8028a9:	68 c4 00 00 00       	push   $0xc4
  8028ae:	68 57 3e 80 00       	push   $0x803e57
  8028b3:	e8 3c db ff ff       	call   8003f4 <_panic>
  8028b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bb:	8b 00                	mov    (%eax),%eax
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	74 10                	je     8028d1 <alloc_block_NF+0x9d>
  8028c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c9:	8b 52 04             	mov    0x4(%edx),%edx
  8028cc:	89 50 04             	mov    %edx,0x4(%eax)
  8028cf:	eb 0b                	jmp    8028dc <alloc_block_NF+0xa8>
  8028d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d4:	8b 40 04             	mov    0x4(%eax),%eax
  8028d7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	74 0f                	je     8028f5 <alloc_block_NF+0xc1>
  8028e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e9:	8b 40 04             	mov    0x4(%eax),%eax
  8028ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ef:	8b 12                	mov    (%edx),%edx
  8028f1:	89 10                	mov    %edx,(%eax)
  8028f3:	eb 0a                	jmp    8028ff <alloc_block_NF+0xcb>
  8028f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802902:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802912:	a1 54 41 80 00       	mov    0x804154,%eax
  802917:	48                   	dec    %eax
  802918:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  80291d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802920:	e9 ad 00 00 00       	jmp    8029d2 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 40 0c             	mov    0xc(%eax),%eax
  80292b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292e:	0f 85 87 00 00 00    	jne    8029bb <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802934:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802938:	75 17                	jne    802951 <alloc_block_NF+0x11d>
  80293a:	83 ec 04             	sub    $0x4,%esp
  80293d:	68 c9 3e 80 00       	push   $0x803ec9
  802942:	68 c8 00 00 00       	push   $0xc8
  802947:	68 57 3e 80 00       	push   $0x803e57
  80294c:	e8 a3 da ff ff       	call   8003f4 <_panic>
  802951:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802954:	8b 00                	mov    (%eax),%eax
  802956:	85 c0                	test   %eax,%eax
  802958:	74 10                	je     80296a <alloc_block_NF+0x136>
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 00                	mov    (%eax),%eax
  80295f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802962:	8b 52 04             	mov    0x4(%edx),%edx
  802965:	89 50 04             	mov    %edx,0x4(%eax)
  802968:	eb 0b                	jmp    802975 <alloc_block_NF+0x141>
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 40 04             	mov    0x4(%eax),%eax
  802970:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802978:	8b 40 04             	mov    0x4(%eax),%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	74 0f                	je     80298e <alloc_block_NF+0x15a>
  80297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802982:	8b 40 04             	mov    0x4(%eax),%eax
  802985:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802988:	8b 12                	mov    (%edx),%edx
  80298a:	89 10                	mov    %edx,(%eax)
  80298c:	eb 0a                	jmp    802998 <alloc_block_NF+0x164>
  80298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	a3 38 41 80 00       	mov    %eax,0x804138
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ab:	a1 44 41 80 00       	mov    0x804144,%eax
  8029b0:	48                   	dec    %eax
  8029b1:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	eb 17                	jmp    8029d2 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8029bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029be:	8b 00                	mov    (%eax),%eax
  8029c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8029c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029c7:	0f 85 7a fe ff ff    	jne    802847 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8029cd:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8029d2:	c9                   	leave  
  8029d3:	c3                   	ret    

008029d4 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029d4:	55                   	push   %ebp
  8029d5:	89 e5                	mov    %esp,%ebp
  8029d7:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8029da:	a1 38 41 80 00       	mov    0x804138,%eax
  8029df:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8029e2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8029ea:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8029f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029f6:	75 68                	jne    802a60 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fc:	75 17                	jne    802a15 <insert_sorted_with_merge_freeList+0x41>
  8029fe:	83 ec 04             	sub    $0x4,%esp
  802a01:	68 34 3e 80 00       	push   $0x803e34
  802a06:	68 da 00 00 00       	push   $0xda
  802a0b:	68 57 3e 80 00       	push   $0x803e57
  802a10:	e8 df d9 ff ff       	call   8003f4 <_panic>
  802a15:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	89 10                	mov    %edx,(%eax)
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	85 c0                	test   %eax,%eax
  802a27:	74 0d                	je     802a36 <insert_sorted_with_merge_freeList+0x62>
  802a29:	a1 38 41 80 00       	mov    0x804138,%eax
  802a2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a31:	89 50 04             	mov    %edx,0x4(%eax)
  802a34:	eb 08                	jmp    802a3e <insert_sorted_with_merge_freeList+0x6a>
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a41:	a3 38 41 80 00       	mov    %eax,0x804138
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a50:	a1 44 41 80 00       	mov    0x804144,%eax
  802a55:	40                   	inc    %eax
  802a56:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802a5b:	e9 49 07 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802a60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a63:	8b 50 08             	mov    0x8(%eax),%edx
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6c:	01 c2                	add    %eax,%edx
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	8b 40 08             	mov    0x8(%eax),%eax
  802a74:	39 c2                	cmp    %eax,%edx
  802a76:	73 77                	jae    802aef <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7b:	8b 00                	mov    (%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	75 6e                	jne    802aef <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802a81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a85:	74 68                	je     802aef <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802a87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8b:	75 17                	jne    802aa4 <insert_sorted_with_merge_freeList+0xd0>
  802a8d:	83 ec 04             	sub    $0x4,%esp
  802a90:	68 70 3e 80 00       	push   $0x803e70
  802a95:	68 e0 00 00 00       	push   $0xe0
  802a9a:	68 57 3e 80 00       	push   $0x803e57
  802a9f:	e8 50 d9 ff ff       	call   8003f4 <_panic>
  802aa4:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802aad:	89 50 04             	mov    %edx,0x4(%eax)
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	8b 40 04             	mov    0x4(%eax),%eax
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	74 0c                	je     802ac6 <insert_sorted_with_merge_freeList+0xf2>
  802aba:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802abf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac2:	89 10                	mov    %edx,(%eax)
  802ac4:	eb 08                	jmp    802ace <insert_sorted_with_merge_freeList+0xfa>
  802ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac9:	a3 38 41 80 00       	mov    %eax,0x804138
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802adf:	a1 44 41 80 00       	mov    0x804144,%eax
  802ae4:	40                   	inc    %eax
  802ae5:	a3 44 41 80 00       	mov    %eax,0x804144
  802aea:	e9 ba 06 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	8b 50 0c             	mov    0xc(%eax),%edx
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	8b 40 08             	mov    0x8(%eax),%eax
  802afb:	01 c2                	add    %eax,%edx
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 40 08             	mov    0x8(%eax),%eax
  802b03:	39 c2                	cmp    %eax,%edx
  802b05:	73 78                	jae    802b7f <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0a:	8b 40 04             	mov    0x4(%eax),%eax
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	75 6e                	jne    802b7f <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802b11:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b15:	74 68                	je     802b7f <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802b17:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1b:	75 17                	jne    802b34 <insert_sorted_with_merge_freeList+0x160>
  802b1d:	83 ec 04             	sub    $0x4,%esp
  802b20:	68 34 3e 80 00       	push   $0x803e34
  802b25:	68 e6 00 00 00       	push   $0xe6
  802b2a:	68 57 3e 80 00       	push   $0x803e57
  802b2f:	e8 c0 d8 ff ff       	call   8003f4 <_panic>
  802b34:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	89 10                	mov    %edx,(%eax)
  802b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b42:	8b 00                	mov    (%eax),%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	74 0d                	je     802b55 <insert_sorted_with_merge_freeList+0x181>
  802b48:	a1 38 41 80 00       	mov    0x804138,%eax
  802b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b50:	89 50 04             	mov    %edx,0x4(%eax)
  802b53:	eb 08                	jmp    802b5d <insert_sorted_with_merge_freeList+0x189>
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b60:	a3 38 41 80 00       	mov    %eax,0x804138
  802b65:	8b 45 08             	mov    0x8(%ebp),%eax
  802b68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6f:	a1 44 41 80 00       	mov    0x804144,%eax
  802b74:	40                   	inc    %eax
  802b75:	a3 44 41 80 00       	mov    %eax,0x804144
  802b7a:	e9 2a 06 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802b7f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b87:	e9 ed 05 00 00       	jmp    803179 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8f:	8b 00                	mov    (%eax),%eax
  802b91:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802b94:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b98:	0f 84 a7 00 00 00    	je     802c45 <insert_sorted_with_merge_freeList+0x271>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 40 08             	mov    0x8(%eax),%eax
  802baa:	01 c2                	add    %eax,%edx
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	8b 40 08             	mov    0x8(%eax),%eax
  802bb2:	39 c2                	cmp    %eax,%edx
  802bb4:	0f 83 8b 00 00 00    	jae    802c45 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	8b 40 08             	mov    0x8(%eax),%eax
  802bc6:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bcb:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802bce:	39 c2                	cmp    %eax,%edx
  802bd0:	73 73                	jae    802c45 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd6:	74 06                	je     802bde <insert_sorted_with_merge_freeList+0x20a>
  802bd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bdc:	75 17                	jne    802bf5 <insert_sorted_with_merge_freeList+0x221>
  802bde:	83 ec 04             	sub    $0x4,%esp
  802be1:	68 e8 3e 80 00       	push   $0x803ee8
  802be6:	68 f0 00 00 00       	push   $0xf0
  802beb:	68 57 3e 80 00       	push   $0x803e57
  802bf0:	e8 ff d7 ff ff       	call   8003f4 <_panic>
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 10                	mov    (%eax),%edx
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	89 10                	mov    %edx,(%eax)
  802bff:	8b 45 08             	mov    0x8(%ebp),%eax
  802c02:	8b 00                	mov    (%eax),%eax
  802c04:	85 c0                	test   %eax,%eax
  802c06:	74 0b                	je     802c13 <insert_sorted_with_merge_freeList+0x23f>
  802c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0b:	8b 00                	mov    (%eax),%eax
  802c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c10:	89 50 04             	mov    %edx,0x4(%eax)
  802c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c16:	8b 55 08             	mov    0x8(%ebp),%edx
  802c19:	89 10                	mov    %edx,(%eax)
  802c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c21:	89 50 04             	mov    %edx,0x4(%eax)
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	75 08                	jne    802c35 <insert_sorted_with_merge_freeList+0x261>
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c35:	a1 44 41 80 00       	mov    0x804144,%eax
  802c3a:	40                   	inc    %eax
  802c3b:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802c40:	e9 64 05 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802c45:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c4a:	8b 50 0c             	mov    0xc(%eax),%edx
  802c4d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c52:	8b 40 08             	mov    0x8(%eax),%eax
  802c55:	01 c2                	add    %eax,%edx
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	8b 40 08             	mov    0x8(%eax),%eax
  802c5d:	39 c2                	cmp    %eax,%edx
  802c5f:	0f 85 b1 00 00 00    	jne    802d16 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802c65:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c6a:	85 c0                	test   %eax,%eax
  802c6c:	0f 84 a4 00 00 00    	je     802d16 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802c72:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c77:	8b 00                	mov    (%eax),%eax
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	0f 85 95 00 00 00    	jne    802d16 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802c81:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c86:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c8c:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c92:	8b 52 0c             	mov    0xc(%edx),%edx
  802c95:	01 ca                	add    %ecx,%edx
  802c97:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802cae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb2:	75 17                	jne    802ccb <insert_sorted_with_merge_freeList+0x2f7>
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 34 3e 80 00       	push   $0x803e34
  802cbc:	68 ff 00 00 00       	push   $0xff
  802cc1:	68 57 3e 80 00       	push   $0x803e57
  802cc6:	e8 29 d7 ff ff       	call   8003f4 <_panic>
  802ccb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	89 10                	mov    %edx,(%eax)
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	74 0d                	je     802cec <insert_sorted_with_merge_freeList+0x318>
  802cdf:	a1 48 41 80 00       	mov    0x804148,%eax
  802ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce7:	89 50 04             	mov    %edx,0x4(%eax)
  802cea:	eb 08                	jmp    802cf4 <insert_sorted_with_merge_freeList+0x320>
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	a3 48 41 80 00       	mov    %eax,0x804148
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d06:	a1 54 41 80 00       	mov    0x804154,%eax
  802d0b:	40                   	inc    %eax
  802d0c:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802d11:	e9 93 04 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 50 08             	mov    0x8(%eax),%edx
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d22:	01 c2                	add    %eax,%edx
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	8b 40 08             	mov    0x8(%eax),%eax
  802d2a:	39 c2                	cmp    %eax,%edx
  802d2c:	0f 85 ae 00 00 00    	jne    802de0 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802d32:	8b 45 08             	mov    0x8(%ebp),%eax
  802d35:	8b 50 0c             	mov    0xc(%eax),%edx
  802d38:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3b:	8b 40 08             	mov    0x8(%eax),%eax
  802d3e:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d43:	8b 00                	mov    (%eax),%eax
  802d45:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802d48:	39 c2                	cmp    %eax,%edx
  802d4a:	0f 84 90 00 00 00    	je     802de0 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 50 0c             	mov    0xc(%eax),%edx
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5c:	01 c2                	add    %eax,%edx
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7c:	75 17                	jne    802d95 <insert_sorted_with_merge_freeList+0x3c1>
  802d7e:	83 ec 04             	sub    $0x4,%esp
  802d81:	68 34 3e 80 00       	push   $0x803e34
  802d86:	68 0b 01 00 00       	push   $0x10b
  802d8b:	68 57 3e 80 00       	push   $0x803e57
  802d90:	e8 5f d6 ff ff       	call   8003f4 <_panic>
  802d95:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	89 10                	mov    %edx,(%eax)
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	8b 00                	mov    (%eax),%eax
  802da5:	85 c0                	test   %eax,%eax
  802da7:	74 0d                	je     802db6 <insert_sorted_with_merge_freeList+0x3e2>
  802da9:	a1 48 41 80 00       	mov    0x804148,%eax
  802dae:	8b 55 08             	mov    0x8(%ebp),%edx
  802db1:	89 50 04             	mov    %edx,0x4(%eax)
  802db4:	eb 08                	jmp    802dbe <insert_sorted_with_merge_freeList+0x3ea>
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	a3 48 41 80 00       	mov    %eax,0x804148
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd0:	a1 54 41 80 00       	mov    0x804154,%eax
  802dd5:	40                   	inc    %eax
  802dd6:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802ddb:	e9 c9 03 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802de0:	8b 45 08             	mov    0x8(%ebp),%eax
  802de3:	8b 50 0c             	mov    0xc(%eax),%edx
  802de6:	8b 45 08             	mov    0x8(%ebp),%eax
  802de9:	8b 40 08             	mov    0x8(%eax),%eax
  802dec:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df1:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802df4:	39 c2                	cmp    %eax,%edx
  802df6:	0f 85 bb 00 00 00    	jne    802eb7 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e00:	0f 84 b1 00 00 00    	je     802eb7 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 40 04             	mov    0x4(%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	0f 85 a3 00 00 00    	jne    802eb7 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802e14:	a1 38 41 80 00       	mov    0x804138,%eax
  802e19:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1c:	8b 52 08             	mov    0x8(%edx),%edx
  802e1f:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802e22:	a1 38 41 80 00       	mov    0x804138,%eax
  802e27:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802e2d:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802e30:	8b 55 08             	mov    0x8(%ebp),%edx
  802e33:	8b 52 0c             	mov    0xc(%edx),%edx
  802e36:	01 ca                	add    %ecx,%edx
  802e38:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e45:	8b 45 08             	mov    0x8(%ebp),%eax
  802e48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e53:	75 17                	jne    802e6c <insert_sorted_with_merge_freeList+0x498>
  802e55:	83 ec 04             	sub    $0x4,%esp
  802e58:	68 34 3e 80 00       	push   $0x803e34
  802e5d:	68 17 01 00 00       	push   $0x117
  802e62:	68 57 3e 80 00       	push   $0x803e57
  802e67:	e8 88 d5 ff ff       	call   8003f4 <_panic>
  802e6c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	89 10                	mov    %edx,(%eax)
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 00                	mov    (%eax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 0d                	je     802e8d <insert_sorted_with_merge_freeList+0x4b9>
  802e80:	a1 48 41 80 00       	mov    0x804148,%eax
  802e85:	8b 55 08             	mov    0x8(%ebp),%edx
  802e88:	89 50 04             	mov    %edx,0x4(%eax)
  802e8b:	eb 08                	jmp    802e95 <insert_sorted_with_merge_freeList+0x4c1>
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	a3 48 41 80 00       	mov    %eax,0x804148
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea7:	a1 54 41 80 00       	mov    0x804154,%eax
  802eac:	40                   	inc    %eax
  802ead:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802eb2:	e9 f2 02 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	8b 50 08             	mov    0x8(%eax),%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec3:	01 c2                	add    %eax,%edx
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 40 08             	mov    0x8(%eax),%eax
  802ecb:	39 c2                	cmp    %eax,%edx
  802ecd:	0f 85 be 00 00 00    	jne    802f91 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed6:	8b 40 04             	mov    0x4(%eax),%eax
  802ed9:	8b 50 08             	mov    0x8(%eax),%edx
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 40 04             	mov    0x4(%eax),%eax
  802ee2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee5:	01 c2                	add    %eax,%edx
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	8b 40 08             	mov    0x8(%eax),%eax
  802eed:	39 c2                	cmp    %eax,%edx
  802eef:	0f 84 9c 00 00 00    	je     802f91 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	8b 50 08             	mov    0x8(%eax),%edx
  802efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efe:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 50 0c             	mov    0xc(%eax),%edx
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0d:	01 c2                	add    %eax,%edx
  802f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f12:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2d:	75 17                	jne    802f46 <insert_sorted_with_merge_freeList+0x572>
  802f2f:	83 ec 04             	sub    $0x4,%esp
  802f32:	68 34 3e 80 00       	push   $0x803e34
  802f37:	68 26 01 00 00       	push   $0x126
  802f3c:	68 57 3e 80 00       	push   $0x803e57
  802f41:	e8 ae d4 ff ff       	call   8003f4 <_panic>
  802f46:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4f:	89 10                	mov    %edx,(%eax)
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	8b 00                	mov    (%eax),%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 0d                	je     802f67 <insert_sorted_with_merge_freeList+0x593>
  802f5a:	a1 48 41 80 00       	mov    0x804148,%eax
  802f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f62:	89 50 04             	mov    %edx,0x4(%eax)
  802f65:	eb 08                	jmp    802f6f <insert_sorted_with_merge_freeList+0x59b>
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f72:	a3 48 41 80 00       	mov    %eax,0x804148
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f81:	a1 54 41 80 00       	mov    0x804154,%eax
  802f86:	40                   	inc    %eax
  802f87:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802f8c:	e9 18 02 00 00       	jmp    8031a9 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f94:	8b 50 0c             	mov    0xc(%eax),%edx
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 40 08             	mov    0x8(%eax),%eax
  802f9d:	01 c2                	add    %eax,%edx
  802f9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa2:	8b 40 08             	mov    0x8(%eax),%eax
  802fa5:	39 c2                	cmp    %eax,%edx
  802fa7:	0f 85 c4 01 00 00    	jne    803171 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	8b 50 0c             	mov    0xc(%eax),%edx
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	8b 40 08             	mov    0x8(%eax),%eax
  802fb9:	01 c2                	add    %eax,%edx
  802fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbe:	8b 00                	mov    (%eax),%eax
  802fc0:	8b 40 08             	mov    0x8(%eax),%eax
  802fc3:	39 c2                	cmp    %eax,%edx
  802fc5:	0f 85 a6 01 00 00    	jne    803171 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802fcb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fcf:	0f 84 9c 01 00 00    	je     803171 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd8:	8b 50 0c             	mov    0xc(%eax),%edx
  802fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fde:	8b 40 0c             	mov    0xc(%eax),%eax
  802fe1:	01 c2                	add    %eax,%edx
  802fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe6:	8b 00                	mov    (%eax),%eax
  802fe8:	8b 40 0c             	mov    0xc(%eax),%eax
  802feb:	01 c2                	add    %eax,%edx
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  803007:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80300b:	75 17                	jne    803024 <insert_sorted_with_merge_freeList+0x650>
  80300d:	83 ec 04             	sub    $0x4,%esp
  803010:	68 34 3e 80 00       	push   $0x803e34
  803015:	68 32 01 00 00       	push   $0x132
  80301a:	68 57 3e 80 00       	push   $0x803e57
  80301f:	e8 d0 d3 ff ff       	call   8003f4 <_panic>
  803024:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	89 10                	mov    %edx,(%eax)
  80302f:	8b 45 08             	mov    0x8(%ebp),%eax
  803032:	8b 00                	mov    (%eax),%eax
  803034:	85 c0                	test   %eax,%eax
  803036:	74 0d                	je     803045 <insert_sorted_with_merge_freeList+0x671>
  803038:	a1 48 41 80 00       	mov    0x804148,%eax
  80303d:	8b 55 08             	mov    0x8(%ebp),%edx
  803040:	89 50 04             	mov    %edx,0x4(%eax)
  803043:	eb 08                	jmp    80304d <insert_sorted_with_merge_freeList+0x679>
  803045:	8b 45 08             	mov    0x8(%ebp),%eax
  803048:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80304d:	8b 45 08             	mov    0x8(%ebp),%eax
  803050:	a3 48 41 80 00       	mov    %eax,0x804148
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305f:	a1 54 41 80 00       	mov    0x804154,%eax
  803064:	40                   	inc    %eax
  803065:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803079:	8b 00                	mov    (%eax),%eax
  80307b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803085:	8b 00                	mov    (%eax),%eax
  803087:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80308a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80308e:	75 17                	jne    8030a7 <insert_sorted_with_merge_freeList+0x6d3>
  803090:	83 ec 04             	sub    $0x4,%esp
  803093:	68 c9 3e 80 00       	push   $0x803ec9
  803098:	68 36 01 00 00       	push   $0x136
  80309d:	68 57 3e 80 00       	push   $0x803e57
  8030a2:	e8 4d d3 ff ff       	call   8003f4 <_panic>
  8030a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030aa:	8b 00                	mov    (%eax),%eax
  8030ac:	85 c0                	test   %eax,%eax
  8030ae:	74 10                	je     8030c0 <insert_sorted_with_merge_freeList+0x6ec>
  8030b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030b3:	8b 00                	mov    (%eax),%eax
  8030b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030b8:	8b 52 04             	mov    0x4(%edx),%edx
  8030bb:	89 50 04             	mov    %edx,0x4(%eax)
  8030be:	eb 0b                	jmp    8030cb <insert_sorted_with_merge_freeList+0x6f7>
  8030c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c3:	8b 40 04             	mov    0x4(%eax),%eax
  8030c6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8030cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ce:	8b 40 04             	mov    0x4(%eax),%eax
  8030d1:	85 c0                	test   %eax,%eax
  8030d3:	74 0f                	je     8030e4 <insert_sorted_with_merge_freeList+0x710>
  8030d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d8:	8b 40 04             	mov    0x4(%eax),%eax
  8030db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030de:	8b 12                	mov    (%edx),%edx
  8030e0:	89 10                	mov    %edx,(%eax)
  8030e2:	eb 0a                	jmp    8030ee <insert_sorted_with_merge_freeList+0x71a>
  8030e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e7:	8b 00                	mov    (%eax),%eax
  8030e9:	a3 38 41 80 00       	mov    %eax,0x804138
  8030ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803101:	a1 44 41 80 00       	mov    0x804144,%eax
  803106:	48                   	dec    %eax
  803107:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80310c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803110:	75 17                	jne    803129 <insert_sorted_with_merge_freeList+0x755>
  803112:	83 ec 04             	sub    $0x4,%esp
  803115:	68 34 3e 80 00       	push   $0x803e34
  80311a:	68 37 01 00 00       	push   $0x137
  80311f:	68 57 3e 80 00       	push   $0x803e57
  803124:	e8 cb d2 ff ff       	call   8003f4 <_panic>
  803129:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80312f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803132:	89 10                	mov    %edx,(%eax)
  803134:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803137:	8b 00                	mov    (%eax),%eax
  803139:	85 c0                	test   %eax,%eax
  80313b:	74 0d                	je     80314a <insert_sorted_with_merge_freeList+0x776>
  80313d:	a1 48 41 80 00       	mov    0x804148,%eax
  803142:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803145:	89 50 04             	mov    %edx,0x4(%eax)
  803148:	eb 08                	jmp    803152 <insert_sorted_with_merge_freeList+0x77e>
  80314a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80314d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803152:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803155:	a3 48 41 80 00       	mov    %eax,0x804148
  80315a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803164:	a1 54 41 80 00       	mov    0x804154,%eax
  803169:	40                   	inc    %eax
  80316a:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  80316f:	eb 38                	jmp    8031a9 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803171:	a1 40 41 80 00       	mov    0x804140,%eax
  803176:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803179:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317d:	74 07                	je     803186 <insert_sorted_with_merge_freeList+0x7b2>
  80317f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803182:	8b 00                	mov    (%eax),%eax
  803184:	eb 05                	jmp    80318b <insert_sorted_with_merge_freeList+0x7b7>
  803186:	b8 00 00 00 00       	mov    $0x0,%eax
  80318b:	a3 40 41 80 00       	mov    %eax,0x804140
  803190:	a1 40 41 80 00       	mov    0x804140,%eax
  803195:	85 c0                	test   %eax,%eax
  803197:	0f 85 ef f9 ff ff    	jne    802b8c <insert_sorted_with_merge_freeList+0x1b8>
  80319d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a1:	0f 85 e5 f9 ff ff    	jne    802b8c <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8031a7:	eb 00                	jmp    8031a9 <insert_sorted_with_merge_freeList+0x7d5>
  8031a9:	90                   	nop
  8031aa:	c9                   	leave  
  8031ab:	c3                   	ret    

008031ac <__udivdi3>:
  8031ac:	55                   	push   %ebp
  8031ad:	57                   	push   %edi
  8031ae:	56                   	push   %esi
  8031af:	53                   	push   %ebx
  8031b0:	83 ec 1c             	sub    $0x1c,%esp
  8031b3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8031b7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031bf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031c3:	89 ca                	mov    %ecx,%edx
  8031c5:	89 f8                	mov    %edi,%eax
  8031c7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031cb:	85 f6                	test   %esi,%esi
  8031cd:	75 2d                	jne    8031fc <__udivdi3+0x50>
  8031cf:	39 cf                	cmp    %ecx,%edi
  8031d1:	77 65                	ja     803238 <__udivdi3+0x8c>
  8031d3:	89 fd                	mov    %edi,%ebp
  8031d5:	85 ff                	test   %edi,%edi
  8031d7:	75 0b                	jne    8031e4 <__udivdi3+0x38>
  8031d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8031de:	31 d2                	xor    %edx,%edx
  8031e0:	f7 f7                	div    %edi
  8031e2:	89 c5                	mov    %eax,%ebp
  8031e4:	31 d2                	xor    %edx,%edx
  8031e6:	89 c8                	mov    %ecx,%eax
  8031e8:	f7 f5                	div    %ebp
  8031ea:	89 c1                	mov    %eax,%ecx
  8031ec:	89 d8                	mov    %ebx,%eax
  8031ee:	f7 f5                	div    %ebp
  8031f0:	89 cf                	mov    %ecx,%edi
  8031f2:	89 fa                	mov    %edi,%edx
  8031f4:	83 c4 1c             	add    $0x1c,%esp
  8031f7:	5b                   	pop    %ebx
  8031f8:	5e                   	pop    %esi
  8031f9:	5f                   	pop    %edi
  8031fa:	5d                   	pop    %ebp
  8031fb:	c3                   	ret    
  8031fc:	39 ce                	cmp    %ecx,%esi
  8031fe:	77 28                	ja     803228 <__udivdi3+0x7c>
  803200:	0f bd fe             	bsr    %esi,%edi
  803203:	83 f7 1f             	xor    $0x1f,%edi
  803206:	75 40                	jne    803248 <__udivdi3+0x9c>
  803208:	39 ce                	cmp    %ecx,%esi
  80320a:	72 0a                	jb     803216 <__udivdi3+0x6a>
  80320c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803210:	0f 87 9e 00 00 00    	ja     8032b4 <__udivdi3+0x108>
  803216:	b8 01 00 00 00       	mov    $0x1,%eax
  80321b:	89 fa                	mov    %edi,%edx
  80321d:	83 c4 1c             	add    $0x1c,%esp
  803220:	5b                   	pop    %ebx
  803221:	5e                   	pop    %esi
  803222:	5f                   	pop    %edi
  803223:	5d                   	pop    %ebp
  803224:	c3                   	ret    
  803225:	8d 76 00             	lea    0x0(%esi),%esi
  803228:	31 ff                	xor    %edi,%edi
  80322a:	31 c0                	xor    %eax,%eax
  80322c:	89 fa                	mov    %edi,%edx
  80322e:	83 c4 1c             	add    $0x1c,%esp
  803231:	5b                   	pop    %ebx
  803232:	5e                   	pop    %esi
  803233:	5f                   	pop    %edi
  803234:	5d                   	pop    %ebp
  803235:	c3                   	ret    
  803236:	66 90                	xchg   %ax,%ax
  803238:	89 d8                	mov    %ebx,%eax
  80323a:	f7 f7                	div    %edi
  80323c:	31 ff                	xor    %edi,%edi
  80323e:	89 fa                	mov    %edi,%edx
  803240:	83 c4 1c             	add    $0x1c,%esp
  803243:	5b                   	pop    %ebx
  803244:	5e                   	pop    %esi
  803245:	5f                   	pop    %edi
  803246:	5d                   	pop    %ebp
  803247:	c3                   	ret    
  803248:	bd 20 00 00 00       	mov    $0x20,%ebp
  80324d:	89 eb                	mov    %ebp,%ebx
  80324f:	29 fb                	sub    %edi,%ebx
  803251:	89 f9                	mov    %edi,%ecx
  803253:	d3 e6                	shl    %cl,%esi
  803255:	89 c5                	mov    %eax,%ebp
  803257:	88 d9                	mov    %bl,%cl
  803259:	d3 ed                	shr    %cl,%ebp
  80325b:	89 e9                	mov    %ebp,%ecx
  80325d:	09 f1                	or     %esi,%ecx
  80325f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803263:	89 f9                	mov    %edi,%ecx
  803265:	d3 e0                	shl    %cl,%eax
  803267:	89 c5                	mov    %eax,%ebp
  803269:	89 d6                	mov    %edx,%esi
  80326b:	88 d9                	mov    %bl,%cl
  80326d:	d3 ee                	shr    %cl,%esi
  80326f:	89 f9                	mov    %edi,%ecx
  803271:	d3 e2                	shl    %cl,%edx
  803273:	8b 44 24 08          	mov    0x8(%esp),%eax
  803277:	88 d9                	mov    %bl,%cl
  803279:	d3 e8                	shr    %cl,%eax
  80327b:	09 c2                	or     %eax,%edx
  80327d:	89 d0                	mov    %edx,%eax
  80327f:	89 f2                	mov    %esi,%edx
  803281:	f7 74 24 0c          	divl   0xc(%esp)
  803285:	89 d6                	mov    %edx,%esi
  803287:	89 c3                	mov    %eax,%ebx
  803289:	f7 e5                	mul    %ebp
  80328b:	39 d6                	cmp    %edx,%esi
  80328d:	72 19                	jb     8032a8 <__udivdi3+0xfc>
  80328f:	74 0b                	je     80329c <__udivdi3+0xf0>
  803291:	89 d8                	mov    %ebx,%eax
  803293:	31 ff                	xor    %edi,%edi
  803295:	e9 58 ff ff ff       	jmp    8031f2 <__udivdi3+0x46>
  80329a:	66 90                	xchg   %ax,%ax
  80329c:	8b 54 24 08          	mov    0x8(%esp),%edx
  8032a0:	89 f9                	mov    %edi,%ecx
  8032a2:	d3 e2                	shl    %cl,%edx
  8032a4:	39 c2                	cmp    %eax,%edx
  8032a6:	73 e9                	jae    803291 <__udivdi3+0xe5>
  8032a8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8032ab:	31 ff                	xor    %edi,%edi
  8032ad:	e9 40 ff ff ff       	jmp    8031f2 <__udivdi3+0x46>
  8032b2:	66 90                	xchg   %ax,%ax
  8032b4:	31 c0                	xor    %eax,%eax
  8032b6:	e9 37 ff ff ff       	jmp    8031f2 <__udivdi3+0x46>
  8032bb:	90                   	nop

008032bc <__umoddi3>:
  8032bc:	55                   	push   %ebp
  8032bd:	57                   	push   %edi
  8032be:	56                   	push   %esi
  8032bf:	53                   	push   %ebx
  8032c0:	83 ec 1c             	sub    $0x1c,%esp
  8032c3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032c7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032cb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032db:	89 f3                	mov    %esi,%ebx
  8032dd:	89 fa                	mov    %edi,%edx
  8032df:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032e3:	89 34 24             	mov    %esi,(%esp)
  8032e6:	85 c0                	test   %eax,%eax
  8032e8:	75 1a                	jne    803304 <__umoddi3+0x48>
  8032ea:	39 f7                	cmp    %esi,%edi
  8032ec:	0f 86 a2 00 00 00    	jbe    803394 <__umoddi3+0xd8>
  8032f2:	89 c8                	mov    %ecx,%eax
  8032f4:	89 f2                	mov    %esi,%edx
  8032f6:	f7 f7                	div    %edi
  8032f8:	89 d0                	mov    %edx,%eax
  8032fa:	31 d2                	xor    %edx,%edx
  8032fc:	83 c4 1c             	add    $0x1c,%esp
  8032ff:	5b                   	pop    %ebx
  803300:	5e                   	pop    %esi
  803301:	5f                   	pop    %edi
  803302:	5d                   	pop    %ebp
  803303:	c3                   	ret    
  803304:	39 f0                	cmp    %esi,%eax
  803306:	0f 87 ac 00 00 00    	ja     8033b8 <__umoddi3+0xfc>
  80330c:	0f bd e8             	bsr    %eax,%ebp
  80330f:	83 f5 1f             	xor    $0x1f,%ebp
  803312:	0f 84 ac 00 00 00    	je     8033c4 <__umoddi3+0x108>
  803318:	bf 20 00 00 00       	mov    $0x20,%edi
  80331d:	29 ef                	sub    %ebp,%edi
  80331f:	89 fe                	mov    %edi,%esi
  803321:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803325:	89 e9                	mov    %ebp,%ecx
  803327:	d3 e0                	shl    %cl,%eax
  803329:	89 d7                	mov    %edx,%edi
  80332b:	89 f1                	mov    %esi,%ecx
  80332d:	d3 ef                	shr    %cl,%edi
  80332f:	09 c7                	or     %eax,%edi
  803331:	89 e9                	mov    %ebp,%ecx
  803333:	d3 e2                	shl    %cl,%edx
  803335:	89 14 24             	mov    %edx,(%esp)
  803338:	89 d8                	mov    %ebx,%eax
  80333a:	d3 e0                	shl    %cl,%eax
  80333c:	89 c2                	mov    %eax,%edx
  80333e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803342:	d3 e0                	shl    %cl,%eax
  803344:	89 44 24 04          	mov    %eax,0x4(%esp)
  803348:	8b 44 24 08          	mov    0x8(%esp),%eax
  80334c:	89 f1                	mov    %esi,%ecx
  80334e:	d3 e8                	shr    %cl,%eax
  803350:	09 d0                	or     %edx,%eax
  803352:	d3 eb                	shr    %cl,%ebx
  803354:	89 da                	mov    %ebx,%edx
  803356:	f7 f7                	div    %edi
  803358:	89 d3                	mov    %edx,%ebx
  80335a:	f7 24 24             	mull   (%esp)
  80335d:	89 c6                	mov    %eax,%esi
  80335f:	89 d1                	mov    %edx,%ecx
  803361:	39 d3                	cmp    %edx,%ebx
  803363:	0f 82 87 00 00 00    	jb     8033f0 <__umoddi3+0x134>
  803369:	0f 84 91 00 00 00    	je     803400 <__umoddi3+0x144>
  80336f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803373:	29 f2                	sub    %esi,%edx
  803375:	19 cb                	sbb    %ecx,%ebx
  803377:	89 d8                	mov    %ebx,%eax
  803379:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80337d:	d3 e0                	shl    %cl,%eax
  80337f:	89 e9                	mov    %ebp,%ecx
  803381:	d3 ea                	shr    %cl,%edx
  803383:	09 d0                	or     %edx,%eax
  803385:	89 e9                	mov    %ebp,%ecx
  803387:	d3 eb                	shr    %cl,%ebx
  803389:	89 da                	mov    %ebx,%edx
  80338b:	83 c4 1c             	add    $0x1c,%esp
  80338e:	5b                   	pop    %ebx
  80338f:	5e                   	pop    %esi
  803390:	5f                   	pop    %edi
  803391:	5d                   	pop    %ebp
  803392:	c3                   	ret    
  803393:	90                   	nop
  803394:	89 fd                	mov    %edi,%ebp
  803396:	85 ff                	test   %edi,%edi
  803398:	75 0b                	jne    8033a5 <__umoddi3+0xe9>
  80339a:	b8 01 00 00 00       	mov    $0x1,%eax
  80339f:	31 d2                	xor    %edx,%edx
  8033a1:	f7 f7                	div    %edi
  8033a3:	89 c5                	mov    %eax,%ebp
  8033a5:	89 f0                	mov    %esi,%eax
  8033a7:	31 d2                	xor    %edx,%edx
  8033a9:	f7 f5                	div    %ebp
  8033ab:	89 c8                	mov    %ecx,%eax
  8033ad:	f7 f5                	div    %ebp
  8033af:	89 d0                	mov    %edx,%eax
  8033b1:	e9 44 ff ff ff       	jmp    8032fa <__umoddi3+0x3e>
  8033b6:	66 90                	xchg   %ax,%ax
  8033b8:	89 c8                	mov    %ecx,%eax
  8033ba:	89 f2                	mov    %esi,%edx
  8033bc:	83 c4 1c             	add    $0x1c,%esp
  8033bf:	5b                   	pop    %ebx
  8033c0:	5e                   	pop    %esi
  8033c1:	5f                   	pop    %edi
  8033c2:	5d                   	pop    %ebp
  8033c3:	c3                   	ret    
  8033c4:	3b 04 24             	cmp    (%esp),%eax
  8033c7:	72 06                	jb     8033cf <__umoddi3+0x113>
  8033c9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033cd:	77 0f                	ja     8033de <__umoddi3+0x122>
  8033cf:	89 f2                	mov    %esi,%edx
  8033d1:	29 f9                	sub    %edi,%ecx
  8033d3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033d7:	89 14 24             	mov    %edx,(%esp)
  8033da:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033de:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033e2:	8b 14 24             	mov    (%esp),%edx
  8033e5:	83 c4 1c             	add    $0x1c,%esp
  8033e8:	5b                   	pop    %ebx
  8033e9:	5e                   	pop    %esi
  8033ea:	5f                   	pop    %edi
  8033eb:	5d                   	pop    %ebp
  8033ec:	c3                   	ret    
  8033ed:	8d 76 00             	lea    0x0(%esi),%esi
  8033f0:	2b 04 24             	sub    (%esp),%eax
  8033f3:	19 fa                	sbb    %edi,%edx
  8033f5:	89 d1                	mov    %edx,%ecx
  8033f7:	89 c6                	mov    %eax,%esi
  8033f9:	e9 71 ff ff ff       	jmp    80336f <__umoddi3+0xb3>
  8033fe:	66 90                	xchg   %ax,%ax
  803400:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803404:	72 ea                	jb     8033f0 <__umoddi3+0x134>
  803406:	89 d9                	mov    %ebx,%ecx
  803408:	e9 62 ff ff ff       	jmp    80336f <__umoddi3+0xb3>
